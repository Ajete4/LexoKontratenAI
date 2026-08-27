import type { ContractAnalysisClause } from '../../types/analysis'
import { severityLabels } from '../analysis/analysisLabels'

type MissingClauseSectionProps = {
  clauses: ContractAnalysisClause[]
  missingInformation: string[]
}

export function MissingClauseSection({
  clauses,
  missingInformation,
}: MissingClauseSectionProps) {
  if (clauses.length === 0 && missingInformation.length === 0) {
    return (
      <section className="risk-missing-section">
        <h2>Klauzola të munguara</h2>
        <div className="risk-report-empty">
          Nuk u identifikuan klauzola ose informacione të munguara.
        </div>
      </section>
    )
  }

  return (
    <section className="risk-missing-section">
      <h2>Klauzola të munguara</h2>
      <div className="risk-missing-list">
        {clauses.map((clause) => (
          <article key={clause.position}>
            <header>
              <div>
                <h3>{clause.title}</h3>
                <span>Klauzola {clause.position}</span>
              </div>
              <span className={`severity-pill severity-pill--${clause.severity}`}>
                {severityLabels[clause.severity]}
              </span>
            </header>
            {(clause.riskExplanation || clause.simplifiedText) && (
              <p>{clause.riskExplanation ?? clause.simplifiedText}</p>
            )}
            {clause.suggestedAction && (
              <p>
                <strong>Veprim i rekomanduar:</strong>{' '}
                {clause.suggestedAction}
              </p>
            )}
          </article>
        ))}

        {missingInformation.map((information, index) => (
          <article key={`${information}-${index}`}>
            <h3>Informacion i munguar</h3>
            <p>{information}</p>
          </article>
        ))}
      </div>
    </section>
  )
}
