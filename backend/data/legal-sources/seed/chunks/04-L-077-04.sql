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
  (450, '451', 'Objekti i dorëzimit', '1-2', 'Ligji 04/L-077
Neni 451 - Objekti i dorëzimit

1. Në qoftë se nuk është kontraktuar diçka tjetër, apo nuk rrjedh diçka tjetër nga vetë natyra e punës,
shitësi ka për detyrë t’ia dorëzojë sendin blerësit në gjendje të rregullt bashkë me pjesët aksesore të tij.
2. Frutat dhe dobitë e tjera nga sendi i takojnë blerësit prej momentit kur shitësi e ka pasur për detyrë
t’ia dorëzojë.', '72b2590eea7ac47f6708802810a08d676e46debff3d9225cf19bba7c1007ff28', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":97,"pageEnd":97,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (451, '452', 'Kur është kontraktuar dorëzimi brenda një periudhe të caktuar', null, 'Ligji 04/L-077
Neni 452 - Kur është kontraktuar dorëzimi brenda një periudhe të caktuar

Kur është kontraktuar që dorëzimi i sendit të bëhet brenda një periudhe të caktuar, ndërsa nuk është
caktuar se cila palë do të ketë të drejtë ta caktojë datën e dorëzimit brenda asaj periudhe, kjo e drejtë i
takon shitësit, përveç kur nga rrethanat e rastit rrjedh se caktimi i datës së dorëzimit i është lënë
blerësit.', '87e834a20f161365ac7b543861d03be41343be76a7ee4792e182a64d59d0376d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":97,"pageEnd":97,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (452, '453', 'Kur data e dorëzimit nuk është caktuar', null, 'Ligji 04/L-077
Neni 453 - Kur data e dorëzimit nuk është caktuar

Kur data e dorëzimit të sendit te blerësi nuk është caktuar, shitësi ka për detyrë ta bëjë dorëzimin
brenda afatit të arsyeshëm pas lidhjes së kontratës duke marrë parasysh natyrën e sendit dhe rrethanat
e tjera.', 'c1312f31a76261bcc5f4837000a4700eb5a8447113e920b54466bea4aa1deb5c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":97,"pageEnd":97,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (453, '454', 'Kur vendi i dorëzimit nuk është caktuar me kontratë', '1-2', 'Ligji 04/L-077
Neni 454 - Kur vendi i dorëzimit nuk është caktuar me kontratë

1. Kur vendi i dorëzimit nuk është caktuar me kontratë, dorëzimi i sendit bëhet në vendin ku shitësi në
momentin e lidhjes së kontratës e ka pasur vendbanimin e vet apo vendqëndrimin, nëse mungon
vendbanimi, e në qoftë se shitësi e ka lidhur kontratën në kuadër të veprimtarisë së vet ekonomike të
rregullt, atëherë vendi i dorëzimit është selia e tij.
2. Në qoftë se në çastin e lidhjes së kontratës palët kontraktuese e kanë ditur se ku ndodhet sendi,
respektivisht se ku duhet të prodhohet, dorëzimi bëhet në atë vend.', '859c0571500bc2b3bb25996c6732f69f6428e141acf989346414a3f4fe1abe22', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":97,"pageEnd":97,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (454, '455', 'Dorëzimi transportuesit', null, 'Ligji 04/L-077
Neni 455 - Dorëzimi transportuesit

Në rastin kur sipas kontratës nevojitet që të bëhet transportimi i sendeve, ndërsa në kontratë nuk është
caktuar vendi i përmbushjes, dorëzimi quhet i kryer me dorëzimin e sendit transportuesit ose personit i
cili e organizon transportin.', '8a87f6c7d79d86d4cf4ce19f37f421de42d4dd2634fbb420a6fe0b19f81062dd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":98,"pageEnd":98,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (455, '456', 'Organizimi i transportit', null, 'Ligji 04/L-077
Neni 456 - Organizimi i transportit

Në qoftë se shitësi e ka pasur për detyrë t’ia dërgojë sendin blerësit, ai duhet që në mënyrë të
zakonshme dhe në kushte të rëndomta të lidhë kontratën e nevojshme për realizimin e transportit deri
në vendin e caktuar.', '5442b685f75f742954e9a3abbf38b11877556d246fb7894fb6578138bf686f75', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":98,"pageEnd":98,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (456, '457', 'Shpenzimet', null, 'Ligji 04/L-077
Neni 457 - Shpenzimet

Shpenzimet e dorëzimit si dhe ato që i paraprijnë dorëzimit i bartë shitësi, ndërsa shpenzimet e dërgimit
të sendit dhe të gjitha shpenzimet e tjera pas dorëzimit i bartë blerësi, në qoftë se nuk është kontraktuar
ndryshe.', 'ad33c446908b04194c0ba3524313775adbfe3914bf6cd821642d2d3bb53ab054', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":98,"pageEnd":98,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (457, '458', 'Shtyrja e dorëzimit deri sa të paguhet çmimi', null, 'Ligji 04/L-077
Neni 458 - Shtyrja e dorëzimit deri sa të paguhet çmimi

Në qoftë se nuk është kontraktuar diçka tjetër ose diçka tjetër nuk rrjedh nga zakoni, shitësi nuk e ka
për detyrë ta dorëzojë sendin në qoftë se blerësi njëkohësisht nuk e paguan çmimin e tij ose nuk është i
gatshëm ta bëjë këtë njëkohësisht, por as blerësi nuk e ka për detyrë të paguajë çmimin para se të ketë
pasur mundësinë ta kontrollon sendin.', 'd426f20b1230bd7a6c9daebe1771bc5522c6e9f1963ae1c0ee0fb6085d8ef953', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":98,"pageEnd":98,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (458, '459', 'Shtyrja e dorëzimit në rastin e transportit të sendit', '1-3', 'Ligji 04/L-077
Neni 459 - Shtyrja e dorëzimit në rastin e transportit të sendit

1. Kur dorëzimi i sendit realizohet duke ia dorëzuar transportuesit, shitësi mund ta shtyjë dërgimin e
sendit deri sa të paguhet çmimi ose ta dërgojë sendin ashtu që të rezervojë të drejtën e disponimit të tij
gjatë kohës së transportit.
2. Në qoftë se e ka rezervuar të drejtën e disponimit të sendit gjatë kohës së transportit, shitësi mund të
kërkojë që sendi të mos i dorëzohet blerësit në vendin e destinimit deri sa të mos e paguajë çmimin,
ndërsa blerësi nuk e ka për detyrë ta paguajë çmimin para se të ketë pasur mundësinë ta kontrollojë
sendin.
3. Kur kontrata parashikon pagimin kundrejt dorëzimit të dokumentit përkatës, blerësi nuk ka të drejtë të
refuzojë pagimin e çmimit për shkak se nuk ka pasur mundësinë ta shikojë sendin.', '3ea4624dd524e2dfa495db4549a2e323615044e030a45f4aa98e01caaf488636', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":98,"pageEnd":98,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (459, '460', 'Pengimi i dorëzimit të sendit të dërguar', '1-2', 'Ligji 04/L-077
Neni 460 - Pengimi i dorëzimit të sendit të dërguar

1. Në qoftë se pas dërgimit të sendit vërtetohet se gjendja materiale e blerësit është e tillë sa që mund
të dyshohet në mënyrë të bazuar se ai do të mund të paguajë çmimin, shitësi mund ta pengojë
dorëzimin e sendit blerësit edhe atëherë kur blerësi ta ketë në dorë dokumentin që e autorizon të
kërkojë dorëzimin e sendit.
2. Shitësi nuk mund ta pengojë dorëzimin në qoftë se këtë e kërkon ndonjë person i tretë i cili është
posedues i rregullt i dokumentit që e autorizon të kërkojë dorëzimin e sendit, përveç nëse dokumenti
përmban kushte (rezerva) lidhur me efektin e bartjes së tij apo në qoftë se shitësi dëshmon se
poseduesi i dokumentit ka vepruar qëllimisht në dëm të shitësit.', 'a4b6671c9ecf3fd0ef2a02ee7e704fa2c3e0e438fd6684dd2b6cf5c2e710bc74', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":98,"pageEnd":99,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (460, '461', 'Të metat materiale për të cilat shitësi përgjigjet', '1-3', 'Ligji 04/L-077
Neni 461 - Të metat materiale për të cilat shitësi përgjigjet

1. Shitësi përgjigjet për të metat materiale të sendit të cilat sendi i ka pasur në çastin e kalimit të rrezikut
në blerësin, pavarësisht se shitësi ishte në dijeni apo jo për të metat e sendit.
2. Shitësi përgjigjet edhe për ato të meta materiale të cilat shfaqen pas kalimit të rrezikut në blerësin, në
qoftë se janë pasojë e shkakut i cili ka ekzistuar më parë.
3. E meta materiale e parëndësishme nuk merret parasysh.', '4a989d99a48c43b0c5878a0446a75fbcaa5d399af40e8beb27979df483736fed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":99,"pageEnd":99,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (461, '462', 'Kur ekzistojnë të metat materiale', '1-1.4', 'Ligji 04/L-077
Neni 462 - Kur ekzistojnë të metat materiale

1. E meta ekziston:
1.1. në qoftë se sendi nuk ka veçoritë e duhura për përdorimin e tij të rregullt ose për qarkullim;
1.2. në qoftë se sendi nuk ka veçoritë e duhura për përdorim special për të cilën e blen blerësi,
e që e ka pasur të njohur shitësi, ose është dashur ta kishte të njohur;
1.3. në qoftë se sendi nuk ka veçori dhe karakteristika të cilat janë kontraktuar shprehimisht
ose heshtazi, përkatësisht që janë caktuar;
1.4. kur shitësi e ka dorëzuar sendin që nuk i është përshtatur mostrës ose modelit, përveç
nëse mostra ose modeli janë treguar vetëm për qëllime njoftimi.', '33004914703d074bd3507147ebc56d7bf744bdaa3d5dd1bf67f1e72e332889da', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.4","pageStart":99,"pageEnd":99,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (462, '463', 'Të metat, për të cilat shitësi nuk përgjigjet', '1-3', 'Ligji 04/L-077
Neni 463 - Të metat, për të cilat shitësi nuk përgjigjet

1. Shitësi nuk përgjigjet për të metat e specifikuara në paragrafët 1. dhe 3. nga neni paraprak në qoftë
se blerësi në momentin e lidhjes së kontratës ishte në dijeni për këto të meta, ose ato nuk kanë mund
të jenë të panjohura për atë.
2. Konsiderohet se nuk kanë mund të jenë të panjohura për blerësin ato të meta të cilat një person i
kujdesshëm, me dituri dhe përvojë mesatare të personit të mjeshtërisë dhe të profesionit të njëjtë sikur
të blerësit do të mund t’i vërente lehtë gjatë shikimit të rëndomtë të sendit.
3. Megjithatë, shitësi përgjigjet edhe për të metat të cilat blerësi ka mundur t’i vërente lehtë, në qoftë se
shitësi ka deklaruar se sendi nuk ka kurrfarë të metash apo se sendi ka cilësi apo karakteristika të
caktuara.', '0e9c9a7a3d3a5e1808f3cc672ff0b79142e2a9aba6064ab811c0165223a9c414', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":99,"pageEnd":99,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (463, '464', 'Shikimi i sendit dhe të metat e dukshme', '1-3', 'Ligji 04/L-077
Neni 464 - Shikimi i sendit dhe të metat e dukshme

1. Blerësi ka për detyrë që sendin e pranuar ta shikojë ose ta japë në shikim sapo kjo të jetë e mundur
sipas rrjedhës së rregullt të gjërave dhe për të metat e dukshme ta lajmërojë shitësin në afat prej tetë
(8) ditësh, ndërsa te kontratat midis ndërmarrësve pa shtyrje përndryshe e humb të drejtën që i takon
mbi këtë bazë.
2. Kur kontrollimi të jetë bërë në prani të të dy palëve, blerësi është i detyruar që vërejtjet e veta për të
metat e dukshme t’ia komunikojë shitësit menjëherë, përndryshe e humb të drejtën e cila i takon mbi
ketë bazë.
3. Në qoftë se blerësi e ka nisur më tutje sendin pa shkarkim, ndërsa shitësi e ka ditur ose është dashur
ta dijë mundësinë e dërgimit të mëtutjeshëm, shikimi i sendit mund të shtyhet derisa të arrijë në
destinacionin e ri dhe në atë rast blerësi është i detyruar ta lajmërojë shitësin për të metat sapo sipas
rrjedhës së rregullt të gjërave ka mundur të merr vesh për to nga klientët e vet.', 'e456f6985bca5107b7501faae3f03d3cd678bea187aeffad3e47f9538ef801b2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":100,"pageEnd":100,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (464, '465', 'Të metat e fshehta', '1-2', 'Ligji 04/L-077
Neni 465 - Të metat e fshehta

1. Kur pas marrjes së sendit nga blerësi shihet se sendi ka ndonjë të metë e cila nuk ka mundur të
zbulohet me shikim të rëndomtë me rastin e marrjes së sendit (e meta e fshehtë), blerësi është i
detyruar me kërcënim të humbjes së të drejtës, që për atë të metë të lajmërojë shitësin në afat prej tetë
(8) ditësh duke llogaritur prej ditës kur e ka zbuluar të metën, ndërsa te kontrata midis ndërmarrësve
menjëherë.
2. Shitësi nuk përgjigjet për të metat të cilat shfaqen pasi të kalojnë gjashtë (6) muajve nga dorëzimi i
sendit, përveç nëse me kontratë është caktuar ndonjë afat më i gjatë.', '8ed76de94ee3dfdf955f32a7f7bb17c87988c2d38d1be4199ec80505626f88b7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":100,"pageEnd":100,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (465, '466', 'Afatet në rast riparimi, zëvendësimi, etj', null, 'Ligji 04/L-077
Neni 466 - Afatet në rast riparimi, zëvendësimi, etj

Kur për shkak të ndonjë të mete janë bërë riparime të sendit, dërgimi i sendit tjetër, zëvendësimi e të
ngjashme fillojnë afatet e dy neneve paraprake fillojnë të rrjedhin që nga dorëzimi i sendit të riparuar,
dorëzimi i sendit tjetër, zëvendësimi i pjesëve e të ngjashme.', '7e28194e0805653400b4cfdfb087fe7cd2f420837f31f7664665b2ebf632a6dc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":100,"pageEnd":100,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (466, '467', 'Njoftimi për të metën', '1-2', 'Ligji 04/L-077
Neni 467 - Njoftimi për të metën

1. Në njoftimin mbi ekzistimin e të metës së sendit, blerësi ka për detyrë ta përshkruajë të metën
hollësisht dhe ta ftojë shitësin ta kontrollojë sendin.
2. Në qoftë se njoftimi për ekzistimin e të metës, të cilin blerësi ia ka dërguar me kohë shitësit me letër
rekomande, me telegram ose në ndonjë mënyrë tjetër të sigurt vonohet ose nuk arrin fare deri te
shitësi, do të konsiderohet se blerësi e ka kryer detyrimin e vet për ta njoftuar shitësin.', 'c8692dbb219e62cb7605346a885d7596acdbe2d5cb11f534637e50da5509da52', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":100,"pageEnd":100,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (467, '468', 'Rëndësia e faktit se shitësi ka qenë në dijeni për të metën', null, 'Ligji 04/L-077
Neni 468 - Rëndësia e faktit se shitësi ka qenë në dijeni për të metën

Blerësi nuk e humb të drejtën që të thirret në ndonjë të metë edhe kur nuk e kryen detyrimin e vet që
sendin ta shikojë pa shtyrje ose detyrimin që brenda afatit të caktuar ta njoftojë shitësin mbi ekzistimin e
të metës, si dhe kur e meta të jetë shfaqur vetëm pasi të kenë kaluar gjashtë (6) muaj nga dorëzimi i
sendit, po që se për këtë të metë shitësi ka qenë në dijeni apo nuk ka mundur të mos jetë ne dijeni.', '4a29944a9d4e1bae3bd37817d217a8926cbbf1edf3c58c9fccf1cba08e9fad4d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":100,"pageEnd":100,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (468, '469', 'Kufizimi kontraktues ose përjashtimi i përgjegjësisë së shitësit për të metat materiale', '1-3', 'Ligji 04/L-077
Neni 469 - Kufizimi kontraktues ose përjashtimi i përgjegjësisë së shitësit për të metat materiale

1. Kontraktuesit mund ta kufizojnë ose ta përjashtojnë krejtësisht përgjegjësinë e shitësit për të metat
materiale të sendit.
2. Dispozita e kontratës mbi kufizimin ose përjashtimin e përgjegjësisë për të metat e sendit është nule
në qoftë se e meta ka qenë e njohur për shitësin, ndërsa ai për këtë gjë nuk e ka njoftuar blerësin, si
dhe kur shitësi e ka imponuar këtë dispozitë duke e shfrytëzuar pozitën dominuese.
3. Blerësi i cili ka hequr dorë nga e drejta për ta zgjidhur kontratën për shkak të të metave të sendit,
mban të drejtat e tjera nga ato të meta.', 'c7e0fe2af3eb11acc12d9ed92e750e877ad04792f0d275afe4ed7e274f9f9e64', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":101,"pageEnd":101,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (469, '470', 'Përmbarimi i dhunshëm', null, 'Ligji 04/L-077
Neni 470 - Përmbarimi i dhunshëm

Poseduesi, sendi i të cilit shitet në një ankand publik të dhunshëm nuk përgjigjet për të metat e sendit.', '9aea35d5d787df849349df3618acbd62032c36238a5bc14d2104b9f5be2ec935', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":101,"pageEnd":101,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (470, '471', 'Të drejtat e blerësit', '1-3', 'Ligji 04/L-077
Neni 471 - Të drejtat e blerësit

1. Blerësi i cili e ka njoftuar shitësin me kohë dhe në mënyrë të rregullt mbi të metën, mundet:
1.1. të kërkojë nga shitësi që të metën ta mënjanojë, ose t’ia dorëzojë sendin tjetër pa të meta
(përmbushja e kontratës);
1.2. të kërkojë zbritjen e çmimit;
1.3. të deklarojë zgjidhjen e kontratës.
2. Në secilin nga këto raste blerësi ka të drejtë për shpërblimin e demit.
3. Përpos kësaj dhe pavarësisht nga kjo, shitësi i përgjigjet blerësit edhe për dëmin të cilin e ka pësuar
ky për shkak të të metave të sendit në të mirat e tjera të veta, dhe këtë sipas rregullave të përgjithshme
mbi përgjegjësinë për dëmin.', '57d0173b41dd7bcd540cf5902fa11eea235797317c13e7d93f5cd071414a66b6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":101,"pageEnd":101,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (471, '472', 'Mos përmbushja e kontratës brenda afatit të arsyeshëm', null, 'Ligji 04/L-077
Neni 472 - Mos përmbushja e kontratës brenda afatit të arsyeshëm

Në qoftë se blerësi nuk e fiton përmbushjen e kërkuar të kontratës brenda afatit të arsyeshëm, mban të
drejtën e zgjidhjes së kontratës ose të zbritjes së çmimit.', '0c55a251c64e113c4a9a969be87c732e2573c774453119d6da559748ccd4beac', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":101,"pageEnd":101,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (472, '473', 'Kur blerësi mund ta zgjidhë kontratën', '1-2', 'Ligji 04/L-077
Neni 473 - Kur blerësi mund ta zgjidhë kontratën

1. Blerësi mund të zgjidhë kontratën vetëm në qoftë se paraprakisht ia ka lënë shitësit afatin plotësues
të arsyeshëm për përmbushjen e kontratës.
2. Blerësi mund ta zgjidhë kontratën edhe pa e lënë afatin e ri plotësues në qoftë se shitësi, pas
njoftimit mbi të metat, i ka komunikuar se nuk do ta përmbushë kontratën apo në qoftë se nga rrethanat
e rastit konkret rezulton qartas se shitësi nuk do të mund të përmbushte kontratën as në afatin
plotësues.', '603cdac8460cce2be589ce8d4be988ff061d91ef63c4f98fdd085dbdb7791071', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":101,"pageEnd":101,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (473, '474', 'Mos përmbushja e kontratës në afatin plotësues', null, 'Ligji 04/L-077
Neni 474 - Mos përmbushja e kontratës në afatin plotësues

Në qoftë se shitësi në afatin plotësues nuk e përmbush kontratën, ajo zgjidhet sipas ligjit, por blerësi
mund ta mbajë në qoftë se pa vonesë i deklaron shitësit se kontratën e mban në fuqi.', 'baa785657fa2e8a9959a40d15526b3360130aa1c7117ccac7fd92987770f8c43', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":102,"pageEnd":102,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (474, '475', 'Të metat e pjesshme', '1-2', 'Ligji 04/L-077
Neni 475 - Të metat e pjesshme

1. Kur vetëm një pjesë e sendit të dorëzuar ka të meta ose kur është dorëzuar vetëm një pjesë e sendit
ose një sasi më e vogël se sa është kontraktuar, blerësi mund ta zgjidhë kontratën në kuptim të neneve
të mësipërme vetëm në lidhje me pjesën e cila ka të meta ose vetëm në lidhje me pjesët ose sasitë që
mungojnë.
2. Blerësi mund ta zgjidhë kontratën në tërësi vetëm në qoftë se sasia e kontraktuar ose sendi i
dorëzuar përbën një tërësi, apo në qoftë se blerësi ka edhe ashtu interes të arsyeshëm që ta merr
sendin e kontraktuar ose sasinë në tërësi.', '60dcc1aa9179b0c76b20e4bc965d8b97454e6e6083f6f475c625c9c6d2ffd682', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":102,"pageEnd":102,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (475, '476', 'Kur shitësi i ka dhënë blerësit sasi më të madhe', '1-2', 'Ligji 04/L-077
Neni 476 - Kur shitësi i ka dhënë blerësit sasi më të madhe

1. Me kontratën e shitjes midis ndërmarrësve, kur shitësi i sendeve të caktuara sipas llojit ia ka dhënë
blerësit sasinë më të madhe nga sa është kontraktuar, ndërsa blerësi brenda afatit të arsyeshëm nuk
deklaron se e refuzon tepricën, do të konsiderohet se e ka marrë edhe këtë tepricë, kështu që ka për
detyrë ta paguajë me të njëjtin çmim.
2. Në qoftë se blerësi refuzon të merr tepricën, shitësi ka për detyrë t’ia shpërblejë blerësit dëmin e
shkaktuar.', 'de61e7a57174c13b00b1b491bec601c38317cdcda3c2e6a254cb218b3ba51dc0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":102,"pageEnd":102,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (476, '477', 'Caktimi i çmimit për disa sende', '1-2', 'Ligji 04/L-077
Neni 477 - Caktimi i çmimit për disa sende

1. Kur me një kontratë dhe për një çmim janë shitur disa sende ose një grumbull sendesh, ndërsa
vetëm disa prej tyre kanë të meta, blerësi mund ta zgjidhë kontratën vetëm për sa u përket sendeve me
te meta, por jo edhe për të tjerat.
2. Në qoftë se këto përbëjnë një tërësi kështu që ndarja e tyre do të ishte e dëmshme, blerësi mund ta
zgjidhë kontratën në tërësi, apo në qoftë se ai megjithatë deklaron se e zgjidhë kontratën vetëm për sa
u përket sendeve me të meta, shitësi nga ana e tij mund ta zgjidhë kontratën edhe për sa u përket
sendeve të tjera.', '1834c8ad4eec073a6f388a80009c929fda78d5d82e2ba372e960fbfe40735a42', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":102,"pageEnd":102,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (477, '478', 'Humbja e të drejtës për zgjidhjen e kontratës për shkak të të metave', '1-3', 'Ligji 04/L-077
Neni 478 - Humbja e të drejtës për zgjidhjen e kontratës për shkak të të metave

1. Blerësi humb të drejtën e zgjidhjes së kontratës për shkak të të metave të sendeve kur është në
pamundësi ta kthejë sendin ose ta kthejë në gjendjen në të cilën e ka marrë.
2. Megjithatë, blerësi mund ta zgjidhë kontratën për shkak të ndonjë të mete të sendit, në qoftë se sendi
është zhdukur tërësisht ose pjesërisht ose është dëmtuar për shkak të të metave që justifikon zgjidhjen
e kontratës apo për shkak të ndonjë ngjarje e cila nuk rezulton prej tij dhe as prej ndonjë personi për të
cilin përgjigjet ai.
3. E njëjta gjë vlen në qoftë se sendi është zhdukur ose dëmtuar tërësisht ose pjesërisht për shkak të
detyrimit të blerësit që ta kontrollojë sendin, apo në qoftë se blerësi para se të jetë zbuluar e meta e ka
konsumuar ose e ka ndryshuar një pjesë të sendit gjatë përdorimit të tij normal si dhe në qoftë se
dëmtimi ose ndryshimi janë të parëndësishme.', '8c97731b7ffac58adaa4edbc25c73c6a2792c7a60093f78963dface207170ada', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":102,"pageEnd":102,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (478, '479', 'Ruajtja e të drejtave të tjera', null, 'Ligji 04/L-077
Neni 479 - Ruajtja e të drejtave të tjera

Blerësi i cili për shkak të pamundësisë që ta kthejë sendin ose ta kthejë në gjendjen në të cilën e ka
marrë e ka humbur të drejtën e zgjidhjes së kontratës, ka të drejta të tjera që ia jep ligji për shkak të
ekzistimit të ndonjë të mete.', '2e298e963e1f790d75368c73569e023b6d30c1214a351313ca378c9a9bb2fcbc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":103,"pageEnd":103,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (479, '480', 'Efektet e zgjidhjes për shkak të të metave', '1-2', 'Ligji 04/L-077
Neni 480 - Efektet e zgjidhjes për shkak të të metave

1. Zgjidhja e kontratës për shkak të të metave të sendit ka efekte të njëjta sikurse edhe zgjidhja e
kontratave të dyanshme për shkak të mos përmbushjes.
2. Blerësi i debiton shitësit kompensimin për dobinë nga sendi edhe kur është në pamundësi që ta
kthejë krejtësisht ose një pjesë të tij, ndërsa kontrata megjithatë është zgjidhur.', 'c7566aedaa7971d4a72fa221bdba5b4504b9b0e45e7b7b25417ef7411a0f2611', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":103,"pageEnd":103,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (480, '481', 'Zbritja e çmimit', null, 'Ligji 04/L-077
Neni 481 - Zbritja e çmimit

Zbritja e çmimit bëhet sipas raportit midis vlerës së sendit pa të meta dhe vlerës së sendit me të meta
në kohën e lidhjes së kontratës.', 'd1eec3f9c93676619e1512417bdef3571bc5af2a32d39a54eb19b63c27f86c28', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":103,"pageEnd":103,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (481, '482', 'Zbulimi gradual i të metave', null, 'Ligji 04/L-077
Neni 482 - Zbulimi gradual i të metave

Blerësi i cili ka realizuar zbritjen e çmimit për shkak të ekzistimit të ndonjë të mete, mund ta zgjidhë
kontratën ose të kërkojë zbritjen e re të çmimit në qoftë se më vonë zbulohet ndonjë e metë tjetër.', '8c6e7907e32bb0b1ad15de7c77ef465ed63cb73b4f6aabf6e2cfe27631bd30c5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":103,"pageEnd":103,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (482, '483', 'Humbja e të drejtave', '1-2', 'Ligji 04/L-077
Neni 483 - Humbja e të drejtave

1. Të drejtat e blerësit, i cili e ka njoftuar me kohë shitësin mbi ekzistimin e të metave, shuhen pasi të
ketë kaluar një (1) vit duke llogaritur nga dita e dërgimit të njoftimit shitësit, përveç nëse blerësi për
shkak të mashtrimit nga ana e shitësit ka qenë i penguar t’i realizojë ato të drejta.
2. Blerësi i cili e ka njoftuar me kohë shitësin mbi ekzistimin e të metave mund pasi të ketë kaluar ky
afat, në qoftë se ende nuk e ka paguar çmimin të realizojë kërkesën e vet për zbritjen e çmimit ose t’ i
shpërblehet dëmi, si kundërshtim kundër kërkesës së shitësit që t’i paguhet çmimi.', 'd193f94dc0ae20133cc03c0a622eae2d1b941d73f436d422e60cdb49c75700b7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":103,"pageEnd":103,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (483, '484', 'Përgjegjësia e shitësit dhe e prodhuesit', '1-2', 'Ligji 04/L-077
Neni 484 - Përgjegjësia e shitësit dhe e prodhuesit

1. Kur shitësi i ndonjë makine, motori, te ndonjë aparati, ose te sendeve tjera si këto që i përkasin te
ashtuquajtura „malli teknik“, ia ka dorëzuar blerësit fletëgarancionin me të cilën prodhuesi garanton
funksionim të rregullt të sendit gjatë një kohe të caktuar duke llogaritur nga dorëzimi i tij, blerësi mundet
në qoftë se sendi nuk funksionon në rregull, të kërkojë si nga shitësi ashtu edhe nga prodhuesi që
sendi të riparohet në afatin e arsyeshëm ose, nëse nuk e bën këtë, në vend të tij t’ia dorëzojë sendin i
cili funksionon në rregull.
2. Me këto rregulla nuk preket në rregullat mbi përgjegjësinë e shitësit për të metat e sendit.', '5b91f3dd2d2af78c1238dbf6ab3c6ffbf2a9f0c4c56b11293d6be826da0c816a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":103,"pageEnd":103,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (484, '485', 'Kërkesa për riparim ose zëvendësim', '1-2', 'Ligji 04/L-077
Neni 485 - Kërkesa për riparim ose zëvendësim

1. Blerësi mundet për shkak të funksionimit jo në rregull të kërkojë nga shitësi, respektivisht nga
prodhuesi riparimin ose zëvendësimin e sendit gjatë afatit të garancionit, pavarësisht se kur është
shfaqur e meta në funksionimin e sendit.
2. Ai ka të drejtë në shpërblimin e dëmit që ka pësuar për shkak se ka qenë i privuar nga përdorimi i
sendit që nga momenti i kërkesës për riparimin ose zëvendësimin deri në kryerjen e tyre.', '1ac8babb457c06f5c201cb89f4e07acf0b0d45aa85b4f5a624606a2050d071e8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":104,"pageEnd":104,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (485, '486', 'Zgjatja e afatit të garancionit', '1-3', 'Ligji 04/L-077
Neni 486 - Zgjatja e afatit të garancionit

1. Në rast të ndonjë riparimi të vogël, afati i garancionit zgjatet aq sa blerësi ka qenë i privuar nga
përdorimi i sendit.
2. Kur për shkak të funksionimit jo në rregull është bërë zëvendësimi i sendit, ose ndonjë riparim
thelbësor të tij, afati i garancionit fillon të rrjedhë përsëri që nga zëvendësimi respektivisht që nga kthimi
i sendit të riparuar.
3. Në qoftë se është zëvendësuar apo riparuar thelbësisht vetëm ndonjë pjesë e sendit, afati i
garancionit fillon të rrjedhë përsëri vetëm për atë pjesë.', 'fe9dc441749a2a6ef0e8a64e04b21b374ecfc2a480b537e36884593f1ee6bdbb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":104,"pageEnd":104,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (486, '487', 'Zgjidhja e kontratës dhe zbritja e çmimit', null, 'Ligji 04/L-077
Neni 487 - Zgjidhja e kontratës dhe zbritja e çmimit

Në qoftë se shitësi nuk e kryen brenda afatit të arsyeshëm riparimin ose zëvendësimin e sendit, blerësi
mund ta zgjidhë kontratën ose të bëjë zbritjen e çmimit dhe të kërkojë shpërblimin e dëmit.', 'f30cbdb8263e7e5b2371fda01525e021efef66ab1c518136c1a16888fd7587d1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":104,"pageEnd":104,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (487, '488', 'Shpenzimet dhe rreziku', '1-2', 'Ligji 04/L-077
Neni 488 - Shpenzimet dhe rreziku

1. Shitësi respektivisht prodhuesi ka për detyrë që me shpenzime të veta ta transportojë sendin deri në
vendin ku duhet të riparohet ose të zëvendësohet, si dhe sendin e riparuar ose të zëvendësuar t’ia
kthejë blerësit.
2. Gjatë asaj kohe shitësi respektivisht prodhuesi bartë rrezikun për shkatërrimin ose dëmtimin e sendit.', '1a06d772cccf2beb5d46e240c3774c20dd665733594ef8c300147567f0463f18', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":104,"pageEnd":104,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (488, '489', 'Përgjegjësia e kooperuesve', null, 'Ligji 04/L-077
Neni 489 - Përgjegjësia e kooperuesve

Kur në prodhimin e pjesëve të veçanta të sendit ose në zbatimin e veprimeve të veçanta kanë marrë
pjesë disa prodhues të pavarur, përgjegjësia e tyre ndaj prodhuesit final për funksionimin jo të rregullt të
sendit që rezulton prej këtyre pjesëve ose prej këtyre veprimeve shuhet, kur shuhet përgjegjësia e
prodhuesit final ndaj blerësit të sendit.', '2e3dd057cd858914524eee50dcd55139ae15f14b3068c35c693df1880e5f1b02', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":104,"pageEnd":104,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (489, '490', 'Humbja e të drejtave', null, 'Ligji 04/L-077
Neni 490 - Humbja e të drejtave

Të drejtat e blerësit ndaj prodhuesit në bazë të fletëgarancionit shuhen pasi të ketë kaluar një (1) vit,
duke llogaritur nga dita kur ka kërkuar prej tij riparimin ose zëvendësimin e sendit.', '268fad159555c5b42b6037e4692b21616c2689d20eb494510f1de4aab09d499b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":104,"pageEnd":104,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (490, '491', 'Të metat juridike', '1-3', 'Ligji 04/L-077
Neni 491 - Të metat juridike

1. Shitësi përgjigjet në qoftë se në sendin e shitur ekziston ndonjë e drejtë e të tretit e cila e përjashton,
zvogëlon ose kufizon të drejtën e blerësit, e për ekzistimin e saj blerësi nuk është njoftuar, e as që ka
dhënë pëlqimin që ta marrë sendin e ngarkuar me këtë të drejtë.
2. Shitësi i ndonjë të drejte tjetër garanton se ajo ekziston dhe se nuk ka pengesa juridike për realizimin
e saj.
3. Në qoftë se në regjistrat publik është regjistruar ndonjë e drejtë e personave të tretë, e cila në realitet
nuk ekziston, shitësi është i detyruar që me shpenzime te veta të bëjë çregjistrimin e asaj të drejte.', 'bfd1261097f8a65121724e03c5848f5a2d7296aaa4c9597737fe964143248142', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":105,"pageEnd":105,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (491, '492', 'Njoftimi i shitësit', null, 'Ligji 04/L-077
Neni 492 - Njoftimi i shitësit

Në qoftë se konstatohet se personi i tretë paraqet një të drejtë mbi sendin, atëherë blerësi është i
detyruar ta njoftojë shitësin për këtë, përveç nëse shitësi për këtë është në dijeni, dhe të kërkojë prej tij
që brenda afatit të arsyeshëm ta lirojë sendin nga e drejta ose pretendimi i personit të tretë, ose kur
objekt i kontratës janë sendet e caktuara sipas llojit, t’ia dërgojë sendin tjetër pa të metë juridike.', 'cd76846d24196907d12e459b187d5be3fb8a437af0849f149b698620aa583809', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":105,"pageEnd":105,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (492, '493', 'Sanksionet për të metat juridike', '1-4', 'Ligji 04/L-077
Neni 493 - Sanksionet për të metat juridike

1. Në qoftë se shitësi nuk vepron sipas kërkesës së blerësit në rastin kur merret sendin nga blerësi
kontrata zgjidhet sipas ligjit, e në rastin e zvogëlimit ose të kufizimit të së drejtës së blerësit, sipas
dëshirës së vet blerësi mundet ta zgjidhë kontratën ose të kërkojë zbritjen proporcionale të çmimit.
2. Në qoftë se shitësi nuk e përmbush detyrën ndaj blerësit që në afatin e arsyeshëm ta lirojë sendin
nga e drejta ose nga pretendimi i personit të tretë, blerësi mund ta zgjidhë kontratën në qoftë se për atë
shkak qëllimi i saj nuk mund të realizohet.
3. Në çdo rast blerësi ka të drejtë për shpërblimin e dëmit të pësuar.
4. Në qoftë se blerësi në çastin e lidhjes së kontratës ka qenë në dijeni për mundësinë që sendi t’i
merret, ose që e drejta e tij t’i zvogëlohet ose t’i kufizohet, nuk ka të drejtë në shpërblimin e dëmit në
qoftë se ajo mundësi realizohet, por ka të drejtë të kërkojë kthimin, respektivisht zbritjen e çmimit.', '3925501ec9a7c472c9395b420030e246bc6d48df5e3200b07fc46676a0d7407c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":105,"pageEnd":105,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (493, '494', 'Kur blerësi nuk e njofton shitësin', null, 'Ligji 04/L-077
Neni 494 - Kur blerësi nuk e njofton shitësin

Blerësi, i cili duke mos njoftuar shitësin është lëshuar në kontest me personin e tretë dhe e ka humbur
kontestin, megjithatë mund të thirret në përgjegjësinë e shitësit për të metat juridike, përveç nëse
shitësi provon se ka disponuar mjete që të refuzohet kërkesa e personave të tretë.', 'eb08a46de4860b00dbc905f1c8d504daf1ec4eabbf27e3ab7079350be7631f03', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":105,"pageEnd":105,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (494, '495', 'Kur e drejta e personit të tretë është haptazi e bazuar', '1-2', 'Ligji 04/L-077
Neni 495 - Kur e drejta e personit të tretë është haptazi e bazuar

1. Blerësi ka të drejtë të thirret në përgjegjësinë e shitësit për të metat juridike edhe kur pa e njoftuar
shitësin dhe pa kontest ka pranuar të drejtën e të tretit haptazi të bazuar dhe padyshim.
2. Në qoftë se blerësi ia ka paguar të tretit një shumë të hollash për të hequr dorë nga e drejta e vet e
padyshimtë, shitësi mund të lirohet nga përgjegjësia e vet në qoftë se ia shpërblen blerësit shumën e
paguar dhe dëmin e pësuar.', '735391dd284733a541df7398d2767ffc69c411c20dc7e5ebe35bf5c2fd873538', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":105,"pageEnd":106,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (495, '496', 'Kufizimi kontraktues ose përjashtimi i përgjegjësisë së shitësit', '1-2', 'Ligji 04/L-077
Neni 496 - Kufizimi kontraktues ose përjashtimi i përgjegjësisë së shitësit

1. Përgjegjësia e shitësit për të metat juridike mund të kufizohet me kontratë ose të përjashtohet
krejtësisht.
2. Në qoftë se në kohën e lidhjes së kontratës shitësi ka qenë në dijeni ose nuk ka mundur të mos ketë
qenë në dijeni për ndonjë të metë në të drejtën e tij, dispozita e kontratës mbi kufizimin ose mbi
përjashtimin e përgjegjësisë për të metat juridike është nule.', 'aac7110b9c3d68643eb0a4356e3a3d2cce5daf0e5b86f712c8fb95bc073cf08d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":106,"pageEnd":106,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (496, '497', 'Kufizimi i natyrës juridiko-publike', null, 'Ligji 04/L-077
Neni 497 - Kufizimi i natyrës juridiko-publike

Shitësi përgjigjet edhe për kufizime të veçanta të natyrës juridiko-publike të cilat nuk kanë qenë të
njohura për blerësin, në qoftë se ai i ka ditur kufizimet ose ka ditur se ato mund të priten e nuk ia ka
komunikuar blerësit.', '2901fa75915111d7370171a1ec8220228461307703604fcddaddc4e0e8960503', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":106,"pageEnd":106,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (497, '498', 'Humbja e të drejtave', '1-2', 'Ligji 04/L-077
Neni 498 - Humbja e të drejtave

1. E drejta e blerësit në bazë të të metave juridike shuhet me skadimin e një (1) viti nga dita kur ka
mësuar për ekzistimin e të drejtës së personit të tretë.
2. Në qoftë se personi i tretë, para skadimit të këtij afati ka iniciuar procesin, ndërsa blerësi e ka ftuar
shitësin që të ndërhyjë në proces, e drejta e blerësit shuhet vetëm pasi të kenë kaluar gjashtë (6) muaj
pas përfundimit të plotfuqishëm të kontestit.', '7eac949d2664a300cde060713b778347efb29fe352586ed3ac5dfdadc66b5783', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":106,"pageEnd":106,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (498, '499', 'Koha dhe vendi i pagimit', '1-3', 'Ligji 04/L-077
Neni 499 - Koha dhe vendi i pagimit

1. Blerësi ka për detyrë të paguajë çmimin në kohën dhe në vendin e caktuar me kontratë.
2. Në mungesë të dispozitës kontraktuese ose dokeve tjera, pagesa bëhet në momentin dhe në vendin
ku kryhet dorëzimi i sendit.
3. Në qoftë se çmimi nuk duhet të paguhet në momentin e dorëzimit, pagesa bëhet në vendbanimin
respektivisht në selinë e shitësit.', '8481126bb1aad426f7594c5b31579db4d169e7a815bb5929167fe483f551e1da', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":106,"pageEnd":106,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (499, '500', 'Kamata në rast të shitjes me kredi', null, 'Ligji 04/L-077
Neni 500 - Kamata në rast të shitjes me kredi

Në qoftë se sendi i shitur me kredi jep uzurfrukt ose dobi tjera, blerësi debiton kamatë prej momentit kur
i është dorëzuar sendi pavarësisht nëse detyrimi i pagimit të çmimit ka rrjedhur ose jo.', '5a96e4bd8a787ef05571dbf043e21e8236c1367107fda7c52c18405041d1345b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":106,"pageEnd":106,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (500, '501', 'Pagimi i çmimit në rastin e dërgesave të njëpasnjëshme', '1-2', 'Ligji 04/L-077
Neni 501 - Pagimi i çmimit në rastin e dërgesave të njëpasnjëshme

1. Në rastin e dërgesave të njëpasnjëshme, blerësi ka për detyrë të paguajë çmimin për çdo dërgesë
në momentin e marrjes në dorëzim, përveç nëse është kontraktuar diçka tjetër ose rjedh nga rrethanat
e punës.
2. Në qoftë se në kontratën me dërgesat e njëpasnjëshme blerësi ia ka dhënë shitësit paradhënien,
dërgimet e para arkëtohen nga paradhënia, po qe se nuk është kontraktuar diçka tjetër.', '03f182fd42908cb0b9828183c56bae1de475b9e815ad24c297cd9a531f8baa8b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":107,"pageEnd":107,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (501, '502', 'Marrja e sendit', '1-2', 'Ligji 04/L-077
Neni 502 - Marrja e sendit

1. Marrja e sendit konsiston nga ndërmarrja e veprimeve të nevojshme për t’u bërë i mundur dorëzimi
dhe mundësimi i pranimit dhe marrjes së sendit.
2. Në qoftë se blerësi pa ndonjë shkak të arsyeshëm refuzon marrjen e sendit, dorëzimi i të cilit i është
ofruar në mënyrë të kontraktuar ose të zakonshme dhe me kohë, shitësi mundet të deklarojë se e
zgjidhë kontratën, në qoftë se ka shkak të arsyeshme të dyshojë se blerësi nuk do ta paguajë çmimin.', 'e69d466ffce1318271de091b1d17f53584cc6c8d7fcf31ec66b343bc2986b900', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":107,"pageEnd":107,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (502, '503', 'Rastet e detyrimit te ruajtjes', '1-3', 'Ligji 04/L-077
Neni 503 - Rastet e detyrimit te ruajtjes

1. Kur për shkak të vonesës së blerësit rreziku ka kaluar në blerësin para dorëzimit të sendit, shitësi ka
për detyrë ta ruajë sendin me kujdes të ekonomistit të mirë respektivisht të shtëpiakut të mirë dhe për
këtë qëllim të ndërmerr masa të nevojshme.
2. E njëjta gjë vlen edhe për blerësin kur i është dorëzuar sendi, ndërsa ai dëshiron t’ia kthejë shitësit,
qoftë për shkak se e ka zgjidhur kontratën, qoftë se ka kërkuar sendin tjetër në vend të tij.
3. Në njërin dhe rastin tjetër kontraktuesi i cili është i detyruar të ndërmarrë masa për ruajtjen e sendit
ka të drejtë në shpërblimin e shpenzimeve të nevojshme për ruajtjen e sendit.', '2072ab1ad3d1c24a3d7fc59b5b7f1502edbaac76f642358f72d77b2b046efc5c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":107,"pageEnd":107,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (503, '504', 'Kur blerësi nuk dëshiron ta marrë sendin që i është dërguar', null, 'Ligji 04/L-077
Neni 504 - Kur blerësi nuk dëshiron ta marrë sendin që i është dërguar

Blerësi që nuk dëshiron ta pranojë sendin që i është dërguar në vendin e destinimit dhe që i është lënë
atje në diskonim, ka për detyrë ta merr përsipër për llogari të shitësit, në qoftë se ky nuk është i
pranishëm në vendin e destinimit, dhe as që ndodhet atje ndokush i cili kishte për ta marrë përsipër
sendin për te, me kusht që kjo të jetë e mundur pa paguar çmimin dhe pa ndërlikime të mëdha ose
shpenzime të tepruara.', '1844b56138326a36a1abefaea3416e25d9c7266ae579068517870fd597d391b3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":107,"pageEnd":107,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (504, '505', 'E drejta e palës së detyruar për ta ruajtur sendin', null, 'Ligji 04/L-077
Neni 505 - E drejta e palës së detyruar për ta ruajtur sendin

Pala kontraktuese e cila sipas dispozitave paraprake ka për detyrë të marrë masa për ruajtjen e sendit,
mundet nën kushte dhe pasoja të caktuara në dispozitat e këtij ligji për depozitimin në gjykatë dhe
shitjen e sendit që është borxh, ta depozitojë në gjykatë, t’ia dorëzojë për ruajtje ndonjë tjetri ose ta
shesë për llogari të palës tjetër.', '1215fb1750275d38041f283943a223a22583d569f85540926d34cdd043bf4b2c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":108,"pageEnd":108,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (505, '506', 'Rregulla të përgjithshme', null, 'Ligji 04/L-077
Neni 506 - Rregulla të përgjithshme

Kur shitja është zgjidhur për shkak të cenimit të kontratës nga ana e njërës palë kontraktuese, pala
tjetër ka të drejtë në shpërblimin e dëmit të cilin atë e pëson për këtë sipas rregullave të përgjithshme
për shpërblimin e dëmit të shkaktuar nga cenimi i kontratës.', '8369ec76f007f7f5522df7e0551e775e1058c6405b58a68932fc4a183cbddc40', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":108,"pageEnd":108,"structuralContext":{"chapterTitle":"KREU 6"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (506, '507', 'Kur sendi ka çmimin vijues', '1-2', 'Ligji 04/L-077
Neni 507 - Kur sendi ka çmimin vijues

1. Kur shitja është zgjidhur për shkak të shkeljes së kontratës nga ana e njërës palë kontraktuese,
ndërsa sendi e ka çmimin rrjedhës, pala tjetër mund të kërkojë diferencën midis çmimit të caktuar në
kontratë dhe çmimit rrjedhës në ditën e zgjidhjes së kontratës në tregun e vendit ku është kryer puna.
2. Në qoftë se në tregun e vendit ku është kryer puna nuk ka çmim rrjedhës, për llogaritjen e shpërblimit
të dëmit merret në konsiderim çmimi rrjedhës i tregut i cili do të mund ta zëvendësonte në rastin
konkret, të cilit i duhet shtuar diferenca e shpenzimeve të transportit.', '1e98b241f0735b6d689d35e835b24c8e9e905773025624a2cc0e94dbe40024aa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":108,"pageEnd":108,"structuralContext":{"chapterTitle":"KREU 6"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (507, '508', 'Kur shitja ose blerja është bërë për mbulesë', '1-3', 'Ligji 04/L-077
Neni 508 - Kur shitja ose blerja është bërë për mbulesë

1. Kur objekt i shitjes është një sasi sendesh të caktuara sipas llojit dhe kur njëra palë nuk e kryen me
kohë detyrimin e vet, pala tjetër mund të bëjë shitjen respektivisht blerjen për mbulesë dhe të kërkojë
diferencën midis çmimit të caktuar me kontratë dhe çmimit të shitjes apo të blerjes për mbulesë.
2. Shitja dhe blerja për mbulesë duhet të bëhet në afatin e arsyeshëm dhe në mënyrën e arsyeshme.
3. Për qëllimin e shitjes përkatësisht blerjes, kreditori është i detyruar ta njoftojë debitorin.', '2ccd066123ccf1f652b6f2138567aac4f76def60046cc9da253c537444519429', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":108,"pageEnd":108,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (508, '509', 'Shpërblimi i dëmit tjetër', null, 'Ligji 04/L-077
Neni 509 - Shpërblimi i dëmit tjetër

Krahas të drejtës për shpërblimin e dëmit sipas rregullave nga nenet paraprake, pala e cila i mbetet
besnike kontratës ka të drejtë edhe në shpërblimin e dëmit më të madh, në qoftë se e ka pësuar.', '4d2a0d44f91f0f8268ce81ca008a7acde4c6e169bfa08c5d96ca7c5a1c59cc2f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":108,"pageEnd":108,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (509, '510', 'Nocioni', null, 'Ligji 04/L-077
Neni 510 - Nocioni

Me dispozitën kontraktuese mbi të drejtën e parablerjes obligohet blerësi që ta njoftoj shitësin mbi
shitjen e sendit që ka ndërmend t’ia bëjë personit të caktuar, si dhe mbi kushtet e kësaj shitjeje dhe t’ia
ofroj që ky ta blej sendin me të njëjtin çmim.', 'e9b7fdf160ffe31fa89aa85137dd94e5e97d9df4e300dcfb2520cc4b3b64ba6c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":109,"pageEnd":109,"structuralContext":{"chapterTitle":"KREU 7"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (510, '511', 'Afatet për ushtrimin e të drejtës dhe për pagimin e çmimit', '1-3', 'Ligji 04/L-077
Neni 511 - Afatet për ushtrimin e të drejtës dhe për pagimin e çmimit

1. Shitësi ka për detyrë ta njoftojë blerësin në mënyrë të sigurt mbi vendimin e vet për ta shfrytëzuar të
drejtën e parablerjes brenda afatit prej tridhjetë (30) ditësh duke llogaritur që nga dita kur shitësi, e ka
njoftuar mbi këtë shitjen që ka ndërmend ti bëjë personit të tretë.
2. Njëkohësisht me deklaratën se ai e blen sendin shitësi ka për detyrë ta paguajë çmimin e njoftuar
personit të tretë ose ta depozitojë pranë gjykatës.
3. Në rast se në kontratën me të tretin është parashikuar afati për pagimin e çmimit – shitësi mund ta
shfrytëzoj këtë afat vetëm në qoftë se ofron siguri të mjaftueshme.', '3c0d430c0a951d70e6019cf792a937794cbb36bbb3b5a64367ca06286f5bb59e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":109,"pageEnd":109,"structuralContext":{"chapterTitle":"KREU 7"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (511, '512', 'Mundësia e trashëgimit dhe të tjetërsimit', null, 'Ligji 04/L-077
Neni 512 - Mundësia e trashëgimit dhe të tjetërsimit

E drejta e parablerjes së sendeve të luajtshme nuk mund të tjetërsohet dhe as të trashëgohet, në qoftë
se me ligj nuk është caktuar ndryshe.', 'b6a128821170e4c847c4a6f759f0590b436cc699338547e171c7403c066e7c6c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":109,"pageEnd":109,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (512, '513', 'Në rastin e shitjes publike të detyrueshme', '1-2', 'Ligji 04/L-077
Neni 513 - Në rastin e shitjes publike të detyrueshme

1. Gjatë ankandit publik të detyrueshëm përfituesi i të drejtës së parablerjes (blerësi) nuk mund të
përdori të drejtën e vet të parablerjes.
2. Mirëpo, përfituesi i të drejtës së parablerjes (blerësi) e drejta e parablerjes e të cilit është shkruar në
regjistrin zyrtar mund të kërkojë anulimin e shitjes publike,në qoftë se nuk është ftuar posaçërisht.', 'd2b69d661704c725814af2ce2f6f274bffa1fd6fd0c2bd5aee7a01cbc1982dd4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":109,"pageEnd":109,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (513, '514', 'Kohëzgjatja e të drejtës së parablerje', '1-2', 'Ligji 04/L-077
Neni 514 - Kohëzgjatja e të drejtës së parablerje

1. E drejta e parablerjes shuhet në kohën e përcaktuar me kontratë.
2. Nëse koha nuk është përcaktuar me kontratë, e drejta e parablerjes shuhet pesë (5) vite pas lidhjes
së kontratës.', '6cc2bdcd3d10dca9f436b40ce2e39bc17f60a3eb78635fcd41e8589fb1f24004', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":109,"pageEnd":109,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (514, '515', 'Nëse është bërë bartja e pasurisë pa e njoftuar shitësin', '1-3', 'Ligji 04/L-077
Neni 515 - Nëse është bërë bartja e pasurisë pa e njoftuar shitësin

1. Në qoftë se shitësi e ka shitur sendin dhe pronësinë e tij e ka bartur në personin e tretë, duke mos e
njoftuar përfituesin e të drejtës së parablerjes (blerësin), megjithëse i treti e ka ditur ose është dashur ta
dinte se përfituesi i të drejtës së parablerjes ka të drejtën e parablerjes, përfituesi i të drejtës së
parablerjes mundet brenda gjashtë (6) muajsh, nga koha kur është njoftuar për kontratën e shitjes, të
kërkojë që bartja të anulohet dhe sendi t''i cedohet këtij nën të njëjta kushte.
2. Në qoftë se shitësi e ka njoftuar në mënyrë jo të saktë blerësin mbi kushtet e shitjes së bërë personit
të tretë, dhe nëse i treti e ka ditur këtë ose është dashur ta dinte, ky afat prej gjashtë (6) muajsh fillon të
rrjedhë nga dita kur përfituesi i të drejtës së parablerjes ka mësuar për kushtet e vërteta të kontratës
3. E drejta e parablerjes në çdo rast shuhet pasi të kenë kaluar pesë (5) vjet nga bartja e pronësisë në
personin e tretë.', 'c26e205a39a9c91665dfc5b8277753cf9275184a3af321e13703e09d86313c33', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":110,"pageEnd":110,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (515, '516', 'E drejta ligjore e parablerjes', '1-3', 'Ligji 04/L-077
Neni 516 - E drejta ligjore e parablerjes

1. Persona të caktuar mund të kenë të drejtën e parablerjes sipas ligjit.
2. Kohëzgjatja e të drejtës ligjore të parablerjes është e pa kufizuar.
3. Rregullat e shitjes me të drejtën e parablerjes zbatohen përshtatshmërisht edhe tek e drejta ligjore e
parablerjes, përveç nëse në rastet e veçanta parashihet ndryshe.', '202b0a4eac053176f67fa4f42b734cca39a3a146e3af5c2f7fc17a1dacdf844e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":110,"pageEnd":110,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (516, '517', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 517 - Nocioni

1. Kur është kontraktuar që blerësi ta merr sendin me kusht që ta provojë për të vërtetuar nëse i
përgjigjet dëshirës së tij, blerësi ka për detyrë ta njoftojë shitësin brenda afatit të caktuar në kontratë
ose sipas dokeve se a mbetet pranë kontratës, e në qoftë se nuk ka një të tillë, atëherë në afatin e
arsyeshëm të cilin do t’ia caktonte shitësi,përndryshe konsiderohet se ka hequr dorë nga kontrata.
2. Në qoftë se sendi i është dorëzuar blerësit për ta provuar deri në afatin e caktuar ndërsa ky nuk e
kthen deri në skadimin e afatit ose nuk i deklaron shitësit se heq dorë nga kontrata, konsiderohet se ka
mbetur pranë kontratës.', 'd56ad2a977b19ce0c5a330acdd8972162907c798aa820f529a7947fa7b847b58', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":110,"pageEnd":110,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (517, '518', 'Prova objektive', null, 'Ligji 04/L-077
Neni 518 - Prova objektive

Kur prova është kontraktuar për të vërtetuar nëse sendi ka cilësi të caktuar ose nëse është i
përshtatshëm për përdorim të caktuar, mbetja në fuqi e kontratës nuk varet nga vlerësimi i blerësit, por
nga fakti nëse ai ka me të vërtetë këto cilësi përkatësisht nëse është i përshtatshëm për përdorim të
caktuar.', 'ecb0fd73a3685b8299a2e494c8b3713b82b0fc19c0dab35f82ffc3298c4bc782', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":110,"pageEnd":110,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (518, '519', 'Rreziku', null, 'Ligji 04/L-077
Neni 519 - Rreziku

Rrezikun e shkatërrimit ose të dëmtimit të rastësishëm të sendit që i është dorëzuar blerësit për provë e
bartë shitësi derisa blerësi të deklarojë se mbetet pranë kontratës, përkatësisht deri në skadimin e afatit
kur blerësi ka qenë i detyruar t’ia kthejë sendin shitësit.', '5591292f5499f47ba507ec0e2aaffcfbbf105123a7ef9e489870017fb35d8832', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":110,"pageEnd":110,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (519, '520', 'Blerja pas kontrollimit përkatësisht me rezervimin e të provuarit', null, 'Ligji 04/L-077
Neni 520 - Blerja pas kontrollimit përkatësisht me rezervimin e të provuarit

Dispozitat për blerjen me provë zbatohen përshtatshmërisht edhe për blerjen pas kontrollimit dhe ndaj
blerjes me rezervimin e të drejtës së të provuarit.', 'ff9a7a61a2d98650e084e431f0787cf7a965988a4cf8425f2c8da15219c53d18', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":111,"pageEnd":111,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (520, '521', 'Shitja sipas mostrës ose modelit', '1-2', 'Ligji 04/L-077
Neni 521 - Shitja sipas mostrës ose modelit

1. Në rastin e shitjes sipas mostrës ose modelit, te kontratat ndërmjet ndërmarrësve në qoftë se sendi
të cilin shitësi ia ka dorëzuar blerësit nuk është i njëjtë si mostra ose modeli, shitësi përgjigjet sipas
dispozitave për përgjegjësinë e shitësit për të metat materiale të sendit, ndërsa në raste të tjera shitësi
përgjigjet sipas dispozitave për përgjegjësinë për mos përmbushjen e detyrimit.
2. Shitësi nuk përgjigjet për të metat e njëjtësisë në qoftë se mostrën, përkatësisht modelin ia ka
paraqitur blerësit vetëm për qëllim njoftimi dhe caktim të përafërt te karakteristikave të sendit pa
premtim të njëjtësisë.', 'bf375f7bb309f7cb99c35b48e2d24ca38a096bab72f86e23cdde30c84ccce34c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":111,"pageEnd":111,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (521, '522', 'Shitja me specifikim', '1-3', 'Ligji 04/L-077
Neni 522 - Shitja me specifikim

1. Në qoftë se me kontratë është rezervuar e drejta për blerësin që të caktojë më vonë formën, masën
ose ndonjë karakteristikë tjetër të sendit, ndërsa blerësi nuk e kryen këtë specifikim deri në datën e
kontraktuar, ose derisa të kalojë një afat i arsyeshëm, duke llogaritur nga kërkesa e shitësit për ta bërë
këtë, shitësi mund të deklarojë se e zgjidhë kontratën ose të bëjë specifikimin sipas asaj që është në
dijeni për nevojat e blerësit.
2. Në qoftë se vet shitësi kryen specifikimin, ai ka për detyrë ta njoftojë blerësin mbi hollësitë e tij dhe
t’ia caktojë një afat të arsyeshëm që të bëjë një specifikim tjetër.
3. Në qoftë se blerësi nuk e shfrytëzon këtë mundësi, mbetet i detyruar specifikimi të cilin e ka bërë
shitësi.', '2a726a26a35ca46c9ce2a041e351562ea4186988c1d75463aa465c1b319ead26', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":111,"pageEnd":111,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (522, '523', 'Kushtet', '1-3', 'Ligji 04/L-077
Neni 523 - Kushtet

1. Shitësi i një sendi të caktuar të luajtshëm mundet që nëpërmjet një dispozite të veçantë në kontratë
të ruaj të drejtën e pronësinë mbi sendin që i është dhënë blerësit derisa blerësi të paguaj çmimin e
shitjes.
2. Ruajtja e të drejtës së pronësisë ka efekt për kreditorin e blerësit vetëm nëse nënshkrimi mbi
kontratën që përmban dispozitën e ruajtjes së të drejtës së pronësisë është noterizuar para falimentimit
të blerësit apo bashkëngjitjes së pronës së luajtshme.
3. Tek sendet të cilat mbahen regjistra të posaçëm publik, pronësia mund të rezervohet vetëm nëse një
gjë e tillë është përcaktuar me dispozitat mbi organizimin dhe administrimin e regjistrave të tillë.', 'c8189cb07d84b491b96d89f70b1b8ba62f9e18275a0a5f05c27664e654c6e041', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":111,"pageEnd":112,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (523, '524', 'Rreziku', null, 'Ligji 04/L-077
Neni 524 - Rreziku

Rreziku për shkatërrimin apo dëmtimin e rastësishëm të sendit merret përsipër nga ana e blerësit prej
momentit të dorëzimit të sendit.', '700af256988fdac77212f138974479830a28d596e2e88da0e06d86743163a0a8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":112,"pageEnd":112,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (524, '525', 'Përkufizimi', null, 'Ligji 04/L-077
Neni 525 - Përkufizimi

Me anë të kontratës së shitjes me këste, shitësi obligohet tia dorëzojë blerësit një send të posaçëm të
luajtshëm para se çmimi i blerjes të paguhet në tërësi, dhe blerësi obligohet të paguaj me këste në
periudha të caktuara kohore.', 'c76236f6577c061266510b3b7e6f1aa0817328dcce0ad29e3210aa6fd143220b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":112,"pageEnd":112,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (525, '526', 'Forma e kontratës', null, 'Ligji 04/L-077
Neni 526 - Forma e kontratës

Kontrata e shitjes me pagimin e çmimit në këste duhet të përpilohet në formë të shkruar.', 'c2d65decc2a66eb6e05e94ba8c5122ef7df795146fabc7cd30d228ec2775edac', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":112,"pageEnd":112,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (526, '527', 'Pjesët esenciale të kontratës', null, 'Ligji 04/L-077
Neni 527 - Pjesët esenciale të kontratës

Tek shitja me para të gatshme, përveç sendit dhe çmimit të tij, dokumenti i kontratës duhet të
përcaktojnë edhe shumën totale të të gjitha kësteve, duke përfshirë edhe ato të paguara në momentin e
lidhjes së kontratës, shumën e secilës pagesë së veçantë dhe numrin e tyre si dhe afatet kohore për
secilën.', '4dc1da720f11ff69f07c4c0c4a07dfa387fbc22399c54e04b54c1cf20f4c65a8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":112,"pageEnd":112,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (527, '528', 'Zgjidhja e kontratës dhe kërkesa për pagimin e plotë të çmimit', '1-4', 'Ligji 04/L-077
Neni 528 - Zgjidhja e kontratës dhe kërkesa për pagimin e plotë të çmimit

1. Në rast se blerësi vonohet në kryerjen e pagesës së këstit fillestarë, shitësi mund ta zgjidhë
kontratën.
2. Pas pagesës së këstit fillestar, shitësi mund ta zgjidhë kontratën në qoftë se blerësi vonohet me të
paktën dy këste të njëpasnjëshme, që përbëjnë të paktën një të tetën e çmimit.
3. Përjashtimisht, shitësi mund ta zgjidh kontratën kur blerësi vonohet me pagesën e një kësti të vetëm,
në qoftë se për pagesën e çmimit nuk janë parashikuar më tepër se katër këste.
4. Në rastet e parashikuara në paragrafët 2. dhe 3. të këtij neni shitësi mundet që në vend që ta zgjidhë
kontratën, të kërkojë nga blerësi pagimin e krejt shumës së mbetur të çmimit, por në këtë rast ka për
detyrë t''i mundësoj blerësit një afat të ri prej pesëmbëdhjetë (15) ditësh.', '72e33f078e75fc354ca0477fa1f4c5cc3dfad2c3d65ee6d4f4d8ff6cdacffd6e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":112,"pageEnd":112,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (528, '529', 'Pasojat e kontratës së anuluar', '1-2', 'Ligji 04/L-077
Neni 529 - Pasojat e kontratës së anuluar

1. Nëse kontrata anulohet shitësi duhet t’i kthej të gjitha këstet e pranuara së bashku me interesin që
nga dita kur i ka pranuar si dhe t’i kthejë të gjitha shpenzimet e nevojshme që blerësi ka pasur për
sendin.
2. Blerësi duhet t’ia kthej sendin shitësit në gjendjen në të cilën e ka pranuar si dhe të paguaj
kompensimin për përdorimin e bërë të sendit gjerë në momentin e anulimit të kontratës.', '4f2d66f5ea32827f4d343449c7fb9363669f60809117153073202862b68c1116', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":113,"pageEnd":113,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (529, '530', 'Detyrimet e palëve', '1-6', 'Ligji 04/L-077
Neni 530 - Detyrimet e palëve

1. Nëse ekziston marrëveshja që pagesa të bëhet me anë të akreditivit blerësi detyrohet që me
shpenzimet e tij në një afat të përshtatshëm të sigurojë se kësti i parë bankarë hap një akreditiv që
është në përputhje me kontratën e shitjes. Akreditivi duhet të jetë i vlefshëm për një kohë të
mjaftueshme pas përmbushjes së detyrimit të shitësit në mënyrë që shitësi të ketë mundësi ti mbledhë
dhe dorëzojë dokumentet në bankë.
2. Nëse banka nuk e hapë akreditivin në përputhje me paragrafin paraprak ose nuk paguan shumën
kreditore edhe pse shitësi ka paraqitur dokumentet e nevojshme, dispozitat mbi vonesat e debitorit do
të zbatohen përshtatshmërisht në marrëdhënien ndërmjet shitësit dhe blerësit.
3. Shitësi i cili akreditivin e hapur nga banka nuk e përdorë në përputhje me kontratën e shitjes nuk e
humbë të drejtën për të kërkuar çmimin e shitjes, por detyrohet që të kompensojë dëmin e blerësit.
4. Palët mund të përcaktojnë se hapja e akreditivit është kusht për vlefshmërinë e kontratës.
5. Nëse akreditivi është zgjatur me marrëveshjen e të dy palëve, secili prej tyre merr përsipër gjysmën
e shpenzimeve. Nëse zgjatja është bërë për arsyet e njërës palë, shpenzimet i ngarkohen kësaj pale.
6. Dispozitat e këtij neni nuk i zëvendësojnë rregullat e akreditivit si transaksion bankar, as e kundërta.', '101333b4dfd4111a34b8c5031206c5bec553771a809e9d1c5034c9fbfeb105f6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":113,"pageEnd":113,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (530, '531', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 531 - Nocioni

1. Me kontratën e urdhrit për shitje detyrohet urdhër marrësi që sendin e caktuar të luajtshëm, të cilin ia
ka dorëzuar urdhërdhënësi, ta shesë me një çmim të caktuar në afatin e caktuar ose që në atë afat t’ia
kthejë urdhërdhënësit.
2. Urdhri i shitjes nuk mund të revokohet.', '9260e23af852ca16469decfbf9e55b5722d43eb8833edbed827e35e932fbbc34', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":113,"pageEnd":113,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (531, '532', 'Rreziku i shkatërrimit dhe i dëmtimit të sendit', null, 'Ligji 04/L-077
Neni 532 - Rreziku i shkatërrimit dhe i dëmtimit të sendit

Sendi i dorëzuar urdhër marrësit mbetet në pronësinë e urdhërdhënësit dhe ai e bartë rrezikun e
shkatërrimit ose të dëmtimit të tij të rastësishëm, por ai nuk mund ta disponojë deri sa të mos i kthehet.', '3ff4a6c2de10700b228b32e5dddbcda8ef79b3a36f2b9f043de7b3a782f11683', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":113,"pageEnd":113,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (532, '533', 'Kur konsiderohet se urdhër marrësi e ka blerë sendin', '1-2', 'Ligji 04/L-077
Neni 533 - Kur konsiderohet se urdhër marrësi e ka blerë sendin

1. Në qoftë se urdhër marrësi nuk e shet sendin dhe nuk ia dorëzon çmimin e caktuar urdhërdhënësit
deri në afatin e caktuar, e as që e kthen në atë afat, konsiderohet se ai e ka blerë sendin.
2. Mirëpo, kreditorët e tij nuk mund të bëjnë sekuestrimin e sendit derisa ai të mos ia paguajë çmimin
urdhër dhënësit.', '2a82dd8a85a0bbd3cac2f13adc8d9062440f0035672c6945d75f89a82130399e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":114,"pageEnd":114,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (533, '534', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 534 - Nocioni

1. Me kontratën për këmbimin secili kontraktues detyrohet ndaj bashkëkontraktuesit të vet ta dorëzojë
sendin që këmbehet, kështu që ai të fitojë të drejtën e pronësisë.
2. Objekt këmbimi mund të jenë edhe të drejtat e bartshme.', '55cdc151e2b42444ec140cc18b7450a5a6ffd776119a009350d036ac5f99cc40', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":114,"pageEnd":114,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (534, '535', 'Efektet e kontratës për këmbimin', null, 'Ligji 04/L-077
Neni 535 - Efektet e kontratës për këmbimin

Me kontratën për këmbimin krijohen për secilin kontraktues detyrime dhe të drejta të cilat me kontratën
e shitjes krijohen për shitësin.', '13b4a538917c0b76239f51f7981691ae20a4cc7c05825756cba45d604022d7f2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":114,"pageEnd":114,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (535, '536', 'Nocioni', '1-3', 'Ligji 04/L-077
Neni 536 - Nocioni

1. Me kontratën për dhuratën një person (dhuratëdhënësi) merr përsipër që pa shpërblim të bartë të
drejtën e pronësisë apo ndonjë të drejtë tjetër tek dhuratëmarrësi apo në ndonjë mënyrë tjetër të
pasurojë dhuratëmarrësin nga llogaria e dhuratëdhënësit, si dhe dhuratëmarrësi të jep pëlqimin për një
gjë të tillë.
2. Heqja dorë nga një e drejtë konsiderohet si dhuratë, nëse personi i detyruar jep pëlqimin për këtë.
3. Heqja dorë nga një e drejtë në lidhje me të cilën nuk ka ndonjë person të detyruar dhe e cila nuk
është kaluar tek ndonjë person i tretë, nuk konsiderohet dhuratë.', 'ea7bde6b31ab13938dd59160c4447f83fda07e4b736dd6e8c571841c33c0d428', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":114,"pageEnd":114,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (536, '537', 'Shpërblimi', null, 'Ligji 04/L-077
Neni 537 - Shpërblimi

Konsiderohet kontratë e dhuratës shpërblimi ose detyrimi moral i dhuratëdhënësit nëse dhuratëmarrësi
nuk ka pasur të drejtë të kërkoj lëndën e këtij detyrimi me anë të padisë.', '9b189406cd71907dfa7b58293687a9b2b3fc554773c70c3bd7cf4e9f51f1d7ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":114,"pageEnd":114,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (537, '538', 'Dhurata e përzier', null, 'Ligji 04/L-077
Neni 538 - Dhurata e përzier

Nëse me të njëjtën kontratë apo me kontratë tjetër, dhuratëmarrësi detyrohet të pasurojë
dhuratëdhënësin do të konsiderohet si kontratë e dhurimit vetëm në lidhje me vlerën shtesë.', 'ef91d15809767d50c7f673ee5aac1d961115ee6ba9d600cc6c24510167609739', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":115,"pageEnd":115,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (538, '539', 'Përmbushja periodike', null, 'Ligji 04/L-077
Neni 539 - Përmbushja periodike

Nëse detyrimet e dhuratëdhënësit përbëjnë përmbushje të kohëpaskohshme, ky detyrim shuhet me
vdekjen e dhuratëdhënësit.', '96f9ac28edf67d6c58d2b7ecde8731a91a0b689a3117c7c90c0fff45d0a27d6c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":115,"pageEnd":115,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (539, '540', 'Përgjegjësia e dhuratëdhënësit për dëmin', '1-2', 'Ligji 04/L-077
Neni 540 - Përgjegjësia e dhuratëdhënësit për dëmin

1. Secili që me dijeni jep sendin e tjetrit si dhe ia fsheh këtë rrethanë dhuratëmarrësit është përgjegjës
për dëmin.
2. Nëse sendi i dhuruar ka një të metë apo ndonjë veçori të rrezikshme si pasojë e së cilës i është
shkaktuar dëmi dhuratëmarrësit, apo të tretit të dëmtuar, përgjegjës për këtë dëm është dhuratëdhënësi
nëse dhuratëdhënësi ka qenë në dijeni apo është dashur të jetë në dijeni për të metën apo veçorinë e
rrezikshme dhe për këtë nuk e ka lajmëruar dhuratëmarrësin.', '1f87ffba4fde680f5680f156a22922dbb4d1c5b72744259de101cd79572e0758', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":115,"pageEnd":115,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (540, '541', 'Forma', '1-2', 'Ligji 04/L-077
Neni 541 - Forma

1. Nëse dhuratëdhënësi nuk e bartë menjëherë sendin apo të drejtën tek dhuratëmarrësi në mënyrë që
dhuratëmarrësi të disponojë me të pa pengesa, atëherë kontrata e dhuratës duhet të jetë në formë të
shkruar.
2. Nëse kontrata e dhuratës nuk është lidhur në formën e përcaktuar në paragrafin paraprak,
dhuratëmarrësi nuk mund të kërkojë me anë të padisë përmbushjen e saj.', '01e38e75811527875d5d07c009578c8b340ee347add49ca4f471cb9e3fa97acc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":115,"pageEnd":115,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (541, '542', 'Revokimi për shkak të varfërimit', '1-3', 'Ligji 04/L-077
Neni 542 - Revokimi për shkak të varfërimit

1. Dhuratëdhënësi i cili pas realizimit të kontratës së dhuratës, bie në pozitë të tillë ku i rrezikohet
mbijetesa mund ta revokojë kontratën e dhuratës.
2. Revokimi i përcaktuar në paragrafin paraprak nuk është i mundshëm nëse si pasojë e kësaj
dhuratëmarrësi do të jetë në pozitë ku i rrezikohet mbijetesa.
3. Dhuratëmarrësi mund ta mbaj dhuratën nëse dhuratëmarrësi i siguron dhuratëdhënësit mjetet e
jetesës.', 'c9fb9679051c886a21e9a15f357fb676aec11a684bf280432ef2fe226ae24285', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":115,"pageEnd":115,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (542, '543', 'Revokimi për shkak të mosmirënjohjes së thellë', '1-4', 'Ligji 04/L-077
Neni 543 - Revokimi për shkak të mosmirënjohjes së thellë

1. Dhuratëdhënësi po ashtu mund të revokojë kontratën për shkak të mosmirënjohjes së thellë nëse
pas lidhjes së sajë dhuratëmarrësi sillet me dhuratëdhënësin apo me ndonjë person të afërt të tij në atë
mënyrë që sipas parimeve themelore të moralit do të ishte e padrejtë për dhuratëmarrësin të mbante
atë që ka marrë me dhuratë.
2. Dhurata po ashtu mund të revokohet nga trashëgimtari për arsye të mënyrës së sjelljes ndaj
dhuratëdhënësit
3. Revokimi për shkak të mënyrës së sjelljes së dhuratëmarrësit është i mundshëm edhe për shkak të
sjelljes së trashëgimtarit të dhuratëmarrësit.
4. Revokimi nuk është i mundur nëse mosmirënjohja e thellë e dhuratëmarrësit ndaj dhuratëdhënësit
ndërpritet.', 'a47b730b76b4e51017688f7c9fe8a1778c57cfab28a3dd8b39dbf92a70a691dc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":116,"pageEnd":116,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (543, '544', 'Revokimi për shkak të lindjes së pastajshme', null, 'Ligji 04/L-077
Neni 544 - Revokimi për shkak të lindjes së pastajshme

Dhuratëdhënësi i cili bëhet me fëmijë pasi që është lidhur kontrata e dhuratës dhe i cili më parë nuk ka
pasur asnjë fëmijë, mund ta revokojë dhuratën.', 'ef66f357a1509349cf15b2220f85e9b6c7615140f7a36ca889b239c5838449fb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":116,"pageEnd":116,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (544, '545', 'Pasojat e revokimit', '1-2', 'Ligji 04/L-077
Neni 545 - Pasojat e revokimit

1. Me anë të deklaratës së revokimit dhuratëdhënësi duhet të kërkojë kthimin e sendit apo të drejtës
apo të pagesës së vlerës me të cilën dhuratëmarrësi është pasuruar në bazë të veprimit të dhuratës.
2. Nëse dhurata ende nuk është përmbushur, revokimi ka për pasojë ndërprerjen e detyrimit të
dhuratëdhënësit.', '2b09076c14c76cf104faf26caf4a082b0a59d3b5d1d28f0f076bd92f3b954af6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":116,"pageEnd":116,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (545, '546', 'Afatet për revokimin', null, 'Ligji 04/L-077
Neni 546 - Afatet për revokimin

Kontrata e dhuratës mund të revokohet brenda një viti nga dita kur dhuratëdhënësi ka mësuar për
arsyet e revokimit.', '3ded7b78bdcbfe138177f0eae893afccad0a292c42901e7ad209e8265ad9428e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":116,"pageEnd":116,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (546, '547', 'Heqja dorë nga revokimi', null, 'Ligji 04/L-077
Neni 547 - Heqja dorë nga revokimi

Është e pavlefshme heqja dorë nga revokimi.', 'd1eea2f575513bfeed33f6753b35749eb1b2675cb4801a1d94c346dd6f131c0c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":116,"pageEnd":116,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (547, '548', 'Dhurata në rast të vdekjes', null, 'Ligji 04/L-077
Neni 548 - Dhurata në rast të vdekjes

Kontrata e dhuratës e cila është për tu përmbushur pas vdekjes së dhuratëdhënësit është e vlefshme
vetëm nëse është bërë në formë të aktit noterial dhe nëse dokumenti për kontratën e lidhur të dhuratës
është dorëzuar tek dhuratëmarrësi.', 'a745d9b64e4bce1ff2173d7374af11984828e96f97bbc524acd4b1020b385ee8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":116,"pageEnd":116,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (548, '549', 'Përkufizimi', null, 'Ligji 04/L-077
Neni 549 - Përkufizimi

Me kontratë të dorëzimit, dorëzuesi merr përsipër të dorëzojë dhe ndajë pronën tek pasardhësit e tij/saj,
tek fëmijët e adoptuar dhe pasardhësve të fëmijëve të adoptuar.', '656ed565219124ae79710078e8b30f0018902fb0487968103cf754ae1cc67981', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":117,"pageEnd":117,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (549, '550', 'Kushtet për vlefshmërinë', '1-4', 'Ligji 04/L-077
Neni 550 - Kushtet për vlefshmërinë

1. Kontrata është e vlefshme vetëm nëse për të jepet pëlqimi nga pasardhësit, fëmijët e adoptuar dhe
pasardhësve të fëmijëve të adoptuar të cilët sipas ligjit do të thirreshin për të trashëguar mbi bazën e
kontratës (pasardhësit).
2. Kontrata duhet të lidhet në formë të aktit noterial.
3. Secili pasardhës që nuk e jep pëlqimin, mund ta bëjë atë më vonë në të njëjtën formë.
4. Dorëzimi dhe ndarja mbetet e vlefshme edhe nëse një pasardhës i cili nuk ka dhënë pëlqimin vdes
para dorëzimit duke mos lënë ndonjë pasardhës, nëse heq dorë nga trashëgimia, nëse është
përjashtuar nga trashëgimia, apo nëse nuk është i denjë të trashëgojë.', '6bb5722e022e5d45fee26d0ce5532b096b534e1916ab1d627ee7986c5fdd6296', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":117,"pageEnd":117,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (550, '551', 'Subjekti i dorëzimit dhe ndarjes së pasurisë', '1-2', 'Ligji 04/L-077
Neni 551 - Subjekti i dorëzimit dhe ndarjes së pasurisë

1. Vetëm pasuria ekzistuese e dorëzuesit, pjesërisht ose në tërësi, mund të përfshihet në dorëzim dhe
ndarje.
2. Është e pavlefshme dispozita për mënyrën e ndarjes së pasurisë që është pjesë e pronës së
përgjithshme të dorëzuesit.', '502dc31ea630141ed6b11166219de1c06a6bfa70c135eda8a88a0090c53578c0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":117,"pageEnd":117,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (551, '552', 'Pozita e pasurisë së dorëzuar', '1-2', 'Ligji 04/L-077
Neni 552 - Pozita e pasurisë së dorëzuar

1. Nëse vdes paraardhësi i cili ka dorëzuar dhe ndarë pasurinë e tij apo saj gjatë kohës sa ka qenë
gjallë, pasuria e përgjithshme e tij apo saj përbëhet vetëm nga pasuria e cila nuk është përfshirë në
dorëzim dhe ndarje si dhe nga prona e fituar më pas.
2. Pasuria e fituar nga pasardhësit e tij apo saj me anë të dorëzimit dhe ndarjes nuk klasifikohet si
pjesë e pasurisë së përgjithshme të tij apo saj si dhe nuk llogaritet gjatë përcaktimit të vlerës së kësaj
pasurie të përgjithshme.', '070ccec02f5b6191ba54dab1dfa05159b8ac91d431e4eb6a5db28766384648b5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":117,"pageEnd":117,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (552, '553', 'Pajtimi i pasardhësve', '1-2', 'Ligji 04/L-077
Neni 553 - Pajtimi i pasardhësve

1. Nëse ndonjëri nga pasardhësit nuk ka dhënë pëlqimin në dorëzimin dhe ndarjen, ato pjesë të
pasurisë të dorëzuara tek pasardhësit tjerë do të konsiderohen dhurata dhe pas vdekjes së
paraardhësit trajtohen si dhurata që u janë bërë trashëgimtarëve nga paraardhësi.
2. Dispozita e paragrafit paraprak do të zbatohet përshtatshmërisht edhe nëse pas dorëzimit dhe
ndarjes, për të cilin është dhënë pëlqimi nga të gjithë pasardhësit, është lindur një fëmijë te dorëzuesi
ose një pasardhës i cili është gjetur pas shpalljes për të vdekur.', '60be10483f86bd622bbaaceecaacf2cc52a147fbaf82ddc53418199986b5356a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":117,"pageEnd":117,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (553, '554', 'Ruajtja e të drejtave gjatë dorëzimit', '1-2', 'Ligji 04/L-077
Neni 554 - Ruajtja e të drejtave gjatë dorëzimit

1. Gjatë dorëzimit dhe ndarjes së pasurisë dorëzuesi mund të ruaj për veten e tij apo saj,
bashkëshorten apo bashkëshortin e tij apo saj apo për çdo person tjetër të drejtën e uzufruktit mbi të
gjithë pasurinë apo një pjesë të pasurisë së dorëzuar ose të kërkojë një rentë jetësore me para në dorë
apo në vepër, mbajtje të përjetshme ose ndonjë kompensim tjetër.
2. Nëse është arritur marrëveshja mbi uzufruktin ose rentën jetësore për dorëzuesin dhe bashkëshorten
apo bashkëshortin e tij apo saj së bashku, atëherë në rast të vdekjes së njërit prej tyre uzufrukti apo
renta jetësore i takon tjetrit në tërësinë e plotë të saj deri në vdekjen e këtij tjetrit, përveç nëse është
përcaktuar ndryshe me marrëveshje ose përveç nëse rrjedh ndryshe nga rrethanat e rastit.', '5fcb4d30e129960e699d9e0e6f10262e9fb2300f45e8f3b973d693aac54a27c5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":118,"pageEnd":118,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (554, '555', 'E drejta e bashkëshortit/es së dorëzuesit/es', '1-3', 'Ligji 04/L-077
Neni 555 - E drejta e bashkëshortit/es së dorëzuesit/es

1. Gjatë dorëzimit dhe ndarjes, dorëzuesi gjithashtu mund të marrë parasysh edhe bashkëshorten apo
bashkëshortin. Për ta bërë këtë është e nevojshme dhënia e pëlqimit të bashkëshortes apo
bashkëshortit.
2. Nëse bashkëshortja apo bashkëshorti nuk janë marrë parasysh, të drejtat e saj apo tij për pjesën e
detyrueshme mbeten të pacenuara.
3. Në rastin e tillë, dorëzimi dhe ndarja mbeten të vlefshme, por në përcaktimin e vlerës së pasurisë së
përgjithshme në bazë të së cilës është përcaktuar pjesa e detyrueshme e bashkëshortes apo
bashkëshortit të pas jetuar, ato pjesë të pasurisë së trashëgimlënësit të dorëzuara tek pasardhësit e tij
apo saj do të konsiderohen si dhurata.', '275cb21c0117ec96b062769e9d11df750925defd431ed939e81c863befe878d0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":118,"pageEnd":118,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (555, '556', 'Borxhet e dorëzuesit', '1-2', 'Ligji 04/L-077
Neni 556 - Borxhet e dorëzuesit

1. Pasardhësi të cilit dorëzuesi i ka dorëzuar pasurinë e tij apo saj, nuk është përgjegjës për borxhet e
dorëzuesit, përveç nëse përcaktohet ndryshe me marrëveshjen e dorëzimit dhe ndarjes.
2. Kreditorët e dorëzuesit mund ta ndalojnë dorëzimin dhe ndarjen sipas kushteve që zbatohen tek
ndalimi i disponimit me mirënjohje.', 'bda7c1642d9056a100bbcfaab004a2bfd9425d8ec1d998735fa80113aeb670d4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":118,"pageEnd":118,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (556, '557', 'Garancia', null, 'Ligji 04/L-077
Neni 557 - Garancia

Detyrimi për garancinë që rrjedh pas ndarjes ndërmjet bashkë trashëgimtarëve duhet të rrjedhë
gjithashtu ndërmjet pasardhësve pas dorëzimit dhe ndarjes së pasurisë të dorëzuar dhe ndarë nga
paraardhësi apo prindi adoptues.', 'b7c01874d5113bf42db795b0dbbc0144c8b3f78b0b20ba85413a753aacedcca4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":118,"pageEnd":118,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (557, '558', 'Revokimi i dorëzimit', '1-3', 'Ligji 04/L-077
Neni 558 - Revokimi i dorëzimit

1. Dorëzuesi mund të revokojë kontratën për arsye të mosmirënjohjes së thellë nëse pas lidhjes së sajë
një pasardhës sillet ndaj dorëzuesit apo ndaj personit të afërt me të në atë mënyrë që sipas parimeve
themelore të moralit do të ishte e padrejtë që të mbante atë që është marrë.
2. Dorëzuesi ka të drejtën e njëjtë nëse pasardhësi nuk arrin ti ofrojë atij apo asaj apo personit tjetër,
mbajtjen për të cilën janë pajtuar me kontratën e dorëzimit dhe ndarjes ose nuk arrin të paguaj borxhet
e dorëzuesit kur kontrata e ka ngarkuar pasardhësin me pagimin e borxheve të tilla.
3. Në rastet e tjera të mos përmbushjes së detyrimeve të marra përsipër me anë të kontratës së
dorëzimit dhe ndarjes, gjykata vendosë nëse dorëzuesi ka të drejtë të kërkojë kthimin e pasurisë së
dhënë apo vetëm të drejtën që të kërkojë përmbushjen e detyrimeve, duke marrë parasysh lartësinë e
borxheve të dorëzuesit si dhe rrethanat tjera të rastit.', '6ab1afd8be7cb9241e22d6bdfb5ff9ca94083f1353f63f2a5fb575f13a2e956a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":118,"pageEnd":119,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (558, '559', 'Të drejtat e pasardhësve, fëmijëve të adoptuar dhe pasardhësve të fëmijëve të adoptuar pas revokimit', '1-2', 'Ligji 04/L-077
Neni 559 - Të drejtat e pasardhësve, fëmijëve të adoptuar dhe pasardhësve të fëmijëve të adoptuar pas revokimit

1. Pasardhësi i cili është dashur të kthej tek dorëzuesi atë që është marrë gjatë dorëzimit dhe ndarjes
mund të kërkojë pjesën e tij apo saj të detyrueshme pas vdekjes së dorëzuesit, përveç nëse është
përjashtuar nga trashëgimia apo nuk është i denjë të trashëgojë nga dorëzuesi, ose përveç nëse ka
hequr dorë nga trashëgimia.
2. Gjatë llogaritjes së pjesës së detyrueshme, ato pjesë të pasurisë të dorëzuara dhe shpërndara nga
trashëgimlënësi gjatë jetës tek pasardhësit tjerë, konsiderohen si dhurata.', 'dbb20e7412b55163d179e9ddd1164a03f17fd895cf2eec7c3a6e5e095ab4a475', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":119,"pageEnd":119,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (559, '560', 'Përkufizimi', '1-3', 'Ligji 04/L-077
Neni 560 - Përkufizimi

1. Me anë të kontratës për mbajtjen e përjetshme, një palë kontraktuese (dhënësi i mbajtjes) merr
përsipër të ndihmojë palën tjetër kontraktuese apo ndonjë person tjetër (marrësin e mbajtjes ) dhe pala
tjetër kontraktuese deklaron se ai apo ajo do ti dorëzojë të parit (dhënësit të mbajtjes) të gjithë pasurinë
apo një pjesë të pasurisë së tij apo sajë, e përbërë nga pasuria e përgjithshme dhe pasuria e luajtshme
e dedikuar për ta përdorur dhe gëzuar pasurinë e përgjithshme, me ç’rast dorëzimi i tillë shtyhet deri në
kohën e vdekjes së dorëzuesit.
2. Kjo kontratë gjithashtu mund të përfshijë edhe pasuri tjetër të luajtshme të marrësit të mbajtjes, e cila
duhet të theksohet në kontratë.
3. Kontratat me të cilat arrihet marrëveshja për premtimin e trashëgimit të një bashkimi të përjetshëm
apo një bashkim i pasurisë ose një palë kontraktuese pajtohet që të kujdeset dhe të mbrojë palën tjetër,
të punoj pronën e tij apo sajë të kryejë të gjitha ceremonitë e funeralit pas vdekjes së tij apo saj, apo
çdo gjë tjetër për të njëjtin qëllim duhet të konsiderohen kontrata për mbajtjen e përjetshme.', 'ca6752dee8164daec070fd521cf0b7822fffd85cb34893da3eab277d6db83d5f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":119,"pageEnd":119,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (560, '561', 'Forma', null, 'Ligji 04/L-077
Neni 561 - Forma

Kontrata për mbajtjen e përjetshme duhet të bëhet në formë të aktit noterial.', '21ce06c959badc796ebf0c1cf826688d07c166d4ba3f27d114cc48b8d9161a39', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":119,"pageEnd":119,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (561, '562', 'Ndalimi i përdorimit në favor të palës mbajtëse', null, 'Ligji 04/L-077
Neni 562 - Ndalimi i përdorimit në favor të palës mbajtëse

Marrësi i mbajtjes mund të heq dorë nga përdorimi i pasurisë që është objekt i kontratës për mbajtjen e
përjetshme në favor të dhënësit të mbajtjes.', 'b942cf9f1d7ebcac9f032402a9b19432dffa978a0c90be24f283e36e9c6fbbcd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":119,"pageEnd":119,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (562, '563', 'Përgjegjësia për borxhet', null, 'Ligji 04/L-077
Neni 563 - Përgjegjësia për borxhet

Pas vdekjes së marrësit të mbajtjes, dhënësi i mbajtjes nuk është përgjegjëse për borxhet e lidhura me
të, por në kontratë mund të përcaktohet që dhënësi i mbajtjes do të jetë përgjegjëse për borxhet
ekzistuese të marrësit të mbajtjes ndaj kreditorëve të caktuar.', '2c7325f809215f5c76c2556cef75c76a60370d34c823b7f2c781d3aa6712fa89', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":120,"pageEnd":120,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (563, '564', 'Anulimi i kontratës', '1-3', 'Ligji 04/L-077
Neni 564 - Anulimi i kontratës

1. Palët kontraktuese kanë mundësi që kontratën për mbajtjen e përjetshme ta shkëpusin me
marrëveshje, madje edhe pasi të kenë filluar me përmbushjen e saj.
2. Nëse sipas kontratës për mbajtjen e përjetshme, palët kontraktuese jetojnë së bashku dhe
marrëdhënia e tyre përkeqësohet deri në atë masë saqë jeta e përbashkët bëhet e patolerueshme,
secila palë mund të kërkojë që gjykata ta anulojë kontratën.
3. Secila palë mund të kërkojë shkëputjen e kontratës nëse pala tjetër nuk përmbushë detyrimet e saj.', 'aa2ab273f2e05a529ee819497f9f33214e0e68f321abf69dc0f23094f739577c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":120,"pageEnd":120,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (564, '565', 'Ndryshimi i rrethanave', '1-2', 'Ligji 04/L-077
Neni 565 - Ndryshimi i rrethanave

1. Nëse pas lidhjes së kontratës, rrethanat ndryshojnë deri në atë masë sa përmbushja e kontratës
bëhet shumë më e vështirë, atëherë gjykata , me kërkesën e ndonjërës prej palëve, duke i marrë
parasysh të gjitha rrethanat, mund të ndryshojë marrëdhëniet e tyre në kontratë ose ta anulojë atë.
2. Gjykata mund të ndryshojë të drejtat e marrësit të mbajtjes në rentë jetësore, nëse kjo gjë është në
interes të dyja palëve.', '1b84f3cec9bff544e673089c0405849f7b8d59e85d2ba53f7163f072d7990e60', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":120,"pageEnd":120,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (565, '566', 'Shkëputja e kontratës', '1-4', 'Ligji 04/L-077
Neni 566 - Shkëputja e kontratës

1. Nëse dhënësi i mbajtjes vdes, detyrimet nga kjo marrëdhënie transferohen tek bashkëshortja e tij
apo bashkëshorti i saj dhe tek pasardhësit, fëmijët e adoptuar dhe pasardhësit e fëmijëve të adoptuar,
nëse ata japin pëlqimin për një gjë të tillë.
2. Në kuptim të paragrafit paraprak, nëse të njëjtit nuk e japin pëlqimin për vazhdimin e kontratës për
mbajtjen e përjetshme, kontrata zgjidhet dhe ata nuk kanë të drejtë të kërkojnë kompensim për
mbajtjen e mëparshme.
3. Nëse bashkëshorti apo bashkëshortja, pasardhësit, fëmijët e adoptuar apo pasardhësit e fëmijëve të
adoptuar nuk kanë mundësi të përmbushin detyrimet kontraktore ata kanë të drejtë të kërkojnë
shpërblim nga marrësi i mbajtjes.
4. Gjykata përcakton shpërblimin e tillë në bazë të diskrecionit të saj, duke marrë parasysh gjendjen
financiare të palës së mbajtur si dhe gjendjen financiare të atyre që janë të thirrur që ta vazhdojnë
kontratën për mbajtjen e përjetshme.', 'e5280b298fc78253b0ed0f063c9a95d00ab37454edea96e30331266d7352770c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":120,"pageEnd":120,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (566, '567', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 567 - Nocioni

1. Me kontratën e huas huadhënësi obligohet t''ia dorëzojë huamarrësit një shumë të caktuar të hollash
ose sasinë e caktuar të sendeve të tjera të zëvendësueshme, ndërsa huamarrësi obligohet ta kthejë
pas një kohe të caktuar të njëjtën shumë të hollash, përkatësisht të njëjtën sasi sendesh të llojit dhe të
cilësisë së njëjtë.
2. Mbi sendet e marra huamarrësi fiton të drejtën e pronësisë.', '69efe726719d662a6305104b0750b85bed50b5a29704474d5cd224ef7a05a598', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":121,"pageEnd":121,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (567, '568', 'Kamata', '1-2', 'Ligji 04/L-077
Neni 568 - Kamata

1. Huamarrësi mund të obligohet që përveç kryegjësë të debitojë edhe kamatën.
2. Në kontratat ekonomike huamarrësi detyrohet të paguaj edhe kamatën, përveç nëse merren vesh
ndryshe.', '025840a02912e848cc94289d8b88ce1efeef96131d85e625e6a796213f355a7b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":121,"pageEnd":121,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (568, '569', 'Dorëzimi i sendeve të premtuara', '1-2', 'Ligji 04/L-077
Neni 569 - Dorëzimi i sendeve të premtuara

1. Huadhënësi ka për detyrë t''i dorëzojë sendet e premtuara në kohën e kontraktuar, e në qoftë se afati
i dorëzimit nuk është caktuar, atëherë duhet ta bëjë këtë kur ta kërkojë huamarrësi.
2. E drejta e huamarrësit për të kërkuar dorëzimin e sendeve të caktuara parashkruhet në tre (3) muaj
nga vonesa e huadhënësit, e në çdo rast për një (1) vit nga lidhja e kontratës.', '6023c71567cb74356b41935bf0216a3e397de4e9ff760b183eac6fe5482d7fee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":121,"pageEnd":121,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (569, '570', 'Gjendja e keqe materiale e huamarrësit', '1-2', 'Ligji 04/L-077
Neni 570 - Gjendja e keqe materiale e huamarrësit

1. Në qoftë se vërtetohet se gjendja materiale e huamarrësit është e atillë që tregon se është e pasigurt
a do të jetë në gjendje ta kthejë huan, huadhënësi mund të refuzojë ta kryejë detyrimin e vet të
dorëzimit të sendeve të premtuara, në qoftë se në kohën e lidhjes së kontratës nuk ka ditur, si dhe në
qoftë se keqësimi i gjendjes materiale të huamarrësit ka ndodhur pas lidhjes së kontratës.
2. Mirëpo, ai do të ketë për detyrë ta kryejë detyrimin e vet në qoftë se huamarrësi ose ndokush tjetër
për të ofron sigurim të mjaftueshëm.', 'b1151c17abdc9c1012a22cae4ebfce023005a829e1bdd80dcf36c9b962717eb1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":121,"pageEnd":121,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (570, '571', 'Dëmi për shkak të të metave të sendeve të dhëna hua', '1-2', 'Ligji 04/L-077
Neni 571 - Dëmi për shkak të të metave të sendeve të dhëna hua

1. Huadhënësi ka për detyrë t''ia kompensojë huamarrësit dëmin që do t''i shkaktohej për shkak të
metave materiale të sendeve të dhëna hua.
2. Mirëpo, në qoftë se huaja është pa shpërblim, ai ka për detyrë ta shpërblejë dëmin vetëm në qoftë se
ka qenë në dijeni për të metat e sendit, ose nuk ka mundur të mos dinte për to, ndërsa ai për to nuk e
ka njoftuar huamarrësin.', '98e621b5323c872a3457df16378281a3a623263c5c6d61aec7a4399f30d22733', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":121,"pageEnd":122,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (571, '572', 'Afati i kthimit të huas', '1-2', 'Ligji 04/L-077
Neni 572 - Afati i kthimit të huas

1. Huamarrësi ka për detyrë që në afatin e kontraktuar t''i kthejë sendet e marra hua në sasi e në cilësi
të njëjtë.
2. Në qoftë se kontraktuesit nuk kanë caktuar afatin për kthimin e huas dhe as që ky mund të caktohet
nga rrethanat e huas, huamarrësi ka për detyrë ta kthejë huan pasi të ketë kaluar afati i arsyeshëm,
duke filluar që nga kërkesa e huadhënësit që huaja t''i kthehet e që nuk mund të jetë më i shkurtër se dy
(2) muaj.', 'a018d2bd4f79098ae7ac5c3e7d09c0af45e1943543c34427bcee59b4a549f4a1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":122,"pageEnd":122,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (572, '573', 'Zgjedhja me rastin e kthimit të huas', '1-2', 'Ligji 04/L-077
Neni 573 - Zgjedhja me rastin e kthimit të huas

1. Në qoftë se nuk janë dhënë hua të hollat, ndërsa është kontraktuar që huamarrësi do ta kthejë huan
në të holla, huamarrësi megjithatë është i autorizuar që sipas dëshirës së vetë ti kthejë sendet e marra
hua ose shumën e të hollave që i përgjigjet vlerës së këtyre sendeve në kohën dhe në vendin e caktuar
në kontratë për ti kthyer.
2. E njëjta gjë vlen edhe në rastin kur nuk ka mundësi të kthehet e njëjta sasi sendesh dhe të cilësisë e
të llojit të njëjtë.', 'effc9e0c800bfd0408580f0a016111dbd100a622554e832ef549f709761c9194', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":122,"pageEnd":122,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (573, '574', 'Heqja dorë nga kontrata', null, 'Ligji 04/L-077
Neni 574 - Heqja dorë nga kontrata

Huamarrësi mund të heqë dorë nga kontrata para se huadhënësi t''i dorëzojë sendet e caktuara por në
qoftë se për këtë shkak do të ndodhte ndonjë dëm për huadhënësin, ka për detyrë ta kompensojë atë.', '065c1d2bc244800311f487a831fe152bf05891a1caa58aafc37bec058e556647', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":122,"pageEnd":122,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (574, '575', 'Kthimi i huas para afatit', null, 'Ligji 04/L-077
Neni 575 - Kthimi i huas para afatit

Huamarrësi mund ta kthejë huan edhe para afatit të caktuar për kthim, por ka për detyrë ta njoftojë
huadhënësin që përpara mbi qëllimin e vet, dhe t''ia shpërblejë dëmin e shkaktuar.', 'ab9ef11c1346f1deb8c175b5f697b5ccf6e0b5e2c61b363cb2961306f92bedc7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":122,"pageEnd":122,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (575, '576', null, null, 'Ligji 04/L-077
Neni 576

Në qoftë se me kontratë është caktuar qëllimi për të cilin huamarrësi mund t''i përdorë të hollat e marra
hua ndërsa ai i përdorë për ndonjë qëllim tjetër, huadhënësi mund të deklarojë se e zgjidhë kontratën.', 'b6982f319167d7f9daa4dea9e0fc7d36b45dd510e5753b375c2a5a5803684661', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":122,"pageEnd":122,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (576, '577', 'Përkufizimi', null, 'Ligji 04/L-077
Neni 577 - Përkufizimi

Me kontratën për huapërdorjen, huapërdordhënësi detyrohet të dorëzojë një send huapërdormarrësit
në përdorim me mirëbesim dhe huapërdormarrësi detyrohet të kthej sendin.', '0ed5bedf1a6a17de36a0a87eebac9dd43209d5ce79d6477114e13079fa588b9a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":123,"pageEnd":123,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (577, '578', 'Përdorimi i sendit', '1-3', 'Ligji 04/L-077
Neni 578 - Përdorimi i sendit

1. Huapërdormarrësi mund të përdorë sendin vetëm për qëllimin e përcaktuar me kontratë.
2. Nëse qëllimi i përdorimit nuk është përcaktuar me kontratë, huapërdormarrësi mund të përdorë
sendin në përputhje me natyrën dhe qëllimin e sendit dhe me kujdesin e një përdoruesi të mirë.
3. Huapërdormarrësi që e përdorë sendin në mënyrë jo të lejueshme është përgjegjës për çdo prishje
apo shkatërrim të rastësishëm.', '12b69050869b71e6e9a59522cf241b6e8e22747e77da3f52365b25866beb637c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":123,"pageEnd":123,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (578, '579', 'Mbajtja e sendit', '1-2', 'Ligji 04/L-077
Neni 579 - Mbajtja e sendit

1. Huapërdormarrësi ngarkohet me shpenzimet e rregullta të mbajtjes së sendit.
2. Huapërdormarrësi mund të kërkojë kthimin e shpenzimeve jo të rregullta të mbajtjes së sendit në
përputhje me rregullat e mbajtjes. Me shuarjen e huapërdorjes, huapërdormarrësi mund t’i ndajë
pajisjet që ndahen nga lënda e huapërdorjes.', 'e0f4395ea72cd7ee2b81f5cc272c7a7c1d31e869c784b3fdeae7efc7b28c675e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":123,"pageEnd":123,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (579, '580', 'Transferimi i përdorimit', null, 'Ligji 04/L-077
Neni 580 - Transferimi i përdorimit

Huapërdormarrësi nuk mund të transferojë përdorimin e sendit tek personi i tretë pa pëlqimin e
huapërdordhënësit.', '09e137b650b9db7bf437c48b607ea64da3de8e5cbe050b5ee9afc9e3c6ffbb0a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":123,"pageEnd":123,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (580, '581', 'Kthimi i sendit', '1-3', 'Ligji 04/L-077
Neni 581 - Kthimi i sendit

1. Huapërdormarrësi duhet të kthej sendin në kohën për të cilën janë marrë vesh.
2. Nëse koha nuk është përcaktuar, kontrata shuhet në momentin kur huapërdormarrësi ka realizuar
qëllimin e përcaktuar në kontratë apo në fund të periudhës në të cilën mund të bëhet përdorimi i tillë.
3. Nëse as koha e as qëllimi nuk janë përcaktuar me kontratë, huapërdordhënësi mund të kërkojë
sendin në secilën kohë që dëshiron.', '71e06e29d9b9250b80df5f17ac88ef19723ad66d39f7d88b5a19436bed07a011', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":123,"pageEnd":123,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (581, '582', 'Zgjidhja e kontratës', '1-1.3', 'Ligji 04/L-077
Neni 582 - Zgjidhja e kontratës

1. Huapërdordhënësi mund të zgjidh kontratën pa njoftim paraprak dhe të kërkojë kthimin e
menjëhershëm të sendit nëse:
1.1. huapërdormarrësi vdes;
1.2. huapërdormarrësi përdorë sendin në kundërshtim me kontratën ose e transferon tek
personi i tretë pa pasur të drejtë;
1.3. sendi i huapërdorjes i duhet huapërdordhënësit për shkak të rrethanave të paparashikuara.', '6795fb089fb1d369f04c0beef0c92dc3e3af9cab90770b6c6af53770b5c0ed6a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.3","pageStart":124,"pageEnd":124,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (582, '583', 'Përgjegjësia', null, 'Ligji 04/L-077
Neni 583 - Përgjegjësia

Huapërdormarrësi nuk është përgjegjës për asnjë përkeqësim apo ndryshim të sendit si rezultat i
pasojave të zakonshme të përdorimit të bërë në përputhje me kontratën.', '100c3b3f1ff770c482a98317f6cc770b8dc155126934aee866a2c8dc2689eef6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":124,"pageEnd":124,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (583, '584', 'Dëmi nga të metat', null, 'Ligji 04/L-077
Neni 584 - Dëmi nga të metat

Nëse sendi i cili është objekt i huapërdorjes ka një të metë apo një veçori të rrezikshme si pasojë e së
cilës dëmi është shkaktuar tek huapërdormarrësi ose te i treti si i dëmtuar, ndërsa huapërdordhënësi,
ka qenë në dijeni apo është dasht të ishte në dijeni për metat apo veçorinë e rrezikshme por nuk e ka
njoftuar huapërdormarrësin, atëherë huapërdordhënësi është përgjegjës për dëmin.', '027842e1c17c93562158d92ccd01ef09a68804b30489db1cb5c8a2cc1d43ea33', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":124,"pageEnd":124,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (584, '585', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 585 - Nocioni

1. Me kontratën për qiranë, qiradhënësi detyrohet që t’ia dorëzojë sendin e caktuar qiramarrësit në
përdorim, ndërsa qiramarrësi detyrohet t’i paguajë qiranë e kontraktuar.
2. Përdorimi përfshin edhe gëzimin e sendit (vjelja e frutave), në qoftë se nuk rrjedhë diçka ndryshe nga
kontrata, ose nga zakoni.', '929e4c15a1c5ca82e7edb7f4b6a6332e709d28cc94af2c5f34981c715f42a4a5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":124,"pageEnd":124,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (585, '586', 'Dorëzimi i Sendit', null, 'Ligji 04/L-077
Neni 586 - Dorëzimi i Sendit

Qiradhënësi ka për detyrë t''i dorëzojë qiramarrësit sendin e marrë me qira së bashku me akcesorët dhe
pjesët përbërëse të tij.', '35d09739bbb5bf2bb8d627a5f9c853f9d4b8a788be72db9383f40a541d0410a2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":125,"pageEnd":125,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (586, '587', 'Mirëmbajtja e sendeve', '1-4', 'Ligji 04/L-077
Neni 587 - Mirëmbajtja e sendeve

1. Qiradhënësi ka për detyrë t''i mirëmbajë sendet në gjendje të rregullt gjatë kohës së qirasë dhe për
këtë arsye të bëjë riparime të nevojshme në të.
2. Ai ka për detyrë t''i kompensojë qiramarrësit shpenzimet që i ka bërë ky për mirëmbajtjen e sendit, e
që do t''i kishte për detyrë ky t''i bënte.
3. Shpenzimet e meremetimeve të vogla të shkaktuara nga përdorimi i zakonshëm i sendit, si dhe
shpenzimet e vetë përdorimit bien në ngarkim të qiramarrësit.
4. Mbi nevojën e riparimit qiramarrësi ka për detyrë ta njoftojë qiradhënësin.', 'cbed622967560bb3fe3071a57c05dadc8139b2b89a146502ecfe94d4080f3e1c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":125,"pageEnd":125,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (587, '588', 'Zgjidhja e kontratës dhe zbritja e qirasë për shkak të riparimeve', '1-2', 'Ligji 04/L-077
Neni 588 - Zgjidhja e kontratës dhe zbritja e qirasë për shkak të riparimeve

1. Në qoftë se meremetimet e nevojshme të sendit të marrë me qira pengojnë përdorimin e tij në një
masë të konsideruar dhe për një kohë të gjatë, qiramarrësi mund ta zgjidhë kontratën.
2. Ai ka të drejtë në zbritjen e qirasë proporcionalisht me kufizimin e përdorimit të sendit për shkak të
këtyre riparimeve.', '70b3fd7171ce7b4ffb1ee75ecb24ecc6c26fc681bc1f3b89c3a126d7ebe9b39c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":125,"pageEnd":125,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (588, '589', 'Ndryshimet në sendin e marrë me qira', '1-2', 'Ligji 04/L-077
Neni 589 - Ndryshimet në sendin e marrë me qira

1. Qiradhënësi nuk mundet pa pëlqimin e qiramarrësit të bëjë ndryshime në sendin e marrë me qira
gjatë kohës së qirasë, në qoftë kjo do të pengonte përdorimin e sendit.
2. Në qoftë se me ndryshimet e sendit do të zvogëlohej në një farë mase përdorimi i sendit nga ana e
qiramarrësit, do të zvogëlohet edhe qiraja në përpjesëtimin përkatës.', '92cf6e1e62dc8fbafed8994a71995423c1164368ea411bfafb751686edce6189', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":125,"pageEnd":125,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (589, '590', 'Përgjegjësia për të metat materiale', '1-2', 'Ligji 04/L-077
Neni 590 - Përgjegjësia për të metat materiale

1. Qiradhënësi i përgjigjet qiramarrësit për të gjitha të metat e sendit të marrë me qira që pengojnë në
përdorimin e kontraktuar ose të zakónshëm të tij, pavarësisht nëse ka ditur ose jo për to, si dhe për të
metat e veçorive apo të karakteristikave të parashikuara shprehimisht ose heshtazi me kontratë.
2. Nuk merren në konsiderim të metat e një rëndësisë të vogël.', '5a89f2a6aff401e0017adf87019408cdc13021527fc91f5bf6a40864b7fd7d74', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":125,"pageEnd":125,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (590, '591', 'Të metat për të cilat qiradhënësi nuk përgjigjet', '1-2', 'Ligji 04/L-077
Neni 591 - Të metat për të cilat qiradhënësi nuk përgjigjet

1. Qiradhënësi nuk përgjigjet për të metat e sendit të marrë me qira të cilat në momentin e lidhjes së
kontratës kanë qenë të njohura për qiramarrësin, ose nuk kanë mundur t''i mbeten të panjohura.
2. Mirëpo, qiradhënësi përgjigjet dhe për te metën e sendit të marrë me qira e cila i ka mbetur e
panjohur qiramarrësit për shkak të pakujdesisë së rëndë, në qoftë se ky ka qenë në dijeni për këtë të
metë dhe me dashje ka ometuar që për këtë ta njoftojë qiramarrësin.', '423ecdb957153d18fd0cc26cb94a4f4e3c2306e0b4b935134e190431537f2a48', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":125,"pageEnd":126,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (591, '592', 'Zgjerimi i përgjegjësisë për të metat materiale', null, 'Ligji 04/L-077
Neni 592 - Zgjerimi i përgjegjësisë për të metat materiale

Qiradhënësi përgjigjet për të gjitha të metat e sendit të marrë me qira, ne qoftë se ka pohuar se ai nuk
ka kurrfarë të metash.', 'c47290bd7ebac97ca22e23adf9b848d1f7e1d629017ae9c116cce30070612542', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":126,"pageEnd":126,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (592, '593', 'Përjashtimi kontraktues ose kufizimi i përgjegjësisë', '1-2', 'Ligji 04/L-077
Neni 593 - Përjashtimi kontraktues ose kufizimi i përgjegjësisë

1. Përgjegjësia për të metat materiale të sendit të marrë me qira mund të përjashtohet ose të kufizohet
me kontratë.
2. Dispozita e kontratës me të cilën kjo përgjegjësi përjashtohet ose kufizohet është e pavlefshme në
qoftë se qiradhënësi ka qene ne dijeni për të metat dhe me dashje ka ometuar që për to ta njoftojë
qiramarrësin, ose poqëse e meta është e atillë që bën të pamundur përdorimin e sendit të marrë me
qira si dhe atëherë kur qiradhënësi ka imponuar këtë dispozitë duke shfrytëzuar pozitën e vet
monopoliste.', '3d756f71d48c4ade9e6b13aa4426c8fe8c4bf134bb4f4e29dbbee2fd79fd48f6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":126,"pageEnd":126,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (593, '594', 'Njoftimi i qiradhënësit mbi të metat dhe rreziqet', '1-3', 'Ligji 04/L-077
Neni 594 - Njoftimi i qiradhënësit mbi të metat dhe rreziqet

1. Qiramarrësi ka për detyrë ta njoftoje qiradhënësin pa shtyrje të panevojshme për secilën të metë të
sendit të marrë me qira që do të tregohej gjatë kohës së qirasë, përveç në qoftë se qiradhënësi ka ditur
për të metën.
2. Ai ka për detyrë gjithashtu ta njoftojë qiradhënësin për çdo rrezik të paparashikuar që do të kanosej
gjate kohës së qirasë, sendit të marrë me qira për të mundur të marrë masa të nevojshme.
3. Qiramarrësi i cili nuk e njofton qiradhënësin mbi shfaqjen e të metës, ose mbi rrezikun e lindur për të
cilën ky nuk ka ditur humb të drejtën e shpërblimit të dëmit që do të pësonte për shkak të ekzistimit të të
metës ose rrezikut të paraqitur për sendin e marrë me qira dhe ka për detyrë ta shpërblejë dëmin që do
ta pësonte qiradhënësi për këtë arsye.', 'a085e4da2aea2cddf18f6872c8676a244b897af026587c96214e64359dcbcf39', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":126,"pageEnd":126,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (594, '595', 'Të drejtat e qiramarrësit kur sendi ka ndonjë të metë', '1-4', 'Ligji 04/L-077
Neni 595 - Të drejtat e qiramarrësit kur sendi ka ndonjë të metë

1. Në qoftë se sendi i marrë me qira në momentin e dorëzimit ka ndonjë të metë që nuk mund të
evitohet, qiramarrësi mundet sipas dëshirës së vet, ta zgjidhë kontratën ose të kërkojë zbritjen e çmimit
të qirasë.
2. Kur sendi ka ndonjë të metë që nuk mund të evitohet pa ndërlikime të mëdha për qiramarrësin,
ndërsa dorëzimi i sendit në afatin e caktuar nuk ka qenë pjese esenciale e kontratës, qiramarrësi mund
të kërkojë nga qiradhënësi ose evitimin e te metës në afatin plotësues, ose zbritjen e çmimit të qirasë.
3. Në qoftë se qiradhënësi nuk e eviton te metën në afatin e ri plotësues qe ia ka caktuar qiramarrësi,
qiramarrësi mund ta zgjidhë kontratën ose të kërkojë zbritjen e çmimit të qirasë.
4. Sidoqoftë, qiramarrësi ka të drejtë në shpërblimin e dëmit.', '2ab80fcf0a96a2e5c5d2d1cc28ca3e02b510d0501786f1754a60c17200f00604', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":126,"pageEnd":126,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (595, '596', 'Kur e meta paraqitet gjatë qirasë dhe kur sendi nuk ka veçori të kontraktuar ose të zakonshme', '1-2', 'Ligji 04/L-077
Neni 596 - Kur e meta paraqitet gjatë qirasë dhe kur sendi nuk ka veçori të kontraktuar ose të zakonshme

1. Dispozitat e nenit paraprak aplikohen edhe në rastin kur gjatë qirasë paraqitet ndonjë e mete në
sendin e marre me qira.
2. Ato aplikohen edhe në rastet kur sendi i marrë me qira nuk ka ndonjë veçori që sipas kontratës ose
sipas praktikës duhet të kishte, apo kur kjo veçori humbë gjatë qirasë.', '918989dd28d8ef44ce171b4843e7d53a6675f57e70a1f92c3a7cd69bc086cc57', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":127,"pageEnd":127,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (596, '597', 'Përgjegjësia e qiradhënësit për të metat juridike', '1-3', 'Ligji 04/L-077
Neni 597 - Përgjegjësia e qiradhënësit për të metat juridike

1. Kur dikush i treti pretendon që në sendin e marre me qira, ose në ndonjë pjesë të tij të ushtrojë
ndonjë të drejtë dhe i drejtohet me kërkesë të vet qiramarrësit, si dhe në qoftë se arbitrarisht e merr
sendin nga qiramarrësi, ky ka për detyrë ta njoftojë për këtë qiradhënësin, përveç nëse ky është tanimë
në dijeni për këtë, përndryshe do të përgjigjet për demin.
2. Në qoftë se vërtetohet se personit të tretë i takon ndonjë e drejte e cila përjashton fare të drejtën e
qiramarrësit në përdorimin e sendit, kontrata e qirasë zgjidhet vetvetiu ne bazë të ligjit, ndërsa
qiradhënësi ka për detyrë që qiramarrësit t''i shpërblejë dëmin e pësuar për këtë arsye.
3. Ne rastin kur me të drejtën e personit të tretë vetëm kufizohet e drejta e qiramarrësit, ky mundet
sipas dëshirës së vet ta zgjidhë kontratën ose të kërkojë zbritjen e qirasë, e në çdo rast shpërblimin e
dëmit.', 'ec04cd258cd2f6730068068f1a8e62c06eadb4e28f0637529d2164ef3be19598', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":127,"pageEnd":127,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (597, '598', 'Përdorimi i sendeve sipas kontratës', '1-3', 'Ligji 04/L-077
Neni 598 - Përdorimi i sendeve sipas kontratës

1. Qiramarrësi ka për detyrë ta përdorë sendin si ekonomist i mire respektivisht si shtëpiak i mirë.
2. Ai mund ta përdore vetëm ashtu sikundër është caktuar me kontratë ose me destinimin e sendit.
3. Ai përgjigjët për dëmin e paraqitur nga përdorimi i sendit të marrë me qira në kundërshtim me
kontratën ose me destinimin e tij, pavarësisht nëse a e ka përdorur sendin ai ose ndonjë person që
punon me urdhër të tij, ose ndonjë person tjetër të cilit ai ia ka bërë të mundur përdorimin e sendit.', '1de20175fa009cbc10c8db1ef1ed0119e22594f72c1e63d514af838cc0c64f54', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":127,"pageEnd":127,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (598, '599', 'Denoncimi për shkak të përdorimit në kundërshtim me kontratën', null, 'Ligji 04/L-077
Neni 599 - Denoncimi për shkak të përdorimit në kundërshtim me kontratën

Ne qoftë se qiramarrësi edhe pas paralajmërimit të drejtuar nga qiradhënësi, e përdore sendin në
kundërshtim me kontratën ose me destinimin e tij, ose e lënë pas dore mirëmbajtjen e tij, kështu që
ekziston rreziku i dëmit të konsideruar për qiradhënësin, ky mund ta denoncoj kontratën pa e dhënë
afatin e denoncimit.', '1e5d4f8244d1ce1c9c0378b94cecd15e2f1e5216e4b1e6af2273bb6a4d337d7f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":127,"pageEnd":127,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (599, '600', 'Pagimi i qirasë', '1-2', 'Ligji 04/L-077
Neni 600 - Pagimi i qirasë

1. Qiramarrësi ka për detyrë ta paguajë qiranë në afatet e caktuara me kontratë ose me ligj e në
mungesë të kontratës dhe të ligjit, ashtu siç praktikohet në vendin ku sendi i është dorëzuar
qiramarrësit.
2. Në qoftë se nuk është kontraktuar ndryshe ose në vendin e dorëzimit të sendit nuk praktikohet
ndryshe, qiraja paguhet për çdo gjashtë (6) mujor kur sendi është dhënë me qira për një ose për disa
vjet e në qoftë se është dhënë për një kohë më të shkurtër, atëherë pasi të ketë kaluar kjo kohë.', 'e85ee522cd0a8e6a5472dbfce2c7ac6b3fd02fd7f55fe36576a6e06a07362fbd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":127,"pageEnd":128,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
