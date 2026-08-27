import { createHash } from "node:crypto";
import type { SupabaseClient } from "@supabase/supabase-js";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import type { ExtractDocx } from "../src/extractors/docx.extractor.js";
import type { ExtractPdf } from "../src/extractors/pdf.extractor.js";
import {
  createExtractContractVersion,
  type ExtractContractVersion
} from "../src/services/document-extraction.service.js";
import type { ContractFileStorage } from "../src/services/storage.service.js";
import { ApiError } from "../src/utils/ApiError.js";

const contractId = "11111111-1111-4111-8111-111111111111";
const otherContractId = "33333333-3333-4333-8333-333333333333";
const versionId = "22222222-2222-4222-8222-222222222222";
const userId = "user-a";
const accessToken = "verified-test-value";
const updatedAt = "2026-08-09T12:00:00.000Z";
const validText = "Kontratë shërbimi me detyrime dhe kushte të përcaktuara qartë.";
const validBuffer = Buffer.from(validText, "utf8");
const validChecksum = createHash("sha256").update(validBuffer).digest("hex");
const expectedPath =
  `users/${userId}/contracts/${contractId}` +
  `/versions/${versionId}/original.txt`;
const authenticatedMiddleware = createRequireAuth(async () => userId);

type ExtractionStatus =
  | "pending"
  | "extracting"
  | "completed"
  | "failed"
  | "unsupported"
  | "requires_ocr";

type Scenario = {
  adminClaimError?: boolean;
  claimMissing?: boolean;
  completeError?: boolean;
  contractError?: boolean;
  contractOwned?: boolean;
  extractDocxText?: ExtractDocx;
  extractPdfText?: ExtractPdf;
  failUpdateError?: boolean;
  status?: ExtractionStatus;
  version?: Partial<Record<string, unknown>>;
  versionError?: boolean;
  versionOwned?: boolean;
};

function createEqBuilder(finalResult: () => Promise<unknown>) {
  const builder: Record<string, unknown> = {};
  builder.eq = vi.fn(() => builder);
  builder.in = vi.fn(() => builder);
  builder.select = vi.fn(() => builder);
  builder.maybeSingle = vi.fn(finalResult);
  return builder;
}

function createHarness(scenario: Scenario = {}) {
  const events: string[] = [];
  const version = {
    id: versionId,
    contract_id: contractId,
    source_kind: "upload",
    storage_bucket: "contract-files",
    storage_path: expectedPath,
    mime_type: "text/plain",
    file_size_bytes: validBuffer.length,
    sha256: validChecksum,
    page_count: null,
    extraction_status: scenario.status ?? "pending",
    updated_at: updatedAt,
    ...scenario.version
  };

  const contractBuilder = createEqBuilder(async () => {
    events.push("contract-ownership");
    return {
      data: scenario.contractOwned === false ? null : { id: contractId },
      error: scenario.contractError ? { message: "private database error" } : null
    };
  });
  const versionBuilder = createEqBuilder(async () => {
    events.push("version-ownership");
    return {
      data: scenario.versionOwned === false ? null : version,
      error: scenario.versionError ? { message: "private database error" } : null
    };
  });
  const userFrom = vi.fn((table: string) => ({
    select: vi.fn(() =>
      table === "contracts" ? contractBuilder : versionBuilder
    )
  }));
  const userClient = { from: userFrom } as unknown as SupabaseClient;

  const adminUpdates: Array<Record<string, unknown>> = [];
  const adminFrom = vi.fn(() => ({
    update: vi.fn((values: Record<string, unknown>) => {
      adminUpdates.push(values);
      const status = values.extraction_status;

      return createEqBuilder(async () => {
        events.push(`admin-${String(status)}`);

        if (status === "extracting") {
          return {
            data: scenario.claimMissing ? null : { id: versionId },
            error: scenario.adminClaimError
              ? { message: "private claim error" }
              : null
          };
        }

        if (status === "completed" || status === "requires_ocr") {
          return {
            data: scenario.completeError ? null : { updated_at: updatedAt },
            error: scenario.completeError
              ? { message: "private completion error" }
              : null
          };
        }

        return {
          data: scenario.failUpdateError ? null : { id: versionId },
          error: scenario.failUpdateError
            ? { message: "private failure update error" }
            : null
        };
      });
    })
  }));
  const adminClient = { from: adminFrom } as unknown as SupabaseClient;
  const download = vi.fn(async () => {
    events.push("storage-download");
    return validBuffer;
  });
  const storage: ContractFileStorage = {
    upload: vi.fn(),
    download,
    remove: vi.fn()
  };
  const createUserClient = vi.fn(() => userClient);
  const service = createExtractContractVersion({
    adminClient,
    createUserClient,
    extractDocxText: scenario.extractDocxText,
    extractPdfText: scenario.extractPdfText,
    storage
  });

  return {
    adminFrom,
    adminUpdates,
    createUserClient,
    download,
    events,
    service,
    storage,
    userFrom
  };
}

