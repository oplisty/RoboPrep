"use client";

import * as React from "react";
import Link from "next/link";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";

/** Week 8 Task 42: request a password-reset email. */
export function ForgotPasswordForm() {
  const [email, setEmail] = React.useState("");
  const [sent, setSent] = React.useState(false);
  const [pending, setPending] = React.useState(false);

  async function handleSubmit(event: React.FormEvent) {
    event.preventDefault();
    setPending(true);
    const supabase = createClient();
    await supabase.auth.resetPasswordForEmail(email, {
      // Return users to whichever domain they started on — the site serves
      // several (scut.dog / roboprep.dpdns.org / robo-prep.vercel.app) and
      // Supabase session cookies are host-scoped.
      redirectTo: `${window.location.origin}/reset-password`,
    });
    // Always show the sent state — never reveal whether the account exists.
    setSent(true);
    setPending(false);
  }

  if (sent) {
    return (
      <div className="border-line-subtle bg-surface shadow-card rounded-md border p-6">
        <p className="text-ink font-medium">请查收邮箱</p>
        <p className="text-ink-secondary mt-1 text-sm leading-relaxed">
          如果 {email}{" "}
          对应的账户存在，重置链接很快就会发送到你的邮箱。链接将在短时间后失效。
        </p>
        <Link
          href="/sign-in"
          className="text-accent hover:text-accent-hover mt-4 inline-block text-sm font-medium"
        >
          返回登录
        </Link>
      </div>
    );
  }

  return (
    <form
      onSubmit={handleSubmit}
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
        {pending ? "发送中…" : "发送重置链接"}
      </Button>
    </form>
  );
}
