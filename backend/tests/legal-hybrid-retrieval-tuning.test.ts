import { createHash } from "node:crypto";
import { mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import type { createLegalHybridRetrievalService } from "../src/legal/legal-hybrid-retrieval.service.js";
import { runLegalHybridRetrievalTuning } from "../src/legal/legal-hybrid-retrieval-tuning.js";
import { createHybridTuningCheckpointStore } from "../src/legal/legal-hybrid-tuning-checkpoint.js";
import {
  createLegalHybridTuningPlan,
  HYBRID_TUNING_RPC_CONFIGURATIONS,
  HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE
} from "../src/legal/legal-hybrid-tuning-config.js";
import {
  calculateControlledTermOverlap,
  rerankLegalHybridTuningResults
} from "../src/legal/legal-hybrid-tuning-reranker.js";
import type { CalibrationGoldSet } from "../src/legal/legal-retrieval-calibration.js";

async function goldSet() {
  return JSON.parse(
    await readFile(resolve(process.cwd(), "data/legal-sources/retrieval/gold-set-v1.json"), "utf8")
  ) as CalibrationGoldSet;
}

describe("controlled legal hybrid tuning", () => {
  it("creates a deterministic bounded plan without migration 0008", async () => {
    const plan = createLegalHybridTuningPlan();
    const artifact = await readFile(
      resolve(process.cwd(), "data/legal-sources/retrieval/hybrid-tuning-plan.json")
    );

    expect(plan.strategyRouting).toEqual({ employment: "A", service: "B", lease: "A" });
    expect(plan.rpcConfigurations).toHaveLength(6);
    expect(plan.evaluatedConfigurations).toBe(12);
    expect(plan.remoteRuns).toBe(54);
    expect(plan.requestBudget).toEqual({
      openAiEmbeddingRequests: 9,
      readOnlyHybridRpcCalls: 54,
      databaseWrites: 0
    });
    expect(plan.uniqueQueries).toBe(9);
    expect(plan.requiresMigration0008).toBe(false);
    expect(createHash("sha256").update(artifact).digest("hex")).toHaveLength(64);
  });

  it("reranks deterministically with controlled term overlap and stable ties", () => {
    const overlap = calculateControlledTermOverlap(
      "zgjidhja kontratës shërbimit",
      { articleTitle: "Zgjidhja e kontratës", content: "Rregullat për shërbimin." }
    );
    const results = [
      { lawNumber: "04/L-077" as const, articleNumber: "1", chunkIndex: 1, contentHash: "a".repeat(64), fusedScore: 0.03, semanticRank: 1, lexicalRank: null, resultRank: 1, termOverlap: 0 },
      { lawNumber: "04/L-077" as const, articleNumber: "2", chunkIndex: 2, contentHash: "b".repeat(64), fusedScore: 0.029, semanticRank: 2, lexicalRank: null, resultRank: 2, termOverlap: 1 }
    ];

    expect(overlap).toBeGreaterThan(0);
    expect(rerankLegalHybridTuningResults(results, 0)[0]?.resultRank).toBe(1);
    expect(rerankLegalHybridTuningResults(results, 0.1)[0]?.resultRank).toBe(2);
    expect(rerankLegalHybridTuningResults(results, 0.1)).toEqual(
      rerankLegalHybridTuningResults(results, 0.1)
    );
  });

  it("uses domain-routed queries, evaluates 12 configurations and sanitizes reports", async () => {
    const gold = await goldSet();
    let callIndex = 0;
    const embedQuery = vi.fn().mockResolvedValue(Array(1_536).fill(0.1));
    const retrieveWithEmbedding = vi.fn(async () => {
      const evaluationIndex = Math.floor(callIndex / HYBRID_TUNING_RPC_CONFIGURATIONS.length);
      const goldCase = gold.cases[evaluationIndex]!;
      const chunk = goldCase.relevantChunks[0]!;
      callIndex += 1;
      return [{
        chunkId: "00000000-0000-4000-8000-000000000001",
        legalSourceId: "00000000-0000-4000-8000-000000000002",
        lawNumber: chunk.lawNumber,
        sourceTitle: "Burim",
        versionLabel: chunk.versionLabel,
        officialUrl: "https://example.test/act",
        officialDocumentUrl: null,
        documentType: "law" as const,
        applicabilityMode: "direct" as const,
        chunkIndex: chunk.chunkIndex,
        articleNumber: chunk.articleNumber,
        articleTitle: chunk.articleTitle,
        paragraphNumber: null,
        pointLabel: null,
        content: "Përmbajtje sintetike që nuk duhet ruajtur.",
        contentHash: chunk.contentHash,
        semanticScore: 0.7,
        lexicalScore: null,
        fusedScore: 0.02,
        semanticRank: 1,
        lexicalRank: null,
        resultRank: 1
      }];
    });
    const report = await runLegalHybridRetrievalTuning(
      { embedQuery, retrieveWithEmbedding } as unknown as ReturnType<typeof createLegalHybridRetrievalService>,
      gold
    );
    const serialized = JSON.stringify(report);

    expect(embedQuery).toHaveBeenCalledTimes(9);
    expect(retrieveWithEmbedding).toHaveBeenCalledTimes(54);
    expect(report.configurations).toHaveLength(12);
    expect(report.verdict).toBe("READY_FOR_RAG_INTEGRATION");
    expect(HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE.service).toBe("B");
    expect(serialized).not.toContain("Përmbajtje sintetike");
    expect(serialized).not.toMatch(/"(?:query|content|chunkId|legalSourceId|embedding|vector)"\s*:/u);
  });

  it("regenerates only needed in-memory embeddings and skips completed RPC runs on resume", async () => {
    const gold = await goldSet();
    const embedQuery = vi.fn().mockResolvedValue(Array(1_536).fill(0.1));
    const retrieveWithEmbedding = vi.fn().mockResolvedValue([]);
    const completedRuns = HYBRID_TUNING_RPC_CONFIGURATIONS.map((configuration) => ({
      runKey: `employment-notice-period:${configuration.id}`,
      evaluationId: "employment-notice-period",
      configurationId: configuration.id,
      results: []
    }));

    await runLegalHybridRetrievalTuning(
      { embedQuery, retrieveWithEmbedding } as unknown as ReturnType<typeof createLegalHybridRetrievalService>,
      gold,
      { completedRuns }
    );

    expect(embedQuery).toHaveBeenCalledTimes(8);
    expect(retrieveWithEmbedding).toHaveBeenCalledTimes(48);
  });

  it("checkpoints atomically, rejects hash mismatch and enforces 54-call budgets", async () => {
    const directory = await mkdtemp(join(tmpdir(), "lexo-hybrid-tuning-"));
    const path = join(directory, "checkpoint.json");
    const goldSetSha256 = "A".repeat(64);
    const planSha256 = "B".repeat(64);
    try {
      const store = await createHybridTuningCheckpointStore({ path, goldSetSha256, planSha256 });
      await store.completeRun({
        runKey: "employment-notice-period:rrf-20-candidates-50",
        evaluationId: "employment-notice-period",
        configurationId: "rrf-20-candidates-50",
        results: []
      });
      const serialized = await readFile(path, "utf8");
      expect(serialized).not.toMatch(/"(?:query|content|chunkId|legalSourceId|embedding|vector)"\s*:/u);
      await expect(createHybridTuningCheckpointStore({
        path,
        goldSetSha256,
        planSha256: "C".repeat(64)
      })).rejects.toThrow("LEGAL_HYBRID_TUNING_CHECKPOINT_INCOMPATIBLE");

      await writeFile(path, JSON.stringify({
        version: "legal-hybrid-tuning-checkpoint-v1",
        goldSetSha256,
        planSha256,
        attempts: { embeddings: 9, rpc: 54 },
        successes: { embeddings: 9, rpc: 54 },
        completedRuns: []
      }));
      const exhausted = await createHybridTuningCheckpointStore({ path, goldSetSha256, planSha256 });
      await expect(exhausted.recordAttempt("embeddings")).rejects.toThrow("LEGAL_HYBRID_TUNING_BUDGET_EXHAUSTED");
      await expect(exhausted.recordAttempt("rpc")).rejects.toThrow("LEGAL_HYBRID_TUNING_BUDGET_EXHAUSTED");
      await exhausted.startExecution();
      expect(exhausted.snapshot().attempts).toEqual({ embeddings: 0, rpc: 54 });
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("keeps real execution disabled and contains only the read-only hybrid RPC", async () => {
    const source = await readFile(
      resolve(process.cwd(), "scripts/run-legal-hybrid-retrieval-tuning.ts"),
      "utf8"
    );
    expect(source).toContain('mode !== "--execute-hybrid-tuning"');
    expect(source.indexOf("REAL_MODE_NOT_APPROVED")).toBeLessThan(
      source.indexOf('import("../src/legal/legal-embedding-adapter.js")')
    );
    expect(source).toContain('"match_legal_chunks_hybrid"');
    expect(source).toMatch(/\{\s*maxRetries:\s*0\s*\}/u);
    expect(source).not.toContain(".from(");
    expect(source).not.toMatch(/console\.(?:log|error)/u);
    expect(source).not.toMatch(/OPENAI_API_KEY\s*=|SUPABASE_SECRET_KEY\s*=/u);
    expect(source).toContain("checkpoint.startExecution()");
  });
});
