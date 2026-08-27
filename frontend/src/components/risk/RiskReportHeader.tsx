import type { ContractAnalysis } from '../../types/analysis'
import { contractTypeLabels } from '../analysis/analysisLabels'

type RiskReportHeaderProps = {
  analysis: ContractAnalysis
  findingCount: number
  onBackToResults: () => void
}

export function RiskReportHeader({
  analysis,
  findingCount,
  onBackToResults,
}: RiskReportHeaderProps) {
  return (
    <header className="risk-report-header">
      <div>
        <h1>Raporti i rrezikut</h1>
        <p>
          {analysis.result.title}
          <span aria-hidden="true">·</span>
          {contractTypeLabels[analysis.result.contractType]}
          <span aria-hidden="true">·</span>
          {findingCount} {findingCount === 1 ? 'gjetje' : 'gjetje'}
        </p>
      </div>

      <button type="button" onClick={onBackToResults}>
        <span aria-hidden="true">←</span>
        Kthehu te rezultatet
      </button>
    </header>
  )
}
