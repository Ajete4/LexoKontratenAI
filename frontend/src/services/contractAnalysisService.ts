import type {
  AnalysisContractType,
  AnalysisKeyDate,
  AnalysisLanguage,
  AnalysisParty,
  AnalysisTerm,
  ClauseEvidenceStatus,
  ClauseSeverity,
  ClauseType,
  ContractAnalysis,
  ContractAnalysisClause,
  ContractAnalysisResult,
  FavoredParty,
  FindingType,
  LegalCitation,
  OverallRiskLevel,
} from '../types/analysis'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export const CONTRACT_ANALYSIS_DISCLAIMER =
  'Ky rezultat ofron informacion të përgjithshëm dhe nuk përbën këshillë juridike. Për vendime ose raste konkrete, konsultohuni me një profesionist juridik të kualifikuar.'

const invalidResponseMessage = 'Përgjigjja e analizës nuk ishte valide.'

export type ContractAnalysisErrorKind =
  | 'aborted'
  | 'authentication'
  | 'configuration'
  | 'network'
  | 'not_found'
  | 'response'
  | 'server'

export class ContractAnalysisServiceError extends Error {
  readonly backendCode: string | null
  readonly canRetry: boolean
  readonly kind: ContractAnalysisErrorKind
  readonly statusCode: number | null

  constructor(
    message: string,
    kind: ContractAnalysisErrorKind,
    options: {
      backendCode?: string | null
      canRetry?: boolean
      statusCode?: number | null
    } = {},
  ) {
    super(message)
    this.name = 'ContractAnalysisServiceError'
    this.backendCode = options.backendCode ?? null
    this.canRetry = options.canRetry ?? false
    this.kind = kind
    this.statusCode = options.statusCode ?? null
  }
}

type AnalyzeContractInput = {
  accessToken: string
  contractId: string
  signal?: AbortSignal
  versionId: string
}

export type GetContractAnalysisInput = AnalyzeContractInput

export type GetLatestContractAnalysisInput = {
  accessToken: string
  signal?: AbortSignal
}

export type GetLatestAnalysisForContractInput = {
  accessToken: string
  contractId: string
  signal?: AbortSignal
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function hasExactKeys(
  value: Record<string, unknown>,
  expectedKeys: readonly string[],
): boolean {
  const actualKeys = Object.keys(value)

  return (
    actualKeys.length === expectedKeys.length &&
    actualKeys.every((key) => expectedKeys.includes(key))
  )
}

function isLimitedString(
  value: unknown,
  minimum: number,
  maximum: number,
): value is string {
  return (
    typeof value === 'string' &&
    value.length >= minimum &&
    value.length <= maximum
  )
}

function isNullableLimitedString(
  value: unknown,
  maximum: number,
): value is string | null {
  return value === null || (typeof value === 'string' && value.length <= maximum)
}

export function isAnalysisUuid(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      value,
    )
  )
}

function isTimestamp(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    value.length > 0 &&
    !Number.isNaN(Date.parse(value))
  )
}

function isOneOf<T extends string>(
  value: unknown,
  allowedValues: readonly T[],
): value is T {
  return typeof value === 'string' && allowedValues.includes(value as T)
}

function isParty(value: unknown): value is AnalysisParty {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['role', 'name', 'description'])
  ) {
    return false
  }

  return (
    isLimitedString(value.role, 1, 100) &&
    isNullableLimitedString(value.name, 200) &&
    isNullableLimitedString(value.description, 500)
  )
}

function isKeyDate(value: unknown): value is AnalysisKeyDate {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['label', 'date', 'description'])
  ) {
    return false
  }

  return (
    isLimitedString(value.label, 1, 100) &&
    isNullableLimitedString(value.date, 50) &&
    isNullableLimitedString(value.description, 500)
  )
}

function isTerm(value: unknown): value is AnalysisTerm {
  if (!isRecord(value) || !hasExactKeys(value, ['title', 'description'])) {
    return false
  }

  return (
    isLimitedString(value.title, 1, 150) &&
    isLimitedString(value.description, 1, 1_000)
  )
}

