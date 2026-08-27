-- Read-only preflight for migration 0007. Execute only after separate approval.
select pg_catalog.current_setting('server_version') as postgres_version;

select cfgname, cfgnamespace::pg_catalog.regnamespace::text as configuration_schema
from pg_catalog.pg_ts_config
where cfgname = 'simple';

select column_name, data_type, udt_schema, udt_name, is_nullable
from information_schema.columns
where table_schema = 'public'
  and table_name = 'legal_chunks'
order by ordinal_position;

select indexname, indexdef
from pg_catalog.pg_indexes
where schemaname = 'public'
  and tablename = 'legal_chunks'
order by indexname;

select
  routine.proname,
  pg_catalog.pg_get_function_identity_arguments(routine.oid) as identity_arguments,
  routine.prosecdef as security_definer,
  routine.provolatile as volatility,
  routine.proconfig as function_configuration
from pg_catalog.pg_proc as routine
join pg_catalog.pg_namespace as namespace on namespace.oid = routine.pronamespace
where namespace.nspname = 'public'
  and routine.proname = 'match_legal_chunks';

select
  pg_catalog.count(*)::integer as total_chunks,
  pg_catalog.count(*) filter (where chunks.embedding is not null)::integer as embedded_chunks,
  pg_catalog.count(*) filter (
    where chunks.embedding_model <> 'text-embedding-3-small'
       or extensions.vector_dims(chunks.embedding) <> 1536
  )::integer as invalid_embeddings,
  pg_catalog.count(distinct chunks.content_hash)::integer as distinct_content_hashes,
  pg_catalog.md5(
    pg_catalog.string_agg(
      chunks.content_hash,
      ',' order by sources.law_number, chunks.chunk_index
    )
  ) as content_hash_fingerprint
from public.legal_chunks as chunks
join public.legal_sources as sources on sources.id = chunks.legal_source_id;

select relname, relrowsecurity
from pg_catalog.pg_class
where oid in ('public.legal_sources'::pg_catalog.regclass, 'public.legal_chunks'::pg_catalog.regclass)
order by relname;

select grantee, table_name, privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name in ('legal_sources', 'legal_chunks')
  and grantee in ('anon', 'authenticated', 'service_role')
order by table_name, grantee, privilege_type;
