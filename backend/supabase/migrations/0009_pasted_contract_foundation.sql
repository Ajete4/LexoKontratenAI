-- Foundation for authenticated, atomic contract creation from pasted plain text.
-- This migration does not modify existing rows and does not access Storage or AI.

alter table public.contract_versions
  drop constraint contract_versions_source_kind_check;

alter table public.contract_versions
  add constraint contract_versions_source_kind_check
  check (source_kind in ('upload', 'generated', 'edited', 'pasted'));

alter table public.contract_versions
  add constraint contract_versions_pasted_shape_check
  check (
    source_kind <> 'pasted'
    or (
      storage_bucket is null
      and storage_path is null
      and original_filename is null
      and mime_type is null
      and file_size_bytes is null
      and sha256 is null
      and page_count is null
      and extraction_status = 'completed'
      and extracted_text is not null
      and pg_catalog.btrim(extracted_text) <> ''
      and extraction_error_safe is null
    )
  );

drop policy contract_versions_insert_own on public.contract_versions;

create policy contract_versions_insert_own
  on public.contract_versions for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.contracts c
      where c.id = contract_versions.contract_id
        and c.owner_id = (select auth.uid())
    )
    and (
      (
        extraction_status = 'pending'
        and extracted_text is null
        and extraction_error_safe is null
      )
      or (
        source_kind = 'pasted'
        and storage_bucket is null
        and storage_path is null
        and original_filename is null
        and mime_type is null
        and file_size_bytes is null
        and sha256 is null
        and page_count is null
        and extraction_status = 'completed'
        and extracted_text is not null
        and pg_catalog.btrim(extracted_text) <> ''
        and extraction_error_safe is null
      )
    )
  );

create or replace function public.create_pasted_contract(
  p_title text,
  p_contract_type text,
  p_text text
)
returns table (
  contract_id uuid,
  version_id uuid,
  version_number integer,
  source_kind text,
  extraction_status text,
  page_count integer,
  created_at timestamptz
)
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_user_id uuid;
  v_contract_id uuid;
  v_version_id uuid;
  v_created_at timestamptz;
begin
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception using
      errcode = '28000',
      message = 'AUTHENTICATION_REQUIRED';
  end if;

  if p_title is null
    or pg_catalog.char_length(pg_catalog.btrim(p_title)) not between 1 and 200 then
    raise exception using
      errcode = '22023',
      message = 'PASTED_CONTRACT_TITLE_INVALID';
  end if;

  if p_contract_type is null
    or p_contract_type not in ('employment', 'service', 'lease') then
    raise exception using
      errcode = '22023',
      message = 'PASTED_CONTRACT_TYPE_INVALID';
  end if;

  -- Matches the existing analysis input ceiling and also bounds UTF-8 bytes.
  if p_text is null
    or pg_catalog.btrim(p_text) = ''
    or pg_catalog.char_length(p_text) > 80000
    or pg_catalog.octet_length(p_text) > 320000 then
    raise exception using
      errcode = '22023',
      message = 'PASTED_CONTRACT_TEXT_INVALID';
  end if;

  insert into public.contracts (
    owner_id,
    title,
    contract_type,
    status
  ) values (
    v_user_id,
    p_title,
    p_contract_type,
    'processing'
  )
  returning id into v_contract_id;

  insert into public.contract_versions (
    contract_id,
    version_number,
    source_kind,
    original_filename,
    storage_bucket,
    storage_path,
    extracted_text,
    mime_type,
    file_size_bytes,
    sha256,
    page_count,
    extraction_status,
    extraction_error_safe
  ) values (
    v_contract_id,
    1,
    'pasted',
    null,
    null,
    null,
    p_text,
    null,
    null,
    null,
    null,
    'completed',
    null
  )
  returning id, contract_versions.created_at
    into v_version_id, v_created_at;

  return query
  select
    v_contract_id,
    v_version_id,
    1,
    'pasted'::text,
    'completed'::text,
    null::integer,
    v_created_at;
end;
$$;

revoke all on function public.create_pasted_contract(text, text, text) from public;
revoke all on function public.create_pasted_contract(text, text, text) from anon;
revoke all on function public.create_pasted_contract(text, text, text) from service_role;
grant execute on function public.create_pasted_contract(text, text, text) to authenticated;
