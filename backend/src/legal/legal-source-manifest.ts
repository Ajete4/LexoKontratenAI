export type LegalContractType = "employment" | "service" | "lease";

export type LegalDocumentType = "law" | "amendment";

export type LegalApplicabilityMode = "direct" | "amendment";

export type LegalSourceStatus = "requires_manual_legal_verification";

export type LegalTextLayerStatus =
  | "available"
  | "not_available"
  | "not_verified";

export interface LegalSourceManifestEntry {
  readonly lawNumber: string;
  readonly title: string;
  readonly documentType: LegalDocumentType;
  readonly issuingInstitution: string;
  readonly publicationDate: string;
  readonly officialGazetteNumber: string;
  readonly officialUrl: string;
  readonly officialDocumentUrl: string;
  readonly language: "sq";
  readonly jurisdiction: "XK";
  readonly legalStatus: LegalSourceStatus;
  readonly versionLabel: string | null;
  readonly isConsolidated: boolean;
  readonly applicability: readonly LegalContractType[];
  readonly applicabilityMode: LegalApplicabilityMode;
  readonly verifiedSource: true;
  readonly verifiedAt: string;
  readonly textLayer: LegalTextLayerStatus;
  readonly requiresOcr: boolean | null;
  readonly baseLawNumber: string | null;
  readonly notes: string;
}

export const LEGAL_SOURCE_MANIFEST = [
  {
    lawNumber: "03/L-212",
    title: "LIGJI NR. 03/L-212 I PUNËS",
    documentType: "law",
    issuingInstitution: "Kuvendi i Republikës së Kosovës",
    publicationDate: "2010-12-01",
    officialGazetteNumber: "90/2010",
    officialUrl: "https://gzk.rks-gov.net/ActDetail.aspx?ActID=2735",
    officialDocumentUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2735",
    language: "sq",
    jurisdiction: "XK",
    legalStatus: "requires_manual_legal_verification",
    versionLabel: "gazette-90-2010",
    isConsolidated: false,
    applicability: ["employment"],
    applicabilityMode: "direct",
    verifiedSource: true,
    verifiedAt: "2026-08-11",
    textLayer: "available",
    requiresOcr: false,
    baseLawNumber: null,
    notes:
      "Ligj bazë për employment. Faqja zyrtare e lidh me ligjet ndryshuese 08/L-142 dhe 08/L-283; ky manifest P0 përfshin vetëm 08/L-142."
  },
  {
    lawNumber: "04/L-077",
    title: "LIGJI NR. 04/L-077 PËR MARRËDHËNIET E DETYRIMEVE",
    documentType: "law",
    issuingInstitution: "Kuvendi i Republikës së Kosovës",
    publicationDate: "2012-06-19",
    officialGazetteNumber: "16/2012",
    officialUrl: "https://gzk.rks-gov.net/ActDetail.aspx?ActID=2828",
    officialDocumentUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2828",
    language: "sq",
    jurisdiction: "XK",
    legalStatus: "requires_manual_legal_verification",
    versionLabel: "gazette-16-2012",
    isConsolidated: false,
    applicability: ["service", "lease"],
    applicabilityMode: "direct",
    verifiedSource: true,
    verifiedAt: "2026-08-11",
    textLayer: "available",
    requiresOcr: false,
    baseLawNumber: null,
    notes:
      "Ligj bazë P0 për marrëdhëniet e detyrimeve në kontratat service dhe lease të MVP-së."
  },
  {
    lawNumber: "08/L-142",
    title:
      "LIGJI NR. 08/L-142 PËR NDRYSHIMIN DHE PLOTËSIMIN E LIGJEVE QË PËRCAKTOJNË SHUMËN E BENEFICIONIT NË LARTËSI TË PAGËS MINIMALE, PROCEDURAT E CAKTIMIT TË PAGËS MINIMALE DHE SHKALLËT TATIMORE NË TË ARDHURAT PERSONALE VJETORE",
    documentType: "amendment",
    issuingInstitution: "Kuvendi i Republikës së Kosovës",
    publicationDate: "2024-08-23",
    officialGazetteNumber: "18/2024",
    officialUrl: "https://gzk.rks-gov.net/ActDetail.aspx?ActID=96360",
    officialDocumentUrl:
      "https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=96360",
    language: "sq",
    jurisdiction: "XK",
    legalStatus: "requires_manual_legal_verification",
    versionLabel: "gazette-18-2024",
    isConsolidated: false,
    applicability: ["employment"],
    applicabilityMode: "amendment",
    verifiedSource: true,
    verifiedAt: "2026-08-11",
    textLayer: "available",
    requiresOcr: false,
    baseLawNumber: "03/L-212",
    notes:
      "Faqja zyrtare konfirmon se ndryshon/plotëson 03/L-212 dhe katër ligje të tjera. PDF-ja zyrtare ka text layer; mapping-u i neneve nuk përfshihet në këtë fazë teknike."
  }
] as const satisfies readonly LegalSourceManifestEntry[];
