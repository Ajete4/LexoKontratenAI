import { z } from "zod";

const severitySchema = z.enum([
  "none", "low", "medium", "high", "critical", "review_required"
]);

export const groundedFindingSchema = z.object({
  finding: z.string().min(1).max(1_000),
  severity: severitySchema,
  explanation: z.string().min(1).max(1_500),
  recommendation: z.string().min(1).max(1_000),
  evidenceStatus: z.enum(["grounded", "insufficient_evidence"]),
  citationIds: z.array(z.string().regex(/^C[1-5]$/u)).max(5),
  requiresProfessionalReview: z.boolean()
}).strict().superRefine((value, context) => {
  if (new Set(value.citationIds).size !== value.citationIds.length) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citationIds"], message: "Duplicate citation ID." });
  }
  if (value.evidenceStatus === "grounded" && value.citationIds.length === 0) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citationIds"], message: "Grounded output requires evidence." });
  }
  if (value.evidenceStatus === "insufficient_evidence" && value.citationIds.length !== 0) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["citationIds"], message: "Insufficient evidence cannot cite sources." });
  }
});

export type GroundedFinding = z.infer<typeof groundedFindingSchema>;
