import type { ExtractedLegalPdf, LegalPdfLine } from "./legal-pdf-extractor.js";

export type ParsedLegalParagraph = {
  readonly paragraphNumber: string | null;
  readonly text: string;
  readonly startPage: number;
  readonly endPage: number;
};

export type ParsedLegalBlock = {
  readonly kind:
    | "preamble"
    | "repeated_header_footer"
    | "structural_heading"
    | "trailing";
  readonly text: string;
  readonly startPage: number;
  readonly endPage: number;
};

export type ParsedLegalArticle = {
  readonly articleNumber: string;
  readonly articleTitle: string | null;
  readonly chapterTitle: string | null;
  readonly startPage: number;
  readonly endPage: number;
  readonly text: string;
  readonly paragraphs: readonly ParsedLegalParagraph[];
};

export type LegalParsingWarning = {
  readonly code: string;
  readonly detail: string;
};

export type ParsedLegalDocument = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly sourceSha256: string;
  readonly pageCount: number;
  readonly extractionMethod: "pdf_text_layer";
  readonly structureStatus: "parsed" | "requires_manual_structure_review";
  readonly documentType: "law" | "amendment";
  readonly title: string | null;
  readonly articles: readonly ParsedLegalArticle[];
  readonly unassignedBlocks: readonly ParsedLegalBlock[];
  readonly amendmentCandidates: readonly {
    readonly baseLawNumber: string;
    readonly sourceArticleNumber: string;
    readonly text: string;
    readonly startPage: number;
    readonly endPage: number;
    readonly status: "candidate_for_manual_review";
  }[];
  readonly warnings: readonly LegalParsingWarning[];
};

type ParseOptions = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly documentType: "law" | "amendment";
  readonly baseLawNumber: string | null;
};

type IndexedLine = LegalPdfLine & {
  readonly index: number;
};

const ARTICLE_HEADING = /^Neni\s+(\d+[A-Z]?)$/iu;
const SUBPARAGRAPH_START = /^(\d+(?:\s*\.\s*\d+)+)\s*\.?\s+(.*)$/u;
const PARAGRAPH_START = /^(\d+)\s*\.\s*(.*)$/u;
const PAGE_NUMBER = /^\d+$/u;
const CHAPTER_HEADING = /^(?:KREU|KAPITULLI)\s+[IVXLCDM\d]+(?:\s*[-–—].*)?$/iu;
const STRUCTURAL_HEADING = /^(?:LIBRI|PJESA|KREU|KAPITULLI|SEKSIONI|NËNSEKSIONI)(?:\s+.+)?$/iu;
const ROMAN_STRUCTURAL_HEADING = /^[IVXLCDM]+\.\s+.+$/u;
const UPPERCASE_LETTER = /[A-ZÇË]/u;
const LOWERCASE_LETTER = /[a-zçë]/u;

function findRepeatedLines(pages: ExtractedLegalPdf["pages"]): Set<string> {
  const pagePresence = new Map<string, Set<number>>();

  for (const page of pages) {
    for (const text of new Set(page.lines.map((line) => line.text))) {
      const pagesForText = pagePresence.get(text) ?? new Set<number>();
      pagesForText.add(page.pageNumber);
      pagePresence.set(text, pagesForText);
    }
  }

  const threshold = Math.max(2, Math.ceil(pages.length * 0.5));

  return new Set(
    [...pagePresence.entries()]
      .filter(([text, occurrences]) => text.length > 5 && occurrences.size >= threshold)
      .map(([text]) => text)
  );
}

function isTopLevelAmendmentArticle(
  lawNumber: string,
  articleNumber: number,
  nextLine: string | undefined
): boolean {
  if (lawNumber !== "08/L-142" || articleNumber !== 6) {
    return true;
  }

  return nextLine?.includes("Ligjit Nr. 03/L-212") === true;
}

function selectArticleHeadings(lines: readonly IndexedLine[], lawNumber: string): IndexedLine[] {
  const selected: IndexedLine[] = [];
  let expectedNumber = 1;

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];

    if (line === undefined) {
      continue;
    }

    const match = ARTICLE_HEADING.exec(line.text);
    const numericArticle = match === null ? Number.NaN : Number(match[1]);

    if (
      !Number.isInteger(numericArticle) ||
      numericArticle !== expectedNumber ||
      !isTopLevelAmendmentArticle(lawNumber, numericArticle, lines[index + 1]?.text)
    ) {
      continue;
    }

    selected.push(line);
    expectedNumber += 1;
  }

  return selected;
}

