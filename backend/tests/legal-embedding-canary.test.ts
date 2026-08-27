import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import type { LegalChunkRemoteMapping } from "../src/legal/legal-chunk-remote-mapping.js";
import type { LegalEmbeddingAdapter } from "../src/legal/legal-embedding-adapter.js";
import {
  renderCanaryPostflightSql,
  renderCanarySemanticSanitySql,
  selectLegalEmbeddingCanary
} from "../src/legal/legal-embedding-canary.js";
import { createLegalEmbeddingCanaryExecutor } from "../src/legal/legal-embedding-canary.service.js";

type EmploymentChunkArtifact = {
  readonly chunks: readonly LegalChunk[];
};

async function loadCanary() {
  const [mapping, artifact] = await Promise.all([
    readFile(
      resolve(
        process.cwd(),
        "data/legal-sources/embeddings/remote-chunk-mapping.json"
      ),
      "utf8"
    ).then((value) => JSON.parse(value) as LegalChunkRemoteMapping),
    readFile(
      resolve(
        process.cwd(),
        "data/legal-sources/chunks/03-L-212/chunks.json"
      ),
      "utf8"
    ).then((value) => JSON.parse(value) as EmploymentChunkArtifact)
  ]);

  return {
    canary: selectLegalEmbeddingCanary(mapping, artifact.chunks),
    chunks: artifact.chunks
  };
}

