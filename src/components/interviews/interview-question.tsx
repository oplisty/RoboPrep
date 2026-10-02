import Link from "next/link";
import { ArrowUpRight, Link2Off } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { displayEnum } from "@/lib/interviews/helpers";
import { renderMathHtml } from "@/lib/math-text";
import type { InterviewQuestionOccurrence } from "@/types/interview";

export function InterviewQuestion({
  question,
}: {
  question: InterviewQuestionOccurrence;
}) {
  const original = question.originalWording?.trim() || null;
  const canonical = question.canonicalQuestion;
  const sameWording =
    !!original &&
    !!canonical &&
    original.toLowerCase() === canonical.title.toLowerCase();
  return (
    <article className="border-line-subtle flex gap-4 border-t py-5 first:border-t-0">
      <span className="text-ink-tertiary mt-0.5 w-7 shrink-0 font-mono text-xs tabular-nums">
        {String(question.orderIndex || 1).padStart(2, "0")}
      </span>
      <div className="min-w-0 flex-1">
        {original ? (
          <p className="text-ink text-[0.9375rem] leading-7">{original}</p>
        ) : (
          <p className="text-ink-secondary text-sm italic">未记录原始提问。</p>
        )}
        {canonical && !sameWording ? (
          <p className="text-ink-secondary mt-3 text-sm">
            <span className="text-ink-tertiary mr-2 text-xs font-semibold tracking-wide uppercase">
              标准问题
            </span>
            {canonical.title}
          </p>
        ) : null}
        {question.questionContext ? (
          <p className="text-ink-secondary mt-3 text-sm leading-relaxed">
            {question.questionContext}
          </p>
        ) : null}
        {question.notes ? (
          <p className="text-ink-tertiary mt-2 text-xs leading-relaxed">
            备注：{question.notes}
          </p>
        ) : null}
        <div className="mt-3 flex flex-wrap items-center gap-2">
          {question.difficulty ? (
            <Badge variant="difficulty" tone={question.difficulty}>
              {displayEnum(question.difficulty)}
            </Badge>
          ) : null}
          {canonical?.topics.slice(0, 3).map((topic) => (
            <Link
              key={topic.slug}
              href={`/knowledge?topic=${encodeURIComponent(topic.slug)}`}
            >
              <Badge variant="topic" className="hover:underline">
                {topic.name}
              </Badge>
            </Link>
          ))}
          {canonical ? (
            <Link
              href={`/knowledge/${canonical.slug}`}
              className="text-accent hover:text-accent-hover ml-auto inline-flex items-center gap-1 text-sm font-medium"
            >
              查看知识库答案
              <ArrowUpRight className="size-3.5" aria-hidden />
            </Link>
          ) : (
            <span className="text-ink-tertiary inline-flex items-center gap-1 text-xs">
              <Link2Off className="size-3.5" aria-hidden />
              尚未关联知识库答案
            </span>
          )}
        </div>
        {question.answerSummary ? (
          <p
            className="text-ink-secondary mt-3 text-sm leading-relaxed"
            dangerouslySetInnerHTML={{ __html: renderMathHtml(question.answerSummary) }}
          />
        ) : null}
      </div>
    </article>
  );
}
