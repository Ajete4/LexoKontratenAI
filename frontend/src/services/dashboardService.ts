import type {
  ClauseSeverity,
  FindingType,
  OverallRiskLevel,
} from '../types/analysis'
import type {
  Dashboard,
  DashboardLatestAnalysis,
  DashboardRecentContract,
  DashboardRecentReview,
} from '../types/dashboard'
import type { ContractStatus, ContractType } from '../types/database'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

const contractTypes: ContractType[] = ['employment', 'service', 'lease']
const contractStatuses: ContractStatus[] = [
  'draft',
  'uploaded',
  'processing',
  'analyzed',
  'failed',
  'archived',
]
const riskLevels: OverallRiskLevel[] = [
  'low',
  'medium',
  'high',
  'critical',
  'unknown',
]
const severities: ClauseSeverity[] = [
  'none',
  'low',
  'medium',
  'high',
  'critical',
  'review_required',
]
const findingTypes: FindingType[] = [
  'normal',
  'risky',
  'imbalanced',
  'missing',
  'ambiguous',
]

export type DashboardServiceErrorKind =
  | 'aborted'
  | 'authentication'
  | 'configuration'
  | 'network'
  | 'response'
  | 'server'

export class DashboardServiceError extends Error {
  readonly canRetry: boolean
  readonly kind: DashboardServiceErrorKind
  readonly statusCode: number | null

  constructor(
    message: string,
    kind: DashboardServiceErrorKind,
    options: { canRetry?: boolean; statusCode?: number | null } = {},
  ) {
    super(message)
    this.name = 'DashboardServiceError'
    this.canRetry = options.canRetry ?? false
    this.kind = kind
    this.statusCode = options.statusCode ?? null
  }
}

type GetDashboardInput = {
  accessToken: string
  signal?: AbortSignal
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function hasExactKeys(
  value: Record<string, unknown>,
  expectedKeys: readonly string[],
) {
  const actualKeys = Object.keys(value)

  return (
    actualKeys.length === expectedKeys.length &&
    actualKeys.every((key) => expectedKeys.includes(key))
  )
}

function isUuid(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      value,
    )
  )
}

function isIsoTimestamp(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})$/.test(
      value,
    ) &&
    !Number.isNaN(Date.parse(value))
  )
}

function isNonNegativeInteger(value: unknown): value is number {
  return Number.isInteger(value) && typeof value === 'number' && value >= 0
}

function isEnumValue<T extends string>(
  value: unknown,
  values: readonly T[],
): value is T {
  return typeof value === 'string' && values.includes(value as T)
}

function isLatestAnalysis(value: unknown): value is DashboardLatestAnalysis {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'analysisId',
      'versionId',
      'overallRiskLevel',
      'completedAt',
      'criticalClauseCount',
      'professionalReviewClauseCount',
    ])
  ) {
    return false
  }

  return (
    isUuid(value.analysisId) &&
    isUuid(value.versionId) &&
    isEnumValue(value.overallRiskLevel, riskLevels) &&
    isIsoTimestamp(value.completedAt) &&
    isNonNegativeInteger(value.criticalClauseCount) &&
    isNonNegativeInteger(value.professionalReviewClauseCount)
  )
}

function isRecentContract(value: unknown): value is DashboardRecentContract {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'id',
      'title',
      'contractType',
      'status',
      'createdAt',
      'latestCompletedAnalysis',
    ])
  ) {
    return false
  }

  return (
    isUuid(value.id) &&
    typeof value.title === 'string' &&
    value.title.length >= 1 &&
    value.title.length <= 200 &&
    isEnumValue(value.contractType, contractTypes) &&
    isEnumValue(value.status, contractStatuses) &&
    isIsoTimestamp(value.createdAt) &&
    (value.latestCompletedAnalysis === null ||
      isLatestAnalysis(value.latestCompletedAnalysis))
  )
}

