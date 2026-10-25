import type { Metadata } from "next";
import Link from "next/link";
import { BookOpen } from "lucide-react";

import { Container } from "@/components/layout/container";
import { PageHeader } from "@/components/layout/page-header";
import { Badge } from "@/components/ui/badge";
import { Button, buttonVariants } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Input } from "@/components/ui/input";
import { Pagination } from "@/components/ui/pagination";
import { getCompanies } from "@/lib/data/queries";
import {
  DIFFICULTY_LABELS,
  KNOWLEDGE_SORT_LABELS,
  QUESTION_TYPE_LABELS,
} from "@/lib/knowledge/constants";
import { filtersToQueryString, parseKnowledgeFilters } from "@/lib/knowledge/filters";
import { getKnowledgeQuestions, getKnowledgeTopics } from "@/lib/knowledge/queries";
import { renderInlineHtml } from "@/lib/answer-markdown";
import type { KnowledgeFilterParams } from "@/lib/knowledge/filters";

import "katex/dist/katex.min.css";

export const metadata: Metadata = {
  title: "知识库",
  description: "具身智能面试中的核心问题。",
};

export default async function KnowledgePage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const params = parseKnowledgeFilters(await searchParams);
  const [questions, topics, companies] = await Promise.all([
    getKnowledgeQuestions({ filters: params, page: params.page }),
    getKnowledgeTopics(),
    getCompanies(),
  ]);
  const companyOptions = companies
    .filter((company) => company.interviewCount > 0)
    .map((company) => ({ value: company.slug, label: company.name }));

  return (
    <Container className="py-14">
      <PageHeader
        title="知识库"
        description="为具身智能面试中反复出现的概念提供标准答案。"
      >
        <KnowledgeSearch params={params} />
      </PageHeader>

      <div className="mt-8 grid gap-10 lg:grid-cols-[minmax(0,1fr)_15rem]">
        <main className="min-w-0">
          <KnowledgeFilters
            params={params}
            companyOptions={companyOptions}
            topicOptions={topics.map((topic) => ({
              value: topic.slug,
              label: topic.name,
            }))}
          />
          <div className="mt-6 flex flex-wrap items-baseline justify-between gap-2">
            <h2 className="text-ink text-lg font-semibold tracking-[-0.01em]">问题</h2>
            <p className="text-ink-tertiary text-sm">共 {questions.total} 个问题</p>
          </div>

          {questions.items.length === 0 ? (
            <EmptyState
              className="mt-4"
              icon={BookOpen}
              title={
                questions.total === 0 ? "没有符合筛选条件的问题" : "这一页暂时没有问题"
              }
              description="清除筛选条件，或尝试其他搜索词、主题、公司或难度。"
              action={
                hasFilters(params) ? (
                  <Link
                    href="/knowledge"
                    className="text-accent hover:text-accent-hover text-sm font-medium"
                  >
                    清除筛选
                  </Link>
                ) : undefined
              }
            />
          ) : (
            <ul className="mt-4 grid gap-4 sm:grid-cols-2">
              {questions.items.map((question) => (
                <li key={question.id}>
                  <Link
                    href={`/knowledge/${question.slug}`}
                    className="group block h-full"
                  >
                    <Card className="group-hover:shadow-raised h-full transition-shadow">
                      <CardHeader>
                        <div className="flex flex-wrap items-center gap-2">
                          <Badge variant="default">
                            {QUESTION_TYPE_LABELS[question.questionType]}
                          </Badge>
                          {question.difficulty ? (
                            <Badge variant="difficulty" tone={question.difficulty}>
                              {DIFFICULTY_LABELS[question.difficulty]}
                            </Badge>
                          ) : null}
                          {question.sourceFreq != null && question.sourceFreq > 0 ? (
                            <Badge
                              variant="default"
                              className="bg-warning/15 text-warning-ink"
                              title={`在 ${question.sourceFreq} 份独立公开面经中出现过（外部题库统计口径）`}
                            >
                              🔥×{question.sourceFreq}
                            </Badge>
                          ) : null}
                        </div>
                        <CardTitle className="mt-2">{question.title}</CardTitle>
                      </CardHeader>
                      <CardContent className="flex flex-col gap-4">
                        {question.summary ? (
                          <p
                            className="text-ink-secondary line-clamp-3 text-sm leading-relaxed"
                            dangerouslySetInnerHTML={{ __html: renderInlineHtml(question.summary) }}
                          />
                        ) : null}
                        {question.topics.length > 0 ? (
                          <ul className="flex flex-wrap gap-2">
                            {question.topics.slice(0, 4).map((topic) => (
                              <li key={topic.slug}>
                                <Badge variant="topic">{topic.name}</Badge>
                              </li>
                            ))}
                          </ul>
                        ) : null}
                        {question.stats ? (
                          <p className="text-ink-tertiary mt-auto text-xs">
                            出现在 {question.stats.interviewCount} 条面试记录中
                          </p>
                        ) : null}
                      </CardContent>
                    </Card>
                  </Link>
                </li>
              ))}
            </ul>
          )}

          <div className="mt-8">
            <Pagination
              page={questions.page}
              totalPages={questions.totalPages}
              makeHref={(page) => `/knowledge${filtersToQueryString(params, { page })}`}
            />
          </div>
        </main>

        <aside className="min-w-0">
          <section
            aria-labelledby="knowledge-topics-heading"
            className="lg:sticky lg:top-20"
          >
            <h2
              id="knowledge-topics-heading"
              className="text-ink text-sm font-semibold tracking-wide uppercase"
            >
              浏览主题
            </h2>
            <ul className="mt-3 flex flex-wrap gap-2 lg:flex-col lg:items-start">
              {topics
                .filter((topic) => topic.questionCount !== 0)
                .slice(0, 18)
                .map((topic) => (
                  <li key={topic.id}>
                    <Link
                      href={`/knowledge?topic=${encodeURIComponent(topic.slug)}`}
                      className="text-ink-secondary hover:text-ink inline-flex items-center gap-2 text-sm"
                    >
                      <span>{topic.name}</span>
                      {topic.questionCount !== null ? (
                        <span className="text-ink-tertiary text-xs">
                          {topic.questionCount}
                        </span>
                      ) : null}
                    </Link>
                  </li>
                ))}
            </ul>
          </section>
        </aside>
      </div>
    </Container>
  );
}

