-- Read-only postflight for migration 0007. Execute only after migration approval.
select indexname, indexdef
from pg_catalog.pg_indexes
where schemaname = 'public'
  and tablename = 'legal_chunks'
  and indexname = 'legal_chunks_content_fts_simple_idx';

select
  routine.proname,
  pg_catalog.pg_get_function_identity_arguments(routine.oid) as identity_arguments,
  pg_catalog.pg_get_function_result(routine.oid) as result_type,
  routine.prosecdef as security_definer,
  routine.provolatile as volatility,
  routine.proconfig as function_configuration,
  pg_catalog.pg_get_functiondef(routine.oid) as function_definition
from pg_catalog.pg_proc as routine
join pg_catalog.pg_namespace as namespace on namespace.oid = routine.pronamespace
where namespace.nspname = 'public'
  and routine.proname = 'match_legal_chunks_hybrid';

select
  pg_catalog.has_function_privilege(
    'anon',
    'public.match_legal_chunks_hybrid(extensions.vector,text,text,integer,integer,double precision,integer)',
    'EXECUTE'
  ) as anon_execute,
  pg_catalog.has_function_privilege(
    'authenticated',
    'public.match_legal_chunks_hybrid(extensions.vector,text,text,integer,integer,double precision,integer)',
    'EXECUTE'
  ) as authenticated_execute,
  pg_catalog.has_function_privilege(
    'service_role',
    'public.match_legal_chunks_hybrid(extensions.vector,text,text,integer,integer,double precision,integer)',
    'EXECUTE'
  ) as service_role_execute;

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

explain (costs, verbose, format text)
select chunks.id
from public.legal_chunks as chunks
where pg_catalog.to_tsvector(
  'pg_catalog.simple'::pg_catalog.regconfig,
  chunks.content
) @@ pg_catalog.plainto_tsquery(
  'pg_catalog.simple'::pg_catalog.regconfig,
  'detyrim kontraktues'
)
limit 8;

