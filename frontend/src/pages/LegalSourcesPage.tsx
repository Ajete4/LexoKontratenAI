import { useMemo, useState } from 'react'

import { Icon } from '../components/ui/Icon'
import { useLegalSources } from '../hooks/useLegalSources'
import type { ContractType } from '../types/database'
import type { LegalSource } from '../types/legalSources'

const applicabilityLabels: Record<ContractType, string> = {
  employment: 'Punësim',
  service: 'Shërbim',
  lease: 'Qira',
}

const legalStatusLabels: Partial<Record<LegalSource['legalStatus'], string>> = {
  verified_current: 'I verifikuar',
  superseded: 'I zëvendësuar',
  repealed: 'I shfuqizuar',
}

const documentTypeLabels: Record<LegalSource['documentType'], string> = {
  law: 'Ligj',
  amendment: 'Ndryshim/plotësim',
}

export function LegalSourcesPage() {
  const { error, isLoading, legalSources, retry } = useLegalSources()
  const [searchQuery, setSearchQuery] = useState('')
  const [applicability, setApplicability] = useState<
    'all' | ContractType
  >('all')

  const filteredSources = useMemo(() => {
    const normalizedSearch = searchQuery.trim().toLocaleLowerCase('sq-AL')

    return legalSources.filter((source) => {
      const matchesSearch =
        normalizedSearch.length === 0 ||
        source.title.toLocaleLowerCase('sq-AL').includes(normalizedSearch) ||
        source.lawNumber.toLocaleLowerCase('sq-AL').includes(normalizedSearch)
      const matchesApplicability =
        applicability === 'all' || source.applicability.includes(applicability)

      return matchesSearch && matchesApplicability
    })
  }, [applicability, legalSources, searchQuery])

  return (
    <div className="legal-sources-page">
      <div className="legal-sources-heading">
        <h2>Burimet ligjore</h2>
        <p>
          Burimet zyrtare dhe të verifikuara të korpusit ligjor të MVP-së.
        </p>
      </div>

      <div className="legal-sources-toolbar">
        <div className="legal-sources-search">
          <Icon name="search" size={17} />
          <input
            aria-label="Kërko burim ligjor"
            value={searchQuery}
            onChange={(event) => setSearchQuery(event.target.value)}
            placeholder="Kërko sipas titullit ose numrit të ligjit…"
          />
        </div>
        <select
          aria-label="Filtro sipas zbatueshmërisë"
          value={applicability}
          onChange={(event) =>
            setApplicability(event.target.value as 'all' | ContractType)
          }
        >
          <option value="all">Të gjitha fushat</option>
          <option value="employment">Punësim</option>
          <option value="service">Shërbim</option>
          <option value="lease">Qira</option>
        </select>
      </div>

      <div className="legal-sources-note">
        <Icon name="info" size={15} />
        <span>
          Këto burime ofrojnë mbështetje informative. Interpretimi juridik
          përfundimtar duhet të verifikohet nga profesionistë të fushës.
        </span>
      </div>

      {isLoading && (
        <section className="legal-sources-empty" role="status">
          <div className="legal-sources-empty__icon">
            <Icon name="book" size={24} />
          </div>
          <h3>Duke ngarkuar burimet ligjore…</h3>
        </section>
      )}

      {!isLoading && error && (
        <section className="legal-sources-empty" role="alert">
          <div className="legal-sources-empty__icon">
            <Icon name="alert" size={24} />
          </div>
          <h3>Burimet nuk mund të ngarkoheshin</h3>
          <p>{error}</p>
          <button type="button" onClick={retry}>
            Provo përsëri
          </button>
        </section>
      )}

      {!isLoading && !error && filteredSources.length > 0 && (
        <section className="legal-source-list" aria-label="Burimet ligjore">
          {filteredSources.map((source) => {
            const sourceUrl =
              source.officialDocumentUrl ?? source.officialUrl
            const legalStatusLabel = legalStatusLabels[source.legalStatus]

            return (
              <article className="legal-source-card" key={source.id}>
                <div className="legal-source-card__icon">
                  <Icon name="book" size={20} />
                </div>
                <div className="legal-source-card__content">
                  <div className="legal-source-card__heading">
                    <div>
                      <span>{source.lawNumber}</span>
                      <h3>{source.title}</h3>
                    </div>
                    {legalStatusLabel && <b>{legalStatusLabel}</b>}
                  </div>
                  <div className="legal-source-card__metadata">
                    <span>{documentTypeLabels[source.documentType]}</span>
                    <span>Versioni: {source.versionLabel}</span>
                    <span>
                      Publikuar: {source.publicationDate ?? 'Pa datë të shënuar'}
                    </span>
                    <span>{source.chunkCount} pjesë të indeksuara</span>
                  </div>
                  <div className="legal-source-card__applicability">
                    {source.applicability.map((contractType) => (
                      <span key={contractType}>
                        {applicabilityLabels[contractType]}
                      </span>
                    ))}
                  </div>
                </div>
                <a
                  href={sourceUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Hap burimin
                </a>
              </article>
            )
          })}
        </section>
      )}

      {!isLoading && !error && filteredSources.length === 0 && (
        <section className="legal-sources-empty">
          <div className="legal-sources-empty__icon">
            <Icon name="book" size={24} />
          </div>
          <h3>
            {legalSources.length === 0
              ? 'Nuk ka burime ligjore të disponueshme'
              : 'Asnjë burim nuk përputhet me filtrat'}
          </h3>
          <p>
            {legalSources.length === 0
              ? 'Burimet e verifikuara do të shfaqen këtu kur të jenë të disponueshme.'
              : 'Ndrysho kërkimin ose filtrin për të parë burimet e tjera.'}
          </p>
        </section>
      )}
    </div>
  )
}
