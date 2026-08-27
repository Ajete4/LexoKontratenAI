import type { ContractAnalysisClause } from '../../types/analysis'
import {
  clauseTypeLabels,
  findingTypeLabels,
  severityLabels,
} from './analysisLabels'

type ClauseExplorerProps = {
  clauses: ContractAnalysisClause[]
  selectedPosition: number | null
  onSelect: (clause: ContractAnalysisClause) => void
}

export function ClauseExplorer({
  clauses,
  selectedPosition,
  onSelect,
}: ClauseExplorerProps) {
  const orderedClauses = [...clauses].sort(
    (first, second) => first.position - second.position,
  )

  return (
    <section className="clause-explorer" aria-labelledby="clause-explorer-title">
      <header className="clause-explorer__header">
        <h2 id="clause-explorer-title">
          Gjetjet e dokumentit <span>· Klikoni një klauzolë</span>
        </h2>
        <div className="clause-explorer__legend" aria-label="Nivelet e rrezikut">
          <span className="legend-critical">Kritik</span>
          <span className="legend-high">I lartë</span>
          <span className="legend-medium">Mesatar</span>
        </div>
      </header>

      {orderedClauses.length === 0 ? (
        <div className="analysis-tab-empty">
          Nuk u identifikuan klauzola në këtë analizë.
        </div>
      ) : (
        <div className="clause-explorer__list">
          {orderedClauses.map((clause) => {
            const isSelected = clause.position === selectedPosition

            return (
              <button
                className={`clause-explorer-card clause-explorer-card--${clause.severity}${isSelected ? ' is-selected' : ''}`}
                type="button"
                key={clause.position}
                aria-pressed={isSelected}
                onClick={() => onSelect(clause)}
              >
                <span className="clause-explorer-card__topline">
                  <span>
                    Klauzola {clause.position} · {clause.title}
                  </span>
                  <span className={`severity-pill severity-pill--${clause.severity}`}>
                    {severityLabels[clause.severity]}
                  </span>
                </span>
                <span className="clause-explorer-card__meta">
                  {clauseTypeLabels[clause.clauseType]} ·{' '}
                  {findingTypeLabels[clause.findingType]}
                  {isSelected && (
                    <strong className="clause-explorer-card__selected">
                      E zgjedhur
                    </strong>
                  )}
                </span>
                <span className="clause-explorer-card__copy">
                  {clause.originalText ??
                    'Kjo klauzolë ose ky informacion mungon në dokument.'}
                </span>
              </button>
            )
          })}
        </div>
      )}
    </section>
  )
}
