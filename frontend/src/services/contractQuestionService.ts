const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export type ContractQuestionCitation = {
  citationId: string
  lawNumber: '03/L-212' | '04/L-077' | '08/L-142'
  sourceTitle: string
  articleNumber: string | null
  articleTitle: string | null
  officialUrl: string
}

export type ContractQuestionResponse = {
  answer: string | null
  insufficientEvidence: boolean
  citations: ContractQuestionCitation[]
  disclaimer: string
}

export class ContractQuestionServiceError extends Error {
  readonly canRetry: boolean
  readonly kind: 'aborted' | 'authentication' | 'configuration' | 'network' | 'response' | 'server'

  constructor(message: string, kind: ContractQuestionServiceError['kind'], canRetry = false) {
    super(message)
    this.name = 'ContractQuestionServiceError'
    this.kind = kind
    this.canRetry = canRetry
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function hasExactKeys(value: Record<string, unknown>, expected: readonly string[]) {
  const keys = Object.keys(value)
  return keys.length === expected.length && keys.every((key) => expected.includes(key))
}

function isUuid(value: string) {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/iu.test(value)
}

function isHttpsUrl(value: unknown): value is string {
  if (typeof value !== 'string') return false
  try {
    return new URL(value).protocol === 'https:'
  } catch {
    return false
  }
}

function isNullableText(value: unknown, maximum: number): value is string | null {
  return value === null || (typeof value === 'string' && value.length >= 1 && value.length <= maximum)
}

function isCitation(value: unknown): value is ContractQuestionCitation {
  if (!isRecord(value) || !hasExactKeys(value, ['citationId', 'lawNumber', 'sourceTitle', 'articleNumber', 'articleTitle', 'officialUrl'])) return false

  return (
    typeof value.citationId === 'string' && /^C[1-5]$/u.test(value.citationId) &&
    ['03/L-212', '04/L-077', '08/L-142'].includes(String(value.lawNumber)) &&
    typeof value.sourceTitle === 'string' && value.sourceTitle.length >= 1 && value.sourceTitle.length <= 300 &&
    isNullableText(value.articleNumber, 100) && isNullableText(value.articleTitle, 300) &&
    isHttpsUrl(value.officialUrl)
  )
}

function parseResponse(payload: unknown): ContractQuestionResponse | null {
  if (!isRecord(payload) || !hasExactKeys(payload, ['data']) || !isRecord(payload.data)) return null
  const data = payload.data
  if (!hasExactKeys(data, ['answer', 'insufficientEvidence', 'citations', 'disclaimer'])) return null
  if (!(data.answer === null || (typeof data.answer === 'string' && data.answer.length >= 1 && data.answer.length <= 4_000)) || typeof data.insufficientEvidence !== 'boolean' || !Array.isArray(data.citations) || data.citations.length > 5 || !data.citations.every(isCitation) || typeof data.disclaimer !== 'string' || data.disclaimer.length < 1 || data.disclaimer.length > 500) return null
  const ids = data.citations.map((citation) => citation.citationId)
  if (new Set(ids).size !== ids.length) return null
  if (data.insufficientEvidence && (data.answer !== null || data.citations.length !== 0)) return null
  if (!data.insufficientEvidence && data.answer === null) return null
  return data as ContractQuestionResponse
}

async function getBackendCode(response: Response) {
  try {
    const payload: unknown = await response.json()
    return isRecord(payload) && isRecord(payload.error) && typeof payload.error.code === 'string' ? payload.error.code : null
  } catch {
    return null
  }
}

export async function askContractQuestion(input: { accessToken: string; contractId: string; versionId: string; question: string; signal?: AbortSignal }): Promise<ContractQuestionResponse> {
  if (!apiBaseUrl) throw new ContractQuestionServiceError('Lidhja me backend-in nuk është konfiguruar.', 'configuration')
  if (!isUuid(input.contractId) || !isUuid(input.versionId)) throw new ContractQuestionServiceError('Konteksti i kontratës nuk është valid.', 'response')
  if (input.question.trim().length === 0 || input.question.length > 1_000) throw new ContractQuestionServiceError('Pyetja duhet të ketë nga 1 deri në 1000 karaktere.', 'response')

  let response: Response
  try {
    response = await fetch(`${apiBaseUrl}/api/contracts/${encodeURIComponent(input.contractId)}/versions/${encodeURIComponent(input.versionId)}/questions`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${input.accessToken}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ question: input.question }),
      signal: input.signal,
    })
  } catch (error) {
    if (input.signal?.aborted || (error instanceof DOMException && error.name === 'AbortError')) throw new ContractQuestionServiceError('Kërkesa u anulua.', 'aborted')
    throw new ContractQuestionServiceError('Backend-i nuk është i disponueshëm për momentin.', 'network', true)
  }

  if (!response.ok) {
    const code = await getBackendCode(response)
    if (response.status === 401) throw new ContractQuestionServiceError('Sesioni juaj ka skaduar.', 'authentication')
    const message = code === 'CONTRACT_VERSION_NOT_FOUND' ? 'Kontrata ose versioni nuk u gjet.' : 'Përgjigjja nuk mund të përgatitej për momentin.'
    throw new ContractQuestionServiceError(message, 'server', response.status >= 500 || response.status === 429)
  }

  let payload: unknown
  try {
    payload = await response.json()
  } catch {
    throw new ContractQuestionServiceError('Përgjigjja e backend-it nuk ishte valide.', 'response')
  }
  const parsed = parseResponse(payload)
  if (!parsed) throw new ContractQuestionServiceError('Përgjigjja e backend-it nuk ishte valide.', 'response')
  return parsed
}
