import OpenAI from "openai";

import { env } from "../config/env.js";
import { ApiError } from "../utils/ApiError.js";
import { OPENAI_MAX_RETRIES } from "./analysis-config.js";

interface OpenAIClientConfiguration {
  apiKey?: string;
  timeoutMs: number;
}

function getEnvironmentConfiguration(): OpenAIClientConfiguration {
  return {
    apiKey: env.OPENAI_API_KEY,
    timeoutMs: env.OPENAI_REQUEST_TIMEOUT_MS
  };
}

export function createOpenAIClient(
  configuration: OpenAIClientConfiguration = getEnvironmentConfiguration()
): OpenAI {
  if (!configuration.apiKey) {
    throw new ApiError(
      503,
      "AI_CONFIGURATION_MISSING",
      "AI analysis is not configured on the server."
    );
  }

  return new OpenAI({
    apiKey: configuration.apiKey,
    timeout: configuration.timeoutMs,
    maxRetries: OPENAI_MAX_RETRIES
  });
}
