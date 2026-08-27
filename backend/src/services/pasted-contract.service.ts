import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import { createUserSupabaseClient } from "../config/supabase.js";
import type { CreatePastedContractInput } from "../schemas/pasted-contract.schema.js";
import type { AuthenticatedUser } from "../types/api.js";
import { ApiError } from "../utils/ApiError.js";

const pastedContractRpcRowSchema = z
  .object({
    contract_id: z.string().uuid(),
    version_id: z.string().uuid(),
    version_number: z.literal(1),
    source_kind: z.literal("pasted"),
    extraction_status: z.literal("completed"),
    page_count: z.null(),
    created_at: z.string().datetime({ offset: true })
  })
  .strict();

export type PastedContractResult = {
  contractId: string;
  version: {
    id: string;
    versionNumber: 1;
    sourceKind: "pasted";
    extractionStatus: "completed";
    pageCount: null;
    createdAt: string;
  };
};

export type CreatePastedContract = (
  authenticatedUser: AuthenticatedUser,
  input: CreatePastedContractInput
) => Promise<PastedContractResult>;

type UserSupabaseClientFactory = (accessToken: string) => SupabaseClient;

function databaseUnavailable(): ApiError {
  return new ApiError(
    503,
    "DATABASE_UNAVAILABLE",
    "The contract could not be created at this time."
  );
}

function rpcResponseInvalid(): ApiError {
  return new ApiError(
    503,
    "PASTED_CONTRACT_RESPONSE_INVALID",
    "The contract could not be created at this time."
  );
}

export function createCreatePastedContract(
  createClient: UserSupabaseClientFactory = createUserSupabaseClient
): CreatePastedContract {
  return async (authenticatedUser, input) => {
    const supabase = createClient(authenticatedUser.accessToken);
    const { data, error } = await supabase.rpc("create_pasted_contract", {
      p_title: input.title,
      p_contract_type: input.contractType,
      p_text: input.text
    });

    if (error) {
      throw databaseUnavailable();
    }

    const result = z.array(pastedContractRpcRowSchema).length(1).safeParse(data);

    if (!result.success) {
      throw rpcResponseInvalid();
    }

    const row = result.data[0]!;

    return {
      contractId: row.contract_id,
      version: {
        id: row.version_id,
        versionNumber: row.version_number,
        sourceKind: row.source_kind,
        extractionStatus: row.extraction_status,
        pageCount: row.page_count,
        createdAt: row.created_at
      }
    };
  };
}

export const createPastedContract = createCreatePastedContract();
