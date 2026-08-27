-- 08/L-142: deterministic chunk batch; 7 rows.
BEGIN;

-- A missing or duplicate source is visible before the write and must stop manual execution.
SELECT id, law_number, version_label, language
FROM public.legal_sources
WHERE law_number = '08/L-142'
    and version_label = 'gazette-18-2024'
    and language = 'sq';

-- The delete is deliberately scoped to this single P0 natural key.
DELETE FROM public.legal_chunks
WHERE legal_source_id IN (
  SELECT id FROM public.legal_sources
  WHERE law_number = '08/L-142'
    and version_label = 'gazette-18-2024'
    and language = 'sq'
);

INSERT INTO public.legal_chunks (
  legal_source_id, chunk_index, article_number, article_title,
  paragraph_number, point_label, content, content_hash, token_count, metadata
)
SELECT source.id, rows.chunk_index, rows.article_number, rows.article_title,
  rows.paragraph_number, null, rows.content, rows.content_hash,
  rows.token_count, rows.metadata
FROM (VALUES
  (0, '1', 'Qëllimi', null, 'Ligji 08/L-142
Neni 1 - Qëllimi

Ky ligj ka për qëllim të ndryshojë dhe plotësojë ligjet e përcaktuara në dispozitat e mëtejme të këtij
ligji, të cilat ndërlidhin shumën e beneficioneve apo kompensimeve me pagën minimale, të ndryshojë
shkallët tatimore në të ardhurat personale vjetore, si dhe të ndryshojë procedurën e vendosjes së
pagës minimale.', 'f76eee823e10d92f3976395bb65ad19368931598a0ddfc135881606a63dd823f', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":1,"pageEnd":1,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1, '2', 'Ndryshimi dhe plotësimi i Ligjit Nr. 04/L-261 për Veteranët e Luftës së Ushtrisë Çlirimtare të Kosovës, i ndryshuar dhe plotësuar me Ligjin Nr. 05/L-141', null, 'Ligji 08/L-142
Neni 2 - Ndryshimi dhe plotësimi i Ligjit Nr. 04/L-261 për Veteranët e Luftës së Ushtrisë Çlirimtare të Kosovës, i ndryshuar dhe plotësuar me Ligjin Nr. 05/L-141

Neni 16A, paragrafi 3 nën paragrafi 3.1 i Ligjit Nr. 04/L-261 për Veteranët e Luftës së Ushtrisë
Çlirimtare të Kosovës, i ndryshuar dhe plotësuar me Ligjin Nr. 05/L-141, ndryshohet me tekstin si në
vijim:
3.1. Deri në kategorizimin përfundimtar të listës së Veteranit Luftëtar të UÇK-së, Qeveria e
Republikës së Kosovës, me propozimin e Ministrisë përgjegjëse për financa, vendosë për
lartësinë e shumës së pensioneve të përcaktuara me këtë ligj, varësisht nga mundësitë
buxhetore, kostoja e jetesës dhe inflacioni eventual.', '3729a27c9b02e9d4adede54c7ed24bb9a5f73ac7cd86d905a1e74401c9257d15', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":1,"pageEnd":1,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[{"baseLawNumber":"04/L-261","baseArticleNumber":"16A","relationTypeCandidate":"amend","reviewStatus":"candidate_for_manual_review"}]}'::jsonb),
  (2, '3', 'Ndryshimi dhe plotësimi i Ligjit Nr. 04/L – 092 për Personat e Verbër', null, 'Ligji 08/L-142
Neni 3 - Ndryshimi dhe plotësimi i Ligjit Nr. 04/L – 092 për Personat e Verbër

Neni 7, paragrafi 2 i Ligjit Nr. 04/L – 092 për Personat e Verbër, ndryshohet me tekstin si në si në
vijim:
2. Qeveria e Republikës së Kosovës, me propozimin e Ministrisë përgjegjëse për financa,
vendosë për lartësinë e shumës së kompensimeve për personat e verbër të përcaktuar me
këtë ligj, varësisht nga mundësitë buxhetore, kostoja e jetesës dhe inflacioni eventual.', 'b9abaaf713a0b5aebb3bd1eda7babd303c02da671569d7b4ef939209300af23d', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":1,"pageEnd":1,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[{"baseLawNumber":"04/L-092","baseArticleNumber":"7","relationTypeCandidate":"amend","reviewStatus":"candidate_for_manual_review"}]}'::jsonb),
  (3, '4', 'Ndryshimi dhe plotësimi i Ligjit Nr. 05/L -067 për Statusin dhe të Drejtat e Personave Paraplegjik dhe Tetraplegjik', null, 'Ligji 08/L-142
Neni 4 - Ndryshimi dhe plotësimi i Ligjit Nr. 05/L -067 për Statusin dhe të Drejtat e Personave Paraplegjik dhe Tetraplegjik

Neni 7, paragrafi 1 i Ligjit Nr. 05/L -067 për Statusin dhe të Drejtat e Personave Paraplegjik dhe
Tetraplegjik, ndryshohet me tekstin si në vijim:
1. Qeveria e Republikës së Kosovës, me propozimin e Ministrisë përgjegjëse për Financa,
vendosë për lartësinë e shumës së kompensimeve për përfituesit e këtij ligji, varësisht nga
mundësitë buxhetore, kostoja e jetesës dhe inflacioni eventual.', 'e0dae002eb9d060a54baed30cf3eca18b55cbf78f3f2497f5e6f4e9791165c7a', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[{"baseLawNumber":"05/L-067","baseArticleNumber":"7","relationTypeCandidate":"amend","reviewStatus":"candidate_for_manual_review"}]}'::jsonb),
  (4, '5', 'Ndryshimi dhe plotësimi i Ligjit Nr. 05/L -028 për Tatimin në të Ardhurat Personale', null, 'Ligji 08/L-142
Neni 5 - Ndryshimi dhe plotësimi i Ligjit Nr. 05/L -028 për Tatimin në të Ardhurat Personale

Neni 6 i Ligjit Nr. 05/L -028 për Tatimin në të Ardhurat Personale, ndryshohet si në vijim:
Neni 6
Shkallët e tatimit
1. Tatimi në të ardhura personale vjetore, ngarkohet sipas shkallëve në vijim:
1.1. Për të ardhurat e tatueshme deri në tremijë euro (3.000 €), duke përfshirë edhe
shumën tremijë euro (3.000 €), zero për qind (0%);
1.2. Për të ardhurat e tatueshme mbi tremijë euro (3.000 €), deri në pesëmijë e
katërqind (5.400 €), duke përfshirë edhe shumën pesëmijë e katërqind (5,400 €), tetë
për qind (8%) të shumës mbi tremijë euro (3.000 €); dhe
1.3. Për të ardhurat e tatueshme mbi pesëmijë e katërqind (5,400 €), njëqind
nëntëdhjetë e dy euro (192 €) plus dhjetë për qind (10%) të shumës mbi pesëmijë e
katërqind (5,400 €).', '3a771f904753037602518fe15ee5e62408b8a6a0d2760f0547610fe17f749827', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[{"baseLawNumber":"05/L-028","baseArticleNumber":"6","relationTypeCandidate":"amend","reviewStatus":"candidate_for_manual_review"}]}'::jsonb),
  (5, '6', 'Ndryshimi dhe plotësimi i Ligjit Nr. 03/L-212 të Punës', null, 'Ligji 08/L-142
Neni 6 - Ndryshimi dhe plotësimi i Ligjit Nr. 03/L-212 të Punës

Neni 57, paragrafi 1, i Ligjit Nr. 03/L-212 të Punës, ndryshohet si në vijim:
Neni 57
Paga Minimale
1. Qeveria e Republikës së Kosovës në fund të çdo viti kalanderik përcakton pagën minimale
sipas propozimit të Këshilli Ekonomiko-Social. Në mungesë të një propozimi të tillë nga
Këshilli Ekonomiko Social, Ministri përkatës për Financa, pas informimit të Këshillit
Ekonomiko Social, mund të parashtrojë një propozim të tillë për Qeverinë e Republikës së
Kosovës.', '0f9e9db6a7d3b35a57e3bdcb384cf9aada2208b27ba1ec4759e694d53897244e', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[{"baseLawNumber":"03/L-212","baseArticleNumber":"57","relationTypeCandidate":"amend","reviewStatus":"candidate_for_manual_review"}]}'::jsonb),
  (6, '7', 'Hyrja në fuqi', null, 'Ligji 08/L-142
Neni 7 - Hyrja në fuqi

Ky ligj hyn në fuqi në ditën e publikimit në Gazetën Zyrtare të Republikës së Kosovës.
Ligji Nr. 08/L-142
13 korrik 2023
Ligji shpallet në Gazetën Zyrtare të Republikës së Kosovës, duke u bazuar në nenin 80
paragrafi 5 të Kushtetutës së Republikës së Kosovës.', '7c00dcaba53ecc392929c09d50e227ecaa3e73687281eebf29bafaa07107f0e1', null::integer, '{"lawNumber":"08/L-142","versionLabel":"gazette-18-2024","documentType":"amendment","jurisdiction":"XK","applicability":["employment"],"applicabilityMode":"amendment_scope","paragraphStart":null,"paragraphEnd":null,"pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"1a26b445bbb82831c7dcb5e0dbc54b4a96aa0be1d28e32269f7e2dee8492c74b","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
) AS rows (
  chunk_index, article_number, article_title, paragraph_number, content,
  content_hash, token_count, metadata
)
CROSS JOIN (
  SELECT id FROM public.legal_sources
  WHERE law_number = '08/L-142'
    and version_label = 'gazette-18-2024'
    and language = 'sq'
) AS source
ON CONFLICT (legal_source_id, chunk_index) DO UPDATE SET
  article_number = excluded.article_number,
  article_title = excluded.article_title,
  paragraph_number = excluded.paragraph_number,
  point_label = excluded.point_label,
  content = excluded.content,
  content_hash = excluded.content_hash,
  token_count = excluded.token_count,
  metadata = excluded.metadata;

COMMIT;
