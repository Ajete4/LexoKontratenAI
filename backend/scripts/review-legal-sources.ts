import { createHash, randomUUID } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { LEGAL_SOURCE_ARTIFACTS } from "../src/legal/legal-source-artifacts.js";
import { LEGAL_SOURCE_MANIFEST } from "../src/legal/legal-source-manifest.js";
import type { ParsedLegalDocument } from "../src/legal/legal-document-parser.js";
import { extractLegalPdf } from "../src/legal/legal-pdf-extractor.js";
import {
  createLegalReviewReport,
  type LegalReviewReport
} from "../src/legal/legal-review.js";

const backendDirectory = resolve(dirname(fileURLToPath(import.meta.url)), "..");

const REVIEW_CONFIGURATIONS = {
  "03/L-212": {
    reviewedArticleNumbers: [
      1, 2, 3, 5, 10, 11, 12, 17, 18, 32, 49, 53, 67, 70, 71, 72, 78,
      80, 90, 100
    ],
    correctionsApplied: [
      {
        code: "MULTILINE_ARTICLE_TITLE",
        provenExample:
          "Article 4 title continued on a second PDF line but parsed.json previously kept only the first line.",
        resolution:
          "Consecutive title lines with the article-heading font are joined deterministically."
      },
      {
        code: "SPACED_PARAGRAPH_NUMBERING",
        provenExample:
          "Article 18 contained '1 . 3.' and Article 49 contained later numbered paragraphs merged into the preceding paragraph.",
        resolution:
          "Spaced paragraph and subparagraph markers are normalized only in paragraphNumber."
      },
      {
        code: "STRUCTURAL_HEADING_IN_ARTICLE_BODY",
        provenExample:
          "Headings such as 'PUSHIMET DHE MUNGESAT NGA PUNA' were attached to the preceding article body.",
        resolution:
          "Heading-font structural lines are preserved as structural_heading blocks."
      }
    ],
    remainingWarnings: [
      "Chapter and section headings are preserved separately but are not yet modeled as a complete hierarchy tree."
    ],
    reviewOutcome: "approved_with_warnings"
  },
  "04/L-077": {
    reviewedArticleNumbers: [
      1, 4, 20, 28, 35, 50, 75, 85, 100, 125, 154, 160, 170, 185, 239,
      245, 262, 275, 300, 307, 325, 346, 360, 385, 415, 450, 500, 585,
      600, 615, 630, 650, 850, 1000, 1059
    ],
    correctionsApplied: [
      {
        code: "STRUCTURAL_HEADING_IN_ARTICLE_BODY",
        provenExample:
          "Book, part, chapter and Roman-numbered section headings were attached to the preceding article body.",
        resolution:
          "Structural headings are preserved outside article body with page provenance."
      },
      {
        code: "MULTILINE_ARTICLE_TITLE",
        provenExample:
          "Long article headings spanning multiple visual lines were truncated after their first line.",
        resolution:
          "Consecutive heading-font lines are joined as one article title."
      },
      {
        code: "SPACED_PARAGRAPH_NUMBERING",
        provenExample:
          "PDF spacing variants around paragraph dots could merge a numbered paragraph with its predecessor.",
        resolution:
          "Paragraph markers with deterministic spacing variants are recognized and canonically numbered."
      }
    ],
    remainingWarnings: [
      "The complete multi-level book/part/chapter hierarchy remains represented as provenance blocks rather than a nested hierarchy."
    ],
    reviewOutcome: "approved_with_warnings"
  },
  "08/L-142": {
    reviewedArticleNumbers: [1, 2, 3, 4, 5, 6, 7],
    correctionsApplied: [
      {
        code: "MULTILINE_ARTICLE_TITLE",
        provenExample:
          "Titles of Articles 2 and 4 continued on a second PDF line that was previously treated as body text.",
        resolution:
          "Both title lines are joined using the shared heading font."
      },
      {
        code: "REPEATED_PAGE_HEADER",
        provenExample:
          "The four-line official-gazette header repeated on page 2 and was previously included in Article 3.",
        resolution:
          "Lines repeated on both pages are preserved as repeated_header_footer blocks."
      },
      {
        code: "NESTED_SUBPARAGRAPH_NUMBERING",
        provenExample:
          "Article 5 replacement text uses subparagraph 1.1 without a terminal dot.",
        resolution:
          "Nested numbering is recognized without changing the source text."
      }
    ],
    remainingWarnings: [
      "Amendment relations remain candidates requiring manual legal verification and are not database relations."
    ],
    reviewOutcome: "approved_with_warnings"
  }
} as const;

