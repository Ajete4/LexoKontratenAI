import { z } from "zod";

export const legalHybridRetrievalContractTypeSchema = z.enum([
  "employment",
  "service",
  "lease"
]);

export const legalHybridRetrievalInputSchema = z.object({
  query: z.string().min(1).max(2_000).refine((value) => value.trim().length > 0),
  contractType: legalHybridRetrievalContractTypeSchema,
  matchCount: z.number().int().min(1).max(20).default(8),
  candidateCount: z.number().int().min(8).max(100).default(50),
  minSemanticSimilarity: z.number().finite().min(0).max(1).default(0.45),
  rrfK: z.number().int().min(1).max(1_000).default(60)
}).strict().superRefine((value, context) => {
  if (value.candidateCount < value.matchCount) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ["candidateCount"],
      message: "Candidate count must cover the requested matches."
    });
  }
});

export type LegalHybridRetrievalInput = z.infer<typeof legalHybridRetrievalInputSchema>;

const nullableShortText = (maximum: number) =>
  z.string().min(1).max(maximum).nullable();

export const legalHybridRetrievalRpcRowSchema = z.object({
  chunk_id: z.string().uuid(),
  legal_source_id: z.string().uuid(),
  law_number: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  source_title: z.string().min(1),
  version_label: z.string().min(1),
  official_url: z.string().url().startsWith("https://"),
  official_document_url: z.string().url().startsWith("https://").nullable(),
  document_type: z.enum(["law", "amendment"]),
  applicability_mode: z.enum(["direct", "amendment_scope"]),
  chunk_index: z.number().int().nonnegative(),
  article_number: nullableShortText(64),
  article_title: nullableShortText(300),
  paragraph_number: nullableShortText(64),
  point_label: nullableShortText(64),
  content: z.string().min(1).refine((value) => value.trim().length > 0),
  content_hash: z.string().regex(/^[0-9a-f]{64}$/u),
  semantic_score: z.number().finite().min(0).max(1).nullable(),
  lexical_score: z.number().finite().nonnegative().nullable(),
  fused_score: z.number().finite().positive(),
  semantic_rank: z.number().int().positive().nullable(),
  lexical_rank: z.number().int().positive().nullable(),
  result_rank: z.number().int().positive()
}).strict().superRefine((row, context) => {
  if ((row.semantic_score === null) !== (row.semantic_rank === null)) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ["semantic_rank"],
      message: "Semantic score and rank must have the same null state."
    });
  }
  if ((row.lexical_score === null) !== (row.lexical_rank === null)) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ["lexical_rank"],
      message: "Lexical score and rank must have the same null state."
    });
  }
  if (row.semantic_rank === null && row.lexical_rank === null) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ["fused_score"],
      message: "At least one retrieval channel must rank the result."
    });
  }
});

export type LegalHybridRetrievalRpcRow = z.infer<
  typeof legalHybridRetrievalRpcRowSchema
>;

export type LegalHybridRetrievalResult = {
  readonly chunkId: string;
  readonly legalSourceId: string;
  readonly lawNumber: LegalHybridRetrievalRpcRow["law_number"];
  readonly sourceTitle: string;
  readonly versionLabel: string;
  readonly officialUrl: string;
  readonly officialDocumentUrl: string | null;
  readonly documentType: LegalHybridRetrievalRpcRow["document_type"];
  readonly applicabilityMode: LegalHybridRetrievalRpcRow["applicability_mode"];
  readonly chunkIndex: number;
  readonly articleNumber: string | null;
  readonly articleTitle: string | null;
  readonly paragraphNumber: string | null;
  readonly pointLabel: string | null;
  readonly content: string;
  readonly contentHash: string;
  readonly semanticScore: number | null;
  readonly lexicalScore: number | null;
  readonly fusedScore: number;
  readonly semanticRank: number | null;
  readonly lexicalRank: number | null;
  readonly resultRank: number;
};
