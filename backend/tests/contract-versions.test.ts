import { createHash } from "node:crypto";
import type { SupabaseClient } from "@supabase/supabase-js";
import multer from "multer";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import { mapContractFileUploadError } from "../src/middleware/contract-file-upload.js";
import {
  createUploadContractVersion,
  type ContractVersionMetadata,
  type UploadContractVersion
} from "../src/services/contract-versions.service.js";
import {
  validateContractFile,
  type ValidatedContractFile
} from "../src/services/file-validation.service.js";
import type { ContractFileStorage } from "../src/services/storage.service.js";
import { ApiError } from "../src/utils/ApiError.js";
import { createMinimalDocxBuffer } from "./fixtures/docx.js";

const authenticatedMiddleware = createRequireAuth(async () => "user-a");
const contractId = "11111111-1111-4111-8111-111111111111";
const versionId = "22222222-2222-4222-8222-222222222222";
const createdAt = "2026-08-09T10:00:00.000Z";
const pdfBuffer = Buffer.from("%PDF-1.7\ncontract");

const validatedPdf: ValidatedContractFile = {
  buffer: pdfBuffer,
  extension: ".pdf",
  mimeType: "application/pdf",
  originalFilename: "contract.pdf",
  size: pdfBuffer.length
};

const responseResult = {
  contractId,
  version: {
    id: versionId,
    versionNumber: 1,
    sourceKind: "upload" as const,
    originalFilename: "contract.pdf",
    mimeType: "application/pdf" as const,
    fileSizeBytes: pdfBuffer.length,
    sha256: createHash("sha256").update(pdfBuffer).digest("hex"),
    extractionStatus: "pending" as const,
    createdAt
  }
};

type DatabaseScenario = {
  currentVersion?: number;
  insertErrorCode?: string;
  insertMissingData?: boolean;
  ownershipError?: boolean;
  owned?: boolean;
  statusUpdateFails?: boolean;
  versionLookupError?: boolean;
};

function createDatabaseHarness(scenario: DatabaseScenario = {}) {
  const events: string[] = [];
  const ownershipEq = vi.fn(() => ownershipBuilder);
  const ownershipBuilder = {
    eq: ownershipEq,
    maybeSingle: vi.fn(async () => {
      events.push("ownership");
      return {
        data: scenario.owned === false ? null : { id: contractId },
        error: scenario.ownershipError ? { message: "private detail" } : null
      };
    })
  };
  const updateEq = vi.fn(() => updateBuilder);
  const updateBuilder = {
    eq: updateEq,
    select: vi.fn(() => ({
      maybeSingle: vi.fn(async () => {
        events.push("status-update");
        return scenario.statusUpdateFails
          ? { data: null, error: { message: "private detail" } }
          : { data: { id: contractId }, error: null };
      })
    }))
  };
  const update = vi.fn(() => updateBuilder);
  const insertedRows: Array<Record<string, unknown>> = [];
  const insert = vi.fn((row: Record<string, unknown>) => {
    insertedRows.push(row);

    return {
      select: vi.fn(() => ({
        single: vi.fn(async () => {
          events.push("version-insert");

          if (scenario.insertErrorCode) {
            return {
              data: null,
              error: {
                code: scenario.insertErrorCode,
                message: "private detail"
              }
            };
          }

          if (scenario.insertMissingData) {
            return { data: null, error: null };
          }

          return {
            data: {
              ...row,
              created_at: createdAt
            } as ContractVersionMetadata,
            error: null
          };
        })
      }))
    };
  });
  const versionSelect = vi.fn(() => ({
    eq: vi.fn(() => ({
      order: vi.fn(() => ({
        limit: vi.fn(async () => {
          events.push("version-lookup");
          return {
            data:
              scenario.currentVersion === undefined
                ? []
                : [{ version_number: scenario.currentVersion }],
            error: scenario.versionLookupError
              ? { message: "private detail" }
              : null
          };
        })
      }))
    }))
  }));
  const from = vi.fn((table: string) => {
    if (table === "contracts") {
      return {
        select: vi.fn(() => ownershipBuilder),
        update
      };
    }

    return {
      insert,
      select: versionSelect
    };
  });

  return {
    client: { from } as unknown as SupabaseClient,
    events,
    from,
    insert,
    insertedRows,
    ownershipEq,
    update
  };
}

function createStorageHarness(options: { removeFails?: boolean } = {}) {
  const events: string[] = [];
  const upload = vi.fn(async () => {
    events.push("storage-upload");
  });
  const remove = vi.fn(async () => {
    events.push("storage-remove");

    if (options.removeFails) {
      throw new Error("private cleanup detail");
    }
  });
  const download = vi.fn(async () => Buffer.from("unused"));

  return {
    events,
    storage: { upload, download, remove } satisfies ContractFileStorage,
    download,
    upload,
    remove
  };
}

