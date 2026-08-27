-- 04/L-077: deterministic chunk batch; 150 rows.
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
  (300, '301', 'Vendi i përmbushjes së detyrimeve në para', '1-3', 'Ligji 04/L-077
Neni 301 - Vendi i përmbushjes së detyrimeve në para

1. Detyrimet në para përmbushen në vendin ku kreditori e ka selinë, respektivisht vendbanimin, e në
mungesë të vendbanimit aty ku e ka vendqëndrimin.
2. Në qoftë se pagimi bëhet me urdhër (virman), detyrimet në para përmbushën në selinë e institucionit
financiar pranë së cilës mbahen paratë e kreditorit.
3. Në qoftë se kreditori e ka ndërruar vendin ku e ka pasur selinë, respektivisht vendbanimin e vet në
kohën e krijimit të detyrimit, kështu që për këtë arsye janë rritur shpenzimet e përmbushjes, kjo rritje bie
në ngarkim të kreditorit.', '864d12fa6a0174ca887fe044d0ca40982715e4825d1b19ff7430e61e5c303d3e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":65,"pageEnd":65,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (301, '302', 'Prezumimet lidhur me dëftesën', '1-4', 'Ligji 04/L-077
Neni 302 - Prezumimet lidhur me dëftesën

1. Kush e përmbush detyrimin në tërësi ose pjesërisht, ka të drejtë të kërkojë që kreditori për këtë gjë t’i
lëshojë dëftesën me shpenzimet e veta.
2. Debitori i cili e ka paguar detyrimin në para përmes bankës ose postës, mund të kërkojë që kreditori
t’i lëshojë dëftesën vetëm në qoftë se për këtë gjë ka shkak të arsyeshëm.
3. Në qoftë se është lëshuar dëftesa se është paguar kërkesa kryesore në tërësi, supozohet se janë
paguar edhe kamatat dhe shpenzimet gjyqësore të tjera nëse ka pasur të tilla.
4. Në qoftë se debitori me prestime periodike, siç janë qiratë dhe kërkesat e tjera që përllogariten
periodikisht, siç janë ato që krijohen me harxhimin e energjisë elektrike, ose të ujit, telefonit, ka
dëftesën se e ka paguar kërkesën e arritur më vonë për pagesë, supozohet se i ka paguar edhe ato që
kanë arritur më përpara për pagesë.', 'f5a81b7fc99ac4674f432607dd3867e41fea0002ba479f36e903699f81de3add', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":65,"pageEnd":65,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (302, '303', 'Refuzimi i lëshimit të dëftesës', null, 'Ligji 04/L-077
Neni 303 - Refuzimi i lëshimit të dëftesës

Në qoftë se kreditori refuzon të lëshojë dëftesën, debitori mund të depozitojë në gjykatë objektin e
detyrimit të vet.', '7c2958d58ea1848d275dd4249612751697d2c350cb943c22200843394c8eb055', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":65,"pageEnd":65,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (303, '304', 'Kthimi i fletëobligacionit', '1-4', 'Ligji 04/L-077
Neni 304 - Kthimi i fletëobligacionit

1. Kur e përmbush detyrimin e vet në tërësi, debitori mundet, përpos dëftesës, të kërkojë nga kreditori
që t’ia kthejë fletëobligacionin.
2. Kur kreditori nuk mund ta kthejë fletëobligacionin, debitori ka të drejtë të kërkojë që kreditori t’i
lëshojë një dokument publik të vërtetuar se detyrimi ka pushuar së ekzistuari.
3. Në qoftë se debitorit i është kthyer fletëobligacioni, supozohet se detyrimi është përmbushur
plotësisht.
4. Debitori që e ka përmbushur detyrimin vetëm pjesërisht, ka të drejtë të kërkojë që kjo përmbushje të
shënohet në fletëobligacion.', 'c1c34ae216746ab39d167c5a756f5471e9b71dbd6bf5355700a72e15c435bad9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":65,"pageEnd":66,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (304, '305', 'Kur debitori është në vonesë', '1-2', 'Ligji 04/L-077
Neni 305 - Kur debitori është në vonesë

1. Debitori është në vonesë kur nuk e përmbush detyrimin brenda afatit të caktuar për përmbushje.
2. Në qoftë se afati për përmbushje nuk është caktuar, debitori është në vonesë kur kreditori ta ftojë që
ta plotësojë detyrimin e vet, verbalisht ose me shkrim, paralajmërim jashtë gjyqësor, ose duke filluar
ndonjë procedurë, qëllimi i së cilës është realizimi i përmbushjes të detyrimit.', '8eb9bf3a68afd1cb92a1b4c5da69b3f0f3068f472776023455801c8a4f82d074', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":66,"pageEnd":66,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (305, '306', 'Kur kreditori është në vonesë', '1-3', 'Ligji 04/L-077
Neni 306 - Kur kreditori është në vonesë

1. Kreditori është në vonese në qoftë se pa ndonjë shkak të arsyeshëm refuzon të pranojë
përmbushjen, ose me sjelljet e veta e parandalon atë.
2. Kreditori është në vonesë edhe kur është i gatshëm të pranojë përmbushjen e detyrimit të
njëkohshëm të debitorit, por nuk ofron përmbushjen e detyrimit të vet të arritur për pagesë.
3. Kreditori nuk është në vonesë në qoftë se provon se në kohën e ofrimit të përmbushjes, ose në
kohën e caktuar për përmbushje, debitori ka qenë në pamundësi ta përmbushë detyrimin e vet.', '4fe08b49b26d0262a9d77ac701450e8b5005886744b04f7d8a8c7249e6b46873', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":66,"pageEnd":66,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (306, '307', 'Efektet e vonesës së kreditorit', '1-3', 'Ligji 04/L-077
Neni 307 - Efektet e vonesës së kreditorit

1. Me vonesën e kreditorit shuhet vonesa e debitorit dhe në kreditorin kalon rreziku i shkatërrimit ose te
dëmtimit te rastësishëm të sendit.
2. Që nga dita e vonesës së kreditorit pushon të rrjedhë kamata.
3. Kreditori në vonesë ka për detyrë t''i shpërblejë debitorit dëmin e krijuar për shkak të vonesës, për të
cilën përgjigjet, si dhe shpenzimet rreth ruajtjes së mëtejshme të sendeve.', '513bdbfbed6123616baf8417bbe4c37644a4b0d635a7a52a4bad0cbf5ebfeca1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":66,"pageEnd":66,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (307, '308', 'Depozitimi në gjykatë', '1-3', 'Ligji 04/L-077
Neni 308 - Depozitimi në gjykatë

1. Kur kreditori është në vonesë ose është i panjohur apo kur është e pasigurt se kush është kreditor
ose ku ndodhet ai, ose kur kreditori është i paaftë për të vepruar dhe nuk ka përfaqësues debitori mund
ta depozitojë sendin të cilin e ka borxh në gjykatë për kreditorin.
2. Të njëjtën të drejtë e kanë edhe personat e tretë të cilët kanë interes juridik që detyrimi të
përmbushet.
3. Për depozitimin e bërë debitori ka për detyrë ta njoftojë kreditorin po qe se di për te dhe për
vendbanimin e tij.', '4768f53d71a016080abd207e355998257c6056865e95022c3b2dce01f2fe70a7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":67,"pageEnd":67,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (308, '309', 'Gjykata kompetente për depozitim', '1-2', 'Ligji 04/L-077
Neni 309 - Gjykata kompetente për depozitim

1. Depozitimi bëhet në gjykatën e kompetencës lëndore në vendin e përmbushjes, përveç nëse për
shkaqet e leverdisë ekonomike ose nga vetë natyra e punës kërkohet që depozitimi të bëhet në vendin
ku ndodhet sendi.
2. Çdo gjykatë tjetër me kompetencë lëndore duhet ta pranojë sendin në depozitë, ndërsa debitori ka
për detyrë t’i japë shpërblim kreditorit në qoftë se ky ka pësuar dëm nga depozitimi në gjykatën tjetër.', 'e7904753bea27e4faddab931f150eb6bea747ac4c6679e3d6772952d3ad8bca4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":67,"pageEnd":67,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (309, '310', 'Dorëzimi për ruajtje personit tjetër', '1-3', 'Ligji 04/L-077
Neni 310 - Dorëzimi për ruajtje personit tjetër

1. Kur objekti i detyrimit është ndonjë send që nuk mund të ruhet në depozitin gjyqësor, debitori mund
të kërkojë nga gjykata që ta caktojë personin të cilit do t’ia dorëzojë sendin për ruajtje, me shpenzime
dhe për llogari të kreditorit.
2. Në rast të detyrimit nga kontrata në ekonomi, dorëzimi i sendit të tillë në depon publike për ruajtjen
për llogari të kreditorit e ka efektin e depozitimit në gjykatë.
3. Për dorëzimin e bërë për ruajtje debitori ka për detyrë ta njoftojë kreditorin.', '35668272ae851c8fcd8ab5168b9aa73898459ef48629fecca8018caa36afeeea', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":67,"pageEnd":67,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (310, '311', 'Rikthimi i sendit të depozituar', '1-3', 'Ligji 04/L-077
Neni 311 - Rikthimi i sendit të depozituar

1. Debitori mund ta rikthen sendin e depozituar.
2. Për rikthimin e sendit të depozituar ka për detyrë ta njoftojë kreditorin.
3. E drejta e debitorit për ta rikthyer sendin e depozituar shuhet kur debitori i deklaron gjykatës se heq
dorë nga kjo e drejtë, kur kreditori deklaron se e pranon sendin e depozituar, si dhe kur vërtetohet me
aktgjykim të plotfuqishëm se depozitimi i plotëson kushtet e përmbushjes së rregullt.', '6241711d8811ad49ee231fe8cda380d8772f862b147363bf5583256e1f577293', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":67,"pageEnd":67,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (311, '312', 'Efekti i depozitimit', '1-5', 'Ligji 04/L-077
Neni 312 - Efekti i depozitimit

1. Me depozitimin e sendit që është borxh, debitori lirohet nga detyrimi në çastin kur e ka bërë
depozitimin.
2. Në qoftë se debitori ka qenë në vonesë, vonesa e tij shuhet.
3. Që nga çasti kur sendi është depozituar, rreziku i shkatërrimit të rastësishëm ose i dëmtimit të sendit
kalon në kreditorin.
4. Që nga dita e depozitimit shuhet rrjedha e kamatës.
5. Në qoftë se debitori e merr sendin e depozituar, konsiderohet njësoj sikur të mos ta kishte depozituar
fare dhe bashkë debitorët dhe dorëzanët e tij mbeten në detyrim.', '1c364a4e77c563c061ab996a16955ef1ab2bc6c4110d0ab13385892d55182b03', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":67,"pageEnd":68,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (312, '313', 'Shpenzimet e depozitimit', null, 'Ligji 04/L-077
Neni 313 - Shpenzimet e depozitimit

Shpenzimet e depozitimit të plotfuqishëm e të parevokueshëm i përballon kreditori në qoftë se i kalojnë
shpenzimet e përmbushjes që ka për detyrë t''i paguaj debitori.', 'b3acadde288143cd974760b4b5463ef8a59ab575909857390c42fa37a2a80c9f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":68,"pageEnd":68,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (313, '314', 'Shitja në vend të depozitimit të sendit', '1-4', 'Ligji 04/L-077
Neni 314 - Shitja në vend të depozitimit të sendit

1. Në qoftë se sendi është i papërshtatshëm për ruajtje apo në qoftë se për ruajtjen ose për
mirëmbajtjen e tij nevojiten shpenzime të cilat nuk janë në përpjesëtim me vlerën e tij, debitori mund ta
shesë, në shitjen e bërë publike në vendin e caktuar për përmbushje apo në ndonjë vend tjetër në qoftë
se kjo është në interesin e kreditorit, kurse shumën e arritur, pasi të jenë zbritur shpenzimet e shitjes, ta
depozitojnë në gjykatën e atij vendi.
2. Në qoftë se sendi ka çmimin vijues, apo në qoftë se ka vlerë të vogël në krahasim me shpenzimet e
shitjes publike, debitori lirisht mund ta shesë.
3. Në qoftë se sendi është i tillë që mund të shkatërrohet apo të prishet, debitori ka për detyrë ta shesë
pa shtyrje në një mënyrë sa më të përshtatshme.
4. Në çdo rast, debitori ka për detyrë ta njoftojë kreditorin për shitjen që ka ndërmend ta bëjë kurdo që
të jetë e mundur, e pas shitjes së bërë ta njoftojë për çmimin e realizuar dhe për depozitimin e tij në
gjykatë.', '943b60685fd1527da0b1206faa3f555cf21e67f434c470e7ae0f197e56be0e76', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":68,"pageEnd":68,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (314, '315', 'Dorëzimi i sendit kreditorit', null, 'Ligji 04/L-077
Neni 315 - Dorëzimi i sendit kreditorit

Gjykata do t’ia dorëzojë kreditorit sendin e depozituar sipas kushteve që i ka caktuar debitori.', '918a5eb84a70d12fe9ad41198841b5cd5311701af05660ebab38cde738479a9f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":68,"pageEnd":68,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (315, '316', 'Shitja për të mbuluar shpenzimet e ruajtjes', '1-2', 'Ligji 04/L-077
Neni 316 - Shitja për të mbuluar shpenzimet e ruajtjes

1. Në qoftë se shpenzimet e ruajtjes nuk paguhen brenda afatit të arsyeshëm, gjykata do të urdhërojë
me kërkesën e ruajtësit, që sendi të shitet dhe do të caktojë mënyrën e shitjes.
2. Nga shuma e realizuar prej shitjes do të zbritën shpenzimet e shitjes dhe shpenzimet e ruajtjes,
ndërsa KREU që mbetet do të depozitohet në gjykatë për kreditorin.', '40c32a506122a943d38a8fef6d1408e37a7541be68b2a4d86ed68033d29e44fd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":68,"pageEnd":68,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (316, '317', 'Kushtet e përgjithshme', null, 'Ligji 04/L-077
Neni 317 - Kushtet e përgjithshme

Debitori mund ta kompensoj kërkesën që ka ndaj kreditorit me atë që kërkon ky prej tij në qoftë se të dy
kërkesat kanë si objekt të hollat, ose sendet e tjera të zëvendësueshme të të njëjtit lloj ose të njëjtës
cilësi dhe në qoftë se të dy kanë arritur për pagesë.', 'd9e74cc63ff3fe4eadd26d2afe6f91c5b5efd9b98d6680f8d8fb93766d693155', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":69,"pageEnd":69,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (317, '318', 'Deklarata për kompensimin', '1-2', 'Ligji 04/L-077
Neni 318 - Deklarata për kompensimin

1. Kompensimi nuk kryhet posa të janë formuar kushtet për këtë, por nevojitet që njëra palë t''i deklarojë
tjetrës se është duke bërë kompensimin.
2. Pas deklaratës mbi kompensimin konsiderohet se kompensimi është kryer që nga çasti kur janë
formuar kushtet për këtë.', '027fe19f7396cd887aa624eda1787356ef99ec05df6a00373d2e60f69c1b3e9c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":69,"pageEnd":69,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (318, '319', 'Mungesa e reciprocitetit', '1-3', 'Ligji 04/L-077
Neni 319 - Mungesa e reciprocitetit

1. Debitori nuk mund të bëjë kompensimin e asaj që debiton kreditorit me atë që kreditori i debiton
dorëzanit të tij.
2. Mirëpo, dorëzani mund të bëjë kompensimin e detyrimit të debitorit ndaj kreditorit me kërkesën e
debitorit nga kreditori.
3. Kush e ka dhënë sendin e vet peng për detyrimin e huaj, mund të kërkojë nga kreditori që t''ia kthejë
sendin e lënë peng kur të jenë plotësuar kushtet për pushimin e këtij detyrimi me anë të kompensimit, si
dhe kur kreditori lëshon me faj të vet mundësin që të bëjë kompensimin.', 'd66a119d8b5c9713426a55da7bcdc3e853cc7b93327f68d47fd1c00b0d3eb8b5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":69,"pageEnd":69,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (319, '320', 'Kërkesa e parashkruar', '1-2', 'Ligji 04/L-077
Neni 320 - Kërkesa e parashkruar

1. Një borxh mund të kompensohet me një kërkesë të parashkruar, vetëm nëse kjo kërkesë e
parashkruar nuk ka qenë e parashkruar në momentin kur kanë ekzistuar kushtet për kompensim.
2. Në qoftë se kushtet për kompensim janë krijuar pasi që një nga kërkesat është parashkruar,
kompensimi nuk krijohet në qoftë se debitori i kërkesës së parashkruar ka theksuar kundërshtimin për
parashkrim.', '09a97440486b1590f92c98998b97401570de936d438fe6bab31bca10ff39c302', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":69,"pageEnd":69,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (320, '321', 'Kompensimi me kërkesën e ceduar', '1-4', 'Ligji 04/L-077
Neni 321 - Kompensimi me kërkesën e ceduar

1. Debitori i kërkesës së ceduar mund t’ia kompensojë marrësit ato kërkesa të veta të cilat deri në
njoftimin mbi cedimin ka mundur t’ia kompensojë ceduesit.
2. Ai mund ti kompensojë edhe ato kërkesa të veta nga ceduesi që i ka fituar para njoftimit për cedimin,
afati i të cilave për cedim nuk ka skaduar në çastin kur është njoftuar për cedimin, por vetëm në qoftë
se ky afat bie para afatit për përmbushjen e kërkesës së ceduar ose në të njëjtën kohë.
3. Debitori që i ka deklaruar pa rezervë marrësit se e pranon cedimin, nuk mund t’i kompensojë me
kurrë farë kërkese të vet nga ceduesi.
4. Në qoftë se kërkesa e ceduar është shkruar në regjistrat publikë, debitori mund t’ia bëjë
kompensimin marrësit vetëm në qoftë se kërkesa e tij është e regjistruar me rastin e kërkesës së
ceduar apo në qoftë se marrësi është njoftuar me rastin e cedimit për ekzistimin e kësaj kërkese.', '13b8d8925f4495bfb99e7263b3187c6e2774bca92f3c92c78eefffe3796f7709', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":69,"pageEnd":70,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (321, '322', 'Rastet e përjashtimit të kompensimit', '1-1.5', 'Ligji 04/L-077
Neni 322 - Rastet e përjashtimit të kompensimit

1. Nuk mund të shuhen me kompensim:
1.1. kërkesat të cilat nuk mund të sekuestrohen;
1.2. kërkesat e sendeve, apo të vlerës së sendeve të cilat i janë dhënë debitorit për ruajtje, ose
për huapërdorje, apo të cilat debitori i ka marrë në mënyrë të kundërligjshme, ose i ka mbajtur
në mënyrë të kundërligjshme;
1.3. kërkesat e krijuara nga shkaktimi i dëmit me dashje;
1.4. kërkesat e shpërblimit të dëmit, të cilat kërkesa janë krijuar me dëmtimin e shëndetit apo
me shkaktimin e vdekjes;
1.5. kërkesat që rrjedhin nga detyrimi ligjor i ushqimit.', '5ebd0f51a5ab75efc7ebfa0484c4e656e065c3ca409d358835a37c26a85502be', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.5","pageStart":70,"pageEnd":70,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (322, '323', 'Ndalimi i kërkesës së palës tjetër', null, 'Ligji 04/L-077
Neni 323 - Ndalimi i kërkesës së palës tjetër

Debitori nuk mund të bëjë kompensimin në qoftë se kërkesa e tij ka arritur për pagesë vetëm pasi
dikush i treti ka vënë ndalesën në kërkesën e kreditorit ndaj tij.', '30b0e521a3f9c46b46a58d25a8ce2a1fe7fa3b6f00425084ba2b75049f7b77e5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":70,"pageEnd":70,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (323, '324', 'Llogaritja e kompensimit', null, 'Ligji 04/L-077
Neni 324 - Llogaritja e kompensimit

Kur midis dy personave ekzistojnë disa detyrime të cilat mund të shuhen me anë të kompensimit,
atëherë kompensimi bëhet sipas rregullave të cilat vlejnë për llogaritjen e përmbushjes.', '7664fbfeb1777cbf2f855e9da458b029863032e5f03ad1f687f32a91917ee1ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":70,"pageEnd":70,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (324, '325', 'Marrëveshja', '1-2', 'Ligji 04/L-077
Neni 325 - Marrëveshja

1. Detyrimi shuhet kur kreditori i deklaron debitorit se nuk do të kërkojë përmbushjen e tij dhe debitori të
jetë dakord me këtë.
2. Për vlefshmërinë e kësaj marrëveshje nuk nevojitet që ajo të lidhet në formën sikur është kontraktuar
puna nga e cila është krijuar detyrimi.', '30f436103885b528e54420db70e50772029ca0249cbb3e31d00ba5e29e5f9796', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":70,"pageEnd":70,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (325, '326', 'Heqja dorë nga mjetet e sigurimit', null, 'Ligji 04/L-077
Neni 326 - Heqja dorë nga mjetet e sigurimit

Kthimi i pengut dhe heqja dorë nga mjetet e tjera me të cilat është siguruar përmbushja e detyrimit, nuk
do të thotë se kreditori ka hequr dorë edhe nga e drejta për të kërkuar përmbushjen e detyrimit.', '13c52473da1798bc84f1f0f82df4863baafddae5ca0d75ccc943f71c3bbe58d6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":71,"pageEnd":71,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (326, '327', 'Falja e borxhit dorëzanit', '1-2', 'Ligji 04/L-077
Neni 327 - Falja e borxhit dorëzanit

1. Falja e borxhit dorëzanit nuk e liron debitorin kryesor, ndërsa falja e borxhit debitorit kryesor e liron
dorëzanin.
2. Kur ka disa dorëzanë dhe kreditori e liron nga detyrimi njërin prej tyre, të tjerëve u mbetet detyrimi,
por detyrimi i tyre zbritet për pjesën e dorëzanit të liruar.', '87fd85c9642bd22fc0a76e4e87f329f34b8f7fc80f7a7535ef32fa7f1db5d442', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":71,"pageEnd":71,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (327, '328', 'Falja e përgjithshme e borxheve', null, 'Ligji 04/L-077
Neni 328 - Falja e përgjithshme e borxheve

Me faljen e përgjithshme të borxheve shuhen të gjitha kërkesat e kreditorit ndaj debitorit, përveç atyre
për të cilat kreditori nuk ka ditur se ekzistojnë në çastin kur është bërë falja.', '7070c4b311d466a75e505896cab90211dd23dee109771a3345e8b2184cd2d728', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":71,"pageEnd":71,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (328, '329', 'Kushtet për përtrirjen e detyrimit', '1-3', 'Ligji 04/L-077
Neni 329 - Kushtet për përtrirjen e detyrimit

1. Detyrimi shuhet në qoftë se kreditori dhe debitori janë pajtuar që detyrimin ekzistues ta
zëvendësojnë me një tjetër dhe në qoftë se detyrimi tjetër ka objekt të ndryshëm ose bazë juridike të
ndryshme.
2. Marrëveshja e kreditorit dhe e debitorit me të cilën ndryshohet ose plotësohet dispozita mbi afatin,
mbi vendin ose mbi mënyrën e përmbushjes, pastaj marrëveshja e mëvonshme mbi kamatën, mbi
dënimin kontraktues, mbi sigurimin e përmbushjes, ose mbi ndonjë dispozitë tjetër akcesore, si dhe
marrëveshja mbi dhënien e dokumentit të ri mbi borxhin, nuk konsiderohen si novacion.
3. Dhënia e kambialit ose e çekut për shkak të ndonjë detyrimi të mëparshëm nuk konsiderohet si
novacion, përveç nëse kjo është kontraktuar ashtu.', 'b1b3dddd031bb98dba91dc74d426afb3891346742eae718f7b2494829fb68bb9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":71,"pageEnd":71,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (329, '330', 'Vullneti për të bërë novacion', null, 'Ligji 04/L-077
Neni 330 - Vullneti për të bërë novacion

Novacioni nuk ekziston, në qoftë se palët nuk e kanë deklaruar qëllimin që ta shuajnë detyrimin
ekzistues kur kanë krijuar detyrimin e ri; atëherë detyrimi i mëparshëm nuk shuhet, por ekziston edhe
më tutje krahas detyrimit të ri.', '2cb8a1d00326107d4a5e45f53b0fc2fdf2ed131344b2b6cd61073560059933e6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":71,"pageEnd":71,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (330, '331', 'Efekti i novacionit', '1-3', 'Ligji 04/L-077
Neni 331 - Efekti i novacionit

1. Me kontratën për novacionin detyrimi i mëparshëm shuhet, kurse detyrimi i ri krijohet.
2. Me detyrimin e mëparshëm shuhet edhe pengu dhe dorëzania, përveç nëse me dorëzaninë ose me
pengdhënësin është kontraktuar ndryshe.
3. E njëjta gjë vlen edhe për të drejtat e tjera akcesore, të cilat kanë qenë të lidhura me detyrimin e
mëparshëm.', 'f7d5b0b52291c4cae1b284d37e9fa4af1b10b78b5a53537f963e286e04cab729', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":71,"pageEnd":72,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (331, '332', 'Mungesa e detyrimit të mëparshëm', '1-2', 'Ligji 04/L-077
Neni 332 - Mungesa e detyrimit të mëparshëm

1. Novacioni është pa efekt në qoftë se detyrimi i mëparshëm ka qenë nul ose është shuar.
2. Në qoftë se detyrimi i mëparshëm ka qenë vetëm i rrëzueshëm, novacioni është i vlefshëm po qe se
debitori e ka ditur për të metën e detyrimit të mëparshëm.', '3ac5a02e59d78c6e0c311bcc1178743d43efd17c1ad30569340bca6e37fb416a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":72,"pageEnd":72,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (332, '333', 'Efekti i anulimit', null, 'Ligji 04/L-077
Neni 333 - Efekti i anulimit

Kur kontrata mbi novacionin është shpallur e pavlefshme, konsiderohet se nuk ka pasur novacion dhe
se detyrimi i mëparshëm as që ka pushuar së ekzistuari.', 'e9c5b72128e3c25e84b3dc043ace89bd8472dca7124330035d1766a9b4262647', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":72,"pageEnd":72,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (333, '334', 'Konfondimi', '1-3', 'Ligji 04/L-077
Neni 334 - Konfondimi

1. Detyrimi shuhet me konfondim, kur i njëjti person bëhet si debitor ashtu edhe kreditor.
2. Kur dorëzani bëhet kreditor, detyrimi i debitorit kryesor nuk shuhet.
3. Detyrimet e regjistruara në regjistrat publike shuhen me anë të konfondimit vetëm pasi të bëhet
regjistrimi i fshirjes.', '8031334b5c40673db1152551536664bc214a57a9f799bcfe58bdd3ce933e5a2f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":72,"pageEnd":72,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (334, '335', 'Shuarja e detyrimit për shkak të pamundësisë së përmbushjes', '1-2', 'Ligji 04/L-077
Neni 335 - Shuarja e detyrimit për shkak të pamundësisë së përmbushjes

1. Detyrimi shuhet kur përmbushja e tij bëhet e pamundur për shkak të rrethanave për të cilat debitori
nuk mban përgjegjësi.
2. Debitori duhet të provojë rrethanat që e përjashtojnë përgjegjësinë e tij.', '02e5b6e70f8ae1eaea4edf03c45312d1303677efa53bb39798654f546c231ada', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":72,"pageEnd":72,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (335, '336', 'Kur sendet e caktuara sipas llojit janë objekt i detyrimit', '1-2', 'Ligji 04/L-077
Neni 336 - Kur sendet e caktuara sipas llojit janë objekt i detyrimit

1. Në qoftë se objekt i detyrimit janë sendet e caktuara sipas llojit, detyrimi nuk shuhet as atëherë kur të
gjitha ato që ka debitori nga këto sende zhduken për shkak të rrethanave, për të cilat ai nuk mban
përgjegjësi.
2. Mirëpo, kur detyrimi ka si objekt sendet e caktuara sipas llojit që duhet të merren nga masa e
caktuar e atyre sendeve, atëherë detyrimi shuhet kur zhduket e gjithë ajo masë.', '79a83bee22b7789c9f4739a206238318a0580c9a3a4ec53c08e321dc79740b75', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":72,"pageEnd":72,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (336, '337', 'Cedimi i të drejtave ndaj të tretit përgjegjës për pamundësinë e përmbushjes', null, 'Ligji 04/L-077
Neni 337 - Cedimi i të drejtave ndaj të tretit përgjegjës për pamundësinë e përmbushjes

Debitori i sendit të caktuar që është shkarkuar nga detyrimi i vet për shkak të pamundësisë së
përmbushjes ka për detyrë t''i cedojë kreditorit të drejtën që do ta kishte ndaj personit të tretë për shkak
të pamundësisë së krijuar', '88e759c7673a460b4dc8b52353e59a40b284f720ba9f4592752b6e5e671f6d01', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":73,"pageEnd":73,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (337, '338', 'Afati në marrëdhëniet e vazhdueshme të detyrimeve', null, 'Ligji 04/L-077
Neni 338 - Afati në marrëdhëniet e vazhdueshme të detyrimeve

Marrëdhënia e detyrimeve e vazhdueshme me afat të caktuar të kohëzgjatjes shuhet kur të skadojë
afati, përveç kur është kontraktuar ose kur është caktuar me ligj që pas skadimit të afatit marrëdhënia e
detyrimeve të zgjatet për një kohë të pacaktuar, në qoftë se ajo marrëdhënie nuk denoncohet me kohë.', '7ed2cb365e88b6c6fd4a92736c03d7e18c91fd449ed96dca07c17b0a90bf1caf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":73,"pageEnd":73,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (338, '339', 'Denoncimi i marrëdhënies së vazhdueshme të detyrimit', '1-6', 'Ligji 04/L-077
Neni 339 - Denoncimi i marrëdhënies së vazhdueshme të detyrimit

1. Në qoftë se kohëzgjatja e marrëdhënies së detyrimeve nuk është caktuar, secila palë mund ta
ndërpret me denoncim.
2. Denoncimi duhet doemos t’i dorëzohet palës tjetër.
3. Denoncimi mund të jepet në çdo kohë, por jo në kohë të papërshtatshme.
4. Marrëdhënia e detyrimeve e denoncuar shuhet kur të ketë skaduar afati i denoncimit i caktuar në
kontratë, e në qoftë se afati i tillë nuk është caktuar me kontratë, atëherë marrëdhënia shuhet pasi të
ketë kaluar afati i caktuar me ligj ose me doke, përkatësisht me skadimin e afatit të arsyeshëm.
5. Palët mund të kontraktojnë se marrëdhënia e tyre e detyrimeve do të shuhet me vetë dorëzimin e
denoncimit, në qoftë se për rastin e caktuar ligji nuk urdhëron diçka tjetër.
6. Kreditori ka të drejtë të kërkojë nga debitori atë detyrim të arritur, para se detyrimi të jetë shuar me
kalimin e afatit ose me denoncim.', 'a1cb5dc39b835ced2376417e9c09ef29c5be5ab8c4b127f7bdd1f1ce79426d7d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":73,"pageEnd":73,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (339, '340', 'Vdekja', null, 'Ligji 04/L-077
Neni 340 - Vdekja

Me vdekjen e debitorit ose të kreditorit shuhet detyrimi vetëm në qoftë se është krijuar duke marrë
parasysh veçoritë personale të njërës nga palët kontraktuese ose aftësitë personale të debitorit.', '4436c6b0a3ba9a1cef3fdb77a43470812266bea51a21c87ef68c84f2bf5a32e7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":73,"pageEnd":73,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (340, '341', 'Rregullat e përgjithshme', '1-3', 'Ligji 04/L-077
Neni 341 - Rregullat e përgjithshme

1. Me parashkrim shuhet e drejta e kërkimit të përmbushjes së detyrimit.
2. Parashkrimi krijohet kur të ketë kaluar afati i caktuar me ligj, brenda të cilit kreditori ka mundur të
kërkojë përmbushjen e detyrimit.
3. Gjykata nuk mund të merr parasysh parashkrimin, në qoftë se debitori nuk thirret në atë.', '79ee7b578cedc79e38ac68c94a0fe9f924b825122f1e611d889f1aa238796217', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":74,"pageEnd":74,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (341, '342', 'Kur fillon të rrjedhë parashkrimi', '1-2', 'Ligji 04/L-077
Neni 342 - Kur fillon të rrjedhë parashkrimi

1. Parashkrimi fillon të rrjedhë ditën e parë pas ditës kur kreditori të ketë pasur të drejtë të kërkojë
përmbushjen e detyrimit, në qoftë se me ligj për raste të veçanta nuk është parashikuar diçka tjetër.
2. Në qoftë se detyrimi konsiston në atë që diçka të mos bëhet, të lihet pa u bërë ose të pësohet,
parashkrimi fillon të rrjedhë ditën e parë pas ditës kur debitori të ketë vepruar në kundërshtim me
detyrimin.', '4f51def098b0065792882c7ecf42d949560b30a0059b4b7375d07a4a1a5a8f9a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":74,"pageEnd":74,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (342, '343', 'Krijimi i parashkrimit', null, 'Ligji 04/L-077
Neni 343 - Krijimi i parashkrimit

Parashkrimi lind, kur të ketë skaduar dita e fundit e kohës së caktuar me ligj.', '5032f147574b02e432636b4ccb1b7506e523ada3f2ad3c7f6524ef0b733a540f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":74,"pageEnd":74,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (343, '344', 'Llogaritja e kohës së paraardhësve', null, 'Ligji 04/L-077
Neni 344 - Llogaritja e kohës së paraardhësve

Në kohën e parashkrimit llogaritet edhe koha që ka kaluar në dobi të paraardhësve të debitorit.', 'de647f8a26a5af0ec1f44db0f95958045c0f73bb238da17aa0f1d8d8dbcf994e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":74,"pageEnd":74,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (344, '345', 'Ndalimi i ndryshimit të afatit të parashkrimit', '1-2', 'Ligji 04/L-077
Neni 345 - Ndalimi i ndryshimit të afatit të parashkrimit

1. Me punë juridike nuk mund të caktohet një kohë më e gjatë ose më e shkurtër e parashkrimit se sa
koha e caktuar me ligj.
2. Me punë juridike nuk mund të caktohet që parashkrimi të mos rrjedhë për një kohë.', '2459063e1287880307cd28a225c645dc31bee4006df8b2472e778b61f5255120', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":74,"pageEnd":74,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (345, '346', 'Heqja dorë nga parashkrimi', null, 'Ligji 04/L-077
Neni 346 - Heqja dorë nga parashkrimi

Debitori nuk mund të heqë dorë nga parashkrimi para se të ketë kaluar koha e caktuar për parashkrim.', '4cef9cd42638569384468a0a222e2f4d3b27bc431331244815f3a54119737846', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":74,"pageEnd":74,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (346, '347', 'Njohja me shkrim dhe sigurimi i detyrimit të parashkruar', '1-2', 'Ligji 04/L-077
Neni 347 - Njohja me shkrim dhe sigurimi i detyrimit të parashkruar

1. Njohja me shkrim i detyrimit të parashkruar konsiderohet si heqje dorë nga parashkrimi.
2. Efekt të njëjtë ka dhënia e pengut ose e ndonjë sigurimi tjetër për kërkesën e parashkruar.', 'f216bb23c947987a4588c3c38ebf3f6c9fbc92f9866d748ff3ebe68738f5bbaa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":74,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (347, '348', 'Efekti i përmbushjes së detyrimit të parashkruar', null, 'Ligji 04/L-077
Neni 348 - Efekti i përmbushjes së detyrimit të parashkruar

Në qoftë se debitori e përmbush detyrimin e parashkruar, ai nuk ka të drejtë të kërkojë që t’i kthehet ajo
që ka dhënë edhe atëherë kur nuk e ka ditur, se detyrimi është parashkruar.', 'b37131c22df5e656b5dab6200320c14f02c31ee280b4fe2002ad4bcb3a350e0f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":75,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (348, '349', 'Kreditori, kërkesa e të cilit është e siguruar', '1-2', 'Ligji 04/L-077
Neni 349 - Kreditori, kërkesa e të cilit është e siguruar

1. Kur të ketë kaluar afati i parashkrimit, kreditori kërkesa e të cilit është e siguruar me peng ose me
hipotekë, mund të paguhet vetëm nga sendi i ngarkuar, në qoftë se e mban në dorë apo në qoftë se e
drejta e tij është regjistruar në regjistrat publikë.
2. Megjithatë, kërkesat e parashkruara të kamatës dhe të dhënieve tjera periodike nuk mund të
përmbushen as edhe nga sendi i ngarkuar.', '06a4af5a834557ce8448926cd235732bd2c080bb6096a0e5a581021d341370ca', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":75,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (349, '350', 'Kërkesat akcesore', null, 'Ligji 04/L-077
Neni 350 - Kërkesat akcesore

Kur parashkruhet kërkesa kryesore, atëherë parashkruhen edhe kërkesat akcesore, sikurse janë:
kërkesat e kamatës, frutave, shpenzimeve dhe dënimeve kontraktuese.', 'f9cca4dfbda65fd8e9c889c37eaa5cf75387d0a2c6a53384c413a896bc338d70', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":75,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (350, '351', 'Kur nuk zbatohen rregullat për parashkrimin', null, 'Ligji 04/L-077
Neni 351 - Kur nuk zbatohen rregullat për parashkrimin

Rregullat për parashkrimin nuk zbatohen në rastet kur me ligj janë caktuar afatet brenda të cilave duhet
të paraqitet padia ose të kryhet një veprim, nën kërcënim të humbjes së të drejtave.', '453382babd7d2104bf256c9045cef67e9dfa1ddf326deac334b86148affd6988', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":75,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (351, '352', 'Afati i përgjithshëm i parashkrimit', null, 'Ligji 04/L-077
Neni 352 - Afati i përgjithshëm i parashkrimit

Kërkesat parashkruhen për pesë (5) vjet, në qoftë se me ligj nuk është caktuar ndonjë afat tjetër i
parashkrimit.', 'a1ab161b465082332e7260942a46b4fa3b676896568ef536d6c8d439720d1637', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":75,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (352, '353', 'Kërkesat periodike', '1-3', 'Ligji 04/L-077
Neni 353 - Kërkesat periodike

1. Kërkesat e dhënieve periodike që rrjedhin vit për vit ose në afate të caktuara më të shkurtra
(kërkesat periodike), qofshin ato kërkesa periodike akcesore, siç janë kërkesat e kamatës, apo kërkesa
periodike të atilla në të cilat përfundon vetë e drejta, siç janë kërkesat e ushqimit, parashkruhen tri (3)
vjet nga arritja e secilës dhënie të veçantë për pagesë.
2. E njëjta gjë vlen për pensionet vjetore me të cilat paguhet shuma kryesore dhe kamata në shuma të
barabarta të përcaktuara më parë, por nuk vlen për pagesat në këste ose për përmbushje të tjera të
pjesshme.
3. Pavarësisht paragrafit të parë të këtij neni, kamata në kërkesat periudha e parashkrimit e të cilave
është më pak se tri (3) vjet, parashkruhen pas kalimit të periudhës së njëjtë si për kërkesën kryesore.', 'b066e6c8145ae8e3c0a07fcae721bdcf772d447d37a11e8f95a47ecd740b35ed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":75,"pageEnd":75,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (353, '354', 'Parashkrimi i vet të drejtës', '1-3', 'Ligji 04/L-077
Neni 354 - Parashkrimi i vet të drejtës

1. Vetë e drejta nga e cila rrjedhin kërkesat periodike parashkruhet për pesë (5) vite duke llogaritur nga
arritja për pagesë e kërkesës më të vjetër të pa përmbushur pas së cilës debitori nuk ka kryer dhënie.
2. Kur parashkruhet e drejta nga e cila rrjedhin kërkesat periodike, atëherë kreditori humb të drejtën jo
vetëm të kërkojë prestime të ardhshme periodike, por edhe prestime periodike të cilat kanë arritur për
pagesë para këtij parashkrimi.
3. Nuk mund të parashkruhet e drejta e ushqimit e caktuar me ligj.', '449c6adf5257366b2ae5959f0d5490c7e573871bcb2a4aa84eaea046f54758a9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":76,"pageEnd":76,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (354, '355', 'Kërkesat reciproke nga kontratat komerciale', '1-2', 'Ligji 04/L-077
Neni 355 - Kërkesat reciproke nga kontratat komerciale

1. Kërkesat reciproke nga kontratat komerciale si dhe kërkesat e shpërblimit të shpenzimeve të bëra
lidhur me këto kontrata, parashkruhen për tri (3) vite.
2. Parashkrimi rrjedh veç e veç për çdo dërgim të mallit, pune ose shërbimi të kryer.', 'e417bd3279145354d2117773b862527408e9245d75f9103c0dacf72144b6c608', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":76,"pageEnd":76,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (355, '356', 'Kërkesa e qirasë', null, 'Ligji 04/L-077
Neni 356 - Kërkesa e qirasë

Kërkesa e qirasë si për atë që është caktuar të paguhet periodikisht, ashtu edhe për atë që është
caktuar të paguhet në shuma totale, parashkruhet për tri (3) vite.', 'c30930f74dde5c646e6182e5a9730ca2000d2aa931b07e3ad0eafa23b9467095', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":76,"pageEnd":76,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (356, '357', 'Kërkesa e shpërblimit të dëmit', '1-4', 'Ligji 04/L-077
Neni 357 - Kërkesa e shpërblimit të dëmit

1. Kërkesa për shpërblimin e dëmit të shkaktuar parashkruhet për tri (3) vite nga data kur i dëmtuari ka
marrë dijeni për dëmin dhe për personin, i cili e ka shkaktuar dëmin.
2. Në çdo rast kjo kërkesë parashkruhet për pesë (5) vite nga shkaktimi i dëmit.
3. Kërkesa për shpërblimin e dëmit të shkaktuar me cenimin e detyrimit kontraktues parashkruhet për
kohën e caktuar për parashkrimin e atij detyrimi.
4. Kërkesat e kompensimit të dëmit të krijuar nga akti i abuzimit seksual me të mitur parashkruhen
pesëmbëdhjetë (15) vite pasi personi i mitur të ketë arritur moshën e pjekurisë.', '5fca7b3420eb89ca056dfaefa6b7b0bc52040d799308a3972797182ec6ec331c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":76,"pageEnd":76,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (357, '358', 'Kërkesa për shpërblimin e dëmit të shkaktuar me vepër penale', '1-3', 'Ligji 04/L-077
Neni 358 - Kërkesa për shpërblimin e dëmit të shkaktuar me vepër penale

1. Kur dëmi është shkaktuar me vepër penale dhe për ndjekjen penale është parashikuar një afat më i
gjatë parashkrimi, kërkesa për shpërblim të dëmit ndaj personit përgjegjës parashkruhet kur të skadojë
koha e caktuar për parashkrimin e ndjekjes penale.
2. Ndërprerja e parashkrimit të ndjekjes penale sjell edhe ndërprerjen e parashkrimit të kërkesës për
shpërblimin e dëmit.
3. E njëjta vlen edhe për ndaljen e parashkrimit.', 'fc78301223dbd3e17e5c94df85a7be8ba357707cb2a8f4eddcf04c12dee4870d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":76,"pageEnd":76,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (358, '359', 'Kompensimi i kërkesave për arsye të korrupsionit', null, 'Ligji 04/L-077
Neni 359 - Kompensimi i kërkesave për arsye të korrupsionit

Në rast se dëmi është shkaktuar nga akti në të cilin ofrimi, dhënia, pranimi ose kërkesa e “ryshfetit“ ose
ndonjë përfitimi tjetër ka pasur ndikim të drejtpërdrejtë ose jo të drejtpërdrejtë, ose nga mosveprimi apo
veprimi që do të kishte parandaluar aktin e korrupsionit, ose nga ndonjë akt tjetër që sipas ligjit ose
traktatit ndërkombëtar paraqet korrupsion, kërkesa parashkruhet pesë (5) vite pasi pala e dëmtuar të
ketë mësuar për dëmin dhe personin që e ka shkaktuar atë; në cilindo rast, ajo parashkruhet
pesëmbëdhjetë (15) vite pas kryerjes së aktit.', 'e95449efbaa06d376419b1c1431e10e1b23cfb9760ff12b3ce0e42ac61275b58', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":77,"pageEnd":77,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (359, '360', 'Afati njëvjeçar i parashkrimit', '1-3', 'Ligji 04/L-077
Neni 360 - Afati njëvjeçar i parashkrimit

1. Kërkesat të cilat parashkruhen pas një (1) viti:
1.1. kërkesat për furnizimin e energjisë elektrike, energjisë termike, gazit, ujit dhe shërbimet e
pastrimit të oxhaqeve dhe për mirëmbajtjen e shërbimit të pastërtisë, nëse furnizimi ose
shërbimi është kryer për nevojat shtëpiake;
1.2. kërkesat e radios dhe televizionit për përdorimin e stacionit;
1.3. kërkesat e postës dhe kompanive të telekomit për përdorimin e telefonit e të separateve
postare, si dhe kërkesat e tjera të tyre që arkëtohen në afate tre (3) mujore apo më të shkurtra;
1.4. kërkesat e parapagimit në botime periodike, duke llogaritur nga kalimi i kohës për të cilën
është porositur botimi;
1.5. kërkesat për shërbimet e qasjes në internet, shërbimet për përdorimin e e-mail-it,
shërbimet për mirëmbajtjen e “faqes elektronike“, dhe shërbimet e lidhura me qasjen në
stacionet e radios dhe televizionit kabllor dhe satelitor që arkëtohen në afate tre (3) mujore apo
më të shkurtra;
1.6. kërkesat nga administratorët e blloqeve të apartamenteve për shërbimet dhe kërkesat e
tjera që arkëtohen në afate tremujore apo më të shkurtra.
2. Afati i parashkrimit rrjedh nga fundi i vitit në të cilin arrin kërkesa për pagesë.
3. Parashkrimi rrjedh edhe nëse furnizimi dhe shërbimet vazhdojnë.', '08993bc128b5a575d3943947b0fb9eec4a3df8fbca83a7ee66e888777fe2d3a4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":77,"pageEnd":77,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (360, '361', 'Kërkesat e vërtetuara nga gjykata ose organet tjera kompetente', '1-2', 'Ligji 04/L-077
Neni 361 - Kërkesat e vërtetuara nga gjykata ose organet tjera kompetente

1. Të gjitha kërkesat që janë vërtetuar me vendim të formës së prerë të gjykatës ose me vendim të
organit tjetër kompetent, ose me ujdinë e palëve para gjykatës apo organit tjetër kompetent,
parashkruhen për dhjetë (10) vjet, madje edhe ato për të cilat ligji edhe ashtu parashikon afat më të
shkurtër për parashkrim.
2. Megjithatë, të gjitha kërkesat periodike që rrjedhin nga vendimet ose ujditë e tilla dhe arrijnë për
pagesë në të ardhmen, parashkruhen në afatin e paraparë për parashkrimin e kërkesave periodike.', 'c4fd4cfb6442e991890195264db1f8293bb80914f4f05770e5a2753b00da10f4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":77,"pageEnd":77,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (361, '362', 'Afatet e parashkrimit te kontratat për sigurimin', '1-6', 'Ligji 04/L-077
Neni 362 - Afatet e parashkrimit te kontratat për sigurimin

1. Kërkesat e kontraktuesve të sigurimit, respektivisht të personit të tretë nga kontrata e sigurimit të
jetës, parashkruhen për pesë (5) vjet, kurse nga kontratat e tjera për sigurimin për tre (3) vjet, duke
llogaritur që nga dita e parë pas kalimit të vitit kalendarik në të cilin është krijuar kërkesa.
2. Në qoftë se personi i interesuar provon se deri në ditën e caktuar në paragrafin paraprak nuk ka ditur
se rasti i siguruar ka ndodhur, parashkrimi fillon që nga dita kur të ketë marrë dijeni për këtë, ashtu që
në çdo rast kërkesa parashkruhet te sigurimi i jetës për dhjetë(10) vjet, kurse te sigurimet e tjera për
pesë (5) vjet nga data e caktuar në paragrafin paraprak.
3. Kërkesat e siguruesit nga kontratat e sigurimit parashkruhen për tre (3) vjet.
4. Nëse i dëmtuari në rastin e sigurimit nga përgjegjësia kërkon shpërblim nga i siguruari, ose
shpërblimin e ka marrë prej tij, parashkrimi i kërkesës të të siguruarit ndaj siguruesit fillon që nga dita
kur personi i dëmtuar ka kërkuar në rrugë gjyqësore shpërblimin nga i siguruari, respektivisht kur i
siguruari t’ia ketë shpërblyer dëmin.
5. Kërkesa e drejtpërdrejtë e personit të tretë të dëmtuar ndaj siguruesit parashkruhet për të njëjtën
kohë për të cilën parashkruhet kërkesa e tij ndaj të siguruarit përgjegjës për dëmin.
6. Parashkrimi i kërkesës që i takon siguruesit ndaj personit të tretë përgjegjës për paraqitjen e rastit të
sigurimit fillon të rrjedhë kur fillon edhe parashkrimi i kërkesës së të siguruarit ndaj këtij personi, dhe
mbaron në të njëjtin afat.', 'f31a950a4862b13425472b7589622af40cc020e35f36f43d0daf44fff906ccc7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":77,"pageEnd":78,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (362, '363', 'Kërkesat ndërmjet personave të caktuar', '1-1.4', 'Ligji 04/L-077
Neni 363 - Kërkesat ndërmjet personave të caktuar

1. Parashkrimi nuk rrjedh:
1.1. ndërmjet bashkëshortëve;
1.2. ndërmjet prindërve dhe fëmijëve derisa zgjat e drejta prindërore;
1.3. ndërmjet personit nën kujdestari dhe kujdestarit të tij si dhe të organit të kujdestarisë, gjatë
kohës së kujdestarisë dhe derisa të mos paraqiten llogaritë;
1.4. ndërmjet dy personave që jetojnë në bashkëjetesë, derisa ekziston ajo bashkëjetesë.', '0c4c6ab334b25495ed3f03e169ee94898cbd5e0642b93c86104750992c2b2eac', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.4","pageStart":78,"pageEnd":78,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (363, '364', 'Kërkesat e personave të caktuar', '1-1.2', 'Ligji 04/L-077
Neni 364 - Kërkesat e personave të caktuar

1. Parashkrimi nuk rrjedh:
1.1. gjatë kohës së mobilizimit në rastin e rrezikut të drejtpërdrejt të luftës ose gjatë luftës lidhur
me kërkesat e personave në detyrë ushtarake;
1.2. në pikëpamje të kërkesave që kanë personat e punësuar në ekonomi të huaj shtëpiake
ndaj punëdhënësve ose anëtarëve të familjes së tij që bashkëjetojnë me te, derisa zgjat ajo
marrëdhënie.', 'f8c621c85cb94de686ab55300b86959d98029063528bdd28c87592136fd2af1c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.2","pageStart":78,"pageEnd":78,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (364, '365', 'Pengesat e papërballueshme', null, 'Ligji 04/L-077
Neni 365 - Pengesat e papërballueshme

Parashkrimi nuk rrjedh për gjithë kohën për të cilën kreditori nuk ka pasur mundësi që për shkak të
pengesave të papërballueshme të kërkojë përmes gjykatës përmbushjen e detyrimit.', '6a70a6c2cbcbb78b363fcfe19ce8e5f5703e1caf34856726d9cf6b8668f57717', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":78,"pageEnd":78,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (365, '366', 'Ndikimi i shkaqeve të ndaljes në rrjedhën e parashkrimit', '1-2', 'Ligji 04/L-077
Neni 366 - Ndikimi i shkaqeve të ndaljes në rrjedhën e parashkrimit

1. Në qoftë se parashkrimi nuk ka mundur të fillojë të rrjedhë për arsye të ndonjë shkaku ligjor, ai fillon
të rrjedhë posa ai shkak të ketë pushuar së ekzistuari.
2. Në qoftë se parashkrimi ka filluar të rrjedhë përpara se të ketë ndodhur shkaku i cili e ka ndalur
rrjedhën e tij të mëtejshëm, ai vazhdon të rrjedhë kur të pushojë së ekzistuari ai shkak, ndërsa koha që
ka kaluar para ndaljes llogaritet në afatin e caktuar ligjor për parashkrim.', '9c6798388ab12cddf4c84aad5613f206c3e59c019c4dbb2a0f4dbb39691afa1a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":79,"pageEnd":79,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (366, '367', 'Kërkesat ndaj personave të paaftë për të vepruar dhe kërkesat e tyre', '1-3', 'Ligji 04/L-077
Neni 367 - Kërkesat ndaj personave të paaftë për të vepruar dhe kërkesat e tyre

1. Parashkrimi rrjedh edhe ndaj të miturit dhe personit tjetër të paaftë për të vepruar, pavarësisht nëse
kanë ose jo përfaqësuesin ligjor të tyre.
2. Megjithatë, parashkrimi i kërkesës së të miturit i cili nuk ka përfaqësues, dhe i personit tjetër të paaftë
për të vepruar pa përfaqësues, nuk mund të fillojë të rrjedhë derisa të mos kenë kaluar dy (2) vjet nga
data kur janë bërë plotësisht të aftë për të vepruar ose kur iu është caktuar përfaqësuesi.
3. Në qoftë se për parashkrimin e një kërkese është caktuar një kohë më e shkurtër se dy (2) vjet,
ndërsa kreditori është i mitur dhe nuk ka përfaqësues ose ndonjë person tjetër i paaftë për të vepruar
pa përfaqësues, parashkrimi i asaj kërkese fillon të rrjedhë kur kreditori është bërë i aftë për të vepruar
ose kur atij i është caktuar përfaqësuesi.', 'fa424a258719e189c27746579caab9c9a11abe3333444f2e143b161d083eeba9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":79,"pageEnd":79,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (367, '368', 'Pranimi i borxhit', '1-2', 'Ligji 04/L-077
Neni 368 - Pranimi i borxhit

1. Parashkrimi ndërpritet kur debitori e pranon borxhin.
2. Pranimi i borxhit mund të bëhet jo vetëm me deklaratën e kreditorit, veçse edhe në mënyrë të
tërthortë, sikurse janë pagesa e këstit, pagesa e kamatës, dhënia e sigurimit.', '7bb9c21e0dc03188a2d7a2dc3133a5d4f3d50c5f8abd75e1a0644ffd659146ec', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":79,"pageEnd":79,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (368, '369', 'Paraqitja e padisë', null, 'Ligji 04/L-077
Neni 369 - Paraqitja e padisë

Parashkrimi ndërprehet me paraqitjen e padisë dhe me çdo veprim tjetër të kreditorit të ndërmarur
kundër debitorit para gjykatës ose autoriteti tjetër kompetent me qëllim vërtetimi, sigurimi ose realizimi
të kërkesës.', 'da671bc12bcddd05774babf653274e2891a52819c5edfa7e6b5c7c1e819c0252', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":79,"pageEnd":79,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (369, '370', 'Heqja dorë, hedhja poshtë ose refuzimi i padisë', '1-2', 'Ligji 04/L-077
Neni 370 - Heqja dorë, hedhja poshtë ose refuzimi i padisë

1. Ndërprerja e parashkrimit e bërë me paraqitjen e padisë ose me ndonjë veprim tjetër të kreditorit të
ndërmarur kundër debitorit para gjykatës ose autoritetit tjetër kompetent me qëllim vërtetimi, sigurimi
ose realizimi të kërkesës, konsiderohet se nuk ka filluar po qe se kreditori heq dorë nga padia ose
veprimi të cilin e ka ndërmarrë.
2. Konsiderohet se nuk ka pasur ndërprerje, në qoftë se padia e kreditorit ose kërkesa e tij është
hedhur poshtë apo refuzuar ose në qoftë se masa e kërkuar ose e ndërmarur e përmbarimit apo e
sigurimit është shpallur e pavlefshme.', 'da9bb7814c27de55f22e2cda5f462d7c10e68c2592aa374a6ccf3c098539e86f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":79,"pageEnd":80,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (370, '371', 'Hedhja poshtë e padisë për shkak të jokompetencës', '1-2', 'Ligji 04/L-077
Neni 371 - Hedhja poshtë e padisë për shkak të jokompetencës

1. Në qoftë se padia kundër debitorit është hedhur poshtë për shkak të jo kompetencës së gjykatës ose
për ndonjë arsye tjetër i cili nuk i përket esencës së çështjes, kështu që kreditori përsëri paraqet padi
brenda afatit prej tre (3) muajsh nga data kur vendimi mbi hedhjen poshtë të padisë të ketë marrë
formën e prerë do të konsiderohet se parashkrimi është ndërprerë me padinë e parë.
2. E njëjta gjë vlen edhe për thirrjen në mbrojtje si dhe për paraqitjen e kompensimit të kërkesës në
kontest si dhe në rastin kur gjykata ose ndonjë organ tjetër e ka drejtuar debitorin që kërkesën e tij të
deklaruar ta realizojë në procedurë civile.', '8eb053a92db955d5b90fbf13a2b0efc75a90d80193a88a298da22ce7a4665e7b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":80,"pageEnd":80,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (371, '372', 'Thirrja e kreditorit', null, 'Ligji 04/L-077
Neni 372 - Thirrja e kreditorit

Për ndërprerjen e parashkrimit nuk mjafton që kreditori ta ftojë debitorin me shkrim ose me gojë që ta
përmbushë detyrimin.', '9348cb83524a5e5ec2b5c862ef639215df589dcfc1c356c024f5487cb2c914aa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":80,"pageEnd":80,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (372, '373', 'Afati i parashkrimit në rastin e ndërprerjes', '1-6', 'Ligji 04/L-077
Neni 373 - Afati i parashkrimit në rastin e ndërprerjes

1. Pas ndërprerjes parashkrimi fillon të rrjedhë përsëri, kurse koha që ka kaluar para ndërprerjes nuk
llogaritet në afatin e caktuar ligjor për parashkrim.
2. Parashkrimi i ndërprerë me anë të pranimit (pohimit) nga ana e debitorit fillon të rrjedhë përsëri nga
pranimi (pohimi).
3. Kur ndërprerja e parashkrimit ka filluar me paraqitjen e padisë ose me thirrjen në mbrojtje, ose duke
paraqitur kompensimin e kërkesave në kontest, respektivisht me paraqitjen e kërkesave në ndonjë
proces tjetër, parashkrimi fillon të rrjedhë përsëri që nga dita kur kontesti të ketë marrë fund definitivisht
ose të ketë përfunduar në ndonjë mënyrë tjetër.
4. Kur ndërprerja e parashkrimit të jetë shkaktuar me paraqitjen e kërkesës në procedurën e
falimentimit, parashkrimi fillon të rrjedhë përsëri që nga dita e përfundimit të asaj procedure.
5. E njëjta gjë vlen edhe kur ndërprerja e parashkrimit të jetë shkaktuar me kërkesën e përmbarimit të
dhunshëm ose të sigurimit.
6. Parashkrimi që fillon të rrjedhë përsëri pas ndërprerjes, mbaron kur të ketë kaluar aq kohë sa është
caktuar me ligj për parashkrimin që është ndërprerë.', 'c53a997cc93b073c6652598eeda202e24593aa8dab7c50dc22fa6a7dbdd09a9f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":80,"pageEnd":80,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (373, '374', 'Parashkrimi në rastin e përtrirjes së detyrimit', null, 'Ligji 04/L-077
Neni 374 - Parashkrimi në rastin e përtrirjes së detyrimit

Në qoftë se ndërprerja ka filluar me pranimin e borxhit nga ana e debitorit, ndërsa kreditori dhe debitori
janë marrë vesh që ta ndryshojnë bazën ose objektin e detyrimit, kërkesa e re parashkruhet për kohën
që është caktuar për parashkrimin e saj.', 'cec1fbe162e1e6677638c6b3883ee45ee681b38537170c11488160e637363b17', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":80,"pageEnd":80,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (374, '375', 'Parimi i nominalizmit monetar', null, 'Ligji 04/L-077
Neni 375 - Parimi i nominalizmit monetar

Kur detyrimi ka si subjekt një shumë të hollash, debitori ka për detyrë të paguajë shumën e njëjtë të të
hollave, përveç nëse kreditori dhe debitori merren vesh ndryshe në pajtim me ligjin.', '41096c765ad1bbb3639bfc6a293d749b480091eb8c6782c1189bd8c07995a1c7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":81,"pageEnd":81,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (375, '376', 'Rivlerësimi i detyrimeve monetare', '1-2', 'Ligji 04/L-077
Neni 376 - Rivlerësimi i detyrimeve monetare

1. Palët kontraktuese mund të pajtohen që shuma e detyrimeve monetare të debitorit të përcaktohet në
raport me ndryshimet në çmim të mallrave dhe shërbimeve të shprehura në indeksin e çmimeve të
shitjeve dhe të përcaktuara nga një organizatë e autorizuar, në lidhje me ndryshimet në kursin valutor
të huaj, ose në lidhje me ndryshimet në çmimet e tjera, përveç nëse një marrëveshje e këtillë është në
kundërshtim me ligjin.
2. Në rast se palët kontraktuese pajtohen me rivlerësimin e detyrimeve monetare, rivlerësimi bëhet për
periudhën nga fillimi i detyrimit e deri në përmbushjen e detyrimit, përveç nëse palët pajtohen ndryshe.', 'ac321e735cde967a3064133b3fe98aac78bac989b99fc385da9f5a95bc0931eb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":81,"pageEnd":81,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (376, '377', 'Përmbushja e parakohshme', '1-3', 'Ligji 04/L-077
Neni 377 - Përmbushja e parakohshme

1. Debitori mund t’i përmbushë detyrimet në para edhe para kohe.
2. Është nul dispozita e kontratës me të cilën debitori heq dorë nga kjo e drejtë.
3. Në rast të përmbushjes së detyrimit në të holla para kohe, debitori ka të drejtë të zbresë kamatën
nga shuma e borxhit për kohën prej datës së pagesës deri në ditën kur detyrimi të ketë arritur për
pagesë, vetëm kur për këtë është i autorizuar me kontratë apo nëse kjo rrjedh nga doket.', 'e9c612e3dc54c9b3cc45808f01ea67ebdb75cef7d2f78208da78ea462ed8c5ea', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":81,"pageEnd":81,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (377, '378', 'Përkufizim', null, 'Ligji 04/L-077
Neni 378 - Përkufizim

Përveç borxhit kryesor (kryegjëja), debitori po ashtu ka për detyrim edhe kamatën, në qoftë se e njëjta
është përcaktuar nga ligji ose në rast se kreditori dhe debitori ashtu kanë kontraktuar.', '2838a9413a00634d71c59094fb37239f0d8c2b4b4e8a63327d61b9f958152201', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":81,"pageEnd":81,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (378, '379', 'Ndalimi i kamatës në kamatë', '1-4', 'Ligji 04/L-077
Neni 379 - Ndalimi i kamatës në kamatë

1. Në kamatën e kontraktuar e cila ka arritur për pagesë, por nuk është paguar nuk rrjedh
kamatëvonesa, përveç nëse është paraparë ndryshe me ligj.
2. Është nule dispozita e kontratës me të cilën parashikohet kamatë në kamatën e cila ka arritur për
pagesë por nuk është paguar.
3. Megjithatë, palët mund të pajtohen që më parë në kontratë se shkalla e kamatës do të jetë më e lartë
në rast se debitori nuk i paguan kamatat e rrjedha për pagesë në kohën e duhur.
4. Në shumën e papaguar të kamatës mund të kërkohet kamatëvonesa vetëm nga dita kur gjykatës i
është paraqitur kërkesa për pagimin e saj.', 'ac1db6f9b8b71a321a70ed3311f46c3124c0326a40183ed2ce8501813199b7d3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":82,"pageEnd":82,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (379, '380', 'Kur kamata pushon të rrjedhë', null, 'Ligji 04/L-077
Neni 380 - Kur kamata pushon të rrjedhë

Kamata pushon të rrjedhë kur shuma e kamatave të arritura për pagesë, arrin lartësinë e borxhit
kryesor.', '5cd8dfae795736017bdbd71fb651a01630bd52987fc4ed871104c857099c7466', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":82,"pageEnd":82,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (380, '381', 'Supozimi i kontratës me fajde', '1-2', 'Ligji 04/L-077
Neni 381 - Supozimi i kontratës me fajde

1. Në rast se niveli i kamatës për të cilin janë pajtuar palët është për pesëdhjetë përqind (50%) më i
lartë sesa niveli i kamatëvonesës, i përllogaritur sipas nenit në vijim, një marrëveshje e tillë
konsiderohet kontratë me fajde, përveç nëse kreditori provon se nuk ka shfrytëzuar gjendjen e
pavolitshme të debitorit, vështirësinë e situatës së tij financiare, pamaturinë ose varësinë e krijuar prej
saj, ose që përfitimet e rezervuara për kreditorin ose personin e tretë nuk janë në shpërpjesëtim me atë
që kreditori ka ofruar ose ka ndërmarrë të ofrojë ose të bëjë.
2. Supozimi i saktësuar në paragrafin paraprak nuk zbatohet në kontratat komerciale.', 'e50672c6e515c1fe87735b3b63ad06db73cb04cd1bd23d63c8829e49fdd67ae9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":82,"pageEnd":82,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (381, '382', 'Kamatëvonesa', '1-2', 'Ligji 04/L-077
Neni 382 - Kamatëvonesa

1. Debitori që vonon në përmbushjen e detyrimit në të holla debiton, përpos borxhit kryesor, edhe
kamatën.
2. Lartësia e kamatëvonesës është tetë përqind (8%) në vit, përveç nëse parashihet ndryshe me ligj të
veçantë.', '0029e80a6a673b3ffc467ce28127d361550d42403121acc51389f638a07f7486', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":82,"pageEnd":82,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (382, '383', 'Kamatëvonesa e kontraktuar', null, 'Ligji 04/L-077
Neni 383 - Kamatëvonesa e kontraktuar

Kreditori dhe debitori mund të pajtohen me kontratë që lartësia e kamatëvonesës të jetë më e ulët ose
më i lartë sesa niveli i kamatëvonesës së përcaktuar me ligj.', 'e5d3246267ebada1efd8d4e06de8f29481dc35b50040b29daa8865787f3c9bcf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":82,"pageEnd":82,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (383, '384', 'E drejta e shpërblimit të plotë', '1-2', 'Ligji 04/L-077
Neni 384 - E drejta e shpërblimit të plotë

1. Kreditori ka të drejtë në kamatëvonesën pa marrë parasysh nëse ka pësuar ndonjë dëm për shkak të
vonesës së debitorit.
2. Në qoftë se dëmi të cilin e ka pësuar kreditori për shkak të vonesës së debitorit, është më i madh
nga shuma të cilën do ta merrte në emër të kamatëvonesës, ai ka të drejtë të kërkojë diferencën deri në
shpërblimin e plotë të dëmit.', 'c79bd7713cc954e5e092170498e5de4763520cff39b98c82d7633a6b621f39c4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":83,"pageEnd":83,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (384, '385', 'Kamata kontraktore', '1-2', 'Ligji 04/L-077
Neni 385 - Kamata kontraktore

1. Palët kontraktuese mund të pajtohen që, përveç shumës kryesore (kryegjësë), debitori duhet të
paguajë kamatën kontraktore nga periudha e lindjes së detyrimit në të holla deri në kohën e arritjes për
pagesë të detyrimit.
2. Në rast se palët janë pajtuar për kontratën kamatore (me interes) por niveli i kamatës dhe koha e
arritjes për pagesë së interesit nuk është përcaktuar, niveli i kamatës është gjashtë përqind (6%) në vit
dhe kamata rrjedh për pagesë në kohën e njëjtë me arritjen për pagesë të kryegjësë (shumës
kryesore).', 'c72b07885c256b01bbbc2b928ecdbc793591b7055e3a1b86dfffdc70331f0ef2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":83,"pageEnd":83,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (385, '386', 'Kamata në detyrimet jomonetare', null, 'Ligji 04/L-077
Neni 386 - Kamata në detyrimet jomonetare

Dispozitat e këtij ligji për kamatën kontraktuese zbatohen përshtatshmërisht edhe për marrëdhëniet e
tjera të detyrimeve të shquara sipas llojit, gjegjësisht detyrimet të cilat kanë për lëndë sendet e
zëvendësueshme dhe të shquara sipas llojit.', 'e02fb443f905dc3446049d028d1f0d39c54b0823664d3f0ca8acf2e3fd53fdd5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":83,"pageEnd":83,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (386, '387', 'E drejta e zgjedhjes', null, 'Ligji 04/L-077
Neni 387 - E drejta e zgjedhjes

Në qoftë se ndonjë detyrim ka dy ose më tepër objekte, por debitori ka për detyrë të jep vetëm një për
t’u liruar nga detyrimi, atëherë, po qe se nuk është kontraktuar ndryshe, e drejta e zgjedhjes i takon
debitorit dhe detyrimi shuhet kur ky ta ketë dorëzuar objektin të cilin e ka zgjedhur vet.', 'fd9f96ebb1caa898868a7b7e9651a3f9656980beb6ed15dcd83ae2957350b736', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":83,"pageEnd":83,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (387, '388', 'Parevokueshmëria dhe efekti i zgjedhjes së bërë', '1-2', 'Ligji 04/L-077
Neni 388 - Parevokueshmëria dhe efekti i zgjedhjes së bërë

1. Zgjedhja quhet e bërë kur pala të cilës i takon e drejta e zgjedhjes e njofton palën tjetër për atë që e
ka zgjedhur dhe nga ky moment zgjedhja nuk mund të ndryshohet.
2. Me zgjedhjen e bërë konsiderohet se detyrimi ka qenë që në fillim i thjesht dhe se që në fillim ka
pasur si objekt sendin e zgjedhur.', '4c56f3fbef94ebfddfdc3760afe2d8b238e40c3fb07f2d63dc88a180e6304b8f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":83,"pageEnd":84,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (388, '389', 'Kohëzgjatja e të drejtës së zgjedhjes', '1-2', 'Ligji 04/L-077
Neni 389 - Kohëzgjatja e të drejtës së zgjedhjes

1. Debitori ka të drejtë të zgjedhë gjithnjë derisa në procedurën e përmbarimit të dhunshëm një prej
sendeve që është borxh të mos i dorëzohet plotësisht ose pjesërisht kreditorit sipas zgjedhjes së tij.
2. Në qoftë se e drejta e zgjedhjes i takon kreditorit dhe ky nuk deklarohet rreth zgjedhjes brenda afatit
të caktuar për përmbushje, debitori mund ta ftojë që të bëjë zgjedhjen dhe për këtë t’i caktojë një afat të
ri, pas skadimit të të cilit e drejta e zgjedhjes kalon në debitorin.', '7bcb43922d95ebaf3785678baa08fcbaa3bb71ce14a6c158910345e4d0c1dbf4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":84,"pageEnd":84,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (389, '390', 'Zgjedhja që i besohet personit të tretë', null, 'Ligji 04/L-077
Neni 390 - Zgjedhja që i besohet personit të tretë

Në qoftë se zgjedhjen duhet ta bëjë ndonjë person i tretë dhe këtë gjë ai nuk e bën, secila palë mund të
kërkojë që zgjedhjen ta bëjë gjykata.', 'aca7a3e6531331e733bd63175a3b9c904b93023b6080b37a114eeb6515874063', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":84,"pageEnd":84,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (390, '391', 'Kufizimi në objektin e mbetur', null, 'Ligji 04/L-077
Neni 391 - Kufizimi në objektin e mbetur

Në qoftë se një objekt i detyrimit është bërë i pamundshëm për shkak të ndonjë ngjarje për të cilën nuk
mbajnë përgjegjësi asnjëra palë, detyrimi kufizohet në objektin e mbetur.', '4cbada3f45514fd00d6f4441f29da6314f4c184c2b7782ad4bc915e830eaed69', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":84,"pageEnd":84,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (391, '392', 'Kufizimi në rast të përgjegjësisë së njërës palë', '1-2', 'Ligji 04/L-077
Neni 392 - Kufizimi në rast të përgjegjësisë së njërës palë

1. Kur një objekt i detyrimit është i pamundur për shkak të ngjarjes për të cilën përgjegjësinë e mban
debitori, detyrimi kufizohet në objektin e mbetur në qoftë se e drejta e zgjedhjes i takon këtij, e nëse e
drejta e zgjedhjes i takon kreditorit, ky mundet pas zgjedhjes së vet të kërkojë objektin e mbetur ose
shpërblimin e dëmit.
2. Kur një objekt i detyrimit është bërë i pamundur për shkak të ngjarjeve për të cilat është përgjegjës
kreditori, detyrimi i debitorit shuhet, por në qoftë se këtij i takon e drejta e zgjedhjes ky mund të kërkojë
shpërblimin e dëmit dhe ta kryejë detyrimin e vet nga objekti i mbetur, e në qoftë se e drejta e zgjedhjes
i takon kreditorit – ky mund të japë shpërblimin e dëmit dhe të kërkojë objektin e mbetur.', 'f16713bb9a032cce54f93640eceeffe38ceeb0ce28ac28f020230fb7f580b712', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":84,"pageEnd":84,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (392, '393', 'Autorizimi i debitorit në detyrimin fakultativ', null, 'Ligji 04/L-077
Neni 393 - Autorizimi i debitorit në detyrimin fakultativ

Debitori, detyrimi i të cilit ka një objekt, por të cilit i lejohet që të lirohet nga detyrimi i vet duke dhënë
ndonjë objekt tjetër të caktuar, mund ta shfrytëzojë këtë mundësi gjithnjë derisa kreditori në procedurën
e përmbarimit të detyrueshëm të mos ta ketë marrë tërësisht ose pjesërisht objektin e detyrimit.', '7fbfc99484ea5d95a988da0b59951d36775c43eb53901ef9eb2382eaf64ed7e5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":84,"pageEnd":84,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (393, '394', 'Autorizimi i kreditorit në detyrimin fakultativ', '1-2', 'Ligji 04/L-077
Neni 394 - Autorizimi i kreditorit në detyrimin fakultativ

1. Kreditori në detyrimin fakultativ mund të kërkojë nga debitori vetëm objektin e detyrimit, por jo edhe
objektin tjetër me të cilin debitori, në qoftë se dëshiron mundet gjithashtu ta përmbushë detyrimin e vet.
2. Kur objekti i detyrimit bëhet i pamundur për shkak të ngjarjeve për të cilat debitori nuk përgjigjet,
kreditori mund të kërkojë vetëm shpërblimin e dëmit, por debitori mund të lirohet nga detyrimi duke
dhënë objektin të cilin është i autorizuar ta japë në vend të objektit që është borxh.', '32e0a2b78d8687543ccfea207a12f2e46838c1f8da93b70f55fc1d055e3499af', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":85,"pageEnd":85,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (394, '395', 'Rregulla e përgjithshme', '1-2', 'Ligji 04/L-077
Neni 395 - Rregulla e përgjithshme

1. Kur me kontratë ose ligj është parashikuar që kreditori mundet në vend të objektit që është borxh të
kërkojë nga debitori ndonjë objekt tjetër të caktuar, debitori ka për detyrë t’ia dorëzojë atë objekt, po qe
se atë e kërkon kreditori.
2. Përndryshe, për kërkesa të këtilla fakultative vlejnë sipas qëllimit të kontraktuesve dhe sipas
rrethanave të punës, rregullat përkatëse mbi detyrimet fakultative dhe ato alternative.', '7297b3f9f22888c788539e99dbb8610cf47babca165a950e14b2e7ef6c7da287', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":85,"pageEnd":85,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (395, '396', 'Pjesëtimi i detyrimeve dhe i kërkesave', '1-3', 'Ligji 04/L-077
Neni 396 - Pjesëtimi i detyrimeve dhe i kërkesave

1. Detyrimi është i pjesëtueshëm në qoftë se ajo që debitohet mund të pjesëtohet dhe të përmbushet
në pjesët që kanë cilësi të njëjta siç ka i tërë objekti dhe në qoftë se me këtë pjesëtim nuk humbë asgjë
nga vlera e vet, ndërsa në të kundërtën detyrimi është i papjesëtueshëm.
2. Kur në ndonjë detyrim të pjesëtueshëm ka disa kreditorë, detyrimi pjesëtohet midis tyre në pjesë të
barabarta, në qoftë se nuk është caktuar pjesëtimi tjetër dhe secili prej tyre përgjigjet për pjesën e vet të
detyrimit.
3. Kur në ndonjë detyrim të pjesëtueshëm ka disa kreditorë, kërkesa pjesëtohet midis tyre në pjesë të
barabarta, në qoftë se nuk është caktuar diçka tjetër dhe secili kreditor mund të kërkojë vetëm pjesën e
vet të kërkesës.', '1f9a38bb314c31020ea5eae3dc7d350c333a4fe2ab187813715d724411fee510', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":85,"pageEnd":85,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (396, '397', 'Prezumimi i solidaritetit', null, 'Ligji 04/L-077
Neni 397 - Prezumimi i solidaritetit

Kur ka disa debitorë në ndonjë detyrim të pjesëtueshëm të krijuar me kontratë, në ekonomi ata i
përgjigjen kreditorit solidarisht, përveç në qoftë se kontraktuesit e kanë eliminuar shprehimisht
përgjegjësinë solidare.', '27579c69f764c173cf53eff76b8270c3c867c20c200cb7cb9620c32997ff5fa7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":85,"pageEnd":85,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (397, '398', 'Përmbajtja e solidaritetit të debitorëve', '1-2', 'Ligji 04/L-077
Neni 398 - Përmbajtja e solidaritetit të debitorëve

1. Secili debitor i detyrimit solidar i përgjigjet kreditorit për krejt detyrimin dhe kreditori mund të kërkojë
përmbushjen e tij nga cilido që dëshiron, gjithnjë derisa të mos përmbushet krejtësisht, por kur një
debitor ta ketë përmbushur detyrimin ai shuhet dhe të gjithë debitorët lirohen.
2. Nga disa debitorë solidarë secili mund të ketë borxh me afat tjetër të përmbushjes, në kushte të tjera
dhe në përgjithësi me alternativa të ndryshme.', 'f1fb1f954a18e417ae4eba5fd3aa54103a7801c6039263d65b006c7ebdd37ef8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":86,"pageEnd":86,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (398, '399', 'Kompensimi', '1-2', 'Ligji 04/L-077
Neni 399 - Kompensimi

1. Secili debitor solidar mund t’i referohet kompensimit që e ka bërë bashkëdebitori i tij.
2. Debitori solidar mund të bëjë kompensimin e kërkesës së bashkëdebitorit të vet ndaj kreditorit me
atë, që kreditori i detyrohet por vetëm për aq sa është pjesa e borxhit e këtij bashkëdebitori në
detyrimin solidar.', '665e2870da0adb8ed4d7e70ad59f5b26e88cabcb8ca33c20eeeb769141ca6792', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":86,"pageEnd":86,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (399, '400', 'Falja e borxhit', '1-2', 'Ligji 04/L-077
Neni 400 - Falja e borxhit

1. Falja e borxhit që bëhet në marrëveshje me një debitor solidar i liron nga detyrimi edhe debitorët e
tjerë.
2. Megjithatë, në qoftë se falja ka pasur për qëllim ta lirojë nga detyrimi vetëm debitorin ndaj të cilit
është falë borxhi, detyrimi solidar zvogëlohet për pjesën e cila sipas marrëdhënieve reciproke të
debitorëve i takon atij, kurse debitorët e tjerë përgjigjen solidarisht për pjesën e mbetur të detyrimit.', '5b609588dc85bcd91d3eaf59b653f3fa0ab079e3f661842189fb9756f47da8e5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":86,"pageEnd":86,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (400, '401', 'Përtrirja (Novacioni)', '1-2', 'Ligji 04/L-077
Neni 401 - Përtrirja (Novacioni)

1. Me përtrirjen të cilin kreditori e ka bërë me një debitor solidar, lirohen edhe debitorët e tjerë.
2. Megjithatë, në qoftë se kreditori dhe debitori e kanë kufizuar përtrirjen vetëm në pjesën e detyrimit
që i takon këtij, detyrimi i të tjerëve nuk shuhet, por vetëm zvogëlohet për atë pjesë.', 'e64a91758765a9e6891488951bf8739e6ce0e0b7b1c30b573c70f077a62543dc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":86,"pageEnd":86,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (401, '402', 'Ujdia', null, 'Ligji 04/L-077
Neni 402 - Ujdia

Ujdia të cilën e ka kontraktuar një nga debitorët solidarë me kreditorin, nuk ka efekt ndaj debitorëve të
tjerë, por këta kanë të drejtë ta pranojnë këtë ujdi në qoftë se ai nuk është i kufizuar vetëm në debitorin
me të cilin është kontraktuar.', '92890717a114cc00d6df0726f1d866c51c41d140b3b5bebbb6d39f60cf122841', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":86,"pageEnd":86,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (402, '403', 'Konfondimi', null, 'Ligji 04/L-077
Neni 403 - Konfondimi

Kur në një person bashkohen cilësia e kreditorit dhe cilësia e debitorit të detyrimeve të njëjta solidare,
atëherë detyrimi i debitorëve të tjerë zvogëlohet për shumën e pjesës që i bie atij.', '721c67eb90edca68de9e046adc23c4cc6e0d87ae780f37f0b9a661e3a83808f1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":86,"pageEnd":86,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (403, '404', 'Vonesa e kreditorit', null, 'Ligji 04/L-077
Neni 404 - Vonesa e kreditorit

Kur kreditori bie në vonesë ndaj një debitori solidar, atëherë ky është në vonesë edhe ndaj debitorëve
të tjerë solidarë.', 'b42de5119e4f3310b615f447eb7133509195052f65838fb7b3ebd8ee0f6f3111', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":87,"pageEnd":87,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (404, '405', 'Vonesa e një debitori dhe pranimi i borxhit', '1-2', 'Ligji 04/L-077
Neni 405 - Vonesa e një debitori dhe pranimi i borxhit

1. Vonesa e një debitori solidar nuk ka efekt ndaj debitorëve të tjerë.
2. E njëjta vlen edhe për pranimin e borxhit që do ta bënte një prej debitorëve solidarë.', 'e59328942d14e3a018f1b435af16c47d25213f746533827531807bac3d3949e1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":87,"pageEnd":87,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (405, '406', 'Ndalja dhe ndërprerja e parashkrimit dhe heqja dorë nga parashkrimi', '1-2', 'Ligji 04/L-077
Neni 406 - Ndalja dhe ndërprerja e parashkrimit dhe heqja dorë nga parashkrimi

1. Në qoftë se parashkrimi nuk rrjedh ose është ndërprerë ndaj njërit debitor, ai vazhdon të rrjedhë për
debitorët e tjerë solidarë dhe mund të përfundoj, por debitori ndaj të cilit detyrimi nuk është parashkruar
dhe i cili është dashur ta përmbushë ka të drejtë të kërkojë nga debitorët e tjerë ndaj të cilëve detyrimi
është parashkruar që t’ia shpërblejë secili pjesën e vet të detyrimit.
2. Heqja dorë nga parashkrimi i kryer nuk ka efekt ndaj debitorëve të tjerë.', '89d2ca11d37b54cbe3adc8c23919f7f1581b73fb43105d1167e65949f8c801b4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":87,"pageEnd":87,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (406, '407', 'E drejta e përmbushësit në kompensim', '1-3', 'Ligji 04/L-077
Neni 407 - E drejta e përmbushësit në kompensim

1. Debitori i cili e ka përmbushur detyrimin ka të drejtë të kërkojë prej secilit bashkë debitorë që t''i
kompensojë pjesën e detyrimit që bie në të.
2. Ndërkaq, nuk ka ndikim rrethana së kreditori e ka liruar ndonjë nga bashkë debitorët nga borxhi ose
ia ka pakësuar borxhin.
3. Pjesa që bie në debitorin nga e cila nuk mund të merret kompensimi, pjesëtohet përpjesëtimisht në
të gjithë debitorët.', 'bf7cf49a69113f2b947320075366e056dc388a286463321f8fd8339b957b6f8b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":87,"pageEnd":87,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (407, '408', 'Pjesëtimi në pjesë të barabarta dhe përjashtimi', '1-2', 'Ligji 04/L-077
Neni 408 - Pjesëtimi në pjesë të barabarta dhe përjashtimi

1. Në qoftë se nuk është kontraktuar diçka tjetër, ose nuk rezulton nga marrëdhëniet juridike të
pjesëmarrësve në punë, mbi secilin debitor bie pjesa e barabartë.
2. Megjithatë, në qoftë se detyrimi solidar është kontraktuar në interes ekskluziv të një debitori solidar,
atëherë ky ka për detyrë t’ia shpërblejë krejt shumën e detyrimit bashkëdebitorit, i cili e ka paguar
kreditorin.', '0f4e386c7c01afcb1366b6227df373be6676cbc4d6de050b713b75815180d67b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":87,"pageEnd":87,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (408, '409', 'Solidariteti nuk prezumohet', null, 'Ligji 04/L-077
Neni 409 - Solidariteti nuk prezumohet

Kur në anën e kreditorit ka disa persona, këta janë solidarë vetëm kur solidariteti është i kontraktuar
ose i caktuar me ligj.', '20b85a4855dc41148a54f834bd021fa4480ec28eaa41491e9a6ffef8231aca31', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":87,"pageEnd":87,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (409, '410', 'Përmbajtja e solidaritetit', '1-2', 'Ligji 04/L-077
Neni 410 - Përmbajtja e solidaritetit

1. Secili kreditor solidar ka të drejtë të kërkojë nga debitori përmbushjen e tërë detyrimit, por kur njëri
prej tyre paguhet, detyrimi shuhet edhe ndaj kreditorëve të tjerë.
2. Debitori mund t’ia përmbushë detyrimin kreditorit të cilin e zgjedh vet, gjithnjë derisa një kreditor të
mos kërkojë përmbushjen.', 'ac94a712ea2b31bdd1a2a8eb338e1551cac8cf8917a4a2b0cbfed2ad979f9270', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (410, '411', 'Kompensimi', '1-2', 'Ligji 04/L-077
Neni 411 - Kompensimi

1. Debitori mund të bëjë kompensimin e detyrimit të vet me kompensimin që ka ndaj kreditorit i cili ia
kërkon përmbushjen.
2. Kompensimi me kërkesën që ka ndaj ndonjë kreditori tjetër debitori mund ta bëjë vetëm deri në
masën e pjesës së kërkesës solidare që i takon këtij kreditori.', '29bb54a8c24a33ec3d31aa88f1ae9e9c87848f0c7ba351e98e80c9cadee05b9c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (411, '412', 'Falja e borxhit dhe përtrirja', null, 'Ligji 04/L-077
Neni 412 - Falja e borxhit dhe përtrirja

Me faljen e borxhit dhe me përtrirjen ndërmjet debitorit dhe një kreditori, zvogëlohet detyrimi solidar për
aq sa është shuma e pjesës së kësaj kërkese të kreditorit.', '8f24236218a9d6c080fb2e58a222e130fec964c3a11b62360a79be0fa379e6e1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (412, '413', 'Ujdia', null, 'Ligji 04/L-077
Neni 413 - Ujdia

Ujdia të cilën e ka lidhur një nga kreditorët solidarë me debitorin nuk ka efekt ndaj kreditorëve të tjerë,
por këta kanë të drejtë që ta pranojnë këtë ujdi, me përjashtim kur ai ka të bëjë vetëm me pjesën e
kreditorit me të cilin është lidhur.', '2522553409a841700b6a8e2b768c3d45c12420f7a4f56933a36fccbf2b7b95bf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (413, '414', 'Konfondimi', null, 'Ligji 04/L-077
Neni 414 - Konfondimi

Kur në një person të një kreditori solidar bashkohet edhe cilësia e debitorit, secili prej kreditorëve të
tjerë solidarë mund të kërkojë prej tij vetëm pjesën e vet të kërkesës.', '2c4b6e02ff193e1f15cba1c64d3e478c7e1f9fade003a8e836ada71a1516660a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (414, '415', 'Vonesa', '1-2', 'Ligji 04/L-077
Neni 415 - Vonesa

1. Kur debitori bie në vonesë ndaj një kreditori solidar, atëherë ai është në vonesë edhe ndaj
kreditorëve të tjerë.
2. Vonesa e një kreditori solidar ka efekt edhe ndaj kreditorëve të tjerë.', '3f914af00240852f8cf000216716d3a9939817e221f8c1b2c767d7115dfc10e4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (415, '416', 'Pranimi i borxhit', null, 'Ligji 04/L-077
Neni 416 - Pranimi i borxhit

Pranimi i borxhit që i është bërë një kreditori është në favor për të gjithë kreditorët.', 'c420684c1cbfe8c99c082883fd6bc401bca41a7002a167fa14480f0143022ef5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":88,"pageEnd":88,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (416, '417', 'Parashkrimi', '1-2', 'Ligji 04/L-077
Neni 417 - Parashkrimi

1. Në qoftë se një kreditor e ndërprenë parashkrimin ose në qoftë se ndaj tij nuk rrjedh parashkrimi, kjo
nuk u shkon në favor kreditorëve të tjerë dhe ndaj tyre parashkrimi rrjedh edhe më tutje.
2. Heqja dorë nga parashkrimi që bëhet ndaj njërit kreditor u shkon në favor edhe kreditorëve tjerë.', '9f0977a9eb1bcedd1e6b2f39be1bc44d230c25532786f568e7bc09ef69e16d18', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":88,"pageEnd":89,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (417, '418', 'Marrëdhëniet ndërmjet kreditorëve pas përmbushjes', '1-2', 'Ligji 04/L-077
Neni 418 - Marrëdhëniet ndërmjet kreditorëve pas përmbushjes

1. Secili kreditor solidar ka të drejtë të kërkojë nga kreditori që e ka marrë përmbushjen nga debitori, që
t’ia japë pjesën e cila i takon.
2. Në qoftë se nga marrëdhënia ndërmjet kreditorëve nuk rrjedh diçka tjetër, secilit kreditor solidar u
takon pjesa e barabartë.', 'cf6b656cc967156ca7e571212b1f86783880964d788e94024dd72613759beae7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":89,"pageEnd":89,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (418, '419', 'Detyrimet e papjesëtueshme', '1-2', 'Ligji 04/L-077
Neni 419 - Detyrimet e papjesëtueshme

1. Për detyrimet e papjesëtueshme ku ka disa debitorë përshtatshmërisht zbatohen dispozitat mbi
detyrimet solidare.
2. Kur në detyrimin e papjesëtueshëm ka disa kreditorë ndërmjet të cilëve nuk është kontraktuar
solidariteti dhe as që është caktuar me ligj, një kreditor mund të kërkojë që debitori t’i përmbushë atij
vetëm në qoftë se është i autorizuar nga kreditorët e tjerë që të pranojë përmbushjen, ndërsa secili
kreditor mund të kërkojë nga debitori përmbushjen e gjithë detyrimit ose atë ta depozitojë në gjykatë.', '1e5afa9c3eba4ed94ca1d97a656264fa55f707c8803250a59a30109fc5fd78f9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":89,"pageEnd":89,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (419, '420', 'Cilat kërkesa mund të kalohen me kontratë', '1-4', 'Ligji 04/L-077
Neni 420 - Cilat kërkesa mund të kalohen me kontratë

1. Kreditori mundet që me kontratën e lidhur me personin e tretë t’i kalojë këtij kërkesat e veta, me
përjashtim të atyre kërkesave kalimi i të cilave është i ndaluar me ligj, si dhe i atyre që lidhen me
personalitetin e kreditorit, ose të cilat nga vetë natyra e tyre nuk mund t’i barten tjetrit.
2. Në rast se debitori dhe kreditori janë pajtuar që kreditori nuk mund të bartë kërkesën te tjetri, bartja
nuk ka efekt ligjor.
3. Nëse me bartjen është dorëzuar dokumenti që vërteton ekzistencën e kërkesës nga e cila nuk rrjedh
asnjë ndalesë e bartjes, bartja ke efekt në rast se pranuesi nuk e ka ditur dhe nuk ka qenë i detyruar të
dijë për ndalesën e bartjes.
4. Në rast se debitori dhe kreditori në një kontratë komerciale janë pajtuar që kreditori nuk mund të
bartë kërkesën monetare te tjetri, bartja megjithatë ka efekt. Në këtë rast, debitori po ashtu lirohet nga
detyrimi në rast se ajo është përmbushur për personin që ka bërë kërkesën.', 'e436400f2586121bc4024a6f803c6de4963fbadcefe646495e4c247abd324ba0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":89,"pageEnd":90,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (420, '421', 'Të drejtat akcesore', '1-3', 'Ligji 04/L-077
Neni 421 - Të drejtat akcesore

1. Me kërkesën kalojnë në pranuesin të drejtat akcesore, siç janë e drejta e para arkëtimit, hipoteka,
pengu, të drejtat nga kontrata me dorëzaninë, e drejta në kamatë, dënimi kontraktues etj.
2. Megjithatë, ceduesi mund t''ia dorëzojë sendin peng pranuesit vetëm në qoftë se pengdhënësi e ka
dhënë pëlqimin për këtë, përndryshe ajo mbetet pranë ceduesit për ta ruajtur për llogari të pritësit.
3. Presupozohet se kanë arritur për pagesë dhe se nuk janë paguar kamatat e ceduara me kërkesën
kryesore.', '2409c427e3cec590ff51026a638ad4675b881a4238a35f7006e054fac11c89e2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":90,"pageEnd":90,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (421, '422', 'Njoftimi i debitorit', '1-2', 'Ligji 04/L-077
Neni 422 - Njoftimi i debitorit

1. Për bartjen e kërkesës nuk nevojitet pëlqimi i debitorit, por ceduesi ka për detyrë ta njoftojë debitorin
mbi cedimin e bërë.
2. Përmbushja e kryer ndaj cedusit para njoftimit mbi cedimin është i plotfuqishëm dhe e shkarkon
debitorin nga detyrimi, por vetëm në qoftë se nuk ka ditur për cedimin, përndryshe detyrimi mbetet dhe
ai ka për detyrë t’ia përmbushë detyrimin cesionarit.', 'd620468fe0836f8a7a765d1acfdad71f1e8f420790f105399ffe78f933fd6ff0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":90,"pageEnd":90,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (422, '423', 'Cedimi i shumëfishtë', null, 'Ligji 04/L-077
Neni 423 - Cedimi i shumëfishtë

Në qoftë se kreditori iu ka ceduar të njëjtën kërkesë personave të ndryshëm, kërkesa i takon cesionarit
për të cilin kreditori e ka njoftuar së pari debitorin përkatësisht i pari i cili i është lajmëruar debitorit.', '150aedaaa9a56eb32a0cdcb1a247b2ee5c53be9f96fc99344f5f46fdfde4aad0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":90,"pageEnd":90,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (423, '424', 'Raporti midis pranuesit dhe debitorit', '1-2', 'Ligji 04/L-077
Neni 424 - Raporti midis pranuesit dhe debitorit

1. Pranuesi ka ndaj debitorit të njëjtat të drejta të cilat ceduesi i ka pasur ndaj debitorit përpara cedimit.
2. Debitori mund t’i theksojë pranuesit përpos prapësimeve që ka ndaj tij edhe ato prapësime të cilat ka
mundur t’ia theksojë ceduesit deri në momentin kur ka mësuar për cedim.', '81992d2dabf965d10485f0b979765d959060baf5bb9cb0613bd41e48c04581b8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":90,"pageEnd":90,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (424, '425', 'Dorëzimi i dokumenteve mbi borxhin', '1-3', 'Ligji 04/L-077
Neni 425 - Dorëzimi i dokumenteve mbi borxhin

1. Ceduesi ka për detyrë t’i dorëzojë pranuesit obligacionin apo dokumentin tjetër mbi borxhin, në qoftë
se ka një gjë të tillë si dhe provat e tjera mbi kërkesën e ceduar dhe mbi të drejtat akcesore.
2. Në qoftë se ceduesi ka kaluar në pranuesin vetëm një pjesë të kërkesës ai ka për detyrë t’i dorëzojë
kopjen e legalizuar të obligacionit ose të ndonjë dokumenti tjetër me të cilin provohet ekzistimi i
kërkesës së ceduar.
3. Ai ka për detyrë që me kërkesën e tij t’i lëshojë vërtetimin e legalizuar mbi cedimin.', '343bb54ea35a7ee7f6092499d2df4c91788ffd1d2989a0baf43a94ae31482903', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":90,"pageEnd":91,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (425, '426', 'Përgjegjësia për ekzistimin e kërkesës', null, 'Ligji 04/L-077
Neni 426 - Përgjegjësia për ekzistimin e kërkesës

Kur cedimi është bërë me anë të kontratës me shpërblim, ceduesi përgjigjet për ekzistimin e kërkesës
në çastin kur është bërë cedimi.', '95b21efc74b79aa70c0bfe5f11c300456f452ceade3a3d457964030621a97a87', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":91,"pageEnd":91,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (426, '427', 'Përgjegjësia për arkëtueshmëri', '1-2', 'Ligji 04/L-077
Neni 427 - Përgjegjësia për arkëtueshmëri

1. Ceduesi përgjigjet për arkëtueshmërinë e kërkesës së ceduar në qoftë se kjo gjë ka qenë
kontraktuar, por vetëm deri në shumën e asaj që ka marrë nga cesionari, si dhe për arkëtueshmërinë e
kamatave, të shpenzimeve rreth cedimit dhe të shpenzimeve të procedurës kundër debitorit.
2. Përgjegjësi më e madhe e ceduesit me mirëbesim nuk mund të kontraktohet.', 'd17d6710a6fed1550a7e69e942f126396c38809e495a474e38ccd1f0483840ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":91,"pageEnd":91,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (427, '428', 'Cedimi në vend të përmbushjes ose me qëllim arkëtimi', '1-4', 'Ligji 04/L-077
Neni 428 - Cedimi në vend të përmbushjes ose me qëllim arkëtimi

1. Kur debitori në vend të përmbushjes së detyrimit të vet ia cedon kreditorit kërkesën e vet ose një
pjesë të saj, në momentin e lidhjes e kontratës mbi cedimin shuhet detyrimi i debitorit deri në shumën e
kërkesës së ceduar.
2. Kur debitori ia cedon kreditorit të vet kërkesën e vet vetëm me qëllim arkëtimi, detyrimi i tij shuhet,
respektivisht zvogëlohet vetëm kur kreditori e arkëton kërkesën e ceduar.
3. Në të dy rastet cesionari ka për detyrë t’ia dorëzojë ceduesit të gjitha ato që ka arkëtuar përtej
shumës së kërkesës së vet ndaj ceduesit.
4. Në rastin e cedimit me qëllim arkëtimi, debitori i kërkesës së ceduar mund ta përmbushë detyrimin e
vet edhe ndaj ceduesit, madje edhe kur është i njoftuar për cedimin.', '0f039891ca8cd4f92df7bd966237a00482482e099719fa8c5816dcddad549168', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":91,"pageEnd":91,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (428, '429', 'Cedimi me qëllim sigurimi', null, 'Ligji 04/L-077
Neni 429 - Cedimi me qëllim sigurimi

Kur cedimi është bërë me qëllim të sigurimit të kërkesës së cesionarit kundër ceduesit, cesionari ka për
detyrë të sillet me kujdesin e ekonomistit të mirë, përkatësisht të shtëpiakut të mirë mbi arkëtimin e
kërkesës së ceduar dhe pas arkëtimit të kryer, pasi të ndalë aq sa nevojitet për të përmbushur
kërkesën e vet ndaj ceduesit, t’ia dorëzojë këtij tepricën.', '40e6a94d1b2a71208e5c9a4dc6ec17193846930eb92cf5e0fe75267edf9b7669', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":91,"pageEnd":91,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (429, '430', 'Kontrata për marrjen përsipër të borxhit', '1-5', 'Ligji 04/L-077
Neni 430 - Kontrata për marrjen përsipër të borxhit

1. Marrja përsipër e borxhit bëhet me kontratën midis debitorit dhe marrësit përsipër të borxhit; për të
cilën kreditori ka dhënë pëlqimin.
2. Për kontratën e lidhur kreditorin mund ta njoftojë secilin prej tyre, dhe secilit prej tyre kreditori mund
t’ia komunikojë pëlqimin e vet për marrjen përsipër të borxhit.
3. Presupozohet se kreditori e ka dhënë pëlqimin , në qoftë se pa kufizim ka pranuar ndonjë
përmbushje nga marrësi përsipër të borxhit, të cilën ky i fundit e ka bërë ky në emër të vet.
4. Kontraktuesit, por edhe secili prej tyre veç e veç, mund ta ftojnë kreditorin që në afat të caktuar të
deklarohet se a pajtohet ose jo me marrjen përsipër të borxhit, dhe në qoftë se kreditori nuk deklarohet
brenda afatit të caktuar, konsiderohet se nuk e ka dhënë pëlqimin e vet.
5. Kontrata mbi marrjen përsipër të borxhit ka efektin e kontratës mbi marrjen përsipër të përmbushjes,
përderisa kreditori nuk e jep pëlqimin e vet për kontratën mbi marrjen përsipër të borxhit si dhe nëse ai
refuzon ta jep pëlqimin.', '709f0d909e44a06b2351b671bd4a51a8b004350e557e8e8c066e7ca73f18694c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":92,"pageEnd":92,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (430, '431', 'Borxhi i siguruar me hipotekë', '1-2', 'Ligji 04/L-077
Neni 431 - Borxhi i siguruar me hipotekë

1. Kur me rastin e tjetërsimit të ndonjë sendi të palujtshëm mbi të cilin ekziston hipoteka e kontraktuar
ndërmjet fituesit dhe tjetërsuesit, se fituesi do ta marrë përsipër borxhin ndaj kreditorit hipotekar,
konsiderohet se kreditori hipotekar e ka dhënë pëlqimin për kontratën për marrjen përsipër të borxhit,
në qoftë se ftesën me shkrim të tjetërsuesit nuk e ka refuzuar brenda tre (3) muajve nga marrja e
ftesës.
2. Në ftesën me shkrim duhet tërhequr vërejtja kreditorit për këtë pasojë, përndryshe ftesa do të
konsiderohet sikur të mos jetë dërguar.', 'e09315921430c4c7b525294d3de8a67f573e81d4c0d7c38a100d87ae8b0b330e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":92,"pageEnd":92,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (431, '432', 'Ndërrimi i debitorit', '1-3', 'Ligji 04/L-077
Neni 432 - Ndërrimi i debitorit

1. Me marrjen përsipër të borxhit, marrësi vëhet në vendin e debitorit të mëparshëm, ndërsa ky lirohet
nga detyrimi.
2. Në qoftë se në kohën e dhënies së pëlqimit të kreditorit për kontratën mbi marrjen përsipër të borxhit
marrësi ka qenë i zhytur në borxhe , ndërsa kreditori për këtë nuk ishte në dijeni dhe as nuk duhej të
ishte në dijeni, debitori i më parashëm nuk lirohet nga detyrimi, kurse kontrata mbi marrjen përsipër të
borxhit e ka efektin e kontratës për hyrje borxh. Presupozohet se në kohën e dhënies së pëlqimit për
marrjen e borxhit përsipër, kreditori nuk e ka ditur se marrësi përsipër të borxhit ka qenë i zhytur në
borxhe.
3. Ndërmjet marrësit përsipër të borxhit dhe kreditorit mbetet i njëjti detyrim, i cili ka ekzistuar deri
atëherë ndërmjet debitorit paraprak dhe kreditorit.', '06ef09463bf1cc3e3203ffd91fbb93345a1892c9bac9b70ced2b26299555a691', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":92,"pageEnd":93,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (432, '433', 'Të drejtat akcesore', '1-2', 'Ligji 04/L-077
Neni 433 - Të drejtat akcesore

1. Të drejtat akcesore të cilat kanë ekzistuar deri atëherë bashkë me kërkesën mbeten edhe më tutje,
por dorëzanitë dhe pengjet që kanë dhënë personat e tretë pushojnë së ekzistuari në qoftë se
dorëzanët e pengdhënësit nuk pajtohen të përgjigjen edhe për debitorin e ri. Pëlqimi jepet në formën e
cila vlen për punën juridike me të cilën krijohet ajo e drejtë akcesore.
2. Në qoftë se nuk është kontraktuar diçka tjetër, marrësi përsipër i borxhit nuk përgjigjet për kamatat e
papaguara, të cilat kanë arritur për pagesë deri ditën e marrjes përsipër të borxhit. E njëjta gjë vlen
edhe për dënimin e kontraktuar që ka arritur për pagesë para se të bëhet e plotfuqishme marrja
përsipër e borxhit.', 'ac30fcb0833a84b4cae6c6c3bae19e5f41dd1b689f932ea27db27a65419afa10', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":93,"pageEnd":93,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (433, '434', 'Kundërshtimet', '1-2', 'Ligji 04/L-077
Neni 434 - Kundërshtimet

1. Marrësi përsipër i borxhit mund të paraqes ndaj kreditorit të gjitha kundërshtimet të cilat rrjedhin nga
marrëdhënia juridike ndërmjet debitorit të mëparshëm dhe kreditorit, nga e cila del borxhi i marrur
përsipër, si dhe kundërshtimet që i ka marrësi përsipër i borxhit ndaj kreditorit.
2. Marrësi përsipër i borxhit nuk mund të paraqes ndaj kreditorit kundërshtime të cilat rrjedhin nga
marrëdhënia e tij juridike me debitorin e mëparshëm, dhe e cila marrëdhënie ka qenë bazë e marrjes
përsipër të borxhit.', '3f0981c89aab1c88e80ea0c618e0f0ec62e8cc191e0a644dad5688f03953a0fd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":93,"pageEnd":93,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (434, '435', 'Kontrata për hyrjen në borxh', null, 'Ligji 04/L-077
Neni 435 - Kontrata për hyrjen në borxh

Kontrata për hyrjen në borxh është ajo kontratë ndërmjet kreditorit dhe personit të tretë, me të cilën
personi i tretë detyrohet ndaj kreditorit se do ta përmbushë kërkesën e tij që ka nga debitori, i treti hyn
në detyrim krahas debitorit.', 'ec0108be990d5306b414924cbe5ae786fe5a3dfcf82da5da13a33d64609e2527', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":93,"pageEnd":93,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (435, '436', 'Hyrja në borxh në rastin e pranimit të ndonjë tërësie pasurore', '1-2', 'Ligji 04/L-077
Neni 436 - Hyrja në borxh në rastin e pranimit të ndonjë tërësie pasurore

1. Personi, në të cilin kalon në bazë të kontratës ndonjë tërësi pasurore e personit fizik ose e personit
juridik ose një pjesë e asaj tërësie, përgjigjet për borxhet që kanë të bëjnë me atë tërësi, respektivisht
me pjesën e saj, përpos zotëruesit të deri atëhershëm dhe solidarisht me te, por vetëm deri në vlerën e
aktives së saj.
2. Nuk ka efekt juridik ndaj kreditorëve dispozita e kontratës me të cilën do të përjashtohej ose kufizohej
përgjegjësia e përcaktuar në paragrafin paraprak.', '406ee968c153ccef9a92b4894e772f26871895f888419664a1bd24e1bfe96a79', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":93,"pageEnd":93,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (436, '437', 'Marrja përsipër e përmbushjes', '1-3', 'Ligji 04/L-077
Neni 437 - Marrja përsipër e përmbushjes

1. Marrja përsipër e përmbushjes bëhet me kontratë ndërmjet debitorit dhe ndonjë personi të tretë, me
të cilën personi i tretë detyrohet ndaj debitorit se do ta përmbushë detyrimin e tij ndaj kreditorit të tij.
2. Ai i përgjigjet debitorit, në qoftë se nuk e përmbush me kohë detyrimin e vet ndaj kreditorit, kështu që
kreditori kërkon përmbushjen nga debitori.
3. Ai nuk e merr përsipër atë borxh dhe as që hyn në borxh dhe kreditori nuk ka kurrfarë të drejte ndaj
tij.', '0653224d0014b6c8854f7a25280b7ecfb1739f40a5362f20b45fe2feef37500f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":94,"pageEnd":94,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (437, '438', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 438 - Nocioni

1. Me kontratën e shitjes detyrohet shitësi që sendin të cilin e shet t’ia dorëzojë blerësit dhe t’ia kalojë të
drejtën e pronësisë, ndërsa blerësi detyrohet që shitësit t’ia paguajë çmimin dhe ta pranojë sendin.
2. Shitësi i ndonjë të drejte tjetër detyrohet se blerësit do t’ia kalojë të drejtën e shitur, ndërsa kur
ushtrimi i asaj të drejte kërkon posedimin e sendit, t’ia dorëzojë edhe sendin.', '262e638e8f0154a52bd3aac9e18868f1842161c1dffea3734e37e3b7ec69d4c5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":94,"pageEnd":94,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (438, '439', 'Rreziku', '1-2', 'Ligji 04/L-077
Neni 439 - Rreziku

1. Deri në dorëzimin e sendit blerësit, rrezikun nga shkatërrimi ose dëmtimi i rastësishëm të sendit e
bartë shitësi, ndërsa me dorëzimin e sendit rreziku kalon në blerësin.
2. Rreziku nuk kalon në blerësin, në qoftë se për shkak të të metave të sendit të dorëzuar, ai e ka
zgjidhur kontratën ose ka kërkuar zëvendësimin e sendit.', '0dfb9b5e483ec7ff9634bae44ec1d1e93898e730f2bc957f318997ad56d61e7d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":94,"pageEnd":94,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (439, '440', 'Kalimi i rrezikut në rast të vonesës së blerësit', '1-3', 'Ligji 04/L-077
Neni 440 - Kalimi i rrezikut në rast të vonesës së blerësit

1. Në qoftë se dorëzimi i sendit nuk është bërë për shkak të vonesës së blerësit, rreziku kalon në
blerësin nga çasti kur ai bie në vonesë.
2. Kur objekt i kontratës janë sendet e caktuara sipas llojit, rreziku kalon në blerësin që gjendet në
vonesë, në qoftë se shitësi i ka veçuar sendet e destinuara haptazi për të bërë dorëzimin dhe për këtë
gjë i ka dërguar njoftimin blerësit.
3. Kur sendet e caktuara sipas llojit janë të një natyre të tillë që shitësi nuk mund ta veçojë një pjesë të
tyre, mjafton që shitësi t’i ketë kryer të gjitha veprimet e nevojshme që blerësi të mund t’i merr sendet
dhe për këtë t’ia ketë dërguar njoftimin blerësit.', '9c1c8a104f5cecf41ff72de17d0d2abb5d51de7475c05511f0cd2c896c4ab091', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":94,"pageEnd":95,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (440, '441', 'Rregullat e përgjithshme', '1-3', 'Ligji 04/L-077
Neni 441 - Rregullat e përgjithshme

1. Sendi që është objekt i kontratës duhet të jetë në qarkullim. Është nule kontrata për shitjen e sendit, i
cili është jashtë qarkullimit.
2. Për shitjen e sendeve, qarkullimi i të cilave është i kufizuar vlejnë dispozita të veçanta.
3. Shitja mund të ketë të bëjë edhe me sendin e ardhshëm.', '5179ddf04929ac7d496e239b18f92e001f51ccfff58914fea482deffc2e4c425', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":95,"pageEnd":95,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (441, '442', 'Kur sendi është shkatërruar para kontraktimit', '1-3', 'Ligji 04/L-077
Neni 442 - Kur sendi është shkatërruar para kontraktimit

1. Kontrata e shitjes nuk ka efekt juridik, në qoftë se në momentin e lidhjes së saj sendi që është objekt
i kontratës ka qenë i shkatërruar.
2. Në qoftë se në çastin e lidhjes së kontratës sendi pjesërisht ka qenë i shkatërruar, blerësi mund ta
zgjidhë kontratën ose të mbetet pranë saj me zbritjen proporcionale të çmimit.
3. Megjithatë, kontrata do të mbetet në fuqi dhe blerësi do të ketë vetëm të drejtën e zbritjes së çmimit
në qoftë se shkatërrimi i pjesshëm nuk e pengon realizimin e qëllimit të kontratës, ose në qoftë se për
sendin e caktuar ekziston një zakon i këtillë në qarkullimin juridik.', '504c424bad53f8d150eef39c42485baa1417203624a8ccf2d37d4f11d6a609e6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":95,"pageEnd":95,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (442, '443', 'Shitja e sendit të huaj', null, 'Ligji 04/L-077
Neni 443 - Shitja e sendit të huaj

Shitja e sendit të huaj i detyron palët kontraktuese, mirëpo blerësi që nuk ishte në dijeni ose nuk ka
qenë i detyruar të jetë në dijeni se sendi është i huaj, mundet, po qe se për këtë shkak nuk mund të
realizohet qëllimi i kontratës, ta zgjidhë kontratën dhe të kërkojë shpërblimin e demit.', '8535e1a9639d4f77721fe69f5351ce987215024bee52cb01c2a801d01d6540d5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":95,"pageEnd":95,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (443, '444', 'Shitja e së drejtës së kontestuar', '1-2', 'Ligji 04/L-077
Neni 444 - Shitja e së drejtës së kontestuar

1. E drejta e kontestuar mund të jetë objekt i kontratës së shitjes.
2. Nule është kontrata me të cilën avokati apo urdhërmarrësi tjetër do ta blente të drejtën kontestuese,
realizimi i së cilës i është besuar atij ose do ta kontraktonte për vete pjesëmarrjen në ndarjen e shumës
së caktuar me vendim gjyqësor urdhërdhënësit të tij.', '9b5297941e761fe4d9cde61c9cb356b7c6ff85cd7126aac39990dcb45302dd3c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":95,"pageEnd":95,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (444, '445', 'Kur çmimi nuk është caktuar', '1-3', 'Ligji 04/L-077
Neni 445 - Kur çmimi nuk është caktuar

1. Në qoftë se me kontratën e shitjes çmimi nuk është caktuar, ndërsa as kontrata nuk përmban të
dhëna të mjaftueshme me të cilat do të mund të caktohej çmimi, kontrata nuk ka efekt juridik.
2. Kur me kontratën e lidhur ndërmjet ndërmarrësve nuk është caktuar çmimi dhe as që ka të dhëna të
mjaftueshme me të cilat do të mund të caktohej çmimi, blerësi ka për detyrë të paguajë çmimin të cilin e
ka arkëtuar rregullisht shitësi në kohën e lidhjes së kontratës, e në mungesë të kësaj çmimin e
arsyeshëm.
3. Çmim i arsyeshëm konsiderohet çmimi i ditës (vijues) në kohën e lidhjes së kontratës dhe nëse
çmimi nuk mund të përcaktohet, atëherë atë e cakton gjykata sipas rrethanave të rastit.', '4d169d086df3b6ab2eccdcd97cd7183165732e103bfceae02f3a30ecfaf5a8d2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":96,"pageEnd":96,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (445, '446', 'Çmimi i caktuar', null, 'Ligji 04/L-077
Neni 446 - Çmimi i caktuar

Kur është kontraktuar çmimi më i lartë se që është ai për llojin e caktuar të sendeve që e ka caktuar
organi kompetent, blerësi ka borxh vetëm shumën e çmimit të caktuar; në qoftë se çmimi i kontraktuar
është paguar blerësi ka të drejtë të kërkojë që t’i kthehet diferenca.', 'e734569b5e00bea793c756fcaf65652fbbb68b075a4de7869abbb6e17be7a99c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":96,"pageEnd":96,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (446, '447', 'Kur është kontraktuar çmimi i ditës', '1-2', 'Ligji 04/L-077
Neni 447 - Kur është kontraktuar çmimi i ditës

1. Kur është kontraktuar çmimi i ditës , blerësi paguan çmimin e përcaktuar me evidencë zyrtare në
tregun e vendit të shitësit, në kohën kur është dashur të bëhej përmbushja.
2. Në qoftë se evidencë e tillë nuk ekziston, atëherë çmimi i ditës caktohet në bazë të elementeve me
të cilat sipas dokeve të tregut përcaktohet çmimi.', '454704a2c71bff7dba992cd9ac1edb881342498e113246f5c353b041bebe9e9f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":96,"pageEnd":96,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (447, '448', 'Kur caktimi i çmimit i është besuar personit të tretë', null, 'Ligji 04/L-077
Neni 448 - Kur caktimi i çmimit i është besuar personit të tretë

Në qoftë se personi i tretë, të cilit i është besuar caktimi i çmimit nuk dëshiron ose nuk mundet ta
caktojë çmimin, ndërsa kontraktuesit nuk dakordohen më vonë mbi caktimin e çmimit dhe as që e
zgjidhin kontratën, do të konsiderohet se është kontraktuar çmimi i arsyeshëm.', '288137cc0242bb2d74ad87db5f5a42bda64e668522dec529ee57b1e4202e1d9f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":96,"pageEnd":96,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (448, '449', 'Kur caktimi i çmimit i është lënë njërës palë kontraktuese', null, 'Ligji 04/L-077
Neni 449 - Kur caktimi i çmimit i është lënë njërës palë kontraktuese

Dispozita e kontratës me të cilën caktimi i çmimit i lihet në vullnetin e njërës palë kontraktuese
konsiderohet sikur të mos ishte kontraktuar fare. Në këtë rast, blerësi ka borxh çmimin sikur në rastin
kur çmimi nuk është caktuar.', '00ee53382bd8d5fb97d54310d26d3444e5a06650fcbf200662bce2897d3a5ecb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":96,"pageEnd":96,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (449, '450', 'Koha dhe vendi i dorëzimit', '1-2', 'Ligji 04/L-077
Neni 450 - Koha dhe vendi i dorëzimit

1. Shitësi ka për detyrë t’ia dorëzojë sendin blerësit në kohën dhe në vendin e parashikuar me kontratë.
2. Shitësi e ka kryer parimisht detyrimin e dorëzimit ndaj blerësit, kur ai (shitësi) ia dorëzon blerësit
sendin apo ia dorëzon dokumentin me të cilin mund të merret sendi.', '7b5554e64dd196f9c40726f8857bbff940dd4d7c7323e0e448ebd2026eec4557', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":97,"pageEnd":97,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
