import { createHash } from "node:crypto";

import type { LegalRetrievalResult } from "./legal-retrieval.schema.js";
import type { createLegalRetrievalService } from "./legal-retrieval.service.js";
import { LEGAL_RETRIEVAL_EVALUATION_CASES } from "./legal-retrieval-evaluation.js";

type RetrievalService = ReturnType<typeof createLegalRetrievalService>;
type StrategyId = "A" | "B" | "C";
type Verdict = "relevant" | "partially_relevant" | "irrelevant";
type EvaluationCase = (typeof LEGAL_RETRIEVAL_EVALUATION_CASES)[number];

const MATCH_COUNT = 8;
const MINIMUM_SIMILARITIES = [0.45, 0.5, 0.55] as const;

const CONTROLLED_LEGAL_TERMS: Readonly<Record<string, string>> = {
  "employment-notice-period": "afati i njoftimit, ndërprerja dhe zgjidhja e kontratës së punës",
  "employment-overtime-pay": "punë jashtë orarit, orari i plotë dhe paga shtesë",
  "employment-probation": "punë provuese, kohëzgjatja dhe ndërprerja gjatë periudhës provuese",
  "service-nonperformance-liability": "mospërmbushja e detyrimit kontraktues, përgjegjësia e debitorit dhe pasojat e mos përmbushjes",
  "service-termination": "zgjidhja e kontratës për mospërmbushje dhe ndërprerja e kontratës për vepër ose shërbim",
  "service-damages": "shpërblimi i dëmit, dëmi real, fitimi i humbur dhe pasojat e mospërmbushjes së detyrimit",
  "lease-maintenance": "mirëmbajtja e sendit me qira, riparimet dhe përgjegjësia e qiradhënësit për të metat",
  "lease-termination": "denoncimi, zgjidhja dhe mbarimi i kontratës së qirasë",
  "lease-property-damage": "përdorimi, dëmtimi, të metat dhe kthimi i sendit të marrë me qira"
};

const CONTRACT_TYPE_LABELS = {
  employment: "kontratë pune",
  service: "marrëveshje shërbimi",
  lease: "kontratë qiraje"
} as const;

export type CalibrationGoldSet = ReturnType<
  typeof import("./legal-retrieval-gold-set.js").buildLegalRetrievalGoldSet
>;

export function formulateCalibrationQuery(
  evaluationCase: EvaluationCase,
  strategy: StrategyId
): string {
  if (strategy === "A") {
    return evaluationCase.query;
  }
  if (strategy === "B") {
    return CONTROLLED_LEGAL_TERMS[evaluationCase.id] ?? evaluationCase.query;
  }
  return `${CONTRACT_TYPE_LABELS[evaluationCase.contractType]}; tema: ${evaluationCase.expectedTopic}; ${CONTROLLED_LEGAL_TERMS[evaluationCase.id] ?? evaluationCase.query}`;
}

type CalibrationResult = Pick<
  LegalRetrievalResult,
  "lawNumber" | "articleNumber" | "chunkIndex" | "contentHash" | "similarity"
>;

export type CalibrationResumeRun = {
  readonly runKey: string;
  readonly evaluationId: string;
  readonly strategy: StrategyId;
  readonly results: readonly CalibrationResult[];
};

function resultKey(result: CalibrationResult): string {
  return `${result.lawNumber}:${result.chunkIndex}:${result.contentHash}`;
}

function verdictFor(
  goldCase: CalibrationGoldSet["cases"][number],
  result: CalibrationResult
): Verdict {
  const key = resultKey(result);
  if (goldCase.relevantChunks.some((chunk) =>
    `${chunk.lawNumber}:${chunk.chunkIndex}:${chunk.contentHash}` === key
  )) {
    return "relevant";
  }
  if (goldCase.partiallyRelevantChunks.some((chunk) =>
    `${chunk.lawNumber}:${chunk.chunkIndex}:${chunk.contentHash}` === key
  )) {
    return "partially_relevant";
  }
  return "irrelevant";
}

function calculateMetrics(cases: readonly {
  readonly contractType: "employment" | "service" | "lease";
  readonly results: readonly { readonly verdict: Verdict }[];
  readonly outOfScopeCount: number;
}[]) {
  const relevantCount = cases.reduce(
    (total, item) => total + item.results.slice(0, 5).filter((result) => result.verdict === "relevant").length,
    0
  );
  const reciprocalRanks = cases.map((item) => {
    const rank = item.results.findIndex((result) => result.verdict === "relevant");
    return rank === -1 ? 0 : 1 / (rank + 1);
  });
  const metricsFor = (contractType: "employment" | "service" | "lease") => {
    const scopedCases = cases.filter((item) => item.contractType === contractType);
    return {
      hitAt5: scopedCases.filter((item) => item.results.slice(0, 5).some((result) => result.verdict === "relevant")).length,
      totalCases: scopedCases.length
    };
  };

  return {
    precisionAt5: relevantCount / (cases.length * 5),
    hitAt5: cases.filter((item) => item.results.slice(0, 5).some((result) => result.verdict === "relevant")).length / cases.length,
    meanReciprocalRank: reciprocalRanks.reduce((sum, value) => sum + value, 0) / cases.length,
    relevantAtRank1: cases.filter((item) => item.results[0]?.verdict === "relevant").length,
    noResultRate: cases.filter((item) => item.results.length === 0).length / cases.length,
    scopeViolations: cases.reduce((sum, item) => sum + item.outOfScopeCount, 0),
    byContractType: {
      employment: metricsFor("employment"),
      service: metricsFor("service"),
      lease: metricsFor("lease")
    }
  };
}

