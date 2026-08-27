import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it, vi } from "vitest";

import { runLegalRetrievalEvaluation } from "../src/legal/legal-retrieval-evaluation-runner.js";
import type { createLegalRetrievalService } from "../src/legal/legal-retrieval.service.js";

describe("real legal retrieval evaluation runner", () => {
  it("runs exactly nine controlled cases and sanitizes the report", async () => {
    const retrieve = vi.fn(async () => [
      {
        chunkId: "00000000-0000-4000-8000-000000000001",
        legalSourceId: "00000000-0000-4000-8000-000000000002",
        lawNumber: "03/L-212" as const,
        sourceTitle: "Burimi",
        versionLabel: "version",
        officialUrl: "https://example.test",
        officialDocumentUrl: null,
        documentType: "law" as const,
        applicabilityMode: "direct" as const,
        chunkIndex: 70,
        articleNumber: "71",
        articleTitle: "Koha e njoftimit",
        paragraphNumber: null,
        pointLabel: null,
        content: "Tekst i plotë që nuk duhet të ruhet.",
        contentHash: "a".repeat(64),
        similarity: 0.9
      }
    ]);
    const report = await runLegalRetrievalEvaluation({ retrieve } as ReturnType<
      typeof createLegalRetrievalService
    >);
    const serialized = JSON.stringify(report);

    expect(retrieve).toHaveBeenCalledTimes(9);
    expect(report.cases).toHaveLength(9);
    expect(serialized).not.toContain("Tekst i plotë");
    expect(serialized).not.toMatch(
      /"(?:chunkId|legalSourceId|embedding|queryVector)"\s*:/u
    );
    expect(report.configuration.maximumOpenAiRequests).toBe(9);
    expect(report.configuration.maximumRpcCalls).toBe(9);
  });

  it("keeps the production script free of sensitive logging", async () => {
    const source = await readFile(
      resolve(process.cwd(), "scripts/run-legal-retrieval-evaluation.ts"),
      "utf8"
    );
    expect(source).not.toMatch(/console\.(?:log|error)/u);
    expect(source).toContain('mode !== "--execute"');
    expect(source).not.toMatch(/OPENAI_API_KEY\s*=|SUPABASE_SECRET_KEY\s*=/u);
  });
});
