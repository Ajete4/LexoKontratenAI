import type { createLegalHybridRetrievalService } from "./legal-hybrid-retrieval.service.js";
import { formulateCalibrationQuery, type CalibrationGoldSet } from "./legal-retrieval-calibration.js";
import { LEGAL_RETRIEVAL_EVALUATION_CASES } from "./legal-retrieval-evaluation.js";

type HybridRetrievalService = ReturnType<typeof createLegalHybridRetrievalService>;
type StrategyId = "A" | "B" | "C";
type Verdict = "relevant" | "partially_relevant" | "irrelevant";

export const HYBRID_CALIBRATION_CONFIGURATION = {
  matchCount: 8,
  candidateCount: 50,
  minSemanticSimilarity: 0.45,
  rrfK: 60
} as const;

export type HybridCalibrationResult = {
  readonly lawNumber: "03/L-212" | "04/L-077" | "08/L-142";
  readonly articleNumber: string | null;
  readonly chunkIndex: number;
  readonly contentHash: string;
  readonly fusedScore: number;
  readonly semanticRank: number | null;
  readonly lexicalRank: number | null;
  readonly resultRank: number;
};

export type HybridCalibrationCompletedRun = {
  readonly runKey: string;
  readonly evaluationId: string;
  readonly strategy: StrategyId;
  readonly results: readonly HybridCalibrationResult[];
};

function resultKey(result: Pick<HybridCalibrationResult, "lawNumber" | "chunkIndex" | "contentHash">) {
  return `${result.lawNumber}:${result.chunkIndex}:${result.contentHash}`;
}

function verdictFor(
  goldCase: CalibrationGoldSet["cases"][number],
  result: HybridCalibrationResult
): Verdict {
  const key = resultKey(result);
  if (goldCase.relevantChunks.some((chunk) => resultKey(chunk) === key)) {
    return "relevant";
  }
  if (goldCase.partiallyRelevantChunks.some((chunk) => resultKey(chunk) === key)) {
    return "partially_relevant";
  }
  return "irrelevant";
}

type ScoredCase = {
  readonly contractType: "employment" | "service" | "lease";
  readonly results: readonly { readonly verdict: Verdict }[];
  readonly outOfScopeCount: number;
};

export function calculateHybridCalibrationMetrics(cases: readonly ScoredCase[]) {
  const relevantInTopFive = cases.reduce(
    (total, item) =>
      total + item.results.slice(0, 5).filter((result) => result.verdict === "relevant").length,
    0
  );
  const metricsFor = (contractType: ScoredCase["contractType"]) => {
    const domainCases = cases.filter((item) => item.contractType === contractType);
    return {
      hitAt5: domainCases.filter((item) =>
        item.results.slice(0, 5).some((result) => result.verdict === "relevant")
      ).length,
      totalCases: domainCases.length
    };
  };
  const reciprocalRanks = cases.map((item) => {
    const index = item.results.findIndex((result) => result.verdict === "relevant");
    return index < 0 ? 0 : 1 / (index + 1);
  });

  return {
    precisionAt5: relevantInTopFive / (cases.length * 5),
    hitAt5:
      cases.filter((item) =>
        item.results.slice(0, 5).some((result) => result.verdict === "relevant")
      ).length / cases.length,
    meanReciprocalRank:
      reciprocalRanks.reduce((total, rank) => total + rank, 0) / cases.length,
    relevantAtRank1: cases.filter((item) => item.results[0]?.verdict === "relevant").length,
    noResultRate: cases.filter((item) => item.results.length === 0).length / cases.length,
    scopeViolations: cases.reduce((total, item) => total + item.outOfScopeCount, 0),
    byContractType: {
      employment: metricsFor("employment"),
      service: metricsFor("service"),
      lease: metricsFor("lease")
    }
  };
}

