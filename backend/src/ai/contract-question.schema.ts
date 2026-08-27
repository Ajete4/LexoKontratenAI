import { z } from "zod";

export const CONTRACT_QUESTION_DISCLAIMER =
  "Ky informacion nuk zëvendëson këshillën juridike profesionale.";

export const contractQuestionModelOutputSchema = z
  .object({
    answer: z.string().min(1).max(4_000).nullable(),
    insufficientEvidence: z.boolean(),
    citationIds: z.array(z.string().regex(/^C[1-5]$/u)).max(5),
  })
  .strict()
  .superRefine((value, context) => {
    if (new Set(value.citationIds).size !== value.citationIds.length) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["citationIds"],
        message: "Duplicate citation ID.",
      });
    }

    if (
      value.insufficientEvidence &&
      (value.answer !== null || value.citationIds.length > 0)
    ) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["answer"],
        message: "Insufficient evidence cannot include an answer or citations.",
      });
    }

    if (!value.insufficientEvidence && value.answer === null) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["answer"],
        message: "A grounded answer is required.",
      });
    }

    if (value.answer !== null) {
      const referenced = [...value.answer.matchAll(/\[(C\d+)\]/gu)]
        .map((match) => match[1])
        .filter(
          (citationId): citationId is string =>
            citationId !== undefined,
        );

      if (
        referenced.some(
          (citationId) => !value.citationIds.includes(citationId),
        )
      ) {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["answer"],
          message: "Answer references an unknown citation.",
        });
      }

      if (
        value.citationIds.some(
          (citationId) => !referenced.includes(citationId),
        )
      ) {
        context.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["citationIds"],
          message: "Every citation must be referenced in the answer.",
        });
      }
    }
  });

export type ContractQuestionModelOutput = z.infer<
  typeof contractQuestionModelOutputSchema
>;