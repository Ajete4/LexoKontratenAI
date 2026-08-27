const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export type RecentQuestion = {
  id: string
  contractId: string
  versionId: string
  question: string
  answer: string
  createdAt: string
}

export type RecentQuestionHistory = {
  questions: RecentQuestion[]
  monthlyCount: number
}

export class QuestionHistoryServiceError extends Error {
  readonly canRetry: boolean
  readonly kind: 'aborted' | 'authentication' | 'configuration' | 'network' | 'response' | 'server'

  constructor(
    message: string,
    kind: QuestionHistoryServiceError['kind'],
    canRetry = false,
  ) {
    super(message)
    this.name = 'QuestionHistoryServiceError'
    this.kind = kind
    this.canRetry = canRetry
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function hasExactKeys(
  value: Record<string, unknown>,
  expectedKeys: readonly string[],
) {
  const keys = Object.keys(value)
  return keys.length === expectedKeys.length && keys.every((key) => expectedKeys.includes(key))
}

function isUuid(value: unknown): value is string {
  return typeof value === 'string' && /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/iu.test(value)
}

function isIsoTimestamp(value: unknown): value is string {
  return typeof value === 'string' && !Number.isNaN(Date.parse(value))
}

function isRecentQuestion(value: unknown): value is RecentQuestion {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, [
      'id',
      'contractId',
      'versionId',
      'question',
      'answer',
      'createdAt',
    ])
  ) {
    return false
  }

  return (
    isUuid(value.id) &&
    isUuid(value.contractId) &&
    isUuid(value.versionId) &&
    typeof value.question === 'string' &&
    value.question.length >= 1 &&
    value.question.length <= 1_000 &&
    typeof value.answer === 'string' &&
    value.answer.length >= 1 &&
    value.answer.length <= 4_000 &&
    isIsoTimestamp(value.createdAt)
  )
}

function parseRecentQuestions(value: unknown): RecentQuestionHistory | null {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['data']) ||
    !isRecord(value.data) ||
    !hasExactKeys(value.data, ['questions', 'monthlyCount']) ||
    !Array.isArray(value.data.questions) ||
    value.data.questions.length > 5 ||
    !value.data.questions.every(isRecentQuestion) ||
    typeof value.data.monthlyCount !== 'number' ||
    !Number.isInteger(value.data.monthlyCount) ||
    value.data.monthlyCount < 0
  ) {
    return null
  }

  return {
    questions: value.data.questions,
    monthlyCount: value.data.monthlyCount,
  }
}

export async function getRecentQuestions(input: {
  accessToken: string
  signal?: AbortSignal
}): Promise<RecentQuestionHistory> {
  if (!apiBaseUrl) {
    throw new QuestionHistoryServiceError(
      'Lidhja me backend-in nuk është konfiguruar.',
      'configuration',
    )
  }

  let response: Response
  try {
    response = await fetch(`${apiBaseUrl}/api/questions/recent`, {
      method: 'GET',
      headers: { Authorization: `Bearer ${input.accessToken}` },
      signal: input.signal,
    })
  } catch (error) {
    if (input.signal?.aborted || (error instanceof DOMException && error.name === 'AbortError')) {
      throw new QuestionHistoryServiceError('Kërkesa u anulua.', 'aborted')
    }
    throw new QuestionHistoryServiceError(
      'Historiku i pyetjeve nuk është i disponueshëm.',
      'network',
      true,
    )
  }

  if (response.status === 401) {
    throw new QuestionHistoryServiceError('Sesioni juaj ka skaduar.', 'authentication')
  }
  if (!response.ok) {
    throw new QuestionHistoryServiceError(
      'Historiku i pyetjeve nuk mund të ngarkohet.',
      'server',
      response.status >= 500,
    )
  }

  let payload: unknown
  try {
    payload = await response.json()
  } catch {
    throw new QuestionHistoryServiceError('Përgjigjja nuk ishte valide.', 'response')
  }

  const questions = parseRecentQuestions(payload)
  if (!questions) {
    throw new QuestionHistoryServiceError('Përgjigjja nuk ishte valide.', 'response')
  }
  return questions
}
