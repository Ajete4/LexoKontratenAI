import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

import { describe, expect, it } from "vitest";

import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";

const REQUIRED_REPORT_KEYS = [
  "lawNumber",
  "sourceSha256",
  "versionLabel",
  "integrityGate",
  "reviewedArticleNumbers",
  "reviewedPageTransitions",
  "checkedArticleCount",
  "checkedParagraphCount",
  "titleIssues",
  "paragraphIssues",
  "orderingIssues",
  "duplicateIssues",
  "unassignedBlockClassification",
  "unicodeIssues",
  "correctionsApplied",
  "remainingWarnings",
  "reviewOutcome"
] as const;

const REQUIRED_SAMPLES = {
  "03/L-212": [
    "1", "2", "3", "5", "10", "11", "12", "17", "18", "32",
    "49", "53", "67", "70", "71", "72", "78", "80", "90", "100"
  ],
  "04/L-077": [
    "1", "4", "20", "28", "35", "50", "75", "85", "100", "125",
    "154", "160", "170", "185", "239", "245", "262", "275", "300",
    "307", "325", "346", "360", "385", "415", "450", "500", "585",
    "600", "615", "630", "650", "850", "1000", "1059"
  ],
  "08/L-142": ["1", "2", "3", "4", "5", "6", "7"]
} as const;

async function readJson(path: string): Promise<Record<string, unknown>> {
  return JSON.parse(
    await readFile(resolve(process.cwd(), path), "utf8")
  ) as Record<string, unknown>;
}

describe("legal review artifacts", () => {
  it("uses a strict deterministic report shape and passes every integrity gate", async () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const directory = artifact.lawNumber.replaceAll("/", "-");
      const report = await readJson(
        `data/legal-sources/review/${directory}/review-report.json`
      );

      expect(Object.keys(report)).toEqual(REQUIRED_REPORT_KEYS);
      expect(report.integrityGate).toEqual({
        sha256Matches: true,
        pageCountMatches: true,
        lawNumberMatches: true,
        versionLabelMatches: true
      });
      expect(report.reviewOutcome).toBe("approved_with_warnings");
    }
  });

  it("contains the required minimum sampling and every physical page transition", async () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const directory = artifact.lawNumber.replaceAll("/", "-");
      const report = await readJson(
        `data/legal-sources/review/${directory}/review-report.json`
      );

      expect(report.reviewedArticleNumbers).toEqual(
        REQUIRED_SAMPLES[artifact.lawNumber as keyof typeof REQUIRED_SAMPLES]
      );
      expect(report.checkedArticleCount).toBe(
        REQUIRED_SAMPLES[artifact.lawNumber as keyof typeof REQUIRED_SAMPLES].length
      );
      expect(report.reviewedPageTransitions).toHaveLength(
        (artifact.pageCount ?? 0) - 1
      );
      expect(report.reviewedPageTransitions).toEqual(
        expect.arrayContaining([
          expect.objectContaining({ result: "verified" })
        ])
      );
    }
  });

  it("preserves corrected multi-line titles, hierarchy and paragraph numbering", async () => {
    const labor = await readJson(
      "data/legal-sources/processed/03-L-212/parsed.json"
    );
    const obligations = await readJson(
      "data/legal-sources/processed/04-L-077/parsed.json"
    );
    const amendment = await readJson(
      "data/legal-sources/processed/08-L-142/parsed.json"
    );
    const laborArticles = labor.articles as Array<Record<string, unknown>>;
    const obligationsArticles = obligations.articles as Array<Record<string, unknown>>;
    const amendmentArticles = amendment.articles as Array<Record<string, unknown>>;

    expect(laborArticles[3]?.articleTitle).toBe(
      "Hierarkia në mes të Ligjit, Kontratës Kolektive, Aktit të Brendshëm të Punëdhënësit dhe Kontratës së Punës"
    );
    expect(
      (laborArticles[17]?.paragraphs as Array<Record<string, unknown>>).map(
        (paragraph) => paragraph.paragraphNumber
      )
    ).toContain("1.3");
    expect(
      (obligationsArticles[49]?.text as string).includes("VI. FORMA E KONTRATËS")
    ).toBe(false);
    expect(amendmentArticles[1]?.articleTitle).toBe(
      "Ndryshimi dhe plotësimi i Ligjit Nr. 04/L-261 për Veteranët e Luftës së Ushtrisë Çlirimtare të Kosovës, i ndryshuar dhe plotësuar me Ligjin Nr. 05/L-141"
    );
    expect(amendmentArticles[3]?.articleTitle).toBe(
      "Ndryshimi dhe plotësimi i Ligjit Nr. 05/L -067 për Statusin dhe të Drejtat e Personave Paraplegjik dhe Tetraplegjik"
    );
    expect(amendmentArticles[2]?.text).not.toContain(
      "GAZETA ZYRTARE E REPUBLIKËS SË KOSOVËS"
    );
  });

  it("reviews all seven amendment articles and records only evidenced candidates", async () => {
    const report = await readJson(
      "data/legal-sources/review/08-L-142/review-report.json"
    );
    const artifact = await readJson(
      "data/legal-sources/review/08-L-142/amendment-candidates.json"
    );
    const candidates = artifact.candidates as Array<Record<string, unknown>>;

    expect(report.reviewedArticleNumbers).toEqual([
      "1", "2", "3", "4", "5", "6", "7"
    ]);
    expect(candidates).toHaveLength(5);

    for (const candidate of candidates) {
      expect(candidate).toEqual(
        expect.objectContaining({
          amendingLawNumber: "08/L-142",
          baseArticleNumber: expect.any(String),
          relationTypeCandidate: "amend",
          reviewStatus: "candidate_for_manual_review"
        })
      );
      expect(candidate.evidenceText).toContain(
        `Neni ${candidate.baseArticleNumber as string}`
      );
    }
  });

  it("keeps raw hashes valid and review outputs free of dynamic or remote data", async () => {
    for (const artifact of LEGAL_SOURCE_ARTIFACTS) {
      const bytes = await readFile(resolve(process.cwd(), artifact.localRelativePath));
      expect(createHash("sha256").update(bytes).digest("hex")).toBe(
        artifact.sha256
      );
    }

    const reviewFiles = [
      "data/legal-sources/review/03-L-212/review-report.json",
      "data/legal-sources/review/04-L-077/review-report.json",
      "data/legal-sources/review/08-L-142/review-report.json",
      "data/legal-sources/review/08-L-142/amendment-candidates.json",
      "data/legal-sources/review/review-summary.json"
    ];
    const content = (
      await Promise.all(
        reviewFiles.map((path) => readFile(resolve(process.cwd(), path), "utf8"))
      )
    ).join("\n");

    expect(content).not.toMatch(/https?:\/\//iu);
    expect(content).not.toMatch(/supabase|openai|embedding/iu);
    expect(content).not.toMatch(/[A-Z]:\\|\/Users\//u);
    expect(content).not.toMatch(/[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/iu);
    expect(content).not.toMatch(/"(?:createdAt|updatedAt|reviewedAt|timestamp)"\s*:/u);
  });
});
