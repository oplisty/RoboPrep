import type { Json } from "@/types/database";
import type {
  KnowledgeQuestionDetail,
  KnowledgeQuestionSummary,
  KnowledgeSourceMeta,
  KnowledgeStats,
  KnowledgeTopic,
  KnowledgeTopicNode,
  QuestionOccurrence,
} from "@/types/knowledge";
import type { Interview, Topic } from "@/types/database";

import type { QuestionWithStatsRow } from "./rows";

/** Normalise raw database rows into Knowledge domain types (Week 2 Task 2). */

/** jsonb bullet lists arrive as arbitrary JSON; narrow defensively. */
export function toStringList(value: Json | null | undefined): string[] {
  if (!Array.isArray(value)) return [];
  return value.filter((item): item is string => typeof item === "string");
}

/** Narrow the source_meta jsonb blob into the UI contract, defensively. */
export function toSourceMeta(value: Json | null | undefined): KnowledgeSourceMeta | null {
  if (!value || typeof value !== "object" || Array.isArray(value)) return null;
  return value as KnowledgeSourceMeta;
}

export function mapStats(row: {
  interview_count: number | null;
  company_count: number | null;
  trend_score: number | null;
  last_seen_at: string | null;
}): KnowledgeStats | null {
  const { interview_count, company_count, trend_score, last_seen_at } = row;
  if (
    interview_count === null &&
    company_count === null &&
    trend_score === null &&
    last_seen_at === null
  ) {
    return null;
  }
  return {
    interviewCount: interview_count ?? 0,
    companyCount: company_count ?? 0,
    trendScore: trend_score ?? 0,
    lastSeenAt: last_seen_at,
  };
}

/** Row of the `questions_with_stats` view. */
export function mapQuestionSummary(
  row: QuestionWithStatsRow,
  topics: KnowledgeQuestionSummary["topics"],
): KnowledgeQuestionSummary {
  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    questionType: row.question_type,
    difficulty: row.difficulty,
    summary: row.summary,
    topics,
    estimatedMinutes: row.estimated_minutes,
    isFeatured: row.is_featured,
    stats: mapStats(row),
    sourceFreq: row.source_freq ?? null,
  };
}

export function mapQuestionDetail(
  row: QuestionWithStatsRow,
  topics: KnowledgeQuestionSummary["topics"],
): KnowledgeQuestionDetail {
  return {
    ...mapQuestionSummary(row, topics),
    shortAnswer: row.short_answer,
    canonicalAnswer: row.canonical_answer,
    deepAnswer: row.deep_answer,
    keyPoints: toStringList(row.key_points),
    commonMistakes: toStringList(row.common_mistakes),
    interviewTips: toStringList(row.interview_tips),
    sourceMeta: toSourceMeta(row.source_meta),
  };
}

export function mapTopic(
  row: Pick<Topic, "id" | "name" | "slug" | "parent_id" | "description">,
  questionCount: number | null = null,
): KnowledgeTopic {
  return {
    id: row.id,
    name: row.name,
    slug: row.slug,
    parentId: row.parent_id,
    description: row.description,
    questionCount,
  };
}

/**
 * Build the topic tree from a flat parent-before-child list.
 *
 * Guarded against malformed data: unknown parents, cycles and excessive depth
 * cannot produce infinite recursion because every topic is visited once.
 */
export function buildTopicTree(
  topics: KnowledgeTopic[],
  maxDepth = 8,
): KnowledgeTopicNode[] {
  const byId = new Map(topics.map((topic) => [topic.id, topic]));
  const childrenOf = new Map<string, KnowledgeTopic[]>();
  const roots: KnowledgeTopic[] = [];

  for (const topic of topics) {
    const parent = topic.parentId ? byId.get(topic.parentId) : undefined;
    if (!parent || parent.id === topic.id) {
      roots.push(topic);
      continue;
    }
    const siblings = childrenOf.get(parent.id) ?? [];
    siblings.push(topic);
    childrenOf.set(parent.id, siblings);
  }

  function build(topic: KnowledgeTopic, depth: number): KnowledgeTopicNode {
    if (depth >= maxDepth) {
      return { topic, children: [] };
    }
    const children = (childrenOf.get(topic.id) ?? []).map((child) =>
      build(child, depth + 1),
    );
    return { topic, children };
  }

  return roots.map((root) => build(root, 1));
}

/** All descendant topic ids (excluding the topic itself), cycle-safe. */
export function descendantTopicIds(
  topics: Pick<KnowledgeTopic, "id" | "parentId">[],
  rootId: string,
): string[] {
  const childrenOf = new Map<string, string[]>();
  for (const topic of topics) {
    if (!topic.parentId || topic.parentId === topic.id) continue;
    const siblings = childrenOf.get(topic.parentId) ?? [];
    siblings.push(topic.id);
    childrenOf.set(topic.parentId, siblings);
  }

  const result: string[] = [];
  const queue = [...(childrenOf.get(rootId) ?? [])];
  const seen = new Set<string>([rootId]);

  while (queue.length > 0) {
    const id = queue.shift();
    if (!id || seen.has(id)) continue;
    seen.add(id);
    result.push(id);
    for (const child of childrenOf.get(id) ?? []) {
      if (!seen.has(child)) queue.push(child);
    }
  }

  return result;
}

export interface OccurrenceRow {
  interview: Interview;
  interviewSlug?: string | null;
  position: { id: string; title: string } | null;
  company: { id: string; name: string; slug: string } | null;
  originalWording: string | null;
  roundNumber?: number | null;
  roundTitle?: string | null;
}

export function mapOccurrence(row: OccurrenceRow): QuestionOccurrence {
  const interview = row.interview;
  return {
    interviewId: interview.id,
    interviewSlug: row.interviewSlug ?? interview.slug ?? null,
    companyName: row.company?.name ?? null,
    companySlug: row.company?.slug ?? null,
    positionTitle: row.position?.title ?? null,
    year: interview.year,
    season: interview.season,
    interviewType: interview.interview_type,
    location: interview.location,
    roundNumber: row.roundNumber ?? null,
    roundTitle: row.roundTitle ?? null,
    originalWording: row.originalWording,
  };
}

/** Human reading-time hint derived from the content itself when unplanned. */
export function estimateReadingMinutes(detail: {
  estimatedMinutes: number | null;
  deepAnswer: string | null;
  canonicalAnswer: string | null;
}): number | null {
  if (detail.estimatedMinutes && detail.estimatedMinutes > 0) {
    return detail.estimatedMinutes;
  }
  const words = `${detail.deepAnswer ?? ""} ${detail.canonicalAnswer ?? ""}`
    .split(/\s+/)
    .filter(Boolean).length;
  if (words === 0) return null;
  return Math.max(1, Math.round(words / 200));
}
