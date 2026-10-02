"use client";

import * as React from "react";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";

/**
 * Password recovery via emailed OTP code instead of a one-time link.
 *
 * Reset links break in the wild: they are single-use, invalidated by the next
 * request, consumed by mail-provider link scanning, and only work in the same
 * browser that requested them (PKCE verifier cookie). A 6-digit code typed
 * into any device sidesteps all of those failure modes, so stage two asks for
 * the code plus the new password directly.
 */
export function ForgotPasswordForm() {
  const [stage, setStage] = React.useState<"email" | "code" | "done">("email");
  const [email, setEmail] = React.useState("");
  const [token, setToken] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [confirm, setConfirm] = React.useState("");
  const [error, setError] = React.useState<string | null>(null);
  const [pending, setPending] = React.useState(false);

  async function handleSendCode(event: React.FormEvent) {
    event.preventDefault();
    setError(null);
    setPending(true);
    const supabase = createClient();
    await supabase.auth.resetPasswordForEmail(email.trim());
    // Always move to the code stage — never reveal whether the account exists.
    setStage("code");
    setPending(false);
  }

  async function handleReset(event: React.FormEvent) {
    event.preventDefault();
    setError(null);
    if (token.trim().length < 6) {
      setError("请输入邮件中的验证码。");
      return;
    }
    if (password.length < 8) {
      setError("密码至少需要 8 个字符。");
      return;
    }
    if (password !== confirm) {
      setError("两次输入的密码不一致。");
      return;
    }
    setPending(true);
    const supabase = createClient();
    const { error: verifyError } = await supabase.auth.verifyOtp({
      email: email.trim(),
      token: token.trim(),
      type: "recovery",
    });
    if (verifyError) {
      setError("验证码无效或已过期，请确认使用的是最新一封邮件中的验证码。");
      setPending(false);
      return;
    }
    const { error: updateError } = await supabase.auth.updateUser({ password });
    if (updateError) {
      setError("密码设置失败，请重试。");
      setPending(false);
      return;
    }
    setStage("done");
    setPending(false);
  }

  if (stage === "done") {
    return (
      <div className="border-line-subtle bg-surface shadow-card rounded-md border p-6">
        <p className="text-ink font-medium">密码已更新 ✅</p>
        <p className="text-ink-secondary mt-1 text-sm leading-relaxed">
          新密码已生效，使用邮箱和新密码登录即可。
        </p>
        <Link
          href="/sign-in"
          className="text-accent hover:text-accent-hover mt-4 inline-block text-sm font-medium"
        >
          去登录
        </Link>
      </div>
    );
  }

  if (stage === "code") {
    return (
      <form
        onSubmit={handleReset}
        className="border-line-subtle bg-surface shadow-card rounded-md border p-6"
      >
        <p className="text-ink text-sm font-medium">输入验证码，设置新密码</p>
        <p className="text-ink-secondary mt-1 text-sm leading-relaxed">
          重置验证码已发送到 <span className="text-ink">{email}</span>
          （若未收到请检查垃圾邮件；发送新的一封会使旧验证码作废）。
        </p>
        <div className="mt-4 flex flex-col gap-4">
          <div>
            <label htmlFor="reset-token" className="text-ink mb-1 block text-sm font-medium">
              验证码
            </label>
            <Input
              id="reset-token"
              inputMode="numeric"
              autoComplete="one-time-code"
              placeholder="6 位数字验证码"
              value={token}
              onChange={(event) => setToken(event.target.value)}
            />
          </div>
          <div>
            <label htmlFor="reset-password" className="text-ink mb-1 block text-sm font-medium">
              新密码
            </label>
            <Input
              id="reset-password"
              type="password"
              autoComplete="new-password"
              placeholder="至少 8 个字符"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
            />
          </div>
          <div>
            <label htmlFor="reset-confirm" className="text-ink mb-1 block text-sm font-medium">
              确认新密码
            </label>
            <Input
              id="reset-confirm"
              type="password"
              autoComplete="new-password"
              value={confirm}
              onChange={(event) => setConfirm(event.target.value)}
            />
          </div>
          {error ? (
            <p role="alert" className="text-danger text-sm">
              {error}
            </p>
          ) : null}
          <Button type="submit" disabled={pending} className="w-full">
            {pending ? "提交中…" : "设置新密码"}
          </Button>
          <Button
            type="button"
            variant="secondary"
            className="w-full"
            disabled={pending}
            onClick={() => {
              setStage("email");
              setToken("");
              setPassword("");
              setConfirm("");
              setError(null);
            }}
          >
            返回重新输入邮箱
          </Button>
        </div>
      </form>
    );
  }

  return (
    <form
      onSubmit={handleSendCode}
      className="border-line-subtle bg-surface shadow-card rounded-md border p-6"
    >
      <div>
        <label htmlFor="email" className="text-ink mb-1 block text-sm font-medium">
          邮箱
        </label>
        <Input
          id="email"
          type="email"
          required
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          autoComplete="email"
        />
      </div>
      <Button type="submit" disabled={pending} className="mt-4 w-full">
        {pending ? "发送中…" : "发送重置验证码"}
      </Button>
    </form>
  );
}
