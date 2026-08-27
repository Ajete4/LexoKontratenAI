import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import {
  ANALYSIS_PIPELINE_VERSION,
  RAG_ANALYSIS_PIPELINE_VERSION
} from "../ai/analysis-config.js";
import { createUserSupabaseClient } from "../config/supabase.js";
import type {
  ContractStatus,
  ContractType,
  CreateContractInput,
  ListContractsQuery
} from "../schemas/contracts.schema.js";
import type { AuthenticatedUser } from "../types/api.js";
import { ApiError } from "../utils/ApiError.js";

export type ContractMetadata = {
  id: string;
  owner_id: string;
  title: string;
  contract_type: ContractType;
  status: ContractStatus;
  created_at: string;
  updated_at: string;
};

export type ContractLatestCompletedAnalysis = {
  id: string;
  versionId: string;
  overallRisk: "low" | "medium" | "high" | "critical" | "unknown";
  completedAt: string;
};

export type ContractListItem = ContractMetadata & {
  latestCompletedAnalysis: ContractLatestCompletedAnalysis | null;
};

export type ListContracts = (
  authenticatedUser: AuthenticatedUser,
  query: ListContractsQuery
) => Promise<ContractListItem[]>;

export type CreateContract = (
  authenticatedUser: AuthenticatedUser,
  input: CreateContractInput
) => Promise<ContractMetadata>;

export type UserSupabaseClientFactory = (
  accessToken: string
) => SupabaseClient;

function escapeLikePattern(value: string): string {
  return value.replace(/[\\%_]/g, "\\$&");
}

const contractMetadataSchema = z
  .object({
    id: z.string().uuid(),
    owner_id: z.string().min(1),
    title: z.string().min(1).max(200),
    contract_type: z.enum(["service", "employment", "lease"]),
    status: z.enum([
      "draft",
      "uploaded",
      "processing",
      "analyzed",
      "failed",
      "archived"
    ]),
    created_at: z.string().datetime({ offset: true }),
    updated_at: z.string().datetime({ offset: true })
  })
  .strict();

const analysisRowSchema = z
  .object({
    id: z.string().uuid(),
    contract_version_id: z.string().uuid(),
    overall_risk_level: z.enum([
      "low",
      "medium",
      "high",
      "critical",
      "unknown"
    ]),
    completed_at: z.string().datetime({ offset: true }),
    contract_versions: z
      .object({
        contract_id: z.string().uuid(),
        contracts: z.object({ owner_id: z.string().min(1) }).strict()
      })
      .strict()
  })
  .strict();

const contractListItemSchema = contractMetadataSchema
  .extend({
    latestCompletedAnalysis: z
      .object({
        id: z.string().uuid(),
        versionId: z.string().uuid(),
        overallRisk: z.enum([
          "low",
          "medium",
          "high",
          "critical",
          "unknown"
        ]),
        completedAt: z.string().datetime({ offset: true })
      })
      .strict()
      .nullable()
  })
  .strict();

function databaseUnavailable(): ApiError {
  return new ApiError(
    503,
    "DATABASE_UNAVAILABLE",
    "Contracts are temporarily unavailable."
  );
}

function contractDataInvalid(): ApiError {
  return new ApiError(
    503,
    "CONTRACT_DATA_INVALID",
    "Contracts are temporarily unavailable."
  );
}

export function createListContracts(
  createClient: UserSupabaseClientFactory = createUserSupabaseClient
): ListContracts {
  return async (authenticatedUser, filters) => {
    const supabase = createClient(authenticatedUser.accessToken);
    let databaseQuery = supabase
      .from("contracts")
      .select(
        "id, owner_id, title, contract_type, status, created_at, updated_at"
      )
      .eq("owner_id", authenticatedUser.userId)
      .order("created_at", { ascending: false })
      .limit(filters.limit);

    if (filters.status) {
      databaseQuery = databaseQuery.eq("status", filters.status);
    }

    if (filters.contractType) {
      databaseQuery = databaseQuery.eq(
        "contract_type",
        filters.contractType
      );
    }

    if (filters.search) {
      databaseQuery = databaseQuery.ilike(
        "title",
        `%${escapeLikePattern(filters.search)}%`
      );
    }

    const { data, error } = await databaseQuery;

    if (error) {
      throw databaseUnavailable();
    }

    const contractsResult = z.array(contractMetadataSchema).safeParse(data ?? []);

    if (!contractsResult.success) {
      throw contractDataInvalid();
    }

    const contracts = contractsResult.data;

    if (contracts.length === 0) {
      return [];
    }

    const contractIds = contracts.map((contract) => contract.id);
    const analysesResult = await supabase
      .from("analyses")
      .select(
        "id, contract_version_id, overall_risk_level, completed_at, " +
          "contract_versions!inner(contract_id, contracts!inner(owner_id))"
      )
      .eq("requested_by", authenticatedUser.userId)
      .eq("status", "completed")
      .in("pipeline_version", [
        RAG_ANALYSIS_PIPELINE_VERSION,
        ANALYSIS_PIPELINE_VERSION
      ])
      .in("contract_versions.contract_id", contractIds)
      .eq(
        "contract_versions.contracts.owner_id",
        authenticatedUser.userId
      )
      .order("completed_at", { ascending: false });

    if (analysesResult.error) {
      throw databaseUnavailable();
    }

    const validatedAnalyses = z
      .array(analysisRowSchema)
      .safeParse(analysesResult.data ?? []);

    if (!validatedAnalyses.success) {
      throw contractDataInvalid();
    }

    const latestAnalysisByContract = new Map<
      string,
      ContractLatestCompletedAnalysis
    >();

    for (const analysis of validatedAnalyses.data) {
      const contractId = analysis.contract_versions.contract_id;

      if (!latestAnalysisByContract.has(contractId)) {
        latestAnalysisByContract.set(contractId, {
          id: analysis.id,
          versionId: analysis.contract_version_id,
          overallRisk: analysis.overall_risk_level,
          completedAt: analysis.completed_at
        });
      }
    }

    const enrichedContracts = contracts.map((contract) => ({
      ...contract,
      latestCompletedAnalysis: latestAnalysisByContract.get(contract.id) ?? null
    }));
    const validatedResponse = z
      .array(contractListItemSchema)
      .safeParse(enrichedContracts);

    if (!validatedResponse.success) {
      throw contractDataInvalid();
    }

    return validatedResponse.data;
  };
}

export const listContracts = createListContracts();

export function createCreateContract(
  createClient: UserSupabaseClientFactory = createUserSupabaseClient
): CreateContract {
  return async (authenticatedUser, input) => {
    const supabase = createClient(authenticatedUser.accessToken);
    const { data, error } = await supabase
      .from("contracts")
      .insert({
        owner_id: authenticatedUser.userId,
        title: input.title,
        contract_type: input.contractType
      })
      .select(
        "id, owner_id, title, contract_type, status, created_at, updated_at"
      )
      .single();

    if (error || !data) {
      throw new ApiError(
        503,
        "DATABASE_UNAVAILABLE",
        "The contract could not be created at this time."
      );
    }

    return data as ContractMetadata;
  };
}

export const createContract = createCreateContract();
