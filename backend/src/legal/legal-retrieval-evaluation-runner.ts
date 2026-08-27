import type { LegalRetrievalResult } from "./legal-retrieval.schema.js";
import type { createLegalRetrievalService } from "./legal-retrieval.service.js";
import {
  LEGAL_RETRIEVAL_EVALUATION_CASES,
  type LegalRetrievalEvaluationCase
} from "./legal-retrieval-evaluation.js";

type RetrievalService = ReturnType<typeof createLegalRetrievalService>;
type Verdict = "relevant" | "partially_relevant" | "irrelevant";
type AllowedLawNumber = LegalRetrievalEvaluationCase["allowedLaws"][number];

const ARTICLE_RUBRIC: Readonly<
  Record<string, { readonly relevant: readonly string[]; readonly partial: readonly string[] }>
> = {
  "employment-notice-period": {
    relevant: ["71"],
    partial: ["67", "68", "69", "70", "72"]
  },
  "employment-overtime-pay": {
    relevant: ["23", "56"],
    partial: ["22", "24", "25", "26", "55", "58"]
  },
  "employment-probation": {
    relevant: ["15"],
    partial: []
  },
  "service-nonperformance-liability": {
    relevant: ["105", "106", "107", "108", "109", "110", "111", "114", "245", "246", "247", "248"],
    partial: ["68", "112", "113", "115", "117", "120", "121"]
  },
  "service-termination": {
    relevant: ["106", "107", "108", "109", "110", "111", "114", "115", "623", "624", "634", "644"],
    partial: ["53", "112", "113", "117"]
  },
  "service-damages": {
    relevant: ["169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "245", "246", "247", "248"],
    partial: ["105", "106", "107", "108", "109", "110", "111", "114"]
  },
  "lease-maintenance": {
    relevant: ["587", "588"],
    partial: ["586", "589", "590", "591", "592", "593", "594", "595", "596", "597"]
  },
  "lease-termination": {
    relevant: ["582", "588", "601", "603", "610", "611"],
    partial: ["587", "594", "595", "596"]
  },
  "lease-property-damage": {
    relevant: ["583", "589", "590", "591", "592", "593", "594", "595", "596", "597", "602"],
    partial: ["587", "588"]
  }
};

function verdictFor(
  evaluationCase: LegalRetrievalEvaluationCase,
  result: LegalRetrievalResult
): Verdict {
  const rubric = ARTICLE_RUBRIC[evaluationCase.id];

  if (result.articleNumber !== null && rubric?.relevant.includes(result.articleNumber)) {
    return "relevant";
  }
  if (result.articleNumber !== null && rubric?.partial.includes(result.articleNumber)) {
    return "partially_relevant";
  }
  return "irrelevant";
}

export async function runLegalRetrievalEvaluation(service: RetrievalService) {
  const cases = [];

  for (const evaluationCase of LEGAL_RETRIEVAL_EVALUATION_CASES) {
    const results = await service.retrieve({
      query: evaluationCase.query,
      contractType: evaluationCase.contractType,
      matchCount: 8,
      minSimilarity: 0.5
    });
    const sanitizedResults = results.map((result, index) => ({
      rank: index + 1,
      lawNumber: result.lawNumber,
      articleNumber: result.articleNumber,
      articleTitle: result.articleTitle,
      chunkIndex: result.chunkIndex,
      contentHash: result.contentHash,
      similarity: result.similarity,
      verdict: verdictFor(evaluationCase, result)
    }));

    cases.push({
      evaluationId: evaluationCase.id,
      contractType: evaluationCase.contractType,
      expectedTopic: evaluationCase.expectedTopic,
      allowedLaws: evaluationCase.allowedLaws,
      returnedCount: sanitizedResults.length,
      outOfScopeCount: sanitizedResults.filter(
        (result) =>
          !(evaluationCase.allowedLaws as readonly AllowedLawNumber[]).includes(
            result.lawNumber
          )
      ).length,
      results: sanitizedResults
    });
  }

  const topFive = cases.flatMap((item) => item.results.slice(0, 5));
  const relevantTopFive = topFive.filter((item) => item.verdict === "relevant");
  const similarities = cases.flatMap((item) =>
    item.results.map((result) => result.similarity)
  );
  const metrics = {
    precisionAt5:
      topFive.length === 0 ? 0 : relevantTopFive.length / topFive.length,
    hitRateAt5:
      cases.filter((item) =>
        item.results.slice(0, 5).some((result) => result.verdict === "relevant")
      ).length / cases.length,
    relevantAtRank1: cases.filter(
      (item) => item.results[0]?.verdict === "relevant"
    ).length,
    outOfScopeResults: cases.reduce(
      (total, item) => total + item.outOfScopeCount,
      0
    ),
    queriesWithoutResults: cases.filter((item) => item.results.length === 0).length,
    similarity: {
      minimum: similarities.length === 0 ? null : Math.min(...similarities),
      maximum: similarities.length === 0 ? null : Math.max(...similarities),
      average:
        similarities.length === 0
          ? null
          : similarities.reduce((total, value) => total + value, 0) /
            similarities.length
    }
  };

  return {
    configuration: {
      model: "text-embedding-3-small",
      dimensions: 1_536,
      matchCount: 8,
      minSimilarity: 0.5,
      evaluationCases: 9,
      maximumOpenAiRequests: 9,
      maximumRpcCalls: 9
    },
    verdictMethod: "manual_article_rubric_v1",
    cases,
    metrics
  };
}
