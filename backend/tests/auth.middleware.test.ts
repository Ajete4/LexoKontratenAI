import express from "express";
import request from "supertest";
import { describe, expect, it } from "vitest";

import {
  createRequireAuth,
  type AuthVerifier
} from "../src/middleware/auth.js";
import { errorHandler } from "../src/middleware/errorHandler.js";

function createTestApp(verifyToken: AuthVerifier) {
  const app = express();

  app.get(
    "/protected",
    createRequireAuth(verifyToken),
    (httpRequest, response) => {
      response.status(200).json({
        userId: httpRequest.auth?.userId
      });
    }
  );
  app.use(errorHandler);

  return app;
}

describe("requireAuth", () => {
  it("returns 401 when the Authorization header is missing", async () => {
    const app = createTestApp(async () => null);
    const response = await request(app).get("/protected");

    expect(response.status).toBe(401);
    expect(response.body).toEqual({
      error: {
        code: "AUTHENTICATION_REQUIRED",
        message: "Authentication is required.",
        details: null
      }
    });
  });

  it("returns 401 for a malformed Bearer header", async () => {
    const app = createTestApp(async () => null);
    const response = await request(app)
      .get("/protected")
      .set("Authorization", "Bearer");

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
  });

  it("returns 401 when the token is invalid", async () => {
    const app = createTestApp(async () => null);
    const response = await request(app)
      .get("/protected")
      .set("Authorization", "Bearer invalid-test-value");

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("INVALID_ACCESS_TOKEN");
  });

  it("adds verified user identity to the request", async () => {
    const app = createTestApp(async () => "user-a");
    const response = await request(app)
      .get("/protected")
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ userId: "user-a" });
  });

  it("returns a safe 503 when the auth service fails", async () => {
    const app = createTestApp(async () => {
      throw new Error("internal provider failure");
    });
    const response = await request(app)
      .get("/protected")
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(503);
    expect(response.body).toEqual({
      error: {
        code: "AUTH_SERVICE_UNAVAILABLE",
        message: "Authentication service is temporarily unavailable.",
        details: null
      }
    });
    expect(JSON.stringify(response.body)).not.toContain("provider failure");
  });
});
