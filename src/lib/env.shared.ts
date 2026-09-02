import { z } from "zod";

/**
 * Centralised environment configuration.
 *
 * Two scopes exist on purpose:
 *
 *  - `env`       -> `NEXT_PUBLIC_*` values. Safe to import from Client Components.
 *  - `serverEnv` -> adds server-only secrets behind `server-only`. Importing it
 *                   from a Client Component is a build error, which is what keeps
 *                   `SUPABASE_SERVICE_ROLE_KEY` out of browser bundles.
 *
 * Consumers should import from `./env` (public) or `./env.server` (server only).
 */

/** Keys the browser is allowed to see. */
export const publicEnvSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
  NEXT_PUBLIC_SITE_URL: z.url().default("http://localhost:3000"),
});

/** Server-only additions. Never prefix these with `NEXT_PUBLIC_`. */
export const serverEnvSchema = publicEnvSchema.extend({
  SUPABASE_SERVICE_ROLE_KEY: z.preprocess(
    (value) => (value === "" ? undefined : value),
    z.string().min(1).optional(),
  ),
  JUDGE_PROVIDER: z.enum(["local", "judge0"]).default("local"),
  JUDGE0_BASE_URL: z.preprocess(
    (value) => (value === "" ? undefined : value),
    z.url().optional(),
  ),
  JUDGE0_API_KEY: z.preprocess(
    (value) => (value === "" ? undefined : value),
    z.string().min(1).optional(),
  ),
  PYTHON_EXECUTABLE: z.string().min(1).default("python3"),
  JUDGE_TIMEOUT_MS: z.coerce.number().int().min(1000).max(120000).default(15000),
});

export type PublicEnv = z.infer<typeof publicEnvSchema>;
export type ServerEnv = z.infer<typeof serverEnvSchema>;

type Issue = { path: PropertyKey[]; message: string };

function formatError(scope: string, issues: readonly Issue[]): string {
  const details = issues
    .map((issue) => {
      const key = issue.path.length > 0 ? issue.path.join(".") : "(root)";
      return `  - ${key}: ${issue.message}`;
    })
    .join("\n");
  return (
    `[环境变量] ${scope} 配置无效：\n${details}\n` +
    "请将 `.env.example` 复制为 `.env.local`，并填写 Supabase 凭据。"
  );
}

/**
 * Validate an environment source against `schema`.
 *
 * In production a missing/invalid variable aborts immediately with a readable
 * message — a half-configured deploy is worse than a failed boot. Outside
 * production we warn once and fall back so `pnpm dev` still starts on a fresh
 * clone (Supabase calls then fail with their own error).
 */
export function parseEnv<S extends z.ZodType>(
  schema: S,
  scope: string,
  fallback: z.output<S>,
  source: unknown = process.env,
): z.output<S> {
  const result = schema.safeParse(source);

  if (result.success) {
    return result.data as z.output<S>;
  }

  const message = formatError(scope, result.error.issues as readonly Issue[]);

  if (process.env.NODE_ENV === "production") {
    throw new Error(message);
  }

  console.warn(`${message}\n[环境变量] 将使用 ${scope} 的占位配置继续运行。`);
  return fallback;
}

export const PUBLIC_FALLBACK: PublicEnv = {
  // `.invalid` is a reserved TLD (RFC 2606): DNS fails instantly and it can
  // never collide with a real project URL, including local ones on :54321.
  NEXT_PUBLIC_SUPABASE_URL: "http://supabase-placeholder.invalid",
  NEXT_PUBLIC_SUPABASE_ANON_KEY: "missing-anon-key",
  NEXT_PUBLIC_SITE_URL: "http://localhost:3000",
};

export const SERVER_FALLBACK: ServerEnv = {
  ...PUBLIC_FALLBACK,
  JUDGE_PROVIDER: "local",
  PYTHON_EXECUTABLE: "python3",
  JUDGE_TIMEOUT_MS: 15000,
};

export function parsePublicEnv(): PublicEnv {
  // Next.js only inlines statically referenced NEXT_PUBLIC_* variables into the
  // browser bundle. Passing process.env directly (or using a dynamic key) leaves
  // these values undefined in Client Components.
  return parseEnv(publicEnvSchema, "public", PUBLIC_FALLBACK, {
    NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
    NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL,
  });
}

export function parseServerEnv(): ServerEnv {
  return parseEnv(serverEnvSchema, "server", SERVER_FALLBACK);
}
