import { Router, type RequestHandler } from "express";

import { createListLegalSourcesController } from "../controllers/legal-sources.controller.js";
import { requireAuth } from "../middleware/auth.js";
import { validate } from "../middleware/validate.js";
import { listLegalSourcesRequestSchema } from "../schemas/legal-sources.schema.js";
import {
  listLegalSources,
  type ListLegalSources
} from "../services/legal-sources.service.js";

type LegalSourcesRouterDependencies = {
  authMiddleware?: RequestHandler;
  listLegalSources?: ListLegalSources;
};

export function createLegalSourcesRouter(
  dependencies: LegalSourcesRouterDependencies = {}
) {
  const router = Router();

  router.get(
    "/",
    dependencies.authMiddleware ?? requireAuth,
    validate(listLegalSourcesRequestSchema),
    createListLegalSourcesController(
      dependencies.listLegalSources ?? listLegalSources
    )
  );

  return router;
}
