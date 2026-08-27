import { createHash } from "node:crypto";

import type { LegalChunk } from "./legal-chunker.js";
import {
  LEGAL_EMBEDDING_BATCH_SIZE,
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MODEL,
  LEGAL_EMBEDDING_PIPELINE_VERSION
} from "./legal-embedding-config.js";

export type LegalEmbeddingPlanSource = {
  readonly lawNumber: string;
  readonly expectedChunkCount: number;
  readonly chunks: readonly LegalChunk[];
};

export type LegalEmbeddingPlan = {
  readonly model: typeof LEGAL_EMBEDDING_MODEL;
  readonly dimensions: typeof LEGAL_EMBEDDING_DIMENSIONS;
  readonly pipelineVersion: typeof LEGAL_EMBEDDING_PIPELINE_VERSION;
  readonly totalChunks: number;
  readonly batchSize: number;
  readonly batchCount: number;
  readonly countsByLawNumber: Readonly<Record<string, number>>;
  readonly batches: readonly {
    readonly batchNumber: number;
    readonly itemCount: number;
    readonly characterCount: number;
    readonly utf8ByteCount: number;
    readonly items: readonly {
      readonly lawNumber: string;
      readonly chunkIndex: number;
      readonly contentHash: string;
      readonly characterCount: number;
      readonly utf8ByteCount: number;
    }[];
  }[];
  readonly warnings: readonly string[];
};

const EXPECTED_COUNTS = {
  "03/L-212": 100,
  "04/L-077": 1_059,
  "08/L-142": 7
} as const;

function contentHash(content: string): string {
  return createHash("sha256").update(content, "utf8").digest("hex");
}

export function createLegalEmbeddingPlan(
  sources: readonly LegalEmbeddingPlanSource[]
): LegalEmbeddingPlan {
  if (
    sources.length !== 3 ||
    sources.some(
      (source, sourceIndex) =>
        source.lawNumber !== Object.keys(EXPECTED_COUNTS)[sourceIndex] ||
        source.expectedChunkCount !==
          EXPECTED_COUNTS[source.lawNumber as keyof typeof EXPECTED_COUNTS] ||
        source.chunks.length !== source.expectedChunkCount
    )
  ) {
    throw new Error("LEGAL_EMBEDDING_PLAN_SOURCE_GATE_FAILED");
  }

  const ordered = sources.flatMap((source) =>
    [...source.chunks]
      .sort((left, right) => left.chunkIndex - right.chunkIndex)
      .map((chunk, index) => {
        if (
          chunk.lawNumber !== source.lawNumber ||
          chunk.chunkIndex !== index ||
          chunk.content.trim().length === 0 ||
          contentHash(chunk.content) !== chunk.contentSha256
        ) {
          throw new Error("LEGAL_EMBEDDING_PLAN_CHUNK_GATE_FAILED");
        }

        return chunk;
      })
  );

  if (ordered.length !== 1_166) {
    throw new Error("LEGAL_EMBEDDING_PLAN_TOTAL_GATE_FAILED");
  }

  const batches = Array.from(
    { length: Math.ceil(ordered.length / LEGAL_EMBEDDING_BATCH_SIZE) },
    (_, index) => {
      const batchChunks = ordered.slice(
        index * LEGAL_EMBEDDING_BATCH_SIZE,
        (index + 1) * LEGAL_EMBEDDING_BATCH_SIZE
      );
      const items = batchChunks.map((chunk) => ({
        lawNumber: chunk.lawNumber,
        chunkIndex: chunk.chunkIndex,
        contentHash: chunk.contentSha256,
        characterCount: chunk.content.length,
        utf8ByteCount: Buffer.byteLength(chunk.content, "utf8")
      }));

      return {
        batchNumber: index + 1,
        itemCount: items.length,
        characterCount: items.reduce(
          (total, item) => total + item.characterCount,
          0
        ),
        utf8ByteCount: items.reduce(
          (total, item) => total + item.utf8ByteCount,
          0
        ),
        items
      };
    }
  );

  return {
    model: LEGAL_EMBEDDING_MODEL,
    dimensions: LEGAL_EMBEDDING_DIMENSIONS,
    pipelineVersion: LEGAL_EMBEDDING_PIPELINE_VERSION,
    totalChunks: ordered.length,
    batchSize: LEGAL_EMBEDDING_BATCH_SIZE,
    batchCount: batches.length,
    countsByLawNumber: EXPECTED_COUNTS,
    batches,
    warnings: [
      "Dry run only: local artifacts do not contain database chunk UUIDs.",
      "No token count or monetary estimate is produced."
    ]
  };
}
