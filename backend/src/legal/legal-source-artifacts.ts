export type LegalArtifactFormat = "pdf" | "html";

export type LegalArtifactTextLayer =
  | "available"
  | "not_available"
  | "not_verified";

export interface LegalSourceArtifact {
  readonly lawNumber: string;
  readonly localRelativePath: string;
  readonly officialDownloadUrl: string;
  readonly mediaType: string;
  readonly fileSizeBytes: number;
  readonly sha256: string;
  readonly retrievedAt: string;
  readonly documentFormat: LegalArtifactFormat;
  readonly pageCount: number | null;
  readonly textLayer: LegalArtifactTextLayer;
  readonly requiresOcr: boolean | null;
  readonly encoding: string | null;
  readonly identityVerified: boolean;
}

export const LEGAL_SOURCE_ARTIFACTS = [
  {
    lawNumber: "03/L-212",
    localRelativePath: "data/legal-sources/raw/03-L-212/official.pdf",
    officialDownloadUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2735",
    mediaType: "application/pdf",
    fileSizeBytes: 169_900,
    sha256: "98aaf8e8e06df611f1277a5305928e7d6a28bafe8322ab7fcdfd219a3a981da5",
    retrievedAt: "2026-08-11T10:45:31.335Z",
    documentFormat: "pdf",
    pageCount: 29,
    textLayer: "available",
    requiresOcr: false,
    encoding: null,
    identityVerified: true
  },
  {
    lawNumber: "04/L-077",
    localRelativePath: "data/legal-sources/raw/04-L-077/official.pdf",
    officialDownloadUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2828",
    mediaType: "application/pdf",
    fileSizeBytes: 1_417_444,
    sha256: "97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4",
    retrievedAt: "2026-08-11T10:45:34.457Z",
    documentFormat: "pdf",
    pageCount: 232,
    textLayer: "available",
    requiresOcr: false,
    encoding: null,
    identityVerified: true
  },
  {
    lawNumber: "08/L-142",
    localRelativePath: "data/legal-sources/raw/08-L-142/official.pdf",
    officialDownloadUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=96360",
    mediaType: "application/pdf",
    fileSizeBytes: 213_218,
    sha256: "1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b",
    retrievedAt: "2026-08-11T10:45:34.616Z",
    documentFormat: "pdf",
    pageCount: 2,
    textLayer: "available",
    requiresOcr: false,
    encoding: null,
    identityVerified: true
  }
] as const satisfies readonly LegalSourceArtifact[];
