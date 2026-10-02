import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

import { env } from "@/lib/env";
import type { Database } from "@/types/database";

/**
 * Supabase client for Server Components, Route Handlers and Server Actions.
 *
 * Reads/writes the session through Next.js cookies so that auth state is shared
 * with the browser client and refreshed by `src/middleware.ts`.
 */
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient<Database>(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    {
      // Kept in sync with the browser client so the PKCE code verifier cookie
      // set during email confirmation can be exchanged server-side.
      auth: { flowType: "pkce" },
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            for (const { name, value, options } of cookiesToSet) {
              cookieStore.set(name, value, options);
            }
          } catch {
            // Called from a Server Component, where cookies are read-only.
            // Safe to ignore: middleware refreshes the session for every request.
          }
        },
      },
    },
  );
}