function isRecentReview(value: unknown): value is DashboardRecentReview {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'analysisId',
      'contractId',
      'versionId',
      'contractTitle',
      'clausePosition',
      'heading',
      'severity',
      'findingType',
      'completedAt',
    ])
  ) {
    return false
  }

  return (
    isUuid(value.analysisId) &&
    isUuid(value.contractId) &&
    isUuid(value.versionId) &&
    typeof value.contractTitle === 'string' &&
    value.contractTitle.length >= 1 &&
    value.contractTitle.length <= 200 &&
    Number.isInteger(value.clausePosition) &&
    typeof value.clausePosition === 'number' &&
    value.clausePosition > 0 &&
    (value.heading === null ||
      (typeof value.heading === 'string' && value.heading.length <= 200)) &&
    isEnumValue(value.severity, severities) &&
    isEnumValue(value.findingType, findingTypes) &&
    isIsoTimestamp(value.completedAt)
  )
}

function parseDashboardResponse(value: unknown): Dashboard | null {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['data']) ||
    !isRecord(value.data) ||
    !hasExactKeys(value.data, ['dashboard']) ||
    !isRecord(value.data.dashboard) ||
    !hasExactKeys(value.data.dashboard, [
      'stats',
      'recentContracts',
      'recentReviews',
    ])
  ) {
    return null
  }

  const dashboard = value.data.dashboard

  if (
    !isRecord(dashboard.stats) ||
    !hasExactKeys(dashboard.stats, [
      'completedAnalyses',
      'criticalClauses',
      'professionalReviewClauses',
      'qaQuestions',
    ]) ||
    !isNonNegativeInteger(dashboard.stats.completedAnalyses) ||
    !isNonNegativeInteger(dashboard.stats.criticalClauses) ||
    !isNonNegativeInteger(dashboard.stats.professionalReviewClauses) ||
    dashboard.stats.qaQuestions !== 0 ||
    !Array.isArray(dashboard.recentContracts) ||
    dashboard.recentContracts.length > 5 ||
    !dashboard.recentContracts.every(isRecentContract) ||
    !Array.isArray(dashboard.recentReviews) ||
    dashboard.recentReviews.length > 5 ||
    !dashboard.recentReviews.every(isRecentReview)
  ) {
    return null
  }

  return dashboard as Dashboard
}

export async function getDashboard({
  accessToken,
  signal,
}: GetDashboardInput): Promise<Dashboard> {
  if (!apiBaseUrl) {
    throw new DashboardServiceError(
      'Lidhja me backend-in nuk është konfiguruar.',
      'configuration',
    )
  }

  if (!accessToken) {
    throw new DashboardServiceError(
      'Sesioni juaj nuk është aktiv.',
      'authentication',
    )
  }

  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}/api/dashboard`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
      signal,
    })
  } catch (error) {
    if (
      signal?.aborted ||
      (error instanceof DOMException && error.name === 'AbortError')
    ) {
      throw new DashboardServiceError('Kërkesa u anulua.', 'aborted')
    }

    throw new DashboardServiceError(
      'Backend-i nuk është i disponueshëm për momentin.',
      'network',
      { canRetry: true },
    )
  }

  if (response.status === 401) {
    throw new DashboardServiceError(
      'Sesioni juaj ka skaduar. Ju lutemi kyçuni përsëri.',
      'authentication',
      { statusCode: response.status },
    )
  }

  if (!response.ok) {
    throw new DashboardServiceError(
      'Paneli nuk mund të ngarkohet për momentin.',
      'server',
      { canRetry: response.status >= 500, statusCode: response.status },
    )
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new DashboardServiceError(
      'Të dhënat e panelit nuk ishin valide.',
      'response',
      { statusCode: response.status },
    )
  }

  const dashboard = parseDashboardResponse(payload)

  if (!dashboard) {
    throw new DashboardServiceError(
      'Të dhënat e panelit nuk ishin valide.',
      'response',
      { statusCode: response.status },
    )
  }

  return dashboard
}
