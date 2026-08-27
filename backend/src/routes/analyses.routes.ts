import { Router, type RequestHandler } from "express";

import { createGetLatestAnalysisController } from "../controllers/contract-analysis.controller.js";
import { requireAuth } from "../middleware/auth.js";
import { validate } from "../middleware/validate.js";
import { getLatestAnalysisRequestSchema } from "../schemas/contract-analysis.schema.js";
import type { GetLatestAnalysis } from "../services/analysis-retrieval.service.js";

interface AnalysesRouterDependencies {
  authMiddleware?: RequestHandler;
  getLatestAnalysis: GetLatestAnalysis;
}

export function createAnalysesRouter(
  dependencies: AnalysesRouterDependencies
) {
  const router = Router();
  const authMiddleware = dependencies.authMiddleware ?? requireAuth;

  router.get(
    "/latest",
    authMiddleware,
    validate(getLatestAnalysisRequestSchema),
    createGetLatestAnalysisController(dependencies.getLatestAnalysis)
  );

  return router;
}
