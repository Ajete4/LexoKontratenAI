import { createHash } from "node:crypto";
import { readFile, readdir } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import {
  createSeedBatches,
  mapSeedChunk,
  mapSeedSource,
  renderChunkBatchSql,
  renderPostflightSql,
  renderPreflightSql,
  sqlLiteral
} from "../src/legal/legal-seed-builder.js";
import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";

type ChunkArtifact = {
  readonly chunks: readonly LegalChunk[];
};

type SeedManifest = {
  readonly sourceCount: number;
  readonly chunkCount: number;
  readonly sources: readonly {
    readonly lawNumber: string;
    readonly versionLabel: string;
    readonly sourceSha256: string;
    readonly chunkCount: number;
  }[];
  readonly batchFiles: readonly {
    readonly file: string;
    readonly lawNumber: string;
    readonly rows: number;
    readonly replacesExistingChunks: boolean;
    readonly sha256: string;
  }[];
  readonly sqlFiles: readonly {
    readonly file: string;
    readonly sha256: string;
  }[];
  readonly expectedPostflightCounts: {
    readonly sources: number;
    readonly chunks: number;
    readonly byLawNumber: Readonly<Record<string, number>>;
    readonly relations: number;
  };
};

const seedRoot = resolve(process.cwd(), "data/legal-sources/seed");

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(await readFile(resolve(process.cwd(), path), "utf8")) as T;
}

