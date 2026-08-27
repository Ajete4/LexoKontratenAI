begin;

alter table public.analyses
  add column result_json jsonb,
  add column overall_risk_level text;

comment on column public.analyses.result_json is
  'Validated analysis-level result only. Must not contain clauses, prompts, contract text, secrets, raw model responses, or Storage metadata.';

comment on column public.analyses.overall_risk_level is
  'Informational overall risk classification produced by the analysis pipeline.';

alter table public.analyses
  add constraint analyses_result_json_object_check
    check (result_json is null or jsonb_typeof(result_json) = 'object'),
  add constraint analyses_result_json_required_keys_check
    check (
      result_json is null
      or result_json ?& array[
        'language',
        'contractType',
        'title',
        'summary',
        'parties',
        'keyDates',
        'paymentTerms',
        'terminationTerms',
        'overallRiskExplanation',
        'missingInformation',
        'professionalReviewRecommended',
        'disclaimer'
      ]::text[]
    ),
  add constraint analyses_result_json_keys_check
    check (
      result_json is null
      or result_json - array[
        'language',
        'contractType',
        'title',
        'summary',
        'parties',
        'keyDates',
        'paymentTerms',
        'terminationTerms',
        'overallRiskExplanation',
        'missingInformation',
        'professionalReviewRecommended',
        'disclaimer'
      ]::text[] = '{}'::jsonb
    ),
  add constraint analyses_overall_risk_level_check
    check (
      overall_risk_level is null
      or overall_risk_level in ('low', 'medium', 'high', 'critical', 'unknown')
    );

-- A completed legacy row cannot be backfilled safely without its validated
-- analysis result. Abort instead of inventing or deleting data.
do $migration$
begin
  if exists (
    select 1
    from public.analyses
    where status = 'completed'
  ) then
    raise exception using
      errcode = '23514',
      message = 'Cannot require analysis results: existing completed analyses need an explicit validated result backfill.';
  end if;
end
$migration$;

alter table public.analyses
  add constraint analyses_completed_result_check
    check (
      status <> 'completed'
      or (
        result_json is not null
        and overall_risk_level is not null
        and completed_at is not null
        and error_message_safe is null
      )
    );

-- pipeline_version is already NOT NULL in 0001. The NULL branch keeps this
-- backfill deterministic if the constraint differs in another local database.
update public.analyses
set pipeline_version = 'analysis-v1'
where pipeline_version is null
  or btrim(pipeline_version) = '';

do $migration$
begin
  if exists (
    select 1
    from public.analyses
    group by contract_version_id, pipeline_version
    having count(*) > 1
  ) then
    raise exception using
      errcode = '23505',
      message = 'Cannot enforce analysis idempotency: duplicate contract-version and pipeline-version rows exist.';
  end if;
end
$migration$;

alter table public.analyses
  add constraint analyses_pipeline_version_not_blank_check
    check (char_length(btrim(pipeline_version)) > 0),
  add constraint analyses_contract_version_pipeline_unique
    unique (contract_version_id, pipeline_version);

alter table public.clauses
  add column position smallint;

do $migration$
begin
  if exists (
    select 1
    from public.clauses
    group by analysis_id
    having count(*) > 30
  ) then
    raise exception using
      errcode = '23514',
      message = 'Cannot backfill clause positions: an analysis contains more than 30 clauses.';
  end if;
end
$migration$;

with ranked_clauses as (
  select
    id,
    row_number() over (
      partition by analysis_id
      order by created_at, id
    ) as next_position
  from public.clauses
)
update public.clauses as clause
set position = ranked.next_position::smallint
from ranked_clauses as ranked
where ranked.id = clause.id;

alter table public.clauses
  alter column position set not null,
  add constraint clauses_position_check
    check (position between 1 and 30),
  add constraint clauses_analysis_position_unique
    unique (analysis_id, position);

create or replace function public.complete_contract_analysis(
  p_analysis_id uuid,
  p_expected_pipeline_version text,
  p_result jsonb,
  p_overall_risk_level text,
  p_clauses jsonb
)
returns table (
  analysis_id uuid,
  status text,
  completed_at timestamptz,
  clause_count integer
)
language plpgsql
security definer
set search_path = pg_catalog
as $function$
declare
  v_analysis_status text;
  v_pipeline_version text;
  v_clause jsonb;
  v_clause_count integer;
  v_ordinality bigint;
  v_completed_at timestamptz := pg_catalog.now();
