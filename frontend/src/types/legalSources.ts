import type { ContractType } from './database'

export type LegalSource = {
  id: string
  title: string
  lawNumber: '03/L-212' | '04/L-077' | '08/L-142'
  versionLabel: string
  publicationDate: string | null
  documentType: 'law' | 'amendment'
  applicability: ContractType[]
  legalStatus:
    | 'requires_manual_legal_verification'
    | 'verified_current'
    | 'superseded'
    | 'repealed'
  officialUrl: string
  officialDocumentUrl: string | null
  chunkCount: number
}
