import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import type { createLegalHybridRetrievalService } from "../src/legal/legal-hybrid-retrieval.service.js";
import {
  createLegalHybridServiceTuningPlan,
  formulateServiceTuningQuery,
  getServiceEvaluationCases,
  runLegalHybridServiceTuning,
  SERVICE_TUNING_REQUEST_BUDGET,
  SERVICE_TUNING_VARIANTS
} from "../src/legal/legal-hybrid-service-tuning.js";
import type { CalibrationGoldSet } from "../src/legal/legal-retrieval-calibration.js";

async function loadGoldSet() {
  return JSON.parse(
    await readFile(resolve(process.cwd(), "data/legal-sources/retrieval/gold-set-v1.json"), "utf8")
  ) as CalibrationGoldSet;
}

describe("service-only hybrid tuning", () => {
  it("creates three deterministic service variants with a strict 9 plus 9 budget", () => {
    const plan = createLegalHybridServiceTuningPlan();

    expect(plan.caseCount).toBe(3);
    expect(plan.variants).toHaveLength(3);
    expect(plan.uniqueQueries).toBe(9);
    expect(plan.requestBudget).toEqual({
      openAiEmbeddingRequests: 9,
      readOnlyHybridRpcCalls: 9,
      databaseWrites: 0
    });
    expect(plan.configuration.minSemanticSimilarity).toBe(0.45);
    expect(plan.globalSimilarityThresholdChanged).toBe(false);
    expect(plan.requiresMigration).toBe(false);
    expect(new Set(plan.queryFingerprints.map((item) => item.sha256)).size).toBe(9);
  });

  it("uses only verified deterministic terminology without injecting article numbers", () => {
    for (const evaluationCase of getServiceEvaluationCases()) {
      for (const variant of SERVICE_TUNING_VARIANTS) {
        const first = formulateServiceTuningQuery(evaluationCase, variant.id);
        const second = formulateServiceTuningQuery(evaluationCase, variant.id);

        expect(first).toBe(second);
        expect(first).not.toMatch(/\b(?:106|169|245|623)\b/u);
        expect(first.length).toBeGreaterThan(10);
      }
    }
  });

  it("runs exactly three cases by three variants and emits no content or identifiers", async () => {
    const goldSet = await loadGoldSet();
    const retrieve = vi.fn(async () => {
      const goldCase = goldSet.cases.find((item) => item.evaluationId === "service-damages")!;
      const chunk = goldCase.relevantChunks[0]!;
      return [{
        chunkId: "00000000-0000-4000-8000-000000000001",
        legalSourceId: "00000000-0000-4000-8000-000000000002",
        lawNumber: "04/L-077" as const,
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
    const report = await runLegalHybridServiceTuning(
      { retrieve } as unknown as ReturnType<typeof createLegalHybridRetrievalService>,
      goldSet
    );
    const serialized = JSON.stringify(report);

    expect(retrieve).toHaveBeenCalledTimes(9);
    expect(report.cases).toHaveLength(9);
    expect(serialized).not.toContain("Përmbajtje sintetike");
    expect(serialized).not.toMatch(/"(?:query|content|chunkId|legalSourceId|contentHash|vector)"\s*:/u);
  });

  it("keeps the real runner disabled without its explicit flag and read-only", async () => {
    const source = await readFile(
      resolve(process.cwd(), "scripts/run-legal-hybrid-service-tuning.ts"),
      "utf8"
    );

    expect(source).toContain('mode !== "--execute-service-tuning"');
    expect(source.indexOf("REAL_MODE_NOT_APPROVED")).toBeLessThan(
      source.indexOf('import("../src/legal/legal-embedding-adapter.js")')
    );
    expect(source).toContain("maxRetries: 0");
    expect(source).toContain('"match_legal_chunks_hybrid"');
    expect(source).not.toContain(".from(");
    expect(source).not.toMatch(/\.(?:insert|update|upsert|delete)\(/u);
    expect(source).not.toMatch(/console\.(?:log|error)/u);
    expect(SERVICE_TUNING_REQUEST_BUDGET.openAiEmbeddingRequests).toBe(9);
    expect(SERVICE_TUNING_REQUEST_BUDGET.readOnlyHybridRpcCalls).toBe(9);
  });

  it("keeps diagnosis and plan artifacts sanitized", async () => {
    for (const fileName of ["service-tuning-diagnosis.json", "service-tuning-plan.json"]) {
      const serialized = await readFile(
        resolve(process.cwd(), "data/legal-sources/retrieval", fileName),
        "utf8"
      );
      expect(serialized).not.toMatch(/"(?:query|content|vector|chunkId|legalSourceId|contentHash|credential|rawResponse)"\s*:/u);
    }
  });
});
