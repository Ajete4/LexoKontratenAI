begin;

create table public.clause_citations (
  id uuid primary key default gen_random_uuid (),
  clause_id uuid not null references public.clauses (id) on delete cascade,
  legal_chunk_id uuid not null references public.legal_chunks (id) on delete restrict,
  citation_rank integer not null,
  citation_id text not null,
  retrieval_method text not null,
  semantic_score double precision,
  lexical_score double precision,
  fused_score double precision not null,
  content_hash text not null,
  created_at timestamptz not null default now(),
  constraint clause_citations_rank_check check (citation_rank between 1 and 5),
  constraint clause_citations_id_check check (citation_id ~ '^C[1-5]$'),
  constraint clause_citations_retrieval_method_check check (retrieval_method = 'hybrid_rrf_v1'),
  constraint clause_citations_semantic_score_check check (
    semantic_score is null
    or (
      semantic_score >= 0
      and semantic_score <= 1
    )
  ),
  constraint clause_citations_lexical_score_check check (
    lexical_score is null
    or (
      lexical_score >= 0
      and lexical_score < 'Infinity'::double precision
    )
  ),
  constraint clause_citations_fused_score_check check (
    fused_score > 0
    and fused_score < 'Infinity'::double precision
  ),
  constraint clause_citations_content_hash_check check (content_hash ~ '^[0-9a-f]{64}$'),
  constraint clause_citations_clause_chunk_unique unique (clause_id, legal_chunk_id),
  constraint clause_citations_clause_rank_unique unique (clause_id, citation_rank),
  constraint clause_citations_clause_id_unique unique (clause_id, citation_id)
);

comment on table public.clause_citations is 'Validated provenance links between persisted analysis clauses and immutable legal chunks.';

comment on constraint clause_citations_clause_rank_unique on public.clause_citations is 'Also provides the clause lookup and deterministic clause-plus-rank ordering index.';

create index clause_citations_legal_chunk_id_idx on public.clause_citations (legal_chunk_id);

alter table public.clause_citations enable row level security;

revoke all on table public.clause_citations
from
  public;

revoke all on table public.clause_citations
from
  anon;

revoke all on table public.clause_citations
from
  authenticated;

grant all on table public.clause_citations to service_role;

create or replace function public.complete_contract_analysis_with_citations (
  p_analysis_id uuid,
  p_expected_pipeline_version text,
  p_result jsonb,
  p_overall_risk_level text,
  p_clauses jsonb,
  p_clause_evidence jsonb
) returns table (
  analysis_id uuid,
  status text,
  completed_at timestamptz,
  clause_count integer,
  citation_count integer
) language plpgsql security definer
set
  search_path = pg_catalog as $$
declare
  v_completion record;
  v_evidence jsonb;
  v_citation jsonb;
  v_clause_position integer;
  v_clause_id uuid;
  v_chunk_hash text;
  v_citation_count integer := 0;
begin
  if pg_catalog.jsonb_typeof(p_clause_evidence) <> 'array' then
    raise exception 'CLAUSE_EVIDENCE_INVALID';
  end if;

  if pg_catalog.jsonb_array_length(p_clause_evidence) <> pg_catalog.jsonb_array_length(p_clauses) then
    raise exception 'CLAUSE_EVIDENCE_COUNT_INVALID';
  end if;

  for v_evidence in
    select value from pg_catalog.jsonb_array_elements(p_clause_evidence)
  loop
    if pg_catalog.jsonb_typeof(v_evidence) <> 'object'
      or not (v_evidence ?& array['clause_key', 'evidence_status', 'citations'])
      or v_evidence - array['clause_key', 'evidence_status', 'citations'] <> '{}'::jsonb
      or (v_evidence->>'clause_key') !~ '^clause-([1-9]|[12][0-9]|30)$'
      or (v_evidence->>'evidence_status') not in ('grounded', 'insufficient_evidence')
      or pg_catalog.jsonb_typeof(v_evidence->'citations') <> 'array'
      or pg_catalog.jsonb_array_length(v_evidence->'citations') > 5
    then
      raise exception 'CLAUSE_EVIDENCE_INVALID';
    end if;

