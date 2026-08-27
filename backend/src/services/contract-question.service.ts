import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import { createContractQuestionAdapter, type AnswerGroundedContractQuestion } from "../ai/contract-question.adapter.js";
import { CONTRACT_QUESTION_DISCLAIMER } from "../ai/contract-question.schema.js";
import { createOpenAIClient } from "../ai/openai-client.js";
import { createUserSupabaseClient, supabaseAdmin } from "../config/supabase.js";
import { createLegalEmbeddingAdapter } from "../legal/legal-embedding-adapter.js";
import { createLegalHybridRetrievalService } from "../legal/legal-hybrid-retrieval.service.js";
import { createRagContextBuilder, type RagContext } from "../rag/rag-context-builder.js";
import { ApiError } from "../utils/ApiError.js";

const ownershipContractSchema = z.object({ id: z.string().uuid(), owner_id: z.string(), contract_type: z.enum(["employment", "service", "lease"]) }).strict();
const ownershipVersionSchema = z.object({ id: z.string().uuid(), contract_id: z.string().uuid(), extraction_status: z.literal("completed"), extracted_text: z.string().min(1) }).strict();

const citationSchema = z.object({
  citationId: z.string().regex(/^C[1-5]$/u),
  lawNumber: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  sourceTitle: z.string().min(1),
  articleNumber: z.string().min(1).nullable(),
  articleTitle: z.string().min(1).nullable(),
  officialUrl: z.string().url().startsWith("https://")
}).strict();

export const contractQuestionResponseSchema = z.object({
  answer: z.string().min(1).max(4_000).nullable(),
  insufficientEvidence: z.boolean(),
  citations: z.array(citationSchema).max(5),
  disclaimer: z.literal(CONTRACT_QUESTION_DISCLAIMER)
}).strict().superRefine((value, context) => {
  if (value.insufficientEvidence && (value.answer !== null || value.citations.length > 0)) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["answer"], message: "Insufficient evidence response is inconsistent." });
  }
});

export type ContractQuestionResponse = z.infer<typeof contractQuestionResponseSchema>;
export type AskContractQuestion = (input: { userId: string; accessToken: string; contractId: string; versionId: string; question: string }) => Promise<ContractQuestionResponse>;

type BuildContext = (input: { contractType: "employment" | "service" | "lease"; clauseTitle: string; clauseText: string | null }) => Promise<RagContext>;

export function createAskContractQuestion(dependencies: {
  createUserClient?: (accessToken: string) => SupabaseClient;
  buildContext: BuildContext;
  answerQuestion: AnswerGroundedContractQuestion;
}): AskContractQuestion {
  return async (input) => {
    const client = (dependencies.createUserClient ?? createUserSupabaseClient)(input.accessToken);
    const contractQuery = await client.from("contracts").select("id, owner_id, contract_type").eq("id", input.contractId).eq("owner_id", input.userId).maybeSingle();
    if (contractQuery.error) throw new ApiError(503, "QUESTION_DATA_UNAVAILABLE", "Të dhënat e kontratës janë përkohësisht të padisponueshme.");
    const contract = ownershipContractSchema.safeParse(contractQuery.data);
    if (!contract.success) throw new ApiError(404, "CONTRACT_VERSION_NOT_FOUND", "Kontrata ose versioni nuk u gjet.");

    const versionQuery = await client.from("contract_versions").select("id, contract_id, extraction_status, extracted_text").eq("id", input.versionId).eq("contract_id", input.contractId).maybeSingle();
    if (versionQuery.error) throw new ApiError(503, "QUESTION_DATA_UNAVAILABLE", "Të dhënat e kontratës janë përkohësisht të padisponueshme.");
    const version = ownershipVersionSchema.safeParse(versionQuery.data);
    if (!version.success) throw new ApiError(404, "CONTRACT_VERSION_NOT_FOUND", "Kontrata ose versioni nuk u gjet.");

    let context: RagContext;
    try {
      context = await dependencies.buildContext({ contractType: contract.data.contract_type, clauseTitle: "Pyetje për kontratën", clauseText: input.question });
    } catch {
      throw new ApiError(503, "QUESTION_RETRIEVAL_UNAVAILABLE", "Burimet juridike janë përkohësisht të padisponueshme.");
    }

    if (context.retrievalStatus === "insufficient_evidence") {
      return { answer: null, insufficientEvidence: true, citations: [], disclaimer: CONTRACT_QUESTION_DISCLAIMER };
    }

    const modelOutput = await dependencies.answerQuestion({ question: input.question, contractText: version.data.extracted_text, context });
    if (modelOutput.insufficientEvidence) {
      return { answer: null, insufficientEvidence: true, citations: [], disclaimer: CONTRACT_QUESTION_DISCLAIMER };
    }

    const citations = modelOutput.citationIds.map((citationId) => {
      const index = Number(citationId.slice(1)) - 1;
      const source = context.sources[index];
      if (!source) throw new ApiError(502, "QUESTION_AI_OUTPUT_INVALID", "Përgjigjja e AI nuk ishte valide.");
      return { citationId, lawNumber: source.lawNumber, sourceTitle: source.sourceTitle, articleNumber: source.articleNumber, articleTitle: source.articleTitle, officialUrl: source.officialUrl };
    });
    const result = contractQuestionResponseSchema.safeParse({ answer: modelOutput.answer, insufficientEvidence: false, citations, disclaimer: CONTRACT_QUESTION_DISCLAIMER });
    if (!result.success || result.data.answer === null) throw new ApiError(502, "QUESTION_AI_OUTPUT_INVALID", "Përgjigjja e AI nuk ishte valide.");

    const historyWrite = await client.from("contract_questions").insert({
      user_id: input.userId,
      contract_id: input.contractId,
      version_id: input.versionId,
      question: input.question,
      answer: result.data.answer
    });

    if (historyWrite.error) {
      throw new ApiError(
        503,
        "QUESTION_HISTORY_UNAVAILABLE",
        "Përgjigjja u krijua, por nuk mund të ruhej në historik."
      );
    }

    return result.data;
  };
}

function createProductionAskContractQuestion(): AskContractQuestion {
  const openAIClient = createOpenAIClient();
  const retrieval = createLegalHybridRetrievalService({
    embeddingAdapter: createLegalEmbeddingAdapter(openAIClient, { maxRetries: 0 }),
    rpcClient: { async rpc(functionName, parameters) { const { data, error } = await supabaseAdmin.rpc(functionName, parameters); return { data, error }; } }
  });
  return createAskContractQuestion({ buildContext: createRagContextBuilder(retrieval), answerQuestion: createContractQuestionAdapter(openAIClient) });
}

export const askContractQuestion: AskContractQuestion = async (input) => createProductionAskContractQuestion()(input);