describe("legal embedding canary", () => {
  it("selects the smallest valid employment chunk deterministically", async () => {
    const { canary, chunks } = await loadCanary();
    const expected = [...chunks]
      .filter((chunk) => chunk.content.trim().length > 0)
      .sort(
        (left, right) =>
          left.content.length - right.content.length ||
          left.chunkIndex - right.chunkIndex
      )[0]!;

    expect(canary.plan).toMatchObject({
      lawNumber: "03/L-212",
      versionLabel: "gazette-90-2010",
      chunkIndex: expected.chunkIndex,
      contentHash: expected.contentSha256,
      characterCount: expected.content.length,
      model: "text-embedding-3-small",
      dimensions: 1_536,
      pipelineVersion: "legal-embedding-v1"
    });
    expect(canary.content).toBe(expected.content);
    expect(selectLegalEmbeddingCanary(
      (JSON.parse(
        await readFile(
          resolve(
            process.cwd(),
            "data/legal-sources/embeddings/remote-chunk-mapping.json"
          ),
          "utf8"
        )
      ) as LegalChunkRemoteMapping),
      chunks
    )).toEqual(canary);
  });

  it("keeps content and vectors out of the plan and generated read-only SQL", async () => {
    const { canary } = await loadCanary();
    const serializedPlan = JSON.stringify(canary.plan);
    const postflight = renderCanaryPostflightSql(canary.plan);
    const sanity = renderCanarySemanticSanitySql(canary.plan);

    expect(serializedPlan).not.toMatch(/"content"\s*:/u);
    expect(serializedPlan).not.toMatch(/"embedding"\s*:/u);
    expect(serializedPlan).not.toContain(canary.content);
    expect(postflight).toMatch(/^-- Read-only/u);
    expect(sanity).toMatch(/^-- Read-only/u);
    expect(`${postflight}\n${sanity}`).not.toMatch(
      /^\s*(?:insert|update|delete|upsert|alter|drop|create|truncate)\b/imu
    );
    expect(`${postflight}\n${sanity}`).not.toContain(canary.content);
    expect(sanity).not.toMatch(/select\s+[^;]*candidate\.content(?:\s|,)/isu);
  });

  it("makes exactly one adapter call and one conditional persistence call", async () => {
    const { canary } = await loadCanary();
    const embedding = Array.from({ length: 1_536 }, () => 0.25);
    const embedLegalChunks = vi.fn(async () => [
      { chunkId: canary.plan.chunkId, embedding }
    ]);
    const persist = vi.fn(async () => ({ updatedRows: 1 }));
    const execute = createLegalEmbeddingCanaryExecutor({
      adapter: { embedLegalChunks },
      persistence: { persist },
      now: () => new Date("2026-08-13T12:00:00.000Z")
    });

    await expect(execute(canary)).resolves.toMatchObject({ persistedRows: 1 });
    expect(embedLegalChunks).toHaveBeenCalledTimes(1);
    expect(embedLegalChunks).toHaveBeenCalledWith({
      items: [{ chunkId: canary.plan.chunkId, content: canary.content }]
    });
    expect(persist).toHaveBeenCalledTimes(1);
    expect(persist).toHaveBeenCalledWith({
      chunkId: canary.plan.chunkId,
      contentHash: canary.plan.contentHash,
      embedding,
      embeddingModel: "text-embedding-3-small",
      embeddedAt: "2026-08-13T12:00:00.000Z"
    });
    await expect(execute(canary)).rejects.toMatchObject({
      code: "LEGAL_EMBEDDING_CANARY_ALREADY_EXECUTED"
    });
    expect(embedLegalChunks).toHaveBeenCalledTimes(1);
  });

  it.each([
    { name: "wrong dimension", embedding: [0.1] },
    {
      name: "non-finite value",
      embedding: [...Array.from({ length: 1_535 }, () => 0.1), Number.NaN]
    },
    {
      name: "infinite value",
      embedding: [...Array.from({ length: 1_535 }, () => 0.1), Number.POSITIVE_INFINITY]
    }
  ])("rejects $name without persistence", async ({ embedding }) => {
    const { canary } = await loadCanary();
    const persist = vi.fn(async () => ({ updatedRows: 1 }));
    const adapter: LegalEmbeddingAdapter = {
      embedLegalChunks: vi.fn(async () => [
        { chunkId: canary.plan.chunkId, embedding }
      ])
    };
    const execute = createLegalEmbeddingCanaryExecutor({
      adapter,
      persistence: { persist }
    });

    await expect(execute(canary)).rejects.toMatchObject({
      code: "LEGAL_EMBEDDING_OUTPUT_INVALID"
    });
    expect(persist).not.toHaveBeenCalled();
  });

  it("rejects zero-row conditional persistence safely", async () => {
    const { canary } = await loadCanary();
    const execute = createLegalEmbeddingCanaryExecutor({
      adapter: {
        embedLegalChunks: vi.fn(async () => [
          {
            chunkId: canary.plan.chunkId,
            embedding: Array.from({ length: 1_536 }, () => 0.1)
          }
        ])
      },
      persistence: { persist: vi.fn(async () => ({ updatedRows: 0 })) }
    });

    await expect(execute(canary)).rejects.toMatchObject({
      code: "LEGAL_EMBEDDING_CANARY_PERSISTENCE_CONFLICT"
    });
  });

  it("hardens persistence by id, hash and three null embedding fields", async () => {
    const source = await readFile(
      resolve(process.cwd(), "src/legal/legal-embedding-canary.persistence.ts"),
      "utf8"
    );

    expect(source).toMatch(/\.eq\("id", input\.chunkId\)/u);
    expect(source).toMatch(/\.eq\("content_hash", input\.contentHash\)/u);
    expect(source).toMatch(/\.is\("embedding", null\)/u);
    expect(source).toMatch(/\.is\("embedding_model", null\)/u);
    expect(source).toMatch(/\.is\("embedded_at", null\)/u);
    expect(source).toMatch(/\.select\("id"\)/u);
    expect(source).not.toMatch(/\.insert\(|\.upsert\(|\.delete\(/u);
  });

  it("keeps dry-run isolated from network, logging and backfill loops", async () => {
    const [script, service, persistence] = await Promise.all(
      [
        "scripts/legal-embedding-canary.ts",
        "src/legal/legal-embedding-canary.service.ts",
        "src/legal/legal-embedding-canary.persistence.ts"
      ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
    );
    const combined = `${script}\n${service}\n${persistence}`;

    expect(combined).not.toMatch(/console\.|\bfetch\s*\(|\.rpc\s*\(/u);
    expect(script).not.toMatch(/for\s*\(|while\s*\(|Promise\.allSettled/u);
    expect(script).toContain('if (mode === "--execute")');
    expect(script).toMatch(/import\("\.\.\/src\/config\/supabase\.js"\)/u);
    expect(script).not.toMatch(/from\s+["']\.\.\/src\/config\/supabase/u);
    expect(combined).not.toMatch(/OPENAI_API_KEY\s*=|SUPABASE_SECRET_KEY\s*=/u);
  });
});
