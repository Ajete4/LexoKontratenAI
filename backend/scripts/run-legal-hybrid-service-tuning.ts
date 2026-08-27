import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

const mode = process.argv[2];
if (mode !== "--execute-service-tuning" || process.argv.length > 3) {
  throw new Error("LEGAL_SERVICE_TUNING_REAL_MODE_NOT_APPROVED");
}

const retrievalDirectory = resolve(process.cwd(), "data", "legal-sources", "retrieval");
const goldSet = JSON.parse(
  await readFile(resolve(retrievalDirectory, "gold-set-v1.json"), "utf8")
);

const [adapterModule, clientModule, serviceModule, supabaseModule, tuningModule] =
  await Promise.all([
    import("../src/legal/legal-embedding-adapter.js"),
    import("../src/ai/openai-client.js"),
    import("../src/legal/legal-hybrid-retrieval.service.js"),
    import("../src/config/supabase.js"),
    import("../src/legal/legal-hybrid-service-tuning.js")
  ]);

let embeddingAttempts = 0;
let rpcAttempts = 0;
const embeddingAdapter = adapterModule.createLegalEmbeddingAdapter(
  clientModule.createOpenAIClient(),
  { maxRetries: 0 }
);
const trackedAdapter = {
  async embedLegalChunks(input: Parameters<typeof embeddingAdapter.embedLegalChunks>[0]) {
    embeddingAttempts += 1;
    if (embeddingAttempts > tuningModule.SERVICE_TUNING_REQUEST_BUDGET.openAiEmbeddingRequests) {
      throw new Error("LEGAL_SERVICE_TUNING_EMBEDDING_BUDGET_EXCEEDED");
    }
    return embeddingAdapter.embedLegalChunks(input);
  }
};
const trackedRpcClient = {
  async rpc(
    functionName: "match_legal_chunks_hybrid",
    parameters: Parameters<typeof supabaseModule.supabaseAdmin.rpc>[1]
  ) {
    rpcAttempts += 1;
    if (rpcAttempts > tuningModule.SERVICE_TUNING_REQUEST_BUDGET.readOnlyHybridRpcCalls) {
      throw new Error("LEGAL_SERVICE_TUNING_RPC_BUDGET_EXCEEDED");
    }
    return supabaseModule.supabaseAdmin.rpc(functionName, parameters);
  }
};
const service = serviceModule.createLegalHybridRetrievalService({
  embeddingAdapter: trackedAdapter,
  rpcClient: trackedRpcClient
});

const report = await tuningModule.runLegalHybridServiceTuning(service, goldSet);
const sanitizedSummary = {
  version: report.version,
  configuration: report.configuration,
  requestCounts: {
    openAiEmbeddingRequests: embeddingAttempts,
    readOnlyHybridRpcCalls: rpcAttempts,
    databaseWrites: 0
  },
  cases: report.cases
};

process.stdout.write(`${JSON.stringify(sanitizedSummary, null, 2)}\n`);
