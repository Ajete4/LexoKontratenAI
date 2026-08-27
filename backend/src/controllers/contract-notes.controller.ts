import type { RequestHandler } from "express";

import type {
  GetContractNotesRequest,
  SaveContractNotesRequest
} from "../schemas/contract-notes.schema.js";
import {
  getContractNotes as defaultGetContractNotes,
  saveContractNotes as defaultSaveContractNotes,
  type GetContractNotes,
  type SaveContractNotes
} from "../services/contract-notes.service.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/asyncHandler.js";

function requireRequestAuth(request: Parameters<RequestHandler>[0]) {
  if (!request.auth) {
    throw new ApiError(
      401,
      "AUTHENTICATION_REQUIRED",
      "Authentication is required."
    );
  }

  return request.auth;
}

export function createGetContractNotesController(
  getNotes: GetContractNotes = defaultGetContractNotes
): RequestHandler {
  return asyncHandler(async (request, response) => {
    const auth = requireRequestAuth(request);
    const validated = request.validated as GetContractNotesRequest;
    const notesChecklist = await getNotes({
      userId: auth.userId,
      accessToken: auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId
    });

    response.status(200).json({ data: { notesChecklist } });
  });
}

export function createSaveContractNotesController(
  saveNotes: SaveContractNotes = defaultSaveContractNotes
): RequestHandler {
  return asyncHandler(async (request, response) => {
    const auth = requireRequestAuth(request);
    const validated = request.validated as SaveContractNotesRequest;
    const notesChecklist = await saveNotes({
      userId: auth.userId,
      accessToken: auth.accessToken,
      contractId: validated.params.contractId,
      versionId: validated.params.versionId,
      notes: validated.body.notes,
      checklist: validated.body.checklist
    });

    response.status(200).json({ data: { notesChecklist } });
  });
}
