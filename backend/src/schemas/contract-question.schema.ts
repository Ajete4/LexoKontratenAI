import { z } from "zod";

export const contractQuestionRequestSchema = z.object({
  body: z.object({
    question: z.string().min(1).max(1_000).refine((value) => value.trim().length > 0)
  }).strict(),
  params: z.object({
    contractId: z.string().uuid(),
    versionId: z.string().uuid()
  }).strict(),
  query: z.object({}).strict()
});

export type ContractQuestionRequest = z.infer<typeof contractQuestionRequestSchema>;
