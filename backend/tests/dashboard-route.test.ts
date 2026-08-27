import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import type { GetDashboard } from "../src/services/dashboard.service.js";
import type { ListContracts } from "../src/services/contracts.service.js";
import { ApiError } from "../src/utils/ApiError.js";

const userId = "authenticated-user";
const accessToken = "verified-placeholder-token";

function createDashboard() {
  return {
    stats: {
      completedAnalyses: 1,
      criticalClauses: 0,
      professionalReviewClauses: 2,
      qaQuestions: 0 as const
    },
    recentContracts: [],
    recentReviews: []
  };
}

function createHarness(getDashboard: GetDashboard = vi.fn(async () => createDashboard())) {
  const verifyToken = vi.fn(async (token: string) =>
    token === accessToken ? userId : null
  );
  const app = createApp({
    authMiddleware: createRequireAuth(verifyToken),
    getDashboard,
    getContracts: vi.fn<ListContracts>(async () => [])
  });

  return { app, getDashboard, verifyToken };
}

describe("GET /api/dashboard", () => {
  it("requires valid authentication", async () => {
    const context = createHarness();

    const missing = await request(context.app).get("/api/dashboard");
    const invalid = await request(context.app)
      .get("/api/dashboard")
      .set("Authorization", "Bearer invalid-placeholder");

    expect(missing.status).toBe(401);
    expect(invalid.status).toBe(401);
    expect(context.getDashboard).not.toHaveBeenCalled();
  });

  it("passes only authenticated identity to the service", async () => {
    const context = createHarness();
    const response = await request(context.app)
      .get("/api/dashboard")
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(200);
    expect(context.getDashboard).toHaveBeenCalledWith({ userId, accessToken });
    expect(response.body).toEqual({ data: { dashboard: createDashboard() } });
  });

  it("rejects query parameters and a non-empty body", async () => {
    const context = createHarness();
    const queryResponse = await request(context.app)
      .get("/api/dashboard?ownerId=untrusted")
      .set("Authorization", `Bearer ${accessToken}`);
    const bodyResponse = await request(context.app)
      .get("/api/dashboard")
      .set("Authorization", `Bearer ${accessToken}`)
      .send({ userId: "untrusted" });

    expect(queryResponse.status).toBe(400);
    expect(bodyResponse.status).toBe(400);
    expect(context.getDashboard).not.toHaveBeenCalled();
  });

  it("preserves the safe database error response", async () => {
    const getDashboard = vi.fn<GetDashboard>(async () => {
      throw new ApiError(
        503,
        "DATABASE_UNAVAILABLE",
        "Dashboard data is temporarily unavailable."
      );
    });
    const context = createHarness(getDashboard);
    const response = await request(context.app)
      .get("/api/dashboard")
      .set("Authorization", `Bearer ${accessToken}`);

    expect(response.status).toBe(503);
    expect(response.body).toEqual({
      error: {
        code: "DATABASE_UNAVAILABLE",
        message: "Dashboard data is temporarily unavailable.",
        details: null
      }
    });
  });

  it("keeps existing endpoints registered", async () => {
    const context = createHarness();
    const health = await request(context.app).get("/api/health");
    const contracts = await request(context.app)
      .get("/api/contracts")
      .set("Authorization", `Bearer ${accessToken}`);

    expect(health.status).toBe(200);
    expect(contracts.status).not.toBe(404);
  });
});
