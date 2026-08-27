import { Router, type RequestHandler } from "express";

import { getAuthenticatedUser } from "../controllers/auth.controller.js";
import { requireAuth } from "../middleware/auth.js";

export function createAuthRouter(
  authMiddleware: RequestHandler = requireAuth
) {
  const router = Router();

  router.get("/me", authMiddleware, getAuthenticatedUser);

  return router;
}
