import { createHash } from "node:crypto";

import { describe, expect, it, vi } from "vitest";

import {
  createLegalPdfExtractor,
  type LegalPdfLoadingTask
} from "../src/legal/legal-pdf-extractor.js";

function createFixture(options?: { failTextExtraction?: boolean }) {
  const pageCleanup = vi.fn();
  const documentCleanup = vi.fn();
  const destroy = vi.fn().mockResolvedValue(undefined);
  const document = {
    numPages: 1,
    getPermissions: vi.fn().mockResolvedValue(null),
    getPage: vi.fn().mockResolvedValue({
      cleanup: pageCleanup,
      getTextContent: options?.failTextExtraction
        ? vi.fn().mockRejectedValue(new Error("synthetic parser failure"))
        : vi.fn().mockResolvedValue({
            items: [
              { fontName: "body", str: "LIGJI 03/L-212", transform: [1, 0, 0, 1, 10, 100] },
              { fontName: "heading", str: "Neni 1", transform: [1, 0, 0, 1, 10, 80] },
              { fontName: "body", str: "është çështje", transform: [1, 0, 0, 1, 10, 60] }
            ]
          })
    }),
    cleanup: documentCleanup
  };
  const loadingTask: LegalPdfLoadingTask = {
    promise: Promise.resolve(document),
    destroy
  };

  return { loadingTask, pageCleanup, documentCleanup, destroy };
}

function integrityFor(bytes: Buffer) {
  return {
    lawNumber: "03/L-212",
    expectedSha256: createHash("sha256").update(bytes).digest("hex"),
    expectedPageCount: 1
  };
}

describe("legal PDF extractor", () => {
  it("preserves Albanian Unicode and cleans up after success", async () => {
    const bytes = Buffer.from("%PDF-synthetic");
    const fixture = createFixture();
    const extractor = createLegalPdfExtractor(() => fixture.loadingTask);

    const result = await extractor(bytes, integrityFor(bytes));

    expect(result.pages[0]?.lines.map((line) => line.text)).toContain(
      "është çështje"
    );
    expect(fixture.pageCleanup).toHaveBeenCalledOnce();
    expect(fixture.documentCleanup).toHaveBeenCalledOnce();
    expect(fixture.destroy).toHaveBeenCalledOnce();
  });

  it("cleans up the page, document and loading task after parser failure", async () => {
    const bytes = Buffer.from("%PDF-synthetic");
    const fixture = createFixture({ failTextExtraction: true });
    const extractor = createLegalPdfExtractor(() => fixture.loadingTask);

    await expect(extractor(bytes, integrityFor(bytes))).rejects.toThrow(
      "synthetic parser failure"
    );
    expect(fixture.pageCleanup).toHaveBeenCalledOnce();
    expect(fixture.documentCleanup).toHaveBeenCalledOnce();
    expect(fixture.destroy).toHaveBeenCalledOnce();
  });

  it("rejects an incorrect hash before loading PDF.js", async () => {
    const loadPdf = vi.fn();
    const extractor = createLegalPdfExtractor(loadPdf);

    await expect(
      extractor(Buffer.from("%PDF-synthetic"), {
        lawNumber: "03/L-212",
        expectedSha256: "0".repeat(64),
        expectedPageCount: 1
      })
    ).rejects.toThrow("LEGAL_PDF_HASH_MISMATCH");
    expect(loadPdf).not.toHaveBeenCalled();
  });
});
