import { isAnalysisUuid } from './contractAnalysisService'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export const clauseRewriteGoals = [
  'balanced_termination',
  'softer_penalty',
  'clearer_payment',
  'stronger_confidentiality',
  'clearer_delivery',
] as const

export type ClauseRewriteGoal = (typeof clauseRewriteGoals)[number]

export type ClauseRewriteResult = {
  clausePosition: number
  goal: ClauseRewriteGoal
  originalText: string
  rewrittenText: string
  disclaimer: string
}

export class ClauseRewriteServiceError extends Error {
  readonly canRetry: boolean
  readonly kind: 'aborted' | 'authentication' | 'configuration' | 'network' | 'not_found' | 'response' | 'server'

  constructor(message: string, kind: ClauseRewriteServiceError['kind'], canRetry = false) {
    super(message)
    this.name = 'ClauseRewriteServiceError'
    this.kind = kind
    this.canRetry = canRetry
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function hasExactKeys(value: Record<string, unknown>, keys: readonly string[]) {
  const actualKeys = Object.keys(value)
  return actualKeys.length === keys.length && actualKeys.every((key) => keys.includes(key))
}

function isGoal(value: unknown): value is ClauseRewriteGoal {
  return typeof value === 'string' && clauseRewriteGoals.includes(value as ClauseRewriteGoal)
}

function parseResponse(value: unknown, position: number, goal: ClauseRewriteGoal): ClauseRewriteResult | null {
  if (!isRecord(value) || !hasExactKeys(value, ['data']) || !isRecord(value.data) || !hasExactKeys(value.data, ['clausePosition', 'goal', 'originalText', 'rewrittenText', 'disclaimer'])) return null
  const data = value.data
  return data.clausePosition === position && data.goal === goal && isGoal(data.goal) && typeof data.originalText === 'string' && data.originalText.trim().length > 0 && data.originalText.length <= 1_500 && typeof data.rewrittenText === 'string' && data.rewrittenText.trim().length > 0 && data.rewrittenText.length <= 2_000 && typeof data.disclaimer === 'string' && data.disclaimer.length > 0 ? data as ClauseRewriteResult : null
}

export async function rewriteClause(input: { accessToken: string; contractId: string; versionId: string; position: number; goal: ClauseRewriteGoal; signal?: AbortSignal }): Promise<ClauseRewriteResult> {
  if (!apiBaseUrl || !isAnalysisUuid(input.contractId) || !isAnalysisUuid(input.versionId) || !Number.isInteger(input.position) || input.position < 1 || input.position > 30 || !isGoal(input.goal)) {
    throw new ClauseRewriteServiceError('Kërkesa për rishkrim nuk është valide.', apiBaseUrl ? 'response' : 'configuration')
  }

  let response: Response
  try {
    response = await fetch(`${apiBaseUrl}/api/contracts/${encodeURIComponent(input.contractId)}/versions/${encodeURIComponent(input.versionId)}/clauses/${input.position}/rewrite`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${input.accessToken}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ goal: input.goal }),
      signal: input.signal,
    })
  } catch (error) {
    if (input.signal?.aborted || (error instanceof DOMException && error.name === 'AbortError')) throw new ClauseRewriteServiceError('Kërkesa u anulua.', 'aborted')
    throw new ClauseRewriteServiceError('Backend-i nuk është i disponueshëm për momentin.', 'network', true)
  }

  if (response.status === 401) throw new ClauseRewriteServiceError('Sesioni juaj ka skaduar.', 'authentication')
  if (response.status === 404) throw new ClauseRewriteServiceError('Klauzola nga analiza e përfunduar nuk u gjet.', 'not_found')
  if (!response.ok) throw new ClauseRewriteServiceError('Klauzola nuk mund të rishkruhej për momentin.', 'server', response.status >= 500)

  let payload: unknown
  try {
    payload = await response.json()
  } catch {
    throw new ClauseRewriteServiceError('Përgjigjja nuk ishte valide.', 'response')
  }
  const result = parseResponse(payload, input.position, input.goal)
  if (!result) throw new ClauseRewriteServiceError('Përgjigjja nuk ishte valide.', 'response')
  return result
}
