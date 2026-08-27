import type { SupabaseClient } from "@supabase/supabase-js";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import {
  createCreateContract,
  createListContracts,
  type CreateContract,
  type ContractListItem,
  type ContractMetadata,
  type ListContracts
} from "../src/services/contracts.service.js";
import { ApiError } from "../src/utils/ApiError.js";

const authenticatedMiddleware = createRequireAuth(async () => "user-a");

const contract: ContractMetadata = {
  id: "11111111-1111-4111-8111-111111111111",
  owner_id: "user-a",
  title: "Kontratë testuese",
  contract_type: "employment",
  status: "draft",
  created_at: "2026-08-08T10:00:00.000Z",
  updated_at: "2026-08-08T10:00:00.000Z"
};

const listedContract: ContractListItem = {
  ...contract,
  latestCompletedAnalysis: null
};

describe("POST /api/contracts", () => {
  it("requires authentication", async () => {
    const response = await request(createApp())
      .post("/api/contracts")
      .send({ title: "Kontratë testuese", contractType: "employment" });

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
  });

  it.each([
    ["missing title", { contractType: "employment" }],
    ["blank title", { title: "   ", contractType: "employment" }],
    [
      "title over 200 characters",
      { title: "a".repeat(201), contractType: "employment" }
    ],
    ["missing contract type", { title: "Kontratë testuese" }],
    [
      "invalid contract type",
      { title: "Kontratë testuese", contractType: "other" }
    ]
  ])("rejects %s", async (_caseName, body) => {
    const createContract = vi.fn<CreateContract>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      createContract
    });
    const response = await request(app)
      .post("/api/contracts")
      .set("Authorization", "Bearer valid-test-value")
      .send(body);

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(response.body.error.message).toBe(
      "Të dhënat e dërguara nuk janë valide."
    );
    expect(Array.isArray(response.body.error.details)).toBe(true);
    expect(createContract).not.toHaveBeenCalled();
  });

  it.each(["ownerId", "owner_id", "status"])(
    "rejects the forbidden %s field",
    async (field) => {
      const createContract = vi.fn<CreateContract>();
      const app = createApp({
        authMiddleware: authenticatedMiddleware,
        createContract
      });
      const response = await request(app)
        .post("/api/contracts")
        .set("Authorization", "Bearer valid-test-value")
        .send({
          title: "Kontratë testuese",
          contractType: "employment",
          [field]: "untrusted-value"
        });

      expect(response.status).toBe(400);
      expect(response.body.error.code).toBe("VALIDATION_ERROR");
      expect(createContract).not.toHaveBeenCalled();
    }
  );

  it.each(["employment", "service", "lease"] as const)(
    "accepts the %s contract type",
    async (contractType) => {
      const createdContract = { ...contract, contract_type: contractType };
      const createContract = vi.fn<CreateContract>(async () => createdContract);
      const app = createApp({
        authMiddleware: authenticatedMiddleware,
        createContract
      });
      const response = await request(app)
        .post("/api/contracts")
        .set("Authorization", "Bearer valid-test-value")
        .send({ title: "  Kontratë testuese  ", contractType });

      expect(response.status).toBe(201);
      expect(response.body).toEqual({
        data: {
          contract: createdContract
        }
      });
      expect(createContract).toHaveBeenCalledWith(
        expect.objectContaining({ userId: "user-a" }),
        { title: "Kontratë testuese", contractType }
      );
    }
  );

  it("uses the authenticated identity instead of request body identity", async () => {
    const createContract = vi.fn<CreateContract>(async (authenticatedUser) => ({
      ...contract,
      owner_id: authenticatedUser.userId
    }));
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      createContract
    });
    const response = await request(app)
      .post("/api/contracts")
      .set("Authorization", "Bearer valid-test-value")
      .send({ title: "Kontratë testuese", contractType: "employment" });

    expect(response.status).toBe(201);
    expect(response.body.data.contract.owner_id).toBe("user-a");
    expect(createContract.mock.calls[0]?.[0].userId).toBe("user-a");
  });

  it("returns a safe error when the database is unavailable", async () => {
    const createContract: CreateContract = async () => {
      throw new ApiError(
        503,
        "DATABASE_UNAVAILABLE",
        "The contract could not be created at this time."
      );
    };
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      createContract
    });
    const response = await request(app)
      .post("/api/contracts")
      .set("Authorization", "Bearer valid-test-value")
      .send({ title: "Kontratë testuese", contractType: "employment" });

    expect(response.status).toBe(503);
    expect(response.body).toEqual({
      error: {
        code: "DATABASE_UNAVAILABLE",
        message: "The contract could not be created at this time.",
        details: null
      }
    });
  });
});

