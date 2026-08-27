import type { RequestHandler } from "express";

import {
  getDashboard as defaultGetDashboard,
  type GetDashboard
} from "../services/dashboard.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export function createDashboardController(
  getDashboard: GetDashboard = defaultGetDashboard
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const dashboard = await getDashboard({
      userId: request.auth.userId,
      accessToken: request.auth.accessToken
    });

    response.status(200).json({ data: { dashboard } });
  });
}
