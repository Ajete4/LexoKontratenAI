import { z } from "zod";

import type {
  ContractAnalysisResult,
  ContractType
} from "../ai/contract-analysis.schema.js";
import { ApiError } from "../utils/ApiError.js";
import {
  ragCitationPersistencePayloadSchema,
  type RagCitationPersistencePayload
} from "./rag-citation-persistence.schema.js";
import type { createRagClauseOrchestrator } from "./rag-orchestrator.js";

export const DEFAULT_RAG_CONCURRENCY = 2;
export const MAX_RAG_CLAUSES = 30;

const pipelineInputSchema = z.object({
  contractType: z.enum(["employment", "service", "lease"]),
  clauses: z.array(z.unknown()).max(MAX_RAG_CLAUSES)
}).strict();

export const publicLegalCitationSchema = z.object({
  citationId: z.string().regex(/^C[1-5]$/u),
  rank: z.number().int().min(1).max(5),
  lawNumber: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  sourceTitle: z.string().min(1),
  articleNumber: z.string().min(1).nullable(),
  articleTitle: z.string().min(1).nullable(),
  officialUrl: z.string().url().startsWith("https://"),
  officialDocumentUrl: z.string().url().startsWith("https://").nullable()
}).strict();

export const clauseEvidenceResponseSchema = z.object({
  evidenceStatus: z.enum(["grounded", "insufficient_evidence", "legacy_unverified"]),
  citations: z.array(publicLegalCitationSchema).max(5)
}).strict().superRefine((value, context) => {
  if (value.evidenceStatus === "grounded" && value.citations.length === 0) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Grounded evidence requires citations." });
  }
  if (value.evidenceStatus !== "grounded" && value.citations.length !== 0) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Ungrounded evidence cannot expose citations." });
  }
});

export type PublicLegalCitation = z.infer<typeof publicLegalCitationSchema>;
export type ClauseEvidence = z.infer<typeof clauseEvidenceResponseSchema>;

export type RagAnalyzedClause = ContractAnalysisResult["clauses"][number] & ClauseEvidence;

export type RagAnalysisPipelineResult = {
  clauses: RagAnalyzedClause[];
  persistence: RagCitationPersistencePayload;
};

type ClauseOrchestrator = ReturnType<typeof createRagClauseOrchestrator>;

function controlledCategory(clauseType: string): string | undefined {
  return clauseType === "other" ? undefined : clauseType;
}

export function createRagAnalysisPipeline(dependencies: {
  orchestrateClause: ClauseOrchestrator;
  concurrency?: number;
}) {
  const concurrency = dependencies.concurrency ?? DEFAULT_RAG_CONCURRENCY;
  if (!Number.isInteger(concurrency) || concurrency < 1 || concurrency > 5) {
    throw new Error("RAG_CONCURRENCY_INVALID");
  }

  return async (input: {
    contractType: ContractType;
    clauses: ContractAnalysisResult["clauses"];
  }): Promise<RagAnalysisPipelineResult> => {
    const parsed = pipelineInputSchema.safeParse(input);
    if (!parsed.success) {
      throw new ApiError(400, "RAG_INPUT_INVALID", "The grounded analysis input is invalid.");
    }

    const results = new Array<RagAnalyzedClause>(input.clauses.length);
    const evidence = new Array<RagCitationPersistencePayload["clause_evidence"][number]>(
      input.clauses.length
    );
    let nextIndex = 0;
    let blockingError: unknown;

    const worker = async () => {
      while (blockingError === undefined) {
        const index = nextIndex++;
        const clause = input.clauses[index];
        if (clause === undefined) return;

        try {
          const grounded = await dependencies.orchestrateClause({
            contractType: input.contractType,
            clauseTitle: clause.title,
            clauseText: clause.originalText ?? clause.riskExplanation ?? clause.simplifiedText,
            controlledCategory: controlledCategory(clause.clauseType)
          });

          const publicCitations = grounded.citations.map((citation, citationIndex) => ({
            citationId: grounded.citationIds[citationIndex]!,
            rank: citationIndex + 1,
            lawNumber: citation.lawNumber,
            sourceTitle: citation.sourceTitle,
            articleNumber: citation.articleNumber,
            articleTitle: citation.articleTitle,
            officialUrl: citation.officialUrl,
            officialDocumentUrl: citation.officialDocumentUrl
          }));

          results[index] = {
            ...clause,
            severity: grounded.finding.severity,
            riskExplanation: grounded.finding.explanation,
            suggestedAction: grounded.finding.recommendation,
            confidence:
              grounded.contextStatus === "insufficient_evidence"
                ? Math.min(clause.confidence, 0.8)
                : clause.confidence,
            requiresProfessionalReview: grounded.finding.requiresProfessionalReview,
            evidenceStatus: grounded.contextStatus,
            citations: publicCitations
          };
          evidence[index] = {
            clause_key: `clause-${clause.position}`,
            evidence_status: grounded.contextStatus,
            citations: grounded.citations.map((citation, citationIndex) => ({
              citation_id: grounded.citationIds[citationIndex]!,
              legal_chunk_id: citation.chunkId,
              citation_rank: citationIndex + 1,
              retrieval_method: "hybrid_rrf_v1" as const,
              semantic_score: citation.semanticScore,
              lexical_score: citation.lexicalScore,
              fused_score: citation.fusedScore,
              content_hash: citation.contentHash
            }))
          };
        } catch (error) {
          blockingError = error;
        }
      }
    };

    await Promise.all(
      Array.from({ length: Math.min(concurrency, input.clauses.length) }, worker)
    );
    if (blockingError !== undefined) throw blockingError;

    const persistence = ragCitationPersistencePayloadSchema.parse({
      clause_evidence: evidence
    });
    return { clauses: results, persistence };
  };
}