describe("GET /api/contracts", () => {
  it("requires authentication", async () => {
    const response = await request(createApp()).get("/api/contracts");

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
  });

  it("returns an empty list", async () => {
    const getContracts: ListContracts = async () => [];
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      getContracts
    });
    const response = await request(app)
      .get("/api/contracts")
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      data: {
        contracts: []
      },
      meta: {
        limit: 50,
        count: 0
      }
    });
  });

  it("passes only verified user identity to the contracts service", async () => {
    const getContracts = vi.fn<ListContracts>(async (authenticatedUser) => {
      expect(authenticatedUser.userId).toBe("user-a");
      return [listedContract];
    });
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      getContracts
    });
    const response = await request(app)
      .get("/api/contracts")
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(200);
    expect(response.body.data.contracts).toEqual([listedContract]);
    expect(
      response.body.data.contracts.every(
        (item: ContractListItem) => item.owner_id === "user-a"
      )
    ).toBe(true);
  });

  it("rejects invalid query parameters", async () => {
    const getContracts = vi.fn<ListContracts>();
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      getContracts
    });
    const response = await request(app)
      .get("/api/contracts?status=unknown")
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe("VALIDATION_ERROR");
    expect(getContracts).not.toHaveBeenCalled();
  });

  it("returns a safe error when the database is unavailable", async () => {
    const getContracts: ListContracts = async () => {
      throw new ApiError(
        503,
        "DATABASE_UNAVAILABLE",
        "Contracts are temporarily unavailable."
      );
    };
    const app = createApp({
      authMiddleware: authenticatedMiddleware,
      getContracts
    });
    const response = await request(app)
      .get("/api/contracts")
      .set("Authorization", "Bearer valid-test-value");

    expect(response.status).toBe(503);
    expect(response.body).toEqual({
      error: {
        code: "DATABASE_UNAVAILABLE",
        message: "Contracts are temporarily unavailable.",
        details: null
      }
    });
  });
});

