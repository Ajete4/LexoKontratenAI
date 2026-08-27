import { beforeEach, describe, expect, it, vi } from "vitest";

vi.hoisted(() => {
  process.env.DOTENV_CONFIG_PATH = "NUL";
  process.env.OPENAI_API_KEY = "";
});

import {
  createLegalEmbeddingAdapter,
  getLegalEmbeddingDiagnosticReason,
  type LegalEmbeddingOpenAIClient
} from "../src/legal/legal-embedding-adapter.js";
import {
  LEGAL_EMBEDDING_BATCH_SIZE,
  LEGAL_EMBEDDING_DIMENSIONS,
  LEGAL_EMBEDDING_MAX_RETRIES,
  LEGAL_EMBEDDING_MODEL
} from "../src/legal/legal-embedding-config.js";
import { env, envSchema } from "../src/config/env.js";
import { ApiError } from "../src/utils/ApiError.js";

const ids = [
  "00000000-0000-4000-8000-000000000001",
  "00000000-0000-4000-8000-000000000002"
] as const;
const vector = () => Array.from({ length: 1_536 }, () => 0.25);

function mockClient(response: unknown, rejects = false) {
  const create = rejects
    ? vi.fn().mockRejectedValue(response)
    : vi.fn().mockResolvedValue(response);
  return {
    client: { embeddings: { create } } as unknown as LegalEmbeddingOpenAIClient,
    create
  };
}

