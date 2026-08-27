-- Read-only preflight for the P0 legal seed.
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
ORDER BY table_name;

SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
ORDER BY table_name, ordinal_position;

SELECT count(*) AS current_legal_source_count FROM public.legal_sources;

SELECT law_number, version_label, language, sha256
FROM public.legal_sources
WHERE (law_number, version_label, language) IN (
  ('03/L-212', 'gazette-90-2010', 'sq'),
  ('04/L-077', 'gazette-16-2012', 'sq'),
  ('08/L-142', 'gazette-18-2024', 'sq')
)
ORDER BY law_number;

SELECT sha256, count(*) AS source_count
FROM public.legal_sources
GROUP BY sha256
HAVING count(*) > 1;

SELECT version_label, language, count(*) AS source_count
FROM public.legal_sources
GROUP BY version_label, language
HAVING count(*) > 1;

SELECT source.law_number, source.version_label, count(chunk.id) AS chunk_count
FROM public.legal_sources AS source
LEFT JOIN public.legal_chunks AS chunk ON chunk.legal_source_id = source.id
WHERE (source.law_number, source.version_label, source.language) IN (
  ('03/L-212', 'gazette-90-2010', 'sq'),
  ('04/L-077', 'gazette-16-2012', 'sq'),
  ('08/L-142', 'gazette-18-2024', 'sq')
)
GROUP BY source.id, source.law_number, source.version_label
ORDER BY source.law_number;

SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
  AND grantee IN ('anon', 'authenticated', 'service_role')
ORDER BY grantee, table_name, privilege_type;

SELECT EXISTS (
  SELECT 1 FROM pg_extension WHERE extname = 'vector'
) AS vector_extension_exists;

SELECT n.nspname AS table_schema, c.relname AS table_name,
  c.relrowsecurity AS rls_enabled
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relname IN ('legal_sources', 'legal_chunks', 'legal_source_relations')
ORDER BY c.relname;
