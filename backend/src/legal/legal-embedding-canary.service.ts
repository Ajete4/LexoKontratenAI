import { ApiError } from "../utils/ApiError.js";
import type { LegalEmbeddingAdapter } from "./legal-embedding-adapter.js";
import type { LegalEmbeddingCanary } from "./legal-embedding-canary.js";
import {
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MODEL
} from "./legal-embedding-config.js";

export type CanaryPersistenceInput = {
  readonly chunkId: string;
  readonly contentHash: string;
  readonly embedding: readonly number[];
  readonly embeddingModel: typeof LEGAL_EMBEDDING_MODEL;
  readonly embeddedAt: string;
};

export interface LegalEmbeddingCanaryPersistence {
  persist(input: CanaryPersistenceInput): Promise<{ readonly updatedRows: number }>;
}

export type LegalEmbeddingCanaryExecutionResult = {
  readonly chunkId: string;
  readonly contentHash: string;
  readonly model: typeof LEGAL_EMBEDDING_MODEL;
  readonly dimensions: typeof LEGAL_EMBEDDING_DIMENSIONS;
  readonly persistedRows: 1;
};

export function createLegalEmbeddingCanaryExecutor(dependencies: {
  readonly adapter: LegalEmbeddingAdapter;
  readonly persistence: LegalEmbeddingCanaryPersistence;
  readonly now?: () => Date;
}) {
  let executed = false;

  return async (
    canary: LegalEmbeddingCanary
  ): Promise<LegalEmbeddingCanaryExecutionResult> => {
    if (executed) {
      throw new ApiError(
        409,
        "LEGAL_EMBEDDING_CANARY_ALREADY_EXECUTED",
        "The canary executor accepts only one attempt."
      );
    }

    executed = true;
    const output = await dependencies.adapter.embedLegalChunks({
      items: [{ chunkId: canary.plan.chunkId, content: canary.content }]
    });
    const result = output[0];

    if (
      output.length !== 1 ||
      result === undefined ||
      result.chunkId !== canary.plan.chunkId ||
      result.embedding.length !== LEGAL_EMBEDDING_DIMENSIONS ||
      !result.embedding.every(Number.isFinite)
    ) {
      throw new ApiError(
        502,
        "LEGAL_EMBEDDING_OUTPUT_INVALID",
        "Legal embedding generation returned an invalid result."
      );
    }

    const persistenceResult = await dependencies.persistence.persist({
      chunkId: canary.plan.chunkId,
      contentHash: canary.plan.contentHash,
      embedding: result.embedding,
      embeddingModel: LEGAL_EMBEDDING_MODEL,
      embeddedAt: (dependencies.now ?? (() => new Date()))().toISOString()
    });

    if (persistenceResult.updatedRows !== 1) {
      throw new ApiError(
        409,
        "LEGAL_EMBEDDING_CANARY_PERSISTENCE_CONFLICT",
        "The canary embedding was not persisted."
      );
    }

    return {
      chunkId: canary.plan.chunkId,
      contentHash: canary.plan.contentHash,
      model: LEGAL_EMBEDDING_MODEL,
      dimensions: LEGAL_EMBEDDING_DIMENSIONS,
      persistedRows: 1
    };
  };
}
