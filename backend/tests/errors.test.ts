import request from "supertest";
import { describe, expect, it } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import type { ListContracts } from "../src/services/contracts.service.js";

describe("API errors", () => {
  it("returns a standardized 404", async () => {
    const response = await request(createApp()).get("/api/unknown-route");

    expect(response.status).toBe(404);
    expect(response.body.error.code).toBe("ROUTE_NOT_FOUND");
    expect(response.body.error.details).toBeNull();
  });

  it("does not expose internal errors", async () => {
    const getContracts: ListContracts = async () => {
      throw new Error("sensitive internal database detail");
    };
    const app = createApp({
      authMiddleware: createRequireAuth(async () => "user-a"),
      getContracts
    });
    const response = await request(app)
      .get("/api/contracts")
      .set("Authorization", "Bearer valid-test-value");
    const serializedBody = JSON.stringify(response.body);

    expect(response.status).toBe(500);
    expect(response.body.error).toEqual({
      code: "INTERNAL_SERVER_ERROR",
      message: "Ndodhi një gabim i papritur në server.",
      details: null
    });
    expect(serializedBody).not.toContain("database detail");
    expect(serializedBody).not.toContain("stack");
  });
});
