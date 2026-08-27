import { createHash, randomUUID } from "node:crypto";
import type { SupabaseClient } from "@supabase/supabase-js";

import { createUserSupabaseClient } from "../config/supabase.js";
import type { AuthenticatedUser } from "../types/api.js";
import { ApiError } from "../utils/ApiError.js";
import {
  validateContractFile,
  type ValidatedContractFile
} from "./file-validation.service.js";
import {
  CONTRACT_FILES_BUCKET,
  contractFileStorage,
  type ContractFileStorage
} from "./storage.service.js";

export type ContractVersionMetadata = {
  id: string;
  contract_id: string;
  version_number: number;
  source_kind: "upload";
  original_filename: string;
  mime_type: ValidatedContractFile["mimeType"];
  file_size_bytes: number;
  sha256: string;
  extraction_status: "pending";
  created_at: string;
};

export type ContractVersionUploadResult = {
  contractId: string;
  version: {
    id: string;
    versionNumber: number;
    sourceKind: "upload";
    originalFilename: string;
    mimeType: ValidatedContractFile["mimeType"];
    fileSizeBytes: number;
    sha256: string;
    extractionStatus: "pending";
    createdAt: string;
  };
};

export type UploadContractVersion = (
  authenticatedUser: AuthenticatedUser,
  contractId: string,
  file: Express.Multer.File | undefined
) => Promise<ContractVersionUploadResult>;

export type ContractVersionServiceDependencies = {
  createUserClient?: (accessToken: string) => SupabaseClient;
  generateVersionId?: () => string;
  storage?: ContractFileStorage;
  validateFile?: (
    file: Express.Multer.File | undefined
  ) => ValidatedContractFile;
};

function databaseUnavailable(): ApiError {
  return new ApiError(
    503,
    "DATABASE_UNAVAILABLE",
    "The contract version could not be saved at this time."
  );
}

async function verifyOwnership(
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
    throw new ApiError(
      404,
      "CONTRACT_NOT_FOUND",
      "The contract was not found."
    );
  }
}

async function getNextVersionNumber(
  client: SupabaseClient,
  contractId: string
): Promise<number> {
  const { data, error } = await client
    .from("contract_versions")
    .select("version_number")
    .eq("contract_id", contractId)
    .order("version_number", { ascending: false })
    .limit(1);

  if (error) {
    throw databaseUnavailable();
  }

  const currentVersion = data?.[0]?.version_number;

  return typeof currentVersion === "number" ? currentVersion + 1 : 1;
}

async function insertContractVersion(
  client: SupabaseClient,
  version: Omit<ContractVersionMetadata, "created_at"> & {
    storage_bucket: string;
    storage_path: string;
  }
): Promise<ContractVersionMetadata> {
  const { data, error } = await client
    .from("contract_versions")
    .insert(version)
    .select(
      "id, contract_id, version_number, source_kind, original_filename, mime_type, file_size_bytes, sha256, extraction_status, created_at"
    )
    .single();

  if (error) {
    if (error.code === "23505") {
      throw new ApiError(
        409,
        "VERSION_CONFLICT",
        "A contract version was created concurrently. Please retry."
      );
    }

    throw databaseUnavailable();
  }

  if (!data) {
    throw databaseUnavailable();
  }

  return data as ContractVersionMetadata;
}

async function updateContractStatus(
  client: SupabaseClient,
  userId: string,
  contractId: string
): Promise<void> {
  const { data, error } = await client
    .from("contracts")
    .update({ status: "uploaded" })
    .eq("id", contractId)
    .eq("owner_id", userId)
    .select("id")
    .maybeSingle();

  if (error || !data) {
    throw new ApiError(
      503,
      "CONTRACT_STATUS_UPDATE_FAILED",
      "The file was stored, but the contract status could not be updated."
    );
  }
}

async function cleanupStoredFile(
  storage: ContractFileStorage,
  storagePath: string
): Promise<void> {
  try {
    await storage.remove(storagePath);
  } catch {
    console.error("Contract file cleanup failed.");
  }
}

export function createUploadContractVersion(
  dependencies: ContractVersionServiceDependencies = {}
): UploadContractVersion {
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;
  const generateVersionId = dependencies.generateVersionId ?? randomUUID;
  const storage = dependencies.storage ?? contractFileStorage;
  const validateFile = dependencies.validateFile ?? validateContractFile;

  return async (authenticatedUser, contractId, file) => {
    const client = createUserClient(authenticatedUser.accessToken);

    await verifyOwnership(client, authenticatedUser.userId, contractId);

    const validatedFile = validateFile(file);
    const versionNumber = await getNextVersionNumber(client, contractId);
    const versionId = generateVersionId();
    const sha256 = createHash("sha256")
      .update(validatedFile.buffer)
      .digest("hex");
    const storagePath =
      `users/${authenticatedUser.userId}/contracts/${contractId}` +
      `/versions/${versionId}/original${validatedFile.extension}`;

    await storage.upload({
      buffer: validatedFile.buffer,
      contentType: validatedFile.mimeType,
      path: storagePath
    });

    let version: ContractVersionMetadata;

    try {
      version = await insertContractVersion(client, {
        id: versionId,
        contract_id: contractId,
        version_number: versionNumber,
        source_kind: "upload",
        original_filename: validatedFile.originalFilename,
        storage_bucket: CONTRACT_FILES_BUCKET,
        storage_path: storagePath,
        mime_type: validatedFile.mimeType,
        file_size_bytes: validatedFile.size,
        sha256,
        extraction_status: "pending"
      });
    } catch (error) {
      await cleanupStoredFile(storage, storagePath);
      throw error;
    }

    await updateContractStatus(
      client,
      authenticatedUser.userId,
      contractId
    );

    return {
      contractId,
      version: {
        id: version.id,
        versionNumber: version.version_number,
        sourceKind: version.source_kind,
        originalFilename: version.original_filename,
        mimeType: version.mime_type,
        fileSizeBytes: version.file_size_bytes,
        sha256: version.sha256,
        extractionStatus: version.extraction_status,
        createdAt: version.created_at
      }
    };
  };
}

export const uploadContractVersion = createUploadContractVersion();
