import { z } from "zod";

const nullableText = z.string().min(1).nullable();

export const legalCitationSchema = z.object({
  chunkId: z.string().uuid(),
  legalSourceId: z.string().uuid(),
  lawNumber: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  sourceTitle: z.string().min(1),
  versionLabel: z.string().min(1),
  articleNumber: nullableText,
  articleTitle: nullableText,
  paragraphNumber: nullableText,
  pointLabel: nullableText,
  officialUrl: z.string().url().startsWith("https://"),
  officialDocumentUrl: z.string().url().startsWith("https://").nullable(),
  contentHash: z.string().regex(/^[0-9a-f]{64}$/u),
  semanticScore: z.number().finite().min(0).max(1).nullable(),
  lexicalScore: z.number().finite().nonnegative().nullable(),
  fusedScore: z.number().finite().positive(),
  resultRank: z.number().int().positive()
}).strict();

export type LegalCitation = z.infer<typeof legalCitationSchema>;

export function createOpaqueCitationMap(sources: readonly LegalCitation[]) {
  const citations = z.array(legalCitationSchema).max(5).parse(sources);
  return new Map(citations.map((citation, index) => [`C${index + 1}`, citation]));
}

export function resolveCitationIds(
  citationIds: readonly string[],
  citationMap: ReadonlyMap<string, LegalCitation>
) {
  const uniqueIds = [...new Set(citationIds)];
  return uniqueIds.map((id) => {
    const citation = citationMap.get(id);
    if (citation === undefined) throw new Error("RAG_CITATION_ID_UNKNOWN");
    return citation;
  });
}
