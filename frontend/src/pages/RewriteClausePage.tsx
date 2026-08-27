import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { useLocation, useParams } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useAuth } from '../hooks/useAuth'
import { usePersistedAnalysis } from '../hooks/usePersistedAnalysis'
import {
  ClauseRewriteServiceError,
  rewriteClause,
  type ClauseRewriteGoal,
  type ClauseRewriteResult,
} from '../services/clauseRewriteService'

const goals: Array<{ code: ClauseRewriteGoal; label: string }> = [
  { code: 'balanced_termination', label: 'Ndërprerje e balancuar' },
  { code: 'softer_penalty', label: 'Penalitet më i butë' },
  { code: 'clearer_payment', label: 'Pagesë më e qartë' },
  { code: 'stronger_confidentiality', label: 'Konfidencialitet më i fortë' },
  { code: 'clearer_delivery', label: 'Dorëzim më i qartë' },
]

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

export function RewriteClausePage() {
  const { session } = useAuth()
  const { contractId, versionId } = useParams<{
    contractId: string
    versionId: string
  }>()
  const location = useLocation()
  const routeState = isRecord(location.state) ? location.state : null
  const {
    analysis,
    error: analysisError,
    isLoading: isAnalysisLoading,
    status,
  } = usePersistedAnalysis({
    contractId,
    routerStateAnalysis: routeState?.analysis,
    versionId,
  })
  const rewriteableClauses = useMemo(
    () => analysis?.clauses.filter((clause) => clause.originalText !== null) ?? [],
    [analysis],
  )
  const requestedPosition =
    typeof routeState?.selectedClausePosition === 'number'
      ? routeState.selectedClausePosition
      : null
  const [selectedPosition, setSelectedPosition] = useState<number | null>(null)
  const [goal, setGoal] = useState<ClauseRewriteGoal>(goals[0].code)
  const [isPickerOpen, setIsPickerOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [canRetry, setCanRetry] = useState(false)
  const [result, setResult] = useState<ClauseRewriteResult | null>(null)
  const [isCopied, setIsCopied] = useState(false)
  const activeController = useRef<AbortController | null>(null)
  const requestSequence = useRef(0)

  const selectedClause =
    rewriteableClauses.find((clause) => clause.position === selectedPosition) ??
    null

  useEffect(() => {
    if (rewriteableClauses.length === 0) {
      setSelectedPosition(null)
      return
    }

    const requestedClause = rewriteableClauses.find(
      (clause) => clause.position === requestedPosition,
    )
    setSelectedPosition((current) =>
      rewriteableClauses.some((clause) => clause.position === current)
        ? current
        : requestedClause?.position ?? rewriteableClauses[0]?.position ?? null,
    )
  }, [requestedPosition, rewriteableClauses])

  const cancelRequest = useCallback(() => {
    requestSequence.current += 1
    activeController.current?.abort()
    activeController.current = null
    setIsLoading(false)
  }, [])

  useEffect(() => cancelRequest, [cancelRequest])
  useEffect(() => {
    if (!session) cancelRequest()
  }, [cancelRequest, session])

  const resetResult = () => {
    cancelRequest()
    setResult(null)
    setError(null)
    setCanRetry(false)
    setIsCopied(false)
  }

  const handleSelectClause = (position: number) => {
    resetResult()
    setSelectedPosition(position)
    setIsPickerOpen(false)
  }

  const handleGoalChange = (nextGoal: ClauseRewriteGoal) => {
    resetResult()
    setGoal(nextGoal)
  }

  const handleRewrite = useCallback(async () => {
    if (
      !session?.access_token ||
      !analysis ||
      !selectedClause ||
      isLoading
    ) {
      return
    }

    cancelRequest()
    const controller = new AbortController()
    const sequence = requestSequence.current
    activeController.current = controller
    setIsLoading(true)
    setError(null)
    setCanRetry(false)
    setResult(null)
    setIsCopied(false)

    try {
      const rewritten = await rewriteClause({
        accessToken: session.access_token,
        contractId: analysis.contractId,
        versionId: analysis.versionId,
        position: selectedClause.position,
        goal,
        signal: controller.signal,
      })

      if (
        requestSequence.current === sequence &&
        !controller.signal.aborted
      ) {
        setResult(rewritten)
      }
    } catch (caught: unknown) {
      if (
        requestSequence.current !== sequence ||
        controller.signal.aborted
      ) {
        return
      }

      const serviceError =
        caught instanceof ClauseRewriteServiceError
          ? caught
          : new ClauseRewriteServiceError(
              'Klauzola nuk mund të rishkruhej për momentin.',
              'network',
              true,
            )

      if (serviceError.kind !== 'aborted') {
        setError(serviceError.message)
        setCanRetry(serviceError.canRetry)
      }
    } finally {
      if (requestSequence.current === sequence) {
        activeController.current = null
        setIsLoading(false)
      }
    }
  }, [analysis, cancelRequest, goal, isLoading, selectedClause, session])

  const handleCopy = async () => {
    if (!result) return
    await navigator.clipboard.writeText(result.rewrittenText)
    setIsCopied(true)
  }

  const pageError = analysisError ?? error

  return (
    <div className="rewrite-page">
      <div className="rewrite-heading">
        <h2>Rishkrim klauzole & kundër-ofertë</h2>
        <p>
          Zgjidhni një klauzolë nga analiza dhe një qëllim për të krijuar një
          formulim alternativ.
        </p>
      </div>

      <section className="rewrite-control">
        <div className="rewrite-selected">
          <div>
            <span>
              {selectedClause
                ? `KLAUZOLA ${selectedClause.position}`
                : 'ASNJË KLAUZOLË E ZGJEDHUR'}
            </span>
            <strong>
              {selectedClause?.title ?? 'Zgjidhni një klauzolë nga analiza'}
            </strong>
          </div>
          <button
            type="button"
            disabled={rewriteableClauses.length === 0 || isLoading}
            onClick={() => setIsPickerOpen((open) => !open)}
          >
            Ndrysho klauzolën
          </button>
        </div>

        {isPickerOpen && (
          <div className="rewrite-clause-picker" aria-label="Zgjidh klauzolën">
            {rewriteableClauses.map((clause) => (
              <button
                type="button"
                key={clause.position}
                className={
                  clause.position === selectedPosition ? 'active' : ''
                }
                onClick={() => handleSelectClause(clause.position)}
              >
                <span>Klauzola {clause.position}</span>
                <strong>{clause.title}</strong>
              </button>
            ))}
          </div>
        )}

        <div className="section-label">QËLLIMI I RISHKRIMIT</div>
        <div className="rewrite-goals">
          {goals.map((item) => (
            <button
              className={goal === item.code ? 'active' : ''}
              type="button"
              key={item.code}
              disabled={isLoading}
              onClick={() => handleGoalChange(item.code)}
            >
              {item.label}
            </button>
          ))}
        </div>

        <button
          className="rewrite-submit"
          type="button"
          disabled={!selectedClause || !analysis || isLoading}
          onClick={() => void handleRewrite()}
        >
          <Icon name="sparkle" size={15} />
          {isLoading ? 'Duke rishkruar…' : 'Gjenero rishkrimin'}
        </button>

        {pageError && (
          <div className="rewrite-error" role="alert">
            <span>{pageError}</span>
            {canRetry && (
              <button type="button" onClick={() => void handleRewrite()}>
                Provo përsëri
              </button>
            )}
          </div>
        )}
      </section>

      <div className="rewrite-comparison">
        <section>
          <header>
            <i />
            ORIGJINALI
          </header>
          <div className="rewrite-placeholder">
            {selectedClause?.originalText ??
              (isAnalysisLoading
                ? 'Analiza po ngarkohet…'
                : status === 'not_found'
                  ? 'Nuk ka analizë të përfunduar.'
                  : 'Teksti origjinal i klauzolës do të shfaqet këtu.')}
          </div>
        </section>

        <section className="proposed">
          <header>
            <div>
              <i />
              VERSIONI I ZGJEDHUR
            </div>
            <span>{result ? '1 version' : 'Pa rezultat'}</span>
          </header>
          <div className="rewrite-placeholder">
            {result?.rewrittenText ??
              'Versioni i rishkruar do të shfaqet vetëm pas një përgjigjeje reale nga AI.'}
            <button
              type="button"
              disabled={!result}
              onClick={() => void handleCopy()}
            >
              {isCopied ? 'U kopjua' : 'Kopjo klauzolën'}
            </button>
          </div>
        </section>
      </div>

      <div className="section-label versions-label">
        VERSIONET E SUGJERUARA
      </div>
      <section className="rewrite-versions-empty">
        <Icon name="sparkle" size={22} />
        <span>
          {result
            ? 'U gjenerua 1 version alternativ.'
            : 'Nuk ka versione të gjeneruara.'}
        </span>
      </section>

      <div className="rewrite-disclaimer">
        <Icon name="info" size={15} />
        <span>
          {result?.disclaimer ??
            'Sugjerimet janë për negocim, jo tekst përfundimtar ligjor.'}
        </span>
      </div>
    </div>
  )
}