describe("legal embedding adapter", () => {
  beforeEach(() => vi.clearAllMocks());

  it("uses the fixed model, dimensions, float encoding and safe request options", async () => {
    const { client, create } = mockClient({
      data: [
        { index: 0, embedding: vector() },
        { index: 1, embedding: vector() }
      ]
    });

    await createLegalEmbeddingAdapter(client).embedLegalChunks({
      items: [
        { chunkId: ids[0], content: "Përmbajtja e parë." },
        { chunkId: ids[1], content: "Përmbajtja e dytë." }
      ]
    });

    expect(create).toHaveBeenCalledTimes(1);
    expect(create.mock.calls[0]).toEqual([
      {
        model: LEGAL_EMBEDDING_MODEL,
        input: ["Përmbajtja e parë.", "Përmbajtja e dytë."],
        dimensions: LEGAL_EMBEDDING_DIMENSIONS,
        encoding_format: "float"
      },
      {
        timeout: env.OPENAI_REQUEST_TIMEOUT_MS,
        maxRetries: LEGAL_EMBEDDING_MAX_RETRIES
      }
    ]);
  });

  it("uses the approved defaults without requiring an API key", () => {
    const parsed = envSchema.safeParse({
      NODE_ENV: "test",
      SUPABASE_URL: "https://example.supabase.co",
      SUPABASE_PUBLISHABLE_KEY: "placeholder",
      SUPABASE_SECRET_KEY: "sb_secret_placeholder",
      OPENAI_API_KEY: ""
    });
    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.OPENAI_EMBEDDING_MODEL).toBe("text-embedding-3-small");
      expect(parsed.data.OPENAI_API_KEY).toBeUndefined();
    }
    expect(LEGAL_EMBEDDING_DIMENSIONS).toBe(1_536);
    expect(LEGAL_EMBEDDING_BATCH_SIZE).toBe(50);
  });

  it.each([
    [{ items: [] }, "empty batch"],
    [
      {
        items: Array.from({ length: 51 }, (_, index) => ({
          chunkId: `00000000-0000-4000-8000-${String(index).padStart(12, "0")}`,
          content: "tekst"
        }))
      },
      "oversized batch"
    ],
    [{ items: [{ chunkId: "invalid", content: "tekst" }] }, "invalid UUID"],
    [
      {
        items: [
          { chunkId: ids[0], content: "a" },
          { chunkId: ids[0], content: "b" }
        ]
      },
      "duplicate UUID"
    ],
    [{ items: [{ chunkId: ids[0], content: "   " }] }, "blank content"],
    [
      { items: [{ chunkId: ids[0], content: "a".repeat(6_001) }] },
      "oversized content"
    ],
    [
      { items: [{ chunkId: ids[0], content: "tekst", extra: true }] },
      "additional field"
    ]
  ])("rejects invalid input: %s", async (input, _label) => {
    const { client, create } = mockClient({ data: [] });
    await expect(
      createLegalEmbeddingAdapter(client).embedLegalChunks(input)
    ).rejects.toMatchObject({ code: "LEGAL_EMBEDDING_INPUT_INVALID" });
    expect(create).not.toHaveBeenCalled();
  });

  it.each([
    [{ data: [] }, "count"],
    [{ data: [{ index: 1, embedding: vector() }] }, "missing index"],
    [
      {
        data: [
          { index: 0, embedding: vector() },
          { index: 0, embedding: vector() }
        ]
      },
      "duplicate index"
    ],
    [{ data: [{ index: 2, embedding: vector() }] }, "index outside range"],
    [{ data: [{ index: 0, embedding: [0.1] }] }, "dimensions"],
    [
      { data: [{ index: 0, embedding: [...vector().slice(0, -1), Number.NaN] }] },
      "NaN"
    ],
    [
      { data: [{ index: 0, embedding: [...vector().slice(0, -1), Infinity] }] },
      "Infinity"
    ],
    [
      { data: [{ index: 0, embedding: [...vector().slice(0, -1), "x"] }] },
      "non-number"
    ]
  ])("rejects invalid output: %s", async (response) => {
    const { client } = mockClient(response);
    await expect(
      createLegalEmbeddingAdapter(client).embedLegalChunks({
        items: [{ chunkId: ids[0], content: "tekst" }]
      })
    ).rejects.toMatchObject({ code: "LEGAL_EMBEDDING_OUTPUT_INVALID" });
  });

  it("restores input order from response indexes", async () => {
    const first = vector();
    const second = vector();
    first[0] = 1;
    second[0] = 2;
    const { client } = mockClient({
      data: [
        { index: 1, embedding: second },
        { index: 0, embedding: first }
      ]
    });
    const result = await createLegalEmbeddingAdapter(client).embedLegalChunks({
      items: [
        { chunkId: ids[0], content: "a" },
        { chunkId: ids[1], content: "b" }
      ]
    });
    expect(result.map((item) => [item.chunkId, item.embedding[0]])).toEqual([
      [ids[0], 1],
      [ids[1], 2]
    ]);
  });

  it("does not trim or otherwise change accepted legal content", async () => {
    const content = "  Përmbajtje juridike me hapësira të qëllimshme.  ";
    const { client, create } = mockClient({
      data: [{ index: 0, embedding: vector() }]
    });

    await createLegalEmbeddingAdapter(client).embedLegalChunks({
      items: [{ chunkId: ids[0], content }]
    });

    expect(create.mock.calls[0]![0].input).toEqual([content]);
  });

  it.each([
    [new ApiError(503, "AI_CONFIGURATION_MISSING", "safe"), "AI_CONFIGURATION_MISSING", "configuration_missing"],
    [{ status: 401 }, "AI_CONFIGURATION_MISSING", "authentication_or_authorization"],
    [{ status: 403 }, "AI_CONFIGURATION_MISSING", "authentication_or_authorization"],
    [{ status: 429 }, "LEGAL_EMBEDDING_RATE_LIMITED", "rate_limited"],
    [{ name: "APIConnectionTimeoutError" }, "LEGAL_EMBEDDING_TIMEOUT", "timeout_or_abort"],
    [{ name: "AbortError" }, "LEGAL_EMBEDDING_TIMEOUT", "timeout_or_abort"],
    [{ code: "ETIMEDOUT" }, "LEGAL_EMBEDDING_TIMEOUT", "timeout_or_abort"],
    [{ code: "ENOTFOUND" }, "LEGAL_EMBEDDING_UNAVAILABLE", "network_dns_tls"],
    [{ status: 500 }, "LEGAL_EMBEDDING_UNAVAILABLE", "upstream_unavailable"],
    [{ unexpected: true }, "LEGAL_EMBEDDING_UNAVAILABLE", "unknown"],
    [new TypeError("network"), "LEGAL_EMBEDDING_UNAVAILABLE", "network_dns_tls"]
  ])("maps upstream errors safely", async (error, code, reason) => {
    const { client, create } = mockClient(error, true);
    let thrown: unknown;
    try {
      await createLegalEmbeddingAdapter(client).embedLegalChunks({
        items: [{ chunkId: ids[0], content: "sensitive legal content" }]
      });
    } catch (caught) {
      thrown = caught;
    }
    expect(thrown).toMatchObject({ code });
    expect(getLegalEmbeddingDiagnosticReason(thrown)).toBe(reason);
    expect(create).toHaveBeenCalledTimes(1);
  });

  it("classifies invalid upstream output without exposing it", async () => {
    const { client } = mockClient({ data: [] });
    let thrown: unknown;
    try {
      await createLegalEmbeddingAdapter(client).embedLegalChunks({
        items: [{ chunkId: ids[0], content: "sensitive legal content" }]
      });
    } catch (error) {
      thrown = error;
    }
    expect(thrown).toMatchObject({ code: "LEGAL_EMBEDDING_OUTPUT_INVALID" });
    expect(getLegalEmbeddingDiagnosticReason(thrown)).toBe("output_invalid");
  });

  it("does not log or expose upstream secrets and content", async () => {
    const secret = "sk-test-placeholder";
    const content = "sensitive legal content";
    const { client } = mockClient(
      { status: 500, message: `${secret}:${content}` },
      true
    );
    const log = vi.spyOn(console, "log").mockImplementation(() => {});
    const errorLog = vi.spyOn(console, "error").mockImplementation(() => {});
    let thrown: unknown;
    try {
      await createLegalEmbeddingAdapter(client).embedLegalChunks({
        items: [{ chunkId: ids[0], content }]
      });
    } catch (error) {
      thrown = error;
    }
    expect(JSON.stringify(thrown)).not.toContain(secret);
    expect(JSON.stringify(thrown)).not.toContain(content);
    expect(log).not.toHaveBeenCalled();
    expect(errorLog).not.toHaveBeenCalled();
    log.mockRestore();
    errorLog.mockRestore();
  });
});
