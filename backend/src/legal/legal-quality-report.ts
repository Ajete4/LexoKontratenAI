import type { ExtractedLegalPdf } from "./legal-pdf-extractor.js";
import type { ParsedLegalDocument } from "./legal-document-parser.js";

export type LegalQualityReport = {
  readonly lawNumber: string;
  readonly pageCount: number;
  readonly articleCount: number;
  readonly paragraphCount: number;
  readonly unassignedBlockCount: number;
  readonly firstArticlePage: number | null;
  readonly lastArticlePage: number | null;
  readonly duplicateArticleHeadings: readonly string[];
  readonly unusualArticleNumbers: readonly string[];
  readonly pagesWithoutText: readonly number[];
  readonly replacementCharacterCount: number;
  readonly assignedTextPercentage: number;
  readonly structureStatus: ParsedLegalDocument["structureStatus"];
  readonly warnings: readonly string[];
};

function meaningfulCharacterCount(text: string): number {
  return [...text.replace(/\s/gu, "")].length;
}

export function createLegalQualityReport(
  extracted: ExtractedLegalPdf,
  parsed: ParsedLegalDocument
): LegalQualityReport {
  const articleCounts = new Map<string, number>();

  for (const article of parsed.articles) {
    articleCounts.set(
      article.articleNumber,
      (articleCounts.get(article.articleNumber) ?? 0) + 1
    );
  }

  const unusualArticleNumbers = parsed.articles
    .filter((article, index) => Number(article.articleNumber) !== index + 1)
    .map((article) => article.articleNumber);
  const sourceTextCount = extracted.pages.reduce(
    (total, page) =>
      total +
      page.lines.reduce(
        (pageTotal, line) =>
          /^\d+$/u.test(line.text)
            ? pageTotal
            : pageTotal + meaningfulCharacterCount(line.text),
        0
      ),
    0
  );
  const assignedTextCount = parsed.articles.reduce(
    (total, article) => total + meaningfulCharacterCount(article.text),
    0
  );
  const unassignedTextCount = parsed.unassignedBlocks.reduce(
    (total, block) => total + meaningfulCharacterCount(block.text),
    0
  );
  const accountedTextCount = assignedTextCount + unassignedTextCount;
  const allExtractedText = extracted.pages
    .flatMap((page) => page.lines)
    .map((line) => line.text)
    .join("\n");

  return {
    lawNumber: parsed.lawNumber,
    pageCount: parsed.pageCount,
    articleCount: parsed.articles.length,
    paragraphCount: parsed.articles.reduce(
      (total, article) => total + article.paragraphs.length,
      0
    ),
    unassignedBlockCount: parsed.unassignedBlocks.length,
    firstArticlePage: parsed.articles[0]?.startPage ?? null,
    lastArticlePage: parsed.articles.at(-1)?.endPage ?? null,
    duplicateArticleHeadings: [...articleCounts.entries()]
      .filter(([, count]) => count > 1)
      .map(([articleNumber]) => articleNumber),
    unusualArticleNumbers,
    pagesWithoutText: extracted.pages
      .filter((page) => page.lines.length === 0)
      .map((page) => page.pageNumber),
    replacementCharacterCount: [...allExtractedText].filter(
      (character) => character === "\uFFFD"
    ).length,
    assignedTextPercentage:
      sourceTextCount === 0
        ? 0
        : Number(((accountedTextCount / sourceTextCount) * 100).toFixed(2)),
    structureStatus: parsed.structureStatus,
    warnings: parsed.warnings.map((warning) => `${warning.code}: ${warning.detail}`)
  };
}
