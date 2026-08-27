import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";
import type { SupabaseClient } from "@supabase/supabase-js";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import type { LegalChunkRemoteMapping } from "../src/legal/legal-chunk-remote-mapping.js";
import type { LegalEmbeddingCanaryPlan } from "../src/legal/legal-embedding-canary.js";
import {
  createLegalEmbeddingBackfill,
  type LegalEmbeddingBackfill
} from "../src/legal/legal-embedding-backfill.js";
import { createLegalEmbeddingBackfillExecutor } from "../src/legal/legal-embedding-backfill.service.js";
import {
  createLegalEmbeddingBackfillStateReader,
  type LegalEmbeddingRemoteState
} from "../src/legal/legal-embedding-backfill.state.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly chunks: readonly LegalChunk[];
};

async function loadBackfill(): Promise<LegalEmbeddingBackfill> {
  const names = ["03-L-212", "04-L-077", "08-L-142"] as const;
  const [mapping, canary, ...artifacts] = await Promise.all([
    readFile(
      resolve(process.cwd(), "data/legal-sources/embeddings/remote-chunk-mapping.json"),
      "utf8"
    ).then((value) => JSON.parse(value) as LegalChunkRemoteMapping),
    readFile(
      resolve(process.cwd(), "data/legal-sources/embeddings/canary-plan.json"),
      "utf8"
    ).then((value) => JSON.parse(value) as LegalEmbeddingCanaryPlan),
    ...names.map((name) =>
      readFile(
        resolve(process.cwd(), `data/legal-sources/chunks/${name}/chunks.json`),
        "utf8"
      ).then((value) => JSON.parse(value) as ChunkArtifact)
    )
  ]);

  return createLegalEmbeddingBackfill({
    mapping,
    canary,
    sources: (artifacts as ChunkArtifact[]).map((artifact) => ({
      lawNumber: artifact.lawNumber,
      chunks: artifact.chunks
    }))
  });
}

function statesFor(
  backfill: LegalEmbeddingBackfill,
  completedIds: ReadonlySet<string> = new Set([backfill.canaryChunkId])
): LegalEmbeddingRemoteState[] {
  return backfill.allItems.map((item) => ({
    chunkId: item.chunkId,
    contentHash: item.contentHash,
    status: completedIds.has(item.chunkId) ? "complete" : "empty"
  }));
}

