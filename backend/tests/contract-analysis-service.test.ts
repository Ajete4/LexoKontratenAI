import type { SupabaseClient } from "@supabase/supabase-js";
import { describe, expect, it, vi } from "vitest";

import type { ContractAnalysisAdapter } from "../src/ai/contract-analysis.adapter.js";
import {
  CONTRACT_ANALYSIS_DISCLAIMER,
  type ContractAnalysisResult
} from "../src/ai/contract-analysis.schema.js";
import {
  createAnalyzeContractVersion
} from "../src/services/contract-analysis.service.js";
import { ApiError } from "../src/utils/ApiError.js";
import type { RagAnalysisPipelineResult } from "../src/rag/rag-analysis-pipeline.js";

const userId = "user-test";
const accessToken = "test-access-token";
const contractId = "11111111-1111-4111-8111-111111111111";
const versionId = "22222222-2222-4222-8222-222222222222";
const analysisId = "33333333-3333-4333-8333-333333333333";
const createdAt = "2026-08-10T10:00:00.000Z";
const startedAt = "2026-08-10T10:01:00.000Z";
const completedAt = "2026-08-10T10:02:00.000Z";
const extractedText = "Tekst sintetik i kontratës së shërbimit.";

type AnalysisStatus = "queued" | "analyzing" | "completed" | "failed";

type AnalysisState = {
  id: string;
  contract_version_id: string;
  requested_by: string;
  status: AnalysisStatus;
  status_history: Array<Record<string, unknown>>;
  pipeline_version: string;
  model_name: string;
  prompt_version: string;
  result_json: unknown;
  overall_risk_level: unknown;
  created_at: string;
  completed_at: string | null;
};

type Scenario = {
  adapterError?: unknown;
  claimWins?: boolean;
  contractError?: boolean;
  contractOwned?: boolean;
  existingStatus?: AnalysisStatus;
  extractedText?: string | null;
  extractionStatus?: string;
  failureUpdateError?: boolean;
  insertConflict?: boolean;
  persistedInvalid?: boolean;
  rpcError?: boolean;
  rpcThrows?: boolean;
  ragPipeline?: (input: {
    contractType: "employment" | "service" | "lease";
    clauses: ContractAnalysisResult["clauses"];
  }) => Promise<RagAnalysisPipelineResult>;
  versionError?: boolean;
  versionOwned?: boolean;
};

function createValidResult(): ContractAnalysisResult {
  return {
    language: "sq",
    contractType: "service",
    title: "Marrëveshje shërbimi",
    summary: "Përmbledhje e marrëveshjes.",
    parties: [],
    keyDates: [],
    paymentTerms: [],
    terminationTerms: [],
    overallRiskLevel: "medium",
    overallRiskExplanation: "Disa kushte kërkojnë shqyrtim.",
    missingInformation: [],
    professionalReviewRecommended: true,
    clauses: [
      {
        position: 1,
        clauseType: "payment",
        findingType: "risky",
        title: "Pagesa",
        originalText: "Pagesa kryhet pas faturimit.",
        simplifiedText: "Pagesa bëhet pas faturës.",
        severity: "medium",
        favoredParty: "unclear",
        riskExplanation: "Afati nuk është përcaktuar.",
        suggestedAction: "Përcaktoni afatin.",
        suggestedRewrite: null,
        confidence: 0.9,
        requiresProfessionalReview: true
      },
      {
        position: 2,
        clauseType: "termination",
        findingType: "missing",
        title: "Ndërprerja",
        originalText: null,
        simplifiedText: null,
        severity: "review_required",
        favoredParty: "not_applicable",
        riskExplanation: "Klauzola e ndërprerjes mungon.",
        suggestedAction: "Kërkoni shqyrtim profesional.",
        suggestedRewrite: null,
        confidence: 0.85,
        requiresProfessionalReview: true
      }
    ],
    disclaimer: CONTRACT_ANALYSIS_DISCLAIMER
  };
}

