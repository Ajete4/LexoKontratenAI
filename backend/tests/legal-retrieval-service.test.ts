import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import type { LegalEmbeddingAdapter } from "../src/legal/legal-embedding-adapter.js";
import {
  createLegalRetrievalService,
  type LegalRetrievalRpcClient
} from "../src/legal/legal-retrieval.service.js";

const queryId = "00000000-0000-4000-8000-000000000000";
const chunkIds = [
  "00000000-0000-4000-8000-000000000001",
  "00000000-0000-4000-8000-000000000002"
] as const;
const sourceId = "00000000-0000-4000-8000-000000000010";
const vector = () => Array.from({ length: 1_536 }, () => 0.25);

function row(overrides: Record<string, unknown> = {}) {
  return {
    chunk_id: chunkIds[0],
    legal_source_id: sourceId,
    law_number: "03/L-212",
    source_title: "Ligji i Punës",
    version_label: "gazette-90-2010",
    official_url: "https://example.test/act",
    official_document_url: "https://example.test/document",
    document_type: "law",
    applicability_mode: "direct",
    chunk_index: 1,
    article_number: "10",
    article_title: "Titulli",
    paragraph_number: "1",
    point_label: null,
    content: "Përmbajtje juridike e verifikuar.",
    content_hash: "a".repeat(64),
    similarity: 0.9,
    ...overrides
  };
}

function setup(data: unknown = [row()], rpcError: unknown = null) {
  const embedLegalChunks = vi.fn(async () => [
    { chunkId: queryId, embedding: vector() }
  ]);
  const rpc = vi.fn(async (_name: unknown, _parameters: unknown) => ({
    data,
    error: rpcError
  }));
  const service = createLegalRetrievalService({
    embeddingAdapter: { embedLegalChunks },
    rpcClient: { rpc } as LegalRetrievalRpcClient
  });
  return { service, embedLegalChunks, rpc };
}

const validInput = {
  query: "  Afati i njoftimit për ndërprerje?  ",
  contractType: "employment" as const,
  matchCount: 8,
  minSimilarity: 0.5
};

