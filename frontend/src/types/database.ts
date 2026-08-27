export type PreferredLanguage = 'sq' | 'en'

export type AiResponseDetail = 'summary' | 'detailed'

export type ContractType = 'service' | 'employment' | 'lease'

export type ContractStatus =
  | 'draft'
  | 'uploaded'
  | 'processing'
  | 'analyzed'
  | 'failed'
  | 'archived'

export type Profile = {
  id: string
  display_name: string
  preferred_language: PreferredLanguage
  ai_response_detail: AiResponseDetail
  show_legal_references: boolean
  created_at: string
  updated_at: string
}

export type Contract = {
  id: string
  owner_id: string
  title: string
  contract_type: ContractType
  status: ContractStatus
  created_at: string
  updated_at: string
}

export type ContractLatestCompletedAnalysis = {
  id: string
  versionId: string
  overallRisk: 'low' | 'medium' | 'high' | 'critical' | 'unknown'
  completedAt: string
}

export type ListedContract = Contract & {
  latestCompletedAnalysis: ContractLatestCompletedAnalysis | null
}
