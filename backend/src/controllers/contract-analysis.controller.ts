import type { RequestHandler } from "express";

import type {
  AnalyzeContractParams,
  GetContractAnalysisParams,
  GetLatestContractAnalysisParams
} from "../schemas/contract-analysis.schema.js";
import {
  getContractAnalysis as defaultGetContractAnalysis,
  getLatestAnalysis as defaultGetLatestAnalysis,
  getLatestContractAnalysis as defaultGetLatestContractAnalysis,
  type GetContractAnalysis,
  type GetLatestAnalysis,
  type GetLatestContractAnalysis
} from "../services/analysis-retrieval.service.js";
import {
  analyzeContractVersion as defaultAnalyzeContractVersion,
  type AnalyzeContractVersion
} from "../services/contract-analysis.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

type ValidatedContractAnalysisRequest = {
  params: AnalyzeContractParams;
};

type ValidatedGetContractAnalysisRequest = {
  params: GetContractAnalysisParams;
};

type ValidatedGetLatestContractAnalysisRequest = {
  params: GetLatestContractAnalysisParams;
};

function requireRequestAuth(request: Parameters<RequestHandler>[0]) {
  if (!request.auth) {
    throw new ApiError(
      401,
      "AUTHENTICATION_REQUIRED",
      "Authentication is required."
    );
  }

  return request.auth;
}

export function createContractAnalysisController(
  analyzeVersion: AnalyzeContractVersion = defaultAnalyzeContractVersion
): RequestHandler {
  return asyncHandler(async (request, response) => {
    const auth = requireRequestAuth(request);

    const validated = request.validated as ValidatedContractAnalysisRequest;
    const analysis = await analyzeVersion({
      userId: auth.userId,
      accessToken: auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId
    });

    response.status(200).json({
      data: {
        analysis
      }
    });
  });
}

export function createGetContractAnalysisController(
  getAnalysis: GetContractAnalysis = defaultGetContractAnalysis
): RequestHandler {
  return asyncHandler(async (request, response) => {
    const auth = requireRequestAuth(request);
    const validated =
      request.validated as ValidatedGetContractAnalysisRequest;
    const analysis = await getAnalysis({
      userId: auth.userId,
      accessToken: auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId
    });

    response.status(200).json({ data: { analysis } });
  });
}

export function createGetLatestAnalysisController(
  getAnalysis: GetLatestAnalysis = defaultGetLatestAnalysis
): RequestHandler {
  return asyncHandler(async (request, response) => {
    const auth = requireRequestAuth(request);
    const analysis = await getAnalysis({
      userId: auth.userId,
      accessToken: auth.accessToken
    });

    response.status(200).json({ data: { analysis } });
  });
}

export function createGetLatestContractAnalysisController(
  getAnalysis: GetLatestContractAnalysis = defaultGetLatestContractAnalysis
): RequestHandler {
  return asyncHandler(async (request, response) => {
    const auth = requireRequestAuth(request);
    const validated =
      request.validated as ValidatedGetLatestContractAnalysisRequest;
    const analysis = await getAnalysis({
      userId: auth.userId,
      accessToken: auth.accessToken,
      contractId: validated.params.contractId
    });

    response.status(200).json({ data: { analysis } });
  });
}
