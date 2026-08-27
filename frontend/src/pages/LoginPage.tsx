import { useState, type FormEvent } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'

import { Icon } from '../components/ui/Icon'
import { useAuth } from '../hooks/useAuth'

type LoginLocationState = {
  from?: {
    pathname?: string
  }
  passwordReset?: boolean
}

export function LoginPage() {
  const { user, isLoading, signIn } = useAuth()
  const location = useLocation()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [errorMessage, setErrorMessage] = useState<string | null>(null)

  const locationState = location.state as LoginLocationState | null
  const destination = locationState?.from?.pathname ?? '/'

  if (!isLoading && user) {
    return <Navigate to="/" replace />
  }

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setIsSubmitting(true)
    setErrorMessage(null)

    const { error } = await signIn(email.trim(), password)

    if (error) {
      setErrorMessage('Email-i ose fjalëkalimi nuk është i saktë.')
      setIsSubmitting(false)
      return
    }

    navigate(destination, { replace: true })
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
          <h1>Kyçu në llogari</h1>
          <p>Vazhdo te kontratat dhe analizat e tua.</p>
        </div>

        <form className="auth-form" onSubmit={handleSubmit}>
          <label htmlFor="login-email">Email</label>
          <input
            id="login-email"
            type="email"
            autoComplete="email"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            required
          />

          {locationState?.passwordReset && (
            <div className="auth-message auth-message--success" role="status">
              Fjalëkalimi u ndryshua. Tani mund të kyçeni.
            </div>
          )}

          <label htmlFor="login-password">Fjalëkalimi</label>
          <input
            id="login-password"
            type="password"
            autoComplete="current-password"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            required
          />

          <Link className="auth-forgot-link" to="/forgot-password">
            Harrova fjalëkalimin?
          </Link>

          {errorMessage && (
            <div className="auth-message auth-message--error" role="alert">
              {errorMessage}
            </div>
          )}

          <button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Duke u kyçur…' : 'Kyçu'}
          </button>
        </form>

        <p className="auth-switch">
          Nuk ke llogari? <Link to="/register">Regjistrohu</Link>
        </p>
      </section>
    </main>
  )
}
