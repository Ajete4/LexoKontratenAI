begin;

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
  v_started_at timestamptz;
  v_clause jsonb;
  v_clause_count integer;
  v_ordinality bigint;
  v_completed_at timestamptz;
begin
  select analysis.status, analysis.pipeline_version, analysis.started_at
  into v_analysis_status, v_pipeline_version, v_started_at
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

  v_completed_at :=
    case
      when v_started_at is null then pg_catalog.clock_timestamp()
      else greatest(
        pg_catalog.clock_timestamp(),
        v_started_at
      )
    end;

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
    v_completed_at,
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
