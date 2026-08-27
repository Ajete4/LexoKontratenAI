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
  (150, '151', 'Përgjegjësia në bazë të drejtshmërisë', '1-2', 'Ligji 04/L-077
Neni 151 - Përgjegjësia në bazë të drejtshmërisë

1. Në rast se shkaktohet dëmi, të cilën e ka shkaktuar personi, i cili për atë dëm nuk ka qenë
përgjegjës, ndërsa shpërblimi nuk mund të nxirret nga personi, i cili e ka pasur për detyrë të kryejë
mbikëqyrjen mbi te, gjykata mundet, kur këtë e kërkon drejtshmëria, e sidomos duke marrë parasysh
gjendjen materiale të dëmtuesit dhe të të dëmtuarit, ta gjykojë dëmtuesin që ta shpërblejë dëmin
tërësisht ose pjesërisht.
2. Në qoftë se dëmin e ka shkaktuar i mituri me aftësi për të gjykuar, i cili nuk është në gjendje ta
shpërblejë, gjykata mundet, kur këtë e kërkon drejtshmëria, e sidomos duke marrë parasysh gjendjen
materiale të prindërve dhe të dëmtuesit, t`i detyrojë prindërit ta shpërblejnë dëmin, tërësisht ose
pjesërisht.', '26c4f356292193f775e4deb69463719a324a7c4ec0beebe10aefff9e5f6f5df3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":33,"pageEnd":33,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (151, '152', 'Përgjegjësia e punëdhënësit', '1-5', 'Ligji 04/L-077
Neni 152 - Përgjegjësia e punëdhënësit

1. Personi juridik ose fizik me të cilin punonjësi ka punuar në kohën e shkaktimit të dëmit është
përgjegjës për dëmin e shkaktuar ndaj personit të tretë nga punonjësi gjatë punës apo në lidhje me
punën, përveç nëse provohet se punonjësi ka vepruar ashtu siç ka qenë e nevojshme në rrethanat
konkrete.
2. Pala e dëmtuar ka të drejtë të kërkojë shpërblimin e dëmit drejtpërdrejt nga punonjësi në rast se
dëmin e ka shkaktuar me dashje.
3. Secili person që dëmshpërblen palën e dëmtuar për dëmin e shkaktuar nga punonjësi me dashje apo
nga pakujdesia e rende ka të drejtë të kërkojë kthimin e shumës së paguar nga punonjësi.
4. Kjo e drejtë shuhet gjashtë (6) muaj pas ditës së pagesës së kompensimit.
5. Me dispozitën e paragrafit 1. të këtij neni nuk preket në rregullat e përgjegjësisë për dëmin e
shkaktuar nga sendet e rrezikshme ose nga veprimtaritë e rrezikshme.', '73397c787eac3a765c0fcc72cac92a9d69447053fd26ebd38832d2f4595a06fd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":33,"pageEnd":34,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (152, '153', 'Përgjegjësia e personit juridik për dëmin e shkaktuar nga organi i tij', '1-3', 'Ligji 04/L-077
Neni 153 - Përgjegjësia e personit juridik për dëmin e shkaktuar nga organi i tij

1. Personi juridik përgjigjet për dëmin të cilin organi i tij ia shkakton personit të tretë gjatë ushtrimit ose
lidhur me ushtrimin e funksioneve të tij.
2. Në qoftë se për rastin e caktuar nuk është parashikuar ndryshe me ligj, personi juridik ka të drejtë në
shpërblim nga personi i cili e ka shkaktuar dëmin me dashje ose nga pakujdesia e rëndë.
3. Kjo e drejtë parashkruhet brenda afatit prej gjashtë (6) muajsh nga dita e pagimit të shpërblimit të
dëmit.', '18aae0f92e541cb407dd75d4cb471b6a5969cef7db46024dbda6da48eba54944', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":34,"pageEnd":34,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (153, '154', 'Prezumimi i kauzalitetit', null, 'Ligji 04/L-077
Neni 154 - Prezumimi i kauzalitetit

Dëmi i shkaktuar lidhur me sendin e rrezikshëm, përkatësisht me veprimtarinë e rrezikshme
konsiderohet se rrjedh nga ky send, përkatësisht nga kjo veprimtari, përveç nëse provohet se ato nuk
kanë qenë shkak i dëmit.', '9a91d5b89eda5652fd854b8b587c9cc499d1aa5e241f78209d2f4db040fcf5f3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":34,"pageEnd":34,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (154, '155', 'Kush përgjigjet për dëmin', null, 'Ligji 04/L-077
Neni 155 - Kush përgjigjet për dëmin

Për dëmin nga sendi i rrezikshëm përgjigjet zotëruesi i saj, kurse për dëmin nga veprimtaria e
rrezikshme përgjigjet personi që merret me të.', '692eab4199e1b72c6baf9cbd3914fe92137200eefeae97a4998e7999d3fa14eb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":34,"pageEnd":34,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (155, '156', 'Marrja e kundërligjshme e sendit të rrezikshëm nga zotëruesi', null, 'Ligji 04/L-077
Neni 156 - Marrja e kundërligjshme e sendit të rrezikshëm nga zotëruesi

Në qoftë se pronarit i është marre sendi i rrezikshëm në mënyrë të kundërligjshëm, për dëmin që rrjedh
nga kjo, nuk përgjigjet ai, por ai që ia ka marre sendin e rrezikshëm, në qoftë se pronari nuk është
përgjegjës për këtë.', '5976f6fbeb7eb0858ce8abe21708998d695b87b264f866426f4174ed1f473bb3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":34,"pageEnd":34,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (156, '157', 'Dorëzimi i sendit personit të tretë', '1-4', 'Ligji 04/L-077
Neni 157 - Dorëzimi i sendit personit të tretë

1. Në vend të pronarit të sendit, dhe njësojë si ai, përgjigjet personi të cilit pronari ia ka besuar sendin
që të shërbehet me te, ose personi i cili përndryshe e ka për detyrë ta mbikëqyrë, ndërsa nuk ndodhet
në punë te ai.
2. Përveç tij do të përgjigjet edhe pronari i sendit, po qe se dëmi ka rrjedhë nga ndonjë e metë e
fshehur ose nga veçoria e fshehur e sendit për të cilën pronari nuk ia ka tërhequr vëmendjen.
3. Në këtë rast personi përgjegjës i cili ia ka paguar shpërblimin dëmtuesit ka të drejtë të kërkojë
shumën e plotë të saj nga pronari.
4. Pronari i sendit të rrezikshëm i cili ia ka besuar atë personit që nuk është i aftësuar apo nuk është i
autorizuar të manipulojë me atë, përgjigjet për dëmin që rrjedhë nga ky send.', '939e45004a053ead3d24a9c4202ccf6a14caa458bcc170a8dd46a0fc75f5e0cf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":34,"pageEnd":35,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (157, '158', 'Lirimi nga përgjegjësia', '1-5', 'Ligji 04/L-077
Neni 158 - Lirimi nga përgjegjësia

1. Zotëruesi lirohet nga përgjegjësia në rast se provohet se dëmi rrjedh nga ndonjë shkak që ka
ndodhur jashtë sendit dhe efekti i të cilit nuk ka mundur të parashihet, të mënjanohet ose të evitohet.
2. Zotëruesi i sendit lirohet nga përgjegjësia edhe në rast se provohet se dëmi është shkaktuar vetëm
nga veprimi i palës së dëmtuar ose i personit të tretë gjë të cilën ai nuk ka mundur të parashihte dhe
pasojat e të cilit nuk ka mundur t’i shmangë ose t''i mënjanoje.
3. Zotëruesi lirohet nga përgjegjësia pjesërisht në rast se pala e dëmtuar pjesërisht ka kontribuar në
shkaktimin e dëmit.
4. Në rast se në shkaktimin e dëmit ka kontribuar pjesërisht personi i tretë, ky person i përgjigjet palës
së dëmtuar solidarisht bashkë me zotëruesin e sendit.
5. Personi që e ndihmon zotëruesin në përdorimin e sendit nuk konsiderohet si person i tretë.', 'a3fafbd45b19962f21e5700eebef1783c17ec3d8a50d54938995c96f427bda6c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":35,"pageEnd":35,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (158, '159', 'Përgjegjësia në rast aksidenti të shkaktuar nga mjetet motorike në lëvizje', '1-4', 'Ligji 04/L-077
Neni 159 - Përgjegjësia në rast aksidenti të shkaktuar nga mjetet motorike në lëvizje

1. Në rast aksidenti të shkaktuar nga mjeti motorik në lëvizje që është shkaktuar vetëm për faj të një
zotëruesi zbatohen rregullat për përgjegjësinë në bazë të fajit.
2. Në qoftë se ekziston faji i dyanshëm, secili zotëruesi i mjetit motorik përgjigjet për dëmin e
tërësishëm që e kanë pësuar ata përpjesëtimisht me shkallën e fajit të tyre.
3. Në qoftë se nuk ka fajësi në asnjërën anë, zotëruesi i mjetit motorik përgjigjet në pjesë të barabarta,
në qoftë se rregullat e drejtshmërisë nuk kërkojnë diç tjetër.
4. Për dëmin që e pësojnë personat e tretë zotëruesit e mjeteve motorike përgjigjen solidarisht.', '90870a0750c2c4381e40e19c06b3f13f2dbe9a1d76acf47da9565d516114fd7b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":35,"pageEnd":35,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (159, '160', 'Përgjegjësia e prodhuesit për të metat e sendit', '1-2', 'Ligji 04/L-077
Neni 160 - Përgjegjësia e prodhuesit për të metat e sendit

1. Kush vë në qarkullim ndonjë send të cilin e ka prodhuar e që për shkak të ndonjë të mete për të cilën
ai nuk ka ditur qe përbën rrezik dëmi për personat ose për sendet përgjigjet për dëmin që do të krijohej
për shkak të kësaj të mete.
2. Prodhuesi përgjigjet edhe për cilësitë e rrezikshme të sendeve në qoftë se nuk ka ndërmarrë çdo gjë
që nevojitet për dëmin të cilin ka mundur ta parashihte ta parandalojë me anë të paralajmërimit në
ambalazh të sigurt ose me ndonjë masë tjetër përkatëse.', 'cb1d521b224507aab944f1319ad8dde240980f190affb03466f1756c396c6422', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":35,"pageEnd":35,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (160, '161', 'Përgjegjësia për shkak të akteve terroriste, demonstratave ose manifestimeve publike', null, 'Ligji 04/L-077
Neni 161 - Përgjegjësia për shkak të akteve terroriste, demonstratave ose manifestimeve publike

Shteti ose personi që është dashur të parandalojë këtë sipas dispozitave në fuqi, është përgjegjës për
dëmin e shkaktuar nga vdekja ose lëndimi fizik si rezultat i akteve të terrorizmit ose gjatë
demonstratave dhe manifestimeve publike.', 'fb9c1d304b29bf3e19ba527d3d345b5df313b7a3b430b67ff7d1aea5f6e052dc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (161, '162', 'Përgjegjësia e organizatorëve të manifestimeve', null, 'Ligji 04/L-077
Neni 162 - Përgjegjësia e organizatorëve të manifestimeve

Organizatori i tubimit të një numri të madh njerëzish në ambiente të mbyllura apo të hapura përgjigjet
për dëmin e krijuar me vdekjen ose me lëndimin trupor që pëson dikush për shkak të rrethanave të
jashtëzakonshme që mund të krijohen në situatat e tilla siç janë lëkundja e masës, çrregullimet e
përgjithshme.', 'df077f4c0cdc93e244842230d8372979da575017dc306651c3c9463430bd0a72', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (162, '163', 'Përgjegjësia për zotëruesin e kafshës', '1-2', 'Ligji 04/L-077
Neni 163 - Përgjegjësia për zotëruesin e kafshës

1. Zotëruesi i kafshës së rrezikshme është përgjegjës për dëmin e shkaktuar prej saj.
2. Zotëruesi i kafshës shtëpiake është përgjegjës për dëmin e shkaktuar prej saj, përveç nëse provohet
se zotëruesi ka treguar kujdesin dhe mbikëqyrjen e nevojshme.', 'c96c32afac59c346220736141844590142327e04c64c03851bddda57d1db7bda', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (163, '164', 'Përgjegjësia e zotëruesit të ndërtesës', null, 'Ligji 04/L-077
Neni 164 - Përgjegjësia e zotëruesit të ndërtesës

Zotëruesi i ndërtesës ose i hapësirës nga e cila ka rënë objekti, është përgjegjës për dëmin e shkaktuar
në rast se një objekt i vendosur në mënyrë të rrezikshme ose objekti i hedhur bie nga ndërtesa.', '24714919b79718e0f1444a28250819305e4f8489065db737698d645e09cff61c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (164, '165', 'Përgjegjësia për shembjen e ndërtimit', null, 'Ligji 04/L-077
Neni 165 - Përgjegjësia për shembjen e ndërtimit

Zotëruesi i ndërtimit është përgjegjës për dëmin e shkaktuar në rast se pjesë të një ndërtimi shemben
ose rrëzohen, përveç nëse provohet se ngjarja nuk ka qenë rezultat i cilësisë së papërshtatshme të
ndërtimit dhe se zotëruesi ka bërë çdo gjë për të shmangur rrezikun.', '06adb20a5f9da002e3476e7414fc556efa3e0eebec0720e894691a0a84ff0485', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (165, '166', 'Përgjegjësia për shkak të refuzimit të dhënies së ndihmës së domosdoshme', '1-2', 'Ligji 04/L-077
Neni 166 - Përgjegjësia për shkak të refuzimit të dhënies së ndihmës së domosdoshme

1. Kush pa pasur rrezik për vete e refuzon dhënien e ndihmës personit, jeta ose shëndeti i të cilit janë
rrezikuar haptazi, përgjigjet për dëmin që është shkaktuar nga kjo, në qoftë se ai këtë dëm sipas
rrethanave të rastit është dashur ta parashikonte.
2. Në qoftë se e kërkon drejtshmëria, gjykata mund ta ketë parasysh masën e shpërblimit te dëmit.', 'a7357e6109feb30aba06c6e0a59b6c4c864a4d0e3eda54fc6a155ed712776691', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (166, '167', 'Përgjegjësia lidhur me detyrimin e lidhjes së kontratës', null, 'Ligji 04/L-077
Neni 167 - Përgjegjësia lidhur me detyrimin e lidhjes së kontratës

Personi i cili sipas ligjit është i detyruar të lidhë ndonjë kontratë, ka për detyrë ta shpërblejë dëmin, në
qoftë se me kërkesë të personit të interesuar nuk e lidhë këtë kontratë pa vonesë.', '0700f0c8dd6b61377ffe9da5730daf0b919dce99649f42703f15db4dc67025b3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":36,"pageEnd":36,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (167, '168', 'Përgjegjësia lidhur me ushtrimin e punëve me interes të përgjithshëm', null, 'Ligji 04/L-077
Neni 168 - Përgjegjësia lidhur me ushtrimin e punëve me interes të përgjithshëm

Organizatat që ushtrojnë veprimtari komunale ose ndonjë veprimtari tjetër të ngjashme me interes
publik përgjigjen për dëmin në qoftë se pa shkak të arsyeshëm ndërprejnë ose kryejnë jo me rregull
shërbimin.', 'c29e2ea3b129048a56402a58deac073e2dc8b20cda3bde57bfdde02737d05a42', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":37,"pageEnd":37,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (168, '169', 'Rivendosja e gjendjes së mëparshme dhe shpërblimi në të holla', '1-4', 'Ligji 04/L-077
Neni 169 - Rivendosja e gjendjes së mëparshme dhe shpërblimi në të holla

1. Personi përgjegjës ka për detyrë ta rivendosë gjendjen e cila ka qenë para se të shkaktohet dëmi.
2. Në qoftë se rivendosja e gjendjes së mëparshme nuk e mënjanon plotësisht dëmin, personi
përgjegjës ka për detyrë që për pjesën tjetër të dëmit të japë shpërblimin në të holla.
3. Kur rivendosja e gjendjes së mëparshme nuk është e mundur, apo kur gjykata konsideron se nuk
është e domosdoshme që këtë ta bëjë personi përgjegjës, gjykata do të caktojë që ai t`ia paguajë të
dëmtuarit shumën përkatëse në të holla në emër të shpërblimit të dëmit.
4. Gjykata do t`i gjykojë të dëmtuarit shpërblimin në të holla kur ai këtë e kërkon, me përjashtim kur
rrethanat e rastit konkret e arsyetojnë rivendosjen e gjendjes së mëparshme.', 'fefc537c0e341750dcc40aaa25ff18b27ea93bfe1b979e9cbe6f027a71228727', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":37,"pageEnd":37,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (169, '170', 'Kur arrin për pagesë detyrimi i shpërblimit', null, 'Ligji 04/L-077
Neni 170 - Kur arrin për pagesë detyrimi i shpërblimit

Detyrimi i shpërblimit të dëmit konsiderohet se ka arritur, për pagesë që nga momenti i shkaktimit të
dëmit.', '38f0f68c2f33286fa7e6338518b031123e5bb8f8a80b87bea84c32c986f3561b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":37,"pageEnd":37,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (170, '171', 'Shpërblimi në rast të shkatërrimit të sendeve të marruara në mënyrë të palejueshme', null, 'Ligji 04/L-077
Neni 171 - Shpërblimi në rast të shkatërrimit të sendeve të marruara në mënyrë të palejueshme

Pronarit të sendit të marrur në mënyrë të palejueshme i takon e drejta për shpërblimin e dëmit edhe kur
sendi është shkatërruar për shkak të fuqisë madhore.', 'f479b6e413598004c4302909054b30444988a96fecc53f650492f9442996b682', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":37,"pageEnd":37,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (171, '172', 'Shpërblimi në formë të rentës në të holla', '1-5', 'Ligji 04/L-077
Neni 172 - Shpërblimi në formë të rentës në të holla

1. Në rast të vdekjes, të lëndimit trupor ose të dëmtimit të shëndetit, shpërblimi caktohet, sipas
rregullës, në formë të rentës në të holla, për gjithë jetën ose për një kohë të caktuar.
2. Renta në të holla e gjykuar në emër të shpërblimit të dëmit paguhet për çdo muaj përpara, në qoftë
se gjykata nuk cakton diç tjetër.
3. Kreditori ka të drejtë të kërkojë sigurim të nevojshëm për pagimin e rentës, përveç nëse kjo sipas
rrethanave të rastit nuk do të ishte e arsyeshme.
4. Në qoftë se debitori nuk e jep sigurimin të cilin e cakton gjykata, kreditori ka të drejtë të kërkojë që në
vend të rentës t`i paguhet një shumë e përgjithshme, lartësia e të cilit do të caktohet sipas lartësisë së
rentës dhe kohëzgjatjes së mundshme të jetës së kreditorit, me zbritje të kamatave përkatëse.
5. Për shkaqe serioze kreditori mundet edhe në raste të tjera të kërkojë menjëherë ose më vonë, që në
vend të rentës t`i paguhet një shumë e përgjithshme.', '083efabb7f1264d874c0b753e98c52aa8a75aa14ddd80b70af7d0447cb8bcd1a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":37,"pageEnd":38,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (172, '173', 'Dëmi i real dhe fitimi i humbur', '1-4', 'Ligji 04/L-077
Neni 173 - Dëmi i real dhe fitimi i humbur

1. I dëmtuari ka të drejtë si për shpërblimin e dëmit të rëndomtë, ashtu edhe për shpërblimin e fitimit të
humbur.
2. Lartësia e shpërblimit të dëmit caktohet sipas çmimeve në kohën e nxjerrjes së vendimit gjyqësor,
përveç nëse me ligj parashihet diçka tjetër.
3. Gjatë vlerësimit të lartësisë së fitimit të humbur merret në konsiderim fitimi që ka mundur të pritej në
mënyrë të bazuar sipas rrjedhjes së rregullt të gjërave ose sipas rrethanave të veçanta, e realizimi i të
cilit është penguar nga veprimi i dëmtuesit ose nga lëshimi që të ndërmerr veprimin.
4. Kur sendi është shkatërruar ose dëmtuar me vepër penale të kryer me dashje, gjykata mund të
caktojë lartësinë e shpërblimit sipas vlerave që ka pasur sendi për të dëmtuarin.', '63edc4c19810eefb8f8cd9f289b1da99c47aaedaef1d4aa444e1c356fa485441', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":38,"pageEnd":38,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (173, '174', 'Shpërblimi i plotë', null, 'Ligji 04/L-077
Neni 174 - Shpërblimi i plotë

Gjykata, duke marrë parasysh edhe rrethanat që janë shkaktuar pas shkaktimit të dëmit, do të gjykojë
shpërblimin në një shumë e cila është e nevojshme që gjendja materiale e të dëmtuarit të sillet në atë
gjendje në të cilën do të kishte qenë po të mos kishte veprim dëmtues ose mosveprim.', '6bca383fc9d679e5b405e2ea38af0ee24cdeaebef26234053518688cf0dfa253', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":38,"pageEnd":38,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (174, '175', 'Zvogëlimi i shpërblimit', '1-2', 'Ligji 04/L-077
Neni 175 - Zvogëlimi i shpërblimit

1. Gjykata mundet, duke pasur kujdes për gjendjen materiale të të dëmtuarit, ta gjykojë personin
përgjegjës ta paguajë shpërblimin më të vogël nga shuma e dëmit, në qoftë se dëmi nuk është
shkaktuar as me dashje e as nga pakujdesia rende, ndërsa personi përgjegjës është në gjendje të
rende materiale, kështu që pagimi i shumës së plotë do ta sjellte në skamje.
2. Në qoftë se dëmtuesi ka shkaktuar dëm duke punuar diç për dobi të të dëmtuarit, gjykata mund të
caktojë shpërblim më të vogël, duke pasur parasysh kujdesin që tregon dëmtuesi në punët vetjake.', 'aaba42f9d0b465a73323579c7c389284fa002e294c00d5a9ce01aa96b3fb1e63', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":38,"pageEnd":38,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (175, '176', 'Përgjegjësia e ndarë', '1-4', 'Ligji 04/L-077
Neni 176 - Përgjegjësia e ndarë

1. I dëmtuari i cili ka kontribuar që dëmi të krijohet ose të jetë më i madh se sa përndryshe do të ishte,
ka të drejtë vetëm në shpërblimin përpjesëtimisht të pakësuar.
2. Për paragrafin paraprak vihen përshtatshmërisht në zbatim dispozitat për përgjegjësinë për
përfaqësuesin ligjor dhe ndihmësin.
3. Kur është e pamundur të vërtetohet se cila pjesë e dëmit rezulton nga veprimi i të dëmtuarit, gjykata
do të gjykojë shpërblimin duke pasur parasysh rrethanat e rastit.
4. Dëmtuesi dhe i dëmtuari mbajnë barrën e provës për kontributin e atij tjetrit në shkaktimin dhe për
kauzalitetin e këtij kontributi për dëmin dhe lartësinë e tij.', '7803347beda71f50b8fac4778800fe229f0fed43d35fba5c569e3ea3862e4f08', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":38,"pageEnd":39,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (176, '177', 'Humbja e fitimit dhe shpenzimet e mjekimit dhe të varrosjes', '1-2', 'Ligji 04/L-077
Neni 177 - Humbja e fitimit dhe shpenzimet e mjekimit dhe të varrosjes

1. Kush shkakton vdekjen e ndokujt ka për detyrë që t`i shpërblejë shpenzimet e zakonshme të varrimit
të tij.
2. Ai ka për detyrë të shpërblejë edhe shpenzimet e mjekimit të tij nga lëndimet e marrura dhe
shpenzimet e tjera të nevojshme lidhur me mjekimin dhe fitimin e humbur për shkak të paaftësisë për
punë.', 'd94ca4bbc3c1398df1bf46253ba7cdf50702efac118fe844df7acddaec6c0e43', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":39,"pageEnd":39,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (177, '178', 'E drejta e personit të cilin e ka ushqyer i vdekuri', '1-2', 'Ligji 04/L-077
Neni 178 - E drejta e personit të cilin e ka ushqyer i vdekuri

1. Personi, të cilin e ka ushqyer ose e ka ndihmuar rregullisht personi që i është shkaktuar vdekja si
dhe ai që sipas ligjit ka pasur të drejtë të kërkojë ushqim nga personi, të cilit i është shkaktuar vdekja ka
të drejtë të shpërblimit të dëmit që pëson nga humbja e ushqimit ose e ndihmës.
2. Ky dëm shpërblehet me pagimin e rentës në të holla, shuma e së cilës caktohet duke marrë
parasysh të gjitha rrethanat e rastit, e që nuk mund të jetë më e madhe nga ajo që do të fitonte i
dëmtuari nga personi të cilit i është shkaktuar vdekja po të mbetej gjallë.', '21935513d5b7b33f3f4ff3c226a50c8ecc543129d9924aa5b1dc9052c91ce0f7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":39,"pageEnd":39,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (178, '179', 'Shpërblimi i dëmit në rast të lëndimit trupor ose të dëmtimit të shëndetit', '1-2', 'Ligji 04/L-077
Neni 179 - Shpërblimi i dëmit në rast të lëndimit trupor ose të dëmtimit të shëndetit

1. Kush i shkakton tjetrit lëndim trupor ose ia dëmton shëndetin ka për detyrë të shpërblejë shpenzimet
rreth mjekimit dhe shpenzimet tjera të nevojshme lidhur me ketë, si dhe fitimin e humbur për shkak të
paaftësisë për punë gjatë kohës së mjekimit.
2. Në qoftë se i lënduari për shkak të paaftësisë së plotë ose të pjesshme për punë e humb fitimin, ose
nevojat janë shtuar vazhdimisht, ose mundësitë e zhvillimit dhe të përparimit të tij të mëtejshëm janë
zhdukur ose janë pakësuar, personi përgjegjës ka për detyrë t`i paguajë të lënduarit rentën e caktuar
në të holla, si shpërblim për këtë dëm.', 'ca5381337d4c9047cb5873d5ee02344dae627617fcc16b40c7d7ed35c78ae51e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":39,"pageEnd":39,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (179, '180', 'Ndryshimi i shpërblimit të gjykuar', null, 'Ligji 04/L-077
Neni 180 - Ndryshimi i shpërblimit të gjykuar

Gjykata mundet me kërkesë të të dëmtuarit, që për të ardhmen ta rritë rentën, por mundet me kërkesë
të dëmtuesit ta zvogëlojë ose ta heq, në qoftë se kanë ndryshuar në mënyrë të konsiderueshme
rrethanat të cilat gjykata i ka pasur parasysh me rastin e nxjerrjes së vendimit të mëparshëm.', 'a0437e1a7c0092240fef42830cd90a79d1b30627e5d3255bf05e32988a7ef9a7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":39,"pageEnd":39,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (180, '181', 'Mosbartja e të drejtave', '1-2', 'Ligji 04/L-077
Neni 181 - Mosbartja e të drejtave

1. E drejta e shpërblimit të dëmit në formë rente në të holla në rast të vdekjes së personit të afërt ose të
lëndimit trupor ose të shkatërrimit të shëndetit nuk mund t`i bartet personit tjetër.
2. Shumat e shpërblimit, të cilat kanë arritur munden t`i barten tjetrit, në qoftë se lartësia e shpërblimit
është caktuar me marrëveshje të shkruar të palëve ose me aktgjykim të formës së prerë.', '8d223a272f006d59a4fcba51d73cfbfb1f342db77fca406f23aeb09faa6fa374', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":39,"pageEnd":39,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (181, '182', 'Shpallja e aktgjykimit ose ndreqja e gabimit', null, 'Ligji 04/L-077
Neni 182 - Shpallja e aktgjykimit ose ndreqja e gabimit

Në rast të cenimit të së drejtës së personalitetit gjykata mund të urdhërojë shpalljen e aktgjykimit,
përkatësisht të përmirësimit me shpenzim të dëmtuesit, ose të urdhërojë që dëmtuesi ta tërheqë
deklaratën me të cilën është bërë shkelja, ose diç tjetër me të cilën gjë mund të realizohet qëllimi që
arrihet me shpërblim.', 'da483192c8eecbf8a33c0ff6df328ed5a160a160e91168ed0bf52f501b434eed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":40,"pageEnd":40,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (182, '183', 'Shpërblimi në të holla', '1-2', 'Ligji 04/L-077
Neni 183 - Shpërblimi në të holla

1. Për dhembjet e pësuara fizike, për dhembjet e pësuara shpirtërore për shkak të zvogëlimit të
aktivitetit jetësor, të shëmtimit, të cenimit të autoritetit, të nderit, të lirive ose të të drejtave të
personalitetit, të vdekjes së personit të afërm, si dhe frikës, gjykata, po të konstatojë se rrethanat e
rastit sidomos intensiteti i dhembjeve dhe i frikës dhe zgjatja e tyre e arsyetojnë këtë, do të gjykojë
shpërblimin e drejtë në të holla, pavarësisht nga shpërblimi i dëmit material si dhe nga mungesa e
dëmit material.
2. Me rastin e vendosjes për kërkesën për shpërblimin e dëmit jo material, si dhe për lartësinë e
shpërblimit të tij, gjykata do të kujdeset për rëndësinë e cenimit të së mirës dhe të qëllimit të cilit i
shërben ky shpërblim, por edhe për atë, se me te mos të favorizohen synimet që nuk janë në pajtim me
natyrën e saj dhe me qëllimin shoqëror.', '64ab42fe57190742d7f659ed670f374dca4a7eda9b6be04c1dc3fea9d611b08d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":40,"pageEnd":40,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (183, '184', 'Personat që kanë të drejtë shpërblimi në të holla në rast vdekjeje ose invaliditeti të rëndë', '1-4', 'Ligji 04/L-077
Neni 184 - Personat që kanë të drejtë shpërblimi në të holla në rast vdekjeje ose invaliditeti të rëndë

1. Në rast vdekjeje të ndonjë personi, gjykata mund t`ua caktojë anëtarëve të familjes së tij të ngushtë
(bashkëshortit, fëmijët dhe prindërit) shpërblim të drejtë në të holla për dhembjen e tyre shpirtërore.
2. Ky shpërblim mund t`u caktohet edhe vëllezërve dhe motrave në qoftë se ndërmjet tyre dhe personit
të vdekur ka ekzistuar bashkëjetesa e vazhdueshme.
3. Në rast të invaliditetit tejet të rëndë ose shëmtimit në shkallë të lartë të ndonjë personi, gjykata mund
tu caktojë bashkëshortit, fëmijëve dhe prindërve shpërblim të drejtë në të holla për dhembjet e tyre
shpirtërore.
4. Shpërblimi nga paragrafi 1. dhe 3. i këtij neni mund t`i caktohet edhe bashkëshortit jashtë martesor
në qoftë se ndërmjet tij dhe të vdekurit, përkatësisht të lënduarit ka ekzistuar bashkëjetesa e
vazhdueshme.', '4bc98bf9be3838094eb38c43aadebd237cf9c74e0e1c81d8b504969e6644e2c4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":40,"pageEnd":40,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (184, '185', 'Shpërblimi në të holla në raste të veçanta (Cenimi i dinjitetit)', null, 'Ligji 04/L-077
Neni 185 - Shpërblimi në të holla në raste të veçanta (Cenimi i dinjitetit)

E drejta e shpërblimit të dëmit në të holla për shkak të dhembjeve shpirtërore të pësuara i takon
personit, i cili me anë të mashtrimit, dhunës ose të shpërdorimit të ndonjë raporti nënshtrimi ose
varësie, është shtytur në marrëdhënie të dënueshme seksuale ose në veprim të dënueshëm seksual të
panatyrshëm, si dhe personi ndaj të cilit është kryer ndonjë vepër tjetër penale kundër dinjitetit të
personalitetit dhe moralit.', '2d06c66a88eccf636f3f80aad642ec775296ada11b99874656677595f6267174', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":40,"pageEnd":40,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (185, '186', 'Shpërblimi i dëmit të ardhshëm', null, 'Ligji 04/L-077
Neni 186 - Shpërblimi i dëmit të ardhshëm

Gjykata, me kërkesën e të dëmtuarit, do të caktojë shpërblimin edhe për dëmin e ardhshëm jo material
në qoftë se sipas rrjedhës së rregullt është e sigurt së ai do të vazhdojë edhe në të ardhmen.', 'fd117a4c356763a27f3986a02c3484480a5d729b93f12644875c3158d18c7021', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":40,"pageEnd":40,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (186, '187', 'Shpërblimi në të holla për personin juridik', null, 'Ligji 04/L-077
Neni 187 - Shpërblimi në të holla për personin juridik

Gjykata i jep shpërblim të drejtë në të holla personit juridik për denigrim të reputacionit ose emrit të
mirë, pavarësisht dëmshpërblimit të dëmit material, në rast se gjen se rrethanat e arsyetojnë këtë, qoftë
edhe nëse nuk ka dëm material.', 'a6c292af5c6a6e47e94976d554414d620abc1440d4acae1f770d9092a7e84b2b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":41,"pageEnd":41,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (187, '188', 'Trashëgimi dhe cedimi i kërkesës së shpërblimit të dëmit jo material', '1-2', 'Ligji 04/L-077
Neni 188 - Trashëgimi dhe cedimi i kërkesës së shpërblimit të dëmit jo material

1. Kërkesa e shpërblimit të dëmit jo material i kalon trashëgimtarit vetëm në qoftë se është caktuar me
aktgjykim të formës së prerë ose me marrëveshje me shkrim.
2. Nën kushte të njëjta kjo kërkesë mund të jetë objekt cedimi, kompensimi dhe i përmbarimit të
dhunshëm.', '51d54247483a4ab74b907b98394a19392eeb1b571d3dadedab568bc1eb4c7020', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":41,"pageEnd":41,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (188, '189', 'Përgjegjësia e ndarë dhe zvogëlimi i shpërblimit', null, 'Ligji 04/L-077
Neni 189 - Përgjegjësia e ndarë dhe zvogëlimi i shpërblimit

Dispozitat për përgjegjësinë e ndarë dhe për zvogëlimin e shpërblimit që vlejnë për dëmin material
përshtatshmërisht zbatohen edhe për dëmin jomaterial.', 'f41f5aafb513fc471ae1c3ee588af3f1fe6868d885248f565ab623c0505708da', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":41,"pageEnd":41,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (189, '190', 'Përgjegjësia solidare', '1-4', 'Ligji 04/L-077
Neni 190 - Përgjegjësia solidare

1. Për dëmin të cilin disa persona e kanë shkaktuar bashkërisht, përgjigjen të gjithë pjesëmarrësit
solidarisht.
2. Nxitësi dhe ndihmësi, si dhe ai që ka ndihmuar që personat përgjegjës të mos zbulohen, përgjigjen
solidarisht me këta.
3. Përgjigjen solidarisht për dëmin e shkaktuar edhe personat që e kanë shkaktuar duke punuar
pavarësisht njeri nga tjetri, në qoftë se nuk mund të vërtetohen pjesët e tyre në dëmin e shkaktuar.
4. Kur nuk ka dyshim se dëmin e ka shkaktuar ndonjë nga dy ose nga më tepër persona të caktuar, të
cilët në ndonjë mënyrë janë të ndërlidhur midis tyre, ndërsa nuk mund të përcaktohet se cili prej tyre e
ka shkaktuar dëmin, këta persona përgjigjen solidarisht.', 'b1561584cdf2356bde4b83b491ce7be8cf2a25a92dff2fd59ca544c96dfe2a23', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":41,"pageEnd":41,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (190, '191', 'Përgjegjësia solidare e porositësit dhe e kryesit të punëve', null, 'Ligji 04/L-077
Neni 191 - Përgjegjësia solidare e porositësit dhe e kryesit të punëve

Porositësi dhe kryerësi i punëve në paluajtshmëri përgjigjen solidarisht ndaj personit të tretë për dëmin
që i krijohet këtij lidhur me kryerjen e këtyre punëve.', '3b3ec68f4d50d10be0b117028bb965276d5b5c9c9aecc90d638730578dc0f1c1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":41,"pageEnd":41,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (191, '192', 'Regresi i paguesit', '1-3', 'Ligji 04/L-077
Neni 192 - Regresi i paguesit

1. Debitori solidar i cili paguan më tepër se sa është shuma e pjesës së tij në dëmin e e shkaktuar,
mund të kërkojë prej secilit nga debitorët e tjerë që t`ia shpërblejnë atë që ka paguar për te.
2. Lartësinë e pjesës të secilit debitor veç e veç e cakton gjykata, duke marrë parasysh peshën e
fajësisë së tij dhe peshën e pasojave që kanë dalur nga veprimi i tij.
3. Në qoftë se pjesët e debitorëve nuk mund të vërtetohen, secili ngarkohet me pjesë të barabartë,
përveç nëse drejtshmëria kërkon që në rastin konkret të vendoset ndryshe.', 'c32e54f8e7c1af1d34c291941e2de052baeb93e0aaddb4f6d1c78201d7722822', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":41,"pageEnd":42,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (192, '193', 'E drejta e të dëmtuarit pas parashkrimit të së drejtës për të kërkuar shpërblimin', null, 'Ligji 04/L-077
Neni 193 - E drejta e të dëmtuarit pas parashkrimit të së drejtës për të kërkuar shpërblimin

Pas parashkrimit të së drejtës për të kërkuar shpërblimin e dëmit i dëmtuari mund të kërkojë nga
personi përgjegjës, sipas rregullave që vlejnë në rastin e pasurimit të pa bazë, që t`i cedojë atë që ka
marrë nga veprimi me të cilin është shkaktuar dëmi.', '5c00f50e4444db138e5b19cbdfb2c0c4337c7b0c85cda95a11537a3ea1c9ea41', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":42,"pageEnd":42,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (193, '194', 'Rregullat e përgjithshme', '1-3', 'Ligji 04/L-077
Neni 194 - Rregullat e përgjithshme

1. Secili person që pasurohet pa bazë ligjore në dëm të një tjetrit, është i detyruar të kthejë atë që ka
marrë nga tjetri, ose ndryshe të kompensojë vlerën e fitimit të arritur.
2. Fjala pasurim po ashtu përfshinë përvetësimin e fitimit përmes shërbimeve.
3. Detyrimi për kthim ose kompensim po ashtu lind edhe nëse një person pranon diçka në lidhje me një
bazë që nuk është realizuar ose më pas zhduket.', '5c2fcdd221577ad7430707af4838ad9bb81a1b660197b13000e8dd9e373f9e60', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":42,"pageEnd":42,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (194, '195', 'Kur nuk mund të kërkohet kthimi', null, 'Ligji 04/L-077
Neni 195 - Kur nuk mund të kërkohet kthimi

Kush kryen pagesën duke ditur se nuk e ka për detyrë ta paguajë nuk ka të drejtë të kërkojë kthimin,
përveç nëse e ka rezervuar të drejtën e kërkimit të kthimit, apo në qoftë se e ka paguar për t''iu
shmangur dhunës.', 'd23a7523486faa9b09701e843a40edf7c0e5bf207924b0adcfc2bfb5b942475e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":42,"pageEnd":42,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (195, '196', 'Zbatimi i një detyrimi natyror ose i ndonjë detyre morale', null, 'Ligji 04/L-077
Neni 196 - Zbatimi i një detyrimi natyror ose i ndonjë detyre morale

Nuk mund të kërkohet kthimi i asaj që është dhënë ose është bërë për përmbushjen e çfarëdo lloji
detyrimi natyror ose detyre morale.', 'dd88ec778fdf4b21b466e8bc542d3aababf194405370a3af11a1d595416e2761', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":42,"pageEnd":42,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (196, '197', 'Vëllimi i kthimit', null, 'Ligji 04/L-077
Neni 197 - Vëllimi i kthimit

Kur kthehet ajo që është fituar pa bazë, duhet të kthehen frutet dhe të paguhet kamatëvonesa, e
pikërisht, në qoftë se fituesi është i pandërgjegjshëm, që nga dita e fitimit, e për ndryshe që nga dita e
paraqitjes së kërkesës.', '4025b17224ba78ede8e097fec43c5ba66bfd2370a3fabe770017c46720eb5c7e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (197, '198', 'Kompensimi i shpenzimeve', null, 'Ligji 04/L-077
Neni 198 - Kompensimi i shpenzimeve

Fituesi ka të drejtë në kompensimin e shpenzimeve të domosdoshme dhe të dobishme por në qoftë se
ka qenë i pandërgjegjshëm, kompensimi për shpenzimet e dobishme i takon vetëm deri në shumën që
përbën shtimin e vlerës në momentin e kthimit.', 'a4511de3cc365f5d3493e6554f2453c61283612629c861883d4b64def65009a7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (198, '199', 'Kur mund të mbahet ajo që është marrë', '1-2', 'Ligji 04/L-077
Neni 199 - Kur mund të mbahet ajo që është marrë

1. Nuk mund të kërkohet kthimi i shumave të kompensuara pa bazë në emër të shpërblimit të dëmit për
shkak të lëndimit fizik, dëmtimit të shëndetit ose të vdekjes, në rast se pagesa i është bërë marrësit që
ka vepruar në mirëbesim.
2. Si shumë e paguar pa bazë llogaritet edhe pagesa mbi bazën e një vendimi gjyqësor që më vonë
është ndryshuar ose prishur.', 'b0082dfb6c7164f890bc3b36868468262f4c4388547648e40f75c8c26b756595', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (199, '200', 'Përdorimi i sendit në dobi të tjetrit', null, 'Ligji 04/L-077
Neni 200 - Përdorimi i sendit në dobi të tjetrit

Në qoftë se dikush e ka përdorur sendin e vet apo të tjetrit në dobi të tretit, kurse nuk ka kushte për
aplikimin e rregullave mbi gjerimin e punëve te huaja pa porosi, i treti ka për detyrë ta kthejë sendin,
respektivisht, po qe se kjo s''është e mundur, t''ia shpërblej vlerën e sendit.', 'f1265c03d79c31f7498b15b38ac9b6feb2d95344205014a3981319344fc58c74', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (200, '201', 'Shpenzimi për tjetrin', null, 'Ligji 04/L-077
Neni 201 - Shpenzimi për tjetrin

Kush kryen për tjetrin ndonjë shpenzim ose diçka tjetër që ky e ka pasur për detyrë në bazë të ligjit ta
bëjë, ka të drejtë të kërkojë shpërblim prej tij.', '7f48cd3020e4788d224918b71b2fa9d76fd41d59df0449d37f4d0bd3a60ec8ce', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (201, '202', 'Përdorimi i sendit të huaj në dobi të vet', null, 'Ligji 04/L-077
Neni 202 - Përdorimi i sendit të huaj në dobi të vet

Kur dikush e ka përdorur sendin e huaj për dobi të vet, zotëruesi mund të kërkojë pavarësisht nga e
drejta e shpërblimit të dëmit ose në mungesë të kësaj, që ky t''ia shpërblej përfitimin që ka pasur nga
përdorimi.', '45e329eda9a9f6df30bb2f8bca1609c6c5ab4290741f298ff3b0037d76ae4859', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (202, '203', 'Përkufizimi dhe kushtet', null, 'Ligji 04/L-077
Neni 203 - Përkufizimi dhe kushtet

Një punë e huaj mund të kryhet pa porosi vetëm në qoftë se puna nuk duron shtyrje dhe mund të
shkaktohet dëmi ose humbet qartazi një dobi.', '9afc37436e75b6bc4f7b0e0bb68d40ace19e01bacf34cbcc9ee92f959355eb3d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":43,"pageEnd":43,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (203, '204', 'Detyrat e kryesit të punëve të huaja pa porosi', '1-3', 'Ligji 04/L-077
Neni 204 - Detyrat e kryesit të punëve të huaja pa porosi

1. Kryesi i punëve të huaja pa porosi ka për detyrë ta njoftojë të zotin e punës për veprimin e tij sa ma
parë që është e mundur dhe po ashtu ta njoftojë se do ta vazhdojë punën e filluar, në qoftë se për ketë
ka mundësi të arsyeshme, derisa i zoti i punës të mos mund ta marrë përsipër kujdesin për te.
2. Pas mbarimit të punës, kryesi i punëve të huaja pa porosi ka për detyrë të japë llogari dhe t`ia bartë
atij gjithë atë, çka ka fituar nga kryerja e punës.
3. Në qoftë se me ligj nuk është përcaktuar diçka tjetër, kryesi i punëve të huaja pa porosi ka detyrime
të urdhër marrësit.', 'e3f61c0dee818fe03fafcd25d97ee0ed4a59a498b6530a2b5e598d86a421b907', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":44,"pageEnd":44,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (204, '205', 'Kujdesi i duhur dhe përgjegjësia', '1-4', 'Ligji 04/L-077
Neni 205 - Kujdesi i duhur dhe përgjegjësia

1. Gjatë kryerjes të punës së huaj kryesi i punëve të huaja pa porosi ka për detyrë të udhëhiqet nga
qëllimet faktike ose të supozuara të të zotit të punës.
2. Ai ka për detyrë të veprojë me kujdesin e ekonomistit të mirë, përkatësisht të shtëpiakut të mirë.
3. Gjykata mundet duke marrë parasysh rrethanat në të cilat dikush e ka filluar punën e huaj pa qenë i
thirrur, të zvogëlojë përgjegjësinë e tij ose ta lirojë fare nga përgjegjësia për pakujdesinë.
4. Për përgjegjësinë e kryesit te punëve të huajat pa porosi, i cili është i paaftë si për të vepruar vlejnë
dispozitat për përgjegjësinë e tij kontraktuese dhe jashtë kontraktuese.', '0ad1bdcfda67dd15fdca7f993ec7dd8d340bdfe52a963889dec0aff7c1762320', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":44,"pageEnd":44,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (205, '206', 'Të drejtat e punë drejtuesit pa porosi', '1-2', 'Ligji 04/L-077
Neni 206 - Të drejtat e punë drejtuesit pa porosi

1. Kryesi i punëve të huaja pa porosi që ka vepruar në tërësi siç duhet dhe ka punuar ashtu siç kanë
kërkuar rrethanat, ka të drejtë të kërkojë nga i zoti i punës të lirohet nga të gjitha detyrimet që i ka marrë
përsipër për shkak të kësaj pune, të marrë mbi vete të gjitha detyrimet që i ka lidhur në emër të tij, të
shpërblehet për të gjitha shpenzimet e domosdoshme dhe të dobishme, edhe në qoftë se rezultati i
pritur nuk është arritur.
2. Kryesit të punëve të huaja i takon edhe shpërblimi adekuat për mundin, në qoftë se e ka evituar
dëmin nga i zoti i punës, ose në qoftë se ia ka siguruar përfitimin që në tërësi i përgjigjet qëllimeve dhe
nevojave të tij.', '86ff8bcaeb188eff698a58790154ce39f92703f07494a746dbd6b75fb26eba91', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":44,"pageEnd":44,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (206, '207', 'Kryerja e punëve të huaja me qëllim që t`i ndihmohet tjetrit', null, 'Ligji 04/L-077
Neni 207 - Kryerja e punëve të huaja me qëllim që t`i ndihmohet tjetrit

Kush kryen punët e huaja me qëllim që t`i ndihmojë tjetrit, e nuk janë plotësuar kushtet për punë drejtim
pa porosi, i takon e drejta e shpërblimit të shpenzimeve të bëra, por më së shumti deri në lartësinë e
përfitimit që e ka realizuar tjetri.', 'e10210e4c6e86de7cb43a4ef6668e27b7d5a00bc503f91726fef7b250e225ef2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":44,"pageEnd":44,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (207, '208', 'Marrja me vete e shtesave', null, 'Ligji 04/L-077
Neni 208 - Marrja me vete e shtesave

Çdo punë drejtues pa porosi ka të drejtë t`i marrë me vete sendet me të cilat e ka shtuar pasurinë e
huaj, e për të cilat shpenzimet e bëra nuk i shpërblehen, në qoftë se këto mund të ndahen pa u
dëmtuar sendi të cilit i janë shtuar, por personi në punën e të cilit ka ndërhyrë, mundet t’i mbajë këto
shtesa po qe se ia shpërblen vlerën e tyre të tashme.', '911f5ba495325cb4925c353f9f5bdc2522f86e4fbe625bb7b2840c5a1402019f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":44,"pageEnd":45,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (208, '209', 'Përgjegjësia e kryesit të punëve të huaja', '1-3', 'Ligji 04/L-077
Neni 209 - Përgjegjësia e kryesit të punëve të huaja

1. Kush e kryen punën e huaj përkundër ndalesës së zotit të punës, e për ndalesën ishte në dijeni ose
duhej të ishte në dijeni, nuk i ka të drejtat që i takojnë kryesit të punëve të huaja pa porosi.
2. Ai përgjigjet për dëmin që e ka shkaktuar duke ndërhyrë në punët e huaja, edhe atëherë kur deri te
kjo ka ardhur pa fajin e tij.
3. Kur ndalesa e kryerjes të punës është në kundërshtim me ligjin ose me moralin, e sidomos në qoftë
se dikush ka ndaluar që tjetri ta përmbush ndonjë detyrim të tij ligjor që nuk duron shtyrje, vlejnë
rregullat e përgjithshme për gjerimin e punëve të huaja pa porosi.', 'c045fc00c06c40ad80f7c6bd0fa04b89027bc57944247fbfff13baf6df8fb853', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":45,"pageEnd":45,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (209, '210', 'Gjerimi i paautorizuar për llogari personale', '1-2', 'Ligji 04/L-077
Neni 210 - Gjerimi i paautorizuar për llogari personale

1. Kush e kryen punën e huaj me qëllim që për vete t`i mbajë përfitimet e arritura, edhe pse e di se
puna është e huaj, ka për detyrë që me kërkesë të zotit të punës të japë llogari si punë drejtues pa
porosi dhe t`ia dorëzojë të gjitha përfitimet e arritura.
2. I zoti i punës mund të kërkojë kthimin në gjendje të mëparshme si dhe shpërblimin e dëmit.', '24112d447993ab8b12972d0909e7ba72bfa8d2746acfb6e27b0a0fade4d27c23', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":45,"pageEnd":45,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (210, '211', 'Aprovimi i të zotit të punës', null, 'Ligji 04/L-077
Neni 211 - Aprovimi i të zotit të punës

Në qoftë së i zoti i punës, e aprovon më vonë punën që është kryer, kryesi i punëve të huaja pa porosi
konsiderohet si urdhër marrësi i cili ka punuar që nga fillimi me porosi të të zotit të punës.', '69e74a7b0140fabe5178e9deaeeb08fbc9595c7bc51b89a93db8ec97ea1e68ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":45,"pageEnd":45,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (211, '212', 'Premtimi obligues', '1-2', 'Ligji 04/L-077
Neni 212 - Premtimi obligues

1. Premtimi i shpërblimit i bërë me anë të shpalljes publike për atë që kryen një veprim të caktuar,
arrinë ndonjë sukses, gjendet në situatë të caktuar ose në qoftë se premtimi është bërë në ndonjë
kusht tjetër, e detyron premtuesin që të përmbushë premtimin.
2. Premtuesi i shpërblimit ose i çfarëdo gare shpërblyese ka për detyrë të caktojë afatin e garës, e në
qoftë se nuk e cakton , kush do që dëshiron të marrë pjesë në garë ka të drejtë të kërkojë që gjykata ta
caktojë afatin përkatës.', '3b9993b79a6bbaabacb2014946b7fe8506f617be2e601fd51730a1b1d5a7c899', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":46,"pageEnd":46,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (212, '213', 'Revokimi i premtimit', '1-2', 'Ligji 04/L-077
Neni 213 - Revokimi i premtimit

1. Premtimi mund të revokohet ashtu siç është bërë, si dhe me anë të komunikimit personal, por ai i cili
e ka kryer veprimin e nuk ishte në dijeni e as që duhej të ishte në dijeni se premtimi i shpërblimit është
revokuar ka të drejtë të kërkojë shpërblimin e premtuar, ndërsa ai i cili deri në revokim ka bërë
shpenzime të nevojshme për të kryer veprimet e caktuara në shpalljen publike ka të drejtë të marrë
shpërblimin e tyre me përjashtim të rastit kur premtuesi provon se ato janë bërë pa nevojë.
2. Premtimi i shpërblimit nuk mund të revokohet, në qoftë se me shpallje është caktuar afati për
kryerjen e veprimit përkatësisht për njoftimin për rezultatet e arritura ose për realizimin e situatës së
caktuar.', '158f5d6be3083eaedc41bba1ec524c74f06d94e7ef954de0d41d126f0f2397d4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":46,"pageEnd":46,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (213, '214', 'E drejta në shpërblim', '1-2', 'Ligji 04/L-077
Neni 214 - E drejta në shpërblim

1. Të drejtë në shpërblim ka ai, i cili i pari e kryen veprimin për të cilin është premtuar shpërblimi.
2. Në qoftë se disa persona e kanë kryer veprimin njëkohësisht, secilit i takon pjesa e barabartë e
shpërblimit, në qoftë se drejtshmëria nuk kërkon ndonjë ndarje tjetër.', '3985679c119a5d59c16b758b4c04f24caad5e5101131afdbdc154583accb86a4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":46,"pageEnd":46,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (214, '215', 'Rasti i konkursit', '1-3', 'Ligji 04/L-077
Neni 215 - Rasti i konkursit

1. Për ndarjen e shpërblimit në rastin e konkursit vendos organizatori i konkursit ose një apo disa
persona të caktuar prej tij.
2. Në qoftë se në kushtet e konkursit ose në disa dispozita të përgjithshme që vlejnë për konkurs të
caktuar, janë caktuar rregullat sipas të cilave shpërblimi duhet të ndahet, secili pjesëmarrës në konkurs
ka të drejtë të kërkojë anulimin e vendimit për ndarjen e shpërblimit në qoftë se shpërblimi nuk është
ndarë në pajtim me këto rregulla.
3. Pronësinë ose ndonjë të drejtë tjetër për veprimin ose punën e kryer me konkurs e fiton organizatori i
konkursit vetëm ne qoftë se kjo është theksuar në shpalljen e konkursit.', '01ebe6190ea1f67f0560bb2a4284c1b62a606eeb4a2772307e5acbe0d0d21b9d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":46,"pageEnd":46,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (215, '216', 'Shuarja e detyrimit', null, 'Ligji 04/L-077
Neni 216 - Shuarja e detyrimit

Detyrimi i premtuesit të shpërblimit shuhet në qoftë se askush nuk ia komunikon brenda afatit të caktuar
në shpallje se e ka kryer veprimin apo se ka arritur sukses apo se në përgjegjësi i ka plotësuar kushtet
e parashtruara në shpalljen publike dhe në qoftë se afati nuk është caktuar, atëherë pas një (1) viti nga
dita e shpalljes së bërë.', '19b22f7cc865cf520b549374db7406e4bb380e916bcbe2ec5f8051b374e6cb2b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":47,"pageEnd":47,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (216, '217', 'Përkufizimi', '1-2', 'Ligji 04/L-077
Neni 217 - Përkufizimi

1. Letra me vlerë është dokument me shkrim me të cilin emetuesi (lëshuesi) i saj detyrohet se do ta
përmbushë detyrimin e shkruar në këtë dokument poseduesit të saj të ligjshëm.
2. Një shënim i shkruar në një mjet tjetër konsiderohet letër me vlerë në rast se kështu është përcaktuar
nga një akt i veçantë ligjor.', '798b53ae7baeebfa2d964aa6bb384291aa7f46215e5f21ac2a078d500a80fe45', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":47,"pageEnd":47,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (217, '218', 'Elementet thelbësore', '1-3', 'Ligji 04/L-077
Neni 218 - Elementet thelbësore

1. Letra me vlerë duhet detyrimisht të përmbajë këto elemente thelbësore:
1.1. emërtimin e llojit të letrës me vlerë;
1.2. firmën, përkatësisht emërtimin dhe selinë, përkatësisht emrin dhe vendbanimin e lëshuesit
të letrës me vlerë;
1.3. firmën, respektivisht, emërtimin ose emrin e personit me urdhër të së cilit është dhënë letra
me vlerë ose emërtimin se letra me vlerë i është e pagueshme prurësit;
1.4. detyrimin e shënuar saktë te lëshuesit të letrës me vlerë;
1.5. vendin dhe datën e lëshimit të letrës me vlerë, kurse për ato që lëshohen në seri edhe
numrin e saj të serisë;
1.6. nënshkrimin e lëshuesit të letrës me vlerë, përkatësisht faksimilin e nënshkrimit të lëshuesit
të letrës me vlerë që emetohet në seri.
2. Me ligj të veçantë për ndonjërën nga letrat me vlerë mund të caktohen edhe elementet tjera
thelbësore.
3. Dokumenti i cili nuk përmban njërën nga elementet thelbësore nuk vlen si letër me vlerë.', '0181ac93bd14f00d5748f8bdd2f2a9a36cd86f89353a1b8b2fdcf8d71a8d6a6c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":47,"pageEnd":47,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (218, '219', 'Llojet e letrave me vlerë', null, 'Ligji 04/L-077
Neni 219 - Llojet e letrave me vlerë

Letra me vlerë mund të jetë sipas prurësit, në emër ose sipas urdhrit.', '2180e07471394e9be47efc2a9ab4ce55e6f434df5c1dc6cf3594d2af861b5f7a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":47,"pageEnd":47,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (219, '220', 'Krijimi i detyrimit', null, 'Ligji 04/L-077
Neni 220 - Krijimi i detyrimit

Detyrimi nga letra me vlerë krijohet në çastin kur lëshuesi ia dorëzon letrën me vlerë shfrytëzuesit të
saj.', 'e86c7925922c0867bfbd6c03e33348eeb8db2e139f7359b22308eccf53b55b4d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":48,"pageEnd":48,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (220, '221', 'Kushtet e veçanta për emetimin e letrave me vlerë në seri', null, 'Ligji 04/L-077
Neni 221 - Kushtet e veçanta për emetimin e letrave me vlerë në seri

Me ligj të veçantë mund të caktohen edhe kushtet tjera për emetimin e letrave me vlerë në seri.', '5d7129b90e13ac7923425dab3b15bd031b3f5b82e7c48c3f3827cd7d69f16b44', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":48,"pageEnd":48,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (221, '222', 'Kujt i takon e drejta nga letra me vlerë', '1-4', 'Ligji 04/L-077
Neni 222 - Kujt i takon e drejta nga letra me vlerë

1. Kërkesa nga letra me vlerë është e lidhur për vetë letrën dhe i takon poseduesit të saj të ligjshëm.
2. Si posedues i ligjshëm i letrës me vlerë për prursin konsiderohet prursi i saj.
3. Si posedues i ligjshëm i letrës me vlerë në emër ose sipas urdhrit konsiderohet personi në emrin e të
cilit është dhënë letra me vlerë, përkatësisht personi të cilit i është bartur ajo me rregullsi.
4. Fituesi me mirëbesim i letrës me vlerë sipas prursit ose urdhrit bëhet posedues i saj i ligjshëm dhe
fiton të drejtën e kërkesës të inkorporuar në te edhe kur letra me vlerë të ketë dalur nga dora e
emetuesit të saj, përkatësisht të poseduesit të saj të mëparshëm edhe pa vullnetin e tij.', '51d2d58a3602323a5d1b8ad07f36ec61eb58bf6de422ba53d084dd59137741bd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":48,"pageEnd":48,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (222, '223', 'Kërkesa për përmbushje', null, 'Ligji 04/L-077
Neni 223 - Kërkesa për përmbushje

Përmbushjen e kërkesës nga letra me vlerë mund ta kërkojë me paraqitjen e saj vetëm poseduesi i saj i
ligjshëm ose personi, të cilin ai e autorizon.', '181f7f7780951bcb05e28b1c8a706f6cda492adccdba224a44d6a1875573b087', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":48,"pageEnd":48,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (223, '224', 'Bartja e së drejtës nga letra me vlerë sipas prurësit', null, 'Ligji 04/L-077
Neni 224 - Bartja e së drejtës nga letra me vlerë sipas prurësit

E drejta nga letra me vlerë për prurësin bartet me dorëzimin e saj.', '9f2916ee06b5dbaf71fef3b0b14cc8016b409148e99328a5f643fedc77ef3c1b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":48,"pageEnd":48,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (224, '225', 'Bartja e së drejtës nga letra me vlerë me emër', '1-3', 'Ligji 04/L-077
Neni 225 - Bartja e së drejtës nga letra me vlerë me emër

1. E drejta nga letra me vlerë me emër bartet me cedim.
2. Me ligj të veçantë mund të caktohet që e drejta nga letra me vlerë me emër mund të bartet edhe me
indosament.
3. Bartja e së drejtës nga letra me vlerë me emër bëhet duke shënuar në vetë letrën firmën,
përkatësisht emërtimin, përkatësisht emrin e poseduesit të ri, duke vënë nënshkrimin e bartësit dhe
duke regjistruar bartjen në regjistrin e letrave me vlerë, në qoftë se një regjistër i tillë mbahet nga
lëshuesi.', '48c42da573ae8c63f628e685c9176f3081e0e00ee79267277e35403ebcbe7168', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":48,"pageEnd":48,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (225, '226', 'Bartja të drejtës nga letra me vlerë sipas urdhrit', null, 'Ligji 04/L-077
Neni 226 - Bartja të drejtës nga letra me vlerë sipas urdhrit

E drejta nga letra me vlerë sipas urdhrit bartet me indosament.', '7431e2d6dfb55b639d2eaefb496e4d3d2bee5394aa01c13050ca81133c86afd1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":49,"pageEnd":49,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (226, '227', 'Llojet e indosamentit', '1-6', 'Ligji 04/L-077
Neni 227 - Llojet e indosamentit

1. Indosamenti mund të jetë i plotë, blank dhe sipas prurësit.
2. Indosamenti i plotë përmban deklaratën e transferimit (cedimit), emërtimin ose emrin e personit në të
cilin bartet e drejta nga letra me vlerë (indosatar) dhe nënshkrimin e bartësit (indosantit), por mund të
përmbajë edhe të dhëna të tjera (vendin, datën etj.).
3. Indosamenti blanko përmban vetëm nënshkrimin e indosantit.
4. Në rast të bartjes për prurësin në vend të emrit të indosatorit vihet fjala: “për prurësin”.
5. Indosamenti për prurësin vlen si indosamenti blanko.
6. Indosamenti i pjesshëm është i pavlefshëm.', 'eabd26de16bc85064cb233aecc7143c911316c1255ccb216f86936da9953b77e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":49,"pageEnd":49,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (227, '228', 'Bartja e prokurës dhe bartja për peng', '1-2', 'Ligji 04/L-077
Neni 228 - Bartja e prokurës dhe bartja për peng

1. Letra me vlerë mund të bartet edhe si bartja e prokurës respektivisht si bartja për pengun.
2. Tek bartja e prokurës vihet klauzola: “vlera në prokurë”, ndërsa tek bartja për peng: “ vlera për peng”,
ose të ngjashme.', '2b92dcdb7950e5552b743f717e4d9a12d869e78b2f5e99f3575430a4fa5f3066', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":49,"pageEnd":49,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (228, '229', 'Efekti i bartjes të së drejtës', '1-3', 'Ligji 04/L-077
Neni 229 - Efekti i bartjes të së drejtës

1. Me bartjen e të drejtës nga letra me vlerë poseduesi i saj i ri fiton të gjitha të drejtat që i takojnë
poseduesit paraprak.
2. Bartja e së drejtës nga letra me vlerë me emër, qoftë në rrugën e cedimit ose të indosamentit, nuk ka
efekt ndaj lëshuesit përderisa ky për këtë gjë të mos njoftohet me shkrim, përkatësisht për derisa kjo
bartje të mos regjistrohet në regjistrin e letrave me vlerë me emër, në qoftë se një regjistër i tillë mbahet
tek lëshuesi.
3. Cedenti, përkatësisht indosanti nuk përgjigjet për mos përmbushjen e detyrimit nga ana e lëshuesit ,
përveç rastit të një dispozite tjetër ligjore, ose në qoftë se ekziston një dispozitë e kundërt e shënuar në
vetë letrën me vlerë.', '46b8165530274f73a05b4397d737b9eac57ba4fa10c33b1eb54cbda2142efd8d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":49,"pageEnd":49,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (229, '230', 'Efekti i bartjes së prokurës dhe i bartjes për pengun', null, 'Ligji 04/L-077
Neni 230 - Efekti i bartjes së prokurës dhe i bartjes për pengun

Poseduesi i letrës me vlerë që i është bartur atij si “bartja e prokurës” ose si “ bartja për peng”, mund të
ushtrojë të gjitha të drejtat që rrjedhin nga kjo letër me vlerë, por letrën mund t`ia bartë tjetrit vetëm si
bartje e prokurës.', '35893de0a291027904cf0add9fa77d160613adb564d57859d8db6a66ab62ff1f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":49,"pageEnd":49,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (230, '231', 'Të provuarit e ligjshmërisë së bartjes', '1-2', 'Ligji 04/L-077
Neni 231 - Të provuarit e ligjshmërisë së bartjes

1. Indosatari i fundit provon të drejtën e tij nga letra me vlerë me një varg të pandërprerë
indosamentesh.
2. Kjo rregull zbatohet përshtatshmërisht edhe ndaj cesionarit të fundit.', '8e90a0006ae1797961210e90093ca3f76df131eba6ab2a4bc3f59acef8c04724', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":50,"pageEnd":50,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (231, '232', 'Ndalimi i bartjes', '1-4', 'Ligji 04/L-077
Neni 232 - Ndalimi i bartjes

1. Ndalimi i bartjes me indosament të letrës me vlerë sipas urdhrit bëhet me shprehjen: “jo sipas
urdhrit”, ose duke vënë klauzolë të ngjashme e cila ka domethënie të njëjtë.
2. E drejta nga letra me vlerë, bartja e të cilës është e ndaluar me indosament mund të bartet vetëm me
ane te cedimit.
3. Bartja me indosament mund të ndalohet nga emetuesi dhe indosanti.
4. Me ligj të veçantë ose me deklaratë të lëshuesit të shkruar në vetë letrën me vlerë me emër mund të
ndalohet çdo bartje e saj.', '11c302776abb2df2b90751e4e04c52e20db5adc8e5c2f06eb94e2754cccdc8ed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":50,"pageEnd":50,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (232, '233', 'Ndryshimet që i bën lëshuesi', '1-2', 'Ligji 04/L-077
Neni 233 - Ndryshimet që i bën lëshuesi

1. Letrën me vlerë sipas prurësit ose sipas urdhrit, lëshuesi mund ta ndryshojë në letrën me vlerë në
emër, me kërkesë dhe me shpenzimet e poseduesit të letrës.
2. Në qoftë se ndryshimin nuk e ka ndaluar shprehimisht, lëshuesi i letrës me vlerë me emër mundet
me kërkesë dhe me shpenzime të poseduesit ta ndryshojë këtë letër në letrën sipas prurësit ose sipas
urdhrit.', '2fc1e7bf0ce678a6a5971baa8e3f892081a0dec75d2a3b6b083a558b6f83b6e3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":50,"pageEnd":50,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (233, '234', 'Ndryshimet që bëhen nga poseduesi gjatë bartjes', '1-3', 'Ligji 04/L-077
Neni 234 - Ndryshimet që bëhen nga poseduesi gjatë bartjes

1. Letrën me vlerë sipas urdhrit indosanti mund t`ia bartë me indosament prurësit, në qoftë se me
dispozitë të veçantë nuk është caktuar ndryshe.
2. Cedenti përkatësisht indosanti mund t’ia bartë letrën me vlerë në emër vetëm personit të caktuar.
3. Letra me vlerë sipas prurësit mund t`i bartet me indosament edhe personit të caktuar.', '3e0baa9e10d7d3819bb53299302bc8a637dc0698244a2e905b6c343bf7d412c8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":50,"pageEnd":50,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (234, '235', 'Bashkimi dhe pjesëtimi i letrave me vlerë', '1-2', 'Ligji 04/L-077
Neni 235 - Bashkimi dhe pjesëtimi i letrave me vlerë

1. Letra me vlerë të lëshuara në seri munden me kërkesë dhe me shpenzime të poseduesit të
bashkohen në një ose në disa letra me vlerë.
2. Letra me vlerë mundet me kërkesë dhe me shpenzime të poseduesit të pjesëtohet në disa letra me
vlerë me shuma më të vogla, por këto shuma nuk mund të jenë nën shumën e apoenit më të vogël të
letrës së lëshuara në këtë seri.', 'a774643e153fa71d5c515e87a1466358413fe35fd6c9c4a358a3c04d87e973ff', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":50,"pageEnd":50,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (235, '236', 'Shuarja e detyrimit', '1-3', 'Ligji 04/L-077
Neni 236 - Shuarja e detyrimit

1. Detyrimi nga letra me vlerë shuhet me përmbushjen nga ana e lëshuesit të letrës ndaj poseduesit të
ligjshëm.
2. Kërkesa nga letra me vlerë shuhet edhe kur letra i takon lëshuesit, në qoftë se me ligj të veçantë nuk
është paraparë ndryshe.
3. Lëshuesi me mirëbesim i letrës me vlerë sipas prurësit lirohet nga detyrimi i përmbushjes prurësit
edhe atëherë kur ky (prurësi) nuk është poseduesi i ligjshëm i letrës me vlerë.', 'a28fb92252e1bc8d4d9a7983f3c167e4d6beee34c448592a8a495cb46caad34b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":51,"pageEnd":51,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (236, '237', 'Ndalimi i përmbushjes', '1-2', 'Ligji 04/L-077
Neni 237 - Ndalimi i përmbushjes

1. Në qoftë se lëshuesi i letrës me vlerë sipas prurësit ishte në dijeni ose duhej të ishte në dijeni se
prurësi nuk është posedues i ligjshëm i letrës, e as që është i autorizuar nga poseduesi i ligjshëm, ka
për detyrë ta refuzojë përmbushjen, përndryshe përgjigjet për dëmin.
2. Lëshuesi i letrës me vlerë nuk mund ta përmbushë në mënyrë të vlefshme detyrimin e tij po qe se
këtë gjë ia ka ndaluar organi kompetent, ose kur ishte në dijeni ose duhej të ishte në dijeni se ka filluar
procedura për amortizimin ose anulimin e letrës me vlerë.', '615def308693a0f21747240bd8b187b42c19413f3177a727b2b6caebc7883e29', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":51,"pageEnd":51,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (237, '238', 'Pagimi i kamatës dhe i të ardhurave tjera pas pagimit të kryegjësë', null, 'Ligji 04/L-077
Neni 238 - Pagimi i kamatës dhe i të ardhurave tjera pas pagimit të kryegjësë

Debitori që ia ka paguar kryegjënë poseduesit të letrës me vlerë ka për detyrë t`i paguajë kuponët e
kamatës, përkatësisht të ardhurat tjera nga e njëjta letër që do t`i paraqiten për pagesë pas pagimit të
kryegjësë, në qoftë se këto kërkesa nuk janë parashkruar.', '15d7ed320b9c382c32cc2b0105711cf4ef28178fb25283559be9ca25727173cb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":51,"pageEnd":51,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (238, '239', 'Kundërshtimet në kërkesën për përmbushjen e detyrimit', '1-4', 'Ligji 04/L-077
Neni 239 - Kundërshtimet në kërkesën për përmbushjen e detyrimit

1. Kundër kërkesës së poseduesit të letrës me vlerë, lëshuesi mund të paraqes vetëm kundërshtime të
cilat kanë të bëjnë me lëshimin e vetë letrës, siç është falsifikimi, pastaj kundërshtimet që dalin nga
përmbajtja e letrës, siç janë afatet ose kushtet; e në fund kundërshtimet që ka ndaj vetë poseduesit siç
janë kompensimi, mungesa e procedurës e parashikuar me ligj për fitimin e letrës me vlerë dhe
mungesa e autorizimit.
2. Lëshuesi mundet kundër kërkesës së poseduesit , të cilit ai ia ka ceduar letrën me vlerë, të theksojë
të metat e veprimit juridik në bazë të të cilit është kryer bartja, por këto të meta nuk mund t`i theksojë
kundër kërkesës të ndonjë poseduesi të mëvonshëm.
3. Megjithatë, në qoftë se poseduesi i letrës me vlerë, duke marrë në dorëzim letrën nga paraardhësi i
tij, ishte në dijeni ose duhej të ishte në dijeni se ky po ia dorëzon letrën me vlerë, për të evituar
kundërshtimin të cilin lëshuesi e ka ndaj tij, lëshuesi mund ta paraqesë këtë kundërshtim edhe kundër
poseduesit të letrës.
4. Me ligj të veçantë mund të caktohen edhe lloje të tjera të kundërshtimeve tek disa nga llojet e letrave
me vlerë.', 'ecc6b01f816a660961e6e8584d1ddf77ecfb0506dbe2f24aeaf922a896c63f64', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":51,"pageEnd":51,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (239, '240', 'Letrat legjitimuese', null, 'Ligji 04/L-077
Neni 240 - Letrat legjitimuese

Në biletat hekurudhore, në biletat e teatrove dhe në bileta tjera, në bona (triska) dhe në dokumentet
tjera të ngjashme të cilat përmbajnë një detyrim të caktuar për lëshuesit e tyre, e në të cilat nuk është
shënuar kreditori, e as që prej tyre ose nga rrethanat në të cilat janë lëshuar del se mund t`i cedohen
tjetrit, zbatohen përshtatshmërisht dispozitat përkatëse për letrat me vlerë.', '0a8e1ac66f708b88401dc2eb5865fcce4dfd67728433383b556bbf11c37c9591', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":52,"pageEnd":52,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (240, '241', 'Shenjat legjitimuese', '1-4', 'Ligji 04/L-077
Neni 241 - Shenjat legjitimuese

1. Shenjat e bagazhave ose shenjat tjera të ngjashme, të cilat përbëhen nga një copë letre, metali apo
materiali tjetër, ku zakonisht është shtypur një numër ose shënuar numri i sendeve të dorëzuara, e të
cilat zakonisht nuk përmbajnë diç të caktuar për detyrimin e lëshuesit të tyre, shërbejnë vetëm për të
treguar se kush është kreditor në marrëdhënien e detyrimit me rastin e krijimit të të cilit janë lëshuar.
2. Lëshuesi i shenjës legjitimuese lirohet nga detyrimi kur me mirëbesim këtë ia kryen prurësit, por për
prurësin nuk vlen prezumimi se ai është kreditori i vërtetë ose se është i autorizuar të kërkojë
përmbushjen, kështu që në rast kontesti ka për detyrë të provojë këtë cilësi të tij.
3. Kreditori mund të kërkojë përmbushjen e detyrimit megjithëse e ka humbur shenjen legjitimuese.
4. Për me tepër, në secilin rast konkret duhet përmbajtur vullnetit të përbashkët të lëshuesit dhe
marrësit të shenjës, si dhe të asaj që është e zakonshme.', 'bb33d66bfd1554289a7d6d4886c323ecf1bb5fabb3c51cdd1e1548614c603dac', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":52,"pageEnd":52,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (241, '242', 'Zëvendësimi i letrave me vlerë të dëmtuara', null, 'Ligji 04/L-077
Neni 242 - Zëvendësimi i letrave me vlerë të dëmtuara

Poseduesi i letrës me vlerë të dëmtuar e cila nuk është e përshtatshme për qarkullim, por vërtetësia
dhe përmbajtja e të cilës mund të përcaktohet saktësisht ka të drejtë të kërkojë lëshimin e letrës së re
me vlerë në të njëjtën shumë, me kusht që ta kthejë letrën e dëmtuar me vlerë dhe t`ia shpërblejë
shpenzimet.', 'd276b11710c2b970572ae049488d10f14bfe2caa99fbd252ec0b1de386f5343a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":52,"pageEnd":52,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (242, '243', 'Amortizimi i letrës me vlerë', '1-2', 'Ligji 04/L-077
Neni 243 - Amortizimi i letrës me vlerë

1. Letra me vlerë e humbur mund të shpallet e pavlefshme (e amortizuar).
2. Lëshuesi i letrës me vlerë duhet t’ia ofrojë të gjitha dokumentet e nevojshme zotëruesit të tanishëm
të letrës me vlerë sipas kërkesës së tij, pas rimbursimit të shpenzimet nga i njëjti, si dhe të ofrojë të
gjithë informacionin që zotëruesi kërkon në procedurën e amortizimit.', '71d66046f1ddb649c65186a25c4f5911a350a234e9e174701b596a91fec21376', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":52,"pageEnd":52,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (243, '244', 'Parashkrimi i kërkesave nga letrat me vlerë', null, 'Ligji 04/L-077
Neni 244 - Parashkrimi i kërkesave nga letrat me vlerë

Për parashkrimin e kërkesave nga letrat me vlerë vlejnë rregullat për parashkrimin, në qoftë se me ligj
të veçantë nuk është paraparë ndryshe.', '41f16aa70afa63fa208eac5478cf6e9441c55945d1b74f759a1d65869ce4f97a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":52,"pageEnd":52,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (244, '245', 'Përmbushja e detyrimit dhe pasojat e mos përmbushjes', '1-5', 'Ligji 04/L-077
Neni 245 - Përmbushja e detyrimit dhe pasojat e mos përmbushjes

1. Kreditori në marrëdhënien e detyrimit ka të drejtë që prej debitorit të kërkojë përmbushjen e detyrimit,
ndërsa debitori ka për detyrë ta përmbushë atë me ndërgjegje dhe në tërësi, në përputhje me
përmbajtjen e tij.
2. Kur debitori nuk e përmbush detyrimin ose vonohet me përmbushjen e tij, kreditori ka të drejtë të
kërkojë edhe shpërblimin e dëmit që ka pësuar për këtë shkak.
3. Për dëmin për shkak të vonesës të përmbushjes së detyrimit përgjigjet edhe debitori të cilit kreditori i
ka dhënë një afat të ri të arsyeshëm për përmbushjen e detyrimit.
4. Debitori përgjigjet edhe për pamundësinë e pjesshme apo të plotë të përmbushjes edhe pse kjo
pamundësi nuk është shkaktuar me fajin e tij, në qoftë se është shkaktuar pas rënies në vonesë për të
cilën përgjigjet.
5. Mirëpo, debitori shkarkohet nga përgjegjësia për dëmin në qoftë se provohet se sendi që është
objekti i detyrimit është shkatërruar rastësisht dhe se ai detyrimin e vet e ka përmbushur në kohë.', 'ed3c3d02973cd309593f9de3bb71f0f3df66faad6fb49329176e2ebe81aec595', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":53,"pageEnd":53,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (245, '246', 'Lirimi i debitorit nga përgjegjësia', null, 'Ligji 04/L-077
Neni 246 - Lirimi i debitorit nga përgjegjësia

Debitori lirohet nga përgjegjësia për dëmin në qoftë se provon se nuk ka mundur ta përmbushë
detyrimin e tij, përkatësisht se është vonuar me përmbushjen e detyrimit për shkak të rrethanave të
krijuara pas lidhjes së kontratës të cilat nuk ka mundur t`i parandalojë, t`i evitojë ose t`iu shmanget.', '248aa7853c345a84634ba1cfb6f679f4aad0bec6be1f3d73103737cbbac537c2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":53,"pageEnd":53,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (246, '247', 'Zgjerimi kontraktues i përgjegjësisë', null, 'Ligji 04/L-077
Neni 247 - Zgjerimi kontraktues i përgjegjësisë

Me kontratë mund të zgjerohet përgjegjësia e debitorit edhe për rastet për të cilat ai përndryshe nuk
përgjigjet, përderisa kjo nuk është në kundërshtim me parimin e mirëbesimit dhe të drejtshmërisë.', '7b9bd92e3ce33ca848adb5f4c803228b01c7522377c128b2f14f638bb53cfe92', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":53,"pageEnd":53,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (247, '248', 'Kufizimi dhe përjashtimi i përgjegjësisë', '1-4', 'Ligji 04/L-077
Neni 248 - Kufizimi dhe përjashtimi i përgjegjësisë

1. Përgjegjësia e debitorit për dashjen ose pakujdesinë e rëndë nuk mund të përjashtohet paraprakisht
me kontratë.
2. Megjithatë, gjykata me kërkesën e palës së interesuar kontraktuese mund ta anulojë edhe dispozitën
kontraktuese për përjashtimin e përgjegjësisë për pakujdesinë e rëndomtë, në qoftë se një marrëveshje
e tillë ka dalur nga pozita monopoliste e debitorit ose në përgjithësi nga marrëdhënia e pabarabartë e
palëve kontraktuese.
3. Është e vlefshme dispozita e kontratës, me të cilën caktohet shuma më e lartë e shpërblimit, në qoftë
se shuma e caktuar kështu nuk është në disproporcion të hapur me dëmin dhe në qoftë se për rastin e
caktuar nuk është caktuar diçka tjetër me ligj.
4. Në rastin e kufizimit të lartësisë së shpërblimit kreditori ka të drejtë në shpërblim të plotë në qoftë se
pamundësia e përmbushjes së detyrimit është shkaktuar me dashje ose nga pakujdesia e rëndë e
debitorit.', 'fc760b76962fef5e83206f97fee32561f73b9235365a25edc751518d6a7c9b96', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":53,"pageEnd":54,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (248, '249', 'Vëllimi i shpërblimit', '1-5', 'Ligji 04/L-077
Neni 249 - Vëllimi i shpërblimit

1. Kreditori ka të drejtë në shpërblim të dëmit të thjeshtë dhe të fitimit të humbur, të cilat debitori është
dashur t`i parashikonte detyrimisht në kohën e lidhjes së kontratës, si pasoja të mundshme të shkeljes
së kontratës e duke marrë parasysh faktet të cilat i ka pasur të njohura ose është dashur detyrimisht t`i
kishte të njohura.
2. Në rast mashtrimi ose të mos përmbushjes me dashje, si dhe të mos përmbushjes për shkak të
pakujdesisë së rëndë, kreditori ka të drejtë të kërkojë nga debitori shpërblimin e të tërë dëmit, i cili
është shkaktuar për shkak të shkeljes së kontratës, pa marrë parasysh atë se kreditori nuk ka ditur për
rrethana të veçanta, për shkak të të cilave janë shkaktuar ato.
3. Në qoftë se me rastin e cenimit të detyrimit, përveç dëmit për kreditorin është krijuar edhe ndonjë
fitim për të me rastin e caktimit të lartësisë së shpërblimit, do të kihet parasysh në një masë të
arsyeshme.
4. Pala e cila thirret në shkeljen e kontratës ka për detyrë të ndërmerr të gjitha masat e arsyeshme që
të zvogëlohet dëmi i shkaktuar nga kjo shkelje, përndryshe pala tjetër mund të kërkojë zvogëlimin e
shpërblimit.
5. Dispozitat e këtij neni në mënyrë përkatëse zbatohen edhe lidhur me mos përmbushjen e
detyrimeve, të cilat nuk janë krijuar nga kontrata, në qoftë se për ndonjërën prej tyre me këtë ligj nuk
është parashikuar ndryshe.', 'a1434b8c3effb863b2da8e88e879e693237d36780fc49ffb6ce9c4ea3fea5fa1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":54,"pageEnd":54,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (249, '250', 'Fajësia e kreditorit', null, 'Ligji 04/L-077
Neni 250 - Fajësia e kreditorit

Kur për dëmin e shkaktuar ose për madhësinë e tij ose për vështirësimin e pozitës së debitorit ekziston
fajësia e kreditorit ose e personit për të cilin përgjigjet ai, shpërblimi zvogëlohet përpjesëtimisht.', '24716400f2e4a06aff8cfd90ad6d72d73243fa2166ae9133d43cf5e25bd292b5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":54,"pageEnd":54,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (250, '251', 'Përgjegjësia për shkak të lëshimit të njoftimit', null, 'Ligji 04/L-077
Neni 251 - Përgjegjësia për shkak të lëshimit të njoftimit

Pala kontraktuese e cila ka për detyrë ta njoftojë palën tjetër për faktet që kanë ndikim në marrëdhëniet
e tyre reciproke, përgjigjet për dëmin të cilin e ka pësuar pala tjetër për shkak se nuk ka qenë e njoftuar
me kohë.', '3e8634c4c9b5f6fc4aa66f8c73e982735f4c0670aafff88f5c36fa57899e08a9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":54,"pageEnd":54,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (251, '252', 'Zbatimi i dispozitave për shpërblimin e dëmit', null, 'Ligji 04/L-077
Neni 252 - Zbatimi i dispozitave për shpërblimin e dëmit

Në qoftë se me dispozitat e këtij nënkreu nuk është parashikuar ndryshe, ndaj shpërblimit të dëmit për
rastet si në këtë nënkre përshtatshmerisht zbatohen dispozitat e këtij Ligji për shpërblimin e dëmit
jashtë kontraktues.', '0aa8ce1a7315fc48a9fb613ac069fab21f0efb0bf6664ddee1445859d826845d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":55,"pageEnd":55,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (252, '253', 'Rregullat e përgjithshme', '1-3', 'Ligji 04/L-077
Neni 253 - Rregullat e përgjithshme

1. Kreditori dhe debitori mund të kontraktojnë që debitori t`i paguajë kreditorit një shumë të caktuar të
hollash ose t`i sjellë ndonjë përfitim tjetër material në qoftë se nuk e përmbushë detyrimin e tij ose
vonohet me përmbushjen e tij. (dënimi kontraktues).
2. Në qoftë se nuk rrjedh diçka tjetër nga kontrata, konsiderohet se dënimi është kontraktuar për rastin
kur debitori vonohet me përmbushjen e detyrimit.
3. Dënimi kontraktues nuk mund të kontraktohet për detyrime në të holla.', '48cde3c066bc69b4f7a9be59c46dd1552b1e8fb63bce667c96da6c080ed394d5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":55,"pageEnd":55,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (253, '254', 'Mënyra e caktimit', '1-2', 'Ligji 04/L-077
Neni 254 - Mënyra e caktimit

1. Palët kontraktuese mund ta caktojnë lartësinë e dënimit sipas vullnetit të tyre, në një shumë të
përgjithshme, në përqindje ose për çdo ditë vonese, ose në ndonjë mënyrë tjetër.
2. Ajo duhet detyrimisht të jetë e kontraktuar në formën e parashikuar me kontratën nga e cila është
krijuar detyrimi me të cilin ka të bëjë përmbushja.', '944bb4e71ba9d14e87b04a4944ca589e44af2ac5b959b1df9df8a78acb7248b1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":55,"pageEnd":55,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (254, '255', 'Akcesoriteti', '1-2', 'Ligji 04/L-077
Neni 255 - Akcesoriteti

1. Marrëveshja për dënimin kontraktues ndanë fatin juridik të detyrimit me sigurimin e të cilës ka të
bëjë.
2. Marrëveshja humb efektin juridik në qoftë se deri te mos përmbushja ose vonesa ka ardhur nga
shkaku për të cilin debitori nuk përgjigjet.', 'd1b56a6ac604f3a0485ca4bbd0463440c1ff259788da55a490fd87d56c4a47e4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":55,"pageEnd":55,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (255, '256', 'Detyrimi i debitorit', null, 'Ligji 04/L-077
Neni 256 - Detyrimi i debitorit

Kreditori mund të mos kërkoj dënim kontraktues në rast se mos përmbushja ose vonesa ka ndodhur
për arsye për të cilën debitori nuk është përgjegjës.', 'c722419ee28f9e00f501ab15300c4856f4c3dc9053cbe108d49780626c258913', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":55,"pageEnd":55,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (256, '257', 'Të drejtat e kreditorit', '1-5', 'Ligji 04/L-077
Neni 257 - Të drejtat e kreditorit

1. Kur dënimi është kontraktuar për rast të mos përmbushjes së detyrimit, kreditori mund të kërkojë ose
përmbushjen e detyrimit ose dënimin kontraktues.
2. Ai e humbë të drejtën për të kërkuar përmbushjen e detyrimit, në qoftë se ka kërkuar pagimin e
dënimit të kontraktuar.
3. Kur dënimi është kontraktuar për rast të mospërmbushjes, debitori nuk ka të drejtë të paguajë
dënimin kontraktues dhe të heqë dorë nga kontrata, përveç nëse kjo ka qenë qëllimi i kontraktuesve kur
e kanë kontraktuar dënimin.
4. Kur dënimi është kontraktuar për rastin kur debitori vonohet me përmbushjen, kreditori ka të drejtë të
kërkojë edhe përmbushjen e detyrimit edhe dënimin kontraktues.
5. Kreditori nuk mund të kërkojë dënimin kontraktues për shkak të vonesës, në qoftë se e ka pranuar
përmbushjen e detyrimit e nuk ia ka komunikuar pa shtyrje debitorit të drejtën e tij në dënimin
kontraktues.', 'b1e71b2d7c26b6e6cd79e0258d298e24155f229cf8024cb03c498d87cadc6ee9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":55,"pageEnd":56,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (257, '258', 'Zvogëlimi i shumës së dënimit kontraktues', null, 'Ligji 04/L-077
Neni 258 - Zvogëlimi i shumës së dënimit kontraktues

Gjykata me kërkesë të debitorit do të zvogëlojë shumën e dënimit kontraktor në qoftë se gjen se ai
është jo përpjestimisht i lartë, duke marrë parasysh vlerën dhe rëndësinë e objektit të detyrimit.', '43e2a6225fe15212a7f935d945ae12e9ad907356c2721a682062273dd55953e8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":56,"pageEnd":56,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (258, '259', 'Dënimi kontraktues dhe shpërblimi i demit', '1-2', 'Ligji 04/L-077
Neni 259 - Dënimi kontraktues dhe shpërblimi i demit

1. Kreditori ka të drejtë të kërkojë dënimin kontraktues edhe kur shuma e tij e tejkalon lartësinë e dëmit
që ai e ka pësuar, si dhe kur nuk ka pësuar kurrfarë dëmi.
2. Në qoftë se dëmin të cilin e ka pësuar kreditori është më i madh nga sa është shuma e dënimit
kontraktues, ai ka të drejtë të kërkojë diferencën deri në shpërblimin e plotë të dëmit.', '630a0023cee76e707e26057a4182e7e01c99981ee93fa5c8f9df1e97b95d1018', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":56,"pageEnd":56,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (259, '260', 'Shpërblimi i caktuar me ligj dhe dënimi kontraktues', null, 'Ligji 04/L-077
Neni 260 - Shpërblimi i caktuar me ligj dhe dënimi kontraktues

Në qoftë se për mos përmbushjen e detyrimit ose për rastin e vonesës në përmbushjen, lartësia e
shpërblimit e caktuar me ligj nën emërtimin e penaliteteve, dënimit kontraktues, shpërblimit ose në
ndonjë emërtim tjetër, ndërsa palët kontraktuese megjithatë e kanë kontraktuar dënimin, kreditori nuk
ka të drejtë të kërkojë njëkohësisht dënimin kontraktues dhe shpërblimin e caktuar në ligj, përveç nëse
kjo lejohet nga vetë ligji.', '2a2db1422dc22606629bb252117b4a9fd8f454b2aa4bee3dcf15e465662c431c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":56,"pageEnd":56,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (260, '261', 'Rregulla e përgjithshme', '1-3', 'Ligji 04/L-077
Neni 261 - Rregulla e përgjithshme

1. Secili kreditor kërkesa e të cilit ka arritur për pagesë dhe pa marrë parasysh se kur është krijuar,
mund ta kundërshtojë veprimin juridik të debitorit të vet i cili është ndërmarrë në dëm të kreditorit.
2. Konsiderohet se veprimi juridik është ndërmarrë në dëm të kreditorit, në qoftë se për shkak të
zbatimit të tij debitori nuk ka mjete të mjaftueshme për plotësimin e kërkesave të kreditorit.
3. Me veprimin juridik nënkuptohet edhe lëshimi për shkak të të cilit debitori e ka humbur ndonjë të
drejtë pasurore ose me të cilin ndaj tij është krijuar ndonjë detyrim pasuror.', '145752d10a4983ff0183e8b1bc89d18df3d62b05acba7c06e735077ffeff350c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":56,"pageEnd":56,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (261, '262', 'Kushtet e kundërshtimit', '1-4', 'Ligji 04/L-077
Neni 262 - Kushtet e kundërshtimit

1. Disponimi me ngarkesë mund të kundërshtohet në qoftë se në kohën e disponimit debitori ishte në
dijeni ose duhej të ishte në dijeni se me disponimin e ndërmarrë u shkakton dëm kreditorëve të tij dhe
në qoftë se personit të tretë me të cilin ose në dobi të cilit është ndërmarrë veprimi juridik, kjo i ka qenë
e njohur ose ka mundur t`i jetë e njohur.
2. Në qoftë se personi i tretë është bashkëshort i debitorit, ose është i afërm nga gjaku në vijë të drejtë,
ose në vijë të tërthortë deri në shkallën e katërt, ose sipas gjinisë së krushqisë deri në shkallën e dytë,
supozohet se e ka pasur të njohur se debitori me disponimin e ndërmarrur i shkakton dëm kreditorit.
3. Te disponimet pa shpërblim dhe te veprimet juridike të barazuara me to, konsiderohet se debitori e
ka ditur se me disponimet e ndërmarra i sjell dëm kreditorit, dhe për kundërshtimin e këtyre veprimeve
nuk kërkohet që personi i tretë të ketë pasur dijeni ose ka mundur t`i jetë e njohur për të.
4. Heqja dorë nga trashëgimia konsiderohet disponim pa shpërblim.', '3d6d3c22bf40c9b5879360bb977bc9c4af1e8a84fe3a15b89a618352572ae128', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":56,"pageEnd":57,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (262, '263', 'Afati për paraqitjen e padisë', '1-2', 'Ligji 04/L-077
Neni 263 - Afati për paraqitjen e padisë

1. Padia për kundërshtim mund te paraqitet brenda afatit prej një viti për disponimet nga paragrafi 1 i
nenit paraprak, ndërsa për raste tjera brenda afatit prej tre vjetësh.
2. Afati nga paragrafi paraprak llogaritet që nga data kur është ndërmarr veprimi juridik i cili
kundërshtohet, përkatësisht nga dita kur është dashur të ndërmerret veprimi i lëshuar.', '14a2b9e777c4f5d34cdcc21d4ca4a381a882274acaddafc74248eda833e7bb62', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":57,"pageEnd":57,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (263, '264', 'Përjashtimi i kundërshtimit', null, 'Ligji 04/L-077
Neni 264 - Përjashtimi i kundërshtimit

Nuk mund të kundërshtohen për shkak të dëmtimit të kreditorëve dhurimet e zakonshme të rastit,
dhurimet shpërblyese, si dhe dhurimet e bëra nga falënderimi, në përpjesëtim me mundësitë materiale
të debitorit.', '1e28628aa7870864931420b1c22b9470f9c376f5afc9b9e86968db5b4ed4245e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":57,"pageEnd":57,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (264, '265', 'Si bëhet kundërshtimi', '1-4', 'Ligji 04/L-077
Neni 265 - Si bëhet kundërshtimi

1. Kundërshtimi mund të bëhet me padi ose me kundërshtim.
2. Padia për kundërshtim paraqitet kundër personit të tretë me të cilin ose në dobi të të cilit është
ndërmarrë veprimi juridik i cili kundërshtohet, përkatësisht kundër trashëgimtarëve të tij juridikë
universal.
3. Në qoftë se personi i tretë e ka tjetërsuar me ndonjë punë me ngarkesë dobinë e përfituar nga
disponimi i cili kundërshtohet, padia mund të ngritet kundër përfituesit vetëm në qoftë se ky e ka ditur
se përfitimi i paraardhësve të tij ka mundur të kundërshtohet, e në qoftë se këtë dobi e ka tjetërsuar me
ndonjë punë pa shpërblim, padia mund të paraqitet kundër përfituesit edhe në qoftë se ky nuk ishte në
dijeni.
4. I padituri mund t’i shmanget kundërshtimit, në qoftë se e përmbush detyrimin e debitorit.', '5e96d2cea09591759c2b4da6ea6e0d4da6065d12b4d004dbe962ba09c9c1bccd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":57,"pageEnd":57,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (265, '266', 'Efekti i kundërshtimit', null, 'Ligji 04/L-077
Neni 266 - Efekti i kundërshtimit

Në qoftë se gjykata e aprovon kërkesëpadinë, veprimi juridik e humb efektin vetëm ndaj paditësit dhe
vetëm aq sa nevojitet për plotësimin e kërkesave të tij.', '01fbc63bad0ec9353b9fa36c730ec4f1d1ef02fff3aaa78cc14dac2063d46dd8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":57,"pageEnd":57,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (266, '267', 'Ushtrimi i të drejtës së retencionit', '1-3', 'Ligji 04/L-077
Neni 267 - Ushtrimi i të drejtës së retencionit

1. Kreditori i kërkesës së arritur për pagesë i cili mban ndonjë send të debitorit ka të drejtën e
retencionit në këtë send gjersa të mos i paguhet kërkesa.
2. Në qoftë se debitori është bërë i paaftë për pagesë, kreditori mund të ushtrojë të drejtën e retencionit
megjithëse kërkesa e tij nuk ka arritur për pagesë.
3. E drejta e retencionit të sendit vazhdon edhe pas kalimit të afatit të parashkrimit të kërkesës.', '52f25021f1069c4a64955c0fafe742c988671878c9f1b927fa4174314d050f1b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":58,"pageEnd":58,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (267, '268', 'Përjashtimet', '1-2', 'Ligji 04/L-077
Neni 268 - Përjashtimet

1. Kreditori nuk ka të drejtën e retencionit kur debitori kërkon që t`i kthehet sendi i cili ka dalur nga
posedimi i tij kundër vullneti të tij ose kur debitori kërkon që t`i kthehet sendi që i është dorëzuar
kreditorit për ruajtje ose në shërbim.
2. Kreditori nuk mund të mbajë as prokurën e marrë nga debitori e as dokumentet tjera të debitorit,
letërnjoftimet, korrespodencën dhe sendet tjera të ngjashme dhe as sende tjera të cilat nuk mund të
shiten.', 'c8166852e9611a1a29dfeedaaf1f9383c61227b1224dd55ab20830f2512cf5ae', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":58,"pageEnd":58,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (268, '269', 'Detyrimi i kthimit të sendeve përpara përmbushjes së detyrimit', null, 'Ligji 04/L-077
Neni 269 - Detyrimi i kthimit të sendeve përpara përmbushjes së detyrimit

Kreditori ka për detyrë t`ia kthejë sendin debitorit në qoftë se ky i ofron sigurim përkatës të kërkesës së
tij.', 'c344ce45c425ca20837025e78522c78ac31d77b96659eec4afbfe79a730e89c2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":58,"pageEnd":58,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (269, '270', 'Efekti i të drejtës së retencionit', null, 'Ligji 04/L-077
Neni 270 - Efekti i të drejtës së retencionit

Kreditori i cili e mban sendin e luajtshëm të debitorit në bazë së të drejtës së retencionit ka të drejtë të
arkëtojë nga vlera e saj në të njëjtën mënyrë si kreditori i pengut, por ka për detyrë që ta njoftojë
debitorin para se të fillojë ta realizojë arkëtimin.', '33d358b8808716301524bb50ed6c473d12bf67e41555f8f3cc014a7d23b62f42', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":58,"pageEnd":58,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (270, '271', 'Kur detyrimi përbëhet nga dhënia e sendeve të caktuara sipas llojit', null, 'Ligji 04/L-077
Neni 271 - Kur detyrimi përbëhet nga dhënia e sendeve të caktuara sipas llojit

Kur detyrimi përbëhet nga dhënia e sendeve të caktuara sipas llojit, ndërsa debitori vjen në vonesë,
kreditori, pasi ta këtë njoftuar më parë debitorin, mundet sipas zgjidhjes së tij ta sigurojë sendin e të
njëjtit lloj dhe të kërkojë nga debitori shpërblimin e çmimit dhe shpërblimin e dëmit ose të kërkojë vlerat
e sendeve borxh dhe shpërblimin e dëmit.', 'a1bdb9ab9f6b273f0598cc19938ec3548f0e8a3886da192884cc0a92c71d1116', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":58,"pageEnd":58,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (271, '272', 'Kur detyrimi përbëhet nga veprimi', null, 'Ligji 04/L-077
Neni 272 - Kur detyrimi përbëhet nga veprimi

Kur detyrimi përbëhet nga veprimi, kurse debitori këtë detyrim nuk e ka përmbushur me kohë, kreditori
mundet duke e njoftuar për këtë më parë debitorin, vetë me shpenzime të debitorit të kryejë atë që
debitori e ka pasur për detyrë ta bënte, kurse nga debitori të kërkojë shpërblimin e dëmit për shkak të
vonesës, si dhe shpërblimin e dëmit tjetër që do ta kishte për shkak të mënyrës së këtillë të
përmbushjes.', 'c90389aecd4b2750751b828d155500fd4edefd3fabe6a1ed4f2a6200d9364157', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":59,"pageEnd":59,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (272, '273', 'Kur detyrimi përbëhet nga mosveprimi', '1-3', 'Ligji 04/L-077
Neni 273 - Kur detyrimi përbëhet nga mosveprimi

1. Kur detyrimi përbëhet nga mosveprimi, kreditori ka të drejtë të shpërblimit të dëmit nga vetë fakti se
debitori ka vepruar në kundërshtim me detyrimin e tij.
2. Në qoftë se diçka është ndërtuar në kundërshtim me detyrimin, kreditori mund të kërkojë që kjo të
mënjanohet me shpenzime të debitorit dhe që debitori t`ia shpërblejë dëmin që ka pësuar lidhur me
ndërtimin dhe mënjanimin.
3. Gjykata mundet, kur gjen se kjo është haptazi më e dobishme, duke marrë parasysh interesin
shoqëror dhe interesin e arsyeshëm të kreditorit të vendosë që të mos rrënohet ajo që është ndërtuar,
por që kreditorit t`i shpërblehet dëmi me të holla.', 'aafd90368cd228ad501c7495d3a7f39dc84f2008c86b5487e3282667efb266bc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":59,"pageEnd":59,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (273, '274', 'E drejta e kërkimit të shpërblimit në vend të sendit të gjykuar', '1-2', 'Ligji 04/L-077
Neni 274 - E drejta e kërkimit të shpërblimit në vend të sendit të gjykuar

1. Në qoftë se debitori nuk e përmbush detyrimin e tij brenda afatit që i është caktuar me aktgjykim të
formës së prerë, kreditori mund ta thërrasë që ta përmbushë në një afat të përshtatshëm të
mëvonshëm dhe të deklarojë që pas skadimit të këtij afati nuk do ta pranojë përmbushjen, por do të
kërkojë shpërblimin e dëmit për shkak të mospërmbushjes.
2. Pas skadimit të afatit të mëvonshëm kreditori mund të kërkojë vetëm shpërblimin e dëmit për shkak
të mos përmbushjes.', '08c080a9dc853caef0b4b2a0b036304e65fd13a41a0a34163b0b585c1de0f201', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":59,"pageEnd":59,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (274, '275', 'Penalet gjyqësore', '1-2', 'Ligji 04/L-077
Neni 275 - Penalet gjyqësore

1. Kur debitori nuk e përmbush brenda afatit ndonjë detyrim të tij jo në të holla të përcaktuar me
aktgjykim të formës së prerë, gjykata mundet me kërkesë të kreditorit t`i caktojë debitorit një afat të
përshtatshëm të mëvonshëm dhe t`i caktojë me qëllim të ndikimit ndaj debitorit dhe pavarësisht nga
çdo dëm, që debitori po qe se nuk e përmbush detyrimin e tij brenda këtij afati të ketë detyrë t`i paguajë
kreditorit një shumë të hollash për çdo ditë vonese ose për ndonjë njësi tjetër kohore duke filluar nga
skadimi i këtij afati.
2. Kur debitori e përmbush më vonë detyrimin e tij, gjykata mund ta zvogëlojë shumën e caktuar në
këtë mënyrë duke pasur parasysh qëllimin për të cilin ka urdhëruar pagimin e saj.', '69032e4e4f45ac37d467bd6ee00629f37fe01d34e7d28ac6426a4cef1750c18d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":59,"pageEnd":59,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (275, '276', 'Rregulla e përgjithshme', '1-2', 'Ligji 04/L-077
Neni 276 - Rregulla e përgjithshme

1. Detyrimi shuhet kur ai përmbushet si dhe në rastet tjera të përcaktuara me ligj.
2. Me shuarjen e detyrimit kryesor shuhen dorëzania, pengu dhe të drejtat tjera akcesore.', '76168144c09b7e32d60513718719e281bbf3ff2ed80f1ef8b2e5796162745ebf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":60,"pageEnd":60,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (276, '277', 'Përmbushja nga ana e debitorit ose e personit të tretë', '1-5', 'Ligji 04/L-077
Neni 277 - Përmbushja nga ana e debitorit ose e personit të tretë

1. Detyrimin mund ta përmbushë jo vetëm debitori, por edhe personi i tretë.
2. Kreditori është i detyruar ta pranojë përmbushjen nga secili person i cili ka ndonjë interes juridik që
detyrimi të përmbushet, madje edhe nëse debitori e kundërshton atë përmbushje.
3. Kreditori ka për detyrë të pranojë përmbushjen nga ana e personit të tretë, në qoftë se debitori
pajtohet me këtë me përjashtim të rastit kur sipas kontratës ose nga vetë natyra e detyrimit, këtë
përmbushje duhet ta bëjë debitori personalisht.
4. Kreditori mund të pranojë përmbushjen nga personi i tretë pa dijen e debitorit, madje edhe në rastin
kur debitori e ka njoftuar se nuk pranon që personi i tretë ta përmbushë detyrimin e tij.
5. Megjithatë, në qoftë se debitori i ka ofruar që vetë ta përmbushë menjëherë detyrimin e vet, kreditori
nuk mund të pranojë përmbushjen nga personi i tretë.', '32666e7c0e2b3012ab1f365993b3401f34dcb69dadbfb0f825fb2959f052f3b2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":60,"pageEnd":60,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (277, '278', 'Përmbushja e personit të paaftë për të vepruar', '1-2', 'Ligji 04/L-077
Neni 278 - Përmbushja e personit të paaftë për të vepruar

1. Edhe debitori i paaftë për të vepruar mundet në mënyrë juridikisht të vlefshme të përmbushë
detyrimin në qoftë se ekzistimi i detyrimit është i padyshimtë dhe në qoftë se ka arritur afati për
përmbushjen e tij.
2. Megjithatë, mund të kontestohet përmbushja në qoftë se personi i tillë e ka paguar borxhin e
parashkruar, ose borxhin i cili rrjedh nga loja e fatit ose nga bastet.', '6477efbdba063593b80ef68c84de600d2c08a7b12ee30d0bd0f5f7abcd516ac8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":60,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (278, '279', 'Shpenzimet e përmbushjes', null, 'Ligji 04/L-077
Neni 279 - Shpenzimet e përmbushjes

Shpenzimet e përmbushjes i bartë debitori, në qoftë se ato nuk i ka shkaktuar kreditori.', '11c6f35c6013dbd565124efba8f4d09d68bc20d53ba97da4750b62dc980f6680', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":61,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (279, '280', 'Përmbushja me bartjen e të drejtës në përmbushësin (subrogimi)', '1-3', 'Ligji 04/L-077
Neni 280 - Përmbushja me bartjen e të drejtës në përmbushësin (subrogimi)

1. Në rast të përmbushjes së detyrimit të huaj, secili përmbushës mund të kontraktojë me kreditorin,
para përmbushjes ose me rastin e përmbushjes, që kërkesa e përmbushur t’i kalohet atij me të gjitha të
drejtat ose vetëm me disa të drejta akcesore.
2. Të drejtat e kreditorit mund të kalojnë në përmbushësin edhe në bazë të kontratës midis debitorit dhe
përmbushësit të lidhur para përmbushjes.
3. Në këto raste subrogimi i përmbushësit në të drejtat e kreditorit krijohet në momentin e përmbushjes.', 'f3d8e52fdfc2b62a76c8aa02ce81fee34168c10e1c02473d3ca6a509d0064980', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":61,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (280, '281', 'Subrogimi ligjor', null, 'Ligji 04/L-077
Neni 281 - Subrogimi ligjor

Kur detyrimin e përmbush personi i cili ka ndonjë interes juridik në këtë çështje, atëherë i kalojnë këtij,
në bazë të vet ligjit, në çastin e përmbushjes, kërkesat e kreditorit me të gjitha të drejtat aksesore.', 'c5b62ed8a3385117153b47a7030b6be6d09922336e7a200ae9f88a6b916ea288', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":61,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (281, '282', 'Subrogimi në rast të përmbushjes së pjesshme', '1-2', 'Ligji 04/L-077
Neni 282 - Subrogimi në rast të përmbushjes së pjesshme

1. Në rast të përmbushjes së pjesshme të kërkesës së kreditorit, në përmbushësin kalojnë të drejtat
akcesore me të cilat është siguruar përmbushja e asaj kërkese vetëm në qoftë se nuk nevojiten për
përmbushjen e pjesës së mbetur të kërkesës së kreditorit.
2. Kreditori dhe përmbushësi mund të kontraktojnë se do të shfrytëzojnë garancione në përpjesëtim me
kërkesat e veta, por mund të kontraktojnë edhe se përmbushësi do të ketë të drejtën e arkëtimit me
përparësi.', '89702bb298e339151ea9de0d9d8d9a32c25243d600be4f5e00c3465f831bdc13', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":61,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (282, '283', 'Provat dhe mjetet e sigurimit', '1-2', 'Ligji 04/L-077
Neni 283 - Provat dhe mjetet e sigurimit

1. Kreditori ka për detyrë t’ia dorëzojë përmbushësit mjetet me të cilat provohet ose sigurohet kërkesa.
2. Përjashtimisht, kreditori mund t’ia dorëzojë përmbushësit sendin të cilin e ka marrë peng nga debitori
ose nga ndonjë tjetër, vetëm në qoftë se penglënësi është pajtuar me këtë, përndryshe, ajo mbetet në
posedim të kreditorit që ta mbajë dhe ta ruajë për llogari të përmbushësit.', 'c64f21071a461e9ff9ae9a1386e7418d6f30bb130fb4276c23202f52d8317711', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":61,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (283, '284', 'Sa mund të kërkohet nga debitori', null, 'Ligji 04/L-077
Neni 284 - Sa mund të kërkohet nga debitori

Përmbushësi te i cili ka kaluar kërkesa, nuk mund të kërkojë nga debitori më tepër se sa i ka paguar
kreditorit.', '5e8954a34a9f725f77d9a0d6f1d109b00e36b808eeadddb5f4dfbe0965067554', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":61,"pageEnd":61,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (284, '285', 'Përjashtimi i përgjegjësisë së kreditorit për ekzistimin dhe arkëtueshmërinë e kërkesës', '1-2', 'Ligji 04/L-077
Neni 285 - Përjashtimi i përgjegjësisë së kreditorit për ekzistimin dhe arkëtueshmërinë e kërkesës

1. Kreditori i cili e ka marrë përmbushjen nga personi i tretë nuk përgjigjet për ekzistimin dhe
arkëtueshmërinë e kërkesës në kohën e përmbushjes.
2. Me këtë nuk përjashtohet aplikimi i rregullave mbi pasurimin pa bazë.', 'b8bafb4d98d601d09daecf40950e9e9e2fed4a1e467b8f928de42bcac8bd4774', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":62,"pageEnd":62,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (285, '286', 'Personi i autorizuar', '1-2', 'Ligji 04/L-077
Neni 286 - Personi i autorizuar

1. Përmbushja medoemos duhet t’i bëhet kreditorit ose personit të caktuar me ligj, me vendim gjyqësor,
me kontratë midis kreditorit e debitorit, ose nga vetë kreditori.
2. Përmbushja është e vlefshme edhe kur i është bërë personit të tretë, në qoftë se kreditori e ka lejuar
më vonë apo në qoftë se e ka përdorur atë.', '6c5758ffa12e7cab43302154871a7fdd2fec6dbd1afa76f3cca86c5f9df922bd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":62,"pageEnd":62,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (286, '287', 'Përmbushja e bërë kreditorit të paaftë për të vepruar', '1-2', 'Ligji 04/L-077
Neni 287 - Përmbushja e bërë kreditorit të paaftë për të vepruar

1. Përmbushja e bërë kreditorit të paaftë për të vepruar e liron debitorin, në qoftë se ka qenë e
dobishme për kreditorin ose objekti i përmbushjes ndodhet ende te ai.
2. Kreditori i paaftë për të vepruar mund të pajtohet, pasi të jetë bërë i aftë për të vepruar, për
përmbushjen të cilin e ka marrë në kohën e paaftësisë së tij për të vepruar.', '9b3e3d291f05143a64ce0b2fff01705db008e6882072edc8115943429a52c1c7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":62,"pageEnd":62,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (287, '288', 'Përmbajtja e detyrimit', '1-2', 'Ligji 04/L-077
Neni 288 - Përmbajtja e detyrimit

1. Përmbushja përbëhet nga kryerja e asaj që është përmbajtja e detyrimit, ashtu që as debitori nuk
mund ta përmbush me diçka tjetër dhe as kreditori nuk mund të kërkojë diçka tjetër.
2. Përmbushja nuk është e vlefshme, në qoftë se ajo që debitori e ka dorëzuar si send borxh dhe
kreditori e ka pranuar si të tillë, gjë që në të vërtetë nuk është dhe kreditori ka të drejtë ta kthejë atë që i
është dorëzuar dhe të kërkojë sendin borxh.', '6aa6d755f2504a263ac56514429302b45ad2a5272b31c03223e894d84b5382fa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":62,"pageEnd":62,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (288, '289', 'Zëvendësimi i përmbushjes', '1-3', 'Ligji 04/L-077
Neni 289 - Zëvendësimi i përmbushjes

1. Detyrimi shuhet në qoftë se kreditori në marrëveshje me debitorin pranon diçka tjetër në vend të asaj
që ka borxh.
2. Në atë rast debitori përgjigjet sikurse shitësi për të metat materiale dhe juridike të sendit të dhënë në
vend të asaj që ka borxh.
3. Megjithatë, kreditori në vend të kërkesës në bazë të përgjegjësisë së debitorit për të metat materiale
ose juridike të sendit mund të kërkojë nga debitori, por jo më nga dorëzani, përmbushjen e kërkesës
paraprake dhe dëmshpërblimin.', '9da05437f0574b72b3944ca738351814d06a1ebf663622ab20a5e2e06156befe', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":62,"pageEnd":62,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (289, '290', 'Dorëzimi me qëllim shitjeje', null, 'Ligji 04/L-077
Neni 290 - Dorëzimi me qëllim shitjeje

Në qoftë se debitori ia ka dorëzuar kreditorit ndonjë send ose ndonjë të drejtë tjetër për t’i shitur dhe
nga shuma e realizuar të arkëtojë kërkesat e veta, ndërsa pjesën tjetër ia dorëzon, detyrimi shuhet
vetëm kur kreditori të arkëtojë nga shuma e realizuar.', '9376dbc6c918e195ea7c59b8be2ea2d35ca2f10b4997ba09fb3c638efdf54935', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":63,"pageEnd":63,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (290, '291', 'Përmbushja e pjesshme', '1-2', 'Ligji 04/L-077
Neni 291 - Përmbushja e pjesshme

1. Kreditori nuk e ka për detyrë të pranojë përmbushjen e pjesshme, përveç nëse vetë natyra e
detyrimit imponon diçka tjetër.
2. Kreditori ka për detyrë ta pranojë përmbushjen e pjesshme të detyrimit në të holla, përveç nëse ka
ndonjë interes të veçantë për ta refuzuar.', 'c4783273fdc2619260cc047427f26fe0a7e77ac3738c2b756dedaa72cc0d9bd1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":63,"pageEnd":63,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (291, '292', 'Detyrimi i dhënies së sendeve të caktuara sipas llojit', '1-2', 'Ligji 04/L-077
Neni 292 - Detyrimi i dhënies së sendeve të caktuara sipas llojit

1. Në qoftë se sendet janë caktuar vetëm sipas llojit, debitori ka për detyrë t’i jep sende të cilësisë
mesatare.
2. Në qoftë se e ka pasur të njohur destinimin e sendit, ka për detyrë t’i jep sendet e cilësisë përkatëse.', '725a76e309221f3c2dca71ca6e8ab02e23a0685657354dcf6bb0dc49de9b3174', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":63,"pageEnd":63,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (292, '293', 'Radha e llogaritjes', '1-4', 'Ligji 04/L-077
Neni 293 - Radha e llogaritjes

1. Kur midis personave të njëjtë ekzistojnë disa detyrime të njëllojta, kështu që atë që debitori e
përmbush nuk mjafton për t’i plotësuar të gjitha, atëherë, në qoftë se për këtë gjë nuk ekziston
marrëveshja e kreditorit dhe debitorit, llogaritja bëhet me atë radhë të cilën e cakton debitori më së voni
me rastin e përmbushjes.
2. Kur nuk ekziston deklarata e debitorit mbi llogaritjen, atëherë detyrimet përmbushen me radhë ashtu
sikurse kanë arritur për përmbushje.
3. Në qoftë se kanë arritur disa detyrime njëkohësisht për përmbushje, së pari plotësohen ato,
përmbushja e të cilave është siguruar më pak, ndërsa kur janë siguruar të gjitha njësoj, atëherë më
parë përmbushën ato të cilat përbëjnë për debitorin barrë më të rëndë.
4. Në kuptim të këtij neni detyrimet që janë të barabarta përmbushen me radhë sikur janë krijuar, e në
qoftë se janë krijuar njëkohësisht, atëherë ajo që është dhënë në emër të përmbushjes pjesëtohet në të
gjitha detyrimet përpjesëtimisht me shumat e tyre.', 'ce9ca5796cbcc153c28c06288a065b6c146d2e81444339d6bc451e6b8b262268', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":63,"pageEnd":63,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (293, '294', 'Llogaritja e kamatës dhe e shpenzimeve', null, 'Ligji 04/L-077
Neni 294 - Llogaritja e kamatës dhe e shpenzimeve

Në qoftë se debitori përpos kërkesës kryesore ka borxh edhe kamata dhe shpenzime, llogaritja bëhet
në atë mënyrë që së pari paguhen shpenzimet, pastaj kamata dhe në fund kërkesa kryesore.', '102bc83b610803f2523136ae4aaa35d05359545e69892795a5469c7214654220', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":63,"pageEnd":63,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (294, '295', 'Kur nuk është caktuar afati', null, 'Ligji 04/L-077
Neni 295 - Kur nuk është caktuar afati

Në qoftë se afati nuk është caktuar, kurse qëllimi i punës, vetë natyra e detyrimit dhe rrethanat e tjera
nuk kërkojnë një afat për përmbushje, kreditori mund të kërkojë menjëherë përmbushjen e detyrimit,
ndërsa debitori nga ana e vet mund të kërkojë nga kreditori që menjëherë të pranojë përmbushjen.', '27dcea33a104786e5ff5461a0b2818b51d47debe30f3791daf024c335ded7f12', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":64,"pageEnd":64,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (295, '296', 'Përmbushja para afatit', '1-2', 'Ligji 04/L-077
Neni 296 - Përmbushja para afatit

1. Kur afati është kontraktuar ekskluzivisht në interesin e debitorit, ai ka të drejtë ta përmbushë
detyrimin edhe para afatit të kontraktuar, por e ka për detyrë ta njoftojë kreditorin për qëllimin e vet dhe
të kujdeset që kjo të mos jetë në kohë të papërshtatshme.
2. Në raste të tjera, kur debitori ofron përmbushjen para afatit, kreditori mund ta refuzojë përmbushjen,
ndërsa mundet edhe ta pranojë dhe ta ruajë të drejtën për shpërblim të dëmit, në qoftë se për këtë gjë
pa shtyrje e njofton debitorin.', '38a68e36ffc73bb69cbe9ead825713ce9b94283b374f9a25fd25e0453c292800', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":64,"pageEnd":64,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (296, '297', 'E drejta e kreditorit për të kërkuar përmbushjen para afatit', null, 'Ligji 04/L-077
Neni 297 - E drejta e kreditorit për të kërkuar përmbushjen para afatit

Kreditori ka të drejtë të kërkojë përmbushjen para afatit në qoftë se debitori nuk ia ka dhënë sigurimin e
premtuar, ose në qoftë se me kërkesën e tij nuk e ka plotësuar sigurimin e zvogëluar pa fajin e tij, si
dhe kur afati është kontraktuar ekskluzivisht në interes të tij.', 'de958fb2b5afb06b59913df9c06e853937e38b3d9255e060ae80b975b0c61aa5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":64,"pageEnd":64,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (297, '298', 'Caktimi i afatit nga njëra palë', null, 'Ligji 04/L-077
Neni 298 - Caktimi i afatit nga njëra palë

Kur caktimi i kohës së përmbushjes i është lënë dëshirës së kreditorit ose të debitorit, pala tjetër
mundet, po qe se i autorizuari nuk e cakton afatin as pas tërheqjes së vërejtjes të kërkojë nga gjykata
që ajo ta caktojë afatin plotësues për përmbushje.', '3213fb481849fcdd12f958a5194edc9f6038cfd9d90f1a9d207d2461d13720a3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":64,"pageEnd":64,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (298, '299', 'Detyrimi monetar', '1-2', 'Ligji 04/L-077
Neni 299 - Detyrimi monetar

1. Në rast se pagesat bëhen me ndërmjetësimin e bankës ose të organizatës tjetër pranë së cilës
mbahet llogaria e kreditorit dhe derisa palët kontraktuese të mos e kenë përcaktuar ndryshe,
konsiderohet se borxhi është likuiduar në kohën kur bankës ose organizatës pranë së cilës mbahet
llogaria t‘i ketë arritur dërgesa e të hollave në dobi të kreditorit ose urdhri i bankës së debitorit ose i
organizatës që t‘i akordojë llogarisë së kreditorit shumën e shënuar në urdhër.
2. Në rast se me kontratë është parashikuar pagesa me anë të postës, supozohet se palët janë pajtuar
se me pagesën e shumës së debituar në postë, debitori e ka likuiduar detyrimin e vet ndaj kreditorit; në
rast se palët nuk janë pajtuar për një mënyrë të tillë të pagesës, borxhi është i likuiduar kur kreditori të
marrë dërgesën e të hollave.', 'c87efe69809a0ae20dcef5086eaaa492adc0280a16bdc56fa856035c9de6194a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":64,"pageEnd":64,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (299, '300', 'Rregulla të përgjithshme', '1-3', 'Ligji 04/L-077
Neni 300 - Rregulla të përgjithshme

1. Debitori është i detyruar ta përmbushë detyrimin, kurse kreditori ta pranojë përmbushjen në vendin e
caktuar me punën juridike ose me ligj.
2. Kur vendi i përmbushjes nuk është caktuar, dhe nuk mund të caktohet as sipas qëllimit të punës,
natyrës së detyrimit apo të rrethanave tjera, atëherë përmbushja e detyrimit bëhet në vendin ku debitori
në kohën e krijimit të detyrimit e ka pasur selinë, respektivisht vendbanimin e vet, e në mungesë të
vendbanimit, ku ka pasur vendqëndrimin e tij.
3. Mirëpo, në qoftë se debitori është person juridik që ka disa njësi në vende të ndryshme, atëherë si
vend i përmbushjes konsiderohet selia e njësisë e cila duhet t’i zbatojë veprimet e domosdoshme për
përmbushjen e detyrimit, në qoftë se kjo rrethanë për kreditorin me rastin e lidhjes së kontratës ka qenë
e njohur ose është dashur të jetë e njohur.', '2e91c6d475396a3a9444bcc0735305828408b97c2bbac04f05def40762635142', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":64,"pageEnd":65,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
