import type { SupabaseClient } from "@supabase/supabase-js";

import { supabaseAdmin } from "../config/supabase.js";
import type { AllowedContractFileMimeType } from "./file-validation.service.js";
import { ApiError } from "../utils/ApiError.js";

export const CONTRACT_FILES_BUCKET = "contract-files";
export const MAX_CONTRACT_FILE_BYTES = 20 * 1024 * 1024;

export type UploadContractFileInput = {
  buffer: Buffer;
  contentType: AllowedContractFileMimeType;
  path: string;
};

export type ContractFileStorage = {
  upload: (input: UploadContractFileInput) => Promise<void>;
  download: (path: string) => Promise<Buffer>;
  remove: (path: string) => Promise<void>;
};

export function createContractFileStorage(
  adminClient: SupabaseClient = supabaseAdmin
): ContractFileStorage {
  return {
    async upload(input) {
      const { error } = await adminClient.storage
        .from(CONTRACT_FILES_BUCKET)
        .upload(input.path, input.buffer, {
          cacheControl: "3600",
          contentType: input.contentType,
          upsert: false
        });

      if (error) {
        throw new ApiError(
          503,
          "STORAGE_UNAVAILABLE",
          "The file could not be stored at this time."
        );
      }
    },

    async download(path) {
      const { data, error } = await adminClient.storage
        .from(CONTRACT_FILES_BUCKET)
        .download(path);

      if (error) {
        const statusCode = "statusCode" in error ? error.statusCode : undefined;

        if (String(statusCode) === "404") {
          throw new ApiError(
            404,
            "STORAGE_OBJECT_NOT_FOUND",
            "The stored contract file was not found."
          );
        }

        throw new ApiError(
          503,
          "STORAGE_UNAVAILABLE",
          "The stored contract file could not be downloaded at this time."
        );
      }

      if (!data) {
        throw new ApiError(
          503,
          "STORAGE_DOWNLOAD_INCOMPLETE",
          "The stored contract file could not be downloaded completely."
        );
      }

      const buffer = Buffer.from(await data.arrayBuffer());

      if (buffer.length === 0) {
        throw new ApiError(
          503,
          "STORAGE_DOWNLOAD_INCOMPLETE",
          "The stored contract file could not be downloaded completely."
        );
      }

      if (buffer.length > MAX_CONTRACT_FILE_BYTES) {
        throw new ApiError(
          413,
          "FILE_TOO_LARGE",
          "The stored contract file exceeds the allowed size."
        );
      }

      return buffer;
    },

    async remove(path) {
      const { error } = await adminClient.storage
        .from(CONTRACT_FILES_BUCKET)
        .remove([path]);

      if (error) {
        throw new ApiError(
          503,
          "STORAGE_UNAVAILABLE",
          "The stored file could not be cleaned up."
        );
      }
    }
  };
}

export const contractFileStorage = createContractFileStorage();
