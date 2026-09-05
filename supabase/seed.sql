-- ---------------------------------------------------------------------------
-- RoboPrep — deterministic development seed
--
-- Applied automatically by `supabase db reset` (see supabase/config.toml).
-- Small on purpose: just enough to render realistic placeholder pages.
--
--   companies            32 (7 placeholder + 25 real, see generated block)
--   positions            5
--   topics              14 (hierarchical)
--   questions           10 canonical
--   interviews          71 published (real 小红书 posts, regenerate with scripts/generate_interview_seed.py)
--   interview_questions 349 (curated: only real interviewer questions; official
--                         marketing, blogger narration and status-only posts are excluded)
-- ---------------------------------------------------------------------------

begin;

-- ---------------------------------------------------------------------------
-- companies
-- ---------------------------------------------------------------------------

insert into public.companies (id, name, slug, country, industry, description) values
  ('c1000000-0000-4000-8000-000000000001', 'ByteDance',     'bytedance',             'CN', '互联网 / AI',       '拥有具身智能研究团队（GR-3、Robix）的互联网公司。'),
  ('c1000000-0000-4000-8000-000000000002', 'NVIDIA',        'nvidia',                'US', '半导体 / AI', '提供 Isaac、GR00T 和 Jetson 等 GPU 平台与机器人技术栈。'),
  ('c1000000-0000-4000-8000-000000000003', 'Physical Intelligence', 'physical-intelligence', 'US', '机器人 / AI', '开发 pi0、pi0-FAST 等通用机器人基础模型。'),
  ('c1000000-0000-4000-8000-000000000004', 'Figure AI',     'figure-ai',             'US', '机器人',            '借助 Helmsman VLA 模型开发面向通用任务的人形机器人。'),
  ('c1000000-0000-4000-8000-000000000005', 'Unitree',       'unitree',               'CN', '机器人',            '提供广泛用于科研硬件平台的四足与人形机器人。'),
  ('c1000000-0000-4000-8000-000000000006', 'AgiBot',        'agibot',                'CN', '机器人 / AI',       '开发智元人形机器人系列与 GO-1 模型的具身智能公司。'),
  ('c1000000-0000-4000-8000-000000000007', 'DJI',           'dji',                   'CN', '机器人',            '提供消费级与企业级无人机，以及机载感知和飞控技术。');

-- ---------------------------------------------------------------------------
-- positions
-- ---------------------------------------------------------------------------

insert into public.positions (id, company_id, title, slug, category, location) values
  ('a1000000-0000-4000-8000-000000000001', 'c1000000-0000-4000-8000-000000000001', '具身智能算法工程师', 'embodied-ai-algorithm-engineer', '算法',  '北京 / 深圳'),
  ('a1000000-0000-4000-8000-000000000002', 'c1000000-0000-4000-8000-000000000002', '机器人系统工程师',      'robotics-systems-engineer',      '系统',    '圣克拉拉, CA'),
  ('a1000000-0000-4000-8000-000000000003', 'c1000000-0000-4000-8000-000000000003', '具身智能研究科学家', 'embodied-ai-research-scientist', '研究',   '旧金山, CA'),
  ('a1000000-0000-4000-8000-000000000004', 'c1000000-0000-4000-8000-000000000004', 'VLA 模型工程师',             'vla-model-engineer',             '模型',      '桑尼维尔, CA'),
  ('a1000000-0000-4000-8000-000000000005', 'c1000000-0000-4000-8000-000000000006', '机器人学习工程师',        'robot-learning-engineer',        '机器人学习', '上海');

insert into public.positions (id, company_id, title, slug, category, location) values
  ('a1000000-0000-4000-8000-000000000006', 'c1000000-0000-4000-8000-000000000005', '机器人学习实习生', 'robot-learning-intern', '机器人学习', '杭州'),
  ('a1000000-0000-4000-8000-000000000007', 'c1000000-0000-4000-8000-000000000007', '感知算法工程师', 'perception-algorithm-engineer', '感知', '深圳'),
  ('a1000000-0000-4000-8000-000000000008', 'c1000000-0000-4000-8000-000000000003', 'VLA 研究实习生', 'vla-research-intern', '研究', '旧金山, CA'),
  ('a1000000-0000-4000-8000-000000000009', 'c1000000-0000-4000-8000-000000000004', '人形机器人学习工程师', 'humanoid-learning-engineer', '机器人学习', '桑尼维尔, CA'),
  ('a1000000-0000-4000-8000-000000000010', 'c1000000-0000-4000-8000-000000000006', '机器人学习应届生', 'robot-learning-new-grad', '机器人学习', '上海'),
  ('a1000000-0000-4000-8000-000000000011', 'c1000000-0000-4000-8000-000000000002', '机器人学习实习生', 'robot-learning-intern', '研究', '圣克拉拉, CA'),
  ('a1000000-0000-4000-8000-000000000012', 'c1000000-0000-4000-8000-000000000001', 'VLA 研究实习生', 'vla-research-intern', '研究', '北京');

-- ---------------------------------------------------------------------------
-- topics
-- ---------------------------------------------------------------------------

insert into public.topics (id, name, slug, parent_id, description) values
  ('d1000000-0000-4000-8000-000000000001', '具身智能',      'embodied-ai',      null,                                 '能够在物理世界中感知、推理并采取行动的智能体。'),
  ('d1000000-0000-4000-8000-000000000002', 'Transformer',      'transformer',      null,                                 '广泛用于视觉、语言和控制的纯 Attention 序列架构。'),
  ('d1000000-0000-4000-8000-000000000003', 'Attention',        'attention',        'd1000000-0000-4000-8000-000000000002', '基于内容对一组 value 向量进行加权汇聚。'),
  ('d1000000-0000-4000-8000-000000000004', 'QKV',              'qkv',              'd1000000-0000-4000-8000-000000000003', '缩放点积 Attention 中的 Query、Key 和 Value 投影。'),
  ('d1000000-0000-4000-8000-000000000005', 'KV Cache',         'kv-cache',         'd1000000-0000-4000-8000-000000000003', '复用过去的 key/value 张量，降低自回归解码的计算成本。'),
  ('d1000000-0000-4000-8000-000000000006', 'VLA',              'vla',              'd1000000-0000-4000-8000-000000000001', '将观测和指令映射为机器人动作的 Vision-Language-Action 模型。'),
  ('d1000000-0000-4000-8000-000000000007', '世界模型',      'world-model',      'd1000000-0000-4000-8000-000000000001', '用于预测、规划或生成数据的学习型动力学模型。'),
  ('d1000000-0000-4000-8000-000000000008', 'Diffusion Policy', 'diffusion-policy', 'd1000000-0000-4000-8000-000000000001', '通过对轨迹进行迭代去噪来生成动作。'),
  ('d1000000-0000-4000-8000-000000000009', 'RL',               'rl',               'd1000000-0000-4000-8000-000000000001', '强化学习：根据奖励信号优化行为。'),
  ('d1000000-0000-4000-8000-000000000010', 'PPO',              'ppo',              'd1000000-0000-4000-8000-000000000009', '使用截断代理目标的 on-policy policy-gradient 方法。'),
  ('d1000000-0000-4000-8000-000000000011', 'GRPO',             'grpo',             'd1000000-0000-4000-8000-000000000009', 'Group Relative Policy Optimisation：不需要 critic 的相对优势估计。'),
  ('d1000000-0000-4000-8000-000000000012', '机器人学',         'robotics',         'd1000000-0000-4000-8000-000000000001', '涵盖运动学、动力学、控制和硬件在环等问题。'),
  ('d1000000-0000-4000-8000-000000000013', '机器人数据',       'robot-data',       'd1000000-0000-4000-8000-000000000012', '机器人的遥操作、采集、清洗和轨迹整理。'),
  ('d1000000-0000-4000-8000-000000000014', 'SE(3)',            'se3',              'd1000000-0000-4000-8000-000000000012', '三维空间中刚体旋转和平移组成的特殊欧氏群。');

-- ---------------------------------------------------------------------------
-- questions (canonical)
-- ---------------------------------------------------------------------------

insert into public.questions (id, title, slug, question_type, difficulty, summary, canonical_answer, deep_answer) values
  (
    'f1000000-0000-4000-8000-000000000001',
    'What are Q, K and V in attention?',
    'what-are-q-k-and-v-in-attention',
    'knowledge', 'easy',
    'Queries ask, keys index, values carry the content that gets pooled.',
    'Given input embeddings X, attention learns three linear projections: Q = XW_Q, K = XW_K, V = XW_V. The query is the vector that is looking for information, the key is the label each token advertises for matching, and the value is the payload that actually gets mixed. Scores are computed as QK^T / sqrt(d_k), softmaxed, and used to take a weighted sum of V. So keys decide *how much* of each value to take; values decide *what* is taken.',
    'Matched content is separated from matching itself: if attention averaged the inputs directly, a token could only attend in proportion to how similar its own embedding is to others. Splitting into K and V lets the model learn "this is the kind of thing I am looking for" (K) independently from "this is what I will contribute once selected" (V). In multi-head attention each head gets its own W_Q, W_K, W_V with d_k = d_model / h, so different heads can attend to different relations (syntax, coreference, geometry). In cross-attention — the mechanism behind VLA conditioning — Q comes from the decoder/action stream while K and V come from the observation or language encoder, which is exactly why the asymmetry matters.'
  ),
  (
    'f1000000-0000-4000-8000-000000000002',
    'Why is KV Cache useful?',
    'why-is-kv-cache-useful',
    'knowledge', 'medium',
    'It trades memory for compute by storing past keys and values so each new token only attends to itself plus history.',
    'Autoregressive decoding recomputes attention over the whole prefix at every step. Naively that is O(n^2) work for a sequence of length n. But the key/value tensors of earlier tokens never change once produced, so they can be cached and reused. Each new token then only needs to compute its own Q, K, V and attend against the cached K/V: O(n) per step instead of O(n^2), at the cost of O(n) extra memory.',
    'The cost is memory bandwidth, not FLOPs, once the cache is large: decoding becomes a bandwidth-bound gather over (layers x heads x seq x d_k) tensors. That is why techniques like multi-query attention, grouped-query attention and KV-cache quantisation exist — they shrink the cache rather than the compute. For robots the stakes are concrete: a VLA running at 10-50 Hz on an onboard GPU has a hard latency budget, and if the observation history is long the cache, not the policy, is usually what blows the budget. Practical mitigations are chunked prompts, sliding-window attention over recent frames, and quantising KV to int8.'
  ),
  (
    'f1000000-0000-4000-8000-000000000003',
    'What is the difference between PPO and GRPO?',
    'difference-between-ppo-and-grpo',
    'knowledge', 'hard',
    'PPO scores actions against a learned critic; GRPO scores them against the average of a sampled group.',
    'PPO estimates advantage with a value network (critic) and generalised advantage estimation: A = GAE(rewards, V(s)). GRPO removes the critic entirely. For each prompt it samples a group of G outputs, scores them with a reward model or verifier, and normalises within the group: A_i = (r_i - mean(r)) / std(r). The policy is then updated with a PPO-style clipped objective (plus a KL term) using those relative advantages.',
    'The practical difference is cost and variance. Dropping the critic saves a second model of roughly policy size — its parameters, its optimiser state and its forward/backward pass — which matters a lot when the policy is a 7B+ VLA. The trade-off is that group-relative advantage is a noisier baseline than a fitted value function, so GRPO needs a reasonably large group (often 8-16) and benefits from verifiable rewards where correctness is unambiguous. PPO still wins when reward is dense and shaped, when sample efficiency dominates, or when you already maintain a critic for other reasons. In an interview it is worth adding that GRPO is not a new objective so much as PPO with a different advantage estimator.'
  ),
  (
    'f1000000-0000-4000-8000-000000000004',
    'Why does GRPO not require a critic?',
    'why-does-grpo-not-require-a-critic',
    'knowledge', 'hard',
    'Because the group mean of sampled rewards is itself a baseline for the advantage.',
    'Advantage only needs a baseline that is independent of the action being scored: A(s, a) = Q(s, a) - b(s). A learned critic V(s) is one choice of b(s). GRPO instead samples G outputs for the same prompt and uses their empirical mean reward as b(s). Since every sample in the group shares the same prompt, the mean is a valid, action-independent baseline — and it needs no extra network, no value loss and no GAE.',
    'What you give up is variance reduction. A fitted critic baselines against the *expected* return, so it can explain away how hard the prompt was; a group of G samples only estimates that expectation from G draws, and with G small the estimate is noisy. Dividing by the group std sharpens the signal but can blow up when all samples score alike (std near zero), which is why implementations clip or skip degenerate groups. This is also why GRPO became popular for verifiable tasks (math, code, unit-tested robotic subroutines) where reward is cheap and dense enough to sample many completions per prompt.'
  ),
  (
    'f1000000-0000-4000-8000-000000000005',
    'What is action chunking?',
    'what-is-action-chunking',
    'knowledge', 'medium',
    'Predicting a short sequence of future actions at once, then executing them open-loop before re-planning.',
    'Instead of mapping one observation to one action, the policy outputs a chunk of H actions a_t..a_{t+H-1}. The robot executes the chunk (often with smoothing) and re-observes. Chunking removes the strong temporal correlation between adjacent single-step predictions, shortens the effective horizon for credit assignment, and amortises one expensive forward pass over H control steps.',
    'Three consequences matter in practice. First, latency: a big model that cannot run at 50 Hz can still control at 50 Hz if it re-plans every 0.5 s and executes the chunk, which is exactly why ACT and pi0-FAST chunk. Second, compounding error: fewer re-planning events means fewer opportunities for the policy to react to drift, so chunks that are too long hurt on contact-rich tasks. Third, execution smoothness: consecutive chunks must be reconciled, usually by temporal ensembling or exponential smoothing across overlapping predictions. Interviewers often follow up on the chunk length trade-off — small H is reactive but jittery, large H is smooth but brittle.'
  ),
  (
    'f1000000-0000-4000-8000-000000000006',
    'What is Diffusion Policy?',
    'what-is-diffusion-policy',
    'knowledge', 'medium',
    'A visuomotor policy that generates action trajectories by iterative denoising.',
    'Diffusion Policy treats action generation as conditional denoising. A trajectory of H actions is initialised as Gaussian noise, then a denoising network eps_theta(a^k, k | o) — conditioned on observations o, often via a visual encoder — iteratively removes noise over K steps. Training is the standard DDPM objective: sample a clean trajectory, add noise at level k, predict the noise. At inference the denoised chunk is executed, possibly with receding-horizon control.',
    'Its appeal for robotics is representational: behaviour cloning with a deterministic MSE head must commit to one action, which on multimodal demonstrations collapses to the average of several valid strategies. A diffusion head can represent the whole mode set and still sample one concrete trajectory. It also extends naturally to score-based and energy-based conditioning and to inpainting constraints such as fixed start or goal states. The costs are inference latency (K denoising steps per decision, mitigated by DDIM samplers and distillation into one-step policies) and sensitivity to the noise schedule. Follow-ups worth preparing: how it compares to ACT (chunked transformers with a deterministic head) and to flow matching, which trains a continuous velocity field and typically needs fewer sampling steps.'
  ),
  (
    'f1000000-0000-4000-8000-000000000007',
    'What is a Vision-Language-Action model?',
    'what-is-a-vision-language-action-model',
    'knowledge', 'medium',
    'A model that takes images plus a language instruction and outputs robot actions.',
    'A VLA extends a vision-language model with an action head. Observations from one or more cameras are encoded into visual tokens, the instruction is tokenised, and a pretrained VLM backbone fuses them. A separate action expert — often a smaller transformer or a flow/diffusion head — maps the fused representation to continuous or discretised actions, and is trained on robot demonstration data.',
    'The motivation is transfer: pretraining on web-scale image-text data gives the backbone semantics ("a red mug on the left") that would take enormous robot data to learn from scratch. Design choices interviewers probe include continuous vs discretised actions (FAST tokenisers discretise action deltas, which lets the policy reuse the language modelling head and train with plain cross-entropy), single vs multiple camera views, proprioception and action chunking, and cross-embodiment training where different robots share the backbone with embodiment-specific action heads. The honest limitations to name: closed-loop latency, poor depth and force sensing from RGB alone, and the gap between semantic understanding and precise contact-rich manipulation.'
  ),
  (
    'f1000000-0000-4000-8000-000000000008',
    'What is an action-conditioned world model?',
    'what-is-an-action-conditioned-world-model',
    'knowledge', 'hard',
    'A learned dynamics model that predicts future observations given current state and a candidate action.',
    'Formally it approximates p(o_{t+1} | o_{t-k..t}, a_t..a_{t+H-1}). The model is trained on trajectories and, unlike a policy, it is queried: you propose an action sequence and ask what the world would look like. That makes it usable for model-predictive control (sample or optimise action sequences, score their imagined rollouts, execute the best first step), for planning, and for generating synthetic training data.',
    'The key design question is the latent space: pixel-space prediction is easy to supervise but wastes capacity on texture, whereas latent-space prediction (as in Dreamer-style RSSMs) is compact and cheap to roll out but needs a well-regularised latent or it collapses. The known failure mode is model exploitation — the optimiser finds action sequences the model *thinks* are good because they land in regions where the model is confidently wrong, which is why rollouts are kept short and combined with real interaction. For embodied AI specifically, world models are attractive because they promise to amortise expensive robot data: learn dynamics from large passive video, then plan with only a small amount of action-labelled data.'
  ),
  (
    'f1000000-0000-4000-8000-000000000009',
    'What is SE(3)?',
    'what-is-se3',
    'knowledge', 'medium',
    'The Special Euclidean group in 3D: all rigid-body poses — 3D rotation plus 3D translation.',
    'SE(3) is the group of transformations x -> Rx + t with R in SO(3) and t in R^3, six degrees of freedom. It is represented as a 4x4 homogeneous matrix [[R, t], [0, 1]], which makes composition a matrix product and makes it easy to chain transforms along a kinematic tree.',
    'Two things matter in robotics. Rotation parameterisation: SO(3) is a curved manifold, so representing orientation with 3 numbers (Euler angles) introduces singularities and non-Euclidean interpolation; quaternions, rotation matrices and the Lie algebra se(3) (6D twists, mapped by the exponential) are the usual fixes, and the choice of representation measurably changes how well a policy learns. Second, equivariance: because SE(3) is the symmetry group of rigid motion, models built to be SE(3)-equivariant generalise across object poses and camera viewpoints instead of memorising them — which is why equivariant and frame-canonicalising architectures show up in modern manipulation work. A good answer mentions that poses need a reference frame: SE(3) transforms are only meaningful relative to the frame they are expressed in.'
  ),
  (
    'f1000000-0000-4000-8000-000000000010',
    'What are the main stages of a robot data collection pipeline?',
    'stages-of-robot-data-collection-pipeline',
    'knowledge', 'medium',
    'Task definition, teleoperation capture, synchronisation, cleaning and labelling, curation, then training-time mixing.',
    '1) Task and embodiment definition — what is being demonstrated, on which hardware, with what success criterion. 2) Capture — teleoperation (leader-follower arms, VR or motion-capture controllers, exoskeletons) recorded at a fixed control rate, logging joint states, end-effector poses, camera streams, force/torque and gripper state. 3) Synchronisation and calibration — hardware timestamps, camera intrinsics and extrinsics, hand-eye calibration. 4) Cleaning — dropping failed or idle segments, trimming to the contact-relevant window, resampling, handling dropped frames. 5) Annotation — language instructions, sub-task segmentation, success labels, sometimes keypoints or affordances. 6) Curation and mixing — balancing task and scene diversity, deduplicating near-identical trajectories, and deciding the ratio of robot data to simulation or human video.',
    'The parts interviewers care about are the failure modes. Hardware drift and re-calibration silently invalidate collected data, so versioning each collection session with its calibration is essential. Teleoperation is the throughput bottleneck, which is why the field leans on cross-embodiment datasets, simulation augmentation and human video pretraining. Demonstration quality dominates quantity: a smaller set of consistent, smooth, successful trajectories usually beats a large noisy set, because behavioural cloning fits the noise as readily as the skill. Finally, the dataset contract matters — action and observation spaces must be pinned down per embodiment, or data collected this month will not train next quarter''s policy.'
  );

-- >>> BEGIN generated interview posts (2026小红书具身智能面经_图片OCR问答版) — DO NOT EDIT; regenerate with scripts/generate_interview_seed.py
-- companies added for real interview posts
insert into public.companies (id, name, slug, country, industry, description) values
  ('fa6f5baf-4b12-5681-8917-7ca37237ce8d', 'Momenta Mstar', 'momenta-mstar', 'CN', '机器人 / AI', null),
  ('58be7dcf-d15e-5551-9597-370d283556f4', '乐聚机器人', 'leju-robotics', 'CN', '机器人 / AI', null),
  ('d9454e48-5588-5133-a1c1-f4b640d279a1', '京东', 'jd', 'CN', '互联网 / AI', null),
  ('8f7d241f-3c3a-5481-b9ce-0de1f7e2edd1', '众擎机器人', 'engineai', 'CN', '机器人 / AI', null),
  ('d53a777d-307d-50da-b988-9544856bdd25', '优必选', 'ubtech', 'CN', '机器人 / AI', null),
  ('366fb5d3-5c19-5c6e-ab63-0f8f1d6d1864', '千寻智能', 'spirit-ai', 'CN', '机器人 / AI', null),
  ('d44efca3-26a1-5c91-a1d0-9b1fade65eeb', '华为', 'huawei', 'CN', '互联网 / AI', null),
  ('ed0dfbe2-fffa-5f42-9095-c1ec99503035', '卧安机器人', 'woan-robotics', 'CN', '机器人 / AI', null),
  ('953d5777-8b56-57bd-b8dc-cf95957e7d28', '原力灵机', 'yuanli-lingji', 'CN', '机器人 / AI', null),
  ('2a2ae66f-2231-5d67-84c9-7752fa2f003d', '它石智航', 'tashi-zhihang', 'CN', '机器人 / AI', null),
  ('b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', '小米', 'xiaomi', 'CN', '互联网 / AI', null),
  ('a903d498-a43d-5885-bb9b-fd7bf058a37c', '小马智行', 'pony-ai', 'CN', '互联网 / AI', null),
  ('712241b7-9724-541b-8d62-2ac3e8478d89', '小鹏汽车', 'xpeng', 'CN', '互联网 / AI', null),
  ('5c4e398c-2ae0-52bd-bfff-8c8fd5d6ee7f', '拓竹科技', 'bambu-lab', 'CN', '机器人 / AI', null),
  ('0809bd24-5c41-5ff5-a34a-2e7f01ae4702', '星海图', 'galaxea', 'CN', '机器人 / AI', null),
  ('429a1770-4c54-5511-9cf4-47615acd1fdc', '普渡机器人', 'pudu-robotics', 'CN', '机器人 / AI', null),
  ('fc61e8a0-16ed-52f9-9eeb-e4e2c3823d97', '智源研究院', 'baaai', 'CN', '机器人 / AI', null),
  ('ab5d70d1-7af4-5a34-a3c0-8b63e3ae7b8e', '灵初智能', 'lingchu-zhineng', 'CN', '机器人 / AI', null),
  ('5daa0508-12c8-57cd-854d-422719fef109', '米哈游', 'mihoyo', 'CN', '互联网 / AI', null),
  ('29cdb524-7a10-5044-aeba-568f60b8b701', '腾讯', 'tencent', 'CN', '互联网 / AI', null),
  ('7a538768-3f89-5d2c-8125-b119a6265603', '自变量机器人', 'zibianliang-robotics', 'CN', '机器人 / AI', null),
  ('5fe20d47-519d-574b-b218-9c4ec119cf92', '蜜雪冰城', 'mixue-bingcheng', 'CN', '机器人 / AI', null),
  ('778f2726-0d59-5a88-9786-7d6ef5e395f8', '逐际动力', 'limx-dynamics', 'CN', '机器人 / AI', null),
  ('21b230c8-0e9d-568e-89b6-c04933d891e1', '银河通用', 'galbot', 'CN', '机器人 / AI', null),
  ('9c659df6-8b36-527a-9e78-3e6d804947c0', '阿里巴巴', 'alibaba', 'CN', '互联网 / AI', null)
;
-- align existing placeholder company names with the real posts
update public.companies set name = '字节跳动 Seed' where id = 'c1000000-0000-4000-8000-000000000001';
update public.companies set name = '宇树科技' where id = 'c1000000-0000-4000-8000-000000000005';
update public.companies set name = '智元机器人' where id = 'c1000000-0000-4000-8000-000000000006';

