-- Read-only preflight for migration 0005. This file performs no writes.

select
  name,
  default_version,
  installed_version,
  comment
from pg_available_extensions
where name = 'vector';

select
  version,
  installed,
  superuser,
  relocatable,
  schema
from pg_available_extension_versions
where name = 'vector'
order by string_to_array(version, '.')::integer[] desc;

select
  extension.extname,
  extension.extversion,
  namespace.nspname as extension_schema
from pg_extension as extension
join pg_namespace as namespace on namespace.oid = extension.extnamespace
where extension.extname = 'vector';

select
  exists (
    select 1
    from pg_available_extension_versions
    where name = 'vector'
      and string_to_array(version, '.')::integer[] >= array[0, 5, 0]
  ) as hnsw_compatible_version_available;

select
  column_name,
  data_type,
  udt_schema,
  udt_name,
  is_nullable
from information_schema.columns
where table_schema = 'public'
  and table_name = 'legal_chunks'
order by ordinal_position;

select count(*) as legal_chunk_count
from public.legal_chunks;

select
  count(*) filter (where token_count is null) as null_token_count_rows,
  count(*) filter (where btrim(content) = '') as empty_content_rows,
  count(distinct content_hash) as distinct_content_hashes
from public.legal_chunks;

select
  grantee,
  privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name = 'legal_chunks'
  and grantee in ('anon', 'authenticated', 'service_role')
order by grantee, privilege_type;

select
  namespace.nspname as table_schema,
  relation.relname as table_name,
  relation.relrowsecurity as rls_enabled
from pg_class as relation
join pg_namespace as namespace on namespace.oid = relation.relnamespace
where namespace.nspname = 'public'
  and relation.relname = 'legal_chunks';
