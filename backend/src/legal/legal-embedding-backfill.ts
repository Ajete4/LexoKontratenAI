import { createHash } from "node:crypto";

import type { LegalChunk } from "./legal-chunker.js";
import type { LegalChunkRemoteMapping } from "./legal-chunk-remote-mapping.js";
import type { LegalEmbeddingCanaryPlan } from "./legal-embedding-canary.js";
import {
  LEGAL_EMBEDDING_BATCH_SIZE,
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MODEL,
  LEGAL_EMBEDDING_PIPELINE_VERSION
} from "./legal-embedding-config.js";

const SOURCE_ORDER = ["03/L-212", "04/L-077", "08/L-142"] as const;
const EXPECTED_COUNTS = [100, 1_059, 7] as const;

export type LegalEmbeddingBackfillItem = {
  readonly chunkId: string;
  readonly contentHash: string;
  readonly lawNumber: string;
  readonly chunkIndex: number;
  readonly content: string;
};

export type LegalEmbeddingBackfill = {
  readonly plan: {
    readonly totalChunks: 1_166;
    readonly existingCanaryChunks: 1;
    readonly candidateChunks: 1_165;
    readonly batchSize: 50;
    readonly batchCount: 24;
    readonly model: typeof LEGAL_EMBEDDING_MODEL;
    readonly dimensions: typeof LEGAL_EMBEDDING_DIMENSIONS;
    readonly pipelineVersion: typeof LEGAL_EMBEDDING_PIPELINE_VERSION;
    readonly countsByLawNumber: Readonly<Record<string, number>>;
    readonly batches: readonly {
      readonly batchNumber: number;
      readonly itemCount: number;
      readonly batchHash: string;
      readonly status: "pending";
    }[];
  };
  readonly canaryChunkId: string;
  readonly allItems: readonly LegalEmbeddingBackfillItem[];
  readonly candidateBatches: readonly (readonly LegalEmbeddingBackfillItem[])[];
};

function sha256(value: string): string {
  return createHash("sha256").update(value, "utf8").digest("hex");
}

export function createLegalEmbeddingBackfill(input: {
  readonly mapping: LegalChunkRemoteMapping;
  readonly sources: readonly {
    readonly lawNumber: string;
    readonly chunks: readonly LegalChunk[];
  }[];
  readonly canary: LegalEmbeddingCanaryPlan;
}): LegalEmbeddingBackfill {
  if (
    input.mapping.totalChunks !== 1_166 ||
    input.sources.length !== SOURCE_ORDER.length
  ) {
    throw new Error("LEGAL_EMBEDDING_BACKFILL_SOURCE_INVALID");
  }

  const allItems: LegalEmbeddingBackfillItem[] = [];

  for (const [sourceIndex, lawNumber] of SOURCE_ORDER.entries()) {
    const source = input.sources[sourceIndex];

    if (
      source?.lawNumber !== lawNumber ||
      source.chunks.length !== EXPECTED_COUNTS[sourceIndex]
    ) {
      throw new Error("LEGAL_EMBEDDING_BACKFILL_SOURCE_INVALID");
    }

    for (const [chunkIndex, chunk] of source.chunks.entries()) {
      const remote = input.mapping.chunks.find(
        (item) =>
          item.lawNumber === lawNumber &&
          item.chunkIndex === chunkIndex &&
          item.contentHash === chunk.contentSha256
      );

      if (
        chunk.chunkIndex !== chunkIndex ||
        chunk.lawNumber !== lawNumber ||
        chunk.content.trim().length === 0 ||
        sha256(chunk.content) !== chunk.contentSha256 ||
        remote === undefined
      ) {
        throw new Error("LEGAL_EMBEDDING_BACKFILL_MAPPING_INVALID");
      }

      allItems.push({
        chunkId: remote.chunkId,
        contentHash: remote.contentHash,
        lawNumber,
        chunkIndex,
        content: chunk.content
      });
    }
  }

  const canaryMatches = allItems.filter(
    (item) =>
      item.chunkId === input.canary.chunkId &&
      item.contentHash === input.canary.contentHash &&
      item.lawNumber === input.canary.lawNumber &&
      item.chunkIndex === input.canary.chunkIndex
  );
  const uniqueIds = new Set(allItems.map((item) => item.chunkId));
  const uniqueHashes = new Set(allItems.map((item) => item.contentHash));

  if (
    allItems.length !== 1_166 ||
    canaryMatches.length !== 1 ||
    uniqueIds.size !== 1_166 ||
    uniqueHashes.size !== 1_166
  ) {
    throw new Error("LEGAL_EMBEDDING_BACKFILL_CANARY_INVALID");
  }

  const candidates = allItems.filter(
    (item) => item.chunkId !== input.canary.chunkId
  );
  const candidateBatches = Array.from(
    { length: Math.ceil(candidates.length / LEGAL_EMBEDDING_BATCH_SIZE) },
    (_, index) =>
      candidates.slice(
        index * LEGAL_EMBEDDING_BATCH_SIZE,
        (index + 1) * LEGAL_EMBEDDING_BATCH_SIZE
      )
  );

  if (
    candidates.length !== 1_165 ||
    candidateBatches.length !== 24 ||
    candidateBatches.some((batch) => batch.length > 50)
  ) {
    throw new Error("LEGAL_EMBEDDING_BACKFILL_BATCH_INVALID");
  }

  return {
    plan: {
      totalChunks: 1_166,
      existingCanaryChunks: 1,
      candidateChunks: 1_165,
      batchSize: 50,
      batchCount: 24,
      model: LEGAL_EMBEDDING_MODEL,
      dimensions: LEGAL_EMBEDDING_DIMENSIONS,
      pipelineVersion: LEGAL_EMBEDDING_PIPELINE_VERSION,
      countsByLawNumber: {
        "03/L-212": 99,
        "04/L-077": 1_059,
        "08/L-142": 7
      },
      batches: candidateBatches.map((batch, index) => ({
        batchNumber: index + 1,
        itemCount: batch.length,
        batchHash: sha256(batch.map((item) => item.contentHash).join("|")),
        status: "pending"
      }))
    },
    canaryChunkId: input.canary.chunkId,
    allItems,
    candidateBatches
  };
}

