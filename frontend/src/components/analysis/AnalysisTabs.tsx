import type { KeyboardEvent } from 'react'

import type {
  ContractAnalysis,
  ContractAnalysisClause,
} from '../../types/analysis'
import {
  clauseTypeLabels,
  contractTypeLabels,
  favoredPartyLabels,
  findingTypeLabels,
  severityLabels,
} from './analysisLabels'
import { LegalSourcesSection } from './LegalSourcesSection'

export type AnalysisTabId =
  | 'summary'
  | 'risks'
  | 'clauses'
  | 'dates'
  | 'missing'

type AnalysisTabsProps = {
  analysis: ContractAnalysis
  activeTab: AnalysisTabId
  selectedClause: ContractAnalysisClause | null
  onTabChange: (tab: AnalysisTabId) => void
}

const tabs: Array<{ id: AnalysisTabId; label: string }> = [
  { id: 'summary', label: 'Përmbledhje' },
  { id: 'risks', label: 'Rreziqet' },
  { id: 'clauses', label: 'Klauzolat' },
  { id: 'dates', label: 'Afatet' },
  { id: 'missing', label: 'Të munguara' },
]

function EmptyState({ children }: { children: string }) {
  return <p className="analysis-tab-empty">{children}</p>
}

function TermsList({
  emptyMessage,
  terms,
}: {
  emptyMessage: string
  terms: ContractAnalysis['result']['paymentTerms']
}) {
  if (terms.length === 0) {
    return <EmptyState>{emptyMessage}</EmptyState>
  }

  return (
    <div className="analysis-tab-list">
      {terms.map((term, index) => (
        <article key={`${term.title}-${index}`}>
          <strong>{term.title}</strong>
          <p>{term.description}</p>
        </article>
      ))}
    </div>
  )
}

function SummaryPanel({ analysis }: { analysis: ContractAnalysis }) {
  return (
    <div className="analysis-summary-panel">
      <section>
        <h3>Përmbledhja</h3>
        <p>{analysis.result.summary}</p>
      </section>

      <dl className="analysis-summary-facts">
        <div>
          <dt>Lloji</dt>
          <dd>{contractTypeLabels[analysis.result.contractType]}</dd>
        </div>
        <div>
          <dt>Shqyrtim profesional</dt>
          <dd>
            {analysis.result.professionalReviewRecommended
              ? 'Rekomandohet'
              : 'Nuk është shënuar si i domosdoshëm'}
          </dd>
        </div>
      </dl>

      <section>
        <h3>Palët</h3>
        {analysis.result.parties.length === 0 ? (
          <EmptyState>Nuk u identifikuan palë.</EmptyState>
        ) : (
          <div className="analysis-tab-list analysis-tab-list--compact">
            {analysis.result.parties.map((party, index) => (
              <article key={`${party.role}-${index}`}>
                <strong>{party.role}</strong>
                {party.name && <span>{party.name}</span>}
                {party.description && <p>{party.description}</p>}
              </article>
            ))}
          </div>
        )}
      </section>

      <section>
        <h3>Kushtet e pagesës</h3>
        <TermsList
          terms={analysis.result.paymentTerms}
          emptyMessage="Nuk u identifikuan kushte pagese."
        />
      </section>

      <section>
        <h3>Kushtet e ndërprerjes</h3>
        <TermsList
          terms={analysis.result.terminationTerms}
          emptyMessage="Nuk u identifikuan kushte ndërprerjeje."
        />
      </section>
    </div>
  )
}