function createUploadService(
  databaseScenario: DatabaseScenario = {},
  storageOptions: { removeFails?: boolean } = {}
) {
  const database = createDatabaseHarness(databaseScenario);
  const storage = createStorageHarness(storageOptions);
  const createUserClient = vi.fn(() => database.client);
  const service = createUploadContractVersion({
    createUserClient,
    generateVersionId: () => versionId,
    storage: storage.storage,
    validateFile: () => validatedPdf
  });

  return { createUserClient, database, service, storage };
}

describe("POST /api/contracts/:contractId/versions", () => {
  it("requires authentication", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const response = await request(createApp({ uploadContractVersion }))
      .post(`/api/contracts/${contractId}/versions`)
      .attach("file", pdfBuffer, {
        filename: "contract.pdf",
        contentType: "application/pdf"
      });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("rejects an invalid contract ID before processing the file", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post("/api/contracts/not-a-uuid/versions")
      .set("Authorization", "Bearer valid-test-value")
      .attach("file", pdfBuffer, {
        filename: "contract.pdf",
        contentType: "application/pdf"
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("rejects a missing file", async () => {
    const uploadContractVersion: UploadContractVersion = async (
      _authenticatedUser,
      _contractId,
      file
    ) => {
      validateContractFile(file);
      return responseResult;
    };
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("FILE_REQUIRED");
  });

  it("rejects multiple files", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value")
      .attach("file", pdfBuffer, {
        filename: "one.pdf",
        contentType: "application/pdf"
      })
      .attach("file", pdfBuffer, {
        filename: "two.pdf",
        contentType: "application/pdf"
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("MULTIPLE_FILES_NOT_ALLOWED");
    expect(response.body.error.details).toBeNull();
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("rejects unexpected multipart text fields", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value")
      .field("title", "untrusted text field")
      .attach("file", pdfBuffer, {
        filename: "contract.pdf",
        contentType: "application/pdf"
      });

    expect(response.status).toBe(400);
    expect(response.body.error).toEqual({
      code: "UNEXPECTED_MULTIPART_FIELD",
      message: "Multipart text fields are not allowed.",
      details: null
    });
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("rejects nested multipart field names safely", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value")
      .field("metadata[owner][id]", "untrusted-value")
      .attach("file", pdfBuffer, {
        filename: "contract.pdf",
        contentType: "application/pdf"
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("UNEXPECTED_MULTIPART_FIELD");
    expect(response.body.error.details).toBeNull();
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("rejects requests containing more than one multipart part", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value")
      .attach("file", pdfBuffer, {
        filename: "contract.pdf",
        contentType: "application/pdf"
      })
      .field("extra", "second-part");

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("UNEXPECTED_MULTIPART_FIELD");
    expect(response.body.error.details).toBeNull();
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("handles malformed multipart input without crashing or exposing internals", async () => {
    const uploadContractVersion = vi.fn<UploadContractVersion>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value")
      .set("Content-Type", "multipart/form-data; boundary=broken-boundary")
      .send("--broken-boundary\r\nContent-Disposition: form-data");

    expect(response.status).toBe(400);
    expect(response.body).toEqual({
      error: {
        code: "INVALID_MULTIPART_REQUEST",
        message: "The multipart request is not valid.",
        details: null
      }
    });
    expect(uploadContractVersion).not.toHaveBeenCalled();
  });

  it("maps Multer size limits without allocating a 20 MB fixture", () => {
    const error = new multer.MulterError("LIMIT_FILE_SIZE");

    expect(mapContractFileUploadError(error)).toMatchObject({
      code: "FILE_TOO_LARGE",
      statusCode: 413
    });
  });

  it("maps the multipart part limit to a safe response", () => {
    const error = new multer.MulterError("LIMIT_PART_COUNT");

    expect(mapContractFileUploadError(error)).toMatchObject({
      code: "MULTIPART_PART_LIMIT_EXCEEDED",
      message: "The multipart request must contain exactly one file part.",
      statusCode: 400
    });
  });

  it.each([
    [pdfBuffer, "contract.pdf", "application/pdf"],
    [
      createMinimalDocxBuffer(),
      "contract.docx",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ],
    [Buffer.from("Kontratë testuese"), "contract.txt", "text/plain"]
  ])("accepts one valid file and returns 201", async (buffer, filename, contentType) => {
    const uploadContractVersion: UploadContractVersion = async (
      _authenticatedUser,
      _contractId,
      file
    ) => {
      validateContractFile(file);
      return responseResult;
    };
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      uploadContractVersion
    });
    const response = await request(app)
      .post(`/api/contracts/${contractId}/versions`)
      .set("Authorization", "Bearer valid-test-value")
      .attach("file", buffer, { filename, contentType });

    expect(response.status).toBe(201);
    expect(response.body).toEqual({ data: responseResult });
  });
});

describe("contract version upload service", () => {
  it("checks user ownership before Storage and uses the user-scoped client", async () => {
    const context = createUploadService();

    await context.service(
      { userId: "user-a", accessToken: "verified-test-value" },
      contractId,
      undefined
    );

    expect(context.createUserClient).toHaveBeenCalledWith("verified-test-value");
    expect(context.database.ownershipEq).toHaveBeenCalledWith("id", contractId);
    expect(context.database.ownershipEq).toHaveBeenCalledWith("owner_id", "user-a");
    expect(context.database.events[0]).toBe("ownership");
    expect(context.storage.upload).toHaveBeenCalledTimes(1);
  });

  it("returns the same 404 when the contract is unavailable through RLS", async () => {
    const context = createUploadService({ owned: false });

    await expect(
      context.service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({ code: "CONTRACT_NOT_FOUND", statusCode: 404 });
    expect(context.storage.upload).not.toHaveBeenCalled();
    expect(context.database.insert).not.toHaveBeenCalled();
  });

  it("does not write to Storage when validation fails", async () => {
    const database = createDatabaseHarness();
    const storage = createStorageHarness();
    const service = createUploadContractVersion({
      createUserClient: () => database.client,
      storage: storage.storage,
      validateFile: () => {
        throw new ApiError(415, "UNSUPPORTED_FILE_TYPE", "Unsupported file.");
      }
    });

    await expect(
      service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({ code: "UNSUPPORTED_FILE_TYPE" });
    expect(database.events[0]).toBe("ownership");
    expect(storage.upload).not.toHaveBeenCalled();
  });

  it("stops before database insertion when Storage is unavailable", async () => {
    const database = createDatabaseHarness();
    const storage: ContractFileStorage = {
      upload: vi.fn(async () => {
        throw new ApiError(503, "STORAGE_UNAVAILABLE", "Storage unavailable.");
      }),
      download: vi.fn(),
      remove: vi.fn()
    };
    const service = createUploadContractVersion({
      createUserClient: () => database.client,
      generateVersionId: () => versionId,
      storage,
      validateFile: () => validatedPdf
    });

    await expect(
      service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({ code: "STORAGE_UNAVAILABLE", statusCode: 503 });
    expect(database.insert).not.toHaveBeenCalled();
  });

  it("computes SHA-256, generates the path, inserts pending metadata, and updates status", async () => {
    const context = createUploadService({ currentVersion: 2 });
    const expectedPath =
      `users/user-a/contracts/${contractId}/versions/${versionId}/original.pdf`;

    const result = await context.service(
      { userId: "user-a", accessToken: "verified-test-value" },
      contractId,
      undefined
    );

    expect(context.storage.upload).toHaveBeenCalledWith({
      buffer: pdfBuffer,
      contentType: "application/pdf",
      path: expectedPath
    });
    expect(expectedPath).not.toContain("contract.pdf");
    expect(context.database.insertedRows).toEqual([
      {
        id: versionId,
        contract_id: contractId,
        version_number: 3,
        source_kind: "upload",
        original_filename: "contract.pdf",
        storage_bucket: "contract-files",
        storage_path: expectedPath,
        mime_type: "application/pdf",
        file_size_bytes: pdfBuffer.length,
        sha256: createHash("sha256").update(pdfBuffer).digest("hex"),
        extraction_status: "pending"
      }
    ]);
    expect(context.database.update).toHaveBeenCalledWith({ status: "uploaded" });
    expect(result.version.versionNumber).toBe(3);
    expect(result.version.sha256).toMatch(/^[0-9a-f]{64}$/);
  });

  it("removes the stored object when version insertion fails", async () => {
    const context = createUploadService({ insertMissingData: true });

    await expect(
      context.service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({ code: "DATABASE_UNAVAILABLE", statusCode: 503 });
    expect(context.storage.remove).toHaveBeenCalledTimes(1);
  });

  it("returns 409 and cleans up after a version-number conflict", async () => {
    const context = createUploadService({ insertErrorCode: "23505" });

    await expect(
      context.service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({ code: "VERSION_CONFLICT", statusCode: 409 });
    expect(context.storage.remove).toHaveBeenCalledTimes(1);
  });

  it("does not expose cleanup internals when cleanup also fails", async () => {
    const consoleError = vi.spyOn(console, "error").mockImplementation(() => undefined);
    const context = createUploadService(
      { insertMissingData: true },
      { removeFails: true }
    );

    await expect(
      context.service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({
      code: "DATABASE_UNAVAILABLE",
      message: "The contract version could not be saved at this time."
    });
    expect(consoleError).toHaveBeenCalledWith("Contract file cleanup failed.");
    consoleError.mockRestore();
  });

  it("preserves the valid file and version after a status-update partial failure", async () => {
    const context = createUploadService({ statusUpdateFails: true });

    await expect(
      context.service(
        { userId: "user-a", accessToken: "verified-test-value" },
        contractId,
        undefined
      )
    ).rejects.toMatchObject({
      code: "CONTRACT_STATUS_UPDATE_FAILED",
      statusCode: 503
    });
    expect(context.database.insert).toHaveBeenCalledTimes(1);
    expect(context.storage.remove).not.toHaveBeenCalled();
  });
});
