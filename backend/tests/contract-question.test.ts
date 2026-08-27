import type { SupabaseClient } from "@supabase/supabase-js";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { CONTRACT_QUESTION_DISCLAIMER } from "../src/ai/contract-question.schema.js";
import { createContractQuestionAdapter } from "../src/ai/contract-question.adapter.js";
import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import { createAskContractQuestion, type AskContractQuestion } from "../src/services/contract-question.service.js";

const userId = "authenticated-user";
const accessToken = "synthetic-access-token";
const contractId = "11111111-1111-4111-8111-111111111111";
const versionId = "22222222-2222-4222-8222-222222222222";

function createRouteHarness(askContractQuestion: AskContractQuestion = vi.fn<AskContractQuestion>(async () => ({
  answer: "Klauzola parashikon pagesën mujore [C1].",
  insufficientEvidence: false,
  citations: [{ citationId: "C1", lawNumber: "04/L-077", sourceTitle: "Ligji për Marrëdhëniet e Detyrimeve", articleNumber: "10", articleTitle: "Parimi", officialUrl: "https://gzk.rks-gov.net/" }],
  disclaimer: CONTRACT_QUESTION_DISCLAIMER
}))) {
  return {
    askContractQuestion,
    app: createApp({
      authMiddleware: createRequireAuth(async (token) => token === accessToken ? userId : null),
      askContractQuestion
    })
  };
}

function endpoint(app: ReturnType<typeof createApp>) {
  return request(app)
    .post(`/api/contracts/${contractId}/versions/${versionId}/questions`)
    .set("Authorization", `Bearer ${accessToken}`);
}

describe("POST contract questions route", () => {
  it("requires authentication and validates exact input", async () => {
    const context = createRouteHarness();
    const unauthenticated = await request(context.app)
      .post(`/api/contracts/${contractId}/versions/${versionId}/questions`)
      .send({ question: "Çfarë thotë kontrata?" });
    const extra = await endpoint(context.app).send({ question: "Pyetje", ownerId: userId });
    const blank = await endpoint(context.app).send({ question: "   " });
    const long = await endpoint(context.app).send({ question: "a".repeat(1_001) });

    expect(unauthenticated.status).toBe(401);
    expect(extra.status).toBe(400);
    expect(blank.status).toBe(400);
    expect(long.status).toBe(400);
    expect(context.askContractQuestion).not.toHaveBeenCalled();
  });

  it("passes only session identity, path IDs and the question", async () => {
    const context = createRouteHarness();
    const response = await endpoint(context.app).send({ question: "Cilat janë kushtet e pagesës?" });

    expect(response.status).toBe(200);
    expect(context.askContractQuestion).toHaveBeenCalledWith({
      userId,
      accessToken,
      contractId,
      versionId,
      question: "Cilat janë kushtet e pagesës?"
    });
    expect(response.body.data.disclaimer).toBe(CONTRACT_QUESTION_DISCLAIMER);
  });
});

function createDatabase(contractType: "employment" | "service" | "lease" = "service") {
  const historyInsert = vi.fn(async (): Promise<{
    data: null;
    error: { message: string } | null;
  }> => ({ data: null, error: null }));
  const from = vi.fn((table: string) => {
    const result = table === "contracts"
      ? { data: { id: contractId, owner_id: userId, contract_type: contractType }, error: null }
      : { data: { id: versionId, contract_id: contractId, extraction_status: "completed", extracted_text: "Pagesa bëhet çdo muaj." }, error: null };
    const builder = {
      select: vi.fn(() => builder),
      eq: vi.fn(() => builder),
      maybeSingle: vi.fn(async () => result),
      insert: table === "contract_questions" ? historyInsert : vi.fn(),
      update: vi.fn(),
      delete: vi.fn()
    };
    return builder;
  });
  return { client: { from } as unknown as SupabaseClient, from, historyInsert };
}

const contextSource = {
  chunkId: "33333333-3333-4333-8333-333333333333",
  legalSourceId: "44444444-4444-4444-8444-444444444444",
  lawNumber: "04/L-077" as const,
  sourceTitle: "Ligji për Marrëdhëniet e Detyrimeve",
  versionLabel: "original",
  officialUrl: "https://gzk.rks-gov.net/",
  officialDocumentUrl: null,
  articleNumber: "10",
  articleTitle: "Parimi",
  paragraphNumber: null,
  pointLabel: null,
  content: "Fragment juridik sintetik.",
  contentHash: "a".repeat(64),
  semanticScore: 0.8,
  lexicalScore: 0.5,
  fusedScore: 0.03,
  resultRank: 1
};

