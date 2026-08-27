import { z } from "zod";

const sha256Schema = z.string().regex(/^[0-9a-f]{64}$/u);
const citationIdSchema = z.string().regex(/^C[1-5]$/u);
const clauseKeySchema = z.string().regex(/^clause-(?:[1-9]|[12][0-9]|30)$/u);
const nullableScoreSchema = z.number().finite().nonnegative().nullable();

export const persistedCitationSchema = z.object({
  citation_id: citationIdSchema,
  legal_chunk_id: z.string().uuid(),
  citation_rank: z.number().int().min(1).max(5),
  retrieval_method: z.literal("hybrid_rrf_v1"),
  semantic_score: z.number().finite().min(0).max(1).nullable(),
  lexical_score: nullableScoreSchema,
  fused_score: z.number().finite().positive(),
  content_hash: sha256Schema
}).strict();

export const clauseEvidencePersistenceSchema = z.object({
  clause_key: clauseKeySchema,
  evidence_status: z.enum(["grounded", "insufficient_evidence"]),
  citations: z.array(persistedCitationSchema).max(5)
}).strict().superRefine((value, context) => {
  const citationIds = value.citations.map((citation) => citation.citation_id);
  const ranks = value.citations.map((citation) => citation.citation_rank);
  const chunkIds = value.citations.map((citation) => citation.legal_chunk_id);

  if (new Set(citationIds).size !== citationIds.length) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Duplicate citation ID." });
  }
  if (new Set(ranks).size !== ranks.length) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Duplicate citation rank." });
  }
  if (new Set(chunkIds).size !== chunkIds.length) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Duplicate legal chunk." });
  }
  if (value.citations.some((citation, index) => citation.citation_rank !== index + 1)) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Citation ranks must be contiguous." });
  }
  if (value.evidence_status === "grounded" && value.citations.length === 0) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Grounded evidence requires citations." });
  }
  if (value.evidence_status === "insufficient_evidence" && value.citations.length !== 0) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citations"], message: "Insufficient evidence must not cite chunks." });
  }
});

export const ragCitationPersistencePayloadSchema = z.object({
  clause_evidence: z.array(clauseEvidencePersistenceSchema).max(30)
}).strict().superRefine((value, context) => {
  const clauseKeys = value.clause_evidence.map((entry) => entry.clause_key);
  if (new Set(clauseKeys).size !== clauseKeys.length) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["clause_evidence"], message: "Duplicate clause key." });
  }
});

export type RagCitationPersistencePayload = z.infer<typeof ragCitationPersistencePayloadSchema>;

export function validateRagCitationProvenance(
  input: unknown,
  expectedHashesByChunkId: ReadonlyMap<string, string>
): RagCitationPersistencePayload {
  const payload = ragCitationPersistencePayloadSchema.parse(input);

  for (const clause of payload.clause_evidence) {
    for (const citation of clause.citations) {
      if (expectedHashesByChunkId.get(citation.legal_chunk_id) !== citation.content_hash) {
        throw new Error("RAG_CITATION_PROVENANCE_INVALID");
      }
    }
  }

  return payload;
}
