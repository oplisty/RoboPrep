/**
 * Hand-maintained mirror of the current Supabase schema (`0001`–`0023`).
 *
 * Once the project is linked to a real Supabase project this file should be
 * replaced by generated types:
 *
 *   pnpm supabase gen types typescript --local > src/types/database.ts
 */

export type Json =
  string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type InterviewStatus = "draft" | "review" | "published" | "rejected";

export type InterviewExperienceLevel =
  "intern" | "new_grad" | "experienced" | "unknown";
export type InterviewEmploymentType =
  "internship" | "full_time" | "contract" | "unknown";
export type InterviewApplicationStage =
  "screening" | "technical" | "onsite" | "final" | "mixed" | "unknown";
export type InterviewDifficulty = Difficulty | "unknown";
export type InterviewRoundType =
  | "recruiter"
  | "technical"
  | "coding"
  | "research"
  | "manager"
  | "behavioral"
  | "mixed"
  | "unknown";

export type QuestionType =
  "knowledge" | "coding" | "system_design" | "research" | "behavioral";

export type Difficulty = "easy" | "medium" | "hard";

export type RelationType = "related" | "prerequisite" | "follow_up" | "contrast";

export type CodingDifficulty = "easy" | "medium" | "hard";
export type CodingComparisonMode = "exact" | "trimmed" | "numeric";
export type CodingEvaluationMode = "program" | "function" | "class";
export type CodingEntrypointType = "function" | "class";
export type CodingFramework = "python" | "numpy" | "pytorch";
export type CodingResourceProfile = "standard_python" | "ml_cpu_small" | "ml_cpu_medium";
export type CodingTestType =
  | "example" | "value" | "shape" | "dtype" | "gradient" | "exception" | "performance";
export type CodingTestGroup =
  | "basic" | "edge" | "numerical" | "shape" | "gradient" | "performance";
export type CodingSubmissionStatus =
  | "queued"
  | "running"
  | "accepted"
  | "wrong_answer"
  | "runtime_error"
  | "time_limit_exceeded"
  | "memory_limit_exceeded"
  | "compile_error"
  | "internal_error";

export type ReviewerRole = "user" | "reviewer" | "admin";

export type Profile = {
  id: string;
  username: string | null;
  display_name: string | null;
  avatar_url: string | null;
  role: ReviewerRole;
  target_role_category: "research" | "engineering" | "mixed" | "unsure" | null;
  primary_focus: "knowledge" | "coding" | "both" | null;
  onboarding_completed_at: string | null;
  created_at: string;
  updated_at: string;
};

export type CompanyAlias = {
  alias: string;
  company_id: string;
  created_at: string;
};

export type Company = {
  id: string;
  name: string;
  slug: string;
  logo_url: string | null;
  country: string | null;
  industry: string | null;
  description: string | null;
  created_at: string;
  updated_at: string;
};

export type Position = {
  id: string;
  company_id: string;
  title: string;
  slug: string;
  category: string | null;
  location: string | null;
  created_at: string;
  updated_at: string;
};

export type Interview = {
  id: string;
  company_id: string;
  position_id: string | null;
  year: number;
  season: string | null;
  location: string | null;
  interview_type: string | null;
  source_type: string | null;
  source_url: string | null;
  status: InterviewStatus;
  created_by: string | null;
  created_at: string;
  updated_at: string;
  verified_at: string | null;
  title: string | null;
  slug: string | null;
  round_count: number;
  duration_minutes: number | null;
  experience_level: InterviewExperienceLevel;
  employment_type: InterviewEmploymentType;
  application_stage: InterviewApplicationStage;
  summary: string | null;
  difficulty_overall: InterviewDifficulty;
  language: string;
  is_anonymous: boolean;
  quality_score: number | null;
  published_at: string | null;
  source_submission_id: string | null;
};

// ---------------------------------------------------------------------------
// Week 6 ingestion tables
// ---------------------------------------------------------------------------