describe("contract question service", () => {
  it("stores only a successful grounded answer with session ownership", async () => {
    const database = createDatabase();
    const buildContext = vi.fn(async () => ({ retrievalStatus: "grounded" as const, contractType: "service" as const, queryStrategy: "verified-title-anchors" as const, sources: [contextSource] }));
    const answerQuestion = vi.fn(async () => ({ answer: "Pagesa rregullohet në kontratë [C1].", insufficientEvidence: false, citationIds: ["C1"] }));
    const service = createAskContractQuestion({ createUserClient: () => database.client, buildContext, answerQuestion });

    const result = await service({ userId, accessToken, contractId, versionId, question: "Si bëhet pagesa?" });

    expect(result.citations[0]?.lawNumber).toBe("04/L-077");
    expect(buildContext).toHaveBeenCalledWith({ contractType: "service", clauseTitle: "Pyetje për kontratën", clauseText: "Si bëhet pagesa?" });
    expect(answerQuestion).toHaveBeenCalledWith(expect.objectContaining({ contractText: "Pagesa bëhet çdo muaj." }));
    expect(database.historyInsert).toHaveBeenCalledWith({
      user_id: userId,
      contract_id: contractId,
      version_id: versionId,
      question: "Si bëhet pagesa?",
      answer: "Pagesa rregullohet në kontratë [C1]."
    });
  });

  it.each([
    ["employment", ["03/L-212"]],
    ["lease", ["04/L-077"]]
  ] as const)("passes %s to scoped retrieval", async (contractType, allowed) => {
    const database = createDatabase(contractType);
    const lawNumber = allowed[0];
    const buildContext = vi.fn(async () => ({ retrievalStatus: "grounded" as const, contractType, queryStrategy: "A" as const, sources: [{ ...contextSource, lawNumber }] }));
    const service = createAskContractQuestion({ createUserClient: () => database.client, buildContext, answerQuestion: async () => ({ answer: "Përgjigje [C1].", insufficientEvidence: false, citationIds: ["C1"] }) });
    await service({ userId, accessToken, contractId, versionId, question: "Pyetje?" });
    expect(buildContext).toHaveBeenCalledWith(expect.objectContaining({ contractType }));
  });

  it("returns a strict insufficient-evidence response without calling the model", async () => {
    const database = createDatabase();
    const answerQuestion = vi.fn();
    const service = createAskContractQuestion({
      createUserClient: () => database.client,
      buildContext: async () => ({ retrievalStatus: "insufficient_evidence", contractType: "service", queryStrategy: "verified-title-anchors", sources: [] }),
      answerQuestion
    });
    const result = await service({ userId, accessToken, contractId, versionId, question: "Pyetje pa evidencë?" });
    expect(result).toEqual({ answer: null, insufficientEvidence: true, citations: [], disclaimer: CONTRACT_QUESTION_DISCLAIMER });
    expect(answerQuestion).not.toHaveBeenCalled();
    expect(database.historyInsert).not.toHaveBeenCalled();
  });

  it("maps history persistence failure safely and does not return an unpersisted answer", async () => {
    const database = createDatabase();
    database.historyInsert.mockResolvedValueOnce({
      data: null,
      error: { message: "synthetic database internals" }
    });
    const service = createAskContractQuestion({
      createUserClient: () => database.client,
      buildContext: async () => ({
        retrievalStatus: "grounded",
        contractType: "service",
        queryStrategy: "verified-title-anchors",
        sources: [contextSource]
      }),
      answerQuestion: async () => ({
        answer: "Përgjigje e suksesshme [C1].",
        insufficientEvidence: false,
        citationIds: ["C1"]
      })
    });

    await expect(service({
      userId,
      accessToken,
      contractId,
      versionId,
      question: "Pyetje?"
    })).rejects.toMatchObject({
      statusCode: 503,
      code: "QUESTION_HISTORY_UNAVAILABLE"
    });
  });

  it("conceals inaccessible ownership and never calls retrieval", async () => {
    const from = vi.fn(() => {
      const builder = {
        select: vi.fn(() => builder),
        eq: vi.fn(() => builder),
        maybeSingle: vi.fn(async () => ({ data: null, error: null }))
      };
      return builder;
    });
    const buildContext = vi.fn();
    const service = createAskContractQuestion({
      createUserClient: () => ({ from } as unknown as SupabaseClient),
      buildContext,
      answerQuestion: vi.fn()
    });

    await expect(service({ userId, accessToken, contractId, versionId, question: "Pyetje?" }))
      .rejects.toMatchObject({ statusCode: 404, code: "CONTRACT_VERSION_NOT_FOUND" });
    expect(buildContext).not.toHaveBeenCalled();
  });

  it("maps retrieval failure safely and does not call OpenAI", async () => {
    const database = createDatabase();
    const answerQuestion = vi.fn();
    const service = createAskContractQuestion({
      createUserClient: () => database.client,
      buildContext: async () => { throw new Error("synthetic upstream internals"); },
      answerQuestion
    });

    await expect(service({ userId, accessToken, contractId, versionId, question: "Pyetje?" }))
      .rejects.toMatchObject({ statusCode: 503, code: "QUESTION_RETRIEVAL_UNAVAILABLE" });
    expect(answerQuestion).not.toHaveBeenCalled();
  });
});

describe("contract question AI adapter", () => {
  it("maps upstream failure to a safe error without exposing internals", async () => {
    const adapter = createContractQuestionAdapter({
      responses: {
        parse: vi.fn(async () => {
          throw new Error("synthetic credential and upstream payload");
        })
      }
    });

    await expect(adapter({
      question: "Pyetje sintetike?",
      contractText: "Tekst sintetik kontrate.",
      context: {
        retrievalStatus: "grounded",
        contractType: "service",
        queryStrategy: "verified-title-anchors",
        sources: [contextSource]
      }
    })).rejects.toMatchObject({
      statusCode: 503,
      code: "QUESTION_AI_UNAVAILABLE",
      message: "Përgjigjja me AI është përkohësisht e padisponueshme."
    });
  });
});
