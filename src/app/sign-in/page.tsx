import type { Metadata } from "next";
import { redirect } from "next/navigation";

import { SignInForm } from "@/components/auth/sign-in-form";
import { getCurrentUser } from "@/lib/auth/session";
import { safeInternalPath } from "@/lib/utils";

export const metadata: Metadata = {
  title: "登录",
  description: "登录 RoboPrep 账户。",
};

export default async function SignInPage({
  searchParams,
}: {
  searchParams: Promise<{ next?: string; error?: string }>;
}) {
  const { next, error } = await searchParams;
  const nextUrl = safeInternalPath(next);

  const user = await getCurrentUser();
  if (user) redirect(nextUrl);

  const callbackFailed = error === "auth_callback";

  return (
    <div className="mx-auto flex w-full max-w-[26rem] flex-col gap-6 py-16 sm:py-24">
      <div className="flex flex-col gap-2 text-center">
        <h1 className="text-title text-ink font-semibold tracking-[-0.02em]">登录</h1>
        <p className="text-ink-secondary text-sm leading-relaxed">
          继续练习具身智能面试。
        </p>
      </div>

      {callbackFailed ? (
        <p
          role="alert"
          className="border-danger/30 bg-danger/10 text-ink rounded-lg border px-4 py-2 text-center text-sm"
        >
          确认链接无效或已过期。如果邮箱尚未确认，注册后请重新点击邮件中的确认链接。
        </p>
      ) : null}

      <div className="border-line-subtle bg-surface shadow-card rounded-lg border p-6 sm:p-8">
        <SignInForm nextUrl={nextUrl} />
      </div>
    </div>
  );
}
