import { createHash } from "node:crypto";

import type { LegalChunk } from "./legal-chunker.js";
import type { LegalSourceManifestEntry } from "./legal-source-manifest.js";

export const LEGAL_SEED_BATCH_LIMIT = 150;

export type SeedSource = {
  readonly title: string;
  readonly lawNumber: string;
  readonly officialUrl: string;
  readonly officialDocumentUrl: string;
  readonly publicationDate: string;
  readonly versionLabel: string;
  readonly retrievedAt: string;
  readonly sha256: string;
  readonly language: "sq";
  readonly status: "verified";
  readonly documentType: "law" | "amendment";
  readonly issuingInstitution: string;
  readonly officialGazetteNumber: string;
  readonly jurisdiction: "XK";
  readonly legalStatus: "requires_manual_legal_verification";
  readonly isConsolidated: false;
  readonly verifiedSource: true;
  readonly verifiedAt: string;
  readonly applicability: readonly ("employment" | "service" | "lease")[];
  readonly applicabilityMode: "direct" | "amendment_scope";
  readonly ingestionStatus: "ingested";
};

export type SeedChunk = {
  readonly chunkIndex: number;
  readonly articleNumber: string;
  readonly articleTitle: string | null;
  readonly paragraphNumber: string | null;
  readonly content: string;
  readonly contentHash: string;
  readonly tokenCount: null;
  readonly metadata: Record<string, unknown>;
};

export type SeedBatch = {
  readonly fileName: string;
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly language: "sq";
  readonly rows: readonly SeedChunk[];
  readonly replacesExistingChunks: boolean;
};

export function sha256(value: string | Buffer): string {
  return createHash("sha256").update(value).digest("hex");
}

export function sqlLiteral(value: string): string {
  return `'${value.replaceAll("'", "''")}'`;
}

function sqlNullable(value: string | null): string {
  return value === null ? "null" : sqlLiteral(value);
}

function sqlTextArray(values: readonly string[]): string {
  return `array[${values.map(sqlLiteral).join(", ")}]::text[]`;
}

export function mapSeedSource(
  source: LegalSourceManifestEntry,
  sourceSha256: string,
  retrievedAt: string
): SeedSource {
  if (source.versionLabel === null) {
    throw new Error("LEGAL_SEED_VERSION_LABEL_REQUIRED");
  }

  return {
    title: source.title,
    lawNumber: source.lawNumber,
    officialUrl: source.officialUrl,
    officialDocumentUrl: source.officialDocumentUrl,
    publicationDate: source.publicationDate,
    versionLabel: source.versionLabel,
    retrievedAt,
    sha256: sourceSha256,
    language: "sq",
    status: "verified",
    documentType: source.documentType,
    issuingInstitution: source.issuingInstitution,
    officialGazetteNumber: source.officialGazetteNumber,
    jurisdiction: "XK",
    legalStatus: "requires_manual_legal_verification",
    isConsolidated: false,
    verifiedSource: true,
    verifiedAt: `${source.verifiedAt}T00:00:00.000Z`,
    applicability: source.applicability,
    applicabilityMode:
      source.applicabilityMode === "amendment"
        ? "amendment_scope"
        : "direct",
    ingestionStatus: "ingested"
  };
}

export function mapSeedChunk(chunk: LegalChunk): SeedChunk {
  const paragraphNumber =
    chunk.paragraphStart === null || chunk.paragraphEnd === null
      ? null
      : chunk.paragraphStart === chunk.paragraphEnd
        ? chunk.paragraphStart
        : `${chunk.paragraphStart}-${chunk.paragraphEnd}`;

  return {
    chunkIndex: chunk.chunkIndex,
    articleNumber: chunk.articleNumber,
    articleTitle: chunk.articleTitle,
    paragraphNumber,
    content: chunk.content,
    contentHash: chunk.contentSha256,
    tokenCount: null,
    metadata: {
      lawNumber: chunk.lawNumber,
      versionLabel: chunk.versionLabel,
      documentType: chunk.documentType,
      jurisdiction: chunk.jurisdiction,
      applicability: chunk.applicability,
      applicabilityMode: chunk.applicabilityMode,
      paragraphStart: chunk.paragraphStart,
      paragraphEnd: chunk.paragraphEnd,
      pageStart: chunk.pageStart,
      pageEnd: chunk.pageEnd,
      structuralContext: chunk.structuralContext,
      sourceSha256: chunk.sourceSha256,
      normalization: chunk.metadata.normalization,
      warnings: chunk.warnings,
      amendmentCandidates: chunk.metadata.amendmentCandidates
    }
  };
}

