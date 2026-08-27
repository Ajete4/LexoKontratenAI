import { createHash } from "node:crypto";
import { existsSync, readFileSync, statSync } from "node:fs";
import { dirname, isAbsolute, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";

const backendDirectory = resolve(
  dirname(fileURLToPath(import.meta.url)),
  ".."
);
const rawSourcesDirectory = resolve(
  backendDirectory,
  "data/legal-sources/raw"
);
const artifactSourcePath = resolve(
  backendDirectory,
  "src/legal/legal-source-artifacts.ts"
);
const artifactSource = readFileSync(artifactSourcePath, "utf8");

function resolveSafeArtifactPath(localRelativePath: string): string {
  expect(isAbsolute(localRelativePath)).toBe(false);

  const resolvedPath = resolve(backendDirectory, localRelativePath);
  const relativeToRawDirectory = relative(rawSourcesDirectory, resolvedPath);

  expect(relativeToRawDirectory).not.toBe("..");
  expect(relativeToRawDirectory.startsWith(`..\\`)).toBe(false);
  expect(relativeToRawDirectory.startsWith("../")).toBe(false);
  expect(isAbsolute(relativeToRawDirectory)).toBe(false);

  return resolvedPath;
}

describe("P0 legal source artifacts", () => {
  it("contains exactly one artifact for every manifest source", () => {
    expect(LEGAL_SOURCE_ARTIFACTS).toHaveLength(3);
    expect(LEGAL_SOURCE_ARTIFACTS.map(({ lawNumber }) => lawNumber)).toEqual(
      LEGAL_SOURCE_MANIFEST.map(({ lawNumber }) => lawNumber)
    );
  });

  it("uses safe relative paths inside the raw legal-source directory", () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      expect(artifact.localRelativePath).toMatch(
        /^data\/legal-sources\/raw\/[^/]+\/official\.(pdf|html)$/
      );
      resolveSafeArtifactPath(artifact.localRelativePath);
    }
  });

  it("uses only official HTTPS download URLs", () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const url = new URL(artifact.officialDownloadUrl);

      expect(url.protocol).toBe("https:");
      expect(url.hostname).toBe("gzk.rks-gov.net");
    }
  });

  it("records valid bounded sizes and lowercase SHA-256 hashes", () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      expect(artifact.fileSizeBytes).toBeGreaterThan(0);
      expect(artifact.fileSizeBytes).toBeLessThanOrEqual(50 * 1024 * 1024);
      expect(artifact.sha256).toMatch(/^[0-9a-f]{64}$/);
    }
  });

  it("matches every local file, real format, size, and original-byte hash", () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const localPath = resolveSafeArtifactPath(artifact.localRelativePath);

      expect(existsSync(localPath)).toBe(true);

      const bytes = readFileSync(localPath);
      const realFormat = bytes.subarray(0, 5).toString("ascii") === "%PDF-"
        ? "pdf"
        : "unknown";
      const sha256 = createHash("sha256").update(bytes).digest("hex");

      expect(statSync(localPath).size).toBe(artifact.fileSizeBytes);
      expect(realFormat).toBe(artifact.documentFormat);
      expect(artifact.mediaType).toBe("application/pdf");
      expect(sha256).toBe(artifact.sha256);
    }
  });

  it("marks all three verified PDFs as readable without OCR", () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      expect(artifact.pageCount).toBeGreaterThan(0);
      expect(artifact.textLayer).toBe("available");
      expect(artifact.requiresOcr).toBe(false);
      expect(artifact.encoding).toBeNull();
      expect(artifact.identityVerified).toBe(true);
    }
  });

  it("uses deterministic unique Gazette version labels", () => {
    const versionLabels = LEGAL_SOURCE_MANIFEST.map(
      ({ versionLabel }) => versionLabel
    );

    expect(versionLabels).toEqual([
      "gazette-90-2010",
      "gazette-16-2012",
      "gazette-18-2024"
    ]);
    expect(new Set(versionLabels).size).toBe(3);
  });

  it("keeps 08/L-142 as the verified amendment of 03/L-212", () => {
    const amendment = LEGAL_SOURCE_MANIFEST.find(
      ({ lawNumber }) => lawNumber === "08/L-142"
    );

    expect(amendment?.documentType).toBe("amendment");
    expect(amendment?.applicabilityMode).toBe("amendment");
    expect(amendment?.baseLawNumber).toBe("03/L-212");
  });

  it("contains technical metadata only and performs no import-time I/O", () => {
    expect(artifactSource).not.toMatch(/\bfetch\s*\(/i);
    expect(artifactSource).not.toMatch(/createClient\s*\(/i);
    expect(artifactSource).not.toMatch(/supabase/i);
    expect(artifactSource).not.toMatch(/\b(content|fullText|legalText)\s*:/i);
    expect(artifactSource).not.toMatch(/\b(uuid|databaseId)\s*:/i);
  });
});
