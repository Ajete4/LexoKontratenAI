-- LexoKontraten AI - read-only semantic retrieval for the verified P0 corpus.
-- Local migration draft. Apply only after the read-only 0006 preflight succeeds.

begin;

create or replace function public.match_legal_chunks(
  p_query_embedding extensions.vector(1536),
  p_contract_type text,
  p_match_count integer default 8,
  p_min_similarity double precision default 0.50
)
returns table (
  chunk_id uuid,
  legal_source_id uuid,
  law_number text,
  source_title text,
  version_label text,
  official_url text,
  official_document_url text,
  document_type text,
  applicability_mode text,
  chunk_index integer,
  article_number varchar(64),
  article_title varchar(300),
  paragraph_number varchar(64),
  point_label varchar(64),
  content text,
  content_hash text,
  similarity double precision
)
language plpgsql
stable
security definer
set search_path = pg_catalog
as $function$
begin
  if p_query_embedding is null
    or extensions.vector_dims(p_query_embedding) <> 1536 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_RETRIEVAL_QUERY_EMBEDDING_INVALID';
  end if;

  if p_contract_type is null
    or p_contract_type not in ('employment', 'service', 'lease') then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_RETRIEVAL_CONTRACT_TYPE_INVALID';
  end if;

  if p_match_count is null or p_match_count < 1 or p_match_count > 20 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_RETRIEVAL_MATCH_COUNT_INVALID';
  end if;

  if p_min_similarity is null
    or p_min_similarity = 'NaN'::double precision
    or p_min_similarity < 0
    or p_min_similarity > 1 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_RETRIEVAL_MIN_SIMILARITY_INVALID';
  end if;

  return query
  select
    matches.chunk_id,
    matches.legal_source_id,
    matches.law_number,
    matches.source_title,
    matches.version_label,
    matches.official_url,
    matches.official_document_url,
    matches.document_type,
    matches.applicability_mode,
    matches.chunk_index,
    matches.article_number,
    matches.article_title,
    matches.paragraph_number,
    matches.point_label,
    matches.content,
    matches.content_hash,
    matches.similarity
  from (
    select
      chunks.id as chunk_id,
      chunks.legal_source_id,
      sources.law_number,
      sources.title as source_title,
      sources.version_label,
      sources.official_url,
      sources.official_document_url,
      sources.document_type,
      sources.applicability_mode,
      chunks.chunk_index,
      chunks.article_number,
      chunks.article_title,
      chunks.paragraph_number,
      chunks.point_label,
      chunks.content,
      chunks.content_hash,
      1 - (
        chunks.embedding OPERATOR(extensions.<=>) p_query_embedding
      ) as similarity
    from public.legal_chunks as chunks
    join public.legal_sources as sources
      on sources.id = chunks.legal_source_id
    where chunks.embedding is not null
      and chunks.embedding_model = 'text-embedding-3-small'
      and sources.status = 'verified'
      and sources.verified_source = true
      and sources.ingestion_status = 'ingested'
      and sources.language = 'sq'
      and sources.law_number in ('03/L-212', '04/L-077', '08/L-142')
      and sources.applicability @> array[p_contract_type]::text[]
      and (
        (
          sources.document_type = 'law'
          and sources.applicability_mode = 'direct'
        )
        or
        (
          sources.document_type = 'amendment'
          and sources.applicability_mode = 'amendment_scope'
        )
      )
      and 1 - (
        chunks.embedding OPERATOR(extensions.<=>) p_query_embedding
      ) >= p_min_similarity
    order by
      chunks.embedding OPERATOR(extensions.<=>) p_query_embedding asc
    limit p_match_count
  ) as matches
  order by
    matches.similarity desc,
    matches.law_number asc,
    matches.chunk_index asc;
end;
$function$;

comment on function public.match_legal_chunks(
  extensions.vector(1536), text, integer, double precision
) is
  'Read-only semantic matching over verified, ingested P0 legal chunks. Amendment scope remains non-consolidated.';

revoke all on function public.match_legal_chunks(
  extensions.vector(1536), text, integer, double precision
) from public;
revoke all on function public.match_legal_chunks(
  extensions.vector(1536), text, integer, double precision
) from anon;
revoke all on function public.match_legal_chunks(
  extensions.vector(1536), text, integer, double precision
) from authenticated;
grant execute on function public.match_legal_chunks(
  extensions.vector(1536), text, integer, double precision
) to service_role;

commit;