function isAnalysisResult(value: unknown): value is ContractAnalysisResult {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'language',
      'contractType',
      'title',
      'summary',
      'parties',
      'keyDates',
      'paymentTerms',
      'terminationTerms',
      'overallRiskLevel',
      'overallRiskExplanation',
      'missingInformation',
      'professionalReviewRecommended',
      'disclaimer',
    ])
  ) {
    return false
  }

  return (
    isOneOf<AnalysisLanguage>(value.language, ['sq', 'en', 'mixed', 'unknown']) &&
    isOneOf<AnalysisContractType>(value.contractType, [
      'employment',
      'service',
      'lease',
    ]) &&
    isLimitedString(value.title, 1, 200) &&
    isLimitedString(value.summary, 1, 2_000) &&
    Array.isArray(value.parties) &&
    value.parties.length <= 10 &&
    value.parties.every(isParty) &&
    Array.isArray(value.keyDates) &&
    value.keyDates.length <= 20 &&
    value.keyDates.every(isKeyDate) &&
    Array.isArray(value.paymentTerms) &&
    value.paymentTerms.length <= 20 &&
    value.paymentTerms.every(isTerm) &&
    Array.isArray(value.terminationTerms) &&
    value.terminationTerms.length <= 10 &&
    value.terminationTerms.every(isTerm) &&
    isOneOf<OverallRiskLevel>(value.overallRiskLevel, [
      'low',
      'medium',
      'high',
      'critical',
      'unknown',
    ]) &&
    isLimitedString(value.overallRiskExplanation, 1, 1_500) &&
    Array.isArray(value.missingInformation) &&
    value.missingInformation.length <= 20 &&
    value.missingInformation.every((item) => isLimitedString(item, 1, 500)) &&
    typeof value.professionalReviewRecommended === 'boolean' &&
    value.disclaimer === CONTRACT_ANALYSIS_DISCLAIMER
  )
}

function isHttpsUrl(value: unknown): value is string {
  if (typeof value !== 'string') {
    return false
  }

  try {
    return new URL(value).protocol === 'https:'
  } catch {
    return false
  }
}

function isLegalCitation(value: unknown): value is LegalCitation {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'citationId',
      'rank',
      'lawNumber',
      'sourceTitle',
      'articleNumber',
      'articleTitle',
      'officialUrl',
      'officialDocumentUrl',
    ])
  ) {
    return false
  }

  return (
    typeof value.citationId === 'string' &&
    /^C[1-5]$/.test(value.citationId) &&
    Number.isInteger(value.rank) &&
    typeof value.rank === 'number' &&
    value.rank >= 1 &&
    value.rank <= 5 &&
    isOneOf<LegalCitation['lawNumber']>(value.lawNumber, [
      '03/L-212',
      '04/L-077',
      '08/L-142',
    ]) &&
    isLimitedString(value.sourceTitle, 1, 300) &&
    isNullableLimitedString(value.articleNumber, 100) &&
    isNullableLimitedString(value.articleTitle, 300) &&
    isHttpsUrl(value.officialUrl) &&
    (value.officialDocumentUrl === null ||
      isHttpsUrl(value.officialDocumentUrl))
  )
}

