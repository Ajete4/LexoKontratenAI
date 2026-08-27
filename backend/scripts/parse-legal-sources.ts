import { randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";
import { parseLegalDocument } from "../src/legal/legal-document-parser.js";
import { extractLegalPdf } from "../src/legal/legal-pdf-extractor.js";
import { createLegalQualityReport } from "../src/legal/legal-quality-report.js";

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");

const ALLOWED_LAWS = Object.freeze(["03/L-212", "04/L-077", "08/L-142"] as const);

async function writeJsonAtomically(targetPath: string, value: unknown): Promise<void> {
  await mkdir(dirname(targetPath), { recursive: true });
  const temporaryPath = `${targetPath}.tmp-${randomUUID()}`;
  const serialized = `${JSON.stringify(value, null, 2)}\n`;

  try {
    await writeFile(temporaryPath, serialized, { encoding: "utf8", flag: "wx" });
    await rename(temporaryPath, targetPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

for (const lawNumber of ALLOWED_LAWS) {
  const artifact = LEGAL_SOURCE_ARTIFACTS.find((entry) => entry.lawNumber === lawNumber);
  const manifest = LEGAL_SOURCE_MANIFEST.find((entry) => entry.lawNumber === lawNumber);

  if (
    artifact === undefined ||
    manifest === undefined ||
    artifact.documentFormat !== "pdf" ||
    artifact.pageCount === null ||
    manifest.versionLabel === null
  ) {
    throw new Error("LEGAL_SOURCE_CONFIGURATION_INVALID");
  }

  const rawPath = resolve(backendDirectory, artifact.localRelativePath);
  const rawBytes = await readFile(rawPath);
  const extracted = await extractLegalPdf(rawBytes, {
    lawNumber,
    expectedSha256: artifact.sha256,
    expectedPageCount: artifact.pageCount
  });
  const parsed = parseLegalDocument(extracted, {
    lawNumber,
    versionLabel: manifest.versionLabel,
    documentType: manifest.documentType,
    baseLawNumber: manifest.baseLawNumber
  });
  const report = createLegalQualityReport(extracted, parsed);
  const directoryName = lawNumber.replaceAll("/", "-");
  const processedDirectory = resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "processed",
    directoryName
  );

  await writeJsonAtomically(resolve(processedDirectory, "parsed.json"), parsed);
  await writeJsonAtomically(resolve(processedDirectory, "quality-report.json"), report);

  process.stdout.write(
    `${JSON.stringify({
      lawNumber,
      pageCount: report.pageCount,
      articleCount: report.articleCount,
      paragraphCount: report.paragraphCount,
      unassignedBlockCount: report.unassignedBlockCount,
      structureStatus: report.structureStatus
    })}\n`
  );
}
