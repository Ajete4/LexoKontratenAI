import { z } from "zod";

import {
  emptyBodySchema,
  emptyParamsSchema
} from "./common.schema.js";

export const contractStatuses = [
  "draft",
  "uploaded",
  "processing",
  "analyzed",
  "failed",
  "archived"
] as const;

export const contractTypes = [
  "service",
  "employment",
  "lease"
] as const;

export const listContractsRequestSchema = z.object({
  body: emptyBodySchema,
  params: emptyParamsSchema,
  query: z
    .object({
      status: z.enum(contractStatuses).optional(),
      contractType: z.enum(contractTypes).optional(),
      search: z.string().trim().min(1).max(200).optional(),
      limit: z.coerce.number().int().min(1).max(100).default(50)
    })
    .strict()
});

export const createContractRequestSchema = z.object({
  body: z
    .object({
      title: z.string().trim().min(1).max(200),
      contractType: z.enum(contractTypes)
    })
    .strict(),
  params: emptyParamsSchema,
  query: z.object({}).strict()
});

export type ListContractsQuery = z.infer<
  typeof listContractsRequestSchema
>["query"];

export type CreateContractInput = z.infer<
  typeof createContractRequestSchema
>["body"];

export type ContractStatus = (typeof contractStatuses)[number];
export type ContractType = (typeof contractTypes)[number];
