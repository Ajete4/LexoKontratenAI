import multer from "multer";
import type { RequestHandler } from "express";

import { MAX_CONTRACT_FILE_SIZE_BYTES } from "../services/file-validation.service.js";
import { ApiError } from "../utils/ApiError.js";

type HardenedMulterLimits = NonNullable<multer.Options["limits"]> & {
  fieldNestingDepth: number;
};

const hardenedMulterLimits: HardenedMulterLimits = {
  fieldNestingDepth: 0,
  fields: 0,
  files: 1,
  fileSize: MAX_CONTRACT_FILE_SIZE_BYTES,
  // Busboy counts its initial boundary; 2 is the minimum that accepts one file.
  parts: 2
};

const contractFileUpload = multer({
  storage: multer.memoryStorage(),
  limits: hardenedMulterLimits
});

export function mapContractFileUploadError(error: unknown): ApiError {
  if (error instanceof multer.MulterError) {
    const errorCode: string = error.code;

    if (errorCode === "LIMIT_FILE_SIZE") {
      return new ApiError(
        413,
        "FILE_TOO_LARGE",
        "The file must not exceed 20 MB."
      );
    }

    if (errorCode === "LIMIT_FILE_COUNT") {
      return new ApiError(
        400,
        "MULTIPLE_FILES_NOT_ALLOWED",
        "Exactly one file must be uploaded in the file field."
      );
    }

    if (errorCode === "LIMIT_UNEXPECTED_FILE") {
      const isAdditionalFile = error.field === "file";

      return new ApiError(
        400,
        isAdditionalFile
          ? "MULTIPLE_FILES_NOT_ALLOWED"
          : "UNEXPECTED_MULTIPART_FIELD",
        isAdditionalFile
          ? "Exactly one file must be uploaded in the file field."
          : "Only the file field is allowed."
      );
    }

    if (
      errorCode === "LIMIT_FIELD_COUNT" ||
      errorCode === "LIMIT_FIELD_KEY" ||
      errorCode === "LIMIT_FIELD_VALUE" ||
      errorCode === "LIMIT_FIELD_NESTING" ||
      errorCode === "MISSING_FIELD_NAME"
    ) {
      return new ApiError(
        400,
        "UNEXPECTED_MULTIPART_FIELD",
        "Multipart text fields are not allowed."
      );
    }

    if (errorCode === "LIMIT_PART_COUNT") {
      return new ApiError(
        400,
        "MULTIPART_PART_LIMIT_EXCEEDED",
        "The multipart request must contain exactly one file part."
      );
    }

    return new ApiError(
      400,
      "INVALID_MULTIPART_REQUEST",
      "The multipart request is not valid."
    );
  }

  return new ApiError(
    400,
    "INVALID_MULTIPART_REQUEST",
    "The multipart request is not valid."
  );
}

export const uploadSingleContractFile: RequestHandler = (
  request,
  response,
  next
) => {
  contractFileUpload.single("file")(request, response, (error) => {
    if (error) {
      next(mapContractFileUploadError(error));
      return;
    }

    next();
  });
};
