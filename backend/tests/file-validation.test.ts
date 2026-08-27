import { Readable } from "node:stream";
import { describe, expect, it } from "vitest";

import {
  MAX_CONTRACT_FILE_SIZE_BYTES,
  validateContractFile
} from "../src/services/file-validation.service.js";
import { createMinimalDocxBuffer } from "./fixtures/docx.js";

const pdfMimeType = "application/pdf";
const docxMimeType =
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

function createUploadedFile(
  buffer: Buffer,
  originalname: string,
  mimetype: string,
  size = buffer.length
): Express.Multer.File {
  return {
    buffer,
    destination: "",
    encoding: "7bit",
    fieldname: "file",
    filename: "",
    mimetype,
    originalname,
    path: "",
    size,
    stream: Readable.from(buffer)
  };
}

describe("contract file validation", () => {
  it("requires a file", () => {
    expect(() => validateContractFile(undefined)).toThrowError(
      expect.objectContaining({ code: "FILE_REQUIRED", statusCode: 400 })
    );
  });

  it("rejects an empty file", () => {
    const file = createUploadedFile(Buffer.alloc(0), "empty.txt", "text/plain");

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "EMPTY_FILE", statusCode: 400 })
    );
  });

  it("rejects a file over 20 MB without allocating a large fixture", () => {
    const file = createUploadedFile(
      Buffer.from("text"),
      "large.txt",
      "text/plain",
      MAX_CONTRACT_FILE_SIZE_BYTES + 1
    );

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "FILE_TOO_LARGE", statusCode: 413 })
    );
  });

  it("rejects an unsupported extension", () => {
    const file = createUploadedFile(Buffer.from("text"), "file.rtf", "text/plain");

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "UNSUPPORTED_FILE_TYPE", statusCode: 415 })
    );
  });

  it("rejects a MIME and extension mismatch", () => {
    const file = createUploadedFile(
      Buffer.from("%PDF-1.7"),
      "file.pdf",
      "text/plain"
    );

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "UNSUPPORTED_FILE_TYPE", statusCode: 415 })
    );
  });

  it("rejects an invalid PDF signature", () => {
    const file = createUploadedFile(Buffer.from("not-pdf"), "file.pdf", pdfMimeType);

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "UNSUPPORTED_FILE_TYPE", statusCode: 415 })
    );
  });

  it("rejects a generic ZIP renamed as DOCX", () => {
    const file = createUploadedFile(
      Buffer.from("PK\u0003\u0004not-a-word-document"),
      "file.docx",
      docxMimeType
    );

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "UNSUPPORTED_FILE_TYPE", statusCode: 415 })
    );
  });

  it("rejects TXT containing NUL or binary control bytes", () => {
    const file = createUploadedFile(
      Buffer.from([0x41, 0x00, 0x42]),
      "file.txt",
      "text/plain"
    );

    expect(() => validateContractFile(file)).toThrowError(
      expect.objectContaining({ code: "UNSUPPORTED_FILE_TYPE", statusCode: 415 })
    );
  });

  it("accepts valid PDF, DOCX, and UTF-8 TXT files", () => {
    const files = [
      createUploadedFile(Buffer.from("%PDF-1.7\n"), "file.pdf", pdfMimeType),
      createUploadedFile(createMinimalDocxBuffer(), "file.docx", docxMimeType),
      createUploadedFile(Buffer.from("Kontratë testuese"), "file.txt", "text/plain")
    ];

    expect(files.map((file) => validateContractFile(file).extension)).toEqual([
      ".pdf",
      ".docx",
      ".txt"
    ]);
  });

  it("sanitizes the display filename and never preserves path segments", () => {
    const file = createUploadedFile(
      Buffer.from("%PDF-1.7\n"),
      "../private/Contract\u0000.pdf",
      pdfMimeType
    );

    const result = validateContractFile(file);

    expect(result.originalFilename).toBe("Contract.pdf");
    expect(result.originalFilename).not.toContain("/");
  });
});
