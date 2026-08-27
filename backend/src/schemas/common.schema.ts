import { z } from "zod";

export const emptyBodySchema = z.object({}).strict();
export const emptyParamsSchema = z.object({}).strict();
