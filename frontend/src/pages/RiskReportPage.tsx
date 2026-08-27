import { useEffect } from 'react'
import { useLocation, useNavigate, useParams } from 'react-router-dom'

import { MissingClauseSection } from '../components/risk/MissingClauseSection'
import { RiskClauseCard } from '../components/risk/RiskClauseCard'
import { RiskCounters } from '../components/risk/RiskCounters'
import { RiskReportHeader } from '../components/risk/RiskReportHeader'
import { RiskReviewNotice } from '../components/risk/RiskReviewNotice'
import { Icon } from '../components/ui/Icon'
import { usePersistedAnalysis } from '../hooks/usePersistedAnalysis'
import type {
  ClauseSeverity,
  ContractAnalysisClause,
} from '../types/analysis'

const severityOrder: Record<ClauseSeverity, number> = {
  critical: 0,
  high: 1,
  medium: 2,
  low: 3,
  review_required: 4,
  none: 5,
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}

function isRiskClause(clause: ContractAnalysisClause) {
  if (clause.findingType === 'missing') {
    return false
  }

  return (
    clause.severity !== 'none' ||
    ['risky', 'ambiguous', 'imbalanced'].includes(clause.findingType) ||
    clause.requiresProfessionalReview
  )
}

function sortRiskClauses(
  first: ContractAnalysisClause,
  second: ContractAnalysisClause,
) {
  const severityDifference =
    severityOrder[first.severity] - severityOrder[second.severity]

  return severityDifference || first.position - second.position
}

export function RiskReportPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const { contractId, versionId } = useParams<{
    contractId: string
    versionId: string
  }>()
  const locationState = isRecord(location.state) ? location.state : null
  const candidateAnalysis = locationState?.analysis
  const { analysis, canRetry, error, isLoading, retry, status } =
    usePersistedAnalysis({
      contractId,
      routerStateAnalysis: candidateAnalysis,
      versionId,
    })
  const activeContractId = analysis?.contractId ?? contractId
  const activeVersionId = analysis?.versionId ?? versionId

  useEffect(() => {
    if (analysis && !contractId && !versionId) {
      navigate(`/risk/${analysis.contractId}/${analysis.versionId}`, {
        replace: true,
        state: { analysis },
      })
    }
  }, [analysis, contractId, navigate, versionId])

  const handleBackToResults = () => {
    if (!activeContractId || !activeVersionId) {
      navigate('/analysis')
      return
    }

    navigate(`/analysis/${activeContractId}/${activeVersionId}`, {
      state: analysis ? { analysis } : undefined,
    })
  }

  const handleViewClause = (position: number) => {
    if (!analysis || !activeContractId || !activeVersionId) {
      return
    }

    navigate(`/analysis/${activeContractId}/${activeVersionId}`, {
      state: { analysis, selectedClausePosition: position },
    })
  }

  const handleRewriteClause = (position: number) => {
    if (!analysis || !activeContractId || !activeVersionId) {
      return
    }

    navigate(`/rewrite/${activeContractId}/${activeVersionId}`, {
      state: { analysis, selectedClausePosition: position },
    })
  }

  if (!analysis) {
    const isEmpty = status === 'not_found'
    const stateTitle = isLoading
      ? 'Raporti po ngarkohet…'
      : isEmpty
        ? 'Nuk ka ende analizë të përfunduar.'
        : 'Raporti nuk mund të ngarkohet'
    const stateDescription = isLoading
      ? 'Ju lutemi prisni derisa të merret raporti i ruajtur.'
      : isEmpty
        ? 'Pasi të përfundojë një analizë, raporti do të shfaqet këtu.'
        : error ?? 'Backend-i nuk është i disponueshëm për momentin.'

    return (
      <div className="risk-page">
        <section className="risk-state-card">
          <div>
            <Icon name="alert" size={24} />
          </div>
          <h2>{stateTitle}</h2>
          <p>{stateDescription}</p>
          {!isLoading && (
            <nav>
              {canRetry && (
                <button type="button" onClick={retry}>
                  Provo përsëri
                </button>
              )}
              <button type="button" onClick={handleBackToResults}>
                Kthehu te rezultatet
              </button>
              <button
                className="secondary"
                type="button"
                onClick={() => navigate('/history')}
              >
                Shko te historiku
              </button>
            </nav>
          )}
        </section>
      </div>
    )
  }

  const riskClauses = analysis.clauses
    .filter(isRiskClause)
    .sort(sortRiskClauses)
  const missingClauses = analysis.clauses
    .filter((clause) => clause.findingType === 'missing')
    .sort((first, second) => first.position - second.position)

  return (
    <div className="risk-page risk-report-workspace">
      <RiskReportHeader
        analysis={analysis}
        findingCount={analysis.clauses.length}
        onBackToResults={handleBackToResults}
      />

      <RiskCounters clauses={analysis.clauses} />

      <section className="risk-findings-section">
        <h2>Klauzola me rrezik</h2>
        {riskClauses.length === 0 ? (
          <div className="risk-report-empty">
            Nuk u identifikuan klauzola me rrezik.
          </div>
        ) : (
          <div className="risk-findings-list">
            {riskClauses.map((clause) => (
                <RiskClauseCard
                  clause={clause}
                  key={clause.position}
                  onRewriteClause={handleRewriteClause}
                  onViewClause={handleViewClause}
                />
            ))}
          </div>
        )}
      </section>

      <MissingClauseSection
        clauses={missingClauses}
        missingInformation={analysis.result.missingInformation}
      />

      <RiskReviewNotice
        disclaimer={analysis.result.disclaimer}
        overallRiskExplanation={analysis.result.overallRiskExplanation}
        overallRiskLevel={analysis.result.overallRiskLevel}
        professionalReviewRecommended={
          analysis.result.professionalReviewRecommended
        }
      />
    </div>
  )
}
