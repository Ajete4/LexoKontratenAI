import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import type { LegalChunkRemoteMapping } from "../src/legal/legal-chunk-remote-mapping.js";
import {
  renderCanaryPostflightSql,
  renderCanarySemanticSanitySql,
  selectLegalEmbeddingCanary
} from "../src/legal/legal-embedding-canary.js";

type EmploymentChunkArtifact = {
  readonly chunks: readonly LegalChunk[];
};

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const embeddingDirectory = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "embeddings"
);
const mode = process.argv[2] ?? "--dry-run";

if (!['--dry-run', '--execute'].includes(mode) || process.argv.length > 3) {
  throw new Error("LEGAL_EMBEDDING_CANARY_ARGUMENT_INVALID");
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

const mapping = (await readJson(
  resolve(embeddingDirectory, "remote-chunk-mapping.json")
)) as LegalChunkRemoteMapping;
const employmentArtifact = (await readJson(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "chunks",
    "03-L-212",
    "chunks.json"
  )
)) as EmploymentChunkArtifact;
const canary = selectLegalEmbeddingCanary(mapping, employmentArtifact.chunks);

await writeAtomically(
  resolve(embeddingDirectory, "canary-plan.json"),
  `${JSON.stringify(canary.plan, null, 2)}\n`
);
await writeAtomically(
  resolve(embeddingDirectory, "canary-postflight.sql"),
  renderCanaryPostflightSql(canary.plan)
);
await writeAtomically(
  resolve(embeddingDirectory, "canary-semantic-sanity.sql"),
  renderCanarySemanticSanitySql(canary.plan)
);

if (mode === "--execute") {
  const [adapterModule, persistenceModule, serviceModule, supabaseModule] =
    await Promise.all([
      import("../src/legal/legal-embedding-adapter.js"),
      import("../src/legal/legal-embedding-canary.persistence.js"),
      import("../src/legal/legal-embedding-canary.service.js"),
      import("../src/config/supabase.js")
    ]);
  const executeCanary = serviceModule.createLegalEmbeddingCanaryExecutor({
    adapter: adapterModule.createLegalEmbeddingAdapter(),
    persistence: persistenceModule.createLegalEmbeddingCanaryPersistence(
      supabaseModule.supabaseAdmin
    )
  });

  await executeCanary(canary);
}
