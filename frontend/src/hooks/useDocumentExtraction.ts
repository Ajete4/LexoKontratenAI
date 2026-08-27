import { useCallback, useEffect, useMemo, useRef, useState } from 'react'

import {
  DocumentExtractionServiceError,
  extractDocumentText,
  isExtractionUuid,
  type DocumentExtractionResult,
} from '../services/documentExtractionService'
import { useAuth } from './useAuth'

export type ProcessingPhase =
  | 'pending'
  | 'extracting'
  | 'completed'
  | 'failed'
  | 'requires_ocr'
  | 'unsupported'
  | 'invalid'

type ProcessingState = {
  canRetry: boolean
  message: string
  phase: ProcessingPhase
  result: DocumentExtractionResult | null
}

const initialState: ProcessingState = {
  canRetry: false,
  message: 'Dokumenti është në pritje për nxjerrjen e tekstit.',
  phase: 'pending',
  result: null,
}

const completedPastedState: ProcessingState = {
  canRetry: false,
  message:
    'Teksti u ruajt me sukses. Dokumenti është gati për fazën e analizës.',
  phase: 'completed',
  result: null,
}

function stateFromResult(result: DocumentExtractionResult): ProcessingState {
  switch (result.extractionStatus) {
    case 'pending':
      return {
        canRetry: false,
        message: 'Dokumenti është në pritje për nxjerrjen e tekstit.',
        phase: 'pending',
        result,
      }
    case 'extracting':
      return {
        canRetry: false,
        message: 'Duke nxjerrë tekstin nga dokumenti…',
        phase: 'extracting',
        result,
      }
    case 'completed':
      return {
        canRetry: false,
        message:
          'Teksti u nxor me sukses. Dokumenti është gati për fazën e analizës.',
        phase: 'completed',
        result,
      }
    case 'requires_ocr':
      return {
        canRetry: false,
        message:
          'PDF-ja duket se përmban faqe të skanuara dhe nuk ka tekst të mjaftueshëm për analizë. Njohja e tekstit me OCR do të shtohet në një fazë të ardhshme.',
        phase: 'requires_ocr',
        result,
      }
    case 'unsupported':
      return {
        canRetry: false,
        message:
          'Ky format nuk mbështetet ende për nxjerrjen e tekstit.',
        phase: 'unsupported',
        result,
      }
    case 'failed':
      return {
        canRetry: true,
        message: 'Nxjerrja e tekstit dështoi.',
        phase: 'failed',
        result,
      }
  }
}

function stateFromError(error: unknown): ProcessingState {
  if (!(error instanceof DocumentExtractionServiceError)) {
    return {
      canRetry: true,
      message: 'Nxjerrja e tekstit dështoi.',
      phase: 'failed',
      result: null,
    }
  }

  if (error.backendCode === 'EXTRACTION_ALREADY_RUNNING') {
    return {
      canRetry: true,
      message:
        'Nxjerrja e tekstit është ende aktive. Mund ta kontrolloni përsëri pas pak.',
      phase: 'extracting',
      result: null,
    }
  }

  if (error.backendCode === 'EXTRACTION_REQUIRES_OCR') {
    return {
      canRetry: false,
      message: 'Dokumenti nuk përmban tekst të lexueshëm dhe kërkon OCR.',
      phase: 'requires_ocr',
      result: null,
    }
  }

  if (
    error.backendCode === 'UNSUPPORTED_DOCUMENT_TYPE' ||
    error.statusCode === 415
  ) {
    return {
      canRetry: false,
      message: 'Ky format nuk mbështetet ende për nxjerrjen e tekstit.',
      phase: 'unsupported',
      result: null,
    }
  }

  if (error.kind === 'configuration') {
    return {
      canRetry: false,
      message: 'Lidhja me backend-in nuk është konfiguruar.',
      phase: 'failed',
      result: null,
    }
  }

  if (error.kind === 'authentication' || error.statusCode === 401) {
    return {
      canRetry: false,
      message: 'Sesioni nuk është më i vlefshëm. Ju lutemi hyni përsëri.',
      phase: 'failed',
      result: null,
    }
  }

  if (error.statusCode === 404) {
    return {
      canRetry: false,
      message: 'Versioni i dokumentit nuk u gjet.',
      phase: 'failed',
      result: null,
    }
  }

  if (error.statusCode === 400) {
    return {
      canRetry: false,
      message: 'Kërkesa për nxjerrjen e tekstit nuk është valide.',
      phase: 'failed',
      result: null,
    }
  }

  if (error.statusCode === 413) {
    return {
      canRetry: false,
      message: 'Dokumenti tejkalon kufirin e lejuar për përpunim.',
      phase: 'failed',
      result: null,
    }
  }

  if (error.statusCode === 422) {
    return {
      canRetry: false,
      message: 'Dokumenti nuk mund të përpunohet në formatin aktual.',
      phase: 'failed',
      result: null,
    }
  }

  if (
    error.kind === 'network' ||
    error.statusCode === 503 ||
    (error.statusCode !== null && error.statusCode >= 500)
  ) {
    return {
      canRetry: true,
      message:
        'Backend-i nuk është i disponueshëm për momentin. Provoni përsëri.',
      phase: 'failed',
      result: null,
    }
  }

  return {
    canRetry: false,
    message: 'Përgjigjja e backend-it nuk ishte valide.',
    phase: 'failed',
    result: null,
  }
}

