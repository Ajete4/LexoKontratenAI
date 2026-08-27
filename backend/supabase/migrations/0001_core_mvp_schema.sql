-- LexoKontraten AI - Core MVP schema
-- Local migration draft. Do not execute before review and approval.
-- Excludes pgvector, embeddings, legal_chunks, clause_citations, and Storage policies.

begin;

create extension if not exists pgcrypto with schema extensions;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  preferred_language text not null default 'sq',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint profiles_display_name_length_check
    check (char_length(btrim(display_name)) between 2 and 100),
  constraint profiles_preferred_language_check
    check (preferred_language in ('sq', 'en'))
);

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(
      nullif(btrim(new.raw_user_meta_data ->> 'display_name'), ''),
      nullif(btrim(new.raw_user_meta_data ->> 'full_name'), ''),
      'Perdorues'
    )
  );

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

create table public.contracts (
  id uuid primary key default extensions.gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  contract_type text not null,
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint contracts_title_length_check
    check (char_length(btrim(title)) between 1 and 200),
  constraint contracts_type_check
    check (contract_type in ('service', 'employment', 'lease')),
  constraint contracts_status_check
    check (status in ('draft', 'uploaded', 'processing', 'analyzed', 'failed', 'archived'))
);

create table public.contract_versions (
  id uuid primary key default extensions.gen_random_uuid(),
  contract_id uuid not null references public.contracts(id) on delete cascade,
  version_number integer not null,
  source_kind text not null,
  original_filename text,
  storage_bucket text,
  storage_path text,
  extracted_text text,
  mime_type text,
  file_size_bytes bigint,
  sha256 text,
  page_count integer,
  extraction_status text not null default 'pending',
  extraction_error_safe text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint contract_versions_contract_version_unique
    unique (contract_id, version_number),
  constraint contract_versions_storage_object_unique
    unique (storage_bucket, storage_path),
  constraint contract_versions_version_number_check
    check (version_number > 0),
  constraint contract_versions_source_kind_check
    check (source_kind in ('upload', 'generated', 'edited')),
  constraint contract_versions_file_size_check
    check (file_size_bytes is null or file_size_bytes >= 0),
  constraint contract_versions_page_count_check
    check (page_count is null or page_count >= 0),
  constraint contract_versions_sha256_check
    check (sha256 is null or sha256 ~ '^[0-9a-f]{64}$'),
  constraint contract_versions_mime_type_check
    check (
      mime_type is null
      or mime_type in (
        'application/pdf',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'text/plain'
      )
    ),
  constraint contract_versions_extraction_status_check
    check (extraction_status in ('pending', 'extracting', 'completed', 'failed', 'unsupported', 'requires_ocr')),
  constraint contract_versions_storage_pair_check
    check (
      (storage_bucket is null and storage_path is null)
      or (storage_bucket is not null and storage_path is not null)
    ),
  constraint contract_versions_upload_storage_check
    check (
      source_kind <> 'upload'
      or (storage_bucket is not null and storage_path is not null and mime_type is not null)
    )
);

create table public.analyses (
  id uuid primary key default extensions.gen_random_uuid(),
  contract_version_id uuid not null references public.contract_versions(id) on delete cascade,
  requested_by uuid not null references auth.users(id) on delete cascade,
  status text not null default 'queued',
  status_history jsonb not null default '[]'::jsonb,
  pipeline_version text not null,
  model_name text,
  prompt_version text,
  retrieval_config jsonb,
  started_at timestamptz,
  completed_at timestamptz,
  error_message_safe text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint analyses_status_check
    check (status in ('queued', 'extracting', 'retrieving', 'analyzing', 'completed', 'failed')),
  constraint analyses_status_history_array_check
    check (jsonb_typeof(status_history) = 'array'),
  constraint analyses_retrieval_config_object_check
    check (retrieval_config is null or jsonb_typeof(retrieval_config) = 'object'),
  constraint analyses_completion_time_check
    check (completed_at is null or started_at is null or completed_at >= started_at),
  constraint analyses_completed_fields_check
    check (status <> 'completed' or completed_at is not null),
  constraint analyses_failed_error_check
    check (status <> 'failed' or error_message_safe is not null),
  constraint analyses_error_message_length_check
    check (error_message_safe is null or char_length(error_message_safe) <= 500)
);

comment on column public.analyses.error_message_safe is
  'Sanitized technical error only. Must not contain contract text, personal data, prompts, tokens, or secrets.';