describe("legal retrieval service", () => {
  it("embeds one unchanged query and calls the RPC with exact parameters", async () => {
    const { service, embedLegalChunks, rpc } = setup();
    const result = await service.retrieve(validInput);

    expect(embedLegalChunks).toHaveBeenCalledTimes(1);
    expect(embedLegalChunks).toHaveBeenCalledWith({
      items: [{ chunkId: queryId, content: validInput.query }]
    });
    expect(rpc).toHaveBeenCalledTimes(1);
    expect(rpc).toHaveBeenCalledWith("match_legal_chunks", {
      p_query_embedding: expect.any(Array),
      p_contract_type: "employment",
      p_match_count: 8,
      p_min_similarity: 0.5
    });
    expect(
      (rpc.mock.calls[0]![1] as { p_query_embedding: number[] })
        .p_query_embedding
    ).toHaveLength(1_536);
    expect(result[0]).toMatchObject({
      chunkId: chunkIds[0],
      lawNumber: "03/L-212",
      similarity: 0.9
    });
    expect(JSON.stringify(result)).not.toMatch(
      /embedding|storagePath|storage_path|metadata|credential/iu
    );
  });

  it("applies only the approved defaults", async () => {
    const { service, rpc } = setup([]);
    await expect(
      service.retrieve({ query: "Pyetje", contractType: "service" })
    ).resolves.toEqual([]);
    expect(rpc).toHaveBeenCalledWith("match_legal_chunks", {
      p_query_embedding: expect.any(Array),
      p_contract_type: "service",
      p_match_count: 8,
      p_min_similarity: 0.5
    });
  });

  it.each([
    [{ ...validInput, query: "" }, "empty query"],
    [{ ...validInput, query: "   " }, "whitespace query"],
    [{ ...validInput, query: "a".repeat(2_001) }, "oversized query"],
    [{ ...validInput, contractType: "sale" }, "contract type"],
    [{ ...validInput, matchCount: 0 }, "low match count"],
    [{ ...validInput, matchCount: 21 }, "high match count"],
    [{ ...validInput, matchCount: 1.5 }, "decimal match count"],
    [{ ...validInput, minSimilarity: null }, "null similarity"],
    [{ ...validInput, minSimilarity: Number.NaN }, "NaN similarity"],
    [{ ...validInput, minSimilarity: Number.POSITIVE_INFINITY }, "infinite similarity"],
    [{ ...validInput, minSimilarity: -0.1 }, "low similarity"],
    [{ ...validInput, minSimilarity: 1.1 }, "high similarity"],
    [{ ...validInput, additional: true }, "additional field"]
  ])("rejects invalid input: %s", async (input, _label) => {
    const { service, embedLegalChunks, rpc } = setup();
    await expect(service.retrieve(input)).rejects.toMatchObject({
      code: "LEGAL_RETRIEVAL_INPUT_INVALID"
    });
    expect(embedLegalChunks).not.toHaveBeenCalled();
    expect(rpc).not.toHaveBeenCalled();
  });

  it.each([
    [[row({ chunk_id: "invalid" })], "UUID"],
    [[row(), row({ chunk_id: chunkIds[0], chunk_index: 2, similarity: 0.8 })], "duplicate"],
    [[row({ content: "   " })], "content"],
    [[row({ content_hash: "ABC" })], "hash"],
    [[row({ similarity: Number.NaN })], "similarity"],
    [[row({ similarity: 1.1 })], "similarity range"],
    [[row({ extra: true })], "additional field"],
    [[row({ law_number: "04/L-077" })], "contract scope"]
  ])("rejects invalid RPC output: %s", async (data) => {
    const { service } = setup(data);
    await expect(service.retrieve(validInput)).rejects.toMatchObject({
      code: "LEGAL_RETRIEVAL_OUTPUT_INVALID"
    });
  });

  it("rejects excessive and incorrectly ordered results", async () => {
    const excessive = Array.from({ length: 9 }, (_, index) =>
      row({
        chunk_id: `00000000-0000-4000-8000-${String(index + 1).padStart(12, "0")}`,
        chunk_index: index,
        similarity: 0.9 - index * 0.01
      })
    );
    await expect(setup(excessive).service.retrieve(validInput)).rejects.toMatchObject({
      code: "LEGAL_RETRIEVAL_OUTPUT_INVALID"
    });

    const wrongSimilarityOrder = [
      row({ similarity: 0.7 }),
      row({ chunk_id: chunkIds[1], chunk_index: 2, similarity: 0.8 })
    ];
    await expect(
      setup(wrongSimilarityOrder).service.retrieve(validInput)
    ).rejects.toMatchObject({ code: "LEGAL_RETRIEVAL_OUTPUT_INVALID" });

    const wrongTieOrder = [
      row({ chunk_index: 2 }),
      row({ chunk_id: chunkIds[1], chunk_index: 1 })
    ];
    await expect(setup(wrongTieOrder).service.retrieve(validInput)).rejects.toMatchObject({
      code: "LEGAL_RETRIEVAL_OUTPUT_INVALID"
    });
  });

  it("validates embedding output before RPC", async () => {
    const rpc = vi.fn();
    const service = createLegalRetrievalService({
      embeddingAdapter: {
        embedLegalChunks: vi.fn(async () => [
          { chunkId: queryId, embedding: [Number.NaN] }
        ])
      } as LegalEmbeddingAdapter,
      rpcClient: { rpc }
    });
    await expect(service.retrieve(validInput)).rejects.toMatchObject({
      code: "LEGAL_RETRIEVAL_OUTPUT_INVALID"
    });
    expect(rpc).not.toHaveBeenCalled();
  });

  it("preserves embedding errors and maps RPC failures safely without logging", async () => {
    const sensitive = "private-upstream-detail";
    const log = vi.spyOn(console, "log").mockImplementation(() => {});
    const errorLog = vi.spyOn(console, "error").mockImplementation(() => {});
    const { service } = setup(null, { message: sensitive });

    let thrown: unknown;
    try {
      await service.retrieve(validInput);
    } catch (error) {
      thrown = error;
    }
    expect(thrown).toMatchObject({ code: "LEGAL_RETRIEVAL_UNAVAILABLE" });
    expect(JSON.stringify(thrown)).not.toContain(sensitive);
    expect(log).not.toHaveBeenCalled();
    expect(errorLog).not.toHaveBeenCalled();
    log.mockRestore();
    errorLog.mockRestore();
  });

  it("has no import-time client creation or direct network call", async () => {
    const source = await readFile(
      resolve(process.cwd(), "src/legal/legal-retrieval.service.ts"),
      "utf8"
    );
    expect(source).not.toMatch(/\bfetch\s*\(|createOpenAIClient|supabaseAdmin|createClient/u);
    expect(source).not.toMatch(/console\.(?:log|error)/u);
    expect(source).not.toMatch(/from\s+["'](?:openai|@supabase\/supabase-js)["']/u);
  });
});
