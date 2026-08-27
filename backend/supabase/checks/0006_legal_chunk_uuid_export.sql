-- Read-only export for mapping approved P0 chunks to their remote UUIDs.
-- Export the result as JSON from Supabase SQL Editor. This query performs no writes.

select
  chunk.id,
  chunk.legal_source_id,
  source.law_number,
  source.version_label,
  source.language,
  chunk.chunk_index,
  chunk.content_hash
from public.legal_chunks as chunk
join public.legal_sources as source on source.id = chunk.legal_source_id
where (source.law_number, source.version_label, source.language) in (
  ('03/L-212', 'gazette-90-2010', 'sq'),
  ('04/L-077', 'gazette-16-2012', 'sq'),
  ('08/L-142', 'gazette-18-2024', 'sq')
)
order by
  case source.law_number
    when '03/L-212' then 1
    when '04/L-077' then 2
    when '08/L-142' then 3
  end,
  chunk.chunk_index;
