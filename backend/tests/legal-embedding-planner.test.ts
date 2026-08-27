import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import { createLegalEmbeddingPlan } from "../src/legal/legal-embedding-planner.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly chunks: readonly LegalChunk[];
};

const definitions = [
  ["03/L-212", 100],
  ["04/L-077", 1_059],
  ["08/L-142", 7]
] as const;

async function loadSources() {
  return Promise.all(
    definitions.map(async ([lawNumber, expectedChunkCount]) => {
      const path = resolve(
        process.cwd(),
        "data/legal-sources/chunks",
        lawNumber.replaceAll("/", "-"),
        "chunks.json"
      );
      const artifact = JSON.parse(await readFile(path, "utf8")) as ChunkArtifact;
      return { lawNumber, expectedChunkCount, chunks: artifact.chunks };
    })
  );
}

describe("legal embedding dry-run planner", () => {
  it("creates the exact deterministic P0 plan", async () => {
    const plan = createLegalEmbeddingPlan(await loadSources());

    expect(plan).toMatchObject({
      model: "text-embedding-3-small",
      dimensions: 1_536,
      pipelineVersion: "legal-embedding-v1",
      totalChunks: 1_166,
      batchSize: 50,
      batchCount: 24,
      countsByLawNumber: {
        "03/L-212": 100,
        "04/L-077": 1_059,
        "08/L-142": 7
      }
    });
    expect(plan.batches.slice(0, -1).every((batch) => batch.itemCount === 50)).toBe(
      true
    );
    expect(plan.batches.at(-1)?.itemCount).toBe(16);
  });

  it("preserves manifest order, chunk indexes, hashes, characters and UTF-8 bytes", async () => {
    const sources = await loadSources();
    const plan = createLegalEmbeddingPlan(sources);
    const plannedItems = plan.batches.flatMap((batch) => batch.items);
    const originalChunks = sources.flatMap((source) => source.chunks);

    expect(plannedItems).toHaveLength(originalChunks.length);

    for (const [index, item] of plannedItems.entries()) {
      const chunk = originalChunks[index]!;
      expect(item).toEqual({
        lawNumber: chunk.lawNumber,
        chunkIndex: chunk.chunkIndex,
        contentHash: chunk.contentSha256,
        characterCount: chunk.content.length,
        utf8ByteCount: Buffer.byteLength(chunk.content, "utf8")
      });
      expect(createHash("sha256").update(chunk.content).digest("hex")).toBe(
        item.contentHash
      );
    }
  });

  it("is byte-for-byte deterministic and excludes content, vectors, IDs and timestamps", async () => {
    const sources = await loadSources();
    const first = `${JSON.stringify(createLegalEmbeddingPlan(sources), null, 2)}\n`;
    const second = `${JSON.stringify(createLegalEmbeddingPlan(sources), null, 2)}\n`;

    expect(second).toBe(first);
    expect(first).not.toMatch(/"content"\s*:/u);
    expect(first).not.toMatch(/"embedding"\s*:/u);
    expect(first).not.toMatch(/"(?:chunkId|uuid|createdAt|generatedAt|timestamp)"\s*:/u);
    expect(first).not.toMatch(/OPENAI_API_KEY|SUPABASE_|Bearer\s/u);
    expect(first).not.toMatch(/[A-Z]:\\|\/Users\//u);
  });

  it("rejects changed counts, order, index, content and hashes", async () => {
    const sources = await loadSources();
    const firstChunk = sources[0]!.chunks[0]!;

    expect(() => createLegalEmbeddingPlan(sources.slice(0, 2))).toThrow();
    expect(() =>
      createLegalEmbeddingPlan([sources[1]!, sources[0]!, sources[2]!])
    ).toThrow();
    expect(() =>
      createLegalEmbeddingPlan([
        { ...sources[0]!, chunks: sources[0]!.chunks.slice(1) },
        sources[1]!,
        sources[2]!
      ])
    ).toThrow();
    expect(() =>
      createLegalEmbeddingPlan([
        {
          ...sources[0]!,
          chunks: [
            { ...firstChunk, content: `${firstChunk.content} changed` },
            ...sources[0]!.chunks.slice(1)
          ]
        },
        sources[1]!,
        sources[2]!
      ])
    ).toThrow();
  });

  it("uses only local files and performs no OpenAI or Supabase calls", async () => {
    const source = await Promise.all(
      [
        "src/legal/legal-embedding-planner.ts",
        "scripts/plan-legal-embeddings.ts"
      ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
    );
    const combined = source.join("\n");

    expect(combined).not.toMatch(/\bfetch\s*\(/u);
    expect(combined).not.toMatch(/from\s+["'](?:openai|@supabase\/supabase-js)["']/u);
    expect(combined).not.toMatch(/\.embeddings\.create\s*\(/u);
    expect(combined).not.toMatch(/\.rpc\s*\(/u);
  });
});
