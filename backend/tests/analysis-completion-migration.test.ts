import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

const migrationPath = fileURLToPath(
  new URL(
    "../supabase/migrations/0003_harden_analysis_completion_timestamp.sql",
    import.meta.url
  )
);
const servicePath = fileURLToPath(
  new URL("../src/services/contract-analysis.service.ts", import.meta.url)
);

const migrationSql = readFileSync(migrationPath, "utf8");
const serviceSource = readFileSync(servicePath, "utf8");

function completionTimestamp(
  databaseTimestamp: Date,
  startedAt: Date | null
): Date {
  if (startedAt === null) {
    return databaseTimestamp;
  }

  return databaseTimestamp >= startedAt ? databaseTimestamp : startedAt;
}

describe("analysis completion timestamp migration", () => {
  it("clamps completion to started_at when the backend clock is ahead", () => {
    const databaseTimestamp = new Date("2026-08-10T10:00:00.000Z");
    const startedAt = new Date("2026-08-10T10:00:05.000Z");

    const completedAt = completionTimestamp(databaseTimestamp, startedAt);

    expect(completedAt).toEqual(startedAt);
    expect(completedAt.getTime()).toBeGreaterThanOrEqual(startedAt.getTime());
  });

  it("uses the database timestamp for a normal completion", () => {
    const databaseTimestamp = new Date("2026-08-10T10:00:05.000Z");
    const startedAt = new Date("2026-08-10T10:00:00.000Z");

    expect(completionTimestamp(databaseTimestamp, startedAt)).toEqual(
      databaseTimestamp
    );
    expect(completionTimestamp(databaseTimestamp, null)).toEqual(
      databaseTimestamp
    );
  });

  it("locks and reads started_at before deriving one completion timestamp", () => {
    expect(migrationSql).toMatch(
      /select analysis\.status, analysis\.pipeline_version, analysis\.started_at\s+into v_analysis_status, v_pipeline_version, v_started_at[\s\S]*?for update;/i
    );
    expect(migrationSql).toMatch(
      /v_completed_at :=\s*case\s*when v_started_at is null then pg_catalog\.clock_timestamp\(\)\s*else greatest\(\s*pg_catalog\.clock_timestamp\(\),\s*v_started_at\s*\)\s*end;/i
    );
    expect(migrationSql.match(/v_completed_at\s*:=/g)).toHaveLength(1);
  });

  it("uses v_completed_at consistently in the completion update and response", () => {
    expect(migrationSql).toMatch(/completed_at = v_completed_at,/);
    expect(migrationSql).toMatch(/updated_at = v_completed_at,/);
    expect(migrationSql).toMatch(/'at', v_completed_at/);
    expect(migrationSql).toMatch(
      /return query\s+select\s+analysis\.id,\s+analysis\.status,\s+v_completed_at,\s+v_clause_count/i
    );
  });

  it("keeps the failure transition compatible with the completion constraint", () => {
    expect(serviceSource).toMatch(
      /status: "failed",\s+completed_at: null,\s+error_message_safe:/
    );
    expect(serviceSource).toMatch(/\.eq\("status", "analyzing"\)/);
  });

  it("preserves the RPC signature and service-role-only execution", () => {
    const signature = String.raw`public\.complete_contract_analysis\(\s*uuid,\s*text,\s*jsonb,\s*text,\s*jsonb\s*\)`;

    expect(migrationSql).toMatch(
      /create or replace function public\.complete_contract_analysis\(\s*p_analysis_id uuid,\s*p_expected_pipeline_version text,\s*p_result jsonb,\s*p_overall_risk_level text,\s*p_clauses jsonb\s*\)/i
    );
    expect(migrationSql).toMatch(
      new RegExp(`revoke execute on function ${signature} from public`, "i")
    );
    expect(migrationSql).toMatch(
      new RegExp(`revoke execute on function ${signature} from anon`, "i")
    );
    expect(migrationSql).toMatch(
      new RegExp(
        `revoke execute on function ${signature} from authenticated`,
        "i"
      )
    );
    expect(migrationSql).toMatch(
      new RegExp(`grant execute on function ${signature} to service_role`, "i")
    );
  });

  it("does not alter tables or constraints", () => {
    expect(migrationSql).not.toMatch(/\balter\s+table\b/i);
    expect(migrationSql).not.toMatch(/\b(add|drop)\s+constraint\b/i);
  });
});
