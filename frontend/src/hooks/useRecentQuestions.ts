import { useCallback, useEffect, useRef, useState } from 'react'

import { useAuth } from './useAuth'
import {
  getRecentQuestions,
  QuestionHistoryServiceError,
  type RecentQuestion,
} from '../services/questionHistoryService'

export function useRecentQuestions() {
  const { isLoading: isAuthLoading, session } = useAuth()
  const [questions, setQuestions] = useState<RecentQuestion[]>([])
  const [monthlyCount, setMonthlyCount] = useState(0)
  const [error, setError] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [retryVersion, setRetryVersion] = useState(0)
  const requestIdRef = useRef(0)

  const retry = useCallback(() => setRetryVersion((value) => value + 1), [])

  useEffect(() => {
    const requestId = ++requestIdRef.current
    const accessToken = session?.access_token

    if (isAuthLoading || !accessToken) {
      setQuestions([])
      setMonthlyCount(0)
      setError(null)
      setIsLoading(false)
      return
    }

    const controller = new AbortController()
    setIsLoading(true)
    setError(null)

    void getRecentQuestions({ accessToken, signal: controller.signal })
      .then((result) => {
        if (requestId === requestIdRef.current && !controller.signal.aborted) {
          setQuestions(result.questions)
          setMonthlyCount(result.monthlyCount)
        }
      })
      .catch((caught: unknown) => {
        if (requestId !== requestIdRef.current || controller.signal.aborted) return
        const serviceError = caught instanceof QuestionHistoryServiceError
          ? caught
          : new QuestionHistoryServiceError('Historiku nuk mund të ngarkohet.', 'network', true)
        if (serviceError.kind !== 'aborted') setError(serviceError.message)
      })
      .finally(() => {
        if (requestId === requestIdRef.current) setIsLoading(false)
      })

    return () => controller.abort()
  }, [isAuthLoading, retryVersion, session?.access_token])

  return { error, isLoading, monthlyCount, questions, retry }
}
