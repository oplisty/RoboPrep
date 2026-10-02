import Link from "next/link";
import { ArrowRight, BookOpen, Code2, MessagesSquare } from "lucide-react";

import { Container } from "@/components/layout/container";
import { Badge } from "@/components/ui/badge";
import { buttonVariants } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import {
  getPublishedInterviews,
  getRecentQuestions,
  getTopics,
} from "@/lib/data/queries";
import { displayEnum, displaySeason } from "@/lib/interviews/helpers";

const pillars = [
  {
    href: "/interviews",
    icon: MessagesSquare,
    title: "真实面试",
    description: "按公司、岗位和年份整理面试经历，保留候选人实际被问到的原话。",
  },
  {
    href: "/knowledge",
    icon: BookOpen,
    title: "知识库",
    description: "整理具身智能高频知识题，提供快速回答、深入讲解以及面试官常见追问。",
  },
  {
    href: "/coding",
    icon: Code2,
    title: "Coding",
    description:
      "围绕真实约束设计机器人和 ML 练习，覆盖运动学、控制循环、批处理与推理预算。",
  },
];

export default async function HomePage({
  searchParams,
}: {
  searchParams: Promise<{ confirmed?: string }>;
}) {
  const [interviews, topics, questions, { confirmed }] = await Promise.all([
    getPublishedInterviews(3),
    getTopics(),
    getRecentQuestions(4),
    searchParams,
  ]);

  const rootTopics = topics.filter((topic) => topic.parent_id === null);

  return (
    <>
      {/* Hero */}
      <section className="border-line-subtle bg-surface border-b">
        <Container className="flex flex-col items-center gap-6 py-24 text-center sm:py-32">
          <p className="text-accent text-[0.9375rem] font-semibold tracking-[-0.01em]">
            RoboPrep
          </p>
          <h1 className="text-display text-ink max-w-3xl font-semibold">
            掌握具身智能面试。
            <br />
            一次一题，稳步提升。
          </h1>
          <p className="text-ink-secondary max-w-xl text-[1.0625rem] leading-relaxed">
            真实面试经历、核心知识与 Coding 练习，助你准备具身智能岗位。
          </p>
          {confirmed === "1" ? (
            <p
              role="status"
              className="border-success/30 bg-success/10 text-success-ink rounded-lg border px-4 py-2 text-sm"
            >
              ✅ 邮箱确认成功，已自动登录，开始练习吧！
            </p>
          ) : null}
          <div className="mt-2 flex flex-col gap-3 sm:flex-row">
            <Link href="/knowledge" className={buttonVariants({ size: "lg" })}>
              开始练习
            </Link>
            <Link
              href="/interviews"
              className={buttonVariants({ variant: "secondary", size: "lg" })}
            >
              浏览面试
            </Link>
          </div>
        </Container>
      </section>

      {/* Product pillars */}
      <section>
        <Container className="grid gap-5 py-20 sm:grid-cols-3">
          {pillars.map((pillar) => (
            <Card key={pillar.href} className="hover:shadow-raised transition-shadow">
              <CardHeader>
                <span className="bg-accent-soft text-accent mb-2 flex size-9 items-center justify-center rounded-sm">
                  <pillar.icon className="size-5" aria-hidden />
                </span>
                <CardTitle>{pillar.title}</CardTitle>
              </CardHeader>
              <CardContent className="flex flex-col gap-4">
                <p className="text-ink-secondary text-sm leading-relaxed">
                  {pillar.description}
                </p>
                <Link
                  href={pillar.href}
                  className="text-accent inline-flex items-center gap-1 text-sm font-medium hover:underline"
                >
                  查看{pillar.title}
                  <ArrowRight className="size-3.5" aria-hidden />
                </Link>
              </CardContent>
            </Card>
          ))}
        </Container>
      </section>

      {/* Latest interviews */}
      <section className="border-line-subtle border-t">
        <Container className="py-20">
          <div className="mb-8 flex items-end justify-between gap-4">
            <div className="flex flex-col gap-1">
              <h2 className="text-title text-ink font-semibold tracking-[-0.02em]">
                最新面试
              </h2>
              <p className="text-ink-secondary text-sm">最近发布的候选人面经。</p>
            </div>
            <Link
              href="/interviews"
              className="text-accent shrink-0 text-sm font-medium hover:underline"
            >
              查看全部
            </Link>
          </div>

          {interviews.length === 0 ? (
            <EmptyState
              icon={MessagesSquare}
              title="暂时还没有已发布的面试"
              description="面试经历通过审核并发布后，会显示在这里。"
            />
          ) : (
            <ul className="grid gap-4 sm:grid-cols-3">
              {interviews.map((interview) => (
                <li key={interview.id}>
                  <Card className="h-full">
                    <CardHeader>
                      <div className="text-ink-tertiary flex items-center gap-2 text-xs">
                        <span>{interview.companyName ?? "未知公司"}</span>
                        <span aria-hidden>·</span>
                        <span>{interview.year}</span>
                      </div>
                      <CardTitle>
                        {displayEnum(interview.interview_type) ?? "面试"}
                        {interview.location ? ` · ${interview.location}` : ""}
                      </CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="flex flex-wrap gap-2">
                        {interview.season ? (
                          <Badge variant="default">
                            {displaySeason(interview.season) ?? "未注明季节"}
                          </Badge>
                        ) : null}
                        <Badge variant="status" tone="published">
                          已发布
                        </Badge>
                      </div>
                    </CardContent>
                  </Card>
                </li>
              ))}
            </ul>
          )}
        </Container>
      </section>

      {/* Knowledge categories */}
      <section className="border-line-subtle bg-surface border-t">
        <Container className="py-20">
          <div className="mb-8 flex flex-col gap-1">
            <h2 className="text-title text-ink font-semibold tracking-[-0.02em]">
              知识分类
            </h2>
            <p className="text-ink-secondary text-sm">
              从一个主题开始，逐步练习相关问题。
            </p>
          </div>

          {rootTopics.length === 0 ? (
            <EmptyState
              icon={BookOpen}
              title="暂时还没有主题"
              description="主题会随着知识题一起创建和归类。"
            />
          ) : (
            <ul className="flex flex-wrap gap-2">
              {rootTopics.map((topic) => (
                <li key={topic.id}>
                  <Link href="/knowledge">
                    <Badge
                      variant="topic"
                      className="hover:bg-accent/15 px-3 py-1.5 text-sm transition-colors"
                    >
                      {topic.name}
                    </Badge>
                  </Link>
                </li>
              ))}
            </ul>
          )}

          {questions.length > 0 ? (
            <ul className="mt-10 grid gap-3 sm:grid-cols-2">
              {questions.map((question) => (
                <li key={question.id}>
                  <Link
                    href="/knowledge"
                    className="text-ink hover:text-accent block rounded-sm px-1 py-2 text-sm transition-colors"
                  >
                    {question.title}
                  </Link>
                </li>
              ))}
            </ul>
          ) : null}
        </Container>
      </section>

      {/* Coding preview */}
      <section className="border-line-subtle border-t">
        <Container className="py-20">
          <div className="max-w-2xl">
            <p className="text-ink-tertiary text-xs font-semibold tracking-wide uppercase">
              即将推出
            </p>
            <h2 className="text-title text-ink mt-2 font-semibold tracking-[-0.02em]">
              Coding
            </h2>
            <p className="text-ink-secondary mt-3 text-[0.9375rem] leading-relaxed">
              围绕真实机器人和 ML 约束设计的 LeetCode 风格练习：包括 SE(3)
              变换、批量控制循环、动作分块缓冲区与推理延迟预算。
            </p>
            <Link
              href="/coding"
              className={`mt-6 ${buttonVariants({ variant: "secondary" })}`}
            >
              查看 Coding 路线图
            </Link>
          </div>
        </Container>
      </section>
    </>
  );
}
