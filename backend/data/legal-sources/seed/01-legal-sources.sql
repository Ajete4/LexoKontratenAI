-- Deterministic P0 legal-source seed. Run only after 00-preflight.sql succeeds.
BEGIN;

INSERT INTO public.legal_sources (
  title, law_number, official_url, official_document_url, publication_date,
  version_label, retrieved_at, sha256, language, status, document_type,
  issuing_institution, official_gazette_number, jurisdiction, legal_status,
  is_consolidated, verified_source, verified_at, applicability,
  applicability_mode, ingestion_status
)
VALUES
  ('LIGJI NR. 03/L-212 I PUNËS', '03/L-212', 'https://gzk.rks-gov.net/ActDetail.aspx?ActID=2735', 'https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2735', '2010-12-01', 'gazette-90-2010', '2026-08-11T10:45:31.335Z', '98aaf8e8e06df611f1277a5305928e7d6a28bafe8322ab7fcdfd219a3a981da5', 'sq', 'verified', 'law', 'Kuvendi i Republikës së Kosovës', '90/2010', 'XK', 'requires_manual_legal_verification', false, true, '2026-08-11T00:00:00.000Z', array['employment']::text[], 'direct', 'ingested'),
  ('LIGJI NR. 04/L-077 PËR MARRËDHËNIET E DETYRIMEVE', '04/L-077', 'https://gzk.rks-gov.net/ActDetail.aspx?ActID=2828', 'https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=2828', '2012-06-19', 'gazette-16-2012', '2026-08-11T10:45:34.457Z', '97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4', 'sq', 'verified', 'law', 'Kuvendi i Republikës së Kosovës', '16/2012', 'XK', 'requires_manual_legal_verification', false, true, '2026-08-11T00:00:00.000Z', array['service', 'lease']::text[], 'direct', 'ingested'),
  ('LIGJI NR. 08/L-142 PËR NDRYSHIMIN DHE PLOTËSIMIN E LIGJEVE QË PËRCAKTOJNË SHUMËN E BENEFICIONIT NË LARTËSI TË PAGËS MINIMALE, PROCEDURAT E CAKTIMIT TË PAGËS MINIMALE DHE SHKALLËT TATIMORE NË TË ARDHURAT PERSONALE VJETORE', '08/L-142', 'https://gzk.rks-gov.net/ActDetail.aspx?ActID=96360', 'https://gzk.rks-gov.net/ActDocumentDetail.aspx?ActID=96360', '2024-08-23', 'gazette-18-2024', '2026-08-11T10:45:34.616Z', '1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b', 'sq', 'verified', 'amendment', 'Kuvendi i Republikës së Kosovës', '18/2024', 'XK', 'requires_manual_legal_verification', false, true, '2026-08-11T00:00:00.000Z', array['employment']::text[], 'amendment_scope', 'ingested')
ON CONFLICT (law_number, version_label, language) DO UPDATE SET
  title = excluded.title,
  official_url = excluded.official_url,
  official_document_url = excluded.official_document_url,
  publication_date = excluded.publication_date,
  retrieved_at = excluded.retrieved_at,
  sha256 = excluded.sha256,
  status = excluded.status,
  document_type = excluded.document_type,
  issuing_institution = excluded.issuing_institution,
  official_gazette_number = excluded.official_gazette_number,
  jurisdiction = excluded.jurisdiction,
  legal_status = excluded.legal_status,
  is_consolidated = excluded.is_consolidated,
  verified_source = excluded.verified_source,
  verified_at = excluded.verified_at,
  applicability = excluded.applicability,
  applicability_mode = excluded.applicability_mode,
  ingestion_status = excluded.ingestion_status,
  updated_at = now();

COMMIT;
