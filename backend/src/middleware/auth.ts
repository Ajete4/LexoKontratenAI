import type { RequestHandler } from "express";

import { supabaseAdmin } from "../config/supabase.js";
import { ApiError } from "../utils/ApiError.js";

export type AuthVerifier = (accessToken: string) => Promise<string | null>;

export const verifyAccessToken: AuthVerifier = async (accessToken) => {
  const { data, error } = await supabaseAdmin.auth.getUser(accessToken);

  if (error || !data.user) {
    return null;
  }

  return data.user.id;
};

export function createRequireAuth(
  verifyToken: AuthVerifier = verifyAccessToken
): RequestHandler {
  return async (request, _response, next) => {
    const authorization = request.header("authorization");
    const bearerMatch = authorization?.match(/^Bearer\s+(\S+)$/i);

    if (!bearerMatch?.[1]) {
      next(
        new ApiError(
          401,
          "AUTHENTICATION_REQUIRED",
          "Authentication is required."
        )
      );
      return;
    }

    const accessToken = bearerMatch[1];

    try {
      const userId = await verifyToken(accessToken);

      if (!userId) {
        next(
          new ApiError(
            401,
            "INVALID_ACCESS_TOKEN",
            "The access token is invalid or expired."
          )
        );
        return;
      }

      request.auth = {
        userId,
        accessToken
      };

      next();
    } catch {
      next(
        new ApiError(
          503,
          "AUTH_SERVICE_UNAVAILABLE",
          "Authentication service is temporarily unavailable."
        )
      );
    }
  };
}

export const requireAuth = createRequireAuth();
