import { createHash } from "node:crypto";

import type {
  ParsedLegalArticle,
  ParsedLegalDocument,
  ParsedLegalParagraph
} from "./legal-document-parser.js";
import type {
  LegalApplicabilityMode,
  LegalContractType,
  LegalDocumentType
} from "./legal-source-manifest.js";

export const LEGAL_CHUNK_TARGET_CHARACTERS = 4_000;
export const LEGAL_CHUNK_HARD_WARNING_CHARACTERS = 6_000;

export type DatabaseApplicabilityMode = "direct" | "amendment_scope";

export type LegalChunk = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly language: "sq";
  readonly jurisdiction: "XK";
  readonly documentType: LegalDocumentType;
  readonly applicability: readonly LegalContractType[];
  readonly applicabilityMode: DatabaseApplicabilityMode;
  readonly articleNumber: string;
  readonly articleTitle: string | null;
  readonly paragraphStart: string | null;
  readonly paragraphEnd: string | null;
  readonly pageStart: number;
  readonly pageEnd: number;
  readonly structuralContext: {
    readonly chapterTitle: string | null;
  };
  readonly chunkIndex: number;
  readonly content: string;
  readonly contentSha256: string;
  readonly sourceSha256: string;
  readonly tokenCount: null;
  readonly warnings: readonly (
    | "oversized_single_paragraph"
    | "hard_character_limit_exceeded"
    | "paragraph_provenance_incomplete"
  )[];
  readonly metadata: {
    readonly paragraphCount: number;
    readonly splitArticle: boolean;
    readonly normalization:
      "unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines";
    readonly paragraphNumberPresentation: "canonical_from_parsed_provenance";
    readonly reviewOutcome:
      | "approved_for_chunking"
      | "approved_with_warnings";
    readonly amendmentCandidates: readonly {
      readonly baseLawNumber: string;
      readonly baseArticleNumber: string;
      readonly relationTypeCandidate: "amend" | "supplement" | "repeal";
      readonly reviewStatus: "candidate_for_manual_review";
    }[];
  };
};

type AmendmentCandidate = LegalChunk["metadata"]["amendmentCandidates"][number] & {
  readonly amendingArticleNumber: string;
};

type ChunkingOptions = {
  readonly documentType: LegalDocumentType;
  readonly applicability: readonly LegalContractType[];
  readonly applicabilityMode: LegalApplicabilityMode;
  readonly reviewOutcome:
    | "approved_for_chunking"
    | "approved_with_warnings";
  readonly amendmentCandidates: readonly AmendmentCandidate[];
};

function normalizeChunkText(text: string): string {
  return text
    .normalize("NFC")
    .replace(/\r\n?/gu, "\n")
    .replace(/[\t ]+$/gmu, "")
    .replace(/\n{3,}/gu, "\n\n")
    .trim();
}

function paragraphText(paragraph: ParsedLegalParagraph): string {
  if (paragraph.paragraphNumber === null) {
    return paragraph.text;
  }

  return `${paragraph.paragraphNumber}. ${paragraph.text}`;
}

function paragraphRange(paragraphs: readonly ParsedLegalParagraph[]): {
  paragraphStart: string | null;
  paragraphEnd: string | null;
} {
  if (
    paragraphs.length === 0 ||
    paragraphs.some((paragraph) => paragraph.paragraphNumber === null)
  ) {
    return { paragraphStart: null, paragraphEnd: null };
  }

  return {
    paragraphStart: paragraphs[0]?.paragraphNumber ?? null,
    paragraphEnd: paragraphs.at(-1)?.paragraphNumber ?? null
  };
}

function createContent(
  lawNumber: string,
  article: ParsedLegalArticle,
  paragraphs: readonly ParsedLegalParagraph[],
  includeRange: boolean
): string {
  const range = paragraphRange(paragraphs);
  const heading = [
    `Ligji ${lawNumber}`,
    `Neni ${article.articleNumber}${
      article.articleTitle === null ? "" : ` - ${article.articleTitle}`
    }`
  ];

  if (
    includeRange &&
    range.paragraphStart !== null &&
    range.paragraphEnd !== null
  ) {
    heading.push(
      range.paragraphStart === range.paragraphEnd
        ? `Paragrafi ${range.paragraphStart}`
        : `Paragrafët ${range.paragraphStart}-${range.paragraphEnd}`
    );
  }

  return normalizeChunkText(
    `${heading.join("\n")}\n\n${paragraphs.map(paragraphText).join("\n")}`
  );
}

