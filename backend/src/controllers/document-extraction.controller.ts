import type { RequestHandler } from "express";

import type { ExtractDocumentParams } from "../schemas/document-extraction.schema.js";
import {
  extractContractVersion as defaultExtractContractVersion,
  type ExtractContractVersion
} from "../services/document-extraction.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

type ValidatedExtractionRequest = {
  params: ExtractDocumentParams;
};

export function createDocumentExtractionController(
  extractVersion: ExtractContractVersion = defaultExtractContractVersion
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated = request.validated as ValidatedExtractionRequest;
    const result = await extractVersion(
      request.auth,
      validated.params.contractId,
      validated.params.versionId
    );

    response.status(200).json({ data: result });
  });
}
