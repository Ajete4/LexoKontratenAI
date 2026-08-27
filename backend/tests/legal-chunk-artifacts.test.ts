import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import type { ParsedLegalDocument } from "../src/legal/legal-document-parser.js";
import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";

type ChunkArtifact = {
  lawNumber: string;
  versionLabel: string;
  sourceSha256: string;
  chunks: LegalChunk[];
};

const EXPECTED = {
  "03/L-212": {
    articleCount: 100,
    chunkCount: 100,
    applicability: ["employment"],
    applicabilityMode: "direct",
    documentType: "law"
  },
  "04/L-077": {
    articleCount: 1059,
    chunkCount: 1059,
    applicability: ["service", "lease"],
    applicabilityMode: "direct",
    documentType: "law"
  },
  "08/L-142": {
    articleCount: 7,
    chunkCount: 7,
    applicability: ["employment"],
    applicabilityMode: "amendment_scope",
    documentType: "amendment"
  }
} as const;

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(
    await readFile(resolve(process.cwd(), path), "utf8")
  ) as T;
}

function reconstructedParagraphBody(article: ParsedLegalDocument["articles"][number]): string {
  return article.paragraphs
    .map((paragraph) =>
      paragraph.paragraphNumber === null
        ? paragraph.text
        : `${paragraph.paragraphNumber}. ${paragraph.text}`
    )
    .join("\n");
}

describe("legal chunk artifacts", () => {
  it("passes source integrity and covers every known article exactly", async () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const directory = artifact.lawNumber.replaceAll("/", "-");
      const rawBytes = await readFile(
        resolve(process.cwd(), artifact.localRelativePath)
      );
      const parsed = await readJson<ParsedLegalDocument>(
        `data/legal-sources/processed/${directory}/parsed.json`
      );
      const chunkArtifact = await readJson<ChunkArtifact>(
        `data/legal-sources/chunks/${directory}/chunks.json`
      );
      const expected = EXPECTED[artifact.lawNumber as keyof typeof EXPECTED];

      expect(createHash("sha256").update(rawBytes).digest("hex")).toBe(
        artifact.sha256
      );
      expect(chunkArtifact.sourceSha256).toBe(artifact.sha256);
      expect(parsed.articles).toHaveLength(expected.articleCount);
      expect(chunkArtifact.chunks).toHaveLength(expected.chunkCount);
      expect(new Set(chunkArtifact.chunks.map((chunk) => chunk.articleNumber))).toEqual(
        new Set(parsed.articles.map((article) => article.articleNumber))
      );
    }
  });

  it("keeps indexes contiguous, one article per chunk and complete paragraph text", async () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const directory = artifact.lawNumber.replaceAll("/", "-");
      const parsed = await readJson<ParsedLegalDocument>(
        `data/legal-sources/processed/${directory}/parsed.json`
      );
      const chunkArtifact = await readJson<ChunkArtifact>(
        `data/legal-sources/chunks/${directory}/chunks.json`
      );

      expect(chunkArtifact.chunks.map((chunk) => chunk.chunkIndex)).toEqual(
        Array.from({ length: chunkArtifact.chunks.length }, (_, index) => index)
      );

      for (const article of parsed.articles) {
        const articleChunks = chunkArtifact.chunks.filter(
          (chunk) => chunk.articleNumber === article.articleNumber
        );
        const bodies = articleChunks.map(
          (chunk) => chunk.content.split("\n\n").slice(1).join("\n\n")
        );

        expect(articleChunks.length).toBeGreaterThanOrEqual(1);
        expect(bodies.join("\n")).toBe(reconstructedParagraphBody(article));
      }
    }
  });

  it("validates hashes, provenance, limits, token count and mappings", async () => {
    for (const [lawNumber, expected] of Object.entries(EXPECTED)) {
      const directory = lawNumber.replaceAll("/", "-");
      const artifact = await readJson<ChunkArtifact>(
        `data/legal-sources/chunks/${directory}/chunks.json`
      );
      const hashes = new Set<string>();

      for (const chunk of artifact.chunks) {
        expect(chunk.contentSha256).toBe(
          createHash("sha256").update(chunk.content, "utf8").digest("hex")
        );
        expect(hashes.has(chunk.contentSha256)).toBe(false);
        hashes.add(chunk.contentSha256);
        expect(chunk.pageStart).toBeGreaterThanOrEqual(1);
        expect(chunk.pageEnd).toBeGreaterThanOrEqual(chunk.pageStart);
        expect(chunk.content.length).toBeLessThanOrEqual(4_000);
        expect(chunk.warnings).toEqual([]);
        expect(chunk.tokenCount).toBeNull();
        expect(chunk.applicability).toEqual(expected.applicability);
        expect(chunk.applicabilityMode).toBe(expected.applicabilityMode);
        expect(chunk.documentType).toBe(expected.documentType);
      }
    }
  });

  it("keeps 08/L-142 independent with review-only amendment metadata", async () => {
    const amendment = await readJson<ChunkArtifact>(
      "data/legal-sources/chunks/08-L-142/chunks.json"
    );
    const candidates = amendment.chunks.flatMap(
      (chunk) => chunk.metadata.amendmentCandidates
    );

    expect(amendment.lawNumber).toBe("08/L-142");
    expect(amendment.chunks.every((chunk) => chunk.lawNumber === "08/L-142")).toBe(
      true
    );
    expect(candidates).toHaveLength(5);
    expect(
      candidates.every(
        (candidate) =>
          candidate.reviewStatus === "candidate_for_manual_review"
      )
    ).toBe(true);
  });

  it("contains no remote calls, generated IDs, embeddings or dynamic timestamps", async () => {
    const source = (
      await Promise.all(
        [
          "src/legal/legal-chunker.ts",
          "src/legal/legal-chunk-summary.ts",
          "scripts/chunk-legal-sources.ts"
        ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
      )
    ).join("\n");
    const outputs = (
      await Promise.all(
        [
          "data/legal-sources/chunks/03-L-212/chunks.json",
          "data/legal-sources/chunks/04-L-077/chunks.json",
          "data/legal-sources/chunks/08-L-142/chunks.json",
          "data/legal-sources/chunks/chunking-summary.json"
        ].map((path) => readFile(resolve(process.cwd(), path), "utf8"))
      )
    ).join("\n");

    expect(source).not.toMatch(/\bfetch\s*\(|supabase|openai|storage\.from/iu);
    expect(outputs).not.toMatch(/"embedding"|"id"|"uuid"|"createdAt"|"updatedAt"/iu);
    expect(outputs).not.toMatch(/[A-Z]:\\|\/Users\//u);
    expect(outputs).not.toMatch(/[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/iu);
  });
});
