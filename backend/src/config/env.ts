import "dotenv/config";
import { z } from "zod";

import {
  DEFAULT_OPENAI_MODEL,
  DEFAULT_OPENAI_REQUEST_TIMEOUT_MS
} from "../ai/analysis-config.js";
import { LEGAL_EMBEDDING_MODEL } from "../legal/legal-embedding-config.js";

const optionalOpenAIApiKeySchema = z.preprocess(
  (value) => {
    if (typeof value === "string" && value.trim().length === 0) {
      return undefined;
    }

    return value;
  },
  z.string().trim().min(1).optional()
);

export const envSchema = z.object({
  NODE_ENV: z
    .enum(["development", "test", "production"])
    .default("development"),

  PORT: z.coerce
    .number()
    .int()
    .positive()
    .default(5000),

  FRONTEND_URL: z
    .string()
    .url()
    .default("http://localhost:5173"),

  SUPABASE_URL: z
    .string()
    .url(),

  SUPABASE_PUBLISHABLE_KEY: z
    .string()
    .min(1),

  SUPABASE_SECRET_KEY: z
    .string()
    .startsWith("sb_secret_"),

  OPENAI_API_KEY: optionalOpenAIApiKeySchema,

  OPENAI_MODEL: z
    .string()
    .trim()
    .min(1)
    .default(DEFAULT_OPENAI_MODEL),

  OPENAI_EMBEDDING_MODEL: z
    .literal(LEGAL_EMBEDDING_MODEL)
    .default(LEGAL_EMBEDDING_MODEL),

  OPENAI_REQUEST_TIMEOUT_MS: z.coerce
    .number()
    .int()
    .positive()
    .default(DEFAULT_OPENAI_REQUEST_TIMEOUT_MS)
});

const parsedEnv = envSchema.safeParse(process.env);

if (!parsedEnv.success) {
  const missingFields = parsedEnv.error.issues
    .map((issue) => issue.path.join("."))
    .filter(Boolean)
    .join(", ");

  throw new Error(
    `Invalid backend environment configuration. Check: ${missingFields}`
  );
}

export const env = parsedEnv.data;
