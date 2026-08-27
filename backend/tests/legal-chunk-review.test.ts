import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import { createLegalChunks, type LegalChunk } from "../src/legal/legal-chunker.js";
import { reviewLegalChunks } from "../src/legal/legal-chunk-review.js";
import type { ParsedLegalDocument } from "../src/legal/legal-document-parser.js";

const REQUIRED_SAMPLES = {
  "03/L-212": [
    "1", "2", "3", "5", "10", "11", "12", "17", "18", "32", "49",
    "53", "57", "67", "70", "71", "72", "78", "80", "90", "100"
  ],
  "04/L-077": [
    "1", "2", "4", "8", "12", "14", "20", "28", "35", "50", "75",
    "85", "100", "104", "125", "136", "154", "160", "170", "185",
    "239", "245", "262", "275", "300", "304", "305", "307", "325",
    "346", "360", "385", "415", "450", "500", "585", "600", "615",
    "650", "1059"
  ],
  "08/L-142": ["1", "2", "3", "4", "5", "6", "7"]
} as const;

function parsedFixture(): ParsedLegalDocument {
  return {
    lawNumber: "TEST/L-001",
    versionLabel: "test-version",
    sourceSha256: "a".repeat(64),
    pageCount: 1,
    extractionMethod: "pdf_text_layer",
    structureStatus: "parsed",
    documentType: "law",
    title: "Test",
    articles: [
      {
        articleNumber: "1",
        articleTitle: "Qëllimi",
        chapterTitle: "KREU I",
        startPage: 1,
        endPage: 1,
        text: "Neni 1\nQëllimi\n1. Teksti juridik.",
        paragraphs: [
          {
            paragraphNumber: "1",
            text: "Teksti juridik.",
            startPage: 1,
            endPage: 1
          }
        ]
      }
    ],
    unassignedBlocks: [],
    amendmentCandidates: [],
    warnings: []
  };
}

function chunksFor(parsed: ParsedLegalDocument): LegalChunk[] {
  return createLegalChunks(parsed, {
    documentType: "law",
    applicability: ["employment"],
    applicabilityMode: "direct",
    reviewOutcome: "approved_with_warnings",
    amendmentCandidates: []
  });
}

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(
    await readFile(resolve(process.cwd(), path), "utf8")
  ) as T;
}

