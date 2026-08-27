import type { createLegalHybridRetrievalService } from "./legal-hybrid-retrieval.service.js";
import {
  HYBRID_TUNING_RERANKERS,
  HYBRID_TUNING_RPC_CONFIGURATIONS,
  HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE
} from "./legal-hybrid-tuning-config.js";
import {
  calculateControlledTermOverlap,
  rerankLegalHybridTuningResults,
  type TuningStoredResult
} from "./legal-hybrid-tuning-reranker.js";
import { calculateHybridCalibrationMetrics } from "./legal-hybrid-retrieval-calibration.js";
import { formulateCalibrationQuery, type CalibrationGoldSet } from "./legal-retrieval-calibration.js";
import { LEGAL_RETRIEVAL_EVALUATION_CASES } from "./legal-retrieval-evaluation.js";

type HybridService = ReturnType<typeof createLegalHybridRetrievalService>;

export type HybridTuningCompletedRun = {
  readonly runKey: string;
  readonly evaluationId: string;
  readonly configurationId: string;
  readonly results: readonly TuningStoredResult[];
};

function provenanceKey(result: Pick<TuningStoredResult, "lawNumber" | "chunkIndex" | "contentHash">) {
  return `${result.lawNumber}:${result.chunkIndex}:${result.contentHash}`;
}

function verdictFor(
  goldCase: CalibrationGoldSet["cases"][number],
  result: TuningStoredResult
) {
  const key = provenanceKey(result);
  if (goldCase.relevantChunks.some((chunk) => provenanceKey(chunk) === key)) return "relevant" as const;
  if (goldCase.partiallyRelevantChunks.some((chunk) => provenanceKey(chunk) === key)) {
    return "partially_relevant" as const;
  }
  return "irrelevant" as const;
}

function passesGate(metrics: ReturnType<typeof calculateHybridCalibrationMetrics>) {
  return (
    metrics.hitAt5 >= 0.75 &&
    metrics.relevantAtRank1 >= 5 &&
    metrics.byContractType.employment.hitAt5 >= 2 &&
    metrics.byContractType.service.hitAt5 >= 2 &&
    metrics.byContractType.lease.hitAt5 >= 2 &&
    metrics.scopeViolations === 0 &&
    metrics.noResultRate <= 1 / 9
  );
}

export async function runLegalHybridRetrievalTuning(
  service: HybridService,
  goldSet: CalibrationGoldSet,
  options: {
    readonly completedRuns?: readonly HybridTuningCompletedRun[];
    readonly beforeRun?: (runKey: string) => Promise<void>;
    readonly onRunCompleted?: (run: HybridTuningCompletedRun) => Promise<void>;
  } = {}
) {
  const resumed = new Map(
    (options.completedRuns ?? []).map((run) => [run.runKey, run] as const)
  );
  const rawRuns: Array<{
    readonly evaluationId: string;
    readonly contractType: "employment" | "service" | "lease";
    readonly configurationId: string;
    readonly results: readonly TuningStoredResult[];
  }> = [];

  for (const evaluationCase of LEGAL_RETRIEVAL_EVALUATION_CASES) {
    const strategy = HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE[evaluationCase.contractType];
    const query = formulateCalibrationQuery(evaluationCase, strategy);
    const requiresRemoteRun = HYBRID_TUNING_RPC_CONFIGURATIONS.some(
      (configuration) => !resumed.has(`${evaluationCase.id}:${configuration.id}`)
    );
    const embedding = requiresRemoteRun ? await service.embedQuery(query) : null;
    for (const configuration of HYBRID_TUNING_RPC_CONFIGURATIONS) {
      const runKey = `${evaluationCase.id}:${configuration.id}`;
      const resumedRun = resumed.get(runKey);
      await options.beforeRun?.(runKey);
      if (resumedRun === undefined && embedding === null) {
        throw new Error("LEGAL_HYBRID_TUNING_EMBEDDING_MISSING");
      }
      const results = resumedRun?.results ?? (await service.retrieveWithEmbedding({
          query,
          contractType: evaluationCase.contractType,
          matchCount: configuration.matchCount,
          candidateCount: configuration.candidateCount,
          minSemanticSimilarity: configuration.minSemanticSimilarity,
          rrfK: configuration.rrfK
        }, embedding!)).map((result) => ({
        lawNumber: result.lawNumber,
        articleNumber: result.articleNumber,
        chunkIndex: result.chunkIndex,
        contentHash: result.contentHash,
        fusedScore: result.fusedScore,
        semanticRank: result.semanticRank,
        lexicalRank: result.lexicalRank,
        resultRank: result.resultRank,
        termOverlap: calculateControlledTermOverlap(query, result)
      }));
      if (resumedRun === undefined) {
        await options.onRunCompleted?.({
          runKey,
          evaluationId: evaluationCase.id,
          configurationId: configuration.id,
          results
        });
      }
      rawRuns.push({
        evaluationId: evaluationCase.id,
        contractType: evaluationCase.contractType,
        configurationId: configuration.id,
        results
      });
    }
  }

  const configurations = HYBRID_TUNING_RPC_CONFIGURATIONS.flatMap((rpcConfiguration) =>
    HYBRID_TUNING_RERANKERS.map((reranker) => {
      const cases = rawRuns
        .filter((run) => run.configurationId === rpcConfiguration.id)
        .map((run) => {
          const goldCase = goldSet.cases.find((item) => item.evaluationId === run.evaluationId);
          const evaluationCase = LEGAL_RETRIEVAL_EVALUATION_CASES.find(
            (item) => item.id === run.evaluationId
          );
          if (goldCase === undefined || evaluationCase === undefined) {
            throw new Error("LEGAL_HYBRID_TUNING_GOLD_CASE_MISSING");
          }
          const allowedLaws = new Set(evaluationCase.allowedLaws);
          const results = rerankLegalHybridTuningResults(run.results, reranker.termBoost).map(
            (result) => ({
              lawNumber: result.lawNumber,
              articleNumber: result.articleNumber,
              chunkIndex: result.chunkIndex,
              contentHash: result.contentHash,
              semanticRank: result.semanticRank,
              lexicalRank: result.lexicalRank,
              originalRank: result.resultRank,
              rank: result.tunedRank,
              verdict: verdictFor(goldCase, result)
            })
          );
          return {
            evaluationId: run.evaluationId,
            contractType: run.contractType,
            returnedCount: results.length,
            outOfScopeCount: results.filter((result) => !allowedLaws.has(result.lawNumber)).length,
            results
          };
        });
      const metrics = calculateHybridCalibrationMetrics(cases);
      return {
        id: `${rpcConfiguration.id}:${reranker.id}`,
        rpcConfiguration,
        reranker,
        metrics,
        passesAcceptanceGate: passesGate(metrics),
        cases
      };
    })
  );

  return {
    version: "legal-hybrid-tuning-report-v1" as const,
    strategyRouting: HYBRID_TUNING_STRATEGY_BY_CONTRACT_TYPE,
    verdict: configurations.some((configuration) => configuration.passesAcceptanceGate)
      ? "READY_FOR_RAG_INTEGRATION" as const
      : "NEEDS_HYBRID_TUNING" as const,
    configurations
  };
}
