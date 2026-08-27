import { useCallback, useEffect, useRef, useState } from 'react'
import { Link, useLocation, useParams } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useAuth } from '../hooks/useAuth'
import {
  askContractQuestion,
  ContractQuestionServiceError,
  type ContractQuestionResponse,
} from '../services/contractQuestionService'

const presets = [
  'A mund të më penalizojë kjo klauzolë?',
  'Çfarë mungon në këtë kontratë?',
  'A është kjo klauzolë në favor të kompanisë?',
  'Si mund ta negocioj këtë pjesë?',
]

export function QuestionsPage() {
  const { session } = useAuth()
  const { contractId, versionId } = useParams<{ contractId: string; versionId: string }>()
  const location = useLocation()
  const routeState = location.state as { contractTitle?: string } | null
  const [draft, setDraft] = useState('')
  const [submittedQuestion, setSubmittedQuestion] = useState<string | null>(null)
  const [result, setResult] = useState<ContractQuestionResponse | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [canRetry, setCanRetry] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const requestSequence = useRef(0)
  const activeController = useRef<AbortController | null>(null)
  const hasContext = Boolean(contractId && versionId)

  const cancelActiveRequest = useCallback(() => {
    requestSequence.current += 1
    activeController.current?.abort()
    activeController.current = null
    setIsLoading(false)
  }, [])

  useEffect(() => cancelActiveRequest, [cancelActiveRequest])
  useEffect(() => {
    if (!session) cancelActiveRequest()
  }, [cancelActiveRequest, session])

  const submitQuestion = useCallback(async (question: string) => {
    if (!session?.access_token || !contractId || !versionId || isLoading) return
    if (question.trim().length === 0 || question.length > 1_000) return

    cancelActiveRequest()
    const controller = new AbortController()
    activeController.current = controller
    const sequence = requestSequence.current
    setSubmittedQuestion(question)
    setResult(null)
    setError(null)
    setCanRetry(false)
    setIsLoading(true)

    try {
      const response = await askContractQuestion({ accessToken: session.access_token, contractId, versionId, question, signal: controller.signal })
      if (requestSequence.current !== sequence || controller.signal.aborted) return
      setResult(response)
    } catch (requestError) {
      if (requestSequence.current !== sequence || controller.signal.aborted) return
      if (requestError instanceof ContractQuestionServiceError && requestError.kind !== 'aborted') {
        setError(requestError.message)
        setCanRetry(requestError.canRetry)
      } else if (!(requestError instanceof ContractQuestionServiceError)) {
        setError('Përgjigjja nuk mund të përgatitej për momentin.')
        setCanRetry(true)
      }
    } finally {
      if (requestSequence.current === sequence) {
        activeController.current = null
        setIsLoading(false)
      }
    }
  }, [cancelActiveRequest, contractId, isLoading, session, versionId])

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    void submitQuestion(draft)
  }

  return (
    <div className="questions-page">
      <aside className="chat-context">
        <div className="section-label">KONTEKSTI</div>
        <div className="context-empty context-empty--active">
          <div><Icon name="file" size={17} /></div>
          <section>
            <strong>{hasContext ? routeState?.contractTitle ?? 'Kontrata' : 'Asnjë kontratë aktive'}</strong>
            <span>{hasContext ? 'Pyetjet lidhen vetëm me këtë dokument' : 'Hap një analizë nga Historiku'}</span>
          </section>
        </div>

        <div className="section-label frequent-label">PYETJE TË SHPESHTA</div>
        <div className="preset-list">
          {presets.map((preset) => (
            <button type="button" key={preset} onClick={() => setDraft(preset)} disabled={!hasContext || isLoading}>{preset}</button>
          ))}
        </div>
        <div className="chat-side-note">Ky sistem ofron ndihmë informative dhe nuk zëvendëson këshillën juridike profesionale.</div>
      </aside>

      <section className="chat-main">
        <div className="chat-messages" aria-live="polite">
          {!hasContext ? (
            <div className="chat-empty">
              <div><Icon name="chat" size={24} /></div>
              <h3>Nuk ka kontratë aktive</h3>
              <p>Hap një analizë të përfunduar për të bërë pyetje mbi kontratën.</p>
              <Link className="chat-empty__link" to="/history">Shko te Historiku</Link>
            </div>
          ) : isLoading ? (
            <div className="chat-empty" role="status">
              <div><Icon name="chat" size={24} /></div>
              <h3>Duke përgatitur përgjigjen…</h3>
              <p>Po kontrollohen kontrata dhe burimet juridike të lejuara.</p>
            </div>
          ) : error ? (
            <div className="chat-empty chat-error" role="alert">
              <div><Icon name="alert" size={24} /></div>
              <h3>Përgjigjja nuk mund të ngarkohet</h3>
              <p>{error}</p>
              {canRetry && <button type="button" onClick={() => submittedQuestion && void submitQuestion(submittedQuestion)}>Provo përsëri</button>}
            </div>
          ) : result ? (
            <div className="question-result">
              {submittedQuestion && <div className="question-result__prompt">{submittedQuestion}</div>}
              {result.insufficientEvidence ? (
                <section className="question-result__insufficient">
                  <h3>Nuk u gjet evidencë e mjaftueshme juridike</h3>
                  <p>Burimet aktuale nuk mbështesin një përgjigje të sigurt për këtë pyetje.</p>
                </section>
              ) : (
                <section className="question-result__answer">
                  <h3>Përgjigjja</h3>
                  <p>{result.answer}</p>
                  {result.citations.length > 0 && (
                    <>
                      <h4>Burimet ligjore</h4>
                      <div className="question-citations">
                        {result.citations.map((citation) => (
                          <article key={citation.citationId}>
                            <span>{citation.citationId}</span>
                            <div>
                              <strong>{citation.lawNumber} · {citation.sourceTitle}</strong>
                              {(citation.articleNumber || citation.articleTitle) && <p>{[citation.articleNumber && `Neni ${citation.articleNumber}`, citation.articleTitle].filter(Boolean).join(' — ')}</p>}
                              <a href={citation.officialUrl} target="_blank" rel="noopener noreferrer">Hap burimin zyrtar</a>
                            </div>
                          </article>
                        ))}
                      </div>
                    </>
                  )}
                </section>
              )}
              <p className="question-result__disclaimer">{result.disclaimer}</p>
            </div>
          ) : (
            <div className="chat-empty">
              <div><Icon name="chat" size={24} /></div>
              <h3>Pyet rreth kontratës</h3>
              <p>Pyetja do të vlerësohet vetëm kundrejt kontratës aktive dhe burimeve juridike të verifikuara.</p>
            </div>
          )}
        </div>

        <form className="chat-composer" onSubmit={handleSubmit}>
          <label className="sr-only" htmlFor="contract-question">Pyetja për kontratën</label>
          <div>
            <textarea id="contract-question" value={draft} onChange={(event) => setDraft(event.target.value)} placeholder="Shkruaj pyetjen tënde për kontratën…" maxLength={1_000} disabled={!hasContext || isLoading} />
            <button type="submit" disabled={!hasContext || isLoading || draft.trim().length === 0} aria-label="Dërgo pyetjen"><Icon name="chat" size={19} /></button>
          </div>
          <p>{draft.length}/1000 · Përgjigjet janë informative dhe duhet të verifikohen me burimin ligjor.</p>
        </form>
      </section>
    </div>
  )
}
