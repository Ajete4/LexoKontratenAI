import { useState } from 'react'
import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom'

import { useAuth } from '../../hooks/useAuth'
import { getDisplayName, getInitials } from '../../utils/userDisplay'
import { Icon, type IconName } from '../ui/Icon'

type SidebarItem = {
  label: string
  icon: IconName
  to?: string
}

const activeContractItems: SidebarItem[] = [
  { label: 'Rezultatet e analizës', icon: 'file', to: '/analysis' },
  { label: 'Raporti i rrezikut', icon: 'alert', to: '/risk' },
  { label: 'Pyetje për AI', icon: 'chat', to: '/questions' },
  { label: 'Rishkrim klauzole', icon: 'sparkle', to: '/rewrite' },
  { label: 'Shënime & Checklist', icon: 'check', to: '/notes' },
]

function SidebarButton({ item }: { item: SidebarItem }) {
  if (item.to) {
    return (
      <NavLink className="sidebar-link" to={item.to} end={item.to === '/'}>
        <Icon name={item.icon} size={17} />
        {item.label}
      </NavLink>
    )
  }

  return (
    <button
      className="sidebar-link sidebar-link--disabled"
      type="button"
      disabled
    >
      <Icon name={item.icon} size={17} />
      {item.label}
    </button>
  )
}

export function AppShell() {
  const location = useLocation()
  const navigate = useNavigate()
  const { profile, profileError, user, signOut } = useAuth()
  const [signOutError, setSignOutError] = useState<string | null>(null)

  const displayName = getDisplayName(profile, user)
  const initials = getInitials(displayName)
  const profileSubtitle = profileError ?? user?.email ?? 'Profil i autentikuar'
  const activeDocumentMatch = location.pathname.match(
    /^\/(?:analysis|risk|questions|rewrite|notes)\/([^/]+)\/([^/]+)$/,
  )
  const notesPath = activeDocumentMatch
    ? `/notes/${activeDocumentMatch[1]}/${activeDocumentMatch[2]}`
    : '/notes'
  const workItems: SidebarItem[] = [
    { label: 'Historiku', icon: 'history', to: '/history' },
    { label: 'Burimet ligjore', icon: 'book', to: '/legal-sources' },
    { label: 'Cilësimet', icon: 'settings', to: '/settings' },
  ]
  const contextualActiveContractItems = activeContractItems.map((item) =>
    item.to === '/notes' ? { ...item, to: notesPath } : item,
  )

  const pageTitles: Record<string, string> = {
    '/': 'Paneli i punës',
    '/upload': 'Analizë e re',
    '/generator': 'Gjenerues kontrate',
    '/processing': 'Duke analizuar…',
    '/analysis': 'Rezultatet e analizës',
    '/risk': 'Raporti i rrezikut',
    '/questions': 'Pyetje për AI',
    '/rewrite': 'Rishkrim klauzole',
    '/notes': 'Shënime & Checklist',
    '/history': 'Historiku i kontratave',
    '/legal-sources': 'Burimet ligjore',
    '/settings': 'Cilësimet',
  }
  const pageTitle = pageTitles[location.pathname] ?? 'LexoKontratën AI'

  const handleSignOut = async () => {
    setSignOutError(null)
    const { error } = await signOut()

    if (error) {
      setSignOutError('Dalja dështoi.')
    }
  }

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="sidebar-brand">
          <div className="sidebar-brand__icon">
            <Icon name="fileCheck" size={16} />
          </div>
          <div>
            <div className="sidebar-brand__name">
              LexoKontratën <span>AI</span>
            </div>
            <div className="sidebar-brand__tagline">
              ANALIZË KONTRATASH · KOSOVË
            </div>
          </div>
        </div>
        <nav className="navigation app-scroll" aria-label="Navigimi kryesor">
          <div className="sidebar-section-title">KRYESORE</div>
          <SidebarButton item={{ label: 'Paneli i punës', icon: 'grid', to: '/' }} />
          <SidebarButton item={{ label: 'Analizë e re', icon: 'upload', to: '/upload' }} />
          <SidebarButton item={{ label: 'Gjenero kontratë', icon: 'edit', to: '/generator' }} />
          <div className="sidebar-section-title sidebar-section-title--spaced">KONTRATA AKTIVE</div>
          {contextualActiveContractItems.map((item) => (
            <SidebarButton item={item} key={item.label} />
          ))}
          <div className="sidebar-section-title sidebar-section-title--spaced">PUNA IME</div>
          {workItems.map((item) => (
            <SidebarButton item={item} key={item.label} />
          ))}
        </nav>
        <div className="sidebar-profile">
          <div className="sidebar-profile__avatar">{initials}</div>
          <div className="sidebar-profile__copy">
            <div>{displayName}</div>
            <span>{signOutError ?? profileSubtitle}</span>
          </div>
          <button
            className="sidebar-sign-out"
            type="button"
            onClick={handleSignOut}
          >
            Dil
          </button>
        </div>
      </aside>
      <div className="app-main">
        <header className="header">
          <h1>{pageTitle}</h1>
          <div className="header-spacer" />
          <div className="header-search">
            <Icon name="search" size={15} />
            <span>Kërko kontrata, klauzola, burime…</span>
          </div>
          <button
            className="header-new-button"
            type="button"
            onClick={() => navigate('/upload')}
          >
            <Icon name="plus" size={15} />
            Analizë e re
          </button>
          <button
            className="header-icon-button"
            type="button"
            aria-label="Njoftimet"
          >
            <Icon name="bell" size={17} />
          </button>
        </header>
        <main className="content app-scroll">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
