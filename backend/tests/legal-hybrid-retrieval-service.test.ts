import { describe, expect, it, vi } from "vitest";

import { legalHybridRetrievalRpcRowSchema } from "../src/legal/legal-hybrid-retrieval.schema.js";
import {
  createLegalHybridRetrievalService,
  type LegalHybridRetrievalRpcClient
} from "../src/legal/legal-hybrid-retrieval.service.js";
import type { LegalEmbeddingAdapter } from "../src/legal/legal-embedding-adapter.js";

const vector = Array.from({ length: 1_536 }, () => 0.1);

function rpcRow(overrides: Record<string, unknown> = {}) {
  return {
    chunk_id: "00000000-0000-4000-8000-000000000001",
    legal_source_id: "00000000-0000-4000-8000-000000000002",
    law_number: "04/L-077",
    source_title: "Ligji për Marrëdhëniet e Detyrimeve",
    version_label: "gazette-16-2012",
    official_url: "https://example.test/act",
    official_document_url: null,
    document_type: "law",
    applicability_mode: "direct",
    chunk_index: 100,
    article_number: "106",
    article_title: "Të drejtat në rast mospërmbushjeje",
    paragraph_number: null,
    point_label: null,
    content: "Përmbajtje juridike sintetike për test.",
    content_hash: "a".repeat(64),
    semantic_score: 0.7,
    lexical_score: 0.4,
    fused_score: 0.03,
    semantic_rank: 1,
    lexical_rank: 2,
    result_rank: 1,
    ...overrides
  };
}

function dependencies(rows: unknown[]) {
  const embedLegalChunks = vi.fn().mockResolvedValue([
    { chunkId: "00000000-0000-4000-8000-000000000000", embedding: vector }
  ]);
  const rpc = vi.fn().mockResolvedValue({ data: rows, error: null });
  return {
    embeddingAdapter: { embedLegalChunks } as LegalEmbeddingAdapter,
    rpcClient: { rpc } as LegalHybridRetrievalRpcClient,
    embedLegalChunks,
    rpc
  };
}

describe("hybrid retrieval output contract", () => {
  it("accepts point_label and all provenance text fields as nullable where allowed", () => {
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({
      article_number: null,
      article_title: null,
      paragraph_number: null,
      point_label: null
    })).success).toBe(true);
  });

  it("accepts a semantic-only result with lexical fields null", () => {
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({
      lexical_score: null,
      lexical_rank: null
    })).success).toBe(true);
  });

  it("accepts a lexical-only result with semantic fields null", () => {
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({
      semantic_score: null,
      semantic_rank: null
    })).success).toBe(true);
  });

  it.each([
    "chunk_id", "legal_source_id", "law_number", "source_title", "version_label",
    "official_url", "document_type", "applicability_mode", "chunk_index", "content",
    "content_hash", "fused_score", "result_rank"
  ])("rejects null for required field %s", (field) => {
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({ [field]: null })).success).toBe(false);
  });

  it("accepts official_document_url as null according to legal_sources", () => {
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({
      official_document_url: null
    })).success).toBe(true);
  });

  it("rejects additional fields, wrong types and incoherent nullable ranks", () => {
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({ extra: true })).success).toBe(false);
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({ lexical_score: "0.4" })).success).toBe(false);
    expect(legalHybridRetrievalRpcRowSchema.safeParse(rpcRow({ lexical_score: null, lexical_rank: 1 })).success).toBe(false);
  });
});

describe("hybrid retrieval service", () => {
  it("can reuse one validated in-memory embedding across multiple read-only RPC calls", async () => {
    const deps = dependencies([]);
    const service = createLegalHybridRetrievalService(deps);
    const embedding = await service.embedQuery("query");
    await service.retrieveWithEmbedding({ query: "query", contractType: "service" }, embedding);
    await service.retrieveWithEmbedding({
      query: "query",
      contractType: "service",
      candidateCount: 75,
      rrfK: 20
    }, embedding);

    expect(deps.embedLegalChunks).toHaveBeenCalledTimes(1);
    expect(deps.rpc).toHaveBeenCalledTimes(2);
  });

  it("maps nullable fields and sends query only as the RPC parameter and embedding input", async () => {
    const deps = dependencies([rpcRow({ lexical_score: null, lexical_rank: null })]);
    const service = createLegalHybridRetrievalService(deps);
    const result = await service.retrieve({
      query: "mospërmbushja e detyrimit",
      contractType: "service",
      matchCount: 8,
      candidateCount: 50,
      minSemanticSimilarity: 0.45,
      rrfK: 60
    });

    expect(result[0]).toMatchObject({
      pointLabel: null,
      lexicalScore: null,
      lexicalRank: null
    });
    expect(deps.rpc).toHaveBeenCalledWith("match_legal_chunks_hybrid", {
      p_query_embedding: vector,
      p_query_text: "mospërmbushja e detyrimit",
      p_contract_type: "service",
      p_match_count: 8,
      p_candidate_count: 50,
      p_min_semantic_similarity: 0.45,
      p_rrf_k: 60
    });
  });

  it.each([
    [rpcRow({ law_number: "03/L-212" }), "out-of-scope law"],
    [[rpcRow(), rpcRow()], "duplicate chunk"],
    [rpcRow({ result_rank: 2 }), "non-contiguous rank"],
    [rpcRow({ semantic_score: Number.NaN }), "non-finite score"]
  ])("rejects invalid output: %s", async (value, _label) => {
    const rows = Array.isArray(value) ? value : [value];
    const service = createLegalHybridRetrievalService(dependencies(rows));
    await expect(service.retrieve({
      query: "query",
      contractType: "service"
    })).rejects.toMatchObject({ code: "LEGAL_HYBRID_RETRIEVAL_OUTPUT_INVALID" });
  });

  it("rejects blank and oversized queries before embedding or RPC", async () => {
    for (const query of [" ", "x".repeat(2_001)]) {
      const deps = dependencies([]);
      const service = createLegalHybridRetrievalService(deps);
      await expect(service.retrieve({ query, contractType: "service" })).rejects.toMatchObject({
        code: "LEGAL_HYBRID_RETRIEVAL_INPUT_INVALID"
      });
      expect(deps.embedLegalChunks).not.toHaveBeenCalled();
      expect(deps.rpc).not.toHaveBeenCalled();
    }
  });
});
