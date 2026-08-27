import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

const migrationPath = resolve(
  process.cwd(),
  "supabase/migrations/0009_pasted_contract_foundation.sql"
);

async function migrationSql() {
  return readFile(migrationPath, "utf8");
}

describe("pasted contract foundation migration", () => {
  it("preserves every existing source kind and adds only pasted", async () => {
    const sql = await migrationSql();
    const baseline = await readFile(
      resolve(process.cwd(), "supabase/migrations/0001_core_mvp_schema.sql"),
      "utf8"
    );

    expect(sql).toMatch(
      /source_kind\s+in\s*\(\s*'upload',\s*'generated',\s*'edited',\s*'pasted'\s*\)/iu
    );
    expect(baseline).toContain("contract_versions_upload_storage_check");
    expect(sql).not.toMatch(/drop constraint contract_versions_upload_storage_check/iu);
  });

  it("requires a completed text-only shape and forbids pasted Storage metadata", async () => {
    const sql = await migrationSql();
    const shape = sql.match(
      /constraint contract_versions_pasted_shape_check[\s\S]*?\n\s*\);/iu
    )?.[0] ?? "";

    for (const field of [
      "storage_bucket",
      "storage_path",
      "original_filename",
      "mime_type",
      "file_size_bytes",
      "sha256",
      "page_count",
      "extraction_error_safe"
    ]) {
      expect(shape).toMatch(new RegExp(`${field}\\s+is\\s+null`, "iu"));
    }
    expect(shape).toMatch(/extraction_status\s*=\s*'completed'/iu);
    expect(shape).toMatch(/extracted_text\s+is\s+not\s+null/iu);
    expect(shape).toMatch(/btrim\(extracted_text\)\s*<>\s*''/iu);
  });

  it("keeps the legacy pending insert branch and adds a separately constrained pasted branch", async () => {
    const sql = await migrationSql();
    const policy = sql.match(
      /create policy contract_versions_insert_own[\s\S]*?\n\s*\);/iu
    )?.[0] ?? "";

    expect(policy).toMatch(/extraction_status\s*=\s*'pending'[\s\S]*?extracted_text\s+is\s+null/iu);
    expect(policy).toMatch(/source_kind\s*=\s*'pasted'[\s\S]*?extraction_status\s*=\s*'completed'/iu);
    expect(policy).toMatch(/c\.owner_id\s*=\s*\(select auth\.uid\(\)\)/iu);
  });

  it("creates an atomic SECURITY INVOKER function with bounded exact text", async () => {
    const sql = await migrationSql();

    expect(sql).toMatch(/create or replace function public\.create_pasted_contract\s*\(/iu);
    expect(sql).toMatch(/security invoker/iu);
    expect(sql).not.toMatch(/security definer/iu);
    expect(sql).toMatch(/set search_path\s*=\s*pg_catalog/iu);
    expect(sql).toMatch(/v_user_id\s*:=\s*auth\.uid\(\)/iu);
    expect(sql).toMatch(/char_length\(p_text\)\s*>\s*80000/iu);
    expect(sql).toMatch(/octet_length\(p_text\)\s*>\s*320000/iu);
    expect(sql).toMatch(/extracted_text[\s\S]*?p_text/iu);
    expect(sql).toMatch(/version_number[\s\S]*?values\s*\([\s\S]*?v_contract_id,\s*1,/iu);
  });

  it("returns only the approved response columns", async () => {
    const sql = await migrationSql();
    const returns = sql.match(/returns table\s*\(([\s\S]*?)\)\s*language/iu)?.[1] ?? "";

    expect(returns).toMatch(/contract_id uuid/iu);
    expect(returns).toMatch(/version_id uuid/iu);
    expect(returns).toMatch(/version_number integer/iu);
    expect(returns).toMatch(/source_kind text/iu);
    expect(returns).toMatch(/extraction_status text/iu);
    expect(returns).toMatch(/page_count integer/iu);
    expect(returns).toMatch(/created_at timestamptz/iu);
    expect(returns).not.toMatch(/owner|extracted_text|storage|filename|sha256/iu);
  });

  it("grants only authenticated execution and contains no external side effects", async () => {
    const sql = await migrationSql();

    expect(sql).toMatch(/revoke all on function[\s\S]*?from public/iu);
    expect(sql).toMatch(/revoke all on function[\s\S]*?from anon/iu);
    expect(sql).toMatch(/revoke all on function[\s\S]*?from service_role/iu);
    expect(sql).toMatch(/grant execute on function[\s\S]*?to authenticated/iu);
    expect(sql).not.toMatch(/grant execute[\s\S]*?to (?:anon|service_role)/iu);
    expect(sql).not.toMatch(/\b(?:delete|truncate)\b/iu);
    expect(sql).not.toMatch(/storage\.|storage\.from|openai|analy[sz]e|analysis-v/iu);
    expect(sql).not.toMatch(/update\s+public\.|insert\s+into\s+public\.(?!contracts\b|contract_versions\b)/iu);
  });

  it("provides SELECT-only preflight and postflight checks", async () => {
    for (const fileName of [
      "0009_pasted_contract_preflight.sql",
      "0009_pasted_contract_postflight.sql"
    ]) {
      const sql = await readFile(resolve(process.cwd(), "supabase/checks", fileName), "utf8");
      expect(sql).not.toMatch(/\b(?:insert|update|delete|truncate|alter|drop|create|grant|revoke)\b/iu);
    }
  });
});
