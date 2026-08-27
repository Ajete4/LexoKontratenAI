import { createHash } from "node:crypto";

import type { LegalChunk } from "./legal-chunker.js";
import type { LegalChunkRemoteMapping } from "./legal-chunk-remote-mapping.js";
import {
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MODEL,
  LEGAL_EMBEDDING_PIPELINE_VERSION
} from "./legal-embedding-config.js";

export type LegalEmbeddingCanary = {
  readonly plan: {
    readonly chunkId: string;
    readonly legalSourceId: string;
    readonly lawNumber: "03/L-212";
    readonly versionLabel: "gazette-90-2010";
    readonly chunkIndex: number;
    readonly contentHash: string;
    readonly characterCount: number;
    readonly utf8ByteCount: number;
    readonly model: typeof LEGAL_EMBEDDING_MODEL;
    readonly dimensions: typeof LEGAL_EMBEDDING_DIMENSIONS;
    readonly pipelineVersion: typeof LEGAL_EMBEDDING_PIPELINE_VERSION;
  };
  readonly content: string;
};

export type LegalEmbeddingCanaryPlan = LegalEmbeddingCanary["plan"];

function hash(content: string): string {
  return createHash("sha256").update(content, "utf8").digest("hex");
}

export function selectLegalEmbeddingCanary(
  mapping: LegalChunkRemoteMapping,
  employmentChunks: readonly LegalChunk[]
): LegalEmbeddingCanary {
  const candidates = employmentChunks
    .filter(
      (chunk) =>
        chunk.lawNumber === "03/L-212" &&
        chunk.versionLabel === "gazette-90-2010" &&
        chunk.content.trim().length > 0 &&
        hash(chunk.content) === chunk.contentSha256
    )
    .sort(
      (left, right) =>
        left.content.length - right.content.length ||
        left.chunkIndex - right.chunkIndex
    );
  const chunk = candidates[0];

  if (chunk === undefined) {
    throw new Error("LEGAL_EMBEDDING_CANARY_SELECTION_FAILED");
  }

  const remote = mapping.chunks.find(
    (item) =>
      item.lawNumber === chunk.lawNumber &&
      item.versionLabel === chunk.versionLabel &&
      item.language === "sq" &&
      item.chunkIndex === chunk.chunkIndex &&
      item.contentHash === chunk.contentSha256
  );

  if (remote === undefined) {
    throw new Error("LEGAL_EMBEDDING_CANARY_MAPPING_FAILED");
  }

  return {
    plan: {
      chunkId: remote.chunkId,
      legalSourceId: remote.legalSourceId,
      lawNumber: "03/L-212",
      versionLabel: "gazette-90-2010",
      chunkIndex: chunk.chunkIndex,
      contentHash: chunk.contentSha256,
      characterCount: chunk.content.length,
      utf8ByteCount: Buffer.byteLength(chunk.content, "utf8"),
      model: LEGAL_EMBEDDING_MODEL,
      dimensions: LEGAL_EMBEDDING_DIMENSIONS,
      pipelineVersion: LEGAL_EMBEDDING_PIPELINE_VERSION
    },
    content: chunk.content
  };
}

function sqlLiteral(value: string): string {
  return `'${value.replaceAll("'", "''")}'`;
}

export function renderCanaryPostflightSql(
  plan: LegalEmbeddingCanaryPlan
): string {
  return `-- Read-only postflight for the single approved legal embedding canary.
with canary as (
  select
    ${sqlLiteral(plan.chunkId)}::uuid as chunk_id,
    ${sqlLiteral(plan.contentHash)}::text as content_hash
), corpus as (
  select
    count(*)::integer as total_chunks,
    count(*) filter (where embedding is not null)::integer as embedded_chunks,
    count(*) filter (
      where embedding_model is not null and embedded_at is not null
    )::integer as embedding_metadata_rows
  from public.legal_chunks
)
select
  corpus.total_chunks,
  corpus.embedded_chunks,
  corpus.embedding_metadata_rows,
  chunks.id = canary.chunk_id as canary_id_matches,
  chunks.content_hash = canary.content_hash as canary_hash_matches,
  chunks.embedding_model,
  extensions.vector_dims(chunks.embedding) as embedding_dimensions,
  chunks.embedded_at is not null as has_embedded_at
from corpus
cross join canary
left join public.legal_chunks as chunks on chunks.id = canary.chunk_id;

select
  relrowsecurity as rls_enabled
from pg_catalog.pg_class
where oid = 'public.legal_chunks'::regclass;

select
  pg_catalog.has_table_privilege('anon', 'public.legal_chunks', 'SELECT') as anon_select,
  pg_catalog.has_table_privilege('authenticated', 'public.legal_chunks', 'SELECT') as authenticated_select,
  pg_catalog.has_table_privilege('service_role', 'public.legal_chunks', 'SELECT') as service_role_select,
  pg_catalog.has_table_privilege('service_role', 'public.legal_chunks', 'UPDATE') as service_role_update;

select
  indexname,
  indexdef
from pg_catalog.pg_indexes
where schemaname = 'public'
  and tablename = 'legal_chunks'
  and indexdef ilike '%using hnsw%'
  and indexdef ilike '%vector_cosine_ops%';
`;
}

export function renderCanarySemanticSanitySql(
  plan: LegalEmbeddingCanaryPlan
): string {
  return `-- Read-only semantic sanity check. No legal text or vector is returned.
with canary as (
  select embedding
  from public.legal_chunks
  where id = ${sqlLiteral(plan.chunkId)}::uuid
    and content_hash = ${sqlLiteral(plan.contentHash)}
    and embedding is not null
)
select
  candidate.id,
  source.law_number,
  source.version_label,
  source.language,
  candidate.chunk_index,
  candidate.content_hash,
  candidate.embedding <=> canary.embedding as cosine_distance
from public.legal_chunks as candidate
join public.legal_sources as source on source.id = candidate.legal_source_id
cross join canary
where source.law_number in ('03/L-212', '04/L-077', '08/L-142')
  and candidate.embedding is not null
order by cosine_distance asc, candidate.id asc
limit 5;
`;
}
