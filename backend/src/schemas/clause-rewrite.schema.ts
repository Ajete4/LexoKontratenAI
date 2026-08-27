import { z } from "zod";

export const clauseRewriteGoals = [
  "balanced_termination",
  "softer_penalty",
  "clearer_payment",
  "stronger_confidentiality",
  "clearer_delivery"
] as const;

export const clauseRewriteRequestSchema = z.object({
  body: z.object({
    goal: z.enum(clauseRewriteGoals)
  }).strict(),
  params: z.object({
    contractId: z.string().uuid(),
    versionId: z.string().uuid(),
    position: z.coerce.number().int().min(1).max(30)
  }).strict(),
  query: z.object({}).strict()
});

export type ClauseRewriteGoal = typeof clauseRewriteGoals[number];
export type ClauseRewriteRequest = z.infer<typeof clauseRewriteRequestSchema>;

