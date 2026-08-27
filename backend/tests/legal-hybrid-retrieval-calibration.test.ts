import { mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import { createHybridCalibrationCheckpointStore } from "../src/legal/legal-hybrid-calibration-checkpoint.js";
import {
  calculateHybridCalibrationMetrics,
  HYBRID_CALIBRATION_CONFIGURATION,
  runLegalHybridRetrievalCalibration
} from "../src/legal/legal-hybrid-retrieval-calibration.js";
import type { createLegalHybridRetrievalService } from "../src/legal/legal-hybrid-retrieval.service.js";
import type { CalibrationGoldSet } from "../src/legal/legal-retrieval-calibration.js";

const goldHash = "A".repeat(64);
const planHash = "B".repeat(64);

async function readGoldSet() {
  return JSON.parse(
    await readFile(
      resolve(process.cwd(), "data/legal-sources/retrieval/gold-set-v1.json"),
      "utf8"
    )
  ) as CalibrationGoldSet;
}

describe("legal hybrid retrieval calibration", () => {
  it("uses the versioned parameters and scores all domains against the unchanged gold set", async () => {
    const goldSet = await readGoldSet();
    let callIndex = 0;
    const retrieve = vi.fn(async () => {
      const goldCase = goldSet.cases[callIndex % goldSet.cases.length]!;
      const chunk = goldCase.relevantChunks[0]!;
      callIndex += 1;
      return [{
        chunkId: "00000000-0000-4000-8000-000000000001",
        legalSourceId: "00000000-0000-4000-8000-000000000002",
        lawNumber: chunk.lawNumber,
        sourceTitle: "Burim sintetik",
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
        content: "Tekst sintetik që nuk duhet të raportohet.",
        contentHash: chunk.contentHash,
        semanticScore: null,
        lexicalScore: 1,
        fusedScore: 0.02,
        semanticRank: null,
        lexicalRank: 1,
        resultRank: 1
      }];
    });

    const report = await runLegalHybridRetrievalCalibration(
      { retrieve } as unknown as ReturnType<typeof createLegalHybridRetrievalService>,
      goldSet
    );
    const serialized = JSON.stringify(report);

    expect(retrieve).toHaveBeenCalledTimes(27);
    expect(report.verdict).toBe("READY_FOR_RAG_INTEGRATION");
    expect(report.strategies).toHaveLength(3);
    expect(report.strategies.every((strategy) => strategy.passesAcceptanceGate)).toBe(true);
    expect(HYBRID_CALIBRATION_CONFIGURATION).toEqual({
      matchCount: 8,
      candidateCount: 50,
      minSemanticSimilarity: 0.45,
      rrfK: 60
    });
    expect(serialized).not.toContain("Tekst sintetik");
    expect(serialized).not.toMatch(/"(?:chunkId|legalSourceId|query|content|embedding|vector)"\s*:/u);
  });

  it("calculates empty-result, rank, domain and scope metrics deterministically", () => {
    const cases = [
      { contractType: "employment" as const, results: [{ verdict: "relevant" as const }], outOfScopeCount: 0 },
      { contractType: "service" as const, results: [], outOfScopeCount: 0 },
      { contractType: "lease" as const, results: [{ verdict: "irrelevant" as const }, { verdict: "relevant" as const }], outOfScopeCount: 1 }
    ];
    const metrics = calculateHybridCalibrationMetrics(cases);

    expect(metrics.precisionAt5).toBe(2 / 15);
    expect(metrics.hitAt5).toBe(2 / 3);
    expect(metrics.meanReciprocalRank).toBe(0.5);
    expect(metrics.relevantAtRank1).toBe(1);
    expect(metrics.noResultRate).toBe(1 / 3);
    expect(metrics.scopeViolations).toBe(1);
    expect(metrics.byContractType.service).toEqual({ hitAt5: 0, totalCases: 1 });
  });

  it("writes an atomic sanitized checkpoint and resumes without duplicate work", async () => {
    const directory = await mkdtemp(join(tmpdir(), "lexo-hybrid-calibration-"));
    const path = join(directory, "checkpoint.json");
    try {
      const store = await createHybridCalibrationCheckpointStore({
        path,
        goldSetSha256: goldHash,
        planSha256: planHash
      });
      await store.recordAttempt("embeddings");
      await store.recordSuccess("embeddings");
      await store.recordAttempt("rpc");
      await store.recordSuccess("rpc");
      await store.completeRun({
        runKey: "employment-notice-period:A",
        evaluationId: "employment-notice-period",
        strategy: "A",
        results: []
      });
      const serialized = await readFile(path, "utf8");
      const reloaded = await createHybridCalibrationCheckpointStore({
        path,
        goldSetSha256: goldHash,
        planSha256: planHash
      });

      expect(reloaded.snapshot().completedRuns).toHaveLength(1);
      expect(serialized).not.toMatch(
        /"(?:query|content|chunkId|legalSourceId|embedding|vector|credential|apiKey)"\s*:/iu
      );

      const goldSet = await readGoldSet();
      const retrieve = vi.fn().mockResolvedValue([]);
      await runLegalHybridRetrievalCalibration(
        { retrieve } as unknown as ReturnType<typeof createLegalHybridRetrievalService>,
        goldSet,
        { completedRuns: reloaded.snapshot().completedRuns }
      );
      expect(retrieve).toHaveBeenCalledTimes(26);
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("rejects hash mismatch and enforces the cumulative request budget", async () => {
    const directory = await mkdtemp(join(tmpdir(), "lexo-hybrid-calibration-"));
    const path = join(directory, "checkpoint.json");
    try {
      await createHybridCalibrationCheckpointStore({
        path,
        goldSetSha256: goldHash,
        planSha256: planHash
      });
      await expect(createHybridCalibrationCheckpointStore({
        path,
        goldSetSha256: goldHash,
        planSha256: "C".repeat(64)
      })).rejects.toThrow("LEGAL_HYBRID_CALIBRATION_CHECKPOINT_INCOMPATIBLE");

      await writeFile(path, JSON.stringify({
        version: "legal-hybrid-calibration-checkpoint-v1",
        goldSetSha256: goldHash,
        planSha256: planHash,
        attempts: { embeddings: 27, rpc: 27 },
        successes: { embeddings: 27, rpc: 27 },
        completedRuns: []
      }));
      const exhausted = await createHybridCalibrationCheckpointStore({
        path,
        goldSetSha256: goldHash,
        planSha256: planHash
      });
      await expect(exhausted.recordAttempt("embeddings")).rejects.toThrow(
        "LEGAL_HYBRID_CALIBRATION_REQUEST_BUDGET_EXHAUSTED"
      );
      await expect(exhausted.recordAttempt("rpc")).rejects.toThrow(
        "LEGAL_HYBRID_CALIBRATION_REQUEST_BUDGET_EXHAUSTED"
      );
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("keeps the real runner disabled without its explicit flag and contains no write RPC", async () => {
    const source = await readFile(
      resolve(process.cwd(), "scripts/run-legal-hybrid-retrieval-calibration.ts"),
      "utf8"
    );

    expect(source).toContain('mode !== "--execute-hybrid-calibration"');
    expect(source.indexOf("REAL_MODE_NOT_APPROVED")).toBeLessThan(
      source.indexOf('import("../src/legal/legal-embedding-adapter.js")')
    );
    expect(source).toContain("createLegalEmbeddingAdapter(");
    expect(source).toContain("{ maxRetries: 0 }");
    expect(source).toContain('"match_legal_chunks_hybrid"');
    expect(source).not.toContain(".from(");
    expect(source).not.toMatch(/supabaseAdmin\s*\.\s*(?:insert|update|delete|upsert)\s*\(/u);
    expect(source).not.toMatch(/console\.(?:log|error)/u);
    expect(source).not.toMatch(/OPENAI_API_KEY\s*=|SUPABASE_SECRET_KEY\s*=/u);
  });
});
