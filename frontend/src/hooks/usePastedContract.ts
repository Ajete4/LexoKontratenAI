import { useCallback, useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import {
  ContractsServiceError,
  createContractFromText,
} from '../services/contractsService'
import type { ContractType } from '../types/database'
import { useAuth } from './useAuth'

type SubmitPastedContractInput = {
  contractType: ContractType
  text: string
  title: string
}

function getPastedContractErrorMessage(error: unknown): string | null {
  if (!(error instanceof ContractsServiceError)) {
    return 'Ndodhi një gabim i papritur gjatë krijimit të kontratës.'
  }

  switch (error.kind) {
    case 'authentication':
      return 'Sesioni nuk është më i vlefshëm. Ju lutemi hyni përsëri.'
    case 'configuration':
      return 'Lidhja me backend-in nuk është konfiguruar.'
    case 'network':
      return 'Backend-i nuk mund të arrihet. Kontrolloni serverin dhe provoni përsëri.'
    case 'response':
      return 'Përgjigjja e backend-it nuk ishte valide.'
    case 'server':
      return error.statusCode === 400
        ? 'Titulli, lloji ose teksti i kontratës nuk është valid.'
        : 'Kontrata nuk mund të krijohej për momentin. Provoni përsëri.'
  }
}

export function usePastedContract() {
  const navigate = useNavigate()
  const { isLoading: isAuthLoading, session } = useAuth()
  const [error, setError] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const activeControllerRef = useRef<AbortController | null>(null)
  const requestIdRef = useRef(0)
  const submittingRef = useRef(false)

  useEffect(() => {
    return () => {
      requestIdRef.current += 1
      submittingRef.current = false
      activeControllerRef.current?.abort()
      activeControllerRef.current = null
    }
  }, [session?.user.id])

  const submit = useCallback(
    async ({ contractType, text, title }: SubmitPastedContractInput) => {
      if (submittingRef.current) {
        return
      }

      if (isAuthLoading || !session?.access_token) {
        setError('Duhet të jeni të kyçur për të krijuar kontratën.')
        return
      }

      submittingRef.current = true
      const requestId = requestIdRef.current + 1
      requestIdRef.current = requestId
      const controller = new AbortController()
      activeControllerRef.current = controller
      setError(null)
      setIsSubmitting(true)

      try {
        const result = await createContractFromText({
          accessToken: session.access_token,
          contractType,
          signal: controller.signal,
          text,
          title,
        })

        if (requestId !== requestIdRef.current || controller.signal.aborted) {
          return
        }

        navigate(
          `/processing/${encodeURIComponent(result.contractId)}/${encodeURIComponent(result.version.id)}?source=pasted`,
          {
            state: {
              extractionCompleted: true,
              sourceKind: 'pasted',
            },
          },
        )
      } catch (nextError) {
        if (requestId === requestIdRef.current && !controller.signal.aborted) {
          setError(getPastedContractErrorMessage(nextError))
        }
      } finally {
        if (requestId === requestIdRef.current) {
          submittingRef.current = false
          activeControllerRef.current = null
          setIsSubmitting(false)
        }
      }
    },
    [isAuthLoading, navigate, session],
  )

  return {
    error,
    isSubmitting,
    submit,
  }
}
