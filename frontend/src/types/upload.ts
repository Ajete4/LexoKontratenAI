export type AllowedUploadExtension = '.pdf' | '.docx' | '.txt'

export type AllowedUploadMimeType =
  | 'application/pdf'
  | 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  | 'text/plain'

export type UploadedContractVersion = {
  id: string
  versionNumber: number
  sourceKind: 'upload'
  originalFilename: string
  mimeType: AllowedUploadMimeType
  fileSizeBytes: number
  sha256: string
  extractionStatus: 'pending'
  createdAt: string
}

export type ContractVersionUploadResult = {
  contractId: string
  version: UploadedContractVersion
}
