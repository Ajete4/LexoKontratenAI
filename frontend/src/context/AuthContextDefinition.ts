import { createContext } from 'react'
import type { AuthError, Session, User } from '@supabase/supabase-js'

import type { Profile } from '../types/database'

type AuthActionResult = {
  error: AuthError | null
}

type SignUpResult = AuthActionResult & {
  requiresEmailConfirmation: boolean
}

export type AuthContextValue = {
  session: Session | null
  user: User | null
  profile: Profile | null
  isLoading: boolean
  profileError: string | null
  signIn: (email: string, password: string) => Promise<AuthActionResult>
  signUp: (
    email: string,
    password: string,
    displayName: string,
  ) => Promise<SignUpResult>
  signOut: () => Promise<AuthActionResult>
  refreshProfile: () => Promise<void>
}

export const AuthContext = createContext<AuthContextValue | null>(null)
