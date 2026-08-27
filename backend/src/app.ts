import cors from "cors";
import express, { type RequestHandler } from "express";
import helmet from "helmet";

import { env } from "./config/env.js";
import type { DatabaseHealthCheck } from "./controllers/health.controller.js";
import { requireAuth } from "./middleware/auth.js";
import { errorHandler } from "./middleware/errorHandler.js";
import { notFound } from "./middleware/notFound.js";
import { createAuthRouter } from "./routes/auth.routes.js";
import { createAnalysesRouter } from "./routes/analyses.routes.js";
import { createContractsRouter } from "./routes/contracts.routes.js";
import { createDashboardRouter } from "./routes/dashboard.routes.js";
import { createHealthRouter } from "./routes/health.routes.js";
import { createLegalSourcesRouter } from "./routes/legal-sources.routes.js";
import { createQuestionHistoryRouter } from "./routes/question-history.routes.js";
import {
  uploadContractVersion,
  type UploadContractVersion
} from "./services/contract-versions.service.js";
import {
  createContract,
  listContracts,
  type CreateContract,
  type ListContracts
} from "./services/contracts.service.js";
import {
  createPastedContract,
  type CreatePastedContract
} from "./services/pasted-contract.service.js";
import {
  extractContractVersion,
  type ExtractContractVersion
} from "./services/document-extraction.service.js";
import {
  analyzeContractVersion,
  type AnalyzeContractVersion
} from "./services/contract-analysis.service.js";
import {
  getContractAnalysis,
  getLatestAnalysis,
  getLatestContractAnalysis,
  type GetContractAnalysis,
  type GetLatestAnalysis,
  type GetLatestContractAnalysis
} from "./services/analysis-retrieval.service.js";
import {
  getDashboard,
  type GetDashboard
} from "./services/dashboard.service.js";
import {
  listLegalSources,
  type ListLegalSources
} from "./services/legal-sources.service.js";
import { askContractQuestion, type AskContractQuestion } from "./services/contract-question.service.js";
import {
  rewriteAnalyzedClause,
  type RewriteAnalyzedClause
} from "./services/clause-rewrite.service.js";
import {
  exportAnalysisPdf,
  type ExportAnalysisPdf
} from "./services/analysis-pdf.service.js";
import {
  listRecentQuestions,
  type ListRecentQuestions
} from "./services/question-history.service.js";
import {
  getContractNotes,
  saveContractNotes,
  type GetContractNotes,
  type SaveContractNotes
} from "./services/contract-notes.service.js";

type AppDependencies = {
  authMiddleware?: RequestHandler;
  checkDatabase?: DatabaseHealthCheck;
  createContract?: CreateContract;
  createPastedContract?: CreatePastedContract;
  getContracts?: ListContracts;
  uploadContractVersion?: UploadContractVersion;
  extractContractVersion?: ExtractContractVersion;
  analyzeContractVersion?: AnalyzeContractVersion;
  getContractAnalysis?: GetContractAnalysis;
  getLatestAnalysis?: GetLatestAnalysis;
  getLatestContractAnalysis?: GetLatestContractAnalysis;
  getDashboard?: GetDashboard;
  listLegalSources?: ListLegalSources;
  askContractQuestion?: AskContractQuestion;
  rewriteAnalyzedClause?: RewriteAnalyzedClause;
  exportAnalysisPdf?: ExportAnalysisPdf;
  listRecentQuestions?: ListRecentQuestions;
  getContractNotes?: GetContractNotes;
  saveContractNotes?: SaveContractNotes;
};

export function createApp(dependencies: AppDependencies = {}) {
  const app = express();
  const authMiddleware = dependencies.authMiddleware ?? requireAuth;
  const createContractService =
    dependencies.createContract ?? createContract;
  const createPastedContractService =
    dependencies.createPastedContract ?? createPastedContract;
  const getContracts = dependencies.getContracts ?? listContracts;
  const uploadVersion =
    dependencies.uploadContractVersion ?? uploadContractVersion;
  const extractVersion =
    dependencies.extractContractVersion ?? extractContractVersion;
  const analyzeVersion =
    dependencies.analyzeContractVersion ?? analyzeContractVersion;
  const getAnalysis =
    dependencies.getContractAnalysis ?? getContractAnalysis;
  const getLatest = dependencies.getLatestAnalysis ?? getLatestAnalysis;
  const getLatestForContract =
    dependencies.getLatestContractAnalysis ?? getLatestContractAnalysis;
  const getDashboardSummary = dependencies.getDashboard ?? getDashboard;
  const getLegalSources = dependencies.listLegalSources ?? listLegalSources;
  const askQuestion = dependencies.askContractQuestion ?? askContractQuestion;
  const rewriteClause =
    dependencies.rewriteAnalyzedClause ?? rewriteAnalyzedClause;
  const exportPdf = dependencies.exportAnalysisPdf ?? exportAnalysisPdf;
  const getRecentQuestions =
    dependencies.listRecentQuestions ?? listRecentQuestions;
  const getNotes = dependencies.getContractNotes ?? getContractNotes;
  const saveNotes = dependencies.saveContractNotes ?? saveContractNotes;

  app.disable("x-powered-by");
  app.use(helmet());
  app.use(
    cors({
      origin: env.FRONTEND_URL,
      credentials: true
    })
  );
  app.use(express.json({ limit: "1mb" }));

  app.use("/api", createHealthRouter(dependencies.checkDatabase));
  app.use("/api/auth", createAuthRouter(authMiddleware));
  app.use(
    "/api/dashboard",
    createDashboardRouter({
      authMiddleware,
      getDashboard: getDashboardSummary
    })
  );
  app.use(
    "/api/contracts",
    createContractsRouter({
      authMiddleware,
      createContract: createContractService,
      createPastedContract: createPastedContractService,
      getContracts,
      uploadContractVersion: uploadVersion,
      extractContractVersion: extractVersion,
      analyzeContractVersion: analyzeVersion,
      getContractAnalysis: getAnalysis,
        getLatestContractAnalysis: getLatestForContract,
        askContractQuestion: askQuestion,
        rewriteAnalyzedClause: rewriteClause,
        exportAnalysisPdf: exportPdf,
        getContractNotes: getNotes,
        saveContractNotes: saveNotes
    })
  );
  app.use(
    "/api/analyses",
    createAnalysesRouter({
      authMiddleware,
      getLatestAnalysis: getLatest
    })
  );
  app.use(
    "/api/legal-sources",
    createLegalSourcesRouter({
      authMiddleware,
      listLegalSources: getLegalSources
    })
  );
  app.use(
    "/api/questions",
    createQuestionHistoryRouter({
      authMiddleware,
      listRecentQuestions: getRecentQuestions
    })
  );

  app.use(notFound);
  app.use(errorHandler);

  return app;
}
