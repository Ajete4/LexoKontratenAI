import type { RequestHandler } from "express";

import {
  listRecentQuestions as defaultListRecentQuestions,
  type ListRecentQuestions
} from "../services/question-history.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export function createQuestionHistoryController(
  listQuestions: ListRecentQuestions = defaultListRecentQuestions
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const history = await listQuestions({
      userId: request.auth.userId,
      accessToken: request.auth.accessToken
    });

    response.status(200).json({ data: history });
  });
}
