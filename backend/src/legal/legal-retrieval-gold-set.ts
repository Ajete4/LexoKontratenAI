import { z } from "zod";

import type { LegalRetrievalEvaluationCase } from "./legal-retrieval-evaluation.js";

const sha256Schema = z.string().regex(/^[0-9a-f]{64}$/u);

const localChunkSchema = z.object({
  lawNumber: z.enum(["03/L-212", "04/L-077", "08/L-142"]),
  versionLabel: z.string().min(1),
  language: z.literal("sq"),
  articleNumber: z.string().min(1),
  articleTitle: z.string().min(1).nullable(),
  chunkIndex: z.number().int().nonnegative(),
  contentSha256: sha256Schema
}).passthrough();

export type GoldSetDefinition = {
  readonly evaluationId: string;
  readonly contractType: LegalRetrievalEvaluationCase["contractType"];
  readonly expectedTopic: string;
  readonly allowedLaws: readonly string[];
  readonly rationale: string;
  readonly relevantArticles: Readonly<Record<string, readonly string[]>>;
  readonly partiallyRelevantArticles: Readonly<Record<string, readonly string[]>>;
};

export const LEGAL_RETRIEVAL_GOLD_DEFINITIONS = [
  {
    evaluationId: "employment-notice-period",
    contractType: "employment",
    expectedTopic: "Afati i njoftimit për ndërprerjen e punësimit",
    allowedLaws: ["03/L-212", "08/L-142"],
    rationale: "Neni 71 trajton drejtpërdrejt kohën e njoftimit; nenet fqinje mbulojnë mënyrat dhe pasojat e ndërprerjes.",
    relevantArticles: { "03/L-212": ["71"] },
    partiallyRelevantArticles: { "03/L-212": ["67", "68", "69", "70", "72"] }
  },
  {
    evaluationId: "employment-overtime-pay",
    contractType: "employment",
    expectedTopic: "Pagesa dhe kompensimi për punë jashtë orarit",
    allowedLaws: ["03/L-212", "08/L-142"],
    rationale: "Nenet 23 dhe 56 mbulojnë punën jashtë orarit dhe pagën shtesë; dispozitat fqinje japin kontekst për orarin dhe pagën.",
    relevantArticles: { "03/L-212": ["23", "56"] },
    partiallyRelevantArticles: { "03/L-212": ["22", "24", "25", "26", "55", "58"] }
  },
  {
    evaluationId: "employment-probation",
    contractType: "employment",
    expectedTopic: "Kohëzgjatja dhe kushtet e periudhës provuese",
    allowedLaws: ["03/L-212", "08/L-142"],
    rationale: "Neni 15 titullohet dhe trajton punën provuese.",
    relevantArticles: { "03/L-212": ["15"] },
    partiallyRelevantArticles: {}
  },
  {
    evaluationId: "service-nonperformance-liability",
    contractType: "service",
    expectedTopic: "Përgjegjësia për mospërmbushjen e shërbimit",
    allowedLaws: ["04/L-077"],
    rationale: "Dispozitat e mospërmbushjes dhe përgjegjësisë kontraktore zbatohen drejtpërdrejt; kontrata për vepër jep kontekst specifik për kryerjen e shërbimit.",
    relevantArticles: { "04/L-077": ["106", "107", "108", "109", "110", "111", "114", "245", "246", "247", "248", "249", "250", "251", "252"] },
    partiallyRelevantArticles: { "04/L-077": ["105", "112", "113", "115", "120", "121", "622", "623", "624", "626", "629", "630", "633", "635"] }
  },
  {
    evaluationId: "service-termination",
    contractType: "service",
    expectedTopic: "Ndërprerja e marrëveshjes së shërbimit",
    allowedLaws: ["04/L-077"],
    rationale: "Nenet për zgjidhjen e kontratës dhe dispozitat e kontratës për vepër trajtojnë mënyrat e ndërprerjes.",
    relevantArticles: { "04/L-077": ["106", "107", "108", "109", "110", "111", "114", "115", "623", "624", "634", "644"] },
    partiallyRelevantArticles: { "04/L-077": ["53", "112", "113", "117", "622", "633", "635"] }
  },
  {
    evaluationId: "service-damages",
    contractType: "service",
    expectedTopic: "Dëmshpërblimi për mosrealizimin e detyrimit",
    allowedLaws: ["04/L-077"],
    rationale: "Nenet 169–176 dhe 245–252 rregullojnë shpërblimin e dëmit dhe pasojat e mospërmbushjes së detyrimit.",
    relevantArticles: { "04/L-077": ["169", "170", "171", "172", "173", "174", "175", "176", "245", "246", "247", "248", "249", "250", "251", "252"] },
    partiallyRelevantArticles: { "04/L-077": ["106", "107", "108", "109", "110", "111", "114", "189", "190", "191"] }
  },
  {
    evaluationId: "lease-maintenance",
    contractType: "lease",
    expectedTopic: "Mirëmbajtja e objektit nga qiradhënësi",
    allowedLaws: ["04/L-077"],
    rationale: "Nenet 587 dhe 588 trajtojnë mirëmbajtjen, riparimet dhe pasojat e tyre; dispozitat për të metat japin kontekst plotësues.",
    relevantArticles: { "04/L-077": ["587", "588"] },
    partiallyRelevantArticles: { "04/L-077": ["586", "590", "591", "592", "593", "594", "595", "596", "597"] }
  },
  {
    evaluationId: "lease-termination",
    contractType: "lease",
    expectedTopic: "Përfundimi dhe ndërprerja e qirasë",
    allowedLaws: ["04/L-077"],
    rationale: "Nenet 601, 603 dhe 609–612 trajtojnë denoncimin ose mbarimin e qirasë në rrethana të ndryshme.",
    relevantArticles: { "04/L-077": ["601", "603", "609", "610", "611", "612"] },
    partiallyRelevantArticles: { "04/L-077": ["588", "599", "605", "613", "614"] }
  },
  {
    evaluationId: "lease-property-damage",
    contractType: "lease",
    expectedTopic: "Përgjegjësia për dëmtimin e objektit me qira",
    allowedLaws: ["04/L-077"],
    rationale: "Nenet për mirëmbajtjen, të metat, përdorimin dhe kthimin e sendit përcaktojnë përgjegjësitë relevante për dëmtimin.",
    relevantArticles: { "04/L-077": ["587", "589", "590", "592", "593", "594", "595", "596", "598", "599", "602"] },
    partiallyRelevantArticles: { "04/L-077": ["586", "588", "591", "597", "613"] }
  }
] as const satisfies readonly GoldSetDefinition[];

