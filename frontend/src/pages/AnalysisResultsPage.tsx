import { useEffect, useState } from 'react'
import { useLocation, useNavigate, useParams } from 'react-router-dom'

import { AnalysisDisclaimer } from '../components/analysis/AnalysisDisclaimer'
import { AnalysisHeader } from '../components/analysis/AnalysisHeader'
import {
  AnalysisTabs,
  type AnalysisTabId,
} from '../components/analysis/AnalysisTabs'
import { ClauseExplorer } from '../components/analysis/ClauseExplorer'
import { RiskSummary } from '../components/analysis/RiskSummary'
import { Icon } from '../components/ui/Icon'
import { usePersistedAnalysis } from '../hooks/usePersistedAnalysis'
import { useAuth } from '../hooks/useAuth'
import {
  AnalysisPdfServiceError,
  downloadAnalysisPdf,
} from '../services/analysisPdfService'
import type { ContractAnalysisClause } from '../types/analysis'

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

export function AnalysisResultsPage() {
  const { session } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const { contractId, versionId } = useParams<{
    contractId: string
    versionId: string
  }>()
  const [activeTab, setActiveTab] = useState<AnalysisTabId>('summary')
  const [selectedClausePosition, setSelectedClausePosition] = useState<
    number | null
  >(null)
  const [isExporting, setIsExporting] = useState(false)
  const [exportError, setExportError] = useState<string | null>(null)
  const locationState = isRecord(location.state) ? location.state : null
  const candidateAnalysis = locationState?.analysis
  const selectedClauseHint = locationState?.selectedClausePosition
  const { analysis, canRetry, error, isLoading, retry, status } =
    usePersistedAnalysis({
      contractId,
      routerStateAnalysis: candidateAnalysis,
      versionId,
    })
  const activeContractId = analysis?.contractId ?? contractId
  const activeVersionId = analysis?.versionId ?? versionId
  const selectedClause =
    analysis?.clauses.find(
      (clause) => clause.position === selectedClausePosition,
    ) ?? null

  useEffect(() => {
    if (analysis && !contractId && !versionId) {
      navigate(`/analysis/${analysis.contractId}/${analysis.versionId}`, {
        replace: true,
        state: { analysis },
      })
    }
  }, [analysis, contractId, navigate, versionId])

  useEffect(() => {
    if (!analysis || analysis.clauses.length === 0) {
      setSelectedClausePosition(null)
      return
    }

    const firstPosition = Math.min(
      ...analysis.clauses.map((clause) => clause.position),
    )
    const validHint =
      typeof selectedClauseHint === 'number' &&
      Number.isInteger(selectedClauseHint) &&
      analysis.clauses.some(
        (clause) => clause.position === selectedClauseHint,
      )

    if (validHint) {
      setSelectedClausePosition(selectedClauseHint)
      setActiveTab('clauses')
      return
    }

    setSelectedClausePosition((currentPosition) =>
      analysis.clauses.some(
        (clause) => clause.position === currentPosition,
      )
        ? currentPosition
        : firstPosition,
    )
  }, [analysis, selectedClauseHint])

  const handleBackToProcessing = () => {
    if (activeContractId && activeVersionId) {
      navigate(`/processing/${activeContractId}/${activeVersionId}`)
      return
    }

    navigate('/processing')
  }

  const handleOpenRiskReport = () => {
    if (!analysis || !activeContractId || !activeVersionId) {
      return
    }

    navigate(`/risk/${activeContractId}/${activeVersionId}`, {
      state: { analysis },
    })
  }

  const handleOpenQuestions = () => {
    if (!analysis || !activeContractId || !activeVersionId) {
      return
    }

    navigate(`/questions/${activeContractId}/${activeVersionId}`, {
      state: { contractTitle: analysis.result.title },
    })
  }

  const handleExport = async () => {
    if (
      !analysis ||
      !activeContractId ||
      !activeVersionId ||
      !session?.access_token ||
      isExporting
    ) {
      return
    }

    setIsExporting(true)
    setExportError(null)
    try {
      const report = await downloadAnalysisPdf({
        accessToken: session.access_token,
        contractId: activeContractId,
        versionId: activeVersionId,
      })
      const url = URL.createObjectURL(report.blob)
      const link = document.createElement('a')
      link.href = url
      link.download = report.fileName
      link.click()
      URL.revokeObjectURL(url)
    } catch (error) {
      setExportError(
        error instanceof AnalysisPdfServiceError
          ? error.message
          : 'Raporti PDF nuk mund të gjenerohet për momentin.',
      )
    } finally {
      setIsExporting(false)
    }
  }

  const handleSelectClause = (clause: ContractAnalysisClause) => {
    setSelectedClausePosition(clause.position)
    setActiveTab('clauses')
  }

  if (!analysis) {
    const isEmpty = status === 'not_found'
    const stateTitle = isLoading
      ? 'Rezultati po ngarkohet…'
      : isEmpty
        ? 'Nuk ka ende analizë të përfunduar.'
        : 'Rezultati nuk mund të ngarkohet'
    const stateDescription = isLoading
      ? 'Ju lutemi prisni derisa të merret analiza e ruajtur.'
      : isEmpty
        ? 'Pasi të përfundojë një analizë, rezultati do të shfaqet këtu.'
        : error ?? 'Backend-i nuk është i disponueshëm për momentin.'

    return (
      <div className="analysis-page">
        <section className="analysis-state-card">
          <div className="analysis-state-card__icon">
            <Icon name="file" size={24} />
          </div>
          <h2>{stateTitle}</h2>
          <p>{stateDescription}</p>
          {!isLoading && (
            <div>
              {canRetry && (
                <button type="button" onClick={retry}>
                  Provo përsëri
                </button>
              )}
              <button type="button" onClick={handleBackToProcessing}>
                Kthehu te përpunimi
              </button>
              <button
                className="secondary"
                type="button"
                onClick={() => navigate('/history')}
              >
                Shko te historiku
              </button>
            </div>
          )}
        </section>
      </div>
    )
  }

  return (
    <div className="analysis-page analysis-results-workspace">
      <AnalysisHeader
        analysis={analysis}
        exportError={exportError}
        isExporting={isExporting}
        onExport={() => void handleExport()}
        onOpenQuestions={handleOpenQuestions}
        onOpenRiskReport={handleOpenRiskReport}
      />

      <div className="analysis-workspace-grid">
        <ClauseExplorer
          clauses={analysis.clauses}
          selectedPosition={selectedClausePosition}
          onSelect={handleSelectClause}
        />

        <aside className="analysis-workspace-sidebar">
          <RiskSummary analysis={analysis} />
          <AnalysisTabs
            analysis={analysis}
            activeTab={activeTab}
            selectedClause={selectedClause}
            onTabChange={setActiveTab}
          />
          <AnalysisDisclaimer disclaimer={analysis.result.disclaimer} />
        </aside>
      </div>
    </div>
  )
}
