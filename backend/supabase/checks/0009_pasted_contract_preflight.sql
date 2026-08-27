-- Read-only preflight for migration 0009. Execute manually before applying it.

select
  pg_catalog.current_setting('server_version') as postgres_version;

select
  pg_catalog.count(*) as existing_contract_version_rows,
  pg_catalog.count(*) filter (where source_kind not in ('upload', 'generated', 'edited'))
    as incompatible_source_kind_rows
from public.contract_versions;

select
  conname,
  pg_catalog.pg_get_constraintdef(oid) as definition
from pg_catalog.pg_constraint
where conrelid = 'public.contract_versions'::pg_catalog.regclass
  and conname in (
    'contract_versions_source_kind_check',
    'contract_versions_upload_storage_check',
    'contract_versions_storage_pair_check'
  )
order by conname;

select
  policyname,
  roles,
  cmd,
  with_check
from pg_catalog.pg_policies
where schemaname = 'public'
  and tablename = 'contract_versions'
  and policyname = 'contract_versions_insert_own';

select
  pg_catalog.to_regprocedure(
    'public.create_pasted_contract(text,text,text)'
  ) as existing_function;
