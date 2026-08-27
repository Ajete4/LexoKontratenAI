import { createHash, randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import {
  createSeedBatches,
  mapSeedChunk,
  mapSeedSource,
  renderChunkBatchSql,
  renderLegalSourcesSql,
  renderPostflightSql,
  renderPreflightSql,
  sha256,
  type SeedSource
} from "../src/legal/legal-seed-builder.js";
import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly sourceSha256: string;
  readonly chunks: readonly LegalChunk[];
};

type ReviewSummary = {
  readonly sources: readonly {
    readonly lawNumber: string;
    readonly chunkCount: number;
    readonly blockingIssueCount: number;
    readonly outcome:
      | "approved_for_seed"
      | "approved_for_seed_with_warnings"
      | "blocked";
  }[];
  readonly blockedSourceCount: number;
  readonly seedPreparationDecision: "eligible_after_explicit_approval" | "blocked";
};

type ReviewReport = {
  readonly warnings: readonly string[];
  readonly blockingIssues: readonly string[];
  readonly outcome:
    | "approved_for_seed"
    | "approved_for_seed_with_warnings"
    | "blocked";
};

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const seedDirectory = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "seed"
);
const migrationPath = resolve(
  backendDirectory,
  "supabase",
  "migrations",
  "0004_legal_corpus_foundation.sql"
);

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(await readFile(path, "utf8")) as T;
}

