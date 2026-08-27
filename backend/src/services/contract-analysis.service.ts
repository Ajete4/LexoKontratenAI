import type { SupabaseClient } from "@supabase/supabase-js";

import {
  type ContractAnalysisAdapter,
  analyzeContract
} from "../ai/contract-analysis.adapter.js";
import {
  ANALYSIS_PIPELINE_VERSION,
  ANALYSIS_PROMPT_VERSION,
  RAG_ANALYSIS_PIPELINE_VERSION,
  RAG_ANALYSIS_PROMPT_VERSION
} from "../ai/analysis-config.js";
import {
  type ContractAnalysisResult,
  type ContractType,
  validateContractAnalysisResult
} from "../ai/contract-analysis.schema.js";
import { env } from "../config/env.js";
import {
  createUserSupabaseClient,
  supabaseAdmin
} from "../config/supabase.js";
import { ApiError } from "../utils/ApiError.js";
import {
  clauseEvidenceResponseSchema,
  type ClauseEvidence,
  type RagAnalysisPipelineResult
} from "../rag/rag-analysis-pipeline.js";
import { createProductionRagAnalysisPipeline } from "../rag/rag-production-composition.js";

const MAX_ANALYSIS_CHARACTERS = 80_000;
const MAX_ANALYSIS_UTF8_BYTES = 320_000;

const ANALYSIS_COLUMNS =
  "id, contract_version_id, requested_by, status, status_history, " +
  "pipeline_version, model_name, prompt_version, result_json, " +
  "overall_risk_level, created_at, completed_at";

const CLAUSE_COLUMNS =
  "id, position, clause_type, finding_type, heading, original_text, " +
  "simplified_text, severity, favored_party, risk_explanation, " +
  "suggested_action, suggested_rewrite, confidence, " +
  "requires_professional_review";

type AnalysisStatus = "queued" | "analyzing" | "completed" | "failed";

type AnalysisRow = {
  id: string;
  contract_version_id: string;
  requested_by: string;
  status: AnalysisStatus | string;
  status_history: unknown;
  pipeline_version: string;
  model_name: string | null;
  prompt_version: string | null;
  result_json: unknown;
  overall_risk_level: unknown;
  created_at: string;
  completed_at: string | null;
};

export type CompletedAnalysisRow = Pick<
  AnalysisRow,
  | "id"
  | "contract_version_id"
  | "status"
  | "pipeline_version"
  | "model_name"
  | "prompt_version"
  | "result_json"
  | "overall_risk_level"
  | "created_at"
  | "completed_at"
>;

type PersistedClause = {
  id: string;
  position: number;
  clause_type: unknown;
  finding_type: unknown;
  heading: unknown;
  original_text: unknown;
  simplified_text: unknown;
  severity: unknown;
  favored_party: unknown;
  risk_explanation: unknown;
  suggested_action: unknown;
  suggested_rewrite: unknown;
  confidence: unknown;
  requires_professional_review: unknown;
};

type SafeAnalysisResult = Omit<ContractAnalysisResult, "clauses">;

export interface ContractAnalysisResponse {
  analysisId: string;
  contractId: string;
  versionId: string;
  status: "completed";
  result: SafeAnalysisResult;
  clauses: Array<ContractAnalysisResult["clauses"][number] & ClauseEvidence>;
  createdAt: string;
  completedAt: string;
}

export interface AnalyzeContractVersionInput {
  userId: string;
  accessToken: string;
  contractId: string;
  versionId: string;
}

export interface ContractAnalysisServiceDependencies {
  adminClient?: SupabaseClient;
  createUserClient?: (accessToken: string) => SupabaseClient;
  adapter?: ContractAnalysisAdapter;
  ragPipeline?: (input: {
    contractType: ContractType;
    clauses: ContractAnalysisResult["clauses"];
  }) => Promise<RagAnalysisPipelineResult>;
  pipelineVersion?: string;
  promptVersion?: string;
  citationClient?: SupabaseClient;
  now?: () => string;
}

export type AnalyzeContractVersion = (
  input: AnalyzeContractVersionInput
) => Promise<ContractAnalysisResponse>;

function safeError(
  statusCode: number,
  code: string,
  message: string
): ApiError {
  return new ApiError(statusCode, code, message);
}

function databaseUnavailable(): ApiError {
  return safeError(
    503,
    "DATABASE_UNAVAILABLE",
    "Contract analysis is temporarily unavailable."
  );
}