v_clause_position := pg_catalog.substr(
  v_evidence->>'clause_key',
  8
)::integer;

    if not exists (
      select 1
      from pg_catalog.jsonb_array_elements(p_clauses) as clause(value)
      where (clause.value->>'position')::integer = v_clause_position
    ) then
      raise exception 'CLAUSE_EVIDENCE_POSITION_INVALID';
    end if;

    if (
      select pg_catalog.count(*)
      from pg_catalog.jsonb_array_elements(p_clause_evidence) as evidence(value)
      where evidence.value->>'clause_key' = v_evidence->>'clause_key'
    ) <> 1 then
      raise exception 'CLAUSE_EVIDENCE_DUPLICATE';
    end if;

    if (v_evidence->>'evidence_status') = 'grounded'
      and pg_catalog.jsonb_array_length(v_evidence->'citations') = 0
    then
      raise exception 'CLAUSE_EVIDENCE_REQUIRED';
    end if;

    if (v_evidence->>'evidence_status') = 'insufficient_evidence'
      and pg_catalog.jsonb_array_length(v_evidence->'citations') <> 0
    then
      raise exception 'CLAUSE_EVIDENCE_MUST_BE_EMPTY';
    end if;

    for v_citation in
      select value from pg_catalog.jsonb_array_elements(v_evidence->'citations')
    loop
      if pg_catalog.jsonb_typeof(v_citation) <> 'object'
        or not (v_citation ?& array[
          'citation_id', 'legal_chunk_id', 'citation_rank', 'retrieval_method',
          'semantic_score', 'lexical_score', 'fused_score', 'content_hash'
        ])
        or v_citation - array[
          'citation_id', 'legal_chunk_id', 'citation_rank', 'retrieval_method',
          'semantic_score', 'lexical_score', 'fused_score', 'content_hash'
        ] <> '{}'::jsonb
      then
        raise exception 'CLAUSE_CITATION_INVALID';
      end if;

      select legal_chunk.content_hash
      into v_chunk_hash
      from public.legal_chunks as legal_chunk
      where legal_chunk.id = (v_citation->>'legal_chunk_id')::uuid;

      if not found or v_chunk_hash <> v_citation->>'content_hash' then
        raise exception 'CLAUSE_CITATION_PROVENANCE_INVALID';
      end if;
    end loop;
  end loop;

  select completed.analysis_id, completed.status, completed.completed_at, completed.clause_count
  into v_completion
  from public.complete_contract_analysis(
    p_analysis_id,
    p_expected_pipeline_version,
    p_result,
    p_overall_risk_level,
    p_clauses
  ) as completed;

  for v_evidence in
    select value from pg_catalog.jsonb_array_elements(p_clause_evidence)
  loop
    v_clause_position := pg_catalog.substr(
  v_evidence->>'clause_key',
  8
)::integer;

    select clause.id
    into strict v_clause_id
    from public.clauses as clause
    where clause.analysis_id = p_analysis_id
      and clause.position = v_clause_position;

    for v_citation in
      select value from pg_catalog.jsonb_array_elements(v_evidence->'citations')
    loop
      insert into public.clause_citations (
        clause_id,
        legal_chunk_id,
        citation_rank,
        citation_id,
        retrieval_method,
        semantic_score,
        lexical_score,
        fused_score,
        content_hash
      ) values (
        v_clause_id,
        (v_citation->>'legal_chunk_id')::uuid,
        (v_citation->>'citation_rank')::integer,
        v_citation->>'citation_id',
        v_citation->>'retrieval_method',
        nullif(v_citation->>'semantic_score', '')::double precision,
        nullif(v_citation->>'lexical_score', '')::double precision,
        (v_citation->>'fused_score')::double precision,
        v_citation->>'content_hash'
      );
      v_citation_count := v_citation_count + 1;
    end loop;
  end loop;

  return query
  select
    v_completion.analysis_id,
    v_completion.status,
    v_completion.completed_at,
    v_completion.clause_count,
    v_citation_count;
end;
$$;

revoke all on function public.complete_contract_analysis_with_citations (uuid, text, jsonb, text, jsonb, jsonb)
from
  public;

revoke all on function public.complete_contract_analysis_with_citations (uuid, text, jsonb, text, jsonb, jsonb)
from
  anon;

revoke all on function public.complete_contract_analysis_with_citations (uuid, text, jsonb, text, jsonb, jsonb)
from
  authenticated;

grant
execute on function public.complete_contract_analysis_with_citations (uuid, text, jsonb, text, jsonb, jsonb) to service_role;

commit;