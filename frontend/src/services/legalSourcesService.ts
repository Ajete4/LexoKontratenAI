import type { LegalSource } from '../types/legalSources'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')
const lawNumbers = ['03/L-212', '04/L-077', '08/L-142'] as const
const contractTypes = ['employment', 'service', 'lease'] as const
const legalStatuses = [
  'requires_manual_legal_verification',
  'verified_current',
  'superseded',
  'repealed',
] as const

type LegalSourcesApiResponse = {
  data: {
    legalSources: LegalSource[]
  }
}

export class LegalSourcesServiceError extends Error {
  readonly kind:
    | 'aborted'
    | 'authentication'
    | 'configuration'
    | 'network'
    | 'response'
    | 'server'

  constructor(kind: LegalSourcesServiceError['kind']) {
    super(kind)
    this.name = 'LegalSourcesServiceError'
    this.kind = kind
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null
}

function hasExactKeys(
  value: Record<string, unknown>,
  expectedKeys: readonly string[],
): boolean {
  const keys = Object.keys(value)

  return (
    keys.length === expectedKeys.length &&
    expectedKeys.every((key) => Object.hasOwn(value, key))
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

function isPublicationDate(value: unknown): value is string | null {
  return (
    value === null ||
    (typeof value === 'string' &&
      /^\d{4}-\d{2}-\d{2}$/u.test(value) &&
      !Number.isNaN(Date.parse(`${value}T00:00:00Z`)))
  )
}

function isLegalSource(value: unknown): value is LegalSource {
  if (!isRecord(value)) {
    return false
  }

  const applicability = value.applicability

  return (
    hasExactKeys(value, [
      'id',
      'title',
      'lawNumber',
      'versionLabel',
      'publicationDate',
      'documentType',
      'applicability',
      'legalStatus',
      'officialUrl',
      'officialDocumentUrl',
      'chunkCount',
    ]) &&
    isUuid(value.id) &&
    typeof value.title === 'string' &&
    value.title.trim().length > 0 &&
    lawNumbers.includes(value.lawNumber as (typeof lawNumbers)[number]) &&
    typeof value.versionLabel === 'string' &&
    value.versionLabel.trim().length > 0 &&
    isPublicationDate(value.publicationDate) &&
    (value.documentType === 'law' || value.documentType === 'amendment') &&
    Array.isArray(applicability) &&
    applicability.length <= 3 &&
    applicability.every((item) =>
      contractTypes.includes(item as (typeof contractTypes)[number]),
    ) &&
    new Set(applicability).size === applicability.length &&
    legalStatuses.includes(
      value.legalStatus as (typeof legalStatuses)[number],
    ) &&
    isHttpsUrl(value.officialUrl) &&
    (value.officialDocumentUrl === null ||
      isHttpsUrl(value.officialDocumentUrl)) &&
    Number.isInteger(value.chunkCount) &&
    Number(value.chunkCount) >= 0
  )
}

function isLegalSourcesApiResponse(
  value: unknown,
): value is LegalSourcesApiResponse {
  return (
    isRecord(value) &&
    hasExactKeys(value, ['data']) &&
    isRecord(value.data) &&
    hasExactKeys(value.data, ['legalSources']) &&
    Array.isArray(value.data.legalSources) &&
    value.data.legalSources.every(isLegalSource)
  )
}

export async function getLegalSources({
  accessToken,
  signal,
}: {
  accessToken: string
  signal: AbortSignal
}): Promise<LegalSource[]> {
  if (!apiBaseUrl) {
    throw new LegalSourcesServiceError('configuration')
  }

  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}/api/legal-sources`, {
      headers: { Authorization: `Bearer ${accessToken}` },
      signal,
    })
  } catch (error) {
    if (error instanceof DOMException && error.name === 'AbortError') {
      throw new LegalSourcesServiceError('aborted')
    }

    throw new LegalSourcesServiceError('network')
  }

  if (response.status === 401) {
    throw new LegalSourcesServiceError('authentication')
  }

  if (!response.ok) {
    throw new LegalSourcesServiceError('server')
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new LegalSourcesServiceError('response')
  }

  if (!isLegalSourcesApiResponse(payload)) {
    throw new LegalSourcesServiceError('response')
  }

  return payload.data.legalSources
}
