import { ApiError } from "../utils/ApiError.js";
import {
  MAX_EXTRACTED_CHARACTERS,
  normalizeExtractedText
} from "./document-text-normalizer.js";

export { MAX_EXTRACTED_CHARACTERS } from "./document-text-normalizer.js";

export function extractTxt(buffer: Buffer): string {
  let decodedText: string;

  try {
    decodedText = new TextDecoder("utf-8", { fatal: true }).decode(buffer);
  } catch {
    throw new ApiError(
      422,
      "INVALID_TEXT_ENCODING",
      "The text file must contain valid UTF-8 text."
    );
  }

  return normalizeExtractedText(decodedText);
}
