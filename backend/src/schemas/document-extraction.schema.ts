import { z } from "zod";

import { emptyBodySchema } from "./common.schema.js";

export const extractDocumentRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: z
    .object({
      contractId: z.string().uuid(),
      versionId: z.string().uuid()
    })
    .strict(),
  query: z.object({}).strict()
});

export type ExtractDocumentParams = z.infer<
  typeof extractDocumentRequestSchema
>["params"];
