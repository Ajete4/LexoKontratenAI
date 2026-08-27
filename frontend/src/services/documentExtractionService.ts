const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

export type ExtractionStatus =
  | 'pending'
  | 'extracting'
  | 'completed'
  | 'failed'
  | 'requires_ocr'
  | 'unsupported'

export type DocumentExtractionResult = {
  contractId: string
  versionId: string
  extractionStatus: ExtractionStatus
  pageCount: number | null
  updatedAt: string
}

type BackendErrorResponse = {
  error: {
    code: string
  }
}

type DocumentExtractionApiResponse = {
  data: DocumentExtractionResult
}

export class DocumentExtractionServiceError extends Error {
  readonly backendCode: string | null
  readonly statusCode: number | null

  readonly kind:
    | 'aborted'
    | 'authentication'
    | 'configuration'
    | 'network'
    | 'response'
    | 'server'

  constructor(
    kind: DocumentExtractionServiceError['kind'],
    statusCode: number | null = null,
    backendCode: string | null = null,
  ) {
    super(kind)
    this.name = 'DocumentExtractionServiceError'
    this.kind = kind
    this.statusCode = statusCode
    this.backendCode = backendCode
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null
}

export function isExtractionUuid(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      value,
    )
  )
}

function isExtractionStatus(value: unknown): value is ExtractionStatus {
  return (
    value === 'pending' ||
    value === 'extracting' ||
    value === 'completed' ||
    value === 'failed' ||
    value === 'requires_ocr' ||
    value === 'unsupported'
  )
}

function isExtractionPageCount(value: unknown): value is number | null {
  return (
    value === null ||
    (typeof value === 'number' &&
      Number.isInteger(value) &&
      value >= 1 &&
      value <= 200)
  )
}

function isBackendErrorResponse(value: unknown): value is BackendErrorResponse {
  return (
    isRecord(value) &&
    isRecord(value.error) &&
    typeof value.error.code === 'string'
  )
}

function isDocumentExtractionApiResponse(
  value: unknown,
  expectedContractId: string,
  expectedVersionId: string,
): value is DocumentExtractionApiResponse {
  if (!isRecord(value) || !isRecord(value.data)) {
    return false
  }

  const { data } = value

  return (
    data.contractId === expectedContractId &&
    data.versionId === expectedVersionId &&
    isExtractionUuid(data.contractId) &&
    isExtractionUuid(data.versionId) &&
    isExtractionStatus(data.extractionStatus) &&
    isExtractionPageCount(data.pageCount) &&
    typeof data.updatedAt === 'string' &&
    !Number.isNaN(Date.parse(data.updatedAt))
  )
}

async function getSafeBackendCode(response: Response): Promise<string | null> {
  try {
    const payload: unknown = await response.json()
    return isBackendErrorResponse(payload) ? payload.error.code : null
  } catch {
    return null
  }
}

type ExtractDocumentInput = {
  accessToken: string
  contractId: string
  signal?: AbortSignal
  versionId: string
}

export async function extractDocumentText({
  accessToken,
  contractId,
  signal,
  versionId,
}: ExtractDocumentInput): Promise<DocumentExtractionResult> {
  if (!apiBaseUrl) {
    throw new DocumentExtractionServiceError('configuration')
  }

  if (!isExtractionUuid(contractId) || !isExtractionUuid(versionId)) {
    throw new DocumentExtractionServiceError('response', 400)
  }

  let response: Response

  try {
    response = await fetch(
      `${apiBaseUrl}/api/contracts/${encodeURIComponent(contractId)}/versions/${encodeURIComponent(versionId)}/extract`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
        signal,
      },
    )
  } catch {
    if (signal?.aborted) {
      throw new DocumentExtractionServiceError('aborted')
    }

    throw new DocumentExtractionServiceError('network')
  }

  if (!response.ok) {
    const backendCode = await getSafeBackendCode(response)
    const kind = response.status === 401 ? 'authentication' : 'server'

    throw new DocumentExtractionServiceError(
      kind,
      response.status,
      backendCode,
    )
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new DocumentExtractionServiceError('response', response.status)
  }

  if (
    !isDocumentExtractionApiResponse(payload, contractId, versionId)
  ) {
    throw new DocumentExtractionServiceError('response', response.status)
  }

  return payload.data
}
