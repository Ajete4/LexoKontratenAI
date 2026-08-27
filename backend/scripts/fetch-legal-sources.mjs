import { createHash } from "node:crypto";
import { mkdir, readFile, rename, rm, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const OFFICIAL_HOST = "gzk.rks-gov.net";
const MAX_BYTES = 50 * 1024 * 1024;
const MAX_REDIRECTS = 3;
const REQUEST_TIMEOUT_MS = 30_000;

const SOURCES = Object.freeze([
  Object.freeze({
    lawNumber: "03/L-212",
    actDocumentUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2735",
    directoryName: "03-L-212"
  }),
  Object.freeze({
    lawNumber: "04/L-077",
    actDocumentUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2828",
    directoryName: "04-L-077"
  }),
  Object.freeze({
    lawNumber: "08/L-142",
    actDocumentUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=96360",
    directoryName: "08-L-142"
  })
]);

const backendDirectory = resolve(
  dirname(fileURLToPath(import.meta.url)),
  ".."
);

function assertOfficialUrl(input) {
  const url = new URL(input);

  if (url.protocol !== "https:" || url.hostname !== OFFICIAL_HOST) {
    throw new Error("LEGAL_SOURCE_HOST_NOT_ALLOWED");
  }

  return url;
}

function decodeHtmlAttribute(value) {
  return value
    .replaceAll("&amp;", "&")
    .replaceAll("&quot;", '"')
    .replaceAll("&#39;", "'")
    .replaceAll("&lt;", "<")
    .replaceAll("&gt;", ">");
}

function parseAttributes(tag) {
  const attributes = new Map();
  const pattern = /([\w:$-]+)\s*=\s*(?:"([^"]*)"|'([^']*)')/g;

  for (const match of tag.matchAll(pattern)) {
    const name = match[1]?.toLowerCase();
    const value = match[2] ?? match[3];

    if (name !== undefined && value !== undefined) {
      attributes.set(name, decodeHtmlAttribute(value));
    }
  }

  return attributes;
}

function createPdfPostBody(html) {
  const body = new URLSearchParams();

  for (const match of html.matchAll(/<input\b[^>]*>/gi)) {
    const attributes = parseAttributes(match[0]);

    if (attributes.get("type")?.toLowerCase() !== "hidden") {
      continue;
    }

    const name = attributes.get("name");

    if (name !== undefined) {
      body.set(name, attributes.get("value") ?? "");
    }
  }

  if (!body.has("__VIEWSTATE")) {
    throw new Error("OFFICIAL_DOWNLOAD_FORM_NOT_FOUND");
  }

  body.set("ctl00$MainContent$imgPDF.x", "1");
  body.set("ctl00$MainContent$imgPDF.y", "1");

  return body;
}

async function fetchWithRedirectValidation(input, init = {}) {
  let currentUrl = assertOfficialUrl(input);
  let currentInit = { ...init, redirect: "manual" };
  const redirectChain = [];

  for (let redirectCount = 0; redirectCount <= MAX_REDIRECTS; redirectCount += 1) {
    const response = await fetch(currentUrl, {
      ...currentInit,
      signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS)
    });
    redirectChain.push(currentUrl.toString());

    if (![301, 302, 303, 307, 308].includes(response.status)) {
      return { response, redirectChain };
    }

    const location = response.headers.get("location");

    if (location === null || redirectCount === MAX_REDIRECTS) {
      throw new Error("LEGAL_SOURCE_REDIRECT_LIMIT");
    }

    currentUrl = assertOfficialUrl(new URL(location, currentUrl).toString());

    if (response.status === 303 || response.status === 301 || response.status === 302) {
      currentInit = { method: "GET", redirect: "manual" };
    }
  }

  throw new Error("LEGAL_SOURCE_REDIRECT_LIMIT");
}

