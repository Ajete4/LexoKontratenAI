import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import type { LegalChunk } from "../src/legal/legal-chunker.js";
import { createLegalChunkRemoteMapping } from "../src/legal/legal-chunk-remote-mapping.js";

type ChunkArtifact = {
  readonly lawNumber: string;
  readonly versionLabel: string;
  readonly chunks: readonly LegalChunk[];
};

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const inputPath = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "embeddings",
  "remote-chunk-export.json"
);
const outputPath = resolve(
  backendDirectory,
  "data",
  "legal-sources",
  "embeddings",
  "remote-chunk-mapping.json"
);
const laws = ["03-L-212", "04-L-077", "08-L-142"] as const;

async function readJson(path: string): Promise<unknown> {
  return JSON.parse(await readFile(path, "utf8")) as unknown;
}

const localSources = await Promise.all(
  laws.map(async (law) => {
    const artifact = (await readJson(
      resolve(
        backendDirectory,
        "data",
        "legal-sources",
        "chunks",
        law,
        "chunks.json"
      )
    )) as ChunkArtifact;

    return {
      lawNumber: artifact.lawNumber,
      versionLabel: artifact.versionLabel,
      chunks: artifact.chunks
    };
  })
);
const mapping = createLegalChunkRemoteMapping(
  await readJson(inputPath),
  localSources
);
const temporaryPath = `${outputPath}.tmp-${randomUUID()}`;

await mkdir(dirname(outputPath), { recursive: true });

try {
  await writeFile(temporaryPath, `${JSON.stringify(mapping, null, 2)}\n`, {
    encoding: "utf8",
    flag: "wx"
  });
  await rename(temporaryPath, outputPath);
} finally {
  await rm(temporaryPath, { force: true });
}
