import { useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useContracts } from '../hooks/useContracts'
import type { OverallRiskLevel } from '../types/analysis'
import type {
  ContractStatus,
  ContractType,
  ListedContract,
} from '../types/database'
import { formatDatabaseDate } from '../utils/dateFormat'

const contractTypeLabels: Record<ContractType, string> = {
  employment: 'Punësim',
  service: 'Shërbim',
  lease: 'Qira',
}

const contractStatusLabels: Record<ContractStatus, string> = {
  draft: 'Draft',
  uploaded: 'E ngarkuar',
  processing: 'Në përpunim',
  analyzed: 'E analizuar',
  failed: 'Dështoi',
  archived: 'Arkivuar',
}

const riskLabels: Record<OverallRiskLevel, string> = {
  low: 'I ulët',
  medium: 'Mesatar',
  high: 'I lartë',
  critical: 'Kritik',
  unknown: 'I panjohur',
}

function getPresentationStatus(contract: ListedContract): ContractStatus {
  return contract.latestCompletedAnalysis ? 'analyzed' : contract.status
}

export function HistoryPage() {
  const navigate = useNavigate()
  const { contracts, isLoading, error, refresh } = useContracts()
  const [contractType, setContractType] = useState<'all' | ContractType>('all')
  const [status, setStatus] = useState<'all' | ContractStatus>('all')
  const [searchQuery, setSearchQuery] = useState('')

  const filteredContracts = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLocaleLowerCase('sq-AL')

    return contracts.filter((contract) => {
      const matchesSearch =
        !normalizedQuery ||
        contract.title.toLocaleLowerCase('sq-AL').includes(normalizedQuery)
      const matchesType =
        contractType === 'all' || contract.contract_type === contractType
      const matchesStatus =
        status === 'all' || getPresentationStatus(contract) === status

      return matchesSearch && matchesType && matchesStatus
    })
  }, [contractType, contracts, searchQuery, status])

  return (
    <div className="history-page">
      <div className="history-heading">
        <div>
          <h2>Historiku i kontratave</h2>
          <p>
            {contracts.length} kontrata · filtroni sipas llojit dhe statusit.
          </p>
        </div>
        <div className="history-filters">
          <select
            aria-label="Filtro sipas llojit"
            value={contractType}
            onChange={(event) =>
              setContractType(event.target.value as 'all' | ContractType)
            }
          >
            <option value="all">Të gjitha llojet</option>
            <option value="employment">Punësim</option>
            <option value="service">Shërbim</option>
            <option value="lease">Qira</option>
          </select>
          <select
            aria-label="Filtro sipas statusit"
            value={status}
            onChange={(event) =>
              setStatus(event.target.value as 'all' | ContractStatus)
            }
          >
            <option value="all">Të gjitha statuset</option>
            <option value="draft">Draft</option>
            <option value="uploaded">E ngarkuar</option>
            <option value="processing">Në përpunim</option>
            <option value="analyzed">E analizuar</option>
            <option value="failed">Dështoi</option>
            <option value="archived">Arkivuar</option>
          </select>
        </div>
      </div>

      <div className="history-search">
        <Icon name="search" size={17} />
        <input
          aria-label="Kërko në historik"
          value={searchQuery}
          onChange={(event) => setSearchQuery(event.target.value)}
          placeholder="Kërko sipas emrit të kontratës…"
        />
      </div>

      <section className="history-table">
        <div className="history-table__header">
          <span>KONTRATA</span>
          <span>LLOJI</span>
          <span>DATA</span>
          <span>STATUSI</span>
          <span>RREZIKU</span>
          <span>VEPRIMI</span>
        </div>

        {isLoading && (
          <div className="history-state" role="status">
            Duke ngarkuar kontratat…
          </div>
        )}

        {!isLoading && error && (
          <div className="history-state history-state--error" role="alert">
            <span>{error}</span>
            <button type="button" onClick={refresh}>
              Provo përsëri
            </button>
          </div>
        )}

        {!isLoading && !error && filteredContracts.length > 0 && (
          <div className="history-table__body">
            {filteredContracts.map((contract) => {
              const latestAnalysis = contract.latestCompletedAnalysis
              const presentationStatus = getPresentationStatus(contract)

              return (
                <article className="history-row" key={contract.id}>
                  <div className="history-contract-title">
                    <div
                      className={`history-contract-icon history-contract-icon--${contract.contract_type}`}
                    >
                      <Icon name="file" size={15} />
                    </div>
                    <span title={contract.title}>{contract.title}</span>
                  </div>
                  <span>{contractTypeLabels[contract.contract_type]}</span>
                  <span>{formatDatabaseDate(contract.created_at)}</span>
                  <span>
                    <b
                      className={`contract-status contract-status--${presentationStatus}`}
                    >
                      {contractStatusLabels[presentationStatus]}
                    </b>
                  </span>
                  {latestAnalysis ? (
                    <b
                      className={`history-risk history-risk--${latestAnalysis.overallRisk}`}
                    >
                      {riskLabels[latestAnalysis.overallRisk]}
                    </b>
                  ) : (
                    <span className="history-risk-empty">—</span>
                  )}
                  <div className="history-analysis-action">
                    <button
                      type="button"
                      disabled={!latestAnalysis}
                      onClick={() => {
                        if (latestAnalysis) {
                          navigate(
                            `/analysis/${contract.id}/${latestAnalysis.versionId}`,
                          )
                        }
                      }}
                    >
                      {latestAnalysis ? 'Shiko analizën' : 'Pa analizë'}
                    </button>
                  </div>
                </article>
              )
            })}
          </div>
        )}

        {!isLoading && !error && filteredContracts.length === 0 && (
          <div className="history-empty">
            <div className="history-empty__icon">
              <Icon name="history" size={23} />
            </div>
            <h3>
              {contracts.length === 0
                ? 'Nuk ka kontrata në historik'
                : 'Asnjë kontratë nuk përputhet me filtrat'}
            </h3>
            <p>
              {contracts.length === 0
                ? 'Kontratat e përdoruesit do të shfaqen këtu pasi të krijohen.'
                : 'Ndrysho kërkimin ose filtrat për të parë rezultate të tjera.'}
            </p>
          </div>
        )}
      </section>
    </div>
  )
}