function persistenceFailed(): ApiError {
  return safeError(
    503,
    "ANALYSIS_PERSISTENCE_FAILED",
    "The analysis result could not be saved safely."
  );
}

function versionNotFound(): ApiError {
  return safeError(404, "VERSION_NOT_FOUND", "The contract version was not found.");
}

function analysisAlreadyRunning(): ApiError {
  return safeError(
    409,
    "ANALYSIS_ALREADY_RUNNING",
    "Analysis is already running for this contract version."
  );
}

function normalizeHistory(value: unknown): Array<Record<string, unknown>> {
  return Array.isArray(value)
    ? value.filter(
        (item): item is Record<string, unknown> =>
          typeof item === "object" && item !== null
      )
    : [];
}

async function verifyOwnership(
  client: SupabaseClient,
  input: AnalyzeContractVersionInput
): Promise<{ contractType: ContractType; extractedText: string }> {
  const { data: contract, error: contractError } = await client
    .from("contracts")
    .select("id, owner_id, contract_type")
    .eq("id", input.contractId)
    .eq("owner_id", input.userId)
    .maybeSingle();

  if (contractError) {
    throw databaseUnavailable();
  }

  if (!contract) {
    throw versionNotFound();
  }

  const { data: version, error: versionError } = await client
    .from("contract_versions")
    .select("id, contract_id, extraction_status, extracted_text")
    .eq("id", input.versionId)
    .eq("contract_id", input.contractId)
    .maybeSingle();

  if (versionError) {
    throw databaseUnavailable();
  }

  if (!version) {
    throw versionNotFound();
  }

  if (version.extraction_status !== "completed") {
    throw safeError(
      422,
      "EXTRACTION_NOT_COMPLETED",
      "Text extraction must complete before analysis."
    );
  }

  if (
    typeof version.extracted_text !== "string" ||
    version.extracted_text.trim().length === 0
  ) {
    throw safeError(
      422,
      "EXTRACTED_TEXT_MISSING",
      "The contract version does not contain extracted text."
    );
  }

  const characterCount = Array.from(version.extracted_text).length;
  const byteCount = Buffer.byteLength(version.extracted_text, "utf8");

  if (
    characterCount > MAX_ANALYSIS_CHARACTERS ||
    byteCount > MAX_ANALYSIS_UTF8_BYTES
  ) {
    throw safeError(
      413,
      "ANALYSIS_INPUT_TOO_LARGE",
      "The extracted contract text exceeds the analysis limits."
    );
  }

  return {
    contractType: contract.contract_type as ContractType,
    extractedText: version.extracted_text
  };
}

async function getAnalysis(
  adminClient: SupabaseClient,
  versionId: string,
  pipelineVersion: string
): Promise<AnalysisRow | null> {
  const { data, error } = await adminClient
    .from("analyses")
    .select(ANALYSIS_COLUMNS)
    .eq("contract_version_id", versionId)
    .eq("pipeline_version", pipelineVersion)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  return data as unknown as AnalysisRow | null;
}

async function createAnalysis(
  adminClient: SupabaseClient,
  userId: string,
  versionId: string,
  timestamp: string,
  pipelineVersion: string,
  promptVersion: string
): Promise<{ analysis: AnalysisRow; created: boolean }> {
  const existing = await getAnalysis(adminClient, versionId, pipelineVersion);

  if (existing) {
    return { analysis: existing, created: false };
  }

  const { data, error } = await adminClient
    .from("analyses")
    .insert({
      contract_version_id: versionId,
      requested_by: userId,
      status: "queued",
      pipeline_version: pipelineVersion,
      model_name: env.OPENAI_MODEL,
      prompt_version: promptVersion,
      retrieval_config: null,
      started_at: null,
      completed_at: null,
      error_message_safe: null,
      status_history: [{ status: "queued", at: timestamp }]
    })
    .select(ANALYSIS_COLUMNS)
    .single();

  if (error) {
    if (error.code === "23505") {
      const conflictedAnalysis = await getAnalysis(
        adminClient,
        versionId,
        pipelineVersion
      );

      if (conflictedAnalysis) {
        return { analysis: conflictedAnalysis, created: false };
      }
    }

    throw databaseUnavailable();
  }

  if (!data) {
    throw databaseUnavailable();
  }

  return { analysis: data as unknown as AnalysisRow, created: true };
}

