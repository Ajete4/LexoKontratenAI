const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export type ContractNotesChecklist = {
  contractId: string
  versionId: string
  notes: string
  checklist: boolean[]
  updatedAt: string
}

export class ContractNotesServiceError extends Error {
  readonly kind:
    | 'aborted'
    | 'authentication'
    | 'configuration'
    | 'network'
    | 'not_found'
    | 'response'
    | 'server'

  constructor(message: string, kind: ContractNotesServiceError['kind']) {
    super(message)
    this.name = 'ContractNotesServiceError'
    this.kind = kind
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
  return (
    keys.length === expectedKeys.length &&
    keys.every((key) => expectedKeys.includes(key))
  )
}

function isUuid(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/iu.test(
      value,
    )
  )
}

function isNotesChecklist(value: unknown): value is ContractNotesChecklist {
  return (
    isRecord(value) &&
    hasExactKeys(value, [
      'contractId',
      'versionId',
      'notes',
      'checklist',
      'updatedAt',
    ]) &&
    isUuid(value.contractId) &&
    isUuid(value.versionId) &&
    typeof value.notes === 'string' &&
    value.notes.length <= 10_000 &&
    Array.isArray(value.checklist) &&
    value.checklist.length === 6 &&
    value.checklist.every((item) => typeof item === 'boolean') &&
    typeof value.updatedAt === 'string' &&
    !Number.isNaN(Date.parse(value.updatedAt))
  )
}

function parseResponse(
  value: unknown,
  allowNull: boolean,
): ContractNotesChecklist | null {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['data']) ||
    !isRecord(value.data) ||
    !hasExactKeys(value.data, ['notesChecklist'])
  ) {
    throw new ContractNotesServiceError(
      'Përgjigjja e backend-it nuk ishte valide.',
      'response',
    )
  }

  if (allowNull && value.data.notesChecklist === null) {
    return null
  }

  if (!isNotesChecklist(value.data.notesChecklist)) {
    throw new ContractNotesServiceError(
      'Përgjigjja e backend-it nuk ishte valide.',
      'response',
    )
  }

  return value.data.notesChecklist
}

async function requestNotes(input: {
  accessToken: string
  body?: { notes: string; checklist: boolean[] }
  contractId: string
  method: 'GET' | 'PUT'
  signal?: AbortSignal
  versionId: string
}): Promise<ContractNotesChecklist | null> {
  if (!apiBaseUrl || !isUuid(input.contractId) || !isUuid(input.versionId)) {
    throw new ContractNotesServiceError(
      'Konteksti i kontratës nuk është valid.',
      apiBaseUrl ? 'not_found' : 'configuration',
    )
  }

  let response: Response

  try {
    response = await fetch(
      `${apiBaseUrl}/api/contracts/${encodeURIComponent(input.contractId)}/versions/${encodeURIComponent(input.versionId)}/notes-checklist`,
      {
        method: input.method,
        headers: {
          Authorization: `Bearer ${input.accessToken}`,
          ...(input.body ? { 'Content-Type': 'application/json' } : {}),
        },
        body: input.body ? JSON.stringify(input.body) : undefined,
        signal: input.signal,
      },
    )
  } catch (error) {
    if (
      input.signal?.aborted ||
      (error instanceof DOMException && error.name === 'AbortError')
    ) {
      throw new ContractNotesServiceError('Kërkesa u anulua.', 'aborted')
    }

    throw new ContractNotesServiceError(
      'Shënimet nuk janë të disponueshme për momentin.',
      'network',
    )
  }

  if (response.status === 401) {
    throw new ContractNotesServiceError('Sesioni juaj ka skaduar.', 'authentication')
  }

  if (response.status === 404) {
    throw new ContractNotesServiceError('Kontrata aktive nuk u gjet.', 'not_found')
  }

  if (!response.ok) {
    throw new ContractNotesServiceError(
      'Shënimet nuk mund të ruheshin për momentin.',
      'server',
    )
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractNotesServiceError(
      'Përgjigjja e backend-it nuk ishte valide.',
      'response',
    )
  }

  return parseResponse(payload, input.method === 'GET')
}

export function getContractNotes(input: {
  accessToken: string
  contractId: string
  signal?: AbortSignal
  versionId: string
}) {
  return requestNotes({ ...input, method: 'GET' })
}

export async function saveContractNotes(input: {
  accessToken: string
  checklist: boolean[]
  contractId: string
  notes: string
  signal?: AbortSignal
  versionId: string
}): Promise<ContractNotesChecklist> {
  const result = await requestNotes({
    accessToken: input.accessToken,
    body: { notes: input.notes, checklist: input.checklist },
    contractId: input.contractId,
    method: 'PUT',
    signal: input.signal,
    versionId: input.versionId,
  })

  if (!result) {
    throw new ContractNotesServiceError(
      'Përgjigjja e backend-it nuk ishte valide.',
      'response',
    )
  }

  return result
}
