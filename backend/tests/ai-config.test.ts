import OpenAI from "openai";
import { zodTextFormat } from "openai/helpers/zod";
import { describe, expect, it } from "vitest";

import {
  ANALYSIS_PIPELINE_VERSION,
  ANALYSIS_PROMPT_VERSION,
  DEFAULT_OPENAI_MODEL,
  DEFAULT_OPENAI_REQUEST_TIMEOUT_MS
} from "../src/ai/analysis-config.js";
import { createOpenAIClient } from "../src/ai/openai-client.js";
import { env, envSchema } from "../src/config/env.js";

const validBaseEnvironment = {
  NODE_ENV: "test",
  FRONTEND_URL: "http://localhost:5173",
  SUPABASE_URL: "https://example.supabase.co",
  SUPABASE_PUBLISHABLE_KEY: "test-publishable-key",
  SUPABASE_SECRET_KEY: "sb_secret_test-only-placeholder"
};

describe("AI configuration", () => {
  it("uses the approved analysis versions and OpenAI defaults", () => {
    expect(ANALYSIS_PIPELINE_VERSION).toBe("analysis-v1");
    expect(ANALYSIS_PROMPT_VERSION).toBe("contract-analysis-v1");
    expect(env.OPENAI_MODEL).toBe(DEFAULT_OPENAI_MODEL);
    expect(env.OPENAI_REQUEST_TIMEOUT_MS).toBe(
      DEFAULT_OPENAI_REQUEST_TIMEOUT_MS
    );
  });

  it("allows startup configuration without an OpenAI API key", () => {
    const result = envSchema.safeParse({
      ...validBaseEnvironment,
      OPENAI_API_KEY: ""
    });

    expect(result.success).toBe(true);

    if (result.success) {
      expect(result.data.OPENAI_API_KEY).toBeUndefined();
    }
  });

  it("rejects an invalid OpenAI request timeout", () => {
    const result = envSchema.safeParse({
      ...validBaseEnvironment,
      OPENAI_REQUEST_TIMEOUT_MS: "invalid"
    });

    expect(result.success).toBe(false);
  });

  it("creates the client only when an API key is provided", () => {
    expect(() =>
      createOpenAIClient({
        apiKey: undefined,
        timeoutMs: DEFAULT_OPENAI_REQUEST_TIMEOUT_MS
      })
    ).toThrowError(
      expect.objectContaining({
        code: "AI_CONFIGURATION_MISSING",
        message: "AI analysis is not configured on the server."
      })
    );

    const client = createOpenAIClient({
      apiKey: "local-test-placeholder",
      timeoutMs: DEFAULT_OPENAI_REQUEST_TIMEOUT_MS
    });

    expect(client).toBeInstanceOf(OpenAI);
    expect(typeof client.responses.parse).toBe("function");
    expect(typeof zodTextFormat).toBe("function");
  });

  it("does not include an API key in the missing-configuration error", () => {
    let thrownError: unknown;

    try {
      createOpenAIClient({
        apiKey: undefined,
        timeoutMs: DEFAULT_OPENAI_REQUEST_TIMEOUT_MS
      });
    } catch (error) {
      thrownError = error;
    }

    expect(String(thrownError)).not.toContain("local-test-placeholder");
  });
});
