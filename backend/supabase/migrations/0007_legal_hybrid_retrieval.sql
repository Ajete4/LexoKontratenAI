-- LexoKontraten AI - deterministic hybrid retrieval over the verified P0 corpus.
-- Local migration draft. Do not execute before remote read-only preflight approval.
-- PostgreSQL simple FTS preserves tokens but provides no Albanian stemming.

begin;

create index if not exists legal_chunks_content_fts_simple_idx
  on public.legal_chunks
  using gin (
    pg_catalog.to_tsvector(
      'pg_catalog.simple'::pg_catalog.regconfig,
      content
    )
  );

create or replace function public.match_legal_chunks_hybrid(
  p_query_embedding extensions.vector(1536),
  p_query_text text,
  p_contract_type text,
  p_match_count integer default 8,
  p_candidate_count integer default 50,
  p_min_semantic_similarity double precision default 0.45,
  p_rrf_k integer default 60
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
  semantic_score double precision,
  lexical_score double precision,
  fused_score double precision,
  semantic_rank integer,
  lexical_rank integer,
  result_rank integer
)
language plpgsql
stable
security definer
set search_path = pg_catalog
as $function$
declare
  v_lexical_query pg_catalog.tsquery;
begin
  if p_query_embedding is null
    or extensions.vector_dims(p_query_embedding) <> 1536 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_QUERY_EMBEDDING_INVALID';
  end if;

  if p_query_text is null
    or pg_catalog.char_length(pg_catalog.btrim(p_query_text)) < 1
    or pg_catalog.char_length(p_query_text) > 2000 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_QUERY_TEXT_INVALID';
  end if;

  if p_contract_type is null
    or p_contract_type not in ('employment', 'service', 'lease') then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_CONTRACT_TYPE_INVALID';
  end if;

  if p_match_count is null or p_match_count < 1 or p_match_count > 20 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_MATCH_COUNT_INVALID';
  end if;

  if p_candidate_count is null
    or p_candidate_count < 8
    or p_candidate_count > 100
    or p_candidate_count < p_match_count then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_CANDIDATE_COUNT_INVALID';
  end if;

  if p_min_semantic_similarity is null
    or p_min_semantic_similarity = 'NaN'::double precision
    or p_min_semantic_similarity < 0
    or p_min_semantic_similarity > 1 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_MIN_SIMILARITY_INVALID';
  end if;

  if p_rrf_k is null or p_rrf_k < 1 or p_rrf_k > 1000 then
    raise exception using
      errcode = '22023',
      message = 'LEGAL_HYBRID_RRF_K_INVALID';
  end if;

  v_lexical_query := pg_catalog.plainto_tsquery(
    'pg_catalog.simple'::pg_catalog.regconfig,
    p_query_text
  );

  return query
  with eligible as not materialized (
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
      ) as semantic_score,
      pg_catalog.ts_rank_cd(
        pg_catalog.to_tsvector(
          'pg_catalog.simple'::pg_catalog.regconfig,
          chunks.content
        ),
        v_lexical_query
      )::double precision as lexical_score,
      pg_catalog.to_tsvector(
        'pg_catalog.simple'::pg_catalog.regconfig,
        chunks.content
      ) @@ v_lexical_query as lexical_matches
    from public.legal_chunks as chunks
    join public.legal_sources as sources
      on sources.id = chunks.legal_source_id
    where chunks.embedding is not null
      and chunks.embedding_model = 'text-embedding-3-small'
      and sources.status = 'verified'
      and sources.verified_source = true
      and sources.ingestion_status = 'ingested'
      and sources.language = 'sq'
      and sources.applicability @> array[p_contract_type]::text[]
      and (
        (p_contract_type = 'employment' and sources.law_number in ('03/L-212', '08/L-142'))
        or (p_contract_type in ('service', 'lease') and sources.law_number = '04/L-077')
      )
      and (
        (sources.document_type = 'law' and sources.applicability_mode = 'direct')
        or (
          sources.document_type = 'amendment'
          and sources.applicability_mode = 'amendment_scope'
        )
      )
  ),
  semantic_candidates as (
    select
      eligible.chunk_id,
      eligible.semantic_score,
      pg_catalog.row_number() over (
        order by
          eligible.semantic_score desc,
          eligible.law_number asc,
          eligible.chunk_index asc,
          eligible.chunk_id asc
      )::integer as semantic_rank
    from eligible
    where eligible.semantic_score >= p_min_semantic_similarity
    order by
      eligible.semantic_score desc,
      eligible.law_number asc,
      eligible.chunk_index asc,
      eligible.chunk_id asc
    limit p_candidate_count
  ),
  lexical_candidates as (
    select
      eligible.chunk_id,
      eligible.lexical_score,
      pg_catalog.row_number() over (
        order by
          eligible.lexical_score desc,
          eligible.law_number asc,
          eligible.chunk_index asc,
          eligible.chunk_id asc
      )::integer as lexical_rank
    from eligible
    where eligible.lexical_matches
      and eligible.lexical_score > 0
    order by
      eligible.lexical_score desc,
      eligible.law_number asc,
      eligible.chunk_index asc,
      eligible.chunk_id asc
    limit p_candidate_count
  ),
  fused as (
    select
      coalesce(semantic_candidates.chunk_id, lexical_candidates.chunk_id) as chunk_id,
      semantic_candidates.semantic_score,
      lexical_candidates.lexical_score,
      semantic_candidates.semantic_rank,
      lexical_candidates.lexical_rank,
      (
        case when semantic_candidates.semantic_rank is null then 0
          else 1.0 / (p_rrf_k + semantic_candidates.semantic_rank) end
        + case when lexical_candidates.lexical_rank is null then 0
          else 1.0 / (p_rrf_k + lexical_candidates.lexical_rank) end
      )::double precision as fused_score
    from semantic_candidates
    full outer join lexical_candidates
      on lexical_candidates.chunk_id = semantic_candidates.chunk_id
  ),
  ranked as (
    select
      eligible.*,
      fused.semantic_score as fused_semantic_score,
      fused.lexical_score as fused_lexical_score,
      fused.fused_score,
      fused.semantic_rank,
      fused.lexical_rank,
      pg_catalog.row_number() over (
        order by
          fused.fused_score desc,
          greatest(
            coalesce(fused.semantic_score, 0),
            coalesce(fused.lexical_score, 0)
          ) desc,
          eligible.law_number asc,
          eligible.chunk_index asc,
          eligible.chunk_id asc
      )::integer as result_rank
    from fused
    join eligible on eligible.chunk_id = fused.chunk_id
  )
  select
    ranked.chunk_id,
    ranked.legal_source_id,
    ranked.law_number,
    ranked.source_title,
    ranked.version_label,
    ranked.official_url,
    ranked.official_document_url,
    ranked.document_type,
    ranked.applicability_mode,
    ranked.chunk_index,
    ranked.article_number,
    ranked.article_title,
    ranked.paragraph_number,
    ranked.point_label,
    ranked.content,
    ranked.content_hash,
    ranked.fused_semantic_score,
    ranked.fused_lexical_score,
    ranked.fused_score,
    ranked.semantic_rank,
    ranked.lexical_rank,
    ranked.result_rank
  from ranked
  order by ranked.result_rank asc
  limit p_match_count;
end;
$function$;

comment on function public.match_legal_chunks_hybrid(
  extensions.vector(1536), text, text, integer, integer, double precision, integer
) is
  'Read-only P0 hybrid retrieval using cosine similarity, simple FTS, and deterministic reciprocal rank fusion.';

revoke all on function public.match_legal_chunks_hybrid(
  extensions.vector(1536), text, text, integer, integer, double precision, integer
) from public;
revoke all on function public.match_legal_chunks_hybrid(
  extensions.vector(1536), text, text, integer, integer, double precision, integer
) from anon;
revoke all on function public.match_legal_chunks_hybrid(
  extensions.vector(1536), text, text, integer, integer, double precision, integer
) from authenticated;
grant execute on function public.match_legal_chunks_hybrid(
  extensions.vector(1536), text, text, integer, integer, double precision, integer
) to service_role;

commit;
