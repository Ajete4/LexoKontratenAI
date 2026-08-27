import { beforeEach, describe, expect, it, vi } from "vitest";

vi.hoisted(() => {
  process.env.DOTENV_CONFIG_PATH = "NUL";
  process.env.OPENAI_API_KEY = "";
});

import {
  type ContractAnalysisOpenAIClient,
  analyzeContract,
  createContractAnalysisAdapter
} from "../src/ai/contract-analysis.adapter.js";
import { CONTRACT_ANALYSIS_DISCLAIMER } from "../src/ai/contract-analysis.schema.js";
import { env } from "../src/config/env.js";

function createValidResult() {
  return {
    language: "sq",
    contractType: "service",
    title: "Marrëveshje shërbimi",
    summary: "Përmbledhje e përgjithshme e marrëveshjes.",
    parties: [],
    keyDates: [],
    paymentTerms: [],
    terminationTerms: [],
    overallRiskLevel: "low",
    overallRiskExplanation: "Nuk u identifikua rrezik i lartë.",
    missingInformation: [],
    professionalReviewRecommended: false,
    clauses: [
      {
        position: 1,
        clauseType: "subject",
        findingType: "normal",
        title: "Objekti",
        originalText: "Ofruesi do të kryejë shërbimin.",
        simplifiedText: "Përcaktohet shërbimi.",
        severity: "none",
        favoredParty: "balanced",
        riskExplanation: null,
        suggestedAction: null,
        suggestedRewrite: null,
        confidence: 0.95,
        requiresProfessionalReview: false
      }
    ],
    disclaimer: CONTRACT_ANALYSIS_DISCLAIMER
  };
}

function createMockClient(response: unknown) {
  const parse = vi.fn().mockResolvedValue(response);
  const client = {
    responses: { parse }
  } as unknown as ContractAnalysisOpenAIClient;

  return { client, parse };
}

function createRejectingClient(error: unknown) {
  const parse = vi.fn().mockRejectedValue(error);
  const client = {
    responses: { parse }
  } as unknown as ContractAnalysisOpenAIClient;

  return { client, parse };
}

const analysisInput = {
  contractType: "service" as const,
  extractedText: "Tekst sintetik i kontratës."
};

