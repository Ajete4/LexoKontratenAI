import { randomUUID } from "node:crypto";
import { mkdir, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const mode = process.argv[2];
if (mode !== "--execute" || process.argv.length > 3) {
  throw new Error("LEGAL_RETRIEVAL_EVALUATION_EXECUTION_NOT_APPROVED");
}

const [adapterModule, clientModule, evaluationModule, retrievalModule, supabaseModule] =
  await Promise.all([
    import("../src/legal/legal-embedding-adapter.js"),
    import("../src/ai/openai-client.js"),
    import("../src/legal/legal-retrieval-evaluation-runner.js"),
    import("../src/legal/legal-retrieval.service.js"),
    import("../src/config/supabase.js")
  ]);
const service = retrievalModule.createLegalRetrievalService({
  embeddingAdapter: adapterModule.createLegalEmbeddingAdapter(
    clientModule.createOpenAIClient()
  ),
  rpcClient: supabaseModule.supabaseAdmin
});
const report = await evaluationModule.runLegalRetrievalEvaluation(service);
const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const outputPath = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "retrieval",
  "evaluation-report.json"
);
const temporaryPath = `${outputPath}.tmp-${randomUUID()}`;

await mkdir(dirname(outputPath), { recursive: true });
try {
  await writeFile(temporaryPath, `${JSON.stringify(report, null, 2)}\n`, {
    encoding: "utf8",
    flag: "wx"
  });
  await rm(outputPath, { force: true });
  await rename(temporaryPath, outputPath);
} finally {
  await rm(temporaryPath, { force: true });
}
