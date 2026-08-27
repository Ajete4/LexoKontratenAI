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
  (600, '601', 'Denoncimi për shkak të mospagimit të qirasë', '1-2', 'Ligji 04/L-077
Neni 601 - Denoncimi për shkak të mospagimit të qirasë

1. Qiradhënësi mund ta denoncojë kontratën e qirasë, në qoftë se qiramarrësi nuk paguan qiranë dhe
këtë gjë nuk e bën as në afatin prej pesëmbëdhjetë (15) ditësh pasi qiradhënësi ta ketë ftuar që të
kryejë pagesën.
2. Mirëpo, kontrata do të mbetet ne fuqi në qoftë se qiramarrësi e paguan shumën e debituar të qirasë
para se t''i komunikohet denoncimi.', 'efe1cc7627125c56b952b021f858eb2f1837a77af8c954d5c9bc0c82abf49524', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":128,"pageEnd":128,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (601, '602', 'Kthimi i sendit të marrë me qira', '1-5', 'Ligji 04/L-077
Neni 602 - Kthimi i sendit të marrë me qira

1. Qiramarrësi ka për detyrë ta ruajë sendin e marrë me qira dhe pas mbarimit të qirasë ta kthejë të
padëmtuar.
2. Sendi kthehet në vendin ku është dorëzuar.
3. Qiramarrësi nuk përgjigjet për harxhimin e sendit që krijohet nga përdorimi i tij i zakonshëm, si dhe
për dëmtimet që rrjedhin nga vjetrimi i tij.
4. Në qoftë se gjatë kohës së qirasë ka bërë ndonjë ndryshim në send, ka për detyrë ta kthejë në
gjendjen në të cilën ndodhej kur i është dhënë me qira.
5. Ai mund ti marre me vete shtesat që ka bërë në send, në qoftë se mund të veçohen pa ndonjë
dëmtim të tij, por qiradhënësi mund t''i mbajë po qe se ia shpërblen vlerën e tyre në kohën e kthimit.', 'aafa2f432163cd08e8114bf027281998e28f0fbd0d530268c9f62988207ae420', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":128,"pageEnd":128,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (602, '603', 'Denoncimi për shkak të nënqirasë së palejueshme', null, 'Ligji 04/L-077
Neni 603 - Denoncimi për shkak të nënqirasë së palejueshme

Qiradhënësi mund ta denoncojë kontratën e qirasë në qoftë se sendi i marrë me qira është dhënë në
nënqira pa lejen e tij kur kjo sipas ligjit, ose sipas kontratës është e nevojshme.', 'c23ef921d915b7b2c3e3f11da795c36bff227c72a69af6098ad54cadb1c2f243', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":128,"pageEnd":128,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (603, '604', 'Kërkesa e drejteperdrejte e qiradhënësit', null, 'Ligji 04/L-077
Neni 604 - Kërkesa e drejteperdrejte e qiradhënësit

Qiradhënësi mundet për ti arkëtuar kërkesat e veta nga qiramarrësi të krijuara nga qiraja, të kërkojë
drejteperdrejte nga nënqiramarrësi pagimin e shumës që ky i debiton qiramarrësit ne bazë të nënqiras.', '4ece38a62ac0353974b79f02770ac89fd392a07be5044bec3c8949e3f12dc345', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":128,"pageEnd":128,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (604, '605', 'Shuarja e nënqirasë në bazë të vetë ligjit', null, 'Ligji 04/L-077
Neni 605 - Shuarja e nënqirasë në bazë të vetë ligjit

Nënqiraja shuhet në çdo rast kur shuhet qiraja.', 'be3311d0f109c7c99be3cc67adb37a1a56995bdc633f524c5abcaab413e42cf1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":128,"pageEnd":128,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (605, '606', 'Tjetërsimi pas dorëzimit me qira', '1-3', 'Ligji 04/L-077
Neni 606 - Tjetërsimi pas dorëzimit me qira

1. Në rast te tjetërsimit të sendit i cili para kësaj i është dorëzuar ndonjë tjetrit me qira fituesi i sendit
zene vendin e qiradhënësit, kështu që pas kësaj, të drejtat dhe detyrimet nga qiraja lindin midis tij dhe
për qiramarrësit.
2. Fituesi nuk mund të kërkojë nga qiramarrësi që t ia dorëzojë sendin para se të ketë kaluar koha për
të cilën është kontraktuar qiraja e në qoftë se kohëzgjatja e qirasë nuk është caktuar as me kontratë
dhe as me ligj, atëherë para skadimit të afatit të denoncimit.
3. Për detyrimet e fituesit nga qiraja ndaj qiramarrësit përgjigjet bartësi si dorzan solidar.', '6dc8bc57bef66d14b0d3218410a0144ef24157bc148f7a8f5d0c417e03fe139d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":129,"pageEnd":129,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (606, '607', 'E drejta e çmimit të qirasë', '1-2', 'Ligji 04/L-077
Neni 607 - E drejta e çmimit të qirasë

1. Ne qofte se nuk është kontraktuar diçka tjetër, fituesi i sendit të dorëzuar me qira ka të drejtë në
çmimin e qirasë, duke filluar që nga afati i parë i ardhshëm pas fitimit të sendit, nëse bartësi ka pranuar
qiranë që më parë, bartësi duhet të njëjtën t’ia ktheje fituesit.
2. Që nga momenti kur është njoftuar mbi tjetërsimin e sendit të marrë me qira, qiramarrësi mund t''ia
paguajë çmimin a qirasë vetëm fituesit.', '8f2f69bbccdcb647f74cbb0ea66765cab32606119d916d774bd2c485abab4c30', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":129,"pageEnd":129,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (607, '608', 'Tjetërsimi i sendit te marrë me qira para se t''i dorëzohet qiramarrësit', '1-3', 'Ligji 04/L-077
Neni 608 - Tjetërsimi i sendit te marrë me qira para se t''i dorëzohet qiramarrësit

1. Në qoftë se sendi për të cilin është lidhur kontrata e qirasë i është dorëzuar fituesit, e jo qiramarrësit,
fituesi zëne vendin e qiradhënësit dhe merr përsipër detyrimet e tij ndaj qiramarrësit në qoftë se në
momentin e lidhjes së kontratës mbi tjetërsimin ka qenë në dijeni për ekzistimin e kontratës së qirasë.
2. Fituesi i cili në momentin e lidhjes se kontratës mbi tjetërsimin nuk ka qenë në dijeni për ekzistimin e
kontratës së qirasë, nuk ka për detyrë t''ia dorëzojë qiramarrësit sendin, ndërsa qiramarrësi mund të
kërkojë vetëm shpërblimin e dëmit nga qiradhënësi.
3. Për detyrimet e fituesit nga dhënia me qira ndaj qiramarrësit përgjigjet bartësi si dorëzan solidar.', '88802a28ee9c68a8ac7327c2f0e402b204800eea49394ddfb545943413e2f261', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":129,"pageEnd":129,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (608, '609', 'Denoncimi i kontratës për shkak të tjetërsimi të sendit', null, 'Ligji 04/L-077
Neni 609 - Denoncimi i kontratës për shkak të tjetërsimi të sendit

Kur për shkak të tjetërsimit të sendit të marrë me qira të drejtat dhe detyrimet e qiradhënësit kalojnë në
fituesin, qiramarrësi mund ta denoncoj kontratën në çdo rast, duke respektuar afatet ligjore të
denoncoje.', '8c65ee9c016b641851944fc5be04c5733080538a4ca130f893c4ebc2d1ec7f8c', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":129,"pageEnd":129,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (609, '610', 'Kalimi i kohës së caktuar', '1-2', 'Ligji 04/L-077
Neni 610 - Kalimi i kohës së caktuar

1. Kontrata e qirasë e lidhur për një kohe të caktuar shuhet me vetë kalimin e kohës për të cilën është
lidhur.
2. E njëjta gjë vlen edhe në rastet kur në mungesë të vullnetit të kontraktuesve kohëzgjatja e qirasë
është caktuar me ligj.', 'bdd54d1eb49060c268f77f7d61ff345886117f38e6a84107ba7ed996ef2dfd85', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":130,"pageEnd":130,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (610, '611', 'Përtëritja heshtazi e qirasë', '1-2', 'Ligji 04/L-077
Neni 611 - Përtëritja heshtazi e qirasë

1. Kur pasi të ketë kaluar koha për të cilën është lidhur kontrata e qirasë, qiramarrësi vazhdon ta
përdorë sendin, ndërsa qiradhënësi nuk e kundërshton këtë, konsiderohet se është lidhur kontratë e re
e qirasë me kohëzgjatje të pacaktuar, në të njëjtat kushte sikurse edhe në ato paraprake.
2. Sigurimet të cilat personat e tretë kanë dhënë për qiranë e parë, shuhen me të kaluar koha për të
cilat është lidhur kontrata e pare.', '41d1f3a14fd0fceeeea5857d35d43c012f6d58e5c1c83e2768ebb6a42455da00', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":130,"pageEnd":130,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (611, '612', 'Denoncimi', '1-4', 'Ligji 04/L-077
Neni 612 - Denoncimi

1. Kontrata e qirasë kohëzgjatja e së cilës nuk është caktuar dhe as që mund të caktohet nga rrethanat
apo nga zakonet e vendit shuhet me denoncim të cilin secila palë mund t''ia japë tjetrës duke respektuar
afatin a caktuar të denoncimit.
2. Në qoftë se kohëzgjatja e afatit të denoncimit nuk është caktuar me kontratë ose me ligj apo me
zakonet e vendit, ndërsa ajo është tetë ditë por që denoncimi të mos mund të jepet në kohën jo të
duhur.
3. Në qoftë se sendet e marra me qira janë të rrezikshme për shëndetin, qiramarrësi mund ta
denoncoje kontratën pa e dhënë afatin e denoncimit edhe në qoftë se në momentin e lidhjes së
kontratës e ka ditur ketë.
4. Qiramarrësi nuk mund të heqë dorë nga e drejta e paraparë në paragrafin 3. të këtij neni.', '0098b27e493427408318469110e602a7eac5fafd8cca1204b1815124ebdfced0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":130,"pageEnd":130,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (612, '613', 'Shkatërrimi i sendeve për shkak të forcës madhore', '1-2', 'Ligji 04/L-077
Neni 613 - Shkatërrimi i sendeve për shkak të forcës madhore

1. Marrja me qira pushon në qoftë se sendi i marrë me qira shkatërrohet nga ndonjë rast i forcës
madhore.
2. Në qoftë se sendi i marrë me qira shkatërrohet pjesërisht ose vetëm dëmtohet, qiramarrësi mund ta
zgjidhë kontratën, ose të mbetet edhe më tej në qiramarrje dhe të kërkojë zbritjen përkatëse të çmimit
të qirasë.', 'a13c4f10746cf99da4e81014ab00d2556cd2475f07631082bb33ad693ce98b77', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":130,"pageEnd":130,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (613, '614', 'Vdekja', null, 'Ligji 04/L-077
Neni 614 - Vdekja

Në rast te vdekjes të qiramarrësit ose të qiradhënësit qiraja, vazhdon me trashëgimtarë të tij po që se
nuk është kontraktuar ndryshe.', 'f138f5d8299f4b4b66489b8c00dbb3ea6fa635a88d73ea28a0938e3fedb0fe56', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":130,"pageEnd":130,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (614, '615', 'Kuptimi', null, 'Ligji 04/L-077
Neni 615 - Kuptimi

Me kontratën për veprën kryerësi i punëve detyrohet të kryejë një punë të caktuar, sikurse është
prodhimi ose riparimi i ndonjë sendi ose kryerja e ndonjë pune fizike ose intelektuale e të ngjashme
kurse porositësi është i detyruar për atë të paguajë shpërblimin.', '3e1bb530c99ce67025fa5c8739ebf55876c7b87e1ede9249e49e86d51658b6f9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":131,"pageEnd":131,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (615, '616', 'Raporti me kontratën për shitjen', '1-3', 'Ligji 04/L-077
Neni 616 - Raporti me kontratën për shitjen

1. Kontrata me të cilën njëra palë detyrohet të prodhojë një send të caktuar të luajtshëm prej materialit
të vet konsiderohet në rast dyshimi kontratë për shitje.
2. Kontrata mbetet kontratë për veprën në qoftë se porositësi është detyruar të japë pjesën thelbësore
të materialit të nevojshëm për prodhimin e sendit.
3. Në çdo rast kontrata konsiderohet kontratë për vepër, në qoftë se kontraktuesit kanë pas për qëllim
veçanërisht punën e kryerësit.', 'a6985e29655a234642d2c292cbda007eaff910d27135213e0f8edbebd80b9974', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":131,"pageEnd":131,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (616, '617', null, null, 'Ligji 04/L-077
Neni 617

Cilësia e materialit të kryer ë sit
1. Në qoftë se është kontraktuar që kryerësi të prodhojë një send prej materialit të vet, ndërsa nuk
është caktuar cilësia, sipërmarrësi ka për detyrë të japë material të cilësisë së mesme.
2. Ai i përgjigjet porositësit për cilësinë e materialit njësoj si shitësi.', '0a155c37c5470f8832b222d2fc1d55d668fa5d7fe547d16502e9d19c96f7e1cf', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":131,"pageEnd":131,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (617, '618', 'Mbikëqyrja', null, 'Ligji 04/L-077
Neni 618 - Mbikëqyrja

Porositësi ka të drejtë të bëjë mbikëqyrjen e kryerjes së punës e të japë udhëzime kur kjo i përgjigjet
natyrës së punës, ndërsa kryerësi ka për detyrë t‘ia bëjë të mundur këtë.', '710829ac86ef08d90f5e7d549bae3ad0ba798b916c1582d3a7c2fd4a7c8bf25d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":131,"pageEnd":131,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (618, '619', 'Ftesa për ankand mbi çmimin e punimeve', '1-2', 'Ligji 04/L-077
Neni 619 - Ftesa për ankand mbi çmimin e punimeve

1. Ftesa e drejtuar numrit të caktuar ose të pacaktuar personash, në kushtet e caktuara dhe me
garancione të caktuara, detyron ftuesin të lidhë kontratën për ato punime me atë që ofron çmimin më të
ulët, përveç nëse këtë detyrim e ka përjashtuar me ftesën për ankand.
2. Në rastin e përjashtimit të detyrimit për të lidhë kontratën, ftesa për ankand konsiderohet si ftesë të
interesuarve që ata të bëjnë oferta të kontratës sipas kushteve të shpallura.', '9e2d82e4181b50ba6d5bcdcc9dc2dab51b5f54d0e3a8d5c056f40714d154d6c9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":132,"pageEnd":132,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (619, '620', 'Ftesa për ankand për zgjidhjen artistike ose teknike të punëve të synuara', null, 'Ligji 04/L-077
Neni 620 - Ftesa për ankand për zgjidhjen artistike ose teknike të punëve të synuara

Ftesa e drejtuar numrit të caktuar ose të pacaktuar personash për ankand për zgjidhjen artistike ose
teknike të punimeve të synuara, detyrojnë ftuesin që sipas kushteve të përmbajtura në ftesë për ankand
të lidhë kontratën me pjesëmarrësin e ankandit, zgjedhja e të cilit është pranuar nga komisioni me
përbërjen e shpallur që përpara, përveç nëse këtë detyrim e ka përjashtuar në ftesën e ankandit.', '080257c649dd6d47478f7e8124f4205a85def5b1143b6d3426630c3f4e48fd0b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":132,"pageEnd":132,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (620, '621', 'Te metat e materialit', '1-3', 'Ligji 04/L-077
Neni 621 - Te metat e materialit

1. Kryerësi ka për detyrë ta paralajmërojë porositësin për të metat e materialit që e ka dorëzuar
porositësi, që i ka vënë re ose është dashur t i vërejë, përndryshe do të përgjigjet për dëmin.
2. Në qoftë se porositësi i ka kërkuar që sendi të prodhohet prej materialit për të metat e të cilit kryerësi
i’a ka treguar, kryerësi ka për detyrë të veprojë sipas kërkesës së tij, përveç nëse është e qartë se
materiali nuk është i përshtatshëm për veprën e porositur ose në qoftë se prodhimi prej materiali të
kërkuar do të mund t’i bëjë dëm prestigjit të kryerësit , në të cilin rast kryerësi mund ta zgjidhë
kontratën.
3. Kryerësi ka për detyrë ta paralajmërojë porositësin për të metat në urdhrin e tij dhe për rrethana të
tjera që ishte në dijeni ose duhej të ishte në dijeni të cilat mund të jenë të rëndësishme për veprën e
porositur ose për kryerjen në kohë, përndryshe do të përgjigjet për dëmin.', '1bd2761ed8f3c1474b57989e7085172fdaa18841e4e71638902835cb734c9d51', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":132,"pageEnd":132,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (621, '622', 'Detyrimi për ta kryer veprën', '1-3', 'Ligji 04/L-077
Neni 622 - Detyrimi për ta kryer veprën

1. Kryerësi ka për detyrë ta kryejë veprën si është kontraktuar dhe sipas rregullave të punës.
2. Ai ka për detyrë ta kryejë veprën për kohën e caktuar, e në qoftë se kjo nuk është caktuar, atëherë
për një kohë të arsyeshme që nevojitet për punë të tilla.
3. Ai nuk përgjigjet për vonesë, të shkaktuar për shkak se porositësi nuk i’a ka dorëzuar materialin në
kohë, apo për shkak se ka kërkuar ndryshime, apo sepse nuk i’a ka paguar paradhënien e kontraktuar
dhe në përgjithësi për vonesë të shkaktuar nga sjellja e porositësit.', 'd568251c393cb4c988497193ba38f8fde2fc036f5d9df9b13f9bbf51f7777277', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":132,"pageEnd":132,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (622, '623', 'Zgjidhja e kontratës për shkak te shmangies nga kushtet e kontraktuara', '1-2', 'Ligji 04/L-077
Neni 623 - Zgjidhja e kontratës për shkak te shmangies nga kushtet e kontraktuara

1. Në qoftë se gjatë kryerjes së veprës tregohet se kryerësi nuk u përmbahet kushteve të kontratës dhe
në përgjithësi nuk punon si duhet, kështu që vepra e kryer do të ketë të meta, porositësi mund ta
paralajmërojë kryerësin për këtë dhe t’i caktojë afat plotësues që punën e vet t’ua përshtatë detyrimeve
të veta.
2. Në qoftë se deri në skadimin e këtij afati kryerësi i punës nuk vepron sipas kërkesës së porositësit,
ky mund ta zgjidhë kontratën dhe të kërkojë shpërblimin e dëmit.', 'eabacd3104d1ceaf7c9c405bc580643561bc8fd187f629caf0c76438e3786d2f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":133,"pageEnd":133,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (623, '624', 'Zgjidhja e kontratës para kalimit të afatit', '1-2', 'Ligji 04/L-077
Neni 624 - Zgjidhja e kontratës para kalimit të afatit

1. Në qoftë se afati është element thelbësor i kontratës, ndërsa kryerësi është aq në vonesë me fillimin
ose me kryerjen e punës, sa që është e qartë se nuk do ta kryejë brenda afatit, porositësi mund ta
zgjidhë kontratën dhe të kërkojë shpërblimin e dëmit.
2. Ai ka këtë të drejtë edhe atëherë kur afati nuk është element thelbësor i kontratës në qoftë se për
shkak të vonesës së tillë porositësi qartazi nuk do të kishte interes për përmbushjen e kontratës.', '2647fa4ff4762d260e028b55d6eba2a78f0776914c2b0d35220e3c973411046b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":133,"pageEnd":133,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (624, '625', 'Besimi i kryerjes së punës personit të tretë', '1-2', 'Ligji 04/L-077
Neni 625 - Besimi i kryerjes së punës personit të tretë

1. Në qoftë se nga kontrata ose nga vetë natyra e punës nuk rrjedh diçka tjetër, kryerësi nuk e ka për
detyrë që punën ta kryejë personalisht.
2. Kryerësi edhe me tej i përgjigjet personit për kryerjen e punës edhe kur punën nuk e kryen
personalisht.', 'ac6895e9b6d75b1fe88b4e37289346fc3a1cab1b72e479b27369bf21a8ae6298', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":133,"pageEnd":133,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (625, '626', 'Përgjegjësia për bashkëpunëtorët', null, 'Ligji 04/L-077
Neni 626 - Përgjegjësia për bashkëpunëtorët

Kryerësi përgjigjet për personat të cilët sipas urdhrit të tij kanë punuar në punën që e ka marrë përsipër
ta kryejë, sikur ta ketë kryer vet.', 'd4dcfc35f86e6a41a5c20b47cc77c653768667f83bd923ad5d4afce37f8822cc', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":133,"pageEnd":133,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (626, '627', 'Kërkesa e drejtpërdrejtë e bashkëpunëtorëve të kryerësit ndaj porositësit', null, 'Ligji 04/L-077
Neni 627 - Kërkesa e drejtpërdrejtë e bashkëpunëtorëve të kryerësit ndaj porositësit

Për arkëtimin e kërkesave të veta nga kryerësi, bashkëpunëtorët e tij mund t’i drejtohen drejtpërdrejt
porositësit dhe të kërkojnë prej tij që t’u paguajë këto kërkesa në ngarkim të shumës të cilën ai në këtë
çast i ka borxh kryerësit, në qoftë se këto kërkesa janë pranuar.', '3019c6949412d34e1aef70772e28494ff30289bb59d25fd48c684dc33e51d0e5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":133,"pageEnd":133,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (627, '628', 'Dorëzimi i sendit të prodhuar porositësit', '1-2', 'Ligji 04/L-077
Neni 628 - Dorëzimi i sendit të prodhuar porositësit

1. Kryerësi ka për detyrë që sendin e prodhuar ose të riparuar t’ia dorëzojë porositësit.
2. Kryerësi lirohet nga ky detyrim, në qoftë se sendi që e ka prodhuar ose riparuar shkatërrohet nga një
shkak, për të cilin ai nuk përgjigjet.', '18aca97acf21bb807f72f84f4fe5ffa5a42f0b455af1ddc0782247565556d087', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":133,"pageEnd":133,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (628, '629', 'Kontrollimi i veprës së kryer dhe njoftimi i kryesit', '1-3', 'Ligji 04/L-077
Neni 629 - Kontrollimi i veprës së kryer dhe njoftimi i kryesit

1. Porositësi ka për detyrë ta kontrollojë veprën e kryer, nëse sipas rrjedhës së rregullt të të punës ky
kontrollim është i mundur dhe për të metat e konstatuara pa shtyrje ta njoftojë kryerësin.
2. Në qoftë se porositësi nuk i përgjigjet ftesës së kryerësit që ta kontrollojë dhe pranojë veprën e kryer
pa ndonjë shkak të arsyeshëm, konsiderohet se vepra është pranuar.
3. Pas kontrollit dhe pranimit të punës së kryer, kryerësi nuk përgjigjet më për të metat që kanë mund të
vërehen me kontroll të zakonshme, përveç se ai ishte në dijeni për ato të meta dhe nuk e ka njoftuar
porositësin.', 'c653d38a8115e5fe46aac6292d0510ac8730801137ac50ddcb521bb97ff265c7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":134,"pageEnd":134,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (629, '630', 'Të metat e fshehura', '1-2', 'Ligji 04/L-077
Neni 630 - Të metat e fshehura

1. Në qoftë se më vonë konstatohet ndonjë e metë e cila nuk ka mund të zbulohet me kontroll të
zakonshëm, porositësi megjithatë mund të thirret në atë me kusht që për këtë ta njoftojë porositësin sa
më parë, por jo më vonë se në afatin prej një (1) muaji nga zbulimi i saj.
2. Me kalimin e dy (2) viteve nga pranimi i punës së kryer, porositësi nuk mundet më të thirret në të
meta.', '6abcdd57ba3ef657d8cb555dc2d03876ff87db377b8ab6781c4ddd7337776e8a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":134,"pageEnd":134,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (630, '631', 'Shuarja e së drejtës', '1-2', 'Ligji 04/L-077
Neni 631 - Shuarja e së drejtës

1. Porositësi i cili e ka njoftuar kryerësin me kohë për të metat e veprës së kryer nuk mund të realizojë
të drejtën e vet në rrugë gjyqësore pas kalimit të një (1) viti nga njoftimi i bërë.
2. Pas skadimit të këtij afati, porositësi mundet, në qoftë se për të metat e ka njoftuar në kohën e duhur
kryerësin e punës, me kundërshtim kundër kërkesës së kryerësit për pagimin e shpërblimit, të theksojë
të drejtën e vet për zbritjen e shpërblimit dhe shpërblimin e dëmit.', '66df1767db9479835ee5fec42f87ac7581befcdc3ad51823fb4951b4f051c41f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":134,"pageEnd":134,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (631, '632', 'Rastet kur kryerësi humb të drejtën të thirret në nenet paraprake', null, 'Ligji 04/L-077
Neni 632 - Rastet kur kryerësi humb të drejtën të thirret në nenet paraprake

Kryerësi nuk mund të thirret në ndonjë dispozitë të neneve paraprake kur e meta ka të bëjë me faktet
për të cilat ishte në dijeni ose nuk kanë mund t’i mbeten të panjohura, ndërsa për këto nuk e ka njoftuar
porositësin.', '6d788b625f46e9276e4621502052314ca1e9c1fe813526e2efd389615f38d31f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":134,"pageEnd":134,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (632, '633', 'E drejta e kërkesës për mënjanimin e të metave', '1-3', 'Ligji 04/L-077
Neni 633 - E drejta e kërkesës për mënjanimin e të metave

1. Porositësi i cili e ka njoftuar me rregull kryerësin se puna e kryer ka ndonjë të metë, mund të kërkojë
prej tij që të metën ta mënjanojë dhe për të t’ia caktojë afatin e arsyeshëm.
2. Ai ka të drejtë edhe për shpërblimin e dëmit që pëson për këtë arsye.
3. Në qoftë se mënjanimi i të metës kërkon shpenzime të tepruara, kryerësi mund të refuzojë ta kryejë,
por me këtë rast porositësit i takon, sipas zgjedhjes së tij, e drejta e zbritjes së shpërblimit ose zgjidhjes
së kontratës si edhe e drejta e shpërblimit të dëmit.', 'c247a3f2ae93a035d04a5147f02103643ab365529bdeb04a6372f1f5c72ce5c8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":134,"pageEnd":134,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (633, '634', 'Zgjidhja e kontratës në rastin e veçantë', null, 'Ligji 04/L-077
Neni 634 - Zgjidhja e kontratës në rastin e veçantë

Kur puna e kryer ka të metë të tillë sa që veprën e bën të papërdorshme ose është kryer në
kundërshtim me kushtet shprehimore të kontratës, porositësi mundet, duke mos kërkuar mënjanimin
paraprak të të metave, ta zgjidhë kontratën dhe të kërkojë shpërblimin e dëmit.', '319faf2d1ee801904a369a39626751d58824adafdefdf11f04ffd4ff4661e03a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":135,"pageEnd":135,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (634, '635', 'E drejta e porositësit në rastin e të metave të tjera të veprës së kryer', '1-5', 'Ligji 04/L-077
Neni 635 - E drejta e porositësit në rastin e të metave të tjera të veprës së kryer

1. Kur puna e kryer ka të metë, por vepra është megjithatë e përdorshme, respektivisht kur puna nuk
është kryer në kundërshtim me kushtet e parapara shprehimisht të kontratës, porositësi ka për detyrë ta
lejojë kryerësin që ta mënjanoj të metën.
2. Porositësi mund t’i caktojë kryerësit një afat të arsyeshëm për mënjanimin e të metave.
3. Në qoftë se kryerësi nuk e mënjanon të metën deri te kalimi i këtij afati, porositësi mundet sipas
zgjedhjes se tij ta kryejë mënjanimin në llogari të kryerësit ose ta zbres shpërblimin ose ta zgjidhë
kontratën.
4. Kur është fjala për të metë të parëndësishme, porositësi nuk mund të shërbehet me të drejtën e
zgjidhjes së kontratës.
5. Në çdo rast ai ka të drejtë edhe për shpërblimin e dëmit.', '802d4dd430a9a15a497fe0e2e4df0deff2bd0eee9fdc8bda7d56c24c8ef8bb33', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":135,"pageEnd":135,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (635, '636', 'Zbritja e shpërblimit', null, 'Ligji 04/L-077
Neni 636 - Zbritja e shpërblimit

Shpërblimi zbritet në përpjesëtim ndërmjet vlerës së punës së kryer pa të meta në kohën e lidhjes së
kontratës dhe vlerës që do të kishte puna e kryer me të meta në atë kohë.', 'c64c8bec61da826cbdfc12e46f15592b3b2eb031b7778053364294ae14dadf9b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":135,"pageEnd":135,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (636, '637', 'Detyrimi i pranimit të punës', null, 'Ligji 04/L-077
Neni 637 - Detyrimi i pranimit të punës

Porositësi ka për detyrë ta pranojë punën e kryer sipas dispozitave të kontratës dhe rregullave të
punës.', '156280d26210f3c727e44894a9fa95a15bd2b0353896b6b625b95bdb675387d9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":135,"pageEnd":135,"structuralContext":{"chapterTitle":"KREU 6"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (637, '638', 'Caktimi dhe pagimi i shpërblimit', '1-4', 'Ligji 04/L-077
Neni 638 - Caktimi dhe pagimi i shpërblimit

1. Shpërblimi caktohet me kontratë, në qoftë se nuk është caktuar me ndonjë tarifë të detyrueshme ose
me ndonjë akt tjetër të detyrueshëm.
2. Në qoftë se shpërblimi nuk është caktuar, gjykata cakton shpërblimin sipas vlerës së punës, sipas
kohës së nevojshme normalisht për punë të tillë dhe sipas shpërblimit të rëndomtë për këtë lloj të
punës.
3. Porositësi nuk ka për detyrë ta paguajë shpërblimin para se ta ketë kontrolluar dhe lejuar, përveç
nëse është kontraktuar ndryshe.
4. E njëjta gjë vlen në qoftë se është kontraktuar kryerja dhe dorëzimi i punëve pjesë-pjesë.', '6dfd09c187ce9de073a441e4f0a2465aebc9a021a083a92392fdf900929ce61a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":135,"pageEnd":135,"structuralContext":{"chapterTitle":"KREU 6"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (638, '639', 'Llogaritja me garanci shprehimore', '1-3', 'Ligji 04/L-077
Neni 639 - Llogaritja me garanci shprehimore

1. Në qoftë se shpërblimi është kontraktuar në bazë të llogaritjes me garanci shprehimore të kryerësit
për saktësinë e tij, ai nuk mund të kërkojë shtimin e shpërblimit as edhe në qoftë se në punim ka dhënë
më tepër punë dhe në qoftë se kryerja e punës ka kërkuar më tepër shpenzime se sa është
parashikuar.
2. Me këtë nuk përjashtohet zbatimi i rregullave për zgjidhjen dhe ndryshimin e kontratës për shkak të
ndryshimit të rrethanave
3. Në qoftë se shpërblimi është kontraktuar në bazë të llogaritjes pa garanci shprehimore të kryerësit
për saktësinë e tij dhe gjatë punës tejkalimi i llogarisë tregohet i pashmangshëm, kryerësi duhet për
këtë pa shtyrje ta njoftojë porositësin, përndryshe humb çdo kërkesë për shkak të shpenzimeve të
shtuara.', '2cc8088f1136e5d4c8a63ded1314ff12fb472a5f982b57762026a0bad9c4deb7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":136,"pageEnd":136,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (639, '640', 'Kur kryerësi e ka dhënë materialin', '1-3', 'Ligji 04/L-077
Neni 640 - Kur kryerësi e ka dhënë materialin

1. Në rast se kryerësi e ka dhënë materialin për prodhimin e sendit, kurse sendi dëmtohet ose
shkatërrohet për arsye të ndryshme para se t’i dorëzohet porositësit, rrezikun e mban kryerësi dhe nuk
ka të drejtë shpërblimin për materialin e dhënë e as për punën e tij.
2. Në qoftë se porositësi e ka kontrolluar punimin e kryer dhe e ka lejuar, konsiderohet se sendi i është
dorëzuar, ndërsa te kryerësi ka mbetur në ruajtje.
3. Në qoftë se porositësi është vonuar për shkak të mospranimit të sendit të ofruar, rreziku i shkatërrimit
ose i dëmtimit të rastësishëm të sendit kalon në atë.', 'e615ef0f2057fa688b497198ba2de2e87d665de8a657414ca47a17665776734b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":136,"pageEnd":136,"structuralContext":{"chapterTitle":"KREU 7"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (640, '641', 'Kur porositësi e ka dhënë materialin', '1-2', 'Ligji 04/L-077
Neni 641 - Kur porositësi e ka dhënë materialin

1. Rrezikun e shkatërrimit ose dëmtimit të rastësishëm e bartë kryerësi, në qoftë se ai e ka dhënë
materialin për prodhimin e sendit.
2. Në këtë rast, kryerësi ka të drejtë të shpërblimit vetëm në qoftë se sendi është shkatërruar ose
dëmtuar pas rënies së porositësit në vonesë ose në qoftë se porositësi nuk i është përgjigjur ftesës të
bërë me rregull për ta kontrolluar sendin.', '4263249e4af1a52869c64ccf6d54d7d488191e4faa00ade69f7901655f5efba3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":136,"pageEnd":136,"structuralContext":{"chapterTitle":"KREU 7"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (641, '642', 'Rreziku në rast të dorëzimit pjesë-pjesë', null, 'Ligji 04/L-077
Neni 642 - Rreziku në rast të dorëzimit pjesë-pjesë

Në qoftë se është kontraktuar se porositësi do ta bëjë kontrollin dhe pranimin e pjesëve të veçanta
ashtu si do të prodhohen, kryerësi ka të drejtë shpërblimi për prodhimin e pjesëve që i ka kontrolluar
dhe lejuar edhe në qoftë se ato pas tij do të shkatërroheshin tek ai pa fajin e tij.', '3bab33ecbe94fc110978dc99fa382fbf556c8df284c65b8e7e3c30297f3c0394', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":136,"pageEnd":136,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (642, '643', 'E drejta e pengut', null, 'Ligji 04/L-077
Neni 643 - E drejta e pengut

Për sigurimin e arkëtimit të kërkesave të shpërblimit për punën dhe shpërblimin e materialit të
shpenzuar dhe kërkesave të tjera në bazë të kontratës për vepër, kryerësi ka të drejtë pengu në sendet
që i ka prodhuar ose riparuar, si dhe në sende të tjera që i’a ka dorëzuar porositësi lidhur me punën e
tij, gjithnjë gjersa ato i mban dhe nuk pushon me vullnet t’i mbajë.', 'd14c81263bb37dc0c8493fae96a2b8eb7a55d3cc82866f4b68435f46c6812e38', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":137,"pageEnd":137,"structuralContext":{"chapterTitle":"KREU 8"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (643, '644', 'Zgjidhja e kontratës me vullnetin e porositësit', null, 'Ligji 04/L-077
Neni 644 - Zgjidhja e kontratës me vullnetin e porositësit

Derisa vepra e porositësit nuk është kryer, porositësi mund ta zgjidhë kontratën kur të dojë, por në atë
rast ka për detyrë t’i paguajë kryerësit shpërblimin e kontraktuar, të zvogëluar për shumën e
shpenzimeve që ky nuk i ka bërë e që do të kishte për detyrë t’i bënte po të mos zgjidhej kontrata si
edhe për shumën e fitimit që e ka realizuar në anën tjetër ose që me qëllim e ka lëshuar ta realizojë.', 'd970c89c52c0445a7527434b704a551de0062f53097b834a7e248f18fbeb39fd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":137,"pageEnd":137,"structuralContext":{"chapterTitle":"KREU 9"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (644, '645', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 645 - Nocioni

1. Kontrata për ndërtim është kontratë me të cilën kryerësi detyrohet sipas projektit të caktuar të
ndërtojë në afatin e caktuar ndërtesën e caktuar në tokën e caktuar, apo në një tokë të tillë respektivisht
në objektin tashmë ekzistues të kryejë punë të tjera ndërtimi, ndërsa porositësi detyrohet që për këtë t’i
paguajë çmimin e caktuar.
2. Kontrata për ndërtimin duhet të jetë e lidhur me shkrim.', '871dad517bc90147665d5e2ffb8da4cb0a4a5bed8d315e987217765278dd2971', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":137,"pageEnd":137,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (645, '646', 'Objektet ndërtimore', null, 'Ligji 04/L-077
Neni 646 - Objektet ndërtimore

Me fjalën "Objektet ndërtimore" në kuptim të kësaj pjese konsiderohen ndërtesat, digat, urat, ujësjellësi,
kanalizimi, rrugët, vijat hekurudhore, tunelet, puset dhe objekte të tjera ndërtimore, ndërtimi i të cilave
kërkon punë më të mëdha dhe më të ndërlikuara.', 'cb6c662987028bbb44087f7c07b3e1031e905a22e78dc23a0264678b453fd6c9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":137,"pageEnd":137,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (646, '647', 'Mbikëqyrja e punimeve dhe kontrolli i cilësisë së materialit', null, 'Ligji 04/L-077
Neni 647 - Mbikëqyrja e punimeve dhe kontrolli i cilësisë së materialit

Kryerësi i punës ka për detyrë t’ia bëjë të mundur porositësit mbikëqyrjen e vazhdueshme të punimeve
dhe kontrollin e sasisë dhe cilësisë së materialit të përdorur.', 'f717c0d95aeee02aa318dd80207d4545ff3185d9519ed010d35b67ad853ca253', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":138,"pageEnd":138,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (647, '648', 'Shmangie nga projekti', '1-2', 'Ligji 04/L-077
Neni 648 - Shmangie nga projekti

1. Për çdo shmangie nga projekti i ndërtimit respektivisht nga punimet e kontraktuara, kryerësi duhet të
ketë pëlqimin me shkrim të porositësit.
2. Ai nuk mund të kërkojë ngritje të çmimit të kontraktuar për punimet që i ka kryer pa pëlqimin e këtillë.', 'a2e19fd05a094562a176073882d5db7920e556155bbc7afea535a44d088b6d78', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":138,"pageEnd":138,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (648, '649', 'Punimet urgjente të paparashikueshme', '1-6', 'Ligji 04/L-077
Neni 649 - Punimet urgjente të paparashikueshme

1. Kryerësi mund t’i kryejë punimet e paparashikuara edhe pa pëlqimin paraprak të porositësit, në qoftë
se për shkak të urgjencës së tyre nuk ka pasur mundësi ta marrë këtë pëlqim.
2. Punime të paparashikuara janë ato, ndërmarrja e të cilave ka qenë e domosdoshme për shkak të
stabilitetit të objektit apo për parandalimin e shkaktimit të dëmit e që janë shkaktuar nga natyra e
papritur më e rëndë e tokës me paraqitjen e papritur të ujit ose nga ndonjë ngjarje tjetër e
jashtëzakonshme dhe e papritur.
3. Kryerësi ka për detyrë që pa vonesë të njoftojë porositësin për këto fenomene dhe për masat e
marra.
4. Kryerësi ka të drejtë për shpërblim të drejtë për punimet e paparashikueshme që është dashur të
kryhen.
5. Porositësi mund ta zgjidhë kontratën në qoftë se për shkak të këtyre punimeve, çmimi kontraktues do
të duhej të shtohej konsiderueshëm për të cilën gjë ka për detyrë që pa shtyrje ta njoftojë kryerësin e
punimeve.
6. Në rastin e zgjidhjes së kontratës, porositësi ka për detyrë t’i paguajë kryerësit të punimeve pjesën
përkatëse të çmimit për punimet e kryera, si edhe një shpërblim të drejtë për shpenzimet e
domosdoshme të bëra.', '1fda153337d145c927f90be5d11cf3f7a0bc419e936f76e6f6e18a8e14ac7c19', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":138,"pageEnd":138,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (649, '650', 'Çmimi i punimeve', null, 'Ligji 04/L-077
Neni 650 - Çmimi i punimeve

Çmimi i punimeve mund të caktohet sipas njësisë së matjes së punimeve të kontraktura (çmimi i
njësisë) ose në shumë të tërësishme për tërë objektin (çmimi total i kontraktuar).', '8178a3eb66f61a7409314ffc710758f1025ef2e3d42a85dc946f5e73628e5816', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":138,"pageEnd":138,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (650, '651', 'Ndryshimi i çmimit', '1-4', 'Ligji 04/L-077
Neni 651 - Ndryshimi i çmimit

1. Në qoftë së me kontratë lidhur me ndryshimin e çmimit nuk është parashikuar diçka tjetër, kryerësi
që e ka kryer detyrimin e vet në afatin e parashikuar mund të kërkojë rritjen e çmimit të punimeve në
qoftë se në kohën midis lidhjes së kontratës e të përmbushjes së saj kanë ndryshuar çmimet e
elementeve në bazë të cilave është caktuar çmimi i punimeve, kështu që do të duhej që ky çmim të
ishte më i madh për më shumë se dy përqind (2%).
2. Në rastin kur kryerësi i punimeve me faj të vet nuk i ka kryer punimet në afatin e parashikuar me
kontratë, ai mund të kërkojë rritjen e çmimit të punimeve në qoftë se në kohën midis lidhjes së
kontratës dhe ditës kur sipas kontratës është dashur të përfundoheshin punimet e elementeve në bazë
të të cilave është caktuar, kështu që ky do të duhej sipas çmimeve të reja të këtyre elementeve të ishte
më i madh për më se pesë për qind.
3. Në rastet nga paragrafët e mësipërm, kryerësi mund të kërkojë vetëm diferencën në çmimin e
punimeve që tejkalon dy (2%) përkatësisht pesë përqind (5%).
4. Kryerësi nuk mund të thirret në rritjen e çmimit të elementeve në bazë të të cilave është caktuar
çmimi i punimeve, në qoftë se deri te rritja e çmimit ka ardhur pas ardhjes së tij në vonesë.', 'f8453f37d2de3799295abee6553504e153c4c46f883d815a6a943dc53ac6dc07', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":138,"pageEnd":139,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (651, '652', 'Dispozitat për pandryshueshmërinë e çmimeve', '1-2', 'Ligji 04/L-077
Neni 652 - Dispozitat për pandryshueshmërinë e çmimeve

1. Në qoftë se është kontraktuar së çmimi i punimeve nuk do të ndryshojë, në rastin kur pas lidhjes së
kontratës rriten çmimet e elementeve, në bazë të të cilave është caktuar çmimi i punimeve, kryerësi
mund të kërkojë megjithëse ekziston një dispozitë e tillë e kontratës, ndryshimin e çmimit të punimeve,
në qoftë se çmimet e elementeve janë rritur në atë masë që çmimi i punimeve do të duhej të ishte më i
madh se dhjetë përlind (10%).
2. Mirëpo, edhe në këtë rast kryesi mund të kërkojë vetëm diferencën në çmimin që tejkalon dhjetë për
qind, përveç nëse shtimi i çmimit të elementeve ka ardhur si pasojë e vonesës së tij.', '1e2a9cdbfaf0e1ce545bf9bc80a71107f79f7f796ae814526e271a8ddd1a64ee', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":139,"pageEnd":139,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (652, '653', 'Zgjidhja e kontratës për shkak të rritjes së çmimit', '1-2', 'Ligji 04/L-077
Neni 653 - Zgjidhja e kontratës për shkak të rritjes së çmimit

1. Në qoftë se në rastet nga nenet paraprake çmimi kontraktues do të duhej të rritej konsiderueshëm,
porositësi mund ta zgjidhë kontratën.
2. Në rastin e zgjidhjes së kontratës, porositësi ka për detyrë t’i paguajë kryerësit pjesën përkatëse të
çmimit të kontraktuar për punimet e kryera gjer atëherë, si edhe shpërblimin e drejtë për shpenzimet e
domosdoshme të bëra.', '76aa7e2165e177a6d52e46002dc2b455825cdb938a781ff8577f37e9c003861e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":139,"pageEnd":139,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (653, '654', 'E drejta e porositësit për të kërkuar zbritjen e çmimit të kontraktuar', '1-3', 'Ligji 04/L-077
Neni 654 - E drejta e porositësit për të kërkuar zbritjen e çmimit të kontraktuar

1. Në qoftë se në kohën midis lidhjes së kontratës dhe përmbushjes së detyrimit të kryerësit janë zbritur
çmimet e elementeve në bazë të cilave është caktuar çmimi i punimeve për më tepër se dy për qind
(2%), kurse punimet janë kryer brenda afatit të kontraktuar, porositësi ka të drejtë të kërkojë zbritjen
përkatëse të çmimit të kontraktuar të punimeve mbi këtë përqindje.
2. Në qoftë se është kontraktuar pandryshueshmëria e çmimit të punimeve, ndërsa këto janë kryer në
afat të kontraktuar, porositësi ka të drejtë për zbritje të kontraktuar në rastin kur çmimet e elementeve,
në bazë të të cilave është caktuar çmimi i punimeve, janë zbritur aq sa çmimi do të ishte më i vogël për
më tepër se dhjetë për qind e pikërisht për diferencën në çmim prej më se dhjetë për qind (10%).
3. Në rastin e vonesës së kryesit të punimeve, porositësi ka të drejtë për zbritjen proporcionale te
çmimit të punimeve për çdo zbritje të çmimit të elementeve, në bazë të cilave është caktuar çmimi i
punimeve.', 'd0894c7af6f1bc2ff809952519864200a139059289688ece66429de18926e2be', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":139,"pageEnd":139,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (654, '655', 'Kontrata për ndërtimin me dispozitë të veçantë', '1-3', 'Ligji 04/L-077
Neni 655 - Kontrata për ndërtimin me dispozitë të veçantë

1. Në qoftë se kontrata për ndërtimin përmban dispozitën "çelësi në dorë" ose ndonjë dispozitë tjetër të
ngjashme, kryerësi detyrohet në mënyrë të pavarur që të kryejë së bashku të gjitha punimet e
nevojshme për ndërtimin dhe përdorimin e objektit të caktuar të tërësishëm.
2. Në këtë rast çmimi i kontraktuar përfshin edhe vlerën e të gjitha punimeve të paparashikuara e të
tepricës së punimeve, ndërsa përjashton ndikimin e mungesave të punimeve në çmimin e kontraktuar.
3. Në qoftë se në kontratën "çelësi në dorë" marrin pjesë disa kryerës si palë kontraktuese, përgjegjësia
e tyre ndaj porositësit është solidare.', '3f56a8d61334532445861c077a21ae9eab3657d400ed04017627e2c56b2e3784', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":140,"pageEnd":140,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (655, '656', 'Zbatimi i rregullave të kontratës për veprën', null, 'Ligji 04/L-077
Neni 656 - Zbatimi i rregullave të kontratës për veprën

Në qoftë se në këtë pjesë nuk është caktuar ndryshe, për përgjegjësinë për të metat e godinës
zbatohen dispozitat përkatëse të kontratës për veprën.', '33ee9a29b250ba3749cefc0ba51d5790ad64287e81e69be97fea47cffe95f449', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":140,"pageEnd":140,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (656, '657', 'Kalimi i të drejtave nga përgjegjësia për të metat', null, 'Ligji 04/L-077
Neni 657 - Kalimi i të drejtave nga përgjegjësia për të metat

Të drejtat e porositësit ndaj kryerësit për shkak të të metave të godinës kalojnë edhe në të gjithë fituesit
e mëvonshëm të godinës ose të pjesës së saj, por fitueseve të mëvonshëm nuk u rrjedh afati i ri për
njoftim dhe padi, por u llogaritet afati i paraardhësve.', 'eefed4ca79e7d3344f2d5c2cea2031029cf222631e404f623a6d90102aa8eb48', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":140,"pageEnd":140,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (657, '658', 'Nga çka përbëhet', '1-5', 'Ligji 04/L-077
Neni 658 - Nga çka përbëhet

1. Kryerësi përgjigjet për të metat e ndërtimit të godinës që i përkasin soliditetit të saj, në qoftë se këto
të meta do të paraqiteshin për një kohë prej dhjetë (10) vitesh nga dorëzimi dhe pranimi i punimeve.
2. Kryerësi përgjigjet edhe për të metat e tokës në të cilën është ngritur godina, të cilat do të
tregoheshin për një kohë prej dhjetë vjetësh nga dorëzimi dhe pranimi i punimeve, përveç nëse
organizata e specializuar e ka dhënë mendimin profesional se toka është e përshtatshme për ndërtim,
kurse gjatë ndërtimit nuk janë paraqitur rrethana që e vijnë në dyshim bazueshmërinë e mendimit
profesional.
3. E njëjta gjë vlen edhe për projektuesin në qoftë se e meta e godinës rrjedh nga ndonjë e metë në
plan.
4. Ata janë përgjegjës sipas paragrafëve të mësipërm jo vetëm ndaj porositësit por edhe çdo fituesi
tjetër të godinës.
5. Kjo përgjegjësi e tyre nuk mund të përjashtohet e as të kufizohet me kontratë.', '89dba485b532569554459479af0e14fe125bb273a08ab289acecd82376a1d504', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":140,"pageEnd":141,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (658, '659', 'Detyra e njoftimit dhe humbja e të drejtave', '1-3', 'Ligji 04/L-077
Neni 659 - Detyra e njoftimit dhe humbja e të drejtave

1. Porositësi ose fituesi tjetër ka për detyrë që për të metat ta njoftojë kryerësin dhe projektuesin e
punimeve në afat prej gjashtë (6) muajsh, prej kur e ka konstatuar të metën, përndryshe humb të
drejtën që të thirret në te.
2. E drejta e porositësit ose e fituesit tjetër ndaj kryerësit respektivisht ndaj projektuesit sipas bazës së
përgjegjësisë së tyre për të metat shuhet brenda një (1) viti duke llogaritur nga dita kur porositësi
respektivisht fituesi e ka njoftuar projektuesin, përkatësisht kryerësin e punimeve për të metën.
3. Kryerësi i punimeve apo projektuesi nuk mund të referohet në dispozitat e paragrafëve të mësipërm
nëse defekti ka të bëjë me faktet që kanë qenë të njohura apo nuk kanë mundur të ngelin të panjohura
dhe se kanë dështuar të njoftojnë porositësin, respektivisht fituesin tjetër, ose përmes veprimit të tyre
ata e kanë keqinformuar porositësin, respektivisht fituesin, në atë mënyrë që ta bëjnë atë të mos ketë
mundësi ta shfrytëzojnë këtë të drejtë me kohë.', '83c34751713ad30dceb08faa21a1683e9e6d0d21e1bdcde1fd956e0843f9b965', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":141,"pageEnd":141,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (659, '660', 'Zvogëlimi dhe përjashtimi i përgjegjësisë', '1-2', 'Ligji 04/L-077
Neni 660 - Zvogëlimi dhe përjashtimi i përgjegjësisë

1. Kryerësi nuk lirohet nga përgjegjësia në qoftë se dëmi është shkaktuar për shkak se gjatë kryerjes së
punimeve të caktuara ka vepruar sipas kërkesave të porositësit.
2. Në qoftë se para kryerjes së punës së caktuar sipas kërkesës së porositësit ia ka tërhequr vërejtjen
për rrezikun nga dëmi, përgjegjësia e tij zvogëlohet dhe sipas rrethanave të rastit konkret, mundet edhe
të përjashtohet.', '136dc80224f37a83e555732211ed6bac4ce93cc6299dfadd3f4179b990a0cf64', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":141,"pageEnd":141,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (660, '661', 'Regresi', '1-4', 'Ligji 04/L-077
Neni 661 - Regresi

1. Kur për dëmin janë përgjegjës kryerësi dhe projektuesi, përgjegjësia e secilit prej tyre caktohet sipas
madhësisë së fajit të tij.
2. Projektuesi që e ka hartuar projektin e godinës dhe të cilit i është besuar mbikëqyrja e kryerjes së
punimeve të planifikuara përgjigjet edhe për të metat në punimet e bëra të shkaktuara me faj të
kryerësit të punimeve, në qoftë se ka mundur t’i vinte re me mbikëqyrjen normale dhe të arsyeshme të
punimeve, por ka të drejtë të kërkojë nga kryerësi i punimeve shpërblimin përkatës.
3. Kryerësi i punimeve që e ka shpërblyer dëmin e shkaktuar për shkak të të metave në punimet e
kryera ka të drejtë të kërkojë shpërblimin nga projektuesi në masën në të cilën të metat në punimet e
kryera rrjedhin prej të metave në projekt.
4. Nëse për të metën është përgjegjës një person, të cilit kryerësi i’a ka besuar kryerjen e një pjese të
punës, atëherë kryerësi duhet – nëse dëshiron shpërblim prej atij personi - të njoftojë për ekzistimin e të
metës në afat prej dy (2) muajsh, duke e llogaritur nga dita kur ai vet ka qenë i njoftuar nga porositësi
për të njëjtën të metë.', '8fbbb008131facaec24ed57587f267f7b784e4868ff98b3d98fda92f682c408a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":141,"pageEnd":141,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (661, '662', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 662 - Nocioni

1. Me kontratën për transportin detyrohet transportuesi që të transportojë në vendin e caktuar ndonjë
person ose send, ndërsa udhëtari, respektivisht dërguesi detyrohet që për këtë t’i paguajë shpërblimin
e caktuar.
2. Transportuesi sipas këtij ligji konsiderohet si personi i cili merret me transport si punë të rregullt të tij,
ashtu edhe çdo person tjetër i cili detyrohet me kontratë të kryejë transportin me shpërblim.', '7da6def09397ae9b123593fc6b0811ab8b7daefbd8e1b1c4b145def434ea1de3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":142,"pageEnd":142,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (662, '663', 'Detyrimet e transportuesit në transportin liniar', '1-3', 'Ligji 04/L-077
Neni 663 - Detyrimet e transportuesit në transportin liniar

1. Transportuesi i cili kryen transportin në një linjë të caktuar (transporti liniar) ka për detyrë që
rregullisht dhe në gjendje të rregullt të mbajë linjën e shpallur.
2. Ai ka për detyrë të pranojë për transport çdo person dhe çdo send që përmbushin kushtet e caktuara
me kushtet e përgjithshme të shpallura.
3. Në qoftë se mjetet e rregullta të transportit të transportuesit nuk mjaftojnë për kryerjen e të gjitha
transporteve të kërkuara, përparësi kanë personat ose sendet për të cilat kjo është parashikuar me
dispozita të veçanta, ndërsa përparësia e mëtejshme caktohet sipas radhës së kërkesave, por midis
kërkesave të njëkohshme përparësia caktohet sipas gjatësisë më të madhe të transportit.', 'e58af442985e59f67ef20237e8ca9e7fbac6a501b0293c8d7e7c3c8b4e89e9ec', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":142,"pageEnd":142,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (663, '664', 'Denoncimi i kontratës', '1-2', 'Ligji 04/L-077
Neni 664 - Denoncimi i kontratës

1. Dërguesi, respektivisht udhëtari mund të denoncojë kontratën para se të fillojë përmbushja e saj, por
ka për detyrë ta shpërblejë dëmin të cilin transportuesi do ta pësonte për këtë shkak.
2. Kur transportuesi vonon me fillimin e transportit aq sa pala tjetër nuk ka më interes për transportin e
kontraktuar, ose kur transportuesi nuk mund ose nuk donë të kryejë transportin e kontraktuar, pala
tjetër mund të denoncoj nga kontrata dhe të kërkojë kthimin e shpërblimit të paguar për transportin.', 'f2de6ce4c9bc0528524fcaac678763e694dcf1ebe2e65121f2088a1e0e01ef99', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":142,"pageEnd":142,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (664, '665', 'Shuma e shpërblimit për transport', '1-3', 'Ligji 04/L-077
Neni 665 - Shuma e shpërblimit për transport

1. Në qofte se shuma e shpërblimit për transport është caktuar me tarifë ose me ndonjë akt tjetër
detyrues të shpallur, nuk mund të kontraktohet shpërblimi më i madh.
2. Në qoftë se shuma e shpërblimit për transport nuk është caktuar me tarifë ose me ndonjë akt
detyrues tjetër të shpallur e as me kontratë, transportuesi ka të drejtë për shpërblim të zakonshëm për
këtë lloj transporti.
3. Në pjesën tjetër në mënyrë përkatëse zbatohen dispozitat për shpërblimin të përmbajtura në pjesën
e këtij ligji për kontratën për veprën.', '81056482ce94f6d89b26fae27936c4da3c8365153f60100f28a568a617c50a8a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":142,"pageEnd":142,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (665, '666', 'Kufizimi i zbatimit të dispozitave të kësaj pjese', null, 'Ligji 04/L-077
Neni 666 - Kufizimi i zbatimit të dispozitave të kësaj pjese

Dispozitat e kësaj pjese zbatohen në të gjitha llojet e transportit, në qoftë se me ligj për lloje të veçanta
nuk është caktuar ndryshe.', '178dbc99969fe422f376f75a3fa585e36566969b3cd2cbc5ee31242219245927', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":143,"pageEnd":143,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (666, '667', 'Dorëzimi i sendeve', null, 'Ligji 04/L-077
Neni 667 - Dorëzimi i sendeve

Transportuesi ka për detyrë që sendin të cilin e ka pranuar për transport t’ia dorëzojë në vendin e
caktuar dërguesit ose personit të caktuar (marrësit).', '642ebec5d84fd6f89704da64905ec9b6ed3c1edcd4a184b6822136b755cbd970', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":143,"pageEnd":143,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (667, '668', 'Detyrat e dërguesit për ta njoftuar transportuesin', '1-4', 'Ligji 04/L-077
Neni 668 - Detyrat e dërguesit për ta njoftuar transportuesin

1. Dërguesi ka për detyrë ta njoftojë transportuesin për llojin e dërgesës dhe për përmbajtjen dhe
sasinë e saj dhe t''i komunikojë se ku duhet të transportohet dërgesa, emrin dhe adresën e marrësit të
dërgesës, emrin dhe adresën e vet, si dhe çdo gjë të nevojshme që transportuesi të mund t''i
përmbushë detyrimet e veta pa shtyrje dhe pengesa.
2. Kur në dërgesë ndodhen sende te çmueshme, letra me vlerë ose sende tjera të shtrenjta, dërguesi
ka për detyrë që për këtë ta njoftojë transportuesin në momentin e dorëzimit të tyre për transport dhe
t’ia komunikojë vlerën e tyre.
3. Kur është fjala për transportin e sendeve të rrezikshme ose të sendeve për të cilat nevojiten kushte
të veçanta të transportit, dërguesi ka për detyrë që për këtë ta njoftojë transportuesin me kohë, kështu
që ai do të mund të ndërmerr masa përkatëse të veçanta.
4. Në qoftë se dërguesi nuk i jep transportuesit të dhënat nga paragrafi 1. dhe 3. të këtij neni, ose i jep
gabimisht përgjigjet për dëmin që do të shkaktohej për shkak të kësaj.', 'c3281e0060043acf7ca20f513715704a1a98b401ff93c74a790d950f58720bb8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":143,"pageEnd":143,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (668, '669', 'Fletëngarkesa', '1-5', 'Ligji 04/L-077
Neni 669 - Fletëngarkesa

1. Kontraktuesit mund të merren vesh që për dërgesën e dorëzuar për transport të përpilohet
fletëngarkesa.
2. Fletëngarkesa duhet të përmbajë emrin dhe adresën e dërguesit e të transportuesit, llojin,
përmbajtjen dhe sasinë e dërgesës, si dhe vlerën e sendeve të çmueshme dhe sendeve të tjera të
shtrenjta, vendin e destinimit, shumën e shpërblimit për transport, respektivisht shënimin se shpërblimi
është parapaguar, dispozitën për shumën me të cilën është ngarkuar dërgesa, vendi dhe dita e lëshimit
të fletëngarkesës.
3. Në fletëngarkesë mund të futen edhe dispozita të tjera të kontratës për transportin.
4. Fletëngarkesa duhet të jetë e nënshkruar nga të dy kontraktuesit.
5. Fletëngarkesa mund të përmbajë dispozitën "sipas urdhrit" ose të jetë e shënuar në prurësin.', '307ef2b88d3ffce98ac2f2575352875585ec1268c36e8bc3147e744c53053e09', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":143,"pageEnd":144,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (669, '670', 'Kontrata për transportin dhe fletëngarkesa', null, 'Ligji 04/L-077
Neni 670 - Kontrata për transportin dhe fletëngarkesa

Ekzistimi dhe vlefshmëria juridike e kontratës për transportin janë të pavarura nga ekzistimi i
fletëngarkesës dhe nga saktësia e saj.', 'ec6129bd0d26ee471244045ae45f357d8679fcb1ccd18bf815d086c7aa6ec5d4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":144,"pageEnd":144,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (670, '671', 'Vërtetimi për marrjen në dorëzim për transport', null, 'Ligji 04/L-077
Neni 671 - Vërtetimi për marrjen në dorëzim për transport

Në qoftë se nuk është dhënë fletëngarkesa, dërguesi mund të kërkojë nga transportuesi që t’i lëshojë
vërtetimin për marrjen e dërgesës për transport me të dhënat që duhet t’i përmbajë fletëngarkesa.', 'f89dab0b037b65e90e8b6214b39a663414b0be28ec052637d14323ab2dfa2ce8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":144,"pageEnd":144,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (671, '672', 'Paketimi', '1-5', 'Ligji 04/L-077
Neni 672 - Paketimi

1. Dërguesi ka për detyrë t’i paketojë sendet sipas mënyrës së parashikuar ose të praktikuar, kështu që
të mos shkaktohet ndonjë dëm ose të rrezikohet siguria e njerëzve ose e të mirave.
2. Transportuesi ka për detyrë të paralajmërojë dërguesin për të metat e paketimit që mund të vihen re,
përndryshe përgjigjet për dëmtimin e dërgesës që do të shkaktohej për shkak të këtyre të metave.
3. Transportuesi nuk përgjigjet për dëmtimin e dërgesës në qoftë se dërguesi, megjithëse iu ka tërhequr
vërejtja për të metat e paketimit, ka kërkuar që transportuesi ta pranojë dërgesën për transport me këto
të meta.
4. Transportuesi ka për detyrë që të refuzojë dërgesën në qoftë se të metat në paketimin e saj janë të
tilla sa që mund të rrezikohet siguria e personave ose e të mirave, ose të shkaktohet ndonjë dëm.
5. Për dëmin që për shkak të metës në paketim e pësojnë personat e tretë deri sa sendi ndodhet te
transportuesi, përgjigjet transportuesi, ndërsa ky ka të drejtë të kërkojë shpërblimin nga dërguesi.', '36fde6a86c14fd7e1a0c2a410ef24f2588cb72d9ef2de79ee5cd3e550cff9738', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":144,"pageEnd":144,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (672, '673', 'Shpërblimi për transport dhe shpenzimet në lidhje me transportin', '1-2', 'Ligji 04/L-077
Neni 673 - Shpërblimi për transport dhe shpenzimet në lidhje me transportin

1. Dërguesi ka për detyrë t’i paguajë transportuesit shpërblimin për transport dhe shpenzimet në lidhje
me transportin.
2. Në qoftë se në fletëngarkesë nuk është theksuar se dërguesi paguan shpërblimin për transport dhe
shpenzimet e tjera lidhur me transportin, supozohet se dërguesi ka udhëzuar transportuesin që
shpërblimin ta arkëtojë nga marrësi.', 'a3b87b18a67e8b6494b77861eab1b0810e3e7430bda6b48de7e539e8a9048f60', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":144,"pageEnd":144,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (673, '674', 'Disponimi me dërgesën', '1-4', 'Ligji 04/L-077
Neni 674 - Disponimi me dërgesën

1. Dërguesi mund të disponojë me dërgesën edhe t’i ndryshojë urdhrat e përmbajtura në kontratë dhe
mund t’i urdhërojë transportuesit ta ndalë transportin e mëtejshëm të dërgesës, t’ia kthejë dërgesën, t’ia
dorëzojë marrësit tjetër ose ta udhëzojë në një vend tjetër.
2. E drejta e dërguesit për t’i ndryshuar urdhrat shuhet pas arritjes së dërgesës në vendin e
destinacionit, kur transportuesi i’a dorëzon marrësit fletëngarkesën ose kur transportuesi e fton
marrësin që të marrë dërgesën, ose kur marrësi e kërkon vet dorëzimin e saj.
3. Në qoftë se është lëshuar fletëngarkesa sipas urdhrit, respektivisht në prurësin, të dhënat e dërguesit
nga paragrafi paraprak i takojnë ekskluzivisht zotëruesit të fletëngarkesës.
4. Personi i autorizuar që shfrytëzon të drejtën e dhënies së urdhëresave të reja transportuesit ka për
detyrë t’ia shpërblejë shpenzimet dhe dëmin që i ka pasur për shkak të kësaj dhe që me kërkesën e tij
t’i japë dorëzani se shpenzimet dhe dëmi do t’i shpërblehen.', '4627342cda967aa0e27f780c9a5c0ce8b8d6b12942224afe093f08496340d75b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":144,"pageEnd":145,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (674, '675', 'Drejtimi i transportit', '1-2', 'Ligji 04/L-077
Neni 675 - Drejtimi i transportit

1. Transportuesi ka për detyrë ta kryejë transportin në mënyrën e kontraktuar.
2. Në qoftë se nuk është kontraktuar se në cilën rrugë duhet të bëhet transporti, transportuesi ka për
detyrë që ta bëjë në atë rrugë që i përgjigjet më tepër interesave të dërguesit.', '9caeeb22209146e132091d38c60a9cc4748e0714ab2ddd070fdd3828f8bf7f02', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":145,"pageEnd":145,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (675, '676', 'Pengesat gjatë kryerjes së transportit', '1-4', 'Ligji 04/L-077
Neni 676 - Pengesat gjatë kryerjes së transportit

1. Transportuesi ka për detyrë ta njoftojë dërguesin për të gjitha rrethanat që do të kishin ndikim në
kryerjen e transportit dhe të veprojë sipas udhëzimeve që i merr nga ai.
2. Transportuesi nuk është i detyruar të veprojë sipas udhëzimeve të dërguesit, zbatimi i të cilave do të
mund të rrezikonte sigurinë e personave ose të të mirave.
3. Në qoftë se rasti do të ishte i tillë sa të mos mund të priten udhëzimet e dërguesit, transportuesi ka
për detyrë të veprojë siç do të vepronte ekonomisti i mirë përkatësisht shtëpiaku i mirë në të njëjtën
situatë dhe për këtë ta njoftojë dërguesin e të kërkojë udhëzimet e tij të mëtejshme.
4. Transportuesi ka të drejtë për shpërblimin e shpenzimeve që kanë ndodhur për shkak të pengesave
të dalura pa fajin e tij.', '2b102f34c7f146feaa8ca70628832c82b79a9a4983d5a44dbaf73d905349a863', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":145,"pageEnd":145,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (676, '677', 'Shpërblimi në rastin e ndërprerjes së transportit', '1-3', 'Ligji 04/L-077
Neni 677 - Shpërblimi në rastin e ndërprerjes së transportit

1. Në qoftë se për ndonjë shkak për të cilin përgjigjet transportuesi është ndërprerë transporti ai ka të
drejtë në pjesën proporcionale të shpërblimit për transportin e kryer, por ka për detyrë që ta shpërblejë
dëmin që do të krijohej për palën tjetër për shkak të ndërprerjes së transportit.
2. Në qoftë se transporti është ndërprerë për ndonjë shkak për të cilin nuk përgjigjet askush nga
personat e interesuar, transportuesi ka të drejtë në diferencën midis shpërblimit të kontraktuar për
transport dhe shpenzimeve të transportit nga vendi ku është ndërprerë transporti deri në vendin e
destinimit.
3. Transportuesi nuk ka të drejtë as në një pjesë të shpërblimit, në qoftë se gjatë transportit dërgesa
shkatërrohet për shkak të fuqisë madhore.', 'af51a6eca57823b19a94b2d99680c4d2d0694e6621869d54b1f566a7fddf352e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":145,"pageEnd":145,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (677, '678', 'Kur dërgesa nuk mund të dorëzohet', '1-2', 'Ligji 04/L-077
Neni 678 - Kur dërgesa nuk mund të dorëzohet

1. Në qoftë se marrësi nuk mund të njoftohet për arritjen e dërgesës ose refuzon ta pranojë dhe në
përgjithësi në qoftë se dërgesa nuk mund të dorëzohet ose në qoftë se marrësi nuk i’a paguan
transportuesit shpërblimin qe e ka për detyrë dhe shumat e tjera që e ngarkojnë dërgesën,
transportuesi ka për detyrë ta njoftojë për këtë dërguesin, të kërkojë prej tij udhëzime dhe të ndermerr
masa të duhura për llogari të tij për ruajtjen e sendit.
2. Në qoftë se brenda afatit të arsyeshëm personi i autorizuar nuk pranon dërgesën, transportuesi ka të
drejtë ta shesë dërgesën sipas rregullave për shitjen e sendit në rastin e vonesës së kreditorit dhe të
arkëtojë kërkesat e veta nga çmimi i realizuar, ndërsa mbetjen ka për detyrë ta depozitojë në gjykatë
për personin e autorizuar.', 'a6b58805b16ab5807d8a936ec2be7731dad17bd63ff51a6724c2dea69dc1f760', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":145,"pageEnd":146,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (678, '679', 'Përgjegjësia e transportuesit ndaj dërguesit', null, 'Ligji 04/L-077
Neni 679 - Përgjegjësia e transportuesit ndaj dërguesit

Në qoftë se transportuesi i’a ka dorëzuar dërgesën marrësit, ndërsa nuk e ka arkëtuar prej tij shumën
me të cilën ka qenë e ngarkuar, ka për detyrë t’ia paguajë këtë shumë dërguesit, por ka të drejtë të
kërkojë shpërblimin nga marrësi.', '3787ed1131414005f64c45537ef97ed0e200ed3d0312e915ff11146efe9ddcbe', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":146,"pageEnd":146,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (679, '680', 'Njoftimi i marrësit për arritjen e dërgesës', '1-2', 'Ligji 04/L-077
Neni 680 - Njoftimi i marrësit për arritjen e dërgesës

1. Transportuesi ka për detyrë ta njoftojë marrësin pa vonesë se dërgesa ka arritur, t’ia vejë në
dispozicion si është kontraktuar dhe t’i paraqesë fletëngarkesën, nëse një fletëngarkesë e tillë është
lëshuar.
2. Në rastin kur është lëshuar fletëngarkesa sipas urdhrit ose në prurësin, ai ka për detyrë të veprojë
sipas paragrafit 1. të këtij neni vetëm në qoftë se në fletëngarkesë është shënuar personi në vendin e
destinimit se dërgesa ka arritur.', '9118c7c848a31abddb54080a382f20486391f7c9fd8ce48fd809f16f192eef90', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":146,"pageEnd":146,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (680, '681', 'Dorëzimi i dërgesës kur është lëshuar duplikati i fletdërgesës', null, 'Ligji 04/L-077
Neni 681 - Dorëzimi i dërgesës kur është lëshuar duplikati i fletdërgesës

Transportuesi mund të refuzojë ta dorëzojë dërgesën, në qoftë se njëkohësisht nuk i jepet duplikati i
fletëngarkesës në të cilën e ka vërtetuar se dërgesa i është dorëzuar.', '90b8dee4fc2eac2502f8b597144af5aea68af7f7d6ff986f3e23bceefc128d22', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":146,"pageEnd":146,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (681, '682', 'E drejta e marrësit për të kërkuar dorëzimin e dërgesës', '1-3', 'Ligji 04/L-077
Neni 682 - E drejta e marrësit për të kërkuar dorëzimin e dërgesës

1. Marrësi mund të ushtrojë të drejtat nga kontrata për transportin ndaj transportuesit dhe të kërkojë
prej tij t’ia dorëzojë fletëngarkesën dhe dërgesën vetëm pasi që ajo të arrijë në vendin e destinimit.
2. Transportuesi ka për detyrë që me kërkesën e marrësit t’ia dorëzojë dërgesën para se ajo të arrijë në
vendin e destinimit, vetëm në qoftë se për këtë e ka autorizuar dërguesi.
3. Marrësi mund të ushtrojë të drejtat nga kontrata për transportin dhe të kërkojë nga transportuesi t’ia
dorëzojë dërgesën vetëm në qoftë se i plotëson kushtet e parashikuara në kontratën për transportin.', '6f5da5b3c8184a12f1441cc22ee74d2e132f476957335896fee349806b50bf6d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":146,"pageEnd":146,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (682, '683', 'Vërtetimi i identitetit dhe i gjendjes së dërgesës', '1-2', 'Ligji 04/L-077
Neni 683 - Vërtetimi i identitetit dhe i gjendjes së dërgesës

1. Personi i autorizuar ka të drejtë të kërkojë që me procesverbal të vërtetohet identiteti i dërgesës dhe
në qoftë se dërgesa është dëmtuar, në çka qëndron ky dëmtim.
2. Në qoftë se vërtetohet se dërgesa nuk është ajo që i është dorëzuar transportuesit ose dëmtimi
është më i madh se sa ka pohuar transportuesi, atëherë shpenzimet e vërtetimit i paguan transportuesi.', '02762621dbe42ae1d04efaa5b429ba63be52447c8f51854343bc65dc9130cab4', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":146,"pageEnd":147,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (683, '684', 'Detyrimi i marrësit për të paguar shpërblimin për transportin', '1-2', 'Ligji 04/L-077
Neni 684 - Detyrimi i marrësit për të paguar shpërblimin për transportin

1. Me marrjen në dorëzim të dërgesës dhe të fletëngarkesës, në qoftë se është lëshuar, marrësi
detyrohet t’i paguajë transportuesit shpërblimin për transport, në qoftë se nuk është caktuar diçka tjetër
në kontratën për transportin ose në fletëngarkesën, si dhe t’i paguajë shumat me të cilat është ngarkuar
dërgesa.
2. Në qoftë se marrësi konsideron se nuk e ka për detyrë t’i paguajë transportuesit aq sa kërkon ky, ai
mund të ushtrojë të drejtat nga kontrata vetëm në qoftë se në gjykatë e deponon shumën kontestuese.', 'a5a3234b77114196465b1f8c4b2296b9cb812a6bde2420338dcc5b7baa90b023', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":147,"pageEnd":147,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (684, '685', 'Humbja ose dëmtimi i dërgesës', '1-5', 'Ligji 04/L-077
Neni 685 - Humbja ose dëmtimi i dërgesës

1. Transportuesi përgjigjet për humbjen ose për dëmtimin e dërgesës që do të shkaktoheshin prej çastit
të marrjes në dorëzim deri në dorëzimin e saj, përveç nëse i janë shkaktuar me veprimin e personit të
autorizuar, nga cilësia e dërgesës ose nga shkaqet e jashtme që nuk kanë mund të parashikohen si
edhe të shmangen ose mënjanohen.
2. Janë nule dispozitat e kontratës për transport, të kushteve të përgjithshme të transportit të tarifave
ose të ndonjë akti tjetër të përgjithshëm sipas të cilave kjo përgjegjësi zvogëlohet.
3. Por është e plotfuqishme dispozita që cakton shumën më të lartë të shpërblimit, me kusht që mos të
jetë në disproporcion të dukshëm me dëmin.
4. Ky kufizim i shumës së shpërblimit nuk vlen në qoftë se dëmin e ka shkaktuar transportuesi me
dashje ose nga pakujdesia e rëndë.
5. Në qoftë se nuk është kontraktuar ndryshe, shuma e shpërblimit caktohet sipas çmimit të tregut të
dërgesës në kohën dhe vendin e dorëzimit për transport.', '2a0e24aece486551d89d4caa542fc1351641a8a95eff76918d78cc0d2d954bf9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"5","pageStart":147,"pageEnd":147,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (685, '686', 'Humbja ose dëmtimi i dërgesës së sendeve të shtrenjta', '1-2', 'Ligji 04/L-077
Neni 686 - Humbja ose dëmtimi i dërgesës së sendeve të shtrenjta

1. Në rastin e humbjes ose të dëmtimit të dërgesës në të cilën gjendeshin sende të çmueshme, letra
me vlerë ose sende të tjera të shtrenjta, transportuesi ka për detyrë të shpërblejë dëmin e shkaktuar,
vetëm në qoftë se me rastin e dorëzimit të sendit për transport ka qenë i njoftuar për natyrën e këtyre
sendeve dhe për vlerën e tyre, ose në qoftë se dëmin e ka shkaktuar me dashje ose nga pakujdesia e
rëndë.
2. Në qoftë se me sendet e përmendura në dërgesë kanë qenë edhe sende të tjera, për humbjen ose
dëmtimin e tyre transportuesi përgjigjet sipas rregullave të përgjithshme për përgjegjësinë e
trasnportuesit.', '15500580bbeacdd90a29f45b25f4db369b28994967e65bddb415eb049bd0e1e1', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":147,"pageEnd":147,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (686, '687', 'Kthimi i shpërblimit të paguar për transport', null, 'Ligji 04/L-077
Neni 687 - Kthimi i shpërblimit të paguar për transport

Në rastin e humbjes së plotë të dërgesës, transportuesi ka për detyrë që përveç shpërblimit të dëmit,
dërguesit t’i kthejë shpërblimin për transport në qoftë se ai është paguar.', '1c708283faeffbf5680fc56713c898ee65a5d71ecc4ab2c5378cdd0b50d17efe', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":147,"pageEnd":147,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (687, '688', 'Kur marrësi e merr dërgesën pa kundërshtim', '1-3', 'Ligji 04/L-077
Neni 688 - Kur marrësi e merr dërgesën pa kundërshtim

1. Kur marrësi e merr dërgesën pa kundërshtim dhe i paguan transportuesit kërkesat e tij, shuhet
përgjegjësia e transportuesit, përveç nëse dëmtimi është konstatuar me procesverbal para marrjes së
dërgesës.
2. Transportuesi mbetet përgjegjës për dëmtimet e dërgesës që mund të viheshin re në momentin e
dorëzimit, në qoftë se marrësi e ka njoftuar për këto dëmtime menjëherë pas zbulimit të tyre, por jo më
vonë se tetë (8) ditë nga dorëzimi.
3. Transportuesi nuk mund të thirret në dispozitat e paragrafëve paraprake, në qoftë se dëmtimi është
shkaktuar me dashje ose nga pakujdesia e rëndë.', 'f036955b80033dd5a312960ea1b8896d4d06ac15da49bd200305802938d40987', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":148,"pageEnd":148,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (688, '689', 'Përgjegjësia e transportuesit për vonesë', null, 'Ligji 04/L-077
Neni 689 - Përgjegjësia e transportuesit për vonesë

Transportuesi përgjigjet për dëmin e shkaktuar për shkak të vonesës, përveç nëse vonesa është
shkaktuar nga ndonjë fakt që përjashton përgjegjësinë e tij për humbjen ose dëmtimin e sendit.', '37b5dd637fe1d00c83934e01645ca2d1e9e15093d1aaeba9b47c1561150bccf0', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":148,"pageEnd":148,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (689, '690', 'Përgjegjësia për ndihmësit', null, 'Ligji 04/L-077
Neni 690 - Përgjegjësia për ndihmësit

Transportuesi përgjigjet për personat që kanë punuar në kryerjen e transportit sipas urdhrit të tij.', '72d36b1869e4e5cb1302936cee49e7af763591393b34336cd3901d90e3a9e931', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":148,"pageEnd":148,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (690, '691', 'Përgjegjësia solidare', '1-6', 'Ligji 04/L-077
Neni 691 - Përgjegjësia solidare

1. Transportuesi, i cili ia beson ndonjë transportuesi tjetër kryerjen e transportit të dërgesës tërësisht
ose pjesërisht që e ka pranuar për transport mbetet edhe më tej përgjegjës për transportin e saj që nga
marrja deri te dorëzimi, por ka të drejtë në shpërblim nga transportuesi të cilit i’a ka besuar dërgesën.
2. Në qoftë se transportuesi tjetër e merr nga transportuesi i parë bashkë me dërgesën edhe
fletëngarkesën, ai bëhet palë kontraktuese në transportin me të drejtat dhe detyrat e debitorit solidar
dhe të kreditorit solidar, kontributet e të cilit janë në përpjesëtim me pjesëmarrjen e tij në transport.
3. E njëjta vlen edhe kur për kryerjen e transportit të ndonjë dërgese detyrohen me të njëjtën kontratë
disa transportues, të cilët do të marrin pjesë në transport njëri pas tjetrit.
4. Secili prej disa transportueseve ka të drejtë të kërkojë që të vërtetohet gjendja e dërgesës në
momentin kur i dorëzohet për kryerjen e pjesës së tij të transportit.
5. Transportuesit solidarë marrin pjesë në bartjen e dëmit përpjesëtimisht me kontributet e tyre në
transport, përveç atij që provon se dëmi nuk është shkaktuar deri sa ai ka transportuar dërgesën.
6. Kundërshtimet e bëra transportuesit të mëvonshëm kanë efekt edhe ndaj transportuesve të
mëparshëm.', '44a2a1bcb3a1b1481832f9dffb557ac595569ec366415fe09ba830309620136a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"6","pageStart":148,"pageEnd":148,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (691, '692', 'Përgjegjësia e pjesëtuar e transportuesve', null, 'Ligji 04/L-077
Neni 692 - Përgjegjësia e pjesëtuar e transportuesve

Kur në kryerjen e transportit të një dërgese marrin pjesë njëri pas tjetrit disa transportues që i ka
caktuar dërguesi, secili prej tyre përgjigjet vetëm për pjesën e vet të transportit.', '86c5932b223c7caa7169f2278e9eb739db2c5be43e2f7e387cf96aa6ef390210', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":149,"pageEnd":149,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (692, '693', 'Kur transportuesi ka të drejtë pengu', '1-4', 'Ligji 04/L-077
Neni 693 - Kur transportuesi ka të drejtë pengu

1. Për sigurimin e arkëtimit të shpërblimit për transport e të shpenzimeve të domosdoshme që i ka bërë
lidhur me transportin, transportuesi ka të drejtën e pengut në sendet që i janë dorëzuar për transport
dhe lidhur me transportin deri sa i mban dhe deri sa ka në dorë dokumentin me ndihmën e të cilit mund
të disponojë me to.
2. Kur në kryerjen e transportit kanë marrë pjesë disa transportues njëri pas tjetrit, kërkesat e tyre lidhur
me transportin janë të siguruara gjithashtu me këtë peng dhe transportuesi i fundit ka për detyrë, në
qoftë se fletëngarkesa nuk përmban diçka tjetër, t’i arkëtojë të gjitha kërkesat sipas fletëngarkesës.
3. Kërkesat e transportuesit të mëparshëm dhe e drejta e tij e pengut kalojnë në transportuesin e
mëvonshëm i cili i’a ka paguar këto kërkesa.
4. Kjo njësoj vlen në qoftë se transportuesi paguan kërkesat e shpediterit.', 'a5605f801f9270cb522f8ac48cfed10dd90700b2d11a157df3b29afa1b64472d', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":149,"pageEnd":149,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (693, '694', 'Konflikti i të drejtave të pengut', '1-2', 'Ligji 04/L-077
Neni 694 - Konflikti i të drejtave të pengut

1. Kur përveç të drejtës së pengut të transportuesit ekzistojnë në të njëjtin send njëkohësisht të drejtat e
pengut të komisionarit, të shpediterit dhe të magazionerit, përparësi arkëtimi kanë kërkesat e atyre
kreditoreve të krijuara me shpeditimin ose transportimin dhe atë me rend të kundërt sipas të cilit janë
krijuar.
2. Kërkesat e tjera të komisionarëve, të magazionerëve, të shpeditorëve dhe të transportuesit te
krijuara nga dhënia e paradhënieve arkëtohen vetëm pas pagimit të kërkesave të përmendura në
paragrafin 1. të këtij neni sipas radhës që janë krijuar.', '3aa040b1d1663c9ba4e59b9f86f7f6644012f2134ea2f4d9ef1c0a182337b807', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":149,"pageEnd":149,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (694, '695', 'Dispozita e përgjithshme', null, 'Ligji 04/L-077
Neni 695 - Dispozita e përgjithshme

Transportuesi ka për detyrë që transportin e personave ta kryej në mënyrë të sigurt me atë mjet të
transportit që është caktuar me kontratë për transportin dhe me ato kushte komoditeti dhe higjienike të
cilat sipas llojit të mjetit transportues përkatës dhe largësisë së rrugës, konsiderohen të domosdoshme.', '6739059a191712292dd4a976372fc8622536c0e00ee5fb4c05654eafef522c96', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":149,"pageEnd":149,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (695, '696', 'E drejta e udhëtarit për vendin e caktuar', null, 'Ligji 04/L-077
Neni 696 - E drejta e udhëtarit për vendin e caktuar

Transportuesi ka për detyrë t’i japë udhëtarit atë vend dhe në atë mjet transporti si është kontraktuar.', '38f9867aea0964b68ffa44ee6e8ea4a2fe80a10296b74b505d989bb94341ce07', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":149,"pageEnd":149,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (696, '697', 'Përgjegjësia e transportuesit për vonesë', '1-2', 'Ligji 04/L-077
Neni 697 - Përgjegjësia e transportuesit për vonesë

1. Transportuesi ka për detyrë t’i transportojë udhëtarët në vendin e caktuar me kohë.
2. Ai përgjigjet për dëmin të cilin udhëtari do ta pësonte për shkak të vonesës, përveç nëse vonesa ka
ardhur nga shkaku i cili nuk ka mundur të mënjanohet as me kujdesin e ekspertit.', '058fb8477d7e087c0daf46aabf44f543721ab3ab428221cf882dca4a193d3757', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":150,"pageEnd":150,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (697, '698', 'Përgjegjësia e transportuesit për sigurinë e udhëtarëve', '1-2', 'Ligji 04/L-077
Neni 698 - Përgjegjësia e transportuesit për sigurinë e udhëtarëve

1. Transportuesi përgjigjet për sigurinë e udhëtarëve nga fillimi i transportit deri në mbarim të tij, si në
rastin e transportit me pagesë, ashtu edhe në transport falas dhe ka për detyrë që të shpërblejë dëmin
që shkaktohet me dëmtimin e shëndetit, lëndimin ose vdekjen e udhëtarit, përveç nëse është shkaktuar
me veprimin e udhëtarit ose shkakun e jashtëm i cili nuk ka mundur të parashihet, të shmanget ose të
mënjanohet.
2. Nule janë dispozitat e kontratës dhe të kushteve të përgjithshme të transportit, të tarifës ose të
ndonjë akti tjetër të përgjithshëm me të cilat zvogëlohet kjo përgjegjësi.', 'c6c9d7f3e47a1b10bd79030a2cba4e386cdb45d7d1117495f23b17b9844b0e21', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":150,"pageEnd":150,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (698, '699', 'Përgjegjësia për bagazhin e dorëzuar për transport dhe sende të tjera', '1-3', 'Ligji 04/L-077
Neni 699 - Përgjegjësia për bagazhin e dorëzuar për transport dhe sende të tjera

1. Bagazhin të cilin ia ka dorëzuar udhëtari, transportuesi ka për detyrë ta transportojë në të njëjtën
kohë kur edhe udhëtarin dhe t’ia dorëzojë atë pas përfundimit të transportit.
2. Për humbjen dhe dëmtimin e bagazhit që i’a ka dorëzuar udhëtari, transportuesi përgjigjet sipas
dispozitave për transportin e sendeve.
3. Për dëmtimin e sendeve që i mban me vete udhëtari përgjigjet transportuesi sipas rregullave të
përgjithshme për përgjegjësinë.', 'f6ec63b1edcd74f47096f63addc09d9f221ce62c3203cb9ba08cb72df2728c47', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":150,"pageEnd":150,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (699, '700', 'Nocioni', null, 'Ligji 04/L-077
Neni 700 - Nocioni

Me kontratën për licencën detyrohet dhënësi i licencës që fituesit të licencës t’i bartë në tërësi ose
pjesërisht të drejtën e shfrytëzimit të shpikjes, të diturisë teknike, të përvojës, të damkës, të mostrës
ose modelit, kurse fituesi i licencës detyrohet t’ia paguajë shpërblimin e caktuar.', '537fe485c0171cf18867b41a9877f35de82c2b880d93a3b82236eaea4b2e1997', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":150,"pageEnd":150,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (700, '701', 'Forma', null, 'Ligji 04/L-077
Neni 701 - Forma

Kontrata për licencën duhet të lidhet në formën me shkrim.', 'b4eaef6c3d21f3470cd91273f411673f91c7fbd2e504d3e7bc7605686266f5c3', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":150,"pageEnd":150,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (701, '702', 'Kohëzgjatja e licencës', null, 'Ligji 04/L-077
Neni 702 - Kohëzgjatja e licencës

Licenca për shfrytëzimin e shpikjes së patentuar, të mostrës ose të modelit nuk mund të kontraktohet
për një kohë më të gjatë se sa kohëzgjatja e mbrojtjes ligjore të këtyre të drejtave.', '909d751c2e355c7da8159b050f172fea6a312f0ba3e0daae83f2e4f444098c11', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":151,"pageEnd":151,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (702, '703', 'Licenca ekskluzive', '1-3', 'Ligji 04/L-077
Neni 703 - Licenca ekskluzive

1. Me kontratën për licencën fituesi i licencës fiton të drejtën ekskluzive të shfrytëzimit të objektit të
licencës, vetëm në qoftë se kjo është kontraktuar shprehimisht (licenca ekskluzive).
2. Mundësitë e tjera të shfrytëzimit të objektit të licencës i mban dhënësi i licencës.
3. Në qoftë se në kontratën për licencën nuk është shënuar se për çfarë licence është fjala,
konsiderohet se është dhënë licenca jo ekskluzive.', '4fbd30abf19da66208cc9124f502493ab9760a5f87496200a4f635f1eb3425d6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":151,"pageEnd":151,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (703, '704', 'Kufizimi territorial i të drejtës së shfrytëzimit', '1-2', 'Ligji 04/L-077
Neni 704 - Kufizimi territorial i të drejtës së shfrytëzimit

1. E drejta e shfrytëzimit të objektit të licencës mund të kufizohet territorialisht vetëm në qoftë se kjo nuk
është në kundërshtim me dispozitat imperative dhe dispozitat tjera për qarkullimin e mallit dhe
shërbimeve.
2. Në qoftë se me kontratën për licencën territorialisht nuk është kufizuar e drejta e shfrytëzimit të
objektit të licencës, konsiderohet se licenca territorialisht është e pakufizuar', 'b3071c771f70baeecf2a97d6ee3a735725f95e918b357e14f2ebc171f6a44505', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":151,"pageEnd":151,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (704, '705', 'Dorëzimi i objektit të licencës', '1-2', 'Ligji 04/L-077
Neni 705 - Dorëzimi i objektit të licencës

1. Dhënësi i licencës ka për detyrë që fituesit të licencës t’i dorëzojë brenda afatit të caktuar objektin e
licencës.
2. Dhënësi i licencës ka për detyrë që fituesit të licencës t’i dorëzojë edhe dokumentacionin teknik të
nevojshëm për zbatimin praktik të objektit të licencës.', '9ac4eb5afd0c4f4641b1d17ad736434504cabdce603c84f2cd930754ffa3e11f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":151,"pageEnd":151,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (705, '706', 'Dhënia e udhëzimeve dhe njoftimeve', null, 'Ligji 04/L-077
Neni 706 - Dhënia e udhëzimeve dhe njoftimeve

Dhënësi i licencës ka për detyrë që fituesit të licencës t’ia jap edhe të gjitha udhëzimet dhe njoftimet që
janë të nevojshëm për zbatimin, shfrytëzimin e suksesshëm të objektit të licencës.', 'c54eca74df22053c32ce495b37a9446478f094614efc53cee4b3031c53e308fa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":151,"pageEnd":151,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (706, '707', 'Detyrimi i garantimit', null, 'Ligji 04/L-077
Neni 707 - Detyrimi i garantimit

Dhënësi i licencës i garanton fituesit të licencës zbatueshmërinë dhe përdorshmërinë teknike të objektit
të licencës.', 'cd5f6df6553f846dc329da0a20d15c971c8fe159e2251f32762795345aa48a87', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":151,"pageEnd":151,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (707, '708', 'Përgjegjësia për të metat juridike', '1-3', 'Ligji 04/L-077
Neni 708 - Përgjegjësia për të metat juridike

1. Dhënësi i licencës garanton se e drejta e shfrytëzimit që është objekt i kontratës t’i takojë atij, se në
të nuk ka barrë dhe se nuk është i kufizuar në dobi të personit të tretë.
2. Në qoftë se objekti i licencës është licenca ekskluzive, dhënësi i licencës garanton, se të drejtën e
shfrytëzimit nuk i’a ka bartur tjetrit as tërësisht as pjesërisht.
3. Dhënësi i licencës ka për detyrë ta ruajë dhe ta mbrojë të drejtën e bartur fituesit të licencës nga të
gjitha pretendimet e personave të tretë.', '29d60e36bedac24d22b51be6f8109c2ccd88969f8accd5b8899c71627eca9912', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (708, '709', 'Dorëzimi i dhënësit të licencës ekskluzive', null, 'Ligji 04/L-077
Neni 709 - Dorëzimi i dhënësit të licencës ekskluzive

Në qoftë se është kontraktuar liçenca ekskluzive, dhënësi i licencës nuk mundet në asnjë formë ta
shfrytëzojë vet objektin e licencës, as pjesë të veçanta, as t’i besojë ndonjë tjetri në kufijtë e
vlefshmërisë territoriale të licencës.', '9ded4e17cf89547db8c962fa669fc6b5986c268d02b2890844ff9a15c41200c7', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (709, '710', 'Shfrytëzimi i objektit të licencës', null, 'Ligji 04/L-077
Neni 710 - Shfrytëzimi i objektit të licencës

Fituesi i licencës ka për detyrë ta shfrytëzojë objektin e licencës në mënyrën e kontraktuar, në vëllimin
e kontraktuar dhe në kufijtë e kontraktuar.', '472ceeaf300d221502237d33d20b66d8599b2f6e6b6017a4bf2891e7a52bc5c5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (710, '711', 'Shfrytëzimi i përfeksionimeve të mëvonshme', null, 'Ligji 04/L-077
Neni 711 - Shfrytëzimi i përfeksionimeve të mëvonshme

Në qoftë se me kontratë nuk është caktuar ndryshe, fituesi i licencës nuk është i autorizuar të
shfrytëzojë perfeksionimet e mëvonshme të objektit të licencës.', 'e8639426e5e45b76a1e82269e3907eb71a03100471198b9a04479510e3c1189b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (711, '712', 'Ruajtja e objektit të licencës në fshehtësi', null, 'Ligji 04/L-077
Neni 712 - Ruajtja e objektit të licencës në fshehtësi

Në qoftë se objektin e licencës e përbëjnë shpikja e jopatentuar ose dituria dhe eksperienca teknike e
fshehtë, fituesi i licencës ka për detyrë ta ruajë në fshehtësi.', '2212939bf6349d9ff783f76d33807ab5b86daff9b7951cf0959d52a76e2e3302', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":"KREU 3"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (712, '713', 'Cilësia', '1-2', 'Ligji 04/L-077
Neni 713 - Cilësia

1. Në qoftë se me licencë të prodhimit është ceduar edhe licenca e përdorimit të vulës (damkës), fituesi
i licencës mund të vejë në qarkullim mallra me këtë vulë (damkë) vetëm në qoftë se cilësia e tyre është
e njëjtë si është edhe cilësia e mallit që e prodhon dhënësi i licencës.
2. Marrëveshja e kundërt nuk ka efekt juridik.', '9dedf2c3ac3e6f30dd452136f1b3b6735c785c7b3c91fd6476323ecdfffd1d21', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (713, '714', 'Të shënuarit', null, 'Ligji 04/L-077
Neni 714 - Të shënuarit

Fituesi i licencës ka për detyrë që mallin ta shënojë me shënimin për prodhimin sipas licencës.', '7f30f1b4869d7ebb817fc8b927ad3070bc6e19ff470928de3cf6ecd7fe5e68c6', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":152,"pageEnd":152,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (714, '715', 'Shpërblimi', null, 'Ligji 04/L-077
Neni 715 - Shpërblimi

Fituesi i licencës ka për detyrë t’i paguajë dhënësit të licencës shpërblimin e kontraktuar në kohën dhe
në mënyrën sikurse është caktuar në kontratë.', 'ae17a2897ae144006d5d139107acf0dad5d77f9e4a9d006b7699ec983010580a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (715, '716', 'Paraqitja e raportit', null, 'Ligji 04/L-077
Neni 716 - Paraqitja e raportit

Në qoftë se shpërblimi caktohet në varësi nga vëllimi i shfrytëzimit të objektit të licencës, fituesi i
licencës ka për detyrë t’i paraqesë dhënësit të licencës raportin për vëllimin e shfrytëzimit dhe të bëjë
llogarinë e shpërblimit për një (1) vit, në qoftë se me kontratë për këtë nuk është caktuar afati më i
shkurtër.', '131be73ff7562c5c65e004973f8f351a83aeca85c5020927b6bace75f1415d4b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (716, '717', 'Ndryshimi i shpërblimit të kontraktuar', null, 'Ligji 04/L-077
Neni 717 - Ndryshimi i shpërblimit të kontraktuar

Në qoftë se shpërblimi i kontraktuar është bërë haptazi i papërpjesëtueshëm në krahasim me të
ardhurat të cilat fituesi i licencës i ka nga shfrytëzimi i objektit të licencës, pala e interesuar mund të
kërkojë ndryshimin e shpërblimit të kontraktuar.', '449c3f5f1e483fd7cc632197af163b783a1ee64023b8c61e1d40fb0df72b372a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (717, '718', 'Kur mund të jepet', '1-2', 'Ligji 04/L-077
Neni 718 - Kur mund të jepet

1. Fituesi i licencës ekskluzive mund t’ia bartë tjetrit të drejtën e shfrytëzimit të licencës (nënlicenca).
2. Në kontratë mund të parashihet se fituesi i licencës nuk mund t’i japë tjetrit nënlicencën ose nuk
mund t’ua japë pa lejen e dhënësit të licencës.', 'd59e7451744140d40fd7b14f8dfcdaffcb7a9d0308b61a69b2dc19d8408c206f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (718, '719', 'Kur dhënësi mund të refuzojë lejen', null, 'Ligji 04/L-077
Neni 719 - Kur dhënësi mund të refuzojë lejen

Kur për dhënien e nënlicencës nevojitet leja e dhënësit të licencës ky mund t’ia refuzojë fituesit të
licencës ekskluzive vetëm për shkaqe serioze.', 'a48aee16990131cc7135203dd8a3a21c6672439d1b082cbd769e889d00d8d711', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (719, '720', 'Denoncimi për shkak të nënlicencës së palejueshme', null, 'Ligji 04/L-077
Neni 720 - Denoncimi për shkak të nënlicencës së palejueshme

Dhënësi i licencës mund të denoncojë kontratën për licencën pa afat denoncimi, në qoftë se nënlicenca
është dhënë pa lejen e tij, kur kjo sipas ligjit ose sipas kontratës është e nevojshme.', '8fec4a1f4b50920a357bba0f4d5b4012715861c29cac61183619f3d7d1f78033', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":"KREU 4"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (720, '721', 'Kërkesa e drejtpërdrejtë e dhënësit të nënlicencës', '1-2', 'Ligji 04/L-077
Neni 721 - Kërkesa e drejtpërdrejtë e dhënësit të nënlicencës

1. Me kontratën për nënlicencën nuk krijohet asnjë marrëdhënie juridike e veçantë midis fituesit të
nënlicencës dhe dhënësit të licencës, as atëherë kur dhënësi i licencës e ka dhënë lejen e nevojshme
për kontraktimin e nënlicencës.
2. Dhënësi i licencës për arkëtimin e kërkesave të veta nga fituesi i licencës të krijuara nga licenca,
mund të kërkojë drejtpërdrejt nga fituesi i nënlicencës pagimin e shumave të cilat ky i’a ka detyrim
dhënësit të nënlicencës në bazë të nënlicencës.', '67254f1c5e6b79363268f5b0c5aeaba67f477442647a306f430adae983f24edd', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":153,"pageEnd":153,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (721, '722', 'Kalimi i kohës së caktuar', null, 'Ligji 04/L-077
Neni 722 - Kalimi i kohës së caktuar

Kontrata për licencën e lidhur për një kohë të caktuar shuhet me vet kalimin e kohës për të cilën është
lidhur dhe nuk nevojitet të denoncohet.', 'ca111438ce40dd891a6f47aede1c8eb04f66eb59d46d783ab008c67887f408f5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":154,"pageEnd":154,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (722, '723', 'Përtëritja e heshtur e licencës', '1-2', 'Ligji 04/L-077
Neni 723 - Përtëritja e heshtur e licencës

1. Kur pas kalimit të kohës për të cilën ka qenë e lidhur kontrata për licencën, fituesi i licencës e
vazhdon shfrytëzimin e objektit të licencës, ndërsa dhënësi i licencës nuk e kundërshton këtë,
konsiderohet se është lidhur kontrata e re për licencën për kohë të pacaktuar, nën të njëjtat kushte
sikurse edhe paraprakja.
2. Sigurimet që i kanë dhënë personat e tretë për licencën e parë shuhen me skadimin e kohës për të
cilën ka qenë e lidhur.', '33bd3efee6d9d7e2c4b2c251613d578a2c57eb21000e716bd1cd0e6bfcb0950f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":154,"pageEnd":154,"structuralContext":{"chapterTitle":"KREU 5"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (723, '724', 'Denoncimi', '1-2', 'Ligji 04/L-077
Neni 724 - Denoncimi

1. Kontrata për licencën, kohëzgjatja e së cilës nuk është caktuar, shuhet me denoncim të cilën secila
palë mund t’ia japë tjetrës, duke respektuar afatin e caktuar të denoncimit.
2. Në qoftë se afati i denoncimit nuk është caktuar me kontratë, është gjashtë (6) muaj, por dhënësi i
licencës nuk mund ta denoncojë kontratën gjatë vitit të parë të vlefshmërisë së saj.', '46f63bfc16c93096a98f2bfc8b92bd169916c994d3ced4e2c875b2300ca8f8ca', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":154,"pageEnd":154,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (724, '725', 'Vdekja, falimentimi dhe likuidimi', '1-3', 'Ligji 04/L-077
Neni 725 - Vdekja, falimentimi dhe likuidimi

1. Në rast të vdekjes së dhënësit të licencës, licenca vazhdon në trashëgimtarët e tij, në qoftë se nuk
është kontraktuar ndryshe.
2. Në rast të vdekjes së fituesit të licencës, licenca vazhdon në trashëgimtarët e tij, të cilët e vazhdojnë
veprimtarinë e tij.
3. Në rast të falimentimit ose të likudimit të fituesit të licencës, dhënësi i licencës mund ta zgjidhë
kontratën.', '155fc4e266a42f560a98ec3476670826e8597b640661ebcc5c0bf80f69b5fae5', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":154,"pageEnd":154,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (725, '726', 'Kuptimi', '1-2', 'Ligji 04/L-077
Neni 726 - Kuptimi

1. Me kontratën për depozitën detyrohet depozitmarrësi që të pranojë sendin nga depozituesi për ta
ruajtur dhe për ta kthyer, kur ky ta kërkojë.
2. Objekt i depozitës mund të jenë vetëm sendet e luajtshme.', '291925bb6c99da411a0fd48734fb4156db63d991ff5de7a87acaf5f766c19c33', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":154,"pageEnd":155,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (726, '727', 'Depozita e sendit të huaj', '1-2', 'Ligji 04/L-077
Neni 727 - Depozita e sendit të huaj

1. Kontratën për depozitën mund ta lidhë plotfuqishëm personi që nuk është pronar i sendit dhe
depozitmarrësi ka për detyrë t’ia kthejë sendin e këtij, përveç nëse vihet në dijeni se sendi është i
vjedhur.
2. Në qoftë se personi i tretë me padi kërkon sendin nga depozitmarrësi si pronar, depozitmarrësi ka
për detyrë ta informojë gjykatën nga cili person e ka marrë dhe njëkohësisht ta informojë
depozitmarrësin për padinë e paraqitur.', 'cc5fc088379f9b41c013adc8729ed8142d82b380ee00c0a57a70ea519f8b99e9', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":155,"pageEnd":155,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (727, '728', 'Detyrimet e ruajtjes dhe të njoftimeve', '1-3', 'Ligji 04/L-077
Neni 728 - Detyrimet e ruajtjes dhe të njoftimeve

1. Depozitmarrësi ka për detyrë ta ruajë sendin si të vetin, e në qoftë se depozita është me shpërblim
duhet ta ruajë si ndërmarrës i mirë respektivisht si shtëpiak i mirë.
2. Në qoftë se është kontraktuar vendi ose mënyra e ruajtjes së sendit, depozitmarrësi mund t’i
ndryshojë vetëm në qoftë se këtë e kërkojnë rrethanat e ndryshuara, përndryshe përgjigjet edhe për
shkatërrimin e rastësishëm ose dëmtimin e rastësishëm.
3. Për të gjitha ndryshimet që do t''i vinte re në sendin dhe për rreziqet që sendet të prishen në cilëndo
mënyrë qoftë depozitëmarrësi ka për detyrë të njoftojë depozitëdhënësin.', '9a10702bf25af5a9578a8b75c10c2275354fbafb9776d174676940127807c1de', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":155,"pageEnd":155,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (728, '729', 'Dorëzimi i sendit tjetrit për ruajtje', null, 'Ligji 04/L-077
Neni 729 - Dorëzimi i sendit tjetrit për ruajtje

Depozitëmarrësi nuk mundet pa pëlqimin e depozitëdhënësit, ose pa nevojë të domosdoshme t''ia
dorëzojë dikujt sendin që i është besuar për ta ruajtur përndryshe përgjigjet edhe për shkatërrimin ose
dëmtimin e tij pa dashje.', '72b8645a09125890e1b8f6b487ea3b17ec67e24b31cd36be3f006f25bfe6eded', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":155,"pageEnd":155,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (729, '730', 'Përdorimi i sendit', '1-3', 'Ligji 04/L-077
Neni 730 - Përdorimi i sendit

1. Depozitëmarrësi nuk ka të drejtë ta përdorë sendin e besuar për ruajtje.
2. Në rast të përdorimit të palejuar të sendit, depozitmarrësi i ka borxh depozituesit shpërblimin gjegjës
dhe i përgjigjet për shkatërrimin ose dëmtimin e rastësishëm të sendit i cili do të ndodhte me atë rast.
3. Kur në depozitë është dhënë ndonjë send i pakonsumueshëm dhe depozitmarrësit i është lejuar që
ta përdorë, në marrëdhëniet e kontraktueseve zbatohen rregullat e kontratës për huapërdorjen, ndërsa
për çështjet për kohën dhe vendin e kthimit të sendit rregullat e kontratës për depozitën, në qoftë se
kontraktuesit diçka tjetër nuk kanë caktuar.', 'cfcdc753d0906c96faa8ef5d6ec392d790600543fac5a85cf086b46f89e8c84f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":155,"pageEnd":155,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (730, '731', 'Përdorimi dhe dorëzimi i sendit personit tjetër', null, 'Ligji 04/L-077
Neni 731 - Përdorimi dhe dorëzimi i sendit personit tjetër

Kur depozitmarrësi, pa pëlqimin e depozituesit dhe pa nevojë të domosdoshme, në kundërshtim me
kontratën, e përdorë sendin, e ndryshon vendin ose mënyrën e ruajtjes së tij, ose kur sendi i është
dorëzuar për ruajtje personit tjetër, ai nuk përgjigjet për shkatërrimin ose dëmtimin pa dashje të sendit
që mund të ndodhnin edhe sikur te ketë vepruar në pajtim me kontratën.', 'ed0057f8c666b31eb2ce8dd7d5e32c13d48cf5e5de2c17fe7f18a063e2b50a6f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":156,"pageEnd":156,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (731, '732', 'Kthimi i sendit', '1-3', 'Ligji 04/L-077
Neni 732 - Kthimi i sendit

1. Depozitmarrësi ka për detyrë ta kthejë sendin posa ta kërkojë depozituesi me të gjitha frutat dhe
fitimet e tjera që ka pasur nga sendi.
2. Në qoftë se është caktuar afati për kthimin e sendit, depozitdhënësi mund të kërkojë që sendi t’i
kthehet edhe para kalimit të afatit, përveç nëse afati nuk është kontraktuar ekskluzivisht në interesin e
depozitdhënësit.
3. Kthimi bëhet në vendin e dorëzimit të sendit depozitmarrësit, në qoftë se me kontratë nuk është
caktuar ndonjë vend tjetër, në të cilin rast depozitmarrësi ka të drejtë në shpërblimin e shpenzimeve të
bartjes së sendit.', '8ef920a9776f16a781b12c5c1c0c7dc739ce9dd5547527ba28617c93f97d5d2a', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":156,"pageEnd":156,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (732, '733', 'Shpërblimi i shpenzimeve dhe i dëmit', null, 'Ligji 04/L-077
Neni 733 - Shpërblimi i shpenzimeve dhe i dëmit

Depozitmarrësi ka të drejtë të kërkojë nga depozituesi qe t‘ia shpërblejë shpenzimet e domosdoshme
për ruajtjen e sendit dhe dëmin që ka pasur për shkak të depozitës.', '71104bb1911030a9e5fc1156bdefc1205874c1a73c81593d44003f5f08ba1d4e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":156,"pageEnd":156,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (733, '734', 'Shpërblimi', null, 'Ligji 04/L-077
Neni 734 - Shpërblimi

Depozitmarrësi nuk ka të drejtë në shpërblimin e vet, përveç nëse shpërblimi është kontraktuar, në
qoftë se depozitmarrësi merret me pranimin e sendeve për ruajtje ose në qoftë se shpërblimi ka
mundur të pritet duke marrë parasysh rrethanat e punës.', '3e8575c0373c5d8546e464a4832bee11fef6ecf65ec4691433293b718c9ab8a8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":156,"pageEnd":156,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (734, '735', 'Kthimi i sendit në rastin e depozitës falas', '1-2', 'Ligji 04/L-077
Neni 735 - Kthimi i sendit në rastin e depozitës falas

1. Depozitmarrësi i cili është detyruar falas ta ruajë sendin për një kohë të caktuar mund t’ia kthejë
depozituesit para kalimit të afatit të kontraktuar, në qoftë se vet sendit do t’i kanosej rreziku i
shkatërrimit ose i dëmtimit ose në qoftë se ruajtja e tij e mëtejshme do të mund të shkaktonte dëmin.
2. Në qoftë se afati nuk është kontraktuar, depozitmarrësi nga paragrafi 1 i këtij neni mundet në çdo
kohë të denoncojë kontratën , por ka për detyrë që depozituesit t’i caktojë afatin e arsyeshëm për
marrjen e sendit.', '447edf0089181bc7bc99c7cc68f84c39d0cefa9a1205587b39c46e3b0d0c0f22', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":156,"pageEnd":156,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (735, '736', 'Depozita e parregullt', null, 'Ligji 04/L-077
Neni 736 - Depozita e parregullt

Kur në depozitë janë dhënë sende të zëvendësueshme me të drejtë që depozitmarrësi t’i konsumojë
dhe me detyrim që t’i kthejë të njëjtën sasi sendesh të të njëjtit lloj, atëherë në marrëdhëniet e tij me
depozituesin zbatohen rregullat e kontratës për huan, vetëm lidhur me kohën dhe vendin e kthimit do të
zbatohen rregullat e kontratës për depozitën, në qoftë se kontraktuesit nuk kanë caktuar diçka tjetër.', '1cd6d2e342e927ad616156d5d8cae43f889e066778dae784ed09c16fc0c3360f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":157,"pageEnd":157,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (736, '737', 'Depozita e domosdoshme', null, 'Ligji 04/L-077
Neni 737 - Depozita e domosdoshme

Kujt i është besuar sendi në rast të ndonjë fatkeqësie, psh. në rast zjarri, tërmeti, vërshimi ka për detyrë
t''a ruajë me kujdesin e shtuar.', 'e9bc5ceb5919fd0b7d4090029cfbb367b5473d0c7b81ec2039dde557d75bc916', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":157,"pageEnd":157,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (737, '738', 'Hotelieri si depozitëmarrës', '1-3', 'Ligji 04/L-077
Neni 738 - Hotelieri si depozitëmarrës

1. Hotelieri konsiderohet dispozitëmarrës lidhur me sendet që i kanë sjellë me vete mysafirët dhe
përgjigjet për humbjen ose dëmtimin e tyre, por jo më tepër se deri në shumën prej pesëmijë (5.000)
Euro.
2. Kjo përgjegjësi është përjashtuar në qoftë se sendet janë shkatërruar ose dëmtuar për shkak të
rrethanave që nuk kanë mundur të shmangen ose të mënjanohen, për ndonjë shkak në vetë sendin, në
qoftë se kanë humbur ose janë dëmtuar me sjelljen e vet mysafirit ose me sjelljen e personave që i ka
sjellë ai ose që i kanë ardhur në vizitë.
3. Hotelieri ka detyrim shpërblimin e plotë në qoftë se mysafiri i’a ka dorëzuar sendin për ruajtje dhe në
qoftë se dëmi është shkaktuar me fajin e tij ose të personave për të cilët ai përgjigjet.', '732432e090fb81d1972322e4f32403f3073845f02a4175e049013b619d057384', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"3","pageStart":157,"pageEnd":157,"structuralContext":{"chapterTitle":"KREU 2"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (738, '739', 'Detyrimet e hotelierit për ta pranuar sendin për ruajtje', '1-2', 'Ligji 04/L-077
Neni 739 - Detyrimet e hotelierit për ta pranuar sendin për ruajtje

1. Hotelieri ka për detyrë t''i pranojë sendet për ruajtje që kanë sjellur mysafirët dhe që dojnë t''ia
dorëzojnë për ruajtje, përveç nëse nuk disponon hapësira të përshtatshme për vendosjen e tyre, ose në
qoftë se ruajtja e tyre i kapërcen mundësitë e tij për ndonjë shkak tjetër.
2. Në qoftë se hotelieri refuzon pa arsye ta pranojë sendin për ruajtje, paguan shpërblimin e plotë të
dëmit të cilin mysafiri e pëson për këtë shkak.', 'f534d3cef57c648507c393fd28ecf4111d37b3647032c8a5f0ef77299bb00e41', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":157,"pageEnd":157,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (739, '740', 'Detyrimi i mysafirit për ta paraqitur dëmi', null, 'Ligji 04/L-077
Neni 740 - Detyrimi i mysafirit për ta paraqitur dëmi

Mysafiri ka për detyrë ta paraqesë humbjen ose dëmtimin e sendeve posa të vihet në dijeni për to,
përndryshe ka të drejtë shpërblimi vetëm në qoftë se provon se dëmi është shkaktuar me fajin e
hotelierit ose të personave për të cilët ai përgjigjet.', '2589f81162e57e271d247f6e38a002e314fbd9b12ece239269d188de14e36303', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":157,"pageEnd":157,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (740, '741', 'Shpalljet për përjashtimin e përgjegjësisë', null, 'Ligji 04/L-077
Neni 741 - Shpalljet për përjashtimin e përgjegjësisë

Nuk kanë kurrfarë efekti juridik shpalljet e theksuara në hapësirat hoteliere me të cilat përjashtohet,
kufizohet ose kushtëzohet përgjegjësia e tyre për sendet që i kanë sjellur mysafirët.', 'd2033a8e31e90a454e0afabb2cd6ea2fe47cb381d39a819c2499e914977b305e', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":158,"pageEnd":158,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (741, '742', 'E drejta e mbajtjes (retencionit)', null, 'Ligji 04/L-077
Neni 742 - E drejta e mbajtjes (retencionit)

Hotelieri që pranon mysafirët ka të drejtë të ndalë sendet të cilat mysafirët i kanë sjellë deri te arkëtimi i
plotë i kërkesave për vendosje dhe shërbime të tjera.', 'cc2815b66cf4cb72c45d826c5eab066eb0cccee680947ce28ae3d25c2246b819', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":158,"pageEnd":158,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (742, '743', 'Zgjerimi i zbatimit të dispozitave për depozitën hoteliere', null, 'Ligji 04/L-077
Neni 743 - Zgjerimi i zbatimit të dispozitave për depozitën hoteliere

Dispozitat për depozitën hoteliere zbatohen përshtatshmërisht edhe për spitale, garazha, vagonëve për
fjetje, kampe të organizuara etj.', 'f89c7a72e925b6bc1cce6177b778d3ad717c4f6a783dc01afa9a0e507040869f', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":158,"pageEnd":158,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (743, '744', 'Nocioni', '1-2', 'Ligji 04/L-077
Neni 744 - Nocioni

1. Me kontratën për magazinimin detyrohet magazinieri që të pranojë dhe ta ruajë mallin e caktuar dhe
të marrë masa të nevojshme ose të kontraktuara për ruajtjen e tij në gjendje të caktuar dhe ta dorëzojë
me kërkesën e dhënësit (të sendit për magazinim) ose të personit tjetër të autorizuar, ndërsa dhënësi
obligohet t’i paguajë shpërblimin e caktuar.
2. Me rastin e dorëzimit të mallit depozitdhënësi ka për detyrë të japë të gjitha njoftimet e nevojshme
për të dhe të deklarojë sa është vlera e tij.', 'b9850101b9aa5da03d5e9655098fe34e4862288d103c8b23ac57db0fbb1074a8', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":158,"pageEnd":158,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (744, '745', 'Përjashtimi i përgjegjësisë dhe disa detyrime të magazinierit', '1-4', 'Ligji 04/L-077
Neni 745 - Përjashtimi i përgjegjësisë dhe disa detyrime të magazinierit

1. Magazinieri përgjigjet për dëmin në mallin, përveç nëse provon se dëmi është shkaktuar për shkak të
rrethanave që nuk kanë mund të shmangen ose të evitohen, ose është shkaktuar me fajin e dhënësit,
të metave ose të vetive natyrore të mallit dhe ambalazhit jo të rregullt.
2. Magazinieri ka për detyrë t’ia tërheq vërejtjen depozitdhënësit për të metat ose cilësitë natyrore të
mallit, përkatësisht për ambalazhin e parregullt, për shkak të të cilave mund të vijë deri te dëmtimi i
mallit, posa t’i ketë vënë re të metat e përmendura ose është dashur t’i vinte re.
3. Në qoftë se në mall do të ndodheshin ndryshime të tilla të paevitueshme për shkak të të cilave
ekziston rreziku që malli të prishet ose të shkatërrohet, magazinieri ka për detyrë, në qoftë se kjo sipas
thirrjes së këtij nuk do të mund ta bënte me kohë depozitdhënësi, ta shesë mallin pa shtyrje në mënyrë
më të përshtatshme.
4. Magazinieri ka për detyrë të ndërmarrë veprime për t’i ruajtur të drejtat e depozitdhënësit ndaj
transportuesit që i’a ka dorëzuar mallin për llogari të depozitdhënësit në gjendje të dëmtuar ose të
mangët.', '37284ae4704d3dd042e016ae010de8dc9ecd7adaa32d85ed9a5a9d828a84791b', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"4","pageStart":158,"pageEnd":159,"structuralContext":{"chapterTitle":"KREU 1"},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (745, '746', 'Kur ekziston detyra e sigurimit', '1-2', 'Ligji 04/L-077
Neni 746 - Kur ekziston detyra e sigurimit

1. Magazinieri ka për detyrë ta sigurojë mallin e marrë për ruajtje vetëm në qoftë se kjo është
kontraktuar.
2. Në qoftë se me kontratë nuk është caktuar se cilat rreziqe duhet t’i përfshijë sigurimi, magazinieri ka
për detyrë ta sigurojë mallin kundër rreziqeve të zakonshme.', '41554cf6f92cbb3619c5e520ab412f9e0c5b4589275f678275535954cf9fc3aa', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":159,"pageEnd":159,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (746, '747', 'Kufizimi i shpërblimit të dëmit', null, 'Ligji 04/L-077
Neni 747 - Kufizimi i shpërblimit të dëmit

Shpërblimi i dëmit, të cilin magazinieri e ka për detyrë ta paguajë për shkak të shkatërrimit, zvogëlimit
ose dëmtimit të mallit, prej pranimit të tij deri te dorëzimi nuk mund të kalojë vlerën e vërtetë të mallit,
përveç nëse dëmin e ka shkaktuar me dashje ose nga pakujdesia e rëndë.', 'bb18815f4dc345f8e64eee9c094f125de0c36680b4b17b513b141ebffcdf9696', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":159,"pageEnd":159,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (747, '748', 'Përzierja e sendeve të zëvendësueshme', '1-2', 'Ligji 04/L-077
Neni 748 - Përzierja e sendeve të zëvendësueshme

1. Magazinieri nuk mund t''i përziejë sendet e zëvendësueshme të pranuara me sendet e llojit të njëjtë
dhe të cilësisë së njëjtë, përveç nëse depozitdhënësi ka dhënë pëlqimin për këtë ose në qoftë se është
e qartë se është fjala për sendet që mund të përzihen pa rrezik nga shkaktimi i dëmit për
depozitdhënësin.
2. Në qoftë se sendet janë përzier, magazinieri mund me kërkesën e personit të autorizuar, pa
pjesëmarrjen e personave të tjerë të autorizuar nga përzierja e sendeve të zëvendësueshme, ta ndajë
pjesën që i takon.', '6e20c58a4d5c94ba5cc288752560627e806992e0f31d06812118ca113dee2305', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":159,"pageEnd":159,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (748, '749', 'Kontrollimi i mallit dhe marrja e mostrave', null, 'Ligji 04/L-077
Neni 749 - Kontrollimi i mallit dhe marrja e mostrave

Magazinieri ka për detyrë t’i lejojë personit të autorizuar ta kontrollojë mallin dhe t’i marrë mostrat prej
tij.', '557ab195b8dc073e605b74a1fdbd4161cad7af943fb04de49a266ee92a7e9904', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":null,"paragraphEnd":null,"pageStart":159,"pageEnd":159,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb),
  (749, '750', 'Kërkesa e magazinierit dhe e drejta e pengut', '1-2', 'Ligji 04/L-077
Neni 750 - Kërkesa e magazinierit dhe e drejta e pengut

1. Përveç shpërblimit për ruajtje magazinieri ka të drejtë në shpërblimin e shpenzimeve që kanë qenë
të nevojshme për ruajtjen e mallit.
2. Për kërkesat e veta nga kontrata për magazinimin dhe për kërkesat e tjera që rrjedhin në lidhje me
ruajtjen e mallit ai ka të drejtën e pengut në këtë mall.', 'eaf8bdd6caa77e6adf46176b83088fcb73fe5d4d4cc63cdbaeea0ae8d25fe470', null::integer, '{"lawNumber":"04/L-077","versionLabel":"gazette-16-2012","documentType":"law","jurisdiction":"XK","applicability":["service","lease"],"applicabilityMode":"direct","paragraphStart":"1","paragraphEnd":"2","pageStart":159,"pageEnd":159,"structuralContext":{"chapterTitle":null},"sourceSha256":"97e2770315ec3a4674ead4184a4bf4f551242fc1e6af703ec161afa786379dc4","normalization":"unicode_nfc_lf_trim_trailing_whitespace_collapse_excess_blank_lines","warnings":[],"amendmentCandidates":[]}'::jsonb)
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
