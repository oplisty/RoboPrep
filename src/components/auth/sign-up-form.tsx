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

      <Button type="submit" size="lg" disabled={pending} className="mt-1 w-full">
        {pending ? (
          <>
            <Loader2 className="size-4 animate-spin" aria-hidden />
            创建中
          </>
        ) : (
          "创建账户"
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