describe("legal embedding backfill", () => {
  it("creates the deterministic 1,165-item plan and excludes the canary", async () => {
    const first = await loadBackfill();
    const second = await loadBackfill();

    expect(first.plan).toMatchObject({
      totalChunks: 1_166,
      existingCanaryChunks: 1,
      candidateChunks: 1_165,
      batchSize: 50,
      batchCount: 24,
      countsByLawNumber: {
        "03/L-212": 99,
        "04/L-077": 1_059,
        "08/L-142": 7
      }
    });
    expect(first.candidateBatches.slice(0, -1).every((batch) => batch.length === 50)).toBe(true);
    expect(first.candidateBatches.at(-1)).toHaveLength(15);
    expect(first.candidateBatches.flat()).toHaveLength(1_165);
    expect(first.candidateBatches.flat().some((item) => item.chunkId === first.canaryChunkId)).toBe(false);
    expect(JSON.stringify(second.plan)).toBe(JSON.stringify(first.plan));
    expect(JSON.stringify(first.plan)).not.toMatch(
      /"(?:chunkId|legalSourceId|content|embedding)"\s*:/iu
    );
  });

  it("uses at most one request per batch and persists each candidate once", async () => {
    const backfill = await loadBackfill();
    const embedding = Array.from({ length: 1_536 }, () => 0.1);
    const embedLegalChunks = vi.fn(async (input: unknown) => {
      const items = (input as { items: { chunkId: string }[] }).items;
      return items.map((item) => ({ chunkId: item.chunkId, embedding }));
    });
    const persist = vi.fn(async () => ({ updatedRows: 1 }));
    const write = vi.fn(async (_checkpoint: unknown) => undefined);
    const execute = createLegalEmbeddingBackfillExecutor({
      adapter: { embedLegalChunks },
      stateReader: { load: vi.fn(async () => statesFor(backfill)) },
      persistence: { persist },
      checkpointWriter: { write },
      now: () => new Date("2026-08-13T12:00:00.000Z")
    });

    await execute(backfill);

    expect(embedLegalChunks).toHaveBeenCalledTimes(24);
    expect(
      embedLegalChunks.mock.calls.every(
        ([input]) => (input as { items: unknown[] }).items.length <= 50
      )
    ).toBe(true);
    expect(persist).toHaveBeenCalledTimes(1_165);
    expect(write).toHaveBeenCalledTimes(24);
    expect(write.mock.calls.at(-1)?.[0]).toMatchObject({
      completedCandidates: 1_165,
      skippedExisting: 0,
      lastCompletedBatch: 24
    });
  });

  it("is resumable and makes no request for already completed batches", async () => {
    const backfill = await loadBackfill();
    const allCompleted = new Set(backfill.allItems.map((item) => item.chunkId));
    const embedLegalChunks = vi.fn();
    const persist = vi.fn();
    const write = vi.fn(async (_checkpoint: unknown) => undefined);
    const execute = createLegalEmbeddingBackfillExecutor({
      adapter: { embedLegalChunks },
      stateReader: {
        load: vi.fn(async () => statesFor(backfill, allCompleted))
      },
      persistence: { persist },
      checkpointWriter: { write }
    });

    await execute(backfill);

    expect(embedLegalChunks).not.toHaveBeenCalled();
    expect(persist).not.toHaveBeenCalled();
    expect(write.mock.calls.at(-1)?.[0]).toMatchObject({
      completedCandidates: 0,
      skippedExisting: 1_165,
      lastCompletedBatch: 24
    });
  });

  it("stops before AI when remote state is missing or has a hash mismatch", async () => {
    const backfill = await loadBackfill();
    const validStates = statesFor(backfill);

    for (const invalidStates of [
      validStates.slice(1),
      validStates.map((state, index) =>
        index === 0 ? { ...state, contentHash: "0".repeat(64) } : state
      )
    ]) {
      const embedLegalChunks = vi.fn();
      const execute = createLegalEmbeddingBackfillExecutor({
        adapter: { embedLegalChunks },
        stateReader: { load: vi.fn(async () => invalidStates) },
        persistence: { persist: vi.fn() },
        checkpointWriter: { write: vi.fn() }
      });

      await expect(execute(backfill)).rejects.toMatchObject({
        code: "LEGAL_EMBEDDING_BACKFILL_REMOTE_STATE_INVALID"
      });
      expect(embedLegalChunks).not.toHaveBeenCalled();
    }
  });

  it("stops immediately on state, output or persistence errors", async () => {
    const backfill = await loadBackfill();
    const embedding = Array.from({ length: 1_536 }, () => 0.1);

    const stateFailureAdapter = { embedLegalChunks: vi.fn() };
    await expect(
      createLegalEmbeddingBackfillExecutor({
        adapter: stateFailureAdapter,
        stateReader: {
          load: vi.fn(async () => {
            throw new Error("PARTIAL_METADATA");
          })
        },
        persistence: { persist: vi.fn() },
        checkpointWriter: { write: vi.fn() }
      })(backfill)
    ).rejects.toThrow("PARTIAL_METADATA");
    expect(stateFailureAdapter.embedLegalChunks).not.toHaveBeenCalled();

    const invalidOutputAdapter = {
      embedLegalChunks: vi.fn(async () => [
        { chunkId: backfill.candidateBatches[0]![0]!.chunkId, embedding: [Number.NaN] }
      ])
    };
    await expect(
      createLegalEmbeddingBackfillExecutor({
        adapter: invalidOutputAdapter,
        stateReader: { load: vi.fn(async () => statesFor(backfill)) },
        persistence: { persist: vi.fn() },
        checkpointWriter: { write: vi.fn() }
      })(backfill)
    ).rejects.toMatchObject({ code: "LEGAL_EMBEDDING_OUTPUT_INVALID" });
    expect(invalidOutputAdapter.embedLegalChunks).toHaveBeenCalledTimes(1);

    for (const updatedRows of [0, 2]) {
      const adapter = {
        embedLegalChunks: vi.fn(async (input: unknown) =>
          (input as { items: { chunkId: string }[] }).items.map((item) => ({
            chunkId: item.chunkId,
            embedding
          }))
        )
      };
      const execute = createLegalEmbeddingBackfillExecutor({
        adapter,
        stateReader: { load: vi.fn(async () => statesFor(backfill)) },
        persistence: { persist: vi.fn(async () => ({ updatedRows })) },
        checkpointWriter: { write: vi.fn() }
      });
      await expect(execute(backfill)).rejects.toMatchObject({
        code: "LEGAL_EMBEDDING_BACKFILL_PERSISTENCE_CONFLICT"
      });
      expect(adapter.embedLegalChunks).toHaveBeenCalledTimes(1);
    }
  });

  it("rejects partial remote metadata without selecting vectors", async () => {
    const backfill = await loadBackfill();
    const item = backfill.allItems[0]!;
    const selectedColumns: string[] = [];
    const client = {
      from: vi.fn(() => ({
        select: (columns: string) => {
          selectedColumns.push(columns);
          return {
            in: () => ({
              is: async () => ({
                data: [
                  {
                    id: item.chunkId,
                    content_hash: item.contentHash,
                    embedding_model: "text-embedding-3-small",
                    embedded_at: null
                  }
                ],
                error: null
              }),
              not: async () => ({ data: [], error: null })
            })
          };
        }
      }))
    } as unknown as SupabaseClient;

    await expect(
      createLegalEmbeddingBackfillStateReader(client).load([item])
    ).rejects.toMatchObject({
      code: "LEGAL_EMBEDDING_BACKFILL_PARTIAL_METADATA"
    });
    expect(selectedColumns).toEqual([
      "id,content_hash,embedding_model,embedded_at",
      "id,content_hash,embedding_model,embedded_at"
    ]);
  });

  it("retries a transient preflight query twice at most", async () => {
    const backfill = await loadBackfill();
    const item = backfill.allItems[0]!;
    let terminalCalls = 0;
    const client = {
      from: vi.fn(() => ({
        select: () => ({
          in: () => ({
            is: async () => {
              terminalCalls += 1;
              return terminalCalls <= 2
                ? { data: null, error: { safe: true } }
                : {
                    data: [
                      {
                        id: item.chunkId,
                        content_hash: item.contentHash,
                        embedding_model: null,
                        embedded_at: null
                      }
                    ],
                    error: null
                  };
            },
            not: async () => {
              terminalCalls += 1;
              return terminalCalls <= 2
                ? { data: null, error: { safe: true } }
                : { data: [], error: null };
            }
          })
        })
      }))
    } as unknown as SupabaseClient;
    const sleep = vi.fn(async (_milliseconds: number) => undefined);

    await expect(
      createLegalEmbeddingBackfillStateReader(client, { sleep }).load([item])
    ).resolves.toEqual([
      {
        chunkId: item.chunkId,
        contentHash: item.contentHash,
        status: "empty"
      }
    ]);
    expect(terminalCalls).toBe(4);
    expect(sleep).toHaveBeenCalledTimes(1);
    expect(sleep).toHaveBeenCalledWith(150);
  });

  it("stops safely after preflight retries are exhausted and never calls AI", async () => {
    const backfill = await loadBackfill();
    const client = {
      from: vi.fn(() => ({
        select: () => ({
          in: () => ({
            is: async () => ({ data: null, error: { private: "hidden" } }),
            not: async () => ({ data: null, error: { private: "hidden" } })
          })
        })
      }))
    } as unknown as SupabaseClient;
    const sleep = vi.fn(async (_milliseconds: number) => undefined);
    const stateReader = createLegalEmbeddingBackfillStateReader(client, {
      sleep
    });
    const embedLegalChunks = vi.fn();
    const execute = createLegalEmbeddingBackfillExecutor({
      adapter: { embedLegalChunks },
      stateReader,
      persistence: { persist: vi.fn() },
      checkpointWriter: { write: vi.fn() }
    });

    await expect(execute(backfill)).rejects.toMatchObject({
      code: "LEGAL_EMBEDDING_BACKFILL_STATE_UNAVAILABLE",
      message: "Legal embedding state could not be verified."
    });
    expect(client.from).toHaveBeenCalledTimes(6);
    expect(sleep.mock.calls.map(([milliseconds]) => milliseconds)).toEqual([
      150,
      300
    ]);
    expect(embedLegalChunks).not.toHaveBeenCalled();
  });

  it("keeps dry-run free of remote clients, sensitive logs and auto-start", async () => {
    const [script, service, state, persistence] = await Promise.all(
      [
        "scripts/legal-embedding-backfill.ts",
        "src/legal/legal-embedding-backfill.service.ts",
        "src/legal/legal-embedding-backfill.state.ts",
        "src/legal/legal-embedding-canary.persistence.ts"
      ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
    );
    const combined = `${script}\n${service}\n${state}\n${persistence}`;

    expect(combined).not.toMatch(/console\.|localStorage|sessionStorage/u);
    expect(script).toContain('if (mode === "--execute")');
    expect(script).not.toMatch(/from\s+["']\.\.\/src\/config\/supabase/u);
    expect(script).toMatch(/import\("\.\.\/src\/config\/supabase\.js"\)/u);
    expect(combined).not.toMatch(/OPENAI_API_KEY\s*=|SUPABASE_SECRET_KEY\s*=/u);
    expect(persistence).toMatch(/\.eq\("id", input\.chunkId\)/u);
    expect(persistence).toMatch(/\.eq\("content_hash", input\.contentHash\)/u);
    expect(persistence).toMatch(/\.is\("embedding", null\)/u);
  });
});
