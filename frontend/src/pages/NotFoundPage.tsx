import { Link } from 'react-router-dom'

export function NotFoundPage() {
  return (
    <section className="page-card">
      <h2>404</h2>
      <p>Faqja që kërkuat nuk ekziston.</p>
      <p>
        <Link to="/">Kthehu në kryefaqe</Link>
      </p>
    </section>
  )
}
