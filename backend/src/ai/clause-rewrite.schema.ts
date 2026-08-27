import { z } from "zod";

export const clauseRewriteModelOutputSchema = z.object({
  rewrittenText: z.string().trim().min(1).max(2_000)
}).strict();

export type ClauseRewriteModelOutput = z.infer<
  typeof clauseRewriteModelOutputSchema
>;

