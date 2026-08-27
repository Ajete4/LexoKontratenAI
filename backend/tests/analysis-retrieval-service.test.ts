import type { SupabaseClient } from "@supabase/supabase-js";
import { describe, expect, it, vi } from "vitest";

import { CONTRACT_ANALYSIS_DISCLAIMER } from "../src/ai/contract-analysis.schema.js";
import {
  createGetContractAnalysis,
  createGetLatestAnalysis,
  createGetLatestContractAnalysis
} from "../src/services/analysis-retrieval.service.js";

const userId = "authenticated-user";
const accessToken = "synthetic-access-token";
const contractId = "11111111-1111-4111-8111-111111111111";
const versionId = "22222222-2222-4222-8222-222222222222";
const analysisId = "33333333-3333-4333-8333-333333333333";
const olderAnalysisId = "44444444-4444-4444-8444-444444444444";
const createdAt = "2026-08-10T10:00:00.000Z";
const completedAt = "2026-08-10T10:02:00.000Z";

function createResult() {
  return {
    language: "sq",
    contractType: "service",
    title: "Marrëveshje shërbimi",
    summary: "Përmbledhje informative.",
    parties: [],
    keyDates: [],
    paymentTerms: [],
    terminationTerms: [],
    overallRiskExplanation: "Disa kushte kërkojnë shqyrtim.",
    missingInformation: [],
    professionalReviewRecommended: true,
    disclaimer: CONTRACT_ANALYSIS_DISCLAIMER
  };
}

function createAnalysis(
  id = analysisId,
  status = "completed",
  completed = completedAt
) {
  return {
    id,
    contract_version_id: versionId,
    requested_by: userId,
    status,
    status_history: [{ status, at: completed }],
    pipeline_version: "analysis-v1",
    model_name: "gpt-4o-mini-2024-07-18",
    prompt_version: "contract-analysis-v1",
    result_json: status === "completed" ? createResult() : null,
    overall_risk_level: status === "completed" ? "medium" : null,
    created_at: createdAt,
    completed_at: status === "completed" ? completed : null,
    storage_path: "must-not-be-returned",
    extracted_text: "must-not-be-returned"
  };
}

const persistedClauses = [
  {
    id: "66666666-6666-4666-8666-666666666662",
    position: 2,
    clause_type: "termination",
    finding_type: "missing",
    heading: "Ndërprerja",
    original_text: null,
    simplified_text: null,
    severity: "review_required",
    favored_party: "not_applicable",
    risk_explanation: "Klauzola mungon.",
    suggested_action: "Kërkoni shqyrtim profesional.",
    suggested_rewrite: null,
    confidence: 0.8,
    requires_professional_review: true
  },
  {
    id: "66666666-6666-4666-8666-666666666661",
    position: 1,
    clause_type: "payment",
    finding_type: "normal",
    heading: "Pagesa",
    original_text: "Pagesa kryhet sipas faturës.",
    simplified_text: "Pagesa bëhet pas faturimit.",
    severity: "none",
    favored_party: "balanced",
    risk_explanation: null,
    suggested_action: null,
    suggested_rewrite: null,
    confidence: 0.95,
    requires_professional_review: false
  }
];

type Scenario = {
  analysisRows?: ReturnType<typeof createAnalysis>[];
  contractFound?: boolean;
  versionFound?: boolean;
  tableError?: string;
  citationRows?: unknown[];
};

