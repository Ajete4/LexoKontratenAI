import type OpenAI from "openai";
import { z } from "zod";

import { env } from "../config/env.js";
import { ApiError } from "../utils/ApiError.js";
import { createOpenAIClient } from "../ai/openai-client.js";
import {
  LEGAL_EMBEDDING_BATCH_SIZE,
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MAX_CONTENT_CHARACTERS,
  LEGAL_EMBEDDING_MAX_RETRIES,
  LEGAL_EMBEDDING_MODEL
} from "./legal-embedding-config.js";

const legalEmbeddingItemSchema = z
  .object({
    chunkId: z.string().uuid(),
    content: z
      .string()
      .min(1)
      .max(LEGAL_EMBEDDING_MAX_CONTENT_CHARACTERS)
      .refine((content) => content.trim().length > 0)
  })
  .strict();

const legalEmbeddingInputSchema = z
  .object({
    items: z
      .array(legalEmbeddingItemSchema)
      .min(1)
      .max(LEGAL_EMBEDDING_BATCH_SIZE)
  })
  .strict()
  .superRefine((value, context) => {
    const ids = new Set<string>();

    for (const [index, item] of value.items.entries()) {
      if (ids.has(item.chunkId)) {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["items", index, "chunkId"],
          message: "Duplicate chunk identifier."
        });
      }

      ids.add(item.chunkId);
    }
  });

type EmbeddingResponse = {
  readonly data: readonly {
    readonly index: unknown;
    readonly embedding: unknown;
  }[];
};

export interface LegalEmbeddingOpenAIClient {
  embeddings: {
    create(
      body: OpenAI.Embeddings.EmbeddingCreateParams,
      options?: OpenAI.RequestOptions
    ): Promise<EmbeddingResponse>;
  };
}

export type LegalEmbeddingResult = {
  readonly chunkId: string;
  readonly embedding: number[];
};

export interface LegalEmbeddingAdapter {
  embedLegalChunks(input: unknown): Promise<LegalEmbeddingResult[]>;
}

type LegalEmbeddingErrorCode =
  | "AI_CONFIGURATION_MISSING"
  | "LEGAL_EMBEDDING_RATE_LIMITED"
  | "LEGAL_EMBEDDING_TIMEOUT"
  | "LEGAL_EMBEDDING_UNAVAILABLE"
  | "LEGAL_EMBEDDING_OUTPUT_INVALID";

export type LegalEmbeddingDiagnosticReason =
  | "configuration_missing"
  | "authentication_or_authorization"
  | "rate_limited"
  | "timeout_or_abort"
  | "network_dns_tls"
  | "upstream_unavailable"
  | "output_invalid"
  | "unknown";

const diagnosticReasons = new WeakMap<Error, LegalEmbeddingDiagnosticReason>();

const errors: Record<
  LegalEmbeddingErrorCode,
  { readonly statusCode: number; readonly message: string }
> = {
  AI_CONFIGURATION_MISSING: {
    statusCode: 503,
    message: "AI embedding service is not configured on the server."
  },
  LEGAL_EMBEDDING_RATE_LIMITED: {
    statusCode: 429,
    message: "Legal embedding generation is temporarily rate limited."
  },
  LEGAL_EMBEDDING_TIMEOUT: {
    statusCode: 504,
    message: "Legal embedding generation timed out."
  },
  LEGAL_EMBEDDING_UNAVAILABLE: {
    statusCode: 503,
    message: "Legal embedding generation is temporarily unavailable."
  },
  LEGAL_EMBEDDING_OUTPUT_INVALID: {
    statusCode: 502,
    message: "Legal embedding generation returned an invalid result."
  }
};

function safeError(
  code: LegalEmbeddingErrorCode,
  diagnosticReason: LegalEmbeddingDiagnosticReason = "unknown"
): ApiError {
  const error = errors[code];
  const apiError = new ApiError(error.statusCode, code, error.message);
  diagnosticReasons.set(apiError, diagnosticReason);
  return apiError;
}

