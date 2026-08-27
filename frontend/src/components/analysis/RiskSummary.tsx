import type { ClauseSeverity, ContractAnalysis } from '../../types/analysis'
import { riskLabels } from './analysisLabels'

type RiskSummaryProps = {
  analysis: ContractAnalysis
}

type CounterDefinition = {
  label: string
  severity: ClauseSeverity | 'professional_review'
}

const counterDefinitions: CounterDefinition[] = [
  { label: 'Kritike', severity: 'critical' },
  { label: 'Të larta', severity: 'high' },
  { label: 'Mesatare', severity: 'medium' },
  { label: 'Të ulëta', severity: 'low' },
  { label: 'Shqyrtim profesional', severity: 'professional_review' },
]

export function RiskSummary({ analysis }: RiskSummaryProps) {
  const riskLevel = analysis.result.overallRiskLevel

  const counters = counterDefinitions.map(({ label, severity }) => ({
    label,
    severity,
    value: analysis.clauses.filter((clause) =>
      severity === 'professional_review'
        ? clause.requiresProfessionalReview ||
          clause.severity === 'review_required'
        : clause.severity === severity,
    ).length,
  }))

  return (
    <section className="analysis-risk-card" aria-labelledby="risk-summary-title">
      <div className="analysis-risk-card__overview">
        <div
          className={`analysis-risk-ring analysis-risk-ring--${riskLevel}`}
          aria-label={`Niveli i rrezikut: ${riskLabels[riskLevel]}`}
        >
          <span>Rreziku</span>
          <strong>{riskLabels[riskLevel]}</strong>
        </div>
        <div>
          <span>Vlerësimi i përgjithshëm</span>
          <h2 id="risk-summary-title">Rrezik {riskLabels[riskLevel].toLowerCase()}</h2>
          <p>{analysis.result.overallRiskExplanation}</p>
        </div>
      </div>

      <div className="analysis-risk-counters">
        {counters.map((counter) => (
          <div
            className={`analysis-risk-counter analysis-risk-counter--${counter.severity}`}
            key={counter.severity}
          >
            <strong>{counter.value}</strong>
            <span>{counter.label}</span>
          </div>
        ))}
      </div>
    </section>
  )
}
