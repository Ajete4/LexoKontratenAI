import type { RequestHandler } from "express";
import type { ZodType } from "zod";

import { ApiError } from "../utils/ApiError.js";

export function validate(schema: ZodType): RequestHandler {
  return (request, _response, next) => {
    const result = schema.safeParse({
      body: request.body,
      params: request.params,
      query: request.query
    });

    if (!result.success) {
      next(
        new ApiError(
          400,
          "VALIDATION_ERROR",
          "Të dhënat e dërguara nuk janë valide.",
          result.error.issues.map((issue) => ({
            path: issue.path.join("."),
            message: issue.message
          }))
        )
      );
      return;
    }

    request.validated = result.data;
    next();
  };
}