export function useDocumentExtraction(
  contractId: string | undefined,
  versionId: string | undefined,
  extractionAlreadyCompleted = false,
) {
  const { isLoading: isAuthLoading, session } = useAuth()
  const [state, setState] = useState<ProcessingState>(initialState)
  const [isRequesting, setIsRequesting] = useState(false)
  const activeControllerRef = useRef<AbortController | null>(null)
  const autoStartedKeyRef = useRef<string | null>(null)
  const effectGenerationRef = useRef(0)
  const requestIdRef = useRef(0)
  const requestInProgressRef = useRef(false)

  const hasValidIds = useMemo(
    () => isExtractionUuid(contractId) && isExtractionUuid(versionId),
    [contractId, versionId],
  )

  const runExtraction = useCallback(async () => {
    if (
      requestInProgressRef.current ||
      isAuthLoading ||
      !session?.access_token ||
      !hasValidIds ||
      !contractId ||
      !versionId ||
      extractionAlreadyCompleted
    ) {
      return
    }

    requestInProgressRef.current = true
    const requestId = requestIdRef.current + 1
    requestIdRef.current = requestId
    const controller = new AbortController()
    activeControllerRef.current = controller
    setIsRequesting(true)
    setState({
      canRetry: false,
      message: 'Duke nxjerrë tekstin nga dokumenti…',
      phase: 'extracting',
      result: null,
    })

    try {
      const result = await extractDocumentText({
        accessToken: session.access_token,
        contractId,
        signal: controller.signal,
        versionId,
      })

      if (requestId === requestIdRef.current && !controller.signal.aborted) {
        setState(stateFromResult(result))
      }
    } catch (error) {
      if (
        requestId === requestIdRef.current &&
        !controller.signal.aborted &&
        !(
          error instanceof DocumentExtractionServiceError &&
          error.kind === 'aborted'
        )
      ) {
        setState(stateFromError(error))
      }
    } finally {
      if (requestId === requestIdRef.current) {
        requestInProgressRef.current = false
        activeControllerRef.current = null
        setIsRequesting(false)
      }
    }
  }, [
    contractId,
    extractionAlreadyCompleted,
    hasValidIds,
    isAuthLoading,
    session,
    versionId,
  ])

  useEffect(() => {
    const effectGeneration = effectGenerationRef.current + 1
    effectGenerationRef.current = effectGeneration

    if (extractionAlreadyCompleted && hasValidIds) {
      setState(completedPastedState)
      return
    }

    if (!contractId || !versionId || !hasValidIds) {
      setState({
        canRetry: false,
        message:
          'Nuk u gjet një dokument valid për nxjerrjen e tekstit.',
        phase: 'invalid',
        result: null,
      })
      return
    }

    if (isAuthLoading || !session?.access_token) {
      setState(initialState)
      return
    }

    const autoStartKey = `${contractId}:${versionId}:${session.user.id}`

    queueMicrotask(() => {
      if (
        effectGenerationRef.current !== effectGeneration ||
        autoStartedKeyRef.current === autoStartKey
      ) {
        return
      }

      autoStartedKeyRef.current = autoStartKey
      void runExtraction()
    })

    return () => {
      queueMicrotask(() => {
        if (effectGenerationRef.current !== effectGeneration) {
          return
        }

        requestIdRef.current += 1
        requestInProgressRef.current = false
        activeControllerRef.current?.abort()
        activeControllerRef.current = null
      })
    }
  }, [
    contractId,
    extractionAlreadyCompleted,
    hasValidIds,
    isAuthLoading,
    runExtraction,
    session,
    versionId,
  ])

  const retry = useCallback(() => {
    if (!state.canRetry || requestInProgressRef.current) {
      return
    }

    void runExtraction()
  }, [runExtraction, state.canRetry])

  return {
    canRetry: state.canRetry,
    isRequesting,
    message: state.message,
    pageCount: state.result?.pageCount ?? null,
    phase: state.phase,
    retry,
  }
}
