import { createHash } from "node:crypto";
import type { SupabaseClient } from "@supabase/supabase-js";

import {
  createUserSupabaseClient,
  supabaseAdmin
} from "../config/supabase.js";
import { extractDocx, type ExtractDocx } from "../extractors/docx.extractor.js";
import {
  extractPdf,
  type ExtractPdf,
  type PdfExtractionResult
} from "../extractors/pdf.extractor.js";
import { extractTxt } from "../extractors/txt.extractor.js";
import type { AuthenticatedUser } from "../types/api.js";
import { ApiError } from "../utils/ApiError.js";
import {
  CONTRACT_FILES_BUCKET,
  contractFileStorage,
  type ContractFileStorage
} from "./storage.service.js";

type ExtractionStatus =
  | "pending"
  | "extracting"
  | "completed"
  | "failed"
  | "unsupported"
  | "requires_ocr";

type ContractVersionForExtraction = {
  id: string;
  contract_id: string;
  source_kind: string;
  storage_bucket: string | null;
  storage_path: string | null;
  mime_type: string | null;
  file_size_bytes: number | null;
  sha256: string | null;
  page_count: number | null;
  extraction_status: ExtractionStatus;
  updated_at: string;
};

export type DocumentExtractionResult = {
  contractId: string;
  versionId: string;
  extractionStatus: "completed" | "requires_ocr";
  pageCount: number | null;
  updatedAt: string;
};

export type ExtractContractVersion = (
  authenticatedUser: AuthenticatedUser,
  contractId: string,
  versionId: string
) => Promise<DocumentExtractionResult>;

export type DocumentExtractionDependencies = {
  adminClient?: SupabaseClient;
  createUserClient?: (accessToken: string) => SupabaseClient;
  extractText?: (buffer: Buffer) => string;
  extractDocxText?: ExtractDocx;
  extractPdfText?: ExtractPdf;
  storage?: ContractFileStorage;
};

const DOCX_MIME_TYPE =
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
const PDF_MIME_TYPE = "application/pdf";
type SupportedExtractionMimeType =
  | "text/plain"
  | typeof DOCX_MIME_TYPE
  | typeof PDF_MIME_TYPE;

const VERSION_COLUMNS =
  "id, contract_id, source_kind, storage_bucket, storage_path, mime_type, " +
  "file_size_bytes, sha256, page_count, extraction_status, updated_at";

function databaseUnavailable(): ApiError {
  return new ApiError(
    503,
    "DATABASE_UNAVAILABLE",
    "The extraction status could not be saved at this time."
  );
}

function versionNotFound(): ApiError {
  return new ApiError(
    404,
    "VERSION_NOT_FOUND",
    "The contract version was not found."
  );
}

async function verifyContractOwnership(
  client: SupabaseClient,
  userId: string,
  contractId: string
): Promise<void> {
  const { data, error } = await client
    .from("contracts")
    .select("id")
    .eq("id", contractId)
    .eq("owner_id", userId)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw versionNotFound();
  }
}

async function getOwnedVersion(
  client: SupabaseClient,
  contractId: string,
  versionId: string
): Promise<ContractVersionForExtraction> {
  const { data, error } = await client
    .from("contract_versions")
    .select(VERSION_COLUMNS)
    .eq("id", versionId)
    .eq("contract_id", contractId)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw versionNotFound();
  }

  return data as unknown as ContractVersionForExtraction;
}

function validateVersionMetadata(
  version: ContractVersionForExtraction,
  userId: string,
  contractId: string,
  versionId: string
): asserts version is ContractVersionForExtraction & {
  storage_bucket: string;
  storage_path: string;
  file_size_bytes: number;
  sha256: string;
  mime_type: SupportedExtractionMimeType;
} {
  if (
    version.mime_type !== "text/plain" &&
    version.mime_type !== DOCX_MIME_TYPE &&
    version.mime_type !== PDF_MIME_TYPE
  ) {
    throw new ApiError(
      422,
      "UNSUPPORTED_DOCUMENT_TYPE",
      "This document type is not supported for text extraction."
    );
  }

  const expectedExtension =
    version.mime_type === "text/plain"
      ? "txt"
      : version.mime_type === DOCX_MIME_TYPE
        ? "docx"
        : "pdf";
  const expectedPath =
    `users/${userId}/contracts/${contractId}` +
    `/versions/${versionId}/original.${expectedExtension}`;
  const hasValidMetadata =
    version.source_kind === "upload" &&
    version.storage_bucket === CONTRACT_FILES_BUCKET &&
    version.storage_path === expectedPath &&
    typeof version.file_size_bytes === "number" &&
    version.file_size_bytes > 0 &&
    typeof version.sha256 === "string" &&
    /^[0-9a-f]{64}$/.test(version.sha256);

  if (!hasValidMetadata) {
    throw new ApiError(
      422,
      "INVALID_VERSION_METADATA",
      "The contract version metadata is not valid for extraction."
    );
  }
}

