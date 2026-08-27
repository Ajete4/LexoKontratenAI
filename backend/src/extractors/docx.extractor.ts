import * as mammoth from "mammoth";

import { validateDocxArchive } from "../services/docx-archive-validation.service.js";
import { ApiError } from "../utils/ApiError.js";
import { normalizeExtractedText } from "./document-text-normalizer.js";

export type MammothRawTextAdapter = (
  input: { buffer: Buffer }
) => Promise<{ value: string }>;

export type ExtractDocx = (buffer: Buffer) => Promise<string>;

export function createDocxExtractor(
  extractRawText: MammothRawTextAdapter = mammoth.extractRawText
): ExtractDocx {
  return async (buffer) => {
    validateDocxArchive(buffer);

    let rawText: string;

    try {
      const result = await extractRawText({ buffer });
      rawText = result.value;
    } catch {
      throw new ApiError(
        422,
        "PARSER_FAILED",
        "The DOCX text could not be extracted safely."
      );
    }

    return normalizeExtractedText(rawText);
  };
}

export const extractDocx = createDocxExtractor();
