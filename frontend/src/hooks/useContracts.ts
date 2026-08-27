import { useCallback, useEffect, useRef, useState } from 'react'

import {
  ContractsServiceError,
  getContracts,
} from '../services/contractsService'
import type { ListedContract } from '../types/database'
import { useAuth } from './useAuth'

function getContractsErrorMessage(error: unknown): string {
  if (!(error instanceof ContractsServiceError)) {
    return 'Kontratat nuk mund të ngarkoheshin.'
  }

  switch (error.kind) {
    case 'authentication':
      return 'Sesioni nuk është më i vlefshëm. Ju lutemi hyni përsëri.'
    case 'configuration':
      return 'Lidhja me shërbimin nuk është konfiguruar.'
    case 'network':
      return 'Serveri nuk mund të arrihet. Kontrolloni lidhjen dhe provoni përsëri.'
    case 'response':
    case 'server':
      return 'Kontratat nuk mund të ngarkoheshin. Provoni përsëri.'
  }
}

export function useContracts() {
  const { isLoading: isAuthLoading, session, user } = useAuth()
  const [contracts, setContracts] = useState<ListedContract[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const requestIdRef = useRef(0)

  const loadContracts = useCallback(async () => {
    const requestId = ++requestIdRef.current

    if (isAuthLoading) {
      setIsLoading(true)
      return
    }

    if (!user || !session) {
      setContracts([])
      setError(null)
      setIsLoading(false)
      return
    }

    setIsLoading(true)
    setError(null)

    try {
      const nextContracts = await getContracts(session.access_token)

      if (requestId !== requestIdRef.current) {
        return
      }

      setContracts(nextContracts)
    } catch (nextError) {
      if (requestId !== requestIdRef.current) {
        return
      }

      setContracts([])
      setError(getContractsErrorMessage(nextError))
    } finally {
      if (requestId === requestIdRef.current) {
        setIsLoading(false)
      }
    }
  }, [isAuthLoading, session, user])

  useEffect(() => {
    void loadContracts()
  }, [loadContracts])

  return {
    contracts,
    isLoading,
    error,
    refresh: loadContracts,
  }
}