describe("contract analysis adapter", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("uses the backend model, privacy settings, limits, and separated roles", async () => {
    const result = createValidResult();
    const { client, parse } = createMockClient({
      output_parsed: result,
      output: []
    });

    await createContractAnalysisAdapter(client).analyzeContract(analysisInput);

    expect(parse).toHaveBeenCalledTimes(1);
    const [request, options] = parse.mock.calls[0]!;

    expect(request).toMatchObject({
      model: env.OPENAI_MODEL,
      store: false,
      max_output_tokens: 6_000
    });
    expect(options).toEqual({
      timeout: env.OPENAI_REQUEST_TIMEOUT_MS,
      maxRetries: 1
    });
    expect(request.input).toEqual([
      expect.objectContaining({ role: "developer" }),
      expect.objectContaining({ role: "user" })
    ]);

    const developerMessage = request.input[0];
    const userMessage = request.input[1];
    expect(JSON.stringify(developerMessage)).not.toContain(
      analysisInput.extractedText
    );
    expect(JSON.stringify(userMessage)).toContain(analysisInput.extractedText);
    expect(JSON.stringify(userMessage)).toContain(
      "UNTRUSTED_CONTRACT_CONTENT_START"
    );
    expect(JSON.stringify(userMessage)).toContain(
      "UNTRUSTED_CONTRACT_CONTENT_END"
    );
    expect(JSON.stringify(request)).not.toContain("userId");
    expect(JSON.stringify(request)).not.toContain("storagePath");
  });

  it("returns only the locally validated parsed result", async () => {
    const parsedResult = createValidResult();
    const { client } = createMockClient({
      output_parsed: parsedResult,
      output: [],
      rawSecret: "must-not-be-returned"
    });

    const result = await createContractAnalysisAdapter(client).analyzeContract(
      analysisInput
    );

    expect(result).toEqual(parsedResult);
    expect(result).not.toHaveProperty("rawSecret");
  });

  it("maps refusal without exposing refusal text or retrying", async () => {
    const refusalText = "Sensitive refusal explanation";
    const { client, parse } = createMockClient({
      output_parsed: null,
      output: [
        {
          type: "message",
          content: [{ type: "refusal", refusal: refusalText }]
        }
      ]
    });

    const promise = createContractAnalysisAdapter(client).analyzeContract(
      analysisInput
    );

    await expect(promise).rejects.toMatchObject({ code: "AI_REFUSED" });
    await expect(promise).rejects.not.toHaveProperty("message", refusalText);
    expect(parse).toHaveBeenCalledTimes(1);
  });

  it("maps missing parsed output to AI_OUTPUT_INVALID", async () => {
    const { client } = createMockClient({ output_parsed: null, output: [] });

    await expect(
      createContractAnalysisAdapter(client).analyzeContract(analysisInput)
    ).rejects.toMatchObject({ code: "AI_OUTPUT_INVALID" });
  });

  it("rejects an invalid enum after parsing without retrying", async () => {
    const invalidResult = { ...createValidResult(), language: "de" };
    const { client, parse } = createMockClient({
      output_parsed: invalidResult,
      output: []
    });

    await expect(
      createContractAnalysisAdapter(client).analyzeContract(analysisInput)
    ).rejects.toMatchObject({ code: "AI_OUTPUT_INVALID" });
    expect(parse).toHaveBeenCalledTimes(1);
  });

  it("rejects invalid cross-field output after parsing", async () => {
    const invalidResult = createValidResult();
    invalidResult.clauses[0]!.findingType = "missing";
    const { client, parse } = createMockClient({
      output_parsed: invalidResult,
      output: []
    });

    await expect(
      createContractAnalysisAdapter(client).analyzeContract(analysisInput)
    ).rejects.toMatchObject({ code: "AI_OUTPUT_INVALID" });
    expect(parse).toHaveBeenCalledTimes(1);
  });

  it.each([
    [{ status: 429 }, "AI_RATE_LIMITED"],
    [{ name: "APIConnectionTimeoutError" }, "AI_TIMEOUT"],
    [{ name: "AbortError" }, "AI_TIMEOUT"],
    [new TypeError("synthetic network failure"), "AI_UNAVAILABLE"],
    [{ status: 503 }, "AI_UNAVAILABLE"],
    [{ status: 401 }, "AI_CONFIGURATION_MISSING"]
  ])("maps upstream failures to a safe error", async (error, code) => {
    const { client, parse } = createRejectingClient(error);

    await expect(
      createContractAnalysisAdapter(client).analyzeContract(analysisInput)
    ).rejects.toMatchObject({ code });
    expect(parse).toHaveBeenCalledTimes(1);
  });

  it("uses one SDK retry and no manual retry loop", async () => {
    const { client, parse } = createRejectingClient({ status: 503 });

    await expect(
      createContractAnalysisAdapter(client).analyzeContract(analysisInput)
    ).rejects.toMatchObject({ code: "AI_UNAVAILABLE" });

    expect(parse).toHaveBeenCalledTimes(1);
    expect(parse.mock.calls[0]![1]).toMatchObject({ maxRetries: 1 });
  });

  it("reports missing backend configuration without making a request", async () => {
    expect(env.OPENAI_API_KEY).toBeUndefined();

    await expect(analyzeContract(analysisInput)).rejects.toMatchObject({
      code: "AI_CONFIGURATION_MISSING"
    });
  });

  it("does not expose API keys or contract text in safe errors", async () => {
    const syntheticApiKey = "sk-test-placeholder-not-real";
    const sensitiveError = {
      status: 500,
      message: `upstream failed for ${analysisInput.extractedText}`,
      apiKey: syntheticApiKey
    };
    const { client } = createRejectingClient(sensitiveError);
    const consoleError = vi.spyOn(console, "error").mockImplementation(() => {});
    const consoleLog = vi.spyOn(console, "log").mockImplementation(() => {});

    let thrownError: unknown;

    try {
      await createContractAnalysisAdapter(client).analyzeContract(analysisInput);
    } catch (error) {
      thrownError = error;
    }

    const serializedError = JSON.stringify(thrownError);
    expect(serializedError).not.toContain(analysisInput.extractedText);
    expect(serializedError).not.toContain(syntheticApiKey);
    expect(consoleError).not.toHaveBeenCalled();
    expect(consoleLog).not.toHaveBeenCalled();

    consoleError.mockRestore();
    consoleLog.mockRestore();
  });
});
