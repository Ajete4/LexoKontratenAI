import { createHash, randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const mode = process.argv[2];
if (mode !== "--execute-hybrid-calibration" || process.argv.length > 3) {
  throw new Error("LEGAL_HYBRID_CALIBRATION_REAL_MODE_NOT_APPROVED");
}

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const retrievalDirectory = resolve(backendDirectory, "data", "legal-sources", "retrieval");
const goldSetPath = resolve(retrievalDirectory, "gold-set-v1.json");
const planPath = resolve(retrievalDirectory, "hybrid-calibration-plan.json");
const checkpointPath = resolve(retrievalDirectory, "hybrid-calibration-checkpoint.json");

async function sha256(path: string) {
  return createHash("sha256").update(await readFile(path)).digest("hex").toUpperCase();
}

async function writeArtifact(fileName: string, value: unknown) {
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

const [goldSetBytes, planBytes] = await Promise.all([
  readFile(goldSetPath),
  readFile(planPath)
]);
const goldSetSha256 = await sha256(goldSetPath);
const planSha256 = await sha256(planPath);
const goldSet = JSON.parse(goldSetBytes.toString("utf8"));
const plan = JSON.parse(planBytes.toString("utf8"));
if (
  plan.configuration?.matchCount !== 8 ||
  plan.configuration?.candidateCount !== 50 ||
  plan.configuration?.minimumSemanticSimilarity !== 0.45 ||
  plan.configuration?.rrfK !== 60
) {
  throw new Error("LEGAL_HYBRID_CALIBRATION_PLAN_INVALID");
}

const [adapterModule, calibrationModule, checkpointModule, clientModule, serviceModule, supabaseModule] =
  await Promise.all([
    import("../src/legal/legal-embedding-adapter.js"),
    import("../src/legal/legal-hybrid-retrieval-calibration.js"),
    import("../src/legal/legal-hybrid-calibration-checkpoint.js"),
    import("../src/ai/openai-client.js"),
    import("../src/legal/legal-hybrid-retrieval.service.js"),
    import("../src/config/supabase.js")
  ]);

const checkpoint = await checkpointModule.createHybridCalibrationCheckpointStore({
  path: checkpointPath,
  goldSetSha256,
  planSha256
});
let activeRunKey = "";

try {
  const baseAdapter = adapterModule.createLegalEmbeddingAdapter(
    clientModule.createOpenAIClient(),
    { maxRetries: 0 }
  );
  const trackedAdapter = {
    async embedLegalChunks(input: unknown) {
      await checkpoint.recordAttempt("embeddings");
      const result = await baseAdapter.embedLegalChunks(input);
      await checkpoint.recordSuccess("embeddings");
      return result;
    }
  };
  const trackedRpcClient = {
    async rpc(functionName: "match_legal_chunks_hybrid", parameters: never) {
      await checkpoint.recordAttempt("rpc");
      const result = await supabaseModule.supabaseAdmin.rpc(functionName, parameters);
      if (result.error === null) await checkpoint.recordSuccess("rpc");
      return result;
    }
  };
  const service = serviceModule.createLegalHybridRetrievalService({
    embeddingAdapter: trackedAdapter,
    rpcClient: trackedRpcClient
  });
  const report = await calibrationModule.runLegalHybridRetrievalCalibration(
    service,
    goldSet,
    {
      completedRuns: checkpoint.snapshot().completedRuns,
      beforeRun: async (runKey: string) => { activeRunKey = runKey; },
      onRunCompleted: async (run: checkpointModule.HybridCheckpointCompletedRun) => {
        await checkpoint.completeRun(run);
      }
    }
  );
  const state = checkpoint.snapshot();
  await writeArtifact("hybrid-calibration-report.json", {
    ...report,
    artifactIntegrity: { goldSetSha256, planSha256 },
    requestCounts: { attempts: state.attempts, successes: state.successes }
  });
} catch (error) {
  const state = checkpoint.snapshot();
  const code =
    typeof error === "object" && error !== null && "code" in error && typeof error.code === "string"
      ? error.code
      : error instanceof Error && /^LEGAL_[A-Z0-9_]+$/u.test(error.message)
        ? error.message
        : "LEGAL_HYBRID_CALIBRATION_FAILED";
  await writeArtifact("hybrid-calibration-diagnostic.json", {
    status: "failed",
    code,
    activeRunFingerprint: createHash("sha256").update(activeRunKey, "utf8").digest("hex"),
    attempts: state.attempts,
    successes: state.successes,
    completedRuns: state.completedRuns.length
  });
  process.exitCode = 1;
}
