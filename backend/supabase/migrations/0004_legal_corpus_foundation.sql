-- LexoKontraten AI - Legal corpus foundation for the MVP.
-- Local migration draft. Do not execute before review and approval.
-- Excludes source seeds, ingestion, embeddings, pgvector, and retrieval functions.

begin;

-- Extend the existing document-level registry without replacing or deleting data.
alter table public.legal_sources
  add column document_type text not null default 'unclassified',
  add column issuing_institution text,
  add column official_gazette_number text,
  add column official_document_url text,
  add column jurisdiction text not null default 'XK',
  add column legal_status text not null default 'requires_manual_legal_verification',
  add column is_consolidated boolean,
  add column verified_source boolean not null default false,
  add column verified_at timestamptz,
  add column content_sha256 text generated always as (sha256) stored,
  add column applicability text[] not null default '{}'::text[],
  add column applicability_mode text not null default 'unclassified',
  add column ingestion_status text not null default 'pending';

alter table public.legal_sources
  add constraint legal_sources_document_type_check
    check (document_type in ('unclassified', 'law', 'amendment')),
  add constraint legal_sources_issuing_institution_check
    check (
      issuing_institution is null
      or char_length(btrim(issuing_institution)) between 1 and 200
    ),
  add constraint legal_sources_official_gazette_number_check
    check (
      official_gazette_number is null
      or char_length(btrim(official_gazette_number)) between 1 and 100
    ),
  add constraint legal_sources_official_document_url_check
    check (
      official_document_url is null
      or official_document_url ~* '^https://'
    ),
  add constraint legal_sources_jurisdiction_check
    check (jurisdiction = 'XK'),
  add constraint legal_sources_legal_status_check
    check (
      legal_status in (
        'requires_manual_legal_verification',
        'verified_current',
        'superseded',
        'repealed'
      )
    ),
  add constraint legal_sources_verified_at_check
    check (not verified_source or verified_at is not null),
  add constraint legal_sources_applicability_check
    check (
      applicability <@ array['employment', 'service', 'lease']::text[]
      and cardinality(applicability) <= 3
      and (
        cardinality(applicability) < 2
        or applicability[1] <> applicability[2]
      )
      and (
        cardinality(applicability) < 3
        or (
          applicability[1] <> applicability[3]
          and applicability[2] <> applicability[3]
        )
      )
    ),
  add constraint legal_sources_applicability_mode_check
    check (
      applicability_mode in (
        'unclassified',
        'direct',
        'amendment_scope',
        'conditional_horizontal'
      )
    ),
  add constraint legal_sources_ingestion_status_check
    check (
      ingestion_status in (
        'pending',
        'source_verified',
        'ingesting',
        'ingested',
        'failed',
        'deferred'
      )
    );

-- New corpus rows are Albanian-only. NOT VALID avoids making assumptions about
-- any pre-existing rows while enforcing the rule for future inserts/updates.
alter table public.legal_sources
  add constraint legal_sources_mvp_language_check
    check (language = 'sq') not valid;

comment on column public.legal_sources.content_sha256 is
  'Generated alias of the existing verified SHA-256 document-content hash.';
comment on column public.legal_sources.applicability is
  'MVP contract types for which the verified source provisions may be relevant.';
comment on column public.legal_sources.applicability_mode is
  'direct, amendment_scope, or conditional_horizontal; never implies automatic citation.';
comment on column public.legal_sources.ingestion_status is
  'Operational corpus state only; it does not assert the legal status of the source.';

create table public.legal_chunks (
  id uuid primary key default extensions.gen_random_uuid(),
  legal_source_id uuid not null
    references public.legal_sources(id) on delete cascade,
  chunk_index integer not null,
  article_number varchar(64),
  article_title varchar(300),
  paragraph_number varchar(64),
  point_label varchar(64),
  content text not null,
  content_hash text not null,
  token_count integer,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),

  constraint legal_chunks_source_index_unique
    unique (legal_source_id, chunk_index),
  constraint legal_chunks_source_content_hash_unique
    unique (legal_source_id, content_hash),
  constraint legal_chunks_chunk_index_check
    check (chunk_index >= 0),
  constraint legal_chunks_article_number_check
    check (
      article_number is null
      or char_length(btrim(article_number)) between 1 and 64
    ),
  constraint legal_chunks_article_title_check
    check (
      article_title is null
      or char_length(btrim(article_title)) between 1 and 300
    ),
  constraint legal_chunks_paragraph_number_check
    check (
      paragraph_number is null
      or char_length(btrim(paragraph_number)) between 1 and 64
    ),
  constraint legal_chunks_point_label_check
    check (
      point_label is null
      or char_length(btrim(point_label)) between 1 and 64
    ),
  constraint legal_chunks_content_check
    check (char_length(btrim(content)) > 0),
  constraint legal_chunks_content_hash_check
    check (content_hash ~ '^[0-9a-f]{64}$'),
  constraint legal_chunks_token_count_check
    check (token_count is null or token_count > 0),
  constraint legal_chunks_metadata_object_check
    check (jsonb_typeof(metadata) = 'object')
);

