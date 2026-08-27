import { inflateRawSync } from "node:zlib";

import { ApiError } from "../utils/ApiError.js";

const END_OF_CENTRAL_DIRECTORY_SIGNATURE = 0x06054b50;
const CENTRAL_DIRECTORY_ENTRY_SIGNATURE = 0x02014b50;
const LOCAL_FILE_HEADER_SIGNATURE = 0x04034b50;
const MAX_ZIP_COMMENT_BYTES = 65_535;
const MAX_CONTRACT_FILE_SIZE_BYTES = 20 * 1024 * 1024;
const MAX_DOCX_ENTRIES = 2_000;
const MAX_TOTAL_UNCOMPRESSED_BYTES = 50 * 1024 * 1024;
const MAX_ENTRY_UNCOMPRESSED_BYTES = 20 * 1024 * 1024;
const MAX_COMPRESSION_RATIO = 100;
const MAX_CONTENT_TYPES_BYTES = 1024 * 1024;
const WORD_DOCUMENT_CONTENT_TYPE =
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml";
const CRITICAL_ENTRIES = new Set([
  "[Content_Types].xml",
  "_rels/.rels",
  "word/document.xml"
]);

type DocxArchiveEntry = {
  compressedSize: number;
  compressionMethod: number;
  dataEnd: number;
  dataStart: number;
  name: string;
  uncompressedSize: number;
};

function invalidDocx(): ApiError {
  return new ApiError(
    422,
    "INVALID_DOCX",
    "The DOCX archive is not valid."
  );
}

function resourceLimitExceeded(): ApiError {
  return new ApiError(
    413,
    "DOCX_RESOURCE_LIMIT_EXCEEDED",
    "The DOCX archive exceeds the allowed processing limits."
  );
}

function findEndOfCentralDirectory(buffer: Buffer): number {
  const minimumOffset = Math.max(
    0,
    buffer.length - (22 + MAX_ZIP_COMMENT_BYTES)
  );

  for (let offset = buffer.length - 22; offset >= minimumOffset; offset -= 1) {
    if (
      buffer.readUInt32LE(offset) === END_OF_CENTRAL_DIRECTORY_SIGNATURE
    ) {
      return offset;
    }
  }

  throw invalidDocx();
}

function decodeEntryName(nameBytes: Buffer): string {
  let name: string;

  try {
    name = new TextDecoder("utf-8", { fatal: true }).decode(nameBytes);
  } catch {
    throw invalidDocx();
  }

  if (
    name.length === 0 ||
    name.includes("\u0000") ||
    name.startsWith("/") ||
    name.startsWith("\\") ||
    /^[a-zA-Z]:/.test(name)
  ) {
    throw invalidDocx();
  }

  const normalizedName = name.replaceAll("\\", "/");
  const segments = normalizedName.split("/");

  if (segments.some((segment) => segment === "..")) {
    throw invalidDocx();
  }

  return normalizedName;
}

function validateEntryLimits(
  compressedSize: number,
  uncompressedSize: number
): void {
  if (uncompressedSize > MAX_ENTRY_UNCOMPRESSED_BYTES) {
    throw resourceLimitExceeded();
  }

  if (
    uncompressedSize > 0 &&
    (compressedSize === 0 || uncompressedSize / compressedSize > MAX_COMPRESSION_RATIO)
  ) {
    throw resourceLimitExceeded();
  }
}

function containsZip64ExtraField(
  buffer: Buffer,
  start: number,
  length: number
): boolean {
  const end = start + length;
  let offset = start;

  while (offset < end) {
    if (offset + 4 > end) {
      throw invalidDocx();
    }

    const headerId = buffer.readUInt16LE(offset);
    const dataSize = buffer.readUInt16LE(offset + 2);
    offset += 4;

    if (offset + dataSize > end) {
      throw invalidDocx();
    }

    if (headerId === 0x0001) {
      return true;
    }

    offset += dataSize;
  }

  return false;
}

