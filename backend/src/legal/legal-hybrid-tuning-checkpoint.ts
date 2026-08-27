import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname } from "node:path";

import { z } from "zod";

const storedResultSchema = z.object({
  lawNumber: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  articleNumber: z.string().nullable(),
  chunkIndex: z.number().int().nonnegative(),
  contentHash: z.string().regex(/^[0-9a-f]{64}$/u),
  fusedScore: z.number().finite().positive(),
  semanticRank: z.number().int().positive().nullable(),
  lexicalRank: z.number().int().positive().nullable(),
  resultRank: z.number().int().positive(),
  termOverlap: z.number().finite().min(0).max(1)
}).strict();

const completedRunSchema = z.object({
  runKey: z.string().regex(/^[a-z0-9-]+:rrf-(?:20|40|60)-candidates-(?:50|75)$/u),
  evaluationId: z.string().min(1),
  configurationId: z.string().regex(/^rrf-(?:20|40|60)-candidates-(?:50|75)$/u),
  results: z.array(storedResultSchema).max(8)
}).strict();

const checkpointSchema = z.object({
  version: z.literal("legal-hybrid-tuning-checkpoint-v1"),
  goldSetSha256: z.string().regex(/^[0-9A-F]{64}$/u),
  planSha256: z.string().regex(/^[0-9A-F]{64}$/u),
  attempts: z.object({ embeddings: z.number().int().min(0).max(9), rpc: z.number().int().min(0).max(54) }).strict(),
  successes: z.object({ embeddings: z.number().int().min(0).max(9), rpc: z.number().int().min(0).max(54) }).strict(),
  completedRuns: z.array(completedRunSchema).max(54)
}).strict().superRefine((value, context) => {
  const keys = value.completedRuns.map((run) => run.runKey);
  if (new Set(keys).size !== keys.length) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["completedRuns"], message: "Duplicate run." });
  }
  if (value.successes.embeddings > value.attempts.embeddings || value.successes.rpc > value.attempts.rpc) {
    context.addIssue({ code: z.ZodIssueCode.custom, path: ["successes"], message: "Invalid counters." });
  }
});

type Checkpoint = z.infer<typeof checkpointSchema>;
export type HybridTuningCheckpointRun = z.infer<typeof completedRunSchema>;

async function atomicWrite(path: string, checkpoint: Checkpoint) {
  const temporaryPath = `${path}.tmp-${randomUUID()}`;
  await mkdir(dirname(path), { recursive: true });
  try {
    await writeFile(temporaryPath, `${JSON.stringify(checkpoint, null, 2)}\n`, { encoding: "utf8", flag: "wx" });
    await rm(path, { force: true });
    await rename(temporaryPath, path);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

export async function createHybridTuningCheckpointStore(options: {
  readonly path: string;
  readonly goldSetSha256: string;
  readonly planSha256: string;
}) {
  let checkpoint: Checkpoint;
  try {
    checkpoint = checkpointSchema.parse(JSON.parse(await readFile(options.path, "utf8")));
    if (checkpoint.goldSetSha256 !== options.goldSetSha256 || checkpoint.planSha256 !== options.planSha256) {
      throw new Error("LEGAL_HYBRID_TUNING_CHECKPOINT_INCOMPATIBLE");
    }
  } catch (error) {
    if (error instanceof Error && "code" in error && error.code === "ENOENT") {
      checkpoint = {
        version: "legal-hybrid-tuning-checkpoint-v1",
        goldSetSha256: options.goldSetSha256,
        planSha256: options.planSha256,
        attempts: { embeddings: 0, rpc: 0 },
        successes: { embeddings: 0, rpc: 0 },
        completedRuns: []
      };
      await atomicWrite(options.path, checkpoint);
    } else {
      throw error;
    }
  }

  const update = async (mutate: (value: Checkpoint) => Checkpoint) => {
    checkpoint = checkpointSchema.parse(mutate(checkpoint));
    await atomicWrite(options.path, checkpoint);
  };
  return {
    snapshot: () => structuredClone(checkpoint),
    async startExecution() {
      await update((current) => ({
        ...current,
        attempts: { ...current.attempts, embeddings: 0 },
        successes: { ...current.successes, embeddings: 0 }
      }));
    },
    async recordAttempt(kind: "embeddings" | "rpc") {
      const maximum = kind === "embeddings" ? 9 : 54;
      if (checkpoint.attempts[kind] >= maximum) throw new Error("LEGAL_HYBRID_TUNING_BUDGET_EXHAUSTED");
      await update((current) => ({ ...current, attempts: { ...current.attempts, [kind]: current.attempts[kind] + 1 } }));
    },
    async recordSuccess(kind: "embeddings" | "rpc") {
      await update((current) => ({ ...current, successes: { ...current.successes, [kind]: current.successes[kind] + 1 } }));
    },
    async completeRun(run: HybridTuningCheckpointRun) {
      if (checkpoint.completedRuns.some((item) => item.runKey === run.runKey)) return;
      await update((current) => ({ ...current, completedRuns: [...current.completedRuns, completedRunSchema.parse(run)] }));
    }
  };
}