function isClause(value: unknown, expectedPosition: number): value is ContractAnalysisClause {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'position',
      'clauseType',
      'findingType',
      'title',
      'originalText',
      'simplifiedText',
      'severity',
      'favoredParty',
      'riskExplanation',
      'suggestedAction',
      'suggestedRewrite',
      'confidence',
      'requiresProfessionalReview',
      'evidenceStatus',
      'citations',
    ])
  ) {
    return false
  }

  const findingTypeValid = isOneOf<FindingType>(value.findingType, [
    'normal',
    'risky',
    'imbalanced',
    'missing',
    'ambiguous',
  ])
  const originalTextValid =
    findingTypeValid && value.findingType === 'missing'
      ? value.originalText === null
      : isLimitedString(value.originalText, 1, 1_500) &&
        value.originalText.trim().length > 0

  const evidenceStatusValid = isOneOf<ClauseEvidenceStatus>(
    value.evidenceStatus,
    ['grounded', 'insufficient_evidence', 'legacy_unverified'],
  )
  const citations =
    Array.isArray(value.citations) && value.citations.every(isLegalCitation)
      ? value.citations
      : null
  const citationsValid =
    citations !== null &&
    citations.length <= 5 &&
    citations.every((citation, index) => citation.rank === index + 1) &&
    new Set(citations.map((citation) => citation.citationId)).size ===
      citations.length
  const evidenceCoherent =
    evidenceStatusValid &&
    citationsValid &&
    (value.evidenceStatus === 'grounded'
      ? citations !== null && citations.length > 0
      : citations !== null && citations.length === 0)

  return (
    value.position === expectedPosition &&
    Number.isInteger(value.position) &&
    isOneOf<ClauseType>(value.clauseType, [
      'parties',
      'subject',
      'obligations',
      'duration',
      'payment',
      'penalty',
      'termination',
      'jurisdiction',
      'confidentiality',
      'liability',
      'data_protection',
      'dispute_resolution',
      'other',
    ]) &&
    findingTypeValid &&
    isLimitedString(value.title, 1, 200) &&
    originalTextValid &&
    isNullableLimitedString(value.simplifiedText, 1_000) &&
    isOneOf<ClauseSeverity>(value.severity, [
      'none',
      'low',
      'medium',
      'high',
      'critical',
      'review_required',
    ]) &&
    isOneOf<FavoredParty>(value.favoredParty, [
      'party_a',
      'party_b',
      'balanced',
      'unclear',
      'not_applicable',
    ]) &&
    isNullableLimitedString(value.riskExplanation, 1_500) &&
    isNullableLimitedString(value.suggestedAction, 1_000) &&
    isNullableLimitedString(value.suggestedRewrite, 2_000) &&
    typeof value.confidence === 'number' &&
    Number.isFinite(value.confidence) &&
    value.confidence >= 0 &&
    value.confidence <= 1 &&
    typeof value.requiresProfessionalReview === 'boolean' &&
    evidenceCoherent
  )
}

export function isContractAnalysis(
  value: unknown,
  expectedContractId: string,
  expectedVersionId: string,
): value is ContractAnalysis {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'analysisId',
      'contractId',
      'versionId',
      'status',
      'result',
      'clauses',
      'createdAt',
      'completedAt',
    ])
  ) {
    return false
  }

  return (
    isAnalysisUuid(value.analysisId) &&
    value.contractId === expectedContractId &&
    value.versionId === expectedVersionId &&
    isAnalysisUuid(value.contractId) &&
    isAnalysisUuid(value.versionId) &&
    value.status === 'completed' &&
    isAnalysisResult(value.result) &&
    Array.isArray(value.clauses) &&
    value.clauses.length <= 30 &&
    value.clauses.every((clause, index) => isClause(clause, index + 1)) &&
    isTimestamp(value.createdAt) &&
    isTimestamp(value.completedAt)
  )
}

function parseAnalysisResponse(
  value: unknown,
  contractId: string,
  versionId: string,
): ContractAnalysis | null {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['data']) ||
    !isRecord(value.data) ||
    !hasExactKeys(value.data, ['analysis']) ||
    !isContractAnalysis(value.data.analysis, contractId, versionId)
  ) {
    return null
  }

  return value.data.analysis
}

function parseLatestAnalysisResponse(value: unknown): ContractAnalysis | null {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['data']) ||
    !isRecord(value.data) ||
    !hasExactKeys(value.data, ['analysis']) ||
    !isRecord(value.data.analysis)
  ) {
    return null
  }

  const contractId = value.data.analysis.contractId
  const versionId = value.data.analysis.versionId

  return isAnalysisUuid(contractId) &&
    isAnalysisUuid(versionId) &&
    isContractAnalysis(value.data.analysis, contractId, versionId)
    ? value.data.analysis
    : null
}

