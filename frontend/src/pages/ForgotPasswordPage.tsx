import { useEffect, useRef, useState, type FormEvent } from 'react'
import { Link } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { supabase } from '../lib/supabase'

export function ForgotPasswordPage() {
  const [email, setEmail] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const requestSequence = useRef(0)

  useEffect(() => () => {
    requestSequence.current += 1
  }, [])

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    if (isSubmitting || !event.currentTarget.reportValidity()) return

    const sequence = ++requestSequence.current
    setIsSubmitting(true)
    setMessage(null)
    setError(null)

    const { error: resetError } = await supabase.auth.resetPasswordForEmail(email.trim(), {
      redirectTo: `${window.location.origin}/reset-password`,
    })

    if (requestSequence.current !== sequence) return
    if (resetError) {
      setError('Kërkesa nuk mund të përfundohej për momentin. Provoni përsëri.')
    } else {
      setMessage('Nëse ekziston një llogari me këtë email, do të pranoni udhëzimet për rikuperim.')
    }
    setIsSubmitting(false)
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
          <h1>Rikupero fjalëkalimin</h1>
          <p>Shkruaj email-in për të marrë linkun e rikuperimit.</p>
        </div>

        <form className="auth-form" onSubmit={handleSubmit}>
          <label htmlFor="forgot-email">Email</label>
          <input id="forgot-email" type="email" autoComplete="email" value={email} onChange={(event) => setEmail(event.target.value)} required disabled={isSubmitting} />
          {error && <div className="auth-message auth-message--error" role="alert">{error}</div>}
          {message && <div className="auth-message auth-message--success" role="status">{message}</div>}
          <button type="submit" disabled={isSubmitting}>{isSubmitting ? 'Duke dërguar…' : 'Dërgo linkun'}</button>
        </form>

        <p className="auth-switch"><Link to="/login">Kthehu te kyçja</Link></p>
      </section>
    </main>
  )
}
