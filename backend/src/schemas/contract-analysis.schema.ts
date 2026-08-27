import { z } from "zod";

import { emptyBodySchema } from "./common.schema.js";

export const analyzeContractRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: z
    .object({
      contractId: z.string().uuid(),
      versionId: z.string().uuid()
    })
    .strict(),
  query: z.object({}).strict()
});

export const getContractAnalysisRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: z
    .object({
      contractId: z.string().uuid(),
      versionId: z.string().uuid()
    })
    .strict(),
  query: z.object({}).strict()
});

export const getLatestAnalysisRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: z.object({}).strict(),
  query: z.object({}).strict()
});

export const getLatestContractAnalysisRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: z
    .object({
      contractId: z.string().uuid()
    })
    .strict(),
  query: z.object({}).strict()
});

export type AnalyzeContractParams = z.infer<
  typeof analyzeContractRequestSchema
>["params"];

export type GetContractAnalysisParams = z.infer<
  typeof getContractAnalysisRequestSchema
>["params"];

export type GetLatestContractAnalysisParams = z.infer<
  typeof getLatestContractAnalysisRequestSchema
>["params"];
