"use client";

import * as React from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Loader2, MailCheck } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import { fieldErrors, readableAuthError, signUpSchema } from "@/lib/validation/auth";

export function SignUpForm({ nextUrl = "/" }: { nextUrl?: string }) {
  const router = useRouter();
  const [displayName, setDisplayName] = React.useState("");
  const [email, setEmail] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [confirmPassword, setConfirmPassword] = React.useState("");
  const [errors, setErrors] = React.useState<Record<string, string>>({});
  const [formError, setFormError] = React.useState<string | null>(null);
  const [pending, setPending] = React.useState(false);
  const [oauthPending, setOauthPending] = React.useState(false);

  async function handleOAuth(provider: "github") {
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
  /** Supabase returns no session when email confirmation is enabled. */
  const [awaitingConfirmation, setAwaitingConfirmation] = React.useState(false);

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setFormError(null);

    const parsed = signUpSchema.safeParse({
      email,
      displayName,
      password,
      confirmPassword,
    });
    if (!parsed.success) {
      setErrors(fieldErrors(parsed.error));
      return;
    }
    setErrors({});
    setPending(true);

    const supabase = createClient();
    const { data, error } = await supabase.auth.signUp({
      email: parsed.data.email,
      password: parsed.data.password,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback?next=${encodeURIComponent(nextUrl)}`,
        data: {
          display_name: parsed.data.displayName || undefined,
        },
      },
    });

    if (error) {
      setPending(false);
      setFormError(readableAuthError(error.message));
      return;
    }

    if (data.session) {
      router.replace(nextUrl);
      router.refresh();
      return;
    }

    setPending(false);
    setAwaitingConfirmation(true);
  }

  if (awaitingConfirmation) {
    return (
      <div className="bg-surface-muted flex flex-col items-center gap-3 rounded-sm p-6 text-center">
        <span className="bg-accent-soft text-accent flex size-11 items-center justify-center rounded-full">
          <MailCheck className="size-5" aria-hidden />
        </span>
        <h2 className="text-ink text-[1.0625rem] font-semibold">请查收邮箱</h2>
        <p className="text-ink-secondary text-sm leading-relaxed">
          我们已将确认链接发送至 <span className="text-ink font-medium">{email}</span>
          。请打开链接激活账户，然后登录。
        </p>
        <Link
          href="/sign-in"
          className="text-accent text-sm font-medium hover:underline"
        >
          返回登录
        </Link>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} noValidate className="flex flex-col gap-4">
      <div className="flex flex-col gap-1.5">
        <label
          htmlFor="signup-name"
          className="text-ink-secondary text-[0.8125rem] font-medium"
        >
          显示名称 <span className="text-ink-tertiary">（可选）</span>
        </label>
        <Input
          id="signup-name"
          name="displayName"
          autoComplete="name"
          placeholder="请输入你的称呼"
          value={displayName}
          invalid={Boolean(errors.displayName)}
          aria-describedby={errors.displayName ? "signup-name-error" : undefined}
          onChange={(event) => setDisplayName(event.target.value)}
        />
        {errors.displayName ? (
          <p id="signup-name-error" role="alert" className="text-danger text-xs">
            {errors.displayName}
          </p>
        ) : null}
      </div>

      <div className="flex flex-col gap-1.5">
        <label
          htmlFor="signup-email"
          className="text-ink-secondary text-[0.8125rem] font-medium"
        >
          邮箱
        </label>
        <Input
          id="signup-email"
          name="email"
          type="email"
          autoComplete="email"
          placeholder="邮箱@example.com"
          value={email}
          invalid={Boolean(errors.email)}
          aria-describedby={errors.email ? "signup-email-error" : undefined}
          onChange={(event) => setEmail(event.target.value)}
        />
        {errors.email ? (
          <p id="signup-email-error" role="alert" className="text-danger text-xs">
            {errors.email}
          </p>
        ) : null}
      </div>

      <div className="flex flex-col gap-1.5">
        <label
          htmlFor="signup-password"
          className="text-ink-secondary text-[0.8125rem] font-medium"
        >
          密码
        </label>
        <Input
          id="signup-password"
          name="password"
          type="password"
          autoComplete="new-password"
          placeholder="至少 8 个字符"
          value={password}
          invalid={Boolean(errors.password)}
          aria-describedby={errors.password ? "signup-password-error" : undefined}
          onChange={(event) => setPassword(event.target.value)}
        />
        {errors.password ? (
          <p id="signup-password-error" role="alert" className="text-danger text-xs">
            {errors.password}
          </p>
        ) : null}
      </div>

      <div className="flex flex-col gap-1.5">
        <label
          htmlFor="signup-confirm"
          className="text-ink-secondary text-[0.8125rem] font-medium"
        >
          确认密码
        </label>
        <Input
          id="signup-confirm"
          name="confirmPassword"
          type="password"
          autoComplete="new-password"
          placeholder="请再次输入密码"
          value={confirmPassword}
          invalid={Boolean(errors.confirmPassword)}
          aria-describedby={errors.confirmPassword ? "signup-confirm-error" : undefined}
          onChange={(event) => setConfirmPassword(event.target.value)}
        />
        {errors.confirmPassword ? (
          <p id="signup-confirm-error" role="alert" className="text-danger text-xs">
            {errors.confirmPassword}
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
            创建中
          </>
        ) : (
          "创建账户"
        )}
      </Button>

      <div className="flex items-center gap-3" aria-hidden>
        <span className="border-line-subtle h-px flex-1 border-t" />
        <span className="text-ink-tertiary text-xs">或</span>
        <span className="border-line-subtle h-px flex-1 border-t" />
      </div>

      <Button
        type="button"
        variant="secondary"
        size="lg"
        disabled={pending || oauthPending}
        className="w-full"
        onClick={() => handleOAuth("github")}
      >
        {oauthPending ? (
          <>
            <Loader2 className="size-4 animate-spin" aria-hidden />
            正在跳转 GitHub
          </>
        ) : (
          <>
            <svg viewBox="0 0 16 16" className="size-4" fill="currentColor" aria-hidden>
              <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8Z" />
            </svg>
            使用 GitHub 注册
          </>
        )}
      </Button>

      <p className="text-ink-secondary text-center text-sm">
        已经有账户了？{" "}
        <Link href="/sign-in" className="text-accent font-medium hover:underline">
          登录
        </Link>
      </p>
    </form>
  );
}
