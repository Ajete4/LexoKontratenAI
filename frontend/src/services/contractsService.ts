import type {
  Contract,
  ContractLatestCompletedAnalysis,
  ContractStatus,
  ContractType,
  ListedContract,
} from '../types/database'

const apiBaseUrl = import.meta.env.VITE_API_BASE_URL?.replace(/\/$/, '')

const contractTypes: ContractType[] = ['service', 'employment', 'lease']
const contractStatuses: ContractStatus[] = [
  'draft',
  'uploaded',
  'processing',
  'analyzed',
  'failed',
  'archived',
]

type ContractsApiResponse = {
  data: {
    contracts: ListedContract[]
  }
  meta: {
    limit: number
    count: number
  }
}

type CreateContractApiResponse = {
  data: {
    contract: Contract
  }
}

type CreateContractFromTextApiResponse = {
  data: {
    contractId: string
    version: {
      id: string
      versionNumber: 1
      sourceKind: 'pasted'
      extractionStatus: 'completed'
      pageCount: null
      createdAt: string
    }
  }
}

export type CreateContractInput = {
  accessToken: string
  contractType: ContractType
  title: string
}

export type CreateContractFromTextInput = {
  accessToken: string
  contractType: ContractType
  signal?: AbortSignal
  text: string
  title: string
}

export type CreatedContractFromText =
  CreateContractFromTextApiResponse['data']

export class ContractsServiceError extends Error {
  readonly statusCode: number | null

  readonly kind:
    | 'authentication'
    | 'configuration'
    | 'network'
    | 'response'
    | 'server'

  constructor(
    kind: ContractsServiceError['kind'],
    statusCode: number | null = null,
  ) {
    super(kind)
    this.name = 'ContractsServiceError'
    this.kind = kind
    this.statusCode = statusCode
  }
}

function isCreateContractApiResponse(
  value: unknown,
): value is CreateContractApiResponse {
  return (
    isRecord(value) &&
    isRecord(value.data) &&
    isContract(value.data.contract) &&
    isUuid(value.data.contract.id) &&
    value.data.contract.status === 'draft'
  )
}

function isCreateContractFromTextApiResponse(
  value: unknown,
): value is CreateContractFromTextApiResponse {
  if (
    !isRecord(value) ||
    !hasExactKeys(value, ['data']) ||
    !isRecord(value.data) ||
    !hasExactKeys(value.data, ['contractId', 'version']) ||
    !isUuid(value.data.contractId) ||
    !isRecord(value.data.version)
  ) {
    return false
  }

  const { version } = value.data

  return (
    hasExactKeys(version, [
      'id',
      'versionNumber',
      'sourceKind',
      'extractionStatus',
      'pageCount',
      'createdAt',
    ]) &&
    isUuid(version.id) &&
    version.versionNumber === 1 &&
    version.sourceKind === 'pasted' &&
    version.extractionStatus === 'completed' &&
    version.pageCount === null &&
    isIsoTimestamp(version.createdAt)
  )
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

function hasExactKeys(
  value: Record<string, unknown>,
  expectedKeys: readonly string[],
): boolean {
  const actualKeys = Object.keys(value)

  return (
    actualKeys.length === expectedKeys.length &&
    expectedKeys.every((key) => Object.hasOwn(value, key))
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

function isContract(value: unknown): value is Contract {
  if (!isRecord(value)) {
    return false
  }

  return (
    typeof value.id === 'string' &&
    typeof value.owner_id === 'string' &&
    typeof value.title === 'string' &&
    contractTypes.includes(value.contract_type as ContractType) &&
    contractStatuses.includes(value.status as ContractStatus) &&
    typeof value.created_at === 'string' &&
    typeof value.updated_at === 'string'
  )
}

function isLatestCompletedAnalysis(
  value: unknown,
): value is ContractLatestCompletedAnalysis {
  if (!isRecord(value)) {
    return false
  }

  return (
    hasExactKeys(value, [
      'id',
      'versionId',
      'overallRisk',
      'completedAt',
    ]) &&
    isUuid(value.id) &&
    isUuid(value.versionId) &&
    ['low', 'medium', 'high', 'critical', 'unknown'].includes(
      value.overallRisk as string,
    ) &&
    isIsoTimestamp(value.completedAt)
  )
}

function isListedContract(value: unknown): value is ListedContract {
  if (!isRecord(value)) {
    return false
  }

  const latestCompletedAnalysis = value.latestCompletedAnalysis

  return (
    hasExactKeys(value, [
      'id',
      'owner_id',
      'title',
      'contract_type',
      'status',
      'created_at',
      'updated_at',
      'latestCompletedAnalysis',
    ]) &&
    (latestCompletedAnalysis === null ||
      isLatestCompletedAnalysis(latestCompletedAnalysis)) &&
    isContract(value)
  )
}

function isContractsApiResponse(value: unknown): value is ContractsApiResponse {
  if (!isRecord(value) || !isRecord(value.data) || !isRecord(value.meta)) {
    return false
  }

  return (
    Array.isArray(value.data.contracts) &&
    value.data.contracts.every(isListedContract) &&
    typeof value.meta.limit === 'number' &&
    typeof value.meta.count === 'number'
  )
}

export async function getContracts(
  accessToken: string,
): Promise<ListedContract[]> {
  if (!apiBaseUrl) {
    throw new ContractsServiceError('configuration')
  }

  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}/api/contracts`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    })
  } catch {
    throw new ContractsServiceError('network')
  }

  if (response.status === 401) {
    throw new ContractsServiceError('authentication')
  }

  if (!response.ok) {
    throw new ContractsServiceError('server')
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractsServiceError('response')
  }

  if (!isContractsApiResponse(payload)) {
    throw new ContractsServiceError('response')
  }

  return payload.data.contracts
}

export async function createContract({
  accessToken,
  contractType,
  title,
}: CreateContractInput): Promise<Contract> {
  if (!apiBaseUrl) {
    throw new ContractsServiceError('configuration')
  }

  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}/api/contracts`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ title, contractType }),
    })
  } catch {
    throw new ContractsServiceError('network')
  }

  if (response.status === 401) {
    throw new ContractsServiceError('authentication', response.status)
  }

  if (!response.ok) {
    throw new ContractsServiceError('server', response.status)
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractsServiceError('response', response.status)
  }

  if (!isCreateContractApiResponse(payload)) {
    throw new ContractsServiceError('response', response.status)
  }

  if (payload.data.contract.contract_type !== contractType) {
    throw new ContractsServiceError('response', response.status)
  }

  return payload.data.contract
}

export async function createContractFromText({
  accessToken,
  contractType,
  signal,
  text,
  title,
}: CreateContractFromTextInput): Promise<CreatedContractFromText> {
  if (!apiBaseUrl) {
    throw new ContractsServiceError('configuration')
  }

  let response: Response

  try {
    response = await fetch(`${apiBaseUrl}/api/contracts/from-text`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ title, contractType, text }),
      signal,
    })
  } catch (error) {
    if (error instanceof DOMException && error.name === 'AbortError') {
      throw error
    }

    throw new ContractsServiceError('network')
  }

  if (response.status === 401) {
    throw new ContractsServiceError('authentication', response.status)
  }

  if (!response.ok) {
    throw new ContractsServiceError('server', response.status)
  }

  let payload: unknown

  try {
    payload = await response.json()
  } catch {
    throw new ContractsServiceError('response', response.status)
  }

  if (!isCreateContractFromTextApiResponse(payload)) {
    throw new ContractsServiceError('response', response.status)
  }

  return payload.data
}