function createHarness(scenario: Scenario = {}) {
  const analyses = scenario.analysisRows ?? [createAnalysis()];
  const events: string[] = [];
  const selectedColumns: Record<string, string[]> = {};
  const filters: Array<{ table: string; column: string; value: unknown }> = [];
  const orders: Array<{
    table: string;
    column: string;
    options: unknown;
  }> = [];
  const limits: Array<{ table: string; value: number }> = [];

  function createBuilder(table: string) {
    const tableFilters: Record<string, unknown> = {};
    const builder: Record<string, unknown> = {};

    builder.select = vi.fn((columns: string) => {
      selectedColumns[table] ??= [];
      selectedColumns[table]!.push(columns);
      return builder;
    });
    builder.eq = vi.fn((column: string, value: unknown) => {
      tableFilters[column] = value;
      filters.push({ table, column, value });
      return builder;
    });
    builder.in = vi.fn((column: string, value: unknown[]) => {
      tableFilters[column] = value;
      filters.push({ table, column, value });
      return builder;
    });
    builder.limit = vi.fn((value: number) => {
      limits.push({ table, value });
      return builder;
    });
    builder.order = vi.fn((column: string, options: unknown) => {
      orders.push({ table, column, options });

      if (table === "clauses") {
        return Promise.resolve({
          data: [...persistedClauses].sort(
            (left, right) => left.position - right.position
          ),
          error: scenario.tableError === table ? { code: "synthetic" } : null
        });
      }

      return builder;
    });
    builder.maybeSingle = vi.fn(async () => {
      events.push(`read-${table}`);

      if (scenario.tableError === table) {
        return { data: null, error: { code: "synthetic" } };
      }

      if (table === "contracts") {
        return {
          data:
            scenario.contractFound === false
              ? null
              : { id: contractId, owner_id: userId },
          error: null
        };
      }

      if (table === "contract_versions") {
        return {
          data:
            scenario.versionFound === false
              ? null
              : { id: versionId, contract_id: contractId },
          error: null
        };
      }

      const matching = analyses
        .filter((analysis) =>
          Object.entries(tableFilters).every(
            ([column, value]) =>
              column === "contract_versions.contract_id"
                ? value === contractId
                : Array.isArray(value)
                  ? value.includes(analysis[column as keyof typeof analysis])
                  : analysis[column as keyof typeof analysis] === value
          )
        )
        .sort((left, right) =>
          String(right.completed_at).localeCompare(String(left.completed_at))
        );

      return { data: matching[0] ?? null, error: null };
    });

    return builder;
  }

  const userClient = {
    from: vi.fn((table: string) => createBuilder(table))
  } as unknown as SupabaseClient;
  const createUserClient = vi.fn(() => userClient);
  const citationOrder = vi.fn(async () => ({
    data: scenario.citationRows ?? [],
    error: null
  }));
  const citationBuilder: Record<string, unknown> = {
    select: vi.fn(() => citationBuilder),
    in: vi.fn(() => citationBuilder),
    order: citationOrder
  };
  const citationClient = {
    from: vi.fn(() => citationBuilder)
  } as unknown as SupabaseClient;

  return {
    createUserClient,
    events,
    filters,
    citationClient,
    citationOrder,
    getDetail: createGetContractAnalysis({ createUserClient, citationClient }),
    getLatest: createGetLatestAnalysis({ createUserClient, citationClient }),
    getLatestContract: createGetLatestContractAnalysis({ createUserClient, citationClient }),
    limits,
    orders,
    selectedColumns,
    userClient
  };
}

function getDetail(context: ReturnType<typeof createHarness>) {
  return context.getDetail({ userId, accessToken, contractId, versionId });
}

function getLatest(context: ReturnType<typeof createHarness>) {
  return context.getLatest({ userId, accessToken });
}

function getLatestContract(context: ReturnType<typeof createHarness>) {
  return context.getLatestContract({ userId, accessToken, contractId });
}