function passesAcceptanceGate(metrics: ReturnType<typeof calculateHybridCalibrationMetrics>) {
  return (
    metrics.scopeViolations === 0 &&
    metrics.hitAt5 >= 0.75 &&
    metrics.byContractType.employment.hitAt5 >= 2 &&
    metrics.byContractType.service.hitAt5 >= 2 &&
    metrics.byContractType.lease.hitAt5 >= 2 &&
    metrics.relevantAtRank1 >= 5 &&
    metrics.noResultRate <= 1 / 9
  );
}

export async function runLegalHybridRetrievalCalibration(
  service: HybridRetrievalService,
  goldSet: CalibrationGoldSet,
  options: {
    readonly completedRuns?: readonly HybridCalibrationCompletedRun[];
    readonly beforeRun?: (runKey: string) => Promise<void>;
    readonly onRunCompleted?: (run: HybridCalibrationCompletedRun) => Promise<void>;
  } = {}
) {
  const resumedRuns = new Map(
    (options.completedRuns ?? []).map((run) => [run.runKey, run] as const)
  );
  const strategyReports = [];

  for (const strategy of ["A", "B", "C"] as const) {
    const cases = [];
    for (const evaluationCase of LEGAL_RETRIEVAL_EVALUATION_CASES) {
      const runKey = `${evaluationCase.id}:${strategy}`;
      const resumed = resumedRuns.get(runKey);
      await options.beforeRun?.(runKey);
      const results = resumed?.results ?? (await service.retrieve({
        query: formulateCalibrationQuery(evaluationCase, strategy),
        contractType: evaluationCase.contractType,
        ...HYBRID_CALIBRATION_CONFIGURATION
      })).map((result) => ({
        lawNumber: result.lawNumber,
        articleNumber: result.articleNumber,
        chunkIndex: result.chunkIndex,
        contentHash: result.contentHash,
        fusedScore: result.fusedScore,
        semanticRank: result.semanticRank,
        lexicalRank: result.lexicalRank,
        resultRank: result.resultRank
      }));

      if (resumed === undefined) {
        await options.onRunCompleted?.({
          runKey,
          evaluationId: evaluationCase.id,
          strategy,
          results
        });
      }

      const goldCase = goldSet.cases.find(
        (item) => item.evaluationId === evaluationCase.id
      );
      if (goldCase === undefined) {
        throw new Error("LEGAL_HYBRID_CALIBRATION_GOLD_CASE_MISSING");
      }
      const allowedLaws = new Set(evaluationCase.allowedLaws);
      const scoredResults = results.map((result) => ({
        lawNumber: result.lawNumber,
        articleNumber: result.articleNumber,
        chunkIndex: result.chunkIndex,
        contentHash: result.contentHash,
        fusedScore: result.fusedScore,
        semanticRank: result.semanticRank,
        lexicalRank: result.lexicalRank,
        resultRank: result.resultRank,
        verdict: verdictFor(goldCase, result)
      }));
      cases.push({
        evaluationId: evaluationCase.id,
        contractType: evaluationCase.contractType,
        returnedCount: scoredResults.length,
        outOfScopeCount: scoredResults.filter(
          (result) => !allowedLaws.has(result.lawNumber)
        ).length,
        results: scoredResults
      });
    }
    const metrics = calculateHybridCalibrationMetrics(cases);
    strategyReports.push({
      strategy,
      configuration: HYBRID_CALIBRATION_CONFIGURATION,
      cases,
      metrics,
      passesAcceptanceGate: passesAcceptanceGate(metrics)
    });
  }

  return {
    version: "legal-hybrid-calibration-report-v1" as const,
    goldSetVersion: goldSet.version,
    requestBudget: {
      openAiEmbeddingRequests: 27,
      readOnlyHybridRpcCalls: 27,
      databaseWrites: 0
    },
    verdict: strategyReports.some((report) => report.passesAcceptanceGate)
      ? "READY_FOR_RAG_INTEGRATION" as const
      : "NEEDS_HYBRID_TUNING" as const,
    strategies: strategyReports
  };
}
