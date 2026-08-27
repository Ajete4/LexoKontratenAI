-- Read-only preflight. Run manually before applying migration 0008.
select to_regclass('public.clause_citations') as clause_citations_before;

select
  to_regprocedure('public.complete_contract_analysis(uuid,text,jsonb,text,jsonb)') as existing_completion_rpc,
  to_regprocedure('public.complete_contract_analysis_with_citations(uuid,text,jsonb,text,jsonb,jsonb)')
    as citation_completion_rpc_before;

select table_name, is_insertable_into
from information_schema.tables
where table_schema = 'public'
  and table_name in ('analyses', 'clauses', 'legal_chunks');

select conrelid::regclass::text as table_name, conname, pg_get_constraintdef(oid) as definition
from pg_catalog.pg_constraint
where conrelid in ('public.clauses'::regclass, 'public.legal_chunks'::regclass)
order by table_name, conname;

select relname, relrowsecurity
from pg_catalog.pg_class
where oid in ('public.clauses'::regclass, 'public.legal_chunks'::regclass);