export function createSeedBatches(
  source: SeedSource,
  chunks: readonly SeedChunk[],
  batchLimit = LEGAL_SEED_BATCH_LIMIT
): SeedBatch[] {
  if (!Number.isInteger(batchLimit) || batchLimit < 1 || batchLimit > 200) {
    throw new Error("LEGAL_SEED_BATCH_LIMIT_INVALID");
  }

  return Array.from(
    { length: Math.ceil(chunks.length / batchLimit) },
    (_, batchIndex) => {
      const start = batchIndex * batchLimit;
      const rows = chunks.slice(start, start + batchLimit);
      const sourceName = source.lawNumber.replaceAll("/", "-");

      return {
        fileName: `chunks/${sourceName}-${String(batchIndex + 1).padStart(2, "0")}.sql`,
        lawNumber: source.lawNumber,
        versionLabel: source.versionLabel,
        language: "sq",
        rows,
        replacesExistingChunks: batchIndex === 0
      };
    }
  );
}

export function renderLegalSourcesSql(sources: readonly SeedSource[]): string {
  const values = sources
    .map(
      (source) => `  (${[
        sqlLiteral(source.title),
        sqlLiteral(source.lawNumber),
        sqlLiteral(source.officialUrl),
        sqlLiteral(source.officialDocumentUrl),
        sqlLiteral(source.publicationDate),
        sqlLiteral(source.versionLabel),
        sqlLiteral(source.retrievedAt),
        sqlLiteral(source.sha256),
        sqlLiteral(source.language),
        sqlLiteral(source.status),
        sqlLiteral(source.documentType),
        sqlLiteral(source.issuingInstitution),
        sqlLiteral(source.officialGazetteNumber),
        sqlLiteral(source.jurisdiction),
        sqlLiteral(source.legalStatus),
        source.isConsolidated ? "true" : "false",
        source.verifiedSource ? "true" : "false",
        sqlLiteral(source.verifiedAt),
        sqlTextArray(source.applicability),
        sqlLiteral(source.applicabilityMode),
        sqlLiteral(source.ingestionStatus)
      ].join(", ")})`
    )
    .join(",\n");

  return `-- Deterministic P0 legal-source seed. Run only after 00-preflight.sql succeeds.\nBEGIN;\n\nINSERT INTO public.legal_sources (\n  title, law_number, official_url, official_document_url, publication_date,\n  version_label, retrieved_at, sha256, language, status, document_type,\n  issuing_institution, official_gazette_number, jurisdiction, legal_status,\n  is_consolidated, verified_source, verified_at, applicability,\n  applicability_mode, ingestion_status\n)\nVALUES\n${values}\nON CONFLICT (law_number, version_label, language) DO UPDATE SET\n  title = excluded.title,\n  official_url = excluded.official_url,\n  official_document_url = excluded.official_document_url,\n  publication_date = excluded.publication_date,\n  retrieved_at = excluded.retrieved_at,\n  sha256 = excluded.sha256,\n  status = excluded.status,\n  document_type = excluded.document_type,\n  issuing_institution = excluded.issuing_institution,\n  official_gazette_number = excluded.official_gazette_number,\n  jurisdiction = excluded.jurisdiction,\n  legal_status = excluded.legal_status,\n  is_consolidated = excluded.is_consolidated,\n  verified_source = excluded.verified_source,\n  verified_at = excluded.verified_at,\n  applicability = excluded.applicability,\n  applicability_mode = excluded.applicability_mode,\n  ingestion_status = excluded.ingestion_status,\n  updated_at = now();\n\nCOMMIT;\n`;
}