create table public.clauses (
  id uuid primary key default extensions.gen_random_uuid(),
  analysis_id uuid not null references public.analyses(id) on delete cascade,
  clause_type text not null,
  finding_type text not null default 'normal',
  heading text,
  original_text text,
  simplified_text text,
  page_number integer,
  severity text not null default 'none',
  favored_party text not null default 'not_applicable',
  risk_explanation text,
  suggested_action text,
  suggested_rewrite text,
  confidence numeric(5,4),
  requires_professional_review boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint clauses_type_check
    check (
      clause_type in (
        'parties', 'subject', 'obligations', 'duration', 'payment',
        'penalty', 'termination', 'jurisdiction', 'confidentiality',
        'liability', 'data_protection', 'dispute_resolution', 'other'
      )
    ),
  constraint clauses_finding_type_check
    check (finding_type in ('normal', 'risky', 'imbalanced', 'missing', 'ambiguous')),
  constraint clauses_original_text_check
    check (
      (finding_type = 'missing' and original_text is null)
      or (
        finding_type <> 'missing'
        and original_text is not null
        and char_length(btrim(original_text)) > 0
      )
    ),
  constraint clauses_page_number_check
    check (page_number is null or page_number > 0),
  constraint clauses_severity_check
    check (severity in ('none', 'low', 'medium', 'high', 'critical', 'review_required')),
  constraint clauses_favored_party_check
    check (favored_party in ('party_a', 'party_b', 'balanced', 'unclear', 'not_applicable')),
  constraint clauses_confidence_check
    check (confidence is null or confidence between 0 and 1),
  constraint clauses_missing_severity_check
    check (finding_type <> 'missing' or severity <> 'none')
);

create table public.legal_sources (
  id uuid primary key default extensions.gen_random_uuid(),
  title text not null,
  law_number text not null,
  official_url text not null,
  publication_date date,
  version_label text not null,
  retrieved_at timestamptz not null,
  storage_path text,
  sha256 text not null,
  language text not null default 'sq',
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint legal_sources_law_version_language_unique
    unique (law_number, version_label, language),
  constraint legal_sources_sha256_unique
    unique (sha256),
  constraint legal_sources_title_check
    check (char_length(btrim(title)) > 0),
  constraint legal_sources_law_number_check
    check (char_length(btrim(law_number)) > 0),
  constraint legal_sources_official_url_check
    check (official_url ~* '^https://'),
  constraint legal_sources_sha256_check
    check (sha256 ~ '^[0-9a-f]{64}$'),
  constraint legal_sources_language_check
    check (language in ('sq', 'en', 'sr')),
  constraint legal_sources_status_check
    check (status in ('draft', 'verified', 'active', 'superseded'))
);

comment on column public.legal_sources.official_url is
  'Verified official publication URL for the Kosovo legal source.';

create table public.generated_contracts (
  id uuid primary key default extensions.gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  contract_type text not null,
  title text not null,
  structured_input jsonb not null,
  generated_content text,
  status text not null default 'draft',
  model_name text,
  prompt_version text,
  docx_storage_path text,
  pdf_storage_path text,
  disclaimer_included boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint generated_contracts_type_check
    check (contract_type in ('service', 'employment', 'lease')),
  constraint generated_contracts_title_check
    check (char_length(btrim(title)) between 1 and 200),
  constraint generated_contracts_input_object_check
    check (jsonb_typeof(structured_input) = 'object'),
  constraint generated_contracts_content_check
    check (
      status not in ('draft', 'ready')
      or (
        generated_content is not null
        and char_length(btrim(generated_content)) > 0
      )
    ),
  constraint generated_contracts_status_check
    check (status in ('generating', 'draft', 'ready', 'failed', 'archived')),
  constraint generated_contracts_ready_disclaimer_check
    check (status <> 'ready' or disclaimer_included = true)
);

-- Foreign-key and common access-path indexes.
create index contracts_owner_id_idx
  on public.contracts (owner_id);
create index contracts_owner_created_at_idx
  on public.contracts (owner_id, created_at desc);
create index contracts_owner_status_idx
  on public.contracts (owner_id, status);

create index contract_versions_contract_id_idx
  on public.contract_versions (contract_id);
create index contract_versions_contract_created_at_idx
  on public.contract_versions (contract_id, created_at desc);
create index contract_versions_sha256_idx
  on public.contract_versions (sha256)
  where sha256 is not null;

create index analyses_contract_version_id_idx
  on public.analyses (contract_version_id);
create index analyses_requested_by_idx
  on public.analyses (requested_by);
create index analyses_contract_version_created_at_idx
  on public.analyses (contract_version_id, created_at desc);
create index analyses_requested_by_created_at_idx
  on public.analyses (requested_by, created_at desc);
create index analyses_active_status_idx
  on public.analyses (status, created_at)
  where status in ('queued', 'extracting', 'retrieving', 'analyzing');

create index clauses_analysis_id_idx
  on public.clauses (analysis_id);
create index clauses_analysis_type_idx
  on public.clauses (analysis_id, clause_type);
create index clauses_analysis_severity_idx
  on public.clauses (analysis_id, severity);

create index legal_sources_status_idx
  on public.legal_sources (status);

create index generated_contracts_owner_id_idx
  on public.generated_contracts (owner_id);
