# Changelog

## 1.5.0 (2026-10-25)

### Added
- **embodied-interview-qa 全量导入（412 题 + 24 题答案融合）**：题源为
  [WinstonJQ/embodied-interview-qa](https://github.com/WinstonJQ/embodied-interview-qa)
  （MIT License，commit 001e4238，2026-10-19 版），中文具身智能秋招高频题库九卷
  共 464 条。跳过源库维护者明确不入主表的 19 条「N 备选」后导入 445 条；其中 33
  条与现有题库重复（含跨语言重复与 DR/SAC/稀疏奖励/在线离线 RL 等多对一重复），
  按「跳过重复 + 现有答案融合补强」处理：24 个现有题各追加「外部题库补充」段落
  （仅补充原答案缺失的要点，如 KV Cache 训练/推理不对称、GRPO 的 KL-in-loss 与
  4 模型 vs 3 模型显存对比、ACT 真机 k=100 数字校准、HER/RND 补位等）并合并
  易错点。新增 10 个 topic（深度学习基础、离线强化学习、工程落地、腿足控制、
  遥操作、SLAM 与 3D 感知、具身导航、LeetCode 手撕、系统设计、前沿方向），
  共 586 条 question_topics 关联。卷八按用户要求全量进入：LeetCode 30 题为
  coding 型知识条目（含完整 Python 实现），ML/机器人系统设计 10 题为
  system_design 型；卷九 8 题标为 research 型（源库明确非面经）。seed 由
  `scripts/generate_embodied_qa_seed.py` 从 vendored 源文件生成
  （`supabase/seed_embodied_interview_qa.sql`，幂等，只插入不修改既有数据；
  融合 UPDATE 单列一段）。seed 后题库规模 79 → 491 题。
- **🔥 外部题库频次（source_freq）**：新增迁移 0025，`questions` 表增加
  `source_freq`（该题在 N 份独立公开面经中出现，即源库 🔥×N 口径；与站内
  `question_stats.interview_count` 相互独立）与 `source_meta`（导入/融合来源：
  repo、commit、license、卷/节/题号）。Knowledge 列表与详情页展示 🔥×N 徽标，
  详情页底部展示题源署名；频次 ≥15 的题设为精选（is_featured）。
- **答案渲染升级**：`math-text.ts` 支持显式 `$…$` / `$$…$$` LaTeX 定界
  （pandoc 风格空白规则，货币单美元符不误判）；新增 `answer-markdown.ts`
  轻量块级渲染器（代码围栏、markdown 表格、有序/无序列表、粗体、行内代码），
  导入题的 170 处代码块、435 行表格与公式均可正确显示；既有纯文本答案渲染
  行为不变。新增 `scripts/tests/answer-render.test.mjs`（9 项回归测试）。
- **全量正确性审查（2026-10-25）**：对 412 道导入题与 24 条融合逐一人工核对
  （公式重推导、代码逐行验证、论文归因与数字逐条比对、易错点本身正确性）。
  结论：修正 3 处内容——卷一 q37 D-H 约定归属写反（Craig 是改进 D-H 代表，
  已改为「标准 DH=Denavit-Hartenberg 原始约定/Spong 沿用 vs MDH=Craig」）、
  卷一 q08 RoPE「天然外推」过强（改为需位置插值/NTK/YaRN 扩展）、卷二 q24
  IQL expectile τ 写死 0.9（改为官方默认 0.7、任务间 0.7-0.9）；修复解析器
  一处易错块截断 bug（易错段内的行内粗体标签误终止段落，影响 5 条，含 v02-q20
  Dueling 归一化公式被截断）。「破例说明」维护注记改归入 source_meta 题源。
  修正经 `scripts/embodied_qa_source/corrections.json`（带 stale 断言）回灌
  生成器，seed 已重新生成。卷六控制类手撕（四元数 Shepperd 分支、改进 DH
  矩阵、DARE、MPC QP 构造）与卷八 30 道 LeetCode 逐用例验证零错误；卷九
  8 条前沿题为源库按一手资料核对的口径、内部自洽，超出可独立核实范围。

## 1.4.0 (2026-09-29)

### Added
- **Embodied RL post-training question set** (26 canonical questions): sourced
  from bo233's 具身智能面经（二）：强化学习为什么容易被问挂 ([WeChat repost by
  深蓝职通车](https://mp.weixin.qq.com/s/aYwVgSD1GXZM1J3UPObVYA), sequel to the
  π-series 面经（一）). Question wordings kept verbatim in Chinese; 2 items
  already covered by the bank (PPO vs GRPO difference + KL constraint → base
  question 3, Sim-to-Real gap localization → question 52) were deduped per the
  extraction guidelines. Covers training paradigms and data (pretraining/SFT/
  GRPO pipeline, when to switch from IL to RL, online vs offline RL, RL/IL
  data mix, failure-trajectory uses, on/off-policy), reward design and credit
  assignment (conflict diagnosis, sparse rewards and shaping validation,
  length bias, return/advantage construction with terminal collisions,
  success detection, potential-based shaping invariance), PPO/GRPO stability
  (degenerate groups, ratio clip gradients, token log-prob and importance
  sampling, GAE bias/variance), closed-loop rollout and evaluation (why RL
  beats rule-based planners, rollout environment, open vs closed loop,
  domain randomization) and SAC/DQN (max-entropy objective and loss signs,
  reparameterization, twin critics, Double DQN, target networks, SAC vs PPO).
  Seeded with three new topics (SAC, DQN, 奖励设计) and one retrofit
  association of the existing reward-design question to 奖励设计: seed totals
  are now 79 canonical questions (was 53) and 27 topics (was 24).

## 1.3.0 (2026-09-22)

### Added
- **LLM & embodied fundamentals question set** (19 canonical questions):
  sourced from a 小红书 high-frequency question card set (PART 1 大模型八股
  12 items + PART 2 具身 VLA 18 items); the 11 items already covered by the
  bank were deduped per the extraction guidelines. New questions cover
  scaled dot-product (√dk), MHA/GQA, BN/LN/RMSNorm, LoRA (with embodied
  applications), distributed-training parallelism, Flow Matching vs
  diffusion, GPU memory optimization, inference acceleration (KV Cache /
  FlashAttention / PagedAttention), alignment methods (SFT/RLHF/DPO/GRPO),
  LLM evaluation, ACT, DAgger, LeRobot format, UMI, embodied data
  augmentation, reward design, real-time control, deployment &
  Sim2Real, and embodied benchmarks (noting RT-1/RT-2 are models, not
  benchmarks). Six new topics (参数高效微调, 分布式训练, 对齐, 模仿学习,
  Sim2Real, 评测与基准): seed totals now 53 canonical questions (was 34)
  and 24 topics (was 18).

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
