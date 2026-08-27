-- Read-only postflight for migration 0009. Execute manually after applying it.

select
  conname,
  pg_catalog.pg_get_constraintdef(oid) as definition,
  convalidated
from pg_catalog.pg_constraint
where conrelid = 'public.contract_versions'::pg_catalog.regclass
  and conname in (
    'contract_versions_source_kind_check',
    'contract_versions_pasted_shape_check',
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
  p.oid::pg_catalog.regprocedure as function_signature,
  p.prosecdef as security_definer,
  p.proconfig as function_configuration,
  pg_catalog.has_function_privilege(
    'anon',
    p.oid,
    'EXECUTE'
  ) as anon_execute,
  pg_catalog.has_function_privilege(
    'authenticated',
    p.oid,
    'EXECUTE'
  ) as authenticated_execute,
  pg_catalog.has_function_privilege(
    'service_role',
    p.oid,
    'EXECUTE'
  ) as service_role_execute
from pg_catalog.pg_proc p
join pg_catalog.pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname = 'create_pasted_contract'
  and pg_catalog.pg_get_function_identity_arguments(p.oid) = 'p_title text, p_contract_type text, p_text text';

select
  pg_catalog.count(*) as contract_version_rows_after_migration
from public.contract_versions;
