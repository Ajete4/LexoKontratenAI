import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import {
  ANALYSIS_PIPELINE_VERSION,
  RAG_ANALYSIS_PIPELINE_VERSION
} from "../ai/analysis-config.js";
import {
  createClauseRewriteAdapter,
  type RewriteClauseWithAI
} from "../ai/clause-rewrite.adapter.js";
import { createOpenAIClient } from "../ai/openai-client.js";
import { createUserSupabaseClient } from "../config/supabase.js";
import type { ClauseRewriteGoal } from "../schemas/clause-rewrite.schema.js";
import { ApiError } from "../utils/ApiError.js";

export const CLAUSE_REWRITE_DISCLAIMER =
  "Ky riformulim është propozim fillestar për negocim dhe nuk zëvendëson këshillën juridike profesionale.";

const ownedContractSchema = z.object({ id: z.string().uuid() }).strict();
const ownedVersionSchema = z.object({
  id: z.string().uuid(),
  contract_id: z.string().uuid()
}).strict();
const completedAnalysisSchema = z.object({ id: z.string().uuid() }).strict();
const rewriteableClauseSchema = z.object({
  position: z.number().int().min(1).max(30),
  clause_type: z.enum([
    "parties",
    "subject",
    "obligations",
    "duration",
    "payment",
    "penalty",
    "termination",
    "jurisdiction",
    "confidentiality",
    "liability",
    "data_protection",
    "dispute_resolution",
    "other"
  ]),
  original_text: z.string().trim().min(1).max(1_500)
}).strict();

type RewriteableClause = z.infer<typeof rewriteableClauseSchema>;

const penaltyPattern =
  /\b(penalitet(?:i|et)?|penal(?:e|ja)?|d[ëe]mshp[ëe]rblim(?:i|e)?|gjob[ëe]?)\b/iu;
const deliveryPattern =
  /\b(dor[ëe]zim(?:i|et)?|dor[ëe]zo(?:het|hen|jë)?|sh[ëe]rbim(?:i|et|eve)?|rezultat(?:i|et)?|produkt(?:i|et)?|deliverable(?:s)?)\b/iu;
const protectedMeaningPatterns = [
  /\bn[ëe] momentin(?: e)?\b/iu,
  /\bme rastin e\b/iu,
  /\bpara(?: se| n[ëe]nshkrimit)?\b/iu,
  /\bpas(?:i| n[ëe]nshkrimit| dor[ëe]zimit| pranimit)?\b/iu,
  /\bbrenda\b/iu,
  /\bderi m[ëe]\b/iu,
  /\bmenj[ëe]her[ëe]\b/iu,
  /\bparaprakisht\b/iu,
  /\bme k[ëe]ste\b/iu,
  /\b(?:çdo|cdo) muaj\b/iu,
  /\bp[ëe]rmes (?:transferit|llogaris[ëe]s|bank[ëe]s)\b/iu,
  /\btransfer(?:it)? bankar\b/iu,
  /\bn[ëe] para t[ëe] gatshme\b/iu,
  /\bme fatur[ëe]\b/iu,
  /\bme kusht q[ëe]\b/iu,
  /\bn[ëe]se\b/iu,
  /\bvet[ëe]m n[ëe]se\b/iu,
  /\bp[ëe]rveç n[ëe]se\b/iu
];

function goalMatchesClause(
  goal: ClauseRewriteGoal,
  clause: RewriteableClause
): boolean {
  switch (goal) {
    case "balanced_termination":
      return clause.clause_type === "termination";
    case "softer_penalty":
      return clause.clause_type === "penalty" &&
        penaltyPattern.test(clause.original_text);
    case "clearer_payment":
      return clause.clause_type === "payment";
    case "stronger_confidentiality":
      return clause.clause_type === "confidentiality";
    case "clearer_delivery":
      return ["subject", "obligations"].includes(clause.clause_type) &&
        deliveryPattern.test(clause.original_text);
  }
}

function incompatibleGoal(): ApiError {
  return new ApiError(
    400,
    "CLAUSE_REWRITE_GOAL_INCOMPATIBLE",
    "Qëllimi i zgjedhur nuk përputhet me llojin ose përmbajtjen e klauzolës."
  );
}

function extractProtectedFacts(text: string): Set<string> {
  const facts = text.match(
    /\b\d+(?:[.,]\d+)?\s*(?:%|€|euro|eur|dit[ëe]|jav[ëe]|muaj|muajve|vit(?:e|ësh)?)?\b|\b\d{1,2}[./-]\d{1,2}[./-]\d{2,4}\b/giu
  ) ?? [];

  return new Set(
    facts.map((fact) => fact.toLocaleLowerCase("sq-AL").replace(/\s+/gu, ""))
  );
}

