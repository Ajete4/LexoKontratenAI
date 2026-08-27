import { zodTextFormat } from "openai/helpers/zod";
import { describe, expect, it } from "vitest";

import {
  CONTRACT_ANALYSIS_DISCLAIMER,
  type ContractAnalysisResult,
  contractAnalysisStructuredOutputSchema,
  validateContractAnalysisResult
} from "../src/ai/contract-analysis.schema.js";

function createValidResult(): ContractAnalysisResult {
  return {
    language: "sq",
    contractType: "service",
    title: "Marrëveshje shërbimi",
    summary: "Përmbledhje e përgjithshme e marrëveshjes.",
    parties: [
      {
        role: "Ofruesi",
        name: "Pala A",
        description: null
      }
    ],
    keyDates: [],
    paymentTerms: [],
    terminationTerms: [],
    overallRiskLevel: "medium",
    overallRiskExplanation: "Disa kushte kërkojnë shqyrtim profesional.",
    missingInformation: [],
    professionalReviewRecommended: true,
    clauses: [
      {
        position: 1,
        clauseType: "payment",
        findingType: "risky",
        title: "Pagesa",
        originalText: "Pagesa kryhet sipas faturës.",
        simplifiedText: "Pagesa bëhet pas faturimit.",
        severity: "medium",
        favoredParty: "unclear",
        riskExplanation: "Afati i pagesës nuk është përcaktuar.",
        suggestedAction: "Përcaktoni afatin e pagesës.",
        suggestedRewrite: null,
        confidence: 0.9,
        requiresProfessionalReview: true
      }
    ],
    disclaimer: CONTRACT_ANALYSIS_DISCLAIMER
  };
}

function expectInvalid(value: unknown): void {
  expect(() => validateContractAnalysisResult(value)).toThrow();
}

describe("contract analysis result validation", () => {
  it("converts the base schema to an OpenAI structured text format", () => {
    const format = zodTextFormat(
      contractAnalysisStructuredOutputSchema,
      "contract_analysis"
    );

    expect(format.type).toBe("json_schema");
    expect(format.strict).toBe(true);
  });

  it("accepts a valid result", () => {
    expect(validateContractAnalysisResult(createValidResult())).toEqual(
      createValidResult()
    );
  });

  it("rejects invalid enums and additional fields", () => {
    expectInvalid({ ...createValidResult(), language: "de" });
    expectInvalid({ ...createValidResult(), unexpected: true });
  });

  it("rejects more than 30 clauses", () => {
    const clause = createValidResult().clauses[0]!;
    const clauses = Array.from({ length: 31 }, (_, index) => ({
      ...clause,
      position: index + 1
    }));

    expectInvalid({ ...createValidResult(), clauses });
  });

  it("requires clause positions to follow array order", () => {
    const result = createValidResult();
    result.clauses[0]!.position = 2;

    expectInvalid(result);
  });

  it("requires missing clauses to have null original text", () => {
    const result = createValidResult();
    result.clauses[0]!.findingType = "missing";

    expectInvalid(result);
  });

  it("rejects a missing clause with severity none", () => {
    const result = createValidResult();
    result.clauses[0]!.findingType = "missing";
    result.clauses[0]!.originalText = null;
    result.clauses[0]!.severity = "none";

    expectInvalid(result);
  });

  it.each([
    "low",
    "medium",
    "high",
    "critical",
    "review_required"
  ] as const)("accepts a missing clause with severity %s", (severity) => {
    const result = createValidResult();
    result.clauses[0]!.findingType = "missing";
    result.clauses[0]!.originalText = null;
    result.clauses[0]!.severity = severity;

    expect(validateContractAnalysisResult(result)).toEqual(result);
  });

  it("continues to allow severity none for a normal clause", () => {
    const result = createValidResult();
    result.clauses[0]!.findingType = "normal";
    result.clauses[0]!.severity = "none";

    expect(validateContractAnalysisResult(result)).toEqual(result);
  });

  it("requires non-missing clauses to have non-empty original text", () => {
    const nullTextResult = createValidResult();
    nullTextResult.clauses[0]!.originalText = null;

    const blankTextResult = createValidResult();
    blankTextResult.clauses[0]!.originalText = "   ";

    expectInvalid(nullTextResult);
    expectInvalid(blankTextResult);
  });

  it("rejects confidence outside zero through one", () => {
    const belowMinimum = createValidResult();
    belowMinimum.clauses[0]!.confidence = -0.01;

    const aboveMaximum = createValidResult();
    aboveMaximum.clauses[0]!.confidence = 1.01;

    expectInvalid(belowMinimum);
    expectInvalid(aboveMaximum);
  });

  it("requires the exact disclaimer", () => {
    expectInvalid({ ...createValidResult(), disclaimer: "Not legal advice." });
  });

  it("rejects strings and arrays over their limits", () => {
    expectInvalid({ ...createValidResult(), title: "x".repeat(201) });
    expectInvalid({
      ...createValidResult(),
      missingInformation: Array.from({ length: 21 }, () => "Mungon")
    });
  });
});
