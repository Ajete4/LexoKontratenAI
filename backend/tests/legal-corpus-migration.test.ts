import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

const migrationPath = fileURLToPath(
  new URL(
    "../supabase/migrations/0004_legal_corpus_foundation.sql",
    import.meta.url
  )
);
const coreMigrationPath = fileURLToPath(
  new URL("../supabase/migrations/0001_core_mvp_schema.sql", import.meta.url)
);

const migrationSql = readFileSync(migrationPath, "utf8");
const cumulativeSchemaSql = `${readFileSync(coreMigrationPath, "utf8")}\n${migrationSql}`;

describe("legal corpus foundation migration", () => {
  it("is additive and does not delete tables or rows", () => {
    expect(migrationSql).toMatch(/alter table public\.legal_sources\s+add column/i);
    expect(migrationSql).toMatch(/create table public\.legal_chunks/i);
    expect(migrationSql).toMatch(/create table public\.legal_source_relations/i);
    expect(migrationSql).not.toMatch(/drop\s+(table|column|constraint)/i);
    expect(migrationSql).not.toMatch(/\b(delete|truncate)\s+(from\s+)?public\./i);
  });

  it("does not enable vector, create embeddings, or seed legal facts", () => {
    expect(migrationSql).not.toMatch(/create extension[^;]*vector/i);
    expect(migrationSql).not.toMatch(/\bvector\s*\(/i);
    expect(migrationSql).not.toMatch(/\bembedding(s)?\b\s+[a-z]/i);
    expect(migrationSql).not.toMatch(/create table public\.clause_citations/i);
    expect(migrationSql).not.toMatch(/insert\s+into\s+public\./i);
  });

  it("adds document metadata and constrained MVP applicability", () => {
    for (const field of [
      "document_type",
      "issuing_institution",
      "publication_date",
      "official_gazette_number",
      "official_url",
      "official_document_url",
      "jurisdiction",
      "legal_status",
      "version_label",
      "is_consolidated",
      "verified_source",
      "verified_at",
      "content_sha256",
      "applicability",
      "applicability_mode",
      "ingestion_status",
      "created_at",
      "updated_at"
    ]) {
      expect(cumulativeSchemaSql).toContain(field);
    }

    expect(migrationSql).toMatch(/check \(language = 'sq'\) not valid/i);
    expect(migrationSql).toMatch(/check \(jurisdiction = 'XK'\)/i);
    expect(migrationSql).toContain("'employment', 'service', 'lease'");
    expect(migrationSql).toMatch(/applicability\[1\] <> applicability\[2\]/i);
    expect(migrationSql).toMatch(/applicability\[1\] <> applicability\[3\]/i);
    expect(migrationSql).toMatch(/applicability\[2\] <> applicability\[3\]/i);
    expect(migrationSql).toMatch(
      /document_type text not null default 'unclassified'/i
    );
    expect(migrationSql).toMatch(
      /applicability_mode text not null default 'unclassified'/i
    );
    expect(migrationSql).toMatch(/add column is_consolidated boolean,/i);
  });

  it("provides chunk provenance and integrity constraints", () => {
    for (const field of [
      "legal_source_id",
      "chunk_index",
      "article_number",
      "article_title",
      "paragraph_number",
      "point_label",
      "content",
      "content_hash",
      "token_count",
      "metadata",
      "created_at"
    ]) {
      expect(migrationSql).toContain(field);
    }

    expect(migrationSql).toMatch(/check \(chunk_index >= 0\)/i);
    expect(migrationSql).toMatch(/content_hash ~ '\^\[0-9a-f\]\{64\}\$'/i);
    expect(migrationSql).toMatch(/unique \(legal_source_id, chunk_index\)/i);
    expect(migrationSql).toMatch(/unique \(legal_source_id, content_hash\)/i);
    expect(migrationSql).toMatch(
      /check \(token_count is null or token_count > 0\)/i
    );
  });

  it("models verified source relations without claiming consolidation", () => {
    expect(migrationSql).toMatch(
      /relationship_type in \('amend', 'supplement', 'repeal'\)/i
    );
    expect(migrationSql).toMatch(/base_source_id <> related_source_id/i);
    expect(migrationSql).toContain("base_article_number");
    expect(migrationSql).toContain("related_article_number");
    expect(migrationSql).toMatch(
      /relationship_type in \('amend', 'supplement'\)[\s\S]*?base_article_number is not null[\s\S]*?related_article_number is not null/i
    );
    expect(migrationSql).toMatch(
      /relationship_type = 'repeal'[\s\S]*?base_article_number is null[\s\S]*?related_article_number is null[\s\S]*?or[\s\S]*?base_article_number is not null[\s\S]*?related_article_number is not null/i
    );
    expect(migrationSql).toContain("does not create a consolidated text");
  });

  it("creates only non-vector filtering and provenance indexes", () => {
    expect(migrationSql).toContain("legal_sources_applicability_idx");
    expect(migrationSql).toContain("legal_chunks_source_article_idx");
    expect(migrationSql).toContain(
      "legal_source_relations_provenance_unique_idx"
    );
    expect(migrationSql).not.toMatch(/using\s+(hnsw|ivfflat)/i);
  });

  it("reserves all corpus access for the trusted service role", () => {
    for (const table of [
      "legal_sources",
      "legal_chunks",
      "legal_source_relations"
    ]) {
      expect(migrationSql).toMatch(
        new RegExp(
          `revoke all privileges on table public\\.${table} from anon`,
          "i"
        )
      );
      expect(migrationSql).toMatch(
        new RegExp(
          `revoke all privileges on table public\\.${table} from authenticated`,
          "i"
        )
      );
      expect(migrationSql).toMatch(
        new RegExp(
          `grant all privileges on table public\\.${table} to service_role`,
          "i"
        )
      );
    }

    expect(migrationSql).not.toMatch(/grant\s+(select|insert|update|delete)[^;]*to\s+(anon|authenticated)/i);
  });
});
