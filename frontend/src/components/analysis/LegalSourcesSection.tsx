import type { ContractAnalysisClause } from '../../types/analysis'

type LegalSourcesSectionProps = {
  clause: ContractAnalysisClause
}

function citationLabel(
  citation: ContractAnalysisClause['citations'][number],
) {
  const article = citation.articleNumber
    ? `Neni ${citation.articleNumber}`
    : 'Neni i papërcaktuar'

  return citation.articleTitle
    ? `${article} — ${citation.articleTitle}`
    : article
}

export function LegalSourcesSection({ clause }: LegalSourcesSectionProps) {
  return (
    <section
      className="legal-sources-section"
      aria-labelledby={`legal-sources-title-${clause.position}`}
    >
      <h4 id={`legal-sources-title-${clause.position}`}>
        Burimet ligjore
      </h4>

      {clause.evidenceStatus !== 'grounded' ? (
        <p className="legal-sources-section__empty">
          Nuk u gjet evidencë e mjaftueshme juridike.
        </p>
      ) : (
        <ol className="legal-sources-section__list">
          {clause.citations.map((citation) => (
            <li key={citation.citationId}>
              <div>
                <strong>Ligji Nr. {citation.lawNumber}</strong>
                <span>{citationLabel(citation)}</span>
              </div>
              <a
                href={citation.officialUrl}
                target="_blank"
                rel="noopener noreferrer"
              >
                Hap burimin zyrtar
                <span className="sr-only"> në tab të ri</span>
              </a>
            </li>
          ))}
        </ol>
      )}
    </section>
  )
}
