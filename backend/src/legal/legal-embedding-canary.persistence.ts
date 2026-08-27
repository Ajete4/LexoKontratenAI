import type { SupabaseClient } from "@supabase/supabase-js";

import { ApiError } from "../utils/ApiError.js";
import type {
  CanaryPersistenceInput,
  LegalEmbeddingCanaryPersistence
} from "./legal-embedding-canary.service.js";

export function createLegalEmbeddingCanaryPersistence(
  adminClient: SupabaseClient
): LegalEmbeddingCanaryPersistence {
  return {
    async persist(input: CanaryPersistenceInput) {
      const { data, error } = await adminClient
        .from("legal_chunks")
        .update({
          embedding: input.embedding,
          embedding_model: input.embeddingModel,
          embedded_at: input.embeddedAt
        })
        .eq("id", input.chunkId)
        .eq("content_hash", input.contentHash)
        .is("embedding", null)
        .is("embedding_model", null)
        .is("embedded_at", null)
        .select("id");

      if (error) {
        throw new ApiError(
          503,
          "LEGAL_EMBEDDING_CANARY_PERSISTENCE_UNAVAILABLE",
          "The canary embedding could not be persisted."
        );
      }

      return { updatedRows: Array.isArray(data) ? data.length : 0 };
    }
  };
}
