import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

const migrationPath = fileURLToPath(
  new URL(
    "../supabase/migrations/0005_legal_chunk_embeddings.sql",
    import.meta.url
  )
);
const preflightPath = fileURLToPath(
  new URL("../supabase/checks/0005_embeddings_preflight.sql", import.meta.url)
);
const postflightPath = fileURLToPath(
  new URL("../supabase/checks/0005_embeddings_postflight.sql", import.meta.url)
);

const migrationSql = readFileSync(migrationPath, "utf8");
const preflightSql = readFileSync(preflightPath, "utf8");
const postflightSql = readFileSync(postflightPath, "utf8");

const writeStatement =
  /\b(?:insert|update|delete|truncate|alter|create|drop|grant|revoke)\b/iu;

describe("legal chunk embeddings migration", () => {
  it("enables pgvector idempotently in the Supabase extensions schema", () => {
    expect(migrationSql).toMatch(
      /create extension if not exists vector with schema extensions/iu
    );
    expect(migrationSql).toMatch(/embedding extensions\.vector\(1536\)/iu);
  });

  it("keeps all embedding fields nullable but atomically consistent", () => {
    expect(migrationSql).toMatch(/add column embedding extensions\.vector\(1536\),/iu);
    expect(migrationSql).toMatch(/add column embedding_model text,/iu);
    expect(migrationSql).toMatch(/add column embedded_at timestamptz,/iu);
    expect(migrationSql).toMatch(
      /embedding is null[\s\S]*embedding_model is null[\s\S]*embedded_at is null[\s\S]*or[\s\S]*embedding is not null[\s\S]*embedding_model is not null[\s\S]*embedded_at is not null/iu
    );
  });

  it("restricts the model and explicitly validates 1,536 dimensions", () => {
    expect(migrationSql).toContain("text-embedding-3-small");
    expect(migrationSql).toMatch(
      /embedding_model is null\s+or embedding_model = 'text-embedding-3-small'/iu
    );
    expect(migrationSql).toMatch(
      /embedding is null\s+or extensions\.vector_dims\(embedding\) = 1536/iu
    );
  });

  it("creates a partial HNSW cosine index", () => {
    expect(migrationSql).toMatch(
      /create index legal_chunks_embedding_hnsw_cosine_idx[\s\S]*using hnsw \(embedding extensions\.vector_cosine_ops\)[\s\S]*where embedding is not null/iu
    );
    expect(migrationSql).not.toMatch(/using\s+ivfflat/iu);
  });

  it("preserves RLS and direct-access restrictions", () => {
    expect(migrationSql).toMatch(
      /alter table public\.legal_chunks enable row level security/iu
    );
    for (const role of ["public", "anon", "authenticated"]) {
      expect(migrationSql).toMatch(
        new RegExp(
          `revoke all privileges on table public\\.legal_chunks from ${role}`,
          "iu"
        )
      );
    }
    expect(migrationSql).toMatch(
      /grant all privileges on table public\.legal_chunks to service_role/iu
    );
    expect(migrationSql).not.toMatch(
      /grant\s+(?:select|insert|update|delete)[^;]*to\s+(?:anon|authenticated)/iu
    );
  });

  it("is additive and creates no rows, vectors, deletes or truncations", () => {
    expect(migrationSql).not.toMatch(/\b(?:insert|update|delete|truncate)\b/iu);
    expect(migrationSql).not.toMatch(/drop\s+(?:table|column|constraint)/iu);
    expect(migrationSql).not.toMatch(/\[[\s\d.,-]{100,}\]/u);
    expect(migrationSql).not.toMatch(/insert\s+into\s+public\.legal_chunks/iu);
  });

  it("provides strictly read-only pgvector preflight checks", () => {
    expect(preflightSql).not.toMatch(writeStatement);
    expect(preflightSql).toContain("pg_available_extensions");
    expect(preflightSql).toContain("pg_available_extension_versions");
    expect(preflightSql).toContain("hnsw_compatible_version_available");
    expect(preflightSql).toContain("legal_chunk_count");
    expect(preflightSql).toContain("relrowsecurity");
    expect(preflightSql).toContain("role_table_grants");
  });

  it("provides a strictly read-only postflight for schema and unchanged rows", () => {
    expect(postflightSql).not.toMatch(writeStatement);
    expect(postflightSql).toContain("legal_chunks_embedding_state_check");
    expect(postflightSql).toContain("legal_chunks_embedding_model_check");
    expect(postflightSql).toContain("legal_chunks_embedding_dimensions_check");
    expect(postflightSql).toContain("legal_chunks_embedding_hnsw_cosine_idx");
    expect(postflightSql).toContain("embedded_chunk_count");
    expect(postflightSql).toContain("distinct_content_hashes");
    expect(postflightSql).toContain("relrowsecurity");
    expect(postflightSql).toContain(
      "pg_get_constraintdef(constraint_catalog.oid)"
    );
    expect(postflightSql).not.toContain("constraint_catalog.pg_constraint.oid");
  });

  it("does not modify earlier migrations or implement retrieval and citations", () => {
    expect(migrationSql).not.toMatch(/legal_source_relations/iu);
    expect(migrationSql).not.toMatch(/clause_citations/iu);
    expect(migrationSql).not.toMatch(/create\s+(?:or\s+replace\s+)?function/iu);
    expect(migrationSql).not.toMatch(
      /(?:create|select|call)\s+(?:function\s+)?(?:public\.)?match_legal/iu
    );
    expect(migrationSql).not.toMatch(/\bopenai\b/iu);
  });
});
