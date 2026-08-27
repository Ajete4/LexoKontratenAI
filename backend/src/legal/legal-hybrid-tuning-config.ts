export const HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE = {
  employment: "A",
  service: "B",
  lease: "A"
} as const;

export const HYBRID_TUNING_RPC_CONFIGURATIONS = [20, 40, 60].flatMap((rrfK) =>
  ([50, 75] as const).map((candidateCount) => ({
    id: `rrf-${rrfK}-candidates-${candidateCount}`,
    rrfK,
    candidateCount,
    matchCount: 8,
    minSemanticSimilarity: 0.45
  }))
);

export const HYBRID_TUNING_RERANKERS = [
  { id: "rpc-order", termBoost: 0 },
  { id: "controlled-term-boost", termBoost: 0.1 }
] as const;

export const HYBRID_TUNING_REQUEST_BUDGET = {
  openAiEmbeddingRequests: 9,
  readOnlyHybridRpcCalls: 54,
  databaseWrites: 0
} as const;

export function createLegalHybridTuningPlan() {
  return {
    version: "legal-hybrid-tuning-plan-v1" as const,
    strategyRouting: HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE,
    rpcConfigurations: HYBRID_TUNING_RPC_CONFIGURATIONS,
    rerankers: HYBRID_TUNING_RERANKERS,
    evaluatedConfigurations:
      HYBRID_TUNING_RPC_CONFIGURATIONS.length * HYBRID_TUNING_RERANKERS.length,
    uniqueQueries: 9,
    remoteRuns: 9 * HYBRID_TUNING_RPC_CONFIGURATIONS.length,
    requestBudget: HYBRID_TUNING_REQUEST_BUDGET,
    acceptanceGate: {
      minimumHitAt5: 0.75,
      minimumRelevantAtRank1: 5,
      minimumEmploymentHits: 2,
      minimumServiceHits: 2,
      minimumLeaseHits: 2,
      scopeViolations: 0,
      maximumNoResultRate: 1 / 9
    },
    requiresMigration0008: false,
    notes: [
      "The existing RPC already exposes candidateCount and rrfK.",
      "Term reranking is deterministic and runs only over validated RPC results.",
      "No query, legal content, vector or remote identifier is persisted."
    ]
  };
}
