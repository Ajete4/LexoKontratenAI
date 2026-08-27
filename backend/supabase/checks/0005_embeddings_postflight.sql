-- Read-only postflight for migration 0005. This file performs no writes.

select
  extension.extname,
  extension.extversion,
  namespace.nspname as extension_schema
from pg_extension as extension
join pg_namespace as namespace on namespace.oid = extension.extnamespace
where extension.extname = 'vector';

select
  column_name,
  data_type,
  udt_schema,
  udt_name,
  is_nullable
from information_schema.columns
where table_schema = 'public'
  and table_name = 'legal_chunks'
  and column_name in ('embedding', 'embedding_model', 'embedded_at')
order by column_name;

select
  constraint_name,
  pg_get_constraintdef(constraint_catalog.oid) as definition
from information_schema.table_constraints as table_constraint
join pg_constraint as constraint_catalog
  on constraint_catalog.conname = table_constraint.constraint_name
join pg_namespace as namespace
  on namespace.oid = constraint_catalog.connamespace
where table_constraint.table_schema = 'public'
  and table_constraint.table_name = 'legal_chunks'
  and namespace.nspname = 'public'
  and table_constraint.constraint_name in (
    'legal_chunks_embedding_state_check',
    'legal_chunks_embedding_model_check',
    'legal_chunks_embedding_dimensions_check'
  )
order by constraint_name;

select
  indexname,
  indexdef
from pg_indexes
where schemaname = 'public'
  and tablename = 'legal_chunks'
  and indexname = 'legal_chunks_embedding_hnsw_cosine_idx';

select
  count(*) as legal_chunk_count,
  count(*) filter (where embedding is not null) as embedded_chunk_count,
  count(*) filter (
    where embedding_model is not null or embedded_at is not null
  ) as embedding_metadata_count
from public.legal_chunks;

select
  count(*) filter (where token_count is null) as null_token_count_rows,
  count(distinct content_hash) as distinct_content_hashes
from public.legal_chunks;

select
  grantee,
  privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name = 'legal_chunks'
  and grantee in ('anon', 'authenticated', 'service_role')
order by grantee, privilege_type;

select
  namespace.nspname as table_schema,
  relation.relname as table_name,
  relation.relrowsecurity as rls_enabled
from pg_class as relation
join pg_namespace as namespace on namespace.oid = relation.relnamespace
where namespace.nspname = 'public'
  and relation.relname = 'legal_chunks';