async function writeAtomically(targetPath: string, content: string): Promise<void> {
  await mkdir(dirname(targetPath), { recursive: true });
  const temporaryPath = `${targetPath}.tmp-${randomUUID()}`;

  try {
    await writeFile(temporaryPath, content, { encoding: "utf8", flag: "wx" });
    await rename(temporaryPath, targetPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

function assertMigrationSchema(migration: string): void {
  const requiredSchema = [
    "create table public.legal_chunks",
    "create table public.legal_source_relations",
    "unique (legal_source_id, chunk_index)",
    "check (jsonb_typeof(metadata) = 'object')",
    "document_type in ('unclassified', 'law', 'amendment')",
    "applicability_mode in (",
    "'amendment_scope'"
  ];

  if (requiredSchema.some((fragment) => !migration.includes(fragment))) {
    throw new Error("LEGAL_SEED_SCHEMA_MISMATCH");
  }

  if (/\bvector\s*\(|\bembedding\b/iu.test(migration)) {
    throw new Error("LEGAL_SEED_VECTOR_SCHEMA_NOT_ALLOWED");
  }
}

function assertChunks(
  artifact: ChunkArtifact,
  expectedSourceHash: string,
  expectedCount: number
): void {
  const indexes = artifact.chunks.map((chunk) => chunk.chunkIndex);
  const contentHashes = artifact.chunks.map((chunk) => chunk.contentSha256);

  if (
    artifact.chunks.length !== expectedCount ||
    artifact.sourceSha256 !== expectedSourceHash ||
    indexes.some((index, position) => index !== position) ||
    new Set(contentHashes).size !== contentHashes.length ||
    artifact.chunks.some(
      (chunk) =>
        chunk.content.trim().length === 0 ||
        chunk.sourceSha256 !== expectedSourceHash ||
        sha256(chunk.content) !== chunk.contentSha256 ||
        chunk.lawNumber !== artifact.lawNumber ||
        chunk.versionLabel !== artifact.versionLabel ||
        chunk.language !== "sq" ||
        chunk.pageStart < 1 ||
        chunk.pageEnd < chunk.pageStart
    )
  ) {
    throw new Error("LEGAL_SEED_CHUNK_GATE_FAILED");
  }
}

const migration = await readFile(migrationPath, "utf8");
assertMigrationSchema(migration);

const reviewSummary = await readJson<ReviewSummary>(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "chunk-review",
    "review-summary.json"
  )
);

if (
  reviewSummary.seedPreparationDecision !== "eligible_after_explicit_approval" ||
  reviewSummary.blockedSourceCount !== 0 ||
  reviewSummary.sources.some(
    (source) => source.outcome === "blocked" || source.blockingIssueCount > 0
  ) ||
  reviewSummary.sources.reduce((sum, source) => sum + source.chunkCount, 0) !==
    1_166
) {
  throw new Error("LEGAL_SEED_REVIEW_GATE_FAILED");
}

const sources: SeedSource[] = [];
const allBatches = [];
const warnings: Record<string, readonly string[]> = {};
const naturalKeys = new Set<string>();

for (const manifestSource of LEGAL_SOURCE_MANIFEST) {
  const artifact = LEGAL_SOURCE_ARTIFACTS.find(
    (candidate) => candidate.lawNumber === manifestSource.lawNumber
  );
  const reviewSource = reviewSummary.sources.find(
    (candidate) => candidate.lawNumber === manifestSource.lawNumber
  );

  if (artifact === undefined || reviewSource === undefined) {
    throw new Error("LEGAL_SEED_SOURCE_INPUT_MISSING");
  }

  const rawBytes = await readFile(resolve(backendDirectory, artifact.localRelativePath));

  if (createHash("sha256").update(rawBytes).digest("hex") !== artifact.sha256) {
    throw new Error("LEGAL_SEED_SOURCE_HASH_MISMATCH");
  }

  const directoryName = manifestSource.lawNumber.replaceAll("/", "-");
  const chunkArtifact = await readJson<ChunkArtifact>(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "chunks",
      directoryName,
      "chunks.json"
    )
  );
  const reviewReport = await readJson<ReviewReport>(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "chunk-review",
      directoryName,
      "review-report.json"
    )
  );

  if (
    reviewReport.outcome === "blocked" ||
    reviewReport.blockingIssues.length > 0 ||
    manifestSource.versionLabel === null ||
    chunkArtifact.versionLabel !== manifestSource.versionLabel
  ) {
    throw new Error("LEGAL_SEED_SOURCE_REVIEW_FAILED");
  }

  assertChunks(chunkArtifact, artifact.sha256, reviewSource.chunkCount);
  const source = mapSeedSource(
    manifestSource,
    artifact.sha256,
    artifact.retrievedAt
  );
  const naturalKey = `${source.lawNumber}\u0000${source.versionLabel}\u0000${source.language}`;

  if (naturalKeys.has(naturalKey)) {
    throw new Error("LEGAL_SEED_DUPLICATE_SOURCE_KEY");
  }

  naturalKeys.add(naturalKey);
  sources.push(source);
  warnings[source.lawNumber] = reviewReport.warnings;
  allBatches.push(
    ...createSeedBatches(source, chunkArtifact.chunks.map(mapSeedChunk))
  );
}

const sqlFiles = new Map<string, string>();
const sourceHashes = Object.fromEntries(
  sources.map((source) => [source.lawNumber, source.sha256])
);

sqlFiles.set("00-preflight.sql", renderPreflightSql());
sqlFiles.set("01-legal-sources.sql", renderLegalSourcesSql(sources));

for (const batch of allBatches) {
  sqlFiles.set(batch.fileName, renderChunkBatchSql(batch));
}

sqlFiles.set("90-postflight.sql", renderPostflightSql(sourceHashes));

for (const [relativePath, content] of sqlFiles) {
  await writeAtomically(resolve(seedDirectory, relativePath), content);
}

const manifest = {
  sourceCount: sources.length,
  chunkCount: allBatches.reduce((sum, batch) => sum + batch.rows.length, 0),
  sources: sources.map((source) => ({
    lawNumber: source.lawNumber,
    versionLabel: source.versionLabel,
    language: source.language,
    sourceSha256: source.sha256,
    chunkCount: allBatches
      .filter((batch) => batch.lawNumber === source.lawNumber)
      .reduce((sum, batch) => sum + batch.rows.length, 0),
    warnings: warnings[source.lawNumber]
  })),
  batchFiles: allBatches.map((batch) => ({
    file: batch.fileName,
    lawNumber: batch.lawNumber,
    rows: batch.rows.length,
    replacesExistingChunks: batch.replacesExistingChunks,
    sha256: sha256(sqlFiles.get(batch.fileName) ?? "")
  })),
  sqlFiles: [...sqlFiles].map(([file, content]) => ({
    file,
    sha256: sha256(content)
  })),
  expectedPostflightCounts: {
    sources: 3,
    chunks: 1_166,
    byLawNumber: {
      "03/L-212": 100,
      "04/L-077": 1_059,
      "08/L-142": 7
    },
    relations: 0
  },
  seedExecutionDecision: "requires_explicit_G1E_3B_approval"
};

if (manifest.sourceCount !== 3 || manifest.chunkCount !== 1_166) {
  throw new Error("LEGAL_SEED_OUTPUT_COUNT_MISMATCH");
}

await writeAtomically(
  resolve(seedDirectory, "seed-manifest.json"),
  `${JSON.stringify(manifest, null, 2)}\n`
);