describe("legal chunk review", () => {
  it("approves a valid source with only allowed warnings", () => {
    const parsed = parsedFixture();
    const report = reviewLegalChunks(parsed, chunksFor(parsed), {
      expectedSourceSha256: parsed.sourceSha256,
      reviewOutcome: "approved_with_warnings",
      chunkingOutcome: "ready_with_warnings",
      sourceWarnings: ["Hierarchy is not fully nested."],
      sampledArticleNumbers: [1]
    });

    expect(report.blockingIssues).toEqual([]);
    expect(report.outcome).toBe("approved_for_seed_with_warnings");
  });

  it("blocks contaminated content even when its hash is internally valid", () => {
    const parsed = parsedFixture();
    const chunks = chunksFor(parsed);
    const original = chunks[0];

    if (original === undefined) throw new Error("fixture missing chunk");

    const content = `${original.content}\nKREU I`;
    const contaminated: LegalChunk = {
      ...original,
      content,
      contentSha256: createHash("sha256").update(content, "utf8").digest("hex")
    };
    const report = reviewLegalChunks(parsed, [contaminated], {
      expectedSourceSha256: parsed.sourceSha256,
      reviewOutcome: "approved_for_chunking",
      chunkingOutcome: "ready_for_chunk_review",
      sourceWarnings: [],
      sampledArticleNumbers: [1]
    });

    expect(report.contaminationChecks.noStructuralHeadingParagraphs).toBe(false);
    expect(report.blockingIssues).toContain("contamination_detected");
    expect(report.outcome).toBe("blocked");
  });

  it("blocks source hash and provenance mismatches", () => {
    const parsed = parsedFixture();
    const chunks = chunksFor(parsed).map((chunk) => ({
      ...chunk,
      pageEnd: 2
    }));
    const report = reviewLegalChunks(parsed, chunks, {
      expectedSourceSha256: "b".repeat(64),
      reviewOutcome: "approved_for_chunking",
      chunkingOutcome: "ready_for_chunk_review",
      sourceWarnings: [],
      sampledArticleNumbers: [1]
    });

    expect(report.integrityChecks.sourceHashMatches).toBe(false);
    expect(report.provenanceChecks.validPageRanges).toBe(false);
    expect(report.outcome).toBe("blocked");
  });

  it("contains the required sampling and all checks pass in local reports", async () => {
    for (const [lawNumber, sample] of Object.entries(REQUIRED_SAMPLES)) {
      const directory = lawNumber.replaceAll("/", "-");
      const report = await readJson<Record<string, unknown>>(
        `data/legal-sources/chunk-review/${directory}/review-report.json`
      );

      expect(report.sampledArticles).toEqual(sample);
      expect(report.sampledChunkCount).toBe(sample.length);
      expect(Object.values(report.integrityChecks as Record<string, boolean>)).toEqual(
        expect.arrayContaining([true])
      );
      expect(
        Object.values(report.integrityChecks as Record<string, boolean>).every(Boolean)
      ).toBe(true);
      expect(
        Object.values(report.textComparisonChecks as Record<string, boolean>).every(Boolean)
      ).toBe(true);
      expect(
        Object.values(report.contaminationChecks as Record<string, boolean>).every(Boolean)
      ).toBe(true);
      expect(
        Object.values(report.provenanceChecks as Record<string, boolean>).every(Boolean)
      ).toBe(true);
      expect(report.blockingIssues).toEqual([]);
      expect(report.outcome).toBe("approved_for_seed_with_warnings");
    }
  });

  it("keeps the amendment isolated and candidate metadata non-final", async () => {
    const chunks = await readJson<{
      lawNumber: string;
      chunks: LegalChunk[];
    }>("data/legal-sources/chunks/08-L-142/chunks.json");
    const candidates = chunks.chunks.flatMap(
      (chunk) => chunk.metadata.amendmentCandidates
    );

    expect(chunks.lawNumber).toBe("08/L-142");
    expect(chunks.chunks.every((chunk) => chunk.applicabilityMode === "amendment_scope")).toBe(
      true
    );
    expect(chunks.chunks.every((chunk) => chunk.lawNumber === "08/L-142")).toBe(
      true
    );
    expect(candidates).toContainEqual({
      baseLawNumber: "03/L-212",
      baseArticleNumber: "57",
      relationTypeCandidate: "amend",
      reviewStatus: "candidate_for_manual_review"
    });
  });

  it("has deterministic local-only review code and artifacts", async () => {
    const source = (
      await Promise.all(
        [
          "src/legal/legal-chunk-review.ts",
          "scripts/review-legal-chunks.ts"
        ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
      )
    ).join("\n");
    const outputs = (
      await Promise.all(
        [
          "data/legal-sources/chunk-review/03-L-212/review-report.json",
          "data/legal-sources/chunk-review/04-L-077/review-report.json",
          "data/legal-sources/chunk-review/08-L-142/review-report.json",
          "data/legal-sources/chunk-review/review-summary.json"
        ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
      )
    ).join("\n");

    expect(source).not.toMatch(/\bfetch\s*\(/u);
    expect(source).not.toMatch(
      /from\s+["']@supabase\/supabase-js["']/u
    );
    expect(source).not.toMatch(/from\s+["']openai(?:\/[^"']*)?["']/u);
    expect(outputs).not.toMatch(/[A-Z]:\\|\/Users\//u);
    expect(outputs).not.toMatch(/"(?:createdAt|updatedAt|reviewedAt|timestamp|uuid)"\s*:/iu);
  });
});
