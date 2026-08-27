import { Icon } from '../ui/Icon'
import type { OverallRiskLevel } from '../../types/analysis'
import { riskLabels } from '../analysis/analysisLabels'

type RiskReviewNoticeProps = {
  disclaimer: string
  overallRiskExplanation: string
  overallRiskLevel: OverallRiskLevel
  professionalReviewRecommended: boolean
}

export function RiskReviewNotice({
  disclaimer,
  overallRiskExplanation,
  overallRiskLevel,
  professionalReviewRecommended,
}: RiskReviewNoticeProps) {
  return (
    <aside
      className={`risk-review-notice risk-review-notice--${overallRiskLevel}`}
      aria-label="Vlerësimi i përgjithshëm dhe kufizimi juridik"
    >
      <Icon name="alert" size={19} />
      <div>
        <strong>Rreziku i përgjithshëm: {riskLabels[overallRiskLevel]}</strong>
        <p>{overallRiskExplanation}</p>
        {professionalReviewRecommended && (
          <p>Rekomandohet shqyrtim nga një profesionist juridik.</p>
        )}
        <p className="risk-review-notice__disclaimer">{disclaimer}</p>
      </div>
    </aside>
  )
}
