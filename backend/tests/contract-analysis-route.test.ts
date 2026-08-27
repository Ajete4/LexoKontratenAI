import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { CONTRACT_ANALYSIS_DISCLAIMER } from "../src/ai/contract-analysis.schema.js";
import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import type {
  AnalyzeContractVersion,
  ContractAnalysisResponse
} from "../src/services/contract-analysis.service.js";
import type { CreateContract, ListContracts } from "../src/services/contracts.service.js";
import type { UploadContractVersion } from "../src/services/contract-versions.service.js";
import type { ExtractContractVersion } from "../src/services/document-extraction.service.js";
import { ApiError } from "../src/utils/ApiError.js";
import type {
  GetContractAnalysis,
  GetLatestAnalysis,
  GetLatestContractAnalysis
} from "../src/services/analysis-retrieval.service.js";

const userId = "authenticated-user";
const accessToken = "verified-placeholder-token";
const contractId = "11111111-1111-4111-8111-111111111111";
const versionId = "22222222-2222-4222-8222-222222222222";
const analysisId = "33333333-3333-4333-8333-333333333333";
const timestamp = "2026-08-10T12:00:00.000Z";

function createAnalysisResponse(): ContractAnalysisResponse {
  return {
    analysisId,
    contractId,
    versionId,
    status: "completed" as const,
    result: {
      language: "sq" as const,
      contractType: "lease" as const,
      title: "Kontratë qiraje",
      summary: "Përmbledhje informative.",
      parties: [],
      keyDates: [],
      paymentTerms: [],
      terminationTerms: [],
      overallRiskLevel: "medium" as const,
      overallRiskExplanation: "Disa kushte kërkojnë shqyrtim.",
      missingInformation: [],
      professionalReviewRecommended: true,
      disclaimer: CONTRACT_ANALYSIS_DISCLAIMER
    },
    clauses: [],
    createdAt: timestamp,
    completedAt: timestamp
  };
}

function createHarness(
  analyzeVersion: AnalyzeContractVersion = vi.fn(async () =>
    createAnalysisResponse()
  )
) {
  const verifyToken = vi.fn(async (token: string) =>
    token === accessToken ? userId : null
  );
  const authMiddleware = createRequireAuth(verifyToken);
  const app = createApp({
    authMiddleware,
    analyzeContractVersion: analyzeVersion
  });

  return { analyzeVersion, app, verifyToken };
}

function analyzeRequest(app: ReturnType<typeof createApp>) {
  return request(app)
    .post(`/api/contracts/${contractId}/versions/${versionId}/analyze`)
    .set("Authorization", `Bearer ${accessToken}`);
}

describe("POST /api/contracts/:contractId/versions/:versionId/analyze", () => {
  it("requires a well-formed and valid Bearer token", async () => {
    const context = createHarness();

    const missing = await request(context.app).post(
      `/api/contracts/${contractId}/versions/${versionId}/analyze`
    );
    const malformed = await request(context.app)
      .post(`/api/contracts/${contractId}/versions/${versionId}/analyze`)
      .set("Authorization", "Basic invalid");
    const invalid = await request(context.app)
      .post(`/api/contracts/${contractId}/versions/${versionId}/analyze`)
      .set("Authorization", "Bearer invalid-placeholder");

    expect(missing.status).toBe(401);
    expect(malformed.status).toBe(401);
    expect(invalid.status).toBe(401);
    expect(context.analyzeVersion).not.toHaveBeenCalled();
  });

  it.each([
    ["invalid-contract", versionId],
    [contractId, "invalid-version"]
  ])("validates both UUID path parameters", async (invalidContract, invalidVersion) => {
    const context = createHarness();
    const response = await request(context.app)
      .post(`/api/contracts/${invalidContract}/versions/${invalidVersion}/analyze`)
      .set("Authorization", `Bearer ${accessToken}`)
      .send({});

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(context.analyzeVersion).not.toHaveBeenCalled();
  });

  it.each([
    { userId: "untrusted" },
    { extractedText: "untrusted text" },
    { model: "untrusted", status: "completed", risk: "low" },
    { ownerId: "untrusted", requestedBy: "untrusted", clauses: [] }
  ])("rejects every non-empty body", async (body) => {
    const context = createHarness();
    const response = await analyzeRequest(context.app).send(body);

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(context.analyzeVersion).not.toHaveBeenCalled();
  });

  it("passes only verified identity and validated params to the service", async () => {
    const context = createHarness();
    const response = await analyzeRequest(context.app).send({});

    expect(response.status).toBe(200);
    expect(context.analyzeVersion).toHaveBeenCalledWith({
      userId,
      accessToken,
      contractId,
      versionId
    });
  });

  it("accepts an absent body normalized by the existing infrastructure", async () => {
    const context = createHarness();
    const response = await analyzeRequest(context.app);

    expect(response.status).toBe(200);
    expect(context.analyzeVersion).toHaveBeenCalledTimes(1);
  });

  it("returns the safe service response under data.analysis", async () => {
    const analysis = createAnalysisResponse();
    const analyzeVersion = vi.fn<AnalyzeContractVersion>(async () => analysis);
    const context = createHarness(analyzeVersion);

    const response = await analyzeRequest(context.app).send({});

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ data: { analysis } });
    const serialized = JSON.stringify(response.body);
    expect(serialized).not.toContain(accessToken);
    expect(serialized).not.toContain("extractedText");
    expect(serialized).not.toContain("prompt");
    expect(serialized).not.toContain("raw_output");
    expect(serialized).not.toContain("status_history");
    expect(serialized).not.toContain("error_message_safe");
    expect(serialized).not.toContain("storage_path");
  });

  it("uses HTTP 200 for an idempotently completed result", async () => {
    const context = createHarness();

    const first = await analyzeRequest(context.app).send({});
    const second = await analyzeRequest(context.app).send({});

    expect(first.status).toBe(200);
    expect(second.status).toBe(200);
  });

  it.each([
    [404, "VERSION_NOT_FOUND"],
    [422, "EXTRACTION_NOT_COMPLETED"],
    [422, "EXTRACTED_TEXT_MISSING"],
    [409, "ANALYSIS_ALREADY_RUNNING"],
    [413, "ANALYSIS_INPUT_TOO_LARGE"],
    [422, "AI_REFUSED"],
    [429, "AI_RATE_LIMITED"],
    [504, "AI_TIMEOUT"],
    [503, "AI_UNAVAILABLE"],
    [502, "AI_OUTPUT_INVALID"],
    [503, "AI_CONFIGURATION_MISSING"],
    [503, "DATABASE_UNAVAILABLE"],
    [503, "ANALYSIS_PERSISTENCE_FAILED"]
  ])("preserves safe service error %s %s", async (statusCode, code) => {
    const analyzeVersion = vi.fn<AnalyzeContractVersion>(async () => {
      throw new ApiError(statusCode, code, "Safe public message.");
    });
    const context = createHarness(analyzeVersion);

    const response = await analyzeRequest(context.app).send({});

    expect(response.status).toBe(statusCode);
    expect(response.body).toEqual({
      error: {
        code,
        message: "Safe public message.",
        details: null
      }
    });
  });
});

