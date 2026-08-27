import { describe, expect, it } from "vitest";

import {
  extractTxt,
  MAX_EXTRACTED_CHARACTERS
} from "../src/extractors/txt.extractor.js";

describe("TXT extractor", () => {
  it("extracts valid Albanian UTF-8 text without changing letters", () => {
    const text = "Marrëveshje për shërbime ndërmjet palëve dhe çmimi përfundimtar.";

    expect(extractTxt(Buffer.from(text, "utf8"))).toBe(text);
  });

  it("removes a UTF-8 BOM only from the beginning", () => {
    const text = "Kontratë shërbimi me kushte të përcaktuara qartë.";

    expect(extractTxt(Buffer.from(`\uFEFF${text}`, "utf8"))).toBe(text);
  });

  it("normalizes CRLF and CR while preserving paragraphs and numbering", () => {
    const input =
      "Neni 1\r\nPalët bien dakord.   \r\n\r\n\r\n1. Detyrimi i parë\r2. Detyrimi i dytë";

    expect(extractTxt(Buffer.from(input))).toBe(
      "Neni 1\nPalët bien dakord.\n\n1. Detyrimi i parë\n2. Detyrimi i dytë"
    );
  });

  it("removes unsafe control characters including NUL", () => {
    const input = "Kontratë\u0000 me\u0007 tekst të vlefshëm dhe kushte të qarta.";

    expect(extractTxt(Buffer.from(input))).toBe(
      "Kontratë me tekst të vlefshëm dhe kushte të qarta."
    );
  });

  it("rejects invalid UTF-8", () => {
    expect(() => extractTxt(Buffer.from([0xc3, 0x28]))).toThrowError(
      expect.objectContaining({ code: "INVALID_TEXT_ENCODING", statusCode: 422 })
    );
  });

  it.each(["", "   \r\n\t", "Shumë pak tekst"])(
    "rejects empty or insufficient meaningful text",
    (input) => {
      expect(() => extractTxt(Buffer.from(input))).toThrowError(
        expect.objectContaining({ code: "EMPTY_EXTRACTED_TEXT", statusCode: 422 })
      );
    }
  );

  it("rejects output over one million characters without truncating it", () => {
    const input = "a".repeat(MAX_EXTRACTED_CHARACTERS + 1);

    expect(() => extractTxt(Buffer.from(input))).toThrowError(
      expect.objectContaining({
        code: "EXTRACTION_OUTPUT_TOO_LARGE",
        statusCode: 413
      })
    );
  });
});
