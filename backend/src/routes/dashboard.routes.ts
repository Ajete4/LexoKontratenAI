import { Router, type RequestHandler } from "express";
import { z } from "zod";

import { createDashboardController } from "../controllers/dashboard.controller.js";
import { requireAuth } from "../middleware/auth.js";
import { validate } from "../middleware/validate.js";
import { emptyBodySchema, emptyParamsSchema } from "../schemas/common.schema.js";
import {
  getDashboard,
  type GetDashboard
} from "../services/dashboard.service.js";

type DashboardRouterDependencies = {
  authMiddleware?: RequestHandler;
  getDashboard?: GetDashboard;
};

const dashboardRequestSchema = z.object({
  body: z.union([emptyBodySchema, z.undefined()]),
  params: emptyParamsSchema,
  query: z.object({}).strict()
});

export function createDashboardRouter(
  dependencies: DashboardRouterDependencies = {}
) {
  const router = Router();
  const authMiddleware = dependencies.authMiddleware ?? requireAuth;

  router.get(
    "/",
    authMiddleware,
    validate(dashboardRequestSchema),
    createDashboardController(dependencies.getDashboard ?? getDashboard)
  );

  return router;
}
