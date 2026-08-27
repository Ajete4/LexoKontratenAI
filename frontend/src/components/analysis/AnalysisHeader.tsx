import { Icon } from '../ui/Icon'
import type { ContractAnalysis } from '../../types/analysis'
import { contractTypeLabels, languageLabels } from './analysisLabels'

type AnalysisHeaderProps = {
  analysis: ContractAnalysis
  onOpenQuestions: () => void
  onOpenRiskReport: () => void
  onExport: () => void
  isExporting: boolean
  exportError: string | null
}

const completedAtFormatter = new Intl.DateTimeFormat('sq-AL', {
  day: '2-digit',
  month: 'short',
  year: 'numeric',
})

export function AnalysisHeader({
  analysis,
  exportError,
  isExporting,
  onExport,
  onOpenQuestions,
  onOpenRiskReport,
}: AnalysisHeaderProps) {
  const completedAt = completedAtFormatter.format(
    new Date(analysis.completedAt),
  )

  return (
    <header className="analysis-workspace-header">
      <div className="analysis-workspace-header__identity">
        <span className="analysis-workspace-header__icon">
          <Icon name="fileCheck" size={22} />
        </span>
        <div>
          <h1>{analysis.result.title}</h1>
          <p>
            {contractTypeLabels[analysis.result.contractType]}
            <span aria-hidden="true">·</span>
            {analysis.clauses.length} klauzola
            <span aria-hidden="true">·</span>
            Analizuar më {completedAt}
            <span aria-hidden="true">·</span>
            {languageLabels[analysis.result.language]}
          </p>
        </div>
      </div>

      <div className="analysis-workspace-header__actions">
        <button
          type="button"
          onClick={onOpenQuestions}
        >
          <Icon name="chat" size={16} />
          Pyet AI
        </button>
        <button type="button" onClick={onOpenRiskReport}>
          <Icon name="alert" size={16} />
          Raporti i rrezikut
        </button>
        <button
          className="analysis-action--primary"
          type="button"
          disabled={isExporting || analysis.status !== 'completed'}
          onClick={onExport}
          title={exportError ?? undefined}
        >
          {isExporting ? 'Duke eksportuar…' : 'Eksporto'}
        </button>
      </div>
    </header>
  )
}