function introducesProtectedFacts(
  originalText: string,
  rewrittenText: string
): boolean {
  const originalFacts = extractProtectedFacts(originalText);
  const rewrittenFacts = extractProtectedFacts(rewrittenText);

  return [...rewrittenFacts].some((fact) => !originalFacts.has(fact));
}

function introducesProtectedMeaning(
  originalText: string,
  rewrittenText: string
): boolean {
  return protectedMeaningPatterns.some(
    (pattern) => pattern.test(rewrittenText) && !pattern.test(originalText)
  );
}

export type ClauseRewriteResponse = {
  clausePosition: number;
  goal: ClauseRewriteGoal;
  originalText: string;
  rewrittenText: string;
  disclaimer: typeof CLAUSE_REWRITE_DISCLAIMER;
};

export type RewriteAnalyzedClause = (input: {
  userId: string;
  accessToken: string;
  contractId: string;
  versionId: string;
  position: number;
  goal: ClauseRewriteGoal;
}) => Promise<ClauseRewriteResponse>;

function notFound(): ApiError {
  return new ApiError(
    404,
    "REWRITE_CLAUSE_NOT_FOUND",
    "Klauzola nga një analizë e përfunduar nuk u gjet."
  );
}

function unavailable(): ApiError {
  return new ApiError(
    503,
    "REWRITE_DATA_UNAVAILABLE",
    "Të dhënat e klauzolës janë përkohësisht të padisponueshme."
  );
}

export function createRewriteAnalyzedClause(dependencies: {
  createUserClient?: (accessToken: string) => SupabaseClient;
  rewriteWithAI: RewriteClauseWithAI;
}): RewriteAnalyzedClause {
  return async (input) => {
    const client = (dependencies.createUserClient ?? createUserSupabaseClient)(
      input.accessToken
    );

    const contractResult = await client
      .from("contracts")
      .select("id")
      .eq("id", input.contractId)
      .eq("owner_id", input.userId)
      .maybeSingle();
    if (contractResult.error) throw unavailable();
    if (!ownedContractSchema.safeParse(contractResult.data).success) {
      throw notFound();
    }

    const versionResult = await client
      .from("contract_versions")
      .select("id, contract_id")
      .eq("id", input.versionId)
      .eq("contract_id", input.contractId)
      .maybeSingle();
    if (versionResult.error) throw unavailable();
    if (!ownedVersionSchema.safeParse(versionResult.data).success) {
      throw notFound();
    }

    const analysisResult = await client
      .from("analyses")
      .select("id")
      .eq("contract_version_id", input.versionId)
      .eq("requested_by", input.userId)
      .in("pipeline_version", [
        RAG_ANALYSIS_PIPELINE_VERSION,
        ANALYSIS_PIPELINE_VERSION
      ])
      .eq("status", "completed")
      .order("completed_at", { ascending: false })
      .limit(1)
      .maybeSingle();
    if (analysisResult.error) throw unavailable();
    const analysis = completedAnalysisSchema.safeParse(analysisResult.data);
    if (!analysis.success) throw notFound();

    const clauseResult = await client
      .from("clauses")
      .select("position, clause_type, original_text")
      .eq("analysis_id", analysis.data.id)
      .eq("position", input.position)
      .maybeSingle();
    if (clauseResult.error) throw unavailable();
    const clause = rewriteableClauseSchema.safeParse(clauseResult.data);
    if (!clause.success) throw notFound();
    if (!goalMatchesClause(input.goal, clause.data)) {
      throw incompatibleGoal();
    }

    const rewritten = await dependencies.rewriteWithAI({
      originalText: clause.data.original_text,
      goal: input.goal
    });

    if (
      introducesProtectedFacts(
        clause.data.original_text,
        rewritten.rewrittenText
      ) ||
      introducesProtectedMeaning(
        clause.data.original_text,
        rewritten.rewrittenText
      )
    ) {
      throw new ApiError(
        502,
        "CLAUSE_REWRITE_OUTPUT_INVALID",
        "Rishkrimi shtoi fakte që nuk ekzistojnë në klauzolën origjinale."
      );
    }

    return {
      clausePosition: clause.data.position,
      goal: input.goal,
      originalText: clause.data.original_text,
      rewrittenText: rewritten.rewrittenText,
      disclaimer: CLAUSE_REWRITE_DISCLAIMER
    };
  };
}

function createProductionRewriteAnalyzedClause(): RewriteAnalyzedClause {
  return createRewriteAnalyzedClause({
    rewriteWithAI: createClauseRewriteAdapter(createOpenAIClient())
  });
}

export const rewriteAnalyzedClause: RewriteAnalyzedClause = async (input) =>
  createProductionRewriteAnalyzedClause()(input);