function runService(
  context: ReturnType<typeof createHarness>,
  requestedContractId = contractId
) {
  return context.service(
    { userId, accessToken },
    requestedContractId,
    versionId
  );
}

describe("POST /api/contracts/:contractId/versions/:versionId/extract", () => {
  it("requires authentication", async () => {
    const extractContractVersion = vi.fn<ExtractContractVersion>();
    const response = await request(createApp({ extractContractVersion })).post(
      `/api/contracts/${contractId}/versions/${versionId}/extract`
    );

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
    expect(extractContractVersion).not.toHaveBeenCalled();
  });

  it.each([
    ["not-a-uuid", versionId],
    [contractId, "not-a-uuid"]
  ])("rejects invalid UUID parameters", async (invalidContractId, invalidVersionId) => {
    const extractContractVersion = vi.fn<ExtractContractVersion>();
    const response = await request(
      createApp({ authMiddleware: authenticatedMiddleware, extractContractVersion })
    )
      .post(
        `/api/contracts/${invalidContractId}/versions/${invalidVersionId}/extract`
      )
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(extractContractVersion).not.toHaveBeenCalled();
  });

  it("rejects a non-empty request body", async () => {
    const extractContractVersion = vi.fn<ExtractContractVersion>();
    const response = await request(
      createApp({ authMiddleware: authenticatedMiddleware, extractContractVersion })
    )
      .post(`/api/contracts/${contractId}/versions/${versionId}/extract`)
      .set("Authorization", `Bearer ${accessToken}`)
      .send({ storagePath: "untrusted" });

    expect(response.status).toBe(400);
    expect(extractContractVersion).not.toHaveBeenCalled();
  });

  it("returns only extraction status metadata", async () => {
    const result = {
      contractId,
      versionId,
      extractionStatus: "completed" as const,
      pageCount: null,
      updatedAt
    };
    const extractContractVersion = vi.fn<ExtractContractVersion>(async () => result);
    const response = await request(
      createApp({ authMiddleware: authenticatedMiddleware, extractContractVersion })
    )
      .post(`/api/contracts/${contractId}/versions/${versionId}/extract`)
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ data: result });
    expect(JSON.stringify(response.body)).not.toContain(validText);
  });
});

