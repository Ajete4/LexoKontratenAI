import { z } from "zod";

import { emptyBodySchema, emptyParamsSchema } from "./common.schema.js";

export const listLegalSourcesRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: emptyParamsSchema,
  query: z.object({}).strict()
});