function createRetrievalHarness(options: {
  getContractAnalysis?: GetContractAnalysis;
  getLatestAnalysis?: GetLatestAnalysis;
  getLatestContractAnalysis?: GetLatestContractAnalysis;
} = {}) {
  const verifyToken = vi.fn(async (token: string) =>
    token === accessToken ? userId : null
  );
  const getContractAnalysis =
    options.getContractAnalysis ??
    vi.fn<GetContractAnalysis>(async () => createAnalysisResponse());
  const getLatestAnalysis =
    options.getLatestAnalysis ??
    vi.fn<GetLatestAnalysis>(async () => createAnalysisResponse());
  const getLatestContractAnalysis =
    options.getLatestContractAnalysis ??
    vi.fn<GetLatestContractAnalysis>(async () => createAnalysisResponse());
  const app = createApp({
    authMiddleware: createRequireAuth(verifyToken),
    getContractAnalysis,
    getLatestAnalysis,
    getLatestContractAnalysis
  });

  return {
    app,
    getContractAnalysis,
    getLatestAnalysis,
    getLatestContractAnalysis,
    verifyToken
  };
}

describe("GET completed analysis retrieval", () => {
  it("requires authentication for detail, latest, and contract latest", async () => {
    const context = createRetrievalHarness();

    const detail = await request(context.app).get(
      `/api/contracts/${contractId}/versions/${versionId}/analysis`
    );
    const latest = await request(context.app).get("/api/analyses/latest");
    const contractLatest = await request(context.app).get(
      `/api/contracts/${contractId}/analysis/latest`
    );

    expect(detail.status).toBe(401);
    expect(latest.status).toBe(401);
    expect(contractLatest.status).toBe(401);
    expect(context.getContractAnalysis).not.toHaveBeenCalled();
    expect(context.getLatestAnalysis).not.toHaveBeenCalled();
    expect(context.getLatestContractAnalysis).not.toHaveBeenCalled();
  });

  it.each([
    ["invalid-contract", versionId],
    [contractId, "invalid-version"]
  ])("validates detail UUID parameters", async (invalidContract, invalidVersion) => {
    const context = createRetrievalHarness();
    const response = await request(context.app)
      .get(
        `/api/contracts/${invalidContract}/versions/${invalidVersion}/analysis`
      )
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(context.getContractAnalysis).not.toHaveBeenCalled();
  });

  it("passes only authenticated identity and validated IDs to detail", async () => {
    const context = createRetrievalHarness();
    const response = await request(context.app)
      .get(`/api/contracts/${contractId}/versions/${versionId}/analysis`)
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(context.getContractAnalysis).toHaveBeenCalledWith({
      userId,
      accessToken,
      contractId,
      versionId
    });
    expect(response.body).toEqual({
      data: { analysis: createAnalysisResponse() }
    });
  });

  it("passes only authenticated identity to latest", async () => {
    const context = createRetrievalHarness();
    const response = await request(context.app)
      .get("/api/analyses/latest")
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(context.getLatestAnalysis).toHaveBeenCalledWith({
      userId,
      accessToken
    });
    expect(response.body).toEqual({
      data: { analysis: createAnalysisResponse() }
    });
  });

  it("validates the contract UUID for contract latest", async () => {
    const context = createRetrievalHarness();
    const response = await request(context.app)
      .get("/api/contracts/invalid-contract/analysis/latest")
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(context.getLatestContractAnalysis).not.toHaveBeenCalled();
  });

  it("passes only authenticated identity and contractId to contract latest", async () => {
    const context = createRetrievalHarness();
    const response = await request(context.app)
      .get(`/api/contracts/${contractId}/analysis/latest`)
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(context.getLatestContractAnalysis).toHaveBeenCalledWith({
      userId,
      accessToken,
      contractId
    });
    expect(response.body).toEqual({
      data: { analysis: createAnalysisResponse() }
    });
  });

  it.each(["detail", "latest", "contract-latest"] as const)(
    "returns ANALYSIS_NOT_FOUND safely for %s",
    async (endpoint) => {
      const notFound = new ApiError(
        404,
        "ANALYSIS_NOT_FOUND",
        "A completed contract analysis was not found."
      );
      const context = createRetrievalHarness({
        getContractAnalysis: vi.fn(async () => {
          throw notFound;
        }),
        getLatestAnalysis: vi.fn(async () => {
          throw notFound;
        }),
        getLatestContractAnalysis: vi.fn(async () => {
          throw notFound;
        })
      });
      const path =
        endpoint === "detail"
          ? `/api/contracts/${contractId}/versions/${versionId}/analysis`
          : endpoint === "latest"
            ? "/api/analyses/latest"
            : `/api/contracts/${contractId}/analysis/latest`;
      const response = await request(context.app)
        .get(path)
        .set("Authorization", `Bearer ${accessToken}`);

      expect(response.status).toBe(404);
      expect(response.body.error).toEqual({
        code: "ANALYSIS_NOT_FOUND",
        message: "A completed contract analysis was not found.",
        details: null
      });
    }
  );

  it("does not expose document, status-history, or Storage internals", async () => {
    const context = createRetrievalHarness();
    const response = await request(context.app)
      .get(`/api/contracts/${contractId}/versions/${versionId}/analysis`)
      .set("Authorization", `Bearer ${accessToken}`);
    const serialized = JSON.stringify(response.body);

    expect(serialized).not.toContain("extracted_text");
    expect(serialized).not.toContain("status_history");
    expect(serialized).not.toContain("storage_bucket");
    expect(serialized).not.toContain("storage_path");
  });
});

