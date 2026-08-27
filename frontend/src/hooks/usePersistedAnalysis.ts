import { useCallback, useEffect, useRef, useState } from 'react'

import { useAuth } from './useAuth'
import {
  ContractAnalysisServiceError,
  getContractAnalysis,
  getLatestContractAnalysis,
  isContractAnalysis,
} from '../services/contractAnalysisService'
import type { ContractAnalysis } from '../types/analysis'

export type PersistedAnalysisStatus =
  | 'idle'
  | 'loading'
  | 'success'
  | 'not_found'
  | 'error'

type UsePersistedAnalysisInput = {
  contractId?: string
  routerStateAnalysis?: unknown
  versionId?: string
}

type PersistedAnalysisState = {
  analysis: ContractAnalysis | null
  canRetry: boolean
  error: string | null
  requestKey: string | null
  status: PersistedAnalysisStatus
}

const initialState: PersistedAnalysisState = {
  analysis: null,
  canRetry: false,
  error: null,
  requestKey: null,
  status: 'idle',
}

export function usePersistedAnalysis({
  contractId,
  routerStateAnalysis,
  versionId,
}: UsePersistedAnalysisInput) {
  const { isLoading: isAuthLoading, session } = useAuth()
  const [state, setState] = useState<PersistedAnalysisState>(initialState)
  const [retryVersion, setRetryVersion] = useState(0)
  const activeControllerRef = useRef<AbortController | null>(null)
  const requestIdRef = useRef(0)
  const hasContractId = typeof contractId === 'string'
  const hasVersionId = typeof versionId === 'string'
  const hasDetailRoute = hasContractId && hasVersionId
  const requestKey = hasDetailRoute
    ? `detail:${contractId}:${versionId}`
    : hasContractId === hasVersionId
      ? 'latest'
      : 'invalid'
  const validRouterAnalysis =
    hasDetailRoute &&
    isContractAnalysis(routerStateAnalysis, contractId, versionId)
      ? routerStateAnalysis
      : null

  const retry = useCallback(() => {
    if (state.canRetry && state.status === 'error') {
      setRetryVersion((version) => version + 1)
    }
  }, [state.canRetry, state.status])

  useEffect(() => {
    requestIdRef.current += 1
    const requestId = requestIdRef.current
    activeControllerRef.current?.abort()
    activeControllerRef.current = null

    if (isAuthLoading) {
      setState(initialState)
      return
    }

    const accessToken = session?.access_token

    if (!accessToken) {
      setState(initialState)
      return
    }

    if (validRouterAnalysis) {
      setState({
        analysis: validRouterAnalysis,
        canRetry: false,
        error: null,
        requestKey,
        status: 'success',
      })
      return
    }

    if (hasContractId !== hasVersionId) {
      setState({
        analysis: null,
        canRetry: false,
        error: 'Adresa e analizës nuk është valide.',
        requestKey,
        status: 'error',
      })
      return
    }

    const controller = new AbortController()
    activeControllerRef.current = controller
    setState({
      analysis: null,
      canRetry: false,
      error: null,
      requestKey,
      status: 'loading',
    })

    const request = hasDetailRoute
      ? getContractAnalysis({
          accessToken,
          contractId,
          versionId,
          signal: controller.signal,
        })
      : getLatestContractAnalysis({
          accessToken,
          signal: controller.signal,
        })

    void request
      .then((analysis) => {
        if (requestId === requestIdRef.current && !controller.signal.aborted) {
          setState({
            analysis,
            canRetry: false,
            error: null,
            requestKey,
            status: 'success',
          })
        }
      })
      .catch((error: unknown) => {
        if (requestId !== requestIdRef.current || controller.signal.aborted) {
          return
        }

        const serviceError =
          error instanceof ContractAnalysisServiceError
            ? error
            : new ContractAnalysisServiceError(
                'Backend-i nuk është i disponueshëm për momentin.',
                'network',
                { canRetry: true },
              )

        if (serviceError.kind === 'aborted') {
          return
        }

        if (serviceError.kind === 'not_found') {
          setState({
            analysis: null,
            canRetry: false,
            error: null,
            requestKey,
            status: 'not_found',
          })
          return
        }

        setState({
          analysis: null,
          canRetry: serviceError.canRetry,
          error: serviceError.message,
          requestKey,
          status: 'error',
        })
      })
      .finally(() => {
        if (requestId === requestIdRef.current) {
          activeControllerRef.current = null
        }
      })

    return () => {
      controller.abort()

      if (activeControllerRef.current === controller) {
        activeControllerRef.current = null
      }
    }
  }, [
    contractId,
    hasContractId,
    hasDetailRoute,
    hasVersionId,
    isAuthLoading,
    retryVersion,
    requestKey,
    session?.access_token,
    validRouterAnalysis,
    versionId,
  ])

  const hasCurrentState = state.requestKey === requestKey
  const visibleAnalysis = validRouterAnalysis ??
    (hasCurrentState ? state.analysis : null)
  const visibleStatus = validRouterAnalysis
    ? 'success'
    : hasCurrentState
      ? state.status
      : 'loading'

  return {
    analysis: visibleAnalysis,
    canRetry: hasCurrentState ? state.canRetry : false,
    error: hasCurrentState ? state.error : null,
    isLoading: isAuthLoading || visibleStatus === 'loading',
    retry,
    status: visibleStatus,
  }
}