describe("analysis retrieval service", () => {
  it.each([
    [{ contractFound: false }, ["read-contracts"]],
    [{ versionFound: false }, ["read-contracts", "read-contract_versions"]]
  ])("hides inaccessible contract/version rows", async (scenario, events) => {
    const context = createHarness(scenario);

    await expect(getDetail(context)).rejects.toMatchObject({
      statusCode: 404,
      code: "ANALYSIS_NOT_FOUND"
    });
    expect(context.events).toEqual(events);
  });

  it.each([
    { analysisRows: [] },
    { analysisRows: [createAnalysis(analysisId, "analyzing")] }
  ])(
    "does not return a missing or incomplete detail analysis",
    async ({ analysisRows }) => {
      const context = createHarness({ analysisRows });

      await expect(getDetail(context)).rejects.toMatchObject({
        statusCode: 404,
        code: "ANALYSIS_NOT_FOUND"
      });
    }
  );

  it("returns a validated completed analysis with ordered clauses", async () => {
    const context = createHarness();

    const result = await getDetail(context);

    expect(result).toMatchObject({
      analysisId,
      contractId,
      versionId,
      status: "completed",
      result: {
        overallRiskLevel: "medium"
      }
    });
    expect(result.clauses.map((clause) => clause.position)).toEqual([1, 2]);
    expect(result.clauses.every((clause) =>
      clause.evidenceStatus === "legacy_unverified" && clause.citations.length === 0
    )).toBe(true);
    expect(context.orders).toContainEqual({
      table: "clauses",
      column: "position",
      options: { ascending: true }
    });
  });

  it("returns no persisted internals or document/storage data", async () => {
    const context = createHarness();
    const result = await getDetail(context);
    const serialized = JSON.stringify(result);

    expect(serialized).not.toContain("extracted_text");
    expect(serialized).not.toContain("status_history");
    expect(serialized).not.toContain("storage_path");
    expect(serialized).not.toContain("must-not-be-returned");
    expect(context.selectedColumns.analyses?.[0]).not.toContain(
      "status_history"
    );
  });

  it("loads all RAG citations in one bounded query and returns only public metadata", async () => {
    const ragAnalysis = {
      ...createAnalysis(),
      pipeline_version: "analysis-rag-v1",
      prompt_version: "contract-analysis-rag-v1"
    };
    const context = createHarness({
      analysisRows: [ragAnalysis],
      citationRows: [{
        clause_id: persistedClauses[1]!.id,
        citation_rank: 1,
        citation_id: "C1",
        legal_chunks: {
          article_number: "10",
          article_title: "Detyrimi",
          legal_sources: {
            law_number: "04/L-077",
            title: "Ligji sintetik",
            official_url: "https://example.test/act",
            official_document_url: null
          }
        }
      }]
    });

    const result = await getDetail(context);
    const grounded = result.clauses.find((clause) => clause.position === 1)!;
    expect(context.citationClient.from).toHaveBeenCalledTimes(1);
    expect(context.citationOrder).toHaveBeenCalledTimes(1);
    expect(grounded.evidenceStatus).toBe("grounded");
    expect(grounded.citations[0]).toEqual(expect.objectContaining({
      citationId: "C1", lawNumber: "04/L-077", articleNumber: "10"
    }));
    expect(JSON.stringify(result)).not.toMatch(/legal_chunk_id|content_hash|embedding|vector/iu);
  });

  it("uses only a user-scoped client and verified identity filters", async () => {
    const context = createHarness();

    await getDetail(context);

    expect(context.createUserClient).toHaveBeenCalledWith(accessToken);
    expect(context.filters).toContainEqual({
      table: "contracts",
      column: "owner_id",
      value: userId
    });
    expect(context.userClient.from).toHaveBeenCalledWith("analyses");
    expect(context.userClient.from).toHaveBeenCalledWith("clauses");
  });

  it("returns ANALYSIS_NOT_FOUND when latest has no completed analysis", async () => {
    const context = createHarness({ analysisRows: [] });

    await expect(getLatest(context)).rejects.toMatchObject({
      statusCode: 404,
      code: "ANALYSIS_NOT_FOUND"
    });
  });

  it("returns only the latest completed analysis for the current pipeline", async () => {
    const context = createHarness({
      analysisRows: [
        createAnalysis(olderAnalysisId, "completed", "2026-08-10T09:00:00.000Z"),
        createAnalysis(),
        createAnalysis("55555555-5555-4555-8555-555555555555", "failed")
      ]
    });

    const result = await getLatest(context);

    expect(result.analysisId).toBe(analysisId);
    expect(context.filters).toEqual(
      expect.arrayContaining([
        { table: "analyses", column: "requested_by", value: userId },
        {
          table: "analyses",
          column: "pipeline_version",
          value: ["analysis-rag-v1", "analysis-v1"]
        },
        { table: "analyses", column: "status", value: "completed" }
      ])
    );
    expect(context.orders).toContainEqual({
      table: "analyses",
      column: "completed_at",
      options: { ascending: false }
    });
    expect(context.limits).toContainEqual({ table: "analyses", value: 1 });
  });

  it.each([
    { contractFound: false },
    { versionFound: false },
    { analysisRows: [] },
    { analysisRows: [createAnalysis(analysisId, "queued")] },
    { analysisRows: [createAnalysis(analysisId, "analyzing")] },
    { analysisRows: [createAnalysis(analysisId, "failed")] }
  ])(
    "hides an inaccessible contract or unavailable completed contract analysis",
    async (scenario) => {
      const context = createHarness(scenario);

      await expect(getLatestContract(context)).rejects.toMatchObject({
        statusCode: 404,
        code: "ANALYSIS_NOT_FOUND"
      });
    }
  );

  it("returns the latest completed analysis for the contract and current pipeline", async () => {
    const wrongPipeline = {
      ...createAnalysis("55555555-5555-4555-8555-555555555555"),
      pipeline_version: "analysis-v0",
      completed_at: "2026-08-10T11:00:00.000Z"
    };
    const context = createHarness({
      analysisRows: [
        createAnalysis(olderAnalysisId, "completed", "2026-08-10T09:00:00.000Z"),
        createAnalysis(),
        wrongPipeline
      ]
    });

    const result = await getLatestContract(context);

    expect(result.analysisId).toBe(analysisId);
    expect(result.versionId).toBe(versionId);
    expect(result.clauses.map((clause) => clause.position)).toEqual([1, 2]);
    expect(context.filters).toEqual(
      expect.arrayContaining([
        { table: "contracts", column: "owner_id", value: userId },
        {
          table: "analyses",
          column: "contract_versions.contract_id",
          value: contractId
        },
        {
          table: "analyses",
          column: "pipeline_version",
          value: ["analysis-rag-v1", "analysis-v1"]
        },
        { table: "analyses", column: "status", value: "completed" }
      ])
    );
    expect(context.orders).toContainEqual({
      table: "analyses",
      column: "completed_at",
      options: { ascending: false }
    });
    expect(context.limits).toContainEqual({ table: "analyses", value: 1 });
    expect(context.createUserClient).toHaveBeenCalledWith(accessToken);
  });

  it("returns no persistence or Storage internals for contract latest", async () => {
    const context = createHarness();
    const result = await getLatestContract(context);
    const serialized = JSON.stringify(result);

    expect(serialized).not.toContain("extracted_text");
    expect(serialized).not.toContain("status_history");
    expect(serialized).not.toContain("storage_path");
    expect(context.selectedColumns.analyses?.[0]).not.toContain(
      "status_history"
    );
  });

  it("maps database errors to a safe availability error", async () => {
    const context = createHarness({ tableError: "analyses" });

    await expect(getDetail(context)).rejects.toMatchObject({
      statusCode: 503,
      code: "DATABASE_UNAVAILABLE"
    });
  });
});
