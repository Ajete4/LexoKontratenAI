-- Read-only postflight. Run manually only after migration 0008 is applied.
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'clause_citations'
order by ordinal_position;

select conname, contype, pg_get_constraintdef(oid) as definition
from pg_catalog.pg_constraint
where conrelid = 'public.clause_citations'::regclass
order by conname;

select indexname, indexdef
from pg_catalog.pg_indexes
where schemaname = 'public' and tablename = 'clause_citations'
order by indexname;

select relrowsecurity
from pg_catalog.pg_class
where oid = 'public.clause_citations'::regclass;

select grantee, privilege_type
from information_schema.role_table_grants
where table_schema = 'public' and table_name = 'clause_citations'
order by grantee, privilege_type;

select
  has_function_privilege('anon', 'public.complete_contract_analysis_with_citations(uuid,text,jsonb,text,jsonb,jsonb)', 'EXECUTE') as anon_execute,
  has_function_privilege('authenticated', 'public.complete_contract_analysis_with_citations(uuid,text,jsonb,text,jsonb,jsonb)', 'EXECUTE') as authenticated_execute,
  has_function_privilege('service_role', 'public.complete_contract_analysis_with_citations(uuid,text,jsonb,text,jsonb,jsonb)', 'EXECUTE') as service_role_execute;

select count(*) as citation_rows_after_install
from public.clause_citations;
