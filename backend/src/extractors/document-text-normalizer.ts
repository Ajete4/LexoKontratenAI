import { ApiError } from "../utils/ApiError.js";

export const MAX_EXTRACTED_CHARACTERS = 1_000_000;
export const MIN_MEANINGFUL_CHARACTERS = 20;

const UNSAFE_CONTROL_CHARACTERS =
  /[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F-\u009F]/g;
const TRAILING_HORIZONTAL_WHITESPACE = /[\t ]+$/gm;
const EXCESS_BLANK_LINES = /\n[\t ]*\n(?:[\t ]*\n)+/g;

function countCharactersUpTo(text: string, limit: number): number {
  let count = 0;

  for (const _character of text) {
    count += 1;

    if (count > limit) {
      return count;
    }
  }

  return count;
}

export function normalizeExtractedText(text: string): string {
  const normalizedText = text
    .replace(/^\uFEFF/, "")
    .replace(/\r\n?/g, "\n")
    .replace(UNSAFE_CONTROL_CHARACTERS, "")
    .replace(TRAILING_HORIZONTAL_WHITESPACE, "")
    .replace(EXCESS_BLANK_LINES, "\n\n")
    .trim();
  const characterCount = countCharactersUpTo(
    normalizedText,
    MAX_EXTRACTED_CHARACTERS
  );

  if (characterCount > MAX_EXTRACTED_CHARACTERS) {
    throw new ApiError(
      413,
      "EXTRACTION_OUTPUT_TOO_LARGE",
      "The extracted text exceeds the allowed size."
    );
  }

  const meaningfulCharacterCount = countCharactersUpTo(
    normalizedText.replace(/\s/gu, ""),
    MIN_MEANINGFUL_CHARACTERS
  );

  if (meaningfulCharacterCount < MIN_MEANINGFUL_CHARACTERS) {
    throw new ApiError(
      422,
      "EMPTY_EXTRACTED_TEXT",
      "The document does not contain enough meaningful text."
    );
  }

  return normalizedText;
}