function toPersistedClauses(result: ContractAnalysisResult) {
  return [...result.clauses]
    .reverse()
    .map((clause) => ({
      id: `66666666-6666-4666-8666-66666666666${clause.position}`,
      position: clause.position,
      clause_type: clause.clauseType,
      finding_type: clause.findingType,
      heading: clause.title,
      original_text: clause.originalText,
      simplified_text: clause.simplifiedText,
      severity: clause.severity,
      favored_party: clause.favoredParty,
      risk_explanation: clause.riskExplanation,
      suggested_action: clause.suggestedAction,
      suggested_rewrite: clause.suggestedRewrite,
      confidence: clause.confidence,
      requires_professional_review: clause.requiresProfessionalReview
    }));
}

function analysisResultJson(result: ContractAnalysisResult) {
  const { clauses: _clauses, overallRiskLevel: _risk, ...resultJson } = result;
  return resultJson;
}

function createAnalysisState(
  status: AnalysisStatus,
  result = createValidResult()
): AnalysisState {
  return {
    id: analysisId,
    contract_version_id: versionId,
    requested_by: userId,
    status,
    status_history: [{ status, at: createdAt }],
    pipeline_version: "analysis-v1",
    model_name: "gpt-4o-mini-2024-07-18",
    prompt_version: "contract-analysis-v1",
    result_json: status === "completed" ? analysisResultJson(result) : null,
    overall_risk_level:
      status === "completed" ? result.overallRiskLevel : null,
    created_at: createdAt,
    completed_at: status === "completed" ? completedAt : null
  };
}

function createUserBuilder(result: () => Promise<unknown>) {
  const builder: Record<string, unknown> = {};
  builder.select = vi.fn(() => builder);
  builder.eq = vi.fn(() => builder);
  builder.maybeSingle = vi.fn(result);
  return builder;
}

