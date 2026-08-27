import type { SupabaseClient } from "@supabase/supabase-js";
import { describe, expect, it, vi } from "vitest";

import { createGetDashboard } from "../src/services/dashboard.service.js";

const userId = "authenticated-user";
const accessToken = "synthetic-access-token";
const contractId = "11111111-1111-4111-8111-111111111111";
const versionId = "22222222-2222-4222-8222-222222222222";
const analysisId = "33333333-3333-4333-8333-333333333333";
const completedAt = "2026-08-10T10:02:00.000Z";

type Scenario = {
  completedCount?: number | null;
  criticalCount?: number | null;
  professionalCount?: number | null;
  contractRows?: unknown[];
  analysisRows?: unknown[];
  reviewRows?: unknown[];
  failingTable?: string;
};

function createContractRow(
  id = contractId,
  createdAt = "2026-08-10T10:00:00.000Z"
) {
  return {
    id,
    title: `Contract ${id.slice(0, 4)}`,
    contract_type: "service",
    status: "uploaded",
    created_at: createdAt
  };
}

function createEmbeddedAnalysis(
  id = analysisId,
  completed = completedAt,
  clauses = [
    { severity: "critical", requires_professional_review: false },
    { severity: "low", requires_professional_review: true }
  ]
) {
  return {
    id,
    contract_version_id: versionId,
    overall_risk_level: "medium",
    completed_at: completed,
    clauses,
    contract_versions: {
      contract_id: contractId,
      contracts: { owner_id: userId }
    }
  };
}

function createReviewRow(position = 1, completed = completedAt) {
  return {
    position,
    heading: "Termination",
    severity: "low",
    finding_type: "normal",
    analyses: {
      id: analysisId,
      contract_version_id: versionId,
      completed_at: completed,
      contract_versions: {
        contract_id: contractId,
        contracts: { id: contractId, title: "Contract test" }
      }
    }
  };
}

function createHarness(scenario: Scenario = {}) {
  const filters: Array<{ table: string; column: string; value: unknown }> = [];
  const limits: Array<{ table: string; value: number }> = [];
  const orders: Array<{
    table: string;
    column: string;
    options: unknown;
  }> = [];
  const selects: Array<{
    table: string;
    columns: string;
    options: unknown;
  }> = [];
  let queryCount = 0;

  function createBuilder(table: string) {
    const queryFilters: Array<{ column: string; value: unknown }> = [];
    const state: { columns: string; options: unknown } = {
      columns: "",
      options: undefined
    };
    const builder: Record<string, unknown> = {};

    builder.select = vi.fn((columns: string, options?: unknown) => {
      state.columns = columns;
      state.options = options;
      selects.push({ table, columns, options });
      return builder;
    });
    builder.eq = vi.fn((column: string, value: unknown) => {
      queryFilters.push({ column, value });
      filters.push({ table, column, value });
      return builder;
    });
    builder.in = vi.fn((column: string, value: unknown) => {
      queryFilters.push({ column, value });
      filters.push({ table, column, value });
      return builder;
    });
    builder.order = vi.fn((column: string, options: unknown) => {
      orders.push({ table, column, options });
      return builder;
    });
    builder.limit = vi.fn((value: number) => {
      limits.push({ table, value });
      return builder;
    });
    builder.then = (
      resolve: (value: unknown) => unknown,
      reject: (reason: unknown) => unknown
    ) => {
      queryCount += 1;
      let result: { data: unknown; count: number | null; error: unknown };

      if (scenario.failingTable === table) {
        result = { data: null, count: null, error: { code: "synthetic" } };
      } else if (table === "analyses") {
        result = state.options
          ? {
              data: null,
              count:
                scenario.completedCount === undefined
                  ? 0
                  : scenario.completedCount,
              error: null
            }
          : { data: scenario.analysisRows ?? [], count: null, error: null };
      } else if (table === "contracts") {
        result = {
          data: scenario.contractRows ?? [],
          count: null,
          error: null
        };
      } else if (state.options && state.columns.includes("analyses!inner(id)")) {
        const isCritical = queryFilters.some(
          (filter) =>
            filter.column === "severity" &&
            filter.value === "critical"
        );
        result = {
          data: null,
          count: isCritical
            ? (scenario.criticalCount ?? 0)
            : (scenario.professionalCount ?? 0),
          error: null
        };
      } else {
        result = {
          data: scenario.reviewRows ?? [],
          count: null,
          error: null
        };
      }

      return Promise.resolve(result).then(resolve, reject);
    };

    return builder;
  }

  const client = {
    from: vi.fn((table: string) => createBuilder(table))
  } as unknown as SupabaseClient;
  const createUserClient = vi.fn(() => client);
  const getDashboard = createGetDashboard({ createUserClient });

  return {
    createUserClient,
    filters,
    getDashboard,
    limits,
    orders,
    queryCount: () => queryCount,
    selects
  };
}