function toBlock(kind: ParsedLegalBlock["kind"], lines: readonly IndexedLine[]): ParsedLegalBlock | null {
  if (lines.length === 0) {
    return null;
  }

  return {
    kind,
    text: lines.map((line) => line.text).join("\n"),
    startPage: lines[0]?.pageNumber ?? 1,
    endPage: lines.at(-1)?.pageNumber ?? 1
  };
}

function paragraphsFromLines(lines: readonly IndexedLine[]): ParsedLegalParagraph[] {
  const paragraphs: Array<{
    paragraphNumber: string | null;
    lines: IndexedLine[];
  }> = [];

  for (const line of lines) {
    const match =
      SUBPARAGRAPH_START.exec(line.text) ?? PARAGRAPH_START.exec(line.text);

    if (match !== null) {
      paragraphs.push({
        paragraphNumber: match[1]?.replace(/\s+/gu, "") ?? null,
        lines: [{ ...line, text: match[2]?.trim() ?? "" }]
      });
      continue;
    }

    const current = paragraphs.at(-1);

    if (current === undefined) {
      paragraphs.push({ paragraphNumber: null, lines: [line] });
    } else {
      current.lines.push(line);
    }
  }

  return paragraphs
    .map((paragraph) => ({
      paragraphNumber: paragraph.paragraphNumber,
      text: paragraph.lines.map((line) => line.text).filter(Boolean).join("\n"),
      startPage: paragraph.lines[0]?.pageNumber ?? 1,
      endPage: paragraph.lines.at(-1)?.pageNumber ?? 1
    }))
    .filter((paragraph) => paragraph.text.length > 0);
}

function findChapterTitle(lines: readonly IndexedLine[], headingIndex: number): string | null {
  for (let index = headingIndex - 1; index >= 0 && index >= headingIndex - 12; index -= 1) {
    const text = lines[index]?.text;

    if (text !== undefined && CHAPTER_HEADING.test(text)) {
      return text;
    }
  }

  return null;
}

function sameFont(left: IndexedLine, right: IndexedLine): boolean {
  return (
    left.fontNames.length > 0 &&
    left.fontNames.length === right.fontNames.length &&
    left.fontNames.every((fontName, index) => fontName === right.fontNames[index])
  );
}

function fontSignature(line: IndexedLine): string {
  return line.fontNames.join("|");
}

function isStructuralHeadingLine(
  line: IndexedLine,
  articleHeadingFonts: ReadonlySet<string>,
  titleLineIndexes: ReadonlySet<number>
): boolean {
  if (titleLineIndexes.has(line.index)) {
    return false;
  }

  if (
    STRUCTURAL_HEADING.test(line.text) ||
    ROMAN_STRUCTURAL_HEADING.test(line.text)
  ) {
    return true;
  }

  return (
    line.text.length >= 5 &&
    UPPERCASE_LETTER.test(line.text) &&
    !LOWERCASE_LETTER.test(line.text) &&
    articleHeadingFonts.has(fontSignature(line))
  );
}

function titleLineCount(heading: IndexedLine, body: readonly IndexedLine[]): number {
  let count = 0;

  for (const line of body) {
    if (
      SUBPARAGRAPH_START.test(line.text) ||
      PARAGRAPH_START.test(line.text) ||
      !sameFont(heading, line)
    ) {
      break;
    }

    count += 1;
  }

  return count;
}

function documentTitle(lines: readonly IndexedLine[], lawNumber: string): string | null {
  const index = lines.findIndex((line) => line.text.includes(lawNumber));

  if (index < 0) {
    return null;
  }

  return lines[index]?.text ?? null;
}