function createHarness(scenario: Scenario = {}) {
  const events: string[] = [];
  const validResult = createValidResult();
  let analysis = scenario.existingStatus
    ? createAnalysisState(scenario.existingStatus, validResult)
    : null;
  const adminUpdates: Array<Record<string, unknown>> = [];
  const insertedRows: Array<Record<string, unknown>> = [];

  const contractBuilder = createUserBuilder(async () => {
    events.push("ownership-contract");
    return {
      data:
        scenario.contractOwned === false
          ? null
          : { id: contractId, owner_id: userId, contract_type: "service" },
      error: scenario.contractError ? { message: "private error" } : null
    };
  });
  const versionBuilder = createUserBuilder(async () => {
    events.push("ownership-version");
    return {
      data:
        scenario.versionOwned === false
          ? null
          : {
              id: versionId,
              contract_id: contractId,
              extraction_status: scenario.extractionStatus ?? "completed",
              extracted_text:
                scenario.extractedText === undefined
                  ? extractedText
                  : scenario.extractedText
            },
      error: scenario.versionError ? { message: "private error" } : null
    };
  });
  const userClient = {
    from: vi.fn((table: string) =>
      table === "contracts" ? contractBuilder : versionBuilder
    )
  } as unknown as SupabaseClient;

  const executeAnalysisRead = async () => {
    events.push("admin-read-analysis");
    return { data: analysis, error: null };
  };

  const createAnalysisBuilder = () => {
    let operation: "read" | "insert" | "update" = "read";
    let payload: Record<string, unknown> = {};
    const builder: Record<string, unknown> = {};

    builder.select = vi.fn(() => builder);
    builder.eq = vi.fn(() => builder);
    builder.in = vi.fn(() => builder);
    builder.insert = vi.fn((values: Record<string, unknown>) => {
      operation = "insert";
      payload = values;
      insertedRows.push(values);
      return builder;
    });
    builder.update = vi.fn((values: Record<string, unknown>) => {
      operation = "update";
      payload = values;
      adminUpdates.push(values);
      return builder;
    });
    builder.single = vi.fn(async () => {
      events.push("admin-insert-analysis");

      if (scenario.insertConflict) {
        analysis = createAnalysisState("queued", validResult);
        return { data: null, error: { code: "23505" } };
      }

      analysis = {
        ...createAnalysisState("queued", validResult),
        ...payload,
        id: analysisId,
        created_at: createdAt,
        result_json: null,
        overall_risk_level: null
      } as AnalysisState;
      return { data: analysis, error: null };
    });
    builder.maybeSingle = vi.fn(async () => {
      if (operation === "read") {
        return executeAnalysisRead();
      }

      if (operation === "update" && payload.status === "analyzing") {
        events.push("admin-claim-analysis");

        if (
          scenario.claimWins === false ||
          !analysis ||
          !["queued", "failed"].includes(analysis.status)
        ) {
          return { data: null, error: null };
        }

        analysis = { ...analysis, ...payload } as AnalysisState;
        return { data: analysis, error: null };
      }

      events.push("admin-fail-analysis");

      if (scenario.failureUpdateError) {
        return { data: null, error: { message: "private failure" } };
      }

      if (analysis?.status === "analyzing") {
        analysis = { ...analysis, ...payload } as AnalysisState;
        return { data: { id: analysis.id }, error: null };
      }

      return { data: null, error: null };
    });

    return builder;
  };

  const clauses = toPersistedClauses(validResult);
  if (scenario.persistedInvalid && clauses[0]) {
    clauses[0].confidence = 2;
  }
  const createClausesBuilder = () => {
    const builder: Record<string, unknown> = {};
    builder.select = vi.fn(() => builder);
    builder.eq = vi.fn(() => builder);
    builder.order = vi.fn(async () => {
      events.push("admin-read-clauses");
      return {
        data: [...clauses].sort((left, right) => left.position - right.position),
        error: null
      };
    });
    return builder;
  };
  const adminFrom = vi.fn((table: string) => {
    if (table === "analyses") {
      return createAnalysisBuilder();
    }

    return createClausesBuilder();
  });
  const rpc = vi.fn(async (_name: string, _arguments: unknown) => {
    events.push("admin-rpc");

    if (scenario.rpcThrows) {
      throw new Error("private rpc transport failure");
    }

    if (scenario.rpcError) {
      return { data: null, error: { message: "private rpc failure" } };
    }

    return {
      data: [
        {
          analysis_id: analysisId,
          status: "completed",
          completed_at: completedAt,
          clause_count: validResult.clauses.length
        }
      ],
      error: null
    };
  });
  const adminClient = { from: adminFrom, rpc } as unknown as SupabaseClient;
  const analyzeContract = vi.fn(async () => {
    events.push("adapter");

    if (scenario.adapterError) {
      throw scenario.adapterError;
    }

    return validResult;
  });
  const adapter: ContractAnalysisAdapter = { analyzeContract };
  const timestamps = [createdAt, startedAt, completedAt, completedAt];
  const now = vi.fn(() => timestamps.shift() ?? completedAt);
  const createUserClient = vi.fn(() => userClient);
  const service = createAnalyzeContractVersion({
    adminClient,
    createUserClient,
    adapter,
    ragPipeline: scenario.ragPipeline,
    now
  });

  return {
    adapter: analyzeContract,
    adminFrom,
    adminUpdates,
    createUserClient,
    events,
    getAnalysis: () => analysis,
    insertedRows,
    rpc,
    service,
    userClient,
    validResult
  };
}

function runService(context: ReturnType<typeof createHarness>) {
  return context.service({ userId, accessToken, contractId, versionId });
}

