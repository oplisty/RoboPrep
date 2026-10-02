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

      <Button type="submit" size="lg" disabled={pending} className="mt-1 w-full">
        {pending ? (
          <>
            <Loader2 className="size-4 animate-spin" aria-hidden />
            登录中
          </>
        ) : (
          "登录"
        )}
      </Button>

      <p className="text-ink-secondary text-center text-sm">
        还没有 RoboPrep 账户？{" "}
        <Link href="/sign-up" className="text-accent font-medium hover:underline">
          创建账户
        </Link>
      </p>
    </form>
  );
}
