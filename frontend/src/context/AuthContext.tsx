import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react'
import type { Session } from '@supabase/supabase-js'

import { supabase } from '../lib/supabase'
import { getProfile } from '../services/profileService'
import type { Profile } from '../types/database'
import { AuthContext, type AuthContextValue } from './AuthContextDefinition'

type AuthProviderProps = {
  children: ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  const [session, setSession] = useState<Session | null>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [isSessionLoading, setIsSessionLoading] = useState(true)
  const [isProfileLoading, setIsProfileLoading] = useState(false)
  const [profileError, setProfileError] = useState<string | null>(null)

  const user = session?.user ?? null

  useEffect(() => {
    let isActive = true

    void supabase.auth.getSession().then(({ data, error }) => {
      if (!isActive) {
        return
      }

      if (error) {
        setSession(null)
      } else {
        setSession(data.session)
      }

      setIsSessionLoading(false)
    })

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, nextSession) => {
      setSession(nextSession)
      setIsSessionLoading(false)
    })

    return () => {
      isActive = false
      subscription.unsubscribe()
    }
  }, [])

  const loadProfile = useCallback(async (userId: string) => {
    setIsProfileLoading(true)
    setProfileError(null)

    try {
      const nextProfile = await getProfile(userId)
      setProfile(nextProfile)
    } catch {
      setProfile(null)
      setProfileError('Profili nuk mund të ngarkohej.')
    } finally {
      setIsProfileLoading(false)
    }
  }, [])

  useEffect(() => {
    if (!user) {
      setProfile(null)
      setProfileError(null)
      setIsProfileLoading(false)
      return
    }

    void loadProfile(user.id)
  }, [loadProfile, user])

  const refreshProfile = useCallback(async () => {
    if (!user) {
      return
    }

    await loadProfile(user.id)
  }, [loadProfile, user])

  const signIn = useCallback(async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    return { error }
  }, [])

  const signUp = useCallback(
    async (email: string, password: string, displayName: string) => {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            display_name: displayName,
          },
        },
      })

      return {
        error,
        requiresEmailConfirmation: !error && !data.session,
      }
    },
    [],
  )

  const signOut = useCallback(async () => {
    const { error } = await supabase.auth.signOut()
    return { error }
  }, [])

  const value = useMemo<AuthContextValue>(
    () => ({
      session,
      user,
      profile,
      isLoading: isSessionLoading || (Boolean(user) && isProfileLoading),
      profileError,
      signIn,
      signUp,
      signOut,
      refreshProfile,
    }),
    [
      isProfileLoading,
      isSessionLoading,
      profile,
      profileError,
      refreshProfile,
      session,
      signIn,
      signOut,
      signUp,
      user,
    ],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