function terminalResult(
  contractId: string,
  version: ContractVersionForExtraction
): DocumentExtractionResult {
  return {
    contractId,
    versionId: version.id,
    extractionStatus: version.extraction_status as "completed" | "requires_ocr",
    pageCount: version.page_count,
    updatedAt: version.updated_at
  };
}

function assertExtractableStatus(
  version: ContractVersionForExtraction
): void {
  if (version.extraction_status === "extracting") {
    throw new ApiError(
      409,
      "EXTRACTION_ALREADY_RUNNING",
      "Text extraction is already running for this version."
    );
  }

  if (version.extraction_status === "unsupported") {
    throw new ApiError(
      422,
      "UNSUPPORTED_DOCUMENT_TYPE",
      "This document type is not supported for text extraction."
    );
  }
}

async function claimExtraction(
  adminClient: SupabaseClient,
  contractId: string,
  versionId: string
): Promise<void> {
  const { data, error } = await adminClient
    .from("contract_versions")
    .update({
      extraction_status: "extracting",
      extracted_text: null,
      extraction_error_safe: null
    })
    .eq("id", versionId)
    .eq("contract_id", contractId)
    .in("extraction_status", ["pending", "failed"])
    .select("id")
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw new ApiError(
      409,
      "EXTRACTION_ALREADY_RUNNING",
      "Text extraction could not be claimed because its status changed."
    );
  }
}

async function completeExtraction(
  adminClient: SupabaseClient,
  contractId: string,
  versionId: string,
  extractedText: string,
  pageCount: number | null
): Promise<string> {
  const { data, error } = await adminClient
    .from("contract_versions")
    .update({
      extraction_status: "completed",
      extracted_text: extractedText,
      page_count: pageCount,
      extraction_error_safe: null
    })
    .eq("id", versionId)
    .eq("contract_id", contractId)
    .eq("extraction_status", "extracting")
    .select("updated_at")
    .maybeSingle();

  if (error || !data || typeof data.updated_at !== "string") {
    throw databaseUnavailable();
  }

  return data.updated_at;
}

async function completeRequiresOcr(
  adminClient: SupabaseClient,
  contractId: string,
  versionId: string,
  pageCount: number
): Promise<string> {
  const { data, error } = await adminClient
    .from("contract_versions")
    .update({
      extraction_status: "requires_ocr",
      extracted_text: null,
      page_count: pageCount,
      extraction_error_safe:
        "The PDF does not contain enough extractable text and requires OCR."
    })
    .eq("id", versionId)
    .eq("contract_id", contractId)
    .eq("extraction_status", "extracting")
    .select("updated_at")
    .maybeSingle();

  if (error || !data || typeof data.updated_at !== "string") {
    throw databaseUnavailable();
  }

  return data.updated_at;
}

const SAFE_EXTRACTION_MESSAGES: Readonly<Record<string, string>> = {
  STORAGE_OBJECT_NOT_FOUND: "The stored contract file was not found.",
  STORAGE_UNAVAILABLE: "The stored contract file is temporarily unavailable.",
  STORAGE_DOWNLOAD_INCOMPLETE: "The stored contract file could not be downloaded completely.",
  FILE_TOO_LARGE: "The stored contract file exceeds the allowed size.",
  FILE_SIZE_MISMATCH: "The stored contract file failed its integrity check.",
  FILE_CHECKSUM_MISMATCH: "The stored contract file failed its integrity check.",
  INVALID_TEXT_ENCODING: "The text file must contain valid UTF-8 text.",
  EMPTY_EXTRACTED_TEXT: "The document does not contain enough meaningful text.",
  EXTRACTION_OUTPUT_TOO_LARGE: "The extracted text exceeds the allowed size.",
  INVALID_DOCX: "The DOCX archive is not valid.",
  DOCX_RESOURCE_LIMIT_EXCEEDED: "The DOCX archive exceeds the allowed processing limits.",
  DOCX_ENCRYPTED: "Encrypted DOCX archives are not supported.",
  PARSER_FAILED: "The DOCX text could not be extracted safely.",
  INVALID_PDF: "The PDF document is not valid.",
  PDF_ENCRYPTED: "Encrypted PDF documents are not supported.",
  PDF_PAGE_LIMIT_EXCEEDED: "The PDF document exceeds the allowed page limit.",
  PDF_RESOURCE_LIMIT_EXCEEDED:
    "The PDF document exceeds the allowed processing limits.",
  PDF_PARSER_FAILED: "The PDF text could not be extracted safely."
};