export function renderChunkBatchSql(batch: SeedBatch): string {
  const sourcePredicate = `law_number = ${sqlLiteral(batch.lawNumber)}\n    and version_label = ${sqlLiteral(batch.versionLabel)}\n    and language = 'sq'`;
  const values = batch.rows
    .map(
      (row) => `  (${[
        String(row.chunkIndex),
        sqlLiteral(row.articleNumber),
        sqlNullable(row.articleTitle),
        sqlNullable(row.paragraphNumber),
        sqlLiteral(row.content),
        sqlLiteral(row.contentHash),
        "null::integer",
        `${sqlLiteral(JSON.stringify(row.metadata))}::jsonb`
      ].join(", ")})`
    )
    .join(",\n");
  const replacement = batch.replacesExistingChunks
    ? `-- The delete is deliberately scoped to this single P0 natural key.\nDELETE FROM public.legal_chunks\nWHERE legal_source_id IN (\n  SELECT id FROM public.legal_sources\n  WHERE ${sourcePredicate}\n);\n\n`
    : "";

  return `-- ${batch.lawNumber}: deterministic chunk batch; ${batch.rows.length} rows.\nBEGIN;\n\n-- A missing or duplicate source is visible before the write and must stop manual execution.\nSELECT id, law_number, version_label, language\nFROM public.legal_sources\nWHERE ${sourcePredicate};\n\n${replacement}INSERT INTO public.legal_chunks (\n  legal_source_id, chunk_index, article_number, article_title,\n  paragraph_number, point_label, content, content_hash, token_count, metadata\n)\nSELECT source.id, rows.chunk_index, rows.article_number, rows.article_title,\n  rows.paragraph_number, null, rows.content, rows.content_hash,\n  rows.token_count, rows.metadata\nFROM (VALUES\n${values}\n) AS rows (\n  chunk_index, article_number, article_title, paragraph_number, content,\n  content_hash, token_count, metadata\n)\nCROSS JOIN (\n  SELECT id FROM public.legal_sources\n  WHERE ${sourcePredicate}\n) AS source\nON CONFLICT (legal_source_id, chunk_index) DO UPDATE SET\n  article_number = excluded.article_number,\n  article_title = excluded.article_title,\n  paragraph_number = excluded.paragraph_number,\n  point_label = excluded.point_label,\n  content = excluded.content,\n  content_hash = excluded.content_hash,\n  token_count = excluded.token_count,\n  metadata = excluded.metadata;\n\nCOMMIT;\n`;
}

function renderPreflightSqlBase(): string {
  return `-- Read-only preflight for the P0 legal seed.\nSELECT table_schema, table_name\nFROM information_schema.tables\nWHERE table_schema = 'public'\n  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')\nORDER BY table_name;\n\nSELECT table_name, column_name, data_type, is_nullable\nFROM information_schema.columns\nWHERE table_schema = 'public'\n  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')\nORDER BY table_name, ordinal_position;\n\nSELECT count(*) AS current_legal_source_count FROM public.legal_sources;\n\nSELECT law_number, version_label, language, sha256\nFROM public.legal_sources\nWHERE (law_number, version_label, language) IN (\n  ('03/L-212', 'gazette-90-2010', 'sq'),\n  ('04/L-077', 'gazette-16-2012', 'sq'),\n  ('08/L-142', 'gazette-18-2024', 'sq')\n)\nORDER BY law_number;\n\nSELECT sha256, count(*) AS source_count\nFROM public.legal_sources\nGROUP BY sha256\nHAVING count(*) > 1;\n\nSELECT version_label, language, count(*) AS source_count\nFROM public.legal_sources\nGROUP BY version_label, language\nHAVING count(*) > 1;\n\nSELECT source.law_number, source.version_label, count(chunk.id) AS chunk_count\nFROM public.legal_sources AS source\nLEFT JOIN public.legal_chunks AS chunk ON chunk.legal_source_id = source.id\nWHERE (source.law_number, source.version_label, source.language) IN (\n  ('03/L-212', 'gazette-90-2010', 'sq'),\n  ('04/L-077', 'gazette-16-2012', 'sq'),\n  ('08/L-142', 'gazette-18-2024', 'sq')\n)\nGROUP BY source.id, source.law_number, source.version_label\nORDER BY source.law_number;\n\nSELECT grantee, table_name, privilege_type\nFROM information_schema.role_table_grants\nWHERE table_schema = 'public'\n  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')\n  AND grantee IN ('anon', 'authenticated', 'service_role')\nORDER BY grantee, table_name, privilege_type;\n\nSELECT EXISTS (\n  SELECT 1 FROM pg_extension WHERE extname = 'vector'\n) AS vector_extension_exists;\n`;
}

