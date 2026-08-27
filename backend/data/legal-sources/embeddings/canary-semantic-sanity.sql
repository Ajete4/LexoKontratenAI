-- Read-only semantic sanity check. No legal text or vector is returned.
with canary as (
  select embedding
  from public.legal_chunks
  where id = 'd1a2e9f2-a182-45d1-8a2c-6f3c4bc27ca9'::uuid
    and content_hash = 'c3359a1dcee2c3ff67b2b4b495cad2e8b8ae55de1e73f0ad9848838c87d25ee3'
    and embedding is not null
)
select
  candidate.id,
  source.law_number,
  source.version_label,
  source.language,
  candidate.chunk_index,
  candidate.content_hash,
  candidate.embedding <=> canary.embedding as cosine_distance
from public.legal_chunks as candidate
join public.legal_sources as source on source.id = candidate.legal_source_id
cross join canary
where source.law_number in ('03/L-212', '04/L-077', '08/L-142')
  and candidate.embedding is not null
order by cosine_distance asc, candidate.id asc
limit 5;
