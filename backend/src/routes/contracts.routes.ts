import { Router, type RequestHandler } from "express";

import {
  createContractController,
  createListContractsController
} from "../controllers/contracts.controller.js";
import {
  createContractAnalysisController,
  createGetContractAnalysisController,
  createGetLatestContractAnalysisController
} from "../controllers/contract-analysis.controller.js";
import { createUploadContractVersionController } from "../controllers/contract-versions.controller.js";
import { createDocumentExtractionController } from "../controllers/document-extraction.controller.js";
import { createPastedContractController } from "../controllers/pasted-contract.controller.js";
import { createContractQuestionController } from "../controllers/contract-question.controller.js";
import { createClauseRewriteController } from "../controllers/clause-rewrite.controller.js";
import { createAnalysisPdfController } from "../controllers/analysis-pdf.controller.js";
import {
  createGetContractNotesController,
  createSaveContractNotesController
} from "../controllers/contract-notes.controller.js";
import { requireAuth } from "../middleware/auth.js";
import { uploadSingleContractFile } from "../middleware/contract-file-upload.js";
import { validate } from "../middleware/validate.js";
import {
  createContractRequestSchema,
  listContractsRequestSchema
} from "../schemas/contracts.schema.js";
import { createPastedContractRequestSchema } from "../schemas/pasted-contract.schema.js";
import { contractQuestionRequestSchema } from "../schemas/contract-question.schema.js";
import { clauseRewriteRequestSchema } from "../schemas/clause-rewrite.schema.js";
import {
  getContractNotesRequestSchema,
  saveContractNotesRequestSchema
} from "../schemas/contract-notes.schema.js";
import {
  uploadContractVersionParamsSchema,
  uploadContractVersionRequestSchema
} from "../schemas/contract-versions.schema.js";
import { extractDocumentRequestSchema } from "../schemas/document-extraction.schema.js";
import {
  analyzeContractRequestSchema,
  getContractAnalysisRequestSchema,
  getLatestContractAnalysisRequestSchema
} from "../schemas/contract-analysis.schema.js";
import {
  getContractAnalysis,
  getLatestContractAnalysis,
  type GetContractAnalysis,
  type GetLatestContractAnalysis
} from "../services/analysis-retrieval.service.js";
import {
  analyzeContractVersion,
  type AnalyzeContractVersion
} from "../services/contract-analysis.service.js";
import {
  uploadContractVersion,
  type UploadContractVersion
} from "../services/contract-versions.service.js";
import {
  createContract,
  listContracts,
  type CreateContract,
  type ListContracts
} from "../services/contracts.service.js";
import {
  extractContractVersion,
  type ExtractContractVersion
} from "../services/document-extraction.service.js";
import {
  createPastedContract,
  type CreatePastedContract
} from "../services/pasted-contract.service.js";
import { askContractQuestion, type AskContractQuestion } from "../services/contract-question.service.js";
import {
  rewriteAnalyzedClause,
  type RewriteAnalyzedClause
} from "../services/clause-rewrite.service.js";
import {
  exportAnalysisPdf,
  type ExportAnalysisPdf
} from "../services/analysis-pdf.service.js";
import {
  getContractNotes,
  saveContractNotes,
  type GetContractNotes,
  type SaveContractNotes
} from "../services/contract-notes.service.js";

type ContractsRouterDependencies = {
  authMiddleware?: RequestHandler;
  createContract?: CreateContract;
  createPastedContract?: CreatePastedContract;
  getContracts?: ListContracts;
  uploadContractVersion?: UploadContractVersion;
  extractContractVersion?: ExtractContractVersion;
  analyzeContractVersion?: AnalyzeContractVersion;
  getContractAnalysis?: GetContractAnalysis;
  getLatestContractAnalysis?: GetLatestContractAnalysis;
  askContractQuestion?: AskContractQuestion;
  rewriteAnalyzedClause?: RewriteAnalyzedClause;
  exportAnalysisPdf?: ExportAnalysisPdf;
  getContractNotes?: GetContractNotes;
  saveContractNotes?: SaveContractNotes;
};

export function createContractsRouter(
  dependencies: ContractsRouterDependencies = {}
) {
  const router = Router();
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
  const getLatestForContract =
    dependencies.getLatestContractAnalysis ?? getLatestContractAnalysis;
  const askQuestion = dependencies.askContractQuestion ?? askContractQuestion;
  const rewriteClause =
    dependencies.rewriteAnalyzedClause ?? rewriteAnalyzedClause;
  const exportPdf = dependencies.exportAnalysisPdf ?? exportAnalysisPdf;
  const getNotes = dependencies.getContractNotes ?? getContractNotes;
  const saveNotes = dependencies.saveContractNotes ?? saveContractNotes;

  router.post(
    "/",
    authMiddleware,
    validate(createContractRequestSchema),
    createContractController(createContractService)
  );

  router.post(
    "/from-text",
    authMiddleware,
    validate(createPastedContractRequestSchema),
    createPastedContractController(createPastedContractService)
  );

  router.get(
    "/",
    authMiddleware,
    validate(listContractsRequestSchema),
    createListContractsController(getContracts)
  );

  router.post(
    "/:contractId/versions/:versionId/questions",
    authMiddleware,
    validate(contractQuestionRequestSchema),
    createContractQuestionController(askQuestion)
  );

  router.get(
    "/:contractId/versions/:versionId/notes-checklist",
    authMiddleware,
    validate(getContractNotesRequestSchema),
    createGetContractNotesController(getNotes)
  );

  router.put(
    "/:contractId/versions/:versionId/notes-checklist",
    authMiddleware,
    validate(saveContractNotesRequestSchema),
    createSaveContractNotesController(saveNotes)
  );

  router.post(
    "/:contractId/versions/:versionId/clauses/:position/rewrite",
    authMiddleware,
    validate(clauseRewriteRequestSchema),
    createClauseRewriteController(rewriteClause)
  );

  router.post(
    "/:contractId/versions",
    authMiddleware,
    validate(uploadContractVersionParamsSchema),
    uploadSingleContractFile,
    validate(uploadContractVersionRequestSchema),
    createUploadContractVersionController(uploadVersion)
  );

  router.post(
    "/:contractId/versions/:versionId/extract",
    authMiddleware,
    validate(extractDocumentRequestSchema),
    createDocumentExtractionController(extractVersion)
  );

  router.post(
    "/:contractId/versions/:versionId/analyze",
    authMiddleware,
    validate(analyzeContractRequestSchema),
    createContractAnalysisController(analyzeVersion)
  );

  router.get(
    "/:contractId/analysis/latest",
    authMiddleware,
    validate(getLatestContractAnalysisRequestSchema),
    createGetLatestContractAnalysisController(getLatestForContract)
  );

  router.get(
    "/:contractId/versions/:versionId/analysis",
    authMiddleware,
    validate(getContractAnalysisRequestSchema),
    createGetContractAnalysisController(getAnalysis)
  );

  router.get(
    "/:contractId/versions/:versionId/analysis/export.pdf",
    authMiddleware,
    validate(getContractAnalysisRequestSchema),
    createAnalysisPdfController(exportPdf)
  );

  return router;
}
