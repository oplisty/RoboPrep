import type { Difficulty, QuestionType, RelationType } from "./database";

/**
 * Knowledge domain types.
 *
 * These are the types the UI consumes. Raw Supabase rows (`src/types/database.ts`)
 * are normalised into these shapes in `src/lib/knowledge/mappers.ts`, so React
 * components never depend on anonymous query payloads or jsonb plumbing.
 */

export type KnowledgeSort = "recommended" | "most_asked" | "trending" | "newest";

export interface KnowledgeFilters {
  /** Free-text search across question titles, summaries and topic names. */
  query?: string;
  /** Topic slug. */
  topic?: string;
  difficulty?: Difficulty;
  questionType?: QuestionType;
  /** Company slug. */
  company?: string;
}

export interface KnowledgeTopicRef {
  name: string;
  slug: string;
}

/** Aggregate stats surfaced on cards and detail pages. */
export interface KnowledgeStats {
  interviewCount: number;
  companyCount: number;
  trendScore: number;
  lastSeenAt: string | null;
}

/** Card-shaped question used in lists and link sections. */
export interface KnowledgeQuestionSummary {
  id: string;
  slug: string;
  title: string;
  questionType: QuestionType;
  difficulty: Difficulty | null;
  summary: string | null;
  topics: KnowledgeTopicRef[];
  estimatedMinutes: number | null;
  isFeatured: boolean;
  stats: KnowledgeStats | null;
  /** 🔥×N — independent public interview reports per the imported external bank; null = unknown. */
  sourceFreq: number | null;
}

/** Full reading view of a canonical question. */
export interface KnowledgeQuestionDetail extends KnowledgeQuestionSummary {
  shortAnswer: string | null;
  canonicalAnswer: string | null;
  deepAnswer: string | null;
  keyPoints: string[];
  commonMistakes: string[];
  interviewTips: string[];
  /** Provenance for imported/enriched questions (repo, license, volume/section). */
  sourceMeta: KnowledgeSourceMeta | null;
}

/** Subset of the questions.source_meta jsonb contract used by the UI. */
export interface KnowledgeSourceMeta {
  source?: string;
  repo?: string;
  commit?: string;
  license?: string;
  volume_title?: string;
  section?: string;
  qid?: string;
  freq_label?: string;
  note?: string;
  merged_from?: string[];
  [key: string]: unknown;
}

export interface KnowledgeTopic {
  id: string;
  name: string;
  slug: string;
  parentId: string | null;
  description: string | null;
  /** Number of canonical published questions tagged with the topic. */
  questionCount: number | null;
}

export interface KnowledgeTopicDetail extends KnowledgeTopic {
  parent: KnowledgeTopic | null;
  children: KnowledgeTopic[];
}

/** One node in the rendered topic tree. */
export interface KnowledgeTopicNode {
  topic: KnowledgeTopic;
  children: KnowledgeTopicNode[];
}

export type QuestionRelationGroup = {
  relationType: RelationType;
  questions: KnowledgeQuestionSummary[];
};

/** Provenance: where this question was actually asked. */
export interface QuestionOccurrence {
  interviewId: string;
  interviewSlug: string | null;
  companyName: string | null;
  companySlug: string | null;
  positionTitle: string | null;
  year: number;
  season: string | null;
  interviewType: string | null;
  location: string | null;
  roundNumber: number | null;
  roundTitle: string | null;
  /** Exact wording the candidate reported, when it differs from the title. */
  originalWording: string | null;
}

export interface PaginatedResult<T> {
  items: T[];
  page: number;
  pageSize: number;
  total: number;
  totalPages: number;
}
