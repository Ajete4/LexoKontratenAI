import type { RequestHandler } from "express";

import type { GetContractAnalysisParams } from "../schemas/contract-analysis.schema.js";
import {
  exportAnalysisPdf as defaultExportAnalysisPdf,
  type ExportAnalysisPdf
} from "../services/analysis-pdf.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

type ValidatedRequest = {
  params: GetContractAnalysisParams;
};

export function createAnalysisPdfController(
  exportPdf: ExportAnalysisPdf = defaultExportAnalysisPdf
): RequestHandler {
  return asyncHandler(async (request, response) => {
    if (!request.auth) {
      throw new ApiError(
        401,
        "AUTHENTICATION_REQUIRED",
        "Authentication is required."
      );
    }

    const validated = request.validated as ValidatedRequest;
    const report = await exportPdf({
      userId: request.auth.userId,
      accessToken: request.auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId
    });

    response
      .status(200)
      .set({
        "Content-Type": "application/pdf",
        "Content-Disposition": `attachment; filename="${report.fileName}"`,
        "Cache-Control": "private, no-store",
        "Content-Length": String(report.buffer.length)
      })
      .send(report.buffer);
  });
}

