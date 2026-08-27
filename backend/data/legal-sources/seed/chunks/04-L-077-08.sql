-- 04/L-077: deterministic chunk batch; 9 rows.
BEGIN;

-- A missing or duplicate source is visible before the write and must stop manual execution.
SELECT id, law_number, version_label, language
FROM public.legal_sources
WHERE law_number = '04/L-077'
    and version_label = 'gazette-16-2012'
    and language = 'sq';

INSERT INTO public.legal_chunks (
  legal_source_id, chunk_index, article_number, article_title,
  paragraph_number, point_label, content, content_hash, token_count, metadata
)
SELECT source.id, rows.chunk_index, rows.article_number, rows.article_title,
  rows.paragraph_number, null, rows.content, rows.content_hash,
  rows.token_count, rows.metadata
FROM (VALUES
  (1050, '1051', 'Zbatimi i dispozitës për kontratat e dyanshme', '1-2', 'Ligji 04/L-077
Neni 1051 - Zbatimi i dispozitës për kontratat e dyanshme

1. Për kontratën për ujdinë vlejnë dispozitat e përgjithshme mbi kontratat e dyanshme, në qoftë se për
atë nuk është paraparë diçka ndryshe.
2. Në rastet kur në emër të ujdisë kontraktuesit kryejnë ndonjë punë tjetër, në ato marrëdhënie të tyre
nuk zbatohen dispozitat e ligjit të cilat vlejnë për ujdinë, por ato të cilat vlejnë për punën e kryer.', '3f512f9031a0e6d4ecbeaefca18980dfbe51215494a32aed37a3b3e70e4a7ad1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":230,"pageEnd":230,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1051, '1052', 'Dëmtimi i pamasë', null, 'Ligji 04/L-077
Neni 1052 - Dëmtimi i pamasë

Për shkak të dëmtimit të pamasë nuk mund të kërkohet anulimi i ujdisë.', '3ec25869957c712aaae0d1e22feb9a3ee9b7bc05e1cb5c8392cfc3a48a98a2b5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":230,"pageEnd":230,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1052, '1053', 'Efekti i ujdisë ndaj dorëzanit dhe pengdhënësit', '1-3', 'Ligji 04/L-077
Neni 1053 - Efekti i ujdisë ndaj dorëzanit dhe pengdhënësit

1. Në qoftë se me ujdi është bërë përtërirja e detyrimit, dorëzani lirohet nga përgjegjësia për
përmbushjen e tij dhe njëherit shuhet edhe pengu të cilën e ka dhënë ndonjë person i tretë.
2. Dorëzani dhe i treti që kanë dhënë sendin e tyre në peng mbeten edhe më tutje në detyrim, ndërkaq
përgjegjësia e tyre mund të zvogëlohet me anë të pajtimit, por jo edhe të rritet, përjashtimisht nëse ata
janë dakorduar me pajtimin.
3. Kur debitori me anë të ujdisë pranon kërkesën e kontestueshme, dorëzani dhe pengdhënësi
rezervojnë të drejtën që kreditorit t’i paraqesin kundërshtimet nga të cilat debitori me anë të ujdisë ka
hequr dorë.', '86860edc3d2befc15996cd67801daf5cb09e63be6589a4c8ae590ad2b6049ef5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":231,"pageEnd":231,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1053, '1054', 'Ujdia për punën e cila mund të kundërshtohet', '1-2', 'Ligji 04/L-077
Neni 1054 - Ujdia për punën e cila mund të kundërshtohet

1. E vlefshme është ujdia për punën juridike, kundërshtimin e së cilës njëra palë mund ta kërkojë, nëse
pala në çastin e ujdisë ishte në dijeni për mundësinë e kundërshtimit.
2. Megjithatë, është e pavlefshme pajtimi për punën juridikisht të pavlefshme kur kontraktuesit kanë
ditur për pavlefshmërinë, por kanë dashur që këtë ta shmangin me ujdi.', '8cc6c86ac4073389f248b0053b77d59f641e9624b2c3ac2965663dd63214cadf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":231,"pageEnd":231,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1054, '1055', 'Pavlefshmëria e ujdisë', '1-3', 'Ligji 04/L-077
Neni 1055 - Pavlefshmëria e ujdisë

1. Ujdia është e pavlefshme, në qoftë se është bazuar në lajthitje të të dy kontraktuesve dhe në qoftë
se përmban marrëdhënie juridike e cila në të vërtetë nuk ekziston, si dhe në qoftë se pa lajthitjen e tyre
nuk do të kishte asnjë kontest dhe pasiguri midis tyre.
2. E njëjta gjë vlen edhe kur lajthitja e kontraktuesve ka të bëjë me fakte të zakonshme.
3. Heqja dorë nga ky nulitet nuk ka efekt juridik dhe se ajo që është dhënë në emër të ekzekutimit të
detyrimeve nga ajo marrëveshje mund të kërkohet që të kthehet.', 'bf2892e56c9f2d1d26a768da44bda3031110251e71c7a02922dec99e7b400990', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":231,"pageEnd":231,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1055, '1056', 'Nuliteti i një dispozite të ujdisë', null, 'Ligji 04/L-077
Neni 1056 - Nuliteti i një dispozite të ujdisë

Dispozitat e ujdisë interpretohen si tërësi prandaj nëse një dispozitë e vetme është e pavlefshme,
atëherë e tërë ujdia është e pavlefshme, përveç nëse nga vetë ujdia shihet qartë se ajo përbëhet nga
pjesë të pavarura.', '832ce7c9e3b3f2cfb848776599eb7418517032cff21bc49af0040f12e6b477b1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":231,"pageEnd":231,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1056, '1057', 'Zbatimi i këtij ligji', null, 'Ligji 04/L-077
Neni 1057 - Zbatimi i këtij ligji

Dispozitat e këtij ligji nuk zbatohen në marrëdhëniet e detyrimeve që kanë lindur para hyrjes në fuqi të
këtij ligji.', 'c0fc0bf7a5df93610a9307783d3c34d03bba84ebe145d77b9760aeb8002f7a11', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":231,"pageEnd":231,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1057, '1058', 'Ndërprerja e vlefshmërisë dhe zbatimi i ligjeve tjera', '1-4', 'Ligji 04/L-077
Neni 1058 - Ndërprerja e vlefshmërisë dhe zbatimi i ligjeve tjera

1. Në ditën e hyrjes në fuqi të këtij Ligji dispozitat e Rregullores së UNMIK-ut nr. 2000/68, për kontratat
mbi shitjen e mallrave pushojnë se ekzistuari.
2. Në kuptim të këtij ligji, e në pajtim me nenin 145 të Kushtetutës së Republikës së Kosovës, ligj i
aplikueshëm për kontratat për shitjen ndërkombëtare të mallrave është Konventa e Kombeve të
Bashkuara për kontratat për shitjen ndërkombëtare të mallrave
3. Në ditën e hyrjes në fuqi të këtij Ligji dispozitat e Ligjit mbi marrëdhëniet e detyrimeve (Gazeta
Zyrtare e RSFJ-së, nr. 29/78, 39/85, 57/89), pushojnë se ekzistuari, me përjashtim të dispozitave në
vijim: Kreu XXXI, nenet 1035 deri 1046; Kreu XXXII, nenet 1047 deri 1051; Kreu XXXIII, nenet 1052
deri 1060; Kreu XXXIV, nenet 1061 deri 1064; Kreu XXXV nenet 1065 deri 1068; Kreu XXXVI nenet
1069 deri 1071; Kreu XXXVII, nenet 1072 deri 1082; Kreu XXXVIII, nenet 1083 deri 1087; Kreu XXXIX,
neni 1088, të cilat përshtatshmërisht do të vazhdojnë të aplikohen përderisa legjislacioni nacional nuk
fuqizon ligje, gjegjësisht akte tjera nënligjore për rregullimin e të njëjtave.
4. Me hyrjen në fuqi të këtij ligji, pushojnë së vepruari edhe dispozitat e ligjeve të mëparshme që kanë
rregulluar këtë materie, përveç në rastet kur me këtë ligj është paraparë ndryshe.', '2ed36604c16a453fb7cefb08cef1751dc2ab70e33ce53227e06a68dae476e12a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":232,"pageEnd":232,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1058, '1059', 'Hyrja në fuqi', null, 'Ligji 04/L-077
Neni 1059 - Hyrja në fuqi

Ky ligj hyn në fuqi gjashtë (6) muaj pas publikimit në Gazetën Zyrtare të Republikës së Kosovës.
Ligji Nr. 04/ L-077
10 maj 2012
Shpallur me dekretin Nr.DL-024-2012, datë 30.05.2012 nga Presidentja e Republikës së Kosovës
Atifete Jahjaga.', 'ee83469400d0aa6d90df80dfa69508a7ba1d3c7f284ac2c1a61c83b98158eda7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":232,"pageEnd":232,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
) AS rows (
  chunk_index, article_number, article_title, paragraph_number, content,
  content_hash, token_count, metadata
)
CROSS JOIN (
  SELECT id FROM public.legal_sources
  WHERE law_number = '04/L-077'
    and version_label = 'gazette-16-2012'
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
