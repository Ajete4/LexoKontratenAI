import { useCallback, useEffect, useRef, useState } from 'react'

import { useAuth } from './useAuth'
import {
  DashboardServiceError,
  getDashboard,
} from '../services/dashboardService'
import type { Dashboard } from '../types/dashboard'

export type DashboardStatus = 'idle' | 'loading' | 'success' | 'error'

type DashboardState = {
  canRetry: boolean
  dashboard: Dashboard | null
  error: string | null
  status: DashboardStatus
}

const initialState: DashboardState = {
  canRetry: false,
  dashboard: null,
  error: null,
  status: 'idle',
}

export function useDashboard() {
  const { isLoading: isAuthLoading, session } = useAuth()
  const [state, setState] = useState<DashboardState>(initialState)
  const [retryVersion, setRetryVersion] = useState(0)
  const activeControllerRef = useRef<AbortController | null>(null)
  const requestIdRef = useRef(0)

  const retry = useCallback(() => {
    if (state.status === 'error') {
      setRetryVersion((version) => version + 1)
    }
  }, [state.status])

  useEffect(() => {
    const requestId = ++requestIdRef.current
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

    const controller = new AbortController()
    activeControllerRef.current = controller
    setState({
      canRetry: false,
      dashboard: null,
      error: null,
      status: 'loading',
    })

    void getDashboard({ accessToken, signal: controller.signal })
      .then((dashboard) => {
        if (requestId === requestIdRef.current && !controller.signal.aborted) {
          setState({
            canRetry: false,
            dashboard,
            error: null,
            status: 'success',
          })
        }
      })
      .catch((error: unknown) => {
        if (requestId !== requestIdRef.current || controller.signal.aborted) {
          return
        }

        const serviceError =
          error instanceof DashboardServiceError
            ? error
            : new DashboardServiceError(
                'Backend-i nuk është i disponueshëm për momentin.',
                'network',
                { canRetry: true },
              )

        if (serviceError.kind === 'aborted') {
          return
        }

        setState({
          canRetry: serviceError.canRetry,
          dashboard: null,
          error: serviceError.message,
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
  }, [isAuthLoading, retryVersion, session?.access_token])

  return {
    ...state,
    isLoading: isAuthLoading || state.status === 'loading',
    retry,
  }
}
