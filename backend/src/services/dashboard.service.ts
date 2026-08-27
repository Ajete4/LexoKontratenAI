import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import {
  ANALYSIS_PIPELINE_VERSION,
  RAG_ANALYSIS_PIPELINE_VERSION
} from "../ai/analysis-config.js";
import { createUserSupabaseClient } from "../config/supabase.js";
import type { Dashboard, DashboardLatestAnalysis } from "../types/dashboard.js";
import { ApiError } from "../utils/ApiError.js";

const MAX_DASHBOARD_ITEMS = 5;

const contractTypeSchema = z.enum(["employment", "service", "lease"]);
const contractStatusSchema = z.enum([
  "draft",
  "uploaded",
  "processing",
  "analyzed",
  "failed",
  "archived"
]);
const riskLevelSchema = z.enum([
  "low",
  "medium",
  "high",
  "critical",
  "unknown"
]);
const severitySchema = z.enum([
  "none",
  "low",
  "medium",
  "high",
  "critical",
  "review_required"
]);
const findingTypeSchema = z.enum([
  "normal",
  "risky",
  "imbalanced",
  "missing",
  "ambiguous"
]);
const nonNegativeIntegerSchema = z.number().int().nonnegative();

const dashboardSchema = z
  .object({
    stats: z
      .object({
        completedAnalyses: nonNegativeIntegerSchema,
        criticalClauses: nonNegativeIntegerSchema,
        professionalReviewClauses: nonNegativeIntegerSchema,
        qaQuestions: z.literal(0)
      })
      .strict(),
    recentContracts: z
      .array(
        z
          .object({
            id: z.string().uuid(),
            title: z.string().min(1).max(200),
            contractType: contractTypeSchema,
            status: contractStatusSchema,
            createdAt: z.string().datetime({ offset: true }),
            latestCompletedAnalysis: z
              .object({
                analysisId: z.string().uuid(),
                versionId: z.string().uuid(),
                overallRiskLevel: riskLevelSchema,
                completedAt: z.string().datetime({ offset: true }),
                criticalClauseCount: nonNegativeIntegerSchema,
                professionalReviewClauseCount: nonNegativeIntegerSchema
              })
              .strict()
              .nullable()
          })
          .strict()
      )
      .max(MAX_DASHBOARD_ITEMS),
    recentReviews: z
      .array(
        z
          .object({
            analysisId: z.string().uuid(),
            contractId: z.string().uuid(),
            versionId: z.string().uuid(),
            contractTitle: z.string().min(1).max(200),
            clausePosition: z.number().int().positive(),
            heading: z.string().max(200).nullable(),
            severity: severitySchema,
            findingType: findingTypeSchema,
            completedAt: z.string().datetime({ offset: true })
          })
          .strict()
      )
      .max(MAX_DASHBOARD_ITEMS)
  })
  .strict();

type DashboardInput = {
  userId: string;
  accessToken: string;
};

type DashboardDependencies = {
  createUserClient?: (accessToken: string) => SupabaseClient;
};

type EmbeddedClauseRow = {
  severity: unknown;
  requires_professional_review: unknown;
};

type EmbeddedAnalysisRow = {
  id: unknown;
  contract_version_id: unknown;
  overall_risk_level: unknown;
  completed_at: unknown;
  clauses: EmbeddedClauseRow[] | null;
};

type RecentContractRow = {
  id: unknown;
  title: unknown;
  contract_type: unknown;
  status: unknown;
  created_at: unknown;
};

type RecentAnalysisRow = EmbeddedAnalysisRow & {
  contract_versions: {
    contract_id: unknown;
    contracts: { owner_id: unknown } | null;
  } | null;
};

type RecentReviewRow = {
  position: unknown;
  heading: unknown;
  severity: unknown;
  finding_type: unknown;
  analyses:
    | {
        id: unknown;
        contract_version_id: unknown;
        completed_at: unknown;
        contract_versions:
          | {
              contract_id: unknown;
              contracts: { id: unknown; title: unknown } | null;
            }
          | null;
      }
    | null;
};

export type GetDashboard = (input: DashboardInput) => Promise<Dashboard>;

function databaseUnavailable(): ApiError {
  return new ApiError(
    503,
    "DATABASE_UNAVAILABLE",
    "Dashboard data is temporarily unavailable."
  );
}

function dashboardDataInvalid(): ApiError {
  return new ApiError(
    503,
    "DASHBOARD_DATA_INVALID",
    "Dashboard data is temporarily unavailable."
  );
}

function mapLatestAnalysis(latest: EmbeddedAnalysisRow | undefined) {
  if (!latest) return null;
  const clauses = latest.clauses ?? [];

  return {
    analysisId: String(latest.id),
    versionId: String(latest.contract_version_id),
    overallRiskLevel:
      latest.overall_risk_level as DashboardLatestAnalysis["overallRiskLevel"],
    completedAt: String(latest.completed_at),
    criticalClauseCount: clauses.filter(
      (clause) => clause.severity === "critical"
    ).length,
    professionalReviewClauseCount: clauses.filter(
      (clause) => clause.requires_professional_review === true
    ).length
  };
}

function mapRecentContracts(
  rows: unknown,
  analysisRows: unknown
): Dashboard["recentContracts"] {
  if (!Array.isArray(rows) || !Array.isArray(analysisRows)) {
    throw dashboardDataInvalid();
  }

  const latestByContract = new Map<string, RecentAnalysisRow>();
  for (const analysis of analysisRows as RecentAnalysisRow[]) {
    const contractId = String(analysis.contract_versions?.contract_id);
    if (!latestByContract.has(contractId)) latestByContract.set(contractId, analysis);
  }

  return (rows as RecentContractRow[]).map((row) => ({
    id: String(row.id),
    title: String(row.title),
    contractType: row.contract_type as Dashboard["recentContracts"][number]["contractType"],
    status: row.status as Dashboard["recentContracts"][number]["status"],
    createdAt: String(row.created_at),
    latestCompletedAnalysis: mapLatestAnalysis(latestByContract.get(String(row.id)))
  }));
}

