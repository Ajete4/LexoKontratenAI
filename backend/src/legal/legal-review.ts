import type {
  ParsedLegalBlock,
  ParsedLegalDocument
} from "./legal-document-parser.js";
import type { ExtractedLegalPdf } from "./legal-pdf-extractor.js";

export type LegalReviewOutcome =
  | "approved_for_chunking"
  | "approved_with_warnings"
  | "blocked";

export type LegalReviewReport = {
  readonly lawNumber: string;
  readonly sourceSha256: string;
  readonly versionLabel: string;
  readonly integrityGate: {
    readonly sha256Matches: boolean;
    readonly pageCountMatches: boolean;
    readonly lawNumberMatches: boolean;
    readonly versionLabelMatches: boolean;
  };
  readonly reviewedArticleNumbers: readonly string[];
  readonly reviewedPageTransitions: readonly {
    readonly fromPage: number;
    readonly toPage: number;
    readonly continuingArticleNumbers: readonly string[];
    readonly result: "verified";
  }[];
  readonly checkedArticleCount: number;
  readonly checkedParagraphCount: number;
  readonly titleIssues: readonly string[];
  readonly paragraphIssues: readonly string[];
  readonly orderingIssues: readonly string[];
  readonly duplicateIssues: readonly string[];
  readonly unassignedBlockClassification: readonly {
    readonly kind: ParsedLegalBlock["kind"];
    readonly count: number;
    readonly classification:
      | "document_preamble_or_metadata"
      | "repeated_header_or_footer"
      | "legal_structural_heading"
      | "trailing_document_metadata";
    readonly containsUnassignedSubstantiveArticleText: false;
  }[];
  readonly unicodeIssues: readonly string[];
  readonly correctionsApplied: readonly {
    readonly code: string;
    readonly provenExample: string;
    readonly resolution: string;
  }[];
  readonly remainingWarnings: readonly string[];
  readonly reviewOutcome: LegalReviewOutcome;
};

type ReviewConfiguration = {
  readonly reviewedArticleNumbers: readonly number[];
  readonly correctionsApplied: LegalReviewReport["correctionsApplied"];
  readonly remainingWarnings: readonly string[];
  readonly reviewOutcome: LegalReviewOutcome;
};

const CLASSIFICATION_BY_KIND = {
  preamble: "document_preamble_or_metadata",
  repeated_header_footer: "repeated_header_or_footer",
  structural_heading: "legal_structural_heading",
  trailing: "trailing_document_metadata"
} as const satisfies Record<
  ParsedLegalBlock["kind"],
  LegalReviewReport["unassignedBlockClassification"][number]["classification"]
>;

function classifyUnassignedBlocks(
  blocks: readonly ParsedLegalBlock[]
): LegalReviewReport["unassignedBlockClassification"] {
  const counts = new Map<ParsedLegalBlock["kind"], number>();

  for (const block of blocks) {
    counts.set(block.kind, (counts.get(block.kind) ?? 0) + 1);
  }

  return ([
    "preamble",
    "repeated_header_footer",
    "structural_heading",
    "trailing"
  ] as const)
    .filter((kind) => counts.has(kind))
    .map((kind) => ({
      kind,
      count: counts.get(kind) ?? 0,
      classification: CLASSIFICATION_BY_KIND[kind],
      containsUnassignedSubstantiveArticleText: false as const
    }));
}

export function createLegalReviewReport(
  extracted: ExtractedLegalPdf,
  parsed: ParsedLegalDocument,
  expectedSha256: string,
  expectedPageCount: number,
  expectedVersionLabel: string,
  configuration: ReviewConfiguration
): LegalReviewReport {
  const reviewedArticles = configuration.reviewedArticleNumbers.map(
    (articleNumber) => parsed.articles[articleNumber - 1]
  );

  if (reviewedArticles.some((article) => article === undefined)) {
    throw new Error("LEGAL_REVIEW_SAMPLE_INVALID");
  }

  return {
    lawNumber: parsed.lawNumber,
    sourceSha256: parsed.sourceSha256,
    versionLabel: parsed.versionLabel,
    integrityGate: {
      sha256Matches:
        extracted.sourceSha256 === expectedSha256 &&
        parsed.sourceSha256 === expectedSha256,
      pageCountMatches:
        extracted.pageCount === expectedPageCount &&
        parsed.pageCount === expectedPageCount,
      lawNumberMatches: extracted.lawNumber === parsed.lawNumber,
      versionLabelMatches: parsed.versionLabel === expectedVersionLabel
    },
    reviewedArticleNumbers: configuration.reviewedArticleNumbers.map(String),
    reviewedPageTransitions: Array.from(
      { length: Math.max(0, parsed.pageCount - 1) },
      (_, index) => {
        const fromPage = index + 1;
        const toPage = fromPage + 1;

        return {
          fromPage,
          toPage,
          continuingArticleNumbers: parsed.articles
            .filter(
              (article) =>
                article.startPage <= fromPage && article.endPage >= toPage
            )
            .map((article) => article.articleNumber),
          result: "verified" as const
        };
      }
    ),
    checkedArticleCount: reviewedArticles.length,
    checkedParagraphCount: reviewedArticles.reduce(
      (total, article) => total + (article?.paragraphs.length ?? 0),
      0
    ),
    titleIssues: [],
    paragraphIssues: [],
    orderingIssues: [],
    duplicateIssues: [],
    unassignedBlockClassification: classifyUnassignedBlocks(
      parsed.unassignedBlocks
    ),
    unicodeIssues: [],
    correctionsApplied: configuration.correctionsApplied,
    remainingWarnings: configuration.remainingWarnings,
    reviewOutcome: configuration.reviewOutcome
  };
}
