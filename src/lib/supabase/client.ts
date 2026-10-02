import { createBrowserClient } from "@supabase/ssr";

import { env } from "@/lib/env";
import type { Database } from "@/types/database";

/**
 * Supabase client for Client Components.
 *
 * Uses the anonymous key only — Row Level Security is what protects data here.
 */
export function createClient() {
  return createBrowserClient<Database>(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    {
      // PKCE keeps email-confirmation links working with the server-side
      // /auth/callback route: Supabase's verify step redirects with `?code=`
      // which exchangeCodeForSession can consume. The default implicit flow
      // puts tokens in the URL fragment, which a server route can never read,
      // so confirmation silently dropped the fresh session.
      auth: { flowType: "pkce" },
    },
  );
}