describe("contract analysis service", () => {
  it("verifies ownership before using the admin client", async () => {
    const context = createHarness();

    await runService(context);

    expect(context.createUserClient).toHaveBeenCalledWith(accessToken);
    expect(context.events.slice(0, 3)).toEqual([
      "ownership-contract",
      "ownership-version",
      "admin-read-analysis"
    ]);
  });

  it.each([
    { contractOwned: false },
    { versionOwned: false }
  ])("hides contracts or versions unavailable through RLS", async (scenario) => {
    const context = createHarness(scenario);

    await expect(runService(context)).rejects.toMatchObject({
      statusCode: 404,
      code: "VERSION_NOT_FOUND"
    });
    expect(context.adminFrom).not.toHaveBeenCalled();
  });

  it("requires completed extraction and non-empty text", async () => {
    const pending = createHarness({ extractionStatus: "extracting" });
    const missing = createHarness({ extractedText: "   " });
    const nullText = createHarness({ extractedText: null });

    await expect(runService(pending)).rejects.toMatchObject({
      code: "EXTRACTION_NOT_COMPLETED"
    });
    await expect(runService(missing)).rejects.toMatchObject({
      code: "EXTRACTED_TEXT_MISSING"
    });
    await expect(runService(nullText)).rejects.toMatchObject({
      code: "EXTRACTED_TEXT_MISSING"
    });
  });

  it("enforces character and UTF-8 byte limits without truncation", async () => {
    const characterLimit = createHarness({ extractedText: "a".repeat(80_001) });
    const byteLimit = createHarness({ extractedText: "😀".repeat(80_001) });

    await expect(runService(characterLimit)).rejects.toMatchObject({
      statusCode: 413,
      code: "ANALYSIS_INPUT_TOO_LARGE"
    });
    await expect(runService(byteLimit)).rejects.toMatchObject({
      statusCode: 413,
      code: "ANALYSIS_INPUT_TOO_LARGE"
    });
    expect(characterLimit.adapter).not.toHaveBeenCalled();
    expect(byteLimit.adapter).not.toHaveBeenCalled();
  });

  it("creates and claims an analysis using backend-owned metadata", async () => {
    const context = createHarness();

    await runService(context);

    expect(context.insertedRows[0]).toMatchObject({
      contract_version_id: versionId,
      requested_by: userId,
      status: "queued",
      pipeline_version: "analysis-v1",
      prompt_version: "contract-analysis-v1",
      retrieval_config: null,
      started_at: null,
      completed_at: null,
      error_message_safe: null,
      status_history: [{ status: "queued", at: createdAt }]
    });
    expect(context.adminUpdates[0]).toMatchObject({
      status: "analyzing",
      started_at: startedAt,
      completed_at: null,
      error_message_safe: null
    });
  });

  it("allows a failed analysis to be claimed for retry", async () => {
    const context = createHarness({ existingStatus: "failed" });

    await runService(context);

    expect(context.adapter).toHaveBeenCalledTimes(1);
    expect(context.adminUpdates[0]).toMatchObject({ status: "analyzing" });
  });

  it.each(["queued", "analyzing"] as const)(
    "returns conflict for an existing %s analysis",
    async (existingStatus) => {
      const context = createHarness({ existingStatus });

      await expect(runService(context)).rejects.toMatchObject({
        statusCode: 409,
        code: "ANALYSIS_ALREADY_RUNNING"
      });
      expect(context.adapter).not.toHaveBeenCalled();
    }
  );

  it("handles an insert conflict by reading the existing analysis", async () => {
    const context = createHarness({ insertConflict: true });

    await expect(runService(context)).rejects.toMatchObject({
      code: "ANALYSIS_ALREADY_RUNNING"
    });
    expect(context.events.filter((event) => event === "admin-read-analysis"))
      .toHaveLength(2);
    expect(context.adapter).not.toHaveBeenCalled();
  });

  it("allows only one concurrent request to reach the adapter", async () => {
    const context = createHarness();
    const outcomes = await Promise.allSettled([
      runService(context),
      runService(context)
    ]);

    expect(context.adapter).toHaveBeenCalledTimes(1);
    expect(outcomes.filter((outcome) => outcome.status === "fulfilled"))
      .toHaveLength(1);
    const rejected = outcomes.find(
      (outcome): outcome is PromiseRejectedResult =>
        outcome.status === "rejected"
    );
    expect(rejected?.reason).toMatchObject({ code: "ANALYSIS_ALREADY_RUNNING" });
  });

  it("returns a completed analysis without calling AI or RPC", async () => {
    const context = createHarness({ existingStatus: "completed" });

    const response = await runService(context);

    expect(response.status).toBe("completed");
    expect(response.clauses.map((clause) => clause.position)).toEqual([1, 2]);
    expect(context.adapter).not.toHaveBeenCalled();
    expect(context.rpc).not.toHaveBeenCalled();
  });

  it("rejects invalid persisted results safely", async () => {
    const context = createHarness({
      existingStatus: "completed",
      persistedInvalid: true
    });

    await expect(runService(context)).rejects.toMatchObject({
      code: "ANALYSIS_PERSISTENCE_FAILED"
    });
  });

  it("calls the adapter with only contract type and extracted text", async () => {
    const context = createHarness();

    await runService(context);

    expect(context.adapter).toHaveBeenCalledWith({
      contractType: "service",
      extractedText
    });
  });

  it("maps result and clauses exactly into the atomic RPC", async () => {
    const context = createHarness();

    await runService(context);

    expect(context.rpc).toHaveBeenCalledTimes(1);
    const [rpcName, rawRpcArguments] = context.rpc.mock.calls[0]!;
    const rpcArguments = rawRpcArguments as Record<string, unknown> & {
      p_clauses: Array<Record<string, unknown>>;
      p_result: Record<string, unknown>;
    };
    expect(rpcName).toBe("complete_contract_analysis");
    expect(rpcArguments).toMatchObject({
      p_analysis_id: analysisId,
      p_expected_pipeline_version: "analysis-v1",
      p_overall_risk_level: "medium"
    });
    expect(rpcArguments.p_clauses).toEqual([
      expect.objectContaining({
        position: 1,
        clause_type: "payment",
        finding_type: "risky",
        heading: "Pagesa",
        favored_party: "unclear",
        requires_professional_review: true
      }),
      expect.objectContaining({
        position: 2,
        clause_type: "termination",
        finding_type: "missing",
        original_text: null
      })
    ]);
    expect(rpcArguments.p_result).not.toHaveProperty("clauses");
    expect(rpcArguments.p_result).not.toHaveProperty("overallRiskLevel");
    expect(rpcArguments.p_clauses[0]).not.toHaveProperty("page_number");
  });

  it("uses the versioned atomic citation RPC only for the RAG pipeline", async () => {
    const ragPipeline = vi.fn(async ({ clauses }: {
      clauses: ContractAnalysisResult["clauses"];
    }) => ({
      clauses: clauses.map((clause) => ({
        ...clause,
        evidenceStatus: "insufficient_evidence" as const,
        citations: []
      })),
      persistence: {
        clause_evidence: clauses.map((clause) => ({
          clause_key: `clause-${clause.position}`,
          evidence_status: "insufficient_evidence" as const,
          citations: []
        }))
      }
    }));
    const context = createHarness({ ragPipeline });

    const result = await runService(context);

    expect(ragPipeline).toHaveBeenCalledTimes(1);
    expect(context.rpc).toHaveBeenCalledTimes(1);
    expect(context.rpc.mock.calls[0]?.[0]).toBe("complete_contract_analysis_with_citations");
    expect(context.rpc.mock.calls[0]?.[1]).toMatchObject({
      p_expected_pipeline_version: "analysis-rag-v1",
      p_clause_evidence: [
        { clause_key: "clause-1", evidence_status: "insufficient_evidence", citations: [] },
        { clause_key: "clause-2", evidence_status: "insufficient_evidence", citations: [] }
      ]
    });
    expect(result.clauses.every((clause) => clause.evidenceStatus === "insufficient_evidence"))
      .toBe(true);
  });

  it("raises overall professional review when a grounded clause requires it", async () => {
    const ragPipeline = vi.fn(async ({ clauses }: {
      clauses: ContractAnalysisResult["clauses"];
    }) => ({
      clauses: clauses.map((clause, index) => ({
        ...clause,
        requiresProfessionalReview: index === 0,
        evidenceStatus: "insufficient_evidence" as const,
        citations: []
      })),
      persistence: {
        clause_evidence: clauses.map((clause) => ({
          clause_key: `clause-${clause.position}`,
          evidence_status: "insufficient_evidence" as const,
          citations: []
        }))
      }
    }));
    const context = createHarness({ ragPipeline });
    context.validResult.professionalReviewRecommended = false;
    context.validResult.clauses.forEach((clause) => {
      clause.requiresProfessionalReview = false;
    });

    await runService(context);

    expect(context.rpc.mock.calls[0]?.[1]).toMatchObject({
      p_result: { professionalReviewRecommended: true }
    });
  });

  it("does not persist partial analysis when RAG orchestration fails", async () => {
    const context = createHarness({
      ragPipeline: vi.fn(async () => {
        throw new ApiError(503, "RAG_EMBEDDING_UNAVAILABLE", "Safe error.");
      })
    });

    await expect(runService(context)).rejects.toMatchObject({
      code: "RAG_EMBEDDING_UNAVAILABLE"
    });
    expect(context.rpc).not.toHaveBeenCalled();
    expect(context.adminUpdates.at(-1)).toMatchObject({
      status: "failed",
      error_message_safe: "RAG_EMBEDDING_UNAVAILABLE"
    });
  });

  it("marks RPC failures safely and returns persistence failure", async () => {
    const context = createHarness({ rpcError: true });

    await expect(runService(context)).rejects.toMatchObject({
      code: "ANALYSIS_PERSISTENCE_FAILED"
    });
    expect(context.adminUpdates.at(-1)).toMatchObject({
      status: "failed",
      completed_at: null,
      error_message_safe: "ANALYSIS_PERSISTENCE_FAILED"
    });
  });

  it("maps a rejected RPC call to the same safe persistence failure", async () => {
    const context = createHarness({ rpcThrows: true });

    await expect(runService(context)).rejects.toMatchObject({
      code: "ANALYSIS_PERSISTENCE_FAILED"
    });
    expect(context.adminUpdates.at(-1)).toMatchObject({
      status: "failed",
      error_message_safe: "ANALYSIS_PERSISTENCE_FAILED"
    });
  });

  it.each([
    "AI_REFUSED",
    "AI_TIMEOUT",
    "AI_RATE_LIMITED",
    "AI_UNAVAILABLE"
  ])("preserves safe adapter error %s and marks failed", async (code) => {
    const adapterError = new ApiError(503, code, "Safe adapter message.");
    const context = createHarness({ adapterError });

    await expect(runService(context)).rejects.toMatchObject({ code });
    expect(context.adminUpdates.at(-1)).toMatchObject({
      status: "failed",
      error_message_safe: code
    });
  });

  it("does not mask the original error when failed-state update fails", async () => {
    const adapterError = new ApiError(504, "AI_TIMEOUT", "AI analysis timed out.");
    const context = createHarness({
      adapterError,
      failureUpdateError: true
    });

    await expect(runService(context)).rejects.toBe(adapterError);
  });

  it("returns no extracted text, prompt, raw output, or database internals", async () => {
    const context = createHarness();

    const response = await runService(context);
    const serialized = JSON.stringify(response);

    expect(serialized).not.toContain(extractedText);
    expect(response).not.toHaveProperty("status_history");
    expect(response).not.toHaveProperty("error_message_safe");
    expect(response).not.toHaveProperty("raw_output");
    expect(response).not.toHaveProperty("prompt");
  });
});