async function readResponseBytes(response) {
  if (!response.ok || response.body === null) {
    throw new Error(`LEGAL_SOURCE_HTTP_${response.status}`);
  }

  const contentLength = response.headers.get("content-length");

  if (contentLength !== null && Number(contentLength) > MAX_BYTES) {
    throw new Error("LEGAL_SOURCE_TOO_LARGE");
  }

  const chunks = [];
  let totalBytes = 0;

  for await (const chunk of response.body) {
    totalBytes += chunk.byteLength;

    if (totalBytes > MAX_BYTES) {
      throw new Error("LEGAL_SOURCE_TOO_LARGE");
    }

    chunks.push(chunk);
  }

  return Buffer.concat(chunks, totalBytes);
}

function detectDocument(bytes) {
  if (bytes.subarray(0, 5).toString("ascii") === "%PDF-") {
    return { documentFormat: "pdf", extension: "pdf" };
  }

  const prefix = bytes.subarray(0, 512).toString("utf8").trimStart().toLowerCase();

  if (prefix.startsWith("<!doctype html") || prefix.startsWith("<html")) {
    return { documentFormat: "html", extension: "html" };
  }

  throw new Error("LEGAL_SOURCE_FORMAT_UNSUPPORTED");
}

async function writeOriginalAtomically(targetPath, bytes, sha256) {
  try {
    const existingBytes = await readFile(targetPath);
    const existingHash = createHash("sha256").update(existingBytes).digest("hex");

    if (existingHash !== sha256) {
      throw new Error("LEGAL_SOURCE_EXISTING_FILE_MISMATCH");
    }

    return "unchanged";
  } catch (error) {
    if (error instanceof Error && error.message === "LEGAL_SOURCE_EXISTING_FILE_MISMATCH") {
      throw error;
    }

    if (!(error instanceof Error) || !Object.hasOwn(error, "code") || error.code !== "ENOENT") {
      throw error;
    }
  }

  await mkdir(dirname(targetPath), { recursive: true });
  const temporaryPath = `${targetPath}.tmp-${crypto.randomUUID()}`;

  try {
    await writeFile(temporaryPath, bytes, { flag: "wx" });
    await rename(temporaryPath, targetPath);
  } finally {
    await rm(temporaryPath, { force: true });
  }

  return "created";
}

async function fetchSource(source) {
  const pageResult = await fetchWithRedirectValidation(source.actDocumentUrl);
  const pageContentType = pageResult.response.headers.get("content-type") ?? "";

  if (!pageContentType.toLowerCase().startsWith("text/html")) {
    throw new Error("OFFICIAL_DOCUMENT_PAGE_NOT_HTML");
  }

  const pageBytes = await readResponseBytes(pageResult.response);
  const pageHtml = pageBytes.toString("utf8");
  const postBody = createPdfPostBody(pageHtml);
  const documentResult = await fetchWithRedirectValidation(source.actDocumentUrl, {
    method: "POST",
    headers: {
      "content-type": "application/x-www-form-urlencoded"
    },
    body: postBody
  });
  const documentBytes = await readResponseBytes(documentResult.response);
  const detected = detectDocument(documentBytes);
  const sha256 = createHash("sha256").update(documentBytes).digest("hex");
  const relativePath = `data/legal-sources/raw/${source.directoryName}/official.${detected.extension}`;
  const targetPath = resolve(backendDirectory, relativePath);
  const writeStatus = await writeOriginalAtomically(targetPath, documentBytes, sha256);

  return {
    lawNumber: source.lawNumber,
    localRelativePath: relativePath.replaceAll("\\", "/"),
    officialDownloadUrl: documentResult.response.url || source.actDocumentUrl,
    redirectChain: documentResult.redirectChain,
    contentType: documentResult.response.headers.get("content-type"),
    contentLength: documentResult.response.headers.get("content-length"),
    documentFormat: detected.documentFormat,
    fileSizeBytes: documentBytes.byteLength,
    sha256,
    retrievedAt: new Date().toISOString(),
    writeStatus
  };
}

const results = [];

for (const source of SOURCES) {
  results.push(await fetchSource(source));
}

process.stdout.write(`${JSON.stringify(results, null, 2)}\n`);
