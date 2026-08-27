import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import {
  createLegalRetrievalCalibrationPlan,
  formulateCalibrationQuery,
  runLegalRetrievalCalibration
} from "../src/legal/legal-retrieval-calibration.js";
import { LEGAL_RETRIEVAL_EVALUATION_CASES } from "../src/legal/legal-retrieval-evaluation.js";
import { buildLegalRetrievalGoldSet } from "../src/legal/legal-retrieval-gold-set.js";
import type { createLegalRetrievalService } from "../src/legal/legal-retrieval.service.js";

function localChunk(lawNumber: "03/L-212" | "04/L-077", articleNumber: string, chunkIndex: number) {
  return {
    lawNumber,
    versionLabel: lawNumber === "03/L-212" ? "gazette-90-2010" : "gazette-16-2012",
    language: "sq",
    articleNumber,
    articleTitle: `Neni ${articleNumber}`,
    chunkIndex,
    contentSha256: chunkIndex.toString(16).padStart(64, "0")
  };
}

const GOLD_ARTICLES = [
  localChunk("03/L-212", "15", 15),
  localChunk("03/L-212", "23", 23),
  localChunk("03/L-212", "56", 56),
  localChunk("03/L-212", "71", 71),
  localChunk("04/L-077", "106", 106),
  localChunk("04/L-077", "169", 169),
  localChunk("04/L-077", "245", 245),
  localChunk("04/L-077", "587", 587),
  localChunk("04/L-077", "601", 601),
  localChunk("04/L-077", "602", 602),
  localChunk("04/L-077", "623", 623)
] as const;

describe("legal retrieval calibration", () => {
  it("builds a versioned, content-free gold set with verifiable provenance", () => {
    const goldSet = buildLegalRetrievalGoldSet(GOLD_ARTICLES);
    const serialized = JSON.stringify(goldSet);

    expect(goldSet.version).toBe("legal-retrieval-gold-v1");
    expect(goldSet.cases).toHaveLength(9);
    expect(serialized).not.toMatch(/"content"\s*:/u);
    expect(serialized).toContain('"contentHash"');
    expect(serialized).toContain('"rationale"');
  });

  it("creates deterministic A, B and C formulations without an LLM", () => {
    const evaluationCase = LEGAL_RETRIEVAL_EVALUATION_CASES[3];
    const formulations = (["A", "B", "C"] as const).map((strategy) =>
      formulateCalibrationQuery(evaluationCase, strategy)
    );

    expect(formulations[0]).toBe(evaluationCase.query);
    expect(new Set(formulations).size).toBe(3);
    expect(formulations[1]).toContain("mospërmbushja");
    expect(formulations[2]).toContain("marrëveshje shërbimi");
  });

  it("plans only 27 embeddings and 27 read-only RPC calls for the full grid", () => {
    const plan = createLegalRetrievalCalibrationPlan();

    expect(plan.requestBudget).toEqual({
      openAiEmbeddingRequests: 27,
      readOnlyRpcCalls: 27,
      evaluatedGridConfigurations: 9
    });
    expect(plan.queryFingerprints).toHaveLength(27);
    expect(JSON.stringify(plan)).not.toContain(LEGAL_RETRIEVAL_EVALUATION_CASES[0].query);
  });

  it("evaluates the grid against exact gold chunks and reports sanitized metrics", async () => {
    const goldSet = buildLegalRetrievalGoldSet(GOLD_ARTICLES);
    const retrieve = vi.fn(async (input: { readonly contractType: "employment" | "service" | "lease" }) => {
      const goldCase = goldSet.cases.find((item) => item.contractType === input.contractType);
      const chunk = goldCase?.relevantChunks[0];
      if (chunk === undefined) {
        return [];
      }
      return [{
        chunkId: "00000000-0000-4000-8000-000000000001",
        legalSourceId: "00000000-0000-4000-8000-000000000002",
        lawNumber: chunk.lawNumber,
        sourceTitle: "Burimi",
        versionLabel: chunk.versionLabel,
        officialUrl: "https://example.test",
        officialDocumentUrl: null,
        documentType: "law" as const,
        applicabilityMode: "direct" as const,
        chunkIndex: chunk.chunkIndex,
        articleNumber: chunk.articleNumber,
        articleTitle: chunk.articleTitle,
        paragraphNumber: null,
        pointLabel: null,
        content: "Tekst që nuk duhet të raportohet",
        contentHash: chunk.contentHash,
        similarity: 0.6
      }];
    });
    const report = await runLegalRetrievalCalibration(
      { retrieve } as ReturnType<typeof createLegalRetrievalService>,
      goldSet
    );
    const serialized = JSON.stringify(report);

    expect(retrieve).toHaveBeenCalledTimes(27);
    expect(report.configurations).toHaveLength(9);
    expect(report.outcome).toBe("NEEDS_HYBRID_RETRIEVAL");
    expect(report.configurations.every((item) => !item.passesMinimumCriteria)).toBe(true);
    expect(serialized).not.toContain("Tekst që nuk duhet të raportohet");
    expect(serialized).not.toMatch(/"(?:chunkId|legalSourceId|query|embedding)"\s*:/u);
  });

  it("resumes completed combinations without duplicate retrieval requests", async () => {
    const goldSet = buildLegalRetrievalGoldSet(GOLD_ARTICLES);
    const retrieve = vi.fn().mockResolvedValue([]);
    const firstGoldChunk = goldSet.cases[0]!.relevantChunks[0]!;

    await runLegalRetrievalCalibration(
      { retrieve } as ReturnType<typeof createLegalRetrievalService>,
      goldSet,
      {
        completedRuns: [{
          runKey: "employment-notice-period:A",
          evaluationId: "employment-notice-period",
          strategy: "A",
          results: [{
            lawNumber: firstGoldChunk.lawNumber,
            articleNumber: firstGoldChunk.articleNumber,
            chunkIndex: firstGoldChunk.chunkIndex,
            contentHash: firstGoldChunk.contentHash,
            similarity: 0.7
          }]
        }]
      }
    );

    expect(retrieve).toHaveBeenCalledTimes(26);
  });

  it("keeps real execution disabled unless the explicit calibration flag is used", async () => {
    const source = await readFile(
      resolve(process.cwd(), "scripts/run-legal-retrieval-calibration.ts"),
      "utf8"
    );

    expect(source).toContain('mode !== "--execute-calibration"');
    expect(source).toContain('mode !== "--execute-canary"');
    expect(source.indexOf("REAL_MODE_NOT_APPROVED")).toBeLessThan(
      source.indexOf('import("../src/legal/legal-embedding-adapter.js")')
    );
    expect(source).toContain("createLegalEmbeddingAdapter(client, { maxRetries: 0 })");
    expect(source).not.toContain("createLegalEmbeddingAdapter({");
    expect(source).not.toMatch(/console\.(?:log|error)/u);
    expect(source).not.toMatch(/OPENAI_API_KEY\s*=|SUPABASE_SECRET_KEY\s*=/u);
  });
});
