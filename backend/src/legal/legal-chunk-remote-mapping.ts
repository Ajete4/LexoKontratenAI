import { z } from "zod";

import type { LegalChunk } from "./legal-chunker.js";

const EXPECTED_SOURCES = [
  { lawNumber: "03/L-212", versionLabel: "gazette-90-2010", count: 100 },
  { lawNumber: "04/L-077", versionLabel: "gazette-16-2012", count: 1_059 },
  { lawNumber: "08/L-142", versionLabel: "gazette-18-2024", count: 7 }
] as const;

const remoteRowSchema = z
  .object({
    id: z.string().uuid(),
    legal_source_id: z.string().uuid(),
    law_number: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
    version_label: z.enum([
      "gazette-90-2010",
      "gazette-16-2012",
      "gazette-18-2024"
    ]),
    language: z.literal("sq"),
    chunk_index: z.number().int().nonnegative(),
    content_hash: z.string().regex(/^[0-9a-f]{64}$/u)
  })
  .strict();

export type LocalMappingSource = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly chunks: readonly LegalChunk[];
};

export type LegalChunkRemoteMapping = {
  readonly totalChunks: 1_166;
  readonly countsByLawNumber: {
    readonly "03/L-212": 100;
    readonly "04/L-077": 1_059;
    readonly "08/L-142": 7;
  };
  readonly chunks: readonly {
    readonly chunkId: string;
    readonly legalSourceId: string;
    readonly lawNumber: string;
    readonly versionLabel: string;
    readonly language: "sq";
    readonly chunkIndex: number;
    readonly contentHash: string;
  }[];
};

function fail(): never {
  throw new Error("LEGAL_CHUNK_REMOTE_MAPPING_INVALID");
}

export function createLegalChunkRemoteMapping(
  exportedJson: unknown,
  localSources: readonly LocalMappingSource[]
): LegalChunkRemoteMapping {
  const rowsResult = z.array(remoteRowSchema).length(1_166).safeParse(exportedJson);

  if (!rowsResult.success || localSources.length !== EXPECTED_SOURCES.length) {
    return fail();
  }

  const rows = rowsResult.data;
  const chunkIds = new Set<string>();
  const naturalKeys = new Set<string>();
  const contentHashes = new Set<string>();
  const sourceIds = new Map<string, string>();
  const rowsByKey = new Map<string, (typeof rows)[number]>();

  for (const row of rows) {
    const naturalKey = [
      row.law_number,
      row.version_label,
      row.language,
      row.chunk_index
    ].join("|");
    const knownSourceId = sourceIds.get(row.law_number);

    if (
      chunkIds.has(row.id) ||
      naturalKeys.has(naturalKey) ||
      contentHashes.has(row.content_hash) ||
      (knownSourceId !== undefined && knownSourceId !== row.legal_source_id)
    ) {
      return fail();
    }

    chunkIds.add(row.id);
    naturalKeys.add(naturalKey);
    contentHashes.add(row.content_hash);
    sourceIds.set(row.law_number, row.legal_source_id);
    rowsByKey.set(naturalKey, row);
  }

  const mapped: LegalChunkRemoteMapping["chunks"][number][] = [];

  for (const [sourceIndex, expected] of EXPECTED_SOURCES.entries()) {
    const local = localSources[sourceIndex];

    if (
      local === undefined ||
      local.lawNumber !== expected.lawNumber ||
      local.versionLabel !== expected.versionLabel ||
      local.chunks.length !== expected.count
    ) {
      return fail();
    }

    for (const [index, chunk] of local.chunks.entries()) {
      const key = [expected.lawNumber, expected.versionLabel, "sq", index].join("|");
      const remote = rowsByKey.get(key);

      if (
        chunk.chunkIndex !== index ||
        chunk.lawNumber !== expected.lawNumber ||
        chunk.versionLabel !== expected.versionLabel ||
        remote === undefined ||
        remote.content_hash !== chunk.contentSha256
      ) {
        return fail();
      }

      mapped.push({
        chunkId: remote.id,
        legalSourceId: remote.legal_source_id,
        lawNumber: remote.law_number,
        versionLabel: remote.version_label,
        language: remote.language,
        chunkIndex: remote.chunk_index,
        contentHash: remote.content_hash
      });
      rowsByKey.delete(key);
    }
  }

  if (mapped.length !== 1_166 || rowsByKey.size !== 0) {
    return fail();
  }

  return {
    totalChunks: 1_166,
    countsByLawNumber: {
      "03/L-212": 100,
      "04/L-077": 1_059,
      "08/L-142": 7
    },
    chunks: mapped
  };
}
