import { Router, type RequestHandler } from "express";

import { createQuestionHistoryController } from "../controllers/question-history.controller.js";
import { requireAuth } from "../middleware/auth.js";
import {
  listRecentQuestions,
  type ListRecentQuestions
} from "../services/question-history.service.js";

type QuestionHistoryRouterDependencies = {
  authMiddleware?: RequestHandler;
  listRecentQuestions?: ListRecentQuestions;
};

export function createQuestionHistoryRouter(
  dependencies: QuestionHistoryRouterDependencies = {}
) {
  const router = Router();

  router.get(
    "/recent",
    dependencies.authMiddleware ?? requireAuth,
    createQuestionHistoryController(
      dependencies.listRecentQuestions ?? listRecentQuestions
    )
  );

  return router;
}

