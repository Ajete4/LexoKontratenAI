import { useNavigate } from 'react-router-dom'

import { Icon, type IconName } from '../components/ui/Icon'
import { useAuth } from '../hooks/useAuth'
import { useContracts } from '../hooks/useContracts'
import { useDashboard } from '../hooks/useDashboard'
import { useRecentQuestions } from '../hooks/useRecentQuestions'
import type { ClauseSeverity, OverallRiskLevel } from '../types/analysis'
import type { DashboardStats } from '../types/dashboard'
import type { ContractStatus, ContractType } from '../types/database'
import { formatDatabaseDate } from '../utils/dateFormat'
import { getDisplayName } from '../utils/userDisplay'

const contractTypeLabels: Record<ContractType, string> = {
  employment: 'Punësim',
  service: 'Shërbim',
  lease: 'Qira',
}

const contractStatusLabels: Record<ContractStatus, string> = {
  draft: 'Draft',
  uploaded: 'E ngarkuar',
  processing: 'Në përpunim',
  analyzed: 'E analizuar',
  failed: 'Dështoi',
  archived: 'Arkivuar',
}

const riskLabels: Record<OverallRiskLevel, string> = {
  low: 'I ulët',
  medium: 'Mesatar',
  high: 'I lartë',
  critical: 'Kritik',
  unknown: 'I panjohur',
}

const severityLabels: Record<ClauseSeverity, string> = {
  none: 'Informuese',
  low: 'I ulët',
  medium: 'Mesatar',
  high: 'I lartë',
  critical: 'Kritik',
  review_required: 'Shqyrtim',
}

type DashboardStatCard = {
  dot?: 'critical' | 'high'
  icon?: IconName
  label: string
  note: string
  tone: 'blue' | 'red' | 'orange' | 'violet'
  value: number | string
}

function createStatCards(
  stats: DashboardStats,
  monthlyQuestionCount: number | string,
): DashboardStatCard[] {
  return [
    {
      label: 'Kontrata të analizuara',
      value: stats.completedAnalyses,
      note:
        stats.completedAnalyses === 0
          ? 'Nuk ka ende analiza'
          : 'Analiza të përfunduara',
      icon: 'file',
      tone: 'blue',
    },
    {
      label: 'Rrezik kritik',
      value: stats.criticalClauses,
      note:
        stats.criticalClauses === 0
          ? 'Nuk ka gjetje kritike'
          : 'Klauzola kritike',
      dot: 'critical',
      tone: 'red',
    },
    {
      label: 'Rishikime në pritje',
      value: stats.professionalReviewClauses,
      note:
        stats.professionalReviewClauses === 0
          ? 'Asnjë klauzolë në pritje'
          : 'Klauzola për shqyrtim',
      dot: 'high',
      tone: 'orange',
    },
    {
      label: 'Pyetje për AI',
      value: monthlyQuestionCount,
      note: 'këtë muaj',
      icon: 'chat',
      tone: 'violet',
    },
  ]
}

function DashboardLoading() {
  return (
    <div className="dashboard-loading" aria-live="polite" aria-busy="true">
      <span className="sr-only">Paneli po ngarkohet.</span>
      <div className="stats-grid">
        {[1, 2, 3, 4].map((item) => (
          <article className="stat-card dashboard-skeleton-card" key={item}>
            <span />
            <strong />
            <small />
          </article>
        ))}
      </div>
      <div className="dashboard-columns">
        <div className="panel dashboard-skeleton-panel" />
        <div className="side-panels">
          <div className="panel dashboard-skeleton-panel dashboard-skeleton-panel--small" />
          <div className="panel dashboard-skeleton-panel dashboard-skeleton-panel--small" />
        </div>
      </div>
    </div>
  )
}