function RisksPanel({ analysis }: { analysis: ContractAnalysis }) {
  const riskClauses = analysis.clauses
    .filter((clause) =>
      ['critical', 'high', 'medium'].includes(clause.severity),
    )
    .sort((first, second) => first.position - second.position)

  if (riskClauses.length === 0) {
    return <EmptyState>Nuk u identifikuan rreziqe të këtij niveli.</EmptyState>
  }

  return (
    <div className="analysis-tab-list">
      {riskClauses.map((clause) => (
        <article
          className={`analysis-tab-risk analysis-tab-risk--${clause.severity}`}
          key={clause.position}
        >
          <header>
            <strong>
              {clause.position}. {clause.title}
            </strong>
            <span className={`severity-pill severity-pill--${clause.severity}`}>
              {severityLabels[clause.severity]}
            </span>
          </header>
          {clause.riskExplanation && <p>{clause.riskExplanation}</p>}
          {clause.suggestedAction && (
            <p>
              <b>Veprimi i sugjeruar:</b> {clause.suggestedAction}
            </p>
          )}
          <LegalSourcesSection clause={clause} />
          <footer>
            <span>
              Pala e favorizuar: {favoredPartyLabels[clause.favoredParty]}
            </span>
            {clause.requiresProfessionalReview && (
              <span>Shqyrtim profesional</span>
            )}
          </footer>
        </article>
      ))}
    </div>
  )
}

function SelectedClauseDetails({
  clause,
}: {
  clause: ContractAnalysisClause
}) {
  return (
    <article className="selected-clause-details">
      <header>
        <div>
          <span>Klauzola {clause.position}</span>
          <h3>{clause.title}</h3>
          <p>
            {clauseTypeLabels[clause.clauseType]} ·{' '}
            {findingTypeLabels[clause.findingType]}
          </p>
        </div>
        <span className={`severity-pill severity-pill--${clause.severity}`}>
          {severityLabels[clause.severity]}
        </span>
      </header>

      <section>
        <h4>Teksti origjinal</h4>
        <p>
          {clause.originalText ??
            'Kjo klauzolë ose ky informacion mungon në dokument.'}
        </p>
      </section>

      {clause.simplifiedText && (
        <section>
          <h4>Shpjegimi i thjeshtuar</h4>
          <p>{clause.simplifiedText}</p>
        </section>
      )}

      {clause.suggestedRewrite && (
        <section>
          <h4>Riformulimi i sugjeruar</h4>
          <p>{clause.suggestedRewrite}</p>
        </section>
      )}

      <LegalSourcesSection clause={clause} />

      <footer>
        Besueshmëria e klasifikimit: {Math.round(clause.confidence * 100)}%
      </footer>
    </article>
  )
}

function ClausesPanel({
  analysis,
  selectedClause,
}: {
  analysis: ContractAnalysis
  selectedClause: ContractAnalysisClause | null
}) {
  if (analysis.clauses.length === 0) {
    return <EmptyState>Nuk u identifikuan klauzola.</EmptyState>
  }

  return (
    <div>
      {selectedClause && <SelectedClauseDetails clause={selectedClause} />}
      <div className="analysis-clause-index">
        <h3>Të gjitha klauzolat</h3>
        {analysis.clauses
          .slice()
          .sort((first, second) => first.position - second.position)
          .map((clause) => (
            <div key={clause.position}>
              <span>{clause.position}</span>
              <strong>{clause.title}</strong>
              <small>{severityLabels[clause.severity]}</small>
            </div>
          ))}
      </div>
    </div>
  )
}

function DatesPanel({ analysis }: { analysis: ContractAnalysis }) {
  const hasDates = analysis.result.keyDates.length > 0
  const hasTerminationTerms = analysis.result.terminationTerms.length > 0

  if (!hasDates && !hasTerminationTerms) {
    return <EmptyState>Nuk u identifikuan afate.</EmptyState>
  }

  return (
    <div className="analysis-summary-panel">
      {hasDates && (
        <section>
          <h3>Datat kryesore</h3>
          <div className="analysis-tab-list">
            {analysis.result.keyDates.map((keyDate, index) => (
              <article key={`${keyDate.label}-${index}`}>
                <strong>{keyDate.label}</strong>
                {keyDate.date && <span>{keyDate.date}</span>}
                {keyDate.description && <p>{keyDate.description}</p>}
              </article>
            ))}
          </div>
        </section>
      )}
      {hasTerminationTerms && (
        <section>
          <h3>Afatet e ndërprerjes</h3>
          <TermsList
            terms={analysis.result.terminationTerms}
            emptyMessage="Nuk u identifikuan afate ndërprerjeje."
          />
        </section>
      )}
    </div>
  )
}

