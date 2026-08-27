import type { User } from '@supabase/supabase-js'

import type { Profile } from '../types/database'

export function getDisplayName(profile: Profile | null, user: User | null) {
  const profileName = profile?.display_name.trim()

  if (profileName) {
    return profileName
  }

  const emailName = user?.email?.split('@')[0]?.trim()
  return emailName || 'Përdorues'
}

export function getInitials(displayName: string) {
  const nameParts = displayName
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)

  return nameParts.map((part) => part[0]?.toUpperCase()).join('') || 'P'
}
