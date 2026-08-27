import { Router } from "express";

import {
  createGetDatabaseHealth,
  getHealth,
  type DatabaseHealthCheck
} from "../controllers/health.controller.js";

export function createHealthRouter(
  checkDatabase?: DatabaseHealthCheck
) {
  const router = Router();

  router.get("/health", getHealth);
  router.get("/health/database", createGetDatabaseHealth(checkDatabase));

  return router;
}
