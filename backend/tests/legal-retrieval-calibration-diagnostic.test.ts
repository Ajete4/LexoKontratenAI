import { mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { describe, expect, it, vi } from "vitest";

import { createCalibrationCheckpointStore } from "../src/legal/legal-retrieval-calibration-checkpoint.js";
import { runLegalRetrievalCalibrationCanary } from "../src/legal/legal-retrieval-calibration-canary.js";

const goldHash = "A".repeat(64);

describe("legal retrieval calibration diagnostics", () => {
  it("writes and reloads an atomic sanitized checkpoint", async () => {
    const directory = await mkdtemp(join(tmpdir(), "lexo-calibration-"));
    const path = join(directory, "checkpoint.json");
    try {
      const store = await createCalibrationCheckpointStore({ path, goldSetSha256: goldHash });
      await store.recordAttempt("embeddings");
      await store.recordSuccess("embeddings");
      await store.recordAttempt("rpc");
      await store.recordSuccess("rpc");
      await store.completeRun({
        runKey: "employment-notice-period:A",
        evaluationId: "employment-notice-period",
        strategy: "A",
        results: [{
          lawNumber: "03/L-212", articleNumber: "71", chunkIndex: 70,
          contentHash: "b".repeat(64), similarity: 0.7
        }]
      });
      const reloaded = await createCalibrationCheckpointStore({ path, goldSetSha256: goldHash });
      const serialized = await readFile(path, "utf8");

      expect(reloaded.snapshot().completedRuns).toHaveLength(1);
      expect(serialized).not.toMatch(
        /"(?:query|queryVector|vector|embedding|content|credential|apiKey)"\s*:/iu
      );
      expect(serialized).toContain('"attempts"');
      expect(serialized).toContain('"successes"');
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("rejects a checkpoint belonging to another gold set", async () => {
    const directory = await mkdtemp(join(tmpdir(), "lexo-calibration-"));
    const path = join(directory, "checkpoint.json");
    try {
      await createCalibrationCheckpointStore({ path, goldSetSha256: goldHash });
      await expect(
        createCalibrationCheckpointStore({ path, goldSetSha256: "B".repeat(64) })
      ).rejects.toThrow("LEGAL_RETRIEVAL_CALIBRATION_CHECKPOINT_INCOMPATIBLE");
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("enforces the total request budget", async () => {
    const directory = await mkdtemp(join(tmpdir(), "lexo-calibration-"));
    const path = join(directory, "checkpoint.json");
    try {
      await writeFile(path, JSON.stringify({
        version: "legal-retrieval-calibration-checkpoint-v1",
        goldSetSha256: goldHash,
        attempts: { embeddings: 27, rpc: 0 },
        successes: { embeddings: 0, rpc: 0 },
        completedRuns: []
      }));
      const store = await createCalibrationCheckpointStore({ path, goldSetSha256: goldHash });
      await expect(store.recordAttempt("embeddings")).rejects.toThrow(
        "LEGAL_RETRIEVAL_CALIBRATION_REQUEST_BUDGET_EXHAUSTED"
      );
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("runs a synthetic canary with one embedding call and no RPC", async () => {
    const embedLegalChunks = vi.fn().mockResolvedValue([{ chunkId: "x", embedding: Array(1536).fill(0.1) }]);
    const report = await runLegalRetrievalCalibrationCanary({ embedLegalChunks });

    expect(embedLegalChunks).toHaveBeenCalledTimes(1);
    expect(report).toEqual({
      status: "success", attempts: 1, successes: 1, dimensions: 1536,
      diagnosticReason: null, rpcCalls: 0
    });
    const input = embedLegalChunks.mock.calls[0]![0];
    expect(JSON.stringify(input)).not.toMatch(/kontrat|ligj|gold/iu);
  });
});