export type SubmissionStatus =
  | "submitted" | "processing" | "parsed" | "needs_review"
  | "approved" | "rejected" | "failed" | "published";

export type SubmissionType = "user_text" | "public_source" | "editorial" | "development";

export type InterviewSubmission = {
  id: string;
  user_id: string | null;
  submission_type: SubmissionType;
  raw_text: string;
  source_url: string | null;
  company_hint: string | null;
  position_hint: string | null;
  year_hint: number | null;
  season_hint: string | null;
  location_hint: string | null;
  language: string;
  status: SubmissionStatus;
  moderation_flags: Json;
  review_notes: string | null;
  processed_at: string | null;
  created_at: string;
  updated_at: string;
};

export type DraftStatus = "parsed" | "approved" | "rejected" | "published" | "archived";

export type InterviewDraft = {
  id: string;
  submission_id: string;
  company_name: string | null;
  position_title: string | null;
  year: number | null;
  season: string | null;
  location: string | null;
  employment_type: InterviewEmploymentType;
  experience_level: InterviewExperienceLevel;
  summary: string | null;
  confidence: number;
  parser_version: string;
  prompt_version: string | null;
  model: string | null;
  provider: string | null;
  interview_type: string;
  status: DraftStatus;
  published_interview_id: string | null;
  created_at: string;
  updated_at: string;
};

export type InterviewRoundDraft = {
  id: string;
  draft_id: string;
  round_number: number | null;
  title: string | null;
  round_type: InterviewRoundType;
  duration_minutes: number | null;
  interviewer_role: string | null;
  summary: string | null;
  confidence: number;
  order_index: number;
  created_at: string;
  updated_at: string;
};

export type InterviewQuestionDraft = {
  id: string;
  draft_id: string;
  round_draft_id: string | null;
  original_wording: string;
  normalized_text: string | null;
  question_type: QuestionType | null;
  difficulty: InterviewDifficulty | null;
  candidate_question_id: string | null;
  candidate_coding_problem_id: string | null;
  match_confidence: number | null;
  match_score: number | null;
  topic_suggestions: Json;
  new_canonical: Json | null;
  order_index: number;
  review_status: "pending" | "accepted" | "edited" | "rejected" | "new_canonical";
  review_notes: string | null;
  created_at: string;
  updated_at: string;
};

export type IngestionJobType =
  | "parse_interview" | "canonicalize_questions" | "classify_topics" | "duplicate_check";

export type IngestionJobStatus = "queued" | "running" | "succeeded" | "failed" | "cancelled";

export type IngestionJob = {
  id: string;
  submission_id: string;
  job_type: IngestionJobType;
  status: IngestionJobStatus;
  attempt_count: number;
  max_attempts: number;
  provider: string | null;
  model: string | null;
  parser_version: string | null;
  prompt_version: string | null;
  input_tokens: number | null;
  output_tokens: number | null;
  estimated_cost: number | null;
  error_code: string | null;
  error_message: string | null;
  started_at: string | null;
  finished_at: string | null;
  created_at: string;
  updated_at: string;
};

export type IngestionEvent = {
  id: string;
  submission_id: string;
  job_id: string | null;
  event_type: string;
  message: string | null;
  metadata: Json;
  created_at: string;
};

// ---------------------------------------------------------------------------
// Week 7 company intelligence caches
// ---------------------------------------------------------------------------

export type CompanyStats = {
  company_id: string;
  published_interview_count: number;
  position_count: number;
  knowledge_question_occurrence_count: number;
  coding_question_occurrence_count: number;
  unique_knowledge_question_count: number;
  unique_coding_problem_count: number;
  latest_interview_at: string | null;
  updated_at: string;
};

export type CompanyPositionStat = {
  company_id: string;
  position_id: string;
  interview_count: number;
  knowledge_occurrences: number;
  coding_occurrences: number;
  latest_interview_at: string | null;
  updated_at: string;
};