function parseArchiveEntries(buffer: Buffer): Map<string, DocxArchiveEntry> {
  if (
    buffer.length < 22 ||
    buffer.length > MAX_CONTRACT_FILE_SIZE_BYTES ||
    buffer.readUInt32LE(0) !== LOCAL_FILE_HEADER_SIGNATURE
  ) {
    throw invalidDocx();
  }

  const endOffset = findEndOfCentralDirectory(buffer);
  const diskNumber = buffer.readUInt16LE(endOffset + 4);
  const centralDirectoryDisk = buffer.readUInt16LE(endOffset + 6);
  const entriesOnDisk = buffer.readUInt16LE(endOffset + 8);
  const entryCount = buffer.readUInt16LE(endOffset + 10);
  const directorySize = buffer.readUInt32LE(endOffset + 12);
  const directoryOffset = buffer.readUInt32LE(endOffset + 16);
  const commentLength = buffer.readUInt16LE(endOffset + 20);

  if (
    endOffset + 22 + commentLength !== buffer.length ||
    diskNumber !== 0 ||
    centralDirectoryDisk !== 0 ||
    entriesOnDisk !== entryCount ||
    entryCount === 0 ||
    entryCount === 0xffff ||
    directorySize === 0xffffffff ||
    directoryOffset === 0xffffffff ||
    entryCount > MAX_DOCX_ENTRIES ||
    directoryOffset + directorySize !== endOffset
  ) {
    throw invalidDocx();
  }

  const entries = new Map<string, DocxArchiveEntry>();
  const occupiedRanges: Array<{ end: number; start: number }> = [];
  let totalUncompressedSize = 0;
  let offset = directoryOffset;

  for (let index = 0; index < entryCount; index += 1) {
    if (
      offset + 46 > endOffset ||
      buffer.readUInt32LE(offset) !== CENTRAL_DIRECTORY_ENTRY_SIGNATURE
    ) {
      throw invalidDocx();
    }

    const flags = buffer.readUInt16LE(offset + 8);
    const compressionMethod = buffer.readUInt16LE(offset + 10);
    const compressedSize = buffer.readUInt32LE(offset + 20);
    const uncompressedSize = buffer.readUInt32LE(offset + 24);
    const nameLength = buffer.readUInt16LE(offset + 28);
    const extraLength = buffer.readUInt16LE(offset + 30);
    const commentSize = buffer.readUInt16LE(offset + 32);
    const diskStart = buffer.readUInt16LE(offset + 34);
    const localHeaderOffset = buffer.readUInt32LE(offset + 42);
    const nextOffset = offset + 46 + nameLength + extraLength + commentSize;

    if (
      nextOffset > endOffset ||
      nameLength === 0 ||
      diskStart !== 0 ||
      localHeaderOffset === 0xffffffff ||
      compressedSize === 0xffffffff ||
      uncompressedSize === 0xffffffff ||
      (flags & 0x1) !== 0 ||
      (compressionMethod !== 0 && compressionMethod !== 8)
    ) {
      if ((flags & 0x1) !== 0) {
        throw new ApiError(
          422,
          "DOCX_ENCRYPTED",
          "Encrypted DOCX archives are not supported."
        );
      }

      throw invalidDocx();
    }

    const centralNameBytes = buffer.subarray(
      offset + 46,
      offset + 46 + nameLength
    );
    const centralExtraStart = offset + 46 + nameLength;

    if (
      containsZip64ExtraField(
        buffer,
        centralExtraStart,
        extraLength
      )
    ) {
      throw invalidDocx();
    }

    const name = decodeEntryName(centralNameBytes);

    if (entries.has(name) && CRITICAL_ENTRIES.has(name)) {
      throw invalidDocx();
    }

    if (
      localHeaderOffset + 30 > directoryOffset ||
      buffer.readUInt32LE(localHeaderOffset) !== LOCAL_FILE_HEADER_SIGNATURE
    ) {
      throw invalidDocx();
    }

    const localFlags = buffer.readUInt16LE(localHeaderOffset + 6);
    const localCompressionMethod = buffer.readUInt16LE(localHeaderOffset + 8);
    const localNameLength = buffer.readUInt16LE(localHeaderOffset + 26);
    const localExtraLength = buffer.readUInt16LE(localHeaderOffset + 28);
    const localNameStart = localHeaderOffset + 30;
    const localExtraStart = localNameStart + localNameLength;
    const dataStart = localNameStart + localNameLength + localExtraLength;
    const dataEnd = dataStart + compressedSize;

    if (
      localFlags !== flags ||
      localCompressionMethod !== compressionMethod ||
      localNameLength !== nameLength ||
      dataStart > directoryOffset ||
      dataEnd > directoryOffset ||
      !buffer
        .subarray(localNameStart, localNameStart + localNameLength)
        .equals(centralNameBytes)
    ) {
      throw invalidDocx();
    }

    if (
      containsZip64ExtraField(
        buffer,
        localExtraStart,
        localExtraLength
      )
    ) {
      throw invalidDocx();
    }

    validateEntryLimits(compressedSize, uncompressedSize);
    totalUncompressedSize += uncompressedSize;

    if (totalUncompressedSize > MAX_TOTAL_UNCOMPRESSED_BYTES) {
      throw resourceLimitExceeded();
    }

    occupiedRanges.push({ start: localHeaderOffset, end: dataEnd });
    entries.set(name, {
      compressedSize,
      compressionMethod,
      dataEnd,
      dataStart,
      name,
      uncompressedSize
    });
    offset = nextOffset;
  }

  if (offset !== endOffset) {
    throw invalidDocx();
  }

  occupiedRanges.sort((left, right) => left.start - right.start);

  for (let index = 1; index < occupiedRanges.length; index += 1) {
    const previous = occupiedRanges[index - 1];
    const current = occupiedRanges[index];

    if (!previous || !current || current.start < previous.end) {
      throw invalidDocx();
    }
  }

  return entries;
}

