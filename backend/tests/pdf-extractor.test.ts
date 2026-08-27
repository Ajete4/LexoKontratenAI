import { describe, expect, it, vi } from "vitest";

import {
  MAX_PDF_PAGES,
  createPdfExtractor,
  extractPdf,
  type LoadPdf,
  type PdfLoadingTask
} from "../src/extractors/pdf.extractor.js";
import { MAX_EXTRACTED_CHARACTERS } from "../src/extractors/document-text-normalizer.js";
import { createSyntheticPdfBuffer } from "./fixtures/pdf.js";

function createMockLoadingTask(
  pageTexts: string[],
  options: {
    failingPage?: number;
    failingTextContentPage?: number;
    pageCount?: number;
  } = {}
) {
  const pageCleanup = vi.fn();
  const documentCleanup = vi.fn();
  const destroy = vi.fn(async () => undefined);
  const document = {
    numPages: options.pageCount ?? pageTexts.length,
    cleanup: documentCleanup,
    getPage: vi.fn(async (pageNumber: number) => {
      if (pageNumber === options.failingPage) {
        throw new Error("private parser failure with document data");
      }

      return {
        cleanup: pageCleanup,
        getTextContent: vi.fn(async () => {
          if (pageNumber === options.failingTextContentPage) {
            throw new Error("private text-content parser failure");
          }

          return {
            items: [{ str: pageTexts[pageNumber - 1] ?? "", hasEOL: true }]
          };
        })
      };
    })
  };
  const task: PdfLoadingTask = {
    destroy,
    promise: Promise.resolve(document)
  };
  const loadPdf = vi.fn<LoadPdf>(() => task);

  return {
    destroy,
    documentCleanup,
    loadPdf,
    pageCleanup
  };
}

describe("PDF text extractor", () => {
  it("extracts a one-page textual PDF and reports the real page count", async () => {
    const buffer = createSyntheticPdfBuffer([
      "Kontrate sherbimi me detyrime dhe kushte te percaktuara qarte."
    ]);

    await expect(extractPdf(buffer)).resolves.toEqual({
      status: "completed",
      text: "Kontrate sherbimi me detyrime dhe kushte te percaktuara qarte.",
      pageCount: 1
    });
  });

  it("preserves Albanian WinAnsi letters", async () => {
    const text = "Kontrat\u00eb sh\u00ebrbimi me \u00e7mim dhe kushte t\u00eb qarta.";

    await expect(
      extractPdf(createSyntheticPdfBuffer([text]))
    ).resolves.toMatchObject({ text });
  });

  it("separates text from multiple pages", async () => {
    const firstPage = "Faqja e pare permban detyrimet kryesore te kontrates.";
    const secondPage = "Faqja e dyte permban afatet dhe kushtet e pageses.";

    await expect(
      extractPdf(createSyntheticPdfBuffer([firstPage, secondPage]))
    ).resolves.toEqual({
      status: "completed",
      text: `${firstPage}\n\n${secondPage}`,
      pageCount: 2
    });
  });

  it.each([
    ["without a text layer", [null]],
    ["with image-only page operators", [null, null]],
    ["with less than twenty meaningful characters", ["Pak tekst"]]
  ])("returns requires_ocr for a PDF %s", async (_description, pageTexts) => {
    await expect(
      extractPdf(createSyntheticPdfBuffer(pageTexts))
    ).resolves.toEqual({
      status: "requires_ocr",
      text: null,
      pageCount: pageTexts.length
    });
  });

  it("does not classify a short but sufficient one-page document as OCR", async () => {
    const text = "Njoftim kontraktual me mbi njezet shkronja.";

    await expect(
      extractPdf(createSyntheticPdfBuffer([text]))
    ).resolves.toMatchObject({ status: "completed", text });
  });

  it("rejects malformed and truncated PDF bytes safely", async () => {
    for (const buffer of [
      Buffer.from("not a PDF"),
      createSyntheticPdfBuffer(["Tekst i vlefshem per dokumentin."]).subarray(0, 40)
    ]) {
      await expect(extractPdf(buffer)).rejects.toMatchObject({
        code: "INVALID_PDF",
        statusCode: 422
      });
    }
  });

  it("maps password-protected PDFs without exposing parser details", async () => {
    const privateError = Object.assign(new Error("password and private details"), {
      name: "PasswordException"
    });
    const destroy = vi.fn(async () => undefined);
    const extract = createPdfExtractor(() => ({
      destroy,
      promise: Promise.reject(privateError)
    }));

    await expect(extract(Buffer.from("%PDF"))).rejects.toMatchObject({
      code: "PDF_ENCRYPTED",
      message: "Encrypted PDF documents are not supported.",
      statusCode: 422
    });
    expect(destroy).toHaveBeenCalledOnce();
  });

  it("rejects documents above the page limit before reading a page", async () => {
    const context = createMockLoadingTask([], {
      pageCount: MAX_PDF_PAGES + 1
    });
    const extract = createPdfExtractor(context.loadPdf);

    await expect(extract(Buffer.from("%PDF"))).rejects.toMatchObject({
      code: "PDF_PAGE_LIMIT_EXCEEDED",
      statusCode: 413
    });
    expect(context.pageCleanup).not.toHaveBeenCalled();
    expect(context.documentCleanup).toHaveBeenCalledOnce();
    expect(context.destroy).toHaveBeenCalledOnce();
  });

  it("stops when extracted output exceeds the character limit", async () => {
    const context = createMockLoadingTask([
      "a".repeat(MAX_EXTRACTED_CHARACTERS + 1)
    ]);
    const extract = createPdfExtractor(context.loadPdf);

    await expect(extract(Buffer.from("%PDF"))).rejects.toMatchObject({
      code: "EXTRACTION_OUTPUT_TOO_LARGE",
      statusCode: 413
    });
    expect(context.pageCleanup).toHaveBeenCalledOnce();
    expect(context.documentCleanup).toHaveBeenCalledOnce();
    expect(context.destroy).toHaveBeenCalledOnce();
  });

  it("cleans up pages and the document after success", async () => {
    const context = createMockLoadingTask([
      "Tekst i mjaftueshem per kontraten dhe kushtet e saj."
    ]);
    const extract = createPdfExtractor(context.loadPdf);

    await extract(Buffer.from("%PDF"));

    expect(context.pageCleanup).toHaveBeenCalledOnce();
    expect(context.documentCleanup).toHaveBeenCalledOnce();
    expect(context.destroy).toHaveBeenCalledOnce();
  });

  it("cleans the page and destroys the loading task when text extraction fails", async () => {
    const context = createMockLoadingTask(["unused"], {
      failingTextContentPage: 1
    });
    const extract = createPdfExtractor(context.loadPdf);

    await expect(extract(Buffer.from("%PDF"))).rejects.toMatchObject({
      code: "PDF_PARSER_FAILED",
      message: "The PDF text could not be extracted safely."
    });
    expect(context.documentCleanup).toHaveBeenCalledOnce();
    expect(context.pageCleanup).toHaveBeenCalledOnce();
    expect(context.destroy).toHaveBeenCalledOnce();
  });
});
