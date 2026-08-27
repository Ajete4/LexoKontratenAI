import type { RequestHandler } from "express";

import type { UploadContractVersionParams } from "../schemas/contract-versions.schema.js";
import {
  uploadContractVersion as defaultUploadContractVersion,
  type UploadContractVersion
} from "../services/contract-versions.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

type ValidatedUploadContractVersionRequest = {
  params: UploadContractVersionParams;
};

export function createUploadContractVersionController(
  uploadVersion: UploadContractVersion = defaultUploadContractVersion
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated =
      request.validated as ValidatedUploadContractVersionRequest;
    const result = await uploadVersion(
      request.auth,
      validated.params.contractId,
      request.file
    );

    response.status(201).json({ data: result });
  });
}
