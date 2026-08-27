import { useCallback, useEffect, useRef, useState } from 'react'
import { Link, useParams } from 'react-router-dom'

import { useAuth } from '../hooks/useAuth'
import {
  ContractNotesServiceError,
  getContractNotes,
  saveContractNotes,
} from '../services/contractNotesService'

const checklistLabels = [
  'Palët e verifikuara',
  'Kushtet e pagesës janë të qarta',
  'Afatet janë të qarta',
  'Penalitetet janë rishikuar',
  'Ndërprerja është rishikuar',
  'Këshillë juridike e rekomanduar (rrezik i lartë)',
] as const

const emptyChecklist = checklistLabels.map(() => false)

type SaveStatus = 'idle' | 'saving' | 'saved' | 'error'

export function NotesChecklistPage() {
  const { session } = useAuth()
  const { contractId, versionId } = useParams<{
    contractId: string
    versionId: string
  }>()
  const [notes, setNotes] = useState('')
  const [checks, setChecks] = useState<boolean[]>(emptyChecklist)
  const [isLoading, setIsLoading] = useState(false)
  const [loadError, setLoadError] = useState<string | null>(null)
  const [isDirty, setIsDirty] = useState(false)
  const [saveStatus, setSaveStatus] = useState<SaveStatus>('idle')
  const activeController = useRef<AbortController | null>(null)
  const requestSequence = useRef(0)
  const hasActiveContract = Boolean(contractId && versionId)
  const completedCount = checks.filter(Boolean).length

  const cancelActiveRequest = useCallback(() => {
    requestSequence.current += 1
    activeController.current?.abort()
    activeController.current = null
  }, [])

  const loadNotes = useCallback(async () => {
    if (!session?.access_token || !contractId || !versionId) {
      return
    }

    cancelActiveRequest()
    const controller = new AbortController()
    const sequence = requestSequence.current
    activeController.current = controller
    setIsLoading(true)
    setLoadError(null)
    setSaveStatus('idle')

    try {
      const result = await getContractNotes({
        accessToken: session.access_token,
        contractId,
        versionId,
        signal: controller.signal,
      })

      if (requestSequence.current !== sequence || controller.signal.aborted) {
        return
      }

      setNotes(result?.notes ?? '')
      setChecks(result?.checklist ?? emptyChecklist)
      setIsDirty(false)
    } catch (error) {
      if (
        requestSequence.current === sequence &&
        !(error instanceof ContractNotesServiceError && error.kind === 'aborted')
      ) {
        setLoadError(
          error instanceof ContractNotesServiceError
            ? error.message
            : 'Shënimet nuk mund të ngarkoheshin.',
        )
      }
    } finally {
      if (requestSequence.current === sequence) {
        activeController.current = null
        setIsLoading(false)
      }
    }
  }, [cancelActiveRequest, contractId, session?.access_token, versionId])

  useEffect(() => {
    if (!hasActiveContract) {
      setNotes('')
      setChecks(emptyChecklist)
      setIsDirty(false)
      setLoadError(null)
      return
    }

    void loadNotes()
  }, [hasActiveContract, loadNotes])

  useEffect(() => cancelActiveRequest, [cancelActiveRequest])

  useEffect(() => {
    if (
      !isDirty ||
      isLoading ||
      !session?.access_token ||
      !contractId ||
      !versionId
    ) {
      return
    }

    const timeoutId = window.setTimeout(() => {
      cancelActiveRequest()
      const controller = new AbortController()
      const sequence = requestSequence.current
      activeController.current = controller
      setSaveStatus('saving')
      setIsDirty(false)

      void saveContractNotes({
        accessToken: session.access_token,
        checklist: checks,
        contractId,
        notes,
        signal: controller.signal,
        versionId,
      })
        .then(() => {
          if (
            requestSequence.current === sequence &&
            !controller.signal.aborted
          ) {
            setSaveStatus('saved')
          }
        })
        .catch((error: unknown) => {
          if (
            requestSequence.current === sequence &&
            !(error instanceof ContractNotesServiceError && error.kind === 'aborted')
          ) {
            setSaveStatus('error')
            setIsDirty(true)
          }
        })
        .finally(() => {
          if (requestSequence.current === sequence) {
            activeController.current = null
          }
        })
    }, 700)

    return () => window.clearTimeout(timeoutId)
  }, [
    cancelActiveRequest,
    checks,
    contractId,
    isDirty,
    isLoading,
    notes,
    session?.access_token,
    versionId,
  ])

  const handleNotesChange = (value: string) => {
    setNotes(value)
    setIsDirty(true)
    setSaveStatus('idle')
  }

  const handleCheckToggle = (index: number) => {
    setChecks((currentChecks) =>
      currentChecks.map((isChecked, itemIndex) =>
        itemIndex === index ? !isChecked : isChecked,
      ),
    )
    setIsDirty(true)
    setSaveStatus('idle')
  }

  const saveMessage =
    saveStatus === 'saving'
      ? 'Duke ruajtur…'
      : saveStatus === 'saved'
        ? 'Ndryshimet u ruajtën.'
        : saveStatus === 'error'
          ? 'Ruajtja dështoi. Ndryshoni përmbajtjen për të provuar përsëri.'
          : 'Ndryshimet ruhen automatikisht.'

  return (
    <div className="notes-page">
      <div className="notes-heading">
        <h2>Shënime & Lista e kontrollit</h2>
        <p>
          {hasActiveContract
            ? 'Kontrata aktive · shënimet dhe lista ruhen në llogarinë tuaj'
            : 'Pa kontratë aktive · nuk ruhet asnjë e dhënë'}
        </p>
      </div>

      {!hasActiveContract && (
        <div className="notes-local-hint" role="status">
          Hapni një analizë nga <Link to="/history">Historiku</Link> për të
          përdorur shënimet dhe listën e kontrollit.
        </div>
      )}

      {loadError && (
        <div className="notes-local-hint" role="alert">
          {loadError}{' '}
          <button type="button" onClick={() => void loadNotes()}>
            Provo përsëri
          </button>
        </div>
      )}

      <div className="notes-layout">
        <section className="notes-card">
          <h3>Shënimet e mia</h3>
          <textarea
            value={notes}
            maxLength={10_000}
            disabled={!hasActiveContract || isLoading || Boolean(loadError)}
            onChange={(event) => handleNotesChange(event.target.value)}
            placeholder="Shkruani shënime për këtë kontratë…"
          />
          <div
            className="notes-local-hint"
            role={saveStatus === 'error' ? 'alert' : 'status'}
          >
            {isLoading ? 'Duke ngarkuar shënimet…' : saveMessage}
          </div>
        </section>

        <section className="notes-card">
          <div className="checklist-heading">
            <h3>Lista e kontrollit</h3>
            <span>
              {completedCount}/{checks.length}
            </span>
          </div>
          <div className="checklist-progress">
            <span
              style={{ width: `${(completedCount / checks.length) * 100}%` }}
            />
          </div>
          <div className="checklist-items">
            {checklistLabels.map((label, index) => (
              <button
                type="button"
                key={label}
                disabled={!hasActiveContract || isLoading || Boolean(loadError)}
                onClick={() => handleCheckToggle(index)}
              >
                <i className={checks[index] ? 'done' : ''}>
                  {checks[index] ? '✓' : ''}
                </i>
                <span className={checks[index] ? 'checked' : ''}>{label}</span>
              </button>
            ))}
          </div>
        </section>
      </div>
    </div>
  )
}