export function getLegalEmbeddingDiagnosticReason(
  error: unknown
): LegalEmbeddingDiagnosticReason {
  return error instanceof Error
    ? diagnosticReasons.get(error) ?? "unknown"
    : "unknown";
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function mapError(error: unknown): ApiError {
  if (error instanceof ApiError && error.code === "AI_CONFIGURATION_MISSING") {
    return safeError("AI_CONFIGURATION_MISSING", "configuration_missing");
  }

  if (!isRecord(error)) {
    return safeError("LEGAL_EMBEDDING_UNAVAILABLE", "unknown");
  }

  const status = typeof error.status === "number" ? error.status : undefined;
  const name = typeof error.name === "string" ? error.name : "";
  const code = typeof error.code === "string" ? error.code : "";

  if (status === 401 || status === 403) {
    return safeError("AI_CONFIGURATION_MISSING", "authentication_or_authorization");
  }
  if (status === 429) {
    return safeError("LEGAL_EMBEDDING_RATE_LIMITED", "rate_limited");
  }
  if (
    name === "APIConnectionTimeoutError" ||
    name === "AbortError" ||
    code === "ETIMEDOUT"
  ) {
    return safeError("LEGAL_EMBEDDING_TIMEOUT", "timeout_or_abort");
  }
  if (status !== undefined && status >= 500) {
    return safeError("LEGAL_EMBEDDING_UNAVAILABLE", "upstream_unavailable");
  }
  if (
    name === "APIConnectionError" ||
    error instanceof TypeError ||
    ["ECONNRESET", "ECONNREFUSED", "ENOTFOUND", "EAI_AGAIN", "CERT_HAS_EXPIRED"].includes(code)
  ) {
    return safeError("LEGAL_EMBEDDING_UNAVAILABLE", "network_dns_tls");
  }

  return safeError("LEGAL_EMBEDDING_UNAVAILABLE", "unknown");
}

function validateOutput(
  response: EmbeddingResponse,
  chunkIds: readonly string[]
): LegalEmbeddingResult[] {
  if (!Array.isArray(response.data) || response.data.length !== chunkIds.length) {
    throw safeError("LEGAL_EMBEDDING_OUTPUT_INVALID", "output_invalid");
  }

  const byIndex = new Map<number, number[]>();

  for (const item of response.data) {
    if (
      !Number.isInteger(item.index) ||
      (item.index as number) < 0 ||
      (item.index as number) >= chunkIds.length ||
      byIndex.has(item.index as number) ||
      !Array.isArray(item.embedding) ||
      item.embedding.length !== LEGAL_EMBEDDING_DIMENSIONS ||
      !(item.embedding as unknown[]).every(
        (value: unknown) =>
          typeof value === "number" && Number.isFinite(value)
      )
    ) {
      throw safeError("LEGAL_EMBEDDING_OUTPUT_INVALID", "output_invalid");
    }

    byIndex.set(item.index as number, item.embedding as number[]);
  }

  return chunkIds.map((chunkId, index) => {
    const embedding = byIndex.get(index);

    if (embedding === undefined) {
      throw safeError("LEGAL_EMBEDDING_OUTPUT_INVALID", "output_invalid");
    }

    return { chunkId, embedding };
  });
}

export function createLegalEmbeddingAdapter(
  client: LegalEmbeddingOpenAIClient = createOpenAIClient(),
  options: { readonly maxRetries?: number } = {}
): LegalEmbeddingAdapter {
  return {
    async embedLegalChunks(input: unknown): Promise<LegalEmbeddingResult[]> {
      const parsed = legalEmbeddingInputSchema.safeParse(input);

      if (!parsed.success) {
        throw new ApiError(
          400,
          "LEGAL_EMBEDDING_INPUT_INVALID",
          "Legal embedding input is invalid."
        );
      }

      let response: EmbeddingResponse;

      try {
        response = await client.embeddings.create(
          {
            model: LEGAL_EMBEDDING_MODEL,
            input: parsed.data.items.map((item) => item.content),
            dimensions: LEGAL_EMBEDDING_DIMENSIONS,
            encoding_format: "float"
          },
          {
            timeout: env.OPENAI_REQUEST_TIMEOUT_MS,
            maxRetries: options.maxRetries ?? LEGAL_EMBEDDING_MAX_RETRIES
          }
        );
      } catch (error) {
        throw mapError(error);
      }

      return validateOutput(
        response,
        parsed.data.items.map((item) => item.chunkId)
      );
    }
  };
}