begin
  select analysis.status, analysis.pipeline_version
  into v_analysis_status, v_pipeline_version
  from public.analyses as analysis
  where analysis.id = p_analysis_id
  for update;

  if not found then
    raise exception using
      errcode = 'P0002',
      message = 'Analysis was not found.';
  end if;

  if v_analysis_status <> 'analyzing' then
    raise exception using
      errcode = 'P0001',
      message = 'Analysis is not in the analyzing state.';
  end if;

  if p_expected_pipeline_version is null
    or char_length(pg_catalog.btrim(p_expected_pipeline_version)) = 0
    or v_pipeline_version <> p_expected_pipeline_version then
    raise exception using
      errcode = 'P0001',
      message = 'Analysis pipeline version does not match.';
  end if;

  if p_result is null or pg_catalog.jsonb_typeof(p_result) <> 'object' then
    raise exception using
      errcode = '22023',
      message = 'Analysis result must be a JSON object.';
  end if;

  if not (p_result ?& array[
    'language',
    'contractType',
    'title',
    'summary',
    'parties',
    'keyDates',
    'paymentTerms',
    'terminationTerms',
    'overallRiskExplanation',
    'missingInformation',
    'professionalReviewRecommended',
    'disclaimer'
  ]::text[]) then
    raise exception using
      errcode = '22023',
      message = 'Analysis result is missing required fields.';
  end if;

  if p_result - array[
    'language',
    'contractType',
    'title',
    'summary',
    'parties',
    'keyDates',
    'paymentTerms',
    'terminationTerms',
    'overallRiskExplanation',
    'missingInformation',
    'professionalReviewRecommended',
    'disclaimer'
  ]::text[] <> '{}'::jsonb then
    raise exception using
      errcode = '22023',
      message = 'Analysis result contains unsupported fields.';
  end if;

  if p_overall_risk_level is null
    or p_overall_risk_level not in ('low', 'medium', 'high', 'critical', 'unknown') then
    raise exception using
      errcode = '22023',
      message = 'Overall risk level is not valid.';
  end if;

  if p_clauses is null or pg_catalog.jsonb_typeof(p_clauses) <> 'array' then
    raise exception using
      errcode = '22023',
      message = 'Clauses must be a JSON array.';
  end if;

  v_clause_count := pg_catalog.jsonb_array_length(p_clauses);

  if v_clause_count > 30 then
    raise exception using
      errcode = '22023',
      message = 'An analysis cannot contain more than 30 clauses.';
  end if;

  for v_clause, v_ordinality in
    select clause_item.value, clause_item.ordinality
    from pg_catalog.jsonb_array_elements(p_clauses)
      with ordinality as clause_item(value, ordinality)
  loop
    if pg_catalog.jsonb_typeof(v_clause) <> 'object' then
      raise exception using
        errcode = '22023',
        message = 'Every clause must be a JSON object.';
    end if;

    if v_clause - array[
      'position',
      'clause_type',
      'finding_type',
      'heading',
      'original_text',
      'simplified_text',
      'severity',
      'favored_party',
      'risk_explanation',
      'suggested_action',
      'suggested_rewrite',
      'confidence',
      'requires_professional_review'
    ]::text[] <> '{}'::jsonb then
      raise exception using
        errcode = '22023',
        message = 'A clause contains unsupported fields.';
    end if;

    if not v_clause ? 'position'
      or (v_clause ->> 'position')::smallint <> v_ordinality::smallint then
      raise exception using
        errcode = '22023',
        message = 'Clause positions must match their array order from 1 through N.';
    end if;
  end loop;

  delete from public.clauses as clause
  where clause.analysis_id = p_analysis_id;

  insert into public.clauses (
    analysis_id,
    position,
    clause_type,
    finding_type,
    heading,
    original_text,
    simplified_text,
    page_number,
    severity,
    favored_party,
    risk_explanation,
    suggested_action,
    suggested_rewrite,
    confidence,
    requires_professional_review
  )
  select
    p_analysis_id,
    (clause_item.value ->> 'position')::smallint,
    clause_item.value ->> 'clause_type',
    clause_item.value ->> 'finding_type',
    clause_item.value ->> 'heading',
    clause_item.value ->> 'original_text',
    clause_item.value ->> 'simplified_text',
    null,
    clause_item.value ->> 'severity',
    clause_item.value ->> 'favored_party',
    clause_item.value ->> 'risk_explanation',
    clause_item.value ->> 'suggested_action',
    clause_item.value ->> 'suggested_rewrite',
    (clause_item.value ->> 'confidence')::numeric,
    (clause_item.value ->> 'requires_professional_review')::boolean
  from pg_catalog.jsonb_array_elements(p_clauses)
    with ordinality as clause_item(value, ordinality)
  order by clause_item.ordinality;

  update public.analyses as analysis
  set
    result_json = p_result,
    overall_risk_level = p_overall_risk_level,
    status = 'completed',
    completed_at = v_completed_at,
    error_message_safe = null,
    updated_at = v_completed_at,
    status_history =
      coalesce(analysis.status_history, '[]'::jsonb)
      || pg_catalog.jsonb_build_array(
        pg_catalog.jsonb_build_object(
          'status', 'completed',
          'at', v_completed_at
        )
      )
  where analysis.id = p_analysis_id;

  return query
  select
    analysis.id,
    analysis.status,
    analysis.completed_at,
    v_clause_count
  from public.analyses as analysis
  where analysis.id = p_analysis_id;
end;
$function$;

revoke execute on function public.complete_contract_analysis(
  uuid,
  text,
  jsonb,
  text,
  jsonb
) from public;

revoke execute on function public.complete_contract_analysis(
  uuid,
  text,
  jsonb,
  text,
  jsonb
) from anon;

revoke execute on function public.complete_contract_analysis(
  uuid,
  text,
  jsonb,
  text,
  jsonb
) from authenticated;

grant execute on function public.complete_contract_analysis(
  uuid,
  text,
  jsonb,
  text,
  jsonb
) to service_role;

commit;