describe("analysis route compatibility", () => {
  it("keeps health and existing contract routes registered", async () => {
    const authMiddleware = createRequireAuth(async () => userId);
    const getContracts = vi.fn<ListContracts>(async () => []);
    const createContract = vi.fn<CreateContract>(async () => ({
      id: contractId,
      owner_id: userId,
      title: "Kontratë",
      contract_type: "service",
      status: "draft",
      created_at: timestamp,
      updated_at: timestamp
    }));
    const uploadContractVersion = vi.fn<UploadContractVersion>(async () => ({
      contractId,
      version: {
        id: versionId,
        versionNumber: 1,
        sourceKind: "upload",
        originalFilename: "contract.txt",
        mimeType: "text/plain",
        fileSizeBytes: 4,
        sha256: "a".repeat(64),
        extractionStatus: "pending",
        createdAt: timestamp
      }
    }));
    const extractContractVersion = vi.fn<ExtractContractVersion>(async () => ({
      contractId,
      versionId,
      extractionStatus: "completed",
      pageCount: null,
      updatedAt: timestamp
    }));
    const app = createApp({
      authMiddleware,
      getContracts,
      createContract,
      uploadContractVersion,
      extractContractVersion,
      analyzeContractVersion: vi.fn(async () => createAnalysisResponse())
    });

    const health = await request(app).get("/api/health");
    const list = await request(app)
      .get("/api/contracts")
      .set("Authorization", `Bearer ${accessToken}`);
    const create = await request(app)
      .post("/api/contracts")
      .set("Authorization", `Bearer ${accessToken}`)
      .send({ title: "Kontratë", contractType: "service" });
    const extract = await request(app)
      .post(`/api/contracts/${contractId}/versions/${versionId}/extract`)
      .set("Authorization", `Bearer ${accessToken}`)
      .send({});

    expect(health.status).toBe(200);
    expect(list.status).toBe(200);
    expect(create.status).toBe(201);
    expect(extract.status).toBe(200);
  });
});
