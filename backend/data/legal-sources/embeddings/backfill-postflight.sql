-- Read-only postflight for the complete P0 embedding corpus.
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
