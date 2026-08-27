export type ZipFixtureEntry = {
  centralExtra?: Buffer;
  compressedData?: Buffer;
  compressionMethod?: 0 | 8;
  data: Buffer | string;
  declaredUncompressedSize?: number;
  flags?: number;
  localExtra?: Buffer;
  name: string;
};

function crc32(buffer: Buffer): number {
  let crc = 0xffffffff;

  for (const byte of buffer) {
    crc ^= byte;

    for (let bit = 0; bit < 8; bit += 1) {
      crc = (crc >>> 1) ^ (crc & 1 ? 0xedb88320 : 0);
    }
  }

  return (crc ^ 0xffffffff) >>> 0;
}

export function createZipFixture(entries: ZipFixtureEntry[]): Buffer {
  const localEntries: Buffer[] = [];
  const centralEntries: Buffer[] = [];
  let localOffset = 0;

  for (const entry of entries) {
    const name = Buffer.from(entry.name, "utf8");
    const data = Buffer.isBuffer(entry.data)
      ? entry.data
      : Buffer.from(entry.data, "utf8");
    const compressedData = entry.compressedData ?? data;
    const compressionMethod = entry.compressionMethod ?? 0;
    const flags = entry.flags ?? 0x0800;
    const localExtra = entry.localExtra ?? Buffer.alloc(0);
    const centralExtra = entry.centralExtra ?? localExtra;
    const uncompressedSize = entry.declaredUncompressedSize ?? data.length;
    const localHeader = Buffer.alloc(30);
    localHeader.writeUInt32LE(0x04034b50, 0);
    localHeader.writeUInt16LE(20, 4);
    localHeader.writeUInt16LE(flags, 6);
    localHeader.writeUInt16LE(compressionMethod, 8);
    localHeader.writeUInt32LE(crc32(data), 14);
    localHeader.writeUInt32LE(compressedData.length, 18);
    localHeader.writeUInt32LE(uncompressedSize, 22);
    localHeader.writeUInt16LE(name.length, 26);
    localHeader.writeUInt16LE(localExtra.length, 28);
    localEntries.push(localHeader, name, localExtra, compressedData);

    const centralHeader = Buffer.alloc(46);
    centralHeader.writeUInt32LE(0x02014b50, 0);
    centralHeader.writeUInt16LE(20, 4);
    centralHeader.writeUInt16LE(20, 6);
    centralHeader.writeUInt16LE(flags, 8);
    centralHeader.writeUInt16LE(compressionMethod, 10);
    centralHeader.writeUInt32LE(crc32(data), 16);
    centralHeader.writeUInt32LE(compressedData.length, 20);
    centralHeader.writeUInt32LE(uncompressedSize, 24);
    centralHeader.writeUInt16LE(name.length, 28);
    centralHeader.writeUInt16LE(centralExtra.length, 30);
    centralHeader.writeUInt32LE(localOffset, 42);
    centralEntries.push(centralHeader, name, centralExtra);
    localOffset +=
      localHeader.length + name.length + localExtra.length + compressedData.length;
  }

  const localDirectory = Buffer.concat(localEntries);
  const centralDirectory = Buffer.concat(centralEntries);
  const endRecord = Buffer.alloc(22);
  endRecord.writeUInt32LE(0x06054b50, 0);
  endRecord.writeUInt16LE(entries.length, 8);
  endRecord.writeUInt16LE(entries.length, 10);
  endRecord.writeUInt32LE(centralDirectory.length, 12);
  endRecord.writeUInt32LE(localDirectory.length, 16);

  return Buffer.concat([localDirectory, centralDirectory, endRecord]);
}

const CONTENT_TYPES_XML = `<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>`;

const ROOT_RELATIONSHIPS_XML = `<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>`;

function escapeXml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

export function createMinimalDocxBuffer(
  paragraphs: string[] = [
    "Kontratë testuese me kushte dhe detyrime të përcaktuara qartë."
  ]
): Buffer {
  const paragraphXml = paragraphs
    .map(
      (paragraph) =>
        `<w:p><w:r><w:t xml:space="preserve">${escapeXml(paragraph)}</w:t></w:r></w:p>`
    )
    .join("");
  const documentXml = `<?xml version="1.0" encoding="UTF-8"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>${paragraphXml}<w:sectPr/></w:body>
</w:document>`;

  return createZipFixture([
    { name: "[Content_Types].xml", data: CONTENT_TYPES_XML },
    { name: "_rels/.rels", data: ROOT_RELATIONSHIPS_XML },
    { name: "word/document.xml", data: documentXml }
  ]);
}

export const validContentTypesXml = CONTENT_TYPES_XML;
export const validRootRelationshipsXml = ROOT_RELATIONSHIPS_XML;
