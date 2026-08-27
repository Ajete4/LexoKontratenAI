import type { SupabaseClient } from "@supabase/supabase-js";

import { createOpenAIClient } from "../ai/openai-client.js";
import { supabaseAdmin } from "../config/supabase.js";
import { createLegalEmbeddingAdapter } from "../legal/legal-embedding-adapter.js";
import { createLegalHybridRetrievalService } from "../legal/legal-hybrid-retrieval.service.js";
import { createRagAnalysisPipeline } from "./rag-analysis-pipeline.js";
import { createRagContextBuilder } from "./rag-context-builder.js";
import { createGroundedAnalysisAdapter } from "./rag-grounded-analysis.adapter.js";
import { createRagClauseOrchestrator } from "./rag-orchestrator.js";

export function createProductionRagAnalysisPipeline(dependencies: {
  openAIClient?: ReturnType<typeof createOpenAIClient>;
  rpcClient?: SupabaseClient;
  concurrency?: number;
} = {}) {
  const openAIClient = dependencies.openAIClient ?? createOpenAIClient();
  const retrieval = createLegalHybridRetrievalService({
    embeddingAdapter: createLegalEmbeddingAdapter(openAIClient, { maxRetries: 0 }),
    rpcClient: {
      async rpc(functionName, parameters) {
        const { data, error } = await (dependencies.rpcClient ?? supabaseAdmin)
          .rpc(functionName, parameters);
        return { data, error };
      }
    }
  });
  const buildContext = createRagContextBuilder(retrieval);
  const analyzeGroundedFinding = createGroundedAnalysisAdapter(openAIClient);

  return createRagAnalysisPipeline({
    orchestrateClause: createRagClauseOrchestrator({
      buildContext,
      analyzeGroundedFinding
    }),
    concurrency: dependencies.concurrency
  });
}
