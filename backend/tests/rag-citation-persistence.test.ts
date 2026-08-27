import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import {
  ragCitationPersistencePayloadSchema,
  validateRagCitationProvenance
} from "../src/rag/rag-citation-persistence.schema.js";

const chunkId = "00000000-0000-4000-8000-000000000001";
const contentHash = "a".repeat(64);

function validPayload() {
  return {
    clause_evidence: [{
      clause_key: "clause-1",
      evidence_status: "grounded",
      citations: [{
        citation_id: "C1",
        legal_chunk_id: chunkId,
        citation_rank: 1,
        retrieval_method: "hybrid_rrf_v1",
        semantic_score: 0.72,
        lexical_score: null,
        fused_score: 0.031,
        content_hash: contentHash
      }]
    }]
  };
}

describe("RAG citation persistence contract", () => {
  it("accepts exact backend-owned provenance and validates the source hash", () => {
    const hashes = new Map([[chunkId, contentHash]]);
    expect(validateRagCitationProvenance(validPayload(), hashes)).toEqual(validPayload());
  });

  it("rejects a missing chunk or content-hash mismatch", () => {
    expect(() => validateRagCitationProvenance(validPayload(), new Map()))
      .toThrow("RAG_CITATION_PROVENANCE_INVALID");
    expect(() => validateRagCitationProvenance(validPayload(), new Map([[chunkId, "b".repeat(64)]])))
      .toThrow("RAG_CITATION_PROVENANCE_INVALID");
  });

  it("enforces grounded and insufficient-evidence coherence", () => {
    const insufficient = validPayload();
    insufficient.clause_evidence[0] = {
      clause_key: "clause-1",
      evidence_status: "insufficient_evidence",
      citations: []
    };
    expect(ragCitationPersistencePayloadSchema.safeParse(insufficient).success).toBe(true);

    expect(ragCitationPersistencePayloadSchema.safeParse({
      ...insufficient,
      clause_evidence: [{ ...insufficient.clause_evidence[0], evidence_status: "grounded" }]
    }).success).toBe(false);
    expect(ragCitationPersistencePayloadSchema.safeParse({
      ...validPayload(),
      clause_evidence: [{ ...validPayload().clause_evidence[0], evidence_status: "insufficient_evidence" }]
    }).success).toBe(false);
  });

  it("rejects duplicate IDs, ranks, chunks and clause keys", () => {
    const citation = validPayload().clause_evidence[0]!.citations[0]!;
    const duplicate = { ...citation };
    const duplicatedCitations = validPayload();
    duplicatedCitations.clause_evidence[0]!.citations.push(duplicate);
    expect(ragCitationPersistencePayloadSchema.safeParse(duplicatedCitations).success).toBe(false);

    const duplicatedClause = validPayload();
    duplicatedClause.clause_evidence.push({ ...duplicatedClause.clause_evidence[0]! });
    expect(ragCitationPersistencePayloadSchema.safeParse(duplicatedClause).success).toBe(false);
  });

  it("rejects URLs, law metadata, content and additional fields from persistence input", () => {
    const payload = validPayload() as Record<string, unknown>;
    const clauseEvidence = (payload.clause_evidence as Array<Record<string, unknown>>)[0]!;
    const citation = (clauseEvidence.citations as Array<Record<string, unknown>>)[0]!;
    citation.official_url = "https://example.test";
    citation.content = "not accepted";
    citation.law_number = "04/L-077";

    expect(ragCitationPersistencePayloadSchema.safeParse(payload).success).toBe(false);
  });

  it("creates an additive table and a separate atomic RPC with least privilege", async () => {
    const migration = await readFile(resolve(
      process.cwd(),
      "supabase/migrations/0008_clause_citations_and_atomic_rag_completion.sql"
    ), "utf8");

    expect(migration).toContain("create table public.clause_citations");
    expect(migration).toMatch(/references public\.clauses\s*\(id\) on delete cascade/iu);
    expect(migration).toMatch(/references public\.legal_chunks\s*\(id\) on delete restrict/iu);
    expect(migration).toContain("unique (clause_id, legal_chunk_id)");
    expect(migration).toContain("unique (clause_id, citation_rank)");
    expect(migration).toContain("unique (clause_id, citation_id)");
    expect(migration).toContain("alter table public.clause_citations enable row level security");
    expect(migration).toContain("grant all on table public.clause_citations to service_role");
    expect(migration).toContain("complete_contract_analysis_with_citations");
    expect(migration).toContain("from public.complete_contract_analysis(");
    expect(migration).toContain("CLAUSE_CITATION_PROVENANCE_INVALID");
    expect(migration).toContain("security definer");
    expect(migration).toMatch(/set\s+search_path\s*=\s*pg_catalog/iu);
    expect(migration).toMatch(/revoke\s+all\s+on\s+function\s+public\.complete_contract_analysis_with_citations[\s\S]*?from\s+anon/iu);
    expect(migration).toMatch(/revoke\s+all\s+on\s+function\s+public\.complete_contract_analysis_with_citations[\s\S]*?from\s+authenticated/iu);
    expect(migration).toMatch(/grant\s+execute\s+on\s+function\s+public\.complete_contract_analysis_with_citations[\s\S]*?to\s+service_role/iu);
  });

  it("contains no destructive corpus operation, vector fabrication or old migration edit", async () => {
    const migration = await readFile(resolve(
      process.cwd(),
      "supabase/migrations/0008_clause_citations_and_atomic_rag_completion.sql"
    ), "utf8");
    expect(migration).not.toMatch(/\b(?:truncate|drop table|delete from public\.legal_chunks|update public\.legal_chunks)\b/iu);
    expect(migration).not.toMatch(/vector\s*\(|embedding\s*=/iu);

    for (const name of [
      "0001_core_mvp_schema.sql",
      "0002_analysis_results_and_atomic_completion.sql",
      "0003_harden_analysis_completion_timestamp.sql"
    ]) {
      expect(await readFile(resolve(process.cwd(), "supabase/migrations", name), "utf8")).not.toContain(
        "complete_contract_analysis_with_citations"
      );
    }
  });
});