describe("contracts service ownership", () => {
  it("enriches contracts with the latest completed current-pipeline analysis in two queries", async () => {
    const secondContract: ContractMetadata = {
      ...contract,
      id: "22222222-2222-4222-8222-222222222222",
      title: "Kontratë pa analizë",
      created_at: "2026-08-07T10:00:00.000Z",
      updated_at: "2026-08-07T10:00:00.000Z"
    };
    const latestAnalysis = {
      id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
      contract_version_id: "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb",
      overall_risk_level: "high",
      completed_at: "2026-08-09T12:00:00.000Z",
      contract_versions: {
        contract_id: contract.id,
        contracts: { owner_id: "user-a" }
      }
    };
    const olderAnalysis = {
      ...latestAnalysis,
      id: "cccccccc-cccc-4ccc-8ccc-cccccccccccc",
      contract_version_id: "dddddddd-dddd-4ddd-8ddd-dddddddddddd",
      overall_risk_level: "medium",
      completed_at: "2026-08-08T12:00:00.000Z"
    };

    const contractsQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      order: vi.fn(),
      limit: vi.fn(),
      ilike: vi.fn(),
      then: (
        resolve: (value: { data: ContractMetadata[]; error: null }) => unknown,
        reject: (reason: unknown) => unknown
      ) =>
        Promise.resolve({ data: [contract, secondContract], error: null }).then(
          resolve,
          reject
        )
    };
    contractsQuery.select.mockReturnValue(contractsQuery);
    contractsQuery.eq.mockReturnValue(contractsQuery);
    contractsQuery.order.mockReturnValue(contractsQuery);
    contractsQuery.limit.mockReturnValue(contractsQuery);
    contractsQuery.ilike.mockReturnValue(contractsQuery);

    const analysesQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      in: vi.fn(),
      order: vi.fn(),
      then: (
        resolve: (value: { data: unknown[]; error: null }) => unknown,
        reject: (reason: unknown) => unknown
      ) =>
        Promise.resolve({
          data: [latestAnalysis, olderAnalysis],
          error: null
        }).then(resolve, reject)
    };
    analysesQuery.select.mockReturnValue(analysesQuery);
    analysesQuery.eq.mockReturnValue(analysesQuery);
    analysesQuery.in.mockReturnValue(analysesQuery);
    analysesQuery.order.mockReturnValue(analysesQuery);

    const from = vi.fn((table: string) =>
      table === "contracts" ? contractsQuery : analysesQuery
    );
    const createClient = vi.fn(
      () => ({ from }) as unknown as SupabaseClient
    );

    const result = await createListContracts(createClient)(
      { userId: "user-a", accessToken: "verified-test-value" },
      { limit: 50 }
    );

    expect(from).toHaveBeenCalledTimes(2);
    expect(analysesQuery.eq).toHaveBeenCalledWith("status", "completed");
    expect(analysesQuery.in).toHaveBeenCalledWith("pipeline_version", [
      "analysis-rag-v1",
      "analysis-v1"
    ]);
    expect(analysesQuery.in).toHaveBeenCalledWith(
      "contract_versions.contract_id",
      [contract.id, secondContract.id]
    );
    expect(analysesQuery.order).toHaveBeenCalledWith("completed_at", {
      ascending: false
    });
    expect(result.map((item) => item.id)).toEqual([
      contract.id,
      secondContract.id
    ]);
    expect(result[0]?.latestCompletedAnalysis).toEqual({
      id: latestAnalysis.id,
      versionId: latestAnalysis.contract_version_id,
      overallRisk: "high",
      completedAt: latestAnalysis.completed_at
    });
    expect(result[1]?.latestCompletedAnalysis).toBeNull();
    expect(JSON.stringify(result)).not.toContain("result_json");
    expect(JSON.stringify(result)).not.toContain("clauses");
    expect(JSON.stringify(result)).not.toContain("status_history");
  });

  it("does not query analyses when the bounded contract list is empty", async () => {
    const contractsQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      order: vi.fn(),
      limit: vi.fn(),
      ilike: vi.fn(),
      then: (
        resolve: (value: { data: never[]; error: null }) => unknown,
        reject: (reason: unknown) => unknown
      ) => Promise.resolve({ data: [], error: null }).then(resolve, reject)
    };
    contractsQuery.select.mockReturnValue(contractsQuery);
    contractsQuery.eq.mockReturnValue(contractsQuery);
    contractsQuery.order.mockReturnValue(contractsQuery);
    contractsQuery.limit.mockReturnValue(contractsQuery);
    contractsQuery.ilike.mockReturnValue(contractsQuery);

    const from = vi.fn(() => contractsQuery);
    const getContracts = createListContracts(
      vi.fn(() => ({ from }) as unknown as SupabaseClient)
    );

    await expect(
      getContracts(
        { userId: "user-a", accessToken: "verified-test-value" },
        { limit: 50 }
      )
    ).resolves.toEqual([]);
    expect(from).toHaveBeenCalledTimes(1);
  });

  it("hides raw errors from the latest-analysis query", async () => {
    const contractsQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      order: vi.fn(),
      limit: vi.fn(),
      ilike: vi.fn(),
      then: (
        resolve: (value: { data: ContractMetadata[]; error: null }) => unknown,
        reject: (reason: unknown) => unknown
      ) => Promise.resolve({ data: [contract], error: null }).then(resolve, reject)
    };
    contractsQuery.select.mockReturnValue(contractsQuery);
    contractsQuery.eq.mockReturnValue(contractsQuery);
    contractsQuery.order.mockReturnValue(contractsQuery);
    contractsQuery.limit.mockReturnValue(contractsQuery);
    contractsQuery.ilike.mockReturnValue(contractsQuery);

    const analysesQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      in: vi.fn(),
      order: vi.fn(async () => ({
        data: null,
        error: { message: "sensitive SQL detail" }
      }))
    };
    analysesQuery.select.mockReturnValue(analysesQuery);
    analysesQuery.eq.mockReturnValue(analysesQuery);
    analysesQuery.in.mockReturnValue(analysesQuery);

    const from = vi.fn((table: string) =>
      table === "contracts" ? contractsQuery : analysesQuery
    );
    const getContracts = createListContracts(
      vi.fn(() => ({ from }) as unknown as SupabaseClient)
    );

    await expect(
      getContracts(
        { userId: "user-a", accessToken: "verified-test-value" },
        { limit: 50 }
      )
    ).rejects.toMatchObject({
      statusCode: 503,
      code: "DATABASE_UNAVAILABLE",
      message: "Contracts are temporarily unavailable."
    });
  });

  it("uses the user access token and an explicit owner filter", async () => {
    const contractsQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      order: vi.fn(),
      limit: vi.fn(),
      ilike: vi.fn(),
      then: (
        resolve: (value: { data: ContractMetadata[]; error: null }) => unknown,
        reject: (reason: unknown) => unknown
      ) => Promise.resolve({ data: [contract], error: null }).then(resolve, reject)
    };

    contractsQuery.select.mockReturnValue(contractsQuery);
    contractsQuery.eq.mockReturnValue(contractsQuery);
    contractsQuery.order.mockReturnValue(contractsQuery);
    contractsQuery.limit.mockReturnValue(contractsQuery);
    contractsQuery.ilike.mockReturnValue(contractsQuery);

    const analysesQuery = {
      select: vi.fn(),
      eq: vi.fn(),
      in: vi.fn(),
      order: vi.fn(),
      then: (
        resolve: (value: { data: never[]; error: null }) => unknown,
        reject: (reason: unknown) => unknown
      ) => Promise.resolve({ data: [], error: null }).then(resolve, reject)
    };

    analysesQuery.select.mockReturnValue(analysesQuery);
    analysesQuery.eq.mockReturnValue(analysesQuery);
    analysesQuery.in.mockReturnValue(analysesQuery);
    analysesQuery.order.mockReturnValue(analysesQuery);

    const from = vi.fn((table: string) =>
      table === "contracts" ? contractsQuery : analysesQuery
    );
    const createClient = vi.fn(
      () => ({ from }) as unknown as SupabaseClient
    );
    const getContracts = createListContracts(createClient);

    const result = await getContracts(
      { userId: "user-a", accessToken: "verified-test-value" },
      { limit: 50 }
    );

    expect(createClient).toHaveBeenCalledWith("verified-test-value");
    expect(from).toHaveBeenCalledWith("contracts");
    expect(from).toHaveBeenCalledWith("analyses");
    expect(contractsQuery.eq).toHaveBeenCalledWith("owner_id", "user-a");
    expect(analysesQuery.eq).toHaveBeenCalledWith("requested_by", "user-a");
    expect(analysesQuery.eq).toHaveBeenCalledWith(
      "contract_versions.contracts.owner_id",
      "user-a"
    );
    expect(result).toEqual([listedContract]);
  });

  it("creates a contract with a user-scoped client and trusted owner identity", async () => {
    const single = vi.fn(async () => ({ data: contract, error: null }));
    const select = vi.fn(() => ({ single }));
    const insert = vi.fn(() => ({ select }));
    const from = vi.fn(() => ({ insert }));
    const createClient = vi.fn(
      () => ({ from }) as unknown as SupabaseClient
    );
    const createContract = createCreateContract(createClient);

    const result = await createContract(
      { userId: "user-a", accessToken: "verified-test-value" },
      { title: "Kontratë testuese", contractType: "employment" }
    );

    expect(createClient).toHaveBeenCalledWith("verified-test-value");
    expect(from).toHaveBeenCalledWith("contracts");
    expect(insert).toHaveBeenCalledWith({
      owner_id: "user-a",
      title: "Kontratë testuese",
      contract_type: "employment"
    });
    expect(result).toEqual(contract);
  });

  it("does not expose raw database errors from contract creation", async () => {
    const single = vi.fn(async () => ({
      data: null,
      error: { message: "sensitive database detail" }
    }));
    const select = vi.fn(() => ({ single }));
    const insert = vi.fn(() => ({ select }));
    const from = vi.fn(() => ({ insert }));
    const createClient = vi.fn(
      () => ({ from }) as unknown as SupabaseClient
    );
    const createContract = createCreateContract(createClient);

    await expect(
      createContract(
        { userId: "user-a", accessToken: "verified-test-value" },
        { title: "Kontratë testuese", contractType: "employment" }
      )
    ).rejects.toMatchObject({
      statusCode: 503,
      code: "DATABASE_UNAVAILABLE",
      message: "The contract could not be created at this time."
    });
  });
});
