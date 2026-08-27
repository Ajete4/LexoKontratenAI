import { ApiError } from "../utils/ApiError.js";
import type { LegalEmbeddingAdapter } from "./legal-embedding-adapter.js";
import type { LegalEmbeddingBackfill } from "./legal-embedding-backfill.js";
import type { LegalEmbeddingBackfillStateReader } from "./legal-embedding-backfill.state.js";
import type { LegalEmbeddingCanaryPersistence } from "./legal-embedding-canary.service.js";
import {
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MODEL
} from "./legal-embedding-config.js";

export type LegalEmbeddingBackfillCheckpoint = {
  readonly totalCandidates: 1_165;
  readonly completedCandidates: number;
  readonly skippedExisting: number;
  readonly lastCompletedBatch: number;
  readonly batchStatuses: readonly {
    readonly batchNumber: number;
    readonly batchHash: string;
    readonly status: "completed" | "skipped" | "pending";
    readonly persistedCount: number;
  }[];
};

export interface LegalEmbeddingBackfillCheckpointWriter {
  write(checkpoint: LegalEmbeddingBackfillCheckpoint): Promise<void>;
}

function fail(code: string, message: string): never {
  throw new ApiError(409, code, message);
}

export function createLegalEmbeddingBackfillExecutor(dependencies: {
  readonly adapter: LegalEmbeddingAdapter;
  readonly stateReader: LegalEmbeddingBackfillStateReader;
  readonly persistence: LegalEmbeddingCanaryPersistence;
  readonly checkpointWriter: LegalEmbeddingBackfillCheckpointWriter;
  readonly now?: () => Date;
}) {
  let executed = false;

  return async (backfill: LegalEmbeddingBackfill): Promise<void> => {
    if (executed) {
      fail(
        "LEGAL_EMBEDDING_BACKFILL_ALREADY_EXECUTED",
        "The backfill executor accepts only one attempt."
      );
    }
    executed = true;

    const states = await dependencies.stateReader.load(backfill.allItems);
    const stateById = new Map(states.map((state) => [state.chunkId, state]));

    if (states.length !== 1_166 || stateById.size !== 1_166) {
      fail(
        "LEGAL_EMBEDDING_BACKFILL_REMOTE_STATE_INVALID",
        "Legal embedding state does not match the approved corpus."
      );
    }

    for (const item of backfill.allItems) {
      const state = stateById.get(item.chunkId);
      if (state === undefined || state.contentHash !== item.contentHash) {
        fail(
          "LEGAL_EMBEDDING_BACKFILL_REMOTE_STATE_INVALID",
          "Legal embedding state does not match the approved corpus."
        );
      }
    }

    if (stateById.get(backfill.canaryChunkId)?.status !== "complete") {
      fail(
        "LEGAL_EMBEDDING_BACKFILL_CANARY_STATE_INVALID",
        "The approved canary embedding is not complete."
      );
    }

    const statuses: LegalEmbeddingBackfillCheckpoint["batchStatuses"][number][] =
      backfill.plan.batches.map((batch) => ({
        batchNumber: batch.batchNumber,
        batchHash: batch.batchHash,
        status: "pending",
        persistedCount: 0
      }));
    let completedCandidates = 0;
    let skippedExisting = 0;

    for (const [batchIndex, batch] of backfill.candidateBatches.entries()) {
      const candidates = batch.filter(
        (item) => stateById.get(item.chunkId)?.status === "empty"
      );
      const skippedInBatch = batch.length - candidates.length;
      skippedExisting += skippedInBatch;

      if (candidates.length > 0) {
        const output = await dependencies.adapter.embedLegalChunks({
          items: candidates.map((item) => ({
            chunkId: item.chunkId,
            content: item.content
          }))
        });

        if (output.length !== candidates.length) {
          fail(
            "LEGAL_EMBEDDING_OUTPUT_INVALID",
            "Legal embedding generation returned an invalid result."
          );
        }

        for (const [outputIndex, result] of output.entries()) {
          const item = candidates[outputIndex];
          if (
            item === undefined ||
            result.chunkId !== item.chunkId ||
            result.embedding.length !== LEGAL_EMBEDDING_DIMENSIONS ||
            !result.embedding.every(Number.isFinite)
          ) {
            fail(
              "LEGAL_EMBEDDING_OUTPUT_INVALID",
              "Legal embedding generation returned an invalid result."
            );
          }
        }

        for (const [outputIndex, result] of output.entries()) {
          const item = candidates[outputIndex]!;
          const persisted = await dependencies.persistence.persist({
            chunkId: item.chunkId,
            contentHash: item.contentHash,
            embedding: result.embedding,
            embeddingModel: LEGAL_EMBEDDING_MODEL,
            embeddedAt: (dependencies.now ?? (() => new Date()))().toISOString()
          });
          if (persisted.updatedRows !== 1) {
            fail(
              "LEGAL_EMBEDDING_BACKFILL_PERSISTENCE_CONFLICT",
              "A legal embedding could not be persisted safely."
            );
          }
          completedCandidates += 1;
        }
      }

      statuses[batchIndex] = {
        batchNumber: batchIndex + 1,
        batchHash: backfill.plan.batches[batchIndex]!.batchHash,
        status: candidates.length === 0 ? "skipped" : "completed",
        persistedCount: candidates.length
      };
      await dependencies.checkpointWriter.write({
        totalCandidates: 1_165,
        completedCandidates,
        skippedExisting,
        lastCompletedBatch: batchIndex + 1,
        batchStatuses: statuses
      });
    }
  };
}
