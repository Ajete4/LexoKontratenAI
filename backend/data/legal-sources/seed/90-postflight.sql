-- Read-only postflight for the P0 legal seed.
WITH expected(law_number, expected_chunks) AS (VALUES
  ('03/L-212', 100), ('04/L-077', 1059), ('08/L-142', 7)
), actual AS (
  SELECT source.law_number, count(chunk.id)::integer AS actual_chunks
  FROM public.legal_sources AS source
  LEFT JOIN public.legal_chunks AS chunk ON chunk.legal_source_id = source.id
  WHERE (source.law_number, source.version_label, source.language) IN (
    ('03/L-212', 'gazette-90-2010', 'sq'),
    ('04/L-077', 'gazette-16-2012', 'sq'),
    ('08/L-142', 'gazette-18-2024', 'sq')
  )
  GROUP BY source.id, source.law_number
)
SELECT expected.law_number, expected.expected_chunks, actual.actual_chunks,
  expected.expected_chunks = actual.actual_chunks AS count_matches
FROM expected LEFT JOIN actual USING (law_number)
ORDER BY expected.law_number;

SELECT count(*) AS p0_source_count
FROM public.legal_sources
WHERE (law_number, version_label, language) IN (
  ('03/L-212', 'gazette-90-2010', 'sq'),
  ('04/L-077', 'gazette-16-2012', 'sq'),
  ('08/L-142', 'gazette-18-2024', 'sq')
);

WITH expected_hashes(law_number, expected_sha256) AS (VALUES
  ('03/L-212', '98aaf8e8e06df611f1277a5305928e7d6a28bafe8322ab7fcdfd219a3a981da5'),
  ('04/L-077', '97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4'),
  ('08/L-142', '1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b')
)
SELECT source.law_number, source.sha256, expected.expected_sha256,
  source.sha256 = expected.expected_sha256 AS hash_matches,
  source.applicability, source.applicability_mode, source.ingestion_status
FROM public.legal_sources AS source
JOIN expected_hashes AS expected USING (law_number)
ORDER BY source.law_number;

SELECT source.law_number, min(chunk.chunk_index) AS minimum_index,
  max(chunk.chunk_index) AS maximum_index, count(*) AS chunk_count,
  count(DISTINCT chunk.chunk_index) AS unique_indexes,
  count(DISTINCT chunk.content_hash) AS unique_hashes,
  count(*) FILTER (WHERE btrim(chunk.content) = '') AS empty_chunks,
  count(*) FILTER (WHERE chunk.token_count IS NOT NULL) AS populated_token_counts
FROM public.legal_sources AS source
JOIN public.legal_chunks AS chunk ON chunk.legal_source_id = source.id
WHERE source.law_number IN ('03/L-212', '04/L-077', '08/L-142')
GROUP BY source.id, source.law_number
ORDER BY source.law_number;

SELECT count(*) AS p0_relation_count
FROM public.legal_source_relations AS relation
JOIN public.legal_sources AS base ON base.id = relation.base_source_id
JOIN public.legal_sources AS related ON related.id = relation.related_source_id
WHERE base.law_number IN ('03/L-212', '04/L-077', '08/L-142')
   OR related.law_number IN ('03/L-212', '04/L-077', '08/L-142');

SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
  AND grantee IN ('anon', 'authenticated', 'service_role')
ORDER BY grantee, table_name, privilege_type;

SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
  AND column_name IN ('embedding', 'vector');

SELECT n.nspname AS table_schema, c.relname AS table_name,
  c.relrowsecurity AS rls_enabled
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relname IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
ORDER BY c.relname;