function safeExtractionMessage(error: unknown): string {
  if (error instanceof ApiError) {
    return SAFE_EXTRACTION_MESSAGES[error.code] ?? "Text extraction failed safely.";
  }

  return "Text extraction failed safely.";
}

async function markExtractionFailed(
  adminClient: SupabaseClient,
  contractId: string,
  versionId: string,
  errorToRecord: unknown
): Promise<void> {
  const safeMessage = safeExtractionMessage(errorToRecord).slice(0, 500);
  const errorDetails =
    errorToRecord instanceof ApiError &&
    typeof errorToRecord.details === "object" &&
    errorToRecord.details !== null &&
    "pageCount" in errorToRecord.details &&
    typeof errorToRecord.details.pageCount === "number"
      ? errorToRecord.details.pageCount
      : null;
  const { data, error } = await adminClient
    .from("contract_versions")
    .update({
      extraction_status: "failed",
      extracted_text: null,
      page_count: errorDetails,
      extraction_error_safe: safeMessage
    })
    .eq("id", versionId)
    .eq("contract_id", contractId)
    .eq("extraction_status", "extracting")
    .select("id")
    .maybeSingle();

  if (error || !data) {
    throw databaseUnavailable();
  }
}

function verifyDownloadedFile(
  buffer: Buffer,
  version: ContractVersionForExtraction & {
    file_size_bytes: number;
    sha256: string;
  }
): void {
  if (buffer.length !== version.file_size_bytes) {
    throw new ApiError(
      422,
      "FILE_SIZE_MISMATCH",
      "The stored contract file failed its integrity check."
    );
  }

  const actualChecksum = createHash("sha256").update(buffer).digest("hex");

  if (actualChecksum !== version.sha256) {
    throw new ApiError(
      422,
      "FILE_CHECKSUM_MISMATCH",
      "The stored contract file failed its integrity check."
    );
  }
}

export function createExtractContractVersion(
  dependencies: DocumentExtractionDependencies = {}
): ExtractContractVersion {
  const adminClient = dependencies.adminClient ?? supabaseAdmin;
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;
  const extractText = dependencies.extractText ?? extractTxt;
  const extractDocxText = dependencies.extractDocxText ?? extractDocx;
  const extractPdfText = dependencies.extractPdfText ?? extractPdf;
  const storage = dependencies.storage ?? contractFileStorage;

  return async (authenticatedUser, contractId, versionId) => {
    const userClient = createUserClient(authenticatedUser.accessToken);

    await verifyContractOwnership(
      userClient,
      authenticatedUser.userId,
      contractId
    );

    const version = await getOwnedVersion(userClient, contractId, versionId);

    if (
      version.extraction_status === "completed" ||
      version.extraction_status === "requires_ocr"
    ) {
      return terminalResult(contractId, version);
    }

    assertExtractableStatus(version);
    validateVersionMetadata(
      version,
      authenticatedUser.userId,
      contractId,
      versionId
    );
    await claimExtraction(adminClient, contractId, versionId);

    try {
      const buffer = await storage.download(version.storage_path);
      verifyDownloadedFile(buffer, version);
      let extractedText: string;
      let pageCount: number | null = null;

      if (version.mime_type === "text/plain") {
        extractedText = extractText(buffer);
      } else if (version.mime_type === DOCX_MIME_TYPE) {
        extractedText = await extractDocxText(buffer);
      } else {
        const pdfResult: PdfExtractionResult = await extractPdfText(buffer);
        pageCount = pdfResult.pageCount;

        if (pdfResult.status === "requires_ocr") {
          const updatedAt = await completeRequiresOcr(
            adminClient,
            contractId,
            versionId,
            pageCount
          );

          return {
            contractId,
            versionId,
            extractionStatus: "requires_ocr",
            pageCount,
            updatedAt
          };
        }

        extractedText = pdfResult.text;
      }

      const updatedAt = await completeExtraction(
        adminClient,
        contractId,
        versionId,
        extractedText,
        pageCount
      );

      return {
        contractId,
        versionId,
        extractionStatus: "completed",
        pageCount,
        updatedAt
      };
    } catch (error) {
      if (error instanceof ApiError && error.code === "DATABASE_UNAVAILABLE") {
        throw error;
      }

      await markExtractionFailed(adminClient, contractId, versionId, error);

      if (error instanceof ApiError) {
        throw error;
      }

      throw new ApiError(
        500,
        "EXTRACTION_FAILED",
        "Text extraction failed safely."
      );
    }
  };
}

export const extractContractVersion = createExtractContractVersion();
