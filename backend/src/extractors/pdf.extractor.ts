import {
  AbortException,
  InvalidPDFException,
  PasswordException,
  getDocument
} from "pdfjs-dist/legacy/build/pdf.mjs";

import { ApiError } from "../utils/ApiError.js";
import {
  MAX_EXTRACTED_CHARACTERS,
  MIN_MEANINGFUL_CHARACTERS,
  normalizeExtractedText
} from "./document-text-normalizer.js";

export const MAX_PDF_PAGES = 200;

type PdfTextItem = {
  str: string;
  hasEOL?: boolean;
};

type PdfPage = {
  cleanup: () => void;
  getTextContent: () => Promise<{ items: unknown[] }>;
};

type PdfDocument = {
  cleanup: () => Promise<void> | void;
  getPage: (pageNumber: number) => Promise<PdfPage>;
  numPages: number;
};

export type PdfLoadingTask = {
  destroy: () => Promise<void>;
  promise: Promise<PdfDocument>;
};

export type LoadPdf = (bytes: Uint8Array) => PdfLoadingTask;

export type PdfExtractionResult =
  | {
      status: "completed";
      text: string;
      pageCount: number;
    }
  | {
      status: "requires_ocr";
      text: null;
      pageCount: number;
    };

export type ExtractPdf = (buffer: Buffer) => Promise<PdfExtractionResult>;

function defaultLoadPdf(bytes: Uint8Array): PdfLoadingTask {
  const safeLoadParameters = {
    data: bytes,
    isEvalSupported: false,
    verbosity: 0
  };

  return getDocument(
    safeLoadParameters as Parameters<typeof getDocument>[0]
  ) as unknown as PdfLoadingTask;
}

function isPdfTextItem(item: unknown): item is PdfTextItem {
  return (
    typeof item === "object" &&
    item !== null &&
    "str" in item &&
    typeof item.str === "string"
  );
}

function countCharacters(text: string): number {
  let count = 0;

  for (const _character of text) {
    count += 1;
  }

  return count;
}

function countMeaningfulCharacters(text: string): number {
  return countCharacters(text.replace(/\s/gu, ""));
}

function pageTextFromItems(items: unknown[]): string {
  let text = "";

  for (const item of items) {
    if (!isPdfTextItem(item) || item.str.length === 0) {
      continue;
    }

    text += item.str;
    text += item.hasEOL ? "\n" : " ";
  }

  return text.trim();
}

function requiresOcr(
  totalMeaningfulCharacters: number,
  meaningfulCharactersByPage: number[]
): boolean {
  if (totalMeaningfulCharacters < MIN_MEANINGFUL_CHARACTERS) {
    return true;
  }

  if (
    meaningfulCharactersByPage.length >= 2 &&
    totalMeaningfulCharacters < 50
  ) {
    const pagesWithVeryLittleText = meaningfulCharactersByPage.filter(
      (count) => count < 10
    ).length;

    return (
      pagesWithVeryLittleText / meaningfulCharactersByPage.length >= 0.9
    );
  }

  return false;
}

function parserError(error: unknown, pageCount: number | null): ApiError {
  const details = pageCount === null ? null : { pageCount };
  const errorName = error instanceof Error ? error.name : "";

  if (error instanceof PasswordException || errorName === "PasswordException") {
    return new ApiError(
      422,
      "PDF_ENCRYPTED",
      "Encrypted PDF documents are not supported.",
      details
    );
  }

  if (
    error instanceof InvalidPDFException ||
    errorName === "InvalidPDFException" ||
    errorName === "FormatError"
  ) {
    return new ApiError(
      422,
      "INVALID_PDF",
      "The PDF document is not valid.",
      details
    );
  }

  if (error instanceof AbortException || errorName === "AbortException") {
    return new ApiError(
      422,
      "PDF_PARSER_FAILED",
      "The PDF text could not be extracted safely.",
      details
    );
  }

  return new ApiError(
    422,
    "PDF_PARSER_FAILED",
    "The PDF text could not be extracted safely.",
    details
  );
}

export function createPdfExtractor(loadPdf: LoadPdf = defaultLoadPdf): ExtractPdf {
  return async (buffer) => {
    const loadingTask = loadPdf(Uint8Array.from(buffer));
    let document: PdfDocument | null = null;
    let pageCount: number | null = null;

    try {
      document = await loadingTask.promise;
      pageCount = document.numPages;

      if (!Number.isInteger(pageCount) || pageCount < 1) {
        throw new ApiError(
          422,
          "INVALID_PDF",
          "The PDF document is not valid."
        );
      }

      if (pageCount > MAX_PDF_PAGES) {
        throw new ApiError(
          413,
          "PDF_PAGE_LIMIT_EXCEEDED",
          "The PDF document exceeds the allowed page limit.",
          { pageCount }
        );
      }

      const pageTexts: string[] = [];
      const meaningfulCharactersByPage: number[] = [];
      let extractedCharacterCount = 0;

      for (let pageNumber = 1; pageNumber <= pageCount; pageNumber += 1) {
        const page = await document.getPage(pageNumber);

        try {
          const content = await page.getTextContent();
          const pageText = pageTextFromItems(content.items);
          const separatorLength = pageTexts.length === 0 ? 0 : 2;

          extractedCharacterCount += countCharacters(pageText) + separatorLength;

          if (extractedCharacterCount > MAX_EXTRACTED_CHARACTERS) {
            throw new ApiError(
              413,
              "EXTRACTION_OUTPUT_TOO_LARGE",
              "The extracted text exceeds the allowed size.",
              { pageCount }
            );
          }

          pageTexts.push(pageText);
          meaningfulCharactersByPage.push(
            countMeaningfulCharacters(pageText)
          );
        } finally {
          page.cleanup();
        }
      }

      const totalMeaningfulCharacters = meaningfulCharactersByPage.reduce(
        (total, count) => total + count,
        0
      );

      if (requiresOcr(totalMeaningfulCharacters, meaningfulCharactersByPage)) {
        return {
          status: "requires_ocr",
          text: null,
          pageCount
        };
      }

      return {
        status: "completed",
        text: normalizeExtractedText(pageTexts.join("\n\n")),
        pageCount
      };
    } catch (error) {
      if (error instanceof ApiError) {
        throw error;
      }

      throw parserError(error, pageCount);
    } finally {
      try {
        if (document) {
          await document.cleanup();
        }
      } finally {
        await loadingTask.destroy();
      }
    }
  };
}

export const extractPdf = createPdfExtractor();