-- interviews (published, sourced from 小红书 2026 具身智能面经)
insert into public.interviews (
  id, company_id, position_id, year, season, location, interview_type, source_type, source_url,
  title, slug, round_count, summary, published_at, status, verified_at,
  experience_level, employment_type, application_stage, difficulty_overall,
  language, is_anonymous, quality_score
) values
  ('b29c8b43-69e3-5bb2-a14a-b415cd5932e3', '8f7d241f-3c3a-5481-b9ce-0de1f7e2edd1', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '众擎机器人｜具身秋招小结之粗糙版面试过程记录', 'engineai-2026-01-010a82', 3, '多模态 强制线下面试，一天内速通三轮技术面，前两轮都有手撕。（真手撕，在纸上写的那种，不会太难） 众擎机器人，vla岗位 总共两轮技术面，全程无手撕，但一面八股较多较细。二面是具身算法总负责人。', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('e0167402-ecc3-5d5c-89ad-935fe82bbcc1', '366fb5d3-5c19-5c6e-ab63-0f8f1d6d1864', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '千寻智能｜具身秋招小结之粗糙版面试过程记录', 'spirit-ai-2026-01-010a82', 3, 'vla岗位 总共两轮技术面，全程无手撕，但一面八股较多较细。二面是具身算法总负责人。 千寻智能，vla岗位 总共四轮技术面，全程无手撕。二面大主管面，三面高阳老师，四面CEO韩峰涛老师。', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('1ac2118a-1561-5178-8f88-45b85c84f456', 'd44efca3-26a1-5c91-a1d0-9b1fade65eeb', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '华为｜具身秋招小结之粗糙版面试过程记录', 'huawei-2026-01-010a82', 3, '的手撕不是常规题目） 华为，多模态 强制线下面试，一天内速通三轮技术面，前两轮都有手撕。（真手撕，在纸上写的那种，不会太难）', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('cc1a2e8d-a1bc-579d-a075-a2f2761f733e', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '字节跳动 Seed｜具身秋招小结之粗糙版面试过程记录', 'bytedance-seed-2026-01-010a82', 3, '未来星，具身机器人部门。一面无手撕，一面后挂 字节seed ，机器人多模态研究员。一面无手撕，一面后挂', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('ac7c0878-6d51-55cd-966d-cee3f35e1e4c', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/696f65ef000000001a0312e7', '字节跳动 Seed｜字节Seed一面面经', 'bytedance-seed-2026-01-0312e7', 1, '12月面了字节seed，分享分享 1️⃣简短的自我介绍 2️⃣基础知识问答——八股 1. 详细描述，如果给一个txt存储的文本，从预处理到SFT的训练流程，要包括对数据的预处理、tokenize、forward、loss计算、参数更新，越细越好 2. tokenizer怎么做的，有哪些tokenizer的实现方式 3. embedding怎么做的，从id到embedding有哪些实现方式 4. transformer八股 transformer的forward计算包含哪些部件 如何解决梯度消失和梯度爆炸的 非线性由什么来提供 3️⃣项目经历 1. 介绍自己最熟悉的一个项目，项目中做了什么 2. 一些对项目细节的提问 3. 这个项目的意义 4. 后续打算做什么 4️⃣手撕：用numpy，写MHA 5️⃣反问环节 听说字节seed进面门槛是2A，随意从内推网投递属实是没想到自己能进面，匆忙准备，甚至没背八股，猝不及防了🏳️', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('8fd78f7c-d912-5ccb-a8b7-d8735788d8fa', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/696f41c0000000000a03c6f1', '字节跳动 Seed｜字节seed机器人具身算法实习一面挂', 'bytedance-seed-2026-01-03c6f1', 1, '不愧是字节seed，我这个小菜鸡果然被狠狠拒绝了面试没有刁难的问题，一直在问之前那篇关于数据生成的工作，还有对于原来那篇工作的延伸思考，有没有可以改进的地方，有没有应用到困难任务的前景，最后是手撕一道简单的算法题（虽然简单但我还没做出来，一道关于栈的使用的题目，属于很简单的） 虽然面试并没有遇到棘手的问题，也都回答上来了，但还是被挂了，感觉bar还是很高的。 整个面试流程效率很高第一天中午投递的申请，第二天就约面试了。然后面试那天下午面完，晚上就发邮件被拒了 本人bg：本硕双九，研二在读，一篇一区在投（机器人模仿学习相关），无实习经历', '2026-01-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('1cf45c94-12e5-5199-b125-6dd324ca085f', 'b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '小米｜具身秋招小结之粗糙版面试过程记录', 'xiaomi-2026-01-010a82', 3, 'vla岗位 有专门的笔试环节，通过后两轮技术面，无手撕。 一些不完全的面试过程记录（因为中道崩殂了）： 小米未来星，具身机器人部门。一面无手撕，一面后挂', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('ebb98a2e-6e64-5379-bbd9-21c40c435916', 'a903d498-a43d-5885-bb9b-fd7bf058a37c', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '小马智行｜具身秋招小结之粗糙版面试过程记录', 'pony-ai-2026-01-010a82', 3, '实验室 总共四轮技术面，全程无手撕，最后一面是张正友老师。 小马“pony star”计划，感知/端到端部门 总共五轮技术面，总共两个部门面试。一二面是不同部门的 均有手撕，三四面是不同部门的leader面，五面是CTO楼教主加面。（小马的手撕不是常规题目）', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('14407c87-1eb5-513f-a42b-7206d5527672', '712241b7-9724-541b-8d62-2ac3e8478d89', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '小鹏汽车｜具身秋招小结之粗糙版面试过程记录', 'xpeng-2026-01-010a82', 3, '仅个人经历记录和分享。 博士，校招。 小鹏机器人，vla研究员 总共两轮技术面，一面有手撕，二面是部门大leader葛老师。', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('7c83531b-64f7-5996-8a2f-88e5e8d714d7', 'fc61e8a0-16ed-52f9-9eeb-e4e2c3823d97', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '智源研究院｜具身秋招小结之粗糙版面试过程记录', 'baaai-2026-01-010a82', 3, '机器人，vla研究员 总共两轮技术面，一面有手撕，二面是部门大leader葛老师。 智源“智星”计划，vla方向 总共五轮技术面，一面手撕coding面，二面主管面，三四面是交叉面，五面院长面。', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('131c9e20-b988-5dad-a92e-bfa398991a82', 'ab5d70d1-7af4-5a34-a3c0-8b63e3ae7b8e', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '灵初智能｜具身秋招小结之粗糙版面试过程记录', 'lingchu-zhineng-2026-01-010a82', 3, 'vla岗位 总共三轮技术面，全程无手撕。终面是CEO张巍老师。 灵初智能，vla岗位 有专门的笔试环节，通过后两轮技术面，无手撕。 一些不完全的面试过程记录（因为中道崩殂了）', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', '29cdb524-7a10-5044-aeba-568f60b8b701', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '腾讯｜具身秋招小结之粗糙版面试过程记录', 'tencent-2026-01-010a82', 3, '“智星”计划，vla方向 总共五轮技术面，一面手撕coding面，二面主管面，三四面是交叉面，五面院长面。 腾讯“青云”计划，roboticsx实验室 总共四轮技术面，全程无手撕，最后一面是张正友老师。', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('698d0993-d8c2-576b-940b-5f07f4e1a1a0', '778f2726-0d59-5a88-9786-7d6ef5e395f8', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '逐际动力｜具身秋招小结之粗糙版面试过程记录', 'limx-dynamics-2026-01-010a82', 3, 'vla岗位 总共四轮技术面，全程无手撕。二面大主管面，三面高阳老师，四面CEO韩峰涛老师。 逐际动力，vla岗位 总共三轮技术面，全程无手撕。终面是CEO张巍老师。', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('92d55798-5fd0-5a58-8a3d-6e8d070128b5', '9c659df6-8b36-527a-9e78-3e6d804947c0', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69638fb2000000000b010a82', '阿里巴巴｜具身秋招小结之粗糙版面试过程记录', 'alibaba-2026-01-010a82', 3, '机器人多模态研究员。一面无手撕，一面后挂 高德阿里星，vla基座部门。一面无手撕，二面通知转普通岗，没继续', '2026-01-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('73c830ed-cba2-55a8-92c2-40d0a6351619', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69859932000000001502200a', '字节跳动 Seed｜字节seed具身智能方向面经拆解', 'bytedance-seed-2026-02-02200a', 1, '这是 SEED 团队探索的核心技术路线之一，核心逻辑： 世界模型：学习环境的动力学模型，预测动作对环境的影响，构建 “想象空间” 强化学习：在想象空间中高效探索，生成优化策略，再迁移到真实环境 核心优势： 大幅提升样本效率：智能体可在 “脑中” 预演，减少真机试错 增强泛化能力：世界模型可学习环境不变量，提升跨场景适应力 降低 Sim2Real 成本：模型学习的是抽象动力学，而非具体环境参数 GR-RL 中融入世界模型思想：通过轻量级预测器捕捉环境变化，提升策略鲁棒性 欢迎大家评论区和群里交流想法 关注我，获取更多大厂面试真题', '2026-02-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('371f89d5-22a5-5d82-9907-f60f39448388', '778f2726-0d59-5a88-9786-7d6ef5e395f8', null, 2026, 'Winter', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69a2f9d20000000026031633', '逐际动力嵌入式实习生一面面经', 'limx-dynamics-2026-02-031633', 1, 'HR开始一直在测试网络 只开了两分钟的人脸 面试开始首先我先做了很长一大段自我介绍 然后HR针对我简历中提到的 RTThread和FPGA的内容进行提问 主要问了一下任务优先级和多时域CDC的同步怎么解决的 然后告诉我 我面试的这个岗位主要还是做传感器的数据融合 然后问了很多关于数据融合的问题 主要是关于现实应用的 比如温飘怎么解决 陀螺仪的数据和里程计怎么做综合 然后主要聊了一下公司内做强化学习的和做嵌入式开发的会不会有冲突 以及相关的人员培养计划 顺利的话 一般是过一天就会出结果', '2026-02-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69a3bb0d0000000015021134', '智元机器人｜具身智能VLA实习经验贴', 'agibot-2026-03-021134', 1, '作为双2工科硕士，我通过扎实的论文基础和面试技巧，成功拿到智元机器人的Offer。避雷小贴士：避免去技术混乱或无正职带路的公司，面试时强调学习工业经验，接触过技术即回答“接触过”。', '2026-03-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('ffb51324-adde-5bed-b17f-938ef56df3ca', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69ae8089000000001a01c5e5', '智元机器人｜具身VLA实习部分面经总结', 'agibot-2026-03-01c5e5', 1, '研一在读，做过一个智元具身模型的部署训练微调工作。年前年后投了许多家具身初创或者有做vla的车企的实习，最后oc了三家。总体感觉这个方向找实习有一些运气成分，有些初创缺人的话就只有一轮面试，而且大部分具身公司不需要手撕，而车企的面试普遍会流程上规范一些有手撕的环节。 这段时间也积累了一些被问到的具身面试问题，给想找具身实习的大伙分享一下，希望能对大家有帮助。可能没记太全，想起来再继续补充。 1.pi0和pi0.5的区别 代码上什么区别 2.pi和gt00t的流匹配的区别 3.描述智元LAPA工作 4.ACT训练和推理的流程 4.数采原理和方式 5.RTC有没有做过，如何实现 6.模型预训练用什么开源数据 7.介绍自己用过的模型的整体框架与流程，模型输入输出，夹爪or灵巧手 8.接着上面的问题，模型具体使用时存在什么问题，可以怎么样改进或者创新 9.如何设计的具体任务，长序列为什么成功率低 10.有些企业还会问vlm相关的内容，比如transformer，vit，自回归生成的整个流程，模型多少b之类的 11.还有一些对技术方向的理解的问题，比如对世界模型有无了解，解释快慢系统，对数据来源的看法之类的 手撕类： 1.用pytorch写多头注意力 解释过程 2.leetcode的题 3.flowmatch伪代码 可能没记太全，想起来再继续补充。大家如果有自己遇到的一些经典具身面试问题也可以评论区互相补充一下互相帮助。', '2026-03-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('075552a1-508b-5417-a7c7-c139d328a5a6', '58be7dcf-d15e-5551-9597-370d283556f4', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69de80e6000000001a036f3c', '乐聚机器人｜乐聚 vla 一面面试经验', 'leju-robotics-2026-04-036f3c', 1, '参加了乐聚的春招面试，因为项目中有复现univla 并且里面涉及到 VQ- VAE 所以一上来对这方面进行了提问 1. VQVAE模型训练完成后，后续是否会对模型参数进行进一步调整？ 2. 本次研究中的VQVAE是否未采用预训练策略，而是直接进行端到端联合训练？ 3. 本次研究采用四个Codebook进行特征表示，相较于原版VQVAE单一Codebook设计，具体实现方式是什么？ 4. 是否对VQVAE中Codebook的特征利用率进行过分析？针对Codebook利用率偏低的行业共性问题，是否有相关研究与思考？ 5. 结合本次研究任务的复杂程度，选择16个Codebook维度的依据与合理性是什么？ 6. VQVAE模型的输入是否包含语言Token特征？请说明具体设计思路。 7. 在视觉特征提取环节选用DINO模型，未采用更新的DINO V2版本的原因是什么？ 8. 请简要阐述DINO V2相较于DINO V1版本的核心改进点。 9. 目前深度学习模型量化与压缩的主流方法有哪些？ 10. 此前研究方向聚焦目标检测领域，为何转向机器人具身智能相关研究？ 11. 除复现相关算法模型外，对机器人运动学、控制理论等专业知识是否具备一定了解？ 12. 请说明在科研项目与实习项目中的团队分工、个人负责内容及核心贡献占比。 13. 请阐述个人未来的职业发展规划与研究方向定位。 14. 结合行业实践经验，当前机器人具身智能技术落地过程中面临的主要问题有哪些？ 面试时有两个面试官 一位研发一位HR 所以最后会涉及一些 价值观问题 @职场薯', '2026-04-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('9668bb19-fe22-500e-b57e-4640b54b5d55', 'd53a777d-307d-50da-b988-9544856bdd25', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69ea32e6000000001f005215', '优必选实习面经', 'ubtech-2026-04-005215', 2, '投实习以来拿到的第一个offer，感动 我投的是大模型算法（世界模型方向），这个岗写的好像是只招博士目前。Boss直聘投的，推进很快，投了以后Hr直接电话约面试了，效率非常高，没有各种繁琐的测评，体验真的比投一些大厂爽的多。 一面是直接和实验室的负责人的技术面，面试官感觉人挺和善，有点小帅，浅挖了一下简历（可能因为我算是转行过来，之前没做过生成方面的工作），后面就是一直问八股，包括世界模型，各种生成模型，以及VLM（因为我主要做这个方向，所以VLM问的多一点，也比较深入），不过个人感觉问的都不算特别难，对各个领域有一些基本的了解就OK。 Coding考了一个多头注意力实现，但是感觉我写完他都没咋看就完事了。 然后就是隔一天就有HR联系我说一面通过了，二面就是和HR电话聊了一些问题，体验也挺不错，下午就告诉我二面通过然后商量offer啥的。 总之是一次体验非常好的面试体验（尤其是在华为实习机试通过综测被挂的情况下），公司和岗位也比较满意，后面堆的面试基本全推了。', '2026-04-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('c735ad49-26b9-5253-b1ab-6d4dbef3ad5c', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69d50c7f000000001d018d6b', '字节跳动 Seed｜本科字节seed一面面经（已通过', 'bytedance-seed-2026-04-018d6b', 1, '面试主要让我自己选一个项目来介绍，由于我这个是后训练的，所以我就讲的一个Agent RL的科研经历 整体面试比较偏压力面，面试官一直在拷打，但整体是针对科研的细节和idea，没有工程上的提问。 代码题： 1. 给定正整数n 输出1-n的全排列 2. 关于贝叶斯的一道代码题 二编：没有已发表的顶会论文', '2026-04-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('0eb7c091-2576-5377-b5fa-05f1e22ac101', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69ddbb4c0000000021005e3b', '字节跳动 Seed｜博0字节seed实习二面面经（已通过）', 'bytedance-seed-2026-04-005e3b', 2, '二面也主要拷打项目。 问了些项目中的训练方面的细节，有没有接触过stf，RL训练等等。 还问了个场景题：如果让你去训练Doubao的专业输出能力，会怎么做 最后没有考代码。周五面试，今天发三面通知', '2026-04-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('0883be4f-2c16-51d1-9a56-4649459d2baf', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69e09511000000001b022652', '智元机器人｜智元vla 一面面试经验', 'agibot-2026-04-022652', 1, '1. 在自回归解码中使用 KV Cache 时，key 和 value 分别缓存的是什么特征？如果在机器人视觉动作模型中启用 KV Cache，会对时序动作推理带来哪些影响？ 2. 当模型采用 Group Query Attention（GQA）或 Multi-Head Attention（MHA）结构时，KV Cache 的存储和索引方式会有什么不同？如何避免在长序列机器人任务中因 KV Cache 过大导致显存溢出？ 3. 为什么在 UniVLA 中直出式 action decoder 效果比 flow matching 更好？ 4. Self Attention 的完整计算流程是什么？ 5. 注意力计算中为什么要除以 √dₖ？ 6. Group Query Attention（GQA）的结构和作用是什么？ 7. 模型输出的是关节角还是末端位姿？具体自由度是多少？ 8. 采用多任务混合训练，相比单任务单独微调，效果有什么差异？ 9. 数据集是如何采集、预处理并接入训练流程的？整个数据链路是怎样的？ 10. 训练时的硬件配置、数据量与训练时长大概是多少？ 11. 你在动作解码模块做了哪些优化？为什么这么设计？ 12. 有没有尝试过位置编码来增强左右手空间感知？效果如何？ 13. 模型在推理时出现机械臂停滞、动作不连贯的原因是什么？ 14. Uni VLA 训练时遇到的主要瓶颈是什么？为什么无法利用历史帧？ 15. 本地评测结果和官方榜单是否一致？如何验证模型性能？ @职场薯', '2026-04-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('8b3066a2-755d-5bc6-87ab-bfe66829323e', 'd9454e48-5588-5133-a1c1-f4b640d279a1', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a01545600000000350259db', '京东｜0pub0实习具身选手勇闯算法暑期 tl及面经', 'jd-2026-05-0259db', 2, '4.13 一面挂（面试官极其逆天，迟到+不开摄像头+不听项目讲解，直接要求手撕项目代码） 京东： 进度最快的一集。两位面试官人都超好。 4.17 周五一面，周一约4.21二面，隔天约4.27hr面，第二天电话oc，流程非常快，可惜商讨后方向略有分歧，最终拒掉了。我还是爱东哥的。', '2026-05-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d717e931-3a92-56b6-9aef-a303a6813235', '366fb5d3-5c19-5c6e-ab63-0f8f1d6d1864', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69fd9548000000003701d805', '千寻智能｜具身求职day1＆面经', 'spirit-ai-2026-05-01d805', 1, 'bg:本科大三，无论文，一段项目实习经历 第一场面的千寻智能。先自我介绍+简单问了一下能够实习的时间，然后开始围绕简历提问。主要内容围绕我之前做过的rl运控项目，问了问整体设计和一些具体的技术细节，因为是自己做的所以答的还比较顺畅。 coding：一道很简单的编程题，甚至不涉及什么算法，也就是大一刚学计概时候的练习题水准，没想到自己太久没手写代码了居然这都没写完... coding之后又按照简历上写的专业技能挑了几点问，问了一些有关电机参数和pd控制的，还问了π0的架构，不过VLA这边只浅看了几篇论文，确实不太熟悉，答的马马虎虎的，也是漏洞百出 由于是第一次面试，多少有些紧张，不过面试官人很好，哪怕我出了很多差乱也始终很耐心，确实是我准备的太匆忙了吸取教训准备下一次吧', '2026-05-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('c3c05533-b404-549b-8e07-1f1ac366419d', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a01545600000000350259db', '字节跳动 Seed｜0pub0实习具身选手勇闯算法暑期 tl及面经', 'bytedance-seed-2026-05-0259db', 2, '试官人都超好。 4.17 周五一面，周一约4.21二面，隔天约4.27hr面，第二天电话oc，流程非常快，可惜商讨后方向略有分歧，最终拒掉了。我还是爱东哥的。 字节： Seed具身人才暑期 4.16一面，4.21横向挂 最奇怪的面试，因为我听说4月之后已经不招27届暑期实习生，官网jd也明确写28届以后。 hr约面前说组内分部门，问我意向部门有哪些，我明确拒绝了其中两个部门。 面试过程非常顺利，相谈甚欢，都聊到实习时长和入职时间和我想做的事情了，直到面试官开始谈组内业务，正好是我拒绝的两个部门之一……我当场表示抵触，最后手撕都没有，果不其然横向挂。 我的简历被挂之后被莫名捞了起来，让我去面ai agent。最后拒掉了面试。 简历挂/泡池子： 字节： 多模态世界模型暑期实习、机器人大模型日常实习。cv和多模态topseed选手的战场，凡人勿入。', '2026-05-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('9c237907-490e-55ba-82b0-427c6122ca2c', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/69fe1a130000000036003428', '智元机器人｜智元面经', 'agibot-2026-05-003428', 1, '还是得潜下心来一点点把数学学透，代码还是得深究，还是得坚持！！', '2026-05-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d77ac39b-994f-5087-80a0-a633ffdf87bc', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a01545600000000350259db', '智元机器人｜0pub0实习具身选手勇闯算法暑期 tl及面经', 'agibot-2026-05-0259db', 2, '4.6开始投简历和刷lc，大概投了十多家暑期的具身岗，全部头铁官网投递，今天终于收到offer。 只投了World Model相关岗位。 智元： 4.13 一面挂（面试官极其逆天，迟到+不开摄像头+不听项目讲解，直接要求手撕项目代码）', '2026-05-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('1d6bb797-8565-58c2-a209-46f3b978fa29', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a142f92000000003502206e', '自变量机器人产品经理实习面经', 'zibianliang-robotics-2026-05-02206e', 1, '1.自我介绍 2.介绍项目中RAG的部分 3.怎么处理数据的 4.如何做到模型可靠的 反问环节 大部分关于技术的问题，产品方面比较少，就是拷打简历 发面经积攒一下人品，求oc', '2026-05-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('6827cecb-a83b-5518-a063-916ca69ad7cb', '778f2726-0d59-5a88-9786-7d6ef5e395f8', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a018b64000000000702cc86', '逐际动力硬件一面', 'limx-dynamics-2026-05-02cc86', 2, '5.8 逐际动力一面 面试时间：半小时左右 面试内容：首先自我介绍，然后基于简历项目针对性问了一些硬件内容；因为是机器人公司，所以问我是否对电机相关的有所了解，是否做过电机的项目，还问了对于人形机器人的主控板的硬件设计框架和思路，以及对于人形机器人未来应用场景、看法和发展前景等等。 面试体验：面试的小姐姐人很好，不会有压迫感，感觉团队氛围很好，比较自由 进展：5.12进行二面', '2026-05-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d04d51ea-12e2-59b3-ab30-e7f0784bd80d', '778f2726-0d59-5a88-9786-7d6ef5e395f8', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a02aafb0000000006037623', '逐际动力硬件二面', 'limx-dynamics-2026-05-037623', 2, '面试时间：5.12 35分钟左右 面试内容：首先进行自我介绍，接着面试官针对简历项目进行提问（这次问的很细节，包括项目整体思路，器件选型等等）；问了实习经历，熟悉哪些软件，开关电源的应用场景和layout需要注意的事项，以及高速信号内容和仿真过程等等。 面试体验：面试官人蛮和蔼，不会给压力。 进展：已oc', '2026-05-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('6c9c21dd-a683-553e-b5e1-67d870e48f1a', '21b230c8-0e9d-568e-89b6-c04933d891e1', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a01545600000000350259db', '银河通用｜0pub0实习具身选手勇闯算法暑期 tl及面经', 'galbot-2026-05-0259db', 2, '银河通用（可能更倾向直接能干活的） 总体来说这个方向的面试过程比较固定： 一面主要问项目细节，最后配一道不太难的手撕（mha和双线性插值） 二面在项目细节的基础上穿插对研究方向的理解（比如WM和VLA的区别、如何解决方向中的某些难题等） 全程没有遇到过任何直接的八股问题，因为面试官水平很高，在问到项目中的问题时，如果你不懂得那些知识是不可能准确的答出来的。 例如问为什么World Model能够解决VLA无法解决的问题，你肯定要从常用的几个模型及其架构、训练等出发回答。所以不推荐背八股，更推荐把自己的项目彻底弄清楚，从数据输入到最终输出的一切都要掌握。 最后祝愿大家都有理想的offer！', '2026-05-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('c0951177-c779-585f-ac70-1807855e40cb', '9c659df6-8b36-527a-9e78-3e6d804947c0', null, 2026, 'Spring', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a01545600000000350259db', '阿里巴巴｜0pub0实习具身选手勇闯算法暑期 tl及面经', 'alibaba-2026-05-0259db', 2, '相谈甚欢，都聊到实习时长和入职时间和我想做的事情了，直到面试官开始谈组内业务，正好是我拒绝的两个部门之一……我当场表示抵触，最后手撕都没有，果不其然横向挂。 阿里系： 高德： 约面之前以为是备选项，后来仔细了解之后才发现是最好也最对口的，明显感觉面试官很懂技术，也是最终去向。不过流程最慢。 4.21 一面，隔天约4.23二面，4.27约5.6三面。 hr面当面告知需要3-5个工作日的横向对比，最终5.11oc。 淘天： 我的简历被挂之后被莫名捞了起来，让我去面ai agent。最后拒掉了面试。 简历挂/泡池子', '2026-05-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('fa7d4b98-0a02-51c9-b809-159572a91155', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a1f98850000000021019200', '字节跳动 Seed｜字节seed多模态一面面经', 'bytedance-seed-2026-06-019200', 1, '我这个bg不知道为什么能被hr和业务捞起来面，想了一整晚也没想明白。第一次面字节就是Seed，没有想象的压力，全程是一种技术交流的心态。 流程： -简单自我介绍 -针对我的八股：为什么学这个专业？套公式回答 -实习拷打：2中厂后训练+1 research岗Agent+RAG（offsite，改了下时间线） 1. 问之前的业务线，整个业务的pipeline，项目怎么给公司带来盈利？ 2.sft到什么程度在做RL？ 3.0.5h对数据层面提出很多疑问，面下来对cot数据制作部分比较感兴趣（sft里加了个loss惩罚，放了个钩子） CoT数据，preference数据，trajectory数据，tool-use数据，failure case数据 4.DPO，PPO，GRPO等时间线八股 -skill，memory，harness -Agentic RL了解 /场景题：风控场景中人都无法进行判断的诈骗，如果让大模型完成任务？ - 论文提问（first author，under review，约等于没有） 1篇传统NLP，3月投 1篇Agent相关，5月投 2篇都是通过堆图片速成的，面试官对文章提出质疑+给出一点建议 总结： 总的来讲不算难，较基础。对 RL 基础的考察比较深入，仅停留在背诵结论的层面不太够，最好能够从公式，优化目标和实际训练过程出发进行解释。 Agent 相关的问题相对较浅，考察对 skill、memory、harness等技术的基本了解，怎么vibe coding的，没有过度深入具体实现细节。 数据是面试官最关注的方向之一，这一点在我近期参加的多场大模型相关面试中都是重点。我认为一方面，数据质量直接影响整个训练 pipeline 的效果；另一方面，团队目前可能有较强的业务落地需求，作为一个实习生，实际工作中应该会涉及较多数据构造和处理任务。 一天后挂。让我去Seed洗数据我也愿意', '2026-06-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('25d3adba-d597-5453-a23b-463c8af9f356', 'b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a42a28d0000000006034493', '小米｜具身智能面经分享', 'xiaomi-2026-06-034493', 1, '前研二，截止到现在也在具身干了两段实习，从去年十月到现在差不多也八个月了。去年十月第一次出来面具身实习，那会儿简历上全是仿真项目，没有任何VLA经历。一口气面了小米', '2026-06-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('4618d4f8-da36-50ef-bfec-f63688032da9', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a3b4f53000000001702851c', '自变量机器人｜自变量嵌软一面面经', 'zibianliang-robotics-2026-06-02851c', 1, '1. 先简单介绍一下你自己吧，重点说说你在机器人战队里的角色和技术方向。 2. 你更偏向软件还是硬件？什么时候开始接触硬件的？ 3. 你提到软件经验多，能讲讲中断机制吗？什么是中断？CPU如何处理中断？ 4. 中断服务函数有什么编写要求？ 5. 在多任务环境下，如果全局变量在中断和主循环里共用，你会怎么处理？ 6. 你们战队常用的通信总线有哪些？CAN总线用得怎么样？遇到过哪些问题？ 7. CAN总线的终端电阻是怎么回事？为什么要加？怎么加？ 8. 调试时你们用UART串口打印吗？现在常用什么调试手段？ 9. 你们的Bootloader是怎么设计的？有没有做远程升级？ 10. Bootloader具体怎么实现无线升级？需要哪些通信方式？ 11. 你们现在的开发工具链是怎样的？为什么从Keil换到CMake+ARM-GCC？ 12. 你们用FreeRTOS吗？相比裸机开发有什么好处？ 13. 你做过的项目中，哪个最难？难在哪里？ 14. 讲讲你是怎么用AI辅助开发的。 15. AI编程给你带来什么体验？对程序员的要求是变低还是变高？ 反问环节 ----------------- 基本上都是简历项目上的问题，纯八股少，流程挺快的，面完就出结果了，感觉前面答得还行，后面Bootloader就开始乱说了', '2026-06-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('91c389f6-a6c0-51ad-b604-3df5a7707765', 'd53a777d-307d-50da-b988-9544856bdd25', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a4928b30000000011007a38', '优必选项目管理面经（已offer', 'ubtech-2026-07-007a38', 2, '优必选的项目管理offer，20W+年薪，直接上岸。 这个岗位，最开始她私信了很多次，才换来的一个机会 她自己也面过其他公司，但优必选一直没动静。 面试后offer推进也比较困难，看得出来一直在横向对比池子里泡着，推进得很慢。 就这么来回拉扯了一段时间。每一次都觉得“这次应该差不多了吧”，然后又被告知还在对比、还要再看看。 说实话，中间她也挺焦虑的。横向对比这个阶段，最磨人，你不知道对面在比什么，也不知道自己要等到什么时候。 ⬇️下面把她的面试经历整理出来，给想冲机器人赛道的宝子们参考 面试流程 一面（业务面） ：项目经理或部门经理直接面，考核内容非常有针对性，基本是考核实际项目中所需要的技能。 二面（综合面） ：更偏向个人特质和职业规划。 HR面：聊稳定性、薪资期望、到岗时间等。 ✅面试真题回顾 项目管理类： 1. 什么是敏捷项目管理？ 2. 项目的最大难点在哪里？ 3. 你会怎么管理这个项目？关键点是什么？ 4. 你认为在完成一个长时间的项目过程中，你作为项目经理最独特的特质是什么？ 5. 职业规划是什么？ 个人特质类： 1. 优缺点是什么？ 2. 喜欢什么风格的领导？ 3. 有没有别的offer？ ✅再说几句，如果有一个岗位你特别想去，投了没回音，不要干等。 主动跟进、反复优化、持续沟通 其次想冲硬件+AI方向的，这家值得放进清单里。 冲就完事了💪', '2026-07-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('824207f1-1767-5157-8873-ad3008e26dd7', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a58c5be00000000010325c3', '自变量机器人｜自变量一/二面合集', 'zibianliang-robotics-2026-07-0325c3', 2, '个人项目信息脱敏 一些相关问题 1.lerobot格式数据meta data里面保存的是什么 2.diffusion和flowmatching的区别 3.pi0.5和pi0的区别 4.pi0.5训练用了多少数据 训练了多久 5.力扣简单题目 6.注意力机制公式 为什么除以根号dk 7.多头注意力机制原理 优势 时间复杂度 8.umi数据和真机数据时间尺度不一样 怎么对齐 9.怎么利用失败的数据 10.umi数据最重要的部分是什么 有试过ik逆解 可视化轨迹么 11.有没有做过鱼眼相机fov的实验', '2026-07-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('8c99d336-61ec-57f5-ad2a-7efed439c968', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a5dd9430000000011017453', '自变量机器人｜具身27届秋招记录', 'zibianliang-robotics-2026-07-017453', 2, '优才 1/3收到面邀 9.自变量提前批 没推进流程 总体来说，基本都没怎么遇到过手撕代码，全程围绕项目问，实习的流程推的快 主包最近实习比较忙，随缘更新～', '2026-07-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('3e40b227-ea8e-591c-8417-f0b9e91bd844', '5fe20d47-519d-574b-b218-9c4ec119cf92', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a6836990000000005039e38', '蜜雪冰城 VLA 算法工程师一面 面经复盘', 'mixue-bingcheng-2026-07-039e38', 1, '最近投了蜜雪冰城的 VLA 算法工程师，没想到第二天就约了技术面。 部门主要做具身智能饮品机器人，让机械臂根据自然语言指令，独立完成取杯、加冰、加糖、摇匀、封口和递交饮品。整场约 60 分钟，没怎么问八股，主要考察 VLA、强化学习、轨迹规划、多模态感知和奶茶制作流程。 问：你怎么理解 VLA？ 答：VLA 就是 Vision-Language-Action。Vision 识别杯子、冰块、柠檬片和顾客表情；Language 理解“少冰”“微糖”“不要香菜”；Action 控制机械臂加料、摇匀和封口。 问：用户说“少冰”，具体放几块？ 答：要结合杯型、室温、饮品种类和历史偏好。比如正常冰 12 块，少冰 6 块，微冰 3 块。 追问：冰块大小不一样怎么办？ 答：用视觉模型估计冰块体积，再闭环控制总冰量。 问：如何避免把柠檬片当成冰块？ 答：融合 RGB、深度和触觉。冰块透明、反光、温度低；柠檬片有黄色纹理和柔性形变。视觉置信度不足，就让机械臂轻轻夹一下，用触觉二次确认。 问：机械臂倒糖浆时手抖怎么办？ 答：检查控制频率、轨迹平滑性和电机参数，再用低通滤波、轨迹插值、阻抗控制和视觉闭环纠偏。 追问：如果是面试紧张导致手抖呢？ 答：建议机械臂先做一次深呼吸。 问：强化学习的 Reward 怎么设计？ 答：成功取杯 +1，正确加冰 +2，正确加糖 +2，成功封口 +3，递给顾客 +5，饮品洒出 -10，吸管插进顾客鼻孔 -100。 同时要避免 Reward Hacking，比如模型为了“不洒”，选择永远不递给顾客。 问：模型出现幻觉怎么办？ 答：如果顾客点的是柠檬水，模型却说成珍珠奶茶，可以通过订单检索、结构化指令解析和动作前校验降低幻觉。执行前再确认：“您点的是少冰柠檬水，对吗？” 问：当前具身智能最大的瓶颈是什么？ 答：不是参数量，也不是训练数据，而是高峰期顾客一直催单。模型刚完成长链路推理，旁边就有人问：“我的奶茶好了吗？” 最后我问：“岗位会提供训练数据吗？” 面试官说：“每天免费喝两杯，数据需要自己采集。” 目前已经进入人才库，HR 说后续有合适岗位会再联系。我感觉应该稳了，已经开始研究珍珠的 Sim2Real 迁移问题了。', '2026-07-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('1bee6efc-9dd9-5072-9d8c-532e504cc38b', 'fa6f5baf-4b12-5681-8917-7ca37237ce8d', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a7484be000000002500d171', 'Momenta Mstar｜官方面经！Mstar·世界模型算法工程师', 'momenta-mstar-2026-08-00d171', 1, '🤔想入职 Momenta？想秒懂“世界模型工程师”？ ✨成为“天选Momentum”的路上，请带上小M的独家面经！ 岗位核心职责有哪些？硬实力门槛迅速 get！ 真实成长体验大揭秘？带你走近工作日常！ 面试官最在意的候选人特质？一篇快速上手！ Follow 小M，即可获得专属内推通道，投递简历快人一步！', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('eaceb563-c968-550c-847b-8374ce47712c', 'fa6f5baf-4b12-5681-8917-7ca37237ce8d', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a830a640000000022012f6f', 'Momenta Mstar｜官方面经！Mstar·端到端大模型算法工程师', 'momenta-mstar-2026-08-012f6f', 1, 'M带着第3期Mstar官方岗位面经来啦！ “一个模型，能不能同时"看懂路况、想清后果、做出判断"？” 这次小M和面试官面对面聊了一个下午，开口就抛了这个问题，面试官不仅认真回答了， 还 Highlight 出了重点内容—— 在Momenta， 端到端大模型算法工程师能够做什么？ Mstar 同学的真实工作体验如何？ 面试官青睐的候选人特质有哪些？ 左滑图片，你想知道的都在里面！ 关于端到端大模型算法，还有什么想了解的？问题请在评论区大胆提问call M！', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('90ace5de-674d-52ad-b2d6-db177ed35cb2', '953d5777-8b56-57bd-b8dc-cf95957e7d28', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8832720000000008013f41', '原力灵机结构一面面经', 'yuanli-lingji-2026-08-013f41', 1, '由于本人第一次面试，没有任何经验，遂专业基础基本没答上来（全忘了😭）： 项目问题还算比较细，具体到某个具体结构设计的原因、零部件如何选型。 专业知识考察大概是这些，电机传动；列举你所了解的金属和非金属材料；电弧焊和线切割加工；3d打印；用机加工处理一根细长管要注意什么；铝合金有哪些表面处理方法。 基本都不会，尴尬得脚趾抠地第一次面试毫无准备，看来得好好准备专业知识了', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d9089ca5-3e5f-52a7-8dc3-8590dc24dd2d', '953d5777-8b56-57bd-b8dc-cf95957e7d28', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a90ebc8000000001f0064e2', '原力灵机一面（凉经）', 'yuanli-lingji-2026-08-0064e2', 1, '岗位：电子硬件集成研发工程师 六月底最早投的一批，当时还是实习，一直以为挂了，结果8.14约面了 拷打最深最细的一次面试，也是收获最大的一次面试，学了很多知识。面试官人也非常好，答不上来也完全不压力，我没答到或者说错的地方都会跟我讲解补充，也会引导我的回答，非常耐心。但是自己太菜了，很多知其然不知其所以然', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('f11aa476-8ca6-52b2-b295-d7d12f631f79', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a6d8ccb0000000022014daa', '字节跳动 Seed｜字节seed面经', 'bytedance-seed-2026-08-014daa', 1, '依旧字节seed面经，需要自取，不需要的看个乐呵！ 秋招加油！', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('6889ae7c-74df-5587-9ae5-512bec4052c4', 'c1000000-0000-4000-8000-000000000001', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a9581fd000000002a03d616', '字节跳动 Seed｜seed日常实习一面（已挂）', 'bytedance-seed-2026-08-03d616', 1, '主包也是完全没想到第一个给我发面试的居然是seed，感觉受宠若惊了，不过主包投递的岗位确实与我的上一段实习经历非常的match，主包虽然知道机会渺茫还是好好准备了面试 流程3min自我介绍+30min项目+20min算法+5min反问 项目我简历写了两部分，一部分是我的实习工作，另外一部分是我自己的项目，面试时只聊了我的实习工作，聊了大概三十多分钟，面试官问的很细，不过主包都是自己实打实做的，问的很多具体细节以及思考主包都想过。不过我看很多帖子seed的面经都问了大模型基础，我还特意复习了一下结果都没问八股（可能项目更加重要吧，而且match） 然后就是算法题，算法题是圆内点的均匀分布，看到题目第一眼其实我很懵逼，因为没看懂题目啥意思，想了十多分钟，最后写的伪代码，感觉面试官更加在意思路，也算是半ac吧。 面完当天没收到结果我大概就知道凉了，第二天问了下hr确实凉了，也是意料之中，hr给我的反馈结果大概意思还是相关经历太少，不过面评应该还行，因为后面被别的hr积极捞了，导致我目前的简历还在被锁中我都不知道锁在哪。。。 面试官非常的奈斯，整个面试都能感觉到被尊重，以及认真的交流，不过我也觉得一段小厂相关实习0论文确实够不到seed的门槛，明年再战', '2026-08-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d655261f-7518-5906-96ef-83d6417ad4af', '2a2ae66f-2231-5d67-84c9-7752fa2f003d', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a867cb8000000001702b73e', '它石智航 嵌入式bsp面经', 'tashi-zhihang-2026-08-02b73e', 1, '1.自我介绍 2.说一下在学校中主要做了哪些项目，介绍你对linux这一块和你刚才提到的RK3588，你重点把你学校做过相关的东西介绍一下 3.RTOS和linux之间的区别 4.RTOS下的调度时延明确的是吧？那linux下有方法能实现这种可预期的调度么（具体怎么实现的） 5.说一下linux中断下半部的几种实现方式，区别是什么？ 6.你有进行过linux中断相关的开发么？（我说没有，只有进行过ARM+RTOS上的中断开发） 7.什么情况下需要屏蔽中断？（我回答的是优先级翻转，不知道对不对）之后就问除了这个还有别的吗？ 8.数据结构有接触过么？你说一下链表和数组的区别，你说一下怎么去判断一下链表里面有没有环？ 9.说一下IIC协议？有用过么？说一下IIC里边上拉电阻阻值一般选什么？阻值的大小会影响什么性能？ 9.linux系统里面有哪些情况会产生段错误？（我没懂什么是段错误，从来没接触过），然后他就问你开发调试的时候没有遇到过段错误么？（我说是线程崩溃了么）他说你可以理解成线程崩溃（我就回答空指针或者越界，解决这种问题可以减少共享状态或者增加边界检查、看门狗或者说进行进程隔离） 10.进程隔离怎么解决段错误？（这是AI给的答案么） 11.你说一下函数指针怎么定义？你描述一下。 12.（手撕）假如我要定义一个int返回值，两个int参数的函数指针，怎么写？你可以直接敲，这里不有消息框么，发过来就行。（解释一下你写的这个定义） 12.什么是指针函数？ 13.反问（①这个岗位主要是做什么：答：嵌入式bsp么，就和你简历上写的这些是差不多的，RK3588或者其他soc芯片的bringup工作，比如设备树的点亮，RTOS也会涉及一些） ②你觉得我哪里做得不够好的，回去可以补充（答：理论基础有点太差了，当然我能感觉出来你刚才用AI了，你面试的时候就正常面试就可以了，你用了AI就没法判断你说的那些信息哪些是对的哪些是错的，就那些是你真是真实掌握的哪些是你没掌握的） ③这个岗位在实习和校招上在学历上和有明确的筛选条件么（答：目前没有，能力够就可以） 到此我就小破一防，没再问了，耻辱下播', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('2ac847df-522b-52b0-abc9-a166a8f56ea7', '2a2ae66f-2231-5d67-84c9-7752fa2f003d', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a86a288000000002800bde4', '它石智航实习面经', 'tashi-zhihang-2026-08-00bde4', 1, '我是今年三月份转入嵌入式linux学习的，导师给我的方向是端侧模型部署，但这玩意门槛太高果断转行。 个人感觉:项目>手撕代码>八股 先自我介绍 然后逮着项目问，掺杂一些八股 我感觉嵌入式岗位比较关心dma,内存方面的知识。代码的话力扣hoot100就够了，嵌入式更关心底层的数据结构的实现:内存池，fifo,大小端，内存对齐。 八股跟着网上经验贴背诵就行了，然后结合ai做一些demo。 一定要在面试中学习，而不是学习完再面试，没人能学完的', '2026-08-01 00:00:00+00', 'published', null, 'intern', 'internship', 'unknown', 'unknown', 'zh-CN', true, null),
  ('e57b850d-c3f9-520f-bc58-31010c516d2c', '2a2ae66f-2231-5d67-84c9-7752fa2f003d', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a881abc000000002a010c95', '它石智航｜秋招第十一面-它石智航（机器人电子硬件）', 'tashi-zhihang-2026-08-010c95', 1, '面试时间：35分钟左右 面试难度：正常 面试内容：首先进行自我介绍；然后开始问项目，首先讲一下项目的整体框架，项目需求是什么，设计完成后，各个指标有没有实际测试，能否满足目标；为什么要考虑多源数据采集，具体的方案是什么，各部分模块怎么选型的，会考虑哪些细节，具体带宽计算以及主控板是否满足通信带宽要求，USB协议有哪些，速率分别是多少，你的主控板有哪些外设资源，怎么分配的；你在公司中做信号仿真工作的流程是什么，眼图会重点关注哪些指标，各指标的含义是什么，怎么判断眼图是否合格，当遇到信号质量不合格情况，你是怎么排查问题，如何优化的；项目中经历过最困难的问题是什么，如何解决的，最后就是反问环节。 面试结果：等待hr通知。 秋招面试流程：一轮技术一轮综合，然后hr面', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('f5c3ed62-8af4-5aca-b627-9186184673cd', 'c1000000-0000-4000-8000-000000000005', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a70665c000000002402f7bf', '宇树科技 AI 大模型后端岗面经', 'unitree-2026-08-02f7bf', 1, '具身智能VLA面经复盘 2026-08-03，收到 1 条具身智能方向-宇树科技 AI 大模型后端岗面经投稿。 面试核心不在通用 LLM 算法，而是 **VLA（Vision-Language-Action）具身模型 + 机器人端云协同**。面试官明确在区分「懂通用 LLM 的人」和「懂机器人+LLM 的人」。以下提炼本批最高频考点。 **考点一：VLA 与通用 LLM 的本质区别** 这是面试核心区分题。通用 LLM（GPT-4、Claude）做文本对话，输出 token 序列。VLA 模型（如 UniFoLM-VLA）做的是文本指令→机器人动作向量，输出的是物理世界可执行的 action。回答时需体现对「LLM 从数字世界走向物理世界」这一趋势的理解，而非停留在文本生成。 **考点二：机器人业务系统设计** 不能只给互联网高并发标准答案。需主动覆盖三要素：①实时性——指令延迟毫秒级响应；②边缘算力受限——推理不能全放云端，需端侧 / 边缘侧推理；③硬件断连——断网本地降级、设备指令重传机制。面试官核心考察点：是否意识到互联网业务和机器人业务的最大鸿沟。建议多了解 ROS2 通信框架（话题 / 服务 / 动作）的基本概念，不要求手写节点，但需理解消息流转链路。 **考点三：具身智能行业认知** 面试官会先问「你了解宇树产品吗？看过官方开源仓库吗？」——诚意题。提前了解 G1、H1、Go2 等产品线，跑通 UniFoLM-VLA 推理代码，了解输入输出格式是基本要求。RAG/Agent 已从加分项降级为「默认基础」，真正的加分项在具身智能领域知识。 **考点四：后端经验在 AI 场景的独特价值** 面试官明确认可后端价值，不要求「抛弃 Java 做纯 AI」，反而看重分布式架构、服务化、设备接入等工程经验在机器人场景的迁移能力。他们要的是「懂后端的大模型应用工程师」，而非「半吊子算法工程师」。这对非算法背景转 AI 的候选人是个重要信号。 完整面经合集在 llmbases.com 第 9 章。', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('cfa77083-517a-5a6c-94c3-2335ea6f3e5f', 'c1000000-0000-4000-8000-000000000005', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a7811e0000000002201192e', '宇树科技一面：Agent调用工具失败如何处理', 'unitree-2026-08-01192e', 1, '今天笔记里Agent部分新增一个专题，我们聊聊Agent的健壮性设计。 这个问题为什么很重要，在我讲2026面试官最喜欢的6个AI项目里面，讲到了把Agent做的更加健壮，产生错误优雅处理和回退，是面试官比较关注的点，是区分你的项目是Demo还是企业项目的考察点之一。 同时最近我在解析面试真题，宇树科技Agent开发一面和英伟达一面都问了这个健壮性的问题。我们从这几点也可以看出来这个问题在面试中的重要性。 （ps: 英伟达Agent开发一面面试内容，我会马上精讲加入到笔记中，这个内容来自于我的好朋友，后面会给大家介绍） 所以笔记专门加入了一个专题，聊聊健壮性设计。我们会讲解比如工具调用失败，模型调用失败，推理失败等等各种失败，如何优雅处理和降级。同时将面试问题穿插其中。 这些各种失败里 ，最常考的就是工具调用失败如何处理了吧。 这个问题，比较系统的做法是：先区分失败类型，是确定性错误，还是瞬态故障。 确定性错误，比如模型调参数给错了，那么可以让模型重新推理参数。 如果是瞬态故障，比如网络问题，那么业界经典做法就是 指数回退+随机扰动。 同事，错误我们要尽最大能力去处理。但是一定要用熔断机制，不能陷入死循环。 最后如果尝试失败，需要优化回退。 这就是比较对这个问题的思路，不要一上来就说把错误给Agent进行推理。我们要先判断错误类型。按照这个思路回答，面试官一定会对你竖起大拇指！', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('550e5494-48fd-527a-8a11-13b599fe1d22', 'c1000000-0000-4000-8000-000000000005', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a7c9c05000000002201176d', '宇树科技｜宇树一面', 'unitree-2026-08-01176d', 1, '面试官给我的感觉起码是一个部门的主管级别吧 主包投了运控和具身，打算主攻运控的，看的流程是运控在进行中，所以基本没看具身的算法，但是面试官是主攻算法的 导致就是问我世界模型细节懂不懂、LLM细节懂不懂、VLA细节懂不懂…真正的运控的问题反而没有 问面试官说运控岗和具身岗面试没有什么区分吗，他说既然搞机器人的各方面都应该掌握 肯定是g了，还是碰瓷不了头部厂啊，但是能给我面的机会就不错啦', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d390d465-c196-59e2-8c9e-5f46af66170c', 'c1000000-0000-4000-8000-000000000005', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a9051b6000000000b024b88', '宇树科技Agent开发一面： 八股大考验！', 'unitree-2026-08-024b88', 2, '朋友们，今天解析今年7月份 的宇树科技Agent开发一面。 这次面试简直就是纯纯的一个八股大战，好像是我解析这么多面经以来问八股问的最多的面经了。 虽然叫他八股，但也不是纯贬义。很多这些知识点我觉得都还是挺重要的。这些问题的答案也可以作为很多其他问题的出发思路。 我将这一次面试的所有对应的问题，都收录到了笔记对应的知识专题讲解部分，这样让大家在学完某个知识点后，下方就能看到对应的面试真题，检验自己。这形势像是在复习高考一样。 宇树的二面，也是很多八股问题，我还挺想解析的，把面试真题作为专题知识的补充是一个特别好的形式，让你看笔记的时候更有意思。 我应该会继续解析二面，甚至是三面，来扩充我们笔记。 我现在有巨多面经，收集面经真的不是卡点（谢谢大家的反馈和投稿），卡点是每个面经我都是深度解析，解析的太慢了。 即使是这么一次纯八股的面试，每个题目我都是重新查阅了书籍，组织答案，视频讲解八股的思路，学习的重点，整理出来的。之前我不是发了Agent健壮性设计的专题讲解吗？ 这些都是从这个面试题里先抽了一部分，做专题深入讲解。包括今天又根据这次面试，整理了ReAct对应的知识点。 我希望每一个面经，大家看到，不光知道答案，也知道要学习什么，学习多深，学习策略，所以一直也在根据面经，沉淀对应学习思路，准备策略。根据最新面试情况：把重点的内容突出，把不是那么重点的内容标记，让大家知道面试喜欢考什么？考多深也是笔记想要达到的目标。 未来应该会更新大量的面经了。因为我自己也准备面试了，9月份，我会以我面试为主线，更新面经，更新包装方法，简历编写方法等等。感兴趣朋友记得关注我！', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('0a90f6d0-7a7d-54ad-8b3a-f5797501aec0', 'b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a76e3d80000000022033637', '小米｜米哈游/小米 大模型/VLA 面经', 'xiaomi-2026-08-033637', 1, '/小米 大模型/VLA 一面面经投稿，汇总如下： 本批面经集中在「生成式模型评估」与「具身智能架构」两个方向，体现工业界从拼模型能力转向拼系统落地。 **生成式评估：指标怎么选，打分模型怎么校准？** 相关性；端到端看任务成功率。关键要区分「检索-生成」耦合评估与解耦评估，避免把召回不足误判为生成幻觉。 **VLA 架构：从零设计的关键是动作表示与实时性** 小米具身智能面经全部围绕 VLA 架构与路线判断。标准链路：Vision Encoder → 对齐层 → LLM Backbone → Action Head。动作空间表示是核心分歧：连续值直接回归简单但高频控制压力大；离散 token 可与语言统一但精度受限；Diffusion Policy 在动作平滑性上更有优势。当前最大瓶颈是数据闭环（跨本体、跨场景）和 Sim-to-Real 鸿沟，改进方向是自动标注 + 失败恢复重标，以及结合世界模型做长程规划。 完整面经合集在 llmbases.com 第 9 章，欢迎私信投稿！！！', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('05f4993c-9ce2-58de-971a-e06c2562db81', 'b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8bfa6e00000000280011c0', '小米一面结束', 'xiaomi-2026-08-0011c0', 1, '面了43分钟，半个多小时一直在挖简历问，问的真是口干舌燥，后面几分钟就问的很正常，对小米汽车的了解，哪里人，职业规划，还有就是反问', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('fff28b53-d4df-5cd0-a614-66c9eba7f30b', 'b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8bcfcd0000000033011555', '小米硬件一面', 'xiaomi-2026-08-011555', 1, '体验感最好的一次面试，面试官非常耐心，还教我一些我没留意过的细节', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', 'b6d12e9f-bb88-5daf-9305-e5a905ac1e0a', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8ff0cd000000002600681e', '小米｜秋招第一面：小米！小米最尊重我之人', 'xiaomi-2026-08-00681e', 1, '感谢小米秋招的第一个面试，打响了我秋招第一枪！ 全程35分钟左右，面试官很和蔼，主要是我在对照我的ppt讲解我的科研项目经历，面试官也没有深挖 反问： 1.这个工作的主要业务是干什么？ ㊙️ 2.工作地点在哪，北京工厂还是小米科技园？ 北京总部小米科技园。 3.薪资待遇怎么样？ 不归我们业务部管，到时候hr会和你谈。 4.一共有几轮面试，一面过后大概要走多久流程？ 业务面一共两轮左右，最后有一个hr面，大概走流程要两周。 5.该岗位主要招收的是硕士还是本科生？ 主要是硕士。', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('eaceff89-c4fc-5dd8-ae14-8f5709abbb26', '5c4e398c-2ae0-52bd-bfff-8c8fd5d6ee7f', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a784e4e00000000060077cf', '拓竹科技｜拓竹AI算法三面全过｜视觉方向面经', 'bambu-lab-2026-08-0077cf', 3, '前段时间走完了拓竹 AI 算法工程师-视觉方向的三轮面试：两轮技术面，一轮 HR 面，三轮都通过了。所以第一篇面经想分享下。 先把岗位说准确：它不是纯 VLA 岗。JD 同时覆盖 ViT/VLM/VLA、3D 打印视觉感知、缺陷识别、模型部署和打印状态闭环，所以准备时不能只背大模型原理。 逐字复述容易失真，下面是我按现场考察点和 JD 重新整理的公开问法，不是原题照搬： 1. ViT、VLM、VLA 分别解决什么问题？做缺陷识别为什么不用检测/分割模型加规则？ 2. patch size、输入分辨率和注意力计算量有什么关系？低对比度小缺陷怎么保留细节？ 3. 缺陷样本少、长尾明显，不同机型、材料和光照又有域偏移，数据和训练方案怎么设计？ 4. 离线指标很好，上机后效果下降，应该从数据、预处理、模型转换还是硬件执行哪层排查？ 5. 端侧部署时，延迟、显存和精度怎么取舍？量化、蒸馏、ONNX/TensorRT 分别解决什么？ 6. 缺陷识别怎么接入闭环控制？误报停机和漏报废件，阈值与安全策略如何权衡？ 7. 讲一个项目失败案例：看到什么现象、提出哪些假设、怎么定位，最后为什么妥协？ 我最大的体感是：视觉算法岗已经不只是训练模型、刷指标。为什么选模型、数据怎么构建、怎么部署、如何接进业务闭环，往往是同一个问题的下一层。 但我也有个疑问：3D 打印缺陷识别真的需要端到端 VLA 吗？如果数据量还不大，我更倾向先做异常检测或检测/分割+规则；等系统需要理解多模态状态并自主选择动作，再引入 VLM/VLA。直接上端到端很酷，但数据成本、稳定性和可解释性都要回答。 注：仅分享个人真实经历与通用复盘，不涉及公司内部题库、业务信息或面试官身份；图片排版使用 AI 辅助。', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('3275ba43-b955-596e-ad7b-b802b45ac27b', '0809bd24-5c41-5ff5-a34a-2e7f01ae4702', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8c4a78000000001602b0ec', '星海图具身一面面经', 'galaxea-2026-08-02b0ec', 1, '本人bg：双9硕，一篇a会，三段具身相关实习 1.注意力计算中为什么要除以根号下dk？讲一下对公式的理解 2.MHA/GQA八股 3.分布式训练相关，如训练时长等 4.batch norm /LN/RMSnorm 5.RL经典八股问题 6.pi0.5中VLM 怎么和动作专家连接？ 7.action chunk相关 8.讲一下对DAgger的理解 9.聊了一下主包的paper 10.手撕力扣简单题 反问环节了解到的信息：不同base地业务差别较大 主包会把近期面试的问题回忆一下，持续总结下来，尽量做到日更', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('eea26463-6fb1-58d7-9c9f-260fd0c93e25', '429a1770-4c54-5511-9cf4-47615acd1fdc', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8ff2c50000000020039929', '普渡机器人｜普渡具身vla一面', 'pudu-robotics-2026-08-039929', 1, '主包最近比较忙，时隔两天终于更新 本人bg：双9硕，一篇a会，三段具身相关实习 1.轻微八股拷打 2.umi数采原理，pipline搭建流程 3.ppo原理以及如何调参 4.pi05框架 5.vlm如何与动作专家交互 6.全量微调参数设置，用了多少卡多少时间 7.腕部为什么使用鱼眼相机？ 8.对历史帧的了解 9.浅谈最近看过的论文 10.其余都是主包的项目和论文相关 反问环节：主包个人感觉这边主要以传统机器人行业为主', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('658ec94e-1d30-5e59-bdde-b2c1127aa9e2', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a7540fa0000000032033781', '智元机器人一面过', 'agibot-2026-08-033781', 2, '智元的面试难度名不虚传，是我面了这些家里面难度明显最大的，给我都面沉默道歉红温了 一共有两位面试官，均未开摄像头，主要是对项目深深拷打➕迁移化拓展，此外还非常注重理论知识的掌握，对于项目会提问“这里用到了/验证了哪些理论？”以及一些与项目完全不相关的八股（涉及机械设计、有限元仿真基础以及材料力学理论力学等），并且还会出一些公司的技术情景题让你设计规划 其实面完我就红温然后感觉要凉了，刚刚居然收到了二面邀约，所以感觉难和有点压力是他们的特色吧，问题只要能答上60%以上可能还是有戏的 我投的仿真岗，机械结构/仿真的同学一定要注重八股，项目没涉及的也要注重，机械原理机械设计材料力学理论力学等最为重要，uu们加油', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('490d1a62-e383-500a-a16d-a66bda1db203', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a7e86c90000000032022253', '智元机器人二面', 'agibot-2026-08-022253', 2, '我的二面相对一面来说无论是问题还是面试官态度都温和很多，面试时长半小时 1️⃣对我的算法项目很感兴趣，问了一些问题以及讨论在实际量产的时候能否将生产一致性考虑进去（虽然这个跟仿真岗看似没什么关系 2️⃣问我有没有做过疲劳仿真，我说没有，于是针对疲劳出了个情景题让我谈谈用仿真的解决思路 3️⃣疲劳相关的八股 4️⃣平时学习一个新的软件要多久 5️⃣实验室什么强度，怎么看待996 6️⃣能不能去实习 整体不难，就是我个大蠢猪面试前几分钟入会发现电脑摄像头突然坏了，没来得及调试好于是没开摄像头跟ld面试了（ld 还开了）', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('c2129627-f7f5-5ce2-801a-df9df27fae14', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a894d6e0000000016020084', '智元机器人｜智元vla一面 有点难呀🥲', 'agibot-2026-08-020084', 1, '最近面完了智元的VLA相关岗位，目前只进行了一轮，想聊聊我对这个岗位的理解。 面完以后重新看了一遍JD，我的第一反应是：这个岗位想要的可能不只是“会训练VLA模型的人”，而是能够把模型、数据、强化学习、机器人控制和真机验证串起来的全栈型选手。 首先是模型层。 Transformer、SFT、RLHF只是基础，还需要理解VLA里的视觉—语言—动作联合建模，以及世界模型如何完成环境建模、状态预测和行为预演。模型不仅要生成动作，还要能在闭环交互中持续修正决策。 其次是机器人层。 JD里同时出现了任务规划、运动控制、多模态感知、复杂操作和闭环执行。这意味着只会讲模型结构可能不够，还需要理解动作最终怎样落到人形、四足或者移动操作机器人上。 第三是数据与训练闭环。 Sim2Real、数据蒸馏、自监督、离线与在线学习都被写进了岗位描述。我的理解是，这个岗位很关注真实机器人数据难获取、分布差异大以及模型如何持续迭代这些落地问题。 所以这个岗位给我的整体感觉更像“具身基础模型研究＋机器人系统落地”，覆盖面非常广。论文和模型能力能帮助进面，但真正做起来，实验复盘、问题定位和真机闭环可能同样重要。 目前我只走完一轮，这些更多是结合JD和面试后的个人理解，不代表完整招聘标准。', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('d3dd3fab-a63a-5bea-a4f4-c94ccec77822', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8abcbc00000000240259e8', '智元机器人｜智元具身VLA一面（回忆版）', 'agibot-2026-08-0259e8', 1, '本人bg：双9硕，一篇a会，三段具身相关实习 1.讲一下对QKV的理解，尤其是kv cache 2.self attention八股，伪代码 3.flow matching八股，伪代码 4.训练数据是关节角还是末端位姿？训练数据量多大？ 5.Lora微调的效果如何，训练时长？ 6.是否使用过数据增强，有哪些方法？效果如何？ 7.umi训练遇到的问题及数采规范 8.数采的pipline如何搭建，遇到的问题有哪些？ 9.手撕MHA，写完挑了几个问题（比如shape的流转等） 个人体感面试难度不算高，偏八股和项目，细节问题方面相较于自变量友好一些', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('233cf00f-fb03-52c7-a04f-8018f4b61457', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8adfb0000000001700995b', '智元机器人｜运动控制算法工程师面经', 'agibot-2026-08-00995b', 1, '题目：为什么选择智元机器人的运动控制算法岗位？你对这个岗位的理解是什么？ 🎯 考察点：求职动机、对公司及岗位的认知程度、职业匹配度 📝 解题框架： 1. 行业与公司选择 从具身智能与人形机器人赛道的发展前景切入，结合智元在行业内的技术积累和量产落地能力，说明为什么选择这家公司而不是其他机器人公司。 2. 岗位匹配度 结合自己的专业背景、项目经历和技能栈，说明为什么适合运动控制算法岗位，具体到控制理论、强化学习、机器人学等方向的积累。 3. 个人成长诉求 表达自己希望在真机落地、算法从仿真到实机迁移的过程中获得成长，而不只是做纯理论研究。 ✅ 参考答案：我选择智元主要有两方面考虑。首先是赛道选择，人形机器人是目前AI落地物理世界最核心的载体，运动控制又是人形机器人的核心技术栈之一，我看好这个方向的长期价值。智元作为国内少数实现了人形机器人规模化量产的公司，既有算法积累也有硬件量产能力，不是单纯做科研Demo，这点很吸引我。 其次是岗位匹配。我本科和硕士都是控制理论与控制工程方向，期间做过两个跟机器人运动控制相关的项目——一个是基于MPC的四足机器人步态控制，另一个是用强化学习做机械臂轨迹跟踪。我熟悉PID、LQR、MPC这些经典控制方法，也有强化学习和仿真环境（Isaac Gym、MuJoCo）的使用经验，跟岗位要求比较契合。 我对这个岗位的理解是，它不是纯理论算法研究，而是要把算法真正跑在机器人本体上，解决真机调试中遇到的各种实际问题，比如sim-to-real迁移、控制延迟、传感器噪声这些。我希望能参与从算法设计到真机落地的完整流程，这也是我选择智元而不是纯研究院的原因。 回答时注意不要泛泛而谈「我对机器人很感兴趣」，一定要结合自己的实际经历来说明匹配度。', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('f504b07b-5969-55f0-890f-1e8014865c21', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8d5110000000003300891b', '智元机器人｜具身智能算法工程师面经', 'agibot-2026-08-00891b', 1, '原帖正文没有可复制文字；已从配图 OCR 提取 35 个问答条目，详见下文。', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('c3961087-9bca-51df-9f40-f2bb439d5c2c', '5daa0508-12c8-57cd-854d-422719fef109', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a76e3d80000000022033637', '米哈游/小米 大模型/VLA 面经', 'mihoyo-2026-08-033637', 1, '大模型评测与VLA面经 2026-08-08，收到 2 条米哈游/ 如下： 本批面经集中在「生成式模型评估」与「具身智能架构」两个方向，体现工业界从拼模型能力转向拼系统落地。 **生成式评估：指标怎么选，打分模型怎么校准？** 米哈游评测岗连追 5 题，核心痛点是缺乏 ground truth 时如何建立可信度量。评估体系分四层：n-gram 重叠类（BLEU/ROUGE）适合有参考答案的短文本；语义相似度（BERTScore）缓解 n-gram 僵化；基于 LLM 的评估（GPT-4 as Judge）适合开放式生成，但需警惕位置偏差、长度偏差和自我增强偏差，可通过细化 rubric、多轮投票和引入参考回答来缓解。若训练 Reward Model，需用高质量 pairwise 对比数据，并对奖励分布做正则 / 加 KL 约束，防止 reward hacking。 **RAG 测评不能只看生成，检索端也要解耦** RAG 系统评估需分三层：检索端看 Recall@K、命中率；生成端看忠实度（Faithfulness）、答案相关性；端到端看任务成功率。关键要区分「检索-生成」耦合评估与解耦评估，避免把召回不足误判为生成幻觉。 **VLA 架构：从零设计的关键是动作表示与实时性**', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('fa6e0570-b586-562f-8303-5dea7f587570', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a82bf760000000022012951', '自变量机器人｜8.17 自变量提前批一面', 'zibianliang-robotics-2026-08-012951', 1, '问了70分钟，一面他说是通用技术面，没问项目，就问了很常见的八股，但是面试官想起来啥就问你啥，同学你知道xx吗，不会也没关系，面试官会替你说哦可能你还没了解过哈哈哈 虽然时间挺久的但是面试官人很好，笑嘻嘻的不会感到压力', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('9bffbb56-e631-5b9c-8fd0-f7503521eef8', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8448e600000000320307b5', '自变量机器人｜8.18 自变量二面', 'zibianliang-robotics-2026-08-0307b5', 2, '没问八股，一直在问我的项目做了什么，链路是什么，没啥压力，只需要把你做的东西说出来就好，面试官也很和蔼一直就说ok', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('4141c408-7e16-5b93-9b80-a1b995cc70ec', '7a538768-3f89-5d2c-8125-b119a6265603', null, 2026, 'Summer', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a8996bf0000000033019a6b', '自变量机器人｜自变量具身vla（一面）面经', 'zibianliang-robotics-2026-08-019a6b', 1, '本人bg：双9硕，一篇a会，三段具身相关实习 项目相关问题 1. lerobot格式数据相关问题 2. umi数据和真机数据时间尺度怎么对齐？ 3. 失败的数据如何利用？ 算法模型（PI0.5为主） 1. pi0.5和pi0的区别？ 2. pi0.5训练的数据量，训练时长？ 3. pi0.5中Action Expert 和 VLM 怎么交互？ 4. RTC相关概念 八股文 1.Transformer 2. 多头注意力机制伪代码 强化学习 1.TD3原理 2. 硕士项目相关的奖励函数设计', '2026-08-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('49091aba-3ea4-5ec6-a483-401638573b86', 'ed0dfbe2-fffa-5f42-9095-c1ec99503035', null, 2026, 'Autumn', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a979b0b00000000110349b4', '卧安机器人秋招一面面经', 'woan-robotics-2026-09-0349b4', 1, '1. 自我介绍 2. 实习中体现好奇心与创新的实践 发现现有功能的数据异常后，主动分析原因并提出改进方案，最终推动上线并带来正向数据反馈。重点突出“发现问题—提出假设—推动落地”的逻辑链条。 3. 遇到过比较困难的事情及解决方式 思路：困难时聚焦于资源有限、时间紧迫或需求模糊等真实场景。 4. 优缺点分析 5. 为什么选择产品经理岗位 说明自身特质（如善于抽象问题、关注用户体验）与产品工作的匹配度；再阐述对产品经理价值的理解（连接用户、业务与技术，驱动产品迭代）；最后用实习经历佐证该认知，形成闭环。 6. 产品经理应具备的核心特质 · 逻辑能力：拆解复杂需求、梳理业务流程的基础； · 沟通能力：协调多方诉求、推动项目落地的关键； · 书面表达与数据敏感度：撰写PRD、分析用户行为数据的必要技能。 7. 职业规划 关注行业认知与业务洞察的积累。 8. 机器人产品相较传统软件产品，在能力要求上有何特殊侧重？ · 进度管控：硬件交付涉及供应链与生产周期，环环相扣，容错空间小； · 成本意识：需兼顾时间成本、硬件制造成本与研发投入； · 持续学习：硬件迭代周期长，需保持对新技术、新场景的好奇心与创新力。 没反问环节，感觉还可以。', '2026-09-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('eb4b9229-dc4f-5976-abfd-e5657dd0d16d', 'c1000000-0000-4000-8000-000000000005', null, 2026, 'Autumn', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a96640b0000000029011ba7', '宇树科技｜具身面经分享：宇树AI算法一面', 'unitree-2026-09-011ba7', 1, '具身面经分享：宇树科技AI算法工程师一面，直接给我问自闭了！！！ 最近整理到一份宇树科技 AI 算法工程师一面面经。 看完最大感受： 现在具身算法岗，真的不是“会调个 VLA”就够了。😂 第一题： 👉 VLA 模型核心架构是什么？ 👉 RT-2 怎么把连续动作变成 Action Token？ 👉 画架构图，并写出动作 Token 的数学定义。 如果只会一句： “图像+语言输入模型，然后输出动作。” 基本到这里就卡住了。 第二题更狠： 👉 7B VLA 推理只有 1～3Hz，但机器人底层控制要 50～200Hz，怎么解决？ 这已经不是考论文，而是在问： 模型到底怎么真正跑到机器人上。 要能讲出： ⚡ 快慢脑分层 ⚡ 蒸馏和量化 ⚡ Waypoint + 插值 ⚡ 不同方案的 Trade-off 第三题继续： 👉 如果基于 7B VLM 做机器人持续预训练，数据集怎么搭？ 互联网数据、仿真数据、真机数据分别放多少？ 训练前中后期，比例为什么还要动态变化？ 整套题其实就考一件事： 动作怎么表示 → 怎么实时执行 → 用什么数据 学会执行。 现在头部机器人公司的面试，越来越看重的是： 模型、数据、控制、真机工程能不能真正串起来。 我把这几道题完整拆成了 8 张卡片，包含 VLA 架构、Action Token、控制频率和持续预训练数据配比。 准备 VLA / 具身智能 / 机器人算法岗的，可以收藏。', '2026-09-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('bdf6d781-4dc0-5009-80e5-71fb7ebfe118', 'c1000000-0000-4000-8000-000000000005', null, 2026, 'Autumn', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a9a5630000000002601770f', '宇树科技 AI Agent 开发一面 9.4（有答案）', 'unitree-2026-09-01770f', 1, '- RAG 中，什么场景下会同时使用向量数据库和关系型数据库？ - RAG 检索中，如何实现向量检索和关键词检索的混合召回？ - 为什么向量数据库不用 B-Tree 作为高维向量索引？ - ANN 检索中，HNSW 和 IVF 索引有什么区别？ - RAG 中，文档 Chunking 策略如何选择？ - RAG 检索链路中，Embedding 和 Rerank 模型分别负责什么？ - RAG 中，如何优化过短或语义模糊的 Query 检索效果？ - 知识频繁更新时，RAG 如何保证知识时效性？ - 大模型应用中，哪些问题更适合通过微调解决，而不是优化 RAG？ - 模型微调后，如何评估是否真正提升了业务效果？ - 同时使用 RAG 和微调后效果仍不好，应该优先排查哪些环节？ - Agent 推理过程中，ReAct 和 CoT 有什么区别？ - Agent 调用工具失败时，重试策略如何设计？ - Agent 调用工具时，如何区分可重试错误和不可重试错误？', '2026-09-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null),
  ('74df3731-ee74-50bc-85e9-9089b588df65', 'c1000000-0000-4000-8000-000000000006', null, 2026, 'Autumn', null, null, 'candidate_report', 'https://www.xiaohongshu.com/explore/6a96dcdc000000002900f515', '智元机器人｜智元一面面经-最难的一集', 'agibot-2026-09-00f515', 1, '7.3 投递硬件 9.1 一面 本来约定下午四点面试，三点多改到了晚上八点半面试，整体面试五十分钟，目前为止面试时间最长，问的最深的一次面试，问的太多了太杂了，面试官挺有礼貌的，但是没开摄像头，有几个问题基本上不是在提问更多是在探讨，也会给你讲一些原理，面试体验给到夯👍，就是时长有点长，力竭了 先是自我介绍，对岗位JD的匹配度的认知(最开始投的灵犀，后面转到了另一个硬件工程师岗) 介绍项目1框架，传感器的采集原理，采集芯片的工作原理，为什么电压会影响电容容值的大小(问的很深，我都已经把电偶极子，感应电荷都答了)，项目中的亮点，感悟；项目2的整体架构；项目3的传感原理（也是基本上到原理公式的层面），项目中电路设计考虑因素有哪些，和项目1的区别 硬件八股相关:STM32外围电路，mode0-3四种通信模式的区别，晶振电路中电容电阻的选取，晶振的布局，电容的等效阻抗模型（串联还是并联），容性感性的趋势变化，随电容容值增大谐振频率变化趋势，一个10微法的电容能否用五个2微法的电容并联代替，滤波电容的放置，SPI通信速率，奈奎斯特采样定律， 对于人形机器人的了解，灵巧手的了解，未来的就业方向，你所希望的一个培养学习模式如何 最后反问', '2026-09-01 00:00:00+00', 'published', null, 'unknown', 'unknown', 'unknown', 'unknown', 'zh-CN', true, null)
;

-- interview rounds (one aggregated round per post)
insert into public.interview_rounds (id, interview_id, round_number, title, round_type, duration_minutes, interviewer_role) values
  ('a1150c3c-304e-58ae-9f33-81a408a83d4e', 'b29c8b43-69e3-5bb2-a14a-b415cd5932e3', 1, '三轮', 'technical', null, null),
  ('e9eb7470-2e92-5bef-b536-400f7843d858', 'e0167402-ecc3-5d5c-89ad-935fe82bbcc1', 1, '三轮', 'technical', null, null),
  ('dd9de9c3-5f27-588f-b1bb-00181961e785', '1ac2118a-1561-5178-8f88-45b85c84f456', 1, '三轮', 'technical', null, null),
  ('fd8ad844-9989-552d-8ee6-a551ce0723c4', 'cc1a2e8d-a1bc-579d-a075-a2f2761f733e', 1, '三轮', 'technical', null, null),
  ('e4b21c7d-7522-5b02-a4af-3e2204471a7f', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', 1, '一面', 'technical', null, null),
  ('d8659270-bf80-5b49-8d74-839e77367b21', '8fd78f7c-d912-5ccb-a8b7-d8735788d8fa', 1, '一面', 'technical', null, null),
  ('b5b3e416-4540-5f37-a749-e4d96c3b48ab', '1cf45c94-12e5-5199-b125-6dd324ca085f', 1, '三轮', 'technical', null, null),
  ('4f17df65-b1d1-56db-95cc-c20186412fb3', 'ebb98a2e-6e64-5379-bbd9-21c40c435916', 1, '三轮', 'technical', null, null),
  ('38213829-1f92-59d2-ae17-efa09367e601', '14407c87-1eb5-513f-a42b-7206d5527672', 1, '三轮', 'technical', null, null),
  ('1f5efc29-c15b-5499-923e-387ff7783a2a', '7c83531b-64f7-5996-8a2f-88e5e8d714d7', 1, '三轮', 'technical', null, null),
  ('19194326-00f7-5d70-a26a-7e78f1778cb7', '131c9e20-b988-5dad-a92e-bfa398991a82', 1, '三轮', 'technical', null, null),
  ('de08aaed-d1bf-548f-91dd-21a4a0408292', '7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', 1, '三轮', 'technical', null, null),
  ('4d20383f-7fb2-5a93-9a5c-7f0c603ee384', '698d0993-d8c2-576b-940b-5f07f4e1a1a0', 1, '三轮', 'technical', null, null),
  ('8abd375b-b91d-5c34-89f5-bd811d30f414', '92d55798-5fd0-5a58-8a3d-6e8d070128b5', 1, '三轮', 'technical', null, null),
  ('5bbb9c70-8c65-5c9c-adfc-7a396adebb89', '73c830ed-cba2-55a8-92c2-40d0a6351619', 1, null, 'unknown', null, null),
  ('d7645a8a-f81e-5945-bd78-fc7be0b954b8', '371f89d5-22a5-5d82-9907-f60f39448388', 1, '一面', 'technical', null, null),
  ('69dd1df7-719b-52d1-9295-f033183039b8', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', 1, null, 'unknown', null, null),
  ('fbbca420-b09b-54b7-8152-28ca501670bf', 'ffb51324-adde-5bed-b17f-938ef56df3ca', 1, null, 'unknown', null, null),
  ('836b4c7e-aadd-508b-af0d-3fbaa5ff55e9', '075552a1-508b-5417-a7c7-c139d328a5a6', 1, '一面', 'technical', null, null),
  ('2799090b-afb9-5684-af76-f2a717781d9d', '9668bb19-fe22-500e-b57e-4640b54b5d55', 1, '二面', 'technical', null, null),
  ('812c83ca-0f23-5fa2-9b3b-5e54af69a25e', 'c735ad49-26b9-5253-b1ab-6d4dbef3ad5c', 1, '一面', 'technical', null, null),
  ('7a6bffb0-c6f9-5dc1-a0b2-ad95f6800590', '0eb7c091-2576-5377-b5fa-05f1e22ac101', 1, '二面', 'technical', null, null),
  ('08b6399c-14ff-5d73-ab46-743ffe06eb9d', '0883be4f-2c16-51d1-9a56-4649459d2baf', 1, '一面', 'technical', null, null),
  ('1a870c04-ce3a-552b-a3c3-d7ae0f6bc377', '8b3066a2-755d-5bc6-87ab-bfe66829323e', 1, '二面', 'technical', null, null),
  ('15d4c429-efb4-58c6-8004-c42f8bded138', 'd717e931-3a92-56b6-9aef-a303a6813235', 1, null, 'unknown', null, null),
  ('37e537a2-3de0-570c-9c3c-b77386c3f7a9', 'c3c05533-b404-549b-8e07-1f1ac366419d', 1, '二面', 'technical', null, null),
  ('ee26924a-1011-56e5-8f8e-9b8279c71a62', '9c237907-490e-55ba-82b0-427c6122ca2c', 1, null, 'unknown', null, null),
  ('428a6976-7f89-50e3-b680-24fbf72481a5', 'd77ac39b-994f-5087-80a0-a633ffdf87bc', 1, '二面', 'technical', null, null),
  ('f653d2c8-1e98-5591-bffc-20bf4125cdf2', '1d6bb797-8565-58c2-a209-46f3b978fa29', 1, null, 'unknown', null, null),
  ('8bdbd6e9-5d5f-5b4f-af50-34f08ec080e4', '6827cecb-a83b-5518-a063-916ca69ad7cb', 1, '二面', 'technical', null, null),
  ('a2570d72-4a75-51e5-922d-9babede2b324', 'd04d51ea-12e2-59b3-ab30-e7f0784bd80d', 1, '二面', 'technical', null, null),
  ('9da7bee6-9304-5c93-9354-af486eb51ad4', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', 1, '二面', 'technical', null, null),
  ('6910e094-0114-5d17-a111-6d02c463ce8f', 'c0951177-c779-585f-ac70-1807855e40cb', 1, '二面', 'technical', null, null),
  ('39a2671b-c20a-567d-83cf-78280bcc57d6', 'fa7d4b98-0a02-51c9-b809-159572a91155', 1, '一面', 'technical', null, null),
  ('0424660c-00ff-501c-9b5e-202cdc5287e9', '25d3adba-d597-5453-a23b-463c8af9f356', 1, null, 'unknown', null, null),
  ('72c0b5df-bfaf-5e9d-82a7-37e48c99501e', '4618d4f8-da36-50ef-bfec-f63688032da9', 1, '一面', 'technical', null, null),
  ('8d981102-11cf-57fb-b2b5-e1bed21ed98f', '91c389f6-a6c0-51ad-b604-3df5a7707765', 1, '二面', 'technical', null, null),
  ('cd35e4c9-23a5-5ee6-97b8-fafeee7ba000', '824207f1-1767-5157-8873-ad3008e26dd7', 1, '一面、二面', 'technical', null, null),
  ('6fd36d9b-0d93-5629-83c6-529eba095bfd', '8c99d336-61ec-57f5-ad2a-7efed439c968', 1, '二面', 'technical', null, null),
  ('82025f20-cdcf-55e7-ac95-720025774326', '3e40b227-ea8e-591c-8417-f0b9e91bd844', 1, '一面', 'technical', null, null),
  ('da8ced63-a9f1-572b-aa66-d9c60a854344', '1bee6efc-9dd9-5072-9d8c-532e504cc38b', 1, null, 'unknown', null, null),
  ('0f5af9f1-c026-55a8-9452-4beeccec1e72', 'eaceb563-c968-550c-847b-8374ce47712c', 1, null, 'unknown', null, null),
  ('1a6e16c0-e854-535c-8277-60f29b33b8d2', '90ace5de-674d-52ad-b2d6-db177ed35cb2', 1, '一面', 'technical', null, null),
  ('6c64cea9-8cc8-59c1-b6d3-22cb07979056', 'd9089ca5-3e5f-52a7-8dc3-8590dc24dd2d', 1, '一面', 'technical', null, null),
  ('a3e8d015-3d87-57c7-bdae-cd33b9f22486', 'f11aa476-8ca6-52b2-b295-d7d12f631f79', 1, null, 'unknown', null, null),
  ('7e1a7213-95ef-5b62-86d6-c91b7f94e491', '6889ae7c-74df-5587-9ae5-512bec4052c4', 1, '一面', 'technical', null, null),
  ('8382c4bc-db9e-51bf-95f3-33cf14abbfd5', 'd655261f-7518-5906-96ef-83d6417ad4af', 1, null, 'unknown', null, null),
  ('05679953-16e1-58e4-88b3-2e494a42dbf3', '2ac847df-522b-52b0-abc9-a166a8f56ea7', 1, null, 'unknown', null, null),
  ('8a2807cd-2470-504b-a888-6b23f8805b8f', 'e57b850d-c3f9-520f-bc58-31010c516d2c', 1, '一面', 'technical', null, null),
  ('842fae74-2b85-52ef-860c-09048967e43c', 'f5c3ed62-8af4-5aca-b627-9186184673cd', 1, null, 'unknown', null, null),
  ('6fab9fd2-0068-5058-b5f8-c8771d10c8bf', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', 1, '一面', 'technical', null, null),
  ('d48c91b6-90b9-50fa-8e25-75b97c43da28', '550e5494-48fd-527a-8a11-13b599fe1d22', 1, '一面', 'technical', null, null),
  ('3f0cd739-e307-59a8-9532-9235cc469a31', 'd390d465-c196-59e2-8c9e-5f46af66170c', 1, '二面', 'technical', null, null),
  ('cf63bd61-a6d9-5a9a-a4fb-7516dbab45a2', '0a90f6d0-7a7d-54ad-8b3a-f5797501aec0', 1, '一面', 'technical', null, null),
  ('14f6d675-40cf-5e57-abd6-a660317bb683', '05f4993c-9ce2-58de-971a-e06c2562db81', 1, '一面', 'technical', null, null),
  ('5b371cca-b407-521a-930d-5472dab2ed17', 'fff28b53-d4df-5cd0-a614-66c9eba7f30b', 1, '一面', 'technical', null, null),
  ('3af27f7f-4e73-531e-a92a-44700298b727', '42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', 1, '一面', 'technical', null, null),
  ('5bb3043b-38b3-559b-9912-f1b83aa0d1e2', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', 1, '三轮', 'technical', null, null),
  ('222d0ddf-009f-583f-ad7a-3da6aa1a2077', '3275ba43-b955-596e-ad7b-b802b45ac27b', 1, '一面', 'technical', null, null),
  ('f916a5ff-c458-562d-9e94-53d95bc2b61c', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', 1, '一面', 'technical', null, null),
  ('dac1ad73-eb83-57b8-af7f-46bb88b63fc7', '658ec94e-1d30-5e59-bdde-b2c1127aa9e2', 1, '二面', 'technical', null, null),
  ('78bac0b6-1953-5059-b58a-b548868ac26d', '490d1a62-e383-500a-a16d-a66bda1db203', 1, '二面', 'technical', null, null),
  ('e7e16224-db6e-56d4-8956-eabe2606a733', 'c2129627-f7f5-5ce2-801a-df9df27fae14', 1, '一面', 'technical', null, null),
  ('62898a5e-6911-5d34-b15e-dab7db870976', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', 1, '一面', 'technical', null, null),
  ('a1ddb547-16bb-57be-9d76-8124fb38478e', '233cf00f-fb03-52c7-a04f-8018f4b61457', 1, null, 'unknown', null, null),
  ('9da059c3-b80b-5a50-acf6-75a2d817e30c', 'f504b07b-5969-55f0-890f-1e8014865c21', 1, null, 'unknown', null, null),
  ('9880be04-fd49-5697-a163-7f3bda4b7be6', 'c3961087-9bca-51df-9f40-f2bb439d5c2c', 1, '一面', 'technical', null, null),
  ('3d23704d-3ea7-53f3-b6c0-d43684ffc2a8', 'fa6e0570-b586-562f-8303-5dea7f587570', 1, '一面', 'technical', null, null),
  ('1ad0f2cc-b8df-5732-a6b3-c5e14e43512d', '9bffbb56-e631-5b9c-8fd0-f7503521eef8', 1, '二面', 'technical', null, null),
  ('420593ef-d44d-58fa-b4a2-61eb58c602e8', '4141c408-7e16-5b93-9b80-a1b995cc70ec', 1, '一面', 'technical', null, null),
  ('b66e8ab6-f032-5e2d-9ce9-4e669d0c356d', '49091aba-3ea4-5ec6-a483-401638573b86', 1, '一面', 'technical', null, null),
  ('20f2f2a9-4842-57e3-b2cc-0c9808068e69', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', 1, '一面', 'technical', null, null),
  ('7ba3ec74-a744-5dc5-89df-24c9437e6235', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', 1, '一面', 'technical', null, null),
  ('c8a852b5-c154-5a8d-bfde-89f0a4bf82be', '74df3731-ee74-50bc-85e9-9089b588df65', 1, '一面', 'technical', null, null)
;

-- interview questions (wording and answers as recorded in the posts)
insert into public.interview_questions (id, interview_id, question_id, round_number, order_index, original_wording, notes, question_context, answer_summary, difficulty) values
  ('798cab17-caf9-578c-abfa-44066fa43f74', 'b29c8b43-69e3-5bb2-a14a-b415cd5932e3', null, 1, 1, '前两轮都有手撕', null, null, null, null),
  ('9e94c951-4d20-5a43-b370-6b78588f29e7', 'b29c8b43-69e3-5bb2-a14a-b415cd5932e3', null, 1, 2, '众擎机器人', null, null, null, null),
  ('f49e040b-a2a3-5865-bd95-d2d3de3bc955', 'b29c8b43-69e3-5bb2-a14a-b415cd5932e3', null, 1, 3, '全程无手撕', null, null, null, null),
  ('30d47995-bc7e-541c-9981-ac5def414f0c', 'cc1a2e8d-a1bc-579d-a075-a2f2761f733e', null, 1, 1, '具身机器人部门', null, null, null, null),
  ('02d975c6-8bc2-5115-8a17-1a5b0decc3ab', 'cc1a2e8d-a1bc-579d-a075-a2f2761f733e', null, 1, 2, '一面无手撕', null, null, null, null),
  ('31ab9862-ead4-5d41-9ee3-239031c4d4c7', 'cc1a2e8d-a1bc-579d-a075-a2f2761f733e', null, 1, 3, '机器人多模态研究员', null, null, null, null),
  ('fe31ecb6-0f27-5940-9ed3-ee4509e4277d', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 1, '详细描述，如果给一个txt存储的文本，从预处理到SFT的训练流程，要包括对数据的预处理、tokenize、forward、loss计算、参数更新，越细越好', null, null, null, null),
  ('e1690b96-e9db-5583-81ea-806585bcb1b7', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 2, 'tokenizer怎么做的，有哪些tokenizer的实现方式', null, null, null, null),
  ('725e1294-fd72-5f8b-b2b6-118a95761a42', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 3, 'embedding怎么做的，从id到embedding有哪些实现方式', null, null, null, null),
  ('f41e0892-12e6-5fba-8deb-a73815d54e3e', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 4, 'transformer八股 transformer的forward计算包含哪些部件 如何解决梯度消失和梯度爆炸的 非线性由什么来提供 3项目经历', null, null, null, null),
  ('d35497c6-7190-5302-8532-09cf90f9425e', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 5, '介绍自己最熟悉的一个项目，项目中做了什么', null, null, null, null),
  ('15397222-6a2c-5a62-82b2-1c668fbbd2dd', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 6, '一些对项目细节的提问', null, null, null, null),
  ('99eb02ec-42a1-562e-ad9f-b838e2c41057', 'ac7c0878-6d51-55cd-966d-cee3f35e1e4c', null, 1, 7, '这个项目的意义', null, null, null, null),
  ('63ece6a5-8389-55dc-8402-d2755c6d7be1', '1cf45c94-12e5-5199-b125-6dd324ca085f', null, 1, 1, '有专门的笔试环节', null, null, null, null),
  ('1204c9fb-8292-58e0-846c-c080e9fff032', '1cf45c94-12e5-5199-b125-6dd324ca085f', null, 1, 2, '具身机器人部门', null, null, null, null),
  ('33c09f5a-b6f0-5f64-b039-e23480b1f870', '1cf45c94-12e5-5199-b125-6dd324ca085f', null, 1, 3, '一面无手撕', null, null, null, null),
  ('459b0471-80ee-589d-a470-49dfd4978f96', '7c83531b-64f7-5996-8a2f-88e5e8d714d7', null, 1, 1, '一面有手撕', null, null, null, null),
  ('9b4d89e3-9a09-50f8-8f21-bc08a604f2c6', '7c83531b-64f7-5996-8a2f-88e5e8d714d7', null, 1, 2, 'vla方向', null, null, null, null),
  ('b587b431-d979-5325-90e3-f2d5723e297c', '7c83531b-64f7-5996-8a2f-88e5e8d714d7', null, 1, 3, '一面手撕coding面', null, null, null, null),
  ('a2c8a57c-4023-5114-8b5c-0fec64c74311', '7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', null, 1, 1, 'vla方向', null, null, null, null),
  ('2bcdf15b-3063-59b7-8e06-9ece4e2b9e90', '7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', null, 1, 2, '一面手撕coding面', null, null, null, null),
  ('31582f5a-3c08-5e35-a617-70c17ac826ff', '7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', null, 1, 3, '全程无手撕', null, null, null, null),
  ('fc056200-f3b6-57fe-ae20-de6a18e36b2c', '92d55798-5fd0-5a58-8a3d-6e8d070128b5', null, 1, 1, '机器人多模态研究员', null, null, null, null),
  ('c3bcf32e-f9e2-5667-91ca-87057c6565cc', '92d55798-5fd0-5a58-8a3d-6e8d070128b5', null, 1, 2, '一面无手撕', null, null, null, null),
  ('301e68fd-d0f1-5a5d-99c6-2422a4af9521', '73c830ed-cba2-55a8-92c2-40d0a6351619', null, 1, 1, '核心逻辑： 世界模型：学习环境的动力学模型', null, null, null, null),
  ('f9d829df-1a36-5599-865a-0321c58ead43', '73c830ed-cba2-55a8-92c2-40d0a6351619', null, 1, 2, '增强泛化能力：世界模型可学习环境不变量', null, null, null, null),
  ('3a329319-f5f8-5ebb-84c7-164a743625b0', '73c830ed-cba2-55a8-92c2-40d0a6351619', null, 1, 3, 'Sim2Real 成本：模型学习的是抽象动力学', null, null, null, null),
  ('e2dc7bb0-a747-526e-9dd2-5bf89cdb0add', '73c830ed-cba2-55a8-92c2-40d0a6351619', null, 1, 4, '而非具体环境参数', null, null, null, null),
  ('ef35d8de-21da-5426-bb3c-105320c88f61', '73c830ed-cba2-55a8-92c2-40d0a6351619', null, 1, 5, 'GR-RL 中融入世界模型思想：通过轻量级预测器捕捉环境变化', null, null, null, null),
  ('77da3ee8-34b1-5084-ab41-56f4dd53189c', '371f89d5-22a5-5d82-9907-f60f39448388', null, 1, 1, '面试开始首先我先做了很长一大段自我介绍', null, null, null, null),
  ('b4812598-6fed-520d-87a8-017f6067ec29', '371f89d5-22a5-5d82-9907-f60f39448388', null, 1, 2, '我面试的这个岗位主要还是做传感器的数据融合', null, null, null, null),
  ('aafd8b31-5659-53a0-b14a-d8556ac8c7a9', '371f89d5-22a5-5d82-9907-f60f39448388', null, 1, 3, '比如温飘怎么解决', null, null, null, null),
  ('33bead2c-cba8-5466-abbd-4c92c9bec76d', '371f89d5-22a5-5d82-9907-f60f39448388', null, 1, 4, '陀螺仪的数据和里程计怎么做综合', null, null, null, null),
  ('aadb71ec-0132-59ea-a5a4-95a83e31df01', '371f89d5-22a5-5d82-9907-f60f39448388', null, 1, 5, '相关的人员培养计划', null, null, null, null),
  ('e1d499e3-7a5c-5596-bf92-ce315a5936da', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', null, 1, 1, 'Pi0架构是怎样的?', null, null, null, null),
  ('4bb30910-8fca-5c4e-9e08-e77254d3c8cb', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', null, 1, 2, 'Diffusion Policy的原理和算法流程?', null, null, null, null),
  ('33163919-39b7-5a00-b890-73a8aead4526', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', null, 1, 3, 'Batch Size增大，学习率 (LR) 怎么变?', null, null, null, null),
  ('3fb6a0df-6a19-59e1-be76-8eedfe842bb4', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', null, 1, 4, '介绍一下LORA原理?', null, null, null, null),
  ('18151711-fe5f-5ed3-9d2a-276f3afb6972', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', null, 1, 5, '注意力机制的计算复杂度是多少?', null, null, null, null),
  ('fd5fa068-6f57-537b-9dd7-86569c662de7', '3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', null, 1, 6, '介绍一下自己的论文?', null, null, null, null),
  ('95f8dffc-b599-5280-ae49-e01e014594ff', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 1, 'pi0和pi0.5的区别 代码上什么区别', null, null, null, null),
  ('0f2c90de-1d5b-56b1-8821-fa0a6378ca04', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 2, 'pi和gt00t的流匹配的区别', null, null, null, null),
  ('8b1769fd-f9ab-593d-ad6b-c1b89937af24', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 3, '描述智元LAPA工作', null, null, null, null),
  ('a9ba7343-f6f8-5adf-9bf0-ddb8b761402c', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 4, 'ACT训练和推理的流程', null, null, null, null),
  ('a30ba073-0808-5dea-b4ea-ab3e735c6f1a', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 5, '数采原理和方式', null, null, null, null),
  ('ec9acc7a-4da6-586a-982e-5a909ce7167a', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 6, 'RTC有没有做过，如何实现', null, null, null, null),
  ('f79ca688-5f90-5c71-a874-684fa3e24d4c', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 7, '模型预训练用什么开源数据', null, null, null, null),
  ('3cf5def3-c3b4-5dda-b754-a220550640cc', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 8, '介绍自己用过的模型的整体框架与流程，模型输入输出，夹爪or灵巧手', null, null, null, null),
  ('9c912cb0-6aeb-537e-999a-958a2a59fef5', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 9, '接着上面的问题，模型具体使用时存在什么问题，可以怎么样改进或者创新', null, null, null, null),
  ('119a4101-37b5-51e7-a8dc-75f883b68edd', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 10, '如何设计的具体任务，长序列为什么成功率低', null, null, null, null),
  ('34c32e72-1f72-5694-8b7e-950694680551', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 11, '有些企业还会问vlm相关的内容，比如transformer，vit，自回归生成的整个流程，模型多少b之类的', null, null, null, null),
  ('31b10068-3159-5df7-b341-f9d01f3a0bbc', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 12, '还有一些对技术方向的理解的问题，比如对世界模型有无了解，解释快慢系统，对数据来源的看法之类的 手撕类：', null, null, null, null),
  ('5996aa1c-18e6-5c4f-b02f-fcd1cdc93665', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 13, '用pytorch写多头注意力 解释过程', null, null, null, null),
  ('b4e34e72-021b-5df1-82e8-f490d2273236', 'ffb51324-adde-5bed-b17f-938ef56df3ca', null, 1, 14, 'leetcode的题', null, null, null, null),
  ('a64552d6-6f53-5d94-a52b-b6f228251e65', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 1, '参加了乐聚的春招面试，因为项目中有复现univla 并且里面涉及到 VQ- VAE 所以一上来对这方面进行了提问 1. VQVAE模型训练完成后，后续是否会对模型参数进行进一步调整？', null, null, null, null),
  ('5443657a-5b22-54a9-96e9-b047e2fa9f51', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 2, '本次研究中的VQVAE是否未采用预训练策略，而是直接进行端到端联合训练？', null, null, null, null),
  ('0058d947-d9e8-52b8-9e57-2152fab45dcf', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 3, '本次研究采用四个Codebook进行特征表示，相较于原版VQVAE单一Codebook设计，具体实现方式是什么？', null, null, null, null),
  ('6f2f49d2-f078-5bb6-8b79-b97394fc4986', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 4, '是否对VQVAE中Codebook的特征利用率进行过分析？针对Codebook利用率偏低的行业共性问题，是否有相关研究与思考？', null, null, null, null),
  ('8f096b6a-c6cc-5002-b1cc-36477a1b8e3e', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 5, '结合本次研究任务的复杂程度，选择16个Codebook维度的依据与合理性是什么？', null, null, null, null),
  ('947701f1-3404-5bcd-b78b-25d772834c1e', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 6, '在视觉特征提取环节选用DINO模型，未采用更新的DINO V2版本的原因是什么？', null, null, null, null),
  ('442d1fc3-9fb3-5c3e-8642-50fe96c2b521', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 7, '请简要阐述DINO V2相较于DINO V1版本的核心改进点', null, null, null, null),
  ('bee79cc5-561a-501b-8ede-65253d2da304', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 8, '目前深度学习模型量化与压缩的主流方法有哪些？', null, null, null, null),
  ('e2201c6a-dd69-5e49-af78-c61946a9ecf1', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 9, '此前研究方向聚焦目标检测领域，为何转向机器人具身智能相关研究？', null, null, null, null),
  ('f84b970e-7827-5917-a4dd-45fb3939b537', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 10, '除复现相关算法模型外，对机器人运动学、控制理论等专业知识是否具备一定了解？', null, null, null, null),
  ('d5629230-b83e-5011-8823-fe75d21cd041', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 11, '请说明在科研项目与实习项目中的团队分工、个人负责内容及核心贡献占比', null, null, null, null),
  ('a4d3cfdd-98c7-575c-b6b9-bc44879371fe', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 12, '请阐述个人未来的职业发展规划与研究方向定位', null, null, null, null),
  ('46a7856e-8385-5f3b-9715-942ce1ccd38e', '075552a1-508b-5417-a7c7-c139d328a5a6', null, 1, 13, '结合行业实践经验，当前机器人具身智能技术落地过程中面临的主要问题有哪些？', null, null, null, null),
  ('e9fdd68e-56fc-5407-b88c-9b6c4eaea471', '0eb7c091-2576-5377-b5fa-05f1e22ac101', null, 1, 1, '二面也主要拷打项目', null, null, null, null),
  ('83174f53-0da9-52e3-87f4-360c094baf49', '0eb7c091-2576-5377-b5fa-05f1e22ac101', null, 1, 2, 'RL训练等等', null, null, null, null),
  ('af997709-cbdc-50f2-9267-d0b8a2361660', '0eb7c091-2576-5377-b5fa-05f1e22ac101', null, 1, 3, '会怎么做', null, null, null, null),
  ('1985b6f7-f9dc-51db-af66-35e9d7080f4f', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 1, '在自回归解码中使用 KV Cache 时，key 和 value 分别缓存的是什么特征？如果在机器人视觉动作模型中启用 KV Cache，会对时序动作推理带来哪些影响？', null, null, null, null),
  ('3666c9c6-089f-5ca3-b750-d48f4ba293da', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 2, '当模型采用 Group Query Attention（GQA）或 Multi-Head Attention（MHA）结构时，KV Cache 的存储和索引方式会有什么不同？如何避免在长序列机器人任务中因 KV Cache 过大导致显存溢出？', null, null, null, null),
  ('2a4b239a-f652-5963-b17f-10ed20a5f172', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 3, '为什么在 UniVLA 中直出式 action decoder 效果比 flow matching 更好？', null, null, null, null),
  ('1cb2e0ad-b643-5275-b4cf-8206fb96183b', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 4, 'Self Attention 的完整计算流程是什么？', null, null, null, null),
  ('5dc96055-0e61-572f-9ccc-e86cb11c7b03', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 5, '注意力计算中为什么要除以 √dₖ？', null, null, null, null),
  ('4484a57a-a9af-5b15-b835-37c506998c05', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 6, 'Group Query Attention（GQA）的结构和作用是什么？', null, null, null, null),
  ('50cb9d1a-9d0a-5448-aa37-a26ce87bbbdb', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 7, '模型输出的是关节角还是末端位姿？具体自由度是多少？', null, null, null, null),
  ('1e8ef05e-127a-586f-8ae5-d47bb6480b95', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 8, '采用多任务混合训练，相比单任务单独微调，效果有什么差异？', null, null, null, null),
  ('b0b4a5bf-a5bb-5134-be52-91149c8516ea', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 9, '数据集是如何采集、预处理并接入训练流程的？整个数据链路是怎样的？', null, null, null, null),
  ('c86ef2af-054f-5282-b4d0-39858a808996', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 10, '训练时的硬件配置、数据量与训练时长大概是多少？', null, null, null, null),
  ('a2aa94b6-3480-5116-aedd-6d728eb401d3', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 11, '你在动作解码模块做了哪些优化？为什么这么设计？', null, null, null, null),
  ('7856af47-9afa-54c0-a173-66d9f77c83a6', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 12, '有没有尝试过位置编码来增强左右手空间感知？效果如何？', null, null, null, null),
  ('fecc677c-4f70-5500-99e0-e49b8a850076', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 13, '模型在推理时出现机械臂停滞、动作不连贯的原因是什么？', null, null, null, null),
  ('0943ab56-629a-5c29-b55e-eec06e8c90d3', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 14, 'Uni VLA 训练时遇到的主要瓶颈是什么？为什么无法利用历史帧？', null, null, null, null),
  ('2851c4c5-e898-5dc2-9e8c-32eee4a61abe', '0883be4f-2c16-51d1-9a56-4649459d2baf', null, 1, 15, '本地评测结果和官方榜单是否一致？如何验证模型性能？', null, null, null, null),
  ('f858db92-d39b-5ea0-9e18-15fedbd8e236', '9c237907-490e-55ba-82b0-427c6122ca2c', null, 1, 1, '你的测量方程的雅可比和矩阵对状态向量中速度项的具 体展开形式是怎么样的 预测和更新部分的具体方程是什么?', null, null, null, null),
  ('01477859-0d28-57b3-ba25-0b744a6699ed', '1d6bb797-8565-58c2-a209-46f3b978fa29', null, 1, 1, '自我介绍', null, null, null, null),
  ('c058b75a-0546-59b6-8ab5-1f48a1b85ff9', '1d6bb797-8565-58c2-a209-46f3b978fa29', null, 1, 2, '介绍项目中RAG的部分', null, null, null, null),
  ('eb835992-7deb-59f2-b359-39f0c3c53e34', '1d6bb797-8565-58c2-a209-46f3b978fa29', null, 1, 3, '怎么处理数据的', null, null, null, null),
  ('601d5f3d-a9fe-5524-a1f1-36a27e899ac4', '1d6bb797-8565-58c2-a209-46f3b978fa29', null, 1, 4, '如何做到模型可靠的 反问环节 大部分关于技术的问题，产品方面比较少，就是拷打简历 发面经积攒一下人品，求oc', null, null, null, null),
  ('236f0943-ebfd-5f76-939d-d94970889ab4', '6827cecb-a83b-5518-a063-916ca69ad7cb', null, 1, 1, '自我介绍', null, null, null, null),
  ('c579f7b4-8997-5ab6-b681-7e0236fb9a8b', '6827cecb-a83b-5518-a063-916ca69ad7cb', null, 1, 2, '否做过电机的项目', null, null, null, null),
  ('d6de1540-367e-589e-92aa-7d70884a858e', '6827cecb-a83b-5518-a063-916ca69ad7cb', null, 1, 3, '对于人形机器人未来应用场景', null, null, null, null),
  ('5f3abaa4-fe07-5e05-aaaf-ed5096f6d48d', 'd04d51ea-12e2-59b3-ab30-e7f0784bd80d', null, 1, 1, '进行自我介绍', null, null, null, null),
  ('625a51f6-9b05-5632-82ee-9ebe8d9ef6d2', 'd04d51ea-12e2-59b3-ab30-e7f0784bd80d', null, 1, 2, '熟悉哪些软件', null, null, null, null),
  ('7f3eafe9-1e76-5f3a-b1f9-7adc88ef30c9', 'd04d51ea-12e2-59b3-ab30-e7f0784bd80d', null, 1, 3, '高速信号内容和仿真过程等等', null, null, null, null),
  ('e96e2eb8-6bcc-546f-906a-5f75fe54de67', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 1, '银河通用 总体来说这个方向的面试过程比较固定： 一面主要问项目细节', null, null, null, null),
  ('8e7cbcba-2f63-503b-8f1f-e947af4053fa', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 2, '在问到项目中的问题时', null, null, null, null),
  ('80787aab-4b77-558c-9dd1-937d54ab4d13', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 3, '例如问为什么World Model能够解决VLA无法解决的问题', null, null, null, null),
  ('a60d26c4-d266-5908-a2e8-d2388b3f7bec', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 4, '你肯定要从常用的几个模型及其架构', null, null, null, null),
  ('3df79f66-b01c-5686-a84f-07f044313d3e', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 5, '训练等出发回答', null, null, null, null),
  ('a0915819-085f-5d81-9c39-686b894694f7', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 6, '不推荐背八股', null, null, null, null),
  ('68475031-7794-5d42-9a8b-01343d3f67fc', '6c9c21dd-a683-553e-b5e1-67d870e48f1a', null, 1, 7, '更推荐把自己的项目彻底弄清楚', null, null, null, null),
  ('b5222508-3b9b-5893-99c7-fb9138b608a0', 'fa7d4b98-0a02-51c9-b809-159572a91155', null, 1, 1, '流程： -简单自我介绍 -针对我的八股：为什么学这个专业？套公式回答 -实习拷打：2中厂后训练+1 research岗Agent+RAG（offsite，改了下时间线） 1. 问之前的业务线，整个业务的pipeline，项目怎么给公司带来盈利？', null, null, null, null),
  ('98c916b5-a3b3-529b-aa91-32908337439d', 'fa7d4b98-0a02-51c9-b809-159572a91155', null, 1, 2, 'sft到什么程度在做RL？', null, null, null, null),
  ('c12e0b2b-e00f-54ec-a2fe-af3cb8a6e934', 'fa7d4b98-0a02-51c9-b809-159572a91155', null, 1, 3, '0.5h对数据层面提出很多疑问，面下来对cot数据制作部分比较感兴趣（sft里加了个loss惩罚，放了个钩子） CoT数据，preference数据，trajectory数据，tool-use数据，failure case数据 4.DPO，PPO，GRPO等时间线八股 -skill，memory，harness -Agentic RL了解 /场景题：风控场景中人都无法进行判断的诈骗，如果让大模型完成任务？', null, null, null, null),
  ('3976aa49-76dd-50b9-b2fa-34c207fedda8', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 1, '你更偏向软件还是硬件？什么时候开始接触硬件的？', null, null, null, null),
  ('c887f2e3-73ce-55c5-bbb6-6cd4bb008881', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 2, '你提到软件经验多，能讲讲中断机制吗？什么是中断？CPU如何处理中断？', null, null, null, null),
  ('c4b9a2e5-81f1-55da-9247-80ffad52ab0c', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 3, '中断服务函数有什么编写要求？', null, null, null, null),
  ('97426015-8fc5-5a84-8b8f-e44ff1cf2548', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 4, '在多任务环境下，如果全局变量在中断和主循环里共用，你会怎么处理？', null, null, null, null),
  ('94bea882-b3c5-5dc4-b4e2-1eb144b4b67c', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 5, '你们战队常用的通信总线有哪些？CAN总线用得怎么样？遇到过哪些问题？', null, null, null, null),
  ('5ee39f45-d729-510c-ad49-63318dcd3f0d', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 6, 'CAN总线的终端电阻是怎么回事？为什么要加？怎么加？', null, null, null, null),
  ('7ca8807b-a34b-5f9e-bd5e-79eeef9fd0a5', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 7, '调试时你们用UART串口打印吗？现在常用什么调试手段？', null, null, null, null),
  ('bb343e55-70f7-57fa-b90d-49e1d5532eea', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 8, '你们的Bootloader是怎么设计的？有没有做远程升级？', null, null, null, null),
  ('be062b9a-e035-5ae9-93e6-f4924f98d20b', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 9, 'Bootloader具体怎么实现无线升级？需要哪些通信方式？', null, null, null, null),
  ('50160fbc-baa8-5201-ab6c-65e718d62cb9', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 10, '你们现在的开发工具链是怎样的？为什么从Keil换到CMake+ARM-GCC？', null, null, null, null),
  ('7e1f842d-f8a4-5746-9680-eafda7e78f06', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 11, '你们用FreeRTOS吗？相比裸机开发有什么好处？', null, null, null, null),
  ('724d0f43-dba4-5f08-a82e-69722606b608', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 12, '你做过的项目中，哪个最难？难在哪里？', null, null, null, null),
  ('ae806f54-3ca0-5c39-ae43-86267ad68502', '4618d4f8-da36-50ef-bfec-f63688032da9', null, 1, 13, 'AI编程给你带来什么体验？对程序员的要求是变低还是变高？', null, null, null, null),
  ('81c26865-0761-53b4-8f8b-21575756e3b5', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 1, '面试真题回顾 项目管理类： 1. 什么是敏捷项目管理？', null, null, null, null),
  ('cfce9b82-6da4-5baa-b8c8-e190454f4f00', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 2, '项目的最大难点在哪里？', null, null, null, null),
  ('ce5c9614-3793-5293-8af5-7a76e034db4a', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 3, '你会怎么管理这个项目？关键点是什么？', null, null, null, null),
  ('592658a3-f44e-510b-9417-38815a3add96', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 4, '你认为在完成一个长时间的项目过程中，你作为项目经理最独特的特质是什么？', null, null, null, null),
  ('9edcd31a-3931-5c97-9e9d-d29fdca93dad', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 5, '职业规划是什么？', null, null, null, null),
  ('0382c490-3d44-5abf-b69e-2cdcde6452cc', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 6, '个人特质类： 1. 优缺点是什么？', null, null, null, null),
  ('431cdd81-a75e-5744-844a-b231bf34ba93', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 7, '喜欢什么风格的领导？', null, null, null, null),
  ('6634a96a-437a-5d6a-a367-6a8472e65c53', '91c389f6-a6c0-51ad-b604-3df5a7707765', null, 1, 8, '有没有别的offer？', null, null, null, null),
  ('3cd8d03a-6034-52ea-b669-d1d2c6db2e90', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 1, 'lerobot格式数据meta data里面保存的是什么', null, null, null, null),
  ('ebc0cb60-6cdb-52fb-ba1d-febd009e5e61', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 2, 'diffusion和flowmatching的区别', null, null, null, null),
  ('02061e3d-0e54-58f9-a712-41a929f0c9b8', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 3, 'pi0.5和pi0的区别', null, null, null, null),
  ('f6a601c9-72e3-59bf-81d6-4e66ddcab742', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 4, 'pi0.5训练用了多少数据 训练了多久', null, null, null, null),
  ('425ba99f-9319-56fc-834a-01a8a38329b7', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 5, '力扣简单题目', null, null, null, null),
  ('f11a6822-0345-50c7-8795-bbb769c78cc5', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 6, '注意力机制公式 为什么除以根号dk', null, null, null, null),
  ('66725445-5cdf-515d-aa69-980edfb369de', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 7, '多头注意力机制原理 优势 时间复杂度', null, null, null, null),
  ('e92a4689-2d16-50de-9221-6a880804be13', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 8, 'umi数据和真机数据时间尺度不一样 怎么对齐', null, null, null, null),
  ('185890ae-4547-5f3a-a139-201a4a864c88', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 9, '怎么利用失败的数据', null, null, null, null),
  ('293dc1f6-953c-565e-b91c-e8b75ff4d4c2', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 10, 'umi数据最重要的部分是什么 有试过ik逆解 可视化轨迹么', null, null, null, null),
  ('3b3b8c37-857e-5730-9c70-5b9e13f64468', '824207f1-1767-5157-8873-ad3008e26dd7', null, 1, 11, '有没有做过鱼眼相机fov的实验', null, null, null, null),
  ('2c5fdf5b-01b2-512e-93d4-9474aee4c1f4', '8c99d336-61ec-57f5-ad2a-7efed439c968', null, 1, 1, '没推进流程', null, null, null, null),
  ('3f8eb7e4-7426-5e8e-a774-c58f43caee96', '8c99d336-61ec-57f5-ad2a-7efed439c968', null, 1, 2, '全程围绕项目问', null, null, null, null),
  ('8a1e70f8-b349-5fe8-9a7d-f176bdcc981f', '8c99d336-61ec-57f5-ad2a-7efed439c968', null, 1, 3, '实习的流程推的快', null, null, null, null),
  ('a907c1be-7828-5d31-bad7-1515204d0e0c', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 1, '你怎么理解 VLA？', null, null, 'VLA 就是 Vision-Language-Action。Vision 识别杯子、冰块、柠檬片和顾客表情；Language 理解“少冰”“微糖”“不要香菜”；Action 控制机械臂加料、摇匀和封口。', null),
  ('e54d5861-ad02-50ba-b1c2-0feb14be92ae', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 2, '用户说“少冰”，具体放几块？', null, null, '要结合杯型、室温、饮品种类和历史偏好。比如正常冰 12 块，少冰 6 块，微冰 3 块。 追', null),
  ('68571dc2-a8ec-5bfa-b05b-471d309d97b0', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 3, '冰块大小不一样怎么办？', null, null, '用视觉模型估计冰块体积，再闭环控制总冰量。', null),
  ('b3e3c130-cb41-5667-b8fb-9bd7029f3abd', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 4, '如何避免把柠檬片当成冰块？', null, null, '融合 RGB、深度和触觉。冰块透明、反光、温度低；柠檬片有黄色纹理和柔性形变。视觉置信度不足，就让机械臂轻轻夹一下，用触觉二次确认。', null),
  ('c291bfc9-9252-5ba6-9bd5-46dad6493f60', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 5, '机械臂倒糖浆时手抖怎么办？', null, null, '检查控制频率、轨迹平滑性和电机参数，再用低通滤波、轨迹插值、阻抗控制和视觉闭环纠偏。 追', null),
  ('074451c5-1f9a-5812-b288-3db7e4e8c982', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 6, '如果是面试紧张导致手抖呢？', null, null, '建议机械臂先做一次深呼吸。', null),
  ('f071b722-e70d-5d85-b046-60434b644315', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 7, '强化学习的 Reward 怎么设计？', null, null, '成功取杯 +1，正确加冰 +2，正确加糖 +2，成功封口 +3，递给顾客 +5，饮品洒出 -10，吸管插进顾客鼻孔 -100。 同时要避免 Reward Hacking，比如模型为了“不洒”，选择永远不递给顾客。', null),
  ('e5453796-ede0-534b-8a1f-6fd8c732238a', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 8, '模型出现幻觉怎么办？', null, null, '如果顾客点的是柠檬水，模型却说成珍珠奶茶，可以通过订单检索、结构化指令解析和动作前校验降低幻觉。执行前再确认：“您点的是少冰柠檬水，对吗？”', null),
  ('27afdefc-d27d-5fa8-82b9-ac8d0e2f17e4', '3e40b227-ea8e-591c-8417-f0b9e91bd844', null, 1, 9, '当前具身智能最大的瓶颈是什么？', null, null, '不是参数量，也不是训练数据，而是高峰期顾客一直催单。模型刚完成长链路推理，旁边就有人', null),
  ('b8272db6-aa0a-57cc-9de3-840e51d1451b', '90ace5de-674d-52ad-b2d6-db177ed35cb2', null, 1, 1, '具体到某个具体结构设计的原因', null, null, null, null),
  ('e1bd7723-b898-56dc-93d9-c71a5e938308', '90ace5de-674d-52ad-b2d6-db177ed35cb2', null, 1, 2, '零部件如何选型', null, null, null, null),
  ('37afac75-313b-508b-901c-6cf2f309ce77', '90ace5de-674d-52ad-b2d6-db177ed35cb2', null, 1, 3, '列举你所了解的金属和非金属材料', null, null, null, null),
  ('b5139266-bc3b-5a20-b464-ef8289d3b3fa', '90ace5de-674d-52ad-b2d6-db177ed35cb2', null, 1, 4, '铝合金有哪些表面处理方法', null, null, null, null),
  ('00b627f3-6f84-51ef-8e76-c9c960eff650', 'f11aa476-8ca6-52b2-b295-d7d12f631f79', null, 1, 1, 'RLHF 整套训练包含哪些损失? 训练阶段如何组合?', null, null, 'RLHF (Reinforcement Learning from Human Feedback) 通常不是一个单独的损失范数，而是一套训练流程。
经典流程可以分为三步:

1 SFT 阶段: 用高质量指令数据做监督微调，让模型先学会基本的问答格式、任务能力和安全边界。

2 Reward Model 阶段: 用人类偏好数据训练奖励模型，让它学会判断同一个 prompt 下哪个回答更好。

3.RL 阶段: 用 PPO 等强化学习方法优化策略模型，让模型生成更符合人类偏好的回答，同时通过 KLAR

吉免偏离 SFTireference model 太远。
对应损失如下。
1. SFT损失
SFT 本质上是语言模型的交叉糖损失，也就是最大化标准答案在当前模型下的概率:
TSFT(9) = -下(ca)~pser [log ro(ylz)]
Hho 是指令或上下文，g 是人工标注或科选后的高质量回答。
2. Reward Model 损失
Reward Model 使用偏好对数据训练(Reward Model 通常用和 SFT同源或规模接近的LLM) 。给定 (zyu,2)
，其中 yw 是人类更偏好的回答，g 是较差回答，奖励模型输出分数 rs(z,y)。常见 pairwise ranking loss
TRM(9) = —E@y..n) [log(re(zgyu) 一rs(z,2))]
这个损失的目标是让好回答的 reward 高于差回答。实际训练中通常还会做 reward normalization、数据去重、
长度偏差控制和验证集评估，避免奖励模型学到''越长越好"或模板化信好。
3. PPO/ RL 阶段损失
RL 阶段把 SFT 模型作为初始策略，把 Reward Model 作为打分器。对 prompt 采样回答后，奖励通常写成:
R(x, y) = rox, y) — BDgr(ro(-lzjllmee(.lz)

其中 ref 通常是 SFT 模型或固定参考模型。KL 项用于约束当前策略不要为了钻 reward model 的空子而偏离原
模型太远。
PPO 阶段通常包含以下几类目标:

。Policy loss: 提升高优势回答的生成概率，降低低优势回答的生成概率。

。Value loss: 训练 value head 预测当前状态或 token 位置的未来回报，用于估计 advantage。

+ KL penalty: 限制当前模型相对 reference model 的漂移。

+ Entropy bonus: 鼓励一定探索，避免策略过早缩
PPO 的 clipped policy objective 常写为:

Lyotiey(9) = 一了 [ma (ooa clip(pot(9),1 一el1+ Av) |
其中:
Te(at|si)
有一(atlsb
al?) Toua(ailsi)
综合起来，最小化形式可以概括为:
Lr = Lyoticy + CoLvatue — @H (19) + 8D (70|| Tree)

训练阶段如何组合:

1. 先用 SFT 训练出一个可用的 instruction model,

2 冻结一份 SFT 模型作为 reference models

3 .用偏好数据训练 Reward Model.

4 用当前 policy model 对 prompt 采样回答。

5 Reward Model 给回答打分，并额外计算相对 reference model 的 KL penalty.

6 用reward 和 value head 估计 advantage.

7 用 PPO 更新 policy model 和 value head。

8 持续用人工评估、安全评估和离线 benchmark 检查 reward hacking、退化和安全问题。
一句话总结:
RLHF 是''SFT 打底、RM 学偏好、PPO 做策略优化"。面试里要强调: RLHF 不只是最大化 reward，还必须用
KL, value loss、entropy、人类评估和安全指标一起约束，否则模型可能学会利用 Reward Model 漏洞，出现
reward hacking、胡编、变吧味或安全退化。', null),
  ('b63a92b3-be6b-5436-80fc-e6b22a5fae43', 'f11aa476-8ca6-52b2-b295-d7d12f631f79', null, 1, 2, 'GRPO 和 PPO 的区别是什么?', null, null, 'PPO 和 GRPO 都属于强化学习优化方法，目标都是让模型生成更高 reward 的回答，同时避免策略更新太猛。
它们最大的区别是: PPO 依赖 Critic/Value Model 来估计 advantage, Ti GRPO 用同一个 prompt 下多条回
答的组内相对分数来估计 advantage, HHT Critic.
可以先用一句通俗的话理解:
PPO 是''找一个价值模型来判断这一步比平均水平好多少"; GRPO 是"同一道题生成多份答案，让它们互相
比，谁比同组平均更好就奖励谁"。
1. 架构差异
PPO 通常需要多类模型参与:
1 当前策略模型 ro : 正在训练、会被更新的模型。它通常从 SFT 模型初始化，也就是先用监督微调训练出一
个会听指令、能正常回答问题的模型，然后在这个基础上继续做 PPO。
2. 旧策略模型 ro : 不是单独从夫训练的新模型，而是当前策略模型在某一轮 PPO 更新前的快照"。它用于
计算新旧策略概率比，限制更新幅度，防止模型一步改得太猛。
3 . 奖励模型 RM: 由偏好数据训练得到。通常先收集同一个 prompt 下两个或多个回答的人类偏好，例如''回答
A比回答 B 好"，再用 pairwise ranking loss 训练一个模型输出 reward score.
4 (HERE! | Critic Vy: 通常和策略模型共享同一个 SFT 初始化的语言模型主干，额外接一个 value head,
用来预测当前状态或 token 位置的未来回报。有些实现会让 policy 和 value 共享部分参数，有些实现会音
独维护一个 critic 模型。
所以 PPO 里这些模型大致可以理解为:
Policy Model ro
SFT Model 一 4 Reference Model rref
Value Model / Critic Vy
其中 reference model 通常是冻结的 SFT 模型，用来计算 KL 约束; old policy 是训练过程中从当前 policy 临时
拷贝出来的快照; Reward Model 则来自单独的偏好数据训练。
PPO 的优势估计通常依赖 Critic，例如:
Ay = Ri — Valse)
其中 Ry BM reward SPIER, Viy(s:) 是 Critic 预测的 baseline。这个设计比较通用，但会带来两个问题:
+ 需要额外训练和保存 Critic，显存和计算开销更大;
。 如果 Critic 估计不准，advantage 也会不准，从而影响策略更新。
GRPO 去掉了价值模型/ Critic。
严格说，GRPO 不是完全只需要一个模型。训练时通常仍然会有当前策略模型、旧策略模型、参考模型，以及
奖励模型或规则 verifier; 但它省掉了 PPO 里最重、最容易带来估计偏差的 Critic/Value Model.
GRPO 对同一个 prompt 采样 G 个回答:
{01,02,...,0G}
然后用奖励模型、规则打分器或 verifier 得到每个回答的奖励:
frbra rc}
它不再让 Critic 预测 baseline，而是直接用同组回答的平均奖励作为 baseline:
G
1
b= Sry
ja
于是第 i 个回答的 advantage 可以简单理解为:
Aj =r; —b
实际实现中也常做标准化:
4-7 mean(ri,...,7@)
std(ri,...,7@)
这样一来，GRPO 省掉了 Critic 的训练和推理成本，显存占用更低，训练链路也更简单。', null),
  ('15cfc709-f466-56a4-a2f2-549a91d962e0', '6889ae7c-74df-5587-9ae5-512bec4052c4', null, 1, 1, '流程3min自我介绍+30min项目+20min算法+5min反问', null, null, null, null),
  ('b62e39ba-2cb9-599b-8eed-cd055c198b39', '6889ae7c-74df-5587-9ae5-512bec4052c4', null, 1, 2, '项目我简历写了两部分', null, null, null, null),
  ('a61b6015-2b3a-593f-87a7-3be154e37524', '6889ae7c-74df-5587-9ae5-512bec4052c4', null, 1, 3, '一部分是我自己的项目', null, null, null, null),
  ('72e1884b-5741-55b4-803b-3c54e6e06950', '6889ae7c-74df-5587-9ae5-512bec4052c4', null, 1, 4, '我还特意复习了一下结果都没问八股', null, null, null, null),
  ('933bee31-6a12-572a-8c7a-ba73468e3637', 'd655261f-7518-5906-96ef-83d6417ad4af', null, 1, 1, '自我介绍 2.说一下在学校中主要做了哪些项目，介绍你对linux这一块和你刚才提到的RK3588，你重点把你学校做过相关的东西介绍一下 3.RTOS和linux之间的区别 4.RTOS下的调度时延明确的是吧？那linux下有方法能实现这种可预期的调度么（具体怎么实现的） 5.说一下linux中断下半部的几种实现方式，区别是什么？', null, null, null, null),
  ('d622d305-58b4-5367-b604-4d822ebbb5c4', 'd655261f-7518-5906-96ef-83d6417ad4af', null, 1, 2, '你有进行过linux中断相关的开发么？（我说没有，只有进行过ARM+RTOS上的中断开发） 7.什么情况下需要屏蔽中断？（我回答的是优先级翻转，不知道对不对）之后就问除了这个还有别的吗？', null, null, null, null),
  ('c9e5b753-8b64-57e0-82d9-cda32771854e', 'd655261f-7518-5906-96ef-83d6417ad4af', null, 1, 3, '数据结构有接触过么？你说一下链表和数组的区别，你说一下怎么去判断一下链表里面有没有环？', null, null, null, null),
  ('941046fb-ff98-5608-a175-a54cc3c8c84d', 'd655261f-7518-5906-96ef-83d6417ad4af', null, 1, 4, '说一下IIC协议？有用过么？说一下IIC里边上拉电阻阻值一般选什么？阻值的大小会影响什么性能？', null, null, null, null),
  ('d896e3a6-dcec-51f3-9db9-d21735cb926a', 'd655261f-7518-5906-96ef-83d6417ad4af', null, 1, 5, '（手撕）假如我要定义一个int返回值，两个int参数的函数指针，怎么写？你可以直接敲，这里不有消息框么，发过来就行。（解释一下你写的这个定义） 12.什么是指针函数？', null, null, null, null),
  ('b46de9f6-0d02-5b68-b679-d9a51f40faed', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 1, '进行自我介绍', null, null, null, null),
  ('cf0a7ae4-ddb7-5c36-bec7-a1899ff8974e', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 2, '讲一下项目的整体框架', null, null, null, null),
  ('dfdeaa7a-566c-5aaa-803e-5a7c375610d3', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 3, '项目需求是什么', null, null, null, null),
  ('710ba88a-ec22-578e-9e51-ff86f98bff60', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 4, '设计完成后', null, null, null, null),
  ('1f50afb1-c9fc-5b19-9418-a936cf103dcc', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 5, '为什么要考虑多源数据采集', null, null, null, null),
  ('7bf4812d-e0c1-5269-804e-99e80acb3468', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 6, '各部分模块怎么选型的', null, null, null, null),
  ('b91edbe4-ab75-5085-aaec-0cad1bc1f0c5', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 7, '会考虑哪些细节', null, null, null, null),
  ('21562ede-c9d0-551e-8c53-6a089a4b457f', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 8, '具体带宽计算以及主控板是否满足通信带宽要求', null, null, null, null),
  ('1ce95b4a-0c6c-59b2-8a60-3169ab508f3a', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 9, 'USB协议有哪些', null, null, null, null),
  ('6ac3441b-1e9e-5a18-bf43-caf26ca4c58c', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 10, '速率分别是多少', null, null, null, null),
  ('f7bd9481-8254-5aa5-b2ae-83fbe9920936', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 11, '你的主控板有哪些外设资源', null, null, null, null),
  ('5c43ca5f-ba1d-5b75-aac4-aadbc4fc8495', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 12, '怎么分配的', null, null, null, null),
  ('84ef77bf-0d5a-5012-9901-7a9d3c4f01e1', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 13, '你在公司中做信号仿真工作的流程是什么', null, null, null, null),
  ('0bb8fc4a-dd9b-52b8-b70f-cf36d7217ef1', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 14, '眼图会重点关注哪些指标', null, null, null, null),
  ('cffc40dc-1a82-5939-aafa-be7c1804f8f3', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 15, '怎么判断眼图是否合格', null, null, null, null),
  ('040822d2-5d20-5d7a-99bf-6528a1199567', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 16, '你是怎么排查问题', null, null, null, null),
  ('2514b54a-190e-524a-923f-e28b5ccbe542', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 17, '如何优化的', null, null, null, null),
  ('c9c97357-9e30-5170-ab7d-9e0b3b95a19c', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 18, '项目中经历过最困难的问题是什么', null, null, null, null),
  ('6e989265-f8c3-5ba0-997e-f7bf828bee56', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 19, '如何解决的', null, null, null, null),
  ('50c6c864-4d8a-5e8e-a54f-308c28c928bd', 'e57b850d-c3f9-520f-bc58-31010c516d2c', null, 1, 20, '秋招面试流程：一轮技术一轮综合', null, null, null, null),
  ('1f8f3656-e8e7-5c50-a88f-22303e4bdf2f', 'f5c3ed62-8af4-5aca-b627-9186184673cd', null, 1, 1, '“VLA（Vision-Language-Action）具身模型 + 机器人端云协同”这一部分的核心要点是什么？', null, null, '。面试官明确在区分「懂通用 LLM 的人」和「懂机器人+LLM 的人」。以下提炼本批最高频考点。', null),
  ('88b5f863-1814-50f9-86df-5e2ac8d45741', 'f5c3ed62-8af4-5aca-b627-9186184673cd', null, 1, 2, '“考点一：VLA 与通用 LLM 的本质区别”这一部分的核心要点是什么？', null, null, '这是面试核心区分题。通用 LLM（GPT-4、Claude）做文本对话，输出 token 序列。VLA 模型（如 UniFoLM-VLA）做的是文本指令→机器人动作向量，输出的是物理世界可执行的 action。回答时需体现对「LLM 从数字世界走向物理世界」这一趋势的理解，而非停留在文本生成。', null),
  ('4d623b52-cbe8-5b88-af86-b60737767a05', 'f5c3ed62-8af4-5aca-b627-9186184673cd', null, 1, 3, '“考点二：机器人业务系统设计”这一部分的核心要点是什么？', null, null, '不能只给互联网高并发标准答案。需主动覆盖三要素：①实时性——指令延迟毫秒级响应；②边缘算力受限——推理不能全放云端，需端侧 / 边缘侧推理；③硬件断连——断网本地降级、设备指令重传机制。面试官核心考察点：是否意识到互联网业务和机器人业务的最大鸿沟。建议多了解 ROS2 通信框架（话题 / 服务 / 动作）的基本概念，不要求手写节点，但需理解消息流转链路。', null),
  ('65915349-86d4-56ca-8530-b915871361bf', 'f5c3ed62-8af4-5aca-b627-9186184673cd', null, 1, 4, '“考点三：具身智能行业认知”这一部分的核心要点是什么？', null, null, '面试官会先问「你了解宇树产品吗？看过官方开源仓库吗？」——诚意题。提前了解 G1、H1、Go2 等产品线，跑通 UniFoLM-VLA 推理代码，了解输入输出格式是基本要求。RAG/Agent 已从加分项降级为「默认基础」，真正的加分项在具身智能领域知识。', null),
  ('7099ec2f-fff8-5a69-a779-bcc3d618ac24', 'f5c3ed62-8af4-5aca-b627-9186184673cd', null, 1, 5, '“考点四：后端经验在 AI 场景的独特价值”这一部分的核心要点是什么？', null, null, '面试官明确认可后端价值，不要求「抛弃 Java 做纯 AI」，反而看重分布式架构、服务化、设备接入等工程经验在机器人场景的迁移能力。他们要的是「懂后端的大模型应用工程师」，而非「半吊子算法工程师」。这对非算法背景转 AI 的候选人是个重要信号。 完整面经合集在 llmbases.com 第 9 章。', null),
  ('82fefce3-c479-518d-8120-ca94d8b485f6', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 1, '我们聊聊Agent的健壮性设计', null, null, null, null),
  ('e9c13970-2340-5e27-935d-0c91bc02eefa', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 2, '这个问题为什么很重要', null, null, null, null),
  ('e5fdc050-2c28-5cdb-905b-0c9f80331dcb', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 3, '区分你的项目是Demo还是企业项目的考察点之一', null, null, null, null),
  ('138dd60b-1f52-5967-b570-9541e713276e', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 4, '聊聊健壮性设计', null, null, null, null),
  ('d22e364c-cc21-55cd-b1e0-5ee1bcc91f1c', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 5, '模型调用失败', null, null, null, null),
  ('6367b5b9-ab6c-5ba0-bcbb-778076acf3cf', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 6, '如何优雅处理和降级', null, null, null, null),
  ('1f2994fd-c82f-57a0-bdd1-ca8c4650b581', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 7, '最常考的就是工具调用失败如何处理了吧', null, null, null, null),
  ('d91afff3-ee7f-590d-a742-401d83529a73', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 8, '比如模型调参数给错了', null, null, null, null),
  ('5ab010be-c344-5c5d-8d15-33ee980e1b29', 'cfa77083-517a-5a6c-94c3-2335ea6f3e5f', null, 1, 9, '那么可以让模型重新推理参数', null, null, null, null),
  ('c35c4ca4-40ca-53a5-bc7a-26d6390c77ca', 'd390d465-c196-59e2-8c9e-5f46af66170c', null, 1, 1, '根据最新面试情况：把重点的内容突出，把不是那么重点的内容标记，让大家知道面试喜欢考什么？', null, null, null, null),
  ('c7408131-c4b2-5062-bfce-59f3ea880720', '0a90f6d0-7a7d-54ad-8b3a-f5797501aec0', null, 1, 1, '生成式评估：指标怎么选，打分模型怎么校准？', null, null, '相关性；端到端看任务成功率。关键要区分「检索-生成」耦合评估与解耦评估，避免把召回不足误判为生成幻觉。', null),
  ('3e7f5134-6d2a-544d-8fd7-724400daf50f', '0a90f6d0-7a7d-54ad-8b3a-f5797501aec0', null, 1, 2, '“VLA 架构：从零设计的关键是动作表示与实时性”这一部分的核心要点是什么？', null, null, '小米具身智能面经全部围绕 VLA 架构与路线判断。标准链路：Vision Encoder → 对齐层 → LLM Backbone → Action Head。动作空间表示是核心分歧：连续值直接回归简单但高频控制压力大；离散 token 可与语言统一但精度受限；Diffusion Policy 在动作平滑性上更有优势。当前最大瓶颈是数据闭环（跨本体、跨场景）和 Sim-to-Real 鸿沟，改进方向是自动标注 + 失败恢复重标，以及结合世界模型做长程规划。 完整面经合集在 llmbases.com 第 9 章，欢迎私信投稿！！！', null),
  ('fba796c6-4b2a-51d0-aab3-fb1ea5a6712c', '42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', null, 1, 1, '感谢小米秋招的第一个面试，打响了我秋招第一枪！ 全程35分钟左右，面试官很和蔼，主要是我在对照我的ppt讲解我的科研项目经历，面试官也没有深挖 反问： 1.这个工作的主要业务是干什么？', null, null, null, null),
  ('5c75e1b1-914b-5e8e-bd15-1e23aafa873b', '42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', null, 1, 2, '㊙ 2.工作地点在哪，北京工厂还是小米科技园？', null, null, null, null),
  ('4b64ca2c-348b-5820-a442-6ed75d07b927', '42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', null, 1, 3, '薪资待遇怎么样？', null, null, null, null),
  ('17507660-69f5-582e-a764-b12847114497', '42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', null, 1, 4, '一共有几轮面试，一面过后大概要走多久流程？', null, null, null, null),
  ('b81700f1-8305-5d2a-b94c-bcae22436694', '42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', null, 1, 5, '该岗位主要招收的是硕士还是本科生？', null, null, null, null),
  ('df2af033-ae10-526d-b487-d3fb1f6e4dae', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 1, '逐字复述容易失真，下面是我按现场考察点和 JD 重新整理的公开问法，不是原题照搬： 1. ViT、VLM、VLA 分别解决什么问题？做缺陷识别为什么不用检测/分割模型加规则？', null, null, null, null),
  ('77a80fa2-6a71-5bfc-95d3-c51730894aad', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 2, 'patch size、输入分辨率和注意力计算量有什么关系？低对比度小缺陷怎么保留细节？', null, null, null, null),
  ('c04d5f59-fc99-5272-8207-eeea5d36bc56', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 3, '缺陷样本少、长尾明显，不同机型、材料和光照又有域偏移，数据和训练方案怎么设计？', null, null, null, null),
  ('4f31d77e-03eb-592b-b741-a9dc3ada80c6', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 4, '离线指标很好，上机后效果下降，应该从数据、预处理、模型转换还是硬件执行哪层排查？', null, null, null, null),
  ('09b8cdea-dfac-5477-9c59-21df3da822d0', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 5, '端侧部署时，延迟、显存和精度怎么取舍？量化、蒸馏、ONNX/TensorRT 分别解决什么？', null, null, null, null),
  ('7abdaf3e-3cf0-5180-827a-f9b6687924f4', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 6, '缺陷识别怎么接入闭环控制？误报停机和漏报废件，阈值与安全策略如何权衡？', null, null, null, null),
  ('03852de3-1890-554d-9677-c2474c9f9557', 'eaceff89-c4fc-5dd8-ae14-8f5709abbb26', null, 1, 7, '讲一个项目失败案例：看到什么现象、提出哪些假设、怎么定位，最后为什么妥协？', null, null, null, null),
  ('0f4104d6-9960-53ef-b6b2-58532f16190a', '3275ba43-b955-596e-ad7b-b802b45ac27b', null, 1, 1, '注意力计算中为什么要除以根号下dk？讲一下对公式的理解', null, null, null, null),
  ('4662576f-5f9e-5dc1-a75d-2af7cfb0417a', '3275ba43-b955-596e-ad7b-b802b45ac27b', null, 1, 2, 'MHA/GQA八股', null, null, null, null),
  ('08249027-0cc2-5320-8238-3462ff18035b', '3275ba43-b955-596e-ad7b-b802b45ac27b', null, 1, 3, '分布式训练相关，如训练时长等', null, null, null, null),
  ('27586e80-3363-5d58-83eb-f823d96bd4db', '3275ba43-b955-596e-ad7b-b802b45ac27b', null, 1, 4, 'batch norm /LN/RMSnorm', null, null, null, null),
  ('bbe92e74-0daf-56fd-83c3-6790663e2675', '3275ba43-b955-596e-ad7b-b802b45ac27b', null, 1, 5, 'RL经典八股问题', null, null, null, null),
  ('cdaf3720-1e9e-5566-b625-5517359cc48f', '3275ba43-b955-596e-ad7b-b802b45ac27b', null, 1, 6, 'pi0.5中VLM 怎么和动作专家连接？', null, null, null, null),
  ('5d36bb98-d980-51de-a12c-86f279484717', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', null, 1, 1, 'umi数采原理，pipline搭建流程', null, null, null, null),
  ('33013fc1-bc70-5d9a-9815-ff38b8868174', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', null, 1, 2, 'ppo原理以及如何调参', null, null, null, null),
  ('b0b7e865-d89a-58bf-8935-90011b15b433', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', null, 1, 3, 'pi05框架', null, null, null, null),
  ('fd5dea8d-7ba2-5ff5-ad60-b9aa2bf42d6c', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', null, 1, 4, 'vlm如何与动作专家交互', null, null, null, null),
  ('4a1b9f1f-6759-5c7a-b588-0b9c6dbd6461', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', null, 1, 5, '全量微调参数设置，用了多少卡多少时间', null, null, null, null),
  ('c4cbbbac-cf1b-52e3-b7ed-32cf26c9fd3b', 'eea26463-6fb1-58d7-9c9f-260fd0c93e25', null, 1, 6, '腕部为什么使用鱼眼相机？', null, null, null, null),
  ('d8eb5101-7153-57c2-ad8a-38be4f2638eb', '658ec94e-1d30-5e59-bdde-b2c1127aa9e2', null, 1, 1, '智元的面试难度名不虚传，是我面了这些家里面难度明显最大的，给我都面沉默道歉红温了 一共有两位面试官，均未开摄像头，主要是对项目深深拷打迁移化拓展，此外还非常注重理论知识的掌握，对于项目会提问“这里用到了/验证了哪些理论？', null, null, null, null),
  ('00cdeb7d-2b5d-53be-b0ed-7002e2b37a0a', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 1, '面完以后重新看了一遍JD', null, null, null, null),
  ('794b1c87-b8b9-5ba0-bc74-ca3ec5ee48f6', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 2, '我的第一反应是：这个岗位想要的可能不只是“会训练VLA模型的人”', null, null, null, null),
  ('7f63dd25-ac07-5fae-bf9a-ebef10ff0b1a', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 3, '而是能够把模型', null, null, null, null),
  ('fa699adc-1ea3-5494-817d-3d22ab87d6fb', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 4, '机器人控制和真机验证串起来的全栈型选手', null, null, null, null),
  ('c8e8d602-bd2f-52e1-995d-7aaea2db78d5', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 5, '世界模型如何完成环境建模', null, null, null, null),
  ('2f95c00c-1aba-5f82-88d1-669fd089e97b', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 6, '模型不仅要生成动作', null, null, null, null),
  ('9eb44c42-1d6a-5939-ba8e-2f2d6c3fb074', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 7, '其次是机器人层', null, null, null, null),
  ('3a390cdc-41f9-57ff-9eb3-345349044135', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 8, 'JD里同时出现了任务规划', null, null, null, null),
  ('64905d47-78a4-50b3-b48a-257ca184450d', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 9, '这意味着只会讲模型结构可能不够', null, null, null, null),
  ('eddbeb37-b48c-5216-a793-1686763a51b1', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 10, '四足或者移动操作机器人上', null, null, null, null),
  ('e58b7b1a-8ecb-5658-ab09-d93ea7bffc22', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 11, '第三是数据与训练闭环', null, null, null, null),
  ('3ce2d18b-ecdd-5125-a11b-1fd244771002', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 12, '这个岗位很关注真实机器人数据难获取', null, null, null, null),
  ('633d154c-a328-52fa-a5a6-77b11998b5f3', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 13, '分布差异大以及模型如何持续迭代这些落地问题', null, null, null, null),
  ('c6baa9fe-2339-5434-a1ce-13605cb62021', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 14, '这个岗位给我的整体感觉更像“具身基础模型研究＋机器人系统落地”', null, null, null, null),
  ('992ed0b9-80c9-5690-98a0-78d76950120d', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 15, '论文和模型能力能帮助进面', null, null, null, null),
  ('8028f0bc-e778-5d36-bb53-a50179ac6d37', 'c2129627-f7f5-5ce2-801a-df9df27fae14', null, 1, 16, '这些更多是结合JD和面试后的个人理解', null, null, null, null),
  ('2afb2891-8958-5594-98ea-f3447638a245', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 1, '讲一下对QKV的理解，尤其是kv cache', null, null, null, null),
  ('52299ded-2f09-5d89-97ba-af79586f9b83', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 2, 'self attention八股，伪代码', null, null, null, null),
  ('5145977c-f19e-5fe6-b7fb-2bcce61add44', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 3, 'flow matching八股，伪代码', null, null, null, null),
  ('5bfbb5d0-ac86-5454-b97f-5ba9b3074617', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 4, '训练数据是关节角还是末端位姿？训练数据量多大？', null, null, null, null),
  ('49791127-8708-5720-a40a-fb2997d6b716', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 5, 'Lora微调的效果如何，训练时长？', null, null, null, null),
  ('69901030-7d1c-5704-811a-428522b9ac06', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 6, '是否使用过数据增强，有哪些方法？效果如何？', null, null, null, null),
  ('4f574fce-0efa-5535-8ad1-4e659aa56943', 'd3dd3fab-a63a-5bea-a4f4-c94ccec77822', null, 1, 7, 'umi训练遇到的问题及数采规范 8.数采的pipline如何搭建，遇到的问题有哪些？', null, null, null, null),
  ('797353bf-6451-5278-a574-f33eb3bfae3c', '233cf00f-fb03-52c7-a04f-8018f4b61457', null, 1, 1, '行业与公司选择 从具身智能与人形机器人赛道的发展前景切入，结合智元在行业内的技术积累和量产落地能力，说明为什么选择这家公司而不是其他机器人公司', null, null, null, null),
  ('0c38d222-7a8d-5ff7-8e42-0d005d6df6df', '233cf00f-fb03-52c7-a04f-8018f4b61457', null, 1, 2, '岗位匹配度 结合自己的专业背景、项目经历和技能栈，说明为什么适合运动控制算法岗位，具体到控制理论、强化学习、机器人学等方向的积累', null, null, null, null),
  ('0d68e68d-8ff2-5a1b-80d6-bdf3afbde354', '233cf00f-fb03-52c7-a04f-8018f4b61457', null, 1, 3, '个人成长诉求 表达自己希望在真机落地、算法从仿真到实机迁移的过程中获得成长，而不只是做纯理论研究。 参考答案：我选择智元主要有两方面考虑。首先是赛道选择，人形机器人是目前AI落地物理世界最核心的载体，运动控制又是人形机器人的核心技术栈之一，我看好这个方向的长期价值。智元作为国内少数实现了人形机器人规模化量产的公司，既有算法积累也有硬件量产能力，不是单纯做科研Demo，这点很吸引我。 其次是岗位匹配。我本科和硕士都是控制理论与控制工程方向，期间做过两个跟机器人运动控制相关的项目——一个是基于MPC的四足机器人步态控制，另一个是用强化学习做机械臂轨迹跟踪。我熟悉PID、LQR、MPC这些经典控制方法，也有强化学习和仿真环境（Isaac Gym、MuJoCo）的使用经验，跟岗位要求比较契合。 我对这个岗位的理解是，它不是纯理论算法研究，而是要把算法真正跑在机器人本体上，解决真机调试中遇到的各种实际问题，比如sim-to-real迁移、控制延迟、传感器噪声这些。我希望能参与从算法设计到真机落地的完整流程，这也是我选择智元而不是纯研究院的原因。 回答时注意不要泛泛而谈「我对机器人很感兴趣」，一定要结合自己的实际经历来说明匹配度', null, null, null, null),
  ('2de0bd52-728f-5481-8917-db8988d6f759', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 1, '请解释Transformer中的多头注意力机制 (MHA) 的原理，并说明其复杂度。BERT 和GPT在架构上有什么区别?', null, null, '多头注意力机制 (Multi-Head Attention) 的核心思想是将输入的Q、K、V通过不同的线性投
影映射到h个子空间，在每个子空间中独立计算Scaled Dot-Product Attention，然后将h个头
的输出拼接起来，再经过一次线性变换得到最终输出。公式为: MultiHead(Q,K,V)=Concat(h
eadl,….,headh)WAO，其中headi=Attention(QWi^Q, KWi*K, VWiAV)。复杂度方面，MHA的
时间复杂度为0(n?. d)，其中mn是序列长度，d是特征维度。平方项来自注意力矩阵的计算，这
也是Transformer处理长序列时的主要瓶颈。BERT和GPT的核心架构差异在于: BERT是双向
编码器 (Encoder-only) ，采用掩码语言模型 (MLM) 进行预训练，能够同时看到上下文信
息，适合理解类任务 GIADA, IS) 。GPT是单向解码器 (Decoder-only) , RAB
回归语言模型进行预训练，只能看到左侧上下文，适合生成类任务 〈如文本生成、对话) 。这
也是为什么BERT在NLU任务上更强，而GPT在NLG任务上更有优势。', null),
  ('834f304b-6db3-58e3-b3a2-9fb779d1b57a', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 2, '请做自我介绍，并谈谈你对具身智能算法工程师的理解，以及你为什么选择智元机器 7)', null, null, '面试官好，我是XX，毕业于XX大学，研究方向为具身智能/强化学习/多模态大模型。具身智能
算法工程师的核心任务是设计一套让机器人“学会动作”的算法体系一一让机器人学得又快又
稳，还能在真实环境里安全地执行任务。这不仅需要算法创新，还要解决Sim2Real、实时性
、人鲁棒性等工程难题。我选择智元机器人，首先是因为智元由稚晖君联合创立，短短时间就构
建了机器人本体+Al全栈技术，实现了人形机器人规模化量产与全球商用。智元是具身智能领
域当之无愧的领跑者。其次，我了解到智元面试效率突出，优才可一周内完成全流程，说明团
队注重实干高效。我希望在这样的环境中快速成长，将算法研究转化为真实产品力。我的匹配
点包括: 熟悉Transformer和强化学习算法，有完整的算法落地项目经验，对机器人学有浓厚
兴趣。希望能加入智元，共同推动具身智能的产业落地。', null),
  ('6c7237dd-4d47-5875-b35e-9e3ea4498d82', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 3, '请介绍你做过的最复杂的具身智能/机器人算法项目，包括项目背景、你的角色、技 术难点及解决方案', null, null, '我参与过的一个项目是基于仿真环境训练四足机器人行走策略并迁移到真机。项目目标是让机
器人在复杂地形上实现自适应行走，核心挑战是Sim2Real gap导致的策略迁移失败。我在项
目中负责RL算法的设计与实现，采用PPO算法结合随机化 (Domain Randomization) 来增
强泛化能力。主要技术难点是仿真中训练好的策略在真机上表现不稳定，足端落地冲击大、姿
态抖动明显。我通过以下方式解决: @在仿真中加入更丰富的随机化参数 (摩擦力、质量、地
面刚度) ，扩大策略的泛化边界; GD)引入阻抗控制作为底层控制器，将RL输出的高层指令转
化为平滑的关节力矩; 图设计了一套渐进式迁移流程一一先在平坦地面测试，再逐步过渡到复
杂地形。最终策略成功迁移到真机，在草地、碎石地等多种地形上实现了稳定行走，步态平滑
度较基线方案提升了约30%。这次经历让我深刻体会到，具身智能算法不能只停留在仿真，必
须考虑真实环境中的物理约束和工程细节。', null),
  ('f9b22619-a2b3-58e5-8062-ec667ba53df6', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 4, '在大模型训练中，KV-cache是什么?为什么要做KV-cache优化? MQA (Multi-Query Attent ion) 的原理是什么?', null, null, null, null),
  ('64bb2536-beb7-59ec-99d9-6ae410d7e5f9', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 5, '在具身智能中，VLA (Vision-Language-Action) 模型如何实现多模态特征对齐? 你了解哪 些VLA模型?', null, null, null, null),
  ('05341b30-faaf-511c-a7f6-fadf7c699121', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 6, '在机器人真机部署中，算法从仿真迁移到真实环境面临哪些挑战? 你如何应对Sim2Real ga p?', null, null, null, null),
  ('f249f6bb-bffb-5a9a-b583-6d51f395978e', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 7, '强化学习算法中，PPO和SAC的核心区别是什么? 在机器人控制中如何选择?', null, null, null, null),
  ('6cdac6d8-4426-54d5-89e4-29455a000a5e', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 8, '你如何理解“数据飞轮”在具身智能算法迭代中的作用? 如何构建高效的数据飞轮?', null, null, null, null),
  ('3f28c2ca-bac5-564f-8acb-ef4b48c29c92', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 9, '模仿学习中的行为克隆 (BC) 和Diffusion Policy各有什么优缺点? 分别适用于什么场景?', null, null, null, null),
  ('81853326-529d-542c-a48f-83a5ddd39ce3', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 10, '请推导策略梯度 (PolicyGradient) 的基本公式，并解释其物理意义', null, null, null, null),
  ('0b785f7e-b558-591f-8f4c-6efb2a4be8ee', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 11, '什么是GAE (Generalized Advantage Estimation) ? 它在PPO中起什么作用?', null, null, null, null),
  ('4abb0a7f-ba8b-548e-a9ef-ab66d8c2339a', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 12, '在机器人操作任务中，如何设计有效的动作空间表示? 连续空间和离散空间各有什么优劣 2', null, null, null, null),
  ('0fa07558-40d8-5d3a-9e4b-e590686f5ff9', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 13, '大模型分布式训练中，FSDP (Fully Sharded Data Parallel) 的工作原理是什么?', null, null, null, null),
  ('0fae72ad-4ec2-5bd0-a67c-fc0d45ced141', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 14, '如何解决强化学习训练中奖励稀疏 (Sparse Reward) 的问题? 有哪些常用方法?', null, null, null, null),
  ('54b03dfd-08e3-512f-91c0-96275078bcb5', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 15, '你了解哪些Sim2Real的域随机化(Domain Randomization) 方法? 请举例说明', null, null, null, null),
  ('2039f39a-4256-58f9-a09e-bc5135b383e7', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 16, '在机器人感知中，如何实现视觉-触觉-力觉的多模态融合?', null, null, null, null),
  ('244f3f97-76ff-5114-916e-e0c5835b81b9', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 17, '具身智能中的世界模型 (World Model) BHA? 它在规划和控制中起什么作用?', null, null, null, null),
  ('79122ef3-eed9-5d43-b9f5-744aba24e1b4', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 18, '请解释Transformer中位置编码 (Positional Encoding) 的作用和实现方式', null, null, null, null),
  ('a282c32b-ac5f-54ec-973d-d759ecdb5c4e', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 19, '在VLA模型中，如何解决视觉编码器和语言编码器的特征空间不一致问题?', null, null, null, null),
  ('43f71e9a-8819-57f2-83be-1b62c72405e7', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 20, '什么是RLHF (Reinforcement Learning from Human Feedback) ? 在具身智能中如何应 用?', null, null, null, null),
  ('208dfc72-a4f8-535a-b4ab-81ca320ec462', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 21, '机器人运动规划中，基于采样的方法 GORRT) MFA AS AALS?', null, null, null, null),
  ('6797f0a8-f839-5b46-839e-fd17a0cbfae2', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 22, '在具身智能系统中，如何设计有效的Sim2Real迁移评估指标?', null, null, null, null),
  ('b290627a-3599-5aa4-b19a-d631d17e65a4', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 23, '什么是“Chunking”技术? 在动作生成中如何应用?', null, null, null, null),
  ('2ce32834-a2ae-51d8-94f5-4e0db978cd0b', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 24, '请解释PPO算法中Clipped Surrogate Objective的含义和作用', null, null, null, null),
  ('02904b0b-6aac-594c-a9ed-03e5e3e9cc6e', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 25, '在多任务强化学习中，如何设计网络结构实现任务间的知识共享?', null, null, null, null),
  ('86922ecc-9950-5695-bfd4-0e7148d58a6f', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 26, '什么是“Teleoperation”数据采集? 在具身智能中如何构建高效的Teleoperation系统?', null, null, null, null),
  ('406c5e5b-d6f6-55d9-bc87-1f880833c906', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 27, '机器人控制中，阻抗控制 (Impedance Control) 和力控制 (Force Control) 的区别是什 a?', null, null, null, null),
  ('73b4469b-a5bc-5eb8-8c30-ba8b73034f29', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 28, '在部署VLA模型到真实机器人时，如何解决推理延迟问题?', null, null, null, null),
  ('11621887-0296-5f51-80f6-7503dac78c4a', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 29, '具身智能算法从实验室研究到产品落地，你认为最大的工程挑战是什么?', null, null, null, null),
  ('2ff5726d-fa25-5d85-a837-2d7addab4282', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 30, '你如何看待“端到端” (End-to-End) 和“模块化” (Modular) 两种机器人算法范式的 A?', null, null, null, null),
  ('bc948f11-1188-5522-b4f9-844d00f1793f', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 31, '智元机器人“远征Al1”的量产商用，对算法工程师提出了哪些不同于纯研究的要求?', null, null, null, null),
  ('a0fce66d-57c3-5320-874f-422ed1ada878', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 32, '在具身智能团队中，算法工程师如何与硬件、软件工程团队有效协作?', null, null, null, null),
  ('582bbac1-b0b6-59a0-8bcd-a1e4d16598e9', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 33, '请分享一篇你最近读过的具身智能领域论文，并谈谈你的见解', null, null, null, null),
  ('89ada1f0-2456-5cb7-9a07-8a52ada56448', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 34, '你对“具身智能”未来3年的技术演进路径有什么判断?', null, null, null, null),
  ('c06d9650-675f-5d99-8072-1d5cc2f4023a', 'f504b07b-5969-55f0-890f-1e8014865c21', null, 1, 35, '你还有什么问题想问我们? 关于技术方向、团队文化或职业发展方面', null, null, null, null),
  ('b3fe9c08-578e-5255-92c8-8a00bf580a49', 'c3961087-9bca-51df-9f40-f2bb439d5c2c', null, 1, 1, '生成式评估：指标怎么选，打分模型怎么校准？', null, null, '米哈游评测岗连追 5 题，核心痛点是缺乏 ground truth 时如何建立可信度量。评估体系分四层：n-gram 重叠类（BLEU/ROUGE）适合有参考答案的短文本；语义相似度（BERTScore）缓解 n-gram 僵化；基于 LLM 的评估（GPT-4 as Judge）适合开放式生成，但需警惕位置偏差、长度偏差和自我增强偏差，可通过细化 rubric、多轮投票和引入参考回答来缓解。若训练 Reward Model，需用高质量 pairwise 对比数据，并对奖励分布做正则 / 加 KL 约束，防止 reward hacking。', null),
  ('9be23c31-af61-5e66-986f-e734e3b00666', 'c3961087-9bca-51df-9f40-f2bb439d5c2c', null, 1, 2, '“RAG 测评不能只看生成，检索端也要解耦”这一部分的核心要点是什么？', null, null, 'RAG 系统评估需分三层：检索端看 Recall@K、命中率；生成端看忠实度（Faithfulness）、答案相关性；端到端看任务成功率。关键要区分「检索-生成」耦合评估与解耦评估，避免把召回不足误判为生成幻觉。', null),
  ('2be1e863-1a87-5897-af0a-dc4ba1f91bc2', '4141c408-7e16-5b93-9b80-a1b995cc70ec', null, 1, 1, '本人bg：双9硕，一篇a会，三段具身相关实习 项目相关问题 1. lerobot格式数据相关问题 2. umi数据和真机数据时间尺度怎么对齐？', null, null, null, null),
  ('c3223cdd-bb9e-50b7-9bbe-01c3be22856a', '4141c408-7e16-5b93-9b80-a1b995cc70ec', null, 1, 2, '失败的数据如何利用？', null, null, null, null),
  ('d080668e-47e6-5da7-9fa5-906d309ed00a', '4141c408-7e16-5b93-9b80-a1b995cc70ec', null, 1, 3, '算法模型（PI0.5为主） 1. pi0.5和pi0的区别？', null, null, null, null),
  ('e8073f6e-c258-5e43-9512-ecbceefc4b75', '4141c408-7e16-5b93-9b80-a1b995cc70ec', null, 1, 4, 'pi0.5训练的数据量，训练时长？', null, null, null, null),
  ('c80096e4-a6ad-5920-b929-67c72b0f8c7e', '4141c408-7e16-5b93-9b80-a1b995cc70ec', null, 1, 5, 'pi0.5中Action Expert 和 VLM 怎么交互？', null, null, null, null),
  ('35b2389e-5bfd-531d-9146-3d8a25e73002', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 1, '自我介绍', null, null, null, null),
  ('cafe1a85-9217-5829-8402-264853e86d02', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 2, '实习中体现好奇心与创新的实践 发现现有功能的数据异常后，主动分析原因并提出改进方案，最终推动上线并带来正向数据反馈。重点突出“发现问题—提出假设—推动落地”的逻辑链条', null, null, null, null),
  ('496e7030-7412-5b1e-8c98-c252d1f1f430', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 3, '遇到过比较困难的事情及解决方式', null, '困难时聚焦于资源有限、时间紧迫或需求模糊等真实场景。', null, null),
  ('7cbd9661-7dc9-5ddc-8517-df395f777dd7', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 4, '优缺点分析', null, null, null, null),
  ('d65aac58-a380-5dda-9350-e10439096f22', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 5, '为什么选择产品经理岗位 说明自身特质（如善于抽象问题、关注用户体验）与产品工作的匹配度；再阐述对产品经理价值的理解（连接用户、业务与技术，驱动产品迭代）；最后用实习经历佐证该认知，形成闭环', null, null, null, null),
  ('4edeee23-fbe0-5003-83ef-3a6b99720b83', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 6, '产品经理应具备的核心特质 · 逻辑能力：拆解复杂需求、梳理业务流程的基础； · 沟通能力：协调多方诉求、推动项目落地的关键； · 书面表达与数据敏感度：撰写PRD、分析用户行为数据的必要技能', null, null, null, null),
  ('57be7549-db74-58c7-9e51-fe33e1b2d1c9', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 7, '职业规划 关注行业认知与业务洞察的积累', null, null, null, null),
  ('c738c808-9f66-5250-b2ce-99dd4544dcb4', '49091aba-3ea4-5ec6-a483-401638573b86', null, 1, 8, '机器人产品相较传统软件产品，在能力要求上有何特殊侧重？ · 进度管控：硬件交付涉及供应链与生产周期，环环相扣，容错空间小； · 成本意识：需兼顾时间成本、硬件制造成本与研发投入； · 持续学习：硬件迭代周期长，需保持对新技术、新场景的好奇心与创新力。 没反问环节，感觉还可以', null, null, null, null),
  ('d56f6e5c-7d61-5f60-a46e-72283300d4f6', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', null, 1, 1, 'VLA 模型核心架构是什么？', null, null, null, null),
  ('ebd9a3a4-21b5-5a70-aa96-ba06e6c07b52', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', null, 1, 2, 'RT-2 怎么把连续动作变成 Action Token？', null, null, null, null),
  ('50b15f8a-3933-5933-b171-3ff728a44643', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', null, 1, 3, '7B VLA 推理只有 1～3Hz，但机器人底层控制要 50～200Hz，怎么解决？', null, null, null, null),
  ('6ab78293-ba50-5bda-8ac6-4b79048dbee7', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', null, 1, 4, '如果基于 7B VLM 做机器人持续预训练，数据集怎么搭？', null, '要能讲出： 快慢脑分层 蒸馏和量化 Waypoint + 插值 不同方案的 Trade-off', null, null),
  ('4f4db429-5fb1-5927-b988-bf4577072a80', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', null, 1, 5, '互联网数据、仿真数据、真机数据分别放多少？', null, null, null, null),
  ('0a45e40c-5d05-5f25-987c-acc2ec4c1169', 'eb4b9229-dc4f-5976-abfd-e5657dd0d16d', null, 1, 6, '训练前中后期，比例为什么还要动态变化？', null, null, null, null),
  ('a06bb2ee-94bc-512c-b8b3-4a65fd7a3e1d', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 1, '- RAG 中，什么场景下会同时使用向量数据库和关系型数据库？', null, null, null, null),
  ('ddc25fcf-9263-56cf-a730-59e4b0db792c', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 2, '- RAG 检索中，如何实现向量检索和关键词检索的混合召回？', null, null, null, null),
  ('81851886-b5a7-51da-b175-7cc4e30fe4a3', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 3, '- 为什么向量数据库不用 B-Tree 作为高维向量索引？', null, null, null, null),
  ('c481ce5f-7f27-5345-b53a-1bb1fa16a8f6', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 4, '- ANN 检索中，HNSW 和 IVF 索引有什么区别？', null, null, null, null),
  ('04a1b6d0-80b1-5703-ab73-60c26530211d', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 5, '- RAG 中，文档 Chunking 策略如何选择？', null, null, null, null),
  ('8614a18e-220e-5758-a4d9-e43805312258', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 6, '- RAG 检索链路中，Embedding 和 Rerank 模型分别负责什么？', null, null, null, null),
  ('65b28a8c-444a-5694-a06c-ade90463310d', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 7, '- RAG 中，如何优化过短或语义模糊的 Query 检索效果？', null, null, null, null),
  ('4e88fc33-4ef3-5b2a-9122-3a65d2ce6080', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 8, '- 知识频繁更新时，RAG 如何保证知识时效性？', null, null, null, null),
  ('43d82789-9f2d-5211-8cc0-3b9d4f096d88', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 9, '- 大模型应用中，哪些问题更适合通过微调解决，而不是优化 RAG？', null, null, null, null),
  ('82a7f5f3-89f4-580f-a2e0-b9b5cac2c6f9', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 10, '- 模型微调后，如何评估是否真正提升了业务效果？', null, null, null, null),
  ('45085d65-e626-5ce3-848c-b4d1c1df0bcd', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 11, '- 同时使用 RAG 和微调后效果仍不好，应该优先排查哪些环节？', null, null, null, null),
  ('1c0b28e3-634a-5d5f-9e6b-e190b80d751c', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 12, '- Agent 推理过程中，ReAct 和 CoT 有什么区别？', null, null, null, null),
  ('5f7e809b-0159-5c9b-ada5-2f6823993dc5', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 13, '- Agent 调用工具失败时，重试策略如何设计？', null, null, null, null),
  ('8c1ffafc-8a7b-5d53-9463-20c7dd42039d', 'bdf6d781-4dc0-5009-80e5-71fb7ebfe118', null, 1, 14, '- Agent 调用工具时，如何区分可重试错误和不可重试错误？', null, null, null, null),
  ('b5f06857-e3d2-5b94-9bc5-7a5d10a40338', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 1, '自我介绍', null, null, null, null),
  ('ea250d91-cef8-526d-bfd5-e0a41c57ac4d', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 2, '对岗位JD的匹配度的认知', null, null, null, null),
  ('deed3029-299e-5f73-97c6-f6f723a7e1b8', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 3, '介绍项目1框架', null, null, null, null),
  ('a7ace29e-95f0-5919-9409-94d874c3026b', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 4, '传感器的采集原理', null, null, null, null),
  ('0bf0e367-4276-5d77-97e0-0fb1df16b22b', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 5, '采集芯片的工作原理', null, null, null, null),
  ('d24e955f-4db3-5790-94f8-8a9f9a4ebfbd', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 6, '为什么电压会影响电容容值的大小', null, null, null, null),
  ('6e75ec6c-3319-5e70-9a96-492ee36e41d1', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 7, '项目中的亮点', null, null, null, null),
  ('73817e48-6ad8-5200-b437-5cbd50a9b5c3', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 8, '项目2的整体架构', null, null, null, null),
  ('eae0df7b-8f63-5a3d-b946-4a1fe41d0d59', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 9, '项目3的传感原理', null, null, null, null),
  ('db6414b2-8886-5de5-b871-a58c56b17a98', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 10, '项目中电路设计考虑因素有哪些', null, null, null, null),
  ('e822a46d-f928-5fae-8dcc-d038223ee885', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 11, '和项目1的区别', null, null, null, null),
  ('ba8546cd-5ad3-5237-8aba-fc9a51b6c2bb', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 12, 'STM32外围电路', null, null, null, null),
  ('8ae79b58-eedf-58c8-840f-c29740864156', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 13, 'mode0-3四种通信模式的区别', null, null, null, null),
  ('694b6086-1379-59ce-beff-9af6525cb244', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 14, '晶振电路中电容电阻的选取', null, null, null, null),
  ('9be1af75-21a8-56b6-9ea2-c34a8d2bf2e7', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 15, '晶振的布局', null, null, null, null),
  ('38ab699a-7cb3-59ad-ada2-fe61754a4643', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 16, '电容的等效阻抗模型', null, null, null, null),
  ('d9fccfc5-c44e-5109-8485-9405c3f25387', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 17, '容性感性的趋势变化', null, null, null, null),
  ('24c7dcbe-fa3a-533a-a8d9-70f3a49eb7f4', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 18, '随电容容值增大谐振频率变化趋势', null, null, null, null),
  ('4dc51c6d-2371-51b0-9ec5-49a38fef8826', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 19, '一个10微法的电容能否用五个2微法的电容并联代替', null, null, null, null),
  ('1ee021ed-bf7e-53ce-ac28-2d4563e28fed', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 20, '滤波电容的放置', null, null, null, null),
  ('82616771-a1e6-5c0f-b821-aae008ddba52', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 21, 'SPI通信速率', null, null, null, null),
  ('ce3b4ef4-4366-5049-b83e-4da7b7bbd8b6', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 22, '奈奎斯特采样定律', null, null, null, null),
  ('8531374d-28e9-5b29-af14-e32b660bb4fa', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 23, '对于人形机器人的了解', null, null, null, null),
  ('7b550ba1-afda-58b3-8296-bda62d5f493e', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 24, '灵巧手的了解', null, null, null, null),
  ('18b144f2-59a1-5c17-ad46-bb0960ffaeb8', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 25, '未来的就业方向', null, null, null, null),
  ('c8789772-5602-52d4-b426-48a7d5ca9ed3', '74df3731-ee74-50bc-85e9-9089b588df65', null, 1, 26, '你所希望的一个培养学习模式如何', null, null, null, null)
;

-- link interview questions to their round
update public.interview_questions iq
set round_id = r.id
from public.interview_rounds r
where r.interview_id = iq.interview_id and r.round_number = coalesce(iq.round_number, 1);

-- interview tags
insert into public.interview_tags (interview_id, tag) values
  ('b29c8b43-69e3-5bb2-a14a-b415cd5932e3', '小红书面经'),
  ('b29c8b43-69e3-5bb2-a14a-b415cd5932e3', '2026'),
  ('e0167402-ecc3-5d5c-89ad-935fe82bbcc1', '小红书面经'),
  ('e0167402-ecc3-5d5c-89ad-935fe82bbcc1', '2026'),
  ('1ac2118a-1561-5178-8f88-45b85c84f456', '小红书面经'),
  ('1ac2118a-1561-5178-8f88-45b85c84f456', '2026'),
  ('cc1a2e8d-a1bc-579d-a075-a2f2761f733e', '小红书面经'),
  ('cc1a2e8d-a1bc-579d-a075-a2f2761f733e', '2026'),
  ('ac7c0878-6d51-55cd-966d-cee3f35e1e4c', '小红书面经'),
  ('ac7c0878-6d51-55cd-966d-cee3f35e1e4c', '2026'),
  ('8fd78f7c-d912-5ccb-a8b7-d8735788d8fa', '小红书面经'),
  ('8fd78f7c-d912-5ccb-a8b7-d8735788d8fa', '2026'),
  ('1cf45c94-12e5-5199-b125-6dd324ca085f', '小红书面经'),
  ('1cf45c94-12e5-5199-b125-6dd324ca085f', '2026'),
  ('ebb98a2e-6e64-5379-bbd9-21c40c435916', '小红书面经'),
  ('ebb98a2e-6e64-5379-bbd9-21c40c435916', '2026'),
  ('14407c87-1eb5-513f-a42b-7206d5527672', '小红书面经'),
  ('14407c87-1eb5-513f-a42b-7206d5527672', '2026'),
  ('7c83531b-64f7-5996-8a2f-88e5e8d714d7', '小红书面经'),
  ('7c83531b-64f7-5996-8a2f-88e5e8d714d7', '2026'),
  ('131c9e20-b988-5dad-a92e-bfa398991a82', '小红书面经'),
  ('131c9e20-b988-5dad-a92e-bfa398991a82', '2026'),
  ('7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', '小红书面经'),
  ('7e305e9f-dd83-5e04-b0fc-5c6a1d4495e5', '2026'),
  ('698d0993-d8c2-576b-940b-5f07f4e1a1a0', '小红书面经'),
  ('698d0993-d8c2-576b-940b-5f07f4e1a1a0', '2026'),
  ('92d55798-5fd0-5a58-8a3d-6e8d070128b5', '小红书面经'),
  ('92d55798-5fd0-5a58-8a3d-6e8d070128b5', '2026'),
  ('73c830ed-cba2-55a8-92c2-40d0a6351619', '小红书面经'),
  ('73c830ed-cba2-55a8-92c2-40d0a6351619', '2026'),
  ('371f89d5-22a5-5d82-9907-f60f39448388', '小红书面经'),
  ('371f89d5-22a5-5d82-9907-f60f39448388', '2026'),
  ('3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', '小红书面经'),
  ('3e1cf0e7-7fdd-50f2-bd7d-49b9a5bef0c5', '2026'),
  ('ffb51324-adde-5bed-b17f-938ef56df3ca', '小红书面经'),
  ('ffb51324-adde-5bed-b17f-938ef56df3ca', '2026'),
  ('075552a1-508b-5417-a7c7-c139d328a5a6', '小红书面经'),
  ('075552a1-508b-5417-a7c7-c139d328a5a6', '2026'),
  ('9668bb19-fe22-500e-b57e-4640b54b5d55', '小红书面经'),
  ('9668bb19-fe22-500e-b57e-4640b54b5d55', '2026'),
  ('c735ad49-26b9-5253-b1ab-6d4dbef3ad5c', '小红书面经'),
  ('c735ad49-26b9-5253-b1ab-6d4dbef3ad5c', '2026'),
  ('0eb7c091-2576-5377-b5fa-05f1e22ac101', '小红书面经'),
  ('0eb7c091-2576-5377-b5fa-05f1e22ac101', '2026'),
  ('0883be4f-2c16-51d1-9a56-4649459d2baf', '小红书面经'),
  ('0883be4f-2c16-51d1-9a56-4649459d2baf', '2026'),
  ('8b3066a2-755d-5bc6-87ab-bfe66829323e', '小红书面经'),
  ('8b3066a2-755d-5bc6-87ab-bfe66829323e', '2026'),
  ('d717e931-3a92-56b6-9aef-a303a6813235', '小红书面经'),
  ('d717e931-3a92-56b6-9aef-a303a6813235', '2026'),
  ('c3c05533-b404-549b-8e07-1f1ac366419d', '小红书面经'),
  ('c3c05533-b404-549b-8e07-1f1ac366419d', '2026'),
  ('9c237907-490e-55ba-82b0-427c6122ca2c', '小红书面经'),
  ('9c237907-490e-55ba-82b0-427c6122ca2c', '2026'),
  ('d77ac39b-994f-5087-80a0-a633ffdf87bc', '小红书面经'),
  ('d77ac39b-994f-5087-80a0-a633ffdf87bc', '2026'),
  ('1d6bb797-8565-58c2-a209-46f3b978fa29', '小红书面经'),
  ('1d6bb797-8565-58c2-a209-46f3b978fa29', '2026'),
  ('6827cecb-a83b-5518-a063-916ca69ad7cb', '小红书面经'),
  ('6827cecb-a83b-5518-a063-916ca69ad7cb', '2026'),
  ('d04d51ea-12e2-59b3-ab30-e7f0784bd80d', '小红书面经'),
  ('d04d51ea-12e2-59b3-ab30-e7f0784bd80d', '2026'),
  ('6c9c21dd-a683-553e-b5e1-67d870e48f1a', '小红书面经'),
  ('6c9c21dd-a683-553e-b5e1-67d870e48f1a', '2026'),
  ('c0951177-c779-585f-ac70-1807855e40cb', '小红书面经'),
  ('c0951177-c779-585f-ac70-1807855e40cb', '2026'),
  ('fa7d4b98-0a02-51c9-b809-159572a91155', '小红书面经'),
  ('fa7d4b98-0a02-51c9-b809-159572a91155', '2026'),
  ('25d3adba-d597-5453-a23b-463c8af9f356', '小红书面经'),
  ('25d3adba-d597-5453-a23b-463c8af9f356', '2026'),
  ('4618d4f8-da36-50ef-bfec-f63688032da9', '小红书面经'),
  ('4618d4f8-da36-50ef-bfec-f63688032da9', '2026'),
  ('91c389f6-a6c0-51ad-b604-3df5a7707765', '小红书面经'),
  ('91c389f6-a6c0-51ad-b604-3df5a7707765', '2026'),
  ('824207f1-1767-5157-8873-ad3008e26dd7', '小红书面经'),
  ('824207f1-1767-5157-8873-ad3008e26dd7', '2026'),
  ('8c99d336-61ec-57f5-ad2a-7efed439c968', '小红书面经'),
  ('8c99d336-61ec-57f5-ad2a-7efed439c968', '2026'),
  ('3e40b227-ea8e-591c-8417-f0b9e91bd844', '小红书面经'),
  ('3e40b227-ea8e-591c-8417-f0b9e91bd844', '2026'),
  ('1bee6efc-9dd9-5072-9d8c-532e504cc38b', '小红书面经'),
  ('1bee6efc-9dd9-5072-9d8c-532e504cc38b', '2026'),
  ('eaceb563-c968-550c-847b-8374ce47712c', '小红书面经'),
  ('eaceb563-c968-550c-847b-8374ce47712c', '2026'),
  ('90ace5de-674d-52ad-b2d6-db177ed35cb2', '小红书面经'),
  ('90ace5de-674d-52ad-b2d6-db177ed35cb2', '2026'),
  ('d9089ca5-3e5f-52a7-8dc3-8590dc24dd2d', '小红书面经'),
  ('d9089ca5-3e5f-52a7-8dc3-8590dc24dd2d', '2026'),
  ('f11aa476-8ca6-52b2-b295-d7d12f631f79', '小红书面经'),
  ('f11aa476-8ca6-52b2-b295-d7d12f631f79', '2026'),
  ('6889ae7c-74df-5587-9ae5-512bec4052c4', '小红书面经'),
  ('6889ae7c-74df-5587-9ae5-512bec4052c4', '2026'),
  ('d655261f-7518-5906-96ef-83d6417ad4af', '小红书面经'),
  ('d655261f-7518-5906-96ef-83d6417ad4af', '2026'),
  ('2ac847df-522b-52b0-abc9-a166a8f56ea7', '小红书面经'),
  ('2ac847df-522b-52b0-abc9-a166a8f56ea7', '2026'),
  ('e57b850d-c3f9-520f-bc58-31010c516d2c', '小红书面经'),
  ('e57b850d-c3f9-520f-bc58-31010c516d2c', '2026'),
  ('f5c3ed62-8af4-5aca-b627-9186184673cd', '小红书面经'),
  ('f5c3ed62-8af4-5aca-b627-9186184673cd', '2026'),
  ('cfa77083-517a-5a6c-94c3-2335ea6f3e5f', '小红书面经'),
  ('cfa77083-517a-5a6c-94c3-2335ea6f3e5f', '2026'),
  ('550e5494-48fd-527a-8a11-13b599fe1d22', '小红书面经'),
  ('550e5494-48fd-527a-8a11-13b599fe1d22', '2026'),
  ('d390d465-c196-59e2-8c9e-5f46af66170c', '小红书面经'),
  ('d390d465-c196-59e2-8c9e-5f46af66170c', '2026'),
  ('0a90f6d0-7a7d-54ad-8b3a-f5797501aec0', '小红书面经'),
  ('0a90f6d0-7a7d-54ad-8b3a-f5797501aec0', '2026'),
  ('05f4993c-9ce2-58de-971a-e06c2562db81', '小红书面经'),
  ('05f4993c-9ce2-58de-971a-e06c2562db81', '2026'),
  ('fff28b53-d4df-5cd0-a614-66c9eba7f30b', '小红书面经'),
  ('fff28b53-d4df-5cd0-a614-66c9eba7f30b', '2026'),
  ('42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', '小红书面经'),
  ('42eaa017-d0a2-5d28-83e0-75a6bfb1cbf5', '2026'),
  ('eaceff89-c4fc-5dd8-ae14-8f5709abbb26', '小红书面经'),
  ('eaceff89-c4fc-5dd8-ae14-8f5709abbb26', '2026'),
  ('3275ba43-b955-596e-ad7b-b802b45ac27b', '小红书面经'),
  ('3275ba43-b955-596e-ad7b-b802b45ac27b', '2026'),
  ('eea26463-6fb1-58d7-9c9f-260fd0c93e25', '小红书面经'),
  ('eea26463-6fb1-58d7-9c9f-260fd0c93e25', '2026'),
  ('658ec94e-1d30-5e59-bdde-b2c1127aa9e2', '小红书面经'),
  ('658ec94e-1d30-5e59-bdde-b2c1127aa9e2', '2026'),
  ('490d1a62-e383-500a-a16d-a66bda1db203', '小红书面经'),
  ('490d1a62-e383-500a-a16d-a66bda1db203', '2026'),
  ('c2129627-f7f5-5ce2-801a-df9df27fae14', '小红书面经'),
  ('c2129627-f7f5-5ce2-801a-df9df27fae14', '2026'),
  ('d3dd3fab-a63a-5bea-a4f4-c94ccec77822', '小红书面经'),
  ('d3dd3fab-a63a-5bea-a4f4-c94ccec77822', '2026'),
  ('233cf00f-fb03-52c7-a04f-8018f4b61457', '小红书面经'),
  ('233cf00f-fb03-52c7-a04f-8018f4b61457', '2026'),
  ('f504b07b-5969-55f0-890f-1e8014865c21', '小红书面经'),
  ('f504b07b-5969-55f0-890f-1e8014865c21', '2026'),
  ('c3961087-9bca-51df-9f40-f2bb439d5c2c', '小红书面经'),
  ('c3961087-9bca-51df-9f40-f2bb439d5c2c', '2026'),
  ('fa6e0570-b586-562f-8303-5dea7f587570', '小红书面经'),
  ('fa6e0570-b586-562f-8303-5dea7f587570', '2026'),
  ('9bffbb56-e631-5b9c-8fd0-f7503521eef8', '小红书面经'),
  ('9bffbb56-e631-5b9c-8fd0-f7503521eef8', '2026'),
  ('4141c408-7e16-5b93-9b80-a1b995cc70ec', '小红书面经'),
  ('4141c408-7e16-5b93-9b80-a1b995cc70ec', '2026'),
  ('49091aba-3ea4-5ec6-a483-401638573b86', '小红书面经'),
  ('49091aba-3ea4-5ec6-a483-401638573b86', '2026'),
  ('eb4b9229-dc4f-5976-abfd-e5657dd0d16d', '小红书面经'),
  ('eb4b9229-dc4f-5976-abfd-e5657dd0d16d', '2026'),
  ('bdf6d781-4dc0-5009-80e5-71fb7ebfe118', '小红书面经'),
  ('bdf6d781-4dc0-5009-80e5-71fb7ebfe118', '2026'),
  ('74df3731-ee74-50bc-85e9-9089b588df65', '小红书面经'),
  ('74df3731-ee74-50bc-85e9-9089b588df65', '2026')
;
-- <<< END generated interview posts

-- ---------------------------------------------------------------------------
-- coding problems (20 Python-first exercises)
-- ---------------------------------------------------------------------------

insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured
) values
  (
    'b1000000-0000-4000-8000-000000000001', 'Implement Stable Softmax', 'implement-stable-softmax',
    'easy', 'transformer',
    'Compute a numerically stable softmax for a list of logits. Subtract the largest logit before exponentiating, then return probabilities rounded to six decimal places.', '1 <= len(logits) <= 128
Input and output are JSON.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    logits = data["logits"]
    pivot = max(logits)
    values = [math.exp(value - pivot) for value in logits]
    total = sum(values)
    return [round(value / total, 6) for value in values]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, true
  ),
  (
    'b1000000-0000-4000-8000-000000000002', 'Implement Layer Normalization', 'implement-layer-normalization',
    'medium', 'transformer',
    'Normalize one feature vector with population variance. Use the supplied epsilon inside the square root and round each normalized value to six decimal places.', '1 <= len(values) <= 256
Input contains values and eps as JSON.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    values = data["values"]
    mean = sum(values) / len(values)
    variance = sum((value - mean) ** 2 for value in values) / len(values)
    scale = math.sqrt(variance + data["eps"])
    return [round((value - mean) / scale, 6) for value in values]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, true
  ),
  (
    'b1000000-0000-4000-8000-000000000003', 'Scaled Dot-Product Attention', 'scaled-dot-product-attention',
    'medium', 'transformer',
    'Implement one query of scaled dot-product attention. Apply softmax to query-key scores and return the weighted value vector rounded to four decimal places.', 'Keys have the same dimension as query.
Input and output are JSON.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    query, keys, values = data["query"], data["keys"], data["values"]
    scale = math.sqrt(len(query))
    scores = [sum(a * b for a, b in zip(query, key)) / scale for key in keys]
    pivot = max(scores)
    weights = [math.exp(score - pivot) for score in scores]
    total = sum(weights)
    weights = [weight / total for weight in weights]
    return [round(sum(weight * value[j] for weight, value in zip(weights, values)), 4) for j in range(len(values[0]))]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, true
  ),
  (
    'b1000000-0000-4000-8000-000000000004', 'Average Multi-Head Attention', 'average-multi-head-attention',
    'hard', 'transformer',
    'Each attention head independently pools its value vectors for the same query. Compute scaled attention in every head and average the head outputs.', 'Every head has the same value dimension.
Round the averaged vector to four decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    query, outputs = data["query"], []
    for head in data["heads"]:
        scale = math.sqrt(len(query))
        scores = [sum(a * b for a, b in zip(query, key)) / scale for key in head["keys"]]
        pivot = max(scores)
        weights = [math.exp(score - pivot) for score in scores]
        total = sum(weights)
        weights = [weight / total for weight in weights]
        outputs.append([sum(weight * value[j] for weight, value in zip(weights, head["values"])) for j in range(len(head["values"][0]))])
    return [round(sum(output[j] for output in outputs) / len(outputs), 4) for j in range(len(outputs[0]))]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, true
  ),
  (
    'b1000000-0000-4000-8000-000000000005', 'Build a Causal Attention Mask', 'build-causal-attention-mask',
    'easy', 'transformer',
    'Turn each row of attention scores into a causal softmax: position i may attend only to positions at most i. Future positions must receive probability zero.', 'The score matrix is square and has at most 64 rows.
Round probabilities to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    result = []
    for index, row in enumerate(data["scores"]):
        visible = row[:index + 1]
        pivot = max(visible)
        weights = [math.exp(value - pivot) for value in visible]
        total = sum(weights)
        result.append([round(value / total, 6) for value in weights] + [0.0] * (len(row) - len(visible)))
    return result

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000006', 'Compute Discounted Returns', 'compute-discounted-returns',
    'easy', 'rl',
    'Given a reward sequence and discount factor, compute the return at every timestep by accumulating rewards backwards.', '0 <= gamma <= 1
Return one value per reward, rounded to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    running, returns = 0.0, []
    for reward in reversed(data["rewards"]):
        running = reward + data["gamma"] * running
        returns.append(round(running, 6))
    return list(reversed(returns))

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000007', 'Generalized Advantage Estimation', 'generalized-advantage-estimation',
    'medium', 'rl',
    'Compute GAE advantages from rewards and one extra bootstrap value. Walk backwards using gamma and lambda, then round to six decimal places.', 'len(values) = len(rewards) + 1
0 <= gamma, lambda <= 1.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    rewards, values = data["rewards"], data["values"]
    running, advantages = 0.0, [0.0] * len(rewards)
    for index in range(len(rewards) - 1, -1, -1):
        delta = rewards[index] + data["gamma"] * values[index + 1] - values[index]
        running = delta + data["gamma"] * data["lambda"] * running
        advantages[index] = round(running, 6)
    return advantages

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000008', 'PPO Clipped Objective', 'ppo-clipped-objective',
    'hard', 'rl',
    'For each action compute the PPO clipped surrogate term and return the mean. Clip ratios to one plus or minus epsilon before multiplying by the advantage.', 'Ratios and advantages have equal non-zero length.
Return the scalar rounded to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    epsilon, terms = data["epsilon"], []
    for ratio, advantage in zip(data["ratios"], data["advantages"]):
        clipped = max(1 - epsilon, min(1 + epsilon, ratio))
        terms.append(min(ratio * advantage, clipped * advantage))
    return round(sum(terms) / len(terms), 6)

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000009', 'Group-Relative Advantage', 'group-relative-advantage',
    'hard', 'rl',
    'Standardize rewards sampled for one prompt. Subtract the group mean and divide by the population standard deviation; degenerate groups return zeros.', '1 <= len(rewards) <= 128
Round each advantage to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    rewards = data["rewards"]
    mean = sum(rewards) / len(rewards)
    deviation = math.sqrt(sum((reward - mean) ** 2 for reward in rewards) / len(rewards))
    if deviation == 0:
        return [0.0] * len(rewards)
    return [round((reward - mean) / deviation, 6) for reward in rewards]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000010', 'Euler Angles to Quaternion', 'euler-angles-to-quaternion',
    'medium', 'robotics',
    'Convert roll, pitch, and yaw in radians into an xyzw unit quaternion. Return components rounded to six decimal places.', 'Angles are in radians.
Use the roll-pitch-yaw convention and return [x, y, z, w].',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    roll, pitch, yaw = data["rpy"]
    cr, sr = math.cos(roll / 2), math.sin(roll / 2)
    cp, sp = math.cos(pitch / 2), math.sin(pitch / 2)
    cy, sy = math.cos(yaw / 2), math.sin(yaw / 2)
    return [round(sr * cp * cy - cr * sp * sy, 6), round(cr * sp * cy + sr * cp * sy, 6), round(cr * cp * sy - sr * sp * cy, 6), round(cr * cp * cy + sr * sp * sy, 6)]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000011', 'Multiply Unit Quaternions', 'multiply-unit-quaternions',
    'medium', 'robotics',
    'Compose two xyzw unit quaternions using the Hamilton product and return the result in xyzw order.', 'Inputs are unit quaternions in [x, y, z, w] order.
Round components to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    x1, y1, z1, w1 = data["q1"]
    x2, y2, z2, w2 = data["q2"]
    return [round(w1*x2 + x1*w2 + y1*z2 - z1*y2, 6), round(w1*y2 - x1*z2 + y1*w2 + z1*x2, 6), round(w1*z2 + x1*y2 - y1*x2 + z1*w2, 6), round(w1*w2 - x1*x2 - y1*y2 - z1*z2, 6)]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000012', 'Spherical Quaternion Interpolation', 'spherical-quaternion-interpolation',
    'hard', 'robotics',
    'Interpolate between two unit quaternions on the shortest spherical path. Use linear interpolation only for nearly parallel inputs and round the result.', 'Quaternions are unit length and use xyzw order.
0 <= t <= 1.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    first, second, t = data["q1"], data["q2"], data["t"]
    dot = sum(a * b for a, b in zip(first, second))
    if dot < 0:
        second, dot = [-value for value in second], -dot
    if dot > 0.9995:
        result = [a + t * (b - a) for a, b in zip(first, second)]
    else:
        angle = math.acos(dot)
        sine = math.sin(angle)
        left, right = math.sin((1 - t) * angle) / sine, math.sin(t * angle) / sine
        result = [left * a + right * b for a, b in zip(first, second)]
    norm = math.sqrt(sum(value * value for value in result))
    return [round(value / norm, 6) for value in result]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000013', 'Transform a Point with SE(3)', 'transform-point-with-se3',
    'medium', 'robotics',
    'Apply a rigid transform to one 3D point. Multiply the rotation matrix first, then add the translation vector.', 'Rotation is 3x3; translation and point are length-three vectors.
Round coordinates to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    rotation, translation, point = data["rotation"], data["translation"], data["point"]
    return [round(sum(rotation[row][column] * point[column] for column in range(3)) + translation[row], 6) for row in range(3)]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000014', 'DDPM Forward Noise Step', 'ddpm-forward-noise-step',
    'hard', 'diffusion',
    'Apply one forward diffusion step x_t = sqrt(alpha_bar) x_0 + sqrt(1 - alpha_bar) epsilon to every coordinate.', '0 <= alpha_bar <= 1
x0 and noise have equal length.
Round coordinates to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json, math

def solve(data):
    alpha = data["alpha_bar"]
    return [round(math.sqrt(alpha) * clean + math.sqrt(1 - alpha) * noise, 6) for clean, noise in zip(data["x0"], data["noise"])]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000015', 'Linear Noise Schedule', 'linear-noise-schedule',
    'easy', 'diffusion',
    'Generate an inclusive linear beta schedule from beta_start to beta_end with the requested number of diffusion steps.', 'steps is positive.
For one step return beta_start; otherwise include both endpoints.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    start, end, steps = data["beta_start"], data["beta_end"], data["steps"]
    if steps == 1:
        return [round(start, 6)]
    return [round(start + (end - start) * index / (steps - 1), 6) for index in range(steps)]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000016', 'Flow-Matching Vector Field', 'flow-matching-vector-field',
    'easy', 'diffusion',
    'For a straight interpolation path from x0 to x1, compute the constant flow-matching target vector x1 - x0.', 'x0 and x1 have equal length.
Round each component to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    return [round(end - start, 6) for start, end in zip(data["x0"], data["x1"])]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000017', 'Replay Buffer Retention', 'replay-buffer-retention',
    'easy', 'robot_learning',
    'Simulate a FIFO replay buffer after inserting all items, then read valid sample indices from the retained buffer.', 'capacity is positive.
Ignore sample indices outside the retained buffer.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    buffer = data["items"][-data["capacity"]:]
    return [buffer[index] for index in data["sample_indices"] if 0 <= index < len(buffer)]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000018', 'Blend Overlapping Action Chunks', 'blend-overlapping-action-chunks',
    'medium', 'robot_learning',
    'Blend action chunks with scalar confidence weights. Every chunk has the same shape; compute a weighted average for each timestep and action dimension.', 'All chunks have equal shape and weights are positive.
Round every action to six decimal places.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    chunks, weights = data["chunks"], data["weights"]
    total = sum(weights)
    return [[round(sum(weight * chunk[t][d] for weight, chunk in zip(weights, chunks)) / total, 6) for d in range(len(chunks[0][0]))] for t in range(len(chunks[0]))]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000019', 'Create Sliding Windows', 'create-sliding-windows',
    'easy', 'algorithms',
    'Split a sequence into full sliding windows using a window size and stride. Discard any incomplete window at the end.', 'window and stride are positive.
Return only windows with exactly window elements.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    sequence, window, stride = data["sequence"], data["window"], data["stride"]
    return [sequence[start:start + window] for start in range(0, len(sequence) - window + 1, stride)]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  ),
  (
    'b1000000-0000-4000-8000-000000000020', 'Top-K Token Frequencies', 'top-k-token-frequencies',
    'easy', 'algorithms',
    'Count tokens and return the k most frequent as [token, count] pairs. Break ties lexicographically for deterministic evaluation.', '1 <= k <= number of distinct tokens.
Tokens are strings.',
    $code$
import json

def solve(data):
    # TODO: implement the solution
    raise NotImplementedError

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, $code$
import json

def solve(data):
    counts = {}
    for token in data["tokens"]:
        counts[token] = counts.get(token, 0) + 1
    ordered = sorted(counts.items(), key=lambda item: (-item[1], item[0]))
    return [[token, count] for token, count in ordered[:data["k"]]]

data = json.loads(input())
print(json.dumps(solve(data), separators=(",", ":")))
$code$, 'solve',
    'python', 3000, 256, 'trimmed', 0.000001, true, false
  );

insert into public.coding_test_cases (
  id, problem_id, name, input_data, expected_output, is_hidden, weight, order_index
) values
  (
    'b2000000-0000-4000-8000-000000000001', 'b1000000-0000-4000-8000-000000000001', 'Two equal logits',
    $data${"logits":[0,0]}$data$, $data$[0.5,0.5]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000002', 'b1000000-0000-4000-8000-000000000001', 'Three logits',
    $data${"logits":[1,2,3]}$data$, $data$[0.090031,0.244728,0.665241]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000003', 'b1000000-0000-4000-8000-000000000001', 'Large spread',
    $data${"logits":[2,0,-2]}$data$, $data$[0.866813,0.11731,0.015876]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000004', 'b1000000-0000-4000-8000-000000000002', 'Three features',
    $data${"values":[1,2,3],"eps":0}$data$, $data$[-1.224745,0.0,1.224745]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000005', 'b1000000-0000-4000-8000-000000000002', 'Constant vector',
    $data${"values":[5,5,5],"eps":0.000001}$data$, $data$[0.0,0.0,0.0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000006', 'b1000000-0000-4000-8000-000000000002', 'Two features',
    $data${"values":[-1,1],"eps":0}$data$, $data$[-1.0,1.0]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000007', 'b1000000-0000-4000-8000-000000000003', 'Equal scores',
    $data${"query":[1,0],"keys":[[1,0],[1,0]],"values":[[10,0],[0,20]]}$data$, $data$[5.0,10.0]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000008', 'b1000000-0000-4000-8000-000000000003', 'Different scores',
    $data${"query":[1,0],"keys":[[1,0],[0,1]],"values":[[10,0],[0,20]]}$data$, $data$[6.6976,6.6048]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000009', 'b1000000-0000-4000-8000-000000000003', 'Swapped query',
    $data${"query":[0,1],"keys":[[1,0],[0,1]],"values":[[10,0],[0,20]]}$data$, $data$[3.3024,13.3952]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000010', 'b1000000-0000-4000-8000-000000000004', 'Two heads',
    $data${"query":[1,0],"heads":[{"keys":[[1,0],[1,0]],"values":[[1,0],[0,1]]},{"keys":[[1,0],[1,0]],"values":[[2,0],[0,2]]}]}$data$, $data$[0.75,0.75]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000011', 'b1000000-0000-4000-8000-000000000004', 'Focused heads',
    $data${"query":[1,0],"heads":[{"keys":[[1,0],[1,0]],"values":[[4,0],[0,2]]},{"keys":[[1,0],[1,0]],"values":[[0,4],[2,0]]}]}$data$, $data$[1.5,1.5]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000012', 'b1000000-0000-4000-8000-000000000004', 'One head',
    $data${"query":[0,1],"heads":[{"keys":[[0,1],[0,1]],"values":[[10,0],[0,20]]}]}$data$, $data$[5.0,10.0]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000013', 'b1000000-0000-4000-8000-000000000005', 'Two positions',
    $data${"scores":[[1,0],[0,1]]}$data$, $data$[[1.0,0.0],[0.268941,0.731059]]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000014', 'b1000000-0000-4000-8000-000000000005', 'Three positions',
    $data${"scores":[[0,0,0],[0,0,0],[1,0,1]]}$data$, $data$[[1.0,0.0,0.0],[0.5,0.5,0.0],[0.422319,0.155362,0.422319]]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000015', 'b1000000-0000-4000-8000-000000000005', 'Strong first token',
    $data${"scores":[[2,0,0],[2,1,0],[2,1,0]]}$data$, $data$[[1.0,0.0,0.0],[0.731059,0.268941,0.0],[0.665241,0.244728,0.090031]]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000016', 'b1000000-0000-4000-8000-000000000006', 'Unit rewards',
    $data${"rewards":[1,1,1],"gamma":0.9}$data$, $data$[2.71,1.9,1.0]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000017', 'b1000000-0000-4000-8000-000000000006', 'No discount',
    $data${"rewards":[1,0,2],"gamma":1}$data$, $data$[3.0,2.0,2.0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000018', 'b1000000-0000-4000-8000-000000000006', 'Zero discount',
    $data${"rewards":[3,-1,5],"gamma":0}$data$, $data$[3.0,-1.0,5.0]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000019', 'b1000000-0000-4000-8000-000000000007', 'Unit bootstrap',
    $data${"rewards":[1,0,2],"values":[0,0,1,0],"gamma":1,"lambda":1}$data$, $data$[3.0,2.0,1.0]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000020', 'b1000000-0000-4000-8000-000000000007', 'Partial trace',
    $data${"rewards":[0,1],"values":[0,0,0],"gamma":0.9,"lambda":0.5}$data$, $data$[0.45,1.0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000021', 'b1000000-0000-4000-8000-000000000007', 'Terminal reward',
    $data${"rewards":[0,0,1],"values":[0,0,0,0],"gamma":1,"lambda":0.5}$data$, $data$[0.25,0.5,1.0]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000022', 'b1000000-0000-4000-8000-000000000008', 'Mixed advantages',
    $data${"ratios":[1.2,0.8,1.05],"advantages":[1,-1,2],"epsilon":0.2}$data$, $data$0.833333$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000023', 'b1000000-0000-4000-8000-000000000008', 'Both clipped',
    $data${"ratios":[0.5,1.5],"advantages":[1,-1],"epsilon":0.2}$data$, $data$-0.5$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000024', 'b1000000-0000-4000-8000-000000000008', 'No clipping',
    $data${"ratios":[1,1],"advantages":[2,-2],"epsilon":0.2}$data$, $data$0.0$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000025', 'b1000000-0000-4000-8000-000000000009', 'Three rewards',
    $data${"rewards":[1,3,2]}$data$, $data$[-1.224745,1.224745,0.0]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000026', 'b1000000-0000-4000-8000-000000000009', 'Degenerate group',
    $data${"rewards":[5,5,5]}$data$, $data$[0.0,0.0,0.0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000027', 'b1000000-0000-4000-8000-000000000009', 'Symmetric group',
    $data${"rewards":[0,2,4,2]}$data$, $data$[-1.414214,0.0,1.414214,0.0]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000028', 'b1000000-0000-4000-8000-000000000010', 'Identity',
    $data${"rpy":[0,0,0]}$data$, $data$[0.0,0.0,0.0,1.0]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000029', 'b1000000-0000-4000-8000-000000000010', 'Quarter turn yaw',
    $data${"rpy":[0,0,1.5707963267948966]}$data$, $data$[0.0,0.0,0.707107,0.707107]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000030', 'b1000000-0000-4000-8000-000000000010', 'Quarter turn roll',
    $data${"rpy":[1.5707963267948966,0,0]}$data$, $data$[0.707107,0.0,0.0,0.707107]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000031', 'b1000000-0000-4000-8000-000000000011', 'Identity composition',
    $data${"q1":[0,0,0,1],"q2":[0,0,0.707107,0.707107]}$data$, $data$[0.0,0.0,0.707107,0.707107]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000032', 'b1000000-0000-4000-8000-000000000011', 'Two quarter turns',
    $data${"q1":[0.707107,0,0,0.707107],"q2":[0,0.707107,0,0.707107]}$data$, $data$[0.5,0.5,0.5,0.5]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000033', 'b1000000-0000-4000-8000-000000000011', 'Right identity',
    $data${"q1":[0.5,0.5,0.5,0.5],"q2":[0,0,0,1]}$data$, $data$[0.5,0.5,0.5,0.5]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000034', 'b1000000-0000-4000-8000-000000000012', 'Half yaw turn',
    $data${"q1":[0,0,0,1],"q2":[0,0,0.707107,0.707107],"t":0.5}$data$, $data$[0.0,0.0,0.382683,0.92388]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000035', 'b1000000-0000-4000-8000-000000000012', 'Start point',
    $data${"q1":[0,0,0,1],"q2":[0,0,0.707107,0.707107],"t":0}$data$, $data$[0.0,0.0,0.0,1.0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000036', 'b1000000-0000-4000-8000-000000000012', 'Orthogonal rotations',
    $data${"q1":[0.707107,0,0,0.707107],"q2":[0,0.707107,0,0.707107],"t":0.5}$data$, $data$[0.408248,0.408248,0.0,0.816497]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000037', 'b1000000-0000-4000-8000-000000000013', 'Identity rotation',
    $data${"rotation":[[1,0,0],[0,1,0],[0,0,1]],"translation":[1,2,3],"point":[2,0,-1]}$data$, $data$[3,2,2]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000038', 'b1000000-0000-4000-8000-000000000013', 'Quarter turn',
    $data${"rotation":[[0,-1,0],[1,0,0],[0,0,1]],"translation":[1,0,0],"point":[1,0,0]}$data$, $data$[1,1,0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000039', 'b1000000-0000-4000-8000-000000000013', 'Translation only',
    $data${"rotation":[[1,0,0],[0,1,0],[0,0,1]],"translation":[-2,4,0.5],"point":[0.5,1,2]}$data$, $data$[-1.5,5.0,2.5]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000040', 'b1000000-0000-4000-8000-000000000014', 'Mixed signal',
    $data${"alpha_bar":0.81,"x0":[1,-1],"noise":[0,1]}$data$, $data$[0.9,-0.46411]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000041', 'b1000000-0000-4000-8000-000000000014', 'No noise',
    $data${"alpha_bar":1,"x0":[2,-3],"noise":[5,5]}$data$, $data$[2.0,-3.0]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000042', 'b1000000-0000-4000-8000-000000000014', 'Equal blend',
    $data${"alpha_bar":0.25,"x0":[2],"noise":[2]}$data$, $data$[2.732051]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000043', 'b1000000-0000-4000-8000-000000000015', 'Four steps',
    $data${"beta_start":0.1,"beta_end":0.2,"steps":4}$data$, $data$[0.1,0.133333,0.166667,0.2]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000044', 'b1000000-0000-4000-8000-000000000015', 'Single step',
    $data${"beta_start":0.01,"beta_end":0.2,"steps":1}$data$, $data$[0.01]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000045', 'b1000000-0000-4000-8000-000000000015', 'Three steps',
    $data${"beta_start":0,"beta_end":1,"steps":3}$data$, $data$[0.0,0.5,1.0]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000046', 'b1000000-0000-4000-8000-000000000016', 'Unit displacement',
    $data${"x0":[0,0],"x1":[2,4]}$data$, $data$[2,4]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000047', 'b1000000-0000-4000-8000-000000000016', 'Reverse displacement',
    $data${"x0":[3,-1],"x1":[1,2]}$data$, $data$[-2,3]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000048', 'b1000000-0000-4000-8000-000000000016', 'Fractional displacement',
    $data${"x0":[0.5,1.5],"x1":[1.25,1.75]}$data$, $data$[0.75,0.25]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000049', 'b1000000-0000-4000-8000-000000000017', 'Evict oldest item',
    $data${"capacity":3,"items":["a","b","c","d"],"sample_indices":[0,2]}$data$, $data$["b","d"]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000050', 'b1000000-0000-4000-8000-000000000017', 'Keep last two',
    $data${"capacity":2,"items":[1,2,3],"sample_indices":[0,1]}$data$, $data$[2,3]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000051', 'b1000000-0000-4000-8000-000000000017', 'Ignore invalid index',
    $data${"capacity":5,"items":["x"],"sample_indices":[0,1,-1]}$data$, $data$["x"]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000052', 'b1000000-0000-4000-8000-000000000018', 'Two predictions',
    $data${"chunks":[[[1,2]],[[3,4]]],"weights":[0.25,0.75]}$data$, $data$[[2.5,3.5]]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000053', 'b1000000-0000-4000-8000-000000000018', 'Three predictions',
    $data${"chunks":[[[0],[2],[4]],[[2],[4],[6]]],"weights":[1,1]}$data$, $data$[[1.0],[3.0],[5.0]]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000054', 'b1000000-0000-4000-8000-000000000018', 'Two timesteps',
    $data${"chunks":[[[1,0],[0,1]],[[3,2],[2,3]]],"weights":[0.5,0.5]}$data$, $data$[[2.0,1.0],[1.0,2.0]]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000055', 'b1000000-0000-4000-8000-000000000019', 'Stride two',
    $data${"sequence":[1,2,3,4,5],"window":3,"stride":2}$data$, $data$[[1,2,3],[3,4,5]]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000056', 'b1000000-0000-4000-8000-000000000019', 'Stride one',
    $data${"sequence":[1,2,3,4],"window":2,"stride":1}$data$, $data$[[1,2],[2,3],[3,4]]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000057', 'b1000000-0000-4000-8000-000000000019', 'Window too large',
    $data${"sequence":[1,2],"window":3,"stride":1}$data$, $data$[]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000058', 'b1000000-0000-4000-8000-000000000020', 'Most common tokens',
    $data${"tokens":["a","b","a","c","b","a"],"k":2}$data$, $data$[["a",3],["b",2]]$data$, false,
    1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000059', 'b1000000-0000-4000-8000-000000000020', 'Lexical tie break',
    $data${"tokens":["z","a","z","a","m"],"k":2}$data$, $data$[["a",2],["z",2]]$data$, false,
    1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000060', 'b1000000-0000-4000-8000-000000000020', 'All tokens unique',
    $data${"tokens":["c","b","a"],"k":3}$data$, $data$[["a",1],["b",1],["c",1]]$data$, true,
    1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000061',
    'b1000000-0000-4000-8000-000000000001',
    'Single logit', $data${"logits":[5]}$data$, $data$[1.0]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000062',
    'b1000000-0000-4000-8000-000000000001',
    'Negative tie', $data${"logits":[-1,-1]}$data$, $data$[0.5,0.5]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000063',
    'b1000000-0000-4000-8000-000000000002',
    'Two features', $data${"values":[0,2],"eps":0}$data$, $data$[-1.0,1.0]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000064',
    'b1000000-0000-4000-8000-000000000002',
    'Four features', $data${"values":[1,2,3,4],"eps":0}$data$, $data$[-1.341641,-0.447214,0.447214,1.341641]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000065',
    'b1000000-0000-4000-8000-000000000003',
    'Equal two-dimensional keys', $data${"query":[1,1],"keys":[[1,1],[1,1]],"values":[[1,2],[3,4]]}$data$, $data$[2.0,3.0]$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000066',
    'b1000000-0000-4000-8000-000000000003',
    'Zero query', $data${"query":[0,0],"keys":[[1,0],[0,1]],"values":[[2,4],[4,2]]}$data$, $data$[3.0,3.0]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000067',
    'b1000000-0000-4000-8000-000000000004',
    'Three equal keys', $data${"query":[1],"heads":[{"keys":[[1],[1],[1]],"values":[[1],[3],[5]]}]}$data$, $data$[3.0]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000068',
    'b1000000-0000-4000-8000-000000000004',
    'Head average', $data${"query":[1],"heads":[{"keys":[[1],[1]],"values":[[0],[2]]},{"keys":[[1],[1]],"values":[[2],[4]]}]}$data$, $data$[2.0]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000069',
    'b1000000-0000-4000-8000-000000000005',
    'One position', $data${"scores":[[-2]]}$data$, $data$[[1.0]]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000070',
    'b1000000-0000-4000-8000-000000000005',
    'Negative scores', $data${"scores":[[-1,-2],[-3,-2]]}$data$, $data$[[1.0,0.0],[0.268941,0.731059]]$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000071',
    'b1000000-0000-4000-8000-000000000006',
    'Single reward', $data${"rewards":[5],"gamma":0.5}$data$, $data$[5.0]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000072',
    'b1000000-0000-4000-8000-000000000006',
    'Negative reward', $data${"rewards":[-1,2],"gamma":0.5}$data$, $data$[0.0,2.0]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000073',
    'b1000000-0000-4000-8000-000000000007',
    'Bootstrap value', $data${"rewards":[1],"values":[0,1],"gamma":0.9,"lambda":0.9}$data$, $data$[1.9]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000074',
    'b1000000-0000-4000-8000-000000000007',
    'Two-step values', $data${"rewards":[1,2],"values":[1,1,0],"gamma":1,"lambda":0.5}$data$, $data$[1.5,1.0]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000075',
    'b1000000-0000-4000-8000-000000000008',
    'Positive clipping', $data${"ratios":[1.3],"advantages":[2],"epsilon":0.2}$data$, $data$2.4$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000076',
    'b1000000-0000-4000-8000-000000000008',
    'Negative clipping', $data${"ratios":[0.7],"advantages":[-2],"epsilon":0.1}$data$, $data$-1.8$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000077',
    'b1000000-0000-4000-8000-000000000009',
    'Two rewards', $data${"rewards":[0,1]}$data$, $data$[-1.0,1.0]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000078',
    'b1000000-0000-4000-8000-000000000009',
    'Symmetric spread', $data${"rewards":[-2,0,2]}$data$, $data$[-1.224745,0.0,1.224745]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000079',
    'b1000000-0000-4000-8000-000000000010',
    'Quarter pitch', $data${"rpy":[0,1.5707963267948966,0]}$data$, $data$[0.0,0.707107,0.0,0.707107]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000080',
    'b1000000-0000-4000-8000-000000000010',
    'Combined turns', $data${"rpy":[1.5707963267948966,1.5707963267948966,0]}$data$, $data$[0.5,0.5,-0.5,0.5]$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000081',
    'b1000000-0000-4000-8000-000000000011',
    'Two z turns', $data${"q1":[0,0,0.7071067811865476,0.7071067811865476],"q2":[0,0,0.7071067811865476,0.7071067811865476]}$data$, $data$[0.0,0.0,1.0,0.0]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000082',
    'b1000000-0000-4000-8000-000000000011',
    'Identity right', $data${"q1":[0.5,0.5,0.5,0.5],"q2":[0,0,0,1]}$data$, $data$[0.5,0.5,0.5,0.5]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000083',
    'b1000000-0000-4000-8000-000000000012',
    'Half yaw turn', $data${"q1":[0,0,0,1],"q2":[0,0,0.707107,0.707107],"t":0.5}$data$, $data$[0.0,0.0,0.382683,0.92388]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000084',
    'b1000000-0000-4000-8000-000000000012',
    'Same quaternion', $data${"q1":[0,0,0,1],"q2":[0,0,0,1],"t":0.25}$data$, $data$[0.0,0.0,0.0,1.0]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000085',
    'b1000000-0000-4000-8000-000000000013',
    'Negative point', $data${"rotation":[[1,0,0],[0,1,0],[0,0,1]],"translation":[0,0,0],"point":[-1,2,3]}$data$, $data$[-1,2,3]$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000086',
    'b1000000-0000-4000-8000-000000000013',
    'Half turn', $data${"rotation":[[-1,0,0],[0,-1,0],[0,0,1]],"translation":[0,1,0],"point":[2,1,0]}$data$, $data$[-2,0,0]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000087',
    'b1000000-0000-4000-8000-000000000014',
    'All noise', $data${"alpha_bar":0,"x0":[1,2],"noise":[3,4]}$data$, $data$[3.0,4.0]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000088',
    'b1000000-0000-4000-8000-000000000014',
    'Half noise', $data${"alpha_bar":0.5,"x0":[0,0],"noise":[1,1]}$data$, $data$[0.707107,0.707107]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000089',
    'b1000000-0000-4000-8000-000000000015',
    'Constant schedule', $data${"beta_start":0.2,"beta_end":0.2,"steps":3}$data$, $data$[0.2,0.2,0.2]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000090',
    'b1000000-0000-4000-8000-000000000015',
    'Two steps', $data${"beta_start":-0.1,"beta_end":0.1,"steps":2}$data$, $data$[-0.1,0.1]$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000091',
    'b1000000-0000-4000-8000-000000000016',
    'No movement', $data${"x0":[1,2,3],"x1":[1,2,3]}$data$, $data$[0,0,0]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000092',
    'b1000000-0000-4000-8000-000000000016',
    'Signed movement', $data${"x0":[-1,2],"x1":[0,-2]}$data$, $data$[1,-4]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000093',
    'b1000000-0000-4000-8000-000000000017',
    'Capacity one', $data${"capacity":1,"items":["a","b"],"sample_indices":[0]}$data$, $data$["b"]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000094',
    'b1000000-0000-4000-8000-000000000017',
    'Empty buffer', $data${"capacity":3,"items":[],"sample_indices":[]}$data$, $data$[]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000095',
    'b1000000-0000-4000-8000-000000000018',
    'Weighted blend', $data${"chunks":[[[0,0]],[[4,8]]],"weights":[1,3]}$data$, $data$[[3.0,6.0]]$data$, true, 1.0, 4
  ),
  (
    'b2000000-0000-4000-8000-000000000096',
    'b1000000-0000-4000-8000-000000000018',
    'Single chunk', $data${"chunks":[[[1,2],[3,4]]],"weights":[2]}$data$, $data$[[1.0,2.0],[3.0,4.0]]$data$, true, 1.0, 0
  ),
  (
    'b2000000-0000-4000-8000-000000000097',
    'b1000000-0000-4000-8000-000000000019',
    'Large stride', $data${"sequence":[0,1,2,3,4,5],"window":4,"stride":3}$data$, $data$[[0,1,2,3]]$data$, true, 1.0, 1
  ),
  (
    'b2000000-0000-4000-8000-000000000098',
    'b1000000-0000-4000-8000-000000000019',
    'Empty sequence', $data${"sequence":[],"window":1,"stride":1}$data$, $data$[]$data$, true, 1.0, 2
  ),
  (
    'b2000000-0000-4000-8000-000000000099',
    'b1000000-0000-4000-8000-000000000020',
    'Robotics token', $data${"tokens":["robot","arm","robot","arm","arm"],"k":1}$data$, $data$[["arm",3]]$data$, true, 1.0, 3
  ),
  (
    'b2000000-0000-4000-8000-000000000100',
    'b1000000-0000-4000-8000-000000000020',
    'All equal tokens', $data${"tokens":["z","y","x","z","y","x"],"k":3}$data$, $data$[["x",2],["y",2],["z",2]]$data$, true, 1.0, 4
  );

insert into public.coding_problem_topics (problem_id, topic_id, weight) values
  ('b1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000002', 1.0),
  ('b1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000002', 1.0),
  ('b1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000003', 1.0),
  ('b1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000003', 1.0),
  ('b1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000004', 1.0),
  ('b1000000-0000-4000-8000-000000000006', 'd1000000-0000-4000-8000-000000000009', 1.0),
  ('b1000000-0000-4000-8000-000000000007', 'd1000000-0000-4000-8000-000000000010', 1.0),
  ('b1000000-0000-4000-8000-000000000008', 'd1000000-0000-4000-8000-000000000010', 1.0),
  ('b1000000-0000-4000-8000-000000000009', 'd1000000-0000-4000-8000-000000000011', 1.0),
  ('b1000000-0000-4000-8000-000000000010', 'd1000000-0000-4000-8000-000000000014', 1.0),
  ('b1000000-0000-4000-8000-000000000011', 'd1000000-0000-4000-8000-000000000014', 1.0),
  ('b1000000-0000-4000-8000-000000000012', 'd1000000-0000-4000-8000-000000000014', 1.0),
  ('b1000000-0000-4000-8000-000000000013', 'd1000000-0000-4000-8000-000000000014', 1.0),
  ('b1000000-0000-4000-8000-000000000014', 'd1000000-0000-4000-8000-000000000008', 1.0),
  ('b1000000-0000-4000-8000-000000000015', 'd1000000-0000-4000-8000-000000000008', 1.0),
  ('b1000000-0000-4000-8000-000000000016', 'd1000000-0000-4000-8000-000000000008', 1.0),
  ('b1000000-0000-4000-8000-000000000017', 'd1000000-0000-4000-8000-000000000013', 1.0),
  ('b1000000-0000-4000-8000-000000000018', 'd1000000-0000-4000-8000-000000000001', 1.0),
  ('b1000000-0000-4000-8000-000000000019', 'd1000000-0000-4000-8000-000000000005', 1.0),
  ('b1000000-0000-4000-8000-000000000020', 'd1000000-0000-4000-8000-000000000012', 1.0);

-- Link representative interview prompts to hands-on exercises.
update public.interview_questions iq
set coding_problem_id = p.id
from public.coding_problems p
where p.slug = case iq.question_id
  when 'f1000000-0000-4000-8000-000000000001' then 'scaled-dot-product-attention'
  when 'f1000000-0000-4000-8000-000000000005' then 'blend-overlapping-action-chunks'
  when 'f1000000-0000-4000-8000-000000000009' then 'transform-point-with-se3'
  else null
end;

 -- ---------------------------------------------------------------------------
-- question_topics
-- ---------------------------------------------------------------------------

insert into public.question_topics (question_id, topic_id, weight) values
  ('f1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000003', 1.0),
  ('f1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000004', 1.0),
  ('f1000000-0000-4000-8000-000000000001', 'd1000000-0000-4000-8000-000000000002', 0.6),

  ('f1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000005', 1.0),
  ('f1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000003', 0.7),
  ('f1000000-0000-4000-8000-000000000002', 'd1000000-0000-4000-8000-000000000002', 0.5),

  ('f1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000003', 'd1000000-0000-4000-8000-000000000009', 0.8),

  ('f1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000009', 0.8),
  ('f1000000-0000-4000-8000-000000000004', 'd1000000-0000-4000-8000-000000000010', 0.5),

  ('f1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000001', 0.9),
  ('f1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000006', 0.8),
  ('f1000000-0000-4000-8000-000000000005', 'd1000000-0000-4000-8000-000000000013', 0.4),

  ('f1000000-0000-4000-8000-000000000006', 'd1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000006', 'd1000000-0000-4000-8000-000000000001', 0.8),
  ('f1000000-0000-4000-8000-000000000006', 'd1000000-0000-4000-8000-000000000012', 0.5),

  ('f1000000-0000-4000-8000-000000000007', 'd1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000007', 'd1000000-0000-4000-8000-000000000001', 0.9),
  ('f1000000-0000-4000-8000-000000000007', 'd1000000-0000-4000-8000-000000000002', 0.4),

  ('f1000000-0000-4000-8000-000000000008', 'd1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000008', 'd1000000-0000-4000-8000-000000000001', 0.8),

  ('f1000000-0000-4000-8000-000000000009', 'd1000000-0000-4000-8000-000000000014', 1.0),
  ('f1000000-0000-4000-8000-000000000009', 'd1000000-0000-4000-8000-000000000012', 0.9),

  ('f1000000-0000-4000-8000-000000000010', 'd1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000010', 'd1000000-0000-4000-8000-000000000012', 0.8),
  ('f1000000-0000-4000-8000-000000000010', 'd1000000-0000-4000-8000-000000000001', 0.6);

-- ---------------------------------------------------------------------------
-- Chinese display content
-- ---------------------------------------------------------------------------

update public.questions
set
  title = case id
    when 'f1000000-0000-4000-8000-000000000001' then 'Attention 中的 Q、K 和 V 是什么？'
    when 'f1000000-0000-4000-8000-000000000002' then '为什么 KV Cache 有用？'
    when 'f1000000-0000-4000-8000-000000000003' then 'PPO 和 GRPO 有什么区别？'
    when 'f1000000-0000-4000-8000-000000000004' then '为什么 GRPO 不需要 critic？'
    when 'f1000000-0000-4000-8000-000000000005' then '什么是 Action Chunking？'
    when 'f1000000-0000-4000-8000-000000000006' then '什么是 Diffusion Policy？'
    when 'f1000000-0000-4000-8000-000000000007' then '什么是 Vision-Language-Action 模型？'
    when 'f1000000-0000-4000-8000-000000000008' then '什么是动作条件世界模型？'
    when 'f1000000-0000-4000-8000-000000000009' then '什么是 SE(3)？'
    when 'f1000000-0000-4000-8000-000000000010' then '机器人数据采集流水线主要有哪些阶段？'
  end,
  summary = case id
    when 'f1000000-0000-4000-8000-000000000001' then 'Query 负责提出查询，Key 用于索引，Value 携带最终汇聚的内容。'
    when 'f1000000-0000-4000-8000-000000000002' then 'KV Cache 用额外内存换取计算量，让每个新 token 只需关注自身和历史缓存。'
    when 'f1000000-0000-4000-8000-000000000003' then 'PPO 使用学习到的 critic 评估动作，GRPO 则使用采样组的平均奖励作为基线。'
    when 'f1000000-0000-4000-8000-000000000004' then 'GRPO 使用同一 prompt 的采样组平均奖励作为优势基线，因此不需要额外的 critic 网络。'
    when 'f1000000-0000-4000-8000-000000000005' then '一次预测一小段未来动作，执行后再重新观测和规划。'
    when 'f1000000-0000-4000-8000-000000000006' then '通过迭代去噪生成动作轨迹的视觉运动策略。'
    when 'f1000000-0000-4000-8000-000000000007' then '同时接收图像和语言指令，并输出机器人动作的模型。'
    when 'f1000000-0000-4000-8000-000000000008' then '根据当前状态和候选动作预测未来观测的学习型动力学模型。'
    when 'f1000000-0000-4000-8000-000000000009' then '三维空间中的特殊欧氏群，表示刚体的旋转和平移。'
    when 'f1000000-0000-4000-8000-000000000010' then '任务定义、遥操作采集、同步校准、清洗标注、整理以及训练期混合。'
  end,
  canonical_answer = case id
    when 'f1000000-0000-4000-8000-000000000001' then '给定输入嵌入 X，Attention 学习三个线性投影：Q = XW_Q、K = XW_K、V = XW_V。Query 是寻找信息的向量，Key 是每个 token 用于匹配的标签，Value 则是实际参与加权混合的内容。分数按照 QK^T / sqrt(d_k) 计算，经过 softmax 后对 V 做加权求和。因此，Key 决定取多少，Value 决定取什么。'
    when 'f1000000-0000-4000-8000-000000000002' then '自回归解码在每一步都会重新计算整个前缀的 Attention。长度为 n 时，朴素做法需要 O(n^2) 的工作量。早先 token 的 key/value 在生成后不会改变，因此可以缓存并复用。生成新 token 时，只需计算自己的 Q、K、V，并与缓存的 K/V 做 Attention：每一步从 O(n^2) 降为 O(n)，代价是额外的 O(n) 内存。'
    when 'f1000000-0000-4000-8000-000000000003' then 'PPO 用 value network，也就是 critic，估计 advantage，通常写作 A = GAE(rewards, V(s))。GRPO 完全移除了 critic：对同一个 prompt 采样 G 个输出，用 reward model 或 verifier 打分，再在组内归一化 A_i = (r_i - mean(r)) / std(r)。最后仍然使用带 clipping 的 PPO 风格目标和 KL 项来更新 policy。'
    when 'f1000000-0000-4000-8000-000000000004' then '优势只需要一个与当前动作无关的基线：A(s, a) = Q(s, a) - b(s)。学习到的 critic V(s) 只是 b(s) 的一种实现。GRPO 对同一个 prompt 采样 G 个输出，并把这组样本的平均奖励作为 b(s)。由于组内样本共享同一个 prompt，这个均值可以作为与动作无关的基线，不需要额外的 value loss 或 GAE。'
    when 'f1000000-0000-4000-8000-000000000005' then '策略不再把一个观测映射为一个动作，而是输出 H 个动作组成的 chunk：a_t 到 a_{t+H-1}。机器人执行这段动作后重新观测。这样可以摊薄一次昂贵前向计算的成本，并缩短 credit assignment 的有效时间跨度。chunk 太短会带来抖动和更高的计算开销，太长则会降低对漂移和接触变化的反应能力。'
    when 'f1000000-0000-4000-8000-000000000006' then 'Diffusion Policy 把动作生成视为条件去噪。先将长度为 H 的动作轨迹初始化为高斯噪声，再使用以观测 o 为条件的去噪网络，经过 K 步逐渐移除噪声。训练时从干净轨迹出发加噪并预测噪声，推理时执行去噪后的动作 chunk，并可结合 receding-horizon control。它能够表示多峰示范行为，但代价是每次决策需要多步去噪，带来推理延迟。'
    when 'f1000000-0000-4000-8000-000000000007' then 'VLA 在 Vision-Language Model 的基础上增加 action head。一个或多个相机的观测被编码成视觉 token，语言指令经过 token 化后与视觉信息由预训练 VLM backbone 融合。独立的 action expert 再把融合表示映射为连续或离散动作，并使用机器人示范数据训练。它的优势是能够迁移互联网图像文本预训练得到的语义知识，局限则包括闭环延迟、深度和力觉不足以及语义理解到精细接触操作之间的差距。'
    when 'f1000000-0000-4000-8000-000000000008' then '动作条件世界模型近似 p(o_{t+1} | o_{t-k..t}, a_t..a_{t+H-1})。它在轨迹数据上训练，不像 policy 那样直接选择动作，而是回答候选动作序列会带来什么未来观测，因此可以用于 model-predictive control、规划和生成合成训练数据。设计上的关键是 latent space：像素空间容易监督但会浪费容量，latent space 更紧凑高效却需要良好正则化，否则可能发生模型利用。'
    when 'f1000000-0000-4000-8000-000000000009' then 'SE(3) 是形如 x -> Rx + t 的刚体变换群，其中 R 属于 SO(3)，t 属于 R^3，共有六个自由度。它通常表示为 4x4 齐次矩阵 [[R, t], [0, 1]]，这样变换组合可以直接写成矩阵乘法。在机器人学中还要注意参考坐标系：一个位姿只有相对于明确的 frame 才有意义。'
    when 'f1000000-0000-4000-8000-000000000010' then '典型流程包括：1）定义任务、机器人本体和成功标准；2）以固定控制频率进行遥操作采集，记录关节状态、末端位姿、相机、力矩和夹爪状态；3）完成时间同步、相机标定和手眼标定；4）删除失败或空闲片段并处理丢帧；5）标注语言指令、子任务和成功标签；6）整理数据、平衡任务与场景多样性，并决定机器人数据与仿真或人类视频的混合比例。'
  end,
  deep_answer = case id
    when 'f1000000-0000-4000-8000-000000000001' then 'Q、K、V 的拆分让匹配和内容传递彼此独立。如果直接对输入做平均，一个 token 只能按自身 embedding 与其他 token 的相似度参与。拆开后，Key 可以表达这是模型正在寻找的类型，Value 可以表达被选中后真正贡献的内容。多头 Attention 中每个 head 都有自己的 W_Q、W_K、W_V，可以学习语法、指代或几何等不同关系。Cross-Attention 中 Q 来自 decoder 或动作流，K 和 V 来自观测或语言编码器，这正是 VLA 中这种不对称结构重要的原因。'
    when 'f1000000-0000-4000-8000-000000000002' then 'KV Cache 变大后，瓶颈通常从 FLOPs 转向内存带宽：解码要在 layers、heads、seq 和 d_k 组成的张量上进行带宽受限的读取。因此才会出现 multi-query attention、grouped-query attention 和 KV-cache quantisation，它们缩小的是缓存而不是计算。对机器人来说，运行在机载 GPU 上的 VLA 往往有严格的 10 到 50 Hz 延迟预算，可以采用分块 prompt、对最近帧使用 sliding-window attention，或将 KV 量化为 int8。'
    when 'f1000000-0000-4000-8000-000000000003' then '两者最实际的区别是成本和方差。去掉 critic 可以省下一个接近 policy 大小的模型，包括参数、优化器状态和前向反向计算，这对 7B 级别以上的 VLA 很重要。代价是组相对优势比拟合出的 value function 更嘈杂，所以 GRPO 通常需要较大的采样组，并且更适合正确性明确的可验证奖励。奖励稠密且经过良好塑形，或样本效率最重要时，PPO 仍然可能更合适。'
    when 'f1000000-0000-4000-8000-000000000004' then 'critic 提供的是期望回报基线，能够解释 prompt 本身有多难；GRPO 的采样组只是用有限个样本估计这个期望，组太小时方差会变大。除以组内标准差可以增强信号，但当所有样本得分接近时标准差会接近零，所以实现通常会 clipping 或跳过退化组。这也是 GRPO 适合数学、代码和经过单元测试的机器人子程序等可验证任务的原因。'
    when 'f1000000-0000-4000-8000-000000000005' then 'Action Chunking 还有三个重要后果。第一是延迟：大模型不必在每个控制周期都完整运行，而是每隔一段时间重新规划并执行 chunk。第二是误差累积：重新规划次数变少后，策略纠正漂移的机会也变少，接触丰富的任务不能使用过长 chunk。第三是动作平滑：相邻 chunk 需要通过 temporal ensembling 或重叠预测上的指数平滑来衔接。'
    when 'f1000000-0000-4000-8000-000000000006' then 'Diffusion Policy 的表示能力来自对多模态行为的建模。确定性的 MSE action head 往往会把多个有效策略平均成一个无效动作，而 diffusion head 可以表达多个 mode，再采样一条具体轨迹。它也能自然支持 score-based conditioning 和固定起点或目标等 inpainting 约束。主要成本是每次决策要做 K 次去噪，以及对 noise schedule 的敏感性；DDIM sampler、蒸馏和 one-step policy 可以缓解延迟。'
    when 'f1000000-0000-4000-8000-000000000007' then 'VLA 的迁移能力来自大规模图像文本预训练，例如 backbone 可以先学会红色杯子在左边这类语义，再用较少的机器人数据学习动作。面试中可以继续讨论连续动作与离散动作、单相机与多相机、本体感知、action chunking，以及不同机器人共享 backbone 并使用本体专属 action head 的 cross-embodiment training。还应主动说明闭环延迟、RGB 缺少深度和力觉，以及语义理解与精细操作之间的差距。'
    when 'f1000000-0000-4000-8000-000000000008' then '世界模型的价值在于把昂贵的真实机器人交互摊销到大量被动视频和少量带动作数据上。像 Dreamer 风格的 RSSM 一样，latent-space rollout 更紧凑，但必须防止 latent collapse。另一个已知失败模式是 model exploitation：优化器找到模型认为很好、但其实落在模型错误高置信区域的动作序列。因此 rollout 通常不会太长，并且需要和真实交互结合。'
    when 'f1000000-0000-4000-8000-000000000009' then '旋转的表示方式很关键。SO(3) 是弯曲流形，直接使用三个 Euler angle 会产生奇异点和非欧氏插值问题，常见替代方案包括 quaternion、rotation matrix 和 Lie algebra se(3) 中的 6D twist。另一个关键点是 equivariance：以 SE(3) 为对称群设计的模型可以跨物体位姿和相机视角泛化，而不是记住每个姿态。'
    when 'f1000000-0000-4000-8000-000000000010' then '数据流水线的风险点往往比流程名称更值得讨论。硬件漂移和重新标定会悄悄让旧数据失效，因此每次采集都应绑定校准版本。遥操作通常是吞吐瓶颈，可以用跨本体数据集、仿真增强和人类视频预训练缓解。示范质量通常比数量重要：少量一致、平滑、成功的轨迹可能优于大量噪声数据。最后还要固定每种机器人本体的 action space 和 observation space，否则本月采集的数据可能无法训练下季度的 policy。'
  end
where id in (
  'f1000000-0000-4000-8000-000000000001',
  'f1000000-0000-4000-8000-000000000002',
  'f1000000-0000-4000-8000-000000000003',
  'f1000000-0000-4000-8000-000000000004',
  'f1000000-0000-4000-8000-000000000005',
  'f1000000-0000-4000-8000-000000000006',
  'f1000000-0000-4000-8000-000000000007',
  'f1000000-0000-4000-8000-000000000008',
  'f1000000-0000-4000-8000-000000000009',
  'f1000000-0000-4000-8000-000000000010'
);


update public.coding_problems
set
  title = case slug
    when 'implement-stable-softmax' then '实现数值稳定的 Softmax'
    when 'implement-layer-normalization' then '实现 Layer Normalization'
    when 'scaled-dot-product-attention' then '实现缩放点积 Attention'
    when 'average-multi-head-attention' then '实现多头 Attention 平均'
    when 'build-causal-attention-mask' then '构建因果 Attention Mask'
    when 'compute-discounted-returns' then '计算折扣回报'
    when 'generalized-advantage-estimation' then '实现广义优势估计（GAE）'
    when 'ppo-clipped-objective' then '实现 PPO Clipped Objective'
    when 'group-relative-advantage' then '计算组相对优势'
    when 'euler-angles-to-quaternion' then '欧拉角转 Quaternion'
    when 'multiply-unit-quaternions' then '相乘两个单位 Quaternion'
    when 'spherical-quaternion-interpolation' then '球面 Quaternion 插值'
    when 'transform-point-with-se3' then '使用 SE(3) 变换点'
    when 'ddpm-forward-noise-step' then '执行 DDPM 前向加噪'
    when 'linear-noise-schedule' then '生成线性噪声调度'
    when 'flow-matching-vector-field' then '计算 Flow Matching 向量场'
    when 'replay-buffer-retention' then '模拟 Replay Buffer 保留'
    when 'blend-overlapping-action-chunks' then '混合重叠的 Action Chunks'
    when 'create-sliding-windows' then '创建滑动窗口'
    when 'top-k-token-frequencies' then '统计 Top-K Token 频率'
  end,
  description = case slug
    when 'implement-stable-softmax' then '为一组 logits 计算数值稳定的 softmax。先减去最大 logit，再进行指数运算，最后返回四舍五入到六位小数的概率。'
    when 'implement-layer-normalization' then '使用总体方差对一个特征向量进行归一化。在平方根中使用给定的 epsilon，并将每个归一化值四舍五入到六位小数。'
    when 'scaled-dot-product-attention' then '实现一个 query 的缩放点积 Attention。对 query-key 分数应用 softmax，并返回四舍五入到四位小数的加权 value 向量。'
    when 'average-multi-head-attention' then '每个 Attention head 都独立地为同一个 query 汇聚 value 向量。计算每个 head 的缩放 Attention，再对所有 head 的输出求平均。'
    when 'build-causal-attention-mask' then '将每一行 Attention 分数转换为因果 softmax：位置 i 只能关注不大于 i 的位置，未来位置的概率必须为零。'
    when 'compute-discounted-returns' then '给定奖励序列和折扣因子，通过从后向前累积奖励，计算每个时间步的回报。'
    when 'generalized-advantage-estimation' then '根据奖励和一个额外的 bootstrap value 计算 GAE advantage。从后向前使用 gamma 和 lambda，并将结果四舍五入到六位小数。'
    when 'ppo-clipped-objective' then '为每个动作计算 PPO clipped surrogate 项并返回平均值。将 ratio 截断到 1 加减 epsilon 后再与 advantage 相乘。'
    when 'group-relative-advantage' then '对同一 prompt 采样的奖励进行标准化。减去组均值并除以总体标准差，退化组返回零。'
    when 'euler-angles-to-quaternion' then '将弧度制的 roll、pitch、yaw 转换为 xyzw 顺序的单位 Quaternion，并将分量四舍五入到六位小数。'
    when 'multiply-unit-quaternions' then '使用 Hamilton product 组合两个 xyzw 顺序的单位 Quaternion，并按 xyzw 顺序返回结果。'
    when 'spherical-quaternion-interpolation' then '沿最短球面路径在两个单位 Quaternion 之间插值。接近平行时才使用线性插值，并返回归一化结果。'
    when 'transform-point-with-se3' then '对一个三维点应用刚体变换。先乘旋转矩阵，再加上平移向量。'
    when 'ddpm-forward-noise-step' then '对每个坐标应用一次前向扩散步骤 x_t = sqrt(alpha_bar) x_0 + sqrt(1 - alpha_bar) epsilon。'
    when 'linear-noise-schedule' then '根据请求的扩散步数，在 beta_start 和 beta_end 之间生成包含两端点的线性 beta 调度。'
    when 'flow-matching-vector-field' then '对于从 x0 到 x1 的直线插值路径，计算恒定的 Flow Matching 目标向量 x1 - x0。'
    when 'replay-buffer-retention' then '插入所有项目后模拟 FIFO Replay Buffer，再从保留下来的 buffer 中读取有效样本索引。'
    when 'blend-overlapping-action-chunks' then '使用标量置信度权重混合 Action Chunks。所有 chunk 形状相同，为每个时间步和动作维度计算加权平均。'
    when 'create-sliding-windows' then '使用窗口大小和步长，将序列切分为完整的滑动窗口，丢弃末尾不完整的窗口。'
    when 'top-k-token-frequencies' then '统计 token 次数，并以 [token, count] 对的形式返回频率最高的 k 个 token。出现并列时按字典序确定顺序。'
  end,
  constraints = case slug
    when 'implement-stable-softmax' then '1 <= len(logits) <= 128' || chr(10) || '输入和输出均为 JSON。'
    when 'implement-layer-normalization' then '1 <= len(values) <= 256' || chr(10) || '输入 JSON 中包含 values 和 eps。'
    when 'scaled-dot-product-attention' then 'Keys 与 query 维度相同。' || chr(10) || '输入和输出均为 JSON。'
    when 'average-multi-head-attention' then '每个 head 的 value 维度相同。' || chr(10) || '将平均后的向量四舍五入到四位小数。'
    when 'build-causal-attention-mask' then '分数矩阵为方阵，最多 64 行。' || chr(10) || '将概率四舍五入到六位小数。'
    when 'compute-discounted-returns' then '0 <= gamma <= 1' || chr(10) || '每个 reward 返回一个值，并四舍五入到六位小数。'
    when 'generalized-advantage-estimation' then 'len(values) = len(rewards) + 1' || chr(10) || '0 <= gamma, lambda <= 1。'
    when 'ppo-clipped-objective' then 'Ratios 和 advantages 长度相同且不为空。' || chr(10) || '将标量结果四舍五入到六位小数。'
    when 'group-relative-advantage' then '1 <= len(rewards) <= 128' || chr(10) || '将每个 advantage 四舍五入到六位小数。'
    when 'euler-angles-to-quaternion' then '角度单位为弧度。' || chr(10) || '使用 roll-pitch-yaw 约定，并返回 [x, y, z, w]。'
    when 'multiply-unit-quaternions' then '输入是 [x, y, z, w] 顺序的单位 Quaternion。' || chr(10) || '将分量四舍五入到六位小数。'
    when 'spherical-quaternion-interpolation' then 'Quaternion 为单位长度，并使用 xyzw 顺序。' || chr(10) || '0 <= t <= 1。'
    when 'transform-point-with-se3' then '旋转矩阵为 3x3，平移和点都是长度为三的向量。' || chr(10) || '将坐标四舍五入到六位小数。'
    when 'ddpm-forward-noise-step' then '0 <= alpha_bar <= 1' || chr(10) || 'x0 和 noise 长度相同。' || chr(10) || '将坐标四舍五入到六位小数。'
    when 'linear-noise-schedule' then 'steps 为正数。' || chr(10) || 'steps 为 1 时返回 beta_start，否则包含两个端点。'
    when 'flow-matching-vector-field' then 'x0 和 x1 长度相同。' || chr(10) || '将每个分量四舍五入到六位小数。'
    when 'replay-buffer-retention' then 'capacity 为正数。' || chr(10) || '忽略保留 buffer 之外的样本索引。'
    when 'blend-overlapping-action-chunks' then '所有 chunk 形状相同，且权重为正数。' || chr(10) || '将每个动作四舍五入到六位小数。'
    when 'create-sliding-windows' then 'window 和 stride 为正数。' || chr(10) || '只返回恰好包含 window 个元素的窗口。'
    when 'top-k-token-frequencies' then '1 <= k <= 不同 token 的数量。' || chr(10) || 'Token 均为字符串。'
  end;

update public.coding_test_cases
set name = '示例 ' || (order_index + 1)
where is_hidden = false;

update public.coding_problems
set starter_code = replace(starter_code, '# TODO: implement the solution', '# TODO：实现该解法');

commit;
