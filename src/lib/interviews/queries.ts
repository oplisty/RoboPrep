import "server-only";

import { isSupabaseConfigured } from "@/lib/env";
import { createClient } from "@/lib/supabase/server";
import type {
  Interview,
  InterviewQuestion,
  InterviewRound as InterviewRoundRow,
  Position,
} from "@/types/database";
import type {
  InterviewDetail,
  InterviewFilters,
  InterviewQuestionOccurrence,
  InterviewRound,
  InterviewSort,
  InterviewSummary,
  InterviewTopicSummary,
  PaginatedInterviews,
  RelatedInterview,
} from "@/types/interview";
import type { KnowledgeQuestionSummary } from "@/types/knowledge";

import { INTERVIEW_PAGE_SIZE } from "./constants";
import { groupQuestionsByRound, rankRelatedInterviews, sortInterviewSummaries } from "./helpers";
import {
  mapInterviewQuestion,
  mapInterviewRound,
  mapInterviewSummary,
  mapInterviewTopicSummary,
} from "./mappers";

type CompanyRow = { id: string; name: string; slug: string };
type PositionRow = Pick<Position, "id" | "company_id" | "title" | "slug" | "category">;
type InterviewQuestionWithRound = InterviewQuestion;

function warn(context: string, error: { message: string }) {
  console.warn(`[interviews] ${context} failed: ${error.message}`);
}

function emptyPage(page: number, pageSize: number): PaginatedInterviews {
  return { items: [], page, pageSize, total: 0, totalPages: 1 };
}

