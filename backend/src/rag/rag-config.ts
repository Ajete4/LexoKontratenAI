export const RAG_PIPELINE_VERSION = "contract-analysis-rag-v1";
export const RAG_CITATION_CONTRACT_VERSION = "legal-citation-v1";

export const RAG_RETRIEVAL_CONFIG = Object.freeze({
  routing: Object.freeze({
    employment: "A",
    service: "verified-title-anchors",
    lease: "A"
  }),
  rrfK: 40,
  candidateCount: 50,
  matchCount: 8,
  minSemanticSimilarity: 0.45,
  reranker: "controlled-term-boost",
  termBoost: 0.1,
  maximumSources: 5,
  maximumContextCharacters: 12_000,
  maximumQueryCharacters: 2_000
} as const);

export const RAG_ALLOWED_LAWS = Object.freeze({
  employment: Object.freeze(["03/L-212", "08/L-142"]),
  service: Object.freeze(["04/L-077"]),
  lease: Object.freeze(["04/L-077"])
} as const);
