import { ApiError } from "../utils/ApiError.js";
import type { LegalEmbeddingAdapter } from "./legal-embedding-adapter.js";
import { LEGAL_EMBEDDING_DIMENSIONS } from "./legal-embedding-config.js";
import {
  legalHybridRetrievalInputSchema,
  legalHybridRetrievalRpcRowSchema,
  type LegalHybridRetrievalInput,
  type LegalHybridRetrievalResult,
  type LegalHybridRetrievalRpcRow
} from "./legal-hybrid-retrieval.schema.js";

const QUERY_CORRELATION_ID = "00000000-0000-4000-8000-000000000000";

const ALLOWED_LAWS = {
  employment: new Set(["03/L-212", "08/L-142"]),
  service: new Set(["04/L-077"]),
  lease: new Set(["04/L-077"])
} as const;

export interface LegalHybridRetrievalRpcClient {
  rpc(
    functionName: "match_legal_chunks_hybrid",
    parameters: {
      readonly p_query_embedding: readonly number[];
      readonly p_query_text: string;
      readonly p_contract_type: LegalHybridRetrievalInput["contractType"];
      readonly p_match_count: number;
      readonly p_candidate_count: number;
      readonly p_min_semantic_similarity: number;
      readonly p_rrf_k: number;
    }
  ): Promise<{ readonly data: unknown; readonly error: unknown }>;
}

function outputInvalid(): ApiError {
  return new ApiError(
    502,
    "LEGAL_HYBRID_RETRIEVAL_OUTPUT_INVALID",
    "Hybrid legal retrieval returned an invalid result."
  );
}

function mapRow(row: LegalHybridRetrievalRpcRow): LegalHybridRetrievalResult {
  return {
    chunkId: row.chunk_id,
    legalSourceId: row.legal_source_id,
    lawNumber: row.law_number,
    sourceTitle: row.source_title,
    versionLabel: row.version_label,
    officialUrl: row.official_url,
    officialDocumentUrl: row.official_document_url,
    documentType: row.document_type,
    applicabilityMode: row.applicability_mode,
    chunkIndex: row.chunk_index,
    articleNumber: row.article_number,
    articleTitle: row.article_title,
    paragraphNumber: row.paragraph_number,
    pointLabel: row.point_label,
    content: row.content,
    contentHash: row.content_hash,
    semanticScore: row.semantic_score,
    lexicalScore: row.lexical_score,
    fusedScore: row.fused_score,
    semanticRank: row.semantic_rank,
    lexicalRank: row.lexical_rank,
    resultRank: row.result_rank
  };
}

function compareRows(left: LegalHybridRetrievalRpcRow, right: LegalHybridRetrievalRpcRow) {
  return (
    right.fused_score - left.fused_score ||
    Math.max(right.semantic_score ?? 0, right.lexical_score ?? 0) -
      Math.max(left.semantic_score ?? 0, left.lexical_score ?? 0) ||
    left.law_number.localeCompare(right.law_number) ||
    left.chunk_index - right.chunk_index ||
    left.chunk_id.localeCompare(right.chunk_id)
  );
}

export function createLegalHybridRetrievalService(dependencies: {
  readonly embeddingAdapter: LegalEmbeddingAdapter;
  readonly rpcClient: LegalHybridRetrievalRpcClient;
}) {
  const embedQuery = async (query: string) => {
      const embeddingOutput = await dependencies.embeddingAdapter.embedLegalChunks({
        items: [{ chunkId: QUERY_CORRELATION_ID, content: query }]
      });
      const embedding = embeddingOutput[0]?.embedding;
      if (
        embeddingOutput.length !== 1 ||
        embedding === undefined ||
        embedding.length !== LEGAL_EMBEDDING_DIMENSIONS ||
        !embedding.every(Number.isFinite)
      ) {
        throw outputInvalid();
      }
      return embedding;
  };

  const retrieveWithEmbedding = async (
    input: unknown,
    embedding: readonly number[]
  ): Promise<LegalHybridRetrievalResult[]> => {
      const parsedInput = legalHybridRetrievalInputSchema.safeParse(input);
      if (
        !parsedInput.success ||
        embedding.length !== LEGAL_EMBEDDING_DIMENSIONS ||
        !embedding.every(Number.isFinite)
      ) {
        throw new ApiError(
          400,
          "LEGAL_HYBRID_RETRIEVAL_INPUT_INVALID",
          "Hybrid legal retrieval input is invalid."
        );
      }

      let rpcResult: { readonly data: unknown; readonly error: unknown };
      try {
        rpcResult = await dependencies.rpcClient.rpc("match_legal_chunks_hybrid", {
          p_query_embedding: embedding,
          p_query_text: parsedInput.data.query,
          p_contract_type: parsedInput.data.contractType,
          p_match_count: parsedInput.data.matchCount,
          p_candidate_count: parsedInput.data.candidateCount,
          p_min_semantic_similarity: parsedInput.data.minSemanticSimilarity,
          p_rrf_k: parsedInput.data.rrfK
        });
      } catch {
        throw new ApiError(
          503,
          "LEGAL_HYBRID_RETRIEVAL_UNAVAILABLE",
          "Hybrid legal retrieval is temporarily unavailable."
        );
      }
      if (rpcResult.error !== null) {
        throw new ApiError(
          503,
          "LEGAL_HYBRID_RETRIEVAL_UNAVAILABLE",
          "Hybrid legal retrieval is temporarily unavailable."
        );
      }

      const parsedRows = legalHybridRetrievalRpcRowSchema
        .array()
        .max(parsedInput.data.matchCount)
        .safeParse(rpcResult.data);
      if (!parsedRows.success) throw outputInvalid();

      const seenChunkIds = new Set<string>();
      for (const [index, row] of parsedRows.data.entries()) {
        const previous = parsedRows.data[index - 1];
        if (
          seenChunkIds.has(row.chunk_id) ||
          !ALLOWED_LAWS[parsedInput.data.contractType].has(row.law_number) ||
          row.result_rank !== index + 1 ||
          row.semantic_rank !== null && row.semantic_rank > parsedInput.data.candidateCount ||
          row.lexical_rank !== null && row.lexical_rank > parsedInput.data.candidateCount ||
          previous !== undefined && compareRows(previous, row) > 0
        ) {
          throw outputInvalid();
        }
        seenChunkIds.add(row.chunk_id);
      }

      return parsedRows.data.map(mapRow);
  };

  return {
    embedQuery,
    retrieveWithEmbedding,
    async retrieve(input: unknown): Promise<LegalHybridRetrievalResult[]> {
      const parsedInput = legalHybridRetrievalInputSchema.safeParse(input);
      if (!parsedInput.success) {
        throw new ApiError(
          400,
          "LEGAL_HYBRID_RETRIEVAL_INPUT_INVALID",
          "Hybrid legal retrieval input is invalid."
        );
      }
      const embedding = await embedQuery(parsedInput.data.query);
      return retrieveWithEmbedding(parsedInput.data, embedding);
    }
  };
}
