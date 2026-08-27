import { z } from "zod";

import { emptyBodySchema } from "./common.schema.js";

const contractVersionParamsSchema = z
  .object({
    contractId: z.string().uuid(),
    versionId: z.string().uuid()
  })
  .strict();

export const getContractNotesRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: contractVersionParamsSchema,
  query: z.object({}).strict()
});

export const saveContractNotesRequestSchema = z.object({
  body: z
    .object({
      notes: z.string().max(10_000),
      checklist: z.array(z.boolean()).length(6)
    })
    .strict(),
  params: contractVersionParamsSchema,
  query: z.object({}).strict()
});

export type GetContractNotesRequest = z.infer<
  typeof getContractNotesRequestSchema
>;

export type SaveContractNotesRequest = z.infer<
  typeof saveContractNotesRequestSchema
>;
