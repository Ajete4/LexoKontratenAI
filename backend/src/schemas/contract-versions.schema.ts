import { z } from "zod";

import { emptyBodySchema } from "./common.schema.js";

export const uploadContractVersionParamsSchema = z.object({
  body: z.unknown(),
  params: z
    .object({
      contractId: z.string().uuid()
    })
    .strict(),
  query: z.object({}).strict()
});

export const uploadContractVersionRequestSchema = z.object({
  body: emptyBodySchema,
  params: z
    .object({
      contractId: z.string().uuid()
    })
    .strict(),
  query: z.object({}).strict()
});

export type UploadContractVersionParams = z.infer<
  typeof uploadContractVersionRequestSchema
>["params"];