async function claimAnalysis(
  adminClient: SupabaseClient,
  analysis: AnalysisRow,
  timestamp: string
): Promise<AnalysisRow | null> {
  const statusHistory = [
    ...normalizeHistory(analysis.status_history),
    { status: "analyzing", at: timestamp }
  ];
  const { data, error } = await adminClient
    .from("analyses")
    .update({
      status: "analyzing",
      started_at: timestamp,
      completed_at: null,
      error_message_safe: null,
      status_history: statusHistory
    })
    .eq("id", analysis.id)
    .in("status", ["queued", "failed"])
    .select(ANALYSIS_COLUMNS)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  return data as AnalysisRow | null;
}

function mapPersistedClause(clause: PersistedClause) {
  return {
    position: clause.position,
    clauseType: clause.clause_type,
    findingType: clause.finding_type,
    title: clause.heading,
    originalText: clause.original_text,
    simplifiedText: clause.simplified_text,
    severity: clause.severity,
    favoredParty: clause.favored_party,
    riskExplanation: clause.risk_explanation,
    suggestedAction: clause.suggested_action,
    suggestedRewrite: clause.suggested_rewrite,
    confidence: clause.confidence,
    requiresProfessionalReview: clause.requires_professional_review
  };
}

type PersistedCitationRow = {
  clause_id: string;
  citation_rank: number;
  citation_id: string;
  legal_chunks: {
    law_number?: never;
    article_number: string | null;
    article_title: string | null;
    legal_sources: {
      law_number: "03/L-212" | "04/L-077" | "08/L-142";
      title: string;
      official_url: string;
      official_document_url: string | null;
    };
  };
};

async function loadClauseEvidence(
  citationClient: SupabaseClient,
  analysis: CompletedAnalysisRow,
  clauses: PersistedClause[]
): Promise<Map<string, ClauseEvidence>> {
  if (analysis.pipeline_version !== RAG_ANALYSIS_PIPELINE_VERSION) {
    return new Map(clauses.map((clause) => [
      clause.id,
      { evidenceStatus: "legacy_unverified" as const, citations: [] }
    ]));
  }

  const clauseIds = clauses.map((clause) => clause.id);
  if (clauseIds.length === 0) return new Map();

  const { data, error } = await citationClient
    .from("clause_citations")
    .select(
      "clause_id, citation_rank, citation_id, " +
      "legal_chunks!inner(article_number, article_title, " +
      "legal_sources!inner(law_number, title, official_url, official_document_url))"
    )
    .in("clause_id", clauseIds)
    .order("citation_rank", { ascending: true });

  if (error || !Array.isArray(data)) throw persistenceFailed();

  const grouped = new Map<string, ClauseEvidence>();
  for (const clause of clauses) {
    grouped.set(clause.id, { evidenceStatus: "insufficient_evidence", citations: [] });
  }
  for (const row of data as unknown as PersistedCitationRow[]) {
    const evidence = grouped.get(row.clause_id);
    const source = row.legal_chunks?.legal_sources;
    if (!evidence || !source || !source.official_url.startsWith("https://")) {
      throw persistenceFailed();
    }
    evidence.evidenceStatus = "grounded";
    evidence.citations.push({
      citationId: row.citation_id,
      rank: row.citation_rank,
      lawNumber: source.law_number,
      sourceTitle: source.title,
      articleNumber: row.legal_chunks.article_number,
      articleTitle: row.legal_chunks.article_title,
      officialUrl: source.official_url,
      officialDocumentUrl: source.official_document_url
    });
  }
  for (const [clauseId, evidence] of grouped) {
    grouped.set(clauseId, clauseEvidenceResponseSchema.parse(evidence));
  }
  return grouped;
}

function splitResult(result: ContractAnalysisResult): {
  result: SafeAnalysisResult;
  clauses: ContractAnalysisResult["clauses"];
} {
  const { clauses, ...analysisResult } = result;
  return { result: analysisResult, clauses };
}