function readEntry(buffer: Buffer, entry: DocxArchiveEntry): Buffer {
  const compressedData = buffer.subarray(entry.dataStart, entry.dataEnd);

  if (entry.compressionMethod === 0) {
    if (entry.compressedSize !== entry.uncompressedSize) {
      throw invalidDocx();
    }

    return compressedData;
  }

  try {
    const output = inflateRawSync(compressedData, {
      maxOutputLength: Math.min(
        entry.uncompressedSize + 1,
        MAX_ENTRY_UNCOMPRESSED_BYTES + 1
      )
    });

    if (output.length !== entry.uncompressedSize) {
      throw invalidDocx();
    }

    return output;
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }

    throw invalidDocx();
  }
}

function hasWordDocumentContentType(contentTypesXml: string): boolean {
  if (
    /<!DOCTYPE|<!ENTITY|<!\[CDATA\[/i.test(contentTypesXml) ||
    (contentTypesXml.match(/<!--/g)?.length ?? 0) !==
      (contentTypesXml.match(/-->/g)?.length ?? 0)
  ) {
    return false;
  }

  const withoutComments = contentTypesXml.replace(/<!--[\s\S]*?-->/g, "");
  const overrideTags = withoutComments.match(/<Override\b[^>]*>/gi) ?? [];

  return overrideTags.some((tag) => {
    const partName = tag.match(/\bPartName\s*=\s*["']([^"']+)["']/i)?.[1];
    const contentType = tag.match(
      /\bContentType\s*=\s*["']([^"']+)["']/i
    )?.[1];

    return (
      partName === "/word/document.xml" &&
      contentType === WORD_DOCUMENT_CONTENT_TYPE
    );
  });
}

export function validateDocxArchive(buffer: Buffer): void {
  const entries = parseArchiveEntries(buffer);

  for (const criticalEntry of CRITICAL_ENTRIES) {
    if (!entries.has(criticalEntry)) {
      throw invalidDocx();
    }
  }

  const contentTypesEntry = entries.get("[Content_Types].xml");

  if (
    !contentTypesEntry ||
    contentTypesEntry.uncompressedSize > MAX_CONTENT_TYPES_BYTES
  ) {
    throw invalidDocx();
  }

  const contentTypesBuffer = readEntry(buffer, contentTypesEntry);
  let contentTypesXml: string;

  try {
    contentTypesXml = new TextDecoder("utf-8", { fatal: true }).decode(
      contentTypesBuffer
    );
  } catch {
    throw invalidDocx();
  }

  if (!hasWordDocumentContentType(contentTypesXml)) {
    throw invalidDocx();
  }
}