function mapRecentReviews(rows: unknown): Dashboard["recentReviews"] {
  if (!Array.isArray(rows)) {
    throw dashboardDataInvalid();
  }

  return (rows as RecentReviewRow[]).map((row) => {
    const analysis = row.analyses;
    const version = analysis?.contract_versions;
    const contract = version?.contracts;

    return {
      analysisId: String(analysis?.id),
      contractId: String(contract?.id ?? version?.contract_id),
      versionId: String(analysis?.contract_version_id),
      contractTitle: String(contract?.title),
      clausePosition: Number(row.position),
      heading: row.heading === null ? null : String(row.heading),
      severity: row.severity as Dashboard["recentReviews"][number]["severity"],
      findingType: row.finding_type as Dashboard["recentReviews"][number]["findingType"],
      completedAt: String(analysis?.completed_at)
    };
  });
}

function readCount(count: number | null): number {
  if (!Number.isInteger(count) || count === null || count < 0) {
    throw dashboardDataInvalid();
  }

  return count;
}

export function createGetDashboard(
  dependencies: DashboardDependencies = {}
): GetDashboard {
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;

  return async ({ userId, accessToken }) => {
    const client = createUserClient(accessToken);

    const completedAnalysesQuery = client
      .from("analyses")
      .select("id", { count: "exact", head: true })
      .eq("requested_by", userId)
      .eq("status", "completed")
      .in("pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION]);

    const criticalClausesQuery = client
      .from("clauses")
      .select("id, analyses!inner(id)", { count: "exact", head: true })
      .eq("severity", "critical")
      .eq("analyses.requested_by", userId)
      .eq("analyses.status", "completed")
      .in("analyses.pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION]);

    const professionalReviewQuery = client
      .from("clauses")
      .select("id, analyses!inner(id)", { count: "exact", head: true })
      .eq("requires_professional_review", true)
      .eq("analyses.requested_by", userId)
      .eq("analyses.status", "completed")
      .in("analyses.pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION]);

    const recentContractsQuery = client
      .from("contracts")
      .select("id, title, contract_type, status, created_at")
      .eq("owner_id", userId)
      .order("created_at", { ascending: false })
      .limit(MAX_DASHBOARD_ITEMS);

    const recentContractsResult = await recentContractsQuery;
    if (recentContractsResult.error) throw databaseUnavailable();
    if (!Array.isArray(recentContractsResult.data)) throw dashboardDataInvalid();

    const recentContractIds = (recentContractsResult.data as RecentContractRow[])
      .map((contract) => String(contract.id));
    const recentAnalysesQuery = recentContractIds.length === 0
      ? Promise.resolve({ data: [], count: null, error: null })
      : client
          .from("analyses")
          .select(
            "id, contract_version_id, overall_risk_level, completed_at, " +
              "clauses(severity, requires_professional_review), " +
              "contract_versions!inner(contract_id, contracts!inner(owner_id))"
          )
          .eq("requested_by", userId)
          .eq("status", "completed")
          .in("pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION])
          .in("contract_versions.contract_id", recentContractIds)
          .eq("contract_versions.contracts.owner_id", userId)
          .order("completed_at", { ascending: false });

    const recentReviewsQuery = client
      .from("clauses")
      .select(
        "position, heading, severity, finding_type, " +
          "analyses!inner(id, contract_version_id, completed_at, " +
          "contract_versions!inner(contract_id, " +
          "contracts!inner(id, title)))"
      )
      .eq("requires_professional_review", true)
      .eq("analyses.requested_by", userId)
      .eq("analyses.status", "completed")
      .in("analyses.pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION])
      .eq("analyses.contract_versions.contracts.owner_id", userId)
      .order("completed_at", {
        ascending: false,
        referencedTable: "analyses"
      })
      .order("position", { ascending: true })
      .limit(MAX_DASHBOARD_ITEMS);

    const [
      completedAnalysesResult,
      criticalClausesResult,
      professionalReviewResult,
      recentAnalysesResult,
      recentReviewsResult
    ] = await Promise.all([
      completedAnalysesQuery,
      criticalClausesQuery,
      professionalReviewQuery,
      recentAnalysesQuery,
      recentReviewsQuery
    ]);

    const results = [
      completedAnalysesResult,
      criticalClausesResult,
      professionalReviewResult,
      recentContractsResult,
      recentAnalysesResult,
      recentReviewsResult
    ];

    if (results.some((result) => result.error)) {
      throw databaseUnavailable();
    }

    const dashboard: Dashboard = {
      stats: {
        completedAnalyses: readCount(completedAnalysesResult.count),
        criticalClauses: readCount(criticalClausesResult.count),
        professionalReviewClauses: readCount(professionalReviewResult.count),
        qaQuestions: 0
      },
      recentContracts: mapRecentContracts(
        recentContractsResult.data,
        recentAnalysesResult.data
      ),
      recentReviews: mapRecentReviews(recentReviewsResult.data)
    };
    const validated = dashboardSchema.safeParse(dashboard);

    if (!validated.success) {
      throw dashboardDataInvalid();
    }

    return validated.data;
  };
}

export const getDashboard = createGetDashboard();
