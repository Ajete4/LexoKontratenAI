import { describe, expect, it, vi } from "vitest";

import {
  createDocxExtractor,
  type MammothRawTextAdapter
} from "../src/extractors/docx.extractor.js";
import { MAX_EXTRACTED_CHARACTERS } from "../src/extractors/document-text-normalizer.js";
import { createMinimalDocxBuffer } from "./fixtures/docx.js";

describe("DOCX raw-text extractor", () => {
  it("extracts multiple paragraphs, numbering, and Albanian Unicode", async () => {
    const buffer = createMinimalDocxBuffer([
      "Kontratë për shërbime ndërmjet palëve.",
      "1. Detyrimi i parë dhe çmimi.",
      "2. Detyrimi i dytë dhe afati."
    ]);
    const extractDocx = createDocxExtractor();

    await expect(extractDocx(buffer)).resolves.toBe(
      "Kontratë për shërbime ndërmjet palëve.\n\n" +
        "1. Detyrimi i parë dhe çmimi.\n\n" +
        "2. Detyrimi i dytë dhe afati."
    );
  });

  it("validates the archive before invoking Mammoth", async () => {
    const adapter = vi.fn<MammothRawTextAdapter>(async () => ({
      value: "should not be used"
    }));
    const extractDocx = createDocxExtractor(adapter);

    await expect(extractDocx(Buffer.from("not a DOCX"))).rejects.toMatchObject({
      code: "INVALID_DOCX",
      statusCode: 422
    });
    expect(adapter).not.toHaveBeenCalled();
  });

  it("passes only the verified Buffer to raw-text extraction", async () => {
    const buffer = createMinimalDocxBuffer();
    const adapter = vi.fn<MammothRawTextAdapter>(async () => ({
      value: "Kontratë\r\n\r\n\r\nme tekst të vlefshëm dhe kushte të qarta.   "
    }));
    const extractDocx = createDocxExtractor(adapter);

    await expect(extractDocx(buffer)).resolves.toBe(
      "Kontratë\n\nme tekst të vlefshëm dhe kushte të qarta."
    );
    expect(adapter).toHaveBeenCalledWith({ buffer });
    expect(Object.keys(adapter.mock.calls[0]?.[0] ?? {})).toEqual(["buffer"]);
  });

  it("rejects empty raw text", async () => {
    const extractDocx = createDocxExtractor(async () => ({ value: " \n\t " }));

    await expect(
      extractDocx(createMinimalDocxBuffer())
    ).rejects.toMatchObject({
      code: "EMPTY_EXTRACTED_TEXT",
      statusCode: 422
    });
  });

  it("rejects raw text over one million characters without truncation", async () => {
    const extractDocx = createDocxExtractor(async () => ({
      value: "a".repeat(MAX_EXTRACTED_CHARACTERS + 1)
    }));

    await expect(
      extractDocx(createMinimalDocxBuffer())
    ).rejects.toMatchObject({
      code: "EXTRACTION_OUTPUT_TOO_LARGE",
      statusCode: 413
    });
  });

  it("maps Mammoth failures without exposing the raw error", async () => {
    const extractDocx = createDocxExtractor(async () => {
      throw new Error("private parser detail and document content");
    });

    await expect(
      extractDocx(createMinimalDocxBuffer())
    ).rejects.toMatchObject({
      code: "PARSER_FAILED",
      message: "The DOCX text could not be extracted safely.",
      statusCode: 422
    });
  });
});
