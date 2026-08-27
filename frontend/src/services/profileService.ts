import { supabase } from '../lib/supabase'
import type { AiResponseDetail, Profile } from '../types/database'

const PROFILE_COLUMNS = [
  'id',
  'display_name',
  'preferred_language',
  'ai_response_detail',
  'show_legal_references',
  'created_at',
  'updated_at',
].join(', ')

type ProfileUpdate = {
  display_name?: string
  ai_response_detail?: AiResponseDetail
  show_legal_references?: boolean
}

export async function getProfile(userId: string): Promise<Profile | null> {
  const { data, error } = await supabase
    .from('profiles')
    .select(PROFILE_COLUMNS)
    .eq('id', userId)
    .maybeSingle()

  if (error) {
    throw error
  }

  return data as Profile | null
}

export async function updateProfile(
  userId: string,
  update: ProfileUpdate,
): Promise<Profile> {
  const allowedUpdate: ProfileUpdate = {}

  if (update.display_name !== undefined) {
    allowedUpdate.display_name = update.display_name
  }

  if (update.ai_response_detail !== undefined) {
    allowedUpdate.ai_response_detail = update.ai_response_detail
  }

  if (update.show_legal_references !== undefined) {
    allowedUpdate.show_legal_references = update.show_legal_references
  }

  const { data, error } = await supabase
    .from('profiles')
    .update(allowedUpdate)
    .eq('id', userId)
    .select(PROFILE_COLUMNS)
    .single()

  if (error) {
    throw error
  }

  return data as unknown as Profile
}