create index generated_contracts_owner_created_at_idx
  on public.generated_contracts (owner_id, created_at desc);
create index generated_contracts_owner_status_idx
  on public.generated_contracts (owner_id, status);

-- updated_at triggers.
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

create trigger contracts_set_updated_at
  before update on public.contracts
  for each row execute function public.set_updated_at();

create trigger contract_versions_set_updated_at
  before update on public.contract_versions
  for each row execute function public.set_updated_at();

create trigger analyses_set_updated_at
  before update on public.analyses
  for each row execute function public.set_updated_at();

create trigger clauses_set_updated_at
  before update on public.clauses
  for each row execute function public.set_updated_at();

create trigger legal_sources_set_updated_at
  before update on public.legal_sources
  for each row execute function public.set_updated_at();

create trigger generated_contracts_set_updated_at
  before update on public.generated_contracts
  for each row execute function public.set_updated_at();

-- Enable RLS for every MVP table.
alter table public.profiles enable row level security;
alter table public.contracts enable row level security;
alter table public.contract_versions enable row level security;
alter table public.analyses enable row level security;
alter table public.clauses enable row level security;
alter table public.legal_sources enable row level security;
alter table public.generated_contracts enable row level security;

-- Profiles: each authenticated user sees and updates only their profile.
create policy profiles_select_own
  on public.profiles for select
  to authenticated
  using ((select auth.uid()) = id);

create policy profiles_update_own
  on public.profiles for update
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- Contracts: direct ownership.
create policy contracts_select_own
  on public.contracts for select
  to authenticated
  using ((select auth.uid()) = owner_id);

create policy contracts_insert_own
  on public.contracts for insert
  to authenticated
  with check ((select auth.uid()) = owner_id);

create policy contracts_update_own
  on public.contracts for update
  to authenticated
  using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);

create policy contracts_delete_own
  on public.contracts for delete
  to authenticated
  using ((select auth.uid()) = owner_id);

-- Contract versions: ownership inherited from the parent contract.
create policy contract_versions_select_own
  on public.contract_versions for select
  to authenticated
  using (
    exists (
      select 1
      from public.contracts c
      where c.id = contract_versions.contract_id
        and c.owner_id = (select auth.uid())
    )
  );

create policy contract_versions_insert_own
  on public.contract_versions for insert
  to authenticated
  with check (
    extraction_status = 'pending'
    and extracted_text is null
    and extraction_error_safe is null
    and exists (
        select 1
        from public.contracts c
        where c.id = contract_versions.contract_id
          and c.owner_id = (select auth.uid())
      )
  );

-- Analyses: ownership inherited through contract_versions and contracts.
create policy analyses_select_own
  on public.analyses for select
  to authenticated
  using (
    requested_by = (select auth.uid())
    and exists (
      select 1
      from public.contract_versions cv
      join public.contracts c on c.id = cv.contract_id
      where cv.id = analyses.contract_version_id
        and c.owner_id = (select auth.uid())
    )
  );

-- Clauses: ownership inherited through analysis, version, and contract.
create policy clauses_select_own
  on public.clauses for select
  to authenticated
  using (
    exists (
      select 1
      from public.analyses a
      join public.contract_versions cv on cv.id = a.contract_version_id
      join public.contracts c on c.id = cv.contract_id
      where a.id = clauses.analysis_id
        and c.owner_id = (select auth.uid())
    )
  );

-- Verified legal sources are read-only for authenticated users.
-- Writes are intentionally reserved for trusted backend/service-role operations.
create policy legal_sources_select_verified
  on public.legal_sources for select
  to authenticated
  using (status in ('verified', 'active'));

-- Generated contracts: direct ownership.
create policy generated_contracts_select_own
  on public.generated_contracts for select
  to authenticated
  using ((select auth.uid()) = owner_id);

-- Explicit minimum table privileges. RLS policies continue to restrict row access.
revoke all privileges on table public.profiles from anon;
revoke all privileges on table public.contracts from anon;
revoke all privileges on table public.contract_versions from anon;
revoke all privileges on table public.analyses from anon;
revoke all privileges on table public.clauses from anon;
revoke all privileges on table public.legal_sources from anon;
revoke all privileges on table public.generated_contracts from anon;

grant select, update on table public.profiles to authenticated;
grant select, insert, update, delete on table public.contracts to authenticated;
grant select, insert on table public.contract_versions to authenticated;
grant select on table public.analyses to authenticated;
grant select on table public.clauses to authenticated;
grant select on table public.legal_sources to authenticated;
grant select on table public.generated_contracts to authenticated;

grant all privileges on table public.profiles to service_role;
grant all privileges on table public.contracts to service_role;
grant all privileges on table public.contract_versions to service_role;
grant all privileges on table public.analyses to service_role;
grant all privileges on table public.clauses to service_role;
grant all privileges on table public.legal_sources to service_role;
grant all privileges on table public.generated_contracts to service_role;

commit;
