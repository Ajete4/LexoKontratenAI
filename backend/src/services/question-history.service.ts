import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import { createUserSupabaseClient } from "../config/supabase.js";
import { ApiError } from "../utils/ApiError.js";

const questionHistoryRowSchema = z.object({
  id: z.string().uuid(),
  contract_id: z.string().uuid(),
  version_id: z.string().uuid(),
  question: z.string().min(1).max(1_000),
  answer: z.string().min(1).max(4_000),
  created_at: z.string().datetime({ offset: true })
}).strict();

const questionHistoryRowsSchema = z.array(questionHistoryRowSchema).max(5);

export type RecentQuestion = {
  id: string;
  contractId: string;
  versionId: string;
  question: string;
  answer: string;
  createdAt: string;
};

export type RecentQuestionHistory = {
  questions: RecentQuestion[];
  monthlyCount: number;
};

export type ListRecentQuestions = (input: {
  userId: string;
  accessToken: string;
}) => Promise<RecentQuestionHistory>;

export function createListRecentQuestions(
  createUserClient: (accessToken: string) => SupabaseClient = createUserSupabaseClient
): ListRecentQuestions {
  return async ({ userId, accessToken }) => {
    const client = createUserClient(accessToken);
    const now = new Date();
    const monthStart = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1));
    const nextMonthStart = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1));

    const [recentResult, countResult] = await Promise.all([
      client
        .from("contract_questions")
        .select("id, contract_id, version_id, question, answer, created_at")
        .eq("user_id", userId)
        .order("created_at", { ascending: false })
        .limit(5),
      client
        .from("contract_questions")
        .select("id", { count: "exact", head: true })
        .eq("user_id", userId)
        .gte("created_at", monthStart.toISOString())
        .lt("created_at", nextMonthStart.toISOString())
    ]);

    if (recentResult.error || countResult.error || countResult.count === null) {
      throw new ApiError(
        503,
        "QUESTION_HISTORY_UNAVAILABLE",
        "Historiku i pyetjeve është përkohësisht i padisponueshëm."
      );
    }

    const rows = questionHistoryRowsSchema.safeParse(recentResult.data);
    if (!rows.success) {
      throw new ApiError(
        503,
        "QUESTION_HISTORY_RESPONSE_INVALID",
        "Historiku i pyetjeve nuk ishte valid."
      );
    }

    return {
      questions: rows.data.map((row) => ({
        id: row.id,
        contractId: row.contract_id,
        versionId: row.version_id,
        question: row.question,
        answer: row.answer,
        createdAt: row.created_at
      })),
      monthlyCount: countResult.count
    };
  };
}

export const listRecentQuestions = createListRecentQuestions();
