import type { RequestHandler } from "express";

import type { ClauseRewriteRequest } from "../schemas/clause-rewrite.schema.js";
import {
  rewriteAnalyzedClause as defaultRewriteAnalyzedClause,
  type RewriteAnalyzedClause
} from "../services/clause-rewrite.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export function createClauseRewriteController(
  rewriteClause: RewriteAnalyzedClause = defaultRewriteAnalyzedClause
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated = request.validated as ClauseRewriteRequest;
    const result = await rewriteClause({
      userId: request.auth.userId,
      accessToken: request.auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId,
      position: validated.params.position,
      goal: validated.body.goal
    });

    response.status(200).json({ data: result });
  });
}