function renderPostflightSqlBase(expectedHashes: Readonly<Record<string, string>>): string {
  const hashValues = Object.entries(expectedHashes)
    .map(([law, hash]) => `  (${sqlLiteral(law)}, ${sqlLiteral(hash)})`)
    .join(",\n");

  return `-- Read-only postflight for the P0 legal seed.\nWITH expected(law_number, expected_chunks) AS (VALUES\n  ('03/L-212', 100), ('04/L-077', 1059), ('08/L-142', 7)\n), actual AS (\n  SELECT source.law_number, count(chunk.id)::integer AS actual_chunks\n  FROM public.legal_sources AS source\n  LEFT JOIN public.legal_chunks AS chunk ON chunk.legal_source_id = source.id\n  WHERE (source.law_number, source.version_label, source.language) IN (\n    ('03/L-212', 'gazette-90-2010', 'sq'),\n    ('04/L-077', 'gazette-16-2012', 'sq'),\n    ('08/L-142', 'gazette-18-2024', 'sq')\n  )\n  GROUP BY source.id, source.law_number\n)\nSELECT expected.law_number, expected.expected_chunks, actual.actual_chunks,\n  expected.expected_chunks = actual.actual_chunks AS count_matches\nFROM expected LEFT JOIN actual USING (law_number)\nORDER BY expected.law_number;\n\nSELECT count(*) AS p0_source_count\nFROM public.legal_sources\nWHERE (law_number, version_label, language) IN (\n  ('03/L-212', 'gazette-90-2010', 'sq'),\n  ('04/L-077', 'gazette-16-2012', 'sq'),\n  ('08/L-142', 'gazette-18-2024', 'sq')\n);\n\nWITH expected_hashes(law_number, expected_sha256) AS (VALUES\n${hashValues}\n)\nSELECT source.law_number, source.sha256, expected.expected_sha256,\n  source.sha256 = expected.expected_sha256 AS hash_matches,\n  source.applicability, source.applicability_mode, source.ingestion_status\nFROM public.legal_sources AS source\nJOIN expected_hashes AS expected USING (law_number)\nORDER BY source.law_number;\n\nSELECT source.law_number, min(chunk.chunk_index) AS minimum_index,\n  max(chunk.chunk_index) AS maximum_index, count(*) AS chunk_count,\n  count(DISTINCT chunk.chunk_index) AS unique_indexes,\n  count(DISTINCT chunk.content_hash) AS unique_hashes,\n  count(*) FILTER (WHERE btrim(chunk.content) = '') AS empty_chunks,\n  count(*) FILTER (WHERE chunk.token_count IS NOT NULL) AS populated_token_counts\nFROM public.legal_sources AS source\nJOIN public.legal_chunks AS chunk ON chunk.legal_source_id = source.id\nWHERE source.law_number IN ('03/L-212', '04/L-077', '08/L-142')\nGROUP BY source.id, source.law_number\nORDER BY source.law_number;\n\nSELECT count(*) AS p0_relation_count\nFROM public.legal_source_relations AS relation\nJOIN public.legal_sources AS base ON base.id = relation.base_source_id\nJOIN public.legal_sources AS related ON related.id = relation.related_source_id\nWHERE base.law_number IN ('03/L-212', '04/L-077', '08/L-142')\n   OR related.law_number IN ('03/L-212', '04/L-077', '08/L-142');\n\nSELECT grantee, table_name, privilege_type\nFROM information_schema.role_table_grants\nWHERE table_schema = 'public'\n  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')\n  AND grantee IN ('anon', 'authenticated', 'service_role')\nORDER BY grantee, table_name, privilege_type;\n\nSELECT table_name, column_name\nFROM information_schema.columns\nWHERE table_schema = 'public'\n  AND table_name IN ('legal_sources', 'legal_chunks', 'legal_source_relations')\n  AND column_name IN ('embedding', 'vector');\n`;
}

function renderRlsInspectionSql(): string {
  return `SELECT n.nspname AS table_schema, c.relname AS table_name,\n  c.relrowsecurity AS rls_enabled\nFROM pg_class AS c\nJOIN pg_namespace AS n ON n.oid = c.relnamespace\nWHERE n.nspname = 'public'\n  AND c.relname IN ('legal_sources', 'legal_chunks', 'legal_source_relations')\nORDER BY c.relname;\n`;
}

export function renderPreflightSql(): string {
  return `${renderPreflightSqlBase()}\n${renderRlsInspectionSql()}`;
}

export function renderPostflightSql(
  expectedHashes: Readonly<Record<string, string>>
): string {
  return `${renderPostflightSqlBase(expectedHashes)}\n${renderRlsInspectionSql()}`;
}
