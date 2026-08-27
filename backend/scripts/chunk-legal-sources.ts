import { createHash, randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { createLegalChunkingSummary } from "../src/legal/legal-chunk-summary.js";
import { createLegalChunks } from "../src/legal/legal-chunker.js";
import type { ParsedLegalDocument } from "../src/legal/legal-document-parser.js";
import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";

type ReviewReport = {
  readonly lawNumber: string;
  readonly sourceSha256: string;
  readonly versionLabel: string;
  readonly integrityGate: Record<string, boolean>;
  readonly remainingWarnings: readonly string[];
  readonly reviewOutcome:
    | "approved_for_chunking"
    | "approved_with_warnings"
    | "blocked";
};

type QualityReport = {
  readonly lawNumber: string;
  readonly pageCount: number;
  readonly articleCount: number;
  readonly structureStatus: "parsed" | "requires_manual_structure_review";
};

type AmendmentCandidateArtifact = {
  readonly candidates: readonly {
    readonly amendingArticleNumber: string;
    readonly baseLawNumber: string;
    readonly baseArticleNumber: string;
    readonly relationTypeCandidate: "amend" | "supplement" | "repeal";
    readonly reviewStatus: "candidate_for_manual_review";
  }[];
};

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const ALLOWED_LAWS = Object.freeze(["03/L-212", "04/L-077", "08/L-142"] as const);

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

const amendmentCandidateArtifact = await readJson<AmendmentCandidateArtifact>(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "review",
    "08-L-142",
    "amendment-candidates.json"
  )
);
const summaries = [];

for (const lawNumber of ALLOWED_LAWS) {
  const manifest = LEGAL_SOURCE_MANIFEST.find((entry) => entry.lawNumber === lawNumber);
  const artifact = LEGAL_SOURCE_ARTIFACTS.find((entry) => entry.lawNumber === lawNumber);

  if (
    manifest === undefined ||
    artifact === undefined ||
    manifest.versionLabel === null ||
    artifact.pageCount === null
  ) {
    throw new Error("LEGAL_CHUNK_SOURCE_CONFIGURATION_INVALID");
  }

  const directoryName = lawNumber.replaceAll("/", "-");
  const processedDirectory = resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "processed",
    directoryName
  );
  const reviewDirectory = resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "review",
    directoryName
  );
  const parsed = await readJson<ParsedLegalDocument>(
    resolve(processedDirectory, "parsed.json")
  );
  const quality = await readJson<QualityReport>(
    resolve(processedDirectory, "quality-report.json")
  );
  const review = await readJson<ReviewReport>(
    resolve(reviewDirectory, "review-report.json")
  );
  const rawBytes = await readFile(resolve(backendDirectory, artifact.localRelativePath));
  const rawHash = createHash("sha256").update(rawBytes).digest("hex");

  if (rawBytes.subarray(0, 5).toString("ascii") !== "%PDF-") {
    throw new Error("LEGAL_CHUNK_SOURCE_MAGIC_INVALID");
  }

  if (
    rawHash !== artifact.sha256 ||
    parsed.sourceSha256 !== artifact.sha256 ||
    review.sourceSha256 !== artifact.sha256 ||
    parsed.pageCount !== artifact.pageCount ||
    quality.pageCount !== artifact.pageCount ||
    parsed.lawNumber !== lawNumber ||
    quality.lawNumber !== lawNumber ||
    review.lawNumber !== lawNumber ||
    parsed.versionLabel !== manifest.versionLabel ||
    review.versionLabel !== manifest.versionLabel ||
    quality.articleCount !== parsed.articles.length ||
    Object.values(review.integrityGate).some((value) => !value)
  ) {
    throw new Error("LEGAL_CHUNK_INTEGRITY_GATE_FAILED");
  }

  if (review.reviewOutcome === "blocked") {
    throw new Error("LEGAL_CHUNK_REVIEW_BLOCKED");
  }

  const amendmentCandidates =
    lawNumber === "08/L-142" ? amendmentCandidateArtifact.candidates : [];
  const chunks = createLegalChunks(parsed, {
    documentType: manifest.documentType,
    applicability: manifest.applicability,
    applicabilityMode: manifest.applicabilityMode,
    reviewOutcome: review.reviewOutcome,
    amendmentCandidates
  });
  const articleNumbers = new Set(parsed.articles.map((article) => article.articleNumber));
  const chunkArticleNumbers = new Set(chunks.map((chunk) => chunk.articleNumber));

  if (
    articleNumbers.size !== chunkArticleNumbers.size ||
    [...articleNumbers].some((articleNumber) => !chunkArticleNumbers.has(articleNumber)) ||
    chunks.some((chunk) => !articleNumbers.has(chunk.articleNumber)) ||
    chunks.some((chunk, index) => chunk.chunkIndex !== index)
  ) {
    throw new Error("LEGAL_CHUNK_COVERAGE_FAILED");
  }

  const summary = createLegalChunkingSummary(
    parsed,
    chunks,
    review.remainingWarnings
  );

  if (summary.outcome === "blocked") {
    throw new Error("LEGAL_CHUNK_SUMMARY_BLOCKED");
  }

  summaries.push(summary);
  await writeJsonAtomically(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "chunks",
      directoryName,
      "chunks.json"
    ),
    {
      lawNumber,
      versionLabel: manifest.versionLabel,
      sourceSha256: artifact.sha256,
      chunks
    }
  );
}

await writeJsonAtomically(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "chunks",
    "chunking-summary.json"
  ),
  {
    targetCharacters: 4_000,
    hardWarningCharacters: 6_000,
    sources: summaries,
    blockedSourceCount: summaries.filter((summary) => summary.outcome === "blocked").length
  }
);
