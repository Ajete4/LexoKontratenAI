begin;

create table public.contract_notes_checklists (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  contract_id uuid not null references public.contracts(id) on delete cascade,
  version_id uuid not null references public.contract_versions(id) on delete cascade,
  notes text not null default '',
  checklist boolean[] not null default array[false, false, false, false, false, false],
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint contract_notes_checklists_owner_contract_version_unique
    unique (user_id, contract_id, version_id),
  constraint contract_notes_checklists_notes_length_check
    check (char_length(notes) <= 10000),
  constraint contract_notes_checklists_six_items_check
    check (
      cardinality(checklist) = 6
      and array_position(checklist, null) is null
    )
);

create index contract_notes_checklists_contract_id_idx
  on public.contract_notes_checklists (contract_id);

create index contract_notes_checklists_version_id_idx
  on public.contract_notes_checklists (version_id);

create trigger contract_notes_checklists_set_updated_at
  before update on public.contract_notes_checklists
  for each row execute function public.set_updated_at();

alter table public.contract_notes_checklists enable row level security;

create policy contract_notes_checklists_select_own
  on public.contract_notes_checklists for select
  to authenticated
  using (
    user_id = (select auth.uid())
    and exists (
      select 1
      from public.contracts c
      join public.contract_versions v on v.contract_id = c.id
      where c.id = contract_notes_checklists.contract_id
        and v.id = contract_notes_checklists.version_id
        and c.owner_id = (select auth.uid())
    )
  );

create policy contract_notes_checklists_insert_own
  on public.contract_notes_checklists for insert
  to authenticated
  with check (
    user_id = (select auth.uid())
    and exists (
      select 1
      from public.contracts c
      join public.contract_versions v on v.contract_id = c.id
      where c.id = contract_notes_checklists.contract_id
        and v.id = contract_notes_checklists.version_id
        and c.owner_id = (select auth.uid())
    )
  );

create policy contract_notes_checklists_update_own
  on public.contract_notes_checklists for update
  to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and exists (
      select 1
      from public.contracts c
      join public.contract_versions v on v.contract_id = c.id
      where c.id = contract_notes_checklists.contract_id
        and v.id = contract_notes_checklists.version_id
        and c.owner_id = (select auth.uid())
    )
  );

revoke all on table public.contract_notes_checklists from anon;
revoke all on table public.contract_notes_checklists from authenticated;
grant select, insert, update on table public.contract_notes_checklists to authenticated;
grant all privileges on table public.contract_notes_checklists to service_role;

commit;
