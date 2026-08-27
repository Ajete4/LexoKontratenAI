import type { ClauseSeverity, ContractAnalysisClause } from '../../types/analysis'

type RiskCountersProps = {
  clauses: ContractAnalysisClause[]
}

type CounterDefinition = {
  label: string
  severity: Exclude<ClauseSeverity, 'none'> | 'professional_review'
}

const counterDefinitions: CounterDefinition[] = [
  { label: 'Kritik', severity: 'critical' },
  { label: 'I lartë', severity: 'high' },
  { label: 'Mesatar', severity: 'medium' },
  { label: 'I ulët', severity: 'low' },
  { label: 'Për shqyrtim', severity: 'professional_review' },
]

export function RiskCounters({ clauses }: RiskCountersProps) {
  return (
    <section className="risk-report-counters" aria-label="Numërimi sipas rrezikut">
      {counterDefinitions.map(({ label, severity }) => {
        const count = clauses.filter((clause) =>
          severity === 'professional_review'
            ? clause.requiresProfessionalReview
            : clause.severity === severity,
        ).length
        const visualSeverity =
          severity === 'professional_review' ? 'review_required' : severity

        return (
          <article
            className={`risk-report-counter risk-report-counter--${visualSeverity}`}
            key={severity}
          >
            <strong>{count}</strong>
            <span>{label}</span>
          </article>
        )
      })}
    </section>
  )
}
