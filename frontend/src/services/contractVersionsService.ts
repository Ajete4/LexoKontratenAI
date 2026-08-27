import type {
  AllowedUploadMimeType,
  ContractVersionUploadResult,
} from '../types/upload'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

const allowedMimeTypes: AllowedUploadMimeType[] = [
  'application/pdf',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'text/plain',
]

type ContractVersionApiResponse = {
  data: ContractVersionUploadResult
}

type BackendErrorResponse = {
  error: {
    code: string
  }
}

export class ContractVersionServiceError extends Error {
  readonly backendCode: string | null
  readonly statusCode: number | null

  readonly kind:
    | 'authentication'
    | 'configuration'
    | 'network'
    | 'response'
    | 'server'

  constructor(
    kind: ContractVersionServiceError['kind'],
    statusCode: number | null = null,
    backendCode: string | null = null,
  ) {
    super(kind)
    this.name = 'ContractVersionServiceError'
    this.kind = kind
    this.statusCode = statusCode
    this.backendCode = backendCode
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null
}

function isUuid(value: unknown): value is string {
  return (
    typeof value === 'string' &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(
      value,
    )
  )
}

function isBackendErrorResponse(value: unknown): value is BackendErrorResponse {
  return (
    isRecord(value) &&
    isRecord(value.error) &&
    typeof value.error.code === 'string'
  )
}

function isContractVersionApiResponse(
  value: unknown,
  expectedContractId: string,
): value is ContractVersionApiResponse {
  if (!isRecord(value) || !isRecord(value.data)) {
    return false
  }

  const { data } = value

  if (data.contractId !== expectedContractId || !isRecord(data.version)) {
    return false
  }

  const { version } = data

  return (
    isUuid(data.contractId) &&
    isUuid(version.id) &&
    Number.isInteger(version.versionNumber) &&
    Number(version.versionNumber) > 0 &&
    version.sourceKind === 'upload' &&
    typeof version.originalFilename === 'string' &&
    version.originalFilename.length > 0 &&
    allowedMimeTypes.includes(version.mimeType as AllowedUploadMimeType) &&
    typeof version.fileSizeBytes === 'number' &&
    version.fileSizeBytes > 0 &&
    typeof version.sha256 === 'string' &&
    /^[0-9a-f]{64}$/.test(version.sha256) &&
    version.extractionStatus === 'pending' &&
    typeof version.createdAt === 'string'
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

export async function uploadContractVersion(
  contractId: string,
  file: File,
  accessToken: string,
): Promise<ContractVersionUploadResult> {
  if (!apiBaseUrl) {
    throw new ContractVersionServiceError('configuration')
  }

  const formData = new FormData()
  formData.append('file', file)

  let response: Response

  try {
    response = await fetch(
      `${apiBaseUrl}/api/contracts/${encodeURIComponent(contractId)}/versions`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
        body: formData,
      },
    )
  } catch {
    throw new ContractVersionServiceError('network')
  }

  if (!response.ok) {
    const backendCode = await getSafeBackendCode(response)
    const kind = response.status === 401 ? 'authentication' : 'server'
    throw new ContractVersionServiceError(kind, response.status, backendCode)
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractVersionServiceError('response', response.status)
  }

  if (!isContractVersionApiResponse(payload, contractId)) {
    throw new ContractVersionServiceError('response', response.status)
  }

  return payload.data
}