export type CompanyTopicStat = {
  company_id: string;
  topic_id: string;
  occurrence_count: number;
  interview_count: number;
  position_count: number;
  share_of_interviews: number | null;
  trend_score: number | null;
  last_seen_at: string | null;
  updated_at: string;
};

export type CompanyQuestionStat = {
  company_id: string;
  question_id: string;
  occurrence_count: number;
  interview_count: number;
  position_count: number;
  occurrences_30d: number;
  occurrences_90d: number;
  trend_score: number | null;
  last_seen_at: string | null;
  updated_at: string;
};

export type CompanyCodingProblemStat = {
  company_id: string;
  coding_problem_id: string;
  occurrence_count: number;
  interview_count: number;
  position_count: number;
  trend_score: number | null;
  last_seen_at: string | null;
  updated_at: string;
};

export type CompanySeasonStat = {
  company_id: string;
  year: number;
  season: string;
  interview_count: number;
  question_occurrence_count: number;
  knowledge_occurrence_count: number;
  coding_occurrence_count: number;
  coding_share: number | null;
  avg_round_count: number | null;
  avg_question_count: number | null;
  updated_at: string;
};

export type CompanyDifficultyStat = {
  company_id: string;
  easy_count: number;
  medium_count: number;
  hard_count: number;
  unknown_count: number;
  average_score: number | null;
  sample_size: number;
  updated_at: string;
};

export type CompanyRoundTypeStat = {
  company_id: string;
  round_type: string;
  round_count: number;
  interview_count: number;
  share: number | null;
  updated_at: string;
};

export type UserFeedback = {
  id: string;
  user_id: string | null;
  category: "bug" | "content_error" | "feature" | "other";
  message: string;
  created_at: string;
};

export type ContentReport = {
  id: string;
  user_id: string | null;
  entity_type: "interview" | "question" | "coding_problem" | "company" | "other";
  entity_id: string;
  reason: "inaccuracy" | "privacy" | "duplicate" | "inappropriate" | "other";
  details: string | null;
  status: "open" | "resolved" | "dismissed";
  created_at: string;
};

export type ReviewTask = {
  id: string;
  submission_id: string;
  draft_id: string | null;
  status: "open" | "in_review" | "approved" | "rejected" | "blocked";
  assigned_to: string | null;
  priority: number;
  duplicate_score: number | null;
  review_notes: string | null;
  created_at: string;
  updated_at: string;
  completed_at: string | null;
};

export type Question = {
  id: string;
  title: string;
  slug: string;
  question_type: QuestionType;
  difficulty: Difficulty | null;
  summary: string | null;
  canonical_answer: string | null;
  deep_answer: string | null;
  short_answer: string | null;
  key_points: Json | null;
  common_mistakes: Json | null;
  interview_tips: Json | null;
  estimated_minutes: number | null;
  is_featured: boolean;
  is_published: boolean;
  view_count: number;
  /** Appearances across independent public interview reports per the imported external bank (🔥×N); null = unknown. */
  source_freq: number | null;
  /** Provenance of an imported/enriched entry: repo, commit, license, volume/section/qid, merge notes. */
  source_meta: Json | null;
  created_at: string;
  updated_at: string;
};

export type QuestionRelation = {
  id: string;
  source_question_id: string;
  target_question_id: string;
  relation_type: RelationType;
  weight: number;
  created_at: string;
};

export type QuestionStats = {
  question_id: string;
  interview_count: number;
  company_count: number;
  occurrences_30d: number;
  occurrences_90d: number;
  trend_score: number;
  last_seen_at: string | null;
  updated_at: string;
};

export type InterviewQuestion = {
  id: string;
  interview_id: string;
  question_id: string | null;
  round_number: number | null;
  order_index: number | null;
  original_wording: string | null;
  round_id: string | null;
  notes: string | null;
  question_context: string | null;
  answer_summary: string | null;
  difficulty: Difficulty | "unknown" | null;
  coding_problem_id: string | null;
  created_at: string;
};

