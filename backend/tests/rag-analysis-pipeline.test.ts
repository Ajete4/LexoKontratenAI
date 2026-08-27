import { describe, expect, it, vi } from "vitest";

import type { ContractAnalysisResult } from "../src/ai/contract-analysis.schema.js";
import {
  createRagAnalysisPipeline,
  DEFAULT_RAG_CONCURRENCY
} from "../src/rag/rag-analysis-pipeline.js";
import type { createRagClauseOrchestrator } from "../src/rag/rag-orchestrator.js";
import { ApiError } from "../src/utils/ApiError.js";

function clauses(count = 3): ContractAnalysisResult["clauses"] {
  return Array.from({ length: count }, (_, index) => ({
    position: index + 1,
    clauseType: index === 0 ? "payment" as const : "termination" as const,
    findingType: "risky" as const,
    title: `Klauzola ${index + 1}`,
    originalText: `Tekst sintetik ${index + 1}`,
    simplifiedText: null,
    severity: "medium" as const,
    favoredParty: "unclear" as const,
    riskExplanation: "Shpjegim fillestar",
    suggestedAction: "Veprim fillestar",
    suggestedRewrite: null,
    confidence: 0.8,
    requiresProfessionalReview: false
  }));
}

function groundedResult(index = 1) {
  return {
    contextStatus: "grounded" as const,
    finding: {
      finding: "Gjetje",
      severity: "high" as const,
      explanation: "Shpjegim i bazuar në evidencë.",
      recommendation: "Kërkoni shqyrtim profesional.",
      evidenceStatus: "grounded" as const,
      citationIds: ["C1"],
      requiresProfessionalReview: true
    },
    citationIds: ["C1"],
    citations: [{
      chunkId: `00000000-0000-4000-8000-${String(index).padStart(12, "0")}`,
      legalSourceId: "00000000-0000-4000-8000-000000000099",
      lawNumber: "04/L-077" as const,
      sourceTitle: "Burim juridik sintetik",
      versionLabel: "official-v1",
      articleNumber: "10",
      articleTitle: "Titull neni",
      paragraphNumber: null,
      pointLabel: null,
      officialUrl: "https://example.test/act",
      officialDocumentUrl: null,
      contentHash: String(index).padStart(64, "a").slice(-64),
      semanticScore: 0.8,
      lexicalScore: 0.2,
      fusedScore: 0.03,
      resultRank: 1
    }]
  };
}

describe("production RAG clause pipeline", () => {
  it("preserves clause order and builds internal provenance without public UUID/hash leakage", async () => {
    const orchestrateClause = vi.fn(async (_input) => groundedResult(orchestrateClause.mock.calls.length));
    const pipeline = createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>,
      concurrency: 2
    });

    const result = await pipeline({ contractType: "service", clauses: clauses() });

    expect(result.clauses.map((clause) => clause.position)).toEqual([1, 2, 3]);
    expect(result.persistence.clause_evidence.map((entry) => entry.clause_key))
      .toEqual(["clause-1", "clause-2", "clause-3"]);
    expect(result.clauses[0]?.citations[0]).not.toHaveProperty("chunkId");
    expect(result.clauses[0]?.citations[0]).not.toHaveProperty("contentHash");
    expect(result.persistence.clause_evidence[0]?.citations[0]).not.toHaveProperty("official_url");
    expect(result.persistence.clause_evidence[0]?.citations[0]).not.toHaveProperty("content");
  });

  it("uses contract type, clause title/text and controlled clause category", async () => {
    const orchestrateClause = vi.fn(async () => groundedResult());
    const pipeline = createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>
    });
    await pipeline({ contractType: "employment", clauses: clauses(1) });
    expect(orchestrateClause).toHaveBeenCalledWith({
      contractType: "employment",
      clauseTitle: "Klauzola 1",
      clauseText: "Tekst sintetik 1",
      controlledCategory: "payment"
    });
  });

  it("persists insufficient evidence with zero citations", async () => {
    const orchestrateClause = vi.fn(async () => ({
      contextStatus: "insufficient_evidence" as const,
      finding: {
        finding: "Pa evidencë", severity: "review_required" as const,
        explanation: "Evidencë e pamjaftueshme.", recommendation: "Shqyrtim profesional.",
        evidenceStatus: "insufficient_evidence" as const, citationIds: [],
        requiresProfessionalReview: true
      },
      citationIds: [],
      citations: []
    }));
    const result = await createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>
    })({ contractType: "lease", clauses: clauses(1) });
    expect(result.persistence.clause_evidence[0]).toEqual({
      clause_key: "clause-1", evidence_status: "insufficient_evidence", citations: []
    });
    expect(result.clauses[0]?.confidence).toBe(0.8);
  });

  it("never leaves 100 percent confidence when legal evidence is insufficient", async () => {
    const inputClauses = clauses(1);
    inputClauses[0]!.confidence = 1;
    const orchestrateClause = vi.fn(async () => ({
      contextStatus: "insufficient_evidence" as const,
      finding: {
        finding: "Pa evidencë",
        severity: "review_required" as const,
        explanation: "Evidencë e pjesshme.",
        recommendation: "Shqyrtim profesional.",
        evidenceStatus: "insufficient_evidence" as const,
        citationIds: [],
        requiresProfessionalReview: true
      },
      citationIds: [],
      citations: []
    }));

    const result = await createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>
    })({ contractType: "service", clauses: inputClauses });

    expect(result.clauses[0]?.confidence).toBe(0.8);
  });

  it("enforces bounded concurrency and one orchestration per clause", async () => {
    let active = 0;
    let maximumActive = 0;
    const orchestrateClause = vi.fn(async () => {
      active += 1;
      maximumActive = Math.max(maximumActive, active);
      await new Promise((resolve) => setTimeout(resolve, 5));
      active -= 1;
      return groundedResult(orchestrateClause.mock.calls.length);
    });
    await createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>,
      concurrency: DEFAULT_RAG_CONCURRENCY
    })({ contractType: "service", clauses: clauses(8) });
    expect(maximumActive).toBeLessThanOrEqual(DEFAULT_RAG_CONCURRENCY);
    expect(orchestrateClause).toHaveBeenCalledTimes(8);
  });

  it("rejects more than 30 clauses before orchestration", async () => {
    const orchestrateClause = vi.fn();
    await expect(createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>
    })({ contractType: "service", clauses: clauses(31) })).rejects.toMatchObject({
      code: "RAG_INPUT_INVALID"
    });
    expect(orchestrateClause).not.toHaveBeenCalled();
  });

  it("stops scheduling remaining work after a blocking safe error", async () => {
    const orchestrateClause = vi.fn(async () => {
      if (orchestrateClause.mock.calls.length === 1) {
        throw new ApiError(503, "RAG_RETRIEVAL_UNAVAILABLE", "Safe error.");
      }
      return groundedResult(orchestrateClause.mock.calls.length);
    });
    await expect(createRagAnalysisPipeline({
      orchestrateClause: orchestrateClause as ReturnType<typeof createRagClauseOrchestrator>,
      concurrency: 1
    })({ contractType: "service", clauses: clauses(10) })).rejects.toMatchObject({
      code: "RAG_RETRIEVAL_UNAVAILABLE"
    });
    expect(orchestrateClause).toHaveBeenCalledTimes(1);
  });
});
