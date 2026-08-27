import { z } from "zod";

import { emptyParamsSchema } from "./common.schema.js";
import { contractTypes } from "./contracts.schema.js";

const MAX_PASTED_TEXT_CHARACTERS = 80_000;
const MAX_PASTED_TEXT_BYTES = 320_000;

const pastedTextSchema = z
  .string()
  .min(1)
  .refine((text) => text.trim().length > 0, {
    message: "Text must not be blank."
  })
  .refine(
    (text) => Array.from(text).length <= MAX_PASTED_TEXT_CHARACTERS,
    {
      message: "Text exceeds the character limit."
    }
  )
  .refine((text) => Buffer.byteLength(text, "utf8") <= MAX_PASTED_TEXT_BYTES, {
    message: "Text exceeds the UTF-8 byte limit."
  });

export const createPastedContractRequestSchema = z.object({
  body: z
    .object({
      title: z.string().trim().min(1).max(200),
      contractType: z.enum(contractTypes),
      text: pastedTextSchema
    })
    .strict(),
  params: emptyParamsSchema,
  query: z.object({}).strict()
});

export type CreatePastedContractInput = z.infer<
  typeof createPastedContractRequestSchema
>["body"];