export async function buildCompletedAnalysisResponse(
  client: SupabaseClient,
  analysis: CompletedAnalysisRow,
  contractId: string,
  versionId: string,
  citationClient: SupabaseClient = client
): Promise<ContractAnalysisResponse> {
  const { data, error } = await client
    .from("clauses")
    .select(CLAUSE_COLUMNS)
    .eq("analysis_id", analysis.id)
    .order("position", { ascending: true });

  if (error || !analysis.completed_at || !Array.isArray(data)) {
    throw persistenceFailed();
  }

  try {
    const persistedClauses = data as unknown as PersistedClause[];
    const validated = validateContractAnalysisResult({
      ...(analysis.result_json as Record<string, unknown>),
      overallRiskLevel: analysis.overall_risk_level,
      clauses: persistedClauses.map(mapPersistedClause)
    });
    const separated = splitResult(validated);
    const evidenceByClauseId = await loadClauseEvidence(
      citationClient,
      analysis,
      persistedClauses
    );

    return {
      analysisId: analysis.id,
      contractId,
      versionId,
      status: "completed",
      result: separated.result,
      clauses: separated.clauses.map((clause, index) => ({
        ...clause,
        ...(evidenceByClauseId.get(persistedClauses[index]!.id) ?? {
          evidenceStatus: "insufficient_evidence" as const,
          citations: []
        })
      })),
      createdAt: analysis.created_at,
      completedAt: analysis.completed_at
    };
  } catch {
    throw persistenceFailed();
  }
}

function rpcPayload(result: ContractAnalysisResult) {
  const { result: resultJson, clauses } = splitResult(result);
  const { overallRiskLevel, ...storedResult } = resultJson;

  return {
    resultJson: storedResult,
    overallRiskLevel,
    clauses: clauses.map((clause) => ({
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
    }))
  };
}

const safeAdapterCodes = new Set([
  "AI_CONFIGURATION_MISSING",
  "AI_RATE_LIMITED",
  "AI_TIMEOUT",
  "AI_UNAVAILABLE",
  "AI_REFUSED",
  "AI_OUTPUT_INVALID"
]);

function normalizeAdapterError(error: unknown): ApiError {
  if (error instanceof ApiError && safeAdapterCodes.has(error.code)) {
    return error;
  }

  return safeError(503, "AI_UNAVAILABLE", "AI analysis is temporarily unavailable.");
}

async function markAnalysisFailed(
  adminClient: SupabaseClient,
  analysis: AnalysisRow,
  timestamp: string,
  safeFailureCode: string
): Promise<void> {
  try {
    await adminClient
      .from("analyses")
      .update({
        status: "failed",
        completed_at: null,
        error_message_safe: safeFailureCode.slice(0, 500),
        status_history: [
          ...normalizeHistory(analysis.status_history),
          { status: "failed", at: timestamp }
        ]
      })
      .eq("id", analysis.id)
      .eq("status", "analyzing")
      .select("id")
      .maybeSingle();
  } catch {
    // Preserve the original safe adapter or persistence error.
  }
}

