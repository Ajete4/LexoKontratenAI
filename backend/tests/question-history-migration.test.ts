import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

const migrationPath = fileURLToPath(
  new URL("../supabase/migrations/0010_contract_question_history.sql", import.meta.url)
);
const migrationSql = readFileSync(migrationPath, "utf8");

describe("contract question history migration", () => {
  it("stores the minimal successful-question fields with cascading ownership relations", () => {
    expect(migrationSql).toMatch(/create table public\.contract_questions/i);
    for (const column of ["user_id", "contract_id", "version_id", "question", "answer", "created_at"]) {
      expect(migrationSql).toContain(column);
    }
    expect(migrationSql).toMatch(/references auth\.users\(id\) on delete cascade/i);
    expect(migrationSql).toMatch(/references public\.contracts\(id\) on delete cascade/i);
    expect(migrationSql).toMatch(/references public\.contract_versions\(id\) on delete cascade/i);
  });

  it("allows only authenticated owner reads and inserts for completed analyses", () => {
    expect(migrationSql).toMatch(/enable row level security/i);
    expect(migrationSql).toMatch(/for select\s+to authenticated/i);
    expect(migrationSql).toMatch(/for insert\s+to authenticated/i);
    expect(migrationSql).toMatch(/c\.owner_id = \(select auth\.uid\(\)\)/i);
    expect(migrationSql).toMatch(/a\.status = 'completed'/i);
    expect(migrationSql).toMatch(/revoke all on table public\.contract_questions from anon/i);
    expect(migrationSql).not.toMatch(/for (update|delete)/i);
  });

  it("does not add editing, deletion, pagination, Storage or AI behavior", () => {
    expect(migrationSql).not.toMatch(/\bdelete\s+from\b|\btruncate\b/i);
    expect(migrationSql).not.toMatch(/storage|openai|embedding|vector/i);
  });
});
