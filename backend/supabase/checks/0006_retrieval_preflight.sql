-- Read-only preflight for migration 0006.
select extname, extversion, extnamespace::regnamespace::text as extension_schema
from pg_catalog.pg_extension
where extname = 'vector';

select column_name, udt_schema, udt_name, is_nullable
from information_schema.columns
where table_schema = 'public'
  and table_name = 'legal_chunks'
  and column_name in ('embedding', 'embedding_model', 'embedded_at')
order by column_name;

select
  count(*)::integer as total_chunks,
  count(*) filter (where embedding is not null)::integer as embedded_chunks,
  count(*) filter (where embedding is null)::integer as pending_chunks,
  count(*) filter (
    where (embedding is null) <> (embedding_model is null)
       or (embedding is null) <> (embedded_at is null)
  )::integer as partial_state_rows,
  count(*) filter (
    where embedding_model is not null
      and embedding_model <> 'text-embedding-3-small'
  )::integer as invalid_model_rows,
  count(*) filter (
    where embedding is not null
      and extensions.vector_dims(embedding) <> 1536
  )::integer as invalid_dimension_rows
from public.legal_chunks;

select indexname, indexdef
from pg_catalog.pg_indexes
where schemaname = 'public'
  and tablename = 'legal_chunks'
  and indexname = 'legal_chunks_embedding_hnsw_cosine_idx';

select
  law_number,
  status,
  verified_source,
  ingestion_status,
  language,
  document_type,
  applicability,
  applicability_mode
from public.legal_sources
order by law_number;

select
  relname,
  relrowsecurity
from pg_catalog.pg_class
where oid in (
  'public.legal_sources'::regclass,
  'public.legal_chunks'::regclass,
  'public.legal_source_relations'::regclass
)
order by relname;

select
  grantee,
  table_name,
  privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name in ('legal_sources', 'legal_chunks', 'legal_source_relations')
  and grantee in ('anon', 'authenticated', 'service_role')
order by table_name, grantee, privilege_type;
