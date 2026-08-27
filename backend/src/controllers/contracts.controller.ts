import type { RequestHandler } from "express";

import type {
  CreateContractInput,
  ListContractsQuery
} from "../schemas/contracts.schema.js";
import {
  createContract as defaultCreateContract,
  listContracts as defaultListContracts,
  type CreateContract,
  type ListContracts
} from "../services/contracts.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

type ValidatedContractsRequest = {
  query: ListContractsQuery;
};

type ValidatedCreateContractRequest = {
  body: CreateContractInput;
};

export function createListContractsController(
  getContracts: ListContracts = defaultListContracts
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated = request.validated as ValidatedContractsRequest;
    const contracts = await getContracts(request.auth, validated.query);

    response.status(200).json({
      data: {
        contracts
      },
      meta: {
        limit: validated.query.limit,
        count: contracts.length
      }
    });
  });
}

export function createContractController(
  createContract: CreateContract = defaultCreateContract
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated = request.validated as ValidatedCreateContractRequest;
    const contract = await createContract(request.auth, validated.body);

    response.status(201).json({
      data: {
        contract
      }
    });
  });
}
