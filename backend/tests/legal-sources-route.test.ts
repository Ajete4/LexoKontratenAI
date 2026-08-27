import type { SupabaseClient } from "@supabase/supabase-js";
import request from "supertest";
import { describe, expect, it, vi } from "vitest";

import { createApp } from "../src/app.js";
import { createRequireAuth } from "../src/middleware/auth.js";
import {
  createListLegalSources,
  type LegalSource,
  type ListLegalSources
} from "../src/services/legal-sources.service.js";

const authenticatedMiddleware = createRequireAuth(async () => "user-a");
const sourceIds = [
  "11111111-1111-4111-8111-111111111111",
  "22222222-2222-4222-8222-222222222222",
  "33333333-3333-4333-8333-333333333333"
];
const sourceRows = [
  {
    id: sourceIds[0]!,
    title: "Ligji i Punës",
    law_number: "03/L-212",
    version_label: "official",
    publication_date: "2010-12-01",
    document_type: "law",
    applicability: ["employment"],
    legal_status: "verified_current",
    official_url: "https://gzk.rks-gov.net/law-1",
    official_document_url: "https://gzk.rks-gov.net/document-1"
  },
  {
    id: sourceIds[1]!,
    title: "Ligji për Marrëdhëniet e Detyrimeve",
    law_number: "04/L-077",
    version_label: "official",
    publication_date: "2012-06-19",
    document_type: "law",
    applicability: ["service", "lease"],
    legal_status: "verified_current",
    official_url: "https://gzk.rks-gov.net/law-2",
    official_document_url: "https://gzk.rks-gov.net/document-2"
  },
  {
    id: sourceIds[2]!,
    title: "Ligji ndryshues",
    law_number: "08/L-142",
    version_label: "official",
    publication_date: "2023-01-05",
    document_type: "amendment",
    applicability: ["employment"],
    legal_status: "verified_current",
    official_url: "https://gzk.rks-gov.net/law-3",
    official_document_url: null
  }
];

function createServiceHarness(options?: { sourceError?: boolean }) {
  const sourcesQuery = {
    select: vi.fn(),
    in: vi.fn(),
    eq: vi.fn(),
    order: vi.fn(async () => ({
      data: options?.sourceError ? null : sourceRows,
      error: options?.sourceError ? { message: "sensitive detail" } : null
    }))
  };
  sourcesQuery.select.mockReturnValue(sourcesQuery);
  sourcesQuery.in.mockReturnValue(sourcesQuery);
  sourcesQuery.eq.mockReturnValue(sourcesQuery);

  const chunkRows = [
    { legal_source_id: sourceIds[0] },
    { legal_source_id: sourceIds[0] },
    { legal_source_id: sourceIds[1] },
    { legal_source_id: sourceIds[2] }
  ];
  const chunksQuery = {
    select: vi.fn(),
    in: vi.fn(),
    limit: vi.fn(async () => ({ data: chunkRows, error: null }))
  };
  chunksQuery.select.mockReturnValue(chunksQuery);
  chunksQuery.in.mockReturnValue(chunksQuery);

  const from = vi.fn((table: string) =>
    table === "legal_sources" ? sourcesQuery : chunksQuery
  );
  const service = createListLegalSources(
    { from } as unknown as SupabaseClient
  );

  return { chunksQuery, from, service, sourcesQuery };
}

describe("GET /api/legal-sources", () => {
  it("requires authentication", async () => {
    const response = await request(createApp()).get("/api/legal-sources");

    expect(response.status).toBe(401);
    expect(response.body.error.code).toBe("AUTHENTICATION_REQUIRED");
  });

  it("returns only validated safe metadata", async () => {
    const legalSources: LegalSource[] = sourceRows.map((source, index) => ({
      id: source.id,
      title: source.title,
      lawNumber: source.law_number as LegalSource["lawNumber"],
      versionLabel: source.version_label,
      publicationDate: source.publication_date,
      documentType: source.document_type as LegalSource["documentType"],
      applicability: source.applicability as LegalSource["applicability"],
      legalStatus: source.legal_status as LegalSource["legalStatus"],
      officialUrl: source.official_url,
      officialDocumentUrl: source.official_document_url,
      chunkCount: index === 0 ? 100 : index === 1 ? 1_059 : 7
    }));
    const listLegalSources = vi.fn<ListLegalSources>(async () => legalSources);
    const response = await request(
      createApp({
        authMiddleware: authenticatedMiddleware,
        listLegalSources
      })
    )
      .get("/api/legal-sources")
      .set("Authorization", "Bearer synthetic-test-token");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ data: { legalSources } });
    expect(JSON.stringify(response.body)).not.toMatch(
      /content|embedding|vector|credential|sha256/iu
    );
  });
});

describe("legal sources service", () => {
  it("uses two bounded queries and counts chunks without N+1", async () => {
    const { chunksQuery, from, service, sourcesQuery } = createServiceHarness();
    const result = await service();

    expect(from).toHaveBeenCalledTimes(2);
    expect(from).toHaveBeenNthCalledWith(1, "legal_sources");
    expect(from).toHaveBeenNthCalledWith(2, "legal_chunks");
    expect(sourcesQuery.in).toHaveBeenCalledWith("law_number", [
      "03/L-212",
      "04/L-077",
      "08/L-142"
    ]);
    expect(sourcesQuery.eq).toHaveBeenCalledWith("verified_source", true);
    expect(sourcesQuery.eq).toHaveBeenCalledWith(
      "ingestion_status",
      "ingested"
    );
    expect(chunksQuery.in).toHaveBeenCalledWith("legal_source_id", sourceIds);
    expect(chunksQuery.limit).toHaveBeenCalledWith(2_000);
    expect(result.map((source) => source.chunkCount)).toEqual([2, 1, 1]);
  });

  it("maps database failures to a safe error", async () => {
    const { service } = createServiceHarness({ sourceError: true });

    await expect(service()).rejects.toMatchObject({
      statusCode: 503,
      code: "LEGAL_SOURCES_UNAVAILABLE",
      details: null
    });
  });
});
