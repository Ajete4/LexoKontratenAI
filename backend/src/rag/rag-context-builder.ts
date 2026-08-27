import { z } from "zod";

import type { ContractType } from "../ai/contract-analysis.schema.js";
import type { createLegalHybridRetrievalService } from "../legal/legal-hybrid-retrieval.service.js";
import {
  calculateControlledTermOverlap,
  rerankLegalHybridTuningResults
} from "../legal/legal-hybrid-tuning-reranker.js";
import { RAG_ALLOWED_LAWS, RAG_RETRIEVAL_CONFIG } from "./rag-config.js";
import { buildDeterministicRagQuery, type RagQueryInput } from "./rag-query-builder.js";

type HybridService = ReturnType<typeof createLegalHybridRetrievalService>;

const contextInputSchema = z.object({
  contractType: z.enum(["employment", "service", "lease"]),
  clauseTitle: z.string().min(1).max(200),
  clauseText: z.string().min(1).max(1_500).nullable(),
  controlledCategory: z.string().min(1).max(100).optional()
}).strict();

export type RagContextSource = {
  readonly chunkId: string;
  readonly legalSourceId: string;
  readonly lawNumber: "03/L-212" | "04/L-077" | "08/L-142";
  readonly sourceTitle: string;
  readonly versionLabel: string;
  readonly officialUrl: string;
  readonly officialDocumentUrl: string | null;
  readonly articleNumber: string | null;
  readonly articleTitle: string | null;
  readonly paragraphNumber: string | null;
  readonly pointLabel: string | null;
  readonly content: string;
  readonly contentHash: string;
  readonly semanticScore: number | null;
  readonly lexicalScore: number | null;
  readonly fusedScore: number;
  readonly resultRank: number;
};

export type RagContext = {
  readonly retrievalStatus: "grounded" | "insufficient_evidence";
  readonly contractType: ContractType;
  readonly queryStrategy: "A" | "verified-title-anchors";
  readonly sources: readonly RagContextSource[];
};

export function createRagContextBuilder(service: HybridService) {
  return async (input: RagQueryInput): Promise<RagContext> => {
    const parsed = contextInputSchema.parse(input);
    const builtQuery = buildDeterministicRagQuery(parsed);
    if (parsed.controlledCategory === "data_protection") {
      return {
        retrievalStatus: "insufficient_evidence",
        contractType: parsed.contractType,
        queryStrategy: builtQuery.queryStrategy,
        sources: []
      };
    }
    const retrieved = await service.retrieve({
      query: builtQuery.query,
      contractType: parsed.contractType,
      matchCount: RAG_RETRIEVAL_CONFIG.matchCount,
      candidateCount: RAG_RETRIEVAL_CONFIG.candidateCount,
      minSemanticSimilarity: RAG_RETRIEVAL_CONFIG.minSemanticSimilarity,
      rrfK: RAG_RETRIEVAL_CONFIG.rrfK
    });
    const allowedLaws = new Set(RAG_ALLOWED_LAWS[parsed.contractType]);
    if (retrieved.some((result) => !allowedLaws.has(result.lawNumber))) {
      throw new Error("RAG_SCOPE_VIOLATION");
    }

    const unique = new Map(retrieved.map((result) => [result.chunkId, result]));
    const reranked = rerankLegalHybridTuningResults(
      [...unique.values()].map((result) => ({
        lawNumber: result.lawNumber,
        articleNumber: result.articleNumber,
        chunkIndex: result.chunkIndex,
        contentHash: result.contentHash,
        semanticScore: result.semanticScore,
        lexicalScore: result.lexicalScore,
        fusedScore: result.fusedScore,
        semanticRank: result.semanticRank,
        lexicalRank: result.lexicalRank,
        resultRank: result.resultRank,
        termOverlap: calculateControlledTermOverlap(builtQuery.query, result)
      })),
      RAG_RETRIEVAL_CONFIG.termBoost
    );
    const byHash = new Map(retrieved.map((result) => [result.contentHash, result]));
    const sources: RagContextSource[] = [];
    let characters = 0;
    for (const rerankedResult of reranked) {
      const result = byHash.get(rerankedResult.contentHash);
      if (result === undefined || sources.some((source) => source.contentHash === result.contentHash)) continue;
      if (sources.length >= RAG_RETRIEVAL_CONFIG.maximumSources) break;
      if (characters + result.content.length > RAG_RETRIEVAL_CONFIG.maximumContextCharacters) continue;
      characters += result.content.length;
      sources.push({
        chunkId: result.chunkId,
        legalSourceId: result.legalSourceId,
        lawNumber: result.lawNumber,
        sourceTitle: result.sourceTitle,
        versionLabel: result.versionLabel,
        officialUrl: result.officialUrl,
        officialDocumentUrl: result.officialDocumentUrl,
        articleNumber: result.articleNumber,
        articleTitle: result.articleTitle,
        paragraphNumber: result.paragraphNumber,
        pointLabel: result.pointLabel,
        content: result.content,
        contentHash: result.contentHash,
        semanticScore: result.semanticScore,
        lexicalScore: result.lexicalScore,
        fusedScore: result.fusedScore,
        resultRank: sources.length + 1
      });
    }

    return {
      retrievalStatus: sources.length === 0 ? "insufficient_evidence" : "grounded",
      contractType: parsed.contractType,
      queryStrategy: builtQuery.queryStrategy,
      sources
    };
  };
}