function passesMinimumCriteria(metrics: ReturnType<typeof calculateMetrics>): boolean {
  return (
    metrics.scopeViolations === 0 &&
    metrics.hitAt5 >= 0.75 &&
    metrics.byContractType.service.hitAt5 >= 2 &&
    metrics.byContractType.employment.hitAt5 >= 2 &&
    metrics.byContractType.lease.hitAt5 >= 2 &&
    metrics.relevantAtRank1 >= 5 &&
    metrics.noResultRate <= 1 / 9
  );
}

export function createLegalRetrievalCalibrationPlan() {
  return {
    mode: "dry-run" as const,
    goldSetVersion: "legal-retrieval-gold-v1",
    strategies: ["A", "B", "C"] as const,
    thresholds: MINIMUM_SIMILARITIES,
    matchCount: MATCH_COUNT,
    executionOptimization: "one retrieval at 0.45 per case and strategy; higher thresholds derived locally",
    requestBudget: {
      openAiEmbeddingRequests: 27,
      readOnlyRpcCalls: 27,
      evaluatedGridConfigurations: 9
    },
    passCriteria: {
      scopeViolations: 0,
      minimumHitAt5: 0.75,
      minimumHitsPerContractType: 2,
      minimumRelevantAtRank1: 5,
      maximumNoResultRate: 1 / 9
    },
    queryFingerprints: LEGAL_RETRIEVAL_EVALUATION_CASES.flatMap((evaluationCase) =>
      (["A", "B", "C"] as const).map((strategy) => ({
        evaluationId: evaluationCase.id,
        strategy,
        sha256: createHash("sha256").update(formulateCalibrationQuery(evaluationCase, strategy), "utf8").digest("hex")
      }))
    )
  };
}

export async function runLegalRetrievalCalibration(
  service: RetrievalService,
  goldSet: CalibrationGoldSet,
  options: {
    readonly completedRuns?: readonly CalibrationResumeRun[];
    readonly beforeRun?: (runKey: string) => Promise<void>;
    readonly onRunCompleted?: (run: CalibrationResumeRun) => Promise<void>;
  } = {}
) {
  const completedRuns = new Map(
    (options.completedRuns ?? []).map((run) => [run.runKey, run] as const)
  );
  const rawRuns: Array<{
    readonly strategy: StrategyId;
    readonly evaluationCase: EvaluationCase;
    readonly results: readonly CalibrationResult[];
  }> = [];
  for (const strategy of ["A", "B", "C"] as const) {
    for (const evaluationCase of LEGAL_RETRIEVAL_EVALUATION_CASES) {
      const runKey = `${evaluationCase.id}:${strategy}`;
      const resumed = completedRuns.get(runKey);
      await options.beforeRun?.(runKey);
      const results = resumed?.results ?? (await service.retrieve({
          query: formulateCalibrationQuery(evaluationCase, strategy),
          contractType: evaluationCase.contractType,
          matchCount: MATCH_COUNT,
          minSimilarity: MINIMUM_SIMILARITIES[0]
        })).map((result) => ({
          lawNumber: result.lawNumber,
          articleNumber: result.articleNumber,
          chunkIndex: result.chunkIndex,
          contentHash: result.contentHash,
          similarity: result.similarity
        }));
      if (resumed === undefined) {
        await options.onRunCompleted?.({
          runKey,
          evaluationId: evaluationCase.id,
          strategy,
          results
        });
      }
      rawRuns.push({ strategy, evaluationCase, results });
    }
  }

  const configurations = (["A", "B", "C"] as const).flatMap((strategy) =>
    MINIMUM_SIMILARITIES.map((minSimilarity) => {
      const cases = rawRuns
        .filter((run) => run.strategy === strategy)
        .map((run) => {
          const goldCase = goldSet.cases.find((item) => item.evaluationId === run.evaluationCase.id);
          if (goldCase === undefined) {
            throw new Error("LEGAL_RETRIEVAL_CALIBRATION_GOLD_CASE_MISSING");
          }
          const results = run.results
            .filter((result) => result.similarity >= minSimilarity)
            .map((result, index) => ({
              rank: index + 1,
              lawNumber: result.lawNumber,
              articleNumber: result.articleNumber,
              chunkIndex: result.chunkIndex,
              contentHash: result.contentHash,
              similarity: result.similarity,
              verdict: verdictFor(goldCase, result)
            }));
          const allowedLaws = new Set(run.evaluationCase.allowedLaws);
          return {
            evaluationId: run.evaluationCase.id,
            contractType: run.evaluationCase.contractType,
            returnedCount: results.length,
            outOfScopeCount: results.filter((result) => !allowedLaws.has(result.lawNumber)).length,
            results
          };
        });
      const metrics = calculateMetrics(cases);
      return {
        strategy,
        minSimilarity,
        matchCount: MATCH_COUNT,
        cases,
        metrics,
        passesMinimumCriteria: passesMinimumCriteria(metrics)
      };
    })
  );

  return {
    goldSetVersion: goldSet.version,
    requestCounts: { openAiEmbeddingRequests: 27, readOnlyRpcCalls: 27 },
    outcome: configurations.some((configuration) => configuration.passesMinimumCriteria)
      ? "READY_FOR_RAG_INTEGRATION"
      : "NEEDS_HYBRID_RETRIEVAL",
    configurations
  };
}
