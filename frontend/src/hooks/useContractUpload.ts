import { useCallback, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import {
  ContractsServiceError,
  createContract,
} from '../services/contractsService'
import {
  ContractVersionServiceError,
  uploadContractVersion,
} from '../services/contractVersionsService'
import type { ContractType } from '../types/database'
import { useAuth } from './useAuth'

type SubmitContractUploadInput = {
  contractType: ContractType
  file: File
  title: string
}

function getContractsServiceMessage(error: ContractsServiceError): string {
  if (error.kind === 'authentication') {
    return 'Sesioni nuk është më i vlefshëm. Ju lutemi hyni përsëri.'
  }

  if (error.kind === 'configuration') {
    return 'Lidhja me backend-in nuk është konfiguruar.'
  }

  if (error.kind === 'network') {
    return 'Backend-i nuk mund të arrihet. Kontrolloni serverin dhe provoni përsëri.'
  }

  if (error.statusCode === 400) {
    return 'Titulli ose lloji i kontratës nuk është valid.'
  }

  return 'Kontrata nuk mund të krijohej. Provoni përsëri.'
}

function getVersionServiceMessage(error: ContractVersionServiceError): string {
  if (error.kind === 'authentication') {
    return 'Sesioni nuk është më i vlefshëm. Ju lutemi hyni përsëri.'
  }

  if (error.kind === 'configuration') {
    return 'Lidhja me backend-in nuk është konfiguruar.'
  }

  if (error.kind === 'network') {
    return 'Ngarkimi nuk mund të lidhej me backend-in. Provoni përsëri.'
  }

  if (error.backendCode === 'CONTRACT_STATUS_UPDATE_FAILED') {
    return 'Dokumenti mund të jetë ruajtur, por statusi nuk u përditësua. Mos e përsërit ngarkimin pa e verifikuar.'
  }

  switch (error.statusCode) {
    case 400:
      return 'Skedari ose kërkesa e ngarkimit nuk është valide.'
    case 404:
      return 'Drafti i kontratës nuk u gjet. Fillo një tentativë të re.'
    case 409:
      return 'U zbulua një konflikt versioni. Provo përsëri me të njëjtin draft.'
    case 413:
      return 'Skedari tejkalon kufirin maksimal prej 20 MB.'
    case 415:
      return 'Skedari duhet të jetë PDF, DOCX ose TXT valid.'
    case 503:
      return 'Ngarkimi nuk është i disponueshëm për momentin. Provo përsëri.'
    default:
      return 'Skedari nuk mund të ngarkohej. Provoni përsëri.'
  }
}

function getUploadErrorMessage(error: unknown): string {
  if (error instanceof ContractsServiceError) {
    return getContractsServiceMessage(error)
  }

  if (error instanceof ContractVersionServiceError) {
    return getVersionServiceMessage(error)
  }

  return 'Ndodhi një gabim i papritur gjatë ngarkimit.'
}

export function useContractUpload() {
  const navigate = useNavigate()
  const { isLoading: isAuthLoading, session } = useAuth()
  const [draftContractId, setDraftContractId] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const submissionInProgressRef = useRef(false)

  const submit = useCallback(
    async ({ contractType, file, title }: SubmitContractUploadInput) => {
      if (submissionInProgressRef.current) {
        return
      }

      if (isAuthLoading || !session) {
        setError('Duhet të jeni të kyçur për të ngarkuar kontratën.')
        return
      }

      submissionInProgressRef.current = true
      setIsSubmitting(true)
      setError(null)

      try {
        let activeContractId = draftContractId

        if (!activeContractId) {
          const contract = await createContract({
            accessToken: session.access_token,
            contractType,
            title,
          })
          activeContractId = contract.id
          setDraftContractId(contract.id)
        }

        const result = await uploadContractVersion(
          activeContractId,
          file,
          session.access_token,
        )

        setError(null)
        navigate(
          `/processing/${encodeURIComponent(result.contractId)}/${encodeURIComponent(result.version.id)}`,
        )
      } catch (nextError) {
        setError(getUploadErrorMessage(nextError))
      } finally {
        submissionInProgressRef.current = false
        setIsSubmitting(false)
      }
    },
    [draftContractId, isAuthLoading, navigate, session],
  )

  const startNewAttempt = useCallback(() => {
    if (submissionInProgressRef.current) {
      return
    }

    setDraftContractId(null)
    setError(null)
  }, [])

  return {
    draftContractId,
    error,
    isSubmitting,
    startNewAttempt,
    submit,
  }
}
