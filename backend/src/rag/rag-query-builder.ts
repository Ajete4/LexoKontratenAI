import { z } from "zod";

import { contractTypeSchema } from "../ai/contract-analysis.schema.js";
import { RAG_RETRIEVAL_CONFIG } from "./rag-config.js";

const queryInputSchema = z.object({
  contractType: contractTypeSchema,
  clauseTitle: z.string().min(1).max(200),
  clauseText: z.string().min(1).max(1_500).nullable(),
  controlledCategory: z.string().min(1).max(100).optional()
}).strict();

const VERIFIED_SERVICE_TITLE_ANCHORS: Readonly<Record<string, string>> = {
  termination:
    "zgjidhja e kontratës deklarimi i zgjidhjes pasojat juridike të zgjidhjes detyrime të vazhdueshme kontrata për vepër",
  liability:
    "nuk e përmbushë detyrimin përmbushja e detyrimit pasojat e mos përmbushjes përgjegjësia e debitorit kufizimi përjashtimi përgjegjësisë",
  obligations:
    "nuk e përmbushë detyrimin përmbushja e detyrimit pasojat e mos përmbushjes përgjegjësia e debitorit kufizimi përjashtimi përgjegjësisë",
  penalty:
    "dëmi real fitimi i humbur shpërblimi i plotë vëllimi i shpërblimit shpërblimi i dëmit"
};

export type RagQueryInput = z.infer<typeof queryInputSchema>;

export function buildDeterministicRagQuery(input: RagQueryInput) {
  const parsed = queryInputSchema.parse(input);
  const strategy = RAG_RETRIEVAL_CONFIG.routing[parsed.contractType];
  const category = parsed.controlledCategory?.trim();
  const controlledTerms =
    parsed.contractType === "service" && category !== undefined
      ? VERIFIED_SERVICE_TITLE_ANCHORS[category]
      : undefined;
  const prefixes = [parsed.clauseTitle];
  if (category !== undefined) prefixes.push(category);
  if (strategy === "verified-title-anchors" && controlledTerms !== undefined) {
    prefixes.push(controlledTerms);
  }
  const prefix = prefixes.join("; ");
  const availableTextLength = Math.max(
    0,
    RAG_RETRIEVAL_CONFIG.maximumQueryCharacters - prefix.length - 2
  );
  const sourceText = parsed.clauseText ?? parsed.clauseTitle;
  const clauseText = Array.from(sourceText).slice(0, availableTextLength).join("");

  return {
    contractType: parsed.contractType,
    queryStrategy: strategy,
    query: `${prefix}: ${clauseText}`.slice(0, RAG_RETRIEVAL_CONFIG.maximumQueryCharacters)
  } as const;
}
