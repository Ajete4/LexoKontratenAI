import { describe, expect, it } from "vitest";

import {
  createLegalChunks,
  LEGAL_CHUNK_HARD_WARNING_CHARACTERS,
  LEGAL_CHUNK_TARGET_CHARACTERS
} from "../src/legal/legal-chunker.js";
import type { ParsedLegalDocument } from "../src/legal/legal-document-parser.js";

function parsedWithParagraphs(
  paragraphs: Array<{
    paragraphNumber: string | null;
    text: string;
    startPage?: number;
    endPage?: number;
  }>,
  articleNumber = "1"
): ParsedLegalDocument {
  return {
    lawNumber: "TEST/L-001",
    versionLabel: "test-version",
    sourceSha256: "a".repeat(64),
    pageCount: 2,
    extractionMethod: "pdf_text_layer",
    structureStatus: "parsed",
    documentType: "law",
    title: "Test",
    articles: [
      {
        articleNumber,
        articleTitle: "Titulli",
        chapterTitle: "KREU I",
        startPage: 1,
        endPage: 2,
        text: "Neni 1\nTitulli",
        paragraphs: paragraphs.map((paragraph) => ({
          paragraphNumber: paragraph.paragraphNumber,
          text: paragraph.text,
          startPage: paragraph.startPage ?? 1,
          endPage: paragraph.endPage ?? 1
        }))
      }
    ],
    unassignedBlocks: [],
    amendmentCandidates: [],
    warnings: []
  };
}

function createChunks(parsed: ParsedLegalDocument) {
  return createLegalChunks(parsed, {
    documentType: "law",
    applicability: ["employment"],
    applicabilityMode: "direct",
    reviewOutcome: "approved_for_chunking",
    amendmentCandidates: []
  });
}

describe("legal chunker", () => {
  it("splits a long article only between complete paragraphs", () => {
    const firstText = "A".repeat(2_100);
    const secondText = "B".repeat(2_100);
    const chunks = createChunks(
      parsedWithParagraphs([
        { paragraphNumber: "1", text: firstText, startPage: 1, endPage: 1 },
        { paragraphNumber: "2", text: secondText, startPage: 2, endPage: 2 }
      ])
    );

    expect(chunks).toHaveLength(2);
    expect(chunks.map((chunk) => chunk.chunkIndex)).toEqual([0, 1]);
    expect(chunks[0]?.content).toContain(firstText);
    expect(chunks[0]?.content).not.toContain(secondText);
    expect(chunks[1]?.content).toContain(secondText);
    expect(chunks[0]).toMatchObject({
      articleNumber: "1",
      paragraphStart: "1",
      paragraphEnd: "1",
      pageStart: 1,
      pageEnd: 1
    });
    expect(chunks[1]).toMatchObject({
      articleNumber: "1",
      paragraphStart: "2",
      paragraphEnd: "2",
      pageStart: 2,
      pageEnd: 2
    });
  });

  it("keeps an oversized single paragraph intact and emits both warnings", () => {
    const paragraph = "X".repeat(
      LEGAL_CHUNK_HARD_WARNING_CHARACTERS + 100
    );
    const chunks = createChunks(
      parsedWithParagraphs([{ paragraphNumber: "1", text: paragraph }])
    );

    expect(chunks).toHaveLength(1);
    expect(chunks[0]?.content).toContain(paragraph);
    expect(chunks[0]?.content.length).toBeGreaterThan(
      LEGAL_CHUNK_TARGET_CHARACTERS
    );
    expect(chunks[0]?.warnings).toEqual([
      "oversized_single_paragraph",
      "hard_character_limit_exceeded"
    ]);
  });

  it("maps amendment applicability and keeps token count null", () => {
    const parsed = parsedWithParagraphs([
      { paragraphNumber: null, text: "Teksti" }
    ]);
    const chunks = createLegalChunks(parsed, {
      documentType: "amendment",
      applicability: ["employment"],
      applicabilityMode: "amendment",
      reviewOutcome: "approved_with_warnings",
      amendmentCandidates: [
        {
          amendingArticleNumber: "1",
          baseLawNumber: "03/L-212",
          baseArticleNumber: "57",
          relationTypeCandidate: "amend",
          reviewStatus: "candidate_for_manual_review"
        }
      ]
    });

    expect(chunks[0]).toMatchObject({
      documentType: "amendment",
      applicabilityMode: "amendment_scope",
      tokenCount: null
    });
    expect(chunks[0]?.metadata.amendmentCandidates).toHaveLength(1);
  });

  it("rejects duplicate final content hashes inside one source", () => {
    const article = parsedWithParagraphs([
      { paragraphNumber: "1", text: "Tekst identik" }
    ]).articles[0];
    const parsed = parsedWithParagraphs([]);

    expect(() =>
      createChunks({
        ...parsed,
        articles: article === undefined ? [] : [article, article]
      })
    ).toThrow("LEGAL_CHUNK_DUPLICATE_CONTENT");
  });
});
