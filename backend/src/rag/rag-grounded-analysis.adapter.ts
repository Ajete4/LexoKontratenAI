import type OpenAI from "openai";
import { zodTextFormat } from "openai/helpers/zod";

import { env } from "../config/env.js";
import { ApiError } from "../utils/ApiError.js";
import { groundedFindingSchema } from "./rag-evidence.schema.js";
import type { buildGroundedClausePrompt } from "./rag-prompt.js";

const RESPONSE_FORMAT_NAME = "grounded_clause_analysis";
const MAX_OUTPUT_TOKENS = 1_500;

type Prompt = ReturnType<typeof buildGroundedClausePrompt>;

export interface GroundedAnalysisClient {
  responses: {
    parse(
      body: OpenAI.Responses.ResponseCreateParamsNonStreaming,
      options?: OpenAI.RequestOptions
    ): Promise<{ output_parsed: unknown | null }>;
  };
}

export function createGroundedAnalysisAdapter(client: GroundedAnalysisClient) {
  return async (prompt: Prompt): Promise<unknown> => {
    let response: { output_parsed: unknown | null };

    try {
      response = await client.responses.parse({
        model: env.OPENAI_MODEL,
        input: [
          { role: "developer", content: prompt.developerInstructions },
          { role: "user", content: prompt.userContent }
        ],
        text: {
          format: zodTextFormat(groundedFindingSchema, RESPONSE_FORMAT_NAME)
        },
        store: false,
        max_output_tokens: MAX_OUTPUT_TOKENS
      }, {
        timeout: env.OPENAI_REQUEST_TIMEOUT_MS,
        maxRetries: 0
      });
    } catch {
      throw new ApiError(
        503,
        "RAG_GROUNDED_AI_UNAVAILABLE",
        "Grounded legal analysis is temporarily unavailable."
      );
    }

    if (response.output_parsed === null) {
      throw new ApiError(
        502,
        "RAG_AI_OUTPUT_INVALID",
        "Grounded analysis returned an invalid result."
      );
    }

    return response.output_parsed;
  };
}
