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
  (900, '901', 'Nocioni', null, 'Ligji 04/L-077
Neni 901 - Nocioni

Me kontratën ndërmjetësuese për udhëtimin, ndërmjetësuesi detyrohet që në emër dhe për llogari të
udhëtarit, të lidhë qoftë kontratën për organizimin e udhëtimit qoftë edhe kontratën për kryerjen e një
ose të disa shërbimeve të veçanta, që bëjnë të mundur realizimin e ndonjë udhëtimi ose qëndrimin,
kurse udhëtari detyrohet të paguajë për këtë shpërblim.', '24fda746209b9dd8fa9c1877053daa4a8b7b9d057363826bd08fdf3ad1f5c74d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":192,"pageEnd":192,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (901, '902', 'Detyrimi i dhënies së vërtetimit', '1-3', 'Ligji 04/L-077
Neni 902 - Detyrimi i dhënies së vërtetimit

1. Kur me kontratën ndërmjetësuese për udhëtimin merret përsipër detyrimi i lidhjes së kontratës për
organizimin e udhëtimit, ndërmjetësuesi ka për detyrë që me rastin e kontraktimit të lëshojë vërtetimin
për udhëtimin, që përpos të dhënave të cilat kanë të bëjnë me vet udhëtimin, shenjën dhe adresën e
organizatorit të udhëtimit, duhet të përmbajë shenjën dhe adresën e ndërmjetësuesit, si dhe të dhënat
që tregojnë se ai paraqitet në këtë status.
2. Në qoftë se në vërtetimin për udhëtimin nuk e shënon statusin e ndërmjetësuesit, ndërmjetësuesi në
organizimin e udhëtimit konsiderohet si organizator i udhëtimit.
3. Në rastin kur kontrata ndërmjetësuese për udhëtimin ka të bëjë me lidhjen e kontratës për ndonjë
shërbim të veçantë, ndërmjetësuesi ka për detyrë të lëshojë vërtetimin që ka të bëjë me këtë shërbim
duke theksuar shumën që paguhet për këtë shërbim.', '7502dc94872063a0fa5f3060639b3b47844cc62758e39319c86e039dc75e382e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":192,"pageEnd":192,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (902, '903', 'Veprimi sipas udhëzimeve të udhëtarit', '1-2', 'Ligji 04/L-077
Neni 903 - Veprimi sipas udhëzimeve të udhëtarit

1. Ndërmjetësuesi ka për detyrë të veprojë sipas udhëzimeve që ia ka dhënë në kohë udhëtari, në qoftë
se ato janë në pajtim me kontratën, me ushtrimin e veprimtarisë së rëndomtë të ndërmjetësuesit dhe
me interesat e udhëtarëve tjerë.
2. Në qoftë se udhëtari nuk jep udhëzime të nevojshme, ndërmjetësuesi ka për detyrë të punojë sipas
mënyrës që në rrethanat konkrete është më e përshtatshme për udhëtarin.', '68bd6a9a9362731791220531cc714af265c55758c420061af711dd555f007fd1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":193,"pageEnd":193,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (903, '904', 'Zgjedhja e personave të tretë', null, 'Ligji 04/L-077
Neni 904 - Zgjedhja e personave të tretë

Ndërmjetësuesi është i detyruar që me ndërgjegje ta zgjedhë personin e tretë, i cili duhet t’i kryejë
shërbimet e parapara me kontratë dhe i përgjigjet udhëtarit për zgjedhjen e tyre.', 'f9c72794cd9aa2446b160070247d172abf1c778be550906faf9a30686d917960', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":193,"pageEnd":193,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (904, '905', 'Zbatimi përkatës i dispozitave të kontratës për organizimin e udhëtimit', null, 'Ligji 04/L-077
Neni 905 - Zbatimi përkatës i dispozitave të kontratës për organizimin e udhëtimit

Dispozitat e këtij ligji që kanë të bëjnë me kontratën për organizimin e udhëtimit, zbatohen
përshtatshmërisht për kontratën ndërmjetësuese për udhëtimin, në qoftë se me dispozitat e kësaj pjese
nuk është caktuar ndryshe.', 'd6d5ce57d99e2bf22764cd72b4b1c66dae56aba662f9f24339fd10e83cc52cb4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":193,"pageEnd":193,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (905, '906', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 906 - Nocioni

1. Me kontratën për alotmanin detyrohet hotelieri që gjatë kohës së caktuar t’i vë në dispozicion
agjencisë turistike një numër shtretërish të caktuar në objektin e caktuar, t’u japë shërbime hoteliere
personave që i dërgon agjencia dhe t’i paguajë provizion të caktuar, kurse kjo detyrohet që të përpiqet
t’i plotësojë, përkatësisht të njoftojë brenda afateve të caktuara se kjo nuk është e mundur, si dhe të
paguajë çmimin e shërbimeve të bëra në qoftë se ka shfrytëzuar angazhimin e kapaciteteve të hotelit.
2. Në qoftë se me kontratë nuk është caktuar ndryshe, konsiderohet se kapacitetet e strehimit të
hotelierisë janë vënë në dispozicion për një (1) vit.', '817cb510d45dddf54fb62e0fd826b6107752080b7f637e040c8be9f9b55ad030', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":193,"pageEnd":193,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (906, '907', 'Forma e kontratës', null, 'Ligji 04/L-077
Neni 907 - Forma e kontratës

Kontrata për alotmanin duhet të lidhet në formën me shkrim.', 'ed8b88ec0ba66c9d45d5e10adfbbfafa5575e78aeba8d9757c34d9d197d7ed66', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":193,"pageEnd":193,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (907, '908', 'Detyrimet e njoftimit', '1-4', 'Ligji 04/L-077
Neni 908 - Detyrimet e njoftimit

1. Agjencia turistike ka për detyrë ta njoftojë hotelierin për procesin e mbushjes së kapaciteteve të
strehimit.
2. Në qoftë se nuk ka mundësi t’i plotësojë të gjitha kapacitetet e rezervuara të strehimit, agjencia
turistike ka për detyrë që brenda afateve të kontraktuara ose të rëndomta ta njoftojë hotelierin për këtë
dhe t’i dërgojë listën e mysafirëve dhe në njoftim të caktojë afatin, deri te i cili hotelieri mund të
disponojë lirisht me kapacitetet e rezervuara.
3. Kapacitetet e hotelierisë që në listën e mysafirëve nuk janë theksuar si të plotësuara, konsiderohen
të lira, që nga dita e marrjes së kësaj liste nga ana e hotelit për periudhën me të cilën ka të bëjë lista.
4. Pasi të ketë kaluar ky afat, agjencia turistike fiton përsëri të drejtën e plotësimit të kapaciteteve të
rezervuara të strehimit.', 'a82b9ccd8b64fd3a3a96c35f5831eada56bcefb87a613cb0d6a351420164e565', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":194,"pageEnd":194,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (908, '909', 'Detyrimi i respektimit të çmimeve të kontraktuara', null, 'Ligji 04/L-077
Neni 909 - Detyrimi i respektimit të çmimeve të kontraktuara

Agjencia turistike nuk mund t’u llogarisë personave që i dërgon në objektin e hotelierisë çmime më të
larta për shërbimet e hotelierisë nga ato që janë parashikuar me kontratën mbi alotmanin ose me listën
e çmimeve të hotelerisë.', '6e5e1ba447721bb7dccbc30ff39a216e8a5d544c725c965e3a5e18aaac816f95', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":194,"pageEnd":194,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (909, '910', 'Detyrimi i pagimit të shërbimeve të hotelierisë', '1-2', 'Ligji 04/L-077
Neni 910 - Detyrimi i pagimit të shërbimeve të hotelierisë

1. Në qoftë se me kontratë nuk është caktuar ndryshe, çmimin e shërbimeve të dhëna të hotelierisë ia
paguan hotelierit agjencia turistike pas kryerjes së shërbimeve.
2. Hotelieri ka të drejtë të kërkojë pagimin e paradhënieve përkatëse.', 'e913596ead794afbfc87c4b2011ba52651519dfa56de132edf02c454f4a71890', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":194,"pageEnd":194,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (910, '911', 'Detyrimi i dhënies së dokumentit të veçantë me shkrim', '1-4', 'Ligji 04/L-077
Neni 911 - Detyrimi i dhënies së dokumentit të veçantë me shkrim

1. Agjencia turistike ka për detyrë që personave të cilët i dërgon në bazë të kontratës për alotmanin t’u
japë dokumentin e veçantë me shkrim.
2. Dokumenti i veçantë me shkrim është në emër ose në grupin e caktuar, është i pabartshëm dhe
përmban urdhërin drejtuar hotelierit që t’i japë shërbimet të cilat janë theksuar në të.
3. Dokumenti i veçantë me shkrim shërben si provë se personi është klient i agjencisë turistike që ka
lidhur kontratën me hotelierin për alotmanin.
4. Në bazë të dokumentit të veçantë me shkrim bëhet përllogaritja e kërkesave reciproke midis
agjencisë turistike dh hotelierit.', 'ee8d9310585f9f6f8d6feeaf0d952e53bb65dd17b194debbdb8e95ea54aaeff2', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":194,"pageEnd":194,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (911, '912', 'Detyrimi i vënies në përdorim të kapaciteteve strehimi të kontraktuara', '1-2', 'Ligji 04/L-077
Neni 912 - Detyrimi i vënies në përdorim të kapaciteteve strehimi të kontraktuara

1. Hotelieri merr përsipër detyrimin definitiv dhe të parevokueshëm që brenda afatit të caktuar të vejë
në përdorim numrin e kontraktuar të shtretërve dhe t’u japë personave që i dërgon agjencia turistike
shërbime të theksuara në dokumentin e veçantë me shkrim.
2. Hotelieri nuk mund të kontraktojë me agjencinë tjetër turistike angazhimin e kapaciteteve që janë
rezervuar në bazë të kontratës mbi alotmanin.', '8008c0bef77bdc68ceee17a5e4f5d75142baa68d3a561843636ecef2440a6c89', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":195,"pageEnd":195,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (912, '913', 'Detyrimi për trajtim të barabartë', null, 'Ligji 04/L-077
Neni 913 - Detyrimi për trajtim të barabartë

Hotelieri duhet t’u ofron shërbime të njëjta personave që dërgohen nga agjencia e turizmit, sikurse
personave me të cilët ka lidhur kontratë direkte mbi shërbimet e hotelierisë.', '288a1761e5bbeb6779676269dbc88180e199e56b7dcacf22e7f65f0662b2e289', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":195,"pageEnd":195,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (913, '914', 'Detyrimi i hotelierit që të mos i ndryshojë çmimet e shërbimeve', '1-4', 'Ligji 04/L-077
Neni 914 - Detyrimi i hotelierit që të mos i ndryshojë çmimet e shërbimeve

1. Hotelieri nuk mund t’i ndryshojë çmimet e kontraktuara, në qoftë se për të nuk e njofton agjencinë
turistike të paktën gjashtë muaj përpara, përveç në rastin e ndryshimit të kursit të këmbimit të valutave
që ndikojnë në çmimin e kontraktuar.
2. Çmimet e reja mund të zbatohen pasi të ketë kaluar një muaj nga dërgimi i tyre agjencisë turistike.
3. Çmimet e reja nuk do të zbatohen ndaj shërbimeve për të cilat është dërguar lista e klientëve.
4. Sidoqoftë, ndryshimet e çmimit nuk kanë efekt ndaj rezervimit që e ka konfirmuar hotelieri.', 'ee543305473226866d0998f38b5c021db798374d5b23a5d7aa0e8429cb3135a0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":195,"pageEnd":195,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (914, '915', 'Detyrimi i pagimit të provizionit', '1-3', 'Ligji 04/L-077
Neni 915 - Detyrimi i pagimit të provizionit

1. Hotelieri ka për detyrë që agjencisë turistike t’i paguajë provizionin për qarkullimin e realizuar në
bazë të kontratës për alotmanin.
2. Provizioni caktohet në përqindje prej çmimit të shërbimeve hoteliere të kryera.
3. Në qoftë se përqindja e provizionit nuk është caktuar me kontratë, agjencisë turistike i takon
provizioni i caktuar me kushtet e përgjithshme të ushtrimit të veprimtarisë së agjencisë turistike, ose në
qoftë se këto nuk ekzistojnë sipas praktikës afariste.', 'd62b581a6019a1b7dd4156a2ee400f2d2d6d9d149173e90b5d575772eadb0685', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":195,"pageEnd":195,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (915, '916', 'E drejta për të hequr dorë nga kapacitetet e angazhuara të strehimit', '1-4', 'Ligji 04/L-077
Neni 916 - E drejta për të hequr dorë nga kapacitetet e angazhuara të strehimit

1. Agjencia turistike mund të heqë dorë përkohësisht nga shfrytëzimi i kapaciteteve të angazhuara të
strehimit dhe me këtë të mos e zgjidhë kontratën për alotmanin dhe as të krijojë për vete detyrimin e
shpërblimit të dëmit hotelierit, në qoftë se në afatin e kontraktuar dërgon njoftimin për heqjen dorë nga
shfrytëzimi.
2. Në qoftë se afati i njoftimit mbi heqjen dorë nuk është caktuar me kontratë, përcaktohen në bazë të
dokeve afariste në hotelieri.
3. Kur njoftimi mbi heqjen dorë nuk është dërguar në afatin e parashikuar, hotelieri ka të drejtë në
shpërblimin e dëmit.
4. Agjensia turistike mund të heqë dorë nga kontrata tërësisht pa detyrimin e shpërblimit të dëmit në
qoftë se njoftimin mbi heqjen dorë e dërgon brenda afatit të kontraktuar.', '33edab09c1f432ba635e7ffb058d7f59d18d69b6fee6bb913466c90b9657fd1d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":195,"pageEnd":196,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (916, '917', null, null, 'Ligji 04/L-077
Neni 917

Detyrimi i agjencisë turistike për t’i plotësuar kapacitetet e angazhuara
1. Me kontratën për alotmanin mund të parashihet detyrimi i veçantë i agjensisë turistike për t’i
plotësuar kapacitetet e angazhuara të hotelierisë.
2. Në qoftë se në këtë rast nuk i plotëson kapacitetet e angazhuara të hotelierësë, agjencia turistike ka
për detyrë t’i paguajë hotelierit shpërblimin për çdo shtrat të pashfrytëzuar dhe për çdo ditë.
3. Agjencia turistike atëherë nuk ka të drejtë që me anë të njoftimit të bërë në kohën e duhur ta
denoncojë kontratën pjesërisht ose tërësisht.', '8fafb7f695e9a53160773a5e8032e55fa57acf2f3552797e813537880d428a7a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":196,"pageEnd":196,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (917, '918', 'Nocioni', null, 'Ligji 04/L-077
Neni 918 - Nocioni

Me kontratën për sigurimin detyrohet kontraktuesi i sigurimit që mbi parimet e reciprocitetit dhe
solidaritetit të paguajë një shumë të caktuar shoqërisë së sigurimit (siguruesi), kurse shoqëria detyrohet
që, nëse ndodh ngjarja që paraqet rastin e siguruar, t’i paguajë siguruesit apo ndonjë personi të tretë
shpërblimin, përkatësisht shumën e kontraktuar ose të kryejë diçka tjetër.', '172d1445f48d46823728dba159b83e99a97fbc9a0c589e0762e84eb3e6fda378', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":196,"pageEnd":196,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (918, '919', 'Rasti i siguruar', '1-3', 'Ligji 04/L-077
Neni 919 - Rasti i siguruar

1. Ngjarja,duke marrë parasysh se për cilën kontraktohet sigurimi (rasti i siguruar) duhet të jetë i
ardhshëm, e pasigurt dhe e pavarur nga vullneti ekskluziv i kontraktuesve.
2. Kontrata e sigurimit është e pavlefshme, në qoftë se në momentin e lidhjes së saj ka ndodhur rasti i
siguruar, apo në qoftë se ky ka qenë në krijim e sipër, apo ka qenë e sigurt se do të vijë, ose po qe se
që atëherë ka pushuar mundësia që ai të ndodhë.
3. Në qoftë se është kontraktuar, se me sigurimin do të përfshihet periudha e caktuar që vjen para
lidhjes së kontratës, kontrata do të jetë nule vetëm në qoftë se në momentin e lidhjes së saj pala e
interesuar e ka ditur se rasti i siguruar ka ndodhur, përkatësisht se që atëherë është shuar mundësia që
ai të ndodhë.', '601cdc2a99e54e468532313192824cbfb66dff487e5f21c7b803d7b7e0ccac34', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":196,"pageEnd":197,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (919, '920', 'Përjashtimi i disa sigurimeve', '1-2', 'Ligji 04/L-077
Neni 920 - Përjashtimi i disa sigurimeve

1. Dispozitat e kësaj pjese nuk do të zbatohen në sigurimet e lundrimit, si dhe në sigurimet të tjera për
të cilat zbatohen rregullat e sigurimit për lundrimin.
2. Dispozitat e përmendura nuk do të zbatohen as në sigurimin e kërkesave, as në marrëdhëniet e
risigurimit.', '4a688530e22692346601d49f0e369fc38ebe4fab9e1368852b8a9c8fa4f92841', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":197,"pageEnd":197,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (920, '921', 'Shmangia nga dispozitat e kësaj pjese', '1-2', 'Ligji 04/L-077
Neni 921 - Shmangia nga dispozitat e kësaj pjese

1. Me kontratë mund të shmanget vetëm nga ato dispozita të kësaj pjese, në të cilat kjo shmangie
është lejuar shprehimisht, si dhe ato që u ofrojnë kontraktuesve mundësinë që të veprojnë siç
dëshirojnë.
2. Shmangia nga dispozitat e tjera, po qe se nuk është e ndaluar me këtë ose me ndonjë ligj tjetër,
lejohet vetëm në qoftë se është në interesin e padyshimtë të të siguruarve.', '5936ff3dee399467258f77598bec6ea41df9f4c04494281be7d519141ea1ecc6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":197,"pageEnd":197,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (921, '922', 'Kur është e lidhur kontrata', '1-4', 'Ligji 04/L-077
Neni 922 - Kur është e lidhur kontrata

1. Kontrata për sigurimin është e lidhur kur kontraktuesit nënshkruajnë polisën e sigurimit ose listën e
mbulesës.
2. Oferta me shkrim që i është bërë të siguruarit për lidhjen e kontratës për sigurimin detyron ofertuesin,
në qoftë se ky nuk ka caktuar ndonjë afat më të shkurtër, për një kohë prej tetë ditësh nga data kur
oferta t’i ketë arritur siguruesit, e në qoftë se nevojitet kontrolli mjekësor, atëherë për një kohë prej
tridhjetë ditësh.
3. Në qoftë se siguruesi në këtë afat refuzon ofertën e cila nuk largohet nga kushtet në të cilat ai
ushtron sigurimin e propozuar, do të konsiderohet se e ka pranuar ofertën dhe se kontrata është lidhur.
4. Në këtë rast kontrata quhet e lidhur kur oferta t’i ketë arritur siguruesit.', '6746e90e58db644a8a7dafbd4f528e63990c0cead543f74e923799e962d2e395', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":197,"pageEnd":197,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (922, '923', 'Polica dhe lista e mbulesës', '1-6', 'Ligji 04/L-077
Neni 923 - Polica dhe lista e mbulesës

1. Në policë duhet të shkruhen palët kontraktuese, sendi i siguruar, respektivisht personi i siguruar,
rreziku i përfshirë nga sigurimi, kohëzgjatja e sigurimit dhe periudha e depozitës, shuma e sigurimit ose
se sigurimi është i pakufizuar, premia ose kontributi, data e dhënies së policës dhe nënshkrimet e
palëve kontraktuese.
2. Lista e mbulesës në të cilën është përshkruar pjesa esenciale e kontratës mundet të zëvendësojë
përkohësisht policën e sigurimit.
3. Në qoftë se kushtet e përgjithshme dhe të veçanta të sigurimit nuk janë të shtypura në vet policën,
siguruesi është i detyruar ta paralajmërojë kontraktuesin e sigurimit se kushtet e tilla janë pjesë
përbërëse të kontratës dhe t’i dorëzojë tekstin e tyre.
4. Zbatimi i detyrimeve nga paragrafi paraprak duhet të konstatohet në policë.
5. Në rastin e mospajtimit të ndonjë dispozite të kushteve të përgjithshme ose të veçanta dhe të ndonjë
dispozite të policës do të aplikohet dispozita e policës, e në rastin e mospajtimit të ndonjë dispozite të
shtypur në policë e të ndonjë dispozite të saj të dorëshkrimit, do të vihet në zbatim kjo e fundit.
6. Sipas marrëveshjes së kontraktuesve, polica mund të mbajë emrin e caktuar, të jetë sipas urdhërit
ose sipas prurësit.', '01b37ba4c8419c3e204a3886a7833e02841b18bc918ea903738a395016742302', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":197,"pageEnd":198,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (923, '924', 'Sigurimi pa polisë', null, 'Ligji 04/L-077
Neni 924 - Sigurimi pa polisë

Me kushtet e sigurimit mund të parashikohen rastet nën të cilat marrëdhënia kontraktuese nga sigurimi
krijohet nga vetë pagimi i premisë.', '34cebde86ed839d132bd4b5164bc37672331d72f99e01b31d683c3292a32ccd8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":198,"pageEnd":198,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (924, '925', 'Lidhja e kontratës në emër të tjetrit pa autorizim', '1-4', 'Ligji 04/L-077
Neni 925 - Lidhja e kontratës në emër të tjetrit pa autorizim

1. Kush lidh kontratën e sigurimit në emër të tjetrit pa autorizim të tij i përgjigjet siguruesit për detyrimet
nga kontrata, gjersa ky në emër të të cilit është lidhur kontrata të mos e miratojë.
2. I interesuari mund të lejojë kontratën edhe pasi të ketë ndodhur rasti i siguruar.
3. Në qoftë se pëlqimi është refuzuar, kontraktuesi i sigurimit ka borxh preminë për periudhën e
sigurimit në të cilën siguruesi është njoftuar për refuzimin e pëlqimit.
4. Punëdrejtuesi pa porosi, i cili e ka njoftuar siguruesin se paraqitet pa autorizim në emër dhe për
llogari të tjetrit nuk përgjigjet për detyrimet nga sigurimi.', '24b177efb24bbb3a99af47c579b91538599721c7c010e392c01204d83f95f19b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":198,"pageEnd":198,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (925, '926', 'Sigurimi për llogari të huaj ose për llogari të të cilit i përket', '1-4', 'Ligji 04/L-077
Neni 926 - Sigurimi për llogari të huaj ose për llogari të të cilit i përket

1. Në rastin e sigurimit për llogari të huaj ose për llogari të të cilit i përket, detyrimet e pagimit të
premisë dhe detyrimet e tjera nga kontrata ka për detyrë t’i zbatojë kontraktuesi i sigurimit, por ky nuk
mund të ushtrojë të drejtat nga sigurimi as edhe kur mban polisën pa pëlqimin e personit, interesi i të
cilit është siguruar dhe të cilit ato i përkasin.
2. Kontraktuesi i sigurimit nuk ka për detyrë t’i dorëzojë polisën personit të interesuar gjersa të mos i
shpërblehen premitë që i ka paguar siguruesit, si dhe shpenzimet e kontratës.
3. Kontraktuesi i sigurimit ka të drejtë arkëtimi prioritar të këtyre kërkesave nga shpërblimi që është
borxh, si dhe të drejtën për të kërkuar pagimin e tyre të drejtpërdrejt nga siguruesi.
4. Siguruesi mund t’i paraqesë secilit shfrytëzues të sigurimit për llogarinë e huaj të gjitha
kundërshtimet, të cilat në bazë të kontratës i ka ndaj kontraktuesit të sigurimit.', '4db9b6f5aa8f1faf440ded4fe19c687011f25876ea991cda5bd672b89eef7a64', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":198,"pageEnd":198,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (926, '927', 'Përfaqësuesi i sigurimit', '1-2', 'Ligji 04/L-077
Neni 927 - Përfaqësuesi i sigurimit

1. Kur siguruesi autorizon ndokënd që ta përfaqësojë, ndërsa nuk cakton vëllimin e autorizimeve të tij,
përfaqësuesi është i autorizuar që në emër dhe për llogari të siguruesit të lidhë kontrata për sigurimin,
të kontraktojë ndryshimet e kontratës ose zgjatjen e afatit të tyre, të lëshojë polisë sigurimi, të arkëtojë
premitë dhe të pranojë deklarata të drejtuara siguruesit.
2. Në qoftë se siguruesi i ka kufizuar autorizimet e përfaqësuesit të vet, ndërsa kjo për kontraktuesin e
sigurimit nuk ka qenë e njohur, konsiderohet sikur këto kufizime të mos kenë ekzistuar.', '2aaf2430ed91911be5489d82c25cf1aff4a47a989592d6ab06623072906cb305', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":199,"pageEnd":199,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (927, '928', 'Detyra e lajmërimit', null, 'Ligji 04/L-077
Neni 928 - Detyra e lajmërimit

Kontraktuesi i sigurimit ka për detyrë t’i lajmërojë siguruesit kur lidhë kontratën të gjitha rrethanat e
rëndësishme të cilat janë të rëndësishme për vlerësimin e rrezikut, të cilat i janë të njohura ose nuk
kanë mundur të mbeten të panjohura.', '5b20666bb9ae75d7dc0abbf213091968882f081742253b13930ba04fda2d1472', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":199,"pageEnd":199,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (928, '929', 'Lajmërimi i pasaktë i bërë me dashje ose lënia në heshtje', '1-3', 'Ligji 04/L-077
Neni 929 - Lajmërimi i pasaktë i bërë me dashje ose lënia në heshtje

1. Në qoftë se kontraktuesi i sigurimit ka bërë me dashje lajmërimin e pasaktë ose me dashje e ka lënë
në heshtje ndonjë rrethanë të një karakteri të tillë, sa që siguruesi nuk do të lidhte kontratën po të kishte
ditur për gjendjen e vërtetë, siguruesi mund të kërkojë anulimin e kontratës.
2. Në rastin e zgjidhjes të kontratës për shkaqe të cekura në paragrafin paraprak, siguruesi mban për
vete premitë e arkëtuara dhe ka të drejtë të kërkojë pagimin e premisë për periudhën e sigurimit në të
cilën ka kërkuar anulimin e kontratës.
3. Siguruesi duhet të paraqesë padi për anulimin e kontratës mbi sigurimin në afat prej tre muajsh nga
koha kur ka marrë njohuri për pasaktësinë e lajmërimit ose të lënies në heshtje.', 'd06e65a00a8f2cd34e65d0f2d68066b503f180e53da40fd54ae3c3e68a26f48b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":199,"pageEnd":199,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (929, '930', 'Pasaktësia e paparamenduar ose lajmërimi jo i plotë', '1-4', 'Ligji 04/L-077
Neni 930 - Pasaktësia e paparamenduar ose lajmërimi jo i plotë

1. Në qoftë se kontraktuesi i sigurimit ka bërë lajmërim të pasaktë ose ka bërë lëshim të jap njoftim që
ka për detyrë, ndërsa këtë nuk e ka bërë me dashje, siguruesi mundet sipas dëshirës së vet brenda një
muaji nga data kur të ketë mësuar për pasaktësinë ose për lajmërimin jo të plotë të lajmërimit, të
deklarojë se e zgjidhë kontratën ose të propozojë shtimin e premisë në përpjesëtim me rrezikun më të
madh.
2. Kontrata në këtë rast shuhet pasi të kenë kaluar katërmbëdhjetë (14) ditë që kur siguruesi t’ia ketë
komunikuar deklaratën e vet mbi zgjidhjen kontraktuesit të sigurimit, e në rastin e propozimit të
siguruesit që premia të shtohet, zgjidhja shkaktohet sipas ligjit, në qoftë se kontraktuesi i sigurimit nuk e
aprovon propozimin brenda katërmbëdhjetë ditësh nga koha që kur e ka marrë.
3. Në rastin e zgjidhjes, siguruesi ka për detyrë ta kthejë pjesën e premisë, e cila i përket kohës deri në
fund të periudhës së sigurimit.
4. Në qoftë se rasti i siguruar ka ndodhur para se të ishte vërtetuar pasaktësia ose lajmërimi jo i plotë,
apo pas kësaj, por para zgjidhjes së kontratës, përkatësisht para arritjes së marrëveshjes për shtimin e
premisë, shpërblimi zvogëlohet në përpjesëtim ndërmjet shkallëve të premive të paguara dhe shkallës
së premive që do të duheshin të paguhen në bazë të rrezikut faktik.', 'ef0ec2de153b48c3ddff1b95e5a1117a51ccfa5e3ba76cf1c71ec7c9dbb9c31f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":199,"pageEnd":200,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (930, '931', 'Zgjerimi i fushës së zbatimit të neneve paraprake', null, 'Ligji 04/L-077
Neni 931 - Zgjerimi i fushës së zbatimit të neneve paraprake

Dispozitat e neneve paraprake për pasojat e lajmërimit të pasaktë ose të lënies në heshtje të
rrethanave me rëndësi për çmuarjen e rrezikut zbatohen edhe në rastet e sigurimit të kontraktuar në
emër dhe për llogari të tjetrit, ose në dobi të të tretit, ose për llogari të huaj, ose për llogari të cilës i
përket, në qoftë se këta persona kanë ditur për pasaktësinë e lajmërimit ose për lënien në heshtje të
rrethanave me rëndësi për çmuarjen e rrezikut.', 'ffc10b315c94959ff2b69aae4e47f9c977083c528cdcd10801098315ad428c44', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":200,"pageEnd":200,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (931, '932', 'Rastet në të cilat siguruesi nuk mund të thirret në pasaktësinë ose lajmërimin jo të plotë', '1-2', 'Ligji 04/L-077
Neni 932 - Rastet në të cilat siguruesi nuk mund të thirret në pasaktësinë ose lajmërimin jo të plotë

1. Siguruesi, i cili në çastin e lidhjes së kontratës ka ditur ose nuk ka mundur të mos ketë qenë në dijeni
për rrethanat që kanë rëndësi për vlerësimin e rrezikut, e të cilat kontraktuesi i sigurimit i ka lajmëruar
në mënyrë jo të saktë ose i ka lënë në heshtje, nuk mund të thirret në pasaktësinë e lajmërimit ose
lënien në heshtje.
2. E njëjta gjë vlen në rastin kur siguruesi të ketë mësuar për këto rrethana gjatë kohës së sigurimit, e
që nuk i ka shfrytëzuar autorizimet ligjore.', '7c3970d13e5ce1074ade30c2b5bb2ae0bcbc56b1ade18a215ac0f36bb287adf0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":200,"pageEnd":200,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (932, '933', 'Detyra e pagimit dhe e marrjes së premisë', '1-3', 'Ligji 04/L-077
Neni 933 - Detyra e pagimit dhe e marrjes së premisë

1. Kontraktuesi i sigurimit ka për detyrë të paguajë preminë e sigurimit, por siguruesi ka për detyrë të
pranojë pagimin e premisë prej secilit person që ka interes juridik që ajo të paguhet.
2. Premia paguhet në afatet e kontraktuara, e në qoftë se duhet të paguhet përnjëherë, atëherë
paguhet me rastin e lidhjes së kontratës.
3. Vendi i pagimit të premisë është vendi në të cilin kontraktuesi i sigurimit ka selinë ose vendbanimin e
vet, në qoftë se në kontratë nuk është caktuar ndonjë vend tjetër.', 'a205ea6efaf2e3e0e2ffbaf51e58940ffc0cddb160c5283302c52dddffe207eb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":200,"pageEnd":200,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (933, '934', 'Pasojat e mospagimit të premisë', '1-6', 'Ligji 04/L-077
Neni 934 - Pasojat e mospagimit të premisë

1. Në qoftë se është kontraktuar që premia të paguhet me rastin e lidhjes së kontratës, detyrimi i
siguruesit për të paguar shpërblimin ose shumën e caktuar me kontratë fillon ditën e ardhshme nga
data e pagimit të premisë.
2. Në qoftë se është kontraktuar që premia të paguhet pas lidhjes së kontratës, detyrimi i siguruesit për
të paguar shpërblimin ose shumën e përcaktuar me kontratë fillon nga data e caktuar me kontratë si
ditë e fillimit të sigurimit.
3. Në qoftë se kontraktuesi i sigurimit nuk e paguan preminë që ka arritur për pagesë pas lidhjes së
kontratës deri në skadimin e saj, dhe as që e bën këtë ndonjë person i interesuar, kontrata për
sigurimin shuhet sipas ligjit, në bazë të drejtës pas skadimit të kohës prej tridhjetë ditësh nga data kur
kontraktuesit të sigurimit i është dorëzuar letra e porositur e siguruesit me njoftimin për arritjen për
pagesë të premisë, por me kusht që ky afat të mos mund të skadojë para se të kenë kaluar tridhjetë
ditë nga data e arritjes për pagesë të premisë.
4. Pas kalimit të afatit kohorë të përcaktuar në paragrafin e tretë të këtij neni, në qoftë se kontraktuesi i
sigurimit është në vonesë për të paguar preminë që ka arritur për pagesë pas lidhjes së kontratës,
siguruesi mundet të denoncojë kontratën e sigurimit pa paralajmërim, në atë mënyrë që denoncimi i
kontratës është efektiv me kalimin e afatit kohorë të përcaktuar në paragrafin e tretë të këtij neni dhe
mbarimi i mbulesës së sigurimit në qoftë se kontraktuesit të sigurimit i është dorëzuar letra e porositur e
siguruesit me njoftimin për mospagesën e pagesës së arritur dhe se mbulesa e sigurimit do të mbarojë.
5. Në qoftë se kontraktuesi i sigurimit paguan preminë pas afatit të specifikuar në paragrafin 3. të këtij
neni, por brenda një (1) viti që kur premia kishte arritur për pagesë, siguruesi do të ketë për detyrim
pagimin e shumës së siguruar, gjegjësisht shpërblimin e dëmit në rast të paraqitjes së rastit të siguruar
që nga mesnata pasi që premia dhe kamatëvonesa të jetë paguar.
6. Dispozitat e këtij neni nuk zbatohen në sigurimin e jetës apo të shëndetit.', 'ae4d236adaa3e7d1ec84660d56154873bc1c095eda8d1bb5f7be6fe68aa9257f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":200,"pageEnd":201,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (934, '935', 'Rritja e rrezikut', '1-6', 'Ligji 04/L-077
Neni 935 - Rritja e rrezikut

1. Kontraktuesi i sigurimit ka për detyrë, që kur është fjala për sigurimin e pasurisë, ta njoftojë
siguruesin për çdo ndryshim të rrethanës që mund të ketë rëndësi për vlerësimin e rrezikut, e kur është
fjala për sigurimin e personave, atëherë vetëm në qoftë se rreziku është shtuar për shkak se personi i
siguruar ka ndryshuar profesionin.
2. Ai ka për detyrë ta njoftojë pa vonesë siguruesin për rritjen e rrezikut, në qoftë se rritja e rrezikut ka
ndodhur pa veprimin e tij, atëherë ka për detyrë ta njoftojë brenda katërmbëdhjetë (14) ditësh pasi të
ketë mësur për këtë.
3. Në qoftë se rritja e rrezikut është aq saqë siguruesi nuk do ta lidhte kontratën po të kishte ekzistuar
një gjendje e tillë në momentin e lidhjes së saj, ai mund ta zgjidhë kontratën.
4. Në qoftë se shtimi i rrezikut është aq i madh, sa që siguruesi do ta lidhte kontratën vetëm me ndonjë
premi më të madhe, po të kishte ekzistuar një gjendje e tillë në çastin e lidhjes së kontratës, ai mund t’i
propozojë kontraktuesit të sigurimit shkallën e re të premisë.
5. Në qoftë se kontraktuesi i sigurimit nuk pranon shkallën e re të premisë brenda katërmbëdhjetë (14)
ditësh nga dita e marrjes në dorëzim të propozimit të shkallës së re, kontrata shuhet në bazë të ligjit.
6. Kontrata mbetet në fuqi dhe siguruesi nuk mund t’i shfrytëzojë më autorizimet që t’i propozojë
kontraktuesit të sigurimit shkallën e re të premisë ose ta zgjidhë kontratën në qoftë se nuk i shfrytëzon
këto autorizime brenda një (1) muaji nga data kur të ketë mësuar në cilëndo mënyrë qoftë për rritjen e
rrezikut, apo në qoftë se edhe para skadimit të këtij afati shprehet në ndonjë mënyrë se është i pajtimit
me zgjatjen e kontratës (në qoftë se pranon preminë, paguan shpërblimin për rastin e siguruar që ka
ndodhur pas kësaj rritje e të ngjashme).', '73ff6cc65cc810f8df982c3ab2c45d0d1a042be7f31c213978e337b33eb84399', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":201,"pageEnd":201,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (935, '936', 'Kur rasti i siguruar ndodh në ndërkohë', null, 'Ligji 04/L-077
Neni 936 - Kur rasti i siguruar ndodh në ndërkohë

Në qoftë se rasti i siguruar ka ndodhur para se siguruesi të jetë njoftuar për shtimin e rrezikut ose pasi
të jetë njoftuar për shtimin e rrezikut, por para se ta ketë zgjidhur kontratën ose të ketë arritur
marrëveshjen me kontraktuesin e sigurimit për rritjen e premisë, shpërblimi zvogëlohet në përpjesëtim
ndërmjet shkallës së premive të paguara dhe premive që do të duheshin të paguhen sipas rritjes së
rrezikut.', 'ab154b5fb3a37b4af5669bacb7cdd94af6fda4f899791d593865abbe737706c7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":201,"pageEnd":202,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (936, '937', 'Zvogëlimi i rrezikut', '1-2', 'Ligji 04/L-077
Neni 937 - Zvogëlimi i rrezikut

1. Në rastin kur pas lidhjes së kontratës për sigurimin të ketë ndodhur zvogëlimi i rrezikut, kontraktuesi i
sigurimit ka të drejtë të kërkojë zvogëlimin përkatës të premisë, duke llogaritur që nga dita kur për
zvogëlimin ta ketë njoftuar siguruesin.
2. Në qoftë se siguruesi nuk është pajtuar me zvogëlimin e premisë, kontraktuesi i sigurimit mund ta
zgjidhë kontratën.', 'abb78fedd7f433b40b05972758a99a94fb85677c51923a4525443f8c413d5a6e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":202,"pageEnd":202,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (937, '938', 'Detyrimi i njoftimit për paraqitjen e rastit të sigurimit', '1-2', 'Ligji 04/L-077
Neni 938 - Detyrimi i njoftimit për paraqitjen e rastit të sigurimit

1. Kontraktuesi i sigurimit ka për detyrë, përveç në rastin e sigurimit të jetës ta njoftojë siguruesin për
paraqitjen e rastit të sigurimit jo më vonë se tri (3) ditë që kur ai vihet në dijeni për këtë.
2. Në qoftë se nuk e kryen këtë detyrim të vet brenda kohës së caktuar, ai ka për detyrë t’ia shpërblejë
siguruesit dëmin, të cilin siguruesi do ta kishte për këtë.', '1818cd12977bb5725e827c4010fa8e787dafbd88f32542a08937de875b075a17', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":202,"pageEnd":202,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (938, '939', 'Nuliteti i dispozitave për humbjen e të drejtave', null, 'Ligji 04/L-077
Neni 939 - Nuliteti i dispozitave për humbjen e të drejtave

Janë nule dispozitat e kontratës që parashikojnë humbjen e të drejtave në shpërblim ose në shumën e
sigurimit, në qoftë se i siguruari pas shkaktimit të rastit të siguruar nuk i përmbush ndonjë nga detyrimet
e parashikuara ose të kontraktuara.', 'e9551dece024b88ec1bee9399af0f3e0a1327e3ae55255edf5780914137948cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":202,"pageEnd":202,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (939, '940', 'Pagimi i shpërblimit ose i shumës së kontraktuar', '1-3', 'Ligji 04/L-077
Neni 940 - Pagimi i shpërblimit ose i shumës së kontraktuar

1. Kur paraqitet rasti i siguruar, siguruesi ka për detyrë të paguajë shpërblimin ose shumën e caktuar
me kontratë në afatin e kontraktuar, i cili nuk mund të jetë më i gjatë se katërmbëdhjetë (14) ditë, duke
llogaritur që nga data kur siguruesi të ketë marrë njoftimin se ka ndodhur rasti i siguruar.
2. Mirëpo, në qoftë se për caktimin e ekzistimit të detyrimit të siguruesit ose të shumës së tij nevojitet
një kohë, ky afat fillon të rrjedhë nga dita kur është vërtetuar ekzistimi i detyrimit të tij dhe shuma e tij.
3. Në qoftë se shuma e detyrimit të siguruesit nuk vërtetohet brenda afatit të caktuar në paragrafin 1. të
këtij neni, siguruesi ka për detyrë, me kërkesën e personit të autorizuar, ta paguajë shumën e pjesës
pakontestuese të detyrimit të vet në emër të paradhënies.', '99188a91e2f4a7362ebd1333a00d88dc1c05795a60f9c630ba36678a9793e016', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":202,"pageEnd":202,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (940, '941', 'Përjashtimi i përgjegjësisë së siguruesit në rastin e paramendimit dhe të mashtrimit', null, 'Ligji 04/L-077
Neni 941 - Përjashtimi i përgjegjësisë së siguruesit në rastin e paramendimit dhe të mashtrimit

Në qoftë se kontraktuesi i sigurimit, i siguruari ose shfrytëzuesi e ka shkaktuar rastin e siguruar me
dashje ose me mashtrim, siguruesi nuk është i detyruar të japë asgjë dhe dispozita e kundërt
kontraktuese nuk ka efekt juridik.', '0b63fc5c564bc75011db7023b0ab2c83605c2df893780c9d0d83b5f545eb3fd3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":202,"pageEnd":202,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (941, '942', 'Kundërshtimet e siguruesit', '1-2', 'Ligji 04/L-077
Neni 942 - Kundërshtimet e siguruesit

1. Kundër kërkesës së prurësit të polisës, si dhe të kërkesës së ndonjë personi tjetër që e invokon atë,
siguruesi mund të theksojë të gjitha kundërshtimet që ka lidhur me kontratën ndaj personit me të cilin
ka lidhur kontratën mbi sigurimin.
2. Përjashtimisht, kundër kërkesës së personit të tretë në rastin e sigurimit vullnetar nga përgjegjësia
dhe të kërkesës së titullarëve të të drejtave të caktuara në sendin e siguruar, e drejtë kjo që ka kaluar
në bazë të vetë ligjit në bazë të së drejtës, me asgjësimin ose me dëmtimin e sendit të siguruar në
shpërblimin nga sigurimi, siguruesi mund të paraqesë vetëm kundërshtime që janë paraqitur para se të
ketë ndodhur rasti i siguruar.', '3d9894e44c10229d101e9e89254d8d42a9d7dd1a3e5cacc37fa5f5f39ed4575e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":203,"pageEnd":203,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (942, '943', 'Fillimi i efektit të sigurimit', '1-5', 'Ligji 04/L-077
Neni 943 - Fillimi i efektit të sigurimit

1. Në qoftë se nuk është kontraktuar ndryshe kontrata mbi sigurimin ka efektet e veta duke filluar që
nga mesnata e ditës kur është shënuar në policë si ditë e fillimit të kohëzgjatjes së sigurimit e deri në
mbarim të ditës së fundit të afatit për të cilin është kontraktuar sigurimi. Kohëzgjatja e sigurimit
konsiderohet që nuk është përcaktuar nëse palët nuk e shkëpusin kontratën para kohës së pagimit të
premiumit të përcaktuar në kushtet e sigurimit dhe nëse ekziston një kohëzgjatje në kontratën e
sigurimit me mundësi të vazhdimit të kontratës edhe për një kohë të njëjtë.
2. Në qoftë se afati i kohëzgjatjes së sigurimit të pasurisë nuk është caktuar me kontratë, secila palë
mund të denoncojë kontratën në ditën e arritshmërisë së premisë, duke njoftuar me shkrim palën më së
voni tre (3) muaj para arritshmërisë së premisë.
3. Në qoftë se sigurimi është lidhur në afatin më të gjatë se tri (3) vite, pas kalimit të këtij afati secila
palë mundet të denoncojë kontratën, duke e lajmëruar palën tjetër me shkrim në periudhën prej tre (3)
muajve.
4. Nuk është e mundur që me anë të kontratës të përjashtohet e drejta e palëve për tu tërhequr nga
kontrata, ashtu siç është përcaktuar në paragrafët e mëparshëm.
5. Dispozitat e këtij neni nuk zbatohen në sigurimin e jetës apo të shëndetit.', '023517cd33aed30e1e3111a7b740a8c7b18d014d6ca19bddf5c9dc49c10cf91e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":203,"pageEnd":203,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (943, '944', 'Ndikimi i falimentimit mbi sigurimin', '1-2', 'Ligji 04/L-077
Neni 944 - Ndikimi i falimentimit mbi sigurimin

1. Në rastin e falimentimit të kontraktuesit të sigurimit, sigurimi vazhdon, por secila palë ka të drejtë ta
zgjidhë kontratën për sigurimin brenda tre (3) muajsh nga data e hapjes së falimentimit, në të cilin rast
masës së falimentimit të kontraktuesve i takon pjesa e premisë së paguar që i përgjigjet kohës së
mbetur të sigurimit.
2. Në rastin e falimentimit të siguruesit, kontrata për sigurimin shuhet pasi të kenë kaluar tridhjetë (30)
ditë nga data e hapjes së falimentimit.', '0ab016dadc0aaee7653c7280135e290f9d35f37eca5405ed6ea9d077ddacfa46', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":203,"pageEnd":203,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (944, '945', 'Interesi i sigurimit', '1-2', 'Ligji 04/L-077
Neni 945 - Interesi i sigurimit

1. Sigurimi i pasurisë mund të kontraktohet nga secili person që ka interes që të mos ndodhë ndonjë
rast i siguruar, sepse përndryshe do të pësonte ndonjë dëm material.
2. Të drejta nga sigurimi mund të kenë vetëm personat të cilët në momentin e shkaktimit të dëmit kanë
pasur interes material që rasti i siguruar të mos ndodhë.', '335989fbb698120c896a5d9dfcb57316cc0cd85d81c90ab13900051a0acadd41', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":204,"pageEnd":204,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (945, '946', 'Qëllimi i sigurimit të pasurisë', '1-7', 'Ligji 04/L-077
Neni 946 - Qëllimi i sigurimit të pasurisë

1. Me sigurimin e pasurisë sigurohet shpërblimi për dëmin që do të ndodhte në pasurinë e të siguruarit
për shkak të paraqitjes së rastit të siguruar.
2. Shuma e shpërblimit nuk mund të jetë më e madhe nga sa është dëmi që ka pësuar i siguruari nga
paraqitja e rastit të siguruar.
3. Në sigurimin e të mbjellurave dhe të fruteve e të produkteve të tjera të tokës shuma e dëmit
përcaktohet duke marrë parasysh vlerën që do të kishin në kohën e grumbullimit, në qoftë se nuk është
kontraktuar ndryshe.
4. Të vlefshme janë dispozitat e kontratës me të cilën shuma e shpërblimit kufizohet në një shumë më
të vogël nga sa është shuma e dëmit.
5. Në rastin e vërtetimit të shumës së dëmit merret në konsiderim fitimi i humbur vetëm në qoftë se kjo
është kontraktuar.
6. Në qoftë se gjatë së njëjtës periudhë të sigurimit ndodhin disa raste të siguruara njëri pas tjetrit,
shpërblimi nga sigurimi për secilin prej tyre caktohet dhe paguhet tërësisht duke marrë parasysh krejt
shumën e sigurimit, pa zbritjen e saj për aq sa është shuma e shpërblimeve të mëparshme të paguara
në atë periudhë.
7. Në qoftë se me kontratën mbi sigurimin vlera e sendit të siguruar është përcaktuar në marrëveshje,
shpërblimi caktohet sipas kësaj vlere, përveç nëse siguruesi provon se vlera e kontraktuar është shumë
më e madhe nga sa është vlera efektive dhe në qoftë se për këtë diferencë nuk ekziston ndonjë arsye e
bazuar (si për shembull, sigurimi i sendit të përdorur në vlerën e sendit të tillë të ri, ose sigurimi i vlerës
subjektive).', '1878879cdccb0657a615469bff0f76142b860d0646570a15778d31faff3abc75', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"7","pageStart":204,"pageEnd":204,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (946, '947', 'Parandalimi i rastit të siguruar dhe shpëtimi', '1-4', 'Ligji 04/L-077
Neni 947 - Parandalimi i rastit të siguruar dhe shpëtimi

1. I siguruari ka për detyrë të marrë masa të parashikuara, të kontraktuara dhe të gjitha masat e tjera të
nevojshme për të parandaluar paraqitjen e rastit të siguruar, e në qoftë se rasti i siguruar shkaktohet,
atëherë ka për detyrë të marrë çdo gjë që varet prej tij për të bërë që të kufizohen pasojat e dëmshme
të tij.
2. Siguruesi ka për detyrë t’i shpërblejë shpenzimet, humbjet si dhe dëmet e tjera të shkaktuara nga
orvatja e arsyeshme për të mënjanuar rrezikun e drejtpërdrejtë të shkaktimit të rastit të siguruar, si dhe
me tentimin që të kufizohen pasojat e dëmshme të tij edhe atëherë kur këto tentime kanë qenë pa
sukses.
3. Siguruesi ka për detyrë ta japë këtë shpërblim, edhe në qoftë se ky së bashku me shpërblimin e
dëmit nga rasti i siguruar tejkalon shumën e sigurimit.
4. Në qoftë se i siguruari nuk e përmbush detyrimin e vet të parandalimit të rastit të siguruar ose
detyrimin e shpëtimit, ndërsa se për këtë nuk ka justifikim, detyrimi i siguruesit zvogëlohet aq sa është
paraqitur dëmi më i madh për shkak të kësaj mospërmbushje.', '100835456faa8f3d72dae0dda30d2bc61da758d1e176e53507b4e06c88deaeb4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":204,"pageEnd":205,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (947, '948', 'Lënia e sendit të dëmtuar që është siguruar', null, 'Ligji 04/L-077
Neni 948 - Lënia e sendit të dëmtuar që është siguruar

Në qoftë se nuk është kontraktuar ndryshe, i siguruari nuk ka të drejtë që pas paraqitjes së rastit të
siguruar t’ia lejë siguruesit sendin e siguruar të dëmtuar dhe të kërkojë prej tij pagimin e shumës së
plotë të sigurimit.', '80a2c26b0f13ae845e59cbc7ba9055612eae57930279c5b8b477a8da7e444b2c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":205,"pageEnd":205,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (948, '949', 'Shkatërrimi i sendit për shkak të ngjarjes që nuk është parashikuar në polisë', '1-2', 'Ligji 04/L-077
Neni 949 - Shkatërrimi i sendit për shkak të ngjarjes që nuk është parashikuar në polisë

1. Në qoftë se sendi i siguruar, ose sendi i lidhur me përdorimin e të cilit është kontraktuar sigurimi nga
përgjegjësia, shkatërrohet gjatë periudhës së sigurimit për shkak të ndonjë ngjarjeje që nuk është
parashikuar në polisë , kontrata nuk ka më fuqi dhe siguruesi ka për detyrë t’i kthejë kontraktuesit të
sigurimit pjesën e premisë në përpjesëtim me kohën e mbetur.
2. Kur një nga disa sende të përfshira me një kontratë shkatërrohet për shkak të ndonjë ngjarje që nuk
është parashikuar në polisë , sigurimi mbetet në fuqi edhe më tutje përsa i përket sendeve të tjera
kundrejt ndryshimeve të nevojshme për shkak të zvogëlimit të objektit të sigurimit.', 'a08715308af0b19bf515491c73c7f68b971ae611569c0b73b0199010257340e4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":205,"pageEnd":205,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (949, '950', 'Dëmet e mbuluara nga sigurimi', '1-3', 'Ligji 04/L-077
Neni 950 - Dëmet e mbuluara nga sigurimi

1. Siguruesi ka për detyrë t’i shpërblejë dëmet e shkaktuara rastësisht ose për faj të kontraktuesit të
sigurimit të siguruarit ose të shfrytëzuesit të sigurimit, përveç nëse për dëmin e shkaktuar ky detyrim i tij
është përjashtuar shprehimisht me kontratën për sigurimin.
2. Ai nuk përgjigjet për dëmin e shkaktuar me dashje nga këta persona, kështu që është nule dispozita
në polisë që do të parashikonte përgjegjësinë e tij edhe në këtë rast.
3. Në qoftë se do të realizohet rasti i siguruar, siguruesi ka për detyrë ta shpërblejë secilin dëm të
shkaktuar nga ana e ndonjë personi, për veprimet e të cilit i siguruari përgjigjet mbi cilëndo bazë qoftë,
pavarësisht nëse dëmi është shkaktuar ose jo nga pakujdesia ose me dashje.', '63b9ebee98ffaf2b0077d1cb417109e0ec9abfa0c4887d58aa1460098497dabc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":205,"pageEnd":205,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (950, '951', 'Dëmet e shkaktuara nga të metat e sendit të siguruar', null, 'Ligji 04/L-077
Neni 951 - Dëmet e shkaktuara nga të metat e sendit të siguruar

Siguruesi nuk përgjigjet për dëmin në sendin e siguruar që rrjedh nga të metat e tij, përveç nëse është
kontraktuar ndryshe.', '6802d7cb157981fd67012398e927b7dcaae287082fb7165eb31db7ded63017e6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":205,"pageEnd":205,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (951, '952', 'Dëmet e shkaktuara nga operacionet e luftës dhe kryengritjet', '1-2', 'Ligji 04/L-077
Neni 952 - Dëmet e shkaktuara nga operacionet e luftës dhe kryengritjet

1. Siguruesi nuk ka për detyrë t’i shpërblejë dëmet e shkaktuara nga operacionet e luftës ose
kryengritjet, përveç nëse është kontraktuar ndryshe.
2. Siguruesi ka për detyrë të provojë se dëmi është shkaktuar nga ndonjë prej këtyre ngjarjeve.', 'e021c200fadf698c0cd1fb31f1522456982fca01d083f8bcd93d743561aa7a65', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":206,"pageEnd":206,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (952, '953', 'Mbisigurimi', '1-3', 'Ligji 04/L-077
Neni 953 - Mbisigurimi

1. Në qoftë se kur lidhet kontrata njëra palë përdorë mashtrimin dhe në këtë mënyrë kontrakton
shumën e sigurimit më të madhe nga sa është vlera efektive e sendit të siguruar, pala tjetër mund të
kërkojë anulimin e kontratës.
2. Në qoftë se shuma e kontraktuar e sigurimit është më e madhe nga sa është vlera e sendit të
siguruar, ndërsa asnjëra nga palët nuk ka vepruar në mënyrë të pandërgjegjshme dhe të pandershme,
kontrata mbetet në fuqi, shuma e sigurimit zbritet deri në shumën e vlerës efektive të sendit të siguruar,
kurse premitë zvogëlohen përpjesëtimisht.
3. Në të dy rastet siguruesi i ndërgjegjshëm mban premitë e marra dhe ka të drejtë në preminë e
pazvogëluar për periudhën vijuese.', '80abb77c529c11b0a62571ce36d59a4b6f6c2bcbce2af531b8c491c00e276f64', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":206,"pageEnd":206,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (953, '954', 'Zvogëlimi i mëvonshëm i vlerës', null, 'Ligji 04/L-077
Neni 954 - Zvogëlimi i mëvonshëm i vlerës

Në qoftë se vlera e siguruar zvogëlohet për kohën e afatit të sigurimit, secila palë kontraktuese ka të
drejtë në zbritjen përkatëse të shumës së sigurimit dhe të premisë, duke filluar nga data kur ia ka
komunikuar palës tjetër kërkesën e vet për zbritje.', '1b7ca8d157291d421e7ebc164a620f56c68bffc457942c5bc07045bb0468b90c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":206,"pageEnd":206,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (954, '955', 'Sigurimi i shumëfishtë dhe i dyfishtë', '1-9', 'Ligji 04/L-077
Neni 955 - Sigurimi i shumëfishtë dhe i dyfishtë

1. Në qoftë se ndonjë objekt është siguruar pranë dy ose më tepër siguruesve kundër të njëjtit rrezik
për të njëjtin interes dhe për të njëjtën kohë, kështu që shuma totale e sigurimit nuk tejkalon vlerën e
këtij sendi (sigurimi i shumëfishtë), secili sigurues përgjigjet për zbatimin në tërësi të detyrimeve të
krijuara nga kontrata që ka lidhur ai.
2. Në qoftë se shuma totale e sigurimit e tejkalon vlerën e sendit të siguruar (sigurimi i dyfishtë), ndërsa
kontraktuesi i sigurimit nuk ka vepruar me ndërgjegje, të gjitha këto sigurime janë të vlefshme dhe secili
sigurues ka të drejtë në preminë e kontraktuar për periudhën e sigurimit në vazhdim, ndërsa siguruesi
ka të drejtë të kërkojë prej secilit sigurues të veçantë shpërblimin sipas kontratës së përfunduar me të,
por gjithsej jo më tepër se sa është shuma e dëmit.
3. Kur ndodh rasti i siguruar, kontraktuesi i sigurimit ka për detyrë ta njoftojë për këtë secilin sigurues të
të njëjtit rrezik dhe t’i komunikojë emrat dhe adresat e siguruesve të tjerë, si dhe shumat e sigurimit të
kontratave të veçanta të përfunduara me këta.
4. Pasi shpërblimi t’i paguhet të siguruarit, secili sigurues përballon pjesën e shpërblimit në
përpjesëtimin në të cilin qëndron shuma e sigurimit në të cilën është detyruar ai ndaj shumës totale të
sigurimit, kështu që siguruesi që ka paguar më tepër ka të drejtë të kërkojë nga siguruesit e tjerë
shpërblimin për shumën e paguar më tepër.
5. Në qoftë se ndonjë kontratë është lidhur pa e treguar shumën e sigurimit, ose kundrejt mbulimit të
pakufizuar, konsiderohet si kontratë e lidhur kundrejt shumës më të lartë të sigurimit.
6. Për pjesën e siguruesit i cili nuk mund të paguajë, përgjigjen siguruesit e tjerë përpjesëtimisht me
pjesët e tyre.
7. Në qoftë se kontraktuesi i sigurimit ka lidhur kontratën e sigurimit me të cilën është krijuar sigurimi i
dyfishtë, duke mos ditur për sigurimin e përfunduar më parë, ai mundet, pavarësisht nëse sigurimin e
mëparshëm e ka lidhur ai apo ndokush tjetër, brenda një muaji nga dita kur ka mësuar për këtë sigurim,
të kërkojë zbritjen përkatëse të shumës së sigurimit dhe të premisë së sigurimit të mëvonshëm, por
siguruesi mban premitë e marra dhe ka të drejtë në preminë për periudhën vijuese.
8. Në qoftë se sigurimi i dyfishtë është realizuar për shkak të zvogëlimit të vlerës së objektit të sigurimit
gjatë kohës së afatit të sigurimit, kontraktuesi i sigurimit ka të drejtë në zbritjet përkatëse të shumave të
sigurimit dhe të premive, duke filluar që nga dita kur ia ka komunikuar siguruesit kërkesën e vet për
zbritje.
9. Në qoftë se gjatë krijimit të sigurimit të dyfishtë kontraktuesi i sigurimit ka vepruar në mënyrë të
pandërgjegjshme, secili sigurues mund të kërkojë anulimin e kontratës, të mbajë premitë e marra dhe
të kërkojë preminë e pazvogëluar për periudhën vijuese.', 'f8e0ef474a42c9d7943df0b0765fcfe765a9038a13eb603d0ec4b99151c7c6f7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"9","pageStart":206,"pageEnd":207,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (955, '956', 'Bashkësigurimi', null, 'Ligji 04/L-077
Neni 956 - Bashkësigurimi

Kur kontrata për sigurimin është lidhur me disa sigurues që janë marrë vesh mbi përballimin dhe
shpërndarjen e përbashkët të rrezikut, secili sigurues i shënuar në polisën e sigurimit përgjigjet para të
siguruarit për shpërblimin e plotë.', '547d6e1ab226ad981bc88aedad429a0dd6852daa242c5461c025df80735bda8a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":207,"pageEnd":207,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (956, '957', 'Nënsigurimi', '1-2', 'Ligji 04/L-077
Neni 957 - Nënsigurimi

1. Kur të vërtetohet se në fillim të periudhës respektive të sigurimit vlera e sendit të sigurimit ka qenë
më e madhe nga sa është shuma e sigurimit, shuma e shpërblimit që ka borxh siguruesi zvogëlohet
përpjesëtimisht, përveç nëse është kontraktuar ndryshe.
2. Siguruesi ka për detyrë të japë shpërblim të plotë deri në shumën e sigurimit, në qoftë se është
kontraktuar që raporti midis vlerës së sendit dhe shumës së sigurimit të mos ketë rëndësi për caktimin
e shumës së shpërblimit.', 'eba91923de177bcf65d905accb3fd2c2225dab51245b4c336fe19d90461e077b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":207,"pageEnd":207,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (957, '958', 'Kalimi i kontratës në përfituesin e sendit të siguruar', '1-6', 'Ligji 04/L-077
Neni 958 - Kalimi i kontratës në përfituesin e sendit të siguruar

1. Në rastin e tjetërsimit të sendit të siguruar si dhe të sendeve lidhur me përdorimin e të cilave është
kontraktuar sigurimi nga përgjegjësia, të drejtat dhe detyrimet e kontraktuesit të sigurimit kalojnë
vetvetiu në bazë të ligjit në përfituesin, përveç nëse është kontraktuar ndryshe.
2. Në qoftë se është tjetërsuar vetëm një pjesë e sendeve të siguruara, të cilat lidhur me sigurimin nuk
përbëjnë tërësi të veçantë, kontrata mbi sigurimin pushon në bazë të ligjit lidhur me sendet e
tjetërsuara.
3. Në rastin kur për shkak të tjetërsimit të sendeve shtohet ose zvogëlohet mundësia e paraqitjes së
rastit të siguruar, zbatohen dispozitat e përgjithshme mbi shtimin ose mbi zvogëlimin e rrezikut.
4. Kontraktuesi i sigurimit, i cili nuk e njofton siguruesin se sendi i siguruar është tjetërsuar, mbetet në
detyrim për pagimin e premive që rrjedhin për pagesë edhe pas ditës së tjetërsimit.
5. Siguruesi dhe përfituesi i sendit të siguruar mund të heqin dorë nga sigurimi me afat denoncimi prej
pesëmbëdhjetë (15) ditësh me kusht që denoncimin ta kenë për detyrë ta paraqesin jo më tepër se
brenda tridhjetë (30) ditësh nga data kur të kenë mësuar për denoncimin.
6. Kontrata për sigurimin nuk mund të zgjidhet në qoftë se polisa e sigurimit është lëshuar në prurësin
ose sipas urdhërit.', 'e41255b737aacab6fcb3ca15933be1d5b7b540ae0e3d5a178fce298c115b2501', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":208,"pageEnd":208,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (958, '959', 'Akordimi i kompensimit titullarëve të pengut dhe të të drejtave të tjera', '1-3', 'Ligji 04/L-077
Neni 959 - Akordimi i kompensimit titullarëve të pengut dhe të të drejtave të tjera

1. Pas paraqitjes së rastit të siguruar, të drejtat e pengut dhe të drejtat e tjera që kanë ekzistuar më
përpara në sendin e siguruar kanë si objekt shpërblimin në borxh si në rastin e sigurimit të sendit
vetjak, ashtu edhe në rastin e sigurimit të sendeve të huaja për shkak të detyrimit të ruajtjes e të kthimit
të tyre, kështu që siguruesi nuk mund t’ia paguajë shpërblimin të siguruarit pa pëlqimin e titullarëve të
këtyre të drejtave.
2. Këta persona mund të kërkojnë drejtpërdrejt nga siguruesi, që në kuadrin e shumës së sigurimit dhe
sipas radhës ligjore t’u paguajë kërkesat e tyre.
3. Në qoftë se në çastin e pagesës, siguruesi nuk ishte në dijeni dhe as që duhet të dinte për këto të
drejta, pagesa e bërë e kompensimit siguruesit mbetet e vlefshme.', '6b52d1192edcc40b61f911a123bb1023f28a4a302c257a7d50aeb297af227e73', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":208,"pageEnd":208,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (959, '960', 'Subrogimi', '1-5', 'Ligji 04/L-077
Neni 960 - Subrogimi

1. Me pagimin e shpërblimit nga sigurimi kalojnë në siguruesin në bazë të ligjit deri në shumën e
shpërblimit të paguar të gjitha të drejtat e të siguruarit kundrejt të gjithë personave, të cilët mbi çfarëdo
baze janë përgjegjës për dëmin.
2. Në qoftë se për faj të të siguruarit është bërë i pamundur ky kalim i të drejtave në sigurues tërësisht
ose pjesërisht, siguruesi shkarkohet në masën përkatëse nga detyrimi i vet ndaj të siguruarit.
3. Kalimi i të drejtave nga i siguruari në sigurues nuk mund të jetë në dëmin e të siguruarit, kështu që
në qoftë se shpërblimi të cilin e ka marrë i siguruari nga siguruesi për cilindo shkak qoftë është më i
vogël nga sa është dëmi që ka pësuar, i siguruari ka të drejtë që prej pasurisë së personit përgjegjës t’i
paguhet mbetja e kompensimit përpara kërkesës së siguruesit në bazë të të drejtave që janë kaluar në
të.
4. Përjashtimisht nga rregullat mbi kalimin e të drejtave të të siguruarit në siguruesin, këto të drejta nuk
kalohen në siguruesin, në qoftë se dëmin e ka shkaktuar personi në gjini në vijë të drejtë me të
siguruarin, ose personi për sjelljet e të cilit përgjigjet siguruesi apo i cili bashkëjeton me të në të njëjtën
ekonomi shtëpiake, ose personi që është punëtor i të siguruarit, përveç nëse këta persona e kanë
shkaktuar dëmin me dashje.
5. Në qoftë se dikush nga personat e përmendur në paragrafin paraprak ka qenë i siguruar nga
përgjegjësia, siguruesi mund të kërkojë nga siguruesi i tij kompensimin e shumës që i ka paguar të
siguruarit.', '1161a833c65c6ef9f2dc7815a5e82f8ad776061c0acb4fa0581377e62b914c56', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":208,"pageEnd":209,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (960, '961', 'Përgjegjësia e siguruesit', '1-2', 'Ligji 04/L-077
Neni 961 - Përgjegjësia e siguruesit

1. Në rastin e sigurimit nga përgjegjësia, siguruesi përgjigjet për dëmin e shkaktuar nga rasti i siguruar
vetëm në qoftë se personi i tretë i dëmtuar kërkon kompensimin e tij.
2. Siguruesi përballon në kuadrin e shumës së sigurimit shpenzimet e kontestit për përgjegjësinë e
siguruesit.', 'd24b7092c2649b4c72e1881cef5a9b918714467dfaf6485eedbe0b65f6721ad1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":209,"pageEnd":209,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (961, '962', 'E drejta personale e të dëmtuarit dhe padia direkte', '1-2', 'Ligji 04/L-077
Neni 962 - E drejta personale e të dëmtuarit dhe padia direkte

1. Në rastin e sigurimit nga përgjegjësia, personi i dëmtuar mund të kërkojë drejtpërdrejt nga siguruesi
shpërblimin e dëmit që ka pësuar nga ngjarja për të cilën përgjigjet siguruesi, por jo më tepër se deri në
shumën e detyrimit të siguruesit.
2. Personi i dëmtuar ka të drejtën personale në shpërblimin nga sigurimi që nga momenti kur ka
ndodhur rasti i siguruar, kështu që çdo ndryshim i mëvonshëm për të drejtat e të siguruarit ndaj
siguruesit nuk ka ndikim në të drejtën e personit të dëmtuar në shpërblim.', 'cf99194f3d44ac053eea287bf3d6fde32ec60960abdf53a197ee5658262a7834', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":209,"pageEnd":209,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (962, '963', 'Përcaktimi i shumës së siguruar', null, 'Ligji 04/L-077
Neni 963 - Përcaktimi i shumës së siguruar

Në kontratat për sigurimin e personave (sigurimi i jetës dhe sigurimin ndaj rastit të fatkeqësisë), shuma
e sigurimit të cilën siguruesi ka për detyrë ta paguajë kur lind rasti i siguruar, përcaktohet në polisë
sipas marrëveshjes së palëve kontraktuese.', 'f08146cfe4ccb06ef67fa9f496c7b524bef74902cb998203bc3f6b0f2a6f0fc8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":210,"pageEnd":210,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (963, '964', 'Polisa e sigurimit të jetës', '1-3', 'Ligji 04/L-077
Neni 964 - Polisa e sigurimit të jetës

1. Përpos pjesëve përbërëse që duhet t’i ketë çdo polisë, në polisën e sigurimit të jetës duhet të
shënohen: emri dhe mbiemri i personit në jetën e të cilit shtrihet sigurimi, datëlindja e tij, ngjarja ose
afati nga i cili varet paraqitja e të drejtës për të kërkuar pagimin e shumës së siguruar.
2. Polisa e sigurimit të jetës mund të jetë e shënuar në personin e caktuar, të jetë e shënuar sipas
urdhërit, por nuk mund të shënohet në prurësin.
3. Për vlefshmërinë e indosamentit të polisës sipas urdhërit nevojitet të përmbajë emrin e shfrytëzuesit,
datën e indosimit dhe nënshkrimin e indosantit.', '507825c41b111a3237673661c8d98b53d5686019569191d7f9d58edc01ff4596', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":210,"pageEnd":210,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (964, '965', 'Paraqitja e pasaktë e moshës së të siguruarit', '1-1.3', 'Ligji 04/L-077
Neni 965 - Paraqitja e pasaktë e moshës së të siguruarit

1. Përjashtimisht nga dispozitat e përgjithshme të këtij kreu mbi pasojat e paraqitjes të pasakta dhe mbi
lënien në heshtje të rrethanave me rëndësi për çmuarjen e rrezikut, për kallëzime të pasakta mbi
moshën në kontratat mbi sigurimin e jetës vlejnë këto rregulla:
1.1. kontrata mbi sigurimin e jetës është nule dhe siguruesi ka për detyrë që në çdo rast t’i
kthejë të gjitha premitë e marra, në qoftë se me rastin e lidhjes së saj është kallëzuar në
mënyrë të pasaktë mosha e të siguruarit, ndërsa mosha faktike e tij kalon kufirin e moshës deri
ku siguruesi sipas kushteve të veta dhe tarifave bën sigurimin e jetës;
1.2. në qoftë se është paraqitur në mënyrë jo të saktë se i siguruari ka më pak vjet, ndërsa
mosha faktike e tij nuk e kalon kufirin deri ku siguruesi bën sigurimin e jetës, kontrata është e
vlefshme, ndërsa shuma e siguruar zvogëlohet në përpjesëtim me preminë e kontraktuar dhe
me premitë e parashikuara për sigurimin e jetës së personave të moshës së personit të
siguruar;
1.3. kur i siguruari ka më pak vjet nga sa është paraqitur me rastin e lidhjes së kontratës,
premia zvogëlohet në shumën përkatëse, ndërsa siguruesi ka për detyrë ta kthejë diferencën
midis premive të marra dhe premive në të cilat ka të drejtë.', '7016e219c1aa6d56dfc497ea7ac77b0aa6656d99028a346b9c786aa82124d142', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1.3","pageStart":210,"pageEnd":210,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (965, '966', 'Pasojat e mospagimit të premisë dhe zvogëlimi i shumës së siguruar', '1-3', 'Ligji 04/L-077
Neni 966 - Pasojat e mospagimit të premisë dhe zvogëlimi i shumës së siguruar

1. Në qoftë se kontraktuesi i sigurimit të jetës nuk paguan ndonjë premi kur rrjedh për pagesë, siguruesi
nuk ka të drejtë që pagimin e saj të kërkojë në rrugë gjyqësore.
2. Në qoftë se kontraktuesi i sigurimit me ftesën e siguruesit, e cila i duhet dorëzuar me letër të
porositur, nuk e paguan preminë e rrjedhur për pagesë brenda afatit të caktuar në këtë letër, e që nuk
mund të jetë më i shkurtër se një (1) muaj, duke llogaritur që nga dita kur i është dorëzuar letra, dhe as
që e bën këtë ndonjë person tjetër i interesuar, siguruesi mundet vetëm, në qoftë se gjer atëherë janë
paguar të paktën tri (3) premitë vjetore t’i deklarojë kontraktuesit të sigurimit se e zvogëlon shumën e
siguruar në shumën e vlerës riblerëse të sigurimit, e në rastin e kundërt se e zgjidh kontratën.
3. Në qoftë se rasti i siguruar ka ndodhur përpara zgjidhjes së kontratës ose zvogëlimit të shumës së
siguruar, konsiderohet sikundër të jetë zvogëluar shuma e siguruar, respektivisht sikur kontrata të jetë
zgjidhur, varësisht nga fakti nëse premitë janë paguar të paktën për tri (3) vjet ose jo.', '7dc3ae3e8f38c3758d5fbe36d49042a7d1df59838755f5c1a6b7316ba027289a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":210,"pageEnd":211,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (966, '967', 'Sigurimi i personit të tretë', '1-3', 'Ligji 04/L-077
Neni 967 - Sigurimi i personit të tretë

1. Sigurimi i jetës mund të shtrihet në jetën e kontraktuesit të sigurimit, por mund të shtrihet edhe në
jetën e ndonjë personi të tretë.
2. E njëjta gjë vlen edhe për sigurimin kundër rastit të fatkeqësisë.
3. Në qoftë se sigurimi shtrihet në rastin e vdekjes së ndonjë të treti, për vlefshmërinë e kontratës
nevojitet pëlqimi i dhënë me shkrim prej tij i shënuar në polisë ose në dokumentin e veçantë, në rastin e
nënshkrimit të polisës duke shënuar shumën e siguruar.', 'f0829370fe71386c7186928d93d18b83f69dafca6fda3d0e5222768fa52d9e8d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":211,"pageEnd":211,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (967, '968', 'Sigurimi në rastin e vdekjes së personit të mitur dhe personit me aftësi të kufizuar për të vepruar', '1-2', 'Ligji 04/L-077
Neni 968 - Sigurimi në rastin e vdekjes së personit të mitur dhe personit me aftësi të kufizuar për të vepruar

1. Është i pavlefshëm sigurimi për rastin e vdekjes së personit të tretë me moshë nën katërmbëdhjetë
(14) vjeç si dhe i personave të paaftë për të vepruar, kështu që siguruesi ka për detyrë t’i kthejë
kontraktuesit të sigurimit të gjitha premitë e marra në bazë të kontratës së këtillë.
2. Për vlefshmërinë e sigurimit për rastin e vdekjes së personit të tretë më të vjetër se katërmbëdhjetë
(14) vjeç nevojitet pëlqimi me shkrim i përfaqësuesit të tij ligjor si dhe pëlqimi me shkrim i çdo personi të
siguruar.', 'f3f72c424132493848b93c1e46c9542401a8759d611ce2e4b7240ec6736d2d89', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":211,"pageEnd":211,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (968, '969', 'Kumulimi i kompensimit dhe i shumës së siguruar', '1-3', 'Ligji 04/L-077
Neni 969 - Kumulimi i kompensimit dhe i shumës së siguruar

1. Në sigurimin e personave, siguruesi që ka paguar shumën e siguruar nuk mund të ketë në asnjë
bazë të drejtë në shpërblim nga personi i tretë përgjegjës për shkaktimin e rastit të siguruar.
2. E drejta në shpërblim nga personi i tretë përgjegjës për paraqitjen e rastit të siguruar i takon
siguruesit respektivisht shfrytëzuesit, pavarësisht nga e drejta e tij në shumën e siguruar.
3. Dispozitat e paragrafëve paraprake nuk shtrihen në rastin, kur sigurimi kundër pasojave të rastit të
fatkeqësisë është kontraktuar si sigurim kundër përgjegjësisë.', '6334b63edb8942f7da52fe2b05a6ec364feba068bf061cc181a7528862ad57a4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":211,"pageEnd":211,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (969, '970', 'Vetëvrasja e të siguruarit', '1-2', 'Ligji 04/L-077
Neni 970 - Vetëvrasja e të siguruarit

1. Me kontratën për sigurimin për rastin e vdekjes nuk është përfshirë rreziku i vetëvrasjes të të
siguruarit, në qoftë se ka ndodhur në vitin e parë të sigurimit.
2. Në rastin kur vetëvrasja ka ndodhur brenda tre (3) vjetësh nga data e lidhjes së kontratës, siguruesi
nuk ka për detyrë t’i paguajë shfrytëzuesit shumën e siguruar, por vetëm rezervën matematikore të
kontratës.', '97462fd840b5d6b353d7f10a23e306e5eef14174e7fd21e3958a9e31acd8666f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":211,"pageEnd":212,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (970, '971', 'Vrasja me dashje e të siguruarit', null, 'Ligji 04/L-077
Neni 971 - Vrasja me dashje e të siguruarit

Siguruesi lirohet nga detyrimi që shfrytëzuesit t’i paguajë shumën e siguruar, në qoftë se ky e ka
shkaktuar me dashje vdekjen e të siguruarit, por ka për detyrë në qoftë se deri atëherë janë paguar të
paktën tri (3) premi vjetore, të paguajë rezervën matematikore të kontratës kontraktuesit të sigurimit, e
në qoftë se ky është i siguruari atëherë trashëgimtarëve të tij.', '556a2e8eb412052d05a59a1d95e17cf794193001a018fa3a6d15080e6fb2632c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":212,"pageEnd":212,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (971, '972', 'Shkaktimi me dashje i rastit të fatkeqësisë', null, 'Ligji 04/L-077
Neni 972 - Shkaktimi me dashje i rastit të fatkeqësisë

Siguruesi lirohet nga detyrimi i kontratës mbi sigurimin kundër rastit të fatkeqësisë, në qoftë se i
siguruari e ka shkaktuar me dashje rastin e fatkeqësisë.', 'c775ba144209b2d668f647f0ea6dfea400f87fcaca9bf9e1fd0e0e60c6e0d9f1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":212,"pageEnd":212,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (972, '973', 'Operacionet e luftës', '1-2', 'Ligji 04/L-077
Neni 973 - Operacionet e luftës

1. Në qoftë se vdekja e të siguruarit është shkaktuar nga operacionet e luftës, siguruesi, në qoftë se
nuk është kontraktuar diçka tjetër, nuk ka për detyrë t’i paguajë shfrytëzuesit të sigurimit shumën e
siguruar, por ka për detyrë t’i paguajë rezervën matematikore nga kontrata.
2. Në qoftë se nuk është kontraktuar diçka tjetër, siguruesi lirohet nga detyrimi prej kontratës mbi
sigurimin kundër rastit të fatkeqësisë, në qoftë se rasti i fatkeqësisë është shkaktuar nga operacionet e
luftës.', 'a04d068d27ebaaa40780efccb79bf31a2667a1cc7f9061f28e958fec9d9b61cd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":212,"pageEnd":212,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (973, '974', 'Përjashtimi kontraktues i rrezikut', null, 'Ligji 04/L-077
Neni 974 - Përjashtimi kontraktues i rrezikut

Me kontratën për sigurimin për rastin e vdekjes ose të rastit të fatkeqësisë mund të përjashtohen nga
sigurimi dhe rreziqet e tjera.', '75cc7e848f41e328ea11bb94673c8c3ba9bc614d71a377edfb78950bbd699df5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":212,"pageEnd":212,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (974, '975', 'Riblerja', '1-4', 'Ligji 04/L-077
Neni 975 - Riblerja

1. Me kërkesën e kontraktuesit të sigurimit të jetës, të përfunduar për tërë jetën e të siguruarit, siguruesi
ka për detyrë t’i paguajë vlerën riblerëse të policës, në qoftë se gjer atëherë janë paguar të paktën tri
(3) premitë vjetore.
2. Në polisë duhet të shënohen kushtet në të cilat kontraktuesi mund të kërkojë pagimin e vlerës së saj
riblerëse si dhe mënyrën se si të përllogaritet kjo vlerë në pajtim me kushtet e sigurimit.
3. Të drejtën e kërkesës së riblerjes nuk mund ta ushtrojnë kreditorët e kontraktuesit të sigurimit si dhe
shfrytëzuesit e sigurimit, por vlera riblerëse do t’i paguhet shfrytëzuesit me kërkesën e tij, në qoftë se
caktimi i shfrytëzuesit është e parevokueshëm.
4. Përjashtimisht nga paragrafi paraprak, riblerja e polisës mund të kërkohet nga kreditori të cilit polisa i
është dorëzuar në peng, në qoftë se kërkesa për sigurimin e së cilës është dhënë pengu nuk paguhet
në afatin e rrjedhjes së saj për pagesë.', '98be14cd176455867de9e1b4310e93a8e88286747bb9ea445f0f68bb8879e624', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":212,"pageEnd":213,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (975, '976', 'Paradhënia', '1-4', 'Ligji 04/L-077
Neni 976 - Paradhënia

1. Me kërkesën e kontraktuesit të sigurimit të jetës, të përfunduar për krejt jetën e të siguruarit,
siguruesi mund t’i parapaguajë pjesën e shumës së siguruar deri në shumën e vlerës riblerëse të
polisës, të cilën kontraktuesi i sigurimit mund ta kthejë më vonë.
2. Mbi paradhënien e marrë kontraktuesi i sigurimit ka për detyrë të paguajë kamatë të caktuar.
3. Në qoftë se kontraktuesi i sigurimit vonon me pagimin e kamatës së rrjedhur për pagesë do të
veprohet sikundër të ketë kërkuar riblerje.
4. Në polisën e sigurimit duhet të shënohen kushtet e dhënies së paradhënies, mundësia që shuma e
marrë në emër të paradhënies t’i kthehet siguruesit, shuma e shkallës së kamatës, pasojat e
mospagimit të kamatës së rrjedhur për pagesë, sikundër është caktuar në kushtet e sigurimit.', '33290f5764b8fb2a0a77cbb15b52bd6cf23b136c2cd5a6ea5e73ec5d73d6c286', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":213,"pageEnd":213,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (976, '977', 'Lënia peng e polisës', '1-3', 'Ligji 04/L-077
Neni 977 - Lënia peng e polisës

1. Polisa e sigurimit të jetës mund të lihet peng.
2. Lënia peng e polisës ka efekt ndaj siguruesit vetëm në qoftë se është njoftuar me shkrim se polisa i
është lënë peng kreditorit të caktuar.
3. Kur polisa është shënuar sipas urdhërit, lënia peng bëhet me indosament.', '44a112a0cafd950ce47b95a9c9adcc0ee93611561fa1f9c627de0e03b4139727', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":213,"pageEnd":213,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (977, '978', 'Caktimi i shfrytëzuesit', '1-4', 'Ligji 04/L-077
Neni 978 - Caktimi i shfrytëzuesit

1. Kontraktuesi i sigurimit të jetës mundet në kontratë si edhe me ndonjë veprim juridik të mëvonshëm
qoftë edhe me testament ta caktojë personin të cilit do t’i takojnë të drejtat nga kontrata.
2. Në qoftë se sigurimi shtrihet në jetën e ndonjë personi tjetër për caktimin e shfrytëzuesit nevojitet
edhe aprovimi i tij me shkrim.
3. Shfrytëzuesi nuk nevojitet medoemos të caktohet sipas emrit, por mjafton në qoftë se akti përmban
të dhënat e domosdoshme për caktimin e tij.
4. Kur si shfrytëzues janë caktuar fëmijët ose pasardhësit, dobia u takon edhe të paslindurëve, ndërsa
dobia e destinuar bashkëshortit i takon personit që ka qenë në martesë me të siguruarin në çastin e
vdekjes së tij.', '97ecd7204b62ff85e6384c523600251a53a573193e333861e02c87cd0be658b0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":213,"pageEnd":213,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (978, '979', 'Pjesëtimi i dobisë midis disa shfrytëzuesve', null, 'Ligji 04/L-077
Neni 979 - Pjesëtimi i dobisë midis disa shfrytëzuesve

Kur si shfrytëzues janë caktuar fëmijët, pasardhësit dhe në përgjithësi trashëgimtarët, në qoftë se
kontraktuesi i sigurimit nuk ka caktuar se si do të bëhet pjesëtimi midis tyre, pjesëtimi do të bëhet
përpjesëtimisht me pjesët e tyre trashëgimore, e në qoftë se shfrytëzuesit nuk janë trashëgimtarë,
shuma e siguruar do të pjesëtohet në pjesë të barabarta.', '6961e0732a07036af7a34595d35db376432c5f51206c83aed6aa8f78086572e5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":213,"pageEnd":214,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (979, '980', 'Revokimi i dispozitës për caktimin e shfrytëzuesve', '1-4', 'Ligji 04/L-077
Neni 980 - Revokimi i dispozitës për caktimin e shfrytëzuesve

1. Dispozitën me të cilën dobia nga sigurimi i caktohet personit të caktuar mund të revokohet vetëm nga
kontraktuesi i sigurimit, dhe këtë të drejtë të tij nuk mund ta ushtrojnë as kreditorët e tij dhe as
trashëgimtarët ligjorë të tij.
2. Kontraktuesi i sigurimit mund ta revokojë dispozitën mbi dobinë gjithnjë gjersa shfrytëzuesi të mos
deklarojë në cilëndo mënyrë qoftë se e pranon, kur ajo bëhet e parevokueshme.
3. Kontraktuesi mund ta revokojë dispozitën mbi dobinë edhe pas deklaratës së shfrytëzuesit se e
pranon, në qoftë se shfrytëzuesi ka tentuar vrasjen e të siguruarit, e në qoftë se dobia është akorduar
pa shpërblim, për revokim vlejnë edhe dispozitat mbi revokimin e dhuratës.
4. Konsiderohet se shfrytëzuesi e ka refuzuar dobinë që i është destinuar, në qoftë se pas vdekjes së
kontraktuesit të sigurimit me thirrjen e trashëgimtarëve të tij nuk deklarohet brenda një muaji se a
pranon.', 'b19c5d8528227a96be97b71b2b0653ee7e0ad180c02b8b04e0369a9c8f457a62', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":214,"pageEnd":214,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (980, '981', 'E drejta personale dhe e drejtpërdrejtë e shfrytëzuesit', '1-3', 'Ligji 04/L-077
Neni 981 - E drejta personale dhe e drejtpërdrejtë e shfrytëzuesit

1. Shuma e siguruar, e cila duhet t’i paguhet shfrytëzuesit nuk hyn në pjesën trashëgimore të
kontraktuesit të sigurimit dhe as atëherë kur si shfrytëzues janë caktuar trashëgimtarët e tij.
2. E drejta në shumën e siguruar i takon vetëm shfrytëzuesit, e pikërisht nga lidhja e kontratës së
sigurimit dhe pavarësisht se si dhe kur është caktuar si shfrytëzues, e pavarësisht nëse ka deklaruar
aprovimin e vet përpara ose pas vdekjes së të siguruarit, kështu që mund t’i drejtohet drejtpërdrejt
siguruesit me kërkesën që t’i paguhet shuma e siguruar.
3. Në qoftë se kontraktuesi i sigurimit ka caktuar si shfrytëzues fëmijët e vet, pasardhësit ose
trashëgimtarët e vet, në përgjithësi secili shfrytëzues, të caktuar kështu, i takon e drejta në pjesën
përkatëse të shumës së siguruar megjithëse heq dorë nga trashëgimia.', '59f31dc474fd2f11d08e14526d20b27fc50bb53c55c404446053f02ea2210c4e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":214,"pageEnd":214,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (981, '982', 'Kreditori i kontraktuesit të sigurimit dhe të siguruarit', '1-2', 'Ligji 04/L-077
Neni 982 - Kreditori i kontraktuesit të sigurimit dhe të siguruarit

1. Kreditorët e kontraktuesit të sigurimit dhe të të siguruarit nuk kanë asnjë të drejtë në shumën e
siguruar të kontraktuar për shfrytëzues.
2. Në qoftë se premitë që i ka derdhur kontraktuesi i sigurimit kanë qenë përpjesëtimisht shumë të
mëdha në krahasim me mundësitë e tij në çastin kur janë derdhur, kreditorët e tij mund të kërkojnë që
t’u dorëzohet pjesa e premisë e cila tejkalon mundësitë e tij, nëse janë përmbushur kushtet në të cilat
kreditorët kanë të drejtë në kundërshtimin e veprimeve juridike të debitorit.', 'aff374a29ba4dfbc811119c834325d9846197661d16207d4eec3174c71b9835b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":214,"pageEnd":214,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (982, '983', 'Cedimi i shumës së siguruar', null, 'Ligji 04/L-077
Neni 983 - Cedimi i shumës së siguruar

Të drejtën e vet në shumën e siguruar shfrytëzuesi mundet t’ia kalojë tjetrit edhe përpara rastit të
siguruar, por për këtë i nevojitet pëlqimi me shkrim i kontraktuesve të sigurimit, ku duhet të shënohet
emri i personave të cilëve u kalohet e drejta, e në qoftë se sigurimi shtrihet në jetën e ndonjë personi
tjetër, atëherë nevojitet i njëjti pëlqim edhe i këtij personi.', '6315cea8879335879c5d79ed8a49042a5b4e6f6cf9b2497523c0bbd946907a3f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":214,"pageEnd":214,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (983, '984', 'Kur shfrytëzuesi i caktuar vdes përpara rrjedhjes së shumës për pagesë', null, 'Ligji 04/L-077
Neni 984 - Kur shfrytëzuesi i caktuar vdes përpara rrjedhjes së shumës për pagesë

Kur personi i cili pa shpërblim është caktuar si shfrytëzues vdes para arritjes së shumës së siguruar
apo të rentës, dobia nga sigurimi nuk u takon trashëgimtarëve të tij, por shfrytëzuesit pasardhës, e në
qoftë se ky nuk është caktuar, atëherë pasurisë së kontraktuesit të sigurimit.', '81588257b7e4016cb005fd1f8d9f594bd8348f9de76d2d5aa71eb4e2848e010a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":215,"pageEnd":215,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (984, '985', 'Sigurimi për rast vdekjeje pa shfrytëzues të caktuar', null, 'Ligji 04/L-077
Neni 985 - Sigurimi për rast vdekjeje pa shfrytëzues të caktuar

Në qoftë se kontraktuesi i sigurimit për rastin e vdekjes nuk e cakton shfrytëzuesin, apo në qoftë se
dispozita mbi caktimin e shfrytëzuesit mbetet pa efekt për shkak të revokimit, apo për shkak të refuzimit
të personit të caktuar, ose cilido shkak tjetër, ndërsa kontraktuesi i sigurimit nuk cakton shfrytëzues
tjetër, shuma e siguruar i takon pasurisë së kontraktuesit të sigurimit dhe si pjesa e saj kalon me të
drejtat e tjera të tij në trashëgimtarët e tij.', 'e2f8f67b664c6e3d7c2168141d0fde43dd21d7f5032d2f8e49562a152baa7b93', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":215,"pageEnd":215,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (985, '986', 'Pagimi i ndërgjegjshëm i shumës së siguruar personit të paautorizuar', '1-2', 'Ligji 04/L-077
Neni 986 - Pagimi i ndërgjegjshëm i shumës së siguruar personit të paautorizuar

1. Kur siguruesi ia paguan shumën e siguruar personit i cili do të kishte të drejtë në të po të mos ta
kishte caktuar shfrytëzuesin kontraktuesi i sigurimit, ky lirohet nga detyrimi prej kontratës mbi sigurimin
në qoftë se në momentin e kryerjes së pagesës nuk ka ditur dhe as që ka mundur ta dinte se
shfrytëzuesi është caktuar me testament ose me ndonjë akt tjetër, i cili nuk i është dorëzuar, ndërsa
shfrytëzuesi ka të drejtë të kërkojë kthimin nga personi që ka pranuar shumën e siguruar.
2. E njëjta gjë vlen në rastin e ndërrimit të shfrytëzuesit.', 'd83c585f6590d4e7fc45a3458fe536e8a90dcb319b250495ed17e33cee19d333', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":215,"pageEnd":215,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (986, '987', 'Nocioni', null, 'Ligji 04/L-077
Neni 987 - Nocioni

Ortakëria është bashkim me kontratë i dy ose më shumë personave (ortakëve) për arritjen e ndonjë
qëllimi të përbashkët të lejuar nga e drejta, me punë ose mjete të përbashkëta të caktuara me kontratë.', '11c4b0ab3f651810a618488c1e029739baa802a41d70e704a2f28358d5a6fb7f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":215,"pageEnd":215,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (987, '988', 'Kontributet', '1-7', 'Ligji 04/L-077
Neni 988 - Kontributet

1. Në ortakëri, secili ortak është i detyruar të kontribuojë për atë që është përcaktuar në kontratë
(kontributi).
2. Kontributi mund të jetë në para, send, e drejtë, kërkesë, ose shërbim, e ardhur apo lejimi i vlerës së
pajisjeve.
3. Ortakët përveç kur parashihet ndryshe me kontratë, kanë për detyrë të japin kontribut të barabartë.
4. Në formë të kontributit në ortakëri, mund të jepet edhe prona për përdorim dhe shfrytëzim.
5. Nëse ndonjërit prej ortakëve i sigurohen vetëm përfitime pa detyrimin që të ofrojë kontribut, atëherë
kjo kontratë nuk konsiderohet ortakëri.
6. Nëse është e nevojshme ruajtja e mjeteve të ortakërisë apo për të shmangur dëmin, secili ortak
është i detyruar të kontribuojë në pjesë proporcionale të asaj që është e nevojshme për ruajtjen e
mjeteve apo parandalimin e dëmit, përveç kontributit të përcaktuar në kontratë.
7. Secili ortak është përgjegjës si shitësi për të metat juridike dhe materiale të kontributit të tij.', '8dcb1dde091f4e5b2d9763fd8ed5ed32820a734cb9a47e5f1300efbf5aea1dc4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"7","pageStart":215,"pageEnd":216,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (988, '989', 'Vendimet e ortakëve dhe udhëheqja', '1-9', 'Ligji 04/L-077
Neni 989 - Vendimet e ortakëve dhe udhëheqja

1. Secili ortak ka një votë. Me anë të kontratës mund të përcaktohet që ortakët të kenë numër të
ndryshëm votash.
2. Për punët e ortakërisë, ortakët marrin vendimet në mënyrë unanime. Sipas kësaj mënyre, ortakët
vendosin sidomos për përdorimin e fitimit dhe përfitimeve tjera, për mënyrën se si të mbulohet humbja,
për pranimin e një ortaku të ri apo përjashtimin e ndonjë ortaku ekzistues, për kërkesat e secilit ortak në
lidhje me dëmet ndaj ortakërisë, shkarkimin e udhëheqjes, shkëputjen e kontratës dhe për çështjet e
tjera në lidhje me udhëheqjen.
3. Me anë të kontratës mund të përcaktohet se për çështjet e përcaktuara në paragrafin e mëparshëm,
ortakët vendosin me shumicë votash. Në rastin e tillë, për marrjen e vendimit kërkohen shumica e
votave apo të paktën dy të tretat e votave.
4. Ortakët duhet të organizojnë udhëheqjen së bashku dhe në mënyrë të barabartë.
5. Me anë të kontratës mund të përcaktohet që secili prej ortakëve kryen udhëheqje në mënyrë të
pavarur, ose që udhëheqja të kryhet vetëm nga disa prej ortakëve, ose nga një apo më shumë persona
të emëruar nga ortakët me unanimitet.
6. Mbi baza të justifikueshme, ortakët mund të përjashtojnë udhëheqjen nga ndonjëri prej ortakëve.
7. Natyra e dispozitave të këtij ligji mbi kontratën për urdhrin zbatohen në lidhje me udhëheqjen.
8. Nëse parashihet me kontratë, udhëheqësi ka të drejtë në pagesë për punën e tij.
9. Secili ortak ka të drejtë që të jetë i informuar për të gjitha punët dhe çështjet e ortakërisë.', '539ea0d19958c2c044afdfdd2fe27c034587c4aa776a742c188cfde96a58aa3b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"9","pageStart":216,"pageEnd":216,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (989, '990', 'Ushtrimi i të drejtave dhe detyrimeve në ortakëri', '1-3', 'Ligji 04/L-077
Neni 990 - Ushtrimi i të drejtave dhe detyrimeve në ortakëri

1. Secili partner duhet t’i kryej punët e ortakërisë dhe detyrimet tjera në lidhje me to me kujdesin dhe
sipas mënyrës që i kryen punët e veta.
2. Nëse qëllimi i ortakërisë është i lidhur me aktivitetet e ortakëve apo profesionin e tyre, ata janë të
detyruar të veprojnë me kujdesin e ekonomistit të mirë apo me kujdesin e ekspertit të mirë.
3. Ortaku nuk mund të ndërmarrë asnjë veprim që do të rrezikonte arritjen e qëllimit të përbashkët.', '491c4065885b22ed8329b4cd5dd04638c7fb62a8beb5fc9e6cd97c498400f9cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":216,"pageEnd":216,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (990, '991', 'Fitimi dhe humbja', '1-3', 'Ligji 04/L-077
Neni 991 - Fitimi dhe humbja

1. Përveç kur përcaktohet ndryshe me kontratë, secili ortak ka të drejtë në pjesën e fitimit të arritur në
ortakëri.
2. Secili partner është i detyruar të marr përsipër pjesën e humbur që ka ndodhur nga funksionimi i
ortakërisë.
3. Ortakët marrin pjesë në fitim në fitim dhe humbje në mënyrë të barabartë në përpjesëtim me pjesët e
tyre të kontributit, përveç kur përcaktohet ndryshe me kontratë.', '7860b27ba69a9ccd7092c051eb3f85d8c4b3080bb2e31161f3c14071ecdacc75', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":216,"pageEnd":217,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (991, '992', 'Paraqitja tek personat e tretë', '1-4', 'Ligji 04/L-077
Neni 992 - Paraqitja tek personat e tretë

1. Ortaku apo udhëheqësi që paraqitet në emër të vetë dhe për llogari të ortakërisë kundrejtë
personave të tretë, të gjitha të drejtat dhe detyrimet në lidhje me personin e tretë i bartin vet.
2. Në qoftë se ortaku lidh punët me ndonjë person të tretë në emër të ortakërisë ose të të gjithë
ortakëve, do të zbatohen dispozitat e këtij ligji mbi përfaqësimin.
3. Për rastet e përcaktuara në paragrafin e dytë të këtij neni të gjithë ortakët bëhen kreditor apo debitor
të përbashkët dhe të ndarë dhe dispozitat e këtij ligji për përgjegjësinë e përbashkët dhe të ndarë do të
zbatohen. Marrëveshja ndërmjet ortakëve që përcakton diçka tjetër nga mësipër nuk ka efekt ligjor ndaj
personave të tretë.
4. Me shpërndarjen e ortakërisë, detyrimet e ortakëve ndaj personave të tretë, sipas këtij neni, nuk
shuhen.', 'c295aa7de6d95a7d063fdf6f6cfd62ce0f2714fddecad1bea5e7edbc57619f59', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":217,"pageEnd":217,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (992, '993', 'Pasuria e ortakërisë', null, 'Ligji 04/L-077
Neni 993 - Pasuria e ortakërisë

Përveç nëse parashihet ndryshe me kontratë, ortakët kanë të drejta të barabarta mbi bashkëpronësinë
dhe pjesët tjera të përbashkëta që kanë ardhur nga kontributet e ortakëve apo veprimtaria e ortakërisë.', 'd66b998c2e40c19f2b9d2534b59fe2d4ddc600716380916192a53a1d077312f6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":217,"pageEnd":217,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (993, '994', 'Marrëdhënia ndërmjet ortakëve', '1-2', 'Ligji 04/L-077
Neni 994 - Marrëdhënia ndërmjet ortakëve

1. Ortakët janë të detyruar që në pjesë të barabarta, t’i mbulojnë shpenzimet për detyrimet ndaj
personave të tretë, nëse nuk mund të mbulohen nga pasuria e ortakërisë, përveçse ndryshe parashihet
me kontratë.
2. Ortaku i cili ndaj personave të tretë, për zbatimin e kontratës ka mbuluar ndonjë shpenzim apo
ndonjë detyrim të ortakërisë, që tejkalon shumën për të cilën sipas kontratës ka qenë i detyruar ta
mbulojë, ka të drejtë të kërkojë kthimin në pjesë proporcionale nga ortakët e tjerë.', 'f968effa061119f2eabae779dac993da90d73cbe883a594622cfe993eb101713', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":217,"pageEnd":217,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (994, '995', 'Ndërrimi i ortakëve', '1-4', 'Ligji 04/L-077
Neni 995 - Ndërrimi i ortakëve

1. Ortakërisë mund ti shtohet ortaku i ri nëse kontrata e lejon një gjë të tillë.
2. Përveç nëse përcaktohet ndryshe me kontratë, ortaku i ri që hyn në ortakëri është i detyruar që të
japë kontributin e njëjtë sikur partnerët tjerë si dhe ka të drejtë në përfitimin që është realizuar pas
hyrjes së tij në ortakëri.
3. Ortaku i ri është përgjegjës ndaj personave të tretë vetëm për detyrimet që rrjedhin pas hyrjes së tij si
ortak.
4. Ortaku nuk mund t’ia kalojë pozitën e tij personit të tretë, por mund ta kalojë atë tek një ortak tjetër
dhe vetëm nëse kontrata e lejon një gjë të tillë dhe sipas kushteve të përcaktuara në kontratë.', '7c51a6ee7cd8e1fc02a382f01f4c5c204504d057bba0c9598f0ba5cb9a4c6b95', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":217,"pageEnd":217,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (995, '996', 'Përjashtimi i Ortakut', '1-4', 'Ligji 04/L-077
Neni 996 - Përjashtimi i Ortakut

1. Me anë të padisë ortakët mund të kërkojnë përjashtimin e ndonjë partneri nëse për këtë ekzistojnë
arsye të mjaftueshme. Kontrata mund të përcaktojë se ortakët mund të vendosin vet për përjashtimin e
një ortaku. Në një rast të tillë përmes padisë ortaku i larguar mund të kërkojë anulimin e një vendimi të
tillë nëse mendon se është marrë në mënyrë të padrejtë.
2. Ortaku i përjashtuar ka të drejtë për pjesët e kontributit të tij në shumën e vlerës së tregut që këto
pjesë kanë në momentin e përjashtimit.
3. Ortakët e tjerë duhet të paguajnë këtë shumë brenda tre (3) viteve nga momenti i përjashtimit.
4. Nëse ortakët tjerë kërkojnë kompenzim nga ortaku i përjashtuar, ata mund të ndalin vlerën e pjesës
së partnerit të përjashtuar derisa vendimi gjyqësor të marrë formën e prerë apo derisa të arrihet një
marrëveshje me ortakun e përjashtuar.', 'b3277228b0d1fda0210ab27b6d6a3518319bc33ae308c3d3890c697d7f3fbdd5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":218,"pageEnd":218,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (996, '997', 'Shuarja e Ortakërisë', '1', 'Ligji 04/L-077
Neni 997 - Shuarja e Ortakërisë

1. Ortakëria shuhet:
1.1. me kalimin e kohës për të cilin është themeluar;
1.2. me përmbushjen e qëllimit të kontraktuar ose kur arritja e këtij qëllimi bëhet e
pamundshme;
1.3. me vendim të ortakëve;
1.4. me vdekjen e një ortaku apo me humbjen e kapacitetit të tij kontraktorë, ose nëse ndaj
ortakut si tregtarë i vetëm kanë filluar procedurat për falimentim, likuidim apo shpërbërje;
1.5. nëse një ortak pushon së ekzistuari si person juridik për shkak të ndryshimit të statusit apo
nëse ndaj tij ka filluar procedura për falimentim likuidim apo shpërbërje;
1.6. nëse pas zbatimit të tyre,pjesët e kontributit janë marrë nga një person i tretë;
1.7. nëse me vendim të autoritetit publik ortakut i është ndaluar ushtrimi i aktiviteteve të cilat
janë qenësore për arritjen e qëllimit të përbashkët;
1.8. Nëse ortaku e denoncon kontratën.
2. Kontrata konsiderohet e lidhur për një periudhë të pakufizuar nëse ortakët vazhdojnë të përmbushin
kontratën e ortakërisë edhe pas kalimit të periudhës së përcaktuar në nën-paragrafin 1.1. të paragrafit
1. të këtij neni.
3. Kontrata e ortakërisë vazhdon të jetë në fuqi për ortakët e mbetur edhe pasi që një ortak nuk merr
pjesë më në ortakëri për arsyet e përcaktuara në nën-paragrafët 1.4. deri 1.8. së bashku të paragrafit
1. të këtij neni, nëse një gjë e tillë është e përcaktuar me kontratë.', '9bd04718c169e542df5dcb2da42aa9edcab67f03c543c836bd1dbb0e9126bad0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"1","pageStart":218,"pageEnd":218,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (997, '998', 'Shkëputja e kontratës', '1-3', 'Ligji 04/L-077
Neni 998 - Shkëputja e kontratës

1. Ortaku mund të shkëpus kontratën, nëse kjo është e përcaktuar në kontratë.
2. Ortaku mund të shkëpus kontratën e lidhur për një kohë të pakufizuar, pa marrë parasysh paragrafin
e mësipërm. Në rastin e tillë njoftimi për shkëputje duhet të bëhet tre muaj përpara.
3. Ortaku për arsye të rëndësishme, mund të kërkojë shkëputjen e kontratës së lidhur për periudhë të
caktuar edhe para përfundimit të kësaj periudhe si dhe pa njoftim paraprak, përmes padisë gjyqësore.', '662569cf79236412beb6ad1b293c4679bc4fbefae4fde1302a15e6df8cd3da3b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":218,"pageEnd":219,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (998, '999', 'Likuidimi', '1-2', 'Ligji 04/L-077
Neni 999 - Likuidimi

1. Nëse ortakëria shuhet, ortakët detyrohen të kryejnë likuidimin sidomos në atë mënyrë që të kryhen
detyrimet ndaj personave të tretë, që ortakët të kompensohen për shpenzimet dhe pagesat që i kalojnë
shumën e detyrimit që ata kanë sipas kontratës, dhe që pjesa tjetër e pasurisë të ndahet ndërmjet
ortakëve në pjesë të barabarta të kontributeve të dhëna. Kontrata mund të përcaktojë pjesë tjera, të
ndryshme nga kontributet.
2. Nëse pasuria e ortakërisë nuk mjafton për të mbuluar shpenzimet dhe detyrimet, pjesa e mbetur
mangët duhet të mbulohet nga ortakët në përpjesëtimin që zbatohet tek kontributet.', '3c86be8a0d81e76a088aa17332f11da79aa14301078362b6bcd112c2887a6396', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":219,"pageEnd":219,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (999, '1000', 'Përkufizimi', null, 'Ligji 04/L-077
Neni 1000 - Përkufizimi

Nëse një e drejtë u takon disa personave së bashku, dispozitat e këtij kreu zbatohen, përveç nëse
parashihet ndryshe me ligj.', '76e1c33bc6bacb1a1ad5fffac0b5d8a6dbbefcf46a451ce22675b3d71679cd1a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":219,"pageEnd":219,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1000, '1001', 'Pjesët', '1-4', 'Ligji 04/L-077
Neni 1001 - Pjesët

1. Në rast të paqartësive, secili anëtar i bashkësisë ka pjesë të barabartë për të drejtën që është objekt
i bashkësisë.
2. Secili anëtar i bashkësisë mund të disponoj lirshëm me pjesën e tij të bashkësisë.
3. Nëse një anëtar i bashkësisë ia transferon pjesën e tij personit tjetër, të drejtat dhe detyrimet e
anëtarit të bashkësisë të mëparshëm i zbatohen për anëtarin e bashkësisë tjetër.
4. Të gjithë anëtaret e bashkësisë së bashku disponojnë me objektin e bashkësisë si tërësi.', 'f8276bd2182d4479cc499102465c9d1395636de7229b8db121c900d9dedb5724', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":219,"pageEnd":219,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1001, '1002', 'Detyrimet e anëtarëve të bashkësisë', '1-2', 'Ligji 04/L-077
Neni 1002 - Detyrimet e anëtarëve të bashkësisë

1. Anëtaret e bashkësisë e përdorin dhe e shfrytëzojnë objektin e bashkësisë dhe vendosin mbi
çështjet e përbashkëta në mënyrë të përshtatshme me natyrën dhe qëllimin e objektit të bashkësisë
dhe me menaxhimin e zakonshëm.
2. Secili anëtar I bashkësisë mund t’i kërkojë gjykatës që me aktvendim të emërojë një administrator i
cili do të merrte vendimet mbi çështjet e përbashkëta, kur anëtaret e bashkësisë nuk veprojnë në
përputhje me paragrafin e parë ose nuk arrijnë marrëveshje për çështjet e përbashkëta.', '7ca04806eaab4050280112786827888a9af0d9256444917d97d82284fa2df111', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":219,"pageEnd":219,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1002, '1003', 'Përdorimi dhe shfrytëzimi', '1-3', 'Ligji 04/L-077
Neni 1003 - Përdorimi dhe shfrytëzimi

1. Nëse objekti i bashkësisë mund të ndahet në natyrë, secili anëtar përdorë dhe shfrytëzon pjesën e tij
si anëtar, por vetëm deri në atë masë sa nuk i pengon anëtaret tjerë apo nuk dëmton vet objektin e
bashkësisë.
2. Secili anëtar mund ta përdorë dhe gëzojë objektin e bashkësisë që nuk mund të ndahet në natyrë,
dhe i cili është i përcaktuar për të gjithë anëtaret , sipas qëllimit të përcaktuar të objektit të bashkësisë
dhe në atë mënyrë që nuk shkakton dëm në përdorimin në të njëjtën kohë nga anëtarët tjerë apo që
nuk shkakton dëm në vet objektin e bashkësisë si të tillë.
3. Nuk është e mundur kufizimi i të drejtës së anëtarëve sipas paragrafëve 1. dhe 2. të këtij neni, pa
dhënien e pëlqimit për një gjë të tillë.', '1dfc87753121027a86ff4d9492edda0205ac1f2136eb7f47ec144316b3551959', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":220,"pageEnd":220,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1003, '1004', 'Marrja e vendimeve për çështjet e përbashkëta', '1-6', 'Ligji 04/L-077
Neni 1004 - Marrja e vendimeve për çështjet e përbashkëta

1. Secili anëtar ka numrin e votave në përputhje me pjesën e tij në bashkësi.
2. Për administrimin e zakonshëm dhe për përdorimin dhe shfrytëzimin e objektit të bashkësisë,
vendimet i marrin anëtarët e bashkësisë me shumicë votash.
3. Anëtarët me dy të tretat (2/3) e votave mund të vendosin për përmirësimin e objektit të bashkësisë ,
për përdorimin e saj më të mirë apo për masat e rëndësishme për rritjen e vlerës së objektit. Nëse një
vendim i tillë kufizon të drejtat e ndonjë anëtari apo nëse ka shpenzime të larta për anëtarët e
bashkësisë , ai vendim duhet të merret me unanimitet.
4. Anëtarët e bashkësisë mund të pajtohen që për çështjet e përcaktuara në paragrafin 2. të këtij neni
mund të vendosë një anëtar i vetëm, vetëm disa nga anëtarët apo një person i tretë. Anëtarët e tillë apo
personat e tretë zgjedhën me shumicën e votave.
5. Pa marrë parasysh paragrafin e dytë, secili anëtar mund të bëjë çfarëdo që është e nevojshme për
shmangien e ndonjë kërcënimi direkt për dëmtimin e objektit të bashkësisë , nëse masat e tilla nuk janë
marrë nga anëtarët apo personat e tretë sipas paragrafit 2. dhe 4. të këtij neni.
6. Anëtarët nuk mund të kërkojnë apo të vendosin për ndryshime shumë të mëdha të objektit të
bashkësisë . Një kërkesë apo vendim i tillë konsiderohet të jetë kërkesë apo vendim për të shkëputur
bashkësinë.', '05deaadb7376b79133ac0d76a3838979f48b7d3314c0aca1883051dca1b03f52', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":220,"pageEnd":220,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1004, '1005', 'Shpenzimet e bashkësisë', '1-2', 'Ligji 04/L-077
Neni 1005 - Shpenzimet e bashkësisë

1. Shpenzimet e objektit të bashkësisë , sidomos ato që kanë të bëjnë me mirëmbajtjen, administrimin
dhe përdorimin e përbashkët, barten nga secili anëtar në përpjesëtim me pjesën e tij të bashkësisë.
2. Secili anëtar është i detyruar të bartë pjesën e përpjesëtuar të shpenzimeve që rrjedhin nga vendimi
për përmirësimin e objektit të bashkësisë , për përdorimin më të mirë të tij, apo për marrje të
rëndësishme për rritjen e vlerës së bashkësisë.', '48eb34f84162fe84f3c4e6111d56bc66e5368922fd86301ade714ff7e5aaa6ea', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":220,"pageEnd":220,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1005, '1006', 'Kërkesa për mbarim', '1-7', 'Ligji 04/L-077
Neni 1006 - Kërkesa për mbarim

1. Secili anëtar mund të kërkojë mbarimin e bashkësisë në çdo kohë.
2. Anëtarët kanë mundësi që me marrëveshje, për një periudhë të caktuar apo për gjithmonë, ta
përjashtojnë të drejtën e kërkesës për mbarimin e bashkësisë apo të përcaktojnë një kohë për
paralajmërim për një gjë të tillë.
3. Për rastet e përcaktuara në paragrafin 2. të këtij neni, është gjithashtu e mundshme që të kërkohet
mbarimi i bashkësisë, nëse ekzistojnë arsye të mjaftueshme për një gjë të tillë.
4. Administratori i emëruar nga gjykata po ashtu mund të kërkojë mbarimin e bashkësisë sipas
paragrafëve të parë dhe të tretë.
5. Pa marrë parasysh paragrafin 2. të këtij neni, anëtarët në çdo moment mund të vendosin me
unanimitet për mbarimin e bashkësisë
6. Bashkësia mbaron gjithashtu kur anëtarët e tjetërsojnë objektin e bashkësisë si tërësi apo nëse
objekti i bashkësisë nuk ekziston më.
7. Kufizimi i të drejtave të anëtarëve apo të administratorit të përcaktuara në paragrafin 1. 3. dhe 4. të
këtij neni nuk është e mundur të bëhet me kontratë.', 'b7a5b68b2631f93003975d54e1868fcb6c9d1cbc8ecc634b21399218f6be2dd6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"7","pageStart":220,"pageEnd":221,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1006, '1007', 'Pasojat e mbarimit', '1-6', 'Ligji 04/L-077
Neni 1007 - Pasojat e mbarimit

1. Pas mbarimit të bashkësisë bëhet ndarja në natyrë e objektit të bashkësisë , nëse një gjë e tillë është
e mundshme pa dëmtuar vlerën e tij.
2. Kur objekti i bashkësisë nuk mund të ndahet në natyrë, ai shitet. Nga shitja së pari duhet të shlyhen
detyrimet e përbashkëta ndaj personave të tretë dhe të anëtarëve që kanë shlyer detyrimet për llogari
të anëtarëve tjerë. Pjesa e mbetur ndahet ndërmjet anëtarëve në përputhje me pjesët përkatëse të
tyre.
3. Nëse objekti i bashkësisë është pasuri e paluajtshme, ai shitet në ankand publik.
4. Një apo disa anëtarë, kanë të drejtën e parablerjes në blerjen e bashkësisë sipas paragrafit të dytë
dhe të tretë, nën kushtet e njëjta me blerësit e tretë.
5. Po ashtu, paragrafi i dytë apo i tretë zbatohet edhe nëse mbarimi i bashkësisë ndodhë për shkak se
anëtarët e kanë tjetërsuar objektin e bashkësisë në tërësi apo nëse objekti i bashkësisë nuk ekziston
më.
6. Nëse shitja nuk ka sukses atëherë bashkësia nuk mund të mbarojë.', '439164a25b733c5b19520aba95010c4022185c9e0452f7509fb9a85e68ad8cf0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":221,"pageEnd":221,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1007, '1008', 'Themelimi i ortakërisë', '1-3', 'Ligji 04/L-077
Neni 1008 - Themelimi i ortakërisë

1. Bashkësia mund të mbarojë edhe nëse anëtarët themelojnë ortakëri sipas dispozitave të këtij ligji
apo sipas dispozitave të ligjit tjetër në fuqi.
2. Kur bashkësia mbaron sipas paragrafit 1. të këtij neni, nëse objekti i bashkësisë si tërësi investohet
në ortakëri, atëherë nuk kryhet ndarja e bashkësisë.
3. Anëtarët e bashkësisë janë përgjegjës ndaj personave të tretë edhe pas themelimit të ortakërisë
ashtu siç kanë qenë para themelimit të saj. Detyrimet e përbashkëta të ndodhura gjatë ekzistimit të
bashkësisë mund të rregullohen ndryshe me anë të kontratës së ortakërisë.', '5e927381fbb6e9de9fd6ee6b1a74f76833f72d44da9113ca53303db8022b605e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":221,"pageEnd":221,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1008, '1009', 'Nocioni', null, 'Ligji 04/L-077
Neni 1009 - Nocioni

Me kontratën mbi dorëzaninë obligohet dorëzani ndaj kreditorit se do ta përmbushë detyrimin e
plotfuqishëm të debitorit të rrjedhur për pagesë, në qoftë se ky nuk e bën këtë.', '25b390de9884084a0492b2f7581a9d2ff56a6ed19cd1d373546c807349464466', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":222,"pageEnd":222,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1009, '1010', 'Forma', null, 'Ligji 04/L-077
Neni 1010 - Forma

Me kontratën mbi dorëzaninë obligohet dorëzani vetëm në qoftë se deklaratën mbi dorëzaninë e ka
bërë me shkrim.', 'e4e8c1f2b6f2008a679d21073bde718da6b6a075acabcb088ed445df64a1ad69', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":222,"pageEnd":222,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1010, '1011', 'Zotësia për të vepruar e dorëzanit', null, 'Ligji 04/L-077
Neni 1011 - Zotësia për të vepruar e dorëzanit

Vetëm personi me zotësi të plotë për të vepruar mund të detyrohet me kontratën për dorëzani.', '973e3dcbc9ed55c042d97dc4328e65a4a20889b39bd577f3987170eb124fffc1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":222,"pageEnd":222,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1011, '1012', 'Dorëzania për personin e paaftë për të vepruar', null, 'Ligji 04/L-077
Neni 1012 - Dorëzania për personin e paaftë për të vepruar

Kush obligohet si dorëzanë për detyrimin e ndonjë personi të paaftë për të vepruar, i përgjigjet kreditorit
njësoj sikur dorëzani i personit të aftë për të vepruar.', '99b7a62c2e1c714876998f9d79659ac354a5f0ee2cd698c84bf864aa537d6715', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":222,"pageEnd":222,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1012, '1013', 'Objekti i dorëzanisë', '1-4', 'Ligji 04/L-077
Neni 1013 - Objekti i dorëzanisë

1. Dorëzania mund të jepet për çdo detyrim të vlefshëm pavarësisht nga përmbajtja e tij.
2. Mund të hyhet dorëzanë edhe për detyrimin e kushtëzuar, si dhe për detyrimin e caktuar të
ardhshëm.
3. Dorëzania për detyrimin e ardhshëm mund të revokohet para se të lind detyrimi, në qoftë se nuk
është parashikuar afati në të cilin ai duhet të lind.
4. Dorëzania mund të jepet edhe për detyrimin e ndonjë dorëzanësi tjetër (dorëzani i dorëzanit).', 'b127dd59dfb7ac7db7c625b396a98b0f8ccae1ec0a0b9849894f517fe905d239', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":222,"pageEnd":222,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1013, '1014', 'Volumi i përgjegjësisë së dorëzanit', '1-5', 'Ligji 04/L-077
Neni 1014 - Volumi i përgjegjësisë së dorëzanit

1. Detyrimi i dorëzanit nuk mund të jetë më i madh nga sa është detyrimi i debitorit kryesor, e në qoftë
se është kontraktuar që të jetë më i madh, ai reduktohet në masën e detyrimit të debitorit.
2. Dorëzani përgjigjet për përmbushjen e krejt detyrimit për të cilin ka qenë dorëzan, në qoftë se
përgjegjësia e tij nuk është e kufizuar në ndonjë pjesë të tij, ose në ndonjë mënyrë tjetër i është
nënshtruar kushteve më të lehta.
3. Ai ka për detyrë t''i kompensojë shpenzimet e nevojshme që i ka bërë kreditori për arkëtimin e borxhit
nga debitori kryesor.
4. Dorëzani përgjigjet edhe për çdo shtim të detyrimit i cili do të krijohej nga vonesa e debitorit ose për
faj të debitorit, në qoftë se nuk është kontraktuar ndryshe.
5. Ai përgjigjet vetëm për atë kamatë të kontraktuar e cila ka rrjedhur për pagesë pas lidhjes së
kontratës mbi dorëzaninë.', 'ca5d39ee3a5b94a9c50b00f3512ae15d6b03369c59f668eae3e815cf83022927', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":222,"pageEnd":223,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1014, '1015', 'Kalimi i të drejtave të kreditorit në dorëzanin (subrogimi)', null, 'Ligji 04/L-077
Neni 1015 - Kalimi i të drejtave të kreditorit në dorëzanin (subrogimi)

Në dorëzanësin i cili e ka plotësuar kërkesën e kreditorit kalon kjo kërkesë me të gjitha të drejtat
akcesore dhe me garancitë e përmbushjes së saj.', '591de2ce9f9dd5512a47286310ffe38b222d1972de3433a51f21f885e81f28e5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":223,"pageEnd":223,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1015, '1016', 'Format e dorëzanisë', '1-4', 'Ligji 04/L-077
Neni 1016 - Format e dorëzanisë

1. Prej dorëzanit mund të kërkohet përmbushja e detyrimit vetëm pasi debitori kryesor të mos e
përmbush brenda afatit të caktuar në thirrjen e drejtuar me shkrim (dorëzania subsidiare).
2. Mirëpo, kreditori mund të kërkojë përmbushjen nga dorëzani megjithëse nuk e ka thirrur më përpara
debitorin kryesor në përmbushjen e detyrimit, në qoftë se s''ka dyshim se prej mjeteve të debitorit
kryesor nuk mund të realizohet përmbushja e detyrimit apo në qoftë se debitori kryesor ka rënë në
falimentim.
3. Në qoftë se dorëzanisë është obliguar si dorëzanë pagues, i përgjigjet kreditorit si debitori kryesor
për krejt detyrimin dhe kreditori mund të kërkojë përmbushjen e tij si nga debitori kryesor ashtu edhe
nga dorëzanësi apo nga të dy njëkohësisht (dorëzania solidare).
4. Dorëzani për detyrimin e lindur nga kontrata në ekonomi përgjigjet si dorëzanë pagues, në qoftë se
nuk është kontraktuar diçka tjetër.', 'a9d1befbdf6813f42698fbfe661dd78ab7fac1eb47d92f04933f47819ced50bc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":223,"pageEnd":223,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1016, '1017', 'Solidariteti i dorëzanësve', null, 'Ligji 04/L-077
Neni 1017 - Solidariteti i dorëzanësve

Disa dorëzanë të një borxhi përgjigjen solidarisht, pavarësisht a kanë hyrë dorëzanë bashkërisht ose
secili prej tyre ka marrë përsipër detyrimin ndaj kreditorit veç e veç, me përjashtim kur në kontratë
përgjegjësia e tyre është rregulluar ndryshe.', '1afd94844848546986a7fd31308f2d633abb385b17565d29787cf641fbe5447e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":223,"pageEnd":223,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1017, '1018', 'Humbja e të drejtës në afat', null, 'Ligji 04/L-077
Neni 1018 - Humbja e të drejtës në afat

Në qoftë se debitori e ka humbur të drejtën në afat të caktuar për përmbushjen e detyrimit të tij, kreditori
megjithatë nuk mund të kërkojë përmbushjen nga dorëzani para skadimit të këtij afati, në qoftë se nuk
është kontraktuar ndryshe.', '81c3809a88313f53ef41f76e2247c34b4d811166ab66f72c8be51db4206fd89f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":223,"pageEnd":223,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1018, '1019', 'Falimentimi i debitorit kryesor', '1-2', 'Ligji 04/L-077
Neni 1019 - Falimentimi i debitorit kryesor

1. Në rastin e falimentimit të debitorit kryesor, kreditori ka për detyrë t''i lajmërojë kërkesat e veta në
falimentim dhe për këtë gjë ta njoftojë dorëzanin, ndryshe i përgjigjet dorëzanit për dëmin të cilin do ta
pësonte ky për këtë gjë.
2. Pakësimi i detyrimit të debitorit kryesor në procedurën e falimentimit ose në procedurën e
kompensimit nuk pas sjell edhe pakësimin përkatës të detyrimit të dorëzanësit, kështu që dorëzani i
përgjigjet kreditorit për krejt shumën e detyrimit të vet.', '8187b56e6f5f77b59fa4a89b0d558dfcc1e8444d66d9bf323e3c654f5cc916cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":224,"pageEnd":224,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1019, '1020', 'Rasti i përgjegjësisë së zvogëluar të trashëgimtarit të debitorit', null, 'Ligji 04/L-077
Neni 1020 - Rasti i përgjegjësisë së zvogëluar të trashëgimtarit të debitorit

Dorëzani përgjigjet për krejt shumën e detyrimit për të cilën ka hyrë dorëzanë edhe në rastin kur nga
trashëgimtari i debitorit do të mund të kërkohej pagimi vetëm i asaj pjese të tij që i përgjigjet vlerës së
pasurisë të trashëguar.', 'd78286546f271fde22c5df0b97a6bf4e6ee7c98aad8ecd075b189d262fe82e9b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":224,"pageEnd":224,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1020, '1021', 'Kundërshtimet e dorëzanit', '1-3', 'Ligji 04/L-077
Neni 1021 - Kundërshtimet e dorëzanit

1. Dorëzani mund të ushtroj kundër kërkesës së kreditorit të gjitha kundërshtimet e debitorit kryesor,
duke përfshirë edhe prapësimin e kompensimit, por jo edhe kundërshtime të tjera thjesht personale të
debitorit
2. Heqje dorë e debitorit nga kundërshtimet, si dhe njohja e tij e kërkesave të kreditorit, nuk ka efekt
ndaj dorëzanit.
3. Dorëzani mund të ushtroj kundër kreditorit edhe kundërshtimet e veta personale, për shembull,
nulitetin e kontratës mbi dorëzaninë, parashkrimin e kërkesave të kreditorit ndaj tij, prapësimin e
kompensimit të kërkesave reciproke.', 'd14b4c42bc7b32c9e43b38cb525f7f3d2444acdafb437e30cfd7f37c72798375', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":224,"pageEnd":224,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1021, '1022', 'Detyrimi i njoftimit të dorëzanit mbi ometimin e debitorit', null, 'Ligji 04/L-077
Neni 1022 - Detyrimi i njoftimit të dorëzanit mbi ometimin e debitorit

Në qoftë se debitori nuk përmbush detyrimin e vet në kohë, kreditori ka për detyrë që për këtë gjë ta
njoftojë dorëzanin, përndryshe do t''i përgjigjet për dëmin të cilin dorëzani do ta pësonte për këtë.', 'f753884b04a8dc2ed5ed63b65dabe8d11aca0ebefadfdd2cf5b43ad60e425100', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":224,"pageEnd":224,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1022, '1023', 'Shkarkimi i dorëzanit për shkak të vonesës së kreditorit', '1-2', 'Ligji 04/L-077
Neni 1023 - Shkarkimi i dorëzanit për shkak të vonesës së kreditorit

1. Dorëzani shkarkohet nga përgjegjësia në qoftë se kreditori, me thirrjen e tij pas rrjedhjes për pagesë
të kërkesës, nuk kërkon përmbushjen nga debitori kryesor brenda një (1) muaji nga data e kësaj
thirjeje.
2. Kur afati i përmbushjes nuk është caktuar, dorëzani shkarkohet nga përgjegjësia në qoftë se
kreditori, me thirrjen e tij pas skadimit të një (1) viti nga lidhja e kontratës mbi dorëzaninë, nuk bën
brenda një (1) muaji nga data e kësaj thirjeje deklaratë të nevojshme për caktimin e datës së
përmbushjes.', '777f9b094742b24b4b3ea1de319bbae84469874d502290351b96a44eeb23c555', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":224,"pageEnd":224,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1023, '1024', 'Lirimi i dorëzanit për shkak të heqjes dorë nga mjetet e sigurimit', '1-2', 'Ligji 04/L-077
Neni 1024 - Lirimi i dorëzanit për shkak të heqjes dorë nga mjetet e sigurimit

1. Në qoftë se kreditori heq dorë nga pengu ose cilëndo e drejtë tjetër me të cilën ka qenë siguruar
përmbushja e kërkesës së tij, ose e humb nga pakujdesia dhe në ketë mënyrë bën të pamundur kalimin
e kësaj të drejte në dorëzanin, ky shkarkohet nga detyrimi i vet ndaj kreditorit për aq sa do të mund të
fitonte nga ushtrimi i kësaj të drejte.
2. Rregulla e paragrafit paraprak vlen si në rastin kur është fjala për të drejtën e lindur para lidhjes së
kontratës mbi dorëzaninë, ashtu edhe në rastin kur ka lindur pas kësaj.', 'c7346f629293cd48d57e6735f9b863f0ef55868141507519084e6d93d2c499c8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":224,"pageEnd":225,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1024, '1025', 'E drejta për të kërkuar kompensimin nga debitori', '1-2', 'Ligji 04/L-077
Neni 1025 - E drejta për të kërkuar kompensimin nga debitori

1. Dorëzani që ka përmbush detyrimin ndaj kreditorit, mund të kërkojë nga debitori t''i kompensojë të
gjitha ato që i ka paguar në llogari të tij si dhe kamatën nga data e pagesës.
2. Ai ka të drejtë në kompensimin e shpenzimeve të krijuara në konteste me kreditorin që nga momenti
kur e ka njoftuar debitorin mbi këtë konteste, si dhe në shpërblimin e dëmit në qoftë se ka ekzistuar.', '2ee78af952cca4cdef38ef327ba8eabecc89176f17d4498be34469a2743228ed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":225,"pageEnd":225,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1025, '1026', 'E drejta e dorëzanit të një debitori solidar', null, 'Ligji 04/L-077
Neni 1026 - E drejta e dorëzanit të një debitori solidar

Dorëzani i një prej disa debitorëve solidarë mund të kërkojë prej cilido prej tyre që t''i kompensojë aq sa
i ka paguar kreditorit, si dhe shpenzimet.', '5aa347990e71bc8457e8d4103775bf5e241bbd9949fb36c050f36f349d203796', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":225,"pageEnd":225,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1026, '1027', 'E drejta e dorëzanit në sigurimin paraprak', null, 'Ligji 04/L-077
Neni 1027 - E drejta e dorëzanit në sigurimin paraprak

Edhe para se ta përmbush kërkesën e kreditorit, dorëzani që është obliguar me dijen ose me pëlqimin e
debitorit, ka të drejtë të kërkojë nga debitori t''i japë sigurim të nevojshëm për kërkesat e tij eventuale në
rastet që vijojnë: në qoftë se debitori nuk e ka përmbushur detyrimin e vet në afatin e rrjedhjes për
pagesë, po që se kreditori ka kërkuar në rrugë gjyqësore arkëtimin nga dorëzani dhe në qoftë se
gjendja pasurore e debitorit është keqësuar mjaft pas lidhjes së kontratës mbi dorëzaninë.', 'cb74d10403bc77440c1d024314c36e46d43e70a6bdf6fde9f807142f80c954c0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":225,"pageEnd":225,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1027, '1028', 'Humbja e të drejtës së kompensimit', '1-2', 'Ligji 04/L-077
Neni 1028 - Humbja e të drejtës së kompensimit

1. Debitori mund të përdorë kundër dorëzanit, i cili pa dijen e tij ka bërë pagimin e kërkesës së
kreditorit, të gjitha mjetet juridike me të cilat në momentin e kësaj pagese ka mundur të refuzojë
kërkesën e kreditorit.
2. Dorëzani që ka paguar kërkesën e kreditorit, ndërsa për këtë gjë nuk e ka njoftuar debitorin, kështu
që edhe ky në padijeni për këtë pagesë e ka paguar përsëri të njëjtën kërkesë, nuk mund të kërkoje
kompensim nga debitori, por ka të drejtë të kërkojë nga kreditori që t''ia kthejë atë që ia ka paguar.', 'eb9cd890478f097db0f99b351d42c7d714a913efef82540faf38106e26cc0432', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":225,"pageEnd":225,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1028, '1029', 'E drejta për kthimin e pjesës së paguar', null, 'Ligji 04/L-077
Neni 1029 - E drejta për kthimin e pjesës së paguar

Dorëzani i cili pa dijen e debitorit e ka paguar kërkesën e kreditorit, e cila më pas me kërkesën e
debitorit është anuluar ose shuar me anë të kompensimit, mund vetëm të kërkojë nga kreditori kthimin
e pjesës së paguar.', 'f737424576a821cfb04e3a71773cbb33dfa23ac879c203b87fe52d865f5a5128', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":225,"pageEnd":225,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1029, '1030', 'E drejta e kompensimit nga dorëzanët tjerë', null, 'Ligji 04/L-077
Neni 1030 - E drejta e kompensimit nga dorëzanët tjerë

Kur ekzistojnë disa dorëzanë, ndërsa njëri prej tyre paguan kërkesën e rrjedhur për pagesë, ai ka të
drejtë të kërkojë prej dorëzanëve të tjerë që secili prej tyre t''ia kompensojë pjesën që i takon atij.', '4c7c37a01b362a57b4bf013e856566fbf68af8119e796215ab97afeea89ff5b5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":226,"pageEnd":226,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1030, '1031', null, '1-4', 'Ligji 04/L-077
Neni 1031

1. Me parashkrimin e detyrimit të debitorit kryesor shuhet edhe detyrimi i dorëzanit.
2. Kur afati për parashkrimin e detyrimit të debitorit kryesor është më i gjatë se dy (2) vjet, detyrimi i
dorëzanit parashkruhet pasi të kenë kaluar dy (2) vjet nga afati i rrjedhjes për pagesë të detyrimit të
debitorit kryesor, përveç nëse dorëzani përgjigjet solidarisht me debitorin.
3. Ndërprerje e parashkrimit të kërkesave ndaj debitorit kryesor ka efekt edhe ndaj dorëzanit vetëm në
qoftë se ndërprerja është shkaktuar nga ndonjë veprim i kreditorit para gjykatës kundër debitorit
kryesor.
4. Ngecja e parashkrimit të detyrimit të debitorit kryesor nuk ka efekt ndaj dorëzanit.', 'd86b933ae36abffb8a7ea4f35c6e3948abb8576df33c8771b4c06a6b27b5c4af', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":226,"pageEnd":226,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1031, '1032', 'Nocioni i kontratës', null, 'Ligji 04/L-077
Neni 1032 - Nocioni i kontratës

Me anë të asignacionit, një person, asignanti autorizon tjetrin, asignatin që për llogari të tij t’i kryejë
diçka të caktuar personit të tretë, marrësit të asignacionit asignatarit, dhe e autorizon këtë që të pranoj
këtë kryerje në emër të vet.', 'b88f09b8d4368e318ead1e50fd03bc993fa6e3088b2f14aa09877c1ef1128cdb', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":226,"pageEnd":226,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1032, '1033', 'Aprovimi nga ana e dërguesit', '1-2', 'Ligji 04/L-077
Neni 1033 - Aprovimi nga ana e dërguesit

1. Asignatari fiton të drejtën që të kërkojë nga asignati përmbushjen vetëm kur ky të deklarojë se e
pranon asignacionin (dërgimin).
2. Aprovimi i dërgimit nuk mund të revokohet.', '62a48a862b25a9816f70a6500e985f69fd9d68795293005529d5465d3e84a585', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":227,"pageEnd":227,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1033, '1034', 'Kundërshtimet e dërguesit', '1-2', 'Ligji 04/L-077
Neni 1034 - Kundërshtimet e dërguesit

1. Me pranimin e dërgimit midis marrësit të dërgimit dhe dërguesit formohet marrëdhënia e borxhit, i
pavarur nga raporti midis dërguesit dhe të dërguarit, si dhe nga raporti midis dërguesit dhe marrësit të
dërgimit.
2. Dërguesi që e ka pranuar dërgimin mund t’i theksojë marrësit të dërgimit vetëm kundërshtimet që
kanë të bëjnë me vlefshmërinë e aprovimit, kundërshtimet që bazohen në përmbajtjen e aprovimit ose
në përmbajtjen e vet asignacionit, si dhe kundërshtimet që ka personalisht ndaj tij.', '4a57d29d363e75411c777d24fd8f759a6b8be564c967cef374add666e976fc43', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":227,"pageEnd":227,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1034, '1035', 'Kalimi i asignacionit', '1-3', 'Ligji 04/L-077
Neni 1035 - Kalimi i asignacionit

1. Marrësi i asignacionit mund ta bëjë kalimin e dërgimit në një tjetër edhe përpara aprovimit nga ana e
dërguesit, ndërsa ky mund ta bëjë kalimin më tej, përveç kur nga vetë dërgimi ose nga rrethanat e
posaçme rrjedh se ai është i pabartshëm.
2. Në qoftë se asignati i ka deklaruar asignatarit se e pranon dërgimin, ky pranim ka efekt ndaj të gjithë
personave, në të cilët dërgimi do të bartej në mënyrë të parreshtur.
3. Në qoftë se asignati i ka deklaruar fituesit në të cilin marrësi i dërgimit e ka bartur asignacionin se e
aprovon atë, ai nuk mund t’i paraqesë fituesit kundërshtime që ka ndaj asignatarit personalisht.', '4018ce793d65510d94c25e4f5b7104acb2c9332d852247e4636839b439c02e6f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":227,"pageEnd":227,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1035, '1036', 'Parashkrimi', '1-2', 'Ligji 04/L-077
Neni 1036 - Parashkrimi

1. E drejta e asignatarit për të kërkuar përmbushjen nga asignati parashkruhet për një (1) vit.
2. Në qoftë se nuk është caktuar afati i përmbushjes, parashkrimi fillon të rrjedhë kur asignati ta
aprovojë asignacionin, e në qoftë se ai e ka aprovuar përpara se t’i jetë dhënë asignatarit, atëherë kur
t’i jetë dhënë këtij.', '2f7c89964a52b387c675e62c50d6b58458eb3794a79e5322315c167a923a353d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":227,"pageEnd":227,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1036, '1037', 'Në qoftë se asignatari është kreditor i asignatit', '1-2', 'Ligji 04/L-077
Neni 1037 - Në qoftë se asignatari është kreditor i asignatit

1. Kreditori nuk ka për detyrë ta pranojë asignacionin që ia ka bërë debitori me qëllim të përmbushjes
së detyrimit të vet, por ka për detyrë që për refuzimin e vet menjëherë ta njoftojë debitorin, përndryshe
do t’i përgjigjet për dëmin.
2. Kreditori që e ka aprovuar asignacionin ka për detyrë ta ftojë asignatin që ta zbatojë atë.', 'def2dbbdf7046180bca34d2173d864f993259e40377244cafcc393e3d6dea117', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":228,"pageEnd":228,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1037, '1038', 'Asignacioni nuk është përmbushja', '1-2', 'Ligji 04/L-077
Neni 1038 - Asignacioni nuk është përmbushja

1. Kur kreditori e ka aprovuar asignacionin e bërë nga debitori i tij me qëllim të përmbushjes së
detyrimit, ky detyrim nuk pushon, në qoftë se nuk është kontraktuar ndryshe as me aprovimin e tij të
asignacionit dhe as me aprovimin nga ana e asignatit, por vetëm me përmbushjen nga ana e asignatit.
2. Kreditori që e ka aprovuar asignacionin e bërë nga ana e debitorit të tij, mund të kërkojë nga
asignanti që t’i plotësojë atë që i debiton vetëm në qoftë se nuk ka marrë përmbushje nga asignati në
kohën e caktuar në asignacion.', '16b0c08f489f38962cb03c242430ee64995176feee8df617c799f7cfe3a6306e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":228,"pageEnd":228,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1038, '1039', 'Detyra e asignatarit për ta njoftuar asignantin', null, 'Ligji 04/L-077
Neni 1039 - Detyra e asignatarit për ta njoftuar asignantin

Në qoftë se asignati refuzon ta aprovojë asignacionin, e refuzon përmbushjen që kërkon prej tij
asignatari, ose deklaron që përpara se nuk do ta zbatojë, asignatari ka për detyrë ta njoftojë menjëherë
asignantin për këtë gjë, përndryshe do t’i përgjigjet për dëmin.', 'f9d1c73f03c2deafa952a831722feac7a7823ae8f6c765f843d6e9bcd226a4f6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":228,"pageEnd":228,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1039, '1040', 'Heqja dorë nga asignacioni i aprovuar', null, 'Ligji 04/L-077
Neni 1040 - Heqja dorë nga asignacioni i aprovuar

Asignatari që nuk është kreditori i asignantit dhe që nuk dëshiron që asignacionin ta përdorë mund të
heqë dorë prej tij, edhe në qoftë se ka deklaruar se e aprovon atë, por ka për detyrë që për këtë gjë ta
njoftojë asignantin pa vonesë.', 'a50d00f3af62fd607a298cf5708648e0ca4b55bec19c0a722dcd4859c2072e65', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":228,"pageEnd":228,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1040, '1041', 'Revokimi i autorizimit të dhënë marrësit të dërgesës', null, 'Ligji 04/L-077
Neni 1041 - Revokimi i autorizimit të dhënë marrësit të dërgesës

Asignanti mund ta revokojë autorizimin që me anë të asignacionit ia ka dhënë marrësit të asignacionit,
përveç se asignacionin e ka lëshuar me qëllim të përmbushjes së ndonjë borxhi të vet ndaj tij dhe në
përgjithësi në qoftë se asignacionin e ka lëshuar në interes të tij.', '22ca1979544e0e8a2df805e08359eb8165d46606f2d348b5830f32c02b5354e7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":228,"pageEnd":228,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1041, '1042', 'Në qoftë se asignati është debitor i asignantit', '1-3', 'Ligji 04/L-077
Neni 1042 - Në qoftë se asignati është debitor i asignantit

1. Asignati nuk ka për detyrë ta aprovojë asignacionin edhe nëse është debitor i asignantit, përveç nëse
ia ka premtuar këtë.
2. Kur asignacioni është lëshuar në bazë të borxhit të asignatit, asignati ka për detyrë ta zbatojë deri në
shumën e këtij borxhi, në qoftë se kjo nuk është në asnjë pikëpamje më e rëndë nga sa është
përmbushja e detyrimit ndaj asignantit.
3. Zbatimi i asignacionit të lëshuar në bazë të borxhit të asignatit, asignati shkarkohet në të njëjtën
masë nga borxhi i vet kundrejt asignantit.', 'e7aff8ca78986e57f663b681dc3d8e21b59e8de5ff74edb3d301bbeeddc74554', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":228,"pageEnd":228,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1042, '1043', 'Revokimi i autorizimit të dhënë asignatit', '1-3', 'Ligji 04/L-077
Neni 1043 - Revokimi i autorizimit të dhënë asignatit

1. Asignanti mund ta revokojë autorizimin të cilin me asignacion ia ka dhënë asignatit, gjithnjë gjersa ky
nuk i deklaron asignatarit se e aprovon asignacionin, apo se nuk e zbaton atë.
2. Ai mund ta revokojë edhe kur në vetë asignacion është shënuar se është i parevokueshëm, si dhe
kur nga revokimi do të ofendohej ndonjë detyrim i tij ndaj asignatarit.
3. Hapja e falimentimit mbi pasurinë e asignantit tërheq vetvetiu në bazë të ligjit revokimin e
asignacionit, përveç me rastin kur asignati e ka aprovuar këtë më parë asignacionin përpara hapjes së
falimentimit, si dhe kur në çastin e aprovimit nuk ka qenë në dijeni dhe as që ka mundur të ishte në
dijeni për këtë falimentim.', '6a5fcd05c60747238179725ce33d04768a29b4482ebb1d9843b0fdc8b6aea2ed', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":229,"pageEnd":229,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1043, '1044', 'Vdekja dhe privimi i aftësisë për të vepruar', null, 'Ligji 04/L-077
Neni 1044 - Vdekja dhe privimi i aftësisë për të vepruar

Vdekja e asignantit, asignatarit ose të asignatit, si dhe privimi i aftësisë për të vepruar të ndonjërit prej
tyre nuk ka ndikim në asignacion.', '306f8d68afbb4d0506c1d98f2d053d3c5e34d6d3e406578c191b4e0234b9bb69', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":229,"pageEnd":229,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1044, '1045', 'Asignacioni në formë të letrës së zotëruesit', '1-3', 'Ligji 04/L-077
Neni 1045 - Asignacioni në formë të letrës së zotëruesit

1. Asignacioni me shkrim mund t’i lëshohet zotëruesit.
2. Në këtë rast secili titullar (posedues) i letrës ka ndaj asignatit pozitën e asignatarit.
3. Raportet që me asignacion lindin midis asignatarit dhe asignantit, formohen në këtë rast vetëm midis
secilit posedues të veçantë të letrës dhe të personit që ia ka ceduar letrën.', 'fa618e5a795c4f7010323b63fc0b12361bdff9dcda066661bbc93e5876cf326f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":229,"pageEnd":229,"structuralContext":{"chapterTitle":"KREU 6"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1045, '1046', 'Asignacioni në formë të letrës sipas urdhërit', null, 'Ligji 04/L-077
Neni 1046 - Asignacioni në formë të letrës sipas urdhërit

Asignacioni shkresor që është i pagueshëm në të holla, në letrat me vlerë, oe në sendet e
zëvendësueshme, mund të lëshohet me dispozitën “sipas urdhërit”, në qoftë se asignati është person
që merret me veprimtari ekonomike dhe në qoftë se ajo që duhet të kryejë, bie në kuadrin e kësaj
veprimtarie.', 'b9910d07a42f58b7acaa2e8bbc32cedcdf928e090df3bcf17bf5eaf0267fb8fe', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":229,"pageEnd":229,"structuralContext":{"chapterTitle":"KREU 7"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1046, '1047', 'Përkufizimi', '1-2', 'Ligji 04/L-077
Neni 1047 - Përkufizimi

1. Me kontratën për ujdinë në mes të personave në kontest apo të cilët kanë paqartësi lidhur me ndonjë
marrëdhënie juridike, kontestet ndërpriten me ndihmën e lëshimeve reciproke, respektivisht eliminohen
pasiguritë dhe përcaktohen të drejtat dhe detyrimet e tyre reciproke.
2. Konsiderohet se ekziston një paqartësi edhe atëherë, nëse ushtrimi i një të drejte specifike është e
pasigurt.', 'c92ec4f6905fa2fd200b17cab1baf4602f3413998b2437245922b2e5098bf8c1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":230,"pageEnd":230,"structuralContext":{"chapterTitle":"KREU 7"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1047, '1048', 'Shtrirja e lëshimeve reciproke', '1-3', 'Ligji 04/L-077
Neni 1048 - Shtrirja e lëshimeve reciproke

1. Lëshimet mund të ekzistojnë, midis tjerash, në njohjen e pjesshme ose të plotë të ndonjë kërkese të
palës tjetër ose në heqjen dorë nga ndonjë kërkesë e vet, në marrjen mbi vete të ndonjë detyrimi të ri,
në zvogëlimin e shkallës së kamatës, në zgjatjen e afatit, në dhënien e pëlqimit për pagimin e kësteve
të pjesshme; në dhënien e të drejtës së pendimit.
2. Lëshimi mund të jetë me kusht.
3. Kur vetëm njëra palë i bën lëshim palës tjetër dhe njeh, p.sh. kërkesën e palës tjetër, atëherë kjo nuk
është ujdi dhe nuk i nënshtrohet rregullave të ujdisë.', '8cb36cbc87a243e2e5a6cb8ac5749ac7acdb14199e3d50afd929771e88f93467', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":230,"pageEnd":230,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1048, '1049', 'Aftësia', null, 'Ligji 04/L-077
Neni 1049 - Aftësia

Për lidhjen e kontratës për pajtimin është e nevojshme aftësia për disponim me të drejtën, e cila është
objekt i ujdisë.', 'f6d35df82a83f9d12cb00ed5491f8880f4235a46596c9897e4adcd1e8357d837', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":230,"pageEnd":230,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (1049, '1050', 'Objekti', '1-3', 'Ligji 04/L-077
Neni 1050 - Objekti

1. Objekt i ujdisë mund të jetë çdo e drejtë me të cilën mund të disponohet.
2. E vlefshme është ujdia për pasojat pasurore të një çështje penale.
3. Objekt i ujdisë nuk mund të jenë kontestet që u përkasin marrëdhënieve statusore.', '718ae67cce6d5b9da30c8428d00d5dc18d1de2d3ae37dd535b58bfeb9b0ca9d4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":230,"pageEnd":230,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
