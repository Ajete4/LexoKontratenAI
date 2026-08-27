import type { SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

import { supabaseAdmin } from "../config/supabase.js";
import { ApiError } from "../utils/ApiError.js";

const P0_LAW_NUMBERS = ["03/L-212", "04/L-077", "08/L-142"] as const;
const MAX_P0_CHUNKS = 2_000;

const sourceRowSchema = z
  .object({
    id: z.string().uuid(),
    title: z.string().trim().min(1),
    law_number: z.enum(P0_LAW_NUMBERS),
    version_label: z.string().trim().min(1),
    publication_date: z.string().date().nullable(),
    document_type: z.enum(["law", "amendment"]),
    applicability: z
      .array(z.enum(["employment", "service", "lease"]))
      .max(3)
      .refine((values) => new Set(values).size === values.length),
    legal_status: z.enum([
      "requires_manual_legal_verification",
      "verified_current",
      "superseded",
      "repealed"
    ]),
    official_url: z.string().url().startsWith("https://"),
    official_document_url: z.string().url().startsWith("https://").nullable()
  })
  .strict();

const chunkRowSchema = z
  .object({
    legal_source_id: z.string().uuid()
  })
  .strict();

const legalSourceSchema = z
  .object({
    id: z.string().uuid(),
    title: z.string().min(1),
    lawNumber: z.enum(P0_LAW_NUMBERS),
    versionLabel: z.string().min(1),
    publicationDate: z.string().date().nullable(),
    documentType: z.enum(["law", "amendment"]),
    applicability: z.array(z.enum(["employment", "service", "lease"])),
    legalStatus: z.enum([
      "requires_manual_legal_verification",
      "verified_current",
      "superseded",
      "repealed"
    ]),
    officialUrl: z.string().url().startsWith("https://"),
    officialDocumentUrl: z.string().url().startsWith("https://").nullable(),
    chunkCount: z.number().int().nonnegative()
  })
  .strict();

export type LegalSource = z.infer<typeof legalSourceSchema>;
export type ListLegalSources = () => Promise<LegalSource[]>;

function unavailable(): ApiError {
  return new ApiError(
    503,
    "LEGAL_SOURCES_UNAVAILABLE",
    "Legal sources are temporarily unavailable."
  );
}

function dataInvalid(): ApiError {
  return new ApiError(
    503,
    "LEGAL_SOURCES_DATA_INVALID",
    "Legal sources are temporarily unavailable."
  );
}

export function createListLegalSources(
  databaseClient: SupabaseClient = supabaseAdmin
): ListLegalSources {
  return async () => {
    const sourcesQuery = await databaseClient
      .from("legal_sources")
      .select(
        "id, title, law_number, version_label, publication_date, " +
          "document_type, applicability, legal_status, official_url, " +
          "official_document_url"
      )
      .in("law_number", [...P0_LAW_NUMBERS])
      .eq("verified_source", true)
      .eq("ingestion_status", "ingested")
      .order("law_number", { ascending: true });

    if (sourcesQuery.error) {
      throw unavailable();
    }

    const validatedSources = z
      .array(sourceRowSchema)
      .length(P0_LAW_NUMBERS.length)
      .safeParse(sourcesQuery.data ?? []);

    if (!validatedSources.success) {
      throw dataInvalid();
    }

    const returnedLawNumbers = new Set(
      validatedSources.data.map((source) => source.law_number)
    );

    if (
      P0_LAW_NUMBERS.some((lawNumber) => !returnedLawNumbers.has(lawNumber))
    ) {
      throw dataInvalid();
    }

    const sourceIds = validatedSources.data.map((source) => source.id);
    const chunksQuery = await databaseClient
      .from("legal_chunks")
      .select("legal_source_id")
      .in("legal_source_id", sourceIds)
      .limit(MAX_P0_CHUNKS);

    if (chunksQuery.error) {
      throw unavailable();
    }

    const validatedChunks = z
      .array(chunkRowSchema)
      .max(MAX_P0_CHUNKS)
      .safeParse(chunksQuery.data ?? []);

    if (!validatedChunks.success) {
      throw dataInvalid();
    }

    const sourceIdSet = new Set(sourceIds);
    const chunkCounts = new Map<string, number>();

    for (const chunk of validatedChunks.data) {
      if (!sourceIdSet.has(chunk.legal_source_id)) {
        throw dataInvalid();
      }

      chunkCounts.set(
        chunk.legal_source_id,
        (chunkCounts.get(chunk.legal_source_id) ?? 0) + 1
      );
    }

    const result = validatedSources.data.map((source) => ({
      id: source.id,
      title: source.title,
      lawNumber: source.law_number,
      versionLabel: source.version_label,
      publicationDate: source.publication_date,
      documentType: source.document_type,
      applicability: source.applicability,
      legalStatus: source.legal_status,
      officialUrl: source.official_url,
      officialDocumentUrl: source.official_document_url,
      chunkCount: chunkCounts.get(source.id) ?? 0
    }));
    const validatedResult = z.array(legalSourceSchema).safeParse(result);

    if (!validatedResult.success) {
      throw dataInvalid();
    }

    return validatedResult.data;
  };
}

export const listLegalSources = createListLegalSources();
