import type { SupabaseClient } from "@supabase/supabase-js";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import {
  createCreatePastedContract,
  type CreatePastedContract,
  type PastedContractResult
} from "../src/services/pasted-contract.service.js";
import { ApiError } from "../src/utils/ApiError.js";

const authenticatedMiddleware = createRequireAuth(async () => "user-a");

const rpcRow = {
  contract_id: "11111111-1111-4111-8111-111111111111",
  version_id: "22222222-2222-4222-8222-222222222222",
  version_number: 1,
  source_kind: "pasted",
  extraction_status: "completed",
  page_count: null,
  created_at: "2026-08-24T10:00:00.000Z"
};

const expectedResult: PastedContractResult = {
  contractId: rpcRow.contract_id,
  version: {
    id: rpcRow.version_id,
    versionNumber: 1,
    sourceKind: "pasted",
    extractionStatus: "completed",
    pageCount: null,
    createdAt: rpcRow.created_at
  }
};

describe("POST /api/contracts/from-text", () => {
  it("requires authentication", async () => {
    const response = await request(createApp())
      .post("/api/contracts/from-text")
      .send({
        title: "Kontratë testuese",
        contractType: "service",
        text: "Tekst testues"
      });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
  });

  it.each([
    ["blank title", { title: "  ", contractType: "service", text: "Tekst" }],
    [
      "long title",
      { title: "a".repeat(201), contractType: "service", text: "Tekst" }
    ],
    [
      "invalid type",
      { title: "Kontratë", contractType: "other", text: "Tekst" }
    ],
    ["blank text", { title: "Kontratë", contractType: "service", text: " \n " }],
    [
      "long text",
      { title: "Kontratë", contractType: "service", text: "a".repeat(80_001) }
    ],
    [
      "additional field",
      {
        title: "Kontratë",
        contractType: "service",
        text: "Tekst",
        ownerId: "user-b"
      }
    ]
  ])("rejects %s", async (_name, body) => {
    const createPastedContract = vi.fn<CreatePastedContract>();
    const response = await request(
      createApp({
        authMiddleware: authenticatedMiddleware,
        createPastedContract
      })
    )
      .post("/api/contracts/from-text")
      .set("Authorization", "Bearer synthetic-test-token")
      .send(body);

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(createPastedContract).not.toHaveBeenCalled();
  });

  it("accepts text at the UTF-8 byte boundary", async () => {
    const createPastedContract = vi.fn<CreatePastedContract>(
      async () => expectedResult
    );
    const text = "😀".repeat(80_000);
    const response = await request(
      createApp({
        authMiddleware: authenticatedMiddleware,
        createPastedContract
      })
    )
      .post("/api/contracts/from-text")
      .set("Authorization", "Bearer synthetic-test-token")
      .send({ title: "Kontratë", contractType: "service", text });

    expect(Array.from(text)).toHaveLength(80_000);
    expect(Buffer.byteLength(text, "utf8")).toBe(320_000);
    expect(response.status).toBe(201);
  });

  it("returns the validated navigation response", async () => {
    const createPastedContract = vi.fn<CreatePastedContract>(
      async () => expectedResult
    );
    const response = await request(
      createApp({
        authMiddleware: authenticatedMiddleware,
        createPastedContract
      })
    )
      .post("/api/contracts/from-text")
      .set("Authorization", "Bearer synthetic-test-token")
      .send({
        title: "  Kontratë testuese  ",
        contractType: "service",
        text: " Teksti ruhet ekzakt. "
      });

    expect(response.status).toBe(201);
    expect(response.body).toEqual({ data: expectedResult });
    expect(createPastedContract).toHaveBeenCalledWith(
      expect.objectContaining({ userId: "user-a" }),
      {
        title: "Kontratë testuese",
        contractType: "service",
        text: " Teksti ruhet ekzakt. "
      }
    );
  });

  it("maps service failures without exposing internals", async () => {
    const createPastedContract: CreatePastedContract = async () => {
      throw new ApiError(
        503,
        "DATABASE_UNAVAILABLE",
        "The contract could not be created at this time."
      );
    };
    const response = await request(
      createApp({
        authMiddleware: authenticatedMiddleware,
        createPastedContract
      })
    )
      .post("/api/contracts/from-text")
      .set("Authorization", "Bearer synthetic-test-token")
      .send({ title: "Kontratë", contractType: "service", text: "Tekst" });

    expect(response.status).toBe(503);
    expect(response.body.error).toEqual({
      code: "DATABASE_UNAVAILABLE",
      message: "The contract could not be created at this time.",
      details: null
    });
    expect(JSON.stringify(response.body)).not.toContain("synthetic-test-token");
  });
});

describe("pasted contract service", () => {
  it("uses one user-scoped RPC with the exact payload", async () => {
    const rpc = vi.fn(async () => ({ data: [rpcRow], error: null }));
    const createClient = vi.fn(
      () => ({ rpc }) as unknown as SupabaseClient
    );
    const service = createCreatePastedContract(createClient);

    const result = await service(
      { userId: "user-a", accessToken: "synthetic-test-token" },
      { title: "Kontratë", contractType: "service", text: "Tekst" }
    );

    expect(createClient).toHaveBeenCalledWith("synthetic-test-token");
    expect(rpc).toHaveBeenCalledTimes(1);
    expect(rpc).toHaveBeenCalledWith("create_pasted_contract", {
      p_title: "Kontratë",
      p_contract_type: "service",
      p_text: "Tekst"
    });
    expect(result).toEqual(expectedResult);
  });

  it("maps an RPC failure to a safe 503 error", async () => {
    const rpc = vi.fn(async () => ({
      data: null,
      error: { code: "internal", message: "sensitive database detail" }
    }));
    const service = createCreatePastedContract(
      () => ({ rpc }) as unknown as SupabaseClient
    );

    await expect(
      service(
        { userId: "user-a", accessToken: "synthetic-test-token" },
        { title: "Kontratë", contractType: "service", text: "Tekst" }
      )
    ).rejects.toMatchObject({
      statusCode: 503,
      code: "DATABASE_UNAVAILABLE",
      details: null
    });
  });

  it.each([
    null,
    [],
    [rpcRow, rpcRow],
    [{ ...rpcRow, version_number: 2 }],
    [{ ...rpcRow, unexpected: true }]
  ])("rejects invalid RPC response %#", async (data) => {
    const rpc = vi.fn(async () => ({ data, error: null }));
    const service = createCreatePastedContract(
      () => ({ rpc }) as unknown as SupabaseClient
    );

    await expect(
      service(
        { userId: "user-a", accessToken: "synthetic-test-token" },
        { title: "Kontratë", contractType: "service", text: "Tekst" }
      )
    ).rejects.toMatchObject({
      statusCode: 503,
      code: "PASTED_CONTRACT_RESPONSE_INVALID",
      details: null
    });
  });
});
