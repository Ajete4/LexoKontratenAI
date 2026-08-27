import type { LegalHybridRetrievalResult } from "./legal-hybrid-retrieval.schema.js";

const ALBANIAN_STOP_WORDS = new Set([
  "dhe", "e", "i", "me", "në", "nga", "një", "ose", "për", "së", "të"
]);

function tokens(value: string) {
  return new Set(
    value
      .normalize("NFKC")
      .toLocaleLowerCase("sq-AL")
      .split(/[^\p{L}\p{N}]+/u)
      .filter((token) => token.length >= 3 && !ALBANIAN_STOP_WORDS.has(token))
  );
}

export function calculateControlledTermOverlap(
  query: string,
  result: Pick<LegalHybridRetrievalResult, "articleTitle" | "content">
) {
  const queryTokens = tokens(query);
  if (queryTokens.size === 0) return 0;
  const resultTokens = tokens(`${result.articleTitle ?? ""} ${result.content}`);
  const matches = [...queryTokens].filter((token) => resultTokens.has(token)).length;
  return matches / queryTokens.size;
}

export type TuningStoredResult = {
  readonly lawNumber: LegalHybridRetrievalResult["lawNumber"];
  readonly articleNumber: string | null;
  readonly chunkIndex: number;
  readonly contentHash: string;
  readonly fusedScore: number;
  readonly semanticRank: number | null;
  readonly lexicalRank: number | null;
  readonly resultRank: number;
  readonly termOverlap: number;
};

export function rerankLegalHybridTuningResults(
  results: readonly TuningStoredResult[],
  termBoost: number
) {
  const maximumFusedScore = Math.max(...results.map((result) => result.fusedScore), 0);
  return results
    .map((result) => ({
      ...result,
      tuningScore:
        (maximumFusedScore === 0 ? 0 : result.fusedScore / maximumFusedScore) +
        termBoost * result.termOverlap
    }))
    .sort((left, right) =>
      right.tuningScore - left.tuningScore ||
      left.resultRank - right.resultRank ||
      left.lawNumber.localeCompare(right.lawNumber) ||
      left.chunkIndex - right.chunkIndex ||
      left.contentHash.localeCompare(right.contentHash)
    )
    .map((result, index) => ({ ...result, tunedRank: index + 1 }));
}
