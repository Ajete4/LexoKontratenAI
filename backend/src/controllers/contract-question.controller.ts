import type { RequestHandler } from "express";

import type { ContractQuestionRequest } from "../schemas/contract-question.schema.js";
import { askContractQuestion as defaultAskContractQuestion, type AskContractQuestion } from "../services/contract-question.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export function createContractQuestionController(askQuestion: AskContractQuestion = defaultAskContractQuestion): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) throw new ApiError(401, "AUTHENTICATION_REQUIRED", "Authentication is required.");
    const validated = request.validated as ContractQuestionRequest;
    const answer = await askQuestion({
      userId: request.auth.userId,
      accessToken: request.auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId,
      question: validated.body.question
    });
    response.status(200).json({ data: answer });
  });
}
