import OpenAI from "openai";
import { zodTextFormat } from "openai/helpers/zod";

import { env } from "../config/env.js";
import { ApiError } from "../utils/ApiError.js";
import { buildContractAnalysisPrompt } from "./contract-analysis.prompt.js";
import {
  type ContractAnalysisResult,
  type ContractType,
  contractAnalysisStructuredOutputSchema,
  validateContractAnalysisResult
} from "./contract-analysis.schema.js";
import { createOpenAIClient } from "./openai-client.js";

const MAX_OUTPUT_TOKENS = 6_000;
const MAX_SDK_RETRIES = 1;
const RESPONSE_FORMAT_NAME = "contract_analysis";

interface ParsedContractAnalysisResponse {
  output_parsed: unknown | null;
  output?: unknown;
}

export interface ContractAnalysisOpenAIClient {
  responses: {
    parse(
      body: OpenAI.Responses.ResponseCreateParamsNonStreaming,
      options?: OpenAI.RequestOptions
    ): Promise<ParsedContractAnalysisResponse>;
  };
}

export interface AnalyzeContractInput {
  contractType: ContractType;
  extractedText: string;
}

export interface ContractAnalysisAdapter {
  analyzeContract(input: AnalyzeContractInput): Promise<ContractAnalysisResult>;
}

type SafeAIErrorCode =
  | "AI_CONFIGURATION_MISSING"
  | "AI_RATE_LIMITED"
  | "AI_TIMEOUT"
  | "AI_UNAVAILABLE"
  | "AI_REFUSED"
  | "AI_OUTPUT_INVALID";

const safeErrorDefinitions: Record<
  SafeAIErrorCode,
  { statusCode: number; message: string }
> = {
  AI_CONFIGURATION_MISSING: {
    statusCode: 503,
    message: "AI analysis is not configured on the server."
  },
  AI_RATE_LIMITED: {
    statusCode: 429,
    message: "AI analysis is temporarily rate limited."
  },
  AI_TIMEOUT: {
    statusCode: 504,
    message: "AI analysis timed out."
  },
  AI_UNAVAILABLE: {
    statusCode: 503,
    message: "AI analysis is temporarily unavailable."
  },
  AI_REFUSED: {
    statusCode: 422,
    message: "AI analysis could not process this document."
  },
  AI_OUTPUT_INVALID: {
    statusCode: 502,
    message: "AI analysis returned an invalid result."
  }
};

function createSafeAIError(code: SafeAIErrorCode): ApiError {
  const definition = safeErrorDefinitions[code];

  return new ApiError(definition.statusCode, code, definition.message);
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function hasModelRefusal(response: ParsedContractAnalysisResponse): boolean {
  if (!Array.isArray(response.output)) {
    return false;
  }

  return response.output.some((outputItem) => {
    if (!isRecord(outputItem) || !Array.isArray(outputItem.content)) {
      return false;
    }

    return outputItem.content.some(
      (contentItem) =>
        isRecord(contentItem) && contentItem.type === "refusal"
    );
  });
}

function mapOpenAIError(error: unknown): ApiError {
  if (
    error instanceof ApiError &&
    error.code === "AI_CONFIGURATION_MISSING"
  ) {
    return createSafeAIError("AI_CONFIGURATION_MISSING");
  }

  if (!isRecord(error)) {
    return createSafeAIError("AI_UNAVAILABLE");
  }

  const status = typeof error.status === "number" ? error.status : undefined;
  const errorName = typeof error.name === "string" ? error.name : "";
  const errorCode = typeof error.code === "string" ? error.code : "";

  if (status === 429) {
    return createSafeAIError("AI_RATE_LIMITED");
  }

  if (
    errorName === "APIConnectionTimeoutError" ||
    errorName === "AbortError" ||
    errorCode === "ETIMEDOUT"
  ) {
    return createSafeAIError("AI_TIMEOUT");
  }

  if (status === 401 || status === 403) {
    return createSafeAIError("AI_CONFIGURATION_MISSING");
  }

  if (
    (status !== undefined && status >= 500) ||
    errorName === "APIConnectionError" ||
    error instanceof TypeError
  ) {
    return createSafeAIError("AI_UNAVAILABLE");
  }

  return createSafeAIError("AI_UNAVAILABLE");
}

export function createContractAnalysisAdapter(
  client: ContractAnalysisOpenAIClient = createOpenAIClient()
): ContractAnalysisAdapter {
  return {
    async analyzeContract(
      input: AnalyzeContractInput
    ): Promise<ContractAnalysisResult> {
      const prompt = buildContractAnalysisPrompt(input);
      let response: ParsedContractAnalysisResponse;

      try {
        response = await client.responses.parse(
          {
            model: env.OPENAI_MODEL,
            input: [
              {
                role: "developer",
                content: prompt.developerInstructions
              },
              {
                role: "user",
                content: prompt.userContent
              }
            ],
            text: {
              format: zodTextFormat(
                contractAnalysisStructuredOutputSchema,
                RESPONSE_FORMAT_NAME
              )
            },
            store: false,
            max_output_tokens: MAX_OUTPUT_TOKENS
          },
          {
            timeout: env.OPENAI_REQUEST_TIMEOUT_MS,
            maxRetries: MAX_SDK_RETRIES
          }
        );
      } catch (error) {
        throw mapOpenAIError(error);
      }

      if (response.output_parsed === null) {
        if (hasModelRefusal(response)) {
          throw createSafeAIError("AI_REFUSED");
        }

        throw createSafeAIError("AI_OUTPUT_INVALID");
      }

      try {
        return validateContractAnalysisResult(response.output_parsed);
      } catch {
        throw createSafeAIError("AI_OUTPUT_INVALID");
      }
    }
  };
}

export async function analyzeContract(
  input: AnalyzeContractInput
): Promise<ContractAnalysisResult> {
  return createContractAnalysisAdapter().analyzeContract(input);
}
