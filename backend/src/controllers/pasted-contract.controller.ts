import type { RequestHandler } from "express";

import type { CreatePastedContractInput } from "../schemas/pasted-contract.schema.js";
import {
  createPastedContract as defaultCreatePastedContract,
  type CreatePastedContract
} from "../services/pasted-contract.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

type ValidatedCreatePastedContractRequest = {
  body: CreatePastedContractInput;
};

export function createPastedContractController(
  createPastedContract: CreatePastedContract = defaultCreatePastedContract
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated = request.validated as ValidatedCreatePastedContractRequest;
    const result = await createPastedContract(request.auth, validated.body);

    response.status(201).json({ data: result });
  });
}
