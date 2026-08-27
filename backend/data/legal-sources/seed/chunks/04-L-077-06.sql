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
  (750, '751', 'Tërheqja e mallit dhe shitja e mallit të patërhequr', '1-2', 'Ligji 04/L-077
Neni 751 - Tërheqja e mallit dhe shitja e mallit të patërhequr

1. Dhënësi mund ta tërheqë mallin edhe para afatit të kontraktuar.
2. Në qoftë se depozitdhënësi nuk e tërheq mallin pas kalimit të afatit të kontraktuar ose pas kalimit të
vitit, në qoftë se nuk është kontraktuar afati për ruajtje, magazinieri mund në llogarinë e tij ta shesë
mallin në shitje publike, por ka për detyrë ta njoftojë më parë për qëllimin e tij dhe t’i lë afat të ri, jo më
pak se prej tetë ditësh që mallin ta tërheqë.', '202297f57b85c90c5b9e76f5caad0623ea85b286b11f476d949543aa9dab8420', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":159,"pageEnd":159,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (751, '752', 'Të metat me rastin e pranimit të mallit', '1-3', 'Ligji 04/L-077
Neni 752 - Të metat me rastin e pranimit të mallit

1. Marrësi i mallit ka për detyrë ta kontrollojë mallin në çastin e pranimit të tij.
2. Në qoftë se me rastin e pranimit të mallit vë re të metat, pranuesi ka për detyrë ta paralajmërojë
menjëherë për këtë magazinierin, përndryshe konsiderohet se malli është pranuar në rregull.
3. Për të metat e mallit që nuk kanë mund të konstatohen në çastin e pranimit, marrësi ka për detyrë në
mënyrë të sigurt ta lajmërojë magazinierin brenda shtatë ditësh, duke llogaritur nga dita e pranimit të
mallit, përndryshe konsiderohet se malli është pranuar në rregull.', '6e71fc108d771a23f0892eb2d2e59c4e6f145090e09cd2e921a1ffb909239e05', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":160,"pageEnd":160,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (752, '753', 'Zbatimi i rregullave për depozitën', null, 'Ligji 04/L-077
Neni 753 - Zbatimi i rregullave për depozitën

Në kontratat për magazinimin përshtatshmërisht zbatohen rregullat për depozitën, në qoftë se me
rregullat e magazinimit nuk është rregulluar ndryshe.', '3a3edaf7d2e9e5c40d8a04809933d9bf993697769cdb867b64556a60bc40e080', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":160,"pageEnd":160,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (753, '754', 'Detyra e dhënies së fletëmagazinimit', null, 'Ligji 04/L-077
Neni 754 - Detyra e dhënies së fletëmagazinimit

Magazinieri i cili në bazë të ligjit është i autorizuar që për mallin e pranuar për magazinim të lëshojë
fletëmagazinimin ka për detyrë t’ia japë depozitëdhënësit me kërkesën e tij.', '58f03b5c69fb238040e1b6b4cc82a1b86a35c8c12af5e21d97c416a3a5949285', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":160,"pageEnd":160,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (754, '755', 'Pjesët përbërëse dhe përmbajtja e fletëmagazinimit', '1-3', 'Ligji 04/L-077
Neni 755 - Pjesët përbërëse dhe përmbajtja e fletëmagazinimit

1. Fletëmagazinimi përbëhet nga çertifikata dhe fletëpengu.
2. Dëftesa dhe fletëpengu përmbajnë këto të dhëna: emërtimin, përkatësisht emrin dhe profesionin e
depozitëdhënësit, selinë përkatësisht vendbanimin e përhershëm të tij, emërtimin dhe selinë e
magazinierit, datën dhe numrin e fletëmagazinimit, vendin ku ndodhet magazina, llojin, natyrën dhe
sasinë e mallit, të dhënën se deri në cilën shumë është siguruar malli dhe të dhëna tjera të nevojshme
për njohjen e mallit dhe caktimin e vlerës së tij.
3. Dëftesa dhe fletëpengu duhet t’i referohen njëra-tjetrës.', '9b20e2819b64c8ec857c41506dae56d6e3bd1ca86a327b4b9c1f5e29f832a248', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":160,"pageEnd":160,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (755, '756', 'Fletëmagazinimi për pjesët e mallrave', '1-3', 'Ligji 04/L-077
Neni 756 - Fletëmagazinimi për pjesët e mallrave

1. Depozitdhënësi mund të kërkojë që magazinieri t’i ndajë mallrat në pjesë të caktuara dhe që për
secilën pjesë t’i lëshojë fletëmagazinim të veçantë.
2. Në qoftë se ka marrë fletëmagazinimin për krejt sasinë e mallit, ai mund të kërkojë që magazinieri t’i
ndajë mallrat në pjesë të caktuara dhe në ndërrim të fletëmagazinimit që e ka marrë, t’i lëshojë
fletëmagazinimin për secilën pjesë të veçantë.
3. Depozitëdhënësi mund të kërkojë që magazinieri t’i lëshojë fletëmagazinimin vetëm për një pjesë të
mallit të zëvendësueshëm që e ka lënë te ai.', '9300b1f5d3c18d7c35d42080449c3154a2724d573233cafd50017126e46a7541', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":160,"pageEnd":160,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (756, '757', 'Të drejtat e poseduesit të fletëmagazinimit', '1-2', 'Ligji 04/L-077
Neni 757 - Të drejtat e poseduesit të fletëmagazinimit

1. Poseduesi i fletëmagazinimit ka të drejtë të kërkojë që t’i dorëzohet malli i shënuar në të.
2. Ai mund të disponojë mallrat e shënuara në fletëmagazinimin me bartjen e fletëmagazinimit.', 'aa5f3178b93e37cf60c15231a78613ca1606b568834629449fe4b35ef826c127', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":161,"pageEnd":161,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (757, '758', 'Bartja e dëftesës dhe e fletëpengut', '1-3', 'Ligji 04/L-077
Neni 758 - Bartja e dëftesës dhe e fletëpengut

1. Dëftesa dhe fletëpengu mund të barten me indosament, bashkë ose ndaras.
2. Me rastin e çdo bartjeje, në to duhet të shënohet data.
3. Me kërkesën e pranuesit të dëftesës ose të fletëpengut, bartja në të do të regjistrohet në regjistrin e
magazinës, ku do të shkruhet edhe selia përkatësisht vendbanimi i përhershëm i tij.', '28124c809b537e889a80cdf4c239cec9545087490bf78d85a0e1d5878d2f89da', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":161,"pageEnd":161,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (758, '759', 'E drejta e poseduesit të dëftesës', '1-3', 'Ligji 04/L-077
Neni 759 - E drejta e poseduesit të dëftesës

1. Bartja e dëftesës pa fletëpengun i jep marrësit të drejtën të kërkojë që t’i dorëzohet malli vetëm në
qoftë se i paguan poseduesit të fletëpengut, ose i depoziton magazinierit për poseduesin e fletëpengut
shumën që duhet t’i paguhet në ditën e rrjedhjes për pagesë të kërkesës.
2. Poseduesi i dëftesës pa fletëpeng mund të kërkojë që malli të shitet, në qoftë se me çmimin e
realizuar mund të paguhet shuma të cilën ka të drejtë poseduesi i fletëpengut, me kusht që teprica e
realizuar t’i dorëzohet atij.
3. Kur është fjala për sendet e zëvendësueshme, poseduesi i dëftesës pa fletëpengun mund të kërkojë
që magazinieri t’i dorëzojë një pjesë të mallrave me kusht që t’i depozitojë magazinierit për llogari të
poseduesit të fletëpengut shumën përkatëse në të holla.', '61e6f1febb7e3a63277509fa476778c4c9910aceb894fbe7ff1025fe3939c771', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":161,"pageEnd":161,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (759, '760', 'E drejta e poseduesit të fletëpengut', '1-5', 'Ligji 04/L-077
Neni 760 - E drejta e poseduesit të fletëpengut

1. Bartja e fletëpengut pa dëftesë i jep marrësit të drejtën e pengut të mallit.
2. Me rastin e bartjes se parë në fletëpeng duhet të jenë të shkruara emërtimi, respektivisht emri dhe
profesioni i kreditorit, selia e punës së tij afariste, respektivisht vendbanimi, shuma e kërkesës së tij,
duke llogaritur edhe kamatën dhe datën e arritjes.
3. Marrësi i parë i fletëpengut ka për detyrë që pa shtyrje t’i paraqes magazinierit se në të është bërë
bartja e fletëpengut, ndërsa magazina ka për detyrë ta regjistrojë këtë bartje në regjistrin e vet dhe në
vetë fletëpengun të shënojë se ky regjistrim është bërë.
4. Pa kryerjen e veprimeve nga paragrafi paraprak, fletëpengu nuk mund të bartet më tej me
indosament.
5. Fletëpengu që nuk përmban shumën e kërkesës së kreditorit të pengut, detyron në dobi të kreditorit
të pengut tërë vlerën e sendit të shënuar në të.', 'f05ce76bc967af8b5b8aefc2c64c60984ed0cea6fac774e9e90a7d3c1b52c005', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":161,"pageEnd":161,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (760, '761', 'Protesta për shkak të mospagimit dhe shitjes se mallit', '1-3', 'Ligji 04/L-077
Neni 761 - Protesta për shkak të mospagimit dhe shitjes se mallit

1. Poseduesi i fletëpengut pa dëftesë, të cilit nuk i paguhet brenda afatit kërkesa e siguruar me
fletëpeng, ka për detyrë që nën kanosjen e humbjes së të drejtave të kërkojë pagimin nga bartësi, të
paraqes protestën sipas ligjit mbi kambialin.
2. Poseduesi i fletëpengut që e ka ngritur protestën mundet pas kalimit të tetë ditëve nga dita e arritjes
se kërkesës, të kërkojë shitjen e mallit të lënë peng dhe e njëjta e drejtë i takon edhe bartësit që i ka
paguar poseduesit të fletëpengut kërkesën e siguruar me fletëpeng.
3. Nga shuma e realizuar nga shitja ndahet shuma e nevojshme për mbulimin e shpenzimeve të shitjes,
të kërkesës së magazinierit nga kontrata për magazinimin dhe e kërkesave të tjera të tij të krijuara
lidhur me lënien e mallit, e pastaj paguhet kërkesa e siguruar e poseduesit të fletëpengut , kurse mbetja
i takon poseduesit të dëftesës.', '977a3edb34d2e47f18922c5c613f8315b6589e62fa5652f2e0c2cfe3b5d816de', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":162,"pageEnd":162,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (761, '762', 'Kërkesa e pagimit nga bartësi i fletëpengut', '1-3', 'Ligji 04/L-077
Neni 762 - Kërkesa e pagimit nga bartësi i fletëpengut

1. Poseduesi i fletëpengut mund të kërkojë pagimin nga bartësi vetëm në qoftë se nuk ka mundë të
realizojë pagimin e plotë nga shitja e mallit peng.
2. Kjo kërkesë duhet të paraqitet në afatin e caktuar në ligjin e veçantë për kambialin për kërkesën
kundër indosentëve dhe ky afat fillon të rrjedhë nga dita kur është bërë shitja e mallit.
3. Poseduesi i fletëpengut humb të drejtën për të kërkuar pagimin nga bartësi në qoftë se nuk do të
kërkojë shitjen e mallit jo me vonë se brenda një muaji nga data e protestës.', '6c3f00a9dc560c59ceebde99fbb14acc53f444f01715928a209727fd68a1a8dc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":162,"pageEnd":162,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (762, '763', 'Nocioni', '1-3', 'Ligji 04/L-077
Neni 763 - Nocioni

1. Me kontratën për urdhrin detyrohet urdhërmarrësi ndaj urdhërdhënësit që për llogari të tij të ndërmerr
punë juridike të caktuara.
2. Njëkohësisht autorizohet urdhërmarrësi për marrjen e këtyre punëve.
3. Urdhërmarrësi ka të drejtë në shpërblim për mundin e tij, përveç nëse diçka tjetër është kontraktuar
ose rrjedh nga natyra e marrëdhënieve të ndërsjellta.', '5eed06ce06161a03683aee9e88c95b9d50a052d13521afc3a9952ddce44cf69d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":162,"pageEnd":162,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (763, '764', 'Personat që kanë për detyrë të përgjigjen në ofertën e urdhërit', null, 'Ligji 04/L-077
Neni 764 - Personat që kanë për detyrë të përgjigjen në ofertën e urdhërit

Kush merret me kryerjen e punëve të huaja si profesion ose ofrohet publikisht për kryerjen e këtyre
punëve ka për detyrë, në qoftë se nuk do të pranojë dekretin e ofruar që ka të bëjë me këto punë, për
këtë shtyrje ta njoftojë palën tjetër, përndryshe përgjigjet për dëmin që do ta pësonte pala për shkak të
kësaj.', 'b24cdb17d1f6171cd02f814b9e25f92e0321253d319343f59cd3c1fd2a85be69', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":162,"pageEnd":162,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (764, '765', 'Zbatimi I urdhërit sikundër është deklaruar', '1-3', 'Ligji 04/L-077
Neni 765 - Zbatimi I urdhërit sikundër është deklaruar

1. Dekretmarrësi ka për detyrë ta kryejë dekretin sipas udhëzimeve të marra me kujdesin e
ndërmarrësit të mirë, përkatësisht shtëpiakut të mirë, duke mbetur në kufijtë e tij dhe të kujdeset
krejtësisht për interesat e dekretdhënësit dhe të udhëhiqet prej tyre.
2. Kur dekretmarrësi konsideron se kryerja e dekretit sipas udhëzimeve të marra do të ishte e
dëmshme për dekretdhënësin, ky ka për detyrë t’ia tërheqë vëmendjen e tij dhe të kërkojë udhëzime të
reja.
3. Në qoftë se dekretdhënësi nuk ka dhënë udhëzime të caktuara për punën që duhet ta kryejë,
dekretmarrësi ka për detyrë duke u udhëhequr nga interesat e dekretdhënësit, të veprojë si ekonomist i
mirë përkatësisht si shtëpiak i mirë, e në qoftë se dekreti është pa shpërblim, ashtu si do të vepronte në
rrethana të njëjta në çështjen e vet.', 'b787c8d99441570e4e26ad0e7a593a79ad313e98a39677e874c28dd6e997b656', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":163,"pageEnd":163,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (765, '766', 'Shmangia nga dekreti (urdhri) dhe udhëzimi', '1-2', 'Ligji 04/L-077
Neni 766 - Shmangia nga dekreti (urdhri) dhe udhëzimi

1. Nga dekreti dhe udhëzimet e marra dekretrmarrësi mund të shmanget vetëm me pëlqimin e
dekretdhënësit, e kur për shkak të kohës së shkurtër ose të ndonjë shkaku tjetër nuk ka mundësi të
kërkojë pëlqimin e dekretdhënësit, ai mund të shmanget nga dekreti dhe udhëzimet vetëm në qoftë se
sipas vlerësimit të të gjitha rrethanave ka mundësi të konsiderojë me bazë se këtë e kërkojnë interesat
e dekretdhënësit.
2. Në qoftë se dekretmarrësi tejkalon kufijtë e dekretit ose të largohet nga udhëzimet e marra, jashtë
rastit të parashikuar në paragrafin paraprak, nuk do të konsiderohet si dekretmarrës, por si
punëdrejtues pa urdhër, përveç nëse dekretdhënësi më vonë jep pëlqimin për atë që ka bërë ky.', '0fa4743f0cf6f86a16b0d0f04cf579b28c063f09047bdb21bb4b74ce2e57d1a2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":163,"pageEnd":163,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (766, '767', 'Zëvendësimi', '1-5', 'Ligji 04/L-077
Neni 767 - Zëvendësimi

1. Dekretmarrësi ka për detyrë ta kryejë dekretin personalisht.
2. Ai mund t’ia besojë kryerjen e dekretit tjetrit vetëm në qoftë se dekretdhënësi ia ka lejuar këtë, dhe
në qoftë se në këtë ka qenë i shtrënguar nga rrethanat.
3. Në këto raste ai përgjigjet vetëm për zgjedhjen e përfaqësuesit dhe për udhëzimet që ia ka dhënë.
4. Në raste e tjera ai përgjigjet vetëm për punën e zëvendësuesit, si dhe për shkatërrimin e rastësishëm
ose të dëmtimit të sendit që do të shkaktoheshin te zëvendësuesi.
5. Dekretdhënësi mundet në çdo rast të kërkojë drejtpërdrejt nga zëvendësuesi kryerjen e detyrimit nga
dekreti.', '4935dfd3d3cd66643640af53c484850381458c9a0fd24604093a4b8b71045792', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":163,"pageEnd":163,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (767, '768', 'Dhënia e llogarive', null, 'Ligji 04/L-077
Neni 768 - Dhënia e llogarive

Për punën e kryer dekretmarrësi ka për detyrë të japë llogari dhe t’ dorëzojë pa shtyrje dekretdhënësit
gjithçka ka marrë në bazë të kryerjes së punëve të besuara, pavarësisht nëse këto që ka marrë nga
dekretdhënësi i ka borxh këtij ose jo.', 'c8d9120a4c8bd7c7d2fa0a067b968a9351f3fceb5389d4b59b235e9f93ad7e25', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":163,"pageEnd":163,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (768, '769', 'Paraqitja e raportit', null, 'Ligji 04/L-077
Neni 769 - Paraqitja e raportit

Dekretmarrësi ka për detyrë që me kërkesën e dekretdhënësit, të paraqes raport për gjendjen e punëve
dhe të japë llogari edhe para kohës së caktuar.', '5299217ff711f70040563bd873f6a28a4712126644ae9ae91d6226c8b5dc598c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (769, '770', 'Përgjegjësia për përdorimin e të hollave të dekretdhënësit', null, 'Ligji 04/L-077
Neni 770 - Përgjegjësia për përdorimin e të hollave të dekretdhënësit

Në qoftë se dekretmarrësi është shërbyer për nevojat e veta me të hollat që i ka marrë për
dekretdhënësin, ka për detyrë të paguajë kamatën sipas përqindjes më të lartë të lejueshme të
kontraktuar, duke llogaritur nga dita e përdorimit, e për të hollat e tjera që janë borxh, që nuk i ka
dorëzuar në kohë, kamatëvonesën, duke llogaritur nga dita kur ka pasur për detyrë ta dorëzojë.', 'c490bdeddc2c9404a95356ec8aad6a8ec1f950d3dfe6a9ab0e7f151daf36e6a6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (770, '771', 'Përgjegjësia solidare e dekretmarrësve', null, 'Ligji 04/L-077
Neni 771 - Përgjegjësia solidare e dekretmarrësve

Në qoftë se kryerja e ndonjë pune u është besuar disave me dekret të njëjtë për ta kryer bashkërisht,
ata përgjigjen solidarisht për detyrimet nga ky dekret, në qoftë se nuk është kontraktuar diçka tjetër.', 'c260a5b006a8af80d6a163c74cec75b0fc8c9114841964ccd73caccaec84552e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (771, '772', 'Paradhënia në të holla', null, 'Ligji 04/L-077
Neni 772 - Paradhënia në të holla

Dekretdhënësi ka për detyrë që me kërkesën e dekretmarrësit t’i japë një shumë të caktuar të hollave
për shpenzime të parashikuara.', '24435e205cb9d10391c081c08f3f877d9a50f8e281e1a06b243e845aef7654a5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (772, '773', 'Shpërblimi i shpenzimeve dhe marrja e detyrimeve', '1-2', 'Ligji 04/L-077
Neni 773 - Shpërblimi i shpenzimeve dhe marrja e detyrimeve

1. Dekretdhënësi ka për detyrë t’i shpërblejë dekretmarrësit, edhe atëherë kur mundi i tij pa fajin e tij
nuk ka pasur sukses, të gjitha shpenzimet e nevojshme qe i ka bërë për kryerjen e dekretit, me kamatë
nga dita kur janë bërë.
2. Ai ka për detyrë të marrë përsipër detyrimet që dekretmarrësi i ka marrë mbi vete, duke i kryer në
emër të vet punët e besuara ose në ndonjë mënyrë tjetër ta lirojë prej tyre.', 'd62f70f839aafbca2f6a37a5b7673bc9e2b1d3570a07a879146708f217fcc442', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (773, '774', 'Shpërblimi i dëmit', null, 'Ligji 04/L-077
Neni 774 - Shpërblimi i dëmit

Dekretdhënësi ka për detyrë t’ia shpërblejë dekretmarrësit dëmin, të cilin ky e ka pësuar pa fajin e vet
në kryerjen e dekretit.', '62bf127e2dc3c0ea9ef8c61cbae40fa6719462e4c7726dd6a9da7a76b3baeddc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (774, '775', 'Lartësia e shpërblimit', null, 'Ligji 04/L-077
Neni 775 - Lartësia e shpërblimit

Në qoftë se nuk është kontraktuar ndryshe, dekretdhënësi ka borxh shpërblimin në lartësinë e
zakonshme, e në qoftë se mungojnë doket e tilla, atëherë shpërblimin e drejtë.', '8eb23710963be9a83fc385361bc0dd065c46d41fe6e0c44ab5721719cd0a1bd8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":164,"pageEnd":164,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (775, '776', 'Pagimi i shpërblimit', '1-3', 'Ligji 04/L-077
Neni 776 - Pagimi i shpërblimit

1. Në qoftë se nuk është kontraktuar ndryshe, dekretdhënësi ka për detyrë t’i paguajë dekretmarrësit
shpërblimin pas kryerjes së punës.
2. Në qoftë se dekretmarrësi pa fajin e vet e ka kryer urdhrin vetëm pjesërisht, atëherë ai ka të drejtë në
pjesën e shpërblimit proporcional.
3. Në rastin kur shpërblimi i parakontraktuar do të ishte në shpërpjesëtim të hapur me shërbimet e bëra
urdhërdhënësi mund të kërkojë zvogëlimin e tij.', 'c0ee6690fd8bee24f5e62a896005ffbd33d9852716ce9c1d1a6294fb77504384', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":165,"pageEnd":165,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (776, '777', 'E drejta e pengut', null, 'Ligji 04/L-077
Neni 777 - E drejta e pengut

Për sigurimin e shpërblimit dhe të shpenzimeve dekretmarrësi ka të drejta të pengut në sendet e
luajtshme të dekretdhënësit që i ka marrë në bazë të dekretit, si dhe në shumat në të holla që i ka
arkëtuar për llogari të dekretdhënësit.', '758e37257bf9b184ac30ce50542c8b3d1940713932fb927e4b6107c1364ce179', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":165,"pageEnd":165,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (777, '778', 'Përgjegjësia solidare e dekretdhënësve', null, 'Ligji 04/L-077
Neni 778 - Përgjegjësia solidare e dekretdhënësve

Në qoftë se disa prej tyre i kanë besuar dekretrmarrësit kryerjen e dekretit, ata i përgjigjen atij
solidarisht.', 'ef8c8460fe4fada1fa338d041c4d620624dd93c9b9218a7c1e43b8da28dd448a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":165,"pageEnd":165,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (778, '779', 'Heqja dorë e dekretdhënësit nga kontrata', '1-2', 'Ligji 04/L-077
Neni 779 - Heqja dorë e dekretdhënësit nga kontrata

1. Dekretdhënësi mund të heq dorë nga kontrata.
2. Në rastin e heqjes dorë nga kontrata në të cilin dekretdhënësit i takon shpërblimi për punën e tij,
dekretdhënësi ka për detyrë t’i paguajë dekretmarrësit pjesën përkatëse të shpërblimit dhe t’ia
shpërblejë dëmin që e ka pësuar me heqjen dorë nga kontrata, në qoftë se për heqje dorë nuk ka pasur
arsye të bazuara.', '95397f180ae656e19af1156443040af6590c389c3d65d27a580fb14b9baaea82', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":165,"pageEnd":165,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (779, '780', 'Denoncimi i kontratës nga dekretmarrësi', '1-3', 'Ligji 04/L-077
Neni 780 - Denoncimi i kontratës nga dekretmarrësi

1. Dekretmarrësi mund të denoncojë dekretin kur të dojë, por jo në kohë të papërshtatshme.
2. Ai ka për detyrë t’i shpërblejë dekretdhënësit dëmin qe ky e ka pësuar për shkak të denoncimit të
dekretit në kohë të papërshtatshme, përveç nëse për denoncim kanë ekzistuar shkaqe të bazuara.
3. Dekretdhënësi ka për detyrë të vazhdojë me kryerjen e punëve, të cilat nuk durojnë shtyrje edhe pas
denoncimit të kontratës derisa dekretdhënësi do të mund të merrte kujdesin për to.', 'b3c1bee5a73cf329667b47d00d828de3563d333e43dcc843885991e2cdc71d4c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":165,"pageEnd":165,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (780, '781', 'Vdekja, shuarja e personit juridik', '1-5', 'Ligji 04/L-077
Neni 781 - Vdekja, shuarja e personit juridik

1. Dekreti shuhet me vdekjen e dekretmarrësit.
2. Trashëgimtarët e dekretmarrësit kanë për detyrë që për vdekjen e tij ta njoftojnë dekretdhënësin dhe
të ndërmarrin çka është e nevojshme për mbrojtjen e interesave të tij, gjersa nuk është në gjendje vetë
të merrë kujdesin për to.
3. Dekreti shuhet me vdekjen e dekretdhënësit vetëm në qoftë se është kontraktuar kështu ose në qoftë
se dekretmarrësi ka marrë urdhër duke marrë parasysh marrëdhëniet e veta personale me
dekretdhënësin.
4. Në këtë rast dekretmarrësi ka për detyrë t’i zgjasë punët e besuara, në qoftë se do të shkaktohej
dëmi për trashëgimtarët gjersa këta janë në pamundësi që të kujdesen vetë për to.
5. Në qoftë se dekretdhënësi ose dekretmarrësi është ndonjë person juridik, dekreti shuhet kur ai
person pushon së ekzistuari.', '6772cbec00a315eb6528c2191e6ee00c06174af6979a53891c1342d915d2599b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":165,"pageEnd":166,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (781, '782', 'Falimentimi, heqja e aftësisë për të vepruar', null, 'Ligji 04/L-077
Neni 782 - Falimentimi, heqja e aftësisë për të vepruar

Dekreti shuhet kur dekretdhënësi ose dekretmarrësi falimenton ose kur i hiqet plotësisht ose pjesërisht
aftësia për të vepruar.', '024ad56b97c570b1ca9f114cb7d94a540b9007ca1b14b4ff2bf9da5d3e493260', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":166,"pageEnd":166,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (782, '783', 'Çasti i shuarjes së dekretit', '1-2', 'Ligji 04/L-077
Neni 783 - Çasti i shuarjes së dekretit

1. Kur dekretdhënësi ka hequr dorë nga kontrata si dhe kur ka vdekur ose ka falimentuar, ose i është
hequr plotësisht ose pjesërisht zotësia për të vepruar, dekreti shuhet në çastin kur dekretmarrësi ka
mësuar për ngjarjen për shkak të cilës dekreti shuhet.
2. Kur dekretmarrësit i lëshohet një prokurë me shkrim, ka për detyrë ta kthejë atë pas shuarjes së
dekretit.', '1cc735a18e4e561bfa84ceec89d05638ac0ef83e1d8e6ebe0a5ed43a1ca95d52', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":166,"pageEnd":166,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (783, '784', 'Përjashtimet', null, 'Ligji 04/L-077
Neni 784 - Përjashtimet

Kur dekreti është dhënë që dekretmarrësi të mund të arrijë përmbushjen e ndonjë kërkese të vet nga
dekretdhënësi, dekretdhënësi nuk mund të heqë dorë nga kontrata dhe dekreti nuk shuhet as me
vdekjen, as me falimentimin e dekretdhënësit ose dekretmarrësit, as kur njëri prej tyre është privuar
plotësisht ose pjesërisht nga aftësia për të vepruar.', '45529c822c409789cd3581526d97f07fc948ab80636e0d9db93c2af0c04fd3a0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":166,"pageEnd":166,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (784, '785', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 785 - Nocioni

1. Me kontratën për komisionin, komisionari detyrohet që për shpërblim (provizion) të kryejë në emër të
vet dhe për llogari të komitentit një ose më shumë punë që ia ka besuar komitenti.
2. Komisionari ka të drejtë në shpërblim edhe kur ky nuk është kontraktuar.', 'b28fc6a5de68895789a77135585cc60c4c49ae6190a3b9111d8d2091fa4f70d7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":166,"pageEnd":166,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (785, '786', 'Zbatimi i rregullave për kontratën për dekretin', null, 'Ligji 04/L-077
Neni 786 - Zbatimi i rregullave për kontratën për dekretin

Në kontratën për komision zbatohen përshtatshmërisht rregullat për dekretin, në qoftë se me rregullat
për komisionin nuk është caktuar ndryshe.', '2df57a5c6f4b237d9914d8fd67da1660733b180c8406fec9b556b1f50e441d99', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":167,"pageEnd":167,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (786, '787', 'Lidhja e punës nën kushte të ndryshme nga ato të dekretit', '1-4', 'Ligji 04/L-077
Neni 787 - Lidhja e punës nën kushte të ndryshme nga ato të dekretit

1. Në qoftë se komisionari ka kontraktuar ndonjë punë me kushte jo të favorshme nga ato që janë
caktuar në dekret dhe kur ai për këtë nuk ka qenë i autorizuar, ka për detyrë t’ia shpërblejë komitentit
diferencën si dhe dëmin e shkaktuar.
2. Në rastin nga paragrafi paraprak komitenti mund të refuzojë të pranojë punën e lidhur, me kusht që
për këtë ta njoftojë menjëherë komisionarin.
3. Komitenti humb këtë të drejtë, në qoftë se komisionari tregon gatishmërinë t’ia paguajë menjëherë
diferencën dhe të shpërblejë dëmin e shkaktuar.
4. Në qoftë se puna është kontraktuar nën kushte më të përshtatshme nga ata që janë caktuar në
dekret, e gjithë dobia e arritur në këtë mënyrë i takon komitentit.', '93ab2823dbcd422d25757830cf8b95f19e1f629305cc9aa798928623950ec306', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":167,"pageEnd":167,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (787, '788', 'Shitja e mallit personit që ka shumë borxh', '1-2', 'Ligji 04/L-077
Neni 788 - Shitja e mallit personit që ka shumë borxh

1. Komisionari ka për detyrë ta kryejë punën e marrë me kujdesin e ndërmarrësit të mirë.
2. Komisionari i përgjigjet komitentit për dëmin, në qoftë se e ka zgjedhur personin e pabesueshëm për
punën ose në qoftë se i ka shitur mallin personit, për borxhet e të cilit ai ka qenë në dijeni ose ka
mundur të jetë në dijeni.', 'd8cc59975b45bfe321acb6bff4a373d455a3ec5fff7433a6095e1fdd36622137', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":167,"pageEnd":167,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (788, '789', 'Kur vetë komisionari blen mallin e komitentit ose ia shet mallin e vet', '1-3', 'Ligji 04/L-077
Neni 789 - Kur vetë komisionari blen mallin e komitentit ose ia shet mallin e vet

1. Komisionari të cilit i është besuar shitja ose blerja e ndonjë malli që ka vlerë në bursë ose në treg
mundet, në qoftë se ia ka lejuar komitenti, të mbajë mallin për vete si blerës, respektivisht të lirojë si
shitës, sipas çmimit në kohën e zbatimit të punës së besuar.
2. Në këtë rast midis komisionarit dhe komitentit lindin marrëdhëniet nga kontrata e shitjes.
3. Në qoftë se çmimi i bursës respektivisht i tregut dhe çmimi të cilin e ka caktuar komitenti nuk
pajtohen, komisionari-shitësi, ka të drejtë në çmimin më të ultë nga sa janë këto dy çmime, ndërsa
komisionari blerësi ka për detyrë të paguajë çmimin më të lartë.', '7fa7d7eef071a0f738ea12124bbb06d4ccd26057a81e565d88e39402ff1aa3c0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":167,"pageEnd":167,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (789, '790', 'Ruajtja dhe sigurimi', '1-2', 'Ligji 04/L-077
Neni 790 - Ruajtja dhe sigurimi

1. Komisionari ka për detyrë ta ruajë mallin e besuar me kujdesin e ekonomistit të mirë.
2. Ai përgjigjet edhe për shkatërrimin ose dëmtimin e rastësishëm të mallit, në qoftë se ai nuk e ka
siguruar mallin edhe pse sipas dekretit ka qenë i detyruar.', '9bdb312e0d9a8ef0c85a5fda0574c2e2c9f192269cade1ecb0357e28076c873c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":167,"pageEnd":167,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (790, '791', 'Njoftimi për gjendjen e mallit të pranuar', '1-2', 'Ligji 04/L-077
Neni 791 - Njoftimi për gjendjen e mallit të pranuar

1. Me rastin e marrjes së mallit nga transportuesi që ia ka dërguar komitenti, komisionari ka për detyrë
të vërtetojë gjendjen e tij dhe pa shtyrje ta njoftojë komitentin për ditën e arritjes së mallit, si edhe për
dëmtimet e dukshme ose mungesën, përndryshe përgjigjet për dëmin e cili për shkak të këtij lëshimi do
të shkaktohej për komitentin.
2. Ai ka për detyrë të ndërmarrë të gjitha masat e nevojshme për ruajtjen e të drejtës së komitentit ndaj
personit përgjegjës.', 'db83317cbb54b608a2b573ba56306cfe24712a9abfcf0a3687e650180f78902b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":168,"pageEnd":168,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (791, '792', 'Njoftimi për ndryshimet në mall', null, 'Ligji 04/L-077
Neni 792 - Njoftimi për ndryshimet në mall

Komisionari ka për detyrë ta njoftojë komitentin për të gjitha ndryshimet në mall për shkak të të cilave
mund të humbë vlera e mallit, e në qoftë se nuk ka kohë për pritje të udhëzimeve të tij, ose në qoftë se
ai e ka zvarritur dhënien e udhëzimeve, në rast rreziku të dëmtimit të konsiderueshëm komisioneri ka
për detyrë ta shesë mallin në mënyrë sa më të volitshme.', '4f0954c5fbe04727e966f00bc37825065903c5991d5129a0fda72bbae6cc1d3f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":168,"pageEnd":168,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (792, '793', 'Njoftimi i komitentit për emrat e palës kontraktuese', '1-2', 'Ligji 04/L-077
Neni 793 - Njoftimi i komitentit për emrat e palës kontraktuese

1. Komisionari ka për detyrë t’i komunikojë komitentit me cilin person ka kryer punën që ia ka besuar
komitenti.
2. Kjo rregull nuk vlen në rastin e shitjes se sendeve të luajtshme që bëhet nëpër shitore të komisionit,
përveç nëse është kontraktuar ndryshe.', '69c8af4c6c52a25119ef1c1a747da9e55397f8ad25c639920c45aaecce3cd9c4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":168,"pageEnd":168,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (793, '794', 'Dhënia e llogarisë', '1-3', 'Ligji 04/L-077
Neni 794 - Dhënia e llogarisë

1. Komisionari ka për detyrë të japë llogarinë për punën e kryer pa shtyrje të panevojshme.
2. Ai ka për detyrë t’ia dorëzojë komitentit në tërësi atë çka ka pranuar në bazë të punës së kryer për
llogari të tij.
3. Komisionari ka për detyrë t’ia kalojë komitentit kërkesat dhe të drejtat e tjera që ka fituar ndaj
personit të tretë me të cilin ka kryer punë në emër të vet dhe për llogari të tij.', '702e483a7317276754813e85c43c76a1ce1c891e950d1a6a59d2eba8759800cb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":168,"pageEnd":168,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (794, '795', 'Del credere', '1-2', 'Ligji 04/L-077
Neni 795 - Del credere

1. Komisioneri përgjigjet për përmbushjen e detyrimeve të palës kontraktuese të vet, vetëm në qoftë se
ka garantuar posaçërisht se ai detyrimet e veta do t’i përmbushë (delkredere), në të cilin rast ai
përgjigjet solidarisht me te.
2. Komisionari që ka garantuar për përmbushjen e detyrimeve të bashkëkontraktuesit të vet ka të drejtë
edhe në shpërblim të veçantë (provizioni delkredere).', '0024ee13d48a8d28a83d4241c0f49daaee9c3bb9a866e17d0ebcbcd09077a214', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":168,"pageEnd":168,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (795, '796', 'Shpërblimi (provizioni)', '1-4', 'Ligji 04/L-077
Neni 796 - Shpërblimi (provizioni)

1. Komitenti ka për detyrë t’i paguajë komisionarit një shpërblim, nëse është kryer puna, të cilën
komisionari ka pasur ta kryejë, si dhe në qoftë se kryerja e punës pengohet nga ndonjë shkak për të
cilin përgjigjet komitenti.
2. Në rastin e kryerjes graduale, komisionari mund të kërkojë pjesën proporcionale të shpërblimit pas
secilës përmbushje të pjesshme.
3. Në qoftë se nuk kryhet puna e kontraktuar nga shkaku për të cilin nuk përgjigjen as komisionari as
komitenti, komisionari ka të drejtë në shpërblimin përkatës për mundin e vet.
4. Komisionari që ka vepruar me mosbesnikëri ndaj komitentit nuk ka të drejtë në shpërblim.', 'ef25dacf37d4bcb1963dede664b089ae02fd2a0c1123e7a7f7c82b6dea17f4d6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":169,"pageEnd":169,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (796, '797', 'Lartësia e shpërblimit', '1-2', 'Ligji 04/L-077
Neni 797 - Lartësia e shpërblimit

1. Në qoftë se shuma e shpërblimit nuk është caktuar me kontratë ose me tarifë, komisionarit i takon
shpërblimi sipas punës së kryer dhe rezultatit të arritur.
2. Në qoftë se në rastin e dhënë shpërblimi është përpjesëtimisht i madh në krahasim me punën e kryer
dhe rezultatin e arritur, gjykata mundet me kërkesë të komitentit ta zbresë në një shumë të drejtë.', 'de4f7eba6cc2576973a60d208c189ec2811de5f95e530d0cf4c2d22112a0ef7f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":169,"pageEnd":169,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (797, '798', 'Shpërblimi i shpenzimeve', '1-2', 'Ligji 04/L-077
Neni 798 - Shpërblimi i shpenzimeve

1. Komitenti ka për detyrë t’i shpërblejë komisionarit shpenzimet që kanë qenë të nevojshme për
kryerjen e dekretit, me kamatë nga dita kur janë bërë.
2. Komitenti ka për detyrë t’i japë komisionarit shpërblim të posaçëm për përdorimin e depove dhe
mjeteve të transportit të tij, në qoftë se ky nuk është përfshirë në shpërblimin për kryerjen e punës.', '9843c60829025469eaadcd0e2a0fe5d6725425822989615955ca4b5cede9f873', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":169,"pageEnd":169,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (798, '799', 'Paradhënia e të hollave komitentit', null, 'Ligji 04/L-077
Neni 799 - Paradhënia e të hollave komitentit

Në qoftë se me kontratën për komisionin nuk është caktuar diçka tjetër, komitenti nuk ka për detyrë t’i
japë paradhënie komisionarit në mjete të nevojshme për kryerjen e punës së besuar.', '43eff11dde186839b4c7d05f52869f1683bc21ff67431ec6e31c79e4a8825cf0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":169,"pageEnd":169,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (799, '800', 'Të drejtat e komisionarit për pengun', '1-3', 'Ligji 04/L-077
Neni 800 - Të drejtat e komisionarit për pengun

1. Komisionari ka të drejtë pengu në sendet që janë objekt i kontratës për komisionin gjersa këto sende
gjenden te ai ose te ndonjë që i mban për te ose gjersa ai ka në dorë dokumentin me anë të të cilit
mund të disponojë me to.
2. Nga vlera e këtyre sendeve komisionari mund të arkëtojë përpara të gjithë kreditorëve të komitentit
kërkesat e veta në bazë të të gjitha punëve të komisionit me komitentin, si dhe në bazë të huave e të
paradhënieve që i janë dhënë komitentit, pa marrë parasysh nëse janë krijuar ose jo në lidhje me këto
sende ose me ndonjë mënyrë tjetër.
3. Të drejtën e përparësisë së arkëtimit e ka komisionari nga kërkesat, të cilat i ka fituar me kryerjen e
dekretit për llogari të komitentit.', '895fa4178eff4603a22b9b4f4123837bc87a539ee40bf306b77729dc9a6f5395', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":169,"pageEnd":170,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (800, '801', 'Të drejtat e komitentit në kërkesat nga puna me të tretin', '1-2', 'Ligji 04/L-077
Neni 801 - Të drejtat e komitentit në kërkesat nga puna me të tretin

1. Komitenti mund të kërkojë përmbushjen e kërkesës nga puna të cilën e ka lidhur komisionari me të
tretin dhe për llogari të tij vetëm nëse ai (komisionari) ia ka bartë (ceduar) atij kërkesat.
2. Në pikëpamje të marrëdhënieve të komitentit me komisionarin dhe me kreditorët e tij konsiderohen
këto kërkesa si kërkesa të komitentit.', '687ad8b5fe962c73abe34bcdc688666fa1bc8096225be19547242d6f58199ce0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":170,"pageEnd":170,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (801, '802', 'Kufizimi i të drejtës së kreditorëve të komisionarit', null, 'Ligji 04/L-077
Neni 802 - Kufizimi i të drejtës së kreditorëve të komisionarit

Kreditorët e komisionarit nuk mund për arkëtimin e kërkesave të veta, as në rastin e falimentimit të tij të
ndërmarrin masa përmbarimi në të drejtat dhe sendet të cilat komisionari, duke kryer urdhrin i ka fituar
në emër të vet dhe për llogari të komitentit, përveç nëse është fjala për kërkesat e krijuara në lidhje me
fitimin e këtyre të drejtave dhe të sendeve.', '81360ad49507be06e587d1c3ad01cfaec3a713744f25e81c4766759060fb6186', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":170,"pageEnd":170,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (802, '803', 'Falimentimi i komisionarit', '1-2', 'Ligji 04/L-077
Neni 803 - Falimentimi i komisionarit

1. Në rastin e falimentimit të komisionarit, komitenti mund të kërkojë veçimin nga masa e falimentimit të
sendeve që ia ka dorëzuar komisionarit për shitje për llogari të tij, si dhe të sendeve që i ka blerë
komisionari për llogari të tij.
2. Në të njëjtin rast komitenti mund të kërkojë nga i treti, të cilit komisionari ia ka dorëzuar sendet që t’ia
paguajë çmimin e tyre, përkatësisht pjesën e papaguar ende.', '765a58cad01b4590275027249ac50f04c35ccd72065d2ef40e2413373bb641f5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":170,"pageEnd":170,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (803, '804', 'Nocioni', '1-5', 'Ligji 04/L-077
Neni 804 - Nocioni

1. Me kontratën mbi përfaqësimin tregtar, përfaqësuesi obligohet të kujdeset vazhdimisht që persona të
tretë të lidhin kontrata me urdhërdhënësin e tij dhe që për këtë të ndërmjetësojë midis tyre dhe
urdhërdhënësit, si dhe që pas marrjes së autorizimit të lidhë kontrata me persona të tretë në emër dhe
për llogari të urdhërdhënësit, ndërsa ky obligohet që për çdo kontratë të lidhur t''i paguajë shpërblim të
caktuar (provizion).
2. Përfaqësuesi, sipas paragrafit të parë të këtij neni, mund të jetë entitet ligjor apo person fizik i cili në
mënyrë të pavarur dhe me qëllim të realizimit të fitimit kryen aktivitete të përfaqësimit si një aktivitet i
regjistruar.
3. Përfaqësuesi tregtarë mundet po ashtu të lidhë kontratë mbi agjencinë tregtare si një urdhërdhënës.
4. Urdhërdhënësi mund të këtë në të njëjtën zonë dhe për të njëjtin lloj pune disa agjenta, përveç nëse
parashihet ndryshe me kontratë.
5. Përfaqësuesi pa pëlqimin e urdhërdhënësit nuk mundet të marrë përsipër obligimin që në të njëjtën
zonë dhe për të njëjtin lloj pune ose për të njëjtin rreth klientësh të punojë për një urdhërdhënës tjetër.', 'fca4881543c306f69fb9e446736f0cf40a53ab5fb788b113cbe5c5de500ad0a1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":170,"pageEnd":171,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (804, '805', 'Forma', '1-2', 'Ligji 04/L-077
Neni 805 - Forma

1. Secila palë mund të kërkojë që të hartohet një dokument mbi përmbajtjen e kontratës, duke përfshirë
të gjitha ndryshimet më të fundit, dhe që të nënshkruhet nga pala tjetër. Palët nuk mund të heqin dorë
nga kjo e drejtë.
2. Përkundër paragrafit të parë të këtij neni, palët mund të merren vesh që forma e shkruar të jetë kusht
për vlefshmërinë e kontratës dhe ndryshimeve në të.', '73a5ba00022ec77afcb0f8f4fad60ebda5af263e2eabb64d99fe066703c6e1ef', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":171,"pageEnd":171,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (805, '806', 'Lidhja e kontratës në emër të urdhërdhënësit', null, 'Ligji 04/L-077
Neni 806 - Lidhja e kontratës në emër të urdhërdhënësit

Përfaqësuesi mund të lidhë kontrata në emër dhe për llogari të urdhërdhënësit të vet, në qoftë se për
këtë ka marrë autorizim të veçantë, apo të përgjithshëm.', '67016d6fcd2f6bbc450cb1da9cfb2a2de072de34b9bd1cebcbf21c20fe7bc88b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":171,"pageEnd":171,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (806, '807', 'Pranimi i përmbushjes', null, 'Ligji 04/L-077
Neni 807 - Pranimi i përmbushjes

Përfaqësuesi nuk mund të kërkojë dhe as të pranojë përmbushjen e kërkesave të urdhërdhënësit të
vet, në qoftë se për këtë nuk është i autorizuar posaçërisht.', '9349e14514fe3d6f315283ec2baba8d5be07242cc2255c2ecdfc5d66a483b315', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":171,"pageEnd":171,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (807, '808', 'Deklaratat e dhëna përfaqësuesit tregtar për urdhërdhënësin', null, 'Ligji 04/L-077
Neni 808 - Deklaratat e dhëna përfaqësuesit tregtar për urdhërdhënësin

Kur kontrata është lidhur me ndërmjetësimin e përfaqësuesit tregtar atëherë bashkëkontraktuesi i
urdhërdhënësit mundet t''i bëjë në mënyrë të plotfuqishme përfaqësuesit tregtar deklarata qe i përkasin
të metave të objekteve të kontratës, si dhe deklaratat të tjera lidhur me këtë kontratë, me qëllim të
ruajtjes ose të ushtrimit të të drejtave nga kontrata.', '79a7878e88d2b990b9049cd422f3a50e4ac443b372ce7ed4c4e2357b1714483e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":171,"pageEnd":171,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (808, '809', 'Deklaratat në emër të urdhërdhënësit', null, 'Ligji 04/L-077
Neni 809 - Deklaratat në emër të urdhërdhënësit

Përfaqësuesit tregtar është i autorizuar që me qëllim të mbrojtjes së të drejtave të urdhërdhënësit të vet
t''i bëjë deklaratë të nevojshme bashkëkontraktuesit të tij.', 'edfc6778b30be6486f8124a07376d2d200f211c1bfe5eb7b4ed724fb7df820e7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":171,"pageEnd":171,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (809, '810', 'Masat e sigurimit', null, 'Ligji 04/L-077
Neni 810 - Masat e sigurimit

Me qëllim të mbrojtjes së interesave të urdhërdhënësit, përfaqësuesit tregtar mund të kërkojë marrjen e
masave të nevojshme të sigurimit.', '362029b235b6b0e3862e04de49a35f6af90ed63270c96c450de73c0556a03d3d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":171,"pageEnd":171,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (810, '811', 'Kujdesi për interesat e urdhërdhënësit', '1-3', 'Ligji 04/L-077
Neni 811 - Kujdesi për interesat e urdhërdhënësit

1. Përfaqësuesit tregtar ka për detyrë të kujdeset për interesat e urdhërdhënësit dhe në të gjitha punët
që ndërmerr ka për detyrë të veprojë me kujdesin e ekonomistit të mirë.
2. Në këtë rast ka për detyrë të respektojë udhëzimet që ia ka dhënë urdhërdhënësi.
3. Ai ka për detyrë t''i jep urdhërdhënësit të gjithë njoftimet e nevojshme mbi situatën e tregut, sidomos
ato që kanë rëndësi për çdo punë të veçantë.', 'a6e1f715dd69a6c9b90fbf947fe20c2590d494cfe1f5040f2bb0f3e7a7528cb9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":172,"pageEnd":172,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (811, '812', 'Informatat dhe raportimi', '1-3', 'Ligji 04/L-077
Neni 812 - Informatat dhe raportimi

1. Përfaqësuesit tregtar duhet ti ofrojë urdhërdhënësit të gjitha informatat e nevojshme mbi situatën e
tregut, veçanërisht për informata për secilën punë juridike të kryer.
2. Përfaqësuesit tregtar është i detyruar që ti raportojë mbi punën e tij rregullisht urdhërdhënësit,
veçanërisht mbi personat e tretë që kanë dëshirë të negociojnë me urdhërdhënësin apo që të lidhin
kontratë me të si dhe për kontratat e lidhura në emër të urdhërdhënësit.
3. Çdo marrëveshje që është në kundërshtim me paragrafin e parë dhe të dytë të këtij neni është e
pavlefshme.', '891b5c197db8ab31232156fb0d3103f246f82d0817347e9da73026e8b0d1ed88', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":172,"pageEnd":172,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (812, '813', 'Pjesëmarrja në kontraktimin e punëve', null, 'Ligji 04/L-077
Neni 813 - Pjesëmarrja në kontraktimin e punëve

Përfaqësuesit tregtar ka për detyrë të marrë pjesë sipas udhëzimeve të urdhërdhënësit në kontraktimin
e punëve deri në përfundimin e tyre të plotë.', 'bab64a471c8dbacf498703484234ff392712a15c74dc5b3fd1ba3af975cd063c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":172,"pageEnd":172,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (813, '814', 'Ruajtja e sekreteve të punës', '1-2', 'Ligji 04/L-077
Neni 814 - Ruajtja e sekreteve të punës

1. Përfaqësuesit tregtar ka për detyrë t''i ruajë sekretet e punës të urdhërdhënësit të tij për të cilat ka
mësuar lidhur me punën që i është besuar.
2. Ai përgjigjet po që se i shfrytëzon ose ia zbulon tjetrit edhe pas pushimit të kontratës mbi agjencinë
tregtare.', 'a5bfb358cf358aa26466d80d1fffd2c71ada20f0ce7062209c0fdabb4c14dc7a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":172,"pageEnd":172,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (814, '815', 'Kthimi i sendeve të dhëna në përdorim', null, 'Ligji 04/L-077
Neni 815 - Kthimi i sendeve të dhëna në përdorim

Pas pushimit të kontratës mbi përfaqësimin tregtare, përfaqësuesit tregtar ka për detyrë t''i kthejë
urdhërdhënësit të gjitha sendet që ia ka dorëzuar ky për përdorim gjatë afatit të kontratës.', '7dd6cb742d0d4b0789098938c08b19f92217d9874ef453e07cb5d49ade66b5b1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":172,"pageEnd":172,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (815, '816', 'Rasti i veçantë i përgjegjësisë', '1-3', 'Ligji 04/L-077
Neni 816 - Rasti i veçantë i përgjegjësisë

1. Përfaqësuesi tregtar i përgjigjët urdhërdhënësit për përmbushjen e detyrimeve nga kontrata për
kontraktimin e së cilës përfaqësuesit tregtar ka ndërmjetësuar, ose të cilën në bazë të autorizimit ai e
ka kontraktuar në emër të urdhërdhënësit, vetëm në qoftë se për këtë ka garantuar posaçërisht me
shkrim.
2. Sigurimi i përmbushjes në kuptim të paragrafit të parë të këtij neni do të jetë i mundshëm vetëm për
punët e veçanta juridike ose punët juridike me person të veçantë.
3. Përfaqësuesit tregtar i cili i ka ofruar sigurim urdhërdhënësit për përmbushjen e detyrimeve që
rrjedhin nga kontrata e ndërmjetësuar nga përfaqësuesit tregtar, ka të drejtë edhe në shpërblim të
posaçëm (provizion del credere).', '57e4baf48906a5b45afbc5645a2331b1951b3068300e3d1dc5f114311ac0b071', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":172,"pageEnd":173,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (816, '817', 'Rregulla e përgjithshme', '1-3', 'Ligji 04/L-077
Neni 817 - Rregulla e përgjithshme

1. Urdhërdhënësi, në marrëdhënien me përfaqësuesit tregtar, duhet të veprojë me sinqeritet dhe me
mirëbesim. Urdhërdhënësi duhet të njoftojë përfaqësuesin tregtar nëse urdhërdhënësi nuk do të kryej
ndonjë punë juridike me palën e tretë apo nëse pala e tretë nuk ka kryer ndonjë punë juridike.
2. Urdhërdhënësi duhet ti ofrojë përfaqësuesit tregtar në me shërbimet e tij të gjithë dokumentacionin e
nevojshëm, shembujt, planet, listat e çmimeve, materialet reklamuese, rregullat dhe kushtet e
përgjithshme të biznesit, etj. Shpenzimet e përkthimit dhe shtypjes së materialit reklamues në gjuhën
zyrtare në Kosovë mbulohen nga përfaqësuesit tregtar.
3. Urdhërdhënësi duhet ti ofrojë përfaqësuesit tregtar të gjitha informacionet e nevojshme për
ekzekutimin e kontratës mbi agjencinë tregtare.', 'c5e0dffa8cedb5e9d8f59066b39285c3be002b1bd3e3c732f657facc6476a98d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":173,"pageEnd":173,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (817, '818', 'Detyra e njoftimit', '1-2', 'Ligji 04/L-077
Neni 818 - Detyra e njoftimit

1. Urdhërdhënësi mundet sipas dëshirës së vet të pranojë ose të refuzojë lidhjen e kontratës së
përgatitur nga ana e përfaqësuesit tregtar , por ka për detyrë të njoftojë pa vonesë përfaqësuesit tregtar
mbi vendimin e vet. Urdhërdhënësi duhet të njoftojë përfaqësuesin për në lidhje me kryerjen apo
moskryerjen e punëve të kontraktuara me personat e tretë.
2. Urdhërdhënësi ka për detyrë të njoftojë përfaqësuesit tregtar pa vonesë mbi nevojën që volumi i
punëve të kontraktuara me ndërmjetësimin e tij të reduktohet në një masë më të vogël nga sa
përfaqësuesit tregtar ka mundur të presë në mënyrë të arsyeshme kështu që ky të zvogëlojë në kohën
e duhur sipërmarrjen e vet në një masë përkatëse, përndryshe urdhërdhënësi do të përgjigjet për dëmin
e pësuar.', '65b6b308ff1a5d7b19a0cb5cb5a68612706bddc7e44614385fe91ad62953a07e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":173,"pageEnd":173,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (818, '819', 'Natyra e detyrueshme e dispozitave', null, 'Ligji 04/L-077
Neni 819 - Natyra e detyrueshme e dispozitave

Çdo marrëveshje mes palëve që është në kundërshtim me nenet e mësipërme është e pavlefshme.', '1c8f837e9ea24cc79229d7b92ff60126b2deab6779c466ed87ebd5406c9a6d50', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":173,"pageEnd":173,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (819, '820', 'Shpërblimi (provizioni)', '1-5', 'Ligji 04/L-077
Neni 820 - Shpërblimi (provizioni)

1. Urdhërdhënësi ka për detyrë t''i paguajë përfaqësuesit tregtar shpërblimin për kontratat e lidhura me
ndërmjetësimin e tij, si dhe për kontratat të cilat vetë agjenti i ka lidhur, në qoftë se për këtë ka qenë i
autorizuar.
2. Përfaqësuesit tregtar ka të drejtë në shpërblimin edhe për kontratat të cilat urdhërdhënësi i ka lidhur
drejtpërdrejtë me klientët që i ka gjetur përfaqësuesit tregtar.
3. Përfaqësuesit tregtar i cili sipas kontratës punon vetëm në një fushë të caktuar apo vetëm me palë të
caktuara, ka të drejtë në shpërblimin për këto lloj kontratash të lidhura për urdhërdhënësin me palë nga
kjo fushë apo me palët e veçanta edhe nëse janë bërë pa ndërmjetësimin e përfaqësuesit tregtar.
4. Përfaqësuesit tregtar i ka të drejtë vetëm në provizion për kontratën e lidhur pas përfundimit të
marrëdhënies ndërmjet përfaqësuesit tregtar dhe urdhërdhënësit, nëse kontrata e tillë është si rezultat i
përpjekjeve të përfaqësuesit tregtar gjatë marrëdhënies me urdhërdhënësin dhe është lidhur pas një
kohë të arsyeshme nga përfundimi i kësaj marrëdhënie ose nëse oferta e personit të tretë për lidhjen e
kontratës ka ardhur tek përfaqësuesit tregtar apo urdhërdhënësi para përfundimit të marrëdhënies së
tyre dhe ka të bëjë me ndonjërën prej kontratave sipas paragrafit të parë dhe të dytë të këtij neni.
5. Paragrafi 2. dhe 3. i këtij neni nuk do të zbatohen nëse e drejta në provizion është shfrytëzuar nga
përfaqësuesit tregtar i mëparshëm sipas paragrafit 4. të këtij neni, përveç nëse sipas rrethanave do të
ishte e drejtë që provizioni të ndahej ndërmjet përfaqësuesve tregtar.', 'af227ad4c980d2c4129d93a2e021baafffe19b16859df4fb9b3e69823855eb4e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":173,"pageEnd":174,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (820, '821', 'Shuma e shpërblimit', '1-3', 'Ligji 04/L-077
Neni 821 - Shuma e shpërblimit

1. Në qoftë se shuma e shpërblimit nuk është caktuar me kontratë, ose me tarifë, përfaqësuesit tregtar
ka të drejtë në shpërblimin e zakonshëm në fushën në të cilën përfaqësuesit tregtar ka kryer aktivitetin
për urdhërdhënësin, duke marrë parasysh natyrën punëve të agjencisë. Përfaqësuesit tregtar i cili ka
ofruar shërbime për urdhërdhënësin në disa fusha ka të drejtë në provizionin e zakonshëm për këtë
fushë në vendin ku ndodhet zyra kryesore.
2. Nëse nuk është e mundur të përcaktohet provizioni sipas nenit paraprak, përfaqësuesit tregtar ka të
drejtë provizioni në një shumë që i merr parasysh të gjitha rrethanat e punës së kryer, veçanërisht
numrin dhe vlerën e punëve juridike të kryera ndërmjet urdhërdhënësit dhe personit të tretë si dhe
natyrën dhe vështirësinë e përpjekjeve të përfaqësuesit tregtar.
3. Në qoftë se në rastin konkret shpërblimi është përpjesëtimisht i madh në krahasim me shërbimin e
bërë, gjykata mundet me kërkesën e urdhërdhënësit të zvogëlojë atë në një shumë të drejtë.', 'ef46c52cdee20441be04a9d52df062bb183dbc4178584d0ed56fce3ec5e3d439', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":174,"pageEnd":174,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (821, '822', 'Fitimi i të drejtës së pagesës', '1-5', 'Ligji 04/L-077
Neni 822 - Fitimi i të drejtës së pagesës

1. Përfaqësuesit tregtar fiton të drejtën në provizion nëse, dhe deri atëherë kur, urdhërdhënësi
përmbushë apo do duhej të kishte përmbushur kontratën me personin e tretë ose nëse personi i tillë
përmbushë pjesën e detyrimit të tij që rrjedh nga kontrata me urdhërdhënësin.
2. Përfaqësuesit tregtar nuk ka të drejtë në provizion në rastet kur është e qartë që kontrata nuk do të
përmbushet dhe se arsyeja për mos përmbushjen e saj nuk është në anën e urdhërdhënësit. Nëse në
rastin e tillë provizioni është paguar, atëherë përfaqësuesit tregtar duhet ta kthej atë.
3. Përfaqësuesit tregtar e fiton të drejtën në provizion më së voni në momentin kur personi i tretë
përmbushë apo do duhej të kishte përmbushur detyrimet sipas kontratës, nëse urdhërdhënësi ka
përmbushur pjesën e urdhërdhënësit.
4. Nëse kontrata ndërmjet urdhërdhënësit dhe personit të tretë është duke u ekzekutuar për një kohë të
gjatë, atëherë përfaqësuesit tregtare ka të drejtë në një pjesë pagese paraprake të provizionit.
5. Nuk është e mundur që me anë të kontratës të drejtat e përcaktuara në këtë nen të ndryshohen në
dëm të përfaqësuesit tregtar.', '13692b7793f124a8eb2d5acf46147a92cfd66ab2a472aa859a8944757ed39c45', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":174,"pageEnd":174,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (822, '823', 'Pagimi i provizionit', '1-5', 'Ligji 04/L-077
Neni 823 - Pagimi i provizionit

1. Urdhërdhënësi çdo tre muaj duhet të përgatis një faturë të provizionit që i takon përfaqësuesit tregtar
për secilin muaj ndaras, dhe ta dërgojë. Fatura duhet të përmbajë të gjitha pjesët përbërëse në bazë të
të cilave është përgatitur.
2. Urdhërdhënësi është i detyruar të paguaj provizionin për të gjithë periudhën në fund të muajit pas
muajit të fundit të periudhës së faturuar. Me anë të kontratës mund të përcaktohet periudha e faturimit
më e shkurtër se tre muaj.
3. Me kërkesën e përfaqësuesit tregtar, urdhërdhënësi detyrohet që nga librat e llogarisë ti dorëzojë
agjentit ekstraktet mbi të gjitha punët për të cilat përfaqësuesit tregtar ka të drejtë provizioni si dhe të
njoftojë përfaqësuesit tregtar në lidhje me të gjitha rrethanat që kanë ndikuar në provizion.
4. Nëse urdhërdhënësi refuzon kërkesën e përfaqësuesit tregtar ose nëse përfaqësuesit tregtar ka
dyshime mbi saktësinë e ekstrakteve, atëherë përfaqësuesit tregtar mund të kërkojë që një auditor i
certifikuar të inspektojë librat e llogarive dhe dokumentet në lidhje me shifrat e rëndësishme për
provizion dhe të raportojë mbi to.
5. Të drejtat e përfaqësuesit tregtar të përcaktuara me këtë nen nuk mund të kufizohen apo hiqen me
kontratë.', '7915add6d23c1692fa94e0d7b3e4925ce09d4c39f21c506397927c33bd651b61', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":175,"pageEnd":175,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (823, '824', 'Shpërblim i veçantë', null, 'Ligji 04/L-077
Neni 824 - Shpërblim i veçantë

Përfaqësuesit tregtar i cili me autorizimin e urdhërdhënësit ka bërë arkëtimin e ndonjë kërkese të tij, ka
të drejtë në provizion të veçantë nga shuma e arkëtuar.', '7544e159d006c11b14b075f1e85dd9721429330f0894a1976f96a0f04570ef41', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":175,"pageEnd":175,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (824, '825', 'Shpenzimet', '1-2', 'Ligji 04/L-077
Neni 825 - Shpenzimet

1. Përfaqësuesit tregtar nuk ka të drejtë në kompensimin e shpenzimeve që rezultojnë nga ushtrimi i
zakonshëm të punëve të ndërmjetësimit, përveç nëse është kontraktuar ndryshe.
2. Mirëpo, ky ka të drejtë në kompensimin e shpenzimeve të veçanta që ka bërë në dobi të
urdhërdhënësit, ose me urdhër të tij.', 'd2e201f0e5eb01c3b953e0fffaccc166f92ac143713b6cfec8766952244d862f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":175,"pageEnd":175,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (825, '826', 'E drejta e pengut e përfaqësuesit tregtar', null, 'Ligji 04/L-077
Neni 826 - E drejta e pengut e përfaqësuesit tregtar

Për sigurimin e arkëtimit të kërkesave të veta të rrjedha për pagesë të krijuara lidhur me kontratën,
përfaqësuesit tregtar ka të drejtë pengu në shumat që ka arkëtuar për urdhërdhënësin, sipas autorizimit
të tij, si dhe në të gjitha sendet e urdhërdhënësit të cilat lidhur me kontratën i ka marrë nga
urdhërdhënësi ose nga ndonjë tjetër, gjersa këto ndodhen tek ai, ose tek ndonjë tjetër që i mban për të,
apo gjersa ka në dorë dokumentin me anë të të cilit mund t''i disponojë ato.', '28ba954cad56bbb29b14686d88a3d43ab7495b492457784e45e1c2a695f8b157', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":175,"pageEnd":175,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (826, '827', 'Zgjidhja e kontratës së lidhur për një kohë të pacaktuar', '1-6', 'Ligji 04/L-077
Neni 827 - Zgjidhja e kontratës së lidhur për një kohë të pacaktuar

1. Kontrata konsiderohet se është lidhur për një periudhë të pacaktuar, përveç nëse palët merren vesh
ndryshe.
2. Nëse kontrata është lidhur për një periudhë të pacaktuar, atëherë secila palë mund ta shkëpus
kontratën duke dhënë njoftim për shkëputje në përputhje me këtë nen.
3. Koha e dhënies së njoftimit për shkëputje varet nga kohëzgjatja e kontratës dhe duhet të llogaritet
nga një muaj për secilin fillim viti gjatë kontratës. Nëse kontrata zgjatë më shumë se pesë (5) vite, koha
e dhënies së njoftimit për shkëputje është gjashtë (6) muaj.
4. Palët nuk mund të përcaktojnë me kontratë kohë njoftimi më të shkurtra.
5. Nëse palët pajtohen për kohë lajmërimi më të gjata, koha e tillë duhet të zbatohet në mënyrë të
barabartë si për urdhërdhënësin edhe për përfaqësuesit tregtar.
6. Përveç kur përcaktohet ndryshe me kontratë, koha e lajmërimit fillon ditën e parë të muajit pasues
kalendarik dhe mbaron ditën e fundit të muajit të tillë.', '05a0e4e54e10991c8f15949704e045295f2d9d0753b91d2725f6bf1234877a42', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":176,"pageEnd":176,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (827, '828', 'Zgjidhja e kontratës së lidhur për një kohë të caktuar', '1-2', 'Ligji 04/L-077
Neni 828 - Zgjidhja e kontratës së lidhur për një kohë të caktuar

1. Kur kontrata mbi agjencinë tregtare është lidhur për një kohë të caktuar, ajo pushon me skadimin e
kohës së caktuar.
2. Në qoftë se të dyja palët vazhdojnë të përmbushin kontratën sipas paragrafit të parë, edhe pas
kohës për të cilën është lidhur, atëherë konsiderohet si kontratë e lidhur për një kohë të pacaktuar. Në
përcaktimin e kohës për njoftim, merret parasysh koha e kaluar që nga momenti i lidhjes së kontratës,
ashtu siç zbatohet tek shkëputja e kontratës e lidhur për kohë të pacaktuar.', 'ef1b2688f9652e0211130fa253ee0f5ba90aaedcfb550766337e367b72811bce', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":176,"pageEnd":176,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (828, '829', 'Zgjidhja e kontratës pa afat denoncimi', '1-4', 'Ligji 04/L-077
Neni 829 - Zgjidhja e kontratës pa afat denoncimi

1. Për shkaqet serioze secila palë mundet duke treguar këto shkaqe të zgjidhë kontratën pa afat
denoncimi.
2. Në qoftë se deklarata mbi denoncimi është bërë pa shkaqe serioze do të konsiderohet si denoncim
me afat të rregullt denoncimi.
3. Përfaqësuesit tregtar i cili për shkak të denoncimit të pabazuar e ka ndërprerë veprimtarinë e vet ka
të drejtë në shpërblimin e dëmit për shkak të provizionit të humbur, e në qoftë se ai e ka denoncuar
kontratën në mënyrë të pabazuar e drejta e shpërblimit të dëmit i takon urdhërdhënësit.
4. Denoncimi i pabazuar i jep të drejta palës tjetër të zgjidhë kontratën pa afat denoncimi.', 'd57937158bdff8cdac8c11bbea3535b30763f58027f69557aef104d2e328916a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":176,"pageEnd":176,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (829, '830', 'Shuma e pjesëtuar', '1-6', 'Ligji 04/L-077
Neni 830 - Shuma e pjesëtuar

1. Pas denoncimit të kontratës, përfaqësuesit tregtar ka të drejtë në ndarjen e një shume të
përshtatshme parash nëse dhe për aq sa përfaqësuesit tregtar ka siguruar klientë të rinjë për
urdhërdhënësin ose në mënyrë të dukshme ka rritur numrin e punëve me klientët e mëparshëm dhe
pasi kontrata të jetë denoncuar urdhërdhënësi gëzon përfitime të dukshme me klientët e tillë, ose nëse
pjesëtimi i shumës dhe pagesa e sajë kërkohet prej rrethanave të veçanta, sidomos nga humbja e
provizionit nga punët juridike me klientët e tillë.
2. Në përcaktimin e shumës së pjesëtuar, është e nevojshme që të merret parasysh provizioni i fituar
nga përfaqësuesit tregtar për kontratat pas shkëputjes së marrëdhënies me urdhërdhënësin, si dhe çdo
pengesë e aktiviteteve konkurruese pas shkëputjes së marrëdhënies me urdhërdhënësin.
3. Shuma e pjesëtuar , sipas paragrafit të parë dhe të dytë të këtij neni, nuk mund të tejkalojë
mesataren e shumës së provizionit vjetorë gjatë pesë (5) viteve të fundit apo të periudhës më të
shkurtër kohore relevante pas lidhjes së kontratës.
4. Kur kontrata e lidhur për një kohë të caktuar, shkëputet para përfundimit të kësaj kohe ose kur
kontrata e lidhur për një kohë të pacaktuar përfundon para kalimit të pesë (5) viteve nga momenti i
lidhjes së kontratës, përfaqësuesit tregtar ka të drejtë në ndarjen e një shumë të përshtatshme parash,
shumën e diferencës ndërmjet shpenzimeve që përfaqësuesit tregtar ka pasur në lidhje me prezantimin
e produktit në treg dhe të gjitha shpenzimeve tjera në lidhje me përmbushjen e kontratës, dhe
diferencës së të ardhurave të përfaqësuesit tregtar të marra nga përmbushja e kontratës si dhe të
ardhurave që përfaqësuesit tregtar sipas të gjitha gjasave do të kishte marrë deri në fund të periudhës
së kontratës nëse ajo është lidhur për një kohë të caktuar apo për pesë (5) vite nga momenti i lidhjes së
kontratës nëse ajo është lidhur për një kohë të pacaktuar.
5. Përfaqësuesit tregtar po ashtu ka të drejtë në pjesëtimin e shumës sipas paragrafit të mëparshëm,
nëse ai nuk ka të drejtë në pjesëtimin e shumës sipas paragrafit 1. të këtij neni, ose nëse pjesëtimi i
shumës relevante sipas paragrafit 1. të këtij neni do të ishte më e vogël sesa shuma relevante e
pjesëtuar sipas paragrafit të mëparshëm.
6. Pagesa e shumës së pjesëtuar nuk e përjashton të drejtën e përfaqësuesit tregtar për kompensim.', 'd4dd4e0896dbaddcfefc16d56bf181db2d834b5cf5fcc2ec3f2d143156b0a34a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":176,"pageEnd":177,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (830, '831', 'Baza për përjashtimin e pjesëtimit të shumës', '1-1.3', 'Ligji 04/L-077
Neni 831 - Baza për përjashtimin e pjesëtimit të shumës

1. Urdhërdhënësi nuk është përgjegjës të paguaj shumën e pjesëtuar, nëse:
1.1. kontrata është shkëputur nga përfaqësuesit tregtar agjenti. Megjithatë, edhe në këtë rast
përfaqësuesit tregtar mund të kërkojë shumën e pjesëtuar nëse arsyeja për shkëputjen e
kontratës kanë qenë rrethanat në anën e urdhërdhënësit apo nëse përfaqësuesit tregtar e ka
shkëputur kontratën për shkak të moshës apo sëmundjes së përfaqësuesit tregtar e cila do të
pamundësonte vazhdimin e marrëdhënies kontraktore.
1.2. urdhërdhënësi ka shkëputur kontratën për shkak të sjelljes me faj të përfaqësuesit tregtar.
1.3. në përputhje me marrëveshjen ndërmjet urdhërdhënësit dhe përfaqësuesit tregtar,
urdhërdhënësi lidh kontratë në vend të përfaqësuesit tregtar. Një marrëveshje e tillë nuk është
e lejueshme përpara përfundimit të marrëdhënies kontraktore.', 'e6ace0b9d333b63cc1dc939430653e543b85ca9726db0155ec2a60db5062b7d2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.3","pageStart":177,"pageEnd":177,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (831, '832', 'Shfrytëzimi i shumës së pjesëtuar', '1-4', 'Ligji 04/L-077
Neni 832 - Shfrytëzimi i shumës së pjesëtuar

1. E drejta në shumën e pjesëtuar rrjedh gjithashtu edhe nëse kontrata është shkëputur për shkak të
vdekjes së përfaqësuesit tregtar.
2. Përfaqësuesit tregtar i cili brenda një viti nga momenti i shkëputjes së marrëdhënies kontraktore nuk
e informon urdhërdhënësin se do të kërkojë shumën e pjesëtuar e humb të drejtën për shumën e
pjesëtuar.
3. Palët nuk munden që paraprakisht ti heqin apo zvogëlojnë të drejtat në dëm të përfaqësuesit tregtar,
në lidhje me shumën e pjesëtuar.
4. Në lidhje me ekstraktet e librave të llogarisë dhe njoftimit mbi rrethanat e dukshme që ndikojnë në
përcaktimin e shumës së pjesëtuar, përfaqësuesit tregtar ka të njëjtat të drejta si në rastin e caktimit të
provizionit.', '6190a83687c7fcb67ffbaa19df8b5ed206c236e65317dbc11fc9f1bd6291d81b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":177,"pageEnd":178,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (832, '833', 'Ndalimi i konkurrencës pas shkëputjes së kontratës', '1-6', 'Ligji 04/L-077
Neni 833 - Ndalimi i konkurrencës pas shkëputjes së kontratës

1. Me anë të kontratës mund të përcaktohet se pas përfundimit të kontratës përfaqësuesi tregtar nuk
mund të kryejë ndonjë aktivitet që do të konkurronte me aktivitetet e urdhërdhënësit.
2. Një dispozitë e tillë është e vlefshme vetëm nëse bëhet me shkrim dhe nëse është në të njëjtën
fushë, për të njëjtët persona dhe të njëjtat mallra siç janë të përcaktuara në kontratë.
3. Kur kontrata është shkëputur për arsyet e urdhërdhënësit, një dispozitë e tillë është e detyrueshme
vetëm për përfaqësuesit tregtar nëse urdhërdhënësi ka paguar shumën e pjesëtuar përkatëse me rastin
e shkëputjes së kontratës dhe nëse gjatë ndalesës për konkurrencë urëdhërdhënësi paguan
kompensimin e përshtatshëm mujorë në një shumë të barabartë me mesataren e provizionit mujorë për
gjatë pesë (5) viteve të fundit të kontratës ose për gjatë kohës së kontratës, nëse ajo ka qenë në fuqi
për më pak se pesë (5) vite.
4. Një dispozitë e tillë do të detyrojë përfaqësuesit tregtar për të paktën dy (2) vite pas shkëputjes së
kontratës.
5. Nëse përfaqësuesit tregtar ka shkëputur kontratën për fajin e urdhërdhënësit dhe ndalesa e
konkurrencës pas shkëputjes së kontratës ka qenë pjesë e marrëveshjes në kontratë, përfaqësuesit
tregtar mundet që brenda një (1) muaji pas shkëputjes së kontratës ti dorëzojë një deklaratë me shkrim
urdhërdhënësit ku e njofton se përfaqësuesit tregtar nuk do ta respektojë ndalesën e konkurrencës.
6. Dispozitat e këtij neni nuk mund të ndryshohen me anë të kontratës në dëm të përfaqësuesit tregtar.', 'd2671a7afaae326ba30ac61175044475ed5e48220fa10519b710308fb9a06cd7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":178,"pageEnd":178,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (833, '834', 'Kuptimi', null, 'Ligji 04/L-077
Neni 834 - Kuptimi

Me kontratën për ndërmjetësimin detyrohet ndërmjetësuesi që të përpiqet të gjejë dhe ta vejë në lidhje
me urdhërdhënësin personin që do të bisedonte me të për lidhjen e kontratës së caktuar, ndërsa
urdhërdhënësi detyrohet t’i paguajë shpërblim të caktuar, në qoftë se kjo kontratë do të lidhet.', '54df77811a69e60bcb49040e2fc8d4b04ae3bdea2ea0a92c7a5b586cb1d2e0e0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":178,"pageEnd":178,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (834, '835', 'Zbatimi i dispozitave të ligjit për kontratën për veprën', null, 'Ligji 04/L-077
Neni 835 - Zbatimi i dispozitave të ligjit për kontratën për veprën

Kur është kontraktuar se ndërmjetësuesi do të ketë të drejtë në shpërblimin e caktuar dhe në qoftë se
përpjekja e tij mbetet pa rezultat, për atë kontratë do të zbatohen dispozitat që vlejnë për kontratën për
veprën.', '7410e5b6c3bf7260fd26539efe1e299997dfae7631095c5c98d66dc444c44ac5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":179,"pageEnd":179,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (835, '836', 'Pranimi i përmbushjes', '1-2', 'Ligji 04/L-077
Neni 836 - Pranimi i përmbushjes

1. Urdhri për ndërmjetësimin nuk përmban autorizim për ndërmjetësuesin që për urdhërdhënësin të
pranojë përmbushjen e detyrimit nga kontrata e lidhur me ndërmjetësimin e tij.
2. Për këtë është e nevojshme një prokurë e veçantë me shkrim.', 'ee46c01e43187cc0653fdd2f611d7f63b92d5213adb23a1dc98b61f39f34462d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":179,"pageEnd":179,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (836, '837', 'Revokimi i urdhrit për ndërmjetësim', null, 'Ligji 04/L-077
Neni 837 - Revokimi i urdhrit për ndërmjetësim

Urdhërdhënësi mund ta revokon urdhrin për ndërmjetësim kur të dojë, në qoftë se nga kjo nuk ka hequr
dorë dhe me kusht që revokimi nuk është në kundërshtim me mirëbesimin.', '7e3dc99107aee1d7fb7a5dbf72b487729ae0fe88c75ad48bc6048f5c62e5d990', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":179,"pageEnd":179,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (837, '838', 'Mungesa e detyrimit për urdhërdhënësin që të lidhë kontratë', null, 'Ligji 04/L-077
Neni 838 - Mungesa e detyrimit për urdhërdhënësin që të lidhë kontratë

Urdhërdhënësi nuk është i detyruar të fillojë bisedime për lidhjen e kontratës me personin të cilin e ka
gjetur ndërmjetësuesi dhe as të lidhë kontratë me të nën kushtet që ia ka komunikuar ndërmjetësuesit,
por do të përgjigjet për dëmin, në qoftë se ka vepruar në kundërshtim me mirëbesim.', '47167321599518459a14b7ab1c2e486f29635f2af3a091338005017b350eb934', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":179,"pageEnd":179,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (838, '839', 'Detyrimi i kërkimit të rastit', '1-3', 'Ligji 04/L-077
Neni 839 - Detyrimi i kërkimit të rastit

1. Ndërmjetësuesi ka për detyrë që, me kujdesin e ekonomistit të mirë, të kërkojë rastin për lidhjen e
kontratës së caktuar dhe t’i tregojë për të urdhërdhënësit.
2. Ndërmjetësuesi ka për detyrë të ndërmjetësojë në bisedime dhe të përpiqet që të vejë deri te lidhja e
kontratës në qoftë se për të posaçërisht është detyruar.
3. Ai nuk përgjigjet në qoftë se edhe krahas kujdesit nuk ka sukses në përpjekjen e vet.', '9e570e5754a1756497c400f8b033b5de2ab029345415ca3762691abf5d051af0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":179,"pageEnd":179,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (839, '840', 'Detyrimi i njoftimit', null, 'Ligji 04/L-077
Neni 840 - Detyrimi i njoftimit

Ndërmjetësuesi ka për detyrë ta njoftojë urdhërdhënësin për të gjitha rrethanat, për të cilat ai është në
dijeni ose duhej të ishte në dijeni dhe për punën e synuar dhe ato rrethana janë me rëndësi.', 'e639c4bfe07a49ee051b3abde4341ec885126cda025fcdb0f4e122d934e3d5c8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":179,"pageEnd":179,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (840, '841', 'Përgjegjësia e ndërmjetësuesit', '1-2', 'Ligji 04/L-077
Neni 841 - Përgjegjësia e ndërmjetësuesit

1. Ndërmjetësuesi përgjigjet për dëmin, të cilin do ta pësonte njëra ose tjetra palë ndërmjet të cilave ka
ndërmjetësuar e që do të shkaktohej për arsye se ka ndërmjetësuar për personin e paaftë për punë,
për paaftësinë e të cilit ishte në dijeni ose duhej të ishte në dijeni, ose për personin për të cilin ishte në
dijeni ose duhej të ishte në dijeni, se nuk do të mund t’i kryejë detyrimet nga kjo kontratë dhe në
përgjithësi për çdo dëm të shkaktuar me fajin e tij.
2. Ndërmjetësuesi përgjigjet për dëmin që do të shkaktohej për urdhërdhënësin për arsye se pa lejen e
urdhërdhënësit e ka njoftuar ndonjë person të tretë për përmbajtjen e urdhrit, për negociata ose për
kushtet e lidhjes së kontratës.', 'ee7c0299da897340f933ae6c1b5d0367fb65091433ca5f2ebf701753674cd312', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":179,"pageEnd":180,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (841, '842', 'Ditari ndërmjetësues dhe fleta', null, 'Ligji 04/L-077
Neni 842 - Ditari ndërmjetësues dhe fleta

Ndërmjetësuesi ka për detyrë në regjistrin e veçantë (ditari ndërmjetësues) t’i shënojë të dhënat
thelbësore për kontratën që është lidhur me ndërmjetësimin e tij dhe të lëshojë ekstraktin nga ky
regjistër të nënshkruar nga ana e tij (fleta e ndërmjetësimit).', '07998aaf7677f80f5edb58ca041fa61beb0624e925c722a3b55d46bec1536c1b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":180,"pageEnd":180,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (842, '843', 'Shpërblimi', '1-4', 'Ligji 04/L-077
Neni 843 - Shpërblimi

1. Ndërmjetësuesi ka të drejtë për shpërblim edhe kur ky nuk është kontraktuar.
2. Në qoftë se lartësia e shpërblimit nuk është caktuar as me tarifë ose me ndonjë akt tjetër të
përgjithshëm, as me kontratë as me doke, atë do ta caktojë gjykata sipas mundit të ndërmjetësuesit
dhe shërbimit të bërë.
3. Shpërblimin e kontraktuar të ndërmjetësimit gjykata mund ta zbresë me kërkesën e urdhërdhënësit,
në qoftë se gjen se është tepër i lartë, duke marrë parasysh mundin dhe shërbimin e bërë.
4. Zbritja e shpërblimit të kontraktuar nuk mund të kërkohet në qoftë se i është paguar ndërmjetësuesit
pas lidhjes së kontratës për të cilën ai ka ndërmjetësuar.', '9429d0cd734d717e33298b4b62abc53196521e1c762b644fd093f2999a0fd318', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":180,"pageEnd":180,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (843, '844', 'Kur ndërmjetësuesi fiton të drejtën e shpërblimit', '1-4', 'Ligji 04/L-077
Neni 844 - Kur ndërmjetësuesi fiton të drejtën e shpërblimit

1. Ndërmjetësuesi fiton të drejtën e shpërblimit në momentin e lidhjes së kontratës për të cilën ka
ndërmjetësuar, në qoftë se nuk është kontraktuar diçka tjetër.
2. Në qoftë se kontrata është lidhur nën kushtin suspenziv (shtytës), ndërmjetësuesi fiton të drejtën e
shpërblimit vetëm kur kushti realizohet.
3. Kur kontrata është lidhur nën kushtin zgjidhës, realizimi i kushtit nuk ka ndikim në të drejtën e
ndërmjetësuesit në shpërblim.
4. Në rastin e pavlefshmërisë së kontratës, ndërmjetësuesi ka të drejtë në shpërblim në qoftë se për
shkakun e pavlefshmërisë nuk ishte në dijeni.', '347206472a3f12ce33e68ed23f36d63a52fd8b8760c5a936e451598a383ffe32', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":180,"pageEnd":180,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (844, '845', 'Shpërblimi i shpenzimeve', '1-2', 'Ligji 04/L-077
Neni 845 - Shpërblimi i shpenzimeve

1. Ndërmjetësuesi nuk ka të drejtë në shpërblimin e shpenzimeve të bëra në kryerjen e urdhrit, përveç
kur kjo është kontraktuar.
2. Në qoftë se me kontratë është e njohur e drejta e shpërblimit të shpenzimeve, ai ka të drejtë në këtë
shpërblim edhe në rastin kur kontrata nuk është lidhur.', '38eefc0da42f14b45aeee8e5baf39f35a8e8a6a7d7fc39039b69cea06ee697ad', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":180,"pageEnd":181,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (845, '846', 'Ndërmjetësimi për të dy palët', '1-2', 'Ligji 04/L-077
Neni 846 - Ndërmjetësimi për të dy palët

1. Në qoftë se nuk është kontaktuar ndryshe, ndërmjetësuesi që e ka marrë urdhrin për ndërmjetësim
nga të dy palët mund të kërkojë nga secila palë vetëm gjysmën e shpërblimit të ndërmjetësimit dhe
shpërblimin e gjysmës së shpenzimeve, në qoftë se shpërblimi i shpenzimeve është kontraktuar.
2. Ndërmjetësuesi ka për detyrë që me kujdesin e ekonomistit të mirë të kujdeset për interesat e të dy
palëve, ndërmjet të cilave ai ndërmjetëson.', '096346c2aa494d46254c94f855ecd5c12a026dcb959a58452bafa7522dc89403', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":181,"pageEnd":181,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (846, '847', 'Humbja e të drejtës së shpërblimit', null, 'Ligji 04/L-077
Neni 847 - Humbja e të drejtës së shpërblimit

Ndërmjetësuesi i cili në kundërshtim me kontratën ose në kundërshtim me interesat e urdhërdhënësit të
vet punon për palën tjetër, humb të drejtën e shpërblimit të ndërmjetësimit dhe të shpërblimit të
shpenzimeve.', 'e25b349905c9ebf695731602a4b519489739c5d16b86116be73680e411be0435', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":181,"pageEnd":181,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (847, '848', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 848 - Nocioni

1. Me kontratën për shpeditimin detyrohet shpedituesi që me qëllim transporti të sendit të caktuar, të
lidhë në emër të vet dhe për llogari të urdhërdhënësit kontratën e transportit dhe kontrata të tjera të
nevojshme për kryerjen e transportit, si dhe të kryejë punë dhe veprime të tjera të rëndomta, ndërsa
urdhërdhënësi detyrohet t’i paguajë shpërblim të caktuar.
2. Në qoftë se me kontratë është paraparë, shpedituesi mund të lidhë kontratën e transportit dhe të
ndërmarrë veprime të tjera juridike në emër dhe për llogari të urdhërdhënësit.', 'c708fa8aa80a4ba1954b8592e66f189b97dacfd63b9b3d58dda51aaeb2c7e754', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":181,"pageEnd":181,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (848, '849', 'Heqja dorë nga kontrata', null, 'Ligji 04/L-077
Neni 849 - Heqja dorë nga kontrata

Urdhërdhënësi mund të heqë dorë nga kontrata sipas vullnetit të vet, por në këtë rast ka për detyrë t’i
shpërblejë shpedituesit të gjitha shpenzimet që ka pasur gjer atëherë dhe t’i paguajë pjesën
proporcionale të shpërblimit për punën e deriatëhershme.', '114ae8ca089f295fef3baf1c5dc89dc367e55386091ac07d4efca338e9197117', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":181,"pageEnd":181,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (849, '850', 'Zbatimi i rregullave për kontratën e komisionit përkatësisht të përfaqësimit tregtar', null, 'Ligji 04/L-077
Neni 850 - Zbatimi i rregullave për kontratën e komisionit përkatësisht të përfaqësimit tregtar

Ndaj marrëdhënieve të urdhërdhënësit dhe shpedituesit që nuk janë rregulluar sipas kësaj pjese
zbatohen përshtatshmërisht rregullat për kontratën e komisionit, përkatësisht të përfaqësimit tregtar.', 'd8b1f6ca54512d0476ed3dae9acc9be303513f40e7f5fb5226719f1b7bb855a2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":181,"pageEnd":181,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (850, '851', 'Tërheqja e vërejtjes për të metat e urdhrit', null, 'Ligji 04/L-077
Neni 851 - Tërheqja e vërejtjes për të metat e urdhrit

Shpedituesi ka për detyrë t’ia tërheqë vërejtjen urdhërdhënësi për të metat në urdhrin e tij, sidomos për
ato që i ekspozojnë të ketë shpenzime më të mëdha ose të pësojë ndonjë dëm.', '3d2c9145f16560d0119fc8998ca2ee8b30b6eecc828d5427cdad58d6b380529e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":182,"pageEnd":182,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (851, '852', 'Tërheqja e vërejtjes për të metat e paketimit', null, 'Ligji 04/L-077
Neni 852 - Tërheqja e vërejtjes për të metat e paketimit

Në qoftë se sendi nuk është paketuar dhe në përgjithësi nuk është bërë gati për transport siç duhet,
shpedituesi ka për detyrë t’ia tërheqë vërejtjen urdhërdhënësit për këto të meta, e kur pritja që
urdhërdhënësi t’i evitojë do t’i shkaktonte dëm këtij, dërguesi ka për detyrë t’i evitojë në llogari të
urdhërdhënësit.', '7042fa7aa088bb1d46b55caa871504c15e8797a1039ab4739d4e83e3b3a3efc4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":182,"pageEnd":182,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (852, '853', 'Ruajtja e interesave të urdhërdhënësit', '1-2', 'Ligji 04/L-077
Neni 853 - Ruajtja e interesave të urdhërdhënësit

1. Shpedituesi ka për detyrë që në çdo rast të veprojë ashtu sikundër e kërkojnë interesat e
urdhërdhënësit dhe me kujdesin e ekonomistit të mirë.
2. Ai ka për detyrë ta njoftojë urdhërdhënësin pa shtyrje për dëmtimin e sendeve si dhe për të gjitha
ngjarjet me rëndësi për të dhe të marrë të gjitha masat e nevojshme për ruajtjen e të drejtave të tij ndaj
personit përgjegjës.', '7f8c5a1375df0bc071a6b9e770c4585ebd737efba6db1b0865dc1a87632c3890', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":182,"pageEnd":182,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (853, '854', 'Veprimi sipas udhëzimeve të urdhërdhënësit', '1-5', 'Ligji 04/L-077
Neni 854 - Veprimi sipas udhëzimeve të urdhërdhënësit

1. Shpedituesi ka për detyrë t’i përmbahet udhëzimeve mbi drejtimin e rrugës, mjeteve dhe mënyrën e
transportit, si dhe udhëzimet e tjera të marra nga urdhërdhënësi.
2. Në qoftë se nuk ka mundësi të veprojë sipas udhëzimeve të përmbajtura në urdhër, shpedituesi ka
për detyrë të kërkojë udhëzime të reja, e në qoftë se për këtë gjë nuk ka kohë, ose nuk është e mundur
shpedituesi ka për detyrë të veprojë sikundër e kërkojnë interesat e urdhërdhënësit.
3. Për çdo shmangie nga urdhëri, shpedituesi ka për detyrë ta njoftojë urdhërdhënësin pa vonesë.
4. Në qoftë se urdhërdhënësi nuk e ka caktuar as rrugën dhe as mjetet, as mënyrën e transportit,
dërguesi do t’i caktojë ashtu sikurse e kërkojnë interesat e urdhërdhënësit në rastin konkret.
5. Në qoftë se shpedituesi i është shmangur udhëzimeve të marra, përgjigjet edhe për dëmin e
shkaktuar për shkak të fuqisë madhore, përveç nëse provon se dëmi do të shkaktohej edhe po t’u
kishte përmbajtur udhëzimeve të dhëna.', '16be23f18f30b36135aaec70eab37ec2d4e95901b567ae6249b1f0e63163f772', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":182,"pageEnd":182,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (854, '855', 'Përgjegjësia e shpedituesit për persona të tjerë', '1-4', 'Ligji 04/L-077
Neni 855 - Përgjegjësia e shpedituesit për persona të tjerë

1. Shpedituesi përgjigjet për zgjedhjen e transportuesit, si dhe për zgjedhjen e personave të tjerë me të
cilët në zbatimin e urdhërit ka lidhur kontratën (magazionimi i mallit etj.), por jo edhe për punën e tyre,
përveç nëse këtë përgjegjësi e ka marrë mbi vete me kontratë.
2. Shpedituesi i cili ia beson zbatimin e urdhërit shpedituesit tjetër në vend që ta përmbushë urdhërin
vet, përgjigjet për punën e tij.
3. Në qoftë se urdhëri përmban autorizimin shprehimor ose heshtazi shpedituesit që t’i besojë zbatimin
e urdhërit dërguesit tjetër ose nëse kjo është padyshim në interesin e urdhërdhënësit, ai përgjigjet
vetëm për zgjedhjen e tij, përveç nëse ka marrë përsipër përgjegjësinë për punën e tij.
4. Përgjegjësitë nga paragrafet e mësipërme të këtij neni nuk mund të përjashtohen dhe as të kufizohen
me kontratë.', '45b32d7840e6e400a64866f02c5be7f34095399b65750cda0a73e4a07223bb99', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":182,"pageEnd":183,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (855, '856', 'Veprimet doganore dhe pagimi i doganës', null, 'Ligji 04/L-077
Neni 856 - Veprimet doganore dhe pagimi i doganës

Në qoftë se në kontratë nuk është caktuar ndryshe, urdhëri për dërgimin e sendit përtej kufirit përmban
detyrimin për dërguesin që të zbatojë veprimet e duhura doganore dhe të paguajë taksat doganore për
llogari të urdhërdhënësit.', '6b8ada6be8af296131ad3dabcad337343c58eab01fd69030508d5fa1a10eb72a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":183,"pageEnd":183,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (856, '857', 'Kur shpedituesi kryen vetë transportin ose punët e tjera', '1-3', 'Ligji 04/L-077
Neni 857 - Kur shpedituesi kryen vetë transportin ose punët e tjera

1. Shpedituesi mundet edhe vetë të kryejë plotësisht ose një pjesë të transportit të sendeve, dërgimi i të
cilave i është besuar, në qoftë se nuk është kontraktuar diçka tjetër.
2. Në qoftë se dërguesi e ka kryer transportin vetë ose pjesën e transportit, ka të drejtë dhe detyrime të
transportuesit, kështu që në këtë rast i takon edhe shërblimi përkatës për transport përveç shpërblimit
mbi bazën e dërgimit dhe shpërblimit të shpenzimeve në lidhje me shpeditimin.
3. E njëjta gjë vlen lidhur me punë të tjera të përfshira me urdhërin, doket ose me kushtet e
përgjithshme.', 'c93ea2b964f7cde38217f70df0847796cf8a21ef912b56c3589e29e7468cd26b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":183,"pageEnd":183,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (857, '858', 'Sigurimi i dërgesës', '1-2', 'Ligji 04/L-077
Neni 858 - Sigurimi i dërgesës

1. Dërguesi ka për detyrë ta sigurojë dërgesën vetëm në qoftë se kjo është kontraktuar.
2. Në qoftë se me kontratë nuk është caktuar se cilat rreziqe duhet t’i përfshijë sigurimi, dërguesi ka për
detyrë t’i sigurojë sendet nga rreziqet e rëndomta.', '97c2a664ebc216cf2f2ebd0f4c258b14ce75069d322780c0d6e5f04200fa20ce', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":183,"pageEnd":183,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (858, '859', 'Dhënia e llogarisë', '1-2', 'Ligji 04/L-077
Neni 859 - Dhënia e llogarisë

1. Pas mbarimit të punës shpedituesi ka për detyrë t’i japë llogari urdhërdhënësit.
2. Sipas kërkesës së urdhërdhënësit shpedituesi ka për detyrë të japë llogari edhe gjatë zbatimit të
urdhrit.', '15ec0f1f94d1cfb9f1407072f247d22ff66d5a8e1464263b2b515564e9c946ed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":183,"pageEnd":183,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (859, '860', 'Pagimi i shpërblimit', null, 'Ligji 04/L-077
Neni 860 - Pagimi i shpërblimit

Urdhërdhënësi ka për detyrë t’i paguajë shpedituesit shpërblimin sipas kontratës, e në qoftë se
shpërblimi nuk është kontraktuar, atëherë shpërblimin sipas tarifës ose të ndonjë akti tjetër të
përgjithshëm, e në mungesë të këtij, shpërblimin do ta caktojë gjykata.', '5e671a9be9f7ee1903b47c967b887c1e09e17e7f82f6235d2d0d5cba20df15f3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":183,"pageEnd":183,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (860, '861', 'Kur dërguesi mund të kërkojë shpërblim', null, 'Ligji 04/L-077
Neni 861 - Kur dërguesi mund të kërkojë shpërblim

Shpedituesi mund të kërkojë shpërblim kur të kryejë detyrimet e veta nga kontrata për shpedicionin.', '9c29e58c140757c42820e4d5d7ef1510a7d38905595fae7f20ff1b4dc9d8ccdd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":184,"pageEnd":184,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (861, '862', 'Shpenzimet dhe paradhënia', '1-3', 'Ligji 04/L-077
Neni 862 - Shpenzimet dhe paradhënia

1. Urdhërdhënësi ka për detyrë t’ia shpërblejë shpedituesit shpenzimet e nevojshme të bëra për
zbatimin e urdhrit për dërgimin e sendit.
2. Shpedituesi mund të kërkojë shpërblimin e shpenzimeve menjëherë posa t’i ketë bërë.
3. Urdhërdhënësi ka për detyrë që me kërkesën e shpedituesit, t’i japë në formë paradhënie një shumë
të nevojshme për shpenzimet që kërkon zbatimi i urdhërit për dërgimin e sendit.', '8e80b4fb53188e51db42ebdb776e506deb9393b280f92aab2b274bd65ecef72b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":184,"pageEnd":184,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (862, '863', 'Kur është kontraktuar që shpërblimin ta paguajë marrësi i sendeve', null, 'Ligji 04/L-077
Neni 863 - Kur është kontraktuar që shpërblimin ta paguajë marrësi i sendeve

Në qoftë se është kontraktuar se shpedituesi do t’i arkëtojë kërkesat e veta nga marrësi i sendeve,
shpedituesi rezervon të drejtën të kërkojë pagimin e shpërblimit nga urdhërdhënësi, në qoftë se marrësi
refuzon t’ia paguajë.', '0ffd2b124b3004e444b4acc71135f0a7eba00178f53f23140ed097b2ee16ea25', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":184,"pageEnd":184,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (863, '864', 'Sendet e rrezikshme dhe të çmueshme', '1-2', 'Ligji 04/L-077
Neni 864 - Sendet e rrezikshme dhe të çmueshme

1. Urdhërdhënësi ka për detyrë ta njoftojë shpedituesin mbi cilësitë e sendeve me të cilat mund të
rrezikohet siguria e njerëzve ose e vlerave apo mbi shkaktimin e dëmit.
2. Kur në dërgesën ndodhen sendet e çmueshme, letrat me vlerë ose sendet e tjera të shtrenjta,
urdhërdhënësi ka për detyrë ta njoftojë për këtë shpedituesin dhe t’ia komunikojë vlerën e tyre në çastin
e dorëzimit për dërgim.', '48be15dc7aa7d1aaa7272d34ad026a3880e76758dda9e1ddd96270e06fef3eca', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":184,"pageEnd":184,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (864, '865', 'Shpeditimi me shpërblimin fiks', '1-2', 'Ligji 04/L-077
Neni 865 - Shpeditimi me shpërblimin fiks

1. Kur me kontratën për shpeditimin është caktuar një shumë e përgjithshme për zbatimin e urdhërit
mbi dërgimin e sendit, në të është përmbajtur shpërblimi për punën e dërguesit, si dhe shpërblimi i
shpenzimeve të transportit dhe shpërblimi i të gjitha shpenzimeve të tjera, në qoftë se nuk është
kontraktuar diçka tjetër.
2. Në këtë rast shpedituesi përgjigjet edhe për punën e transportuesit dhe të personave të tjerë që i ka
përdorur me anë të autorizimit nga kontrata.', '93331fca9faac202229c2e31c3074ef81ba2af79bb729ea210c29bc30e5e6e39', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":184,"pageEnd":184,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (865, '866', 'Shpeditimi përmbledhës', '1-3', 'Ligji 04/L-077
Neni 866 - Shpeditimi përmbledhës

1. Shpedituesi në zbatimin e urdhrave të marra mund të organizojë shpeditimin përmbledhës, përveç
nëse me kontratë kjo është përjashtuar.
2. Në qoftë se me shpeditimin përmbledhës realizon diferencën në çmimin e transportit në dobi të
urdhërdhënësit, dërguesi ka të drejtë në shpërblimin e veçantë suplementar.
3. Në rastin e shpeditimit përmbledhës shpedituesi përgjigjet për humbjen ose dëmtimin e sendit të
shkaktuar gjatë kohës së transportit që nuk do të shkaktoheshin po mos të kishte qenë dërgimi
kompleks.', '2552c6e45dcec4d483b346fda9cf9836e21386fef716faa68ef440f811dc1d3a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":184,"pageEnd":185,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (866, '867', 'E drejta e pengut e shpedituesit', '1-4', 'Ligji 04/L-077
Neni 867 - E drejta e pengut e shpedituesit

1. Për sigurimin e arkëtimit të kërkesave të veta të krijuara lidhur me kontratën për shpeditimin,
shpedituesi ka të drejtë pengu në sendet e dorëzuara për dërgim dhe lidhur me dërgimin gjithnjë gjersa
e mban, ose gjersa ka në dorë dokumentin me anë të të cilit mund t’i disponojë ato.
2. Kur në kryerjen e dërgimit ka marrë pjesë edhe dërguesi tjetër, ai ka për detyrë të kujdeset për
arkëtimin e kërkesave dhe për realizimin e të drejtës së pengut të dërguesve të mëparshëm.
3. Në qoftë se dërguesi tjetër paguan kërkesat e dërguesit ndaj urdhërdhënësit, këto kërkesa dhe e
drejta e pengut e dërguesit i barten këtij në bazë të vet ligjit.
4. E njëjta gjë ndodh po qe se dërguesi tjetër paguan kërkesat e transportuesit.', '6c2cdfdd58e68bcafd5b4e4de4fac104dfad7e3c183a6873bf8f49ef85bf69a0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":185,"pageEnd":185,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (867, '868', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 868 - Nocioni

1. Me kontratën për kontrollin e mallrave njëra palë kontraktuese (kryerësi i kontrollit) detyrohet të
kryejë në mënyrë profesionale dhe të paanshme kontrollin kontraktues të mallrave dhe të lëshojë
certifikatë për këtë, kurse pala tjetër (porositësi i kontrollit) detyrohet që për kontrollin e kryer të paguajë
shpërblimin e kontraktuar.
2. Kontrolli i mallrave mund të përbëhet nga përcaktimi i identitetit, cilësisë, sasisë dhe të veçorive të
tjera të mallrave.', '0a4ffabc2e7d64cf56bbffd29239f3116232622d108e63400f263ea92461a6ff', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":185,"pageEnd":185,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (868, '869', 'Vëllimi i kontrollit', null, 'Ligji 04/L-077
Neni 869 - Vëllimi i kontrollit

Kryerësi i kontrollit është i detyruar të kryejë kontrollin në vëllimin dhe në mënyrën që janë caktuar në
kontratë, e në qoftë se në kontratë asgjë nuk është caktuar, në vëllimin dhe në mënyrën që i përgjigjet
natyrës së sendit.', 'f06f449c4347c70fc9808a1e4b50c6a71f61e3b3c5b6235dfa91ff611892499e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":185,"pageEnd":185,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (869, '870', 'Nuliteti i disa dispozitave të kontratës', '1-2', 'Ligji 04/L-077
Neni 870 - Nuliteti i disa dispozitave të kontratës

1. Janë nule dispozitat e kontratës që i imponojnë kryerësit të kontrollit detyrat që do të mund të
ndikonin në paanshmërinë e ushtrimit të kontrollit ose në rregullsinë e dokumentit për kontrollin e kryer
(çertifikata).
2. Kontrolli konsiderohet i kryer vetëm pas lëshimit të çertifikatës.', 'f0f7bf66c7365dc04a63ccf65dc4700a60b316afae0ef6c7ad944ce42716beb7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":185,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (870, '871', 'Ruajtja e mallrave, respektivisht e mostrave', '1-2', 'Ligji 04/L-077
Neni 871 - Ruajtja e mallrave, respektivisht e mostrave

1. Mallin të cilin porositësi i kontrollit ia ka dorëzuar kryerësit të kontrollit për kryerjen e kontrollit të
kontraktuar, ushtruesi i kontrollit ka për detyrë t’i ruajë dhe t’i sigurojë nga ndërrimi.
2. Kryerësi i kontrollit është i detyruar t’i ruajë mostrat të cilat iu kanë dorëzuar së paku gjashtë (6)
muaj, në qoftë se nuk është kontraktuar ndryshe.', 'a5c9f42dd47b8704a1f0cf8e8bb424ca6aed0503d4ec73c3837c41998e42082a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":186,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (871, '872', 'Detyrimi i lajmërimit të porositësit', null, 'Ligji 04/L-077
Neni 872 - Detyrimi i lajmërimit të porositësit

Kryerësi i kontrollit ka për detyrë që për të gjitha rrethanat e rëndësishme gjatë kontrollit dhe ruajtjes së
mallrave ta lajmërojë porositësin e kontrollit në kohën e duhur, e sidomos për shpenzimet e
domosdoshme dhe të dobishme që janë bërë për llogari të tij.', '3ce4b5c37f82b7262eb0abe4b7bd309f500e6b184e94850ad836d9659a720a4c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":186,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (872, '873', 'Shpërblimi', '1-2', 'Ligji 04/L-077
Neni 873 - Shpërblimi

1. Për kontrollin dhe për ruajtjen e kryer të mallit, kryerësi i kontrollit ka të drejtë për shpërblim të
kontraktuar ose të rëndomtë.
2. Kryerësi i kontrollit ka të drejtën e shpërblimit për të gjitha shpenzimet e nevojshme dhe të dobishme,
të cilat janë shkaktuar për llogari të porositësit.', 'a92af8e428771f4553f71690a8e84c97f848252430e5682e720119952f2fce55', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":186,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (873, '874', 'E drejta e pengut', null, 'Ligji 04/L-077
Neni 874 - E drejta e pengut

Për sigurimin e shpërblimit të kontraktuar apo të rëndomtë dhe të shpërblimit të shpenzimeve të
domosdoshme dhe të dobishme kryerësi i kontrollit ka të drejtë pengu mbi mallin që i është dorëzuar
për kontroll.', 'cbbfebe3773c1d3497cd1ef6e95f7ede67209d4c50b4c579254bedfebf15d78d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":186,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (874, '875', 'Të besuarit e kontrollit të mallit kryerësit tjetër të kontrollit', '1-2', 'Ligji 04/L-077
Neni 875 - Të besuarit e kontrollit të mallit kryerësit tjetër të kontrollit

1. Kryerësi i kontrollit mund t’ia besojë tjetrit kryerjen e kontrollit të kontraktuar të mallit, përveç nëse
porositësi i kontrollit ia ka ndaluar këtë shprehimisht.
2. Kryerësi i kontrollit i përgjigjet porositësit të kontrollit për punën e kryerësit tjetër të kontrollit.', 'bdeb5d791b8d5d964071ab88e83bb1681d6db1893a4a79c9bb431c81af814ced', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":186,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (875, '876', 'Kontrolli i mallit me kryerjen e disa veprimeve juridike', '1-2', 'Ligji 04/L-077
Neni 876 - Kontrolli i mallit me kryerjen e disa veprimeve juridike

1. Në bazë të urdhërit shprehimor të porositësit të kontrollit, kryerësi i kontrollit është i autorizuar që,
përpos kryerjes së kontrollit të mallit të ushtrojë edhe veprime të veçanta juridike në emër dhe për
llogari të porositësit të kontrollit.
2. Kryerësi i kontrollit ka të drejtë shpërblimi të veçantë të rëndomtë ose të kontraktuar për kryerjen e
veprimeve të veçanta juridike në emër dhe për llogari të porositësit të kontrollit.', '93123a6786dc072077034abd92c059ee8900b41809ce8abe9f4fa11e9e5d5340', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":186,"pageEnd":186,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (876, '877', 'Kontrolli i mallit me garanci', '1-2', 'Ligji 04/L-077
Neni 877 - Kontrolli i mallit me garanci

1. Kryerësi i kontrollit mund të garantojë për pandryshueshmërinë e cilësive të mallit të kontraktuar
brenda afatit kontraktues.
2. Për garancinë e marrë përsipër në pikëpamje të cilësive të mallit, kryerësi i kontrollit ka të drejtë
shpërblimi të veçantë të kontraktuar ose të rëndomtë.', '0193f9fd1145b006f7b6ee00d916b2287951c09d5958be6b9f190a15e17257cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":187,"pageEnd":187,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (877, '878', 'Kontrolli i shërbimeve dhe i sendeve që nuk janë destinuar për qarkullim', null, 'Ligji 04/L-077
Neni 878 - Kontrolli i shërbimeve dhe i sendeve që nuk janë destinuar për qarkullim

Në qoftë se kontrolli ka të bëjë me shërbime ose me sende që nuk janë destinuar për qarkullim,
kryerësi i kontrollit dhe porositësi i kontrollit kanë të njëjtat të drejta dhe detyrime sikurse te kontrolli i
mallit.', '713581514d6b97822c37ffd6d50feedc29bd64fc207a3eb586a4ff6a63bc888e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":187,"pageEnd":187,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (878, '879', 'Zgjidhja e kontratës', null, 'Ligji 04/L-077
Neni 879 - Zgjidhja e kontratës

Porositësi i kontrollit mund të deklarojë se e zgjidhë kontratën gjithnjë gjersa të mos jetë kryer kontrolli i
porositur, por në këtë rast ka për detyrë që kryerësit të kontrollit t’i paguajë pjesën proporcionale të
shpërblimit dhe shpenzimet e domosdoshme dhe të dobishme që janë bërë, si dhe t’ia shpërblejë
dëmin.', '5972c4d4cb30f52ba120f7f357cd31dae2ce7c579a68271c50c8afa8bb82b20a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":187,"pageEnd":187,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (879, '880', 'Përkufizimi', '1-2', 'Ligji 04/L-077
Neni 880 - Përkufizimi

1. Me kontratën mbi organizimin e udhëtimit obligohet organizatori i udhëtimit t''i jap udhëtarit një paketë
shërbimesh që përbëhen nga transporti, banimi dhe nga shërbimet e tjera që lidhen me të, kurse
udhëtari obligohet që organizatorit ti paguajë një shumë të përgjithshme (paushale).
2. Shitësi i paketës së udhëtimit, të ofruar nga organizatori i udhëtimit, i cili nuk ka zyre kryesore në atë
vend, konsiderohet të jetë organizatori i udhëtimit.', 'd04e8f1658a9d3de98efc9d0b6093d8cb2b09b8cfcf292ea3e38bd97d9fefb6a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":187,"pageEnd":187,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (880, '881', 'Dhënia e vërtetimit mbi udhëtimin', '1-3', 'Ligji 04/L-077
Neni 881 - Dhënia e vërtetimit mbi udhëtimin

1. Organizatori i udhëtimit deri më së largu me rastin e lidhjes së kontratës, i lëshon udhëtarit vërtetimin
mbi udhëtimin ose duhet të lidhë kontratë në formë të shkruar e cila përmban të gjitha pjesët e
detyrueshme të vërtetimit mbi udhëtimin.
2. Vërtetimi i udhëtimit duhet të përmbajë vendin dhe datën e përdorimit, logon dhe titullin e
organizatorit të udhëtimit, emrin e udhëtarit, lokacioni dhe datat e fillimit dhe mbarimit të paketës së
udhëtimit, numrin e ditëve të banimit, informatat e nevojshme për oraret, çmimet dhe kushtet e
transportit dhe cilësia e llojeve të transportit, informatat e nevojshme për banimin duke përfshirë edhe
vendin e banimit si dhe tipin dhe kategorinë e ambienteve të banimit, informatat në lidhje me numrin e
shujtave (psh. shujtat e plota, gjysma e shujtave, shtrati dhe mëngjesi) detajet e orareve të udhëtimit
dhe informata për shërbimet tjera të përfshira në çmimin e përgjithshëm, informata nëse është i
nevojshëm ekzistimi i një minimumi të udhëtarëve në mënyrë që udhëtimi të realizohet si dhe afatin
kohor kur do të njoftohet udhëtari për ndonjë anulim, çmimin e përgjithshëm për paketën e shërbimeve
të parapara në kontratë, kushtet në bazë të të cilave udhëtari mund të kërkojë anulimin e kontratës,
afatet kohore për ankesat dhe kërkesat për zbritje të çmimit për shkak të cilësisë së dobët apo për
shërbimet jo të plota, informatat e nevojshme në lidhje me kushtet formale të kufijve dhe doganave,
higjienës, rregullat tjera financiare dhe administrative, si dhe informatat tjera të cilat konsiderohen se
janë të dobishme nëse përfshihen në vërtetimin e udhëtimit.
3. Në qoftë se para lëshimit të vërtetimit mbi udhëtimin udhëtarit i është dhënë programi i udhëtimit, ku
ndodhen të dhënat nga paragrafi paraprak, vërtetimi mbi udhëtimin mund të përmbajë vetëm udhëzimin
për këtë program.', '92132a4733b6593fbef4bae1fdba4450e71b149e32547a4c945c0e9d4fc6fde9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":187,"pageEnd":188,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (881, '882', 'Raporti i kontratës dhe i vërtetimit mbi udhëtimin', '1-2', 'Ligji 04/L-077
Neni 882 - Raporti i kontratës dhe i vërtetimit mbi udhëtimin

1. Ekzistimi dhe plotfuqishmëria e kontratës mbi organizimin e udhëtimit janë të pavarur nga ekzistimi i
vërtetimit mbi udhëtimin dhe nga përmbajtja e tij.
2. Mirëpo organizatori i udhëtimit përgjigjet për krejt dëmin që pëson pala tjetër për shkak të mos
dhënies së vërtetimit mbi udhëtimin ose për shkak të pasaktësisë së tij.', 'b62ee38cb835b9ef455828c9199550ba15599e0dbb0f7f4d84c957873c8b4371', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":188,"pageEnd":188,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (882, '883', 'Prezumimi i saktësisë së vërtetimit', null, 'Ligji 04/L-077
Neni 883 - Prezumimi i saktësisë së vërtetimit

Konsiderohet se është e saktë ajo që ndodhet në vërtetim gjithnjë gjersa të mos provohet e kundërta.', '9295a4db94858c0def85b906a152685aa10198dd18f6a3c2521ca2b50f2cecfb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":188,"pageEnd":188,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (883, '884', 'Mbrojtja e të drejtave dhe e interesave të udhëtarit', null, 'Ligji 04/L-077
Neni 884 - Mbrojtja e të drejtave dhe e interesave të udhëtarit

Organizatori i udhëtimit ka për detyrë t''i japë udhëtarit shërbime që kanë përmbajtjen dhe veçoritë e
parashikuara me kontratë, me vërtetim, respektivisht me programin e udhëtimit dhe të kujdeset për të
drejtat dhe interesat e udhëtarit, në pajtim me praktikën e mirë afariste në këtë sferë.', '2946c497dacadb346f02946d26f005c7c14f56f7097cd227f30249b8db219d25', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":188,"pageEnd":188,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (884, '885', 'Detyrimi për të njoftuar', null, 'Ligji 04/L-077
Neni 885 - Detyrimi për të njoftuar

Para lidhjes së kontratës organizatori i udhëtimit, në formë të shkruar apo në ndonjë formë tjetër të
përshtatshme, duhet ti ofrojë udhëtarit të gjitha informacionet e nevojshme në lidhje me formalitetet
kufitare (pasaportat dhe vizat) dhe formalitetet sanitare, të kërkuara gjatë udhëtimit dhe banimit në
destinacionin e planifikuar. Organizatori i udhëtimit, para nisjes së udhëtimit, detyrohet të njoftojë
udhëtarin për afatet kohore në të njëjtën mënyrë dhe saktësisht të përcaktojë vendin e udhëtarit në
mjetet e transportit (p.sh. kabinën apo kuvertën në anije, vendin e ndarë për fjetjen në tren), informatat
për adresën dhe numrin e telefonit të përfaqësuesit lokal të organizatorit të udhëtimit ose të shitësit apo
nëse nuk ka përfaqësues lokal, informatat për ndonjë numër emergjence apo çdo lloj informacioni tjetër
që do i mundësonte udhëtarit të kontaktojë organizatorin e udhëtimit dhe ose të shitësit, si dhe
informata mbi lidhjen opsionale të sigurimit për të mbuluar shpenzimet e anulimit të kontratës dhe
sigurimit për mbulimin e shpenzimeve në rast të sëmundjes apo aksidenteve gjatë udhëtimit. Në rastet
e udhëtimit apo qëndrimit të të miturve jashtë vendit, organizatori i udhëtimit duhet të ofrojë informata
për vendosjen e kontaktit të drejt për drejtë me të miturin apo me zyrtarin përgjegjës të vendit ku është
duke qëndruar i mituri.', 'b36d541b6ad08ae7409dd5a7579c0a29f87fc5e8f7d661ac83f5ad9de450c25e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":188,"pageEnd":188,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (885, '886', 'Detyrimi i ruajtjes së sekretit', null, 'Ligji 04/L-077
Neni 886 - Detyrimi i ruajtjes së sekretit

Njoftimin që e merr mbi udhëtarin, mbi bagazhin dhe lëvizjet e tij, organizatori mund t''ua komunikojë
personave të tretë vetëm me lejen e udhëtarit ose me kërkesën e organit kompetent.', '8970bcf9432735cb4aefe4c4eafef15a1c527a9197b0fa18a86526caeb4cc37b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":189,"pageEnd":189,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (886, '887', 'Përgjegjësia për organizimin e udhëtimit', null, 'Ligji 04/L-077
Neni 887 - Përgjegjësia për organizimin e udhëtimit

Organizatori i udhëtimit përgjigjet për dëmin që i shkakton udhëtarit për shkak të moszbatimit të plotë
ose të pjesshëm të detyrimeve që kanë të bëjnë me organizimin e udhëtimit që parashikohen me
kontratën dhe me këtë ligj.', 'b218f5d0531ca0dc0ac40aa4fca683672146325693b0829c338f7b3a0b5353cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":189,"pageEnd":189,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (887, '888', 'Përgjegjësia e organizatorit të udhëtimit kur i kryen vetë shërbimet e veçanta', null, 'Ligji 04/L-077
Neni 888 - Përgjegjësia e organizatorit të udhëtimit kur i kryen vetë shërbimet e veçanta

Në qoftë se i jep vetë shërbimet e transportit, të strehimit ose shërbimet e tjera lidhur me kryerjen e
udhëtimit të organizuar, organizatori përgjigjet për dëmin që i ka shkaktuar udhëtarit sipas dispozitave
që kanë të bëjnë me këto shërbime.', '9b38132d57e87390cf4209f121c6d4f16f6cada9bec6d4be8f25ad14fc85c40c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":189,"pageEnd":189,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (888, '889', 'Përgjegjësia e organizatorit të udhëtimit kur kryerjen e shërbimeve të veçanta ua ka besuar personave të tretë', '1-5', 'Ligji 04/L-077
Neni 889 - Përgjegjësia e organizatorit të udhëtimit kur kryerjen e shërbimeve të veçanta ua ka besuar personave të tretë

1. Organizatori i udhëtimit që u ka besuar personave të tretë kryerjen e shërbimeve të transportit, të
strehimit ose të shërbimeve të tjera lidhur me kryerjen e udhëtimit, i përgjigjet udhëtarit për dëmin e
shkaktuar për shkak të moszbatimit të plotë ose të pjesshëm të këtyre shërbimeve, në pajtim me
dispozitat që kanë të bëjnë me të.
2. Mirëpo, edhe kur shërbimet janë kryer në pajtim me kontratën dhe me dispozitat që kanë të bëjnë me
të, organizatori përgjigjet për dëmin që pëson udhëtari me rastin e kryerjes së tyre, përveç nëse provon
se sjellet si organizator i kujdesshëm i udhëtimit gjatë zgjedhjes së personave që e kanë zbatuar.
3. Udhëtari ka të drejtë të kërkojë direkt nga personi i tretë përgjegjës për dëmin, shpërblimin e plotë
ose plotësues për dëmin e pësuar.
4. Në masën në të cilën ia ka shpërblyer dëmin udhëtarit organizatori i udhëtimit fiton të gjitha të drejtat
që do t''i kishte udhëtari ndaj personit të tretë përgjegjës për këtë dëm (e drejta e regresit).
5. Udhëtari ka për detyrë t''i cedojë organizatorit të udhëtimit dokumente dhe çdo gjë që nevojitet për
realizimin e të drejtës së regresit.', 'bbc8b0ce656247ad3ad89c7d1b3bc4db6dfdbd682d34e7ff9fed4ed7aab95a2c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":189,"pageEnd":189,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (889, '890', 'Zbritja e çmimit', '1-2', 'Ligji 04/L-077
Neni 890 - Zbritja e çmimit

1. Në qoftë se shërbimet nga kontrata mbi organizimin e udhëtimit janë kryer në mënyrë jo të plotë ose
jo me cilësi, udhëtari mund të kërkojë zbritjen proporcionale të çmimit me konditë që t''i ketë bërë
prapësim organizatorit të udhëtimit brenda tetë ditësh nga data e përfundimit të udhëtimit.
2. Kërkesa për zbritjen e çmimit nuk ndikon në të drejtën e udhëtarit që të kërkojë kompensimin e
dëmit.', '5c5d4c4efc0643bee10e79b9aa7b7ecbe731a2344098ee60ddaa20682ab48e7c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":189,"pageEnd":189,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (890, '891', 'Përjashtimi dhe kufizimi i përgjëgjësisë së organizatorit të udhëtimit', '1-3', 'Ligji 04/L-077
Neni 891 - Përjashtimi dhe kufizimi i përgjëgjësisë së organizatorit të udhëtimit

1. Janë nul dispozitat e kontratës mbi organizimin e udhëtimit që përjashtojnë ose pakësojnë
përgjegjësinë e organizatorit të udhëtimit.
2. Mirëpo, është e plotfuqishme dispozita e shkruar e kontratës me të cilën parapërcaktohet shuma më
e lartë e shpërblimit, me konditë që të mos jetë në shpërpjesëtim të hapur me dëmin.
3. Ky kufizim i shumës së shpërblimit, nuk vlen në qoftë se organizatori e ka shkaktuar dëmin me
dashje ose nga pakujdesia ekstreme.', '65a018822a4ed15e016761c6f0cef58944f67a5732eee66e33c5e8ca0bdf1432', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":190,"pageEnd":190,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (891, '892', 'Pagimi i çmimit', null, 'Ligji 04/L-077
Neni 892 - Pagimi i çmimit

Udhëtari ka për detyrë që organizatorit të udhëtimit t''i paguajë çmimin e kontraktuar për udhëtimin në
kohën, sikundër është kontraktuar, respektivisht siç praktikohet.', '3833e590160327a9334123b5163b9c177b6d712c98e4356068ba843a0f3426bb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":190,"pageEnd":190,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (892, '893', 'Detyrimi i dhënies të të dhënave', null, 'Ligji 04/L-077
Neni 893 - Detyrimi i dhënies të të dhënave

Udhëtari ka për detyrë që me kërkesën e organizatorit, t''i japë në kohën e duhur të gjitha të dhënat e
nevojshme për organizimin e udhëtimit, e sidomos për marrjen e biletave të udhëtimit, rëzervimin e
strehimit, si dhe dokumentet e nevojshme për kalimin e kufirit.', '076aece66fc4a01ae719dbe0554c586cf24765580cfa9fa9217d965d92dc1092', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":190,"pageEnd":190,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (893, '894', 'Përmbushja e kushteve të parashikuara me dispozita', null, 'Ligji 04/L-077
Neni 894 - Përmbushja e kushteve të parashikuara me dispozita

Udhëtari ka për detyrë të kujdeset që ai personalisht, dokumentet e tij dhe bagazhi i tij t''i përmbushin
kushtet e parashikuara me dispozitat kufitare, doganore, sanitare, monetare dhe me dispozitat e tjera
administrative.', '7d26fb194bd32ebcef1f444a9d5a6f472b383d374ee6992f5fe535c6edfd299f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":190,"pageEnd":190,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (894, '895', 'Përgjegjësia e udhëtarit për dëmin e shkaktuar', null, 'Ligji 04/L-077
Neni 895 - Përgjegjësia e udhëtarit për dëmin e shkaktuar

Udhëtari përgjigjet për dëmin që i shkakton organizatorit të udhëtimit nga moskryerja e detyrimeve që
rezultojnë për të nga kontrata dhe nga dispozitat e këtij ligji.', 'da4152bc03f6cd918ee35c53a1fffc4ef94f8a57288a60cfef37ce6c2d265087', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":190,"pageEnd":190,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (895, '896', 'Zëvendësimi i udhëtarit me ndonjë person tjetër', null, 'Ligji 04/L-077
Neni 896 - Zëvendësimi i udhëtarit me ndonjë person tjetër

Në qoftë se nuk është kontraktuar ndryshe, udhëtari mund të caktojë personin tjetër që në vend të tij t''i
shfrytëzojë shërbimet e kontraktuara me konditë që ky person t''i plotësojë kushtet e veçanta të
parashikuara për udhëtimin e caktuar dhe që udhëtari t''i shpërblejë organizatorit të udhëtimit
shpenzimet e shkaktuara nga zëvendësimi.', 'd4a028e7aeccaee3fe092c5daf9f58bd5a332c94d74854ef2c6b420c052a86f7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":190,"pageEnd":190,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (896, '897', 'Rritja dhe ulja e çmimit të kontraktuar', '1-4', 'Ligji 04/L-077
Neni 897 - Rritja dhe ulja e çmimit të kontraktuar

1. Organizatori i udhëtimit mund të kërkojë rritjen e çmimit të kontraktuar vetëm në qoftë se pas lidhjes
së kontratës kanë ndodhur ndryshime, në kursin e këmbimit të valutës apo ndryshime në tarifat e
transportuesve të cilat ndikojnë në çmimin e udhëtimit. Nëse ndryshimet e tilla kanë ndikuar në uljen e
çmimit të udhëtimit, atëherë organizatori i udhëtimit duhet të kthej diferencën në çmimit tek udhëtari.
2. Organizatori i udhëtimit mund ta përdori të drejtën e rritjes së çmimit të kontraktuar ose detyrohet të
pranojë uljen e çmimit të përcaktuar në paragrafin e mësipërm, nëse ndryshimi i çmimit pas lidhjes së
kontratës dhe metoda e llogaritjes së ndryshimit janë të parapara në vërtetimin e udhëtimit. Çmimi i
udhëtimit mund të rritet vetëm deri në njëzet ditë para fillimit të udhëtimit.
3. Nëse rritja e çmimit të kontraktuar kalon shumën prej dhjetë përqind (10%), udhëtari mund të tërhiqet
nga kontrata pa pasur detyrim për shpërblimin e dëmit.
4. Në rastin e tillë udhëtari ka të drejtën që t’i kthehet shuma që i ka paguar organizatorit të udhëtimit.', '3d5886c57bacc599f8df68220861e76345742e54a64571c208a262cd08df67a0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":191,"pageEnd":191,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (897, '898', 'E drejta e udhëtarit për të hequr dorë nga kontrata', '1-5', 'Ligji 04/L-077
Neni 898 - E drejta e udhëtarit për të hequr dorë nga kontrata

1. Udhëtari në çdo moment mund të heqë dorë nga kontrata, plotësisht ose pjesërisht.
2. Ne qoftë se udhëtari para fillimit të udhëtimit heq dorë nga kontrata në një afat të arsyeshme që
caktohet duke marrë parasysh llojin e aranzhmanit (heqja dorë në kohën e duhur), organizatori i
udhëtimit ka të drejtë vetëm në shpërblimin e shpenzimeve administrative.
3. Në rast të heqjes dorë jo në kohën e duhur nga kontrata, organizatori i udhëtimit mund të kërkojë nga
udhëtari shpërblimin në përqindje të caktuar të çmimit të kontraktuar, që përcaktohet përpjestimisht me
kohën që mbetet deri në fillim të udhëtimit dhe që duhet të justifikohet ekonomikisht.
4. Organizatori i udhëtimit ka të drejtë vetëm në shpërblimin e shpenzimeve të bëra në qoftë se
udhëtari ka hequr dorë nga kontrata për shkak të rrethanave që nuk ka mundur t''i evitojë ose t''i
shmangë dhe që, po të ekzistojnë në kohën e lidhjes së kontratës, do të përbënin shkak të bazuar që
kontrata të mos lidhet, si dhe në rastin kur udhëtari e ka siguruar zëvendësimin përkatës apo
zëvendësimin e ka gjetur vetë organizatori.
5. Në qoftë se udhëtari heq dorë nga kontrata pas fillimit të udhëtimit, kurse shkak për këtë nuk janë
rrethanat nga paragrafi paraprak i këtij neni, organizatori ka të drejtë në shumën e plotë të çmimit të
kontraktuar të udhëtimit.', 'e3f9466a5ddc44a230a514d8c618604f1ee847372a7589319b1ff03b010c1cbb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":191,"pageEnd":191,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (898, '899', 'E drejta e organizatorit të udhëtimit për të hequr dorë nga kontrata', '1-4', 'Ligji 04/L-077
Neni 899 - E drejta e organizatorit të udhëtimit për të hequr dorë nga kontrata

1. Organizatori i udhëtimit mund të heqë dorë nga kontrata, plotësisht ose pjesërisht, pa detyrimin e
shpërblimit të dëmit, në qoftë se përpara ose gjatë kohës së zbatimit të kontratës lindin rrethana të
jashtëzakonshme që nuk kanë mundur të parashikohen dhe as të shmangen ose të mënjanohen e që
po të ekzistonin në kohën e lidhjes së kontratës, do të përbënin shkak të bazuar për organizatorin e
udhëtimit që të mos e lidhë kontratën.
2. Organizatori i udhëtimit mund të heq dorë nga kontrata pa detyrimin e shpërblimit të dëmit edhe kur
numri minimal i udhëtarëve i parashikuar në vërtetimin mbi udhëtimin nuk është grumbulluar me konditë
që për ketë rrethanë udhëtari të jetë njoftuar brenda afatit të caktuar që nuk mund të jetë më i shkurtër
se pesë ditë para ditës kur udhëtimi është dashur të fillonte.
3. Në rastin e heqjes dorë nga kontrata para zbatimit të saj, organizatori duhet të kthejë në tërësi atë që
ka marrë nga udhëtari.
4. Në qoftë se organizatori ka hequr dorë nga kontrata gjatë kohës së zbatimit të saj ka të drejtë të
marrë shpërblim të drejtë për shërbimet e realizuara të kontraktuara, kurse ka për detyrë të marrë të
gjitha masat e domosdoshme për ruajtjen e interesave të udhëtarit.', 'da7f28c2d19ff3eb937f03adaeb61be61e418079fc7095aca13f8d55aff2a26a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":191,"pageEnd":192,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (899, '900', 'Ndryshimet në programin e udhëtimit', '1-5', 'Ligji 04/L-077
Neni 900 - Ndryshimet në programin e udhëtimit

1. Ndryshimet në programin e udhëtimit mund të behën vetëm në qoftë se janë shkaktuar nga rrethanat
e jashtëzakonshme që organizatori i udhëtimit nuk ka mundur t''i parashikojë t''i shmangë ose t''i
mënjanojë.
2. Shpenzimet që janë krijuar për shkak të ndryshimit të programit i përballon organizatori i udhëtimit,
ndërsa pakësimi i shpenzimeve shkon në dobi të udhëtarit.
3. Zëvendësimi i strehimit të kontraktuar mund të bëhet vetëm me përdorimin e objektit të së njëjtës
kategori, apo në ngarkim të organizatorit me përdorimin e objektit të kategorisë më të lartë dhe në
vendin e kontraktuar të strehimit.
4. Në qoftë se në programin e udhëtimit janë bërë ndryshime esenciale pa ndonjë shkak të arsyeshëm
organizatori i udhëtimit duhet të kthejë tërësisht atë që ka marrë nga udhëtari i cili për këtë arsye ka
hequr dorë nga udhëtimi.
5. Në qoftë se janë bërë ndryshime esenciale në programin gjatë kohës së zbatimit të kontratës,
udhëtari në rast të heqjes dorë përballon vetëm shpenzimet efektive të shërbimeve të realizuara.', '0983be1237faf2194dce5cd0da9f72f2398dad9101f15741f1704d440394eb22', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":192,"pageEnd":192,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
