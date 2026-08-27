import { useCallback, useEffect, useRef, useState } from 'react'

import {
  ContractAnalysisServiceError,
  requestContractAnalysis,
} from '../services/contractAnalysisService'
import type { ContractAnalysis } from '../types/analysis'

export type ContractAnalysisStatus =
  | 'idle'
  | 'loading'
  | 'success'
  | 'error'
  | 'already_running'

export type AnalyzeContractParameters = {
  accessToken: string
  contractId: string
  versionId: string
}

type AnalysisHookState = {
  analysis: ContractAnalysis | null
  error: string | null
  canRetry: boolean
  status: ContractAnalysisStatus
}

const initialState: AnalysisHookState = {
  analysis: null,
  error: null,
  canRetry: false,
  status: 'idle',
}

export function useContractAnalysis() {
  const [state, setState] = useState<AnalysisHookState>(initialState)
  const activeControllerRef = useRef<AbortController | null>(null)
  const lastInputRef = useRef<AnalyzeContractParameters | null>(null)
  const mountedRef = useRef(true)
  const requestIdRef = useRef(0)
  const requestInProgressRef = useRef(false)

  useEffect(() => {
    mountedRef.current = true

    return () => {
      mountedRef.current = false
      requestIdRef.current += 1
      requestInProgressRef.current = false
      activeControllerRef.current?.abort()
      activeControllerRef.current = null
    }
  }, [])

  const analyze = useCallback(async (input: AnalyzeContractParameters) => {
    if (requestInProgressRef.current) {
      return
    }

    requestInProgressRef.current = true
    lastInputRef.current = input
    const requestId = requestIdRef.current + 1
    requestIdRef.current = requestId
    const controller = new AbortController()
    activeControllerRef.current = controller
    setState({
      analysis: null,
      error: null,
      canRetry: false,
      status: 'loading',
    })

    try {
      const analysis = await requestContractAnalysis({
        ...input,
        signal: controller.signal,
      })

      if (
        mountedRef.current &&
        requestId === requestIdRef.current &&
        !controller.signal.aborted
      ) {
        setState({
          analysis,
          error: null,
          canRetry: false,
          status: 'success',
        })
      }
    } catch (error) {
      if (
        !mountedRef.current ||
        requestId !== requestIdRef.current ||
        controller.signal.aborted ||
        (error instanceof ContractAnalysisServiceError &&
          error.kind === 'aborted')
      ) {
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

      setState({
        analysis: null,
        error: serviceError.message,
        canRetry: serviceError.canRetry,
        status:
          serviceError.backendCode === 'ANALYSIS_ALREADY_RUNNING'
            ? 'already_running'
            : 'error',
      })
    } finally {
      if (requestId === requestIdRef.current) {
        requestInProgressRef.current = false
        activeControllerRef.current = null
      }
    }
  }, [])

  const retry = useCallback(async () => {
    if (
      requestInProgressRef.current ||
      !state.canRetry ||
      !lastInputRef.current
    ) {
      return
    }

    await analyze(lastInputRef.current)
  }, [analyze, state.canRetry])

  const reset = useCallback(() => {
    requestIdRef.current += 1
    requestInProgressRef.current = false
    activeControllerRef.current?.abort()
    activeControllerRef.current = null
    lastInputRef.current = null

    if (mountedRef.current) {
      setState(initialState)
    }
  }, [])

  return {
    analysis: state.analysis,
    status: state.status,
    error: state.error,
    analyze,
    retry,
    reset,
    isLoading: state.status === 'loading',
    canRetry: state.canRetry,
  }
}
