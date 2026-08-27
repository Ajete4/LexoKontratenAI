import { useEffect, useState } from 'react'

import { useAuth } from '../hooks/useAuth'
import { updateProfile } from '../services/profileService'
import type { AiResponseDetail } from '../types/database'
import { getDisplayName, getInitials } from '../utils/userDisplay'

type ToggleProps = {
  checked: boolean
  disabled?: boolean
  label: string
  onChange: () => void
}

function Toggle({ checked, disabled = false, label, onChange }: ToggleProps) {
  return (
    <button
      className={`settings-toggle ${checked ? 'active' : ''}`}
      type="button"
      role="switch"
      aria-checked={checked}
      aria-label={label}
      disabled={disabled}
      onClick={onChange}
    >
      <span />
    </button>
  )
}

export function SettingsPage() {
  const { isLoading, profile, profileError, refreshProfile, user } = useAuth()
  const [isEditingProfile, setIsEditingProfile] = useState(false)
  const [displayNameDraft, setDisplayNameDraft] = useState('')
  const [aiDetail, setAiDetail] = useState<AiResponseDetail>('summary')
  const [showLegalReferences, setShowLegalReferences] = useState(true)
  const [isSavingProfile, setIsSavingProfile] = useState(false)
  const [isSavingPreferences, setIsSavingPreferences] = useState(false)
  const [profileFeedback, setProfileFeedback] = useState<string | null>(null)
  const [preferencesFeedback, setPreferencesFeedback] = useState<string | null>(
    null,
  )

  useEffect(() => {
    if (!profile) {
      return
    }

    setDisplayNameDraft(profile.display_name)
    setAiDetail(profile.ai_response_detail)
    setShowLegalReferences(profile.show_legal_references)
  }, [profile])

  const displayName = getDisplayName(profile, user)
  const initials = getInitials(displayName)

  const handleStartProfileEdit = () => {
    setDisplayNameDraft(profile?.display_name ?? '')
    setProfileFeedback(null)
    setIsEditingProfile(true)
  }

  const handleCancelProfileEdit = () => {
    setDisplayNameDraft(profile?.display_name ?? '')
    setProfileFeedback(null)
    setIsEditingProfile(false)
  }

  const handleSaveProfile = async () => {
    const normalizedDisplayName = displayNameDraft.trim()

    if (
      !user ||
      normalizedDisplayName.length < 2 ||
      normalizedDisplayName.length > 100
    ) {
      setProfileFeedback('Emri duhet të ketë nga 2 deri në 100 karaktere.')
      return
    }

    setIsSavingProfile(true)
    setProfileFeedback(null)

    try {
      await updateProfile(user.id, { display_name: normalizedDisplayName })
      await refreshProfile()
      setIsEditingProfile(false)
      setProfileFeedback('Profili u përditësua me sukses.')
    } catch {
      setProfileFeedback('Profili nuk mund të përditësohej. Provoni përsëri.')
    } finally {
      setIsSavingProfile(false)
    }
  }

  const handleAiDetailChange = async (nextDetail: AiResponseDetail) => {
    if (!user || isSavingPreferences || nextDetail === aiDetail) {
      return
    }

    setIsSavingPreferences(true)
    setPreferencesFeedback(null)

    try {
      await updateProfile(user.id, { ai_response_detail: nextDetail })
      setAiDetail(nextDetail)
      await refreshProfile()
      setPreferencesFeedback('Preferenca u ruajt.')
    } catch {
      setPreferencesFeedback('Preferenca nuk mund të ruhej. Provoni përsëri.')
    } finally {
      setIsSavingPreferences(false)
    }
  }

  const handleLegalReferencesChange = async () => {
    if (!user || isSavingPreferences) {
      return
    }

    const nextValue = !showLegalReferences
    setIsSavingPreferences(true)
    setPreferencesFeedback(null)

    try {
      await updateProfile(user.id, { show_legal_references: nextValue })
      setShowLegalReferences(nextValue)
      await refreshProfile()
      setPreferencesFeedback('Preferenca u ruajt.')
    } catch {
      setPreferencesFeedback('Preferenca nuk mund të ruhej. Provoni përsëri.')
    } finally {
      setIsSavingPreferences(false)
    }
  }

  return (
    <div className="settings-page">
      <div className="settings-heading">
        <h2>Cilësimet</h2>
      </div>

      <div className="settings-sections">
        <section className="settings-card">
          <h3>Profili</h3>
          <div className="settings-profile">
            <div className="settings-profile__avatar">{initials}</div>
            <div className="settings-profile__copy">
              {isEditingProfile ? (
                <label className="settings-profile__edit">
                  <span>Emri i profilit</span>
                  <input
                    type="text"
                    value={displayNameDraft}
                    minLength={2}
                    maxLength={100}
                    disabled={isSavingProfile}
                    autoFocus
                    onChange={(event) => setDisplayNameDraft(event.target.value)}
                  />
                </label>
              ) : (
                <>
                  <strong>{isLoading ? 'Duke ngarkuar…' : displayName}</strong>
                  <span>{user?.email ?? 'Profili i përdoruesit'}</span>
                </>
              )}
            </div>

            {isEditingProfile ? (
              <div className="settings-profile__actions">
                <button
                  type="button"
                  disabled={isSavingProfile}
                  onClick={handleCancelProfileEdit}
                >
                  Anulo
                </button>
                <button
                  className="settings-profile__save"
                  type="button"
                  disabled={isSavingProfile}
                  onClick={handleSaveProfile}
                >
                  {isSavingProfile ? 'Duke ruajtur…' : 'Ruaj'}
                </button>
              </div>
            ) : (
              <button
                type="button"
                disabled={!profile || isLoading}
                onClick={handleStartProfileEdit}
              >
                Ndrysho
              </button>
            )}
          </div>

          {(profileFeedback || profileError) && (
            <p
              className="settings-feedback"
              role={profileFeedback?.includes('sukses') ? 'status' : 'alert'}
            >
              {profileFeedback ?? profileError}
            </p>
          )}
        </section>

        <section className="settings-card">
          <h3>Gjuha & juridiksioni</h3>
          <div className="settings-row">
            <label htmlFor="interface-language">Gjuha e ndërfaqes</label>
            <select id="interface-language" value="sq-KS" disabled>
              <option value="sq-KS">Shqip (Kosovë)</option>
            </select>
          </div>
          <div className="settings-row settings-row--last">
            <label htmlFor="default-jurisdiction">
              Juridiksioni i parazgjedhur
            </label>
            <select id="default-jurisdiction" value="kosovo" disabled>
              <option value="kosovo">Kosovë</option>
            </select>
          </div>
        </section>

        <section className="settings-card">
          <h3>Sjellja e AI</h3>
          <p>Sa të hollësishme të jenë shpjegimet.</p>
          <div className="settings-choice-grid">
            <button
              className={aiDetail === 'summary' ? 'active' : ''}
              type="button"
              disabled={!profile || isSavingPreferences}
              onClick={() => handleAiDetailChange('summary')}
            >
              E përmbledhur
            </button>
            <button
              className={aiDetail === 'detailed' ? 'active' : ''}
              type="button"
              disabled={!profile || isSavingPreferences}
              onClick={() => handleAiDetailChange('detailed')}
            >
              E detajuar
            </button>
          </div>
          <div className="settings-row settings-row--toggle">
            <span>Shfaq gjithmonë referencat ligjore</span>
            <Toggle
              checked={showLegalReferences}
              disabled={!profile || isSavingPreferences}
              label="Shfaq gjithmonë referencat ligjore"
              onChange={handleLegalReferencesChange}
            />
          </div>

          {preferencesFeedback && (
            <p
              className="settings-feedback"
              role={
                preferencesFeedback === 'Preferenca u ruajt.'
                  ? 'status'
                  : 'alert'
              }
            >
              {preferencesFeedback}
            </p>
          )}
        </section>

        <section className="settings-card">
          <h3>Eksporti</h3>
          <div className="settings-row settings-row--last settings-row--first">
            <label htmlFor="default-export-format">
              Formati i parazgjedhur i eksportit
            </label>
            <select id="default-export-format" value="pdf" disabled>
              <option value="pdf">PDF</option>
            </select>
          </div>
        </section>
      </div>
    </div>
  )
}
