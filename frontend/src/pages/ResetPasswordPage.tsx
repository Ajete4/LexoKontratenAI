import { useEffect, useRef, useState, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useAuth } from '../hooks/useAuth'
import { supabase } from '../lib/supabase'

export function ResetPasswordPage() {
  const navigate = useNavigate()
  const { isLoading, session } = useAuth()
  const [password, setPassword] = useState('')
  const [confirmation, setConfirmation] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const requestSequence = useRef(0)

  useEffect(() => () => {
    requestSequence.current += 1
  }, [])

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    if (isSubmitting || !session || !event.currentTarget.reportValidity()) return
    if (password !== confirmation) {
      setError('Fjalëkalimet nuk përputhen.')
      return
    }

    const sequence = ++requestSequence.current
    setIsSubmitting(true)
    setError(null)
    const { error: updateError } = await supabase.auth.updateUser({ password })

    if (requestSequence.current !== sequence) return
    if (updateError) {
      setError('Fjalëkalimi nuk mund të ndryshohej. Kërko një link të ri dhe provo përsëri.')
      setIsSubmitting(false)
      return
    }

    await supabase.auth.signOut()
    if (requestSequence.current !== sequence) return
    navigate('/login', { replace: true, state: { passwordReset: true } })
  }

  if (isLoading) {
    return <div className="auth-loading" role="status">Duke verifikuar linkun e rikuperimit…</div>
  }

  return (
    <main className="auth-page">
      <section className="auth-card">
        <div className="auth-brand">
          <div className="auth-brand__icon"><Icon name="fileCheck" size={20} /></div>
          <div>
            <strong>LexoKontratën <span>AI</span></strong>
            <small>ANALIZË KONTRATASH · KOSOVË</small>
          </div>
        </div>

        <div className="auth-heading">
          <h1>Vendos fjalëkalimin e ri</h1>
          <p>Fjalëkalimi duhet të ketë së paku 8 karaktere.</p>
        </div>

        {!session ? (
          <div className="auth-recovery-empty">
            <div className="auth-message auth-message--error" role="alert">Linku i rikuperimit është i pavlefshëm ose ka skaduar.</div>
            <Link to="/forgot-password">Kërko link të ri</Link>
          </div>
        ) : (
          <form className="auth-form" onSubmit={handleSubmit}>
            <label htmlFor="reset-password">Fjalëkalimi i ri</label>
            <input id="reset-password" type="password" autoComplete="new-password" minLength={8} value={password} onChange={(event) => setPassword(event.target.value)} required disabled={isSubmitting} />
            <label htmlFor="reset-confirmation">Konfirmo fjalëkalimin</label>
            <input id="reset-confirmation" type="password" autoComplete="new-password" minLength={8} value={confirmation} onChange={(event) => setConfirmation(event.target.value)} required disabled={isSubmitting} />
            {error && <div className="auth-message auth-message--error" role="alert">{error}</div>}
            <button type="submit" disabled={isSubmitting}>{isSubmitting ? 'Duke ndryshuar…' : 'Ndrysho fjalëkalimin'}</button>
          </form>
        )}

        <p className="auth-switch"><Link to="/login">Kthehu te kyçja</Link></p>
      </section>
    </main>
  )
}