function splitArticle(
  lawNumber: string,
  article: ParsedLegalArticle
): ParsedLegalParagraph[][] {
  if (article.paragraphs.length === 0) {
    return [[]];
  }

  const groups: ParsedLegalParagraph[][] = [];
  let current: ParsedLegalParagraph[] = [];

  for (const paragraph of article.paragraphs) {
    const candidate = [...current, paragraph];
    const candidateContent = createContent(
      lawNumber,
      article,
      candidate,
      true
    );

    if (
      current.length > 0 &&
      candidateContent.length > LEGAL_CHUNK_TARGET_CHARACTERS
    ) {
      groups.push(current);
      current = [paragraph];
    } else {
      current = candidate;
    }
  }

  if (current.length > 0) {
    groups.push(current);
  }

  return groups;
}

function mapApplicabilityMode(
  applicabilityMode: LegalApplicabilityMode
): DatabaseApplicabilityMode {
  return applicabilityMode === "amendment" ? "amendment_scope" : "direct";
}

export function createLegalChunks(
  parsed: ParsedLegalDocument,
  options: ChunkingOptions
): LegalChunk[] {
  const chunks: LegalChunk[] = [];

  for (const article of parsed.articles) {
    const groups = splitArticle(parsed.lawNumber, article);
    const split = groups.length > 1;

    for (const paragraphs of groups) {
      const content = createContent(
        parsed.lawNumber,
        article,
        paragraphs,
        split
      );
      const range = paragraphRange(paragraphs);
      const warnings: LegalChunk["warnings"][number][] = [];

      if (
        paragraphs.length === 1 &&
        content.length > LEGAL_CHUNK_TARGET_CHARACTERS
      ) {
        warnings.push("oversized_single_paragraph");
      }

      if (content.length > LEGAL_CHUNK_HARD_WARNING_CHARACTERS) {
        warnings.push("hard_character_limit_exceeded");
      }

      if (
        paragraphs.some(
          (paragraph) =>
            !Number.isInteger(paragraph.startPage) ||
            !Number.isInteger(paragraph.endPage)
        )
      ) {
        warnings.push("paragraph_provenance_incomplete");
      }

      const pageStart =
        paragraphs[0]?.startPage ?? article.startPage;
      const pageEnd = paragraphs.at(-1)?.endPage ?? article.endPage;

      chunks.push({
        lawNumber: parsed.lawNumber,
        versionLabel: parsed.versionLabel,
        language: "sq",
        jurisdiction: "XK",
        documentType: options.documentType,
        applicability: options.applicability,
        applicabilityMode: mapApplicabilityMode(options.applicabilityMode),
        articleNumber: article.articleNumber,
        articleTitle: article.articleTitle,
        paragraphStart: range.paragraphStart,
        paragraphEnd: range.paragraphEnd,
        pageStart,
        pageEnd,
        structuralContext: {
          chapterTitle: article.chapterTitle
        },
        chunkIndex: chunks.length,
        content,
        contentSha256: createHash("sha256")
          .update(content, "utf8")
          .digest("hex"),
        sourceSha256: parsed.sourceSha256,
        tokenCount: null,
        warnings,
        metadata: {
          paragraphCount: paragraphs.length,
          splitArticle: split,
          normalization:
            "unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines",
          paragraphNumberPresentation: "canonical_from_parsed_provenance",
          reviewOutcome: options.reviewOutcome,
          amendmentCandidates: options.amendmentCandidates
            .filter(
              (candidate) =>
                candidate.amendingArticleNumber === article.articleNumber
            )
            .map((candidate) => ({
              baseLawNumber: candidate.baseLawNumber,
              baseArticleNumber: candidate.baseArticleNumber,
              relationTypeCandidate: candidate.relationTypeCandidate,
              reviewStatus: candidate.reviewStatus
            }))
        }
      });
    }
  }

  const hashes = new Set<string>();

  for (const chunk of chunks) {
    if (hashes.has(chunk.contentSha256)) {
      throw new Error("LEGAL_CHUNK_DUPLICATE_CONTENT");
    }

    hashes.add(chunk.contentSha256);
  }

  return chunks;
}
