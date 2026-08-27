import type { ContractAnalysisClause } from '../../types/analysis'
import {
  favoredPartyLabels,
  findingTypeLabels,
  severityLabels,
} from '../analysis/analysisLabels'

type RiskClauseCardProps = {
  clause: ContractAnalysisClause
  onRewriteClause: (position: number) => void
  onViewClause: (position: number) => void
}

export function RiskClauseCard({
  clause,
  onRewriteClause,
  onViewClause,
}: RiskClauseCardProps) {
  return (
    <article className={`risk-finding-card risk-finding-card--${clause.severity}`}>
      <header>
        <div>
          <h3>{clause.title}</h3>
          <span>Klauzola {clause.position}</span>
        </div>
        <span className={`severity-pill severity-pill--${clause.severity}`}>
          {severityLabels[clause.severity]}
        </span>
      </header>

      <div className="risk-finding-card__meta">
        <span>{findingTypeLabels[clause.findingType]}</span>
        {clause.requiresProfessionalReview && (
          <span className="risk-professional-badge">Shqyrtim profesional</span>
        )}
      </div>

      {clause.originalText && (
        <section>
          <h4>Teksti origjinal</h4>
          <p>{clause.originalText}</p>
        </section>
      )}

      {clause.riskExplanation && (
        <section>
          <h4>Shpjegimi i rrezikut</h4>
          <p>{clause.riskExplanation}</p>
        </section>
      )}

      {clause.suggestedAction && (
        <div className="risk-recommended-action">
          <span aria-hidden="true">✓</span>
          <p>
            <strong>Veprim i rekomanduar:</strong> {clause.suggestedAction}
          </p>
        </div>
      )}

      {clause.suggestedRewrite && (
        <section className="risk-suggested-rewrite">
          <h4>Riformulimi i sugjeruar</h4>
          <p>{clause.suggestedRewrite}</p>
        </section>
      )}

      <p className="risk-favored-party">
        Pala e favorizuar: {favoredPartyLabels[clause.favoredParty]}
      </p>

      <footer>
        <button type="button" onClick={() => onViewClause(clause.position)}>
          Shiko klauzolën
        </button>
        <button
          className="risk-rewrite-button"
          type="button"
          disabled={!clause.originalText}
          onClick={() => onRewriteClause(clause.position)}
        >
          Rishkruaj më të sigurt
        </button>
      </footer>
    </article>
  )
}