export type InterviewRound = {
  id: string;
  interview_id: string;
  round_number: number;
  title: string | null;
  round_type: InterviewRoundType;
  duration_minutes: number | null;
  interviewer_role: string | null;
  summary: string | null;
  created_at: string;
  updated_at: string;
};

export type InterviewTag = {
  interview_id: string;
  tag: string;
  created_at: string;
};

export type Topic = {
  id: string;
  name: string;
  slug: string;
  parent_id: string | null;
  description: string | null;
  created_at: string;
  updated_at: string;
};

export type QuestionTopic = {
  question_id: string;
  topic_id: string;
  weight: number | null;
  created_at: string;
};

export type CodingProblem = {
  id: string;
  title: string;
  slug: string;
  difficulty: CodingDifficulty;
  category: string | null;
  description: string;
  constraints: string | null;
  starter_code: string | null;
  solution_code: string | null;
  function_name: string | null;
  language: "python";
  time_limit_ms: number;
  memory_limit_mb: number;
  comparison_mode: CodingComparisonMode;
  tolerance: number;
  evaluation_mode: CodingEvaluationMode;
  entrypoint_type: CodingEntrypointType | null;
  entrypoint_name: string | null;
  framework: CodingFramework | null;
  resource_profile: CodingResourceProfile;
  evaluator_config: Json | null;
  is_published: boolean;
  is_featured: boolean;
  created_at: string;
  updated_at: string;
};

export type CodingProblemTopic = {
  problem_id: string;
  topic_id: string;
  weight: number;
  created_at: string;
};

export type CodingTestCase = {
  id: string;
  problem_id: string;
  name: string | null;
  input_data: string;
  expected_output: string;
  is_hidden: boolean;
  weight: number;
  order_index: number;
  test_type: CodingTestType | null;
  test_group: CodingTestGroup | null;
  input_json: Json | null;
  expected_json: Json | null;
  metadata: Json | null;
  created_at: string;
};

export type CodingSubmission = {
  id: string;
  user_id: string;
  problem_id: string;
  language: "python";
  source_code: string;
  status: CodingSubmissionStatus;
  score: number | null;
  runtime_ms: number | null;
  memory_kb: number | null;
  judge_token: string | null;
  error_message: string | null;
  evaluation_summary: Json | null;
  created_at: string;
  completed_at: string | null;
};

export type CodingSubmissionCase = {
  id: string;
  submission_id: string;
  test_case_id: string | null;
  status: CodingSubmissionStatus | null;
  runtime_ms: number | null;
  memory_kb: number | null;
  stdout: string | null;
  stderr: string | null;
  created_at: string;
};

export type CodingCollection = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  is_published: boolean;
  order_index: number;
  created_at: string;
  updated_at: string;
};

export type CodingCollectionProblem = {
  collection_id: string;
  problem_id: string;
  order_index: number;
};

export type UserCodingProgress = {
  user_id: string;
  problem_id: string;
  status: "solved" | "attempted" | "unsolved";
  attempt_count: number;
  best_runtime_ms: number | null;
  first_solved_at: string | null;
  last_attempt_at: string;
  updated_at: string;
};

type Table<
  Row extends Record<string, unknown>,
  Insert extends Record<string, unknown>,
  Update extends Record<string, unknown>,
> = {
  Row: Row;
  Insert: Insert;
  Update: Update;
  Relationships: [];
};

