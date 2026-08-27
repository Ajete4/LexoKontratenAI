import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import { createLegalEmbeddingPlan } from "../src/legal/legal-embedding-planner.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly chunks: readonly LegalChunk[];
};

const expectedCounts = {
  "03/L-212": 100,
  "04/L-077": 1_059,
  "08/L-142": 7
} as const;
const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const outputPath = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "embeddings",
  "embedding-plan.json"
);

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(await readFile(path, "utf8")) as T;
}

const sources = [];

for (const source of LEGAL_SOURCE_MANIFEST) {
  if (!(source.lawNumber in expectedCounts)) {
    throw new Error("LEGAL_EMBEDDING_PLAN_SOURCE_NOT_ALLOWED");
  }

  const artifact = await readJson<ChunkArtifact>(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "chunks",
      source.lawNumber.replaceAll("/", "-"),
      "chunks.json"
    )
  );

  sources.push({
    lawNumber: source.lawNumber,
    expectedChunkCount:
      expectedCounts[source.lawNumber as keyof typeof expectedCounts],
    chunks: artifact.chunks
  });
}

const plan = createLegalEmbeddingPlan(sources);
const temporaryPath = `${outputPath}.tmp-${randomUUID()}`;

await mkdir(dirname(outputPath), { recursive: true });

try {
  await writeFile(temporaryPath, `${JSON.stringify(plan, null, 2)}\n`, {
    encoding: "utf8",
    flag: "wx"
  });
  await rename(temporaryPath, outputPath);
} finally {
  await rm(temporaryPath, { force: true });
}
