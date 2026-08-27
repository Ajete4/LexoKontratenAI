import { randomUUID } from "node:crypto";
import { mkdir, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { createLegalRetrievalEvaluationPlan } from "../src/legal/legal-retrieval-evaluation.js";

const mode = process.argv[2] ?? "--dry-run";
if (mode !== "--dry-run" || process.argv.length > 3) {
  throw new Error("LEGAL_RETRIEVAL_EVALUATION_REAL_MODE_NOT_APPROVED");
}

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const outputPath = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "retrieval",
  "evaluation-plan.json"
);
const temporaryPath = `${outputPath}.tmp-${randomUUID()}`;

await mkdir(dirname(outputPath), { recursive: true });
try {
  await writeFile(
    temporaryPath,
    `${JSON.stringify(createLegalRetrievalEvaluationPlan(), null, 2)}\n`,
    { encoding: "utf8", flag: "wx" }
  );
  await rm(outputPath, { force: true });
  await rename(temporaryPath, outputPath);
} finally {
  await rm(temporaryPath, { force: true });
}