export interface Database {
  public: {
    Tables: {
      profiles: Table<
        Profile,
        Partial<Omit<Profile, "created_at" | "updated_at">> & { id: string },
        Partial<Omit<Profile, "id" | "created_at" | "updated_at">>
      >;
      company_aliases: Table<
        CompanyAlias,
        Partial<Omit<CompanyAlias, "created_at">> & { alias: string; company_id: string },
        Partial<Omit<CompanyAlias, "created_at">>
      >;
      companies: Table<
        Company,
        Partial<Omit<Company, "id" | "created_at" | "updated_at">> & {
          name: string;
          slug: string;
        },
        Partial<Omit<Company, "id" | "created_at" | "updated_at">>
      >;
      positions: Table<
        Position,
        Partial<Omit<Position, "id" | "created_at" | "updated_at">> & {
          company_id: string;
          title: string;
          slug: string;
        },
        Partial<Omit<Position, "id" | "created_at" | "updated_at">>
      >;
      interviews: Table<
        Interview,
        Partial<Omit<Interview, "id" | "created_at" | "updated_at">> & {
          company_id: string;
          year: number;
        },
        Partial<Omit<Interview, "id" | "created_at" | "updated_at">>
      >;
      interview_rounds: Table<
        InterviewRound,
        Partial<Omit<InterviewRound, "id" | "created_at" | "updated_at">> & {
          interview_id: string;
          round_number: number;
        },
        Partial<
          Omit<InterviewRound, "id" | "interview_id" | "created_at" | "updated_at">
        >
      >;
      questions: Table<
        Question,
        Partial<Omit<Question, "id" | "created_at" | "updated_at">> & {
          title: string;
          slug: string;
          question_type: QuestionType;
        },
        Partial<Omit<Question, "id" | "created_at" | "updated_at">>
      >;
      interview_questions: Table<
        InterviewQuestion,
        Partial<Omit<InterviewQuestion, "id" | "created_at">> & {
          interview_id: string;
        },
        Partial<Omit<InterviewQuestion, "id" | "question_id" | "created_at">>
      >;
      interview_tags: Table<
        InterviewTag,
        Partial<Omit<InterviewTag, "created_at">> & {
          interview_id: string;
          tag: string;
        },
        Partial<Omit<InterviewTag, "interview_id" | "tag" | "created_at">>
      >;
      topics: Table<
        Topic,
        Partial<Omit<Topic, "id" | "created_at" | "updated_at">> & {
          name: string;
          slug: string;
        },
        Partial<Omit<Topic, "id" | "created_at" | "updated_at">>
      >;
      question_topics: Table<
        QuestionTopic,
        Partial<Omit<QuestionTopic, "created_at">> & {
          question_id: string;
          topic_id: string;
        },
        Partial<Omit<QuestionTopic, "question_id" | "topic_id" | "created_at">>
      >;
      question_relations: Table<
        QuestionRelation,
        Partial<Omit<QuestionRelation, "id" | "created_at">> & {
          source_question_id: string;
          target_question_id: string;
          relation_type: RelationType;
        },
        Partial<
          Omit<
            QuestionRelation,
            "source_question_id" | "target_question_id" | "relation_type" | "created_at"
          >
        >
      >;
      question_stats: Table<
        QuestionStats,
        Partial<Omit<QuestionStats, "question_id" | "updated_at">> & {
          question_id: string;
        },
        Partial<Omit<QuestionStats, "question_id" | "updated_at">>
      >;
      coding_problems: Table<
        CodingProblem,
        Partial<Omit<CodingProblem, "id" | "created_at" | "updated_at">> & {
          title: string;
          slug: string;
          difficulty: CodingDifficulty;
          description: string;
        },
        Partial<Omit<CodingProblem, "id" | "created_at" | "updated_at">>
      >;
      coding_problem_topics: Table<
        CodingProblemTopic,
        Partial<Omit<CodingProblemTopic, "created_at">> & {
          problem_id: string;
          topic_id: string;
        },
        Partial<Omit<CodingProblemTopic, "problem_id" | "topic_id" | "created_at">>
      >;
      coding_test_cases: Table<
        CodingTestCase,
        Partial<Omit<CodingTestCase, "id" | "created_at">> & { problem_id: string },
        Partial<Omit<CodingTestCase, "id" | "problem_id" | "created_at">>
      >;
      coding_submissions: Table<
        CodingSubmission,
        Partial<Omit<CodingSubmission, "id" | "created_at">> & {
          user_id: string;
          problem_id: string;
          source_code: string;
          status: CodingSubmissionStatus;
        },
        Partial<Omit<CodingSubmission, "id" | "user_id" | "problem_id" | "created_at">>
      >;
      coding_submission_cases: Table<
        CodingSubmissionCase,
        Partial<Omit<CodingSubmissionCase, "id" | "created_at">> & {
          submission_id: string;
        },
        Partial<Omit<CodingSubmissionCase, "id" | "submission_id" | "created_at">>
      >;
      coding_collections: Table<
        CodingCollection,
        Partial<Omit<CodingCollection, "id" | "created_at" | "updated_at">> & {
          name: string;
          slug: string;
        },
        Partial<Omit<CodingCollection, "id" | "created_at" | "updated_at">>
      >;
      coding_collection_problems: Table<
        CodingCollectionProblem,
        Partial<Omit<CodingCollectionProblem, "created_at">> & {
          collection_id: string;
          problem_id: string;
        },
        Partial<Omit<CodingCollectionProblem, "collection_id" | "problem_id">>
      >;
      interview_submissions: Table<
        InterviewSubmission,
        Partial<Omit<InterviewSubmission, "id" | "created_at" | "updated_at">> & {
          raw_text: string;
        },
        Partial<Omit<InterviewSubmission, "id" | "created_at" | "updated_at">>
      >;
      interview_drafts: Table<
        InterviewDraft,
        Partial<Omit<InterviewDraft, "id" | "created_at" | "updated_at">> & {
          submission_id: string;
        },
        Partial<Omit<InterviewDraft, "id" | "created_at" | "updated_at">>
      >;
      interview_round_drafts: Table<
        InterviewRoundDraft,
        Partial<Omit<InterviewRoundDraft, "id" | "created_at" | "updated_at">> & {
          draft_id: string;
          order_index: number;
        },
        Partial<Omit<InterviewRoundDraft, "id" | "draft_id" | "created_at" | "updated_at">>
      >;
      interview_question_drafts: Table<
        InterviewQuestionDraft,
        Partial<Omit<InterviewQuestionDraft, "id" | "created_at" | "updated_at">> & {
          draft_id: string;
          order_index: number;
          original_wording: string;
        },
        Partial<Omit<InterviewQuestionDraft, "id" | "draft_id" | "created_at" | "updated_at">>
      >;
      ingestion_jobs: Table<
        IngestionJob,
        Partial<Omit<IngestionJob, "id" | "created_at" | "updated_at">> & {
          submission_id: string;
          job_type: IngestionJobType;
        },
        Partial<Omit<IngestionJob, "id" | "created_at" | "updated_at">>
      >;
      ingestion_events: Table<
        IngestionEvent,
        Partial<Omit<IngestionEvent, "id" | "created_at">> & {
          submission_id: string;
          event_type: string;
        },
        Partial<Omit<IngestionEvent, "id" | "created_at">>
      >;
      user_feedback: Table<
        UserFeedback,
        Partial<Omit<UserFeedback, "id" | "created_at">> & { category: UserFeedback["category"]; message: string },
        Partial<Omit<UserFeedback, "id" | "created_at">>
      >;
      content_reports: Table<
        ContentReport,
        Partial<Omit<ContentReport, "id" | "created_at">> & {
          entity_type: ContentReport["entity_type"];
          entity_id: string;
          reason: ContentReport["reason"];
        },
        Partial<Omit<ContentReport, "id" | "created_at">>
      >;
      review_tasks: Table<
        ReviewTask,
        Partial<Omit<ReviewTask, "id" | "created_at" | "updated_at">> & {
          submission_id: string;
        },
        Partial<Omit<ReviewTask, "id" | "created_at" | "updated_at">>
      >;
      company_stats: Table<
        CompanyStats,
        Partial<Omit<CompanyStats, "company_id" | "updated_at">> & { company_id: string },
        Partial<Omit<CompanyStats, "company_id" | "updated_at">>
      >;
      company_position_stats: Table<
        CompanyPositionStat,
        Partial<Omit<CompanyPositionStat, "company_id" | "position_id" | "updated_at">> & {
          company_id: string;
          position_id: string;
        },
        Partial<Omit<CompanyPositionStat, "company_id" | "position_id" | "updated_at">>
      >;
      company_topic_stats: Table<
        CompanyTopicStat,
        Partial<Omit<CompanyTopicStat, "company_id" | "topic_id" | "updated_at">> & {
          company_id: string;
          topic_id: string;
        },
        Partial<Omit<CompanyTopicStat, "company_id" | "topic_id" | "updated_at">>
      >;
      company_question_stats: Table<
        CompanyQuestionStat,
        Partial<Omit<CompanyQuestionStat, "company_id" | "question_id" | "updated_at">> & {
          company_id: string;
          question_id: string;
        },
        Partial<Omit<CompanyQuestionStat, "company_id" | "question_id" | "updated_at">>
      >;
      company_coding_problem_stats: Table<
        CompanyCodingProblemStat,
        Partial<Omit<CompanyCodingProblemStat, "company_id" | "coding_problem_id" | "updated_at">> & {
          company_id: string;
          coding_problem_id: string;
        },
        Partial<Omit<CompanyCodingProblemStat, "company_id" | "coding_problem_id" | "updated_at">>
      >;
      company_season_stats: Table<
        CompanySeasonStat,
        Partial<Omit<CompanySeasonStat, "company_id" | "year" | "season" | "updated_at">> & {
          company_id: string;
          year: number;
          season: string;
        },
        Partial<Omit<CompanySeasonStat, "company_id" | "year" | "season" | "updated_at">>
      >;
      company_difficulty_stats: Table<
        CompanyDifficultyStat,
        Partial<Omit<CompanyDifficultyStat, "company_id" | "updated_at">> & { company_id: string },
        Partial<Omit<CompanyDifficultyStat, "company_id" | "updated_at">>
      >;
      company_round_type_stats: Table<
        CompanyRoundTypeStat,
        Partial<Omit<CompanyRoundTypeStat, "company_id" | "round_type" | "updated_at">> & {
          company_id: string;
          round_type: string;
        },
        Partial<Omit<CompanyRoundTypeStat, "company_id" | "round_type" | "updated_at">>
      >;
      user_coding_progress: Table<
        UserCodingProgress,
        Partial<Omit<UserCodingProgress, "user_id" | "problem_id" | "updated_at">> & {
          user_id: string;
          problem_id: string;
        },
        Partial<Omit<UserCodingProgress, "user_id" | "problem_id" | "updated_at">>
      >;
    };
    Views: {
      questions_with_stats: {
        Row: Question & {
          interview_count: number | null;
          company_count: number | null;
          occurrences_30d: number | null;
          occurrences_90d: number | null;
          trend_score: number | null;
          last_seen_at: string | null;
        };
        Relationships: [];
      };
      coding_problem_catalog: {
        Row: Omit<CodingProblem, "solution_code" | "evaluator_config"> & {
          /** Derived public capability hints (migration 0016). */
          public_checks: string[] | null;
        };
        Relationships: [];
      };
      coding_visible_test_cases: {
        Row: Omit<CodingTestCase, "is_hidden">;
        Relationships: [];
      };
    };
    Functions: {
      refresh_company_stats: {
        Args: { p_company_id?: string | null };
        Returns: undefined;
      };
      publish_interview_draft: {
        Args: {
          p_draft_id: string;
          p_company_id: string;
          p_position_id?: string | null;
          p_slug?: string | null;
        };
        Returns: string;
      };
    };
    Enums: {
      interview_status: InterviewStatus;
      question_type: QuestionType;
      question_difficulty: Difficulty;
    };
    CompositeTypes: Record<never, never>;
  };
}
