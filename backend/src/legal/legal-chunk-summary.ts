import type { LegalChunk } from "./legal-chunker.js";
import type { ParsedLegalDocument } from "./legal-document-parser.js";

export type LegalChunkingSummary = {
  readonly lawNumber: string;
  readonly articleCount: number;
  readonly chunkCount: number;
  readonly splitArticleCount: number;
  readonly unsplitArticleCount: number;
  readonly oversizedChunkCount: number;
  readonly minimumCharacters: number;
  readonly maximumCharacters: number;
  readonly averageCharacters: number;
  readonly missingProvenanceCount: number;
  readonly duplicateContentHashCount: number;
  readonly sourceWarnings: readonly string[];
  readonly outcome:
    | "ready_for_chunk_review"
    | "ready_with_warnings"
    | "blocked";
};

export function createLegalChunkingSummary(
  parsed: ParsedLegalDocument,
  chunks: readonly LegalChunk[],
  sourceWarnings: readonly string[]
): LegalChunkingSummary {
  const splitArticleNumbers = new Set(
    chunks
      .filter((chunk) => chunk.metadata.splitArticle)
      .map((chunk) => chunk.articleNumber)
  );
  const lengths = chunks.map((chunk) => chunk.content.length);
  const hashCounts = new Map<string, number>();

  for (const chunk of chunks) {
    hashCounts.set(
      chunk.contentSha256,
      (hashCounts.get(chunk.contentSha256) ?? 0) + 1
    );
  }

  const missingProvenanceCount = chunks.filter(
    (chunk) =>
      !Number.isInteger(chunk.pageStart) ||
      !Number.isInteger(chunk.pageEnd) ||
      chunk.pageStart < 1 ||
      chunk.pageEnd < chunk.pageStart
  ).length;
  const oversizedChunkCount = chunks.filter(
    (chunk) => chunk.warnings.length > 0
  ).length;
  const duplicateContentHashCount = [...hashCounts.values()].filter(
    (count) => count > 1
  ).length;
  const blocked =
    missingProvenanceCount > 0 || duplicateContentHashCount > 0;

  return {
    lawNumber: parsed.lawNumber,
    articleCount: parsed.articles.length,
    chunkCount: chunks.length,
    splitArticleCount: splitArticleNumbers.size,
    unsplitArticleCount: parsed.articles.length - splitArticleNumbers.size,
    oversizedChunkCount,
    minimumCharacters: lengths.length === 0 ? 0 : Math.min(...lengths),
    maximumCharacters: lengths.length === 0 ? 0 : Math.max(...lengths),
    averageCharacters:
      lengths.length === 0
        ? 0
        : Number(
            (
              lengths.reduce((total, length) => total + length, 0) /
              lengths.length
            ).toFixed(2)
          ),
    missingProvenanceCount,
    duplicateContentHashCount,
    sourceWarnings,
    outcome: blocked
      ? "blocked"
      : sourceWarnings.length > 0 || oversizedChunkCount > 0
        ? "ready_with_warnings"
        : "ready_for_chunk_review"
  };
}
