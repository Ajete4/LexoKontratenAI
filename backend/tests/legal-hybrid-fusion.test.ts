import { describe, expect, it } from "vitest";

import { fuseLegalRetrievalCandidates } from "../src/legal/legal-hybrid-fusion.js";

const candidate = (
  chunkKey: string,
  lawNumber: "03/L-212" | "04/L-077" | "08/L-142",
  chunkIndex: number,
  score: number
) => ({ chunkKey, lawNumber, chunkIndex, score });

describe("legal hybrid reciprocal rank fusion", () => {
  it("combines semantic and lexical ranks with deterministic RRF", () => {
    const result = fuseLegalRetrievalCandidates({
      semantic: [candidate("a", "04/L-077", 1, 0.8), candidate("b", "04/L-077", 2, 0.7)],
      lexical: [candidate("b", "04/L-077", 2, 0.9), candidate("c", "04/L-077", 3, 0.5)],
      contractType: "service",
      matchCount: 3,
      rrfK: 60
    });

    expect(result.map((item) => item.chunkKey)).toEqual(["b", "a", "c"]);
    expect(result[0]).toMatchObject({ semanticRank: 2, lexicalRank: 1, resultRank: 1 });
  });

  it("rejects duplicate candidates within either ranked list", () => {
    const duplicate = candidate("a", "04/L-077", 1, 0.8);
    expect(() => fuseLegalRetrievalCandidates({
      semantic: [duplicate, duplicate], lexical: [], contractType: "service", matchCount: 2
    })).toThrow("LEGAL_HYBRID_DUPLICATE_CANDIDATE");
  });

  it.each([
    ["employment", "04/L-077"],
    ["service", "03/L-212"],
    ["lease", "08/L-142"]
  ] as const)("enforces %s scope isolation", (contractType, lawNumber) => {
    expect(() => fuseLegalRetrievalCandidates({
      semantic: [candidate("x", lawNumber, 1, 0.8)], lexical: [], contractType, matchCount: 1
    })).toThrow("LEGAL_HYBRID_SCOPE_VIOLATION");
  });

  it("uses deterministic law, chunk index and key tie breakers", () => {
    const input = {
      semantic: [
        candidate("z", "04/L-077", 2, 0.5),
        candidate("a", "04/L-077", 1, 0.5)
      ],
      lexical: [] as const,
      contractType: "lease" as const,
      matchCount: 2
    };
    expect(fuseLegalRetrievalCandidates(input)).toEqual(fuseLegalRetrievalCandidates(input));
  });

  it("returns an empty array for zero candidates", () => {
    expect(fuseLegalRetrievalCandidates({
      semantic: [], lexical: [], contractType: "employment", matchCount: 8
    })).toEqual([]);
  });
});
