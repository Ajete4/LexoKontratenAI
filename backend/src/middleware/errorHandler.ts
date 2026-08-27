import type { ErrorRequestHandler } from "express";
import { ZodError } from "zod";

import { ApiError } from "../utils/ApiError.js";

type ErrorResponse = {
  error: {
    code: string;
    message: string;
    details: unknown;
  };
};

export const errorHandler: ErrorRequestHandler = (
  error: unknown,
  _request,
  response,
  _next
) => {
  if (error instanceof ApiError) {
    const body: ErrorResponse = {
      error: {
        code: error.code,
        message: error.message,
        details: error.details
      }
    };

    response.status(error.statusCode).json(body);
    return;
  }

  if (error instanceof ZodError) {
    response.status(400).json({
      error: {
        code: "VALIDATION_ERROR",
        message: "Të dhënat e dërguara nuk janë valide.",
        details: error.issues.map((issue) => ({
          path: issue.path.join("."),
          message: issue.message
        }))
      }
    } satisfies ErrorResponse);
    return;
  }

  response.status(500).json({
    error: {
      code: "INTERNAL_SERVER_ERROR",
      message: "Ndodhi një gabim i papritur në server.",
      details: null
    }
  } satisfies ErrorResponse);
};
