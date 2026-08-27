import { useCallback, useEffect, useRef, useState } from 'react'

import {
  getLegalSources,
  LegalSourcesServiceError,
} from '../services/legalSourcesService'
import type { LegalSource } from '../types/legalSources'
import { useAuth } from './useAuth'

function getSafeErrorMessage(error: unknown): string | null {
  if (!(error instanceof LegalSourcesServiceError)) {
    return 'Burimet ligjore nuk mund të ngarkoheshin.'
  }

  switch (error.kind) {
    case 'aborted':
      return null
    case 'authentication':
      return 'Sesioni nuk është më i vlefshëm. Ju lutemi hyni përsëri.'
    case 'configuration':
      return 'Lidhja me backend-in nuk është konfiguruar.'
    case 'network':
      return 'Serveri nuk mund të arrihet. Provoni përsëri.'
    case 'response':
    case 'server':
      return 'Burimet ligjore nuk mund të ngarkoheshin. Provoni përsëri.'
  }
}

export function useLegalSources() {
  const { isLoading: isAuthLoading, session, user } = useAuth()
  const [legalSources, setLegalSources] = useState<LegalSource[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const activeControllerRef = useRef<AbortController | null>(null)
  const requestIdRef = useRef(0)

  const load = useCallback(async () => {
    const requestId = requestIdRef.current + 1
    requestIdRef.current = requestId
    activeControllerRef.current?.abort()

    if (isAuthLoading) {
      setIsLoading(true)
      return
    }

    if (!session?.access_token || !user) {
      setLegalSources([])
      setError(null)
      setIsLoading(false)
      return
    }

    const controller = new AbortController()
    activeControllerRef.current = controller
    setIsLoading(true)
    setError(null)

    try {
      const nextSources = await getLegalSources({
        accessToken: session.access_token,
        signal: controller.signal,
      })

      if (requestId === requestIdRef.current && !controller.signal.aborted) {
        setLegalSources(nextSources)
      }
    } catch (nextError) {
      if (requestId === requestIdRef.current && !controller.signal.aborted) {
        setLegalSources([])
        setError(getSafeErrorMessage(nextError))
      }
    } finally {
      if (requestId === requestIdRef.current) {
        activeControllerRef.current = null
        setIsLoading(false)
      }
    }
  }, [isAuthLoading, session, user])

  useEffect(() => {
    void load()

    return () => {
      requestIdRef.current += 1
      activeControllerRef.current?.abort()
      activeControllerRef.current = null
    }
  }, [load])

  return { error, isLoading, legalSources, retry: load }
}