export function HomePage() {
  const navigate = useNavigate()
  const { profile, user } = useAuth()
  const { contracts } = useContracts()
  const { dashboard, error, isLoading, retry, status } = useDashboard()
  const recentQuestions = useRecentQuestions()
  const displayName = getDisplayName(profile, user)
  const firstName = displayName.split(/\s+/)[0]
  const statCards = dashboard
    ? createStatCards(
        dashboard.stats,
        recentQuestions.isLoading || recentQuestions.error
          ? '—'
          : recentQuestions.monthlyCount,
      )
    : []

  return (
    <div className="dashboard-page">
      <div className="dashboard-heading">
        <div>
          <h2>Mirë se erdhe, {firstName}</h2>
          <p>Menaxho kontratat dhe rezultatet e analizave të tua.</p>
        </div>
        <div className="dashboard-actions">
          <button
            className="button button--primary"
            type="button"
            onClick={() => navigate('/upload')}
          >
            <Icon name="upload" size={16} />
            Analizë e re
          </button>
          <button className="button button--secondary" type="button" disabled>
            <Icon name="file" size={16} />
            Gjenero kontratë
          </button>
        </div>
      </div>

      <div className="legal-reminder">
        <Icon name="info" size={17} />
        <div>
          <strong>Kujtesë:</strong> Ky sistem ofron ndihmë informative dhe nuk
          zëvendëson këshillën juridike profesionale.
        </div>
      </div>

      {isLoading && <DashboardLoading />}

      {!isLoading && status === 'error' && (
        <section className="dashboard-error" role="alert">
          <div>
            <Icon name="alert" size={21} />
          </div>
          <h3>Paneli nuk mund të ngarkohet.</h3>
          <p>{error ?? 'Backend-i nuk është i disponueshëm për momentin.'}</p>
          <button type="button" onClick={retry}>
            Provo përsëri
          </button>
        </section>
      )}

      {!isLoading && dashboard && (
        <>
          <div className="stats-grid">
            {statCards.map((stat) => (
              <article
                className={`stat-card stat-card--${stat.tone}`}
                key={stat.label}
              >
                <div className="stat-card__top">
                  <span>{stat.label}</span>
                  {stat.icon ? (
                    <Icon name={stat.icon} size={16} />
                  ) : (
                    <i
                      className={`status-dot status-dot--${stat.dot}`}
                      aria-hidden="true"
                    />
                  )}
                </div>
                <div className="stat-card__value">{stat.value}</div>
                <div className="stat-card__note">{stat.note}</div>
              </article>
            ))}
          </div>

          <div className="dashboard-columns">
            <section className="panel recent-panel">
              <div className="panel-heading">
                <h3>Kontratat e fundit</h3>
                <button type="button" onClick={() => navigate('/history')}>
                  Shiko të gjitha
                  <Icon name="chevronRight" size={14} />
                </button>
              </div>

              {dashboard.recentContracts.length === 0 ? (
                <div className="empty-state">
                  <div className="empty-state__icon">
                    <Icon name="file" size={20} />
                  </div>
                  <strong>Nuk ka kontrata</strong>
                  <span>Kontratat e ngarkuara do të shfaqen këtu.</span>
                  <button type="button" onClick={() => navigate('/upload')}>
                    Ngarko kontratën
                  </button>
                </div>
              ) : (
                <div className="dashboard-contract-list">
                  <div className="dashboard-contract-table-head" aria-hidden="true">
                    <span>Kontrata</span>
                    <span>Statusi</span>
                    <span>Rreziku</span>
                    <span>Shqyrtime</span>
                    <span>Veprime</span>
                  </div>
                  {dashboard.recentContracts.map((contract) => {
                    const latestAnalysis = contract.latestCompletedAnalysis
                    const displayStatus = latestAnalysis
                      ? 'analyzed'
                      : contract.status
                    return (
                      <div className="dashboard-contract-row" key={contract.id}>
                        <span className="dashboard-contract-identity">
                        <span
                          className={`dashboard-contract-icon dashboard-contract-icon--${contract.contractType}`}
                        >
                          <Icon name="file" size={15} />
                        </span>
                        <span className="dashboard-contract-main">
                          <strong title={contract.title}>{contract.title}</strong>
                          <small>
                            {contractTypeLabels[contract.contractType]} ·{' '}
                            {formatDatabaseDate(contract.createdAt)}
                          </small>
                        </span>
                        </span>
                        <span
                          className={`contract-status contract-status--${displayStatus}`}
                        >
                          {contractStatusLabels[displayStatus]}
                        </span>
                        <span
                          className={`dashboard-contract-risk${
                            latestAnalysis
                              ? ` dashboard-contract-risk--${latestAnalysis.overallRiskLevel}`
                              : ''
                          }`}
                        >
                          {latestAnalysis
                            ? riskLabels[latestAnalysis.overallRiskLevel]
                            : '—'}
                        </span>
                        <span className="dashboard-contract-review">
                          {latestAnalysis && latestAnalysis.professionalReviewClauseCount > 0 ? (
                            <span className="dashboard-review-badge">
                              {latestAnalysis.professionalReviewClauseCount} për
                              shqyrtim
                            </span>
                          ) : '—'}
                        </span>
                        <span className="dashboard-contract-actions">
                          {latestAnalysis && (
                            <>
                            <button
                              type="button"
                              onClick={() => navigate(`/analysis/${contract.id}/${latestAnalysis.versionId}`)}
                            >
                              Shiko analizën
                            </button>
                            <button
                              type="button"
                              onClick={() => navigate(`/questions/${contract.id}/${latestAnalysis.versionId}`, { state: { contractTitle: contract.title } })}
                            >
                              Pyet AI
                            </button>
                            </>
                          )}
                        </span>
                      </div>
                    )
                  })}
                </div>
              )}
            </section>

            <div className="side-panels">
              <section className="panel compact-panel">
                <h3>Rishikime në pritje</h3>
                {dashboard.recentReviews.length === 0 ? (
                  <div className="mini-empty">Nuk ka rishikime në pritje.</div>
                ) : (
                  <div className="dashboard-review-list">
                    {dashboard.recentReviews.map((review) => (
                      <button
                        className={`dashboard-review-item dashboard-review-item--${review.severity}`}
                        type="button"
                        key={`${review.analysisId}-${review.clausePosition}`}
                        onClick={() =>
                          navigate(
                            `/analysis/${review.contractId}/${review.versionId}`,
                            {
                              state: {
                                selectedClausePosition: review.clausePosition,
                              },
                            },
                          )
                        }
                      >
                        <span>
                          <strong>
                            {review.heading ?? 'Titulli nuk u identifikua'}
                          </strong>
                          <small>
                            {review.contractTitle} · Klauzola{' '}
                            {review.clausePosition}
                          </small>
                        </span>
                        <b className={`severity-pill severity-pill--${review.severity}`}>
                          {severityLabels[review.severity]}
                        </b>
                      </button>
                    ))}
                  </div>
                )}
              </section>

              <section className="panel compact-panel">
                <div className="panel-heading panel-heading--plain">
                  <h3>Pyetjet e fundit për AI</h3>
                </div>
                {recentQuestions.isLoading ? (
                  <div className="mini-empty" aria-live="polite">
                    Duke ngarkuar pyetjet…
                  </div>
                ) : recentQuestions.error ? (
                  <div className="dashboard-qa-callout" role="alert">
                    <p>{recentQuestions.error}</p>
                    <button type="button" onClick={recentQuestions.retry}>
                      Provo përsëri
                    </button>
                  </div>
                ) : recentQuestions.questions.length === 0 ? (
                  <div className="dashboard-qa-callout">
                    <p>Nuk ka ende pyetje të ruajtura për kontratat e analizuara.</p>
                    <button type="button" onClick={() => navigate('/history')}>
                      Zgjidh kontratën
                    </button>
                  </div>
                ) : (
                  <div className="dashboard-question-list">
                    {recentQuestions.questions.slice(0, 5).map((question) => {
                      const contractTitle = contracts.find(
                        (contract) => contract.id === question.contractId,
                      )?.title

                      return (
                        <button
                          type="button"
                          key={question.id}
                          onClick={() => navigate(
                            `/questions/${question.contractId}/${question.versionId}`,
                            { state: { contractTitle } },
                          )}
                        >
                          <strong>{question.question}</strong>
                          <span>
                            <small>{contractTitle ?? 'Kontrata'}</small>
                            <time dateTime={question.createdAt}>
                              {formatDatabaseDate(question.createdAt)}
                            </time>
                          </span>
                        </button>
                      )
                    })}
                  </div>
                )}
              </section>
            </div>
          </div>
        </>
      )}
    </div>
  )
}