function toIlikePattern(query: string): string {
  const cleaned = query
    .replace(/[%_,().\\]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
  return cleaned ? `%${cleaned}%` : "";
}

async function matchingInterviewIds(
  supabase: Awaited<ReturnType<typeof createClient>>,
  search: string,
): Promise<string[]> {
  const pattern = toIlikePattern(search);
  if (!pattern) return [];

  const [interviews, companies, positions, questionLinks, rounds, questions] =
    await Promise.all([
      supabase
        .from("interviews")
        .select("id")
        .eq("status", "published")
        .or(
          `title.ilike.${pattern},summary.ilike.${pattern},interview_type.ilike.${pattern},location.ilike.${pattern}`,
        ),
      supabase.from("companies").select("id").or(`name.ilike.${pattern},slug.ilike.${pattern}`),
      supabase
        .from("positions")
        .select("id")
        .or(`title.ilike.${pattern},category.ilike.${pattern}`),
      supabase
        .from("interview_questions")
        .select("interview_id")
        .ilike("original_wording", pattern),
      supabase
        .from("interview_rounds")
        .select("interview_id")
        .ilike("summary", pattern),
      supabase
        .from("questions")
        .select("id")
        .eq("is_published", true)
        .or(`title.ilike.${pattern},summary.ilike.${pattern}`),
    ]);

  const ids = new Set<string>((interviews.data ?? []).map((row) => row.id));
  const companyIds = (companies.data ?? []).map((row) => row.id);
  const positionIds = (positions.data ?? []).map((row) => row.id);
  const questionIds = (questions.data ?? []).map((row) => row.id);

  const [companyMatches, positionMatches, questionMatches] = await Promise.all([
    companyIds.length
      ? supabase
          .from("interviews")
          .select("id")
          .eq("status", "published")
          .in("company_id", companyIds)
      : Promise.resolve({ data: [], error: null }),
    positionIds.length
      ? supabase
          .from("interviews")
          .select("id")
          .eq("status", "published")
          .in("position_id", positionIds)
      : Promise.resolve({ data: [], error: null }),
    questionIds.length
      ? supabase
          .from("interview_questions")
          .select("interview_id")
          .in("question_id", questionIds)
      : Promise.resolve({ data: [], error: null }),
  ]);

  for (const row of companyMatches.data ?? []) ids.add(row.id);
  for (const row of positionMatches.data ?? []) ids.add(row.id);
  for (const row of questionMatches.data ?? []) ids.add(row.interview_id);
  for (const row of questionLinks.data ?? []) ids.add(row.interview_id);
  for (const row of rounds.data ?? []) ids.add(row.interview_id);
  return [...ids];
}

async function getCompanyMap(
  supabase: Awaited<ReturnType<typeof createClient>>,
  ids: string[],
): Promise<Map<string, CompanyRow>> {
  if (ids.length === 0) return new Map();
  const { data, error } = await supabase
    .from("companies")
    .select("id, name, slug")
    .in("id", ids);
  if (error) warn("companies", error);
  return new Map((data ?? []).map((row) => [row.id, row]));
}

async function getPositionMap(
  supabase: Awaited<ReturnType<typeof createClient>>,
  ids: string[],
): Promise<Map<string, PositionRow>> {
  if (ids.length === 0) return new Map();
  const { data, error } = await supabase
    .from("positions")
    .select("id, company_id, title, slug, category")
    .in("id", ids);
  if (error) warn("positions", error);
  return new Map((data ?? []).map((row) => [row.id, row]));
}

interface InterviewSupport {
  rounds: InterviewRoundRow[];
  questions: InterviewQuestionWithRound[];
  tags: string[];
  questionTypes: Map<string, string>;
  topicByQuestion: Map<string, Array<{ name: string; slug: string }>>;
}

async function getInterviewSupport(
  supabase: Awaited<ReturnType<typeof createClient>>,
  interviews: Interview[],
): Promise<Map<string, InterviewSupport>> {
  const result = new Map<string, InterviewSupport>();
  if (interviews.length === 0) return result;
  const interviewIds = interviews.map((interview) => interview.id);

  const [roundsResult, questionsResult, tagsResult] = await Promise.all([
    supabase
      .from("interview_rounds")
      .select("*")
      .in("interview_id", interviewIds)
      .order("round_number"),
    supabase
      .from("interview_questions")
      .select("*")
      .in("interview_id", interviewIds)
      .order("round_number")
      .order("order_index"),
    supabase.from("interview_tags").select("interview_id, tag").in("interview_id", interviewIds),
  ]);

  if (roundsResult.error) warn("support/rounds", roundsResult.error);
  if (questionsResult.error) warn("support/questions", questionsResult.error);
  if (tagsResult.error) warn("support/tags", tagsResult.error);

  const questions = questionsResult.data ?? [];
  const questionIds = [
    ...new Set(
      questions
        .map((question) => question.question_id)
        .filter((id): id is string => id !== null),
    ),
  ];
  const [questionTypesResult, topicLinksResult] = await Promise.all([
    questionIds.length
      ? supabase.from("questions").select("id, question_type").in("id", questionIds)
      : Promise.resolve({ data: [], error: null }),
    questionIds.length
      ? supabase.from("question_topics").select("question_id, topic_id").in("question_id", questionIds)
      : Promise.resolve({ data: [], error: null }),
  ]);
  if (questionTypesResult.error) warn("support/question types", questionTypesResult.error);
  if (topicLinksResult.error) warn("support/topic links", topicLinksResult.error);

  const topicIds = [...new Set((topicLinksResult.data ?? []).map((row) => row.topic_id))];
  const { data: topics, error: topicsError } = topicIds.length
    ? await supabase.from("topics").select("id, name, slug").in("id", topicIds)
    : { data: [], error: null };
  if (topicsError) warn("support/topics", topicsError);
  const topicById = new Map((topics ?? []).map((topic) => [topic.id, topic]));
  const topicByQuestion = new Map<string, Array<{ name: string; slug: string }>>();
  for (const link of topicLinksResult.data ?? []) {
    const topic = topicById.get(link.topic_id);
    if (!topic) continue;
    const entries = topicByQuestion.get(link.question_id) ?? [];
    entries.push({ name: topic.name, slug: topic.slug });
    topicByQuestion.set(link.question_id, entries);
  }

  const questionTypes = new Map(
    (questionTypesResult.data ?? []).map((row) => [row.id, row.question_type]),
  );
  for (const interview of interviews) {
    result.set(interview.id, {
      rounds: (roundsResult.data ?? []).filter((round) => round.interview_id === interview.id),
      questions: questions.filter((question) => question.interview_id === interview.id),
      tags: (tagsResult.data ?? [])
        .filter((tag) => tag.interview_id === interview.id)
        .map((tag) => tag.tag),
      questionTypes,
      topicByQuestion,
    });
  }
  return result;
}

async function hydrateSummaries(
  supabase: Awaited<ReturnType<typeof createClient>>,
  interviews: Interview[],
): Promise<InterviewSummary[]> {
  if (interviews.length === 0) return [];
  const companyMap = await getCompanyMap(
    supabase,
    [...new Set(interviews.map((interview) => interview.company_id))],
  );
  const positionMap = await getPositionMap(
    supabase,
    [
      ...new Set(
        interviews
          .map((interview) => interview.position_id)
          .filter((id): id is string => id !== null),
      ),
    ],
  );
  const supportMap = await getInterviewSupport(supabase, interviews);

  return interviews.map((interview) => {
    const support = supportMap.get(interview.id) ?? {
      rounds: [],
      questions: [],
      tags: [],
      questionTypes: new Map<string, string>(),
      topicByQuestion: new Map<string, Array<{ name: string; slug: string }>>(),
    };
    const topics = support.questions.flatMap(
      (question) =>
        question.question_id
          ? support.topicByQuestion.get(question.question_id) ?? []
          : [],
    );
    const roundNumbers = [
      ...support.rounds.map((round) => ({ roundNumber: round.round_number })),
      ...support.questions
        .filter((question) => question.round_number !== null)
        .map((question) => ({ roundNumber: question.round_number ?? 1 })),
    ];
    return mapInterviewSummary({
      interview,
      company: companyMap.get(interview.company_id) ?? null,
      position: interview.position_id
        ? positionMap.get(interview.position_id) ?? null
        : null,
      tags: support.tags,
      stats: {
        roundCount: new Set(roundNumbers.map((round) => round.roundNumber)).size || interview.round_count,
        questionCount: support.questions.length,
        linkedQuestionCount: support.questions.filter((question) => question.question_id !== null)
          .length,
        codingQuestionCount: support.questions.filter(
          (question) =>
            question.question_id !== null &&
            support.questionTypes.get(question.question_id) === "coding",
        ).length,
        topicCount: new Set(topics.map((topic) => topic.slug)).size,
      },
    });
  });
}

async function resolveCompanyId(
  supabase: Awaited<ReturnType<typeof createClient>>,
  slug: string,
): Promise<string | null> {
  const { data, error } = await supabase
    .from("companies")
    .select("id")
    .eq("slug", slug)
    .maybeSingle();
  if (error) warn("resolve company", error);
  return data?.id ?? null;
}

async function resolvePositionIds(
  supabase: Awaited<ReturnType<typeof createClient>>,
  slug: string,
  companyId?: string,
): Promise<string[]> {
  let query = supabase.from("positions").select("id").eq("slug", slug);
  if (companyId) query = query.eq("company_id", companyId);
  const { data, error } = await query;
  if (error) warn("resolve position", error);
  return (data ?? []).map((row) => row.id);
}

export async function getInterviews(options: {
  filters?: InterviewFilters;
  sort?: InterviewSort;
  page?: number;
  pageSize?: number;
} = {}): Promise<PaginatedInterviews> {
  const page = Math.max(1, options.page ?? 1);
  const pageSize = Math.min(50, Math.max(1, options.pageSize ?? INTERVIEW_PAGE_SIZE));
  const filters = options.filters ?? {};
  const sort = options.sort ?? "latest";
  if (!isSupabaseConfigured) return emptyPage(page, pageSize);

  const supabase = await createClient();
  let query = supabase
    .from("interviews")
    .select("*", { count: "exact" })
    .eq("status", "published");

  const companyId = filters.company
    ? await resolveCompanyId(supabase, filters.company)
    : null;
  if (filters.company && !companyId) return emptyPage(page, pageSize);
  if (companyId) query = query.eq("company_id", companyId);

  const positionIds = filters.position
    ? await resolvePositionIds(supabase, filters.position, companyId ?? undefined)
    : [];
  if (filters.position && positionIds.length === 0) return emptyPage(page, pageSize);
  if (positionIds.length) query = query.in("position_id", positionIds);

  if (filters.year) query = query.eq("year", filters.year);
  if (filters.season) query = query.ilike("season", filters.season);
  if (filters.experienceLevel) query = query.eq("experience_level", filters.experienceLevel);
  if (filters.employmentType) query = query.eq("employment_type", filters.employmentType);
  if (filters.difficulty) query = query.eq("difficulty_overall", filters.difficulty);

  if (filters.query) {
    const matchingIds = await matchingInterviewIds(supabase, filters.query);
    if (matchingIds.length === 0) return emptyPage(page, pageSize);
    query = query.in("id", matchingIds);
  }

  const needsMemorySort = sort !== "latest";
  if (!needsMemorySort) {
    query = query
      .order("published_at", { ascending: false, nullsFirst: false })
      .order("created_at", { ascending: false });
  }
  const { data, error, count } = needsMemorySort
    ? await query.range(0, Math.max(999, page * pageSize - 1))
    : await query.range((page - 1) * pageSize, page * pageSize - 1);
  if (error || !data) {
    if (error) warn("getInterviews", error);
    return emptyPage(page, pageSize);
  }

  const summaries = await hydrateSummaries(supabase, data);
  const ordered = sortInterviewSummaries(summaries, sort);
  const total = count ?? ordered.length;
  return {
    items: needsMemorySort
      ? ordered.slice((page - 1) * pageSize, page * pageSize)
      : ordered,
    page,
    pageSize,
    total,
    totalPages: Math.max(1, Math.ceil(total / pageSize)),
  };
}

async function getCanonicalQuestionSummaries(
  supabase: Awaited<ReturnType<typeof createClient>>,
  questionIds: string[],
): Promise<Map<string, KnowledgeQuestionSummary>> {
  const result = new Map<string, KnowledgeQuestionSummary>();
  if (questionIds.length === 0) return result;
  const { data, error } = await supabase
    .from("questions_with_stats")
    .select("*")
    .eq("is_published", true)
    .in("id", questionIds);
  if (error || !data) {
    if (error) warn("canonical questions", error);
    return result;
  }

  const { data: links, error: linksError } = await supabase
    .from("question_topics")
    .select("question_id, topic_id")
    .in("question_id", questionIds);
  if (linksError) warn("canonical question topics", linksError);
  const topicIds = [...new Set((links ?? []).map((link) => link.topic_id))];
  const { data: topics, error: topicsError } = topicIds.length
    ? await supabase.from("topics").select("id, name, slug").in("id", topicIds)
    : { data: [], error: null };
  if (topicsError) warn("canonical topics", topicsError);
  const topicById = new Map((topics ?? []).map((topic) => [topic.id, topic]));
  const topicsByQuestion = new Map<string, Array<{ name: string; slug: string }>>();
  for (const link of links ?? []) {
    const topic = topicById.get(link.topic_id);
    if (!topic) continue;
    const entries = topicsByQuestion.get(link.question_id) ?? [];
    entries.push({ name: topic.name, slug: topic.slug });
    topicsByQuestion.set(link.question_id, entries);
  }

  for (const row of data) {
    result.set(row.id, {
      id: row.id,
      slug: row.slug,
      title: row.title,
      questionType: row.question_type,
      difficulty: row.difficulty,
      summary: row.summary,
      topics: topicsByQuestion.get(row.id) ?? [],
      estimatedMinutes: row.estimated_minutes,
      isFeatured: row.is_featured,
      sourceFreq: row.source_freq ?? null,
      stats: {
        interviewCount: row.interview_count ?? 0,
        companyCount: row.company_count ?? 0,
        trendScore: row.trend_score ?? 0,
        lastSeenAt: row.last_seen_at,
      },
    });
  }
  return result;
}

export async function getInterviewBySlug(slug: string): Promise<InterviewDetail | null> {
  if (!isSupabaseConfigured) return null;
  const supabase = await createClient();
  const { data: interview, error } = await supabase
    .from("interviews")
    .select("*")
    .eq("slug", slug)
    .eq("status", "published")
    .maybeSingle();
  if (error) {
    warn("getInterviewBySlug", error);
    return null;
  }
  if (!interview) return null;

  const [companies, positions, roundsResult, questionsResult, tagsResult] = await Promise.all([
    supabase.from("companies").select("id, name, slug").eq("id", interview.company_id).maybeSingle(),
    interview.position_id
      ? supabase
          .from("positions")
          .select("id, company_id, title, slug, category")
          .eq("id", interview.position_id)
          .maybeSingle()
      : Promise.resolve({ data: null, error: null }),
    supabase
      .from("interview_rounds")
      .select("*")
      .eq("interview_id", interview.id)
      .order("round_number"),
    supabase
      .from("interview_questions")
      .select("*")
      .eq("interview_id", interview.id)
      .order("round_number")
      .order("order_index"),
    supabase.from("interview_tags").select("tag").eq("interview_id", interview.id),
  ]);
  if (companies.error) warn("detail/company", companies.error);
  if (positions.error) warn("detail/position", positions.error);
  if (roundsResult.error) warn("detail/rounds", roundsResult.error);
  if (questionsResult.error) warn("detail/questions", questionsResult.error);
  if (tagsResult.error) warn("detail/tags", tagsResult.error);

  const questionRows = questionsResult.data ?? [];
  const canonical = await getCanonicalQuestionSummaries(
    supabase,
    questionRows
      .map((row) => row.question_id)
      .filter((id): id is string => id !== null),
  );
  const occurrences = questionRows.map((row) =>
    mapInterviewQuestion(row, row.question_id ? canonical.get(row.question_id) ?? null : null),
  );
  const explicitRounds = (roundsResult.data ?? []).map(mapInterviewRound);
  const rounds = groupQuestionsByRound(occurrences, explicitRounds);
  const topicsBySlug = new Map<string, InterviewTopicSummary>();
  for (const question of canonical.values()) {
    for (const topic of question.topics) {
      const current = topicsBySlug.get(topic.slug);
      topicsBySlug.set(
        topic.slug,
        mapInterviewTopicSummary(
          topic.name,
          topic.slug,
          (current?.questionCount ?? 0) + 1,
        ),
      );
    }
  }
  const summary = mapInterviewSummary({
    interview,
    company: companies.data,
    position: positions.data,
    tags: (tagsResult.data ?? []).map((tag) => tag.tag),
    stats: {
      roundCount: rounds.length || interview.round_count,
      questionCount: occurrences.length,
      linkedQuestionCount: occurrences.filter((question) => question.questionId !== null).length,
      codingQuestionCount: occurrences.filter(
        (question) => question.canonicalQuestion?.questionType === "coding",
      ).length,
      topicCount: topicsBySlug.size,
    },
  });
  return {
    ...summary,
    rounds,
    topics: [...topicsBySlug.values()].sort(
      (a, b) => b.questionCount - a.questionCount || a.name.localeCompare(b.name),
    ),
  };
}

export async function getInterviewRounds(interviewId: string): Promise<InterviewRound[]> {
  if (!isSupabaseConfigured) return [];
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("interview_rounds")
    .select("*")
    .eq("interview_id", interviewId)
    .order("round_number");
  if (error) {
    warn("getInterviewRounds", error);
    return [];
  }
  return (data ?? []).map(mapInterviewRound);
}

export async function getInterviewQuestions(
  interviewId: string,
): Promise<InterviewQuestionOccurrence[]> {
  if (!isSupabaseConfigured) return [];
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("interview_questions")
    .select("*")
    .eq("interview_id", interviewId)
    .order("round_number")
    .order("order_index");
  if (error) {
    warn("getInterviewQuestions", error);
    return [];
  }
  const canonical = await getCanonicalQuestionSummaries(
    supabase,
    (data ?? [])
      .map((row) => row.question_id)
      .filter((id): id is string => id !== null),
  );
  return (data ?? []).map((row) =>
    mapInterviewQuestion(row, row.question_id ? canonical.get(row.question_id) ?? null : null),
  );
}

export async function getInterviewFilterOptions() {
  if (!isSupabaseConfigured) {
    return { companies: [], positions: [], years: [], seasons: [], difficulties: [] };
  }
  const supabase = await createClient();
  const { data: interviews, error } = await supabase
    .from("interviews")
    .select("company_id, position_id, year, season, difficulty_overall")
    .eq("status", "published");
  if (error || !interviews) {
    if (error) warn("getInterviewFilterOptions/interviews", error);
    return { companies: [], positions: [], years: [], seasons: [], difficulties: [] };
  }
  const companyIds = [...new Set(interviews.map((row) => row.company_id))];
  const positionIds = [
    ...new Set(
      interviews
        .map((row) => row.position_id)
        .filter((id): id is string => id !== null),
    ),
  ];
  const [companies, positions] = await Promise.all([
    getCompanyMap(supabase, companyIds),
    getPositionMap(supabase, positionIds),
  ]);
  const companyOptions = [...companies.values()]
    .map((company) => ({ name: company.name, slug: company.slug }))
    .sort((a, b) => a.name.localeCompare(b.name));
  const positionsById = [...positions.values()];
  const positionOptions = positionsById
    .map((position) => ({
      title: position.title,
      slug: position.slug,
      companySlug: companies.get(position.company_id)?.slug ?? null,
    }))
    .sort((a, b) => a.title.localeCompare(b.title));
  return {
    companies: companyOptions,
    positions: positionOptions,
    years: [...new Set(interviews.map((row) => row.year))].sort((a, b) => b - a),
    seasons: [...new Set(interviews.map((row) => row.season).filter((value): value is string => !!value))]
      .sort(),
    difficulties: [
      ...new Set(interviews.map((row) => row.difficulty_overall)),
    ].sort(),
  };
}

export async function getRelatedInterviews(
  interviewId: string,
  limit = 4,
): Promise<RelatedInterview[]> {
  if (!isSupabaseConfigured) return [];
  const supabase = await createClient();
  const { data: current, error } = await supabase
    .from("interviews")
    .select("*")
    .eq("id", interviewId)
    .eq("status", "published")
    .maybeSingle();
  if (error || !current) {
    if (error) warn("getRelatedInterviews/current", error);
    return [];
  }
  const { data: candidates, error: candidatesError } = await supabase
    .from("interviews")
    .select("*")
    .eq("status", "published")
    .neq("id", interviewId)
    .limit(100);
  if (candidatesError || !candidates) {
    if (candidatesError) warn("getRelatedInterviews/candidates", candidatesError);
    return [];
  }
  const all = await hydrateSummaries(supabase, [current, ...candidates]);
  const currentSummary = all.find((item) => item.id === current.id);
  if (!currentSummary) return [];
  const ranked = rankRelatedInterviews(
    currentSummary,
    all.filter((item) => item.id !== current.id),
  );
  return ranked.slice(0, limit).map((item) => {
    let score = 0;
    if (item.company?.id === currentSummary.company?.id) score += 8;
    if (item.position?.category && item.position.category === currentSummary.position?.category) {
      score += 4;
    }
    if (item.position?.id === currentSummary.position?.id) score += 3;
    if (item.year === currentSummary.year) score += 1;
    return { ...item, relationScore: score };
  });
}

export async function getRecentInterviews(limit = 6): Promise<InterviewSummary[]> {
  return (await getInterviews({ page: 1, pageSize: limit, sort: "latest" })).items;
}

export async function getInterviewCountByCompany(companyId: string): Promise<number> {
  if (!isSupabaseConfigured) return 0;
  const supabase = await createClient();
  const { count, error } = await supabase
    .from("interviews")
    .select("id", { count: "exact", head: true })
    .eq("company_id", companyId)
    .eq("status", "published");
  if (error) {
    warn("getInterviewCountByCompany", error);
    return 0;
  }
  return count ?? 0;
}

export type { InterviewQuestionWithRound };
