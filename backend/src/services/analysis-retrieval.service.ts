import type { SupabaseClient } from "@supabase/supabase-js";

import {
  ANALYSIS_PIPELINE_VERSION,
  RAG_ANALYSIS_PIPELINE_VERSION
} from "../ai/analysis-config.js";
import { createUserSupabaseClient, supabaseAdmin } from "../config/supabase.js";
import {
  buildCompletedAnalysisResponse,
  type CompletedAnalysisRow,
  type ContractAnalysisResponse
} from "./contract-analysis.service.js";
import { ApiError } from "../utils/ApiError.js";

const COMPLETED_ANALYSIS_COLUMNS =
  "id, contract_version_id, status, pipeline_version, model_name, " +
  "prompt_version, result_json, overall_risk_level, created_at, completed_at";

export interface AnalysisRetrievalInput {
  userId: string;
  accessToken: string;
}

export interface GetContractAnalysisInput extends AnalysisRetrievalInput {
  contractId: string;
  versionId: string;
}

export interface GetLatestContractAnalysisInput extends AnalysisRetrievalInput {
  contractId: string;
}

export interface AnalysisRetrievalDependencies {
  createUserClient?: (accessToken: string) => SupabaseClient;
  citationClient?: SupabaseClient;
}

export type GetContractAnalysis = (
  input: GetContractAnalysisInput
) => Promise<ContractAnalysisResponse>;

export type GetLatestAnalysis = (
  input: AnalysisRetrievalInput
) => Promise<ContractAnalysisResponse>;

export type GetLatestContractAnalysis = (
  input: GetLatestContractAnalysisInput
) => Promise<ContractAnalysisResponse>;

function analysisNotFound(): ApiError {
  return new ApiError(
    404,
    "ANALYSIS_NOT_FOUND",
    "A completed contract analysis was not found."
  );
}

function databaseUnavailable(): ApiError {
  return new ApiError(
    503,
    "DATABASE_UNAVAILABLE",
    "Contract analysis is temporarily unavailable."
  );
}

async function findOwnedContract(
  client: SupabaseClient,
  contractId: string,
  userId: string
): Promise<void> {
  const { data, error } = await client
    .from("contracts")
    .select("id")
    .eq("id", contractId)
    .eq("owner_id", userId)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw analysisNotFound();
  }
}

async function findOwnedVersion(
  client: SupabaseClient,
  versionId: string,
  contractId?: string
): Promise<{ id: string; contract_id: string }> {
  let query = client
    .from("contract_versions")
    .select("id, contract_id")
    .eq("id", versionId);

  if (contractId) {
    query = query.eq("contract_id", contractId);
  }

  const { data, error } = await query.maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw analysisNotFound();
  }

  return data as { id: string; contract_id: string };
}

async function ensureContractHasVersion(
  client: SupabaseClient,
  contractId: string
): Promise<void> {
  const { data, error } = await client
    .from("contract_versions")
    .select("id")
    .eq("contract_id", contractId)
    .limit(1)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw analysisNotFound();
  }
}

async function findCompletedAnalysisForVersion(
  client: SupabaseClient,
  versionId: string
): Promise<CompletedAnalysisRow> {
  const { data, error } = await client
    .from("analyses")
    .select(COMPLETED_ANALYSIS_COLUMNS)
    .eq("contract_version_id", versionId)
    .in("pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION])
    .eq("status", "completed")
    .order("completed_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) {
    throw databaseUnavailable();
  }

  if (!data) {
    throw analysisNotFound();
  }

  return data as unknown as CompletedAnalysisRow;
}

export function createGetContractAnalysis(
  dependencies: AnalysisRetrievalDependencies = {}
): GetContractAnalysis {
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;
  const citationClient = dependencies.citationClient ?? supabaseAdmin;

  return async (input) => {
    const client = createUserClient(input.accessToken);

    await findOwnedContract(client, input.contractId, input.userId);
    await findOwnedVersion(client, input.versionId, input.contractId);
    const analysis = await findCompletedAnalysisForVersion(
      client,
      input.versionId
    );

    return buildCompletedAnalysisResponse(
      client,
      analysis,
      input.contractId,
      input.versionId,
      citationClient
    );
  };
}

export function createGetLatestAnalysis(
  dependencies: AnalysisRetrievalDependencies = {}
): GetLatestAnalysis {
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;
  const citationClient = dependencies.citationClient ?? supabaseAdmin;

  return async (input) => {
    const client = createUserClient(input.accessToken);
    const { data, error } = await client
      .from("analyses")
      .select(COMPLETED_ANALYSIS_COLUMNS)
      .eq("requested_by", input.userId)
      .in("pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION])
      .eq("status", "completed")
      .order("completed_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (error) {
      throw databaseUnavailable();
    }

    if (!data) {
      throw analysisNotFound();
    }

    const analysis = data as unknown as CompletedAnalysisRow;
    const version = await findOwnedVersion(
      client,
      analysis.contract_version_id
    );

    return buildCompletedAnalysisResponse(
      client,
      analysis,
      version.contract_id,
      version.id,
      citationClient
    );
  };
}

export function createGetLatestContractAnalysis(
  dependencies: AnalysisRetrievalDependencies = {}
): GetLatestContractAnalysis {
  const createUserClient =
    dependencies.createUserClient ?? createUserSupabaseClient;
  const citationClient = dependencies.citationClient ?? supabaseAdmin;

  return async (input) => {
    const client = createUserClient(input.accessToken);

    await findOwnedContract(client, input.contractId, input.userId);
    await ensureContractHasVersion(client, input.contractId);

    const { data, error } = await client
      .from("analyses")
      .select(
        `${COMPLETED_ANALYSIS_COLUMNS}, contract_versions!inner(contract_id)`
      )
      .eq("contract_versions.contract_id", input.contractId)
      .in("pipeline_version", [RAG_ANALYSIS_PIPELINE_VERSION, ANALYSIS_PIPELINE_VERSION])
      .eq("status", "completed")
      .order("completed_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (error) {
      throw databaseUnavailable();
    }

    if (!data) {
      throw analysisNotFound();
    }

    const analysis = data as unknown as CompletedAnalysisRow;

    return buildCompletedAnalysisResponse(
      client,
      analysis,
      input.contractId,
      analysis.contract_version_id,
      citationClient
    );
  };
}

export const getContractAnalysis = createGetContractAnalysis();
export const getLatestAnalysis = createGetLatestAnalysis();
export const getLatestContractAnalysis = createGetLatestContractAnalysis();
