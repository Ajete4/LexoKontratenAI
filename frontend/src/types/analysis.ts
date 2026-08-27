export type AnalysisLanguage = 'sq' | 'en' | 'mixed' | 'unknown'

export type AnalysisContractType = 'employment' | 'service' | 'lease'

export type OverallRiskLevel =
  | 'low'
  | 'medium'
  | 'high'
  | 'critical'
  | 'unknown'

export type ClauseType =
  | 'parties'
  | 'subject'
  | 'obligations'
  | 'duration'
  | 'payment'
  | 'penalty'
  | 'termination'
  | 'jurisdiction'
  | 'confidentiality'
  | 'liability'
  | 'data_protection'
  | 'dispute_resolution'
  | 'other'

export type FindingType =
  | 'normal'
  | 'risky'
  | 'imbalanced'
  | 'missing'
  | 'ambiguous'

export type ClauseSeverity =
  | 'none'
  | 'low'
  | 'medium'
  | 'high'
  | 'critical'
  | 'review_required'

export type FavoredParty =
  | 'party_a'
  | 'party_b'
  | 'balanced'
  | 'unclear'
  | 'not_applicable'

export type AnalysisParty = {
  role: string
  name: string | null
  description: string | null
}

export type AnalysisKeyDate = {
  label: string
  date: string | null
  description: string | null
}

export type AnalysisTerm = {
  title: string
  description: string
}

export type ClauseEvidenceStatus =
  | 'grounded'
  | 'insufficient_evidence'
  | 'legacy_unverified'

export type LegalCitation = {
  citationId: string
  rank: number
  lawNumber: '03/L-212' | '04/L-077' | '08/L-142'
  sourceTitle: string
  articleNumber: string | null
  articleTitle: string | null
  officialUrl: string
  officialDocumentUrl: string | null
}

export type ContractAnalysisResult = {
  language: AnalysisLanguage
  contractType: AnalysisContractType
  title: string
  summary: string
  parties: AnalysisParty[]
  keyDates: AnalysisKeyDate[]
  paymentTerms: AnalysisTerm[]
  terminationTerms: AnalysisTerm[]
  overallRiskLevel: OverallRiskLevel
  overallRiskExplanation: string
  missingInformation: string[]
  professionalReviewRecommended: boolean
  disclaimer: string
}

export type ContractAnalysisClause = {
  position: number
  clauseType: ClauseType
  findingType: FindingType
  title: string
  originalText: string | null
  simplifiedText: string | null
  severity: ClauseSeverity
  favoredParty: FavoredParty
  riskExplanation: string | null
  suggestedAction: string | null
  suggestedRewrite: string | null
  confidence: number
  requiresProfessionalReview: boolean
  evidenceStatus: ClauseEvidenceStatus
  citations: LegalCitation[]
}

export type ContractAnalysis = {
  analysisId: string
  contractId: string
  versionId: string
  status: 'completed'
  result: ContractAnalysisResult
  clauses: ContractAnalysisClause[]
  createdAt: string
  completedAt: string
}
