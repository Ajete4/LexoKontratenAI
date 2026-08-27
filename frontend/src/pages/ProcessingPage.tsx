import { useEffect, useRef } from 'react'
import {
  Link,
  useLocation,
  useNavigate,
  useParams,
  useSearchParams,
} from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useContractAnalysis } from '../hooks/useContractAnalysis'
import { useAuth } from '../hooks/useAuth'
import {
  useDocumentExtraction,
  type ProcessingPhase,
} from '../hooks/useDocumentExtraction'
import { isAnalysisUuid } from '../services/contractAnalysisService'

const statusLabels: Record<ProcessingPhase, string> = {
  pending: 'PENDING',
  extracting: 'EXTRACTING',
  completed: 'COMPLETED',
  failed: 'FAILED',
  requires_ocr: 'REQUIRES OCR',
  unsupported: 'UNSUPPORTED',
  invalid: '—',
}

const stateTitles: Record<ProcessingPhase, string> = {
  pending: 'Dokumenti është në pritje',
  extracting: 'Duke përpunuar dokumentin',
  completed: 'Nxjerrja përfundoi',
  failed: 'Nxjerrja dështoi',
  requires_ocr: 'Dokumenti kërkon OCR',
  unsupported: 'Formati nuk mbështetet',
  invalid: 'Nuk u gjet dokument valid',
}

export function ProcessingPage() {
  const location = useLocation()
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()
  const { contractId, versionId } = useParams<{
    contractId: string
    versionId: string
  }>()
  const { session } = useAuth()
  const processingState = location.state as
    | { extractionCompleted?: boolean; sourceKind?: string }
    | null
  const isCompletedPastedVersion =
    searchParams.get('source') === 'pasted' ||
    (processingState?.sourceKind === 'pasted' &&
      processingState.extractionCompleted === true)
  const { canRetry, isRequesting, message, pageCount, phase, retry } =
    useDocumentExtraction(contractId, versionId, isCompletedPastedVersion)
  const {
    analysis,
    status: analysisStatus,
    error: analysisError,
    analyze,
    retry: retryAnalysis,
    isLoading: isAnalysisLoading,
    canRetry: canRetryAnalysis,
  } = useContractAnalysis()
  const navigatedAnalysisIdRef = useRef<string | null>(null)
  const hasValidAnalysisRoute =
    isAnalysisUuid(contractId) && isAnalysisUuid(versionId)
  const canStartAnalysis =
    phase === 'completed' &&
    hasValidAnalysisRoute &&
    Boolean(session?.access_token)
  const showAnalysisButton =
    canStartAnalysis &&
    (analysisStatus === 'idle' || analysisStatus === 'loading')
  const showNavigation = phase === 'invalid'
  const pageCountMessage =
    pageCount === null
      ? null
      : phase === 'requires_ocr'
        ? `Dokumenti përmban ${pageCount} faqe.`
        : phase === 'completed'
          ? `U përpunuan ${pageCount} faqe.`
          : null

  const displayedTitle = isAnalysisLoading
    ? 'Analiza po kryhet'
    : stateTitles[phase]
  const displayedMessage = isAnalysisLoading
    ? 'Dokumenti po analizohet. Kjo mund të zgjasë disa sekonda.'
    : message

  useEffect(() => {
    if (
      analysisStatus !== 'success' ||
      !analysis ||
      !contractId ||
      !versionId ||
      navigatedAnalysisIdRef.current === analysis.analysisId
    ) {
      return
    }

    navigatedAnalysisIdRef.current = analysis.analysisId
    navigate(`/analysis/${contractId}/${versionId}`, {
      state: { analysis },
    })
  }, [analysis, analysisStatus, contractId, navigate, versionId])

  const handleAnalyze = () => {
    if (
      !canStartAnalysis ||
      isAnalysisLoading ||
      !contractId ||
      !versionId ||
      !session?.access_token
    ) {
      return
    }

    void analyze({
      accessToken: session.access_token,
      contractId,
      versionId,
    })
  }

  const handleAnalysisRetry = () => {
    void retryAnalysis()
  }

  return (
    <div className="processing-page">
      <div className="processing-heading">
        <div
          className={`processing-indicator processing-indicator--${phase}`}
        >
          <span />
        </div>
        <h2>{displayedTitle}</h2>
        <p>{displayedMessage}</p>
      </div>

      <section className="processing-card">
        <div className="processing-progress-label">
          <b>Statusi</b>
          <span>{statusLabels[phase]}</span>
        </div>

        <div
          className={`processing-pending-state processing-state--${phase}`}
          role="status"
        >
          <Icon
            name={phase === 'failed' || phase === 'invalid' ? 'alert' : 'fileCheck'}
            size={21}
          />
          <div>
            <strong>{stateTitles[phase]}</strong>
            <span>{message}</span>
            {pageCountMessage && <span>{pageCountMessage}</span>}
          </div>
        </div>

        {canRetry && (
          <div className="processing-actions">
            <button
              className="button button--primary"
              type="button"
              disabled={isRequesting}
              onClick={retry}
            >
              {phase === 'extracting' ? 'Kontrollo përsëri' : 'Provo përsëri'}
            </button>
          </div>
        )}

        {showAnalysisButton && (
          <div className="processing-analysis-action">
            <button
              className="button button--primary"
              type="button"
              disabled={isAnalysisLoading}
              onClick={handleAnalyze}
            >
              <Icon name="search" size={17} />
              {isAnalysisLoading ? 'Duke analizuar…' : 'Analizo kontratën'}
            </button>
          </div>
        )}

        {(analysisStatus === 'error' ||
          analysisStatus === 'already_running') && (
          <div className="processing-analysis-error" role="alert">
            <Icon name="alert" size={18} />
            <div>
              <strong>
                {analysisStatus === 'already_running'
                  ? 'Analiza është duke u përpunuar. Mund ta kontrolloni përsëri.'
                  : analysisError}
              </strong>
              {canRetryAnalysis && (
                <button type="button" onClick={handleAnalysisRetry}>
                  {analysisStatus === 'already_running'
                    ? 'Kontrollo përsëri'
                    : 'Provo përsëri'}
                </button>
              )}
            </div>
          </div>
        )}

        {showNavigation && (
          <div className="processing-actions">
            <Link className="button button--primary" to="/upload">
              Ngarko kontratën
            </Link>
            <Link className="button button--secondary" to="/history">
              Shiko historikun
            </Link>
          </div>
        )}
      </section>

      <section className="processing-card document-preview">
        <div>PARAPAMJE E DOKUMENTIT</div>
        <div className="document-placeholder">
          <Icon name="file" size={22} />
          <span>
            Përmbajtja e nxjerrë nuk shfaqet në këtë ekran.
          </span>
        </div>
      </section>
    </div>
  )
}
