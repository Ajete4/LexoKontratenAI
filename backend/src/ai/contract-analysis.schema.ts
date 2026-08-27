import { z } from "zod";

export const CONTRACT_ANALYSIS_DISCLAIMER =
  "Ky rezultat ofron informacion të përgjithshëm dhe nuk përbën këshillë juridike. Për vendime ose raste konkrete, konsultohuni me një profesionist juridik të kualifikuar.";

export const contractTypeSchema = z.enum([
  "employment",
  "service",
  "lease"
]);

const nullableLimitedString = (maximumLength: number) =>
  z.string().max(maximumLength).nullable();

const partySchema = z
  .object({
    role: z.string().min(1).max(100),
    name: nullableLimitedString(200),
    description: nullableLimitedString(500)
  })
  .strict();

const keyDateSchema = z
  .object({
    label: z.string().min(1).max(100),
    date: nullableLimitedString(50),
    description: nullableLimitedString(500)
  })
  .strict();

const titledDescriptionSchema = (titleMaximumLength: number) =>
  z
    .object({
      title: z.string().min(1).max(titleMaximumLength),
      description: z.string().min(1).max(1_000)
    })
    .strict();

export const contractAnalysisClauseSchema = z
  .object({
    position: z.number().int().min(1).max(30),
    clauseType: z.enum([
      "parties",
      "subject",
      "obligations",
      "duration",
      "payment",
      "penalty",
      "termination",
      "jurisdiction",
      "confidentiality",
      "liability",
      "data_protection",
      "dispute_resolution",
      "other"
    ]),
    findingType: z.enum([
      "normal",
      "risky",
      "imbalanced",
      "missing",
      "ambiguous"
    ]),
    title: z.string().min(1).max(200),
    originalText: nullableLimitedString(1_500),
    simplifiedText: nullableLimitedString(1_000),
    severity: z.enum([
      "none",
      "low",
      "medium",
      "high",
      "critical",
      "review_required"
    ]),
    favoredParty: z.enum([
      "party_a",
      "party_b",
      "balanced",
      "unclear",
      "not_applicable"
    ]),
    riskExplanation: nullableLimitedString(1_500),
    suggestedAction: nullableLimitedString(1_000),
    suggestedRewrite: nullableLimitedString(2_000),
    confidence: z.number().min(0).max(1),
    requiresProfessionalReview: z.boolean()
  })
  .strict();

/**
 * Base schema passed to zodTextFormat. Cross-field rules are intentionally
 * applied by contractAnalysisResultSchema after the model output is parsed.
 */
export const contractAnalysisStructuredOutputSchema = z
  .object({
    language: z.enum(["sq", "en", "mixed", "unknown"]),
    contractType: contractTypeSchema,
    title: z.string().min(1).max(200),
    summary: z.string().min(1).max(2_000),
    parties: z.array(partySchema).max(10),
    keyDates: z.array(keyDateSchema).max(20),
    paymentTerms: z.array(titledDescriptionSchema(150)).max(20),
    terminationTerms: z.array(titledDescriptionSchema(150)).max(10),
    overallRiskLevel: z.enum([
      "low",
      "medium",
      "high",
      "critical",
      "unknown"
    ]),
    overallRiskExplanation: z.string().min(1).max(1_500),
    missingInformation: z.array(z.string().min(1).max(500)).max(20),
    professionalReviewRecommended: z.boolean(),
    clauses: z.array(contractAnalysisClauseSchema).max(30),
    disclaimer: z.literal(CONTRACT_ANALYSIS_DISCLAIMER)
  })
  .strict();

export const contractAnalysisResultSchema =
  contractAnalysisStructuredOutputSchema.superRefine((result, context) => {
    result.clauses.forEach((clause, index) => {
      const expectedPosition = index + 1;

      if (clause.position !== expectedPosition) {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          message: `Clause position must be ${expectedPosition}.`,
          path: ["clauses", index, "position"]
        });
      }

      if (clause.findingType === "missing") {
        if (clause.originalText !== null) {
          context.addIssue({
            code: z.ZodIssueCode.custom,
            message: "A missing clause must have null originalText.",
            path: ["clauses", index, "originalText"]
          });
        }

        if (clause.severity === "none") {
          context.addIssue({
            code: z.ZodIssueCode.custom,
            message: "A missing clause cannot have severity none.",
            path: ["clauses", index, "severity"]
          });
        }

        return;
      }

      if (
        clause.originalText === null ||
        clause.originalText.trim().length === 0
      ) {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          message: "A non-missing clause must have non-empty originalText.",
          path: ["clauses", index, "originalText"]
        });
      }
    });
  });

export type ContractType = z.infer<typeof contractTypeSchema>;
export type ContractAnalysisResult = z.infer<
  typeof contractAnalysisResultSchema
>;

export function validateContractAnalysisResult(
  value: unknown
): ContractAnalysisResult {
  return contractAnalysisResultSchema.parse(value);
}
