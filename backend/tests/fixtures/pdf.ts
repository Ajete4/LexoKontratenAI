function escapePdfText(text: string): string {
  return text.replace(/([\\()])/g, "\\$1");
}

export function createSyntheticPdfBuffer(
  pageTexts: Array<string | null>
): Buffer {
  if (pageTexts.length === 0) {
    throw new Error("A synthetic PDF needs at least one page.");
  }

  const pageObjectStart = 3;
  const contentObjectStart = pageObjectStart + pageTexts.length;
  const fontObjectId = contentObjectStart + pageTexts.length;
  const pageReferences = pageTexts.map(
    (_text, index) => `${pageObjectStart + index} 0 R`
  );
  const objects: string[] = [
    "<< /Type /Catalog /Pages 2 0 R >>",
    `<< /Type /Pages /Kids [${pageReferences.join(" ")}] /Count ${pageTexts.length} >>`
  ];

  for (let index = 0; index < pageTexts.length; index += 1) {
    objects.push(
      `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] ` +
        `/Resources << /Font << /F1 ${fontObjectId} 0 R >> >> ` +
        `/Contents ${contentObjectStart + index} 0 R >>`
    );
  }

  for (const text of pageTexts) {
    const stream =
      text === null
        ? "q\nBI /W 1 /H 1 /CS /RGB /BPC 8 ID \x00\x00\x00 EI\nQ"
        : `BT /F1 12 Tf 72 720 Td (${escapePdfText(text)}) Tj ET`;

    objects.push(
      `<< /Length ${Buffer.byteLength(stream, "latin1")} >>\n` +
        `stream\n${stream}\nendstream`
    );
  }

  objects.push(
    "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica " +
      "/Encoding /WinAnsiEncoding >>"
  );

  let source = "%PDF-1.4\n%\xE2\xE3\xCF\xD3\n";
  const offsets = [0];

  for (let index = 0; index < objects.length; index += 1) {
    offsets.push(Buffer.byteLength(source, "latin1"));
    source += `${index + 1} 0 obj\n${objects[index]}\nendobj\n`;
  }

  const xrefOffset = Buffer.byteLength(source, "latin1");
  source += `xref\n0 ${objects.length + 1}\n`;
  source += "0000000000 65535 f \n";

  for (const offset of offsets.slice(1)) {
    source += `${String(offset).padStart(10, "0")} 00000 n \n`;
  }

  source +=
    `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\n` +
    `startxref\n${xrefOffset}\n%%EOF\n`;

  return Buffer.from(source, "latin1");
}