function KnowledgeSearch({ params }: { params: KnowledgeFilterParams }) {
  return (
    <form action="/knowledge" method="get" className="flex w-full gap-2 sm:w-96">
      <Input
        name="q"
        defaultValue={params.q ?? ""}
        placeholder="搜索问题和主题…"
        aria-label="搜索知识库问题"
      />
      {hiddenSearchFields(params)}
      <Button type="submit" size="sm">
        搜索
      </Button>
    </form>
  );
}

function KnowledgeFilters({
  params,
  companyOptions,
  topicOptions,
}: {
  params: KnowledgeFilterParams;
  companyOptions: Array<{ value: string; label: string }>;
  topicOptions: Array<{ value: string; label: string }>;
}) {
  return (
    <div className="border-line-subtle bg-surface-muted rounded-md border p-4">
      <form
        action="/knowledge"
        method="get"
        className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4"
      >
        {params.q ? <input type="hidden" name="q" value={params.q} /> : null}
        <FilterSelect
          name="topic"
          label="主题"
          value={params.topic}
          options={topicOptions}
        />
        <FilterSelect
          name="difficulty"
          label="难度"
          value={params.difficulty}
          options={Object.entries(DIFFICULTY_LABELS).map(([value, label]) => ({
            value,
            label,
          }))}
        />
        <FilterSelect
          name="type"
          label="问题类型"
          value={params.type}
          options={Object.entries(QUESTION_TYPE_LABELS).map(([value, label]) => ({
            value,
            label,
          }))}
        />
        <FilterSelect
          name="company"
          label="公司"
          value={params.company}
          options={companyOptions}
        />
        <FilterSelect
          name="sort"
          label="排序"
          value={params.sort}
          options={Object.entries(KNOWLEDGE_SORT_LABELS).map(([value, label]) => ({
            value,
            label,
          }))}
        />
        <div className="flex items-end gap-2 sm:col-span-2 lg:col-span-4">
          <Button type="submit" size="sm">
            应用筛选
          </Button>
          <Link
            href="/knowledge"
            className={buttonVariants({ variant: "ghost", size: "sm" })}
          >
            全部清除
          </Link>
        </div>
      </form>
      {params.topic ? (
        <p className="text-ink-tertiary mt-3 text-xs">
          当前主题：<span className="text-ink-secondary">{params.topic}</span>
        </p>
      ) : null}
    </div>
  );
}

function FilterSelect({
  name,
  label,
  value,
  options,
}: {
  name: string;
  label: string;
  value?: string;
  options: Array<{ value: string; label: string }>;
}) {
  return (
    <label className="flex flex-col gap-1.5">
      <span className="text-ink-secondary text-xs font-medium">{label}</span>
      <select
        name={name}
        defaultValue={value ?? ""}
        className="bg-surface text-ink border-line focus:outline-accent h-10 rounded-sm border px-3 text-sm focus:outline-2"
      >
        <option value="">全部</option>
        {options.map((option) => (
          <option key={`${name}-${option.value}`} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
    </label>
  );
}

function hiddenSearchFields(params: KnowledgeFilterParams) {
  return (
    <>
      {params.topic ? <input type="hidden" name="topic" value={params.topic} /> : null}
      {params.difficulty ? (
        <input type="hidden" name="difficulty" value={params.difficulty} />
      ) : null}
      {params.type ? <input type="hidden" name="type" value={params.type} /> : null}
      {params.company ? (
        <input type="hidden" name="company" value={params.company} />
      ) : null}
      {params.sort !== "recommended" ? (
        <input type="hidden" name="sort" value={params.sort} />
      ) : null}
    </>
  );
}

function hasFilters(params: KnowledgeFilterParams): boolean {
  return Boolean(
    params.q ||
    params.topic ||
    params.difficulty ||
    params.type ||
    params.company ||
    params.sort !== "recommended" ||
    params.page > 1,
  );
}