describe("dashboard service", () => {
  it("returns zero stats, zero Q&A, and empty lists", async () => {
    const context = createHarness();

    await expect(
      context.getDashboard({ userId, accessToken })
    ).resolves.toEqual({
      stats: {
        completedAnalyses: 0,
        criticalClauses: 0,
        professionalReviewClauses: 0,
        qaQuestions: 0
      },
      recentContracts: [],
      recentReviews: []
    });
  });

  it("maps real counts including professional review independent of severity", async () => {
    const context = createHarness({
      completedCount: 3,
      criticalCount: 1,
      professionalCount: 2,
      contractRows: [createContractRow()],
      analysisRows: [createEmbeddedAnalysis()]
    });

    const dashboard = await context.getDashboard({ userId, accessToken });

    expect(dashboard.stats).toEqual({
      completedAnalyses: 3,
      criticalClauses: 1,
      professionalReviewClauses: 2,
      qaQuestions: 0
    });
    expect(
      dashboard.recentContracts[0]?.latestCompletedAnalysis
        ?.professionalReviewClauseCount
    ).toBe(1);
  });

  it("applies user, completed-status, and current-pipeline filters", async () => {
    const context = createHarness();

    await context.getDashboard({ userId, accessToken });

    expect(context.createUserClient).toHaveBeenCalledWith(accessToken);
    expect(context.filters).toEqual(
      expect.arrayContaining([
        { table: "analyses", column: "requested_by", value: userId },
        { table: "analyses", column: "status", value: "completed" },
        {
          table: "analyses",
          column: "pipeline_version",
          value: ["analysis-rag-v1", "analysis-v1"]
        },
        { table: "contracts", column: "owner_id", value: userId },
        {
          table: "clauses",
          column: "requires_professional_review",
          value: true
        }
      ])
    );
  });

  it("maps a contract without a completed analysis to null", async () => {
    const context = createHarness({ contractRows: [createContractRow()] });
    const dashboard = await context.getDashboard({ userId, accessToken });

    expect(dashboard.recentContracts[0]?.latestCompletedAnalysis).toBeNull();
  });

  it("keeps the five newest contracts even when some have no completed analysis", async () => {
    const newestId = "55555555-5555-4555-8555-555555555555";
    const context = createHarness({
      contractRows: [
        createContractRow(newestId, "2026-08-11T10:00:00.000Z"),
        createContractRow(contractId, "2026-08-10T10:00:00.000Z")
      ],
      analysisRows: [createEmbeddedAnalysis()]
    });

    const dashboard = await context.getDashboard({ userId, accessToken });

    expect(dashboard.recentContracts.map((contract) => contract.id)).toEqual([
      newestId,
      contractId
    ]);
    expect(dashboard.recentContracts[0]?.latestCompletedAnalysis).toBeNull();
    expect(dashboard.recentContracts[1]?.latestCompletedAnalysis).not.toBeNull();
  });

  it("selects the newest completed embedded analysis", async () => {
    const older = createEmbeddedAnalysis(
      "44444444-4444-4444-8444-444444444444",
      "2026-08-09T10:00:00.000Z"
    );
    const newest = createEmbeddedAnalysis();
    const context = createHarness({
      contractRows: [createContractRow()],
      analysisRows: [newest, older]
    });

    const dashboard = await context.getDashboard({ userId, accessToken });

    expect(
      dashboard.recentContracts[0]?.latestCompletedAnalysis?.analysisId
    ).toBe(analysisId);
  });

  it("keeps recent contracts and reviews bounded to five", async () => {
    const ids = ["1", "2", "3", "4", "5"].map(
      (digit) => `${digit.repeat(8)}-${digit.repeat(4)}-4${digit.repeat(3)}-8${digit.repeat(3)}-${digit.repeat(12)}`
    );
    const context = createHarness({
      contractRows: ids.map((id, index) =>
        createContractRow(id, `2026-08-0${index + 1}T10:00:00.000Z`)
      ),
      reviewRows: [1, 2, 3, 4, 5].map((position) =>
        createReviewRow(position)
      )
    });

    const dashboard = await context.getDashboard({ userId, accessToken });

    expect(dashboard.recentContracts).toHaveLength(5);
    expect(dashboard.recentReviews).toHaveLength(5);
    expect(context.limits).toEqual(
      expect.arrayContaining([
        { table: "contracts", value: 5 },
        { table: "clauses", value: 5 }
      ])
    );
  });

  it("orders contracts and reviews as specified", async () => {
    const context = createHarness();

    await context.getDashboard({ userId, accessToken });

    expect(context.orders).toEqual(
      expect.arrayContaining([
        {
          table: "contracts",
          column: "created_at",
          options: { ascending: false }
        },
        {
          table: "clauses",
          column: "completed_at",
          options: { ascending: false, referencedTable: "analyses" }
        },
        {
          table: "clauses",
          column: "position",
          options: { ascending: true }
        }
      ])
    );
  });

  it("returns only the approved recent review fields", async () => {
    const context = createHarness({ reviewRows: [createReviewRow()] });
    const dashboard = await context.getDashboard({ userId, accessToken });
    const serialized = JSON.stringify(dashboard);

    expect(dashboard.recentReviews[0]).toEqual({
      analysisId,
      contractId,
      versionId,
      contractTitle: "Contract test",
      clausePosition: 1,
      heading: "Termination",
      severity: "low",
      findingType: "normal",
      completedAt
    });
    expect(serialized).not.toContain("extracted_text");
    expect(serialized).not.toContain("result_json");
    expect(serialized).not.toContain("status_history");
    expect(serialized).not.toContain("suggested_action");
  });

  it("uses a constant five-query plan without per-row queries", async () => {
    const context = createHarness({
      contractRows: [createContractRow()],
      reviewRows: [createReviewRow()]
    });

    await context.getDashboard({ userId, accessToken });

    expect(context.queryCount()).toBe(6);
  });

  it("maps database failures to a safe 503", async () => {
    const context = createHarness({ failingTable: "contracts" });

    await expect(
      context.getDashboard({ userId, accessToken })
    ).rejects.toMatchObject({
      statusCode: 503,
      code: "DATABASE_UNAVAILABLE",
      details: null
    });
  });

  it("rejects invalid mapped persistence data safely", async () => {
    const context = createHarness({ completedCount: null });

    await expect(
      context.getDashboard({ userId, accessToken })
    ).rejects.toMatchObject({
      statusCode: 503,
      code: "DASHBOARD_DATA_INVALID"
    });
  });
});