export function buildLegalRetrievalGoldSet(rawChunks: readonly unknown[]) {
  const chunks = z.array(localChunkSchema).parse(rawChunks);
  const seenChunkKeys = new Set<string>();

  const cases = LEGAL_RETRIEVAL_GOLD_DEFINITIONS.map((definition) => {
    const select = (articlesByLaw: Readonly<Record<string, readonly string[]>>) =>
      chunks
        .filter((chunk) =>
          articlesByLaw[chunk.lawNumber]?.includes(chunk.articleNumber)
        )
        .map((chunk) => ({
          lawNumber: chunk.lawNumber,
          versionLabel: chunk.versionLabel,
          language: chunk.language,
          articleNumber: chunk.articleNumber,
          articleTitle: chunk.articleTitle,
          chunkIndex: chunk.chunkIndex,
          contentHash: chunk.contentSha256
        }))
        .sort((left, right) =>
          left.lawNumber.localeCompare(right.lawNumber) ||
          left.chunkIndex - right.chunkIndex
        );

    const relevantChunks = select(definition.relevantArticles);
    const partiallyRelevantChunks = select(definition.partiallyRelevantArticles);
    if (relevantChunks.length === 0) {
      throw new Error(`LEGAL_RETRIEVAL_GOLD_SET_EMPTY:${definition.evaluationId}`);
    }
    for (const chunk of [...relevantChunks, ...partiallyRelevantChunks]) {
      const key = `${definition.evaluationId}:${chunk.lawNumber}:${chunk.chunkIndex}:${chunk.contentHash}`;
      if (seenChunkKeys.has(key)) {
        throw new Error(`LEGAL_RETRIEVAL_GOLD_SET_DUPLICATE:${definition.evaluationId}`);
      }
      seenChunkKeys.add(key);
    }

    return {
      ...definition,
      relevantChunks,
      partiallyRelevantChunks
    };
  });

  return {
    version: "legal-retrieval-gold-v1",
    corpus: "P0",
    language: "sq",
    cases
  } as const;
}
