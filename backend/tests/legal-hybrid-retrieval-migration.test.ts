import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

const migrationPath = resolve(process.cwd(), "supabase/migrations/0007_legal_hybrid_retrieval.sql");

describe("0007 legal hybrid retrieval migration", () => {
  it("creates simple FTS, semantic candidates and deterministic RRF", async () => {
    const sql = await readFile(migrationPath, "utf8");
    expect(sql).toContain("legal_chunks_content_fts_simple_idx");
    expect(sql).toMatch(/to_tsvector\([\s\S]*pg_catalog\.simple/iu);
    expect(sql).toContain("plainto_tsquery");
    expect(sql).toContain("eligible as not materialized");
    expect(sql).toContain(") @@ v_lexical_query as lexical_matches");
    expect(sql).toContain("semantic_candidates");
    expect(sql).toContain("lexical_candidates");
    expect(sql).toContain("1.0 / (p_rrf_k + semantic_candidates.semantic_rank)");
    expect(sql).toContain("full outer join lexical_candidates");
  });

  it("validates every input and enforces contract scope before ranking", async () => {
    const sql = await readFile(migrationPath, "utf8");
    for (const code of [
      "QUERY_EMBEDDING_INVALID", "QUERY_TEXT_INVALID", "CONTRACT_TYPE_INVALID",
      "MATCH_COUNT_INVALID", "CANDIDATE_COUNT_INVALID", "MIN_SIMILARITY_INVALID", "RRF_K_INVALID"
    ]) expect(sql).toContain(code);
    expect(sql).toContain("p_contract_type = 'employment'");
    expect(sql).toContain("sources.law_number in ('03/L-212', '08/L-142')");
    expect(sql).toContain("p_contract_type in ('service', 'lease')");
    expect(sql).toContain("sources.law_number = '04/L-077'");
  });

  it("keeps the RPC read-only and service-role-only", async () => {
    const sql = await readFile(migrationPath, "utf8");
    expect(sql).toContain("stable");
    expect(sql).toContain("security definer");
    expect(sql).toContain("set search_path = pg_catalog");
    expect(sql).toMatch(/revoke all[\s\S]*from anon/iu);
    expect(sql).toMatch(/revoke all[\s\S]*from authenticated/iu);
    expect(sql).toMatch(/grant execute[\s\S]*to service_role/iu);
    expect(sql).not.toMatch(/\b(?:insert|update|delete|truncate)\b(?!\s+retrieval)/iu);
    expect(sql).not.toMatch(/execute\s+format|dynamic\s+sql/iu);
  });

  it("does not replace semantic RPC or alter corpus data", async () => {
    const sql = await readFile(migrationPath, "utf8");
    expect(sql).not.toMatch(/drop\s+(?:function|table|index)/iu);
    expect(sql).not.toMatch(/create\s+or\s+replace\s+function\s+public\.match_legal_chunks\s*\(/iu);
    expect(sql).not.toMatch(/alter\s+table/iu);
  });

  it("provides SELECT-only preflight and postflight checks", async () => {
    for (const file of ["0007_hybrid_retrieval_preflight.sql", "0007_hybrid_retrieval_postflight.sql"]) {
      const sql = await readFile(resolve(process.cwd(), "supabase/checks", file), "utf8");
      expect(sql).toMatch(/\bselect\b/iu);
      expect(sql).not.toMatch(/\b(?:insert|update|delete|truncate|alter|create|drop)\b/iu);
    }
  });

  it("preserves the approved calibration artifacts byte-for-byte", async () => {
    const expected = new Map([
      ["gold-set-v1.json", "F15A212AD111D7F9DDCA77E376E43C4BAB862E084DBC6376F04C6CA06D2E7FC3"],
      ["calibration-report.json", "94F05C30B75A793C858964C2D98A65CA9A4EAB791C67DB34C0AB7443AE0744CE"],
      ["calibration-checkpoint.json", "B5B4BB7CD2A14DCBBA685A37310F69A4028080BF3134A150195DBD1F32F0D5B2"]
    ]);
    for (const [file, hash] of expected) {
      const bytes = await readFile(resolve(process.cwd(), "data/legal-sources/retrieval", file));
      expect(createHash("sha256").update(bytes).digest("hex").toUpperCase()).toBe(hash);
    }
  });
});