export function parseLegalDocument(
  extracted: ExtractedLegalPdf,
  options: ParseOptions
): ParsedLegalDocument {
  const repeatedLines = findRepeatedLines(extracted.pages);
  const allLines = extracted.pages
    .flatMap((page) => page.lines)
    .filter((line) => !PAGE_NUMBER.test(line.text))
    .map((line, index) => ({ ...line, index }));
  const articleHeadings = selectArticleHeadings(allLines, options.lawNumber);
  const articleHeadingFonts = new Set(articleHeadings.map(fontSignature));
  const titleLineIndexes = new Set<number>();

  for (let position = 0; position < articleHeadings.length; position += 1) {
    const heading = articleHeadings[position];

    if (heading === undefined) {
      continue;
    }

    const nextHeadingIndex = articleHeadings[position + 1]?.index ?? allLines.length;
    const candidateBody = allLines
      .slice(heading.index + 1, nextHeadingIndex)
      .filter((line) => !repeatedLines.has(line.text));
    const count = titleLineCount(heading, candidateBody);

    for (const line of candidateBody.slice(0, count)) {
      titleLineIndexes.add(line.index);
    }
  }

  const isStructural = (line: IndexedLine) =>
    isStructuralHeadingLine(line, articleHeadingFonts, titleLineIndexes);
  const repeatedBlocks: ParsedLegalBlock[] = allLines
    .filter((line) => repeatedLines.has(line.text))
    .map((line) => ({
      kind: "repeated_header_footer",
      text: line.text,
      startPage: line.pageNumber,
      endPage: line.pageNumber
    }));
  const structuralBlocks: ParsedLegalBlock[] = allLines
    .filter(isStructural)
    .map((line) => ({
      kind: "structural_heading",
      text: line.text,
      startPage: line.pageNumber,
      endPage: line.pageNumber
    }));
  const articles: ParsedLegalArticle[] = [];

  for (let position = 0; position < articleHeadings.length; position += 1) {
    const heading = articleHeadings[position];

    if (heading === undefined) {
      continue;
    }

    const nextHeadingIndex = articleHeadings[position + 1]?.index ?? allLines.length;
    const rawBody = allLines.slice(heading.index + 1, nextHeadingIndex);
    const body = rawBody.filter(
      (line) =>
        !repeatedLines.has(line.text) && !isStructural(line)
    );
    const numberOfTitleLines = titleLineCount(heading, body);
    const titleLines = body.slice(0, numberOfTitleLines);
    const title =
      titleLines.length === 0
        ? null
        : titleLines.map((line) => line.text).join(" ");
    const contentLines = body.slice(numberOfTitleLines);
    const headingMatch = ARTICLE_HEADING.exec(heading.text);

    articles.push({
      articleNumber: headingMatch?.[1] ?? String(position + 1),
      articleTitle: title,
      chapterTitle: findChapterTitle(allLines, heading.index),
      startPage: heading.pageNumber,
      endPage: body.at(-1)?.pageNumber ?? heading.pageNumber,
      text: [heading.text, ...body.map((line) => line.text)].join("\n"),
      paragraphs: paragraphsFromLines(contentLines)
    });
  }

  const unassignedBlocks: ParsedLegalBlock[] = [
    ...repeatedBlocks,
    ...structuralBlocks
  ];
  const firstHeadingIndex = articleHeadings[0]?.index;

  if (firstHeadingIndex === undefined) {
    const block = toBlock(
      "preamble",
      allLines.filter(
        (line) =>
          !repeatedLines.has(line.text) && !isStructural(line)
      )
    );
    if (block !== null) unassignedBlocks.push(block);
  } else {
    const preamble = toBlock(
      "preamble",
      allLines
        .slice(0, firstHeadingIndex)
        .filter(
          (line) =>
            !repeatedLines.has(line.text) && !isStructural(line)
        )
    );
    if (preamble !== null) unassignedBlocks.push(preamble);
  }

  const warnings: LegalParsingWarning[] = [];
  const expectedArticleCounts: Readonly<Record<string, number>> = {
    "03/L-212": 100,
    "04/L-077": 1059,
    "08/L-142": 7
  };
  const expectedCount = expectedArticleCounts[options.lawNumber];

  if (expectedCount === undefined || articles.length !== expectedCount) {
    warnings.push({
      code: "ARTICLE_SEQUENCE_REQUIRES_REVIEW",
      detail: `Expected ${expectedCount ?? "unknown"} sequential articles; parsed ${articles.length}.`
    });
  }

  const amendmentCandidates =
    options.documentType === "amendment" && options.baseLawNumber !== null
      ? articles
          .filter((article) => article.text.includes(options.baseLawNumber as string))
          .map((article) => ({
            baseLawNumber: options.baseLawNumber as string,
            sourceArticleNumber: article.articleNumber,
            text: article.text,
            startPage: article.startPage,
            endPage: article.endPage,
            status: "candidate_for_manual_review" as const
          }))
      : [];

  return {
    lawNumber: options.lawNumber,
    versionLabel: options.versionLabel,
    sourceSha256: extracted.sourceSha256,
    pageCount: extracted.pageCount,
    extractionMethod: "pdf_text_layer",
    structureStatus: warnings.length === 0 ? "parsed" : "requires_manual_structure_review",
    documentType: options.documentType,
    title: documentTitle(allLines, options.lawNumber),
    articles,
    unassignedBlocks,
    amendmentCandidates,
    warnings
  };
}
