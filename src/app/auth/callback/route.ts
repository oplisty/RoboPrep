import { NextResponse, type NextRequest } from "next/server";

import { createClient } from "@/lib/supabase/server";
import { safeInternalPath } from "@/lib/utils";

/**
 * Email confirmation / magic-link entry point.
 *
 * Supabase redirects here with a `code` that is exchanged for a session cookie.
 */
export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const codeParam = searchParams.get("code");
  const next = safeInternalPath(searchParams.get("next") ?? undefined);

  const target = request.nextUrl.clone();
  target.search = "";

  if (codeParam) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(codeParam);

    if (!error) {
      target.pathname = next;
      // Surface the confirmation so users see that their email was verified —
      // the homepage renders a banner when this flag is present.
      target.searchParams.set("confirmed", "1");
      return NextResponse.redirect(target);
    }
  }

  target.pathname = "/sign-in";
  target.searchParams.set("error", "auth_callback");
  return NextResponse.redirect(target);
}