export function createAnalyzeContractVersion(
  dependencies: ContractAnalysisServiceDependencies = {}
): AnalyzeContractVersion {
  const adminClient = dependencies.adminClient ?? supabaseAdmin;
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;
  const adapter = dependencies.adapter ?? { analyzeContract };
  const ragPipeline = dependencies.ragPipeline;
  const pipelineVersion = dependencies.pipelineVersion ??
    (ragPipeline ? RAG_ANALYSIS_PIPELINE_VERSION : ANALYSIS_PIPELINE_VERSION);
  const promptVersion = dependencies.promptVersion ??
    (ragPipeline ? RAG_ANALYSIS_PROMPT_VERSION : ANALYSIS_PROMPT_VERSION);
  const citationClient = dependencies.citationClient ?? adminClient;
  const now = dependencies.now ?? (() => new Date().toISOString());

  return async (input) => {
    const userClient = createUserClient(input.accessToken);
    const ownedVersion = await verifyOwnership(userClient, input);
    const initialTimestamp = now();
    const createdAnalysis = await createAnalysis(
      adminClient,
      input.userId,
      input.versionId,
      initialTimestamp,
      pipelineVersion,
      promptVersion
    );
    let analysis = createdAnalysis.analysis;

    if (analysis.status === "completed") {
      return buildCompletedAnalysisResponse(
        adminClient,
        analysis,
        input.contractId,
        input.versionId,
        citationClient
      );
    }

    if (!createdAnalysis.created && analysis.status !== "failed") {
      if (analysis.status === "queued" || analysis.status === "analyzing") {
        throw analysisAlreadyRunning();
      }

      throw databaseUnavailable();
    }

    const claimed = await claimAnalysis(adminClient, analysis, now());

    if (!claimed) {
      const current = await getAnalysis(adminClient, input.versionId, pipelineVersion);

      if (current?.status === "completed") {
        return buildCompletedAnalysisResponse(
          adminClient,
          current,
          input.contractId,
          input.versionId,
          citationClient
        );
      }

      if (current?.status === "queued" || current?.status === "analyzing") {
        throw analysisAlreadyRunning();
      }

      throw databaseUnavailable();
    }

    analysis = claimed;
    let adapterResult: ContractAnalysisResult;

    try {
      adapterResult = await adapter.analyzeContract({
        contractType: ownedVersion.contractType,
        extractedText: ownedVersion.extractedText
      });
    } catch (error) {
      const safeAdapterError = normalizeAdapterError(error);
      await markAnalysisFailed(
        adminClient,
        analysis,
        now(),
        safeAdapterError.code
      );
      throw safeAdapterError;
    }

    let responseClauses: ContractAnalysisResponse["clauses"];
    let clauseEvidence: RagAnalysisPipelineResult["persistence"] | undefined;
    if (ragPipeline) {
      try {
        const grounded = await ragPipeline({
          contractType: ownedVersion.contractType,
          clauses: adapterResult.clauses
        });
        adapterResult = {
          ...adapterResult,
          professionalReviewRecommended:
            adapterResult.professionalReviewRecommended ||
            grounded.clauses.some((clause) => clause.requiresProfessionalReview),
          clauses: grounded.clauses
        };
        responseClauses = grounded.clauses;
        clauseEvidence = grounded.persistence;
      } catch (error) {
        const safeRagError = error instanceof ApiError
          ? error
          : safeError(503, "RAG_UNAVAILABLE", "Legal evidence processing is temporarily unavailable.");
        await markAnalysisFailed(adminClient, analysis, now(), safeRagError.code);
        throw safeRagError;
      }
    } else {
      responseClauses = adapterResult.clauses.map((clause) => ({
        ...clause,
        evidenceStatus: "legacy_unverified",
        citations: []
      }));
    }

    const payload = rpcPayload(adapterResult);
    let completionRows: unknown = null;
    let completionError: unknown = null;

    try {
      const completionResponse = ragPipeline && clauseEvidence
        ? await adminClient.rpc("complete_contract_analysis_with_citations", {
          p_analysis_id: analysis.id,
          p_expected_pipeline_version: pipelineVersion,
          p_result: payload.resultJson,
          p_overall_risk_level: payload.overallRiskLevel,
          p_clauses: payload.clauses,
          p_clause_evidence: clauseEvidence.clause_evidence
        })
        : await adminClient.rpc("complete_contract_analysis", {
          p_analysis_id: analysis.id,
          p_expected_pipeline_version: pipelineVersion,
          p_result: payload.resultJson,
          p_overall_risk_level: payload.overallRiskLevel,
          p_clauses: payload.clauses
        });
      completionRows = completionResponse.data;
      completionError = completionResponse.error;
    } catch {
      completionError = true;
    }

    const completion = (
      Array.isArray(completionRows) ? completionRows[0] : completionRows
    ) as
      | { status?: unknown; completed_at?: unknown }
      | null
      | undefined;

    if (
      completionError ||
      !completion ||
      completion.status !== "completed" ||
      typeof completion.completed_at !== "string"
    ) {
      const safePersistenceError = persistenceFailed();
      await markAnalysisFailed(
        adminClient,
        analysis,
        now(),
        safePersistenceError.code
      );
      throw safePersistenceError;
    }

    const separated = splitResult(adapterResult);

    return {
      analysisId: analysis.id,
      contractId: input.contractId,
      versionId: input.versionId,
      status: "completed",
      result: separated.result,
      clauses: responseClauses,
      createdAt: analysis.created_at,
      completedAt: completion.completed_at
    };
  };
}

let productionRagService: AnalyzeContractVersion | undefined;

export const analyzeContractVersion: AnalyzeContractVersion = async (input) => {
  productionRagService ??= createAnalyzeContractVersion({
    ragPipeline: createProductionRagAnalysisPipeline(),
    pipelineVersion: RAG_ANALYSIS_PIPELINE_VERSION,
    promptVersion: RAG_ANALYSIS_PROMPT_VERSION
  });
  return productionRagService(input);
};
