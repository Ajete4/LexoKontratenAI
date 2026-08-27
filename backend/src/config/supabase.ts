import { createClient, type SupabaseClient } from "@supabase/supabase-js";

import { env } from "./env.js";

export const supabaseAdmin = createClient(
  env.SUPABASE_URL,
  env.SUPABASE_SECRET_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);

export function createUserSupabaseClient(accessToken: string): SupabaseClient {
  return createClient(
    env.SUPABASE_URL,
    env.SUPABASE_PUBLISHABLE_KEY,
    {
      global: {
        headers: {
          Authorization: `Bearer ${accessToken}`
        }
      },
      auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false
      }
    }
  );
}