async function getBackendCode(response: Response): Promise<string | null> {
  try {
    const value: unknown = await response.json()

    return isRecord(value) &&
      isRecord(value.error) &&
      typeof value.error.code === 'string'
      ? value.error.code
      : null
  } catch {
    return null
  }
}

const backendMessages: Readonly<Record<string, { message: string; retry: boolean }>> = {
  VERSION_NOT_FOUND: {
    message: 'Versioni i kontratës nuk u gjet.',
    retry: false,
  },
  ANALYSIS_ALREADY_RUNNING: {
    message: 'Analiza është duke u përpunuar.',
    retry: true,
  },
  ANALYSIS_INPUT_TOO_LARGE: {
    message: 'Dokumenti është shumë i madh për analizë.',
    retry: false,
  },
  EXTRACTION_NOT_COMPLETED: {
    message: 'Nxjerrja e tekstit duhet të përfundojë para analizës.',
    retry: false,
  },
  EXTRACTED_TEXT_MISSING: {
    message: 'Dokumenti nuk përmban tekst për analizë.',
    retry: false,
  },
  AI_REFUSED: {
    message: 'Analiza nuk mund të përfundohej për këtë dokument.',
    retry: false,
  },
  AI_RATE_LIMITED: {
    message: 'Shërbimi i analizës është i ngarkuar. Provoni përsëri më vonë.',
    retry: true,
  },
  AI_OUTPUT_INVALID: {
    message: 'Rezultati i analizës nuk ishte valid. Provoni përsëri.',
    retry: true,
  },
  AI_CONFIGURATION_MISSING: {
    message: 'Shërbimi AI nuk është konfiguruar.',
    retry: false,
  },
  AI_UNAVAILABLE: {
    message: 'Shërbimi AI nuk është i disponueshëm për momentin.',
    retry: true,
  },
  DATABASE_UNAVAILABLE: {
    message: 'Rezultati nuk mund të ruhej. Provoni përsëri.',
    retry: true,
  },
  ANALYSIS_PERSISTENCE_FAILED: {
    message: 'Rezultati nuk mund të ruhej. Provoni përsëri.',
    retry: true,
  },
  AI_TIMEOUT: {
    message: 'Analiza zgjati më shumë se pritej. Provoni përsëri.',
    retry: true,
  },
}

function serviceErrorFromResponse(
  statusCode: number,
  backendCode: string | null,
): ContractAnalysisServiceError {
  if (statusCode === 401) {
    return new ContractAnalysisServiceError(
      'Sesioni juaj ka skaduar. Ju lutemi kyçuni përsëri.',
      'authentication',
      { backendCode, statusCode },
    )
  }

  if (statusCode === 404 && backendCode === 'ANALYSIS_NOT_FOUND') {
    return new ContractAnalysisServiceError(
      'Nuk ka ende analizë të përfunduar.',
      'not_found',
      { backendCode, statusCode },
    )
  }

  const mapped = backendCode ? backendMessages[backendCode] : undefined

  if (mapped) {
    return new ContractAnalysisServiceError(mapped.message, 'server', {
      backendCode,
      canRetry: mapped.retry,
      statusCode,
    })
  }

  return new ContractAnalysisServiceError(
    'Backend-i nuk është i disponueshëm për momentin.',
    'server',
    { backendCode, canRetry: statusCode >= 500, statusCode },
  )
}

