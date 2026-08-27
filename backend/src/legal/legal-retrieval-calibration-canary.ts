import {
  getLegalEmbeddingDiagnosticReason,
  type LegalEmbeddingAdapter
} from "./legal-embedding-adapter.js";

const SYNTHETIC_CANARY_INPUT = {
  items: [{
    chunkId: "00000000-0000-4000-8000-000000000000",
    content: "Tekst sintetik për kontroll teknik të embedding-ut."
  }]
} as const;

export async function runLegalRetrievalCalibrationCanary(
  adapter: LegalEmbeddingAdapter
) {
  try {
    const result = await adapter.embedLegalChunks(SYNTHETIC_CANARY_INPUT);
    return {
      status: "success" as const,
      attempts: 1,
      successes: 1,
      dimensions: result[0]?.embedding.length ?? null,
      diagnosticReason: null,
      rpcCalls: 0
    };
  } catch (error) {
    const publicCode =
      typeof error === "object" && error !== null && "code" in error
        ? error.code
        : null;
    return {
      status: "failed" as const,
      attempts: 1,
      successes: 0,
      dimensions: null,
      diagnosticReason:
        publicCode === "AI_CONFIGURATION_MISSING"
          ? "configuration_missing" as const
          : getLegalEmbeddingDiagnosticReason(error),
      rpcCalls: 0
    };
  }
}
