import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import {
  createLegalChunkRemoteMapping,
  type LocalMappingSource
} from "../src/legal/legal-chunk-remote-mapping.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly chunks: readonly LegalChunk[];
};

type RemoteRow = {
  id: string;
  legal_source_id: string;
  law_number: string;
  version_label: string;
  language: string;
  chunk_index: number;
  content_hash: string;
  extra?: string;
};

const lawDirectories = ["03-L-212", "04-L-077", "08-L-142"] as const;
const sourceIds = [
  "10000000-0000-4000-8000-000000000001",
  "10000000-0000-4000-8000-000000000002",
  "10000000-0000-4000-8000-000000000003"
] as const;

function syntheticChunkId(index: number): string {
  return `20000000-0000-4000-8000-${String(index + 1).padStart(12, "0")}`;
}

async function fixtures(): Promise<{
  localSources: LocalMappingSource[];
  remoteRows: RemoteRow[];
}> {
  const artifacts = await Promise.all(
    lawDirectories.map(async (directory) =>
      JSON.parse(
        await readFile(
          resolve(
            process.cwd(),
            "data",
            "legal-sources",
            "chunks",
            directory,
            "chunks.json"
          ),
          "utf8"
        )
      ) as ChunkArtifact
    )
  );
  const localSources = artifacts.map((artifact) => ({
    lawNumber: artifact.lawNumber,
    versionLabel: artifact.versionLabel,
    chunks: artifact.chunks
  }));
  let globalIndex = 0;
  const remoteRows = artifacts.flatMap((artifact, sourceIndex) =>
    artifact.chunks.map((chunk) => ({
      id: syntheticChunkId(globalIndex++),
      legal_source_id: sourceIds[sourceIndex]!,
      law_number: artifact.lawNumber,
      version_label: artifact.versionLabel,
      language: "sq",
      chunk_index: chunk.chunkIndex,
      content_hash: chunk.contentSha256
    }))
  );

  return { localSources, remoteRows };
}

describe("legal chunk remote UUID mapping", () => {
  it("validates and maps all 1,166 rows deterministically", async () => {
    const { localSources, remoteRows } = await fixtures();
    const first = createLegalChunkRemoteMapping(remoteRows, localSources);
    const second = createLegalChunkRemoteMapping(remoteRows, localSources);

    expect(first.totalChunks).toBe(1_166);
    expect(first.countsByLawNumber).toEqual({
      "03/L-212": 100,
      "04/L-077": 1_059,
      "08/L-142": 7
    });
    expect(first.chunks).toHaveLength(1_166);
    expect(JSON.stringify(second)).toBe(JSON.stringify(first));
    expect(first.chunks[0]).toMatchObject({
      lawNumber: "03/L-212",
      versionLabel: "gazette-90-2010",
      chunkIndex: 0
    });
    expect(first.chunks.at(-1)).toMatchObject({
      lawNumber: "08/L-142",
      versionLabel: "gazette-18-2024",
      chunkIndex: 6
    });
  });

  it.each([
    ["wrong count", (rows: RemoteRow[]) => rows.slice(1)],
    ["invalid UUID", (rows: RemoteRow[]) => [{ ...rows[0]!, id: "invalid" }, ...rows.slice(1)]],
    ["duplicate UUID", (rows: RemoteRow[]) => [{ ...rows[0]!, id: rows[1]!.id }, ...rows.slice(1)]],
    ["duplicate natural key", (rows: RemoteRow[]) => [{ ...rows[0]!, chunk_index: rows[1]!.chunk_index }, ...rows.slice(1)]],
    ["duplicate hash", (rows: RemoteRow[]) => [{ ...rows[0]!, content_hash: rows[1]!.content_hash }, ...rows.slice(1)]],
    ["hash mismatch", (rows: RemoteRow[]) => [{ ...rows[0]!, content_hash: "a".repeat(64) }, ...rows.slice(1)]],
    ["missing and extra", (rows: RemoteRow[]) => [{ ...rows[0]!, chunk_index: 100 }, ...rows.slice(1)]],
    ["additional field", (rows: RemoteRow[]) => [{ ...rows[0]!, extra: "forbidden" }, ...rows.slice(1)]]
  ])("rejects %s", async (_label, mutate) => {
    const { localSources, remoteRows } = await fixtures();
    expect(() =>
      createLegalChunkRemoteMapping(mutate(remoteRows), localSources)
    ).toThrow("LEGAL_CHUNK_REMOTE_MAPPING_INVALID");
  });

  it("produces no content, embeddings, credentials or dynamic metadata", async () => {
    const { localSources, remoteRows } = await fixtures();
    const serialized = JSON.stringify(
      createLegalChunkRemoteMapping(remoteRows, localSources)
    );

    expect(serialized).not.toMatch(/"content"\s*:/u);
    expect(serialized).not.toMatch(/"embedding"\s*:/u);
    expect(serialized).not.toMatch(/OPENAI_API_KEY|SUPABASE_|Bearer\s/u);
    expect(serialized).not.toMatch(/"(?:createdAt|updatedAt|timestamp)"\s*:/u);
  });

  it("provides a strictly read-only, minimal P0 export query", async () => {
    const sql = await readFile(
      resolve(process.cwd(), "supabase/checks/0006_legal_chunk_uuid_export.sql"),
      "utf8"
    );

    expect(sql).not.toMatch(
      /\b(?:insert|update|delete|upsert|alter|create|drop|truncate|grant|revoke|call)\b/iu
    );
    expect(sql).toContain("chunk.id");
    expect(sql).toContain("chunk.legal_source_id");
    expect(sql).toContain("source.law_number");
    expect(sql).toContain("source.version_label");
    expect(sql).toContain("source.language");
    expect(sql).toContain("chunk.chunk_index");
    expect(sql).toContain("chunk.content_hash");
    expect(sql).not.toMatch(/\bchunk\.content\b(?!_hash)/u);
    expect(sql).not.toMatch(/embedding|metadata|contract|user/iu);
  });
});