describe("TXT document extraction service", () => {
  it("checks contract and version ownership before admin access or download", async () => {
    const context = createHarness();

    await runService(context);

    expect(context.createUserClient).toHaveBeenCalledWith(accessToken);
    expect(context.events.slice(0, 3)).toEqual([
      "contract-ownership",
      "version-ownership",
      "admin-extracting"
    ]);
    expect(context.events[3]).toBe("storage-download");
  });

  it.each([
    [{ contractOwned: false }, "contract unavailable"],
    [{ versionOwned: false }, "version unavailable"],
    [{ version: { contract_id: otherContractId }, versionOwned: false }, "other contract"]
  ] as const)("returns the same 404 when %s", async (scenario, _description) => {
    const context = createHarness(scenario);

    await expect(runService(context)).rejects.toMatchObject({
      code: "VERSION_NOT_FOUND",
      statusCode: 404
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
    expect(context.download).not.toHaveBeenCalled();
  });

  it.each([
    ["storage_bucket", "other-bucket"],
    ["storage_path", "users/untrusted/original.txt"],
    ["source_kind", "generated"]
  ])("rejects invalid %s metadata before admin access", async (key, value) => {
    const context = createHarness({ version: { [key]: value } });

    await expect(runService(context)).rejects.toMatchObject({
      code: "INVALID_VERSION_METADATA",
      statusCode: 422
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
    expect(context.download).not.toHaveBeenCalled();
  });

  it("rejects an unsupported MIME without using the admin client", async () => {
    const context = createHarness({ version: { mime_type: "image/png" } });

    await expect(runService(context)).rejects.toMatchObject({
      code: "UNSUPPORTED_DOCUMENT_TYPE",
      statusCode: 422
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
  });

  it("dispatches PDF by authoritative MIME and stores its real page count", async () => {
    const extractedPdfText =
      "Kontrate PDF me kushte dhe detyrime te percaktuara qarte.";
    const extractPdfText = vi.fn<ExtractPdf>(async () => ({
      status: "completed",
      text: extractedPdfText,
      pageCount: 2
    }));
    const context = createHarness({
      extractPdfText,
      version: {
        mime_type: "application/pdf",
        storage_path:
          `users/${userId}/contracts/${contractId}` +
          `/versions/${versionId}/original.pdf`
      }
    });

    await expect(runService(context)).resolves.toMatchObject({
      extractionStatus: "completed",
      pageCount: 2
    });
    expect(extractPdfText).toHaveBeenCalledWith(validBuffer);
    expect(context.adminUpdates.at(-1)).toEqual({
      extraction_status: "completed",
      extracted_text: extractedPdfText,
      page_count: 2,
      extraction_error_safe: null
    });
  });

  it("stores and returns requires_ocr as a successful technical result", async () => {
    const extractPdfText = vi.fn<ExtractPdf>(async () => ({
      status: "requires_ocr",
      text: null,
      pageCount: 3
    }));
    const context = createHarness({
      extractPdfText,
      version: {
        mime_type: "application/pdf",
        storage_path:
          `users/${userId}/contracts/${contractId}` +
          `/versions/${versionId}/original.pdf`
      }
    });

    await expect(runService(context)).resolves.toEqual({
      contractId,
      versionId,
      extractionStatus: "requires_ocr",
      pageCount: 3,
      updatedAt
    });
    expect(context.adminUpdates.at(-1)).toEqual({
      extraction_status: "requires_ocr",
      extracted_text: null,
      page_count: 3,
      extraction_error_safe:
        "The PDF does not contain enough extractable text and requires OCR."
    });
  });

  it("dispatches DOCX by authoritative MIME and completes with page_count null", async () => {
    const extractedDocxText =
      "Kontratë DOCX me kushte dhe detyrime të përcaktuara qartë.";
    const extractDocxText = vi.fn<ExtractDocx>(async () => extractedDocxText);
    const context = createHarness({
      extractDocxText,
      version: {
        mime_type:
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        storage_path:
          `users/${userId}/contracts/${contractId}` +
          `/versions/${versionId}/original.docx`
      }
    });

    await expect(runService(context)).resolves.toMatchObject({
      contractId,
      versionId,
      extractionStatus: "completed",
      pageCount: null
    });
    expect(extractDocxText).toHaveBeenCalledWith(validBuffer);
    expect(context.adminUpdates.at(-1)).toEqual({
      extraction_status: "completed",
      extracted_text: extractedDocxText,
      page_count: null,
      extraction_error_safe: null
    });
  });

  it("marks a DOCX parser failure as failed without exposing raw details", async () => {
    const extractDocxText = vi.fn<ExtractDocx>(async () => {
      throw new ApiError(
        422,
        "PARSER_FAILED",
        "raw Mammoth detail that must not be stored"
      );
    });
    const context = createHarness({
      extractDocxText,
      version: {
        mime_type:
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        storage_path:
          `users/${userId}/contracts/${contractId}` +
          `/versions/${versionId}/original.docx`
      }
    });

    await expect(runService(context)).rejects.toMatchObject({
      code: "PARSER_FAILED",
      statusCode: 422
    });
    expect(context.adminUpdates.at(-1)).toEqual({
      extraction_status: "failed",
      extracted_text: null,
      page_count: null,
      extraction_error_safe: "The DOCX text could not be extracted safely."
    });
  });

  it("conditionally claims pending and failed versions before completing", async () => {
    for (const status of ["pending", "failed"] as const) {
      const context = createHarness({ status });

      await runService(context);

      expect(context.adminUpdates[0]).toEqual({
        extraction_status: "extracting",
        extracted_text: null,
        extraction_error_safe: null
      });
      expect(context.adminUpdates[1]).toEqual({
        extraction_status: "completed",
        extracted_text: validText,
        page_count: null,
        extraction_error_safe: null
      });
    }
  });

  it("prevents a duplicate request when the conditional claim returns no row", async () => {
    const context = createHarness({ claimMissing: true });

    await expect(runService(context)).rejects.toMatchObject({
      code: "EXTRACTION_ALREADY_RUNNING",
      statusCode: 409
    });
    expect(context.download).not.toHaveBeenCalled();
  });

  it("returns 409 for a version already extracting", async () => {
    const context = createHarness({ status: "extracting" });

    await expect(runService(context)).rejects.toMatchObject({
      code: "EXTRACTION_ALREADY_RUNNING",
      statusCode: 409
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
  });

  it("returns completed idempotently without admin access or download", async () => {
    const context = createHarness({ status: "completed" });

    await expect(runService(context)).resolves.toEqual({
      contractId,
      versionId,
      extractionStatus: "completed",
      pageCount: null,
      updatedAt
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
    expect(context.download).not.toHaveBeenCalled();
  });

  it("returns requires_ocr idempotently without another download", async () => {
    const context = createHarness({
      status: "requires_ocr",
      version: { page_count: 4 }
    });

    await expect(runService(context)).resolves.toEqual({
      contractId,
      versionId,
      extractionStatus: "requires_ocr",
      pageCount: 4,
      updatedAt
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
    expect(context.download).not.toHaveBeenCalled();
  });

  it("returns a safe terminal error for unsupported versions", async () => {
    const context = createHarness({ status: "unsupported" });

    await expect(runService(context)).rejects.toMatchObject({
      code: "UNSUPPORTED_DOCUMENT_TYPE",
      statusCode: 422
    });
    expect(context.download).not.toHaveBeenCalled();
  });

  it("stores a safe PDF parser failure with a known page count", async () => {
    const extractPdfText = vi.fn<ExtractPdf>(async () => {
      throw new ApiError(
        422,
        "PDF_PARSER_FAILED",
        `private parser output: ${validText}`,
        { pageCount: 2 }
      );
    });
    const context = createHarness({
      extractPdfText,
      version: {
        mime_type: "application/pdf",
        storage_path:
          `users/${userId}/contracts/${contractId}` +
          `/versions/${versionId}/original.pdf`
      }
    });

    await expect(runService(context)).rejects.toMatchObject({
      code: "PDF_PARSER_FAILED",
      statusCode: 422
    });
    expect(context.adminUpdates.at(-1)).toEqual({
      extraction_status: "failed",
      extracted_text: null,
      page_count: 2,
      extraction_error_safe: "The PDF text could not be extracted safely."
    });
  });

  it("verifies the downloaded size", async () => {
    const context = createHarness({
      version: { file_size_bytes: validBuffer.length + 1 }
    });

    await expect(runService(context)).rejects.toMatchObject({
      code: "FILE_SIZE_MISMATCH",
      statusCode: 422
    });
    expect(context.adminUpdates.at(-1)).toMatchObject({
      extraction_status: "failed",
      extracted_text: null,
      page_count: null
    });
  });

  it("verifies SHA-256 before extracting", async () => {
    const context = createHarness({ version: { sha256: "0".repeat(64) } });

    await expect(runService(context)).rejects.toMatchObject({
      code: "FILE_CHECKSUM_MISMATCH",
      statusCode: 422
    });
    expect(context.adminUpdates.at(-1)?.extraction_error_safe).toBe(
      "The stored contract file failed its integrity check."
    );
  });

  it.each([
    ["STORAGE_OBJECT_NOT_FOUND", 404],
    ["STORAGE_UNAVAILABLE", 503],
    ["STORAGE_DOWNLOAD_INCOMPLETE", 503]
  ])("marks Storage error %s as failed safely", async (code, statusCode) => {
    const failingContext = createHarness();
    failingContext.download.mockRejectedValue(
      new ApiError(statusCode, code, "raw private storage detail")
    );

    await expect(runService(failingContext)).rejects.toMatchObject({ code, statusCode });
    expect(failingContext.adminUpdates.at(-1)?.extraction_error_safe).not.toContain(
      "raw private"
    );
  });

  it("maps an unknown extractor failure to a safe 500 and failed status", async () => {
    const context = createHarness();
    const service = createExtractContractVersion({
      adminClient: (context.adminFrom && ({ from: context.adminFrom } as unknown as SupabaseClient)),
      createUserClient: context.createUserClient,
      extractText: () => {
        throw new Error(`private parser output: ${validText}`);
      },
      storage: context.storage
    });

    await expect(
      service({ userId, accessToken }, contractId, versionId)
    ).rejects.toMatchObject({
      code: "EXTRACTION_FAILED",
      message: "Text extraction failed safely.",
      statusCode: 500
    });
    expect(context.adminUpdates.at(-1)?.extraction_error_safe).toBe(
      "Text extraction failed safely."
    );
  });

  it("does not expose content when the final database update fails", async () => {
    const context = createHarness({ completeError: true });

    await expect(runService(context)).rejects.toMatchObject({
      code: "DATABASE_UNAVAILABLE",
      message: "The extraction status could not be saved at this time.",
      statusCode: 503
    });
    expect(JSON.stringify(context.adminUpdates)).toContain(validText);
  });
});
