-- Minimal authenticated Q&A history for the MVP.

create table public.contract_questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  contract_id uuid not null references public.contracts(id) on delete cascade,
  version_id uuid not null references public.contract_versions(id) on delete cascade,
  question text not null,
  answer text not null,
  created_at timestamptz not null default pg_catalog.clock_timestamp(),
  constraint contract_questions_question_check
    check (pg_catalog.char_length(pg_catalog.btrim(question)) between 1 and 1000),
  constraint contract_questions_answer_check
    check (pg_catalog.char_length(pg_catalog.btrim(answer)) between 1 and 4000)
);

create index contract_questions_user_created_at_idx
  on public.contract_questions (user_id, created_at desc);

create index contract_questions_contract_id_idx
  on public.contract_questions (contract_id);

create index contract_questions_version_id_idx
  on public.contract_questions (version_id);

alter table public.contract_questions enable row level security;

create policy contract_questions_select_own
  on public.contract_questions for select
  to authenticated
  using (user_id = (select auth.uid()));

create policy contract_questions_insert_own
  on public.contract_questions for insert
  to authenticated
  with check (
    user_id = (select auth.uid())
    and exists (
      select 1
      from public.contracts c
      join public.contract_versions v
        on v.contract_id = c.id
      join public.analyses a
        on a.contract_version_id = v.id
      where c.id = contract_questions.contract_id
        and v.id = contract_questions.version_id
        and c.owner_id = (select auth.uid())
        and a.status = 'completed'
        and a.pipeline_version in ('analysis-v1', 'analysis-rag-v1')
    )
  );

revoke all on table public.contract_questions from anon;
revoke all on table public.contract_questions from authenticated;
grant select, insert on table public.contract_questions to authenticated;
grant all on table public.contract_questions to service_role;
