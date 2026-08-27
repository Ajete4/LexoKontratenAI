import { createHash } from "node:crypto";

import type { LegalChunk } from "./legal-chunker.js";
import type { ParsedLegalDocument } from "./legal-document-parser.js";

export type ChunkReviewOutcome =
  | "approved_for_seed"
  | "approved_for_seed_with_warnings"
  | "blocked";

export type LegalChunkReviewReport = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly articleCount: number;
  readonly chunkCount: number;
  readonly sampledArticles: readonly string[];
  readonly sampledChunkCount: number;
  readonly integrityChecks: {
    readonly sourceHashMatches: boolean;
    readonly reviewOutcomeAllowed: boolean;
    readonly chunkingOutcomeAllowed: boolean;
    readonly chunkCountMatchesArticleCount: boolean;
    readonly completeArticleCoverage: boolean;
    readonly noUnknownArticles: boolean;
    readonly contiguousUniqueIndexes: boolean;
    readonly validContentHashes: boolean;
    readonly noDuplicateContentHashes: boolean;
    readonly noEmptyChunks: boolean;
    readonly noChunkAboveHardLimit: boolean;
    readonly singleSourceIdentityPerChunk: boolean;
  };
  readonly textComparisonChecks: {
    readonly sampledBodiesMatchParsedText: boolean;
    readonly sampledTitlesMatch: boolean;
    readonly sampledHeadersAreSelfContained: boolean;
    readonly sampledParagraphOrderMatches: boolean;
  };
  readonly contaminationChecks: {
    readonly noIsolatedPageNumbers: boolean;
    readonly noOfficialGazetteHeaders: boolean;
    readonly noPreamble: boolean;
    readonly noStructuralHeadingParagraphs: boolean;
    readonly noReplacementCharacters: boolean;
    readonly noHtml: boolean;
    readonly noUuidOrDynamicTimestamp: boolean;
    readonly noStorageOrCredentialMaterial: boolean;
  };
  readonly provenanceChecks: {
    readonly validPageRanges: boolean;
    readonly sampledPagesCoverParsedProvenance: boolean;
    readonly structuralContextMatchesParsed: boolean;
    readonly sourceSha256Propagated: boolean;
  };
  readonly warnings: readonly string[];
  readonly blockingIssues: readonly string[];
  readonly outcome: ChunkReviewOutcome;
};

type ReviewInputs = {
  readonly expectedSourceSha256: string;
  readonly reviewOutcome:
    | "approved_for_chunking"
    | "approved_with_warnings"
    | "blocked";
  readonly chunkingOutcome:
    | "ready_for_chunk_review"
    | "ready_with_warnings"
    | "blocked";
  readonly sourceWarnings: readonly string[];
  readonly sampledArticleNumbers: readonly number[];
};

