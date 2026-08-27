import { useState, type FormEvent } from 'react'
import { Link, Navigate } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useAuth } from '../hooks/useAuth'

export function RegisterPage() {
  const { user, isLoading, signUp } = useAuth()
  const [displayName, setDisplayName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)
  const [successMessage, setSuccessMessage] = useState<string | null>(null)

  if (!isLoading && user) {
    return <Navigate to="/" replace />
  }

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setIsSubmitting(true)
    setErrorMessage(null)
    setSuccessMessage(null)

    const { error, requiresEmailConfirmation } = await signUp(
      email.trim(),
      password,
      displayName.trim(),
    )

    if (error) {
      setErrorMessage('Regjistrimi dështoi. Kontrollo të dhënat dhe provo përsëri.')
      setIsSubmitting(false)
      return
    }

    if (requiresEmailConfirmation) {
      setSuccessMessage(
        'Llogaria u krijua. Kontrollo email-in për konfirmimin e llogarisë.',
      )
    }

    setIsSubmitting(false)
  }

  return (
    <main className="auth-page">
      <section className="auth-card">
        <div className="auth-brand">
          <div className="auth-brand__icon">
            <Icon name="fileCheck" size={20} />
          </div>
          <div>
            <strong>
              LexoKontratën <span>AI</span>
            </strong>
            <small>ANALIZË KONTRATASH · KOSOVË</small>
          </div>
        </div>

        <div className="auth-heading">
          <h1>Krijo llogari</h1>
          <p>Regjistrohu për të ruajtur kontratat dhe rezultatet e tua.</p>
        </div>

        <form className="auth-form" onSubmit={handleSubmit}>
          <label htmlFor="register-name">Emri dhe mbiemri</label>
          <input
            id="register-name"
            type="text"
            autoComplete="name"
            minLength={2}
            maxLength={100}
            value={displayName}
            onChange={(event) => setDisplayName(event.target.value)}
            required
          />

          <label htmlFor="register-email">Email</label>
          <input
            id="register-email"
            type="email"
            autoComplete="email"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            required
          />

          <label htmlFor="register-password">Fjalëkalimi</label>
          <input
            id="register-password"
            type="password"
            autoComplete="new-password"
            minLength={6}
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            required
          />

          {errorMessage && (
            <div className="auth-message auth-message--error" role="alert">
              {errorMessage}
            </div>
          )}

          {successMessage && (
            <div className="auth-message auth-message--success" role="status">
              {successMessage}
            </div>
          )}

          <button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Duke u regjistruar…' : 'Regjistrohu'}
          </button>
        </form>

        <p className="auth-switch">
          Ke llogari? <Link to="/login">Kyçu</Link>
        </p>
      </section>
    </main>
  )
}