const AMENDMENT_CANDIDATES = [
  {
    amendingLawNumber: "08/L-142",
    amendingArticleNumber: "2",
    baseLawNumber: "04/L-261",
    baseArticleNumber: "16A",
    relationTypeCandidate: "amend",
    evidenceText: "Neni 16A, paragrafi 3 nën paragrafi 3.1 ... ndryshohet me tekstin si në vijim.",
    reviewStatus: "candidate_for_manual_review"
  },
  {
    amendingLawNumber: "08/L-142",
    amendingArticleNumber: "3",
    baseLawNumber: "04/L-092",
    baseArticleNumber: "7",
    relationTypeCandidate: "amend",
    evidenceText: "Neni 7, paragrafi 2 ... ndryshohet me tekstin si në vijim.",
    reviewStatus: "candidate_for_manual_review"
  },
  {
    amendingLawNumber: "08/L-142",
    amendingArticleNumber: "4",
    baseLawNumber: "05/L-067",
    baseArticleNumber: "7",
    relationTypeCandidate: "amend",
    evidenceText: "Neni 7, paragrafi 1 ... ndryshohet me tekstin si në vijim.",
    reviewStatus: "candidate_for_manual_review"
  },
  {
    amendingLawNumber: "08/L-142",
    amendingArticleNumber: "5",
    baseLawNumber: "05/L-028",
    baseArticleNumber: "6",
    relationTypeCandidate: "amend",
    evidenceText: "Neni 6 ... ndryshohet si në vijim.",
    reviewStatus: "candidate_for_manual_review"
  },
  {
    amendingLawNumber: "08/L-142",
    amendingArticleNumber: "6",
    baseLawNumber: "03/L-212",
    baseArticleNumber: "57",
    relationTypeCandidate: "amend",
    evidenceText: "Neni 57, paragrafi 1 ... ndryshohet si në vijim.",
    reviewStatus: "candidate_for_manual_review"
  }
] as const;

async function writeJsonAtomically(targetPath: string, value: unknown): Promise<void> {
  await mkdir(dirname(targetPath), { recursive: true });
  const temporaryPath = `${targetPath}.tmp-${randomUUID()}`;

  try {
    await writeFile(temporaryPath, `${JSON.stringify(value, null, 2)}\n`, {
      encoding: "utf8",
      flag: "wx"
    });
    await rename(temporaryPath, targetPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }
}

const reports: LegalReviewReport[] = [];

for (const [lawNumber, configuration] of Object.entries(REVIEW_CONFIGURATIONS)) {
  const artifact = LEGAL_SOURCE_ARTIFACTS.find((entry) => entry.lawNumber === lawNumber);
  const manifest = LEGAL_SOURCE_MANIFEST.find((entry) => entry.lawNumber === lawNumber);

  if (artifact === undefined || artifact.pageCount === null || manifest?.versionLabel == null) {
    throw new Error("LEGAL_REVIEW_CONFIGURATION_INVALID");
  }

  const sourceBytes = await readFile(resolve(backendDirectory, artifact.localRelativePath));
  const sourceHash = createHash("sha256").update(sourceBytes).digest("hex");

  if (sourceHash !== artifact.sha256) {
    throw new Error("LEGAL_REVIEW_INTEGRITY_FAILED");
  }

  const extracted = await extractLegalPdf(sourceBytes, {
    lawNumber,
    expectedSha256: artifact.sha256,
    expectedPageCount: artifact.pageCount
  });
  const directoryName = lawNumber.replaceAll("/", "-");
  const parsed = JSON.parse(
    await readFile(
      resolve(
        backendDirectory,
        "data",
        "legal-sources",
        "processed",
        directoryName,
        "parsed.json"
      ),
      "utf8"
    )
  ) as ParsedLegalDocument;
  const report = createLegalReviewReport(
    extracted,
    parsed,
    artifact.sha256,
    artifact.pageCount,
    manifest.versionLabel,
    configuration
  );

  if (Object.values(report.integrityGate).some((value) => !value)) {
    throw new Error("LEGAL_REVIEW_INTEGRITY_FAILED");
  }

  reports.push(report);
  await writeJsonAtomically(
    resolve(
      backendDirectory,
      "data",
      "legal-sources",
      "review",
      directoryName,
      "review-report.json"
    ),
    report
  );
}

await writeJsonAtomically(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "review",
    "08-L-142",
    "amendment-candidates.json"
  ),
  {
    amendingLawNumber: "08/L-142",
    candidates: AMENDMENT_CANDIDATES
  }
);

await writeJsonAtomically(
  resolve(
    backendDirectory,
    "data",
    "legal-sources",
    "review",
    "review-summary.json"
  ),
  {
    documents: reports.map((report) => ({
      lawNumber: report.lawNumber,
      checkedArticleCount: report.checkedArticleCount,
      checkedParagraphCount: report.checkedParagraphCount,
      reviewedPageTransitionCount: report.reviewedPageTransitions.length,
      reviewOutcome: report.reviewOutcome,
      remainingWarningCount: report.remainingWarnings.length
    })),
    blockedDocumentCount: reports.filter(
      (report) => report.reviewOutcome === "blocked"
    ).length,
    nextPhaseDecision: reports.some(
      (report) => report.reviewOutcome === "blocked"
    )
      ? "blocked"
      : "eligible_after_manual_approval"
  }
);
