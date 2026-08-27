import { describe, expect, it } from "vitest";

import { validateDocxArchive } from "../src/services/docx-archive-validation.service.js";
import {
  createMinimalDocxBuffer,
  createZipFixture,
  validContentTypesXml,
  validRootRelationshipsXml,
  type ZipFixtureEntry
} from "./fixtures/docx.js";

const validDocumentXml = `<?xml version="1.0" encoding="UTF-8"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body><w:p><w:r><w:t>Kontratë me tekst të vlefshëm.</w:t></w:r></w:p></w:body>
</w:document>`;

function criticalEntries(): ZipFixtureEntry[] {
  return [
    { name: "[Content_Types].xml", data: validContentTypesXml },
    { name: "_rels/.rels", data: validRootRelationshipsXml },
    { name: "word/document.xml", data: validDocumentXml }
  ];
}

function expectInvalidDocx(buffer: Buffer) {
  expect(() => validateDocxArchive(buffer)).toThrowError(
    expect.objectContaining({ code: "INVALID_DOCX", statusCode: 422 })
  );
}

describe("DOCX archive validation", () => {
  it("accepts a minimal valid WordprocessingML archive", () => {
    expect(() => validateDocxArchive(createMinimalDocxBuffer())).not.toThrow();
  });

  it.each([
    Buffer.from("not a zip archive"),
    createMinimalDocxBuffer().subarray(0, 80)
  ])("rejects non-ZIP and damaged ZIP input", (buffer) => {
    expectInvalidDocx(buffer);
  });

  it.each([
    "[Content_Types].xml",
    "_rels/.rels",
    "word/document.xml"
  ])("rejects an archive missing %s", (missingName) => {
    const entries = criticalEntries().filter(
      (entry) => entry.name !== missingName
    );

    expectInvalidDocx(createZipFixture(entries));
  });

  it("requires the WordprocessingML main document content type", () => {
    const entries = criticalEntries();
    entries[0] = {
      name: "[Content_Types].xml",
      data: "<Types><Override PartName=\"/word/document.xml\" ContentType=\"application/xml\"/></Types>"
    };

    expectInvalidDocx(createZipFixture(entries));
  });

  it("does not accept a content type hidden inside an XML comment", () => {
    const entries = criticalEntries();
    entries[0] = {
      name: "[Content_Types].xml",
      data:
        "<Types><!-- <Override PartName=\"/word/document.xml\" " +
        "ContentType=\"application/vnd.openxmlformats-officedocument." +
        "wordprocessingml.document.main+xml\"/> --></Types>"
    };

    expectInvalidDocx(createZipFixture(entries));
  });

  it("rejects encrypted entries with a dedicated safe error", () => {
    const entries = criticalEntries();
    entries[2] = { ...entries[2]!, flags: 0x0801 };

    expect(() => validateDocxArchive(createZipFixture(entries))).toThrowError(
      expect.objectContaining({ code: "DOCX_ENCRYPTED", statusCode: 422 })
    );
  });

  it.each([
    "../outside.xml",
    "/absolute.xml",
    "C:/drive.xml",
    "folder/../outside.xml",
    "unsafe\u0000name.xml"
  ])("rejects unsafe ZIP entry path %s", (name) => {
    expectInvalidDocx(
      createZipFixture([
        ...criticalEntries(),
        { name, data: "unsafe" }
      ])
    );
  });

  it("rejects duplicate critical entries", () => {
    expectInvalidDocx(
      createZipFixture([
        ...criticalEntries(),
        { name: "word/document.xml", data: validDocumentXml }
      ])
    );
  });

  it("rejects more than 2,000 entries", () => {
    const extraEntries = Array.from({ length: 1_998 }, (_, index) => ({
      name: `custom/entry-${index}.xml`,
      data: ""
    }));

    expectInvalidDocx(
      createZipFixture([...criticalEntries(), ...extraEntries])
    );
  });

  it("rejects a single entry declared over 20 MB", () => {
    const oversizedEntry: ZipFixtureEntry = {
      name: "custom/large.bin",
      data: Buffer.alloc(1),
      compressedData: Buffer.alloc(300_000),
      compressionMethod: 8,
      declaredUncompressedSize: 20 * 1024 * 1024 + 1
    };

    expect(() =>
      validateDocxArchive(
        createZipFixture([...criticalEntries(), oversizedEntry])
      )
    ).toThrowError(
      expect.objectContaining({
        code: "DOCX_RESOURCE_LIMIT_EXCEEDED",
        statusCode: 413
      })
    );
  });

  it("rejects total declared uncompressed data over 50 MB", () => {
    const largeEntries: ZipFixtureEntry[] = Array.from(
      { length: 3 },
      (_, index) => ({
        name: `custom/large-${index}.bin`,
        data: Buffer.alloc(1),
        compressedData: Buffer.alloc(200_000),
        compressionMethod: 8,
        declaredUncompressedSize: 18 * 1024 * 1024
      })
    );

    expect(() =>
      validateDocxArchive(
        createZipFixture([...criticalEntries(), ...largeEntries])
      )
    ).toThrowError(
      expect.objectContaining({ code: "DOCX_RESOURCE_LIMIT_EXCEEDED" })
    );
  });

  it("rejects compression ratios over 100:1", () => {
    const compressedEntry: ZipFixtureEntry = {
      name: "custom/compressed.bin",
      data: Buffer.alloc(1),
      compressedData: Buffer.alloc(10),
      compressionMethod: 8,
      declaredUncompressedSize: 1_001
    };

    expect(() =>
      validateDocxArchive(
        createZipFixture([...criticalEntries(), compressedEntry])
      )
    ).toThrowError(
      expect.objectContaining({ code: "DOCX_RESOURCE_LIMIT_EXCEEDED" })
    );
  });

  it("rejects malformed central directory data", () => {
    const buffer = createMinimalDocxBuffer();
    const endOffset = buffer.length - 22;
    const centralOffset = buffer.readUInt32LE(endOffset + 16);
    buffer.writeUInt32LE(0, centralOffset);

    expectInvalidDocx(buffer);
  });

  it("rejects ZIP64 sentinel values and ZIP64 extra fields", () => {
    const sentinelBuffer = createMinimalDocxBuffer();
    sentinelBuffer.writeUInt16LE(0xffff, sentinelBuffer.length - 22 + 10);
    expectInvalidDocx(sentinelBuffer);

    const zip64Extra = Buffer.from([0x01, 0x00, 0x00, 0x00]);
    const entries = criticalEntries();
    entries[2] = {
      ...entries[2]!,
      centralExtra: zip64Extra,
      localExtra: zip64Extra
    };
    expectInvalidDocx(createZipFixture(entries));
  });

  it("rejects local entry offsets outside the file payload", () => {
    const buffer = createMinimalDocxBuffer();
    const endOffset = buffer.length - 22;
    const centralOffset = buffer.readUInt32LE(endOffset + 16);
    buffer.writeUInt32LE(buffer.length, centralOffset + 42);

    expectInvalidDocx(buffer);
  });
});
