import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import { createUserSupabaseClient } from "../config/supabase.js";
import { ApiError } from "../utils/ApiError.js";

const notesRowSchema = z
  .object({
    contract_id: z.string().uuid(),
    version_id: z.string().uuid(),
    notes: z.string().max(10_000),
    checklist: z.array(z.boolean()).length(6),
    updated_at: z.string().datetime({ offset: true })
  })
  .strict();

export type ContractNotes = {
  contractId: string;
  versionId: string;
  notes: string;
  checklist: boolean[];
  updatedAt: string;
};

type ContractNotesContext = {
  userId: string;
  accessToken: string;
  contractId: string;
  versionId: string;
};

export type GetContractNotes = (
  input: ContractNotesContext
) => Promise<ContractNotes | null>;

export type SaveContractNotes = (
  input: ContractNotesContext & { notes: string; checklist: boolean[] }
) => Promise<ContractNotes>;

function unavailable(): ApiError {
  return new ApiError(
    503,
    "CONTRACT_NOTES_UNAVAILABLE",
    "Shënimet nuk janë të disponueshme për momentin."
  );
}

function contextNotFound(): ApiError {
  return new ApiError(
    404,
    "CONTRACT_NOTES_CONTEXT_NOT_FOUND",
    "Kontrata aktive nuk u gjet."
  );
}

async function assertOwnedContext(
  client: SupabaseClient,
  input: ContractNotesContext
): Promise<void> {
  const contractResult = await client
    .from("contracts")
    .select("id")
    .eq("id", input.contractId)
    .eq("owner_id", input.userId)
    .maybeSingle();

  if (contractResult.error) {
    throw unavailable();
  }

  if (!contractResult.data) {
    throw contextNotFound();
  }

  const versionResult = await client
    .from("contract_versions")
    .select("id")
    .eq("id", input.versionId)
    .eq("contract_id", input.contractId)
    .maybeSingle();

  if (versionResult.error) {
    throw unavailable();
  }

  if (!versionResult.data) {
    throw contextNotFound();
  }
}

function mapRow(value: unknown): ContractNotes {
  const parsed = notesRowSchema.safeParse(value);

  if (!parsed.success) {
    throw unavailable();
  }

  return {
    contractId: parsed.data.contract_id,
    versionId: parsed.data.version_id,
    notes: parsed.data.notes,
    checklist: parsed.data.checklist,
    updatedAt: parsed.data.updated_at
  };
}

export function createGetContractNotes(
  createClient: (accessToken: string) => SupabaseClient = createUserSupabaseClient
): GetContractNotes {
  return async (input) => {
    const client = createClient(input.accessToken);
    await assertOwnedContext(client, input);

    const result = await client
      .from("contract_notes_checklists")
      .select("contract_id, version_id, notes, checklist, updated_at")
      .eq("user_id", input.userId)
      .eq("contract_id", input.contractId)
      .eq("version_id", input.versionId)
      .maybeSingle();

    if (result.error) {
      throw unavailable();
    }

    return result.data ? mapRow(result.data) : null;
  };
}

export function createSaveContractNotes(
  createClient: (accessToken: string) => SupabaseClient = createUserSupabaseClient
): SaveContractNotes {
  return async (input) => {
    const client = createClient(input.accessToken);
    await assertOwnedContext(client, input);

    const result = await client
      .from("contract_notes_checklists")
      .upsert(
        {
          user_id: input.userId,
          contract_id: input.contractId,
          version_id: input.versionId,
          notes: input.notes,
          checklist: input.checklist
        },
        { onConflict: "user_id,contract_id,version_id" }
      )
      .select("contract_id, version_id, notes, checklist, updated_at")
      .single();

    if (result.error) {
      throw unavailable();
    }

    return mapRow(result.data);
  };
}

export const getContractNotes = createGetContractNotes();
export const saveContractNotes = createSaveContractNotes();
