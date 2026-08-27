-- Read-only postflight for the single approved legal embedding canary.
with canary as (
  select
    'd1a2e9f2-a182-45d1-8a2c-6f3c4bc27ca9'::uuid as chunk_id,
    'c3359a1dcee2c3ff67b2b4b495cad2e8b8ae55de1e73f0ad9848838c87d25ee3'::text as content_hash
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
