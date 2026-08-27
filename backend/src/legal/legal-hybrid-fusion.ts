import { z } from "zod";

const candidateSchema = z.object({
  chunkKey: z.string().min(1).max(200),
  lawNumber: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  chunkIndex: z.number().int().nonnegative(),
  score: z.number().finite().min(0)
}).strict();

export type HybridFusionCandidate = z.infer<typeof candidateSchema>;

const ALLOWED_LAWS = {
  employment: new Set(["03/L-212", "08/L-142"]),
  service: new Set(["04/L-077"]),
  lease: new Set(["04/L-077"])
} as const;

export function fuseLegalRetrievalCandidates(input: {
  readonly semantic: readonly HybridFusionCandidate[];
  readonly lexical: readonly HybridFusionCandidate[];
  readonly contractType: keyof typeof ALLOWED_LAWS;
  readonly matchCount: number;
  readonly rrfK?: number;
}) {
  const semantic = z.array(candidateSchema).max(100).parse(input.semantic);
  const lexical = z.array(candidateSchema).max(100).parse(input.lexical);
  const matchCount = z.number().int().min(1).max(20).parse(input.matchCount);
  const rrfK = z.number().int().min(1).max(1_000).parse(input.rrfK ?? 60);
  const allowedLaws = ALLOWED_LAWS[input.contractType];

  const validateUniqueAndScope = (candidates: readonly HybridFusionCandidate[]) => {
    const keys = new Set<string>();
    for (const candidate of candidates) {
      if (keys.has(candidate.chunkKey)) {
        throw new Error("LEGAL_HYBRID_DUPLICATE_CANDIDATE");
      }
      if (!allowedLaws.has(candidate.lawNumber)) {
        throw new Error("LEGAL_HYBRID_SCOPE_VIOLATION");
      }
      keys.add(candidate.chunkKey);
    }
  };
  validateUniqueAndScope(semantic);
  validateUniqueAndScope(lexical);

  const combined = new Map<string, {
    candidate: HybridFusionCandidate;
    semanticRank: number | null;
    lexicalRank: number | null;
    semanticScore: number | null;
    lexicalScore: number | null;
  }>();

  semantic.forEach((candidate, index) => {
    combined.set(candidate.chunkKey, {
      candidate,
      semanticRank: index + 1,
      lexicalRank: null,
      semanticScore: candidate.score,
      lexicalScore: null
    });
  });
  lexical.forEach((candidate, index) => {
    const existing = combined.get(candidate.chunkKey);
    combined.set(candidate.chunkKey, {
      candidate: existing?.candidate ?? candidate,
      semanticRank: existing?.semanticRank ?? null,
      lexicalRank: index + 1,
      semanticScore: existing?.semanticScore ?? null,
      lexicalScore: candidate.score
    });
  });

  return [...combined.values()]
    .map((item) => ({
      ...item.candidate,
      semanticScore: item.semanticScore,
      lexicalScore: item.lexicalScore,
      semanticRank: item.semanticRank,
      lexicalRank: item.lexicalRank,
      fusedScore:
        (item.semanticRank === null ? 0 : 1 / (rrfK + item.semanticRank)) +
        (item.lexicalRank === null ? 0 : 1 / (rrfK + item.lexicalRank))
    }))
    .sort((left, right) =>
      right.fusedScore - left.fusedScore ||
      Math.max(right.semanticScore ?? 0, right.lexicalScore ?? 0) -
        Math.max(left.semanticScore ?? 0, left.lexicalScore ?? 0) ||
      left.lawNumber.localeCompare(right.lawNumber) ||
      left.chunkIndex - right.chunkIndex ||
      left.chunkKey.localeCompare(right.chunkKey)
    )
    .slice(0, matchCount)
    .map((item, index) => ({ ...item, resultRank: index + 1 }));
}
