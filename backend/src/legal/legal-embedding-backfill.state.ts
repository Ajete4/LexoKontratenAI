import type { SupabaseClient } from "@supabase/supabase-js";

import { ApiError } from "../utils/ApiError.js";
import type { LegalEmbeddingBackfillItem } from "./legal-embedding-backfill.js";
import { LEGAL_EMBEDDING_MODEL } from "./legal-embedding-config.js";

export type LegalEmbeddingRemoteState = {
  readonly chunkId: string;
  readonly contentHash: string;
  readonly status: "empty" | "complete";
};

export interface LegalEmbeddingBackfillStateReader {
  load(items: readonly LegalEmbeddingBackfillItem[]): Promise<LegalEmbeddingRemoteState[]>;
}

type StateRow = {
  readonly id: string;
  readonly content_hash: string;
  readonly embedding_model: string | null;
  readonly embedded_at: string | null;
};

type StateQueryResult = {
  readonly data: unknown[] | null;
  readonly error: unknown;
};

const PREFLIGHT_RETRY_DELAYS_MS = [150, 300] as const;

function safeUnavailable(): ApiError {
  return new ApiError(
    503,
    "LEGAL_EMBEDDING_BACKFILL_STATE_UNAVAILABLE",
    "Legal embedding state could not be verified."
  );
}

export function createLegalEmbeddingBackfillStateReader(
  adminClient: SupabaseClient,
  options: {
    readonly sleep?: (milliseconds: number) => Promise<void>;
  } = {}
): LegalEmbeddingBackfillStateReader {
  const sleep =
    options.sleep ??
    ((milliseconds: number) =>
      new Promise<void>((resolve) => setTimeout(resolve, milliseconds)));

  async function queryBatch(ids: readonly string[]): Promise<{
    readonly emptyRows: StateRow[];
    readonly completeRows: StateRow[];
  }> {
    for (let attempt = 0; attempt <= PREFLIGHT_RETRY_DELAYS_MS.length; attempt += 1) {
      const [emptyResult, completeResult] = (await Promise.all([
        adminClient
          .from("legal_chunks")
          .select("id,content_hash,embedding_model,embedded_at")
          .in("id", ids)
          .is("embedding", null),
        adminClient
          .from("legal_chunks")
          .select("id,content_hash,embedding_model,embedded_at")
          .in("id", ids)
          .not("embedding", "is", null)
      ])) as [StateQueryResult, StateQueryResult];

      if (!emptyResult.error && !completeResult.error) {
        return {
          emptyRows: (emptyResult.data ?? []) as StateRow[],
          completeRows: (completeResult.data ?? []) as StateRow[]
        };
      }

      const retryDelay = PREFLIGHT_RETRY_DELAYS_MS[attempt];
      if (retryDelay === undefined) {
        throw safeUnavailable();
      }
      await sleep(retryDelay);
    }

    throw safeUnavailable();
  }

  return {
    async load(items) {
      const states: LegalEmbeddingRemoteState[] = [];

      for (let offset = 0; offset < items.length; offset += 50) {
        const batch = items.slice(offset, offset + 50);
        const ids = batch.map((item) => item.chunkId);
        const { emptyRows, completeRows } = await queryBatch(ids);

        for (const row of emptyRows) {
          if (row.embedding_model !== null || row.embedded_at !== null) {
            throw new ApiError(
              409,
              "LEGAL_EMBEDDING_BACKFILL_PARTIAL_METADATA",
              "Legal embedding metadata is incomplete."
            );
          }
          states.push({
            chunkId: row.id,
            contentHash: row.content_hash,
            status: "empty"
          });
        }

        for (const row of completeRows) {
          if (
            row.embedding_model !== LEGAL_EMBEDDING_MODEL ||
            row.embedded_at === null
          ) {
            throw new ApiError(
              409,
              "LEGAL_EMBEDDING_BACKFILL_PARTIAL_METADATA",
              "Legal embedding metadata is incomplete."
            );
          }
          states.push({
            chunkId: row.id,
            contentHash: row.content_hash,
            status: "complete"
          });
        }
      }

      return states;
    }
  };
}
