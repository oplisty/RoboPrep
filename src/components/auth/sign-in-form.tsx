"use client";

import * as React from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import { fieldErrors, readableAuthError, signInSchema } from "@/lib/validation/auth";

export function SignInForm({ nextUrl = "/" }: { nextUrl?: string }) {
  const router = useRouter();
  const [email, setEmail] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [errors, setErrors] = React.useState<Record<string, string>>({});
  const [formError, setFormError] = React.useState<string | null>(null);
  const [pending, setPending] = React.useState(false);
  const [oauthPending, setOauthPending] = React.useState(false);

  async function handleOAuth(provider: "github" | "google") {
    setFormError(null);
    setOauthPending(true);
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(nextUrl)}`,
      },
    });
    if (error) {
      setOauthPending(false);
      setFormError(readableAuthError(error.message));
    }
  }

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setFormError(null);

    const parsed = signInSchema.safeParse({ email, password });
    if (!parsed.success) {
      setErrors(fieldErrors(parsed.error));
      return;
    }
    setErrors({});
    setPending(true);

    const supabase = createClient();
    const { error } = await supabase.auth.signInWithPassword(parsed.data);

    if (error) {
      setPending(false);
      setFormError(readableAuthError(error.message));
      return;
    }

    // Refresh so Server Components re-render with the new session, then navigate.
    router.replace(nextUrl);
    router.refresh();
  }

  return (
    <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
      <div className="flex flex-col gap-1.5">
        <label
          htmlFor="signin-email"
          className="text-ink-secondary text-[0.8125rem] font-medium"
        >
          邮箱
        </label>
        <Input
          id="signin-email"
          name="email"
          type="email"
          autoComplete="email"
          placeholder="邮箱@example.com"
          value={email}
          invalid={Boolean(errors.email)}
          aria-describedby={errors.email ? "signin-email-error" : undefined}
          onChange={(event) => setEmail(event.target.value)}
        />
        {errors.email ? (
          <p id="signin-email-error" role="alert" className="text-danger text-xs">
            {errors.email}
          </p>
        ) : null}
      </div>

      <div className="flex flex-col gap-1.5">
        <div className="flex items-center justify-between">
          <label
            htmlFor="signin-password"
            className="text-ink-secondary text-[0.8125rem] font-medium"
          >
            密码
          </label>
          <Link
            href="/forgot-password"
            className="text-accent text-[0.8125rem] font-medium hover:underline"
          >
            忘记密码？
          </Link>
        </div>
        <Input
          id="signin-password"
          name="password"
          type="password"
          autoComplete="current-password"
          placeholder="请输入密码"
          value={password}
          invalid={Boolean(errors.password)}
          aria-describedby={errors.password ? "signin-password-error" : undefined}
          onChange={(event) => setPassword(event.target.value)}
        />
        {errors.password ? (
          <p id="signin-password-error" role="alert" className="text-danger text-xs">
            {errors.password}
          </p>
        ) : null}
      </div>

      {formError ? (
        <p role="alert" className="text-danger text-sm">
          {formError}
        </p>
      ) : null}

      <Button type="submit" size="lg" disabled={pending || oauthPending} className="mt-1 w-full">
        {pending ? (
          <>
            <Loader2 className="size-4 animate-spin" aria-hidden />
            登录中
          </>
        ) : (
          "登录"
        )}
      </Button>

      <div className="flex items-center gap-3" aria-hidden>
        <span className="border-line-subtle h-px flex-1 border-t" />
        <span className="text-ink-tertiary text-xs">或</span>
        <span className="border-line-subtle h-px flex-1 border-t" />
      </div>

      <div className="grid grid-cols-2 gap-3">
        <Button
          type="button"
          variant="secondary"
          size="lg"
          disabled={pending || oauthPending}
          onClick={() => handleOAuth("github")}
        >
          {oauthPending ? (
            <Loader2 className="size-4 animate-spin" aria-hidden />
          ) : (
            <svg viewBox="0 0 16 16" className="size-4" fill="currentColor" aria-hidden>
              <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8Z" />
            </svg>
          )}
          GitHub
        </Button>
        <Button
          type="button"
          variant="secondary"
          size="lg"
          disabled={pending || oauthPending}
          onClick={() => handleOAuth("google")}
        >
          {oauthPending ? (
            <Loader2 className="size-4 animate-spin" aria-hidden />
          ) : (
            <svg viewBox="0 0 24 24" className="size-4" aria-hidden>
              <path fill="#4285F4" d="M23.49 12.27c0-.79-.07-1.54-.19-2.27H12v4.51h6.47c-.29 1.48-1.14 2.73-2.4 3.58v3h3.86c2.26-2.09 3.56-5.17 3.56-8.82Z" />
              <path fill="#34A853" d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.86-3c-1.08.72-2.45 1.16-4.07 1.16-3.13 0-5.78-2.11-6.73-4.96H1.29v3.09C3.26 21.3 7.31 24 12 24Z" />
              <path fill="#FBBC05" d="M5.27 14.29c-.25-.72-.38-1.49-.38-2.29s.14-1.57.38-2.29V6.62H1.29C.47 8.24 0 10.06 0 12s.47 3.76 1.29 5.38l3.98-3.09Z" />
              <path fill="#EA4335" d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.31 0 3.26 2.7 1.29 6.62l3.98 3.09C6.22 6.86 8.87 4.75 12 4.75Z" />
            </svg>
          )}
          Google
        </Button>
      </div>

      <p className="text-ink-secondary text-center text-sm">
        还没有 RoboPrep 账户？{" "}
        <Link href="/sign-up" className="text-accent font-medium hover:underline">
          创建账户
        </Link>
      </p>
    </form>
  );
}
