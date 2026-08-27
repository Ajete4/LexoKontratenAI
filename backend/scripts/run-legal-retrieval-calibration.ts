import { createHash, randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const mode = process.argv[2];
if ((mode !== "--execute-calibration" && mode !== "--execute-canary") || process.argv.length > 3) {
  throw new Error("LEGAL_RETRIEVAL_CALIBRATION_REAL_MODE_NOT_APPROVED");
}

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const retrievalDirectory = resolve(backendDirectory, "data", "legal-sources", "retrieval");

async function writeArtifact(fileName: string, value: unknown): Promise<void> {
  const outputPath = resolve(retrievalDirectory, fileName);
  const temporaryPath = `${outputPath}.tmp-${randomUUID()}`;
  await mkdir(dirname(outputPath), { recursive: true });
  try {
    await writeFile(temporaryPath, `${JSON.stringify(value, null, 2)}\n`, { encoding: "utf8", flag: "wx" });
    await rm(outputPath, { force: true });
    await rename(temporaryPath, outputPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

const adapterModule = await import("../src/legal/legal-embedding-adapter.js");
const clientModule = await import("../src/ai/openai-client.js");

function diagnosticReason(error: unknown) {
  if (typeof error === "object" && error !== null && "code" in error && error.code === "AI_CONFIGURATION_MISSING") {
    return "configuration_missing";
  }
  return adapterModule.getLegalEmbeddingDiagnosticReason(error);
}

if (mode === "--execute-canary") {
  const canaryModule = await import("../src/legal/legal-retrieval-calibration-canary.js");
  let report;
  try {
    const client = clientModule.createOpenAIClient();
    const adapter = adapterModule.createLegalEmbeddingAdapter(client, { maxRetries: 0 });
    report = await canaryModule.runLegalRetrievalCalibrationCanary(adapter);
  } catch (error) {
    report = {
      status: "failed", attempts: 1, successes: 0, dimensions: null,
      diagnosticReason: diagnosticReason(error), rpcCalls: 0
    };
  }
  await writeArtifact("calibration-canary-report.json", report);
  if (report.status === "failed") process.exitCode = 1;
} else {
  const goldSetPath = resolve(retrievalDirectory, "gold-set-v1.json");
  const goldSetBytes = await readFile(goldSetPath);
  const goldSetSha256 = createHash("sha256").update(goldSetBytes).digest("hex").toUpperCase();
  const goldSet = JSON.parse(goldSetBytes.toString("utf8"));
  const checkpointModule = await import("../src/legal/legal-retrieval-calibration-checkpoint.js");
  const calibrationModule = await import("../src/legal/legal-retrieval-calibration.js");
  const serviceModule = await import("../src/legal/legal-retrieval.service.js");
  const supabaseModule = await import("../src/config/supabase.js");
  const checkpoint = await checkpointModule.createCalibrationCheckpointStore({
    path: resolve(retrievalDirectory, "calibration-checkpoint.json"),
    goldSetSha256
  });
  let activeRunKey = "";

  try {
    const client = clientModule.createOpenAIClient();
    const baseAdapter = adapterModule.createLegalEmbeddingAdapter(client, { maxRetries: 0 });
    const trackedAdapter = {
      async embedLegalChunks(input: unknown) {
        await checkpoint.recordAttempt("embeddings");
        const result = await baseAdapter.embedLegalChunks(input);
        await checkpoint.recordSuccess("embeddings");
        return result;
      }
    };
    const trackedRpcClient = {
      async rpc(functionName: "match_legal_chunks", parameters: never) {
        await checkpoint.recordAttempt("rpc");
        const result = await supabaseModule.supabaseAdmin.rpc(functionName, parameters);
        if (result.error === null) await checkpoint.recordSuccess("rpc");
        return result;
      }
    };
    const service = serviceModule.createLegalRetrievalService({
      embeddingAdapter: trackedAdapter,
      rpcClient: trackedRpcClient
    });
    const report = await calibrationModule.runLegalRetrievalCalibration(service, goldSet, {
      completedRuns: checkpoint.snapshot().completedRuns,
      beforeRun: async (runKey) => { activeRunKey = runKey; },
      onRunCompleted: async (run) => checkpoint.completeRun(run)
    });
    await writeArtifact("calibration-report.json", report);
  } catch (error) {
    const state = checkpoint.snapshot();
    await writeArtifact("calibration-diagnostic.json", {
      status: "failed",
      diagnosticReason: diagnosticReason(error),
      activeRunFingerprint: createHash("sha256").update(activeRunKey, "utf8").digest("hex"),
      attempts: state.attempts,
      successes: state.successes,
      completedRuns: state.completedRuns.length
    });
    process.exitCode = 1;
  }
}