describe("P0 legal seed builder", () => {
  it("maps sources to schema-supported values and unique natural keys", () => {
    const sources = LEGAL_SOURCE_MANIFEST.map((manifestSource) => {
      const artifact = LEGAL_SOURCE_ARTIFACTS.find(
        (candidate) => candidate.lawNumber === manifestSource.lawNumber
      );
      expect(artifact).toBeDefined();
      return mapSeedSource(
        manifestSource,
        artifact?.sha256 ?? "",
        artifact?.retrievedAt ?? ""
      );
    });

    expect(sources.map((source) => source.documentType)).toEqual([
      "law",
      "law",
      "amendment"
    ]);
    expect(sources.map((source) => source.applicabilityMode)).toEqual([
      "direct",
      "direct",
      "amendment_scope"
    ]);
    expect(
      sources.every(
        (source) =>
          source.status === "verified" &&
          source.legalStatus === "requires_manual_legal_verification" &&
          source.ingestionStatus === "ingested" &&
          source.isConsolidated === false
      )
    ).toBe(true);
    expect(
      new Set(
        sources.map(
          (source) =>
            `${source.lawNumber}|${source.versionLabel}|${source.language}`
        )
      ).size
    ).toBe(3);
  });

  it("maps provenance into real columns and metadata without embeddings", async () => {
    const artifact = await readJson<ChunkArtifact>(
      "data/legal-sources/chunks/03-L-212/chunks.json"
    );
    const chunk = mapSeedChunk(artifact.chunks[1]!);

    expect(chunk.paragraphNumber).toBe("1-4");
    expect(chunk.tokenCount).toBeNull();
    expect(chunk.metadata).toMatchObject({
      lawNumber: "03/L-212",
      pageStart: 1,
      pageEnd: 1,
      paragraphStart: "1",
      paragraphEnd: "4"
    });
    expect(chunk.metadata).not.toHaveProperty("embedding");
    expect(JSON.stringify(chunk.metadata)).not.toMatch(/[A-Z]:\\|\/Users\//u);
  });

  it("creates bounded batches and source-scoped idempotent replacement", async () => {
    const artifact = await readJson<ChunkArtifact>(
      "data/legal-sources/chunks/04-L-077/chunks.json"
    );
    const source = mapSeedSource(
      LEGAL_SOURCE_MANIFEST[1],
      LEGAL_SOURCE_ARTIFACTS[1].sha256,
      LEGAL_SOURCE_ARTIFACTS[1].retrievedAt
    );
    const batches = createSeedBatches(source, artifact.chunks.map(mapSeedChunk));

    expect(batches.map((batch) => batch.rows.length)).toEqual([
      150, 150, 150, 150, 150, 150, 150, 9
    ]);
    expect(batches.filter((batch) => batch.replacesExistingChunks)).toHaveLength(1);

    const firstSql = renderChunkBatchSql(batches[0]!);
    const secondSql = renderChunkBatchSql(batches[1]!);
    expect(firstSql).toContain("DELETE FROM public.legal_chunks");
    expect(firstSql).toContain("law_number = '04/L-077'");
    expect(firstSql).toContain("version_label = 'gazette-16-2012'");
    expect(firstSql).not.toMatch(/\bTRUNCATE\b/iu);
    expect(secondSql).not.toContain("DELETE FROM public.legal_chunks");
    expect(firstSql).toContain("ON CONFLICT (legal_source_id, chunk_index)");
    expect(firstSql.match(/null::integer/gmu)).toHaveLength(150);
    expect(firstSql.match(/::jsonb/gmu)).toHaveLength(150);
    expect(firstSql).not.toMatch(
      /content_hash,\s*token_count,\s*metadata[\s\S]*?'[0-9a-f]{64}',\s*null,\s*'/u
    );
    expect(firstSql).toContain("BEGIN;");
    expect(firstSql.endsWith("COMMIT;\n")).toBe(true);
  });

  it("escapes apostrophes, preserves Unicode and reconstructs content", async () => {
    expect(sqlLiteral("Ligji për çështjen e palës 'A'")).toBe(
      "'Ligji për çështjen e palës ''A'''"
    );

    const artifact = await readJson<ChunkArtifact>(
      "data/legal-sources/chunks/03-L-212/chunks.json"
    );
    const chunk = mapSeedChunk(artifact.chunks[0]!);
    const source = mapSeedSource(
      LEGAL_SOURCE_MANIFEST[0],
      LEGAL_SOURCE_ARTIFACTS[0].sha256,
      LEGAL_SOURCE_ARTIFACTS[0].retrievedAt
    );
    const sql = renderChunkBatchSql(createSeedBatches(source, [chunk], 1)[0]!);

    expect(sql).toContain(sqlLiteral(chunk.content));
    expect(createHash("sha256").update(chunk.content).digest("hex")).toBe(
      chunk.contentHash
    );
    expect(sql).toContain("ë");
    expect(sql).not.toContain("�");
  });

  it("keeps preflight and postflight strictly read-only", () => {
    const preflight = renderPreflightSql();
    const postflight = renderPostflightSql({
      "03/L-212": "a".repeat(64),
      "04/L-077": "b".repeat(64),
      "08/L-142": "c".repeat(64)
    });
    const forbidden = /\b(?:insert|update|delete|upsert|alter|drop|create|truncate|grant|revoke)\b/iu;

    expect(preflight).not.toMatch(forbidden);
    expect(postflight).not.toMatch(forbidden);
    expect(preflight).toContain("pg_extension");
    expect(postflight).toContain("p0_relation_count");
    expect(postflight).toContain("populated_token_counts");
    expect(postflight).toContain("column_name IN ('embedding', 'vector')");
  });

  it("declares exactly 3 sources and 1,166 chunks with valid file hashes", async () => {
    const manifest = await readJson<SeedManifest>(
      "data/legal-sources/seed/seed-manifest.json"
    );

    expect(manifest.sourceCount).toBe(3);
    expect(manifest.chunkCount).toBe(1_166);
    expect(manifest.sources.map((source) => source.chunkCount)).toEqual([
      100, 1_059, 7
    ]);
    expect(manifest.batchFiles.reduce((sum, file) => sum + file.rows, 0)).toBe(
      1_166
    );
    expect(manifest.batchFiles.every((file) => file.rows <= 200)).toBe(true);
    expect(manifest.expectedPostflightCounts).toEqual({
      sources: 3,
      chunks: 1_166,
      byLawNumber: {
        "03/L-212": 100,
        "04/L-077": 1_059,
        "08/L-142": 7
      },
      relations: 0
    });

    for (const file of manifest.sqlFiles) {
      const content = await readFile(resolve(seedRoot, file.file), "utf8");
      expect(createHash("sha256").update(content).digest("hex")).toBe(file.sha256);
    }
  });

  it("serializes every approved content hash exactly once", async () => {
    const manifest = await readJson<SeedManifest>(
      "data/legal-sources/seed/seed-manifest.json"
    );
    const batchSql = (
      await Promise.all(
        manifest.batchFiles.map((batch) =>
          readFile(resolve(seedRoot, batch.file), "utf8")
        )
      )
    ).join("\n");
    let expectedChunks = 0;

    for (const source of manifest.sources) {
      const directory = source.lawNumber.replaceAll("/", "-");
      const artifact = await readJson<ChunkArtifact>(
        `data/legal-sources/chunks/${directory}/chunks.json`
      );
      expectedChunks += artifact.chunks.length;

      for (const chunk of artifact.chunks) {
        expect(batchSql.split(chunk.contentSha256)).toHaveLength(2);
      }
    }

    expect(expectedChunks).toBe(1_166);
  });

  it("isolates 08/L-142 and contains no relations, vectors or secrets", async () => {
    const files = await readdir(resolve(seedRoot, "chunks"));
    const allSql = (
      await Promise.all(
        ["00-preflight.sql", "01-legal-sources.sql", "90-postflight.sql"]
          .concat(files.map((file) => `chunks/${file}`))
          .map((file) => readFile(resolve(seedRoot, file), "utf8"))
      )
    ).join("\n");
    const amendmentSql = await readFile(
      resolve(seedRoot, "chunks", "08-L-142-01.sql"),
      "utf8"
    );

    expect(amendmentSql).toContain('"applicabilityMode":"amendment_scope"');
    expect(amendmentSql).toContain('"reviewStatus":"candidate_for_manual_review"');
    expect(allSql).not.toMatch(/INSERT\s+INTO\s+public\.legal_source_relations/iu);
    expect(allSql).not.toMatch(
      /\b(?:OPENAI_API_KEY|SUPABASE_(?:URL|ANON_KEY|SERVICE_ROLE_KEY))\s*=/u
    );
    expect(allSql).not.toMatch(/[A-Z]:\\|\/Users\//u);
  });
});
