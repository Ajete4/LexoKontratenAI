import type { RequestHandler } from "express";

import {
  listLegalSources as defaultListLegalSources,
  type ListLegalSources
} from "../services/legal-sources.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export function createListLegalSourcesController(
  listLegalSources: ListLegalSources = defaultListLegalSources
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const legalSources = await listLegalSources();

    response.status(200).json({ data: { legalSources } });
  });
}