const ISOLATED_PAGE_NUMBER = /^\d+$/mu;
const OFFICIAL_GAZETTE_HEADER = /GAZETA ZYRTARE E REPUBLIKËS SË KOSOVËS/iu;
const PREAMBLE_MARKER = /^(?:Kuvendi i Republikës së Kosovës[;:]?|Miraton[:]?)$/mu;
const STRUCTURAL_HEADING = /^(?:LIBRI|PJESA|KREU|NËNKREU)(?:\s|$)/mu;
const HTML_TAG = /<\/?[A-Za-z][^>]*>/u;
const UUID = /[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/iu;
const DYNAMIC_TIMESTAMP = /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/u;
const SENSITIVE_MATERIAL = /(?:storage\/v1|service_role|OPENAI_API_KEY|SUPABASE_[A-Z_]+|Bearer\s+[A-Za-z0-9._-]+)/u;

function paragraphBody(article: ParsedLegalDocument["articles"][number]): string {
  return article.paragraphs
    .map((paragraph) =>
      paragraph.paragraphNumber === null
        ? paragraph.text
        : `${paragraph.paragraphNumber}. ${paragraph.text}`
    )
    .join("\n");
}

function chunkBody(chunk: LegalChunk): string {
  return chunk.content.split("\n\n").slice(1).join("\n\n");
}

function allTrue(value: Record<string, boolean>): boolean {
  return Object.values(value).every(Boolean);
}

export function reviewLegalChunks(
  parsed: ParsedLegalDocument,
  chunks: readonly LegalChunk[],
  inputs: ReviewInputs
): LegalChunkReviewReport {
  const sampledArticles = inputs.sampledArticleNumbers.map(
    (articleNumber) => parsed.articles[articleNumber - 1]
  );

  if (sampledArticles.some((article) => article === undefined)) {
    throw new Error("LEGAL_CHUNK_REVIEW_SAMPLE_INVALID");
  }

  const articleNumbers = new Set(parsed.articles.map((article) => article.articleNumber));
  const chunkArticleNumbers = new Set(chunks.map((chunk) => chunk.articleNumber));
  const hashes = chunks.map((chunk) => chunk.contentSha256);
  const sampledChunks = chunks.filter((chunk) =>
    inputs.sampledArticleNumbers.map(String).includes(chunk.articleNumber)
  );
  const sourceContent = chunks.map((chunk) => chunk.content).join("\n");
  const textComparisonChecks = {
    sampledBodiesMatchParsedText: sampledArticles.every((article) => {
      if (article === undefined) return false;
      const bodies = sampledChunks
        .filter((chunk) => chunk.articleNumber === article.articleNumber)
        .map(chunkBody);
      return bodies.join("\n") === paragraphBody(article);
    }),
    sampledTitlesMatch: sampledChunks.every((chunk) => {
      const article = parsed.articles.find(
        (candidate) => candidate.articleNumber === chunk.articleNumber
      );
      return article?.articleTitle === chunk.articleTitle;
    }),
    sampledHeadersAreSelfContained: sampledChunks.every((chunk) => {
      const expectedHeading = `Neni ${chunk.articleNumber}${
        chunk.articleTitle === null ? "" : ` - ${chunk.articleTitle}`
      }`;
      return chunk.content.startsWith(
        `Ligji ${chunk.lawNumber}\n${expectedHeading}`
      );
    }),
    sampledParagraphOrderMatches: sampledArticles.every((article) => {
      if (article === undefined) return false;
      const body = sampledChunks
        .filter((chunk) => chunk.articleNumber === article.articleNumber)
        .map(chunkBody)
        .join("\n");
      let previousIndex = -1;

      return article.paragraphs.every((paragraph) => {
        const index = body.indexOf(paragraph.text, previousIndex + 1);
        if (index < 0) return false;
        previousIndex = index;
        return true;
      });
    })
  };
  const contaminationChecks = {
    noIsolatedPageNumbers: !ISOLATED_PAGE_NUMBER.test(sourceContent),
    noOfficialGazetteHeaders: !OFFICIAL_GAZETTE_HEADER.test(sourceContent),
    noPreamble: !PREAMBLE_MARKER.test(sourceContent),
    noStructuralHeadingParagraphs: !STRUCTURAL_HEADING.test(sourceContent),
    noReplacementCharacters: !sourceContent.includes("\uFFFD"),
    noHtml: !HTML_TAG.test(sourceContent),
    noUuidOrDynamicTimestamp:
      !UUID.test(sourceContent) && !DYNAMIC_TIMESTAMP.test(sourceContent),
    noStorageOrCredentialMaterial: !SENSITIVE_MATERIAL.test(sourceContent)
  };
  const integrityChecks = {
    sourceHashMatches:
      parsed.sourceSha256 === inputs.expectedSourceSha256 &&
      chunks.every(
        (chunk) => chunk.sourceSha256 === inputs.expectedSourceSha256
      ),
    reviewOutcomeAllowed:
      inputs.reviewOutcome === "approved_for_chunking" ||
      inputs.reviewOutcome === "approved_with_warnings",
    chunkingOutcomeAllowed:
      inputs.chunkingOutcome === "ready_for_chunk_review" ||
      inputs.chunkingOutcome === "ready_with_warnings",
    chunkCountMatchesArticleCount: chunks.length === parsed.articles.length,
    completeArticleCoverage: [...articleNumbers].every((articleNumber) =>
      chunkArticleNumbers.has(articleNumber)
    ),
    noUnknownArticles: [...chunkArticleNumbers].every((articleNumber) =>
      articleNumbers.has(articleNumber)
    ),
    contiguousUniqueIndexes: chunks.every(
      (chunk, index) => chunk.chunkIndex === index
    ),
    validContentHashes: chunks.every(
      (chunk) =>
        createHash("sha256").update(chunk.content, "utf8").digest("hex") ===
        chunk.contentSha256
    ),
    noDuplicateContentHashes: new Set(hashes).size === hashes.length,
    noEmptyChunks: chunks.every((chunk) => chunk.content.trim().length > 0),
    noChunkAboveHardLimit: chunks.every(
      (chunk) => chunk.content.length <= 6_000
    ),
    singleSourceIdentityPerChunk: chunks.every(
      (chunk) =>
        chunk.lawNumber === parsed.lawNumber &&
        articleNumbers.has(chunk.articleNumber)
    )
  };
  const provenanceChecks = {
    validPageRanges: chunks.every(
      (chunk) =>
        Number.isInteger(chunk.pageStart) &&
        Number.isInteger(chunk.pageEnd) &&
        chunk.pageStart >= 1 &&
        chunk.pageEnd >= chunk.pageStart &&
        chunk.pageEnd <= parsed.pageCount
    ),
    sampledPagesCoverParsedProvenance: sampledChunks.every((chunk) => {
      const article = parsed.articles.find(
        (candidate) => candidate.articleNumber === chunk.articleNumber
      );
      return (
        article !== undefined &&
        chunk.pageStart >= article.startPage &&
        chunk.pageEnd <= article.endPage
      );
    }),
    structuralContextMatchesParsed: chunks.every((chunk) => {
      const article = parsed.articles.find(
        (candidate) => candidate.articleNumber === chunk.articleNumber
      );
      return article?.chapterTitle === chunk.structuralContext.chapterTitle;
    }),
    sourceSha256Propagated: chunks.every(
      (chunk) => chunk.sourceSha256 === parsed.sourceSha256
    )
  };
  const blockingIssues: string[] = [];

  if (!allTrue(integrityChecks)) blockingIssues.push("integrity_gate_failed");
  if (!allTrue(textComparisonChecks)) blockingIssues.push("text_comparison_failed");
  if (!allTrue(contaminationChecks)) blockingIssues.push("contamination_detected");
  if (!allTrue(provenanceChecks)) blockingIssues.push("provenance_failed");

  return {
    lawNumber: parsed.lawNumber,
    versionLabel: parsed.versionLabel,
    articleCount: parsed.articles.length,
    chunkCount: chunks.length,
    sampledArticles: inputs.sampledArticleNumbers.map(String),
    sampledChunkCount: sampledChunks.length,
    integrityChecks,
    textComparisonChecks,
    contaminationChecks,
    provenanceChecks,
    warnings: inputs.sourceWarnings,
    blockingIssues,
    outcome:
      blockingIssues.length > 0
        ? "blocked"
        : inputs.sourceWarnings.length > 0
          ? "approved_for_seed_with_warnings"
          : "approved_for_seed"
  };
}
