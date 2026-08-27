import { createHash, randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import {
  reviewLegalChunks,
  type LegalChunkReviewReport
} from "../src/legal/legal-chunk-review.js";
import type { ParsedLegalDocument } from "../src/legal/legal-document-parser.js";
import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly sourceSha256: string;
  readonly chunks: readonly LegalChunk[];
};

type SourceReview = {
  readonly reviewOutcome:
    | "approved_for_chunking"
    | "approved_with_warnings"
    | "blocked";
  readonly remainingWarnings: readonly string[];
};

type ChunkingSummary = {
  readonly sources: readonly {
    readonly lawNumber: string;
    readonly chunkCount: number;
    readonly outcome:
      | "ready_for_chunk_review"
      | "ready_with_warnings"
      | "blocked";
    readonly sourceWarnings: readonly string[];
  }[];
};

const SAMPLES = {
  "03/L-212": [
    1, 2, 3, 5, 10, 11, 12, 17, 18, 32, 49, 53, 57, 67, 70, 71, 72,
    78, 80, 90, 100
  ],
  "04/L-077": [
    1, 2, 4, 8, 12, 14, 20, 28, 35, 50, 75, 85, 100, 104, 125, 136,
    154, 160, 170, 185, 239, 245, 262, 275, 300, 304, 305, 307, 325,
    346, 360, 385, 415, 450, 500, 585, 600, 615, 650, 1059
  ],
  "08/L-142": [1, 2, 3, 4, 5, 6, 7]
} as const;

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(await readFile(path, "utf8")) as T;
}

async function writeJsonAtomically(targetPath: string, value: unknown): Promise<void> {
  await mkdir(dirname(targetPath), { recursive: true });
  const temporaryPath = `${targetPath}.tmp-${randomUUID()}`;

  try {
    await writeFile(temporaryPath, `${JSON.stringify(value, null, 2)}\n`, {
      encoding: "utf8",
      flag: "wx"
    });
    await rename(temporaryPath, targetPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

const chunkingSummary = await readJson<ChunkingSummary>(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "chunks",
    "chunking-summary.json"
  )
);
const reports: LegalChunkReviewReport[] = [];

for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
  const lawNumber = artifact.lawNumber as keyof typeof SAMPLES;
  const sample = SAMPLES[lawNumber];

  if (sample === undefined) {
    throw new Error("LEGAL_CHUNK_REVIEW_SOURCE_NOT_ALLOWED");
  }

  const directoryName = lawNumber.replaceAll("/", "-");
  const parsed = await readJson<ParsedLegalDocument>(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "processed",
      directoryName,
      "parsed.json"
    )
  );
  const sourceReview = await readJson<SourceReview>(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "review",
      directoryName,
      "review-report.json"
    )
  );
  const chunkArtifact = await readJson<ChunkArtifact>(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "chunks",
      directoryName,
      "chunks.json"
    )
  );
  const sourceSummary = chunkingSummary.sources.find(
    (source) => source.lawNumber === lawNumber
  );
  const rawBytes = await readFile(
    resolve(backendDirectory, artifact.localRelativePath)
  );
  const rawHash = createHash("sha256").update(rawBytes).digest("hex");

  if (
    sourceSummary === undefined ||
    rawHash !== artifact.sha256 ||
    chunkArtifact.sourceSha256 !== artifact.sha256 ||
    chunkArtifact.lawNumber !== lawNumber ||
    sourceSummary.chunkCount !== chunkArtifact.chunks.length
  ) {
    throw new Error("LEGAL_CHUNK_REVIEW_INTEGRITY_FAILED");
  }

  const report = reviewLegalChunks(parsed, chunkArtifact.chunks, {
    expectedSourceSha256: artifact.sha256,
    reviewOutcome: sourceReview.reviewOutcome,
    chunkingOutcome: sourceSummary.outcome,
    sourceWarnings: [
      ...new Set([
        ...sourceReview.remainingWarnings,
        ...sourceSummary.sourceWarnings
      ])
    ],
    sampledArticleNumbers: sample
  });

  reports.push(report);
  await writeJsonAtomically(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "chunk-review",
      directoryName,
      "review-report.json"
    ),
    report
  );
}

await writeJsonAtomically(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "chunk-review",
    "review-summary.json"
  ),
  {
    sources: reports.map((report) => ({
      lawNumber: report.lawNumber,
      articleCount: report.articleCount,
      chunkCount: report.chunkCount,
      sampledArticleCount: report.sampledArticles.length,
      sampledChunkCount: report.sampledChunkCount,
      warningCount: report.warnings.length,
      blockingIssueCount: report.blockingIssues.length,
      outcome: report.outcome
    })),
    approvedSourceCount: reports.filter(
      (report) => report.outcome !== "blocked"
    ).length,
    blockedSourceCount: reports.filter(
      (report) => report.outcome === "blocked"
    ).length,
    seedPreparationDecision: reports.some(
      (report) => report.outcome === "blocked"
    )
      ? "blocked"
      : "eligible_after_explicit_approval"
  }
);
