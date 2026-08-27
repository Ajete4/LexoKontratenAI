import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import {
  createLegalRetrievalEvaluationPlan,
  LEGAL_RETRIEVAL_EVALUATION_CASES
} from "../src/legal/legal-retrieval-evaluation.js";

describe("legal retrieval evaluation dry-run", () => {
  it("contains exactly nine deterministic scoped Albanian cases", () => {
    expect(LEGAL_RETRIEVAL_EVALUATION_CASES).toHaveLength(9);
    expect(new Set(LEGAL_RETRIEVAL_EVALUATION_CASES.map((item) => item.id)).size).toBe(9);
    expect(
      LEGAL_RETRIEVAL_EVALUATION_CASES.filter(
        (item) => item.contractType === "employment"
      )
    ).toHaveLength(3);
    expect(
      LEGAL_RETRIEVAL_EVALUATION_CASES.filter(
        (item) => item.contractType === "service"
      )
    ).toHaveLength(3);
    expect(
      LEGAL_RETRIEVAL_EVALUATION_CASES.filter(
        (item) => item.contractType === "lease"
      )
    ).toHaveLength(3);
  });

  it("produces a deterministic plan without results, vectors, UUIDs or credentials", () => {
    const first = `${JSON.stringify(createLegalRetrievalEvaluationPlan(), null, 2)}\n`;
    const second = `${JSON.stringify(createLegalRetrievalEvaluationPlan(), null, 2)}\n`;
    expect(second).toBe(first);
    expect(first).not.toMatch(/"(?:embedding|results?|uuid|timestamp)"\s*:/iu);
    expect(first).not.toMatch(/OPENAI_API_KEY|SUPABASE_|Bearer\s/iu);
    expect(first).toContain('"caseCount": 9');
  });

  it("keeps the runner dry-run-only and free of remote imports", async () => {
    const source = await readFile(
      resolve(process.cwd(), "scripts/plan-legal-retrieval-evaluation.ts"),
      "utf8"
    );
    expect(source).toContain('mode !== "--dry-run"');
    expect(source).not.toMatch(/\bfetch\s*\(|openai|supabase|\.rpc\s*\(/iu);
    expect(source).not.toMatch(/console\.(?:log|error)/u);
  });
});
