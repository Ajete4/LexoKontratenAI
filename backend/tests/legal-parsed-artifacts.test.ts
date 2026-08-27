import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";

const EXPECTED = {
  "03/L-212": { articles: 100, paragraphs: 441, firstTitle: "Qëllimi", lastTitle: "Hyrja në fuqi" },
  "04/L-077": { articles: 1059, paragraphs: 2338, firstTitle: "Fushë veprimtaria e ligjit", lastTitle: "Hyrja në fuqi" },
  "08/L-142": { articles: 7, paragraphs: 15, firstTitle: "Qëllimi", lastTitle: "Hyrja në fuqi" }
} as const;

async function readJson(relativePath: string) {
  return JSON.parse(await readFile(resolve(process.cwd(), relativePath), "utf8")) as Record<string, unknown>;
}

describe("processed legal artifacts", () => {
  it("keeps every raw PDF byte-for-byte identical to its verified hash", async () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const bytes = await readFile(resolve(process.cwd(), artifact.localRelativePath));
      expect(createHash("sha256").update(bytes).digest("hex")).toBe(artifact.sha256);
    }
  });

  it("contains the verified deterministic article and paragraph structure", async () => {
    for (const [lawNumber, expected] of Object.entries(EXPECTED)) {
      const directory = lawNumber.replaceAll("/", "-");
      const parsed = await readJson(`data/legal-sources/processed/${directory}/parsed.json`);
      const articles = parsed.articles as Array<Record<string, unknown>>;
      const paragraphCount = articles.reduce(
        (total, article) => total + (article.paragraphs as unknown[]).length,
        0
      );

      expect(articles).toHaveLength(expected.articles);
      expect(paragraphCount).toBe(expected.paragraphs);
      expect(articles[0]?.articleTitle).toBe(expected.firstTitle);
      expect(articles.at(-1)?.articleTitle).toBe(expected.lastTitle);
      expect(articles.map((article) => article.articleNumber)).toEqual(
        Array.from({ length: expected.articles }, (_, index) => String(index + 1))
      );
    }
  });

  it("reports full provenance quality without empty pages or replacement characters", async () => {
    for (const lawNumber of Object.keys(EXPECTED)) {
      const directory = lawNumber.replaceAll("/", "-");
      const report = await readJson(
        `data/legal-sources/processed/${directory}/quality-report.json`
      );

      expect(report.pagesWithoutText).toEqual([]);
      expect(report.replacementCharacterCount).toBe(0);
      expect(report.duplicateArticleHeadings).toEqual([]);
      expect(report.unusualArticleNumbers).toEqual([]);
      expect(report.structureStatus).toBe("parsed");
      expect(report.assignedTextPercentage).toEqual(expect.any(Number));
      expect(report.assignedTextPercentage).toBeGreaterThan(95);
      expect(report.assignedTextPercentage).toBeLessThanOrEqual(100);
    }
  });

  it("does not contain generated identifiers, embeddings or dynamic timestamps", async () => {
    for (const lawNumber of Object.keys(EXPECTED)) {
      const directory = lawNumber.replaceAll("/", "-");
      const content = await readFile(
        resolve(process.cwd(), `data/legal-sources/processed/${directory}/parsed.json`),
        "utf8"
      );

      expect(content).not.toMatch(/"(?:id|uuid|embedding|createdAt|updatedAt|processedAt)"\s*:/u);
      expect(content).not.toMatch(/[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/iu);
    }
  });

  it("keeps 08/L-142 separate and marks its link to 03/L-212 as review-only", async () => {
    const amendment = await readJson(
      "data/legal-sources/processed/08-L-142/parsed.json"
    );
    const candidates = amendment.amendmentCandidates as Array<Record<string, unknown>>;

    expect(amendment.documentType).toBe("amendment");
    expect(candidates).toEqual([
      expect.objectContaining({
        baseLawNumber: "03/L-212",
        sourceArticleNumber: "6",
        status: "candidate_for_manual_review"
      })
    ]);
    expect(JSON.stringify(amendment)).not.toContain("consolidatedText");
  });

  it("keeps the parser pipeline local without network or remote service calls", async () => {
    const sourceFiles = await Promise.all(
      [
        "src/legal/legal-pdf-extractor.ts",
        "src/legal/legal-document-parser.ts",
        "src/legal/legal-quality-report.ts",
        "scripts/parse-legal-sources.ts"
      ].map((relativePath) =>
        readFile(resolve(process.cwd(), relativePath), "utf8")
      )
    );
    const source = sourceFiles.join("\n");

    expect(source).not.toMatch(/\bfetch\s*\(/u);
    expect(source).not.toMatch(/supabase|openai|storage\.from/iu);
    expect(source).not.toMatch(/https?:\/\//iu);
  });
});
