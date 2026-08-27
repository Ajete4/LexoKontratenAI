import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import type { LegalChunkRemoteMapping } from "../src/legal/legal-chunk-remote-mapping.js";
import type { LegalEmbeddingCanaryPlan } from "../src/legal/legal-embedding-canary.js";
import {
  createLegalEmbeddingBackfill,
  renderLegalEmbeddingBackfillPostflightSql
} from "../src/legal/legal-embedding-backfill.js";
import type { LegalEmbeddingBackfillCheckpoint } from "../src/legal/legal-embedding-backfill.service.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly chunks: readonly LegalChunk[];
};

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const embeddingDirectory = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "embeddings"
);
const checkpointPath = resolve(embeddingDirectory, "backfill-checkpoint.json");
const mode = process.argv[2] ?? "--dry-run";

if (!["--dry-run", "--execute"].includes(mode) || process.argv.length > 3) {
  throw new Error("LEGAL_EMBEDDING_BACKFILL_ARGUMENT_INVALID");
}

async function readJson(path: string): Promise<unknown> {
  return JSON.parse(await readFile(path, "utf8")) as unknown;
}

async function writeAtomically(path: string, content: string): Promise<void> {
  const temporaryPath = `${path}.tmp-${randomUUID()}`;
  await mkdir(dirname(path), { recursive: true });

  try {
    await writeFile(temporaryPath, content, { encoding: "utf8", flag: "wx" });
    await rm(path, { force: true });
    await rename(temporaryPath, path);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

const sourceNames = ["03-L-212", "04-L-077", "08-L-142"] as const;
const [mapping, canary, ...artifacts] = await Promise.all([
  readJson(resolve(embeddingDirectory, "remote-chunk-mapping.json")),
  readJson(resolve(embeddingDirectory, "canary-plan.json")),
  ...sourceNames.map((sourceName) =>
    readJson(
      resolve(
        backendDirectory,
        "data",
        "legal-sources",
        "chunks",
        sourceName,
        "chunks.json"
      )
    )
  )
]);
const backfill = createLegalEmbeddingBackfill({
  mapping: mapping as LegalChunkRemoteMapping,
  canary: canary as LegalEmbeddingCanaryPlan,
  sources: (artifacts as ChunkArtifact[]).map((artifact) => ({
    lawNumber: artifact.lawNumber,
    chunks: artifact.chunks
  }))
});
const initialCheckpoint: LegalEmbeddingBackfillCheckpoint = {
  totalCandidates: 1_165,
  completedCandidates: 0,
  skippedExisting: 0,
  lastCompletedBatch: 0,
  batchStatuses: backfill.plan.batches.map((batch) => ({
    batchNumber: batch.batchNumber,
    batchHash: batch.batchHash,
    status: "pending",
    persistedCount: 0
  }))
};

await writeAtomically(
  resolve(embeddingDirectory, "backfill-plan.json"),
  `${JSON.stringify(backfill.plan, null, 2)}\n`
);
await writeAtomically(
  resolve(embeddingDirectory, "backfill-postflight.sql"),
  renderLegalEmbeddingBackfillPostflightSql()
);

if (mode === "--dry-run") {
  await writeAtomically(
    checkpointPath,
    `${JSON.stringify(initialCheckpoint, null, 2)}\n`
  );
}

if (mode === "--execute") {
  const [adapterModule, persistenceModule, serviceModule, stateModule, supabaseModule] =
    await Promise.all([
      import("../src/legal/legal-embedding-adapter.js"),
      import("../src/legal/legal-embedding-canary.persistence.js"),
      import("../src/legal/legal-embedding-backfill.service.js"),
      import("../src/legal/legal-embedding-backfill.state.js"),
      import("../src/config/supabase.js")
    ]);
  const executeBackfill = serviceModule.createLegalEmbeddingBackfillExecutor({
    adapter: adapterModule.createLegalEmbeddingAdapter(),
    stateReader: stateModule.createLegalEmbeddingBackfillStateReader(
      supabaseModule.supabaseAdmin
    ),
    persistence: persistenceModule.createLegalEmbeddingCanaryPersistence(
      supabaseModule.supabaseAdmin
    ),
    checkpointWriter: {
      write: (checkpoint) =>
        writeAtomically(
          checkpointPath,
          `${JSON.stringify(checkpoint, null, 2)}\n`
        )
    }
  });

  await executeBackfill(backfill);
}
