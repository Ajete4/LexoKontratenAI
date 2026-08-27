-- LexoKontraten AI - pgvector foundation for P0 legal chunk retrieval.
-- Apply only after the read-only 0005 preflight confirms HNSW support.
-- This migration creates no embeddings and changes no existing chunk content.

begin;

create extension if not exists vector with schema extensions;

alter table public.legal_chunks
  add column embedding extensions.vector(1536),
  add column embedding_model text,
  add column embedded_at timestamptz,

  add constraint legal_chunks_embedding_state_check
    check (
      (
        embedding is null
        and embedding_model is null
        and embedded_at is null
      )
      or
      (
        embedding is not null
        and embedding_model is not null
        and embedded_at is not null
      )
    ),
  add constraint legal_chunks_embedding_model_check
    check (
      embedding_model is null
      or embedding_model = 'text-embedding-3-small'
    ),
  add constraint legal_chunks_embedding_dimensions_check
    check (
      embedding is null
      or extensions.vector_dims(embedding) = 1536
    );

comment on column public.legal_chunks.embedding is
  'Nullable 1536-dimensional semantic vector; populated only by the trusted backend.';
comment on column public.legal_chunks.embedding_model is
  'Exact embedding model identifier; currently restricted to text-embedding-3-small.';
comment on column public.legal_chunks.embedded_at is
  'Timestamp at which the matching embedding was produced.';

create index legal_chunks_embedding_hnsw_cosine_idx
  on public.legal_chunks
  using hnsw (embedding extensions.vector_cosine_ops)
  where embedding is not null;

-- Preserve the corpus access boundary established by migration 0004.
alter table public.legal_chunks enable row level security;

revoke all privileges on table public.legal_chunks from public;
revoke all privileges on table public.legal_chunks from anon;
revoke all privileges on table public.legal_chunks from authenticated;
grant all privileges on table public.legal_chunks to service_role;

commit;
