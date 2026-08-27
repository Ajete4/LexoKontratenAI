-- Read-only postflight for migration 0006.
select
  routine.proname,
  pg_catalog.pg_get_function_identity_arguments(routine.oid) as identity_arguments,
  pg_catalog.pg_get_function_result(routine.oid) as result_type,
  routine.prosecdef as security_definer,
  routine.provolatile as volatility,
  routine.proconfig as function_configuration
from pg_catalog.pg_proc as routine
join pg_catalog.pg_namespace as namespace on namespace.oid = routine.pronamespace
where namespace.nspname = 'public'
  and routine.proname = 'match_legal_chunks';

select
  pg_catalog.has_function_privilege(
    'anon',
    'public.match_legal_chunks(extensions.vector,text,integer,double precision)',
    'EXECUTE'
  ) as anon_execute,
  pg_catalog.has_function_privilege(
    'authenticated',
    'public.match_legal_chunks(extensions.vector,text,integer,double precision)',
    'EXECUTE'
  ) as authenticated_execute,
  pg_catalog.has_function_privilege(
    'service_role',
    'public.match_legal_chunks(extensions.vector,text,integer,double precision)',
    'EXECUTE'
  ) as service_role_execute;

select
  count(*)::integer as total_chunks,
  count(*) filter (where embedding is not null)::integer as embedded_chunks,
  count(*) filter (where embedding is null)::integer as pending_chunks
from public.legal_chunks;

-- Synthetic-vector smoke test; returns safe provenance fields and no vector.
select
  law_number,
  version_label,
  document_type,
  applicability_mode,
  chunk_index,
  article_number,
  content_hash,
  similarity
from public.match_legal_chunks(
  array_fill(0.001::real, array[1536])::extensions.vector(1536),
  'employment',
  3,
  0
);

-- Run manually after applying 0006. Planner choice depends on corpus size and cost.
explain (costs, verbose, format text)
select
  chunks.id
from public.legal_chunks as chunks
join public.legal_sources as sources on sources.id = chunks.legal_source_id
where chunks.embedding is not null
  and chunks.embedding_model = 'text-embedding-3-small'
  and sources.status = 'verified'
  and sources.verified_source = true
  and sources.ingestion_status = 'ingested'
  and sources.applicability @> array['employment']::text[]
order by chunks.embedding OPERATOR(extensions.<=>)
  array_fill(0.001::real, array[1536])::extensions.vector(1536)
limit 8;
