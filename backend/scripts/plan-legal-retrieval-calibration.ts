import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { createLegalRetrievalCalibrationPlan } from "../src/legal/legal-retrieval-calibration.js";
import { buildLegalRetrievalGoldSet } from "../src/legal/legal-retrieval-gold-set.js";

const mode = process.argv[2] ?? "--dry-run";
if (mode !== "--dry-run" || process.argv.length > 3) {
  throw new Error("LEGAL_RETRIEVAL_CALIBRATION_REAL_MODE_NOT_APPROVED");
}

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const retrievalDirectory = resolve(backendDirectory, "data", "legal-sources", "retrieval");
const chunkDirectories = ["03-L-212", "04-L-077", "08-L-142"] as const;
const rawChunks = (
  await Promise.all(
    chunkDirectories.map(async (directory) => {
      const artifact = JSON.parse(
        await readFile(
          resolve(backendDirectory, "data", "legal-sources", "chunks", directory, "chunks.json"),
          "utf8"
        )
      ) as { readonly chunks?: readonly unknown[] };
      if (!Array.isArray(artifact.chunks)) {
        throw new Error("LEGAL_RETRIEVAL_CALIBRATION_CHUNKS_INVALID");
      }
      return artifact.chunks;
    })
  )
).flat();

async function writeArtifact(fileName: string, value: unknown): Promise<void> {
  const outputPath = resolve(retrievalDirectory, fileName);
  const temporaryPath = `${outputPath}.tmp-${randomUUID()}`;
  await mkdir(dirname(outputPath), { recursive: true });
  try {
    await writeFile(temporaryPath, `${JSON.stringify(value, null, 2)}\n`, {
      encoding: "utf8",
      flag: "wx"
    });
    await rm(outputPath, { force: true });
    await rename(temporaryPath, outputPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

await writeArtifact("gold-set-v1.json", buildLegalRetrievalGoldSet(rawChunks));
await writeArtifact("calibration-plan.json", createLegalRetrievalCalibrationPlan());
