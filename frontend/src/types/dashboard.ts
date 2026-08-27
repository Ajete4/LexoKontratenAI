import type {
  ClauseSeverity,
  FindingType,
  OverallRiskLevel,
} from './analysis'
import type { ContractStatus, ContractType } from './database'

export type DashboardStats = {
  completedAnalyses: number
  criticalClauses: number
  professionalReviewClauses: number
  qaQuestions: number
}

export type DashboardLatestAnalysis = {
  analysisId: string
  versionId: string
  overallRiskLevel: OverallRiskLevel
  completedAt: string
  criticalClauseCount: number
  professionalReviewClauseCount: number
}

export type DashboardRecentContract = {
  id: string
  title: string
  contractType: ContractType
  status: ContractStatus
  createdAt: string
  latestCompletedAnalysis: DashboardLatestAnalysis | null
}

export type DashboardRecentReview = {
  analysisId: string
  contractId: string
  versionId: string
  contractTitle: string
  clausePosition: number
  heading: string | null
  severity: ClauseSeverity
  findingType: FindingType
  completedAt: string
}

export type Dashboard = {
  stats: DashboardStats
  recentContracts: DashboardRecentContract[]
  recentReviews: DashboardRecentReview[]
}
