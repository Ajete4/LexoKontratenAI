import type { ContractAnalysisResponse } from "./contract-analysis.service.js";
import {
  getContractAnalysis,
  type GetContractAnalysis
} from "./analysis-retrieval.service.js";

type PdfLine = {
  text: string;
  bold?: boolean;
  size?: number;
  spacingAfter?: number;
};

export type ExportAnalysisPdf = (input: {
  userId: string;
  accessToken: string;
  contractId: string;
  versionId: string;
}) => Promise<{ buffer: Buffer; fileName: string }>;

const contractTypeLabels = {
  employment: "Punësim",
  service: "Shërbim",
  lease: "Qira"
} as const;

const riskLabels = {
  none: "Informuese",
  low: "I ulët",
  medium: "Mesatar",
  high: "I lartë",
  critical: "Kritik",
  review_required: "Kërkon shqyrtim",
  unknown: "I panjohur"
} as const;

function normalizePdfText(value: string): string {
  return value
    .replace(/[–—]/gu, "-")
    .replace(/[“”]/gu, '"')
    .replace(/[‘’]/gu, "'")
    .replace(/[^\x20-\x7E\xA0-\xFF]/gu, "?");
}

function escapePdfText(value: string): string {
  return normalizePdfText(value)
    .replace(/\\/gu, "\\\\")
    .replace(/\(/gu, "\\(")
    .replace(/\)/gu, "\\)");
}

function wrapText(value: string, maximumLength = 88): string[] {
  const paragraphs = value.split(/\r?\n/gu);
  const lines: string[] = [];

  for (const paragraph of paragraphs) {
    const words = paragraph.trim().split(/\s+/gu).filter(Boolean);
    if (words.length === 0) {
      lines.push("");
      continue;
    }

    let current = "";
    for (const word of words) {
      if (current.length > 0 && current.length + word.length + 1 > maximumLength) {
        lines.push(current);
        current = word;
      } else {
        current = current.length === 0 ? word : `${current} ${word}`;
      }
    }
    if (current.length > 0) lines.push(current);
  }

  return lines;
}

function addWrappedLine(
  lines: PdfLine[],
  text: string,
  options: Omit<PdfLine, "text"> = {}
): void {
  for (const wrapped of wrapText(text, options.size && options.size >= 14 ? 68 : 88)) {
    lines.push({ text: wrapped, ...options });
  }
}

function createReportLines(analysis: ContractAnalysisResponse): PdfLine[] {
  const lines: PdfLine[] = [];
  addWrappedLine(lines, "LexoKontratën AI - Raporti i analizës", {
    bold: true,
    size: 17,
    spacingAfter: 8
  });
  addWrappedLine(lines, analysis.result.title, {
    bold: true,
    size: 14,
    spacingAfter: 4
  });
  addWrappedLine(
    lines,
    `Lloji: ${contractTypeLabels[analysis.result.contractType]} | Statusi: Përfunduar | Rreziku i përgjithshëm: ${riskLabels[analysis.result.overallRiskLevel]}`,
    { spacingAfter: 10 }
  );

  addWrappedLine(lines, "Përmbledhje", { bold: true, size: 13 });
  addWrappedLine(lines, analysis.result.summary, { spacingAfter: 8 });
  addWrappedLine(lines, analysis.result.overallRiskExplanation, {
    spacingAfter: 10
  });

  addWrappedLine(lines, "Afatet dhe termat kryesorë", {
    bold: true,
    size: 13
  });
  if (analysis.result.keyDates.length === 0 &&
      analysis.result.terminationTerms.length === 0) {
    addWrappedLine(lines, "Nuk u identifikuan afate të strukturuara.", {
      spacingAfter: 8
    });
  } else {
    for (const item of analysis.result.keyDates) {
      addWrappedLine(
        lines,
        `- ${item.label}: ${item.date ?? "E papërcaktuar"}${item.description ? ` - ${item.description}` : ""}`
      );
    }
    for (const item of analysis.result.terminationTerms) {
      addWrappedLine(lines, `- ${item.title}: ${item.description}`);
    }
    lines.push({ text: "", spacingAfter: 6 });
  }

  addWrappedLine(lines, "Elementet që mungojnë", {
    bold: true,
    size: 13
  });
  if (analysis.result.missingInformation.length === 0) {
    addWrappedLine(lines, "Nuk u raportuan elemente të munguara.", {
      spacingAfter: 8
    });
  } else {
    for (const item of analysis.result.missingInformation) {
      addWrappedLine(lines, `- ${item}`);
    }
    lines.push({ text: "", spacingAfter: 6 });
  }

  addWrappedLine(lines, "Klauzolat e identifikuara", {
    bold: true,
    size: 13,
    spacingAfter: 3
  });
  for (const clause of analysis.clauses) {
    addWrappedLine(
      lines,
      `${clause.position}. ${clause.title} - Rreziku: ${riskLabels[clause.severity]}`,
      { bold: true, spacingAfter: 2 }
    );
    if (clause.originalText) {
      addWrappedLine(lines, `Teksti: ${clause.originalText}`);
    }
    if (clause.riskExplanation) {
      addWrappedLine(lines, `Shpjegimi: ${clause.riskExplanation}`);
    }
    if (clause.suggestedAction) {
      addWrappedLine(lines, `Veprimi i sugjeruar: ${clause.suggestedAction}`);
    }
    if (clause.citations.length > 0) {
      addWrappedLine(lines, "Burimet ligjore:", { bold: true });
      for (const citation of clause.citations) {
        addWrappedLine(
          lines,
          `- ${citation.lawNumber}${citation.articleNumber ? `, Neni ${citation.articleNumber}` : ""}${citation.articleTitle ? ` - ${citation.articleTitle}` : ""} | ${citation.officialUrl}`
        );
      }
    }
    lines.push({ text: "", spacingAfter: 5 });
  }

  addWrappedLine(lines, "Kufizimi juridik", { bold: true, size: 13 });
  addWrappedLine(lines, analysis.result.disclaimer);
  return lines;
}

