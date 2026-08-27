import { describe, expect, it } from "vitest";

import {
  parseLegalDocument,
  type ParsedLegalDocument
} from "../src/legal/legal-document-parser.js";
import type { ExtractedLegalPdf } from "../src/legal/legal-pdf-extractor.js";

function line(pageNumber: number, text: string) {
  return { pageNumber, text, fontNames: ["body"] };
}

function fixture(): ExtractedLegalPdf {
  return {
    lawNumber: "TEST/L-001",
    sourceSha256: "a".repeat(64),
    pageCount: 2,
    pages: [
      {
        pageNumber: 1,
        lines: [
          line(1, "LIGJI TEST/L-001"),
          { ...line(1, "Neni 1"), fontNames: ["heading"] },
          { ...line(1, "Qëllimi"), fontNames: ["heading"] },
          { ...line(1, "i ligjit"), fontNames: ["heading"] },
          line(1, "1. Teksti me çështje."),
          line(1, "Sipas nenit 2 vazhdon shpjegimi."),
          { ...line(1, "KREU II"), fontNames: ["heading"] },
          line(1, "HEADER I PËRSËRITUR")
        ]
      },
      {
        pageNumber: 2,
        lines: [
          line(2, "HEADER I PËRSËRITUR"),
          line(2, "Vazhdimi i nenit të parë."),
          { ...line(2, "Neni 2"), fontNames: ["heading"] },
          line(2, "2. Paragraf pa titull")
        ]
      }
    ]
  };
}

function parse(extracted = fixture()): ParsedLegalDocument {
  return parseLegalDocument(extracted, {
    lawNumber: extracted.lawNumber,
    versionLabel: "test-version",
    documentType: "law",
    baseLawNumber: null
  });
}

describe("legal document parser", () => {
  it("recognizes controlled headings without treating references as articles", () => {
    const parsed = parse();

    expect(parsed.articles.map((article) => article.articleNumber)).toEqual([
      "1",
      "2"
    ]);
    expect(parsed.articles[0]?.text).toContain("Sipas nenit 2");
  });

  it("keeps one article across page boundaries and preserves provenance", () => {
    const parsed = parse();

    expect(parsed.articles[0]).toMatchObject({ startPage: 1, endPage: 2 });
    expect(parsed.articles[0]?.text).toContain("Vazhdimi i nenit");
  });

  it("keeps paragraph numbering and permits a null article title", () => {
    const parsed = parse();

    expect(parsed.articles[0]?.paragraphs[0]?.paragraphNumber).toBe("1");
    expect(parsed.articles[1]?.articleTitle).toBeNull();
    expect(parsed.articles[1]?.paragraphs[0]?.paragraphNumber).toBe("2");
  });

  it("joins consecutive multi-line title text with the heading font", () => {
    const extracted = fixture();
    const pages = extracted.pages.map((page) => ({
      ...page,
      lines: page.lines.map((value) =>
        value.text === "Neni 1" || value.text === "Qëllimi"
          ? { ...value, fontNames: ["heading"] }
          : value
      )
    }));
    const parsed = parse({ ...extracted, pages });

    expect(parsed.articles[0]?.articleTitle).toBe("Qëllimi i ligjit");
  });

  it("moves structural headings outside article text without losing them", () => {
    const parsed = parse();

    expect(parsed.articles[0]?.text).not.toContain("KREU II");
    expect(parsed.unassignedBlocks).toContainEqual(
      expect.objectContaining({ kind: "structural_heading", text: "KREU II" })
    );
  });

  it("normalizes spaced paragraph and subparagraph numbering", () => {
    const extracted = fixture();
    const pages = extracted.pages.map((page) => ({
      ...page,
      lines: page.lines.map((value) =>
        value.text === "1. Teksti me çështje."
          ? { ...value, text: "1 . 3. Teksti me çështje." }
          : value
      )
    }));
    const parsed = parse({ ...extracted, pages });

    expect(parsed.articles[0]?.paragraphs[0]?.paragraphNumber).toBe("1.3");
  });

  it("preserves preamble text and produces deterministic output", () => {
    const first = parse();
    const second = parse();

    expect(
      first.unassignedBlocks.find((block) => block.kind === "preamble")?.text
    ).toContain("LIGJI TEST/L-001");
    expect(JSON.stringify(first)).toBe(JSON.stringify(second));
  });

  it("keeps an amendment separate and emits only review candidates", () => {
    const extracted: ExtractedLegalPdf = {
      lawNumber: "08/L-142",
      sourceSha256: "b".repeat(64),
      pageCount: 1,
      pages: [
        {
          pageNumber: 1,
          lines: [
            line(1, "LIGJI 08/L-142"),
            line(1, "Neni 1"),
            line(1, "Qëllimi"),
            line(1, "Ndryshohet Ligji 03/L-212.")
          ]
        }
      ]
    };
    const parsed = parseLegalDocument(extracted, {
      lawNumber: "08/L-142",
      versionLabel: "gazette-18-2024",
      documentType: "amendment",
      baseLawNumber: "03/L-212"
    });

    expect(parsed.documentType).toBe("amendment");
    expect(parsed.amendmentCandidates).toEqual([
      expect.objectContaining({
        baseLawNumber: "03/L-212",
        status: "candidate_for_manual_review"
      })
    ]);
    expect(JSON.stringify(parsed)).not.toContain("consolidatedText");
  });
});
