import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

const migrationSql = readFileSync(
  fileURLToPath(
    new URL(
      "../supabase/migrations/0006_legal_semantic_retrieval.sql",
      import.meta.url
    )
  ),
  "utf8"
);
const preflightSql = readFileSync(
  fileURLToPath(
    new URL("../supabase/checks/0006_retrieval_preflight.sql", import.meta.url)
  ),
  "utf8"
);
const postflightSql = readFileSync(
  fileURLToPath(
    new URL("../supabase/checks/0006_retrieval_postflight.sql", import.meta.url)
  ),
  "utf8"
);

const tableWriteStatement = /^\s*(?:insert|update|delete|truncate)\b/imu;

describe("legal semantic retrieval migration", () => {
  it("defines the controlled 1,536-dimensional RPC signature", () => {
    expect(migrationSql).toMatch(
      /create or replace function public\.match_legal_chunks\([\s\S]*p_query_embedding extensions\.vector\(1536\)[\s\S]*p_contract_type text[\s\S]*p_match_count integer default 8[\s\S]*p_min_similarity double precision default 0\.50/iu
    );
    expect(migrationSql).toMatch(
      /extensions\.vector_dims\(p_query_embedding\) <> 1536/iu
    );
  });

  it("validates contract type, match count and similarity bounds", () => {
    expect(migrationSql).toContain("('employment', 'service', 'lease')");
    expect(migrationSql).toMatch(/p_match_count < 1 or p_match_count > 20/iu);
    expect(migrationSql).toMatch(
      /p_min_similarity < 0[\s\S]*p_min_similarity > 1/iu
    );
    expect(migrationSql).toContain("LEGAL_RETRIEVAL_QUERY_EMBEDDING_INVALID");
  });

  it("uses cosine matching over only approved embedded P0 sources", () => {
    expect(migrationSql).toContain(
      "chunks.embedding OPERATOR(extensions.<=>) p_query_embedding"
    );
    expect(migrationSql).toContain(
      "chunks.embedding_model = 'text-embedding-3-small'"
    );
    expect(migrationSql).toContain("sources.status = 'verified'");
    expect(migrationSql).toContain("sources.verified_source = true");
    expect(migrationSql).toContain("sources.ingestion_status = 'ingested'");
    expect(migrationSql).toContain(
      "sources.applicability @> array[p_contract_type]::text[]"
    );
    expect(migrationSql).toContain(
      "sources.law_number in ('03/L-212', '04/L-077', '08/L-142')"
    );
  });

  it("keeps amendments isolated and never constructs consolidated text", () => {
    expect(migrationSql).toMatch(
      /sources\.document_type = 'amendment'[\s\S]*sources\.applicability_mode = 'amendment_scope'/iu
    );
    expect(migrationSql).not.toMatch(/legal_source_relations|consolidat(?:e|ed|ion)\s*\(/iu);
  });

  it("returns only the approved retrieval and citation fields", () => {
    const returnTableBlock = migrationSql.match(
      /returns table \(([\s\S]*?)\)\s*language plpgsql/iu
    )?.[1];

    expect(returnTableBlock).toBeDefined();
    for (const field of [
      "chunk_id uuid",
      "legal_source_id uuid",
      "law_number text",
      "source_title text",
      "version_label text",
      "official_url text",
      "official_document_url text",
      "document_type text",
      "applicability_mode text",
      "chunk_index integer",
      "article_number varchar(64)",
      "article_title varchar(300)",
      "paragraph_number varchar(64)",
      "point_label varchar(64)",
      "content text",
      "content_hash text",
      "similarity double precision"
    ]) {
      expect(returnTableBlock).toContain(field);
    }
    expect(returnTableBlock).not.toMatch(
      /\b(?:embedding|storage_path|status_history|metadata)\b/iu
    );
  });

  it("orders deterministically while retaining an index-compatible inner order", () => {
    expect(migrationSql).toMatch(
      /order by\s+chunks\.embedding OPERATOR\(extensions\.<=>\) p_query_embedding asc[\s\S]*limit p_match_count/iu
    );
    expect(migrationSql).toMatch(
      /order by[\s\S]*matches\.similarity desc,[\s\S]*matches\.law_number asc,[\s\S]*matches\.chunk_index asc/iu
    );
  });

  it("uses a hardened service-role-only security boundary", () => {
    expect(migrationSql).toMatch(/stable[\s\S]*security definer/iu);
    expect(migrationSql).toContain("set search_path = pg_catalog");
    for (const role of ["public", "anon", "authenticated"]) {
      expect(migrationSql).toMatch(
        new RegExp(
          `revoke all on function public\\.match_legal_chunks\\([\\s\\S]*?\\) from ${role}`,
          "iu"
        )
      );
    }
    expect(migrationSql).toMatch(
      /grant execute on function public\.match_legal_chunks\([\s\S]*?\) to service_role/iu
    );
  });

  it("is read-only and changes no corpus rows or prior schema", () => {
    expect(migrationSql).not.toMatch(tableWriteStatement);
    expect(migrationSql).not.toMatch(
      /\b(?:alter table|create table|drop table|truncate|clause_citations|openai)\b/iu
    );
    expect(migrationSql).not.toMatch(/\[[\s\d.,-]{100,}\]/u);
  });

  it("provides read-only preflight, postflight and manual HNSW explain", () => {
    expect(preflightSql).not.toMatch(tableWriteStatement);
    expect(postflightSql).not.toMatch(tableWriteStatement);
    expect(preflightSql).toContain("total_chunks");
    expect(preflightSql).toContain("embedded_chunks");
    expect(preflightSql).toContain("legal_chunks_embedding_hnsw_cosine_idx");
    expect(preflightSql).toContain("applicability_mode");
    expect(preflightSql).toContain("relrowsecurity");
    expect(postflightSql).toContain("pg_get_function_identity_arguments");
    expect(postflightSql).toContain("security_definer");
    expect(postflightSql).toContain("service_role_execute");
    expect(postflightSql).toContain("array_fill(0.001::real, array[1536])");
    expect(postflightSql).toMatch(/explain \(costs, verbose, format text\)/iu);
    expect(`${preflightSql}\n${postflightSql}`).not.toMatch(/\bopenai\b/iu);
  });
});
