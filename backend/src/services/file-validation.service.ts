import path from "node:path";
import { TextDecoder } from "node:util";

import { ApiError } from "../utils/ApiError.js";
import { validateDocxArchive } from "./docx-archive-validation.service.js";

const MAX_ORIGINAL_FILENAME_LENGTH = 200;

export const MAX_CONTRACT_FILE_SIZE_BYTES = 20 * 1024 * 1024;

export const allowedContractFileTypes = {
  ".pdf": "application/pdf",
  ".docx":
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  ".txt": "text/plain"
} as const;

export type AllowedContractFileExtension =
  keyof typeof allowedContractFileTypes;

export type AllowedContractFileMimeType =
  (typeof allowedContractFileTypes)[AllowedContractFileExtension];

export type ValidatedContractFile = {
  buffer: Buffer;
  extension: AllowedContractFileExtension;
  mimeType: AllowedContractFileMimeType;
  originalFilename: string;
  size: number;
};

function unsupportedFileType(): ApiError {
  return new ApiError(
    415,
    "UNSUPPORTED_FILE_TYPE",
    "Only valid PDF, DOCX, or UTF-8 TXT files are supported."
  );
}

function isPdf(buffer: Buffer): boolean {
  return buffer.length >= 5 && buffer.subarray(0, 5).equals(Buffer.from("%PDF-"));
}

function isDocx(buffer: Buffer): boolean {
  try {
    validateDocxArchive(buffer);
    return true;
  } catch {
    return false;
  }
}

function isUtf8Text(buffer: Buffer): boolean {
  if (buffer.includes(0)) {
    return false;
  }

  try {
    new TextDecoder("utf-8", { fatal: true }).decode(buffer);
  } catch {
    return false;
  }

  let suspiciousControlBytes = 0;

  for (const byte of buffer) {
    const isAllowedWhitespace = byte === 9 || byte === 10 || byte === 13;

    if ((byte < 32 && !isAllowedWhitespace) || byte === 127) {
      suspiciousControlBytes += 1;
    }
  }

  return suspiciousControlBytes / buffer.length <= 0.01;
}

function sanitizeOriginalFilename(
  originalName: string,
  extension: AllowedContractFileExtension
): string {
  const withoutPath = path.posix.basename(originalName.replaceAll("\\", "/"));
  const withoutExtension = withoutPath.slice(0, -extension.length);
  const cleanedBase = withoutExtension
    .replace(/[\u0000-\u001f\u007f]/g, "")
    .trim();
  const maximumBaseLength = MAX_ORIGINAL_FILENAME_LENGTH - extension.length;
  const safeBase = cleanedBase.slice(0, maximumBaseLength).trim() || "document";

  return `${safeBase}${extension}`;
}

export function validateContractFile(
  file: Express.Multer.File | undefined
): ValidatedContractFile {
  if (!file) {
    throw new ApiError(
      400,
      "FILE_REQUIRED",
      "Exactly one file must be uploaded in the file field."
    );
  }

  if (file.size === 0 || file.buffer.length === 0) {
    throw new ApiError(400, "EMPTY_FILE", "The uploaded file is empty.");
  }

  if (
    file.size > MAX_CONTRACT_FILE_SIZE_BYTES ||
    file.buffer.length > MAX_CONTRACT_FILE_SIZE_BYTES
  ) {
    throw new ApiError(
      413,
      "FILE_TOO_LARGE",
      "The file must not exceed 20 MB."
    );
  }

  const extension = path.extname(file.originalname).toLowerCase();

  if (!(extension in allowedContractFileTypes)) {
    throw unsupportedFileType();
  }

  const typedExtension = extension as AllowedContractFileExtension;
  const expectedMimeType = allowedContractFileTypes[typedExtension];

  if (file.mimetype !== expectedMimeType) {
    throw unsupportedFileType();
  }

  const signatureIsValid =
    (typedExtension === ".pdf" && isPdf(file.buffer)) ||
    (typedExtension === ".docx" && isDocx(file.buffer)) ||
    (typedExtension === ".txt" && isUtf8Text(file.buffer));

  if (!signatureIsValid) {
    throw unsupportedFileType();
  }

  return {
    buffer: file.buffer,
    extension: typedExtension,
    mimeType: expectedMimeType,
    originalFilename: sanitizeOriginalFilename(file.originalname, typedExtension),
    size: file.size
  };
}