comment on table public.legal_chunks is
  'Verified legal-text chunks with article-level provenance; contains no embeddings.';

create table public.legal_source_relations (
  id uuid primary key default extensions.gen_random_uuid(),
  base_source_id uuid not null
    references public.legal_sources(id) on delete cascade,
  related_source_id uuid not null
    references public.legal_sources(id) on delete cascade,
  relationship_type text not null,
  base_article_number varchar(64),
  related_article_number varchar(64),
  verification_notes varchar(500),
  created_at timestamptz not null default now(),

  constraint legal_source_relations_no_self_reference_check
    check (base_source_id <> related_source_id),
  constraint legal_source_relations_type_check
    check (relationship_type in ('amend', 'supplement', 'repeal')),
  constraint legal_source_relations_article_provenance_check
    check (
      (
        relationship_type in ('amend', 'supplement')
        and
        base_article_number is not null
        and related_article_number is not null
      )
      or
      (
        relationship_type = 'repeal'
        and (
          (
            base_article_number is null
            and related_article_number is null
          )
          or
          (
            base_article_number is not null
            and related_article_number is not null
          )
        )
      )
    ),
  constraint legal_source_relations_base_article_check
    check (
      base_article_number is null
      or char_length(btrim(base_article_number)) between 1 and 64
    ),
  constraint legal_source_relations_related_article_check
    check (
      related_article_number is null
      or char_length(btrim(related_article_number)) between 1 and 64
    ),
  constraint legal_source_relations_notes_check
    check (
      verification_notes is null
      or char_length(btrim(verification_notes)) between 1 and 500
    )
);

comment on table public.legal_source_relations is
  'Verified amendment/supplement/repeal provenance; does not create a consolidated text.';

create unique index legal_source_relations_provenance_unique_idx
  on public.legal_source_relations (
    base_source_id,
    related_source_id,
    relationship_type,
    coalesce(base_article_number, ''),
    coalesce(related_article_number, '')
  );

-- Filtering and provenance access paths. No vector index is created here.
create index legal_sources_document_type_idx
  on public.legal_sources (document_type);
create index legal_sources_legal_status_idx
  on public.legal_sources (legal_status);
create index legal_sources_ingestion_status_idx
  on public.legal_sources (ingestion_status);
create index legal_sources_law_number_idx
  on public.legal_sources (law_number);
create index legal_sources_applicability_idx
  on public.legal_sources using gin (applicability);

create index legal_chunks_legal_source_id_idx
  on public.legal_chunks (legal_source_id);
create index legal_chunks_source_article_idx
  on public.legal_chunks (legal_source_id, article_number, paragraph_number, point_label);
create index legal_chunks_content_hash_idx
  on public.legal_chunks (content_hash);

create index legal_source_relations_base_source_id_idx
  on public.legal_source_relations (base_source_id);
create index legal_source_relations_related_source_id_idx
  on public.legal_source_relations (related_source_id);
create index legal_source_relations_type_idx
  on public.legal_source_relations (relationship_type);

alter table public.legal_chunks enable row level security;
alter table public.legal_source_relations enable row level security;

-- The legal corpus is not directly exposed to browser roles. Future authenticated
-- reads must go through a backend endpoint and a narrowly scoped response contract.
drop policy if exists legal_sources_select_verified on public.legal_sources;

revoke all privileges on table public.legal_sources from public;
revoke all privileges on table public.legal_sources from anon;
revoke all privileges on table public.legal_sources from authenticated;
revoke all privileges on table public.legal_chunks from public;
revoke all privileges on table public.legal_chunks from anon;
revoke all privileges on table public.legal_chunks from authenticated;
revoke all privileges on table public.legal_source_relations from public;
revoke all privileges on table public.legal_source_relations from anon;
revoke all privileges on table public.legal_source_relations from authenticated;

grant all privileges on table public.legal_sources to service_role;
grant all privileges on table public.legal_chunks to service_role;
grant all privileges on table public.legal_source_relations to service_role;

commit;
