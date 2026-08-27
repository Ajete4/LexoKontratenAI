import { createHash } from "node:crypto";

import type { createLegalHybridRetrievalService } from "./legal-hybrid-retrieval.service.js";
import type { CalibrationGoldSet } from "./legal-retrieval-calibration.js";
import {
  formulateCalibrationQuery
} from "./legal-retrieval-calibration.js";
import {
  LEGAL_RETRIEVAL_EVALUATION_CASES
} from "./legal-retrieval-evaluation.js";

type HybridService = ReturnType<typeof createLegalHybridRetrievalService>;
type EvaluationCase = (typeof LEGAL_RETRIEVAL_EVALUATION_CASES)[number];
type ServiceEvaluationCase = Extract<EvaluationCase, { readonly contractType: "service" }>;

export const SERVICE_TUNING_VARIANTS = [
  {
    id: "baseline-controlled",
    description: "Existing controlled terminology from calibration strategy B."
  },
  {
    id: "verified-title-anchors",
    description: "Terms taken only from locally verified headings of Law 04/L-077."
  },
  {
    id: "verified-inflection-expansion",
    description: "Verified title anchors with deterministic Albanian surface-form expansion."
  }
] as const;

export type ServiceTuningVariantId = (typeof SERVICE_TUNING_VARIANTS)[number]["id"];

const VERIFIED_TITLE_ANCHORS: Readonly<Record<string, string>> = {
  "service-nonperformance-liability":
    "nuk e përmbushë detyrimin përmbushja e detyrimit pasojat e mos përmbushjes përgjegjësia e debitorit kufizimi përjashtimi përgjegjësisë",
  "service-termination":
    "zgjidhja e kontratës deklarimi i zgjidhjes pasojat juridike të zgjidhjes detyrime të vazhdueshme kontrata për vepër",
  "service-damages":
    "dëmi real fitimi i humbur shpërblimi i plotë vëllimi i shpërblimit shpërblimi i dëmit"
};

const VERIFIED_INFLECTION_EXPANSIONS: Readonly<Record<string, string>> = {
  "service-nonperformance-liability":
    "mospërmbushja mos përmbushjes përmbushë përmbushja përgjegjësi përgjegjësia përgjegjësisë debitor debitorit",
  "service-termination":
    "zgjidhja zgjidhjes zgjidhje kontrata kontratës detyrim detyrime vazhdueshme vepër veprës",
  "service-damages":
    "dëm dëmi dëmit shpërblim shpërblimi dëmshpërblim fitim fitimi humbur"
};

export const SERVICE_TUNING_CONFIGURATION = {
  contractType: "service",
  matchCount: 8,
  candidateCount: 50,
  minSemanticSimilarity: 0.45,
  rrfK: 60
} as const;

export const SERVICE_TUNING_REQUEST_BUDGET = {
  openAiEmbeddingRequests: 9,
  readOnlyHybridRpcCalls: 9,
  databaseWrites: 0
} as const;

export function getServiceEvaluationCases(): readonly ServiceEvaluationCase[] {
  return LEGAL_RETRIEVAL_EVALUATION_CASES.filter(
    (evaluationCase): evaluationCase is ServiceEvaluationCase =>
      evaluationCase.contractType === "service"
  );
}

export function formulateServiceTuningQuery(
  evaluationCase: ServiceEvaluationCase,
  variantId: ServiceTuningVariantId
) {
  if (variantId === "baseline-controlled") {
    return formulateCalibrationQuery(evaluationCase, "B");
  }

  const anchors = VERIFIED_TITLE_ANCHORS[evaluationCase.id];
  if (anchors === undefined) {
    throw new Error("LEGAL_SERVICE_TUNING_TERMINOLOGY_MISSING");
  }
  if (variantId === "verified-title-anchors") {
    return anchors;
  }

  const expansion = VERIFIED_INFLECTION_EXPANSIONS[evaluationCase.id];
  if (expansion === undefined) {
    throw new Error("LEGAL_SERVICE_TUNING_TERMINOLOGY_MISSING");
  }
  return `${anchors} ${expansion}`;
}

export function createLegalHybridServiceTuningPlan() {
  const cases = getServiceEvaluationCases();
  return {
    version: "legal-hybrid-service-tuning-plan-v1" as const,
    mode: "local-only" as const,
    contractType: "service" as const,
    caseCount: cases.length,
    variants: SERVICE_TUNING_VARIANTS,
    configuration: SERVICE_TUNING_CONFIGURATION,
    uniqueQueries: cases.length * SERVICE_TUNING_VARIANTS.length,
    requestBudget: SERVICE_TUNING_REQUEST_BUDGET,
    globalSimilarityThresholdChanged: false,
    requiresMigration: false,
    queryFingerprints: cases.flatMap((evaluationCase) =>
      SERVICE_TUNING_VARIANTS.map((variant) => ({
        evaluationId: evaluationCase.id,
        variantId: variant.id,
        sha256: createHash("sha256")
          .update(formulateServiceTuningQuery(evaluationCase, variant.id), "utf8")
          .digest("hex")
      }))
    )
  };
}

function provenanceKey(value: {
  readonly lawNumber: string;
  readonly chunkIndex: number;
  readonly contentHash: string;
}) {
  return `${value.lawNumber}:${value.chunkIndex}:${value.contentHash}`;
}

export async function runLegalHybridServiceTuning(
  service: HybridService,
  goldSet: CalibrationGoldSet
) {
  const cases = [];
  for (const evaluationCase of getServiceEvaluationCases()) {
    const goldCase = goldSet.cases.find((item) => item.evaluationId === evaluationCase.id);
    if (goldCase === undefined) {
      throw new Error("LEGAL_SERVICE_TUNING_GOLD_CASE_MISSING");
    }
    const relevant = new Set(goldCase.relevantChunks.map(provenanceKey));
    const partial = new Set(goldCase.partiallyRelevantChunks.map(provenanceKey));

    for (const variant of SERVICE_TUNING_VARIANTS) {
      const query = formulateServiceTuningQuery(evaluationCase, variant.id);
      const results = await service.retrieve({
        query,
        ...SERVICE_TUNING_CONFIGURATION
      });
      const sanitizedResults = results.map((result, index) => {
        const key = provenanceKey(result);
        return {
          rank: index + 1,
          articleNumber: result.articleNumber,
          semanticRank: result.semanticRank,
          lexicalRank: result.lexicalRank,
          verdict: relevant.has(key)
            ? "relevant" as const
            : partial.has(key)
              ? "partially_relevant" as const
              : "irrelevant" as const
        };
      });
      cases.push({
        evaluationId: evaluationCase.id,
        variantId: variant.id,
        returnedCount: sanitizedResults.length,
        hitAt5: sanitizedResults.slice(0, 5).some((result) => result.verdict === "relevant"),
        relevantAtRank1: sanitizedResults[0]?.verdict === "relevant",
        lexicalCandidatesInTop5: sanitizedResults
          .slice(0, 5)
          .filter((result) => result.lexicalRank !== null).length,
        results: sanitizedResults
      });
    }
  }

  return {
    version: "legal-hybrid-service-tuning-report-v1" as const,
    configuration: SERVICE_TUNING_CONFIGURATION,
    requestBudget: SERVICE_TUNING_REQUEST_BUDGET,
    cases
  };
}