export function renderLegalEmbeddingBackfillPostflightSql(): string {
  return `-- Read-only postflight for the complete P0 embedding corpus.
select
  count(*)::integer as total_chunks,
  count(*) filter (where embedding is not null)::integer as embedded_chunks,
  count(*) filter (where embedding is null)::integer as null_embeddings,
  count(*) filter (
    where (embedding is null) <> (embedding_model is null)
       or (embedding is null) <> (embedded_at is null)
  )::integer as partial_metadata_rows,
  count(*) filter (
    where embedding_model is not null
      and embedding_model <> 'text-embedding-3-small'
  )::integer as invalid_model_rows,
  count(*) filter (
    where embedding is not null
      and extensions.vector_dims(embedding) <> 1536
  )::integer as invalid_dimension_rows,
  count(distinct content_hash)::integer as unique_content_hashes
from public.legal_chunks;

select
  source.law_number,
  count(*)::integer as total_chunks,
  count(*) filter (where chunks.embedding is not null)::integer as embedded_chunks
from public.legal_chunks as chunks
join public.legal_sources as source on source.id = chunks.legal_source_id
where source.law_number in ('03/L-212', '04/L-077', '08/L-142')
group by source.law_number
order by source.law_number;

select relrowsecurity as rls_enabled
from pg_catalog.pg_class
where oid = 'public.legal_chunks'::regclass;

select
  pg_catalog.has_table_privilege('anon', 'public.legal_chunks', 'SELECT') as anon_select,
  pg_catalog.has_table_privilege('authenticated', 'public.legal_chunks', 'SELECT') as authenticated_select,
  pg_catalog.has_table_privilege('service_role', 'public.legal_chunks', 'SELECT') as service_role_select,
  pg_catalog.has_table_privilege('service_role', 'public.legal_chunks', 'UPDATE') as service_role_update;

select indexname, indexdef
from pg_catalog.pg_indexes
where schemaname = 'public'
  and tablename = 'legal_chunks'
  and indexdef ilike '%using hnsw%'
  and indexdef ilike '%vector_cosine_ops%';
`;
}
