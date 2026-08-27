-- 04/L-077: deterministic chunk batch; 150 rows.
BEGIN;

-- A missing or duplicate source is visible before the write and must stop manual execution.
SELECT id, law_number, version_label, language
FROM public.legal_sources
WHERE law_number = '04/L-077'
    and version_label = 'gazette-16-2012'
    and language = 'sq';

-- The delete is deliberately scoped to this single P0 natural key.
DELETE FROM public.legal_chunks
WHERE legal_source_id IN (
  SELECT id FROM public.legal_sources
  WHERE law_number = '04/L-077'
    and version_label = 'gazette-16-2012'
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
  (0, '1', 'Fushë veprimtaria e ligjit', '1-2', 'Ligji 04/L-077
Neni 1 - Fushë veprimtaria e ligjit

1. Ky ligj përmban parimet themelore dhe rregullat e përgjithshme për të gjitha marrëdhëniet e
detyrimeve.
2. Dispozitat e këtij ligji zbatohen ndaj marrëdhënieve të detyrimeve të rregulluara me akte të tjera
ligjore në lidhje me çështjet që nuk rregullohen në këto akte.', '7d11f9d525fb8651b3986ac8644c505e6fa772f8e644fd847901e2f1ffe919ff', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":1,"pageEnd":1,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1, '2', 'Autonomia e vullnetit', '1-2', 'Ligji 04/L-077
Neni 2 - Autonomia e vullnetit

1. Pjesëmarrësit në marrëdhëniet e detyrimeve janë të lirë, që në pajtim me dispozitat urdhëruese, të
rendit publik dhe të dokeve të mira, t`i rregullojnë marrëdhëniet e veta sipas vullnetit të tyre.
2. Pjesëmarrësit mund t`i rregullojnë marrëdhëniet e tyre të detyrimeve ndryshe nga ajo që është
paraparë me këtë ligj, për derisa nuk rezulton diçka tjetër nga dispozitat e këtij ligji ose të kuptimit dhe
qëllimit të tyre.', 'b2f653437b9585d65af017032e3420eca515a060380f82a0991389eee32073ef', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":1,"pageEnd":1,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (2, '3', 'Barazia e pjesëmarrësve në marrëdhëniet e detyrimeve', null, 'Ligji 04/L-077
Neni 3 - Barazia e pjesëmarrësve në marrëdhëniet e detyrimeve

Pjesëmarrësit në marrëdhëniet e detyrimeve janë të barabartë.', 'c2dd7f7829e1e8575ba04d6b47ff6ad7fe87decb9d2bef7ff96330c01bad2b7e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":1,"pageEnd":1,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (3, '4', 'Parimi i ndërgjegjshmërisë dhe ndershmërisë', '1-2', 'Ligji 04/L-077
Neni 4 - Parimi i ndërgjegjshmërisë dhe ndershmërisë

1. Në krijimin e marrëdhënieve të detyrimeve dhe në ushtrimin e të drejtave dhe përmbushjen e
detyrimeve që rrjedhin nga këto marrëdhënie, pjesëmarrësit duhet t’i përmbahen parimit të
ndërgjegjshmërisë dhe ndershmërisë.
2. Pjesëmarrësit në marrëdhëniet e detyrimeve duhet të veprojnë në pajtim me doket e mira afariste në
marrëdhëniet e tyre. Pjesëmarrësit nuk munden të përjashtojnë ose kufizojnë këtë detyrim.', 'd3c1f586ce6bc4d0f692854ecc074e1fdbad33a06070637f40a1778a4e02ab0e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":1,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (4, '5', 'Kujdesi', '1-2', 'Ligji 04/L-077
Neni 5 - Kujdesi

1. Në përmbushjen e detyrimeve të tyre, pjesëmarrësit në marrëdhëniet e detyrimeve detyrohen të
veprojnë me kujdesin që kërkohet në qarkullimin juridik të llojit përkatës të marrëdhënies së detyrimit
(kujdesi i një ekonomisti të mirë ose kujdesi i një shtëpiaku të mirë).
2. Në përmbushjen e detyrimeve të tyre nga veprimtaritë profesionale, pjesëmarrësit në marrëdhëniet e
tyre të detyrimeve duhet të veprojnë me kujdes të lartë, sipas rregullave dhe zakonit të profesionit
(kujdesi i një eksperti të mirë).', 'fdf4ae4362579dc8dac439f4b1396232c56308d7e99def5484a2a7cb78844946', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (5, '6', 'Ndalimi i keqpërdorimit të të drejtave', '1-3', 'Ligji 04/L-077
Neni 6 - Ndalimi i keqpërdorimit të të drejtave

1. Të drejtat që rrjedhin nga marrëdhëniet e detyrimeve duhet të ushtrohen në pajtim me parimet
themelore të këtij ligji dhe qëllimin e tyre.
2. Gjatë ushtrimit të të drejtave të tyre, pjesëmarrësit në një marrëdhënie detyrimi duhet të përmbahen
nga veprimi që do të mund të vështirësonte kryerjen e detyrimeve të pjesëmarrësve të tjerë.
3. Çdo veprim përmes të cilit bartësi i një të drejte vepron me qëllimin e vetëm ose të qartë të dëmtimit
të tjetrit konsiderohet keqpërdorim i të drejtës.', '6d9be33e24b483cf61bdc7b6fe267a0a41b2e532edc000d2a12ccfb4048de090', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (6, '7', 'Parimi i ekuivalencës së prestimeve', '1-2', 'Ligji 04/L-077
Neni 7 - Parimi i ekuivalencës së prestimeve

1. Në krijimin e kontratave me shpërblim, pjesëmarrësit nisen nga parimi i vlerës së barabartë të
dhënieve reciproke.
2. Me ligj përcaktohet se në cilat raste prishja e këtij parimi krijon pasoja juridike.', '2c4c5b5307edabbb4f7fe76891e7028b9321080785cabb9fa91c1bdfd0a7b2aa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (7, '8', 'Detyrat e përmbushjes së detyrimeve', '1-2', 'Ligji 04/L-077
Neni 8 - Detyrat e përmbushjes së detyrimeve

1. Pjesëmarrësit në marrëdhënien e detyrimit kanë për detyrë ta përmbushin detyrimin e vet dhe janë
përgjegjës për përmbushjen e të njëjtit.
2. Detyrimi mund të shuhet vetëm me pajtimin e vullneteve të pjesëmarrësve në marrëdhënien e
detyrimeve ose në bazë të ligjit.', '03f20028008042f8649eb571d238de57e841d4a2cedf91c3c20e46c9d7447d05', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (8, '9', 'Ndalimi i shkaktimit të dëmit', null, 'Ligji 04/L-077
Neni 9 - Ndalimi i shkaktimit të dëmit

Secili person ka për detyrë të përmbahet nga veprimi që mund t’i shkaktoj dëm tjetrit.', '8a027a011891963d682f3f020bdf2f81c35dfedfeb0bcb05d158d5795cf375cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (9, '10', 'Zgjidhja e konflikteve në mënyrë paqësore', null, 'Ligji 04/L-077
Neni 10 - Zgjidhja e konflikteve në mënyrë paqësore

Pjesëmarrësit e marrëdhënies së detyrimit do të përpiqen që kontestet t’i zgjidhin me anë të negocimit,
të ndërmjetësimit apo në ndonjë mënyrë tjetër me pajtimin e pjesëmarrësve.', 'ab12bd2cd0fccd0b6aba233f5465b11408ad403bf902d289a0d9baef937d923b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":2,"pageEnd":2,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (10, '11', 'Doket afariste, uzansat dhe praktika', null, 'Ligji 04/L-077
Neni 11 - Doket afariste, uzansat dhe praktika

Doket afariste, uzansat dhe praktika e krijuar ndërmjet palëve duhet të merret në konsideratë në
vlerësimin e sjelljes së kërkuar dhe efekteve të saj në marrëdhëniet e detyrimeve të subjekteve afarist.', 'cd82ff32804918b5cc08b5fe5c12e867bd0670a6339b4d58f945e7e3d287d119', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":3,"pageEnd":3,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (11, '12', 'Kontratat komerciale', '1-4', 'Ligji 04/L-077
Neni 12 - Kontratat komerciale

1. Dispozitat e këtij ligji zbatohen për të gjitha llojeve të kontratave, përveç nëse me ligj përcaktohet
ndryshe.
2. Kontratat komerciale janë kontrata të lidhura nga subjektet komerciale ndërmjet tyre.
3. Entitetet afariste të përcaktuara me ligj, si dhe personat e tjerë juridike që kryejnë veprimtari
fitimprurëse konsiderohen subjekte afariste në kuptimin e këtij ligji.
4. Personat e tjerë juridike konsiderohen subjekte komerciale në kuptimin e këtij ligji kur në pajtim me
dispozitat ligjore, herë pas here ose gjatë veprimtarive të tyre parësore, përfshihen në veprimtari
fitimprurëse, në rast se çështja ka të bëjë me një kontratë në lidhje me këto veprimtari fitimprurëse.', '3315b768c03078e098baa66722a994f7f2e7636024f763706b98732fbd0e460a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":3,"pageEnd":3,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (12, '13', 'Punët e tjera juridike', null, 'Ligji 04/L-077
Neni 13 - Punët e tjera juridike

Kuptimi i dispozitave të këtij ligji në lidhje me kontratat përshtatshmërisht aplikohet edhe ndaj punëve të
tjera juridike.', 'f99828804686f81a6183707fa2b2377f291098521740cc7c8ca52151d1e99b73', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":3,"pageEnd":3,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (13, '14', 'Zbatimi analog i ligjit', null, 'Ligji 04/L-077
Neni 14 - Zbatimi analog i ligjit

Për marrëdhëniet për të cilat ky ligj nuk përmban ndonjë dispozitë zbatohen përshtatshmërisht
dispozitat për marrëdhënie juridike të ngjashme, e në mungesë të dispozitave të tilla zbatohen parimet
të cilat burojnë nga bazat e rendit juridik dhe doket e mira.', '8d0b42c17c37e4b7daa64698673b480a64ae75f461872a151d6993d979b7a8d3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":3,"pageEnd":3,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (14, '15', 'Lidhja e kontratës', null, 'Ligji 04/L-077
Neni 15 - Lidhja e kontratës

Kontrata është e lidhur kur palët kontraktuese janë marrë vesh për elementet thelbësore të kontratës.', '99e0d6d7ba105eb938cc60f481856e7c0e4b467a8e5b2d2c48b7c1c5dbbdef6b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":3,"pageEnd":3,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (15, '16', 'Mosmarrëveshja', null, 'Ligji 04/L-077
Neni 16 - Mosmarrëveshja

Kur palët besojnë se janë pajtuar, kurse midis tyre ekziston mosmarrëveshja rreth elementeve
thelbësore të kontratës, kontrata nuk do të konsiderohet e lidhur.', '4448d20cb543d432cb41660c24401ce6aefb48890ed671862af310b8228f3b44', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":4,"pageEnd":4,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (16, '17', 'Lidhja e detyrueshme dhe përmbajtja e detyrueshme e kontratës', '1-2', 'Ligji 04/L-077
Neni 17 - Lidhja e detyrueshme dhe përmbajtja e detyrueshme e kontratës

1. Kushdo që sipas ligjit është i detyruar të lidhë kontratë, personi i interesuar mund të kërkojë që një
kontratë e tillë të lidhet pa shtyrje.
2. Dispozitat ligjore, me të cilat caktohet pjesërisht apo tërësisht përmbajtja e detyrueshme e kontratës
janë pjesë përbërëse e këtyre kontratave, kështu që i plotësojnë ato, ose hyjnë në vend të dispozitave
kontraktuese që nuk janë në përputhje me to.', 'e29778501c4b90e3ca8f29eaa52d7bb60d61af1011604fbba0f1793942858b2f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":4,"pageEnd":4,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (17, '18', 'Shprehja e vullnetit', '1-2', 'Ligji 04/L-077
Neni 18 - Shprehja e vullnetit

1. Vullneti për ta lidhur kontratën mund të shprehet me fjalë, me shenja të rëndomta ose me ndonjë
sjellje tjetër nga e cila mund të konkludohet me siguri për ekzistimin e tij.
2. Shprehja e vullnetit duhet të bëhet lirisht dhe seriozisht.', '4ddc266db68658230063201374c322eee91802859c2f03313b3e51e62ab99c83', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":4,"pageEnd":4,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (18, '19', 'Pëlqimi', '1-2', 'Ligji 04/L-077
Neni 19 - Pëlqimi

1. Kur për lidhjen e ndonjë kontrate nevojitet aprovimi i personit të tretë, ky pëlqim mund të jepet para
lidhjes së kontratës, si leje, apo, pas lidhjes së saj, si aprovim, po qe se me ligj nuk është parashikuar
diç tjetër.
2. Leja, përkatësisht aprovimi duhet të jepet në formën e parashikuar për kontrata, për lidhjen e të
cilave jepen.', 'ab83011f1d648d6af69ec3315abc8effb0133365fbdcd6d569f95f35bc694c11', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":4,"pageEnd":4,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (19, '20', 'Negociatat', '1-4', 'Ligji 04/L-077
Neni 20 - Negociatat

1. Negociatat që i paraprijnë lidhjes së kontratës nuk detyrojnë dhe secila palë mund t`i ndërpret kurdo
që të dëshirojë.
2. Pala që ka zhvilluar negociata pa pasur qëllim që të lidhë kontratë, mban përgjegjësi për dëmin e
shkaktuar gjatë zhvillimit të negociatave.
3. Përgjegjësi për dëmin mban edhe pala që i ka zhvilluar negociata me qëllim që të lidhë kontratë, e
pastaj heqë dorë nga ky qëllim, pa ndonjë shkak të bazuar dhe në këtë mënyrë i shkakton dëm palës
tjetër.
4. Në qoftë se nuk merren vesh ndryshe, secila palë bartë shpenzimet e veta rreth përgatitjes për
lidhjen e kontratës, kurse shpenzimet e përbashkëta i bartin në pjesë të barabarta.', '6f9df047c8962c7bb42ed3cd8ba377c22490a6137c4d1f75a83d97ecf0ec2f4b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":4,"pageEnd":4,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (20, '21', 'Koha dhe vendi i lidhjes së kontratës', '1-2', 'Ligji 04/L-077
Neni 21 - Koha dhe vendi i lidhjes së kontratës

1. Kontrata është e lidhur në çastin kur ofertuesi merr deklaratën e të ofertuarit se e pranon ofertën.
2. Konsiderohet se kontrata është e lidhur në vendin ku ofertuesi e ka pasur selinë e tij, përkatësisht
vendbanimin në çastin kur e ka bërë ofertën.', 'b256a499e9891ff7f04ee212c5a6d8e68e5d9d9e00afb10105aa0cb5085ee15d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":4,"pageEnd":4,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (21, '22', 'Oferta', '1-3', 'Ligji 04/L-077
Neni 22 - Oferta

1. Oferta është propozim për lidhjen e kontratës që i bëhet personit të caktuar dhe përmban të gjitha
elementet thelbësore të kontratës, kështu që me pranimin e saj do të mund të lidhej kontrata.
2. Kontrata konsiderohet e lidhur, nëse palët kontraktuese e lënë për më vonë marrëveshjen për
elementet sekondare, me kusht që palët janë pajtuar për elementet thelbësore të kontratës. Nëse palët
nuk mund të merren vesh për elementet dytësore, ato do të caktohen nga gjykata duke pasur parasysh
negociatat paraprake, praktikën e krijuar ndërmjet kontraktuesve dhe doket.
3. Propozimi për lidhjen e kontratës që i bëhet një numri të pacaktuar personash, i cili përmban
elementet thelbësore të kontratës, i destinuar për lidhjen e saj, vlen si ofertë, në qoftë se nuk rrjedh
ndryshe nga rrethanat e rastit ose nga doket.', '0f4d1c7c6380e0aeba2d0393bbd62aff672726b248d23c031a2de3594a449c44', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":5,"pageEnd":5,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (22, '23', 'Ekspozimi i mallit', null, 'Ligji 04/L-077
Neni 23 - Ekspozimi i mallit

Ekspozimi i mallit me shënimin e çmimit konsiderohet si ofertë, në qoftë se nuk rrjedh ndryshe nga
rrethanat e rastit ose nga doket.', '83721f17d0ce77a609908b9345745213cd43a2a24ed462611bce4f8dbf79244c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":5,"pageEnd":5,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (23, '24', 'Dërgimi i katalogjeve dhe i shpalljeve', '1-2', 'Ligji 04/L-077
Neni 24 - Dërgimi i katalogjeve dhe i shpalljeve

1. Dërgimi i katalogëve, i çmimoreve, tarifave dhe i njoftimeve të tjera, si dhe shpalljet e bëra me anë të
shtypit, trakteve, radios, televizionit ose në ndonjë mënyrë tjetër, nuk përbëjnë ofertë për lidhjen e
kontratës, por vetëm ftesë që të bëhet oferta nën kushtet e shpallura.
2. Megjithatë, dërguesi i ftesave të tilla do të përgjigjet për dëmin, të cilin do ta pësonte ofertuesi, po qe
se dërguesi pa ndonjë shkak të arsyeshëm nuk e ka pranuar ofertën e ofertuesit.', '65512b8b700f905134cd67dc288e79deae7a9780e87430c8c99f7f60c4babdbc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":5,"pageEnd":5,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (24, '25', 'Efekti i ofertës dhe i revokimit', '1-2', 'Ligji 04/L-077
Neni 25 - Efekti i ofertës dhe i revokimit

1. Ofertuesi është i lidhur me ofertën, përveç nëse ofertuesi detyrimin e vet për ta mbajtur ofertën e ka
përjashtuar, apo në qoftë se ky përjashtim rrjedh nga rrethanat e rastit.
2. Oferta mund të revokohet vetëm në qoftë se i ofertuari e ka marrë revokimin përpara marrjes së
ofertës, apo njëkohësisht me të.', '5920990e830ba071ef56af78f52e1e001765d1e950e6948b4af0bfc6acd4f3ba', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":5,"pageEnd":5,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (25, '26', 'Oferta Detyruese', '1-6', 'Ligji 04/L-077
Neni 26 - Oferta Detyruese

1. Oferta në të cilën është caktuar afati për pranimin e saj, e detyron ofertuesin deri në skadimin e këtij
afati.
2. Në qoftë se ofertuesi në letër ose në telegram e ka caktuar afatin e pranimit, do të konsiderohet se
ky afat ka filluar të rrjedhë që nga data e shënuar në letër, ose në rast se nuk ka datë të shënuar në
letër, nga data e shënuar në zarf, përkatësisht që nga dita kur është dorëzuar telegrami në postë. Afati
për pranim i caktuar nga ofertuesi me telefon, teleks ose ndonjë mjet tjetër të drejtpërdrejtë të
komunikimit fillon të rrjedhë në momentin kur i ofertuari e merr ofertën.
3. Oferta e bërë personit në mungesë, në të cilën nuk është caktuar afati i pranimit, detyron ofertuesin
për kohën që nevojitet rregullisht që oferta t`i arrijë të ofertuarit, që ky ta shqyrtojë atë, të vendosë për
te dhe që përgjigjja për pranimin të arrijë ofertuesit.
4. Oferta që i bëhet personit të pranishëm (oferta e drejtpërdrejt) në të cilën asnjë afat kohor për pranim
nuk është caktuar, konsiderohet e refuzuar në rast se nuk është pranuar menjëherë, përveç nëse nga
rrethanat del se të oferetuarit i takon një kohë për të shqyrtuar ofertën.
5. Oferta e bërë me telefon, ose drejtpërdrejt me anë të radio-ndërlidhjes si dhe me mjete të
komunikimit drejtpërdrejt, konsiderohet si ofertë e bërë personit të pranishëm.
6. Në rast se afati kohor i caktuar për pranim nuk ka mbaruar ende, oferta pushon së qenuri e vlefshme
kur ofertuesi pranon deklaratën për refuzimin e saj.', '6a82af1bd2a6b7b08177c37e049645c53bba32bbc3e656e0855dfef858171c7a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":5,"pageEnd":6,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (26, '27', 'Forma e ofertës', '1-2', 'Ligji 04/L-077
Neni 27 - Forma e ofertës

1. Oferta e kontratës për lidhjen e së cilës ligji kërkon formë të veçantë e detyron ofertuesin vetëm po
qe se është bërë në këtë formë.
2. E njëjta vlen edhe për pranimin e ofertës.', '6c4159570b33bfb669418d545e8c8b89f7e5ab870ee304a1581f1fa2a3544c2b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":6,"pageEnd":6,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (27, '28', 'Pranimi i ofertës', '1-3', 'Ligji 04/L-077
Neni 28 - Pranimi i ofertës

1. Oferta është e pranuar kur ofertuesi e merr deklaratën e të ofertuarit se e pranon ofertën.
2. Oferta është e pranuar edhe atëherë kur i ofertuari e dërgon sendin ose e paguan çmimin, si dhe kur
bën ndonjë veprim tjetër i cili në bazë të ofertës, praktikës së vërtetuar midis palëve të interesuara ose
dokeve mund të konsiderohet si deklaratë për pranimin.
3. Pranimi mund të revokohet, në qoftë se ofertuesi e merr deklaratën për revokimin përpara deklaratës
për pranimin ose njëkohësisht me të.', 'c5fa0f032ca5dadf3f317662d63baa7cbe8c06149d10d8dcf7d16721749624ce', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":6,"pageEnd":6,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (28, '29', 'Pranimi i ofertës me propozimin për ndryshim', '1-3', 'Ligji 04/L-077
Neni 29 - Pranimi i ofertës me propozimin për ndryshim

1. Në rast se përgjigjja ndaj ofertës shpreh pranim, por njëkohësisht propozon që ajo diku të ndryshohet
ose të plotësohet, konsiderohet se i ofertuari e ka refuzuar ofertën dhe i ka bërë një ofertë tjetër
ofertuesit të mëparshëm.
2. Përgjigjja ndaj ofertës që shpreh pranim, por njëkohësisht përmban shtesa ose ndryshime që nuk e
ndryshojnë thelbësisht ofertën nënkupton pranim, përveç nëse ofertuesi kundërshton menjëherë. Në
rast se ofertuesi nuk vepron, kontrata lidhet në përputhje me përmbajtjen e ofertës me ndryshimet e
theksuara në deklaratën e pranimit.
3. Shtesat ose ndryshimet që lidhen me çmimin ose pagesat për cilësinë dhe sasinë e mallrave, vendin
dhe kohën e dorëzimit, nivelin e detyrimeve të njërës palë në krahasim me tjetrën ose zgjidhjen e
kontesteve konsiderohen ndryshim thelbësor i ofertës.', 'f6bcaff3fe454caa37b91f9b10586f9db4f1b7e43a8a8164ca8782cc343a8953', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":6,"pageEnd":6,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (29, '30', 'Heshtja e të ofertuarit', '1-5', 'Ligji 04/L-077
Neni 30 - Heshtja e të ofertuarit

1. Heshtja e të ofertuarit nuk do të thotë pranim i ofertës.
2. Nuk ka efekt dispozita në ofertë se me heshtje të të ofertuarit ose ndonjë lëshim tjetër i tij (p.sh. në
qoftë se nuk e refuzon ofertën brenda afatit të caktuar, apo në qoftë se sendin e dërguar për të cilin i
ofrohet kontrata nuk e kthen brenda afatit të caktuar etj.) do të konsiderohet si pranim.
3. Megjithatë, kur i ofertuari ndodhet në lidhje të vazhdueshme afariste me ofertuesin lidhur me mallin e
caktuar, konsiderohet se e ka pranuar ofertën që ka të bëjë me mallin e tillë, në qoftë se nuk e ka
refuzuar menjëherë ose brenda afatit që i është lënë.
4. Po kështu, personi që i është ofruar tjetrit që të zbatojë urdhrat e tij për kryerjen e punëve të
caktuara, si dhe personi në veprimtarinë afariste të të cilit hyn ushtrimi i urdhrave të tilla, ka për detyrë
ta zbatojë urdhrin e marr në qoftë se nuk e ka refuzuar menjëherë.
5. Në qoftë se në rastin nga paragrafi paraprak, oferta, përkatësisht urdhri nuk është refuzuar,
konsiderohet se kontrata është lidhur në çastin kur oferta, përkatësisht urdhri i ka arritur të ofertuarit.', '2952b67f9133f18b17a459bbfef887049cde668a74bed0a4c9cfccfed0708fe7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":6,"pageEnd":7,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (30, '31', 'Pranimi i vonuar dhe dërgimi i vonuar i deklaratës së pranimit', '1-2', 'Ligji 04/L-077
Neni 31 - Pranimi i vonuar dhe dërgimi i vonuar i deklaratës së pranimit

1. Pranimi i ofertës që bëhet me vonesë konsiderohet si ofertë e re nga i ofertuari, përveç nëse
ofertuesi e njofton menjëherë të ofertuarin se kontrata është lidhur në pajtim me ofertën e parë.
2. Në rast se është e qartë nga dokumenti që përmban pranimin e vonuar se është dërguar në rrethana
të tilla që ofertuesi do ta kishte pranuar atë në kohë po qe se do të ishte transferuar në mënyrë të
rregullt, kontrata do të konsiderohet e lidhur, përveç nëse ofertuesi e njofton menjëherë të ofertuarin se
oferta nuk konsiderohet detyruese për shkak të vonesës.', '3a48eb0b06c96ebdcedfa6f1ab77e295e334fa411cc257fd61274c82cb1cdc94', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":7,"pageEnd":7,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (31, '32', 'Vdekja ose paaftësia e njërës palë', null, 'Ligji 04/L-077
Neni 32 - Vdekja ose paaftësia e njërës palë

Oferta nuk e humb efektin, në qoftë se vdekja ose paaftësia e njërës palë është shkaktuar përpara
pranimit të saj, përveç nëse e kundërta del nga qëllimi i palëve, nga doket ose nga natyra e punës.', '225db51cb6df9e742211c727b7e51a335c7bcd31e19700e0624fe6ce82f2fe14', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":7,"pageEnd":7,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (32, '33', 'Parakontrata', '1-6', 'Ligji 04/L-077
Neni 33 - Parakontrata

1. Parakontrata është kontratë me të cilën merret përsipër detyrimi që më vonë të lidhet kontrata tjetër
kryesore.
2. Dispozitat mbi formën e kontratës kryesore vlejnë edhe për parakontratën, në qoftë se forma e
parashikuar është kusht i vlefshmërisë së kontratës.
3. Parakontrata detyron, në qoftë se i përmban elementet thelbësore të kontratës kryesore.
4. Me kërkesën e palës së interesuar, gjykata do ta urdhërojë palën tjetër që refuzon lidhjen e kontratës
kryesore ta bëjë këtë brenda afatit të cilin do t`ia caktojë.
5. Lidhja e kontratës kryesore mund të kërkohet brenda afatit prej gjashtë (6) muajsh nga skadimi i
afatit të parashikuar për lidhjen e saj, e në qoftë se ky afat nuk është parashikuar, atëherë prej ditës kur
sipas natyrës së punës dhe rrethanave konkrete, kontrata është dashur të lidhet.
6. Parakontrata nuk detyron në qoftë se rrethanat, prej lidhjes së saj kanë ndryshuar aq sa që nuk do të
lidhej fare po të ekzistonin rrethanat e tilla në atë kohë.', '1de86b349ff6e87180bf1619a02ccc68072e60091c8ec5f4b18faaec19ce44b7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":7,"pageEnd":7,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (33, '34', 'Objekti i detyrimit kontraktues', '1-2', 'Ligji 04/L-077
Neni 34 - Objekti i detyrimit kontraktues

1. Detyrimi kontraktues mund të përbëhet nga dhënia, veprimi, mosveprimi ose durimi.
2. Detyrimi duhet të jetë i mundshëm, i lejueshëm, i caktuar përkatësisht i caktueshëm.', '5a03225eb1f2beba8630e20e61469a2d1b95aefcb9d93466be0ac0311c81c2be', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":8,"pageEnd":8,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (34, '35', 'Kontrata nule', null, 'Ligji 04/L-077
Neni 35 - Kontrata nule

Kur objekti i detyrimit është i pamundur, i palejueshëm, i pacaktuar ose i cili nuk mund të caktohet,
kontrata është absolutisht e pavlefshme.', '9dab50b9106d81063860eb9ade16fa9ec5dc7aa56ad423aee5b3cdc22aed9ea4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":8,"pageEnd":8,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (35, '36', 'Kushti shtyrës', null, 'Ligji 04/L-077
Neni 36 - Kushti shtyrës

Kontrata e lidhur nën kushtin shtyrës, ose me afat është e vlefshme në qoftë se objekti i detyrimit i cili
në fillim ishte i pamundur është bërë i mundur para realizimit të kushteve apo skadimit të afatit.', '10948828d12253d7db6df91dab29ff3273c7145fa31154818cc1e34a1d327b46', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":8,"pageEnd":8,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (36, '37', 'Kur objekti i detyrimit është i palejueshëm', null, 'Ligji 04/L-077
Neni 37 - Kur objekti i detyrimit është i palejueshëm

Objekti i detyrimit është i palejueshëm, në qoftë se është në kundërshtim me dispozitat e rendit publik,
dispozitat tjera urdhëruese dhe moralin e shoqërisë.', '543d590a65f5156428e3d64abf8e1af5eba912f5eb347375d3c8f90250a23974', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":8,"pageEnd":8,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (37, '38', 'Kur objekti është i caktueshëm', '1-2', 'Ligji 04/L-077
Neni 38 - Kur objekti është i caktueshëm

1. Objekti i detyrimit është i caktueshëm në qoftë se kontrata përmban të dhënat me ndihmën e të
cilave mund të caktohet objekti, apo nëse palët ia kanë lënë personit të tretë që ta caktojnë objektin.
2. Në qoftë se ky person i tretë nuk dëshiron apo nuk mund ta caktojë objektin e detyrimit, kontrata
është absolutisht e pavlefshme.', '3c3ec1d4a60271b78eb5d1f50862eae3d42c6148c4b5b161baf1cfadb6b471fa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":8,"pageEnd":8,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (38, '39', 'Baza e lejueshme', '1-4', 'Ligji 04/L-077
Neni 39 - Baza e lejueshme

1. Secili detyrim kontraktues duhet të ketë bazën e lejueshme.
2. Baza është e palejushme në rast se është në kundërshtim me dispozitat e rendit publik, dispozitat
tjera urdhëruese dhe moralin e shoqërisë.
3. Konsiderohet se detyrimi ka bazë, edhe në rast se kjo nuk është e shprehur.
4. Në rast se nuk ka bazë ose baza është e palejueshme, kontrata është nul dhe absolutisht e
pavlefshme.', 'a2db6abdc6652c198bf96b561a2426548f4c4e587a6c7679cd1764b44194123a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":8,"pageEnd":8,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (39, '40', 'Motivet për lidhjen e kontratës', '1-3', 'Ligji 04/L-077
Neni 40 - Motivet për lidhjen e kontratës

1. Motivet nga të cilat është lidhur kontrata nuk ndikojnë në plotfuqishmërinë e saj.
2. Megjithatë, ne qoftë se motivi i palejueshëm ka ndikuar esencialisht që një nga kontraktuesit të
vendosë lidhjen e kontratës dhe në qoftë se këtë gjë kontraktuesi tjetër e ka ditur ose është dashur ta
dinte, kontrata do të jetë pa efekt.
3. Kontrata pa shpërblim nuk ka efekt juridik edhe kur kontraktuesi tjetër nuk ka ditur se motivi i
palejueshëm ka ndikuar esencialisht në vendimin e bashkë kontraktuesit të tij.', '5ca14d9caf335b3a75bd1218fa6cf5d850c17f8036786c911c8b36bf16736c0a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":8,"pageEnd":9,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (40, '41', 'Kontrata e personit të paaftë për të vepruar', '1-3', 'Ligji 04/L-077
Neni 41 - Kontrata e personit të paaftë për të vepruar

1. Për lidhjen e kontratës së vlefshme nevojitet që kontraktuesi të ketë zotësinë për të vepruar që
kërkohet për lidhjen e kësaj kontrate.
2. Personi me zotësi të kufizuar për të vepruar mundet pa lejen e përfaqësuesit të vet ligjor të lidhë
vetëm ato kontrata, lidhja e të cilave i lejohet nga ligji.
3. Kontratat e tjera të këtyre personave janë të rrëzueshme, në qoftë se janë lidhur pa lejen e
përfaqësuesit ligjor, por mund të fuqizohen me aprovimin e mëvonshëm të të njëjtave.', 'b857cfa9c6b4550d5a617e87da6c58ea4ff92aa1ddb6ca774a98c73c6ae3efa9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":9,"pageEnd":9,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (41, '42', 'E drejta e bashkë kontraktuesve të personit të paaftë për të vepruar', '1-3', 'Ligji 04/L-077
Neni 42 - E drejta e bashkë kontraktuesve të personit të paaftë për të vepruar

1. Bashkë kontraktuesi i personit të paaftë për të vepruar,i cili nuk ka ditur për paaftësinë e tij për të
vepruar mund të heqë dorë nga kontrata që ka lidhur me të pa lejen e përfaqësuesit të tij ligjor.
2. Të njëjtën të drejtë e ka edhe bashkë kontraktuesi i personit të paaftë për të vepruar që ka ditur për
paaftësinë e tij për të vepruar, por ka qenë i mashtruar prej tij se e ka lejen e përfaqësuesit të vet ligjor.
3. Kjo e drejt shuhet pasi të kenë kaluar tridhjetë (30) ditë nga data kur të ketë mësuar për paaftësinë
për të vepruar të palës tjetër, respektivisht për mungesën e lejen të përfaqësuesit ligjor, por shuhet
edhe më përpara në qoftë se përfaqësuesi ligjor do ta lejojë kontratën para se të ketë skaduar ky afat.', '118eee71668a74a69426adbeccc7e954d53951da6f9d2535adb46c2f996e5a73', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":9,"pageEnd":9,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (42, '43', 'Ftesa e përfaqësuesit ligjor për t''u deklaruar', '1-2', 'Ligji 04/L-077
Neni 43 - Ftesa e përfaqësuesit ligjor për t''u deklaruar

1. Bashkë kontraktuesi i personit të paaftë për të vepruar që ka lidhur kontratën me këtë te fundit pa
lejen e përfaqësuesit të tij ligjor mund ta ftojë përfaqësuesin e tij ligjor që të deklarohet se a e aprovon
ose jo këtë kontratë.
2. Në qoftë se përfaqësuesi ligjor nuk deklarohet brenda tridhjetë (30) ditësh nga data e kësaj ftese për
lejimin e kontratës, do të konsiderohet se ka refuzuar ta japë lejen.', 'd05657a1b662827d6d0bac93d03558f71e202129ac629eced6646f28f1cb9bb1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":9,"pageEnd":9,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (43, '44', 'Kur kontraktuesi e fiton zotësinë për të vepruar pas lidhjes së kontratës', null, 'Ligji 04/L-077
Neni 44 - Kur kontraktuesi e fiton zotësinë për të vepruar pas lidhjes së kontratës

Personi i aftë për të vepruar mund të kërkojë që të anulohet kontrata të cilën, pa autorizimin e
nevojshëm, e ka lidhur gjatë kohëzgjatjes së zotësisë së kufizuar për të vepruar, vetëm në qoftë se
padinë e ka paraqitur brenda tre (3) muajsh nga data e fitimit të zotësisë së plotë për të vepruar.', '946b2f9a42b67610df77bf8df14102426dd09022b7494e7420d9cd64fbd102d9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":9,"pageEnd":9,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (44, '45', 'Kanosja', '1-2', 'Ligji 04/L-077
Neni 45 - Kanosja

1. Në qoftë se pala kontraktuese ose ndonjë i tretë me kanosje të palejueshme ka shkaktuar frikësim të
bazuar te pala tjetër, kështu që kjo për këtë arsye e ka lidhur kontratën, pala tjetër mund të kërkojë që
kontrata të anulohet.
2. Frika konsiderohet e bazuar në qoftë se nga rrethanat shihet se nga rreziku serioz është cenuar jeta
trupi ose ndonjë e mirë tjetër e rëndësishme e palës kontraktuese ose e personit të tretë.', 'ef2cf6fcd3f05ab9535ff1288fa987d243a02816765b7b98cff681924f89f630', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":10,"pageEnd":10,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (45, '46', 'Lajthimi thelbësor', '1-4', 'Ligji 04/L-077
Neni 46 - Lajthimi thelbësor

1. Lajthimi është thelbësor, në qoftë se ka të bëjë me elementet thelbësore të objektit, me personin me
të cilin lidhet kontrata, në qoftë se lidhet duke marrë parasysh këtë person, si dhe me rrethanat të cilat
sipas dokeve që praktikohen ose sipas qëllimit të palëve, konsiderohen vendimtare, ndërsa pala që
është në lajthim nuk do ta lidhte përndryshe kontratën me përmbajtje të tillë.
2. Pala e cila është në lajthim mund të kërkojë të shpallet e pavlefshme kontrata për shkak të lajthimit
thelbësor, përveç nëse gjatë lidhjes së kontratës nuk ka vepruar me kujdesin që kërkohet në qarkullim.
3. Nëse kontrata shpallet e pavlefshme për shkak të lajthimit, pala tjetër me mirëbesim ka të drejtë të
kërkojë shpërblim për dëmin e pësuar.
4. Pala e cila është në lajthim nuk mund t`i referohet lajthimit, në qoftë se pala tjetër është e gatshme ta
përmbushë kontratën sikur lajthimi të mos kishte ekzistuar fare.', 'ecf6cf884701a5409f3f5f1b7e02eb817b91d8087293f81a477e9ab9458bc313', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":10,"pageEnd":10,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (46, '47', 'Lajthimi për motivin te kontrata pa shpërblim', null, 'Ligji 04/L-077
Neni 47 - Lajthimi për motivin te kontrata pa shpërblim

Te kontrata pa shpërblim lajthim thelbësor konsiderohet edhe lajthimi për motivin që ka qenë vendimtar
për marrjen përsipër të detyrimit.', '7e6939719e7e820ac128e57d2cea269fd2868cfed63640f4b19862589a41db13', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":10,"pageEnd":10,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (47, '48', 'Deklarata e tërthortë', null, 'Ligji 04/L-077
Neni 48 - Deklarata e tërthortë

Lajthimi i personit me anë të të cilit pala ka shprehur vullnetin e saj konsiderohet se është njësoj si dhe
lajthimi në shfaqjen e vullnetit vetjak.', '6f6ba0181cb5e94283cb9d27eaa9ac5067c029fddbe0f9584867bf85bb2ae09a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":10,"pageEnd":10,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (48, '49', 'Mashtrimi', '1-4', 'Ligji 04/L-077
Neni 49 - Mashtrimi

1. Në qoftë se njëra palë shkakton lajthim te pala tjetër, ose mban në lajthim me qëllim që me këtë ta
shtyj për lidhjen e kontratës, pala tjetër mund të kërkojë të shpallet e pavlefshme kontrata edhe atëherë
kur lajthimi nuk është thelbësor.
2. Pala që ka lidhur kontratë duke qenë e mashtruar, ka të drejtë që të kërkojë shpërblim për dëmin e
pësuar.
3. Në qoftë se mashtrimin e ka bërë personi i tretë, mashtrimi ndikon në vetë kontratën në qoftë se pala
tjetër kontraktuese në kohën e lidhjes së kontratës ishte në dijeni ose është dashur të dinte për
mashtrimin.
4. Kontrata pa shpërblim mund të shpallet e pavlefshme edhe kur mashtrimin e ka bërë personi i tretë,
pavarësisht nëse pala tjetër kontraktuese në kohën e lidhjes së kontratës e ka ditur ose është dashur të
dinte për mashtrimin.', 'c2b9fbfb8905bbb495dc3724c30a56ce835dd271b13535bd13958b06d87132b9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":10,"pageEnd":10,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (49, '50', 'Kontrata fiktive', '1-3', 'Ligji 04/L-077
Neni 50 - Kontrata fiktive

1. Kontrata fiktive nuk ka efekt juridik ndërmjet palëve kontraktuese.
2. Në qoftë se kontrata fiktive fsheh ndonjë kontratë tjetër, atëherë kjo e dyta është e vlefshme, nëse
janë plotësuar kushtet për vlefshmërinë e saj e saj juridike.
3. Fiktiviteti i kontratës nuk mund të theksohet ndaj personit të tretë.', '158ca4fcf5080df67245cd5e208ad4a778c0fa4849b1c3130a3540dd8650a9ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":11,"pageEnd":11,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (50, '51', 'Joformaliteti i kontratës', '1-4', 'Ligji 04/L-077
Neni 51 - Joformaliteti i kontratës

1. Lidhja e kontratës nuk i nënshtrohet asnjë forme, përveç nëse me ligj është caktuar ndryshe.
2. Përcaktimi me ligj, që kontrata të lidhet në një formë të caktuar vlen edhe për të gjitha ndryshimet
ose plotësimet e mëvonshme të kontratës.
3. Megjithatë, të vlefshme janë plotësimet e mëvonshme gojore për elementet sekondare, për të cilat
në kontratën formale nuk është thënë asgjë, në qoftë se kjo nuk është në kundërshtim me qëllimin për
të cilin është parashikuar forma.
4. Të vlefshme janë edhe ujditë e mëvonshme gojore me të cilat zvogëlohen ose lehtësohen detyrimet
e njërës ose të palës tjetër, në qoftë se forma e veçantë është parashikuar vetëm në interesin e palëve
kontraktuese.', '7ec3ffa229fb10339cbdb94e5fbe83ca20baf5b8a06b5a356bab54096562efca', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":11,"pageEnd":11,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (51, '52', 'Forma e kontratës për transferin e titullit të paluajtshmërisë', null, 'Ligji 04/L-077
Neni 52 - Forma e kontratës për transferin e titullit të paluajtshmërisë

Kontrata në bazë të së cilës transferohet titulli i paluajtshmërisë ose përmes së cilës krijohet një e drejtë
tjetër subjektive për paluajtshmërinë duhet të lidhet në formën e shkruar.', 'b86d73f8d25b03c60e0e1d8fa4b374036b23d44eff7a4b61ff32214d0aea8f29', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":11,"pageEnd":11,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (52, '53', 'Zgjidhja e kontratave formale', null, 'Ligji 04/L-077
Neni 53 - Zgjidhja e kontratave formale

Kontratat formale mund të zgjidhen me marrëveshje joformale, përveç nëse në rastin e caktuar nga ligji
parashikohet ndryshe, ose kur qëllimi për të cilin është parashikuar forma për lidhjen e kontratës kërkon
që zgjidhja e kontratës të bëhet në të njëjtën formë.', '4bca0a89ffabc76124dc0455728b90bae2977bc1819b121474f9e32201857990', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":11,"pageEnd":11,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (53, '54', 'Forma e kontraktuar', '1-3', 'Ligji 04/L-077
Neni 54 - Forma e kontraktuar

1. Palët kontraktuese mund të merren vesh, që forma e veçantë të jetë kusht për vlefshmërinë e
kontratës së tyre.
2. Kontrata për lidhjen e së cilës është kontraktuar forma e veçantë mund të zgjidhet, të plotësohet ose
të ndryshohet në ndonjë mënyrë tjetër edhe me marrëveshje joformale.
3. Në qoftë se palët kontraktuese kanë parashikuar formën e caktuar vetëm për të siguruar provën për
lidhjen e kontratës së tyre, ose për të arritur diçka tjetër, kontrata është e lidhur kur të jetë arritur pëlqimi
për përmbajtjen e saj, ndërsa për kontraktuesin ka lindur në të njëjtën kohë detyrimi që kontratës t`i
japin formën e parashikuar.', '99c956d27dd269e429e4242309d06409b95ad7ba580a09cdd7d96db33a673b6f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":11,"pageEnd":11,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (54, '55', 'Sanksioni për mungesë të formës së nevojshme', '1-2', 'Ligji 04/L-077
Neni 55 - Sanksioni për mungesë të formës së nevojshme

1. Kontrata që nuk është e lidhur në formën e parashikuar nuk ka efekt juridik, në qoftë se nga qëllimi i
dispozitës me të cilën është caktuar forma nuk del diçka tjetër.
2. Kontrata që nuk është lidhur në formën e kontraktuar nuk ka efekt juridik, në qoftë se palët e kanë
kushtëzuar vlefshmërinë e kontratës me formë të veçantë.', '94d762c3362ac959fa777af9eb7c9ce97864c341a3fe9dfa75b092e86d3cff45', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":12,"pageEnd":12,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (55, '56', 'Kushti i plotësisë së dokumentit', '1-3', 'Ligji 04/L-077
Neni 56 - Kushti i plotësisë së dokumentit

1. Në qoftë se kontrata është lidhur në formë të veçantë, si në bazë të ligjit ashtu edhe në bazë të
vullnetit të palëve, vlen vetëm ajo që është shprehur në këtë formë.
2. Megjithatë, do të jenë të vlefshme ujditë e njëkohshme gojore për elementet sekondare për të cilat
në kontratën formale nuk është thënë asgjë, në qoftë se nuk janë në kundërshtim me përmbajtjen e saj,
apo nëse nuk janë në kundërshtim me qëllimin për të cilin është parashikuar forma.
3. Të vlefshme janë edhe marrëveshjet e njëkohshme gojore që i zvogëlojnë ose i lehtësojnë detyrimet
e njërës ose të të dy palëve, në qoftë se forma e veçantë është parashikuar vetëm në interesin e
palëve kontraktuese.', 'c1040fa9de76d64d0e30e7c7383ce1e8e752436610ff61eeb042dbb37edcc94f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":12,"pageEnd":12,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (56, '57', 'Përpilimi i dokumentit', '1-5', 'Ligji 04/L-077
Neni 57 - Përpilimi i dokumentit

1. Kur për lidhjen e kontratës nevojitet përpilimi i dokumentit, kontrata është e lidhur kur dokumentin ta
nënshkruajnë të gjithë personat që detyrohen prej saj.
2. Kontraktuesi që nuk di të shkruajë do të vejë në dokument shenjën e gishtit të vërtetuar nga dy
dëshmitarë ose nga gjykata apo organi tjetër.
3. Për lidhjen e kontratës dypalëshe mjafton që të dy palët ta nënshkruajnë një dokument ose që secila
prej palëve të nënshkruajë kopjen e dokumentit të destinuar palës tjetër.
4. Kërkesa e formës me shkrim është e përmbushur, në qoftë se palët këmbejnë letra ose merren vesh
me ndonjë mjet tjetër që bënë të mundur që me siguri të përcaktohet përmbajtja dhe personi, i cili e ka
dhënë deklaratën.
5. Në qoftë se me ligj shprehimisht nuk caktohet ndryshe, forma me shkrim zëvendësohet edhe me
deklarata me mjete elektronike, për të cilat zbatohen dispozitat e ligjit të veçantë.', '84c4d327e5b9bf63d854a8b452454c7e788a8c52b711428c3c9db3204e526101', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":12,"pageEnd":12,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (57, '58', 'Kur kontrata e përmbushur të cilës i mungon forma me shkrim është e vlefshme', null, 'Ligji 04/L-077
Neni 58 - Kur kontrata e përmbushur të cilës i mungon forma me shkrim është e vlefshme

Kontrata, për lidhjen e së cilës kërkohet forma me shkrim është e vlefshme edhe pse nuk është lidhur
në këtë formë, në qoftë se palët kontraktuese detyrimet i kanë përmbushur në tërësi ose në pjesën më
të madhe që dalin nga kontrata, përveç nëse qartë del ndryshe nga qëllimi për të cilin është
parashikuar forma.', 'da91bb251104d0f37cd18c1590622a7384a7358b9aef7cadff15a0666a9ed13f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":12,"pageEnd":12,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (58, '59', 'Kushtet dhe efektet e tyre', '1-4', 'Ligji 04/L-077
Neni 59 - Kushtet dhe efektet e tyre

1. Kontrata quhet e lidhur me kusht, në qoftë se krijimi ose shuarja e saj varen nga një fakt i pasigurt.
2. Në qoftë se kontrata lidhet nën kusht shtyrës (pezullues) dhe kushti plotësohet, efekti i kontratës
fillon që nga lidhja e saj, përveç nëse nga ligji, karakteri i punës ose vullneti i palëve del diç tjetër.
3. Në qoftë se kontrata lidhet nën kushtin zgjidhës, kontrata pushon të vlejë në qoftë se kushti
plotësohet.
4. Konsiderohet se kushti është realizuar në qoftë se realizimi i tij, në kundërshtim me parimin e
ndërgjegjshmërisë dhe të ndershmërisë, e parandalon pala në dëm të së cilës është caktuar, ndërsa
konsiderohet se nuk është realizuar në qoftë se realizimi i tij, në kundërshtim me parimin e
ndërgjegjshmërisë dhe të ndershmërisë, e shkakton pala në dobi të së cilës është caktuar.', 'c7422a624b7f4c6f6f8f4549556e448b28c37c963c80edd509fe553394556c84', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":12,"pageEnd":13,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (59, '60', 'Efekti prapaveprues', null, 'Ligji 04/L-077
Neni 60 - Efekti prapaveprues

Nëse sipas përmbajtjes së kontratës pasojat që krijohen me përmbushjen e një kushti kanë efekt që
nga një moment më i hershëm kohor, atëherë, në rast të përmbushjes së këtij kushti, pjesëmarrësit
janë të detyruar që t`i mundësojnë njëri tjetrit atë që do të kishin mundësuar, sikur pasojat të kishin
lindur në çastin më të hershëm kohorë.', 'defec07797b0bfcdcb10ca6576876d2ba606f7c4f9d510db5ea9ad0a741903d0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":13,"pageEnd":13,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (60, '61', 'Kushti i palejueshëm ose i pamundur', '1-2', 'Ligji 04/L-077
Neni 61 - Kushti i palejueshëm ose i pamundur

1. Është e pavlefshme kontrata në të cilën është vënë kushti shtyrës ose zgjidhës në kundërshtim me
dispozitat urdhëruese, rendin publik ose moralin e shoqërisë.
2. Kontrata e lidhur nën kusht të pamundshëm shtyrës është e pavlefshme, ndërsa kushti i
pamundshëm zgjidhës konsiderohet i paqenë.', 'b0521ad694706036e66c065c464b7c7b29df55d52dfd4493111a31dae8c95416', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":13,"pageEnd":13,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (61, '62', 'Sigurimi i të drejtës kushtëzuese', null, 'Ligji 04/L-077
Neni 62 - Sigurimi i të drejtës kushtëzuese

Në qoftë se kontrata është e lidhur me kusht shtyrës, kreditori, e drejta e të cilit është kushtëzuar, mund
të kërkojë sigurimin përkatës të kësaj të drejte në qoftë se realizimi i saj është rrezikuar.', 'b5b3a99731bbf46b7c64708cc5622f81b73369552ec96f163ea3fcd37d9ee1d3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":13,"pageEnd":13,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (62, '63', 'Mbrojtja e së drejtës së kushtëzuar', '1-2', 'Ligji 04/L-077
Neni 63 - Mbrojtja e së drejtës së kushtëzuar

1. Përfituesi nga puna juridike e lidhur nën kushtin shtyrës mundet, në rast të përmbushjes së këtij
kushti, të kërkojë shpërblimin e dëmit nga pala tjetër, në qoftë se kjo para përmbushjes së kushtit me
fajin e saj e ka pamundësuar ose kufizuar të drejtën e cila varet nga ky kusht.
2. Në rast të kontratës së lidhur nën kushtin zgjidhës, të njëjtën të drejtë dhe nën të njëjtat kushte e ka
ai në dobi të të cilit rikthehet gjendja e mëhershme juridike.', 'ee3aab21e16ab42ed5b9e20d9dc2fd64d090104f7a33b6746586dc4fc33c3da2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":13,"pageEnd":13,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (63, '64', 'Pavlefshmëria e disponimeve gjatë kohëzgjatjes së kushtit', '1-3', 'Ligji 04/L-077
Neni 64 - Pavlefshmëria e disponimeve gjatë kohëzgjatjes së kushtit

1. Nëse dikush e ka në dispozicion një objekt nën kushtin shtyrës, atëherë çdo disponim tjetër, të cilin e
ndërmerr para plotësimit të kushtit, bëhet i pavlefshëm në momentin e plotësimit të kushtit, në masë për
sa disponimi do të pengonte ose dëmtonte arritjen e qëllimit që varet nga kushti.
2. E njëjta vlen në rast të një kushti zgjidhës për disponimet e atij, e drejta e të cilit shuhet me
plotësimin e këtij kushti.
3. Dispozitat mbi mbrojtjen e të drejtave të personave të tretë në mirëbesim zbatohen
përshtatshmërisht.', '5af3fa2fc5ce05f5ad14793a93132ebd30332b27b4975e88665aa98c574fe4eb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":13,"pageEnd":13,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (64, '65', 'Llogaritja e afateve', '1-4', 'Ligji 04/L-077
Neni 65 - Llogaritja e afateve

1. Afati i caktuar në ditë fillon të rrjedhë ditën e parë pas ngjarjes nga e cila mund të llogaritet afati,
ndërsa përfundon me skadimin e ditës së fundit, të afatit.
2. Afati i caktuar në javë, muaj ose vite përfundon atë ditë që me emër dhe numër përputhet me ditën e
lindjes së ngjarjes nga e cila ka filluar të rrjedhë afati; e në qoftë se një ditë e tillë nuk ekziston në
muajin e fundit, fundi i afatit bie në ditën e fundit të atij muaji.
3. Në qoftë se dita e fundit e afatit bie në ditën kur në bazë të ligjit është caktuar që të mos punohet, si
ditë e fundit e afatit llogaritet dita e parë e punës në vijim.
4. Fillimi i muajit shënon ditën e parë të muajit, mesi i muajit me pesëmbëdhjetë (15) të muajt, dhe fundi
i muajit në ditën e fundit të muajit, në qoftë se diçka tjetër nuk rezulton nga qëllimi i palëve, nga natyra e
marrëdhënies, ose nga doket.', 'fd65ffa725cc4c5ba1d76c143328320de705aafb4220a96bbd78022d28c64524', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":14,"pageEnd":14,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (65, '66', 'Aplikimi i rregullave për kushtin', null, 'Ligji 04/L-077
Neni 66 - Aplikimi i rregullave për kushtin

Kur efekti i kontratës fillon që nga koha e caktuar vihen në zbatim rregullat për kushtin shtytës; kur
kontrata pushon të jetë në fuqi pas mbarimit të kohës së caktuar, vihen në zbatim rregullat për kushtin
zgjidhës.', '81dc532cc51c1ef75b63496028f8c68d3b66b0a091b04edd5704318b66b266b2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":14,"pageEnd":14,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (66, '67', 'Kthimi dhe llogaritja e kaparit', '1-3', 'Ligji 04/L-077
Neni 67 - Kthimi dhe llogaritja e kaparit

1. Në qoftë se në çastin e lidhjes së kontratës njëra palë ia ka dhënë palës tjetër një shumë të hollash,
ose një sasi sendesh të tjera të zëvendësueshme si shenjë se kontrata është lidhur (kapari), kontrata
konsiderohet e lidhur kur kapari të jetë dhënë, në qoftë se nuk është kontraktuar diç tjetër.
2. Kapari llogaritet në përmbushjen e detyrimit, e në qoftë se kjo nuk është e mundur, atëherë ai
(kapari) duhet të kthehet në çastin e përmbushjes.
3. Në qoftë se nuk është kontraktuar diç tjetër, pala që e ka dhënë kaparin nuk mund të heqë dorë nga
kontrata, duke ia lënë kaparin palës tjetër, e as që mund ta bëjë këtë pala tjetër duke e kthyer kaparin e
dyfishuar.', 'd57d3debb4646bb6910ad98064b79a937dc6743166b9f044c45f12d5856e58f5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":14,"pageEnd":14,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (67, '68', 'Mos përmbushja e kontratës', '1-4', 'Ligji 04/L-077
Neni 68 - Mos përmbushja e kontratës

1. Në qoftë se për mos përmbushjen e kontratës është përgjegjëse pala që e ka dhënë kaparin, pala
tjetër mundet, sipas vullnetit së saj të kërkojë përmbushjen e kontratës, në qoftë se kjo është ende e
mundshme dhe të kërkojë shpërblimin e demit. Ajo mundet kaparin ta kompensojë me shpërblimin e
dëmit ose ta kthejë ose pala mundet të pajtohet me kaparin e marrur.
2. Në qoftë se për mos përmbushjen e kontratës është përgjegjëse pala që e ka marrë kaparin, pala
tjetër mundet, sipas zgjedhjes së saj të kërkojë përmbushjen e kontratës, po të jetë kjo ende e mundur
ose të kërkojë shpërblimin e dëmit dhe kthimin e kaparit, ose të kërkojë kthimin e kaparit të dyfishuar.
3. Sidoqoftë, kur pala tjetër, kërkon zbatimin e kontratës, ajo ka të drejtë edhe për shpërblimin e dëmit
që pëson për shkak të vonesës.
4. Gjykata mundet, me kërkesë të palës së interesuar, ta zvogëlojë kaparin tepër të lartë.', 'de427e4661800f8e797e86008a4478cdda5567f66296634e4c4a1cf72ba6b490', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":14,"pageEnd":15,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (68, '69', 'Përmbushja e pjesshme', '1-2', 'Ligji 04/L-077
Neni 69 - Përmbushja e pjesshme

1. Në rastin e përmbushjes së pjesshme të detyrimit, kreditori nuk mund ta mbajë kaparin, por mund të
kërkojë përmbushjen e detyrimit të mbetur dhe shpërblimin e dëmit për shkak të vonesës, apo të
kërkojë shpërblimin e dëmit për shkak të përmbushjes jo të plotë, por në dy rastet kapari llogaritet në
shpërblimin e dëmit.
2. Në qoftë se kreditori e zgjidhë kontratën dhe e kthen atë që ka marrë si përmbushje të pjesshme, ai
mund të zgjedhë midis kërkesave të tjera që i takojnë njërës palë kur kontrata ka mbetur e pa
përmbushur me faj të tjetrës.', 'ae0208488e3e4c3a05b9a8c2174a235cee96beeadbe43dd7ee7741d511953f44', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":15,"pageEnd":15,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (69, '70', 'Pendimi', '1-5', 'Ligji 04/L-077
Neni 70 - Pendimi

1. Me marrëveshjen e palëve kontraktuese mund të autorizohet njëra ose secila palë që të heqë dorë
nga kontrata duke e dhënë pendimin.
2. Kur pala në dobi të së cilës është kontraktuar pendimi i deklaron palës tjetër se do ta jep pendimin,
ajo nuk mund të kërkojë më përmbushjen e kontratës.
3. Pala e autorizuar për të hequr dorë ka për detyrë të japë pendimin njëkohësisht me deklaratën për
heqjen dorë.
4. Në qoftë se kontraktuesit nuk e kanë caktuar afatin brenda të cilit pala e autorizuar mund të heqë
dorë nga kontrata, ajo mund ta bëjë këtë gjithnjë gjersa të mos kalojë afati i caktuar për përmbushjen e
detyrimit të saj.
5. Kjo e drejtë e heqjes dorë nga kontrata mbaron edhe kur, pala në favor të së cilës është kontraktuar,
fillon t`i përmbushë detyrimet nga kjo kontratë ose të pranojë përmbushjen nga pala tjetër.', 'bfc4ccd57244f9d584f57bb863587f92efa0fea30041b9b73f0239ded013a1ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":15,"pageEnd":15,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (70, '71', 'Kapari si pendim', '1-2', 'Ligji 04/L-077
Neni 71 - Kapari si pendim

1. Kur bashkë me kaparin është kontraktuar e drejta e heqjes dorë nga kontrata, atëherë kapari
konsiderohet si pendim dhe secila palë mund të heqë dorë nga kontrata.
2. Në këtë rast, në qoftë se heq dorë pala që e ka dhënë kaparin, kjo e humb atë, e në qoftë se heq
dorë pala që e ka marrë kaparin, ajo e kthen të dyfishuar.', 'fb2031e4e0ee0ee9143e3e1a5763b5d8c87e1b6117b0265011daf5d09ee76f43', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":15,"pageEnd":15,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (71, '72', 'Mundësia e përfaqësimit', '1-2', 'Ligji 04/L-077
Neni 72 - Mundësia e përfaqësimit

1. Lidhja e kontratës dhe punët e tjera juridike mund të kryhen edhe me përfaqësues.
2. Autorizimi për përfaqësim bazohet në ligj, në aktin e përgjithshëm të personit juridik, në aktin e
organit kompetent ose në deklarimin e vullnetit të të përfaqësuarit (prokura).', 'faaa9b9543efae07c012e966eee5bb5b00830ae60f0b3788da3ad9e43cb6cde5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":16,"pageEnd":16,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (72, '73', 'Efekti i përfaqësimit', '1-3', 'Ligji 04/L-077
Neni 73 - Efekti i përfaqësimit

1. Kontrata të cilën e lidhë përfaqësuesi në emër të personit të përfaqësuar dhe në kuadrin e
autorizimeve të veta, e obligon drejtpërdrejt të përfaqësuarin dhe palën tjetër kontraktuese.
2. Nën të njëjtat kushtet edhe veprimet e tjera juridike të përfaqësuesit krijojnë efekt juridik direkt ndaj
personit të përfaqësuar
3. Përfaqësuesi ka për detyrë ta njoftojë palën tjetër se paraqitet në emër të personit të përfaqësuar,
por edhe kur nuk e bënë këtë gjë kontrata ka efekt juridik për të përfaqësuarin dhe për palën tjetër, në
qoftë se kjo ka ditur, ose nga rrethanat, ka mundur të vijë në përfundim se ai paraqitet si përfaqësues.', '0f43a466a5f2c5df5e021c4fe11435682e17775777cdbed28426976798b07d32', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":16,"pageEnd":16,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (73, '74', 'Bartja e autorizimeve', '1-2', 'Ligji 04/L-077
Neni 74 - Bartja e autorizimeve

1. Përfaqësuesi nuk mund të bëjë bartjen e autorizimeve ta veta në tjetrin, përveç nëse kjo i është
lejuar me ligi ose me kontratë.
2. Përjashtimisht, ai mund ta bëjë këtë, në qoftë se është i penguar nga rrethanat që punën ta kryejë
vetë, kurse interesat e të përfaqësuarit kërkojnë ndërmarrjen pa vonesë të veprimit juridik.', 'bc2b9338c1a6c0f67ad130d1a28d083d421d3c5847a6863fd4aee7ce402ff570', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":16,"pageEnd":16,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (74, '75', 'Tejkalimi i kufirit të autorizimit', '1-5', 'Ligji 04/L-077
Neni 75 - Tejkalimi i kufirit të autorizimit

1. Kur përfaqësuesi i tejkalon kufijtë e autorizimit, i përfaqësuari është në obligim vetëm në qoftë se e
miraton kapërcimin.
2. Në qoftë se i përfaqësuari nuk e aprovon kontratën brenda afatit që nevojitet rregullisht që kontrata e
llojit të tillë të shqyrtohet e të vlerësohet, do të konsiderohet se aprovimi nuk është dhënë fare.
3. Aprovimi i specifikuar nga paragrafi paraprak ka efekt prapaveprues, në qoftë se palët nuk caktojnë
ndryshe.
4. Në qoftë se pala tjetër nuk ka ditur dhe as që është dashur ta dinte për kapërcimin e autorizimit,
menjëherë posa ta ketë mësuar për tejkalimin e bërë, mundet duke mos pritur që i përfaqësuari të
deklarohet rreth kontratës, ta deklarojë se nuk e quan vetën të obliguar nga kontrata.
5. Në qoftë se i përfaqësuari e refuzon lejimin, përfaqësuesi dhe i përfaqësuari janë solidarisht
përgjegjës për dëmin që e ka pësuar pala tjetër, po që se kjo nuk ka ditur dhe as që është dashur te
ishte ne dijeni për tejkalimin e autorizimit.', '33b2fda2066525feeea517df7aa9eb0217aad6f7509107dec0b8cd2e0cb7f0d2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":16,"pageEnd":17,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (75, '76', 'Lidhja e kontratës nga personi i paautorizuar', '1-4', 'Ligji 04/L-077
Neni 76 - Lidhja e kontratës nga personi i paautorizuar

1. Kontrata që lidhet prej ndonjë personi si i autorizuari në emër të tjetrit pa autorizimin e këtij, e obligon
personin e përfaqësuar në mënyrë të paautorizuar vetëm nëse ky e aprovon kontratën më vonë.
2. Pala me të cilën është lidhur kontrata mund të kërkojë nga personi i përfaqësuar në mënyrë të
paautorizuar që në afatin e caktuar të deklarohet nëse e lejon kontratën ose jo.
3. Në qoftë se personi i përfaqësuar në mënyrë ta paautorizuar as edhe në afatin e lënë të kontratës
nuk e lejon atë, konsiderohet sikur kontrata ta mos jetë lidhur fare.
4. Në këtë rast pala me të cilin është lidhur kontrata, mund të kërkojë nga personi i cili si përfaqësues e
ka lidhur kontratën pa autorizim kompensimin e dëmit, në qoftë se në çastin e lidhjes se kontratës nuk e
ka ditur e as që është dashur ta dije se ky person nuk ka pasur autorizim për lidhjen e kontratës.', '18e5c758cb3eb63d17b47c7d995c16c569c5bd8df67ce6df4941542d494338c0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":17,"pageEnd":17,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (76, '77', 'Dhënia e prokurës', '1-3', 'Ligji 04/L-077
Neni 77 - Dhënia e prokurës

1. Prokura përmban autorizimin për përfaqësim që i jepet me punë juridike të autorizuarit nga ana e
autorizuesit.
2. Ekzistimi dhe vëllimi i prokurës janë të pavarur nga raporti juridik mbi bazën e së cilës është dhënë
prokura.
3. I autorizuar mund të jetë edhe personi juridik.', '474bcc5c064b6ce8d8516b57c14c384e6a7aa76f237670535c54d7a6fa28083d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":17,"pageEnd":17,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (77, '78', 'Forma e veçantë e prokurës', null, 'Ligji 04/L-077
Neni 78 - Forma e veçantë e prokurës

Forma e parashikuar me ligj për ndonjë kontratë ose për ndonjë punë tjetër juridike vlen edhe për
prokurën që jepet për lidhjen e kësaj kontrate, përkatësisht për ndërmarrjen e kësaj pune juridike.', '6744844aa712a81d1545ab8493c364ce7ff15bb7d583557766b2107b13b00461', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":17,"pageEnd":17,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (78, '79', 'Vëllimi i autorizimit', '1-4', 'Ligji 04/L-077
Neni 79 - Vëllimi i autorizimit

1. Përfaqësuesi mund të ndërmerr vetëm ato punë juridike për ndërmarrjen e të cilave i është dhënë
prokura.
2. Përfaqësuesi, të cilit i është dhënë prokura e përgjithshme mund të ndërmerr vetëm punë juridike që
i takojnë ushtrimit të veprimtarisë së rregullt.
3. Puna që nuk hyn në veprimtari të rregullt mund të ndërmerret nga përfaqësuesi vetëm në qoftë se
është i autorizuar veçanërisht për ndërmarrjen e kësaj pune ose të llojeve të punëve ku bën pjesë e
njëjta.
4. Përfaqësuesi nuk mundet, pa autorizim të veçantë për secilin rast të veçantë, të ndërmerr detyrimin
kambialor, të lidhë kontratë për dorëzaninë, për pajtimin, për gjykatën e zgjedhur ose arbitrazhin, për
tjetërsimin apo ngarkimin e paluajtshmerive, që të përfshihet në një kontest, e as të heqë dorë nga
ndonjë e drejtë pa shpërblim.', 'df710ffb67e379d6405dde5e6ecc1ee72a55c5c890e9d54dfcb2a1aae3c52117', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":17,"pageEnd":18,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (79, '80', 'Revokimi dhe kufizimi i prokurës', '1-3', 'Ligji 04/L-077
Neni 80 - Revokimi dhe kufizimi i prokurës

1. Dhënësi i prokurës mund ta kufizojë ose ta revokojë prokurën, edhe nëse me kontratë ka hequr dorë
nga kjo e drejtë.
2. Revokimi dhe kufizimi i secilës prokurë mund të bëhet me deklaratë pa formë të veçantë.
3. Në qoftë se me revokimin ose me kufizimin e prokurës është cenuar kontrata mbi dekretin ose
kontrata mbi veprën, apo ndonjë kontratë tjetër i autorizuari ka të drejtë të kërkojë shpërblimin e dëmit
të shkaktuar me këtë.', '676e7461ceefade197b8687084da1a7943fb2c8c00e24bbea43ed68bbef5e1ef', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":18,"pageEnd":18,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (80, '81', 'Efekti i shuarjes dhe i kufizimit të prokurës ndaj personave të tretë', '1-3', 'Ligji 04/L-077
Neni 81 - Efekti i shuarjes dhe i kufizimit të prokurës ndaj personave të tretë

1. Revokimi i prokurës dhe kufizimi i saj, nuk ka efekt ndaj personit të tretë që ka lidhur kontratën me të
autorizuarin, apo që ka kryer ndonjë punë tjetër juridike, e nuk ishte në dijeni dhe as që ka qenë i
obliguar të dinte se prokura është revokuar, përkatësisht se është kufizuar.
2. Në këtë rast, dhënësi i prokurës ka të drejtë të kërkojë nga i autorizuari shpërblimin e dëmit që do të
pësonte për këtë arsye, me përjashtim kur i autorizuari nuk ishte në dijeni as që është dashur ta dinte
për revokimin, përkatësisht për kufizimin e prokurës.
3. E njëjta vlen edhe në rastet të tjera të shuarjes së prokurës.', 'e35e6c7086e3730dc08a2c8e38a53d79df24df19423c5c9c00b88a6a22542413', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":18,"pageEnd":18,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (81, '82', 'Raste të tjera të shuarjes të prokurës', '1-3', 'Ligji 04/L-077
Neni 82 - Raste të tjera të shuarjes të prokurës

1. Prokura shuhet me shuarjen e personit juridik si i autorizuar, në qoftë se me ligj nuk është caktuar
ndryshe.
2. Prokura shuhet me vdekjen e autorizuesit.
3. Prokura shuhet me shuarjen e personit juridik, përkatësisht me vdekjen e personit që e ka dhënë atë,
përveç nëse puna e filluar nuk mund të ndërpritet pa u shkaktuar dëm trashëgimtarëve ligjorë, apo nëse
prokura vlen edhe në rast të vdekjes së dhënësit të prokurës, si me vullnetin e tij, ashtu edhe duke
marrë parasysh karakterin e punës.', 'aec7e0e651b6b2544ed33e010e5a5818ecfd06fee575f561ebb63733f9e15f71', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":18,"pageEnd":18,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (82, '83', 'Autorizimi i punonjësit', null, 'Ligji 04/L-077
Neni 83 - Autorizimi i punonjësit

Personat që në bazë të kontratës me një kompani ose tregtar të pavarur kryejnë punë që kërkon lidhjen
ose përmbushjen e kontratave specifike, si shitës në dyqane, persona që kryejnë punë specifike në
furnizim me ushqim dhe sektorin spitalor, dhe sportelistë në zyra të postës dhe bankave, kanë të
drejtën të lidhin dhe përmbushin këto kontrata.', '1d66d34f927eaf06ee0f75753d11654f4e5ef8348e39c2a65d18edde0c314119', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":18,"pageEnd":18,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (83, '84', 'Të drejtat e përfaqësuesit të shitjeve të udhëtimeve', '1-4', 'Ligji 04/L-077
Neni 84 - Të drejtat e përfaqësuesit të shitjeve të udhëtimeve

1. Përfaqësuesi i shitjeve të udhëtimeve për një kompani ose tregtar të vetëm autorizohet vetëm për
veprimet juridike që lidhen me shitjen e mallrave dhe të përmendura në autorizim.
2. Në rast se nuk është e sigurt, përfaqësuesi i shitjeve të udhëtimeve konsiderohet se nuk ka të drejtë
të lidhë kontratë, por thjesht të marrë urdhra.
3. Përfaqësuesit e shitjeve të udhëtimeve të autorizuar për lidhjen e kontratave për shitjen mallrave nuk
autorizohen për lidhjen e kontratave për kredi ose për pranimin e të ardhurave të shitjeve, përveç nëse
posedojnë një autorizim të veçantë për shitje të kredisë ose për pranimin e të ardhurave të shitjeve.
4. Përfaqësuesit e shitjeve të udhëtimeve kanë të drejtë të pranojnë për autorizuesin deklarata në lidhje
me të metat në mallra dhe deklarata të tjera në lidhje me përmbushjen e kontratës së lidhur me
përfshirjen e tyre, dhe të marrë masat e nevojshme në emër të autorizuesit për të ruajtur të drejtat
kontraktore të autorizuesit.', '071e7debc3da3d4b61a4a8d5ea542bedea7133e61695957c0a9f0b5b5dc75f1e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":18,"pageEnd":19,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (84, '85', 'Aplikimi i dispozitave dhe interpretimi i dispozitave kontestuese', '1-2', 'Ligji 04/L-077
Neni 85 - Aplikimi i dispozitave dhe interpretimi i dispozitave kontestuese

1. Dispozitat e kontratës zbatohen ashtu sikundër e kanë përmbajtjen.
2. Me rastin e interpretimit të dispozitave kontestuese nuk duhet lidhur vetëm për domethënien
tekstuale të shprehjeve të përdorura, por duhet hulumtuar qëllimi i përbashkët i kontraktuesve dhe
dispozita të kuptohet ashtu sikundër u përgjigjet parimeve të së drejtës së detyrimeve të përcaktuara
me këtë ligj.', '51480b6fc7f78adc8c275fbe5996cf8ac3b1ef57eca9b4fdf9dfab7d9372b17b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":19,"pageEnd":19,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (85, '86', 'Dispozitat e paqarta në raste të veçanta', null, 'Ligji 04/L-077
Neni 86 - Dispozitat e paqarta në raste të veçanta

Në rastin kur kontrata është lidhur sipas përmbajtjes së shtypur që më parë, ose kur kontrata ka qenë
në ndonjë mënyrë e përgatitur dhe e propozuar nga njëra palë kontraktuese, dispozitat e paqarta do të
interpretohen në dobi të palës tjetër.', '8e0c7df735d3727f4ed23861b23657bbe645fe14ddfee9ed367acd4f336dccb4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":19,"pageEnd":19,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (86, '87', 'Rregullat plotësuese', null, 'Ligji 04/L-077
Neni 87 - Rregullat plotësuese

Dispozitat e paqarta në kontratën pa shpërblim duhet interpretuar në kuptimin që dispozita e rëndon më
pak debitorin, ndërsa te kontrata me shpërblim në kuptimin me të cilin realizohet një marrëdhënie e
drejtë e prestimeve reciproke.', '6b08e0ac572357f5936b487b31bf51345756e76e265de828597e810edf8ebdec', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":19,"pageEnd":19,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (87, '88', 'Interpretimi jashtëgjyqësor i kontratës', '1-2', 'Ligji 04/L-077
Neni 88 - Interpretimi jashtëgjyqësor i kontratës

1. Palët kontraktuese mund të parashikojnë se, në rastin e mospajtimit lidhur me kuptimin dhe sferën e
dispozitave kontraktuese, një i tretë do ta interpretojë kontratën.
2. Në këtë rast, në qoftë se me kontratë nuk është parashikuar ndryshe, palët nuk mund të fillojnë
kontestin para gjykatës ose para organit tjetër kompetent, derisa mos e marrin më parë interpretimin e
kontratës, përveç nëse personi i tretë refuzon ta japë interpretimin e kontratës.', '9831951ad33f1df45b5f0f51a5a09018d551df78fa2587ae3345d4651185bcbd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":19,"pageEnd":19,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (88, '89', 'Nuliteti', '1-2', 'Ligji 04/L-077
Neni 89 - Nuliteti

1. Kontrata që është në kundërshtim me rendin publik, dispozitat urdhëruese, ose moralin e shoqërisë
është nule, në qoftë se qëllimi i rregullës së cenuar nuk udhëzon në ndonjë sanksion tjetër apo në qoftë
se ligji në rastin e caktuar nuk parashikon diç tjetër.
2. Në qoftë se lidhja e kontratës së caktuar është e ndaluar vetëm për njërën palë, kontrata do të jetë e
vlefshme, në qoftë se në ligj nuk është parashikuar ndryshe për rastin e caktuar, ndërsa pala që e ka
cenuar ndalesën ligjore do të pësojë pasoja përkatëse.', '61de062b064bc1c418b1ab59a409fbbcfb25c133802d387c1f1e4873dbf066ab', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":20,"pageEnd":20,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (89, '90', 'Pasojat e nulitetit', '1-2', 'Ligji 04/L-077
Neni 90 - Pasojat e nulitetit

1. Në rastin e nulitetit të kontratës secila palë kontraktuese ka për detyrë t’ia kthej palës atë që ka
marrë në bazë të kontratës së tillë, e në rast se kjo është e pamundshme apo nëse kthimi parandalohet
nga natyra e asaj që është plotësuar, duhet të bëhet kompensimi përkatës në të holla sipas çmimeve
në kohën e nxjerrjes së vendimit gjyqësor, përveç nëse përcaktohet ndryshe me ligj.
2. Në rast se kontrata është nul për shkak se sipas përmbajtjes ose qëllimit të vet është në kundërshtim
me parimet themelore morale, gjykata mund të refuzojë tërësisht ose pjesërisht kërkesën e palës së
pandërgjegjshme për kthimin e asaj që i ka dhënë palës tjetër; në marrjen e vendimit, gjykata do të ketë
parasysh shkallën e veprimit në mirëbesim të njërës ose të të dy palëve dhe rëndësinë e interesave që
cenohen.', '7b36a86d8dfa949542ea258bc429f90a6f54f9326c2e1df6696420da96d5a260', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":20,"pageEnd":20,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (90, '91', 'Nuliteti i pjesshëm', '1-2', 'Ligji 04/L-077
Neni 91 - Nuliteti i pjesshëm

1. Nuliteti i ndonjë dispozite të kontratës nuk mund të ketë si pasojë nulitetin edhe të vetë kontratës, në
qoftë se ajo mund të qëndrojë pa dispozitën nule, dhe në qoftë se ajo nuk ka qenë kusht apo motiv
vendimtar për lidhjen e saj.
2. Megjithatë, kontrata do të jetë e vlefshme edhe atëherë kur dispozita nule ka qenë kusht ose motiv
vendimtar i kontratës në rastin kur nuliteti është konstatuar pikërisht që kontrata të lirohej prej kësaj
dispozite dhe të vlejë pa te.', '81946b14feaa3921d63e034aa29aefc0f299d70b87ef1b07b74730510b0963e3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":20,"pageEnd":20,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (91, '92', 'Konversioni i kontratës së pavlefshme', null, 'Ligji 04/L-077
Neni 92 - Konversioni i kontratës së pavlefshme

Kur kontrata nule i plotëson kushtet për vlefshmërinë e ndonjë kontrate tjetër, atëherë midis
kontraktuesve do të vlejë kjo e dyta, në qoftë se kjo do të ishte në përputhje me qëllimin të cilin
kontraktuesit e kanë pasur parasysh kur e kanë lidhur kontratën dhe në qoftë se mund të merret se
këta do ta lidhin këtë kontratë po të ishin në dijeni për nulitetin e kontratës së tyre.', 'ba4517c1d10256ce619fcfb9942d7029f290174ffb426e629dfb607995dfd4c0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":20,"pageEnd":20,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (92, '93', 'Shuarja e mëvonshme e shkaqeve të nulitetit', '1-2', 'Ligji 04/L-077
Neni 93 - Shuarja e mëvonshme e shkaqeve të nulitetit

1. Kontrata nule nuk bëhet e vlefshme, nëse ndalesa ose ndonjë shkak tjetër i pavlefshmërisë zhduket
më vonë.
2. Mirëpo, në qoftë se ndalesa ka qenë me rëndësi të vogël, ndërsa kontrata është zbatuar, atëherë
nuk mund të kërkohet nuliteti.', '29444fa0ff31c23a6a29874e117115c4b03fe79a8f04e1e4054b79966e1da04c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":20,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (93, '94', 'Përgjegjësia e personit fajtor për nulitetin e kontratës', null, 'Ligji 04/L-077
Neni 94 - Përgjegjësia e personit fajtor për nulitetin e kontratës

Kontraktuesi që është fajtor për lidhjen e kontratës nule i përgjigjet bashkë kontraktuesit të tij për dëmin
që pëson për shkak të nulitetit të kontratës, në qoftë se ky nuk ishte në dijeni apo sipas rrethanave nuk
do të duhej te ishte ne dijeni për ekzistimin e shkakut të nulitetit.', '2f48fcdefd696ea327f14c6ba6e92a4de7e27d96a465cb766ada7f5fb6dee01e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":21,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (94, '95', 'Kërkimi i nulitetit', null, 'Ligji 04/L-077
Neni 95 - Kërkimi i nulitetit

Për nulitetin gjykata kujdeset sipas detyrës zyrtare dhe në atë mund të thirret çdo person i interesuar.', 'b021581d2cd4291143de6a9b4c93a9475f30aeafedee7109bc7fe2bc9af6c1ec', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":21,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (95, '96', 'Kërkimi i pakufizuar i nulitetit', null, 'Ligji 04/L-077
Neni 96 - Kërkimi i pakufizuar i nulitetit

E drejta e paraqitjes së kërkesës të nulitetit nuk shuhet.', 'c641f4dee0f972284c429acb975e88e5b9454433c63dfbcecca3844299b2a808', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":21,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (96, '97', 'Kontrata e rrëzueshme', null, 'Ligji 04/L-077
Neni 97 - Kontrata e rrëzueshme

Kontrata është e rrëzueshme kur e ka lidhur pala me aftësi të kufizuar për të vepruar, kur gjatë lidhjes
së saj ka pasur të meta në pikëpamje të vullnetit të palëve, si dhe kur kjo gjë është caktuar me këtë ligj
ose me dispozitë të veçantë.', '86bbd9fb0043932d9e20caf435b4ee7158c5dc57f75cc0620bb3787945c3691e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":21,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (97, '98', 'Anulimi i kontratës', '1-3', 'Ligji 04/L-077
Neni 98 - Anulimi i kontratës

1. Pala kontraktuese, në interesin e së cilës është vërtetuar rrëzueshmëria, mund të kërkojë që kontrata
të shpallet e pavlefshme.
2. Mirëpo, bashkëkontraktuesi i kësaj pale mund të kërkojë prej saj që, brenda afatit të caktuar, por jo
më të shkurtër se tridhjetë (30) ditë, të deklarohet se a mbetet pranë kontratës apo jo, sepse në të
kundërtën do të konsiderojë se kontrata është shpallur e pavlefshme.
3. Në qoftë se pala e thirrur kontraktuese brenda afatit të lënë nuk deklarohet apo nëse deklaron se nuk
mbetet pranë kontratës, konsiderohet se kontrata është shpallur e pavlefshme.', '5cb4e7cb905f0d0dbee4d905d17aee7763d1d992dd155c905508906e4f64e2d7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":21,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (98, '99', 'Pasojat e anulimit', '1-2', 'Ligji 04/L-077
Neni 99 - Pasojat e anulimit

1. Në rast se në bazë të kontratës se rrëzueshme që është anuluar është përmbushur diçka, duhet të
bëhet kthimi; në rast se kjo është e pamundshme apo në rast se kthimi ndalohet nga natyra e asaj që
është përmbushur, duhet të bëhet kompensimi përkatës në të holla.
2. Kompensimi në të holla jepet sipas çmimeve në kohën e kthimit ose në kohën e nxjerrjes së vendimit
gjyqësor.', 'a8d2b1083bdb1fdfb0a7a2a6b4f94240f322eaafb5b4b2908767934867748155', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":21,"pageEnd":21,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (99, '100', 'Përgjegjësia për anulimin e kontratës', null, 'Ligji 04/L-077
Neni 100 - Përgjegjësia për anulimin e kontratës

Kontraktuesi, në anën e të cilit është shkaku i rrëzueshmërisë, i përgjigjet bashkë kontraktuesit për
dëmin që pëson për shkak të anulimit të kontratës, nëse ky nuk ishte në dijeni dhe as që duhej të ishte
në dijeni për ekzistimin e shkakut të rrëzueshmërisë së kontratës.', 'a518bd534841a8594a32437abad4b8784cfb7bf7bfd221c637e3e54f0e6ccb1c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":22,"pageEnd":22,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (100, '101', 'Përgjegjësia e personit me aftësi të kufizuar për të vepruar', null, 'Ligji 04/L-077
Neni 101 - Përgjegjësia e personit me aftësi të kufizuar për të vepruar

Personi me aftësi të kufizuar për të vepruar përgjigjet për dëmin e shkaktuar me anulimin e kontratës,
në qoftë se me dinakëri e ka bindur bashkë kontraktuesin e tij se është i aftë për të vepruar.', 'a0a3e74c9233180d142a0c0081eca4dcb436cd00e3cbbb1fe03be9627dfbb7cf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":22,"pageEnd":22,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (101, '102', 'Shuarja e së drejtës së anulimit', '1-2', 'Ligji 04/L-077
Neni 102 - Shuarja e së drejtës së anulimit

1. E drejta për të kërkuar anulimin të një kontrate të rrëzueshme shuhet me skadimin e afatit prej një (1)
viti nga dita kur të jetë ditur shkaku i rrëzueshmërisë, përkatësisht prej pushimit të dhunës.
2. Kjo e drejtë në çdo rast shuhet me skadimin e afatit prej tri (3) vitesh nga dita e lidhjes së kontratës.', 'a69c7c18d73b71892d6837d61fce53fffa197681d73f4e3c35c12789857f2df5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":22,"pageEnd":22,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (102, '103', 'Përgjegjësia për të metat materiale dhe juridike', '1-3', 'Ligji 04/L-077
Neni 103 - Përgjegjësia për të metat materiale dhe juridike

1. Te kontrata me shpërblim secili kontraktues përgjigjet për të metat materiale të mos përmbushjes së
vet.
2. Kontraktuesi përgjigjet edhe për të metat juridike të përmbushjes dhe ka për detyrë të mbrojë palën
tjetër nga të drejtat dhe kërkesat e personave të tretë me të cilat e drejta e saj do të përjashtohej ose
kufizohej.
3. Lidhur me këto detyrime të bartësve përshtatshmërisht zbatohen dispozitat e këtij ligji për
përgjegjësitë e shitësit për të metat materiale dhe juridike, në qoftë se për rastin e caktuar nuk është
parashikuar ndryshe.', 'b772205315bcfe556f3dca84e6e7cfedf6c2b71995b15ab07bb7bf4c3728ea9a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":22,"pageEnd":22,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (103, '104', 'Rregullat e përmbushjes së njëkohshme', '1-2', 'Ligji 04/L-077
Neni 104 - Rregullat e përmbushjes së njëkohshme

1. Në kontratat e dyanshme asnjëra palë nuk e ka për detyrë ta përmbushë detyrimin e vet në qoftë se
pala tjetër nuk e përmbush, ose nuk është e gatshme që njëkohësisht ta përmbushë detyrimin e saj, me
përjashtim kur është kontraktuar diçka tjetër ose është caktuar me ligj apo kur rrjedh diçka tjetër nga
vetë natyra e punës.
2. Mirëpo, në qoftë se në gjykatë njëra nga palët thekson se nuk e ka për detyrë ta përmbushë
detyrimin e vet, gjersa edhe pala tjetër nuk e përmbush të vetin, gjykata do t”i urdhërojë që ta
përmbushë detyrimin e saj kur pala tjetër ta përmbushë të vetin.', '51833348710ee16f9727564b8e039e691a7420b6b46ab4fead0a00a98c8f983c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":22,"pageEnd":23,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (104, '105', 'Kur përmbushja e detyrimit të njërës palë bëhet e pasigurt', '1-3', 'Ligji 04/L-077
Neni 105 - Kur përmbushja e detyrimit të njërës palë bëhet e pasigurt

1. Në qoftë se është kontraktuar që së pari njëra palë ta përmbushë detyrimin e saj, e më vonë, pas
lidhjes së kontratës, rrethanat materiale të palës tjetër keqësohen deri në atë masë saqë është e
pasigurt nëse ajo do të mund ta përmbushë detyrimin e saj, ose nëse kjo pasiguri del nga shkaqet tjera
serioze, atëherë pala që është detyruar ta përmbushë e para detyrimin e saj, mund ta shtyjë
përmbushjen e tij gjersa pala tjetër mos ta përmbushë detyrimin e vet, apo derisa të mos të japë
sigurim të mjaftueshëm se do ta përmbushë atë.
2. Kjo vlen edhe kur rrethanat materiale të palës tjetër kanë qenë në të njëjtën masë të vështira, qysh
para lidhjes së kontratës, në qoftë se bashkë kontraktuesi i saj për këtë nuk ishte në dijeni e as që
duhej të ishte në dijeni.
3. Në raste të tilla, pala që është detyruar që e para ta përmbushë detyrimin e vet mund të kërkojë që t`i
jepet sigurimi brenda një afati të përshtatshëm, e pasi të kalojë ky afat pa rezultat, mund ta zgjidhë
kontratën.', '0e06c833d42387960818cb65f47439d2aa7d1ec9fb17c2e227777355f0f388ab', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":23,"pageEnd":23,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (105, '106', 'Të drejtat e njërës palë kur pala tjetër nuk e përmbushë detyrimin saj', null, 'Ligji 04/L-077
Neni 106 - Të drejtat e njërës palë kur pala tjetër nuk e përmbushë detyrimin saj

Në kontratat e dyanshme, kur njëra palë nuk e përmbushë detyrimin e saj, pala tjetër mundet, në qoftë
se nuk është caktuar diç tjetër, të kërkojë përmbushjen e detyrimit ose, në kushtet të parashikuara në
nenet e mëposhtëm, ta zgjidhë kontratën me deklaratë të thjeshtë, në qoftë se zgjidhja e kontratës nuk
krijohet sipas vetë ligjit. Në çdo rast ka të drejtë në shpërblimin e dëmit.', '1ce68a0f63a62094085e859e6a8f0220ad18016b068cdabe5004eb93f13365e8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":23,"pageEnd":23,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (106, '107', 'Kur përmbushja brenda afatit është element thelbësor i kontratës', '1-4', 'Ligji 04/L-077
Neni 107 - Kur përmbushja brenda afatit është element thelbësor i kontratës

1. Kur përmbushja e detyrimit brenda afatit të caktuar është element thelbësor i kontratës, ndërsa
debitori nuk e përmbush detyrimin brenda këtij afati, kontrata zgjidhet sipas vetë ligjit.
2. Kreditori mund ta mbajë kontratën në fuqi, në qoftë se pas skadimit të afatit, pa shtyrje e njofton
debitorin se kërkon përmbushjen e kontratës.
3. Kur kreditori e ka kërkuar përmbushjen, por kjo nuk është realizuar brenda afatit të arsyeshëm, mund
të deklarojë zgjidhjen e kontratës.
4. Këto rregulla vlejnë si në rastin kur palët kontraktuese kanë parashikuar që kontrata të konsiderohet
e zgjidhur në qoftë se nuk do të përmbushet brenda afatit të caktuar, ashtu edhe kur përmbushja e
kontratës brenda afatit të caktuar është element thelbësor i kontratës sipas vetë natyrës së punës.', '0556d5d08219e9e3ed762a4e39b6cd9849465e243798b915b9aafc709a021b6c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":23,"pageEnd":23,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (107, '108', 'Kur përmbushja e detyrimit brenda afatit nuk është element thelbësor i kontratës', '1-3', 'Ligji 04/L-077
Neni 108 - Kur përmbushja e detyrimit brenda afatit nuk është element thelbësor i kontratës

1. Kur përmbushja e detyrimit brenda afatit të caktuar nuk është element thelbësor i kontratës, debitori
mban të drejtën që edhe pas skadimit të afatit ta përmbushë detyrimin e tij, kurse kreditori të kërkojë
përmbushjen e saj.
2. Në qoftë se kreditori dëshiron ta zgjidhë kontratën duhet detyrimisht t`i lejë debitorit një afat të ri të
përshtatshëm për përmbushjen e detyrimit.
3. Në qoftë se debitori nuk e përmbush detyrimin brenda afatit të ri krijohen të njëjtat pasoja sikurse kur
afati është element thelbësor i kontratës.', '5ca893742c62854852cc758d1ab8cd3bc853ee2fe8769d94158a029d2afcb52f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":23,"pageEnd":24,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (108, '109', 'Zgjidhja e kontratës pa lënien e afatit të ri', null, 'Ligji 04/L-077
Neni 109 - Zgjidhja e kontratës pa lënien e afatit të ri

Kreditori mund ta zgjidhë kontratën pa i lënë debitorit afat të ri për përmbushjen e detyrimit në qoftë se
nga qëndrimi i debitorit del se ai detyrimin e tij nuk do ta përmbushë as në afatin e ri.', 'ec46e9f18803f30d47787603d113cd3051eed752bab0a3839e94b733a94a0dbe', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":24,"pageEnd":24,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (109, '110', 'Zgjidhja e kontratës para skadimit të afatit', null, 'Ligji 04/L-077
Neni 110 - Zgjidhja e kontratës para skadimit të afatit

Kur para skadimit të afatit për përmbushjen e detyrimit del e qartë se njëra palë nuk do ta përmbushë
detyrimin e saj nga kontrata, pala tjetër mund ta zgjidhë kontratën dhe të kërkojë shpërblimin e dëmit.', '872c48406fb1e15e7101f8a9a2caaa631495df13e829b0882e05a8fc33bfeb12', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":24,"pageEnd":24,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (110, '111', 'Zgjidhja e kontratës me detyrime të vazhdueshme', '1-3', 'Ligji 04/L-077
Neni 111 - Zgjidhja e kontratës me detyrime të vazhdueshme

1. Kur në kontratën me detyrime të vazhdueshme njëra palë nuk përmbush një detyrim, pala tjetër
mundet brenda një afati të arsyeshëm, ta zgjidhë kontratën lidhur me të gjitha detyrimet e ardhshme, në
qoftë se nga rrethanat konkrete del e qartë se as ato nuk do të përmbushen.
2. Pala mund ta zgjidhë kontratën jo vetëm sa u përket detyrimeve të ardhshme, por edhe sa u përket
detyrimeve të përmbushura, po qe se përmbushja e tyre pa përmbushjen e atyre që kanë mbetur nuk
ka interes për te.
3. Debitori mund ta mbajë kontratën, në qoftë se jep sigurimin përkatës.', '415e7d2f59d91bfdb8071383e5c1e3b7dabaa0533d66ed3e6912d7c4717ffa35', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":24,"pageEnd":24,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (111, '112', 'Detyrimi i njoftimit', null, 'Ligji 04/L-077
Neni 112 - Detyrimi i njoftimit

Kreditori i cili për shkak të mos përmbushjes së detyrimit të debitorit e zgjidh kontratën, ka për detyrë që
këtë t`ia komunikojë debitorit pa shtyrje.', 'fdeb91943f1797daee327aa43760556e09218733af7e38fb14aa9e3e06916540', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":24,"pageEnd":24,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (112, '113', 'Kontrata që nuk mund të zgjidhet', null, 'Ligji 04/L-077
Neni 113 - Kontrata që nuk mund të zgjidhet

Kontrata nuk mund të zgjidhet për shkak të mos përmbushjes së pjesës me vlerë të vogël të detyrimit.', '0ccc0beac0c2fa4622b5e965e9b3879e1e2c3cadf698d307095e16aed0fc1db9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":24,"pageEnd":24,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (113, '114', 'Pasojat juridike të zgjidhjes', '1-5', 'Ligji 04/L-077
Neni 114 - Pasojat juridike të zgjidhjes

1. Me zgjidhjen e kontratës të dy palët lirohen nga detyrimet e tyre, me përjashtim të detyrimit për
shpërblimin e dëmit eventual.
2. Në qoftë se njëra palë e ka përmbushur kontratën tërësisht ose pjesërisht, ka të drejtë që t`i kthehet
ajo që ka dhënë.
3. Në qoftë se të dy palët kanë të drejtë të kërkojnë kthimin e asaj që kanë dhënë, kthimet reciproke
bëhen sipas rregullave për përmbushjen e kontratave të dyanshme.
4. Secila palë i ka borxh tjetrës shpërblimin për dobitë që ka pasur në ndërkohë prej asaj që e ka për
detyrë ta kthejë ose ta shpërblejë.
5. Pala e cila kthen të hollat ka për detyrë të paguajë kamatëvonesën që nga dita kur e ka marrë
pagesën.', 'b4a691e2ef99a80faaf8603471f2769f0de5162d690a67b44c6060eee83e411a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":24,"pageEnd":25,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (114, '115', 'Deklarimi i zgjidhjes', null, 'Ligji 04/L-077
Neni 115 - Deklarimi i zgjidhjes

Zgjidhja bëhet me deklarimin ndaj palës tjetër.', '9c1aa31205c5bf63e4d28705c0a2f5f8ab4d4b940591990e3d7141943b90c12f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":25,"pageEnd":25,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (115, '116', 'Klauzula Rebus Sic Stantibus', '1-5', 'Ligji 04/L-077
Neni 116 - Klauzula Rebus Sic Stantibus

1. Në qoftë se pas lidhjes së kontratës krijohen rrethanat që e vështirësojnë përmbushjen e detyrimit të
njërës palë, apo në qoftë se për shkak të tyre nuk mund të realizohet qëllimi i kontratës, e si në njërin,
ashtu edhe në rastin tjetër në atë masë sa që del e qartë se kontrata nuk i përgjigjet më asaj që është
pritur nga palët kontraktuese dhe se sipas vlerësimit të përgjithshëm do të ishte e padrejtë të mbahet
në fuqi e tillë siç është, pala të cilës i është vështirësuar përmbushja e detyrimit, përkatësisht pala e cila
për shkak të rrethanave të ndryshuara nuk mund ta realizojë qëllimin e kontratës, mund të kërkojë që
kontrata të zgjidhet apo të ndryshohet.
2. Zgjidhja e kontratës nuk mund të kërkohet në qoftë se pala thirret në rrethana të ndryshuara, ka
pasur për detyrë që në kohën e lidhjes së kontratës të marrë në konsiderim këto rrethana ose ka
mundur që këto t`i evitojë apo t`i përballojë.
3. Pala që kërkon zgjidhjen e kontratës nuk mund të thirret në rrethana të ndryshuara që janë shkaktuar
pas skadimit të afatit të caktuar për përmbushjen e detyrimit të saj.
4. Kontrata nuk do të zgjidhet në qoftë se pala tjetër ofron ose pranon që kushtet përkatëse të kontratës
të ndryshohen në mënyrë të drejtë.
5. Në qoftë se është deklaruar zgjidhja e kontratës, gjykata me kërkesë të palës tjetër, do ta detyrojë
palën që e ka kërkuar zgjidhjen t`ia shpërblejë palës tjetër pjesën e dëmit të caktuar në mënyrë të
drejtë, të cilën e pëson për këtë.', '2836fe23be68356f2a5ed778605313d4d1e4462d77d274c08efce19a94135916', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":25,"pageEnd":25,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (116, '117', 'Detyrimi i njoftimit', null, 'Ligji 04/L-077
Neni 117 - Detyrimi i njoftimit

Pala që është e autorizuar, që për shkak të ndryshimit të rrethanave të kërkojë zgjidhjen ose
ndryshimin e kontratës, ka për detyrë që për qëllimin e saj ta njoftojë palën tjetër, posa të këtë mësuar
se janë shkaktuar rrethanat e tilla. Në qoftë se këtë nuk e bën, përgjigjet për dëmin që ka pësuar pala
tjetër për shkak se kërkesa nuk i është komunikuar me kohë.', '5473e5c5bb1fada2d7aa3a25f53cf33bacfda889c653fb4bab46e48a8fe77d93', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":25,"pageEnd":25,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (117, '118', 'Rrethanat me rëndësi për vendimin e gjykatës', null, 'Ligji 04/L-077
Neni 118 - Rrethanat me rëndësi për vendimin e gjykatës

Kur vendos për zgjidhjen e kontratës, përkatësisht për ndryshimin e saj gjykata udhëhiqet nga parimet
e qarkullimit të ndershëm, duke pasur kujdes sidomos për qëllimin e kontratës, për rrezikun e
zakonshëm te kontratat e llojit përkatës, për interesin e përgjithshëm, si dhe për interesat e të dy
palëve.', 'c8682cf8ec292bb13dd8ff81c370d6e55e1bac36ba30f3b77a01148da67a86a6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":25,"pageEnd":25,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (118, '119', 'Heqja dorë nga e drejta për tu thirrur në rrethana të ndryshuara', null, 'Ligji 04/L-077
Neni 119 - Heqja dorë nga e drejta për tu thirrur në rrethana të ndryshuara

Palët munden me kontratë që më parë të heqin dorë nga e drejta për tu thirrur në rrethanat përkatëse
të ndryshuara, përveç nëse kjo është në kundërshtim me parimin e ndërgjegjshmërisë dhe të
ndershmërisë.', '1277ba3bbb528d1a35bd5f67b0cd8ce9714c3694736b0ec0be3c1bdd174942d2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":26,"pageEnd":26,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (119, '120', 'Pamundësia e përmbushjes për të cilën nuk përgjigjet asnjëra palë', '1-2', 'Ligji 04/L-077
Neni 120 - Pamundësia e përmbushjes për të cilën nuk përgjigjet asnjëra palë

1. Kur përmbushja e detyrimit e njërës palë në kontratën e dyanshme është bërë e pamundur për shkak
të ngjarjes për të cilën nuk është përgjegjëse asnjëra as tjetra palë, shuhet edhe detyrimi i palës tjetër,
e në qoftë se kjo ka përmbushur diç prej detyrimit të saj, mund të kërkojë kthimin sipas rregullave për
kthimin e pasurimit të pabazë.
2. Në rast të pamundësisë së përmbushjes së pjesshme, për shkak të ngjarjes për të cilën nuk është
përgjegjëse as njëra as pala tjetër, pala tjetër mund ta zgjidhë kontratën në qoftë se përmbushja e
pjesshme nuk u përgjigjet nevojave të saj, përndryshe kontrata mbetet në fuqi, ndërsa pala tjetër ka të
drejtë të kërkojë zvogëlimin proporcional të detyrimit të saj.', '150983772613914fcfdae0e331a9f6967f144c2617620bcd15b3c5bb31d5c808', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":26,"pageEnd":26,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (120, '121', 'Pamundësia e përmbushjes për të cilën përgjigjet pala tjetër', '1-3', 'Ligji 04/L-077
Neni 121 - Pamundësia e përmbushjes për të cilën përgjigjet pala tjetër

1. Kur përmbushja e detyrimit të njërës palë në kontratën e dyanshme detyruese është bërë e
pamundur për shkak të ngjarjes për të cilën përgjigjet pala tjetër, detyrimi i saj shuhet, ndërsa ajo
rezervon kërkesat e veta kundrejt palës tjetër; kërkesa do të zvogëlohet për aq sa ka mundur të ketë
dobi nga lirimi i detyrimit të vet.
2. Përveç kësaj, ajo duhet që t’i cedojë palës tjetër të gjitha të drejtat që do të kishte ndaj personave të
tretë lidhur me objektin e detyrimit të vet përmbushja e të cilit është bërë e pamundur.
3. Në rast se përmbushja e detyrimeve bëhet e pamundshme për njërën palë në një kontratë dypalëshe
për shkak të ngjarjes për të cilën kjo palë është përgjegjëse, pala tjetër mund të kërkojë kompensim për
mos përmbushje ose tërheqje nga kontrata dhe të kërkojë shpërblimin e dëmit.', '4380ed766c67b0708d338af6667bf3a388d22a40bb8acad9ff352e5a2a5227b9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":26,"pageEnd":26,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (121, '122', 'Disproporcioni i hapur i dhënieve reciproke', '1-5', 'Ligji 04/L-077
Neni 122 - Disproporcioni i hapur i dhënieve reciproke

1. Në qoftë se midis detyrimeve të palëve kontraktuese në kontratën e dyanshme detyruese ekziston
në kohën e lidhjes së kontratës disproporcion i hapur pala e dëmtuar mund të kërkojë edhe anulimin e
kontratës, në qoftë se për vlerën e saktë atëherë nuk ka ditur dhe as që është dashur të dinte.
2. E drejta për të kërkuar anulimin e kontratës pushon me skadimin e një (1) viti nga lidhja e kontratës.
3. Heqja dorë që me pare nga kjo e drejtë nuk ka efekt juridik.
4. Kontrata do të mbetet në fuqi në qoftë se pala tjetër ofron plotësimin e dhënies deri në vlerën e plotë.
5. Për shkak të këtij disproporcioni nuk mund të kërkohet anulimi i kontratës aleatore të shitjes në
ankandin publik, si dhe atëherë kur për sendin është dhënë çmimi i lartë për shkak të afinitetit të
posaçëm.', '4b1da560583be5dc73deb4350779a5d85cc88440963f5dced4dc40c5f6a0c9a8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":26,"pageEnd":27,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (122, '123', 'Kontratat me fajde', '1-4', 'Ligji 04/L-077
Neni 123 - Kontratat me fajde

1. Kontrata është nule kur dikush, duke shfrytëzuar gjendjen e nevojës ose gjendjen e vështirë
materiale të tjetrit, përvojën e pamjaftueshme të tij mendjelehtësinë apo varësinë e tij, kontrakton për
veten e tij ose për ndonjë të tretë dobinë që është haptazi në shpërpjesëtim me atë që ai i ka dhënë
apo i ka bërë tjetrit, ose është detyruar të japë ose të bëjë.
2. Kuptimi i dispozitave të këtij ligji mbi pasojat e pavlefshmërisë dhe për pavlefshmërinë e pjesshme të
kontratave zbatohen përshtatshmërisht të kontratat me fajde.
3. Në qoftë se i dëmtuari kërkon që detyrimi i tij të zvogëlohet në një shumë të drejtë, gjykata do ta
pranojë këtë kërkesë, po qe se kjo është e mundur dhe, në këtë rast, kontrata, me ndryshimin përkatës,
mbetet në fuqi.
4. I dëmtuari mund të bëjë kërkesë për zvogëlimin e detyrimit në një shumë të drejtë brenda afatit prej
pesë (5) vitesh nga lidhja e kontratës.', 'ab0482a7a9ecd93a322f010a162e542d59495126bc1e92a6d474c522562f7b13', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":27,"pageEnd":27,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (123, '124', 'Detyrimi', '1-4', 'Ligji 04/L-077
Neni 124 - Detyrimi

1. Kushtet e përgjithshme të caktuara nga ana e një palë kontraktuese, qofshin ato të përmbajtura në
kontratën formale apo të referuara nga kontrata, përbëjnë marrëveshje të veçanta ndërmjet palëve
kontraktuese në të njëjtën kontratë dhe si rregull janë njësoj detyruese.
2. Kushtet e përgjithshme të kontratës duhet të shpallen sipas mënyrës së zakonshme.
3. Kushtet e përgjithshme e detyrojnë palën kontraktuese në rast se kanë qenë të njohura për te ose
është dashur t''i njihte në rastin e lidhjes së kontratës.
4. Në rast të mospërputhjes ndërmjet kushteve të përgjithshme dhe marrëveshjeve të veçanta, vlejnë
këto të fundit.', 'ff1cefedade90ef1bfbc80ec1876d852d10546ff4578b19f2b56abdca371fe08', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":27,"pageEnd":27,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (124, '125', 'Nuliteti i disa dispozitave të kushteve të përgjithshme', '1-2', 'Ligji 04/L-077
Neni 125 - Nuliteti i disa dispozitave të kushteve të përgjithshme

1. Janë nul dispozitat e kushteve të përgjithshme që janë në kundërshtim me vetë qëllimin e kontratës
së lidhur ose me praktikën e mirë afariste, qoftë edhe kur kushtet e përgjithshme brenda të cilave bëjnë
pjesë të jenë miratuar nga autoriteti kompetent.
2. Gjykata mund të refuzojë zbatimin e disa dispozitave të kushteve të përgjithshme që e privojnë palën
tjetër nga e drejta për të bërë kundërshtime ose apelim, ose të dispozitave në bazë të të cilave pala
humbë të drejtën nga kontrata ose afatet, ose përndryshe janë të padrejta apo tepër rigoroze ndaj
palës.', '09eb83d05fdbfa17c289b15137c5373187d2c4ee08b3fc09d879552a4b43e22f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":27,"pageEnd":27,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (125, '126', 'Kolizioni në mes të kushteve të përgjithshme', '1-2.2', 'Ligji 04/L-077
Neni 126 - Kolizioni në mes të kushteve të përgjithshme

1. Nëse palët kanë arritur marrëveshje përveç se oferta dhe pranimi i saj i referohen kushteve të
përgjithshme të cilat janë në kolizion në mes tyre, kontrata megjithatë konsiderohet e lidhur. Kushtet e
përgjithshme janë pjesë e kontratës deri në atë masë sa janë të përbashkëta në substancë.
2. Sidoqoftë nuk mund të lidhet kontratë nëse njëra palë:
2.1. paraprakisht ka bërë me dije, në mënyrë shprehimore, dhe jo përmes kushteve të
përgjithshme, qëllimin e saj për të mos qenë pjesë e kontratës në bazë të paragrafit 1. të këtij
neni; ose
2.2. pa vonesë të panevojshme, njofton palën tjetër për qëllimin e tillë.', 'ccec5b9ceb4bc2a4e13dd5f60725e1e45d534bda307e3be55752ac7cb17acecf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2.2","pageStart":28,"pageEnd":28,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (126, '127', 'Kushtet e cedimit', '1-4', 'Ligji 04/L-077
Neni 127 - Kushtet e cedimit

1. Secila palë në kontratën dypalëshe mundet po qe se për këtë jep pëlqimin pala tjetër t’ia cedojë
kontratën personit të tretë i cili me ketë gjë bëhet titullar i të gjitha të drejtave dhe detyrimeve të tij që
dalin nga kjo kontratë.
2. Me cedimin e kontratës, marrëdhënia kontraktuese ndërmjet ceduesit dhe palës tjetër kalon në
pritësin dhe në palën tjetër në momentin kur pala tjetër ka pranuar cedimin; në rast se pëlqimi është
dhënë më parë, cedimi konsiderohet se ka ndodhur kur pala tjetër është njoftuar për cedimin.
3. Pëlqimi për cedimin e kontratës është i vlefshëm vetëm në rast se është dhënë në formën e
parashikuar me ligj për lidhjen e kontratës së ceduar.
4. Kuptimi i dispozitave të të drejtave të palëve në lidhje me kontratën e marrjes përsipër të borxhit vlen
edhe ndaj cedimit të kontratave.', '042b921d8eab3fde8c1ea460328beddbc19c98cbd048f3f6e774f104024e0b8d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":28,"pageEnd":28,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (127, '128', 'Përgjegjësia e cedentit', '1-3', 'Ligji 04/L-077
Neni 128 - Përgjegjësia e cedentit

1. Cedenti i përgjigjet cesionarit për vlefshmërinë e kontratës së ceduar.
2. Ai nuk i garanton se pala tjetër do t`i përmbushë detyrimet e saja nga kontrata e ceduar, përveç nëse
për këtë është detyruar veçanërisht.
3. Ai nuk i garanton po ashtu palës tjetër se cesionari do t`i përmbushë detyrimet nga kontrata, përveç
nëse për këtë është detyruar veçanërisht.', '430a7553f8ac52ceb20f18bde75e95a818b41421469e41b9f442a43edcc8e91d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":28,"pageEnd":28,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (128, '129', 'Kundërshtimet', null, 'Ligji 04/L-077
Neni 129 - Kundërshtimet

Pala tjetër mund t`i paraqes cesionarit të gjitha kundërshtimet nga kontrata e ceduar, si edhe ato që i ka
nga marrëdhëniet tjera me të, por jo edhe kundërshtimet që i ka ndaj cedentit.', '41023134e1c5d79d04d945d364947e2437843680f36d1d57ad6b0e8805364b89', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":28,"pageEnd":28,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (129, '130', 'Efekti i kontratave midis kontraktuesve dhe pasardhësve të tyre', '1-3', 'Ligji 04/L-077
Neni 130 - Efekti i kontratave midis kontraktuesve dhe pasardhësve të tyre

1. Kontrata krijon të drejta dhe detyrime për palët kontraktuese.
2. Kontrata krijon efekte te veta edhe për pasardhësit juridikë universal te palëve kontraktuese, përveç
nëse është kontraktuar diçka tjetër apo nëse diçka tjetër rezulton nga vete natyra e kontratës.
3. Me kontratë mund të krijohet e drejta në dobi të personit të tretë.', '9f49ae6add1cd792e91e4764c1ea5fd41938d4e57415a2e38f3d1a1972063244', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":29,"pageEnd":29,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (130, '131', 'E drejta e drejtpërdrejtë e të tretit', '1-2', 'Ligji 04/L-077
Neni 131 - E drejta e drejtpërdrejtë e të tretit

1. Kur dikush kontrakton në emër të tij ndonjë kërkesë në dobi të personit të tretë, atëherë personi i
tretë fiton të drejtën vetjake dhe të drejtpërdrejtë ndaj debitorit, në qoftë se nuk është kontraktuar diç
tjetër ose nuk del nga rrethanat e punës.
2. Kontraktuesi ka të drejtë të kërkojë që debitori të kryejë ndaj personit të tretë atë që është
kontraktuar në dobi të atij personit të tretë.', 'fc8409f7d6ed7049e013d3f0c58c586140e89dcac17532f2118884ac3fe79fd7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":29,"pageEnd":29,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (131, '132', 'Revokimi i dobive për personin e tretë', '1-2', 'Ligji 04/L-077
Neni 132 - Revokimi i dobive për personin e tretë

1. Kontraktuesi mund t’i revokojë ose ti ndryshojë dobitë për personin e tretë gjithnjë derisa personi i
tretë të mos deklarojë se e pranon atë që është kontraktuar në dobi të tij.
2. Në qoftë se është kontraktuar se debitori do të përmbush atë për të cilën është detyruar në dobi të
personit të tretë vetëm pas vdekjes së kontraktuesit, ky mundet deri atëherë, madje edhe me
testamentin e tij, ta revokojë dobinë e kontraktuar për personin e tretë në qoftë se nga vetë kontrata
ose nga rrethanat nuk del diçka tjetër.', '7f51ead9b19a7a8a1390dbc4756dde83ae82e18255597d1dfb0697336a8f1597', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":29,"pageEnd":29,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (132, '133', 'Prapësimet e debitorit ndaj të tretit', null, 'Ligji 04/L-077
Neni 133 - Prapësimet e debitorit ndaj të tretit

Debitori mund t`i paraqesë personit të tretë të gjitha prapësimet që i ka ndaj kontraktuesit në bazë të
kontratës me të cilën është kontraktuar përfitimi për të tretin.', 'b1daf8cbb5faffbc9c97bfd1e0aa46d1b07445a90e6bb78bf49c7b2a6b21f436', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":29,"pageEnd":29,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (133, '134', 'Refuzimi i të tretit', null, 'Ligji 04/L-077
Neni 134 - Refuzimi i të tretit

Në qoftë se i treti e refuzon dobinë që është kontraktuar për te, apo nëse kontraktuesi e revokon, dobia
i takon kontraktuesit po qe se diçka tjetër nuk është kontraktuar ose nuk del nga vetë natyra e punës.', '210107be0749851cd92fa54562def0c752a20d4361bc9dd474360ff7d3731b97', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":29,"pageEnd":29,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (134, '135', 'Premtimi i veprimit të personit të tretë', '1-2', 'Ligji 04/L-077
Neni 135 - Premtimi i veprimit të personit të tretë

1. Premtimi i bërë tjetrit se i treti do të kryejë ose do të lëshojë që të kryejë diçka, të tretin nuk e
detyron, kurse premtuesi përgjigjet për dëmin që do të pësonte tjetri për shkak se i treti nuk donë të
detyrohet që ta kryejë ose të lëshojë që të mos e kryejë veprimin e caktuar.
2. Premtuesi nuk do të përgjigjet në qoftë se i ka premtuar tjetrit se vetëm do të angazhohet tek personi
i tretë që ky do të detyrohet që diçka të kryejë ose të lëshojë që të kryejë, kurse në këtë nuk ka pasur
sukses përkundër gjithë angazhimit të nevojshëm.', 'd1c2d6f3b23903050278cd1c46fd2e4c9825bc16c8a0fb1ade540a7dc7e1d5ea', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":30,"pageEnd":30,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (135, '136', 'Bazat e përgjegjësisë', '1-3', 'Ligji 04/L-077
Neni 136 - Bazat e përgjegjësisë

1. Kush i shkakton tjetrit dëm ka për detyrë ta kompensojë, përveç nëse vërtetohet se dëmi është
shkaktuar pa fajin e tij.
2. Për dëmin nga sendet ose nga veprimtaritë, nga të cilat rrjedhë rreziku i shtuar i dëmit për rrethin
përgjigjet pavarësisht nga faji.
3. Për dëmin, pavarësisht nga faji mbahet përgjegjësia edhe në rastet tjera të parashikuara me ligj.', '7738c8ade241db56a4f4547fc726aff15a61fcdb43edca6191210a11044d199c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":30,"pageEnd":30,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (136, '137', 'Dëmi', null, 'Ligji 04/L-077
Neni 137 - Dëmi

Dëmi është zvogëlimi i pasurisë së dikujt (dëm i zakonshëm) dhe pengimi i rritjes së saj (fitimi i
humbur), si dhe shkaktimi tjetrit i dhembjes fizike, vuajtjes psikike ose frikës (dëmi jo material).', '99192f2ac820b020aeccbcedb448f12458e8300fba28b08614322e4af27198b7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":30,"pageEnd":30,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (137, '138', 'Kërkesa për mënjanimin e rrezikut të dëmit', '1-4', 'Ligji 04/L-077
Neni 138 - Kërkesa për mënjanimin e rrezikut të dëmit

1. Kushdo mund të kërkojë prej tjetrit që të mënjanojë burimin e rrezikut të dëmit të rëndësishëm që i
kanoset atij ose numrit të pacaktuar njerëzish si dhe të përmbahet nga veprimtaritë nga të cilat rezulton
trazimi ose rreziku i dëmit në qoftë se lindja e trazimit ose e dëmit nuk mund të parandalohet me masa
përkatëse.
2. Gjykata do të urdhërojë sipas kërkesës së personit të interesuar që të ndërmerren masat përkatëse
për parandalimin e shkaktimit të dëmit ose të shqetësimit, ose të evitohet burimi i rrezikut, me
shpenzime të mbajtësit të burimit të rrezikut, në qoftë se ky vetë nuk e bën këtë.
3. Në qoftë se dëmi shkaktohet në ushtrimin e veprimtarisë me interes të përgjithshëm, për të cilën
është marrë leja e organit kompetent, mund të kërkohet vetëm shpërblimi i dëmit që i tejkalon kufijtë e
rëndomtë.
4. Mirëpo edhe në këtë rast mund të kërkohet ndërmarrja e masave shoqërisht të arsyeshme për
parandalimin e shkaktimit të dëmit apo për zvogëlimin e tij.', '17722c39bfdae4102f845940eef8c68b65420d64ac4b3fcabe4ef21c73ede1e3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":30,"pageEnd":30,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (138, '139', 'Kërkesa që të pushohet me shkeljen e të drejtave të personalitetit', '1-2', 'Ligji 04/L-077
Neni 139 - Kërkesa që të pushohet me shkeljen e të drejtave të personalitetit

1. Secili ka të drejtë të kërkojë nga gjykata ose nga organi tjetër kompetent të urdhërojë pushimin e
veprimit që e shkel integritetin e personalitetit të njeriut të jetës personale e familjare e të drejtave të
tjera të personalitetit të tij.
2. Gjykata, përkatësisht organi tjetër kompetent mund të urdhërojë që të pushojë veprimi nën
kërcënimin e pagimit të një shume të caktuar të hollash, të caktuara gjithsejtë ose në periudha të kohës
në dobi të të dëmtuarit.', 'e3906e59f9c68f81fab7278e1cb712403353aa305e39bbe6bbea6c3ff5491586', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":31,"pageEnd":31,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (139, '140', 'Ekzistimi i fajësisë', null, 'Ligji 04/L-077
Neni 140 - Ekzistimi i fajësisë

Fajësia ekziston kur dëmtuesi e ka shkaktuar dëmin me dashje ose nga pakujdesia.', 'fac0b97a39e8a3e945fdf724af10740cecdf7c85083ba5d88582f48d8c0558ac', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":31,"pageEnd":31,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (140, '141', 'Personat të cilët nuk janë përgjegjës', '1-3', 'Ligji 04/L-077
Neni 141 - Personat të cilët nuk janë përgjegjës

1. Personi i cili për shkak të sëmundjes psikike, të zhvillimit të metë mendor apo të shkaqeve të tjera
nuk është i aftë të gjykojë, nuk përgjigjet për dëmin e shkaktuar, përveç nëse provohet që dëmin e ka
shkaktuar në kohën kur ka qenë i aftë për të gjykuar.
2. Kush i shkakton dëm tjetrit në gjendje të paaftësisë së përkohshme për gjykim, është përgjegjës për
atë, përveç nëse provon se pa fajin e tij është sjellë në një gjendje të tillë.
3. Në qoftë se në këtë gjendje është sjellë me faj të dikujt, për dëmin do të përgjigjet ai që e ka sjellë në
gjendje të tillë.', 'fd6ef70ab1e4cc31b3ec6a62863b1d2695b2c7a5fbe2cf8c237842b681b518c9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":31,"pageEnd":31,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (141, '142', 'Përgjegjësia e të miturit', '1-3', 'Ligji 04/L-077
Neni 142 - Përgjegjësia e të miturit

1. I mituri deri në moshën shtatë vjeç nuk përgjigjet për dëmin të cilin e shkakton.
2. I mituri prej moshës shtatë (7) vjeçare, deri në moshën katërmbëdhjetë (14) vjeçare, nuk përgjigjet
për dëmin e shkaktuar, përveç në qoftë se provohet se gjatë shkaktimit të dëmit ka qenë i aftë për të
gjykuar.
3. I mituri mbasi t`i ketë mbushur katërmbëdhjetë (14) vjet përgjigjet sipas rregullave të përgjithshme
për përgjegjësinë për dëmin.', '9a44d754300434ac1ff6bdbc46a365399a9b2cffe465d4a222f016c220b518ae', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":31,"pageEnd":31,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (142, '143', 'Mbrojtja e nevojshme, gjendja e nevojës, mënjanimi i dëmit nga tjetri', '1-3', 'Ligji 04/L-077
Neni 143 - Mbrojtja e nevojshme, gjendja e nevojës, mënjanimi i dëmit nga tjetri

1. Kush në mbrojtje të nevojshme i shkakton dëm sulmuesit nuk e ka për detyrë ta shpërblejë dëmin,
përveç në rastin e tejkalimit të mbrojtjes së nevojshme.
2. Në qoftë se dikush e shkakton dëmin në gjendje të nevojës ekstreme, i dëmtuari mund të kërkojë
shpërblim nga personi që është fajtor për shkaktimin e rrezikut të dëmit ose nga personat nga të cilët
është mënjanuar dëmi, por nga këta të fundit jo më tepër se sa kanë pasur përfitim nga kjo.
3. Kush pëson dëm duke mënjanuar prej tjetrit rrezikun e dëmit ka të drejtë të kërkojë prej tij
shpërblimin e atij dëmi të cilit i është ekspozuar me arsye.', '9010347fdb5a2022d835df03c764c50665205c0d5c7c650c379b6952c1fbb20d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":31,"pageEnd":32,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (143, '144', 'Vetë ndihma e lejuar', '1-2', 'Ligji 04/L-077
Neni 144 - Vetë ndihma e lejuar

1. Kush në rastin e vetë ndihmës së lejuar i shkakton dëm personit i cili e ka shkaktuar nevojën e vetë
ndihmës nuk ka për detyrë ta shpërblejë.
2. Me vetë ndihmë të lejuar nënkuptohet e drejta e çdo personi për të mënjanuar shkeljen e të drejtës
kur kanoset rreziku i drejtpërdrejtë, në qoftë se një mbrojtje e tillë është e domosdoshme dhe nëse
mënyra e mënjanimit të cenimi të së drejtës i përgjigjet rrethanave në të cilat shkaktohet rreziku.', '8c0178dd8c51daac54968fbf2561c1145e2b0ea3712c53d66eb83e85d5466c13', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":32,"pageEnd":32,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (144, '145', 'Pëlqimi i të dëmtuarit', '1-2', 'Ligji 04/L-077
Neni 145 - Pëlqimi i të dëmtuarit

1. Kush në dëm të vet i lejon tjetrit ndërmarrjen e ndonjë veprimi, nuk mund të kërkojë prej tij
shpërblimin e dëmit të shkaktuar nga ky veprim.
2. Është e pavlefshme deklarata e të dëmtuarit me të cilën e ka dhënë pëlqimin që t`i shkaktohet dëmi
me veprimin e ndaluar me ligj.', '6d506892417db2633a55966d8288f725c0604adc0d6daf2a00ab979c41f7bbac', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":32,"pageEnd":32,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (145, '146', 'Personat me sëmundje mendore dhe me të meta në zhvillimin mendor', '1-2', 'Ligji 04/L-077
Neni 146 - Personat me sëmundje mendore dhe me të meta në zhvillimin mendor

1. Për dëmin të cilin e shkakton personi i cili për shkak të sëmundjes mendore ose të zhvillimit mendor
të metë ose të shkaqeve të tjera nuk është i aftë për të gjykuar, përgjigjet ai i cili në bazë të ligjit ose të
vendimit të organit kompetent ose të kontratës ka për detyrë të bëjë mbikëqyrjen e tij.
2. Ai mund të lirohet nga përgjegjësia në qoftë se provon se e ka kryer mbikëqyrjen për të cilën është i
detyruar, apo se dëmi do të shkaktohej edhe me kryerjen e kujdesshme të mbikëqyrjes.', '96b409b461c12aaa49ceac09fa3c40c823ffb2db9a09a6b3fbcd71d0fc389df0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":32,"pageEnd":32,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (146, '147', 'Përgjegjësia e prindërve', '1-4', 'Ligji 04/L-077
Neni 147 - Përgjegjësia e prindërve

1. Prindërit përgjigjen për dëmin që i shkakton tjetrit fëmija i tyre deri në moshën shtatë vjeçare,
pavarësisht nga faji i tij.
2. Ata lirohen nga përgjegjësia nëse ekzistojnë shkaqet për përjashtimin e përgjegjësisë sipas
rregullave për përgjegjësinë pavarësisht nga faji.
3. Ata nuk përgjigjen në qoftë se dëmi është shkaktuar gjersa fëmija i është besuar personit tjetër dhe
në qoftë se ky person është përgjegjës për dëmin.
4. Prindërit përgjigjen për dëmin që i shkakton tjetrit fëmija i mitur i tyre që ka mbushur moshën shtatë
vjeç, përveç nëse provojnë se dëmi është shkaktuar pa fajin e tyre.', '4cc63d9de2acd17fadee78620e32ad95337319dafa4053a07929310c5e7ea800', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":32,"pageEnd":32,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (147, '148', 'Përgjegjësia solidare', null, 'Ligji 04/L-077
Neni 148 - Përgjegjësia solidare

Në qoftë se përveç prindërve përgjigjet për dëmin edhe fëmija, përgjegjësia e tyre është solidare.', '22d145115a78e0c0a70fc2cb806f21104974e34721b89ca437f4d441079a87ba', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":32,"pageEnd":32,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (148, '149', 'Përgjegjësia e personit tjetër për të miturin', '1-2', 'Ligji 04/L-077
Neni 149 - Përgjegjësia e personit tjetër për të miturin

1. Për dëmin të cilin ia shkakton tjetrit i mituri derisa ndodhet nën mbikëqyrjen e kujdestarit, shkollës
ose institucionit tjetër, përgjigjet kujdestari, shkolla, përkatësisht institucioni tjetër, përveç nëse provojnë
se mbikëqyrjen e kanë kryer sipas mënyrës në të cilën kanë qenë të detyruar, apo se dëmi do të
shkaktohej edhe me kryerjen e kujdesshme të mbikëqyrjes.
2. Në qoftë se për dëmin përgjigjet edhe i mituri, përgjegjësia është solidare.', 'f8e4388f2e387c82adcb180fb04697c77d3dfdb7e025273eeabc0503ac87993f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":33,"pageEnd":33,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (149, '150', 'Përgjegjësia e veçantë e prindërve', '1-2', 'Ligji 04/L-077
Neni 150 - Përgjegjësia e veçantë e prindërve

1. Në qoftë se detyra e mbikëqyrjes mbi personin e mitur nuk bie mbi prindërit, por mbi ndonjë person
tjetër, i dëmtuari ka të drejtë të kërkojë shpërblimin nga prindërit kur dëmi është krijuar për shkak të
edukatës së keqe të të miturit, shembujve të këqij ose të shprehive familjare të cilat ia kanë dhënë
prindërit ose kur edhe ashtu dëmi mund t`i dedikohej fajit të prindërve.
2. Personi në të cilin në këtë rast bie përgjegjësi e mbikëqyrjes ka të drejtë të kërkojë nga prindërit që
t`ia shpërblejnë shumën e paguar, në qoftë se ai ia ka paguar shpërblimin dëmtuesit.', 'cc141f06524dc8ed93c511491cd6e47e497e8d910b00fc918cb1e95235bcc5a9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":33,"pageEnd":33,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
