# Changelog

## 1.2.0 (2026-09-20)

### Added
- **π-series interview question set** (24 canonical questions): sourced from
  bo233's 具身智能面经（一）：π 论文篇 ([Zhihu original](https://zhuanlan.zhihu.com/p/2081126347766875774),
  authorized repost on the 深蓝职通车 WeChat account). Question wordings kept
  verbatim in Chinese; canonical/deep answers curated from the papers. Covers
  π0 architecture and the flow matching action expert, π0.5 co-training and
  open-world generalization, π\*0.6 RECAP / replay buffers / reward
  modelling, π0.7 compositional generalization, RLT (RL Token) online RL,
  π-FAST action tokenization (DCT+BPE) and series-level evolution plus the
  RT-series / OpenVLA comparison. Seeded with four new topics (π 系列,
  Flow Matching, Action Chunking, 动作 Tokenization): seed totals are now
  34 canonical questions (was 10) and 18 topics (was 14).

## 1.1.0 (2026-09-16)

### Added
- **LLM core operators problem set** (26 problems, 140 test cases): adapted
  from [TorchCode](https://github.com/duoan/TorchCode) (with author
  authorization) into the declarative structured judge format. Covers
  from-scratch PyTorch implementations: basic operators (ReLU, GELU,
  cross-entropy, embedding, linear, batchnorm, conv2d, inverted dropout,
  linear regression), attention variants (GQA, sliding-window, linear,
  Flash-Attention-style causal), architecture modules (LoRA, ViT patch
  embed, GPT-2 block, MoE), training and decoding (Adam, cosine LR,
  gradient clipping/accumulation, beam search, top-p filter, BPE, INT8
  quantization) and the DPO loss. Chinese problem statements; new
  "LLM 核心算子" collection.
- **Batch authoring workflow**: `scripts/torchcode_problems/` problem
  source modules plus `scripts/generate_coding_seed.py`, which runs
  reference solutions in the pinned environment to auto-compute expected
  values (gradient convention, 6-decimal rounding) and emits deterministic
  seed SQL. `scripts/extract_seed_problems.py` replaces the ad-hoc
  `/tmp` extractor referenced by the authoring guide.

### Fixed
- `validate-seed-problems.ts`: exception-kind expected values were passed
  to the judge with DB snake_case keys, so `exception_type` never matched
  (`mapExpected` reads `exceptionType`); now mapped correctly. Also added
  a `--input <path>` argument (previously hardcoded to
  `/tmp/seed_data_fixed.json`).

### Docs
- README: "最新动态" section, supplementary seed import steps, local
  `PYTHON_EXECUTABLE` judge setup; authoring guide gained the batch
  generation workflow.

## 1.0.0 (2026-09-02)

First public V1.

### Added
- **Knowledge System** (Week 2): canonical questions, topic hierarchy,
  question graph, search.
- **Interview System** (Week 3): structured interview records, rounds,
  question occurrences with provenance.
- **Coding platform** (Weeks 4–5): 53 published Python/ML problems,
  Monaco editor, Run/Submit with hidden tests, program + ML function/class
  judges (CPU PyTorch with shape/numerical/gradient checks), collections,
  per-user progress.
- **Interview ingestion** (Week 6): authenticated raw submission, LLM/mock
  parser with strict validation, canonicalization review, duplicate
  detection, moderation flags, human review queue, idempotent publish with
  provenance and privacy safeguards.
- **Company Intelligence** (Week 7): company/role pages, topic/question/
  coding frequency with sample-size policy, difficulty and season
  comparison, volume-normalized trends, preparation guides.
- **Production hardening** (Week 8): feature flags, structured logging with
  correlation ids, redaction policy, health endpoint, admin ops/audit/
  diagnostics, global ⌘K search with bilingual aliases, robots/sitemap/
  canonical/OG metadata, security headers, onboarding/settings/password
  reset/account deletion, legal pages, feedback + content reports,
  recovery/production smoke scripts, ops runbooks.

### Known limitations
See `docs/technical-debt.md` and `docs/week8-status.md`. The coding judge
requires an isolated provider in production; rate limiting is
single-instance at V1 scale.
