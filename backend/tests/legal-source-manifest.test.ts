import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";

const manifestSourcePath = fileURLToPath(
  new URL("../src/legal/legal-source-manifest.ts", import.meta.url)
);
const manifestSource = readFileSync(manifestSourcePath, "utf8");

describe("P0 legal source manifest", () => {
  it("contains exactly the three unique P0 laws", () => {
    expect(LEGAL_SOURCE_MANIFEST).toHaveLength(3);
    expect(LEGAL_SOURCE_MANIFEST.map(({ lawNumber }) => lawNumber)).toEqual([
      "03/L-212",
      "04/L-077",
      "08/L-142"
    ]);
    expect(
      new Set(LEGAL_SOURCE_MANIFEST.map(({ lawNumber }) => lawNumber)).size
    ).toBe(3);
  });

  it("uses only official HTTPS Kosovo Gazette URLs", () => {
    for (const source of LEGAL_SOURCE_MANIFEST) {
      for (const url of [source.officialUrl, source.officialDocumentUrl]) {
        const parsedUrl = new URL(url);

        expect(parsedUrl.protocol).toBe("https:");
        expect(parsedUrl.hostname).toBe("gzk.rks-gov.net");
      }
    }
  });

  it("uses the Albanian Kosovo metadata scope", () => {
    const allowedContractTypes = new Set(["employment", "service", "lease"]);

    for (const source of LEGAL_SOURCE_MANIFEST) {
      expect(source.language).toBe("sq");
      expect(source.jurisdiction).toBe("XK");
      expect(source.verifiedSource).toBe(true);
      expect(source.applicability.every((type) => allowedContractTypes.has(type))).toBe(
        true
      );
    }
  });

  it("maps the two base laws only to their approved MVP contract types", () => {
    const labourLaw = LEGAL_SOURCE_MANIFEST.find(
      ({ lawNumber }) => lawNumber === "03/L-212"
    );
    const obligationsLaw = LEGAL_SOURCE_MANIFEST.find(
      ({ lawNumber }) => lawNumber === "04/L-077"
    );

    expect(labourLaw?.applicability).toEqual(["employment"]);
    expect(labourLaw?.applicabilityMode).toBe("direct");
    expect(obligationsLaw?.applicability).toEqual(["service", "lease"]);
    expect(obligationsLaw?.applicabilityMode).toBe("direct");
  });

  it("records 08/L-142 only as the verified employment amendment", () => {
    const amendment = LEGAL_SOURCE_MANIFEST.find(
      ({ lawNumber }) => lawNumber === "08/L-142"
    );

    expect(amendment?.documentType).toBe("amendment");
    expect(amendment?.applicability).toEqual(["employment"]);
    expect(amendment?.applicabilityMode).toBe("amendment");
    expect(amendment?.baseLawNumber).toBe("03/L-212");
    expect(amendment?.isConsolidated).toBe(false);
    expect(amendment?.textLayer).toBe("available");
    expect(amendment?.requiresOcr).toBe(false);
  });

  it("uses unique deterministic Official Gazette version labels", () => {
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

  it("contains no P1 or deferred sources", () => {
    const lawNumbers = LEGAL_SOURCE_MANIFEST.map(({ lawNumber }) => lawNumber);

    expect(lawNumbers).not.toContain("06/L-082");
    expect(lawNumbers).not.toContain("08/L-283");
  });

  it("contains metadata only and performs no import-time I/O", () => {
    expect(manifestSource).not.toMatch(/\bfetch\s*\(/i);
    expect(manifestSource).not.toMatch(/createClient\s*\(/i);
    expect(manifestSource).not.toMatch(/supabase/i);
    expect(manifestSource).not.toMatch(/storage(Path|Bucket)?\s*:/i);
    expect(manifestSource).not.toMatch(/sha(256)?\s*:/i);
    expect(manifestSource).not.toMatch(/\b(uuid|id)\s*:/i);
    expect(manifestSource).not.toMatch(/\b(content|fullText|legalText)\s*:/i);
  });
});
