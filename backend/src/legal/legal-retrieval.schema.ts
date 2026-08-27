import { z } from "zod";

export const legalRetrievalContractTypeSchema = z.enum([
  "employment",
  "service",
  "lease"
]);

export const legalRetrievalInputSchema = z
  .object({
    query: z
      .string()
      .min(1)
      .max(2_000)
      .refine((value) => value.trim().length > 0),
    contractType: legalRetrievalContractTypeSchema,
    matchCount: z.number().int().min(1).max(20).default(8),
    minSimilarity: z.number().finite().min(0).max(1).default(0.5)
  })
  .strict();

export type LegalRetrievalInput = z.infer<typeof legalRetrievalInputSchema>;

const nullableShortText = (maximum: number) =>
  z.string().min(1).max(maximum).nullable();

export const legalRetrievalRpcRowSchema = z
  .object({
    chunk_id: z.string().uuid(),
    legal_source_id: z.string().uuid(),
    law_number: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
    source_title: z.string().min(1),
    version_label: z.string().min(1),
    official_url: z.string().url().startsWith("https://"),
    official_document_url: z
      .string()
      .url()
      .startsWith("https://")
      .nullable(),
    document_type: z.enum(["law", "amendment"]),
    applicability_mode: z.enum(["direct", "amendment_scope"]),
    chunk_index: z.number().int().nonnegative(),
    article_number: nullableShortText(64),
    article_title: nullableShortText(300),
    paragraph_number: nullableShortText(64),
    point_label: nullableShortText(64),
    content: z.string().min(1).refine((value) => value.trim().length > 0),
    content_hash: z.string().regex(/^[0-9a-f]{64}$/u),
    similarity: z.number().finite().min(0).max(1)
  })
  .strict();

export type LegalRetrievalResult = {
  readonly chunkId: string;
  readonly legalSourceId: string;
  readonly lawNumber: "03/L-212" | "04/L-077" | "08/L-142";
  readonly sourceTitle: string;
  readonly versionLabel: string;
  readonly officialUrl: string;
  readonly officialDocumentUrl: string | null;
  readonly documentType: "law" | "amendment";
  readonly applicabilityMode: "direct" | "amendment_scope";
  readonly chunkIndex: number;
  readonly articleNumber: string | null;
  readonly articleTitle: string | null;
  readonly paragraphNumber: string | null;
  readonly pointLabel: string | null;
  readonly content: string;
  readonly contentHash: string;
  readonly similarity: number;
};
