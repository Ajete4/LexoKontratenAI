import type { SupabaseClient } from "@supabase/supabase-js";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import {
  createListRecentQuestions,
  type ListRecentQuestions
} from "../src/services/question-history.service.js";

const userId = "authenticated-user";
const accessToken = "synthetic-access-token";
const questionId = "11111111-1111-4111-8111-111111111111";
const contractId = "22222222-2222-4222-8222-222222222222";
const versionId = "33333333-3333-4333-8333-333333333333";

describe("GET /api/questions/recent", () => {
  it("requires auth and returns at most five session-owned questions", async () => {
    const listRecentQuestions = vi.fn<ListRecentQuestions>(async () => ({
      questions: [{
        id: questionId,
        contractId,
        versionId,
        question: "Si rregullohet pagesa?",
        answer: "Pagesa rregullohet sipas kontratës.",
        createdAt: "2026-08-26T10:00:00.000Z"
      }],
      monthlyCount: 7
    }));
    const app = createApp({
      authMiddleware: createRequireAuth(async (token) => token === accessToken ? userId : null),
      listRecentQuestions
    });

    const denied = await request(app).get("/api/questions/recent");
    const response = await request(app)
      .get("/api/questions/recent")
      .set("Authorization", `Bearer ${accessToken}`);

    expect(denied.status).toBe(401);
    expect(response.status).toBe(200);
    expect(response.body.data.questions).toHaveLength(1);
    expect(response.body.data.monthlyCount).toBe(7);
    expect(listRecentQuestions).toHaveBeenCalledWith({ userId, accessToken });
  });
});

describe("question history service", () => {
  it("uses a user-scoped client, owner filter, descending order and fixed limit", async () => {
    const limit = vi.fn(async () => ({
      data: [{
        id: questionId,
        contract_id: contractId,
        version_id: versionId,
        question: "Si rregullohet pagesa?",
        answer: "Pagesa rregullohet sipas kontratës.",
        created_at: "2026-08-26T10:00:00.000Z"
      }],
      error: null
    }));
    const recentOrder = vi.fn(() => ({ limit }));
    const recentEq = vi.fn(() => ({ order: recentOrder }));
    const recentSelect = vi.fn(() => ({ eq: recentEq }));
    const countLt = vi.fn(async () => ({ data: null, error: null, count: 7 }));
    const countGte = vi.fn(() => ({ lt: countLt }));
    const countEq = vi.fn(() => ({ gte: countGte }));
    const countSelect = vi.fn(() => ({ eq: countEq }));
    const from = vi.fn()
      .mockReturnValueOnce({ select: recentSelect })
      .mockReturnValueOnce({ select: countSelect });
    const createUserClient = vi.fn(() => ({ from }) as unknown as SupabaseClient);
    const service = createListRecentQuestions(createUserClient);

    const result = await service({ userId, accessToken });

    expect(createUserClient).toHaveBeenCalledWith(accessToken);
    expect(from).toHaveBeenCalledWith("contract_questions");
    expect(recentEq).toHaveBeenCalledWith("user_id", userId);
    expect(recentOrder).toHaveBeenCalledWith("created_at", { ascending: false });
    expect(limit).toHaveBeenCalledWith(5);
    expect(countEq).toHaveBeenCalledWith("user_id", userId);
    expect(countGte).toHaveBeenCalledWith("created_at", expect.any(String));
    expect(countLt).toHaveBeenCalledWith("created_at", expect.any(String));
    expect(result.monthlyCount).toBe(7);
    expect(result.questions[0]).toEqual(expect.objectContaining({ contractId, versionId }));
  });

  it("maps database failures without exposing upstream details", async () => {
    const from = vi.fn()
      .mockReturnValueOnce({
        select: () => ({
          eq: () => ({
            order: () => ({
              limit: async () => ({ data: null, error: { message: "private SQL detail" } })
            })
          })
        })
      })
      .mockReturnValueOnce({
        select: () => ({
          eq: () => ({
            gte: () => ({
              lt: async () => ({ data: null, error: null, count: 0 })
            })
          })
        })
      });
    const client = { from } as unknown as SupabaseClient;

    await expect(createListRecentQuestions(() => client)({ userId, accessToken }))
      .rejects.toMatchObject({
        statusCode: 503,
        code: "QUESTION_HISTORY_UNAVAILABLE"
      });
  });
});
