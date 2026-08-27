import { createHash } from "node:crypto";

import {
  PasswordException,
  getDocument
} from "pdfjs-dist/legacy/build/pdf.mjs";

export type LegalPdfLine = {
  readonly pageNumber: number;
  readonly text: string;
  readonly fontNames: readonly string[];
};

export type ExtractedLegalPdf = {
  readonly lawNumber: string;
  readonly sourceSha256: string;
  readonly pageCount: number;
  readonly pages: readonly {
    readonly pageNumber: number;
    readonly lines: readonly LegalPdfLine[];
  }[];
};

type LegalPdfIntegrity = {
  readonly lawNumber: string;
  readonly expectedSha256: string;
  readonly expectedPageCount: number;
};

type TextItem = {
  readonly fontName: string;
  readonly str: string;
  readonly transform: readonly number[];
};

type LegalPdfPage = {
  cleanup: () => void;
  getTextContent: () => Promise<{ items: unknown[] }>;
};

type LegalPdfDocument = {
  cleanup: () => Promise<void> | void;
  getPage: (pageNumber: number) => Promise<LegalPdfPage>;
  getPermissions: () => Promise<unknown[] | null>;
  numPages: number;
};

export type LegalPdfLoadingTask = {
  destroy: () => Promise<void>;
  promise: Promise<LegalPdfDocument>;
};

export type LoadLegalPdf = (bytes: Uint8Array) => LegalPdfLoadingTask;

const LINE_Y_TOLERANCE = 1.5;

function isTextItem(value: unknown): value is TextItem {
  return (
    typeof value === "object" &&
    value !== null &&
    "str" in value &&
    typeof value.str === "string" &&
    "fontName" in value &&
    typeof value.fontName === "string" &&
    "transform" in value &&
    Array.isArray(value.transform) &&
    value.transform.length >= 6 &&
    value.transform.every((coordinate) => typeof coordinate === "number")
  );
}

function normalizeLine(text: string): string {
  return text.normalize("NFC").replace(/\s+/gu, " ").trim();
}

function linesFromItems(
  items: readonly unknown[],
  pageNumber: number
): LegalPdfLine[] {
  const groups: Array<{
    y: number;
    items: Array<{ x: number; text: string; fontName: string }>;
  }> = [];

  for (const item of items) {
    if (!isTextItem(item) || item.str.trim().length === 0) {
      continue;
    }

    const x = item.transform[4];
    const y = item.transform[5];

    if (x === undefined || y === undefined) {
      continue;
    }

    let group = groups.find(
      (candidate) => Math.abs(candidate.y - y) <= LINE_Y_TOLERANCE
    );

    if (group === undefined) {
      group = { y, items: [] };
      groups.push(group);
    }

    group.items.push({ x, text: item.str, fontName: item.fontName });
  }

  return groups
    .sort((left, right) => right.y - left.y)
    .map((group) => ({
      pageNumber,
      fontNames: [...new Set(group.items.map((item) => item.fontName))].sort(),
      text: normalizeLine(
        group.items
          .sort((left, right) => left.x - right.x)
          .map((item) => item.text)
          .join(" ")
      )
    }))
    .filter((line) => line.text.length > 0);
}

function assertPdfMagic(bytes: Buffer): void {
  if (bytes.subarray(0, 5).toString("ascii") !== "%PDF-") {
    throw new Error("LEGAL_PDF_MAGIC_INVALID");
  }
}

function defaultLoadLegalPdf(bytes: Uint8Array): LegalPdfLoadingTask {
  const loadingParameters = {
    data: bytes,
    isEvalSupported: false,
    verbosity: 0
  };

  return getDocument(
    loadingParameters as Parameters<typeof getDocument>[0]
  ) as unknown as LegalPdfLoadingTask;
}

export function createLegalPdfExtractor(
  loadPdf: LoadLegalPdf = defaultLoadLegalPdf
) {
  return async (
    bytes: Buffer,
    integrity: LegalPdfIntegrity
  ): Promise<ExtractedLegalPdf> => {
    assertPdfMagic(bytes);

    const sourceSha256 = createHash("sha256").update(bytes).digest("hex");

    if (sourceSha256 !== integrity.expectedSha256) {
      throw new Error("LEGAL_PDF_HASH_MISMATCH");
    }

    const loadingTask = loadPdf(Uint8Array.from(bytes));
    let document: LegalPdfDocument | null = null;

    try {
      document = await loadingTask.promise;

      if (document.numPages !== integrity.expectedPageCount) {
        throw new Error("LEGAL_PDF_PAGE_COUNT_MISMATCH");
      }

      const permissions = await document.getPermissions();

      if (permissions !== null) {
        throw new Error("LEGAL_PDF_ENCRYPTED_OR_RESTRICTED");
      }

      const pages: ExtractedLegalPdf["pages"][number][] = [];

      for (
        let pageNumber = 1;
        pageNumber <= document.numPages;
        pageNumber += 1
      ) {
        const page = await document.getPage(pageNumber);

        try {
          const content = await page.getTextContent();
          pages.push({
            pageNumber,
            lines: linesFromItems(content.items, pageNumber)
          });
        } finally {
          page.cleanup();
        }
      }

      const initialText = pages
        .slice(0, Math.min(3, pages.length))
        .flatMap((page) => page.lines)
        .map((line) => line.text)
        .join(" ");

      if (!initialText.includes(integrity.lawNumber)) {
        throw new Error("LEGAL_PDF_IDENTITY_MISMATCH");
      }

      return {
        lawNumber: integrity.lawNumber,
        sourceSha256,
        pageCount: document.numPages,
        pages
      };
    } catch (error) {
      if (
        error instanceof PasswordException ||
        (error instanceof Error && error.name === "PasswordException")
      ) {
        throw new Error("LEGAL_PDF_ENCRYPTED_OR_RESTRICTED");
      }

      throw error;
    } finally {
      try {
        if (document !== null) {
          await document.cleanup();
        }
      } finally {
        await loadingTask.destroy();
      }
    }
  };
}

export const extractLegalPdf = createLegalPdfExtractor();
