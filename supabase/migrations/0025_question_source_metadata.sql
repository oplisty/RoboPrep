-- ---------------------------------------------------------------------------
-- RoboPrep — external question-bank provenance & frequency
--
-- `source_freq` records how many independent public interview reports a
-- question appeared in, as counted by an imported external question bank
-- (e.g. WinstonJQ/embodied-interview-qa, where it renders as 🔥×N).
-- It is deliberately separate from question_stats.interview_count, which is
-- derived from interviews submitted to RoboPrep itself and refreshed by
-- scripts/refresh-question-stats.ts.
--
-- `source_meta` carries the full provenance of an imported/enriched entry:
-- repo, commit, license, volume/section/qid of the source entry, and merge
-- notes for questions whose answers were enriched from the source bank.
-- ---------------------------------------------------------------------------

alter table public.questions
  add column if not exists source_freq integer,
  add column if not exists source_meta jsonb;

alter table public.questions
  add constraint questions_source_freq_check
  check (source_freq is null or source_freq between 0 and 999);

comment on column public.questions.source_freq is
  'Number of independent public interview reports this question appeared in, per the imported external bank (🔥×N). Null = unknown / not tracked.';
comment on column public.questions.source_meta is
  'Provenance of an imported or enriched question: source repo, commit, license, volume/section/qid, merge notes.';

create index if not exists questions_source_freq_idx
  on public.questions (source_freq desc nulls last);