function renderPage(lines: PdfLine[], pageNumber: number): Buffer {
  let y = 792;
  const commands: string[] = [];

  for (const line of lines) {
    const size = line.size ?? 10;
    const font = line.bold ? "F2" : "F1";
    commands.push(
      `BT /${font} ${size} Tf 48 ${y} Td (${escapePdfText(line.text)}) Tj ET`
    );
    y -= size + 4 + (line.spacingAfter ?? 0);
  }

  commands.push(
    `BT /F1 8 Tf 48 28 Td (LexoKontratën AI - Faqja ${pageNumber}) Tj ET`
  );
  return Buffer.from(commands.join("\n"), "latin1");
}

function paginate(lines: PdfLine[]): PdfLine[][] {
  const pages: PdfLine[][] = [];
  let current: PdfLine[] = [];
  let usedHeight = 0;

  for (const line of lines) {
    const height = (line.size ?? 10) + 4 + (line.spacingAfter ?? 0);
    if (current.length > 0 && usedHeight + height > 720) {
      pages.push(current);
      current = [];
      usedHeight = 0;
    }
    current.push(line);
    usedHeight += height;
  }

  if (current.length > 0) pages.push(current);
  return pages.length > 0 ? pages : [[{ text: "Raporti është bosh." }]];
}

export function createAnalysisPdf(analysis: ContractAnalysisResponse): Buffer {
  const pages = paginate(createReportLines(analysis));
  const pageObjectIds = pages.map((_, index) => 5 + index * 2);
  const objects = new Map<number, Buffer>();

  objects.set(1, Buffer.from("<< /Type /Catalog /Pages 2 0 R >>", "ascii"));
  objects.set(
    2,
    Buffer.from(
      `<< /Type /Pages /Kids [${pageObjectIds.map((id) => `${id} 0 R`).join(" ")}] /Count ${pages.length} >>`,
      "ascii"
    )
  );
  objects.set(
    3,
    Buffer.from("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>", "ascii")
  );
  objects.set(
    4,
    Buffer.from("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>", "ascii")
  );

  pages.forEach((pageLines, index) => {
    const pageId = pageObjectIds[index]!;
    const contentId = pageId + 1;
    const stream = renderPage(pageLines, index + 1);
    objects.set(
      pageId,
      Buffer.from(`<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents ${contentId} 0 R >>`, "ascii")
    );
    objects.set(
      contentId,
      Buffer.concat([
        Buffer.from(`<< /Length ${stream.length} >>\nstream\n`, "ascii"),
        stream,
        Buffer.from("\nendstream", "ascii")
      ])
    );
  });

  const header = Buffer.from("%PDF-1.4\n%\xE2\xE3\xCF\xD3\n", "latin1");
  const chunks: Buffer[] = [header];
  const offsets = [0];
  let offset = header.length;
  const maximumObjectId = Math.max(...objects.keys());

  for (let id = 1; id <= maximumObjectId; id += 1) {
    const body = objects.get(id)!;
    const object = Buffer.concat([
      Buffer.from(`${id} 0 obj\n`, "ascii"),
      body,
      Buffer.from("\nendobj\n", "ascii")
    ]);
    offsets[id] = offset;
    chunks.push(object);
    offset += object.length;
  }

  const xrefOffset = offset;
  const xrefLines = [
    "xref",
    `0 ${maximumObjectId + 1}`,
    "0000000000 65535 f "
  ];
  for (let id = 1; id <= maximumObjectId; id += 1) {
    xrefLines.push(`${String(offsets[id]).padStart(10, "0")} 00000 n `);
  }
  chunks.push(Buffer.from(
    `${xrefLines.join("\n")}\ntrailer\n<< /Size ${maximumObjectId + 1} /Root 1 0 R >>\nstartxref\n${xrefOffset}\n%%EOF\n`,
    "ascii"
  ));
  return Buffer.concat(chunks);
}

function safeFileName(title: string): string {
  const base = normalizePdfText(title)
    .replace(/[^a-zA-Z0-9À-ÿ]+/gu, "-")
    .replace(/^-+|-+$/gu, "")
    .slice(0, 80);
  return `${base || "analiza-e-kontrates"}.pdf`;
}

export function createExportAnalysisPdf(
  getAnalysis: GetContractAnalysis = getContractAnalysis
): ExportAnalysisPdf {
  return async (input) => {
    const analysis = await getAnalysis(input);
    return {
      buffer: createAnalysisPdf(analysis),
      fileName: safeFileName(analysis.result.title)
    };
  };
}

export const exportAnalysisPdf = createExportAnalysisPdf();

