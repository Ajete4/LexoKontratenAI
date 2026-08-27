import { z } from "zod";

import { ApiError } from "../utils/ApiError.js";
import {
  createOpaqueCitationMap,
  legalCitationSchema,
  resolveCitationIds,
  type LegalCitation
} from "./rag-citations.js";
import type { RagContext } from "./rag-context-builder.js";
import { groundedFindingSchema, type GroundedFinding } from "./rag-evidence.schema.js";
import { buildGroundedClausePrompt } from "./rag-prompt.js";
import type { RagQueryInput } from "./rag-query-builder.js";

const orchestratorInputSchema = z.object({
  contractType: z.enum(["employment", "service", "lease"]),
  clauseTitle: z.string().min(1).max(200),
  clauseText: z.string().min(1).max(1_500).nullable(),
  controlledCategory: z.string().min(1).max(100).optional()
}).strict();

type Prompt = ReturnType<typeof buildGroundedClausePrompt>;

export type RagOrchestratorDependencies = {
  readonly buildContext: (input: RagQueryInput) => Promise<RagContext>;
  readonly analyzeGroundedFinding: (prompt: Prompt) => Promise<unknown>;
};

function citationFromSource(source: RagContext["sources"][number]): LegalCitation {
  return legalCitationSchema.parse({
    chunkId: source.chunkId,
    legalSourceId: source.legalSourceId,
    lawNumber: source.lawNumber,
    sourceTitle: source.sourceTitle,
    versionLabel: source.versionLabel,
    articleNumber: source.articleNumber,
    articleTitle: source.articleTitle,
    paragraphNumber: source.paragraphNumber,
    pointLabel: source.pointLabel,
    officialUrl: source.officialUrl,
    officialDocumentUrl: source.officialDocumentUrl,
    contentHash: source.contentHash,
    semanticScore: source.semanticScore,
    lexicalScore: source.lexicalScore,
    fusedScore: source.fusedScore,
    resultRank: source.resultRank
  });
}

const insufficientEvidence: GroundedFinding = {
  finding: "Nuk ka evidencë të mjaftueshme juridike në korpusin e kufizuar.",
  severity: "review_required",
  explanation: "Rezultati nuk mund të mbështetet në fragmentet juridike të rikthyera.",
  recommendation: "Kërkohet shqyrtim profesional përpara një përfundimi juridik.",
  evidenceStatus: "insufficient_evidence",
  citationIds: [],
  requiresProfessionalReview: true
};

export function createRagClauseOrchestrator(dependencies: RagOrchestratorDependencies) {
  return async (input: unknown) => {
    const parsed = orchestratorInputSchema.safeParse(input);
    if (!parsed.success) {
      throw new ApiError(400, "RAG_INPUT_INVALID", "The grounded analysis input is invalid.");
    }

    let context: RagContext;
    try {
      context = await dependencies.buildContext(parsed.data);
    } catch (error) {
      if (error instanceof ApiError) {
        if (error.code.startsWith("LEGAL_EMBEDDING_") || error.code === "AI_CONFIGURATION_MISSING") {
          throw new ApiError(503, "RAG_EMBEDDING_UNAVAILABLE", "Legal query embedding is temporarily unavailable.");
        }
        if (error.code.startsWith("LEGAL_HYBRID_RETRIEVAL_")) {
          throw new ApiError(503, "RAG_RETRIEVAL_UNAVAILABLE", "Legal evidence retrieval is temporarily unavailable.");
        }
      }
      throw new ApiError(503, "RAG_RETRIEVAL_UNAVAILABLE", "Legal evidence retrieval is temporarily unavailable.");
    }
    if (context.retrievalStatus === "insufficient_evidence" || context.sources.length === 0) {
      return {
        contextStatus: "insufficient_evidence" as const,
        finding: insufficientEvidence,
        citationIds: [],
        citations: []
      };
    }

    const citations = context.sources.map(citationFromSource);
    const citationMap = createOpaqueCitationMap(citations);
    const prompt = buildGroundedClausePrompt({
      clauseTitle: parsed.data.clauseTitle,
      clauseText: parsed.data.clauseText,
      context
    });
    let finding: GroundedFinding;
    try {
      finding = groundedFindingSchema.parse(
        await dependencies.analyzeGroundedFinding(prompt)
      );
    } catch (error) {
      if (
        error instanceof ApiError &&
        ["RAG_GROUNDED_AI_UNAVAILABLE", "AI_CONFIGURATION_MISSING"].includes(error.code)
      ) {
        throw error;
      }
      throw new ApiError(502, "RAG_AI_OUTPUT_INVALID", "Grounded analysis returned an invalid result.");
    }

    let resolvedCitations: LegalCitation[];
    try {
      resolvedCitations = resolveCitationIds(finding.citationIds, citationMap);
    } catch {
      throw new ApiError(502, "RAG_AI_OUTPUT_INVALID", "Grounded analysis returned an invalid result.");
    }
    return {
      contextStatus: finding.evidenceStatus,
      finding,
      citationIds: finding.citationIds,
      citations: resolvedCitations
    };
  };
}
