import { ApiError } from "../utils/ApiError.js";
import type { LegalEmbeddingAdapter } from "./legal-embedding-adapter.js";
import { LEGAL_EMBEDDING_DIMENSIONS } from "./legal-embedding-config.js";
import {
  legalRetrievalInputSchema,
  legalRetrievalRpcRowSchema,
  type LegalRetrievalInput,
  type LegalRetrievalResult
} from "./legal-retrieval.schema.js";

const QUERY_CORRELATION_ID = "00000000-0000-4000-8000-000000000000";

const ALLOWED_LAWS = {
  employment: new Set(["03/L-212", "08/L-142"]),
  service: new Set(["04/L-077"]),
  lease: new Set(["04/L-077"])
} as const;

export interface LegalRetrievalRpcClient {
  rpc(
    functionName: "match_legal_chunks",
    parameters: {
      readonly p_query_embedding: readonly number[];
      readonly p_contract_type: LegalRetrievalInput["contractType"];
      readonly p_match_count: number;
      readonly p_min_similarity: number;
    }
  ): Promise<{ readonly data: unknown; readonly error: unknown }>;
}

function outputInvalid(): ApiError {
  return new ApiError(
    502,
    "LEGAL_RETRIEVAL_OUTPUT_INVALID",
    "Legal retrieval returned an invalid result."
  );
}

function mapRow(
  row: typeof legalRetrievalRpcRowSchema._output
): LegalRetrievalResult {
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
    similarity: row.similarity
  };
}

export function createLegalRetrievalService(dependencies: {
  readonly embeddingAdapter: LegalEmbeddingAdapter;
  readonly rpcClient: LegalRetrievalRpcClient;
}) {
  return {
    async retrieve(input: unknown): Promise<LegalRetrievalResult[]> {
      const parsedInput = legalRetrievalInputSchema.safeParse(input);
      if (!parsedInput.success) {
        throw new ApiError(
          400,
          "LEGAL_RETRIEVAL_INPUT_INVALID",
          "Legal retrieval input is invalid."
        );
      }

      const embeddingOutput = await dependencies.embeddingAdapter.embedLegalChunks({
        items: [
          {
            chunkId: QUERY_CORRELATION_ID,
            content: parsedInput.data.query
          }
        ]
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

      let rpcResult: { readonly data: unknown; readonly error: unknown };
      try {
        rpcResult = await dependencies.rpcClient.rpc("match_legal_chunks", {
          p_query_embedding: embedding,
          p_contract_type: parsedInput.data.contractType,
          p_match_count: parsedInput.data.matchCount,
          p_min_similarity: parsedInput.data.minSimilarity
        });
      } catch {
        throw new ApiError(
          503,
          "LEGAL_RETRIEVAL_UNAVAILABLE",
          "Legal retrieval is temporarily unavailable."
        );
      }

      if (rpcResult.error !== null) {
        throw new ApiError(
          503,
          "LEGAL_RETRIEVAL_UNAVAILABLE",
          "Legal retrieval is temporarily unavailable."
        );
      }

      const rowsResult = legalRetrievalRpcRowSchema
        .array()
        .max(parsedInput.data.matchCount)
        .safeParse(rpcResult.data);

      if (!rowsResult.success) {
        throw outputInvalid();
      }

      const seenChunkIds = new Set<string>();
      for (const [index, row] of rowsResult.data.entries()) {
        const previous = rowsResult.data[index - 1];
        const invalidOrder =
          previous !== undefined &&
          (previous.similarity < row.similarity ||
            (previous.similarity === row.similarity &&
              (previous.law_number > row.law_number ||
                (previous.law_number === row.law_number &&
                  previous.chunk_index > row.chunk_index))));

        if (
          seenChunkIds.has(row.chunk_id) ||
          !ALLOWED_LAWS[parsedInput.data.contractType].has(row.law_number) ||
          invalidOrder
        ) {
          throw outputInvalid();
        }
        seenChunkIds.add(row.chunk_id);
      }

      return rowsResult.data.map(mapRow);
    }
  };
}
