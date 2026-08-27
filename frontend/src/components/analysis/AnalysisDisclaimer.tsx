import { Icon } from '../ui/Icon'

type AnalysisDisclaimerProps = {
  disclaimer: string
}

export function AnalysisDisclaimer({ disclaimer }: AnalysisDisclaimerProps) {
  return (
    <aside className="analysis-workspace-disclaimer" aria-label="Kufizim juridik">
      <Icon name="info" size={17} />
      <span>{disclaimer}</span>
    </aside>
  )
}