export async function requestContractAnalysis({
  accessToken,
  contractId,
  signal,
  versionId,
}: AnalyzeContractInput): Promise<ContractAnalysis> {
  if (!apiBaseUrl) {
    throw new ContractAnalysisServiceError(
      'Lidhja me backend-in nuk është konfiguruar.',
      'configuration',
    )
  }

  if (!isAnalysisUuid(contractId) || !isAnalysisUuid(versionId)) {
    throw new ContractAnalysisServiceError(
      'Kërkesa për analizë nuk është valide.',
      'response',
      { statusCode: 400 },
    )
  }

  let response: Response

  try {
    response = await fetch(
      `${apiBaseUrl}/api/contracts/${encodeURIComponent(contractId)}/versions/${encodeURIComponent(versionId)}/analyze`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
        signal,
      },
    )
  } catch (error) {
    if (signal?.aborted || (error instanceof DOMException && error.name === 'AbortError')) {
      throw new ContractAnalysisServiceError('Kërkesa u anulua.', 'aborted')
    }

    throw new ContractAnalysisServiceError(
      'Backend-i nuk është i disponueshëm për momentin.',
      'network',
      { canRetry: true },
    )
  }

  if (!response.ok) {
    const backendCode = await getBackendCode(response)
    throw serviceErrorFromResponse(response.status, backendCode)
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractAnalysisServiceError(
      invalidResponseMessage,
      'response',
      { statusCode: response.status },
    )
  }

  const analysis = parseAnalysisResponse(payload, contractId, versionId)

  if (!analysis) {
    throw new ContractAnalysisServiceError(
      invalidResponseMessage,
      'response',
      { statusCode: response.status },
    )
  }

  return analysis
}

async function requestPersistedAnalysis(
  path: string,
  accessToken: string,
  signal: AbortSignal | undefined,
  validatePayload: (payload: unknown) => ContractAnalysis | null,
): Promise<ContractAnalysis> {
  if (!apiBaseUrl) {
    throw new ContractAnalysisServiceError(
      'Lidhja me backend-in nuk është konfiguruar.',
      'configuration',
    )
  }

  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}${path}`, {
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
      throw new ContractAnalysisServiceError('Kërkesa u anulua.', 'aborted')
    }

    throw new ContractAnalysisServiceError(
      'Backend-i nuk është i disponueshëm për momentin.',
      'network',
      { canRetry: true },
    )
  }

  if (!response.ok) {
    const backendCode = await getBackendCode(response)
    throw serviceErrorFromResponse(response.status, backendCode)
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractAnalysisServiceError(
      invalidResponseMessage,
      'response',
      { statusCode: response.status },
    )
  }

  const analysis = validatePayload(payload)

  if (!analysis) {
    throw new ContractAnalysisServiceError(
      invalidResponseMessage,
      'response',
      { statusCode: response.status },
    )
  }

  return analysis
}

export async function getContractAnalysis({
  accessToken,
  contractId,
  signal,
  versionId,
}: GetContractAnalysisInput): Promise<ContractAnalysis> {
  if (!isAnalysisUuid(contractId) || !isAnalysisUuid(versionId)) {
    throw new ContractAnalysisServiceError(
      'Kërkesa për analizën nuk është valide.',
      'response',
      { statusCode: 400 },
    )
  }

  return requestPersistedAnalysis(
    `/api/contracts/${encodeURIComponent(contractId)}/versions/${encodeURIComponent(versionId)}/analysis`,
    accessToken,
    signal,
    (payload) => parseAnalysisResponse(payload, contractId, versionId),
  )
}

export async function getLatestContractAnalysis({
  accessToken,
  signal,
}: GetLatestContractAnalysisInput): Promise<ContractAnalysis> {
  return requestPersistedAnalysis(
    '/api/analyses/latest',
    accessToken,
    signal,
    parseLatestAnalysisResponse,
  )
}

export async function getLatestAnalysisForContract({
  accessToken,
  contractId,
  signal,
}: GetLatestAnalysisForContractInput): Promise<ContractAnalysis> {
  if (!isAnalysisUuid(contractId)) {
    throw new ContractAnalysisServiceError(
      'Kërkesa për analizën nuk është valide.',
      'response',
      { statusCode: 400 },
    )
  }

  return requestPersistedAnalysis(
    `/api/contracts/${encodeURIComponent(contractId)}/analysis/latest`,
    accessToken,
    signal,
    (payload) => {
      const analysis = parseLatestAnalysisResponse(payload)

      return analysis?.contractId === contractId ? analysis : null
    },
  )
}