function MissingPanel({ analysis }: { analysis: ContractAnalysis }) {
  const missingClauses = analysis.clauses
    .filter((clause) => clause.findingType === 'missing')
    .sort((first, second) => first.position - second.position)
  const hasMissingInformation = analysis.result.missingInformation.length > 0

  if (!hasMissingInformation && missingClauses.length === 0) {
    return <EmptyState>Nuk u raportua informacion i munguar.</EmptyState>
  }

  return (
    <div className="analysis-summary-panel">
      {hasMissingInformation && (
        <section>
          <h3>Informacioni i munguar</h3>
          <ul className="analysis-missing-list">
            {analysis.result.missingInformation.map((item, index) => (
              <li key={`${item}-${index}`}>{item}</li>
            ))}
          </ul>
        </section>
      )}
      {missingClauses.length > 0 && (
        <section>
          <h3>Klauzolat që mungojnë</h3>
          <div className="analysis-tab-list">
            {missingClauses.map((clause) => (
              <article key={clause.position}>
                <strong>{clause.title}</strong>
                {clause.riskExplanation && <p>{clause.riskExplanation}</p>}
                {clause.suggestedAction && <p>{clause.suggestedAction}</p>}
                <LegalSourcesSection clause={clause} />
              </article>
            ))}
          </div>
        </section>
      )}
    </div>
  )
}

export function AnalysisTabs({
  activeTab,
  analysis,
  onTabChange,
  selectedClause,
}: AnalysisTabsProps) {
  const handleTabKeyDown = (event: KeyboardEvent<HTMLButtonElement>) => {
    const currentIndex = tabs.findIndex((tab) => tab.id === activeTab)
    let targetIndex = currentIndex

    if (event.key === 'ArrowRight') {
      targetIndex = (currentIndex + 1) % tabs.length
    } else if (event.key === 'ArrowLeft') {
      targetIndex = (currentIndex - 1 + tabs.length) % tabs.length
    } else if (event.key === 'Home') {
      targetIndex = 0
    } else if (event.key === 'End') {
      targetIndex = tabs.length - 1
    } else {
      return
    }

    event.preventDefault()
    onTabChange(tabs[targetIndex].id)
    const tabButtons = event.currentTarget.parentElement?.querySelectorAll(
      'button[role="tab"]',
    )
    ;(tabButtons?.[targetIndex] as HTMLButtonElement | undefined)?.focus()
  }

  return (
    <section className="analysis-tabs-card">
      <div className="analysis-tabs" role="tablist" aria-label="Detajet e analizës">
        {tabs.map((tab) => (
          <button
            id={`analysis-tab-${tab.id}`}
            type="button"
            role="tab"
            key={tab.id}
            aria-controls="analysis-tab-panel"
            aria-selected={activeTab === tab.id}
            tabIndex={activeTab === tab.id ? 0 : -1}
            onClick={() => onTabChange(tab.id)}
            onKeyDown={handleTabKeyDown}
          >
            {tab.label}
          </button>
        ))}
      </div>

      <div
        id="analysis-tab-panel"
        className="analysis-tab-panel"
        role="tabpanel"
        aria-labelledby={`analysis-tab-${activeTab}`}
        tabIndex={0}
      >
        {activeTab === 'summary' && <SummaryPanel analysis={analysis} />}
        {activeTab === 'risks' && <RisksPanel analysis={analysis} />}
        {activeTab === 'clauses' && (
          <ClausesPanel analysis={analysis} selectedClause={selectedClause} />
        )}
        {activeTab === 'dates' && <DatesPanel analysis={analysis} />}
        {activeTab === 'missing' && <MissingPanel analysis={analysis} />}
      </div>
    </section>
  )
}
