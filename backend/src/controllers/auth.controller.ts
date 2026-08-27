import type { RequestHandler } from "express";

import { ApiError } from "../utils/ApiError.js";

export const getAuthenticatedUser: RequestHandler = (
  request,
  response,
  next
) => {
  if (!request.auth) {
    next(
      new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      )
    );
    return;
  }

  response.status(200).json({
    userId: request.auth.userId
  });
};
