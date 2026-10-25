-- 逐条补强说明：deep_answer 追加「外部题库补充」段落（仅含原答案缺失的要点），
-- common_mistakes 原为 null、直接写入源库易错点精选，source_freq 取配对源题频次
-- （多对取 max）。英语撰写的原题保持英语补充，风格与原答案一致。

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：复杂度速答：时间 O(n^2·d)、空间 O(n^2)（注意力矩阵是瓶颈）；多头注意力是 h 个小头并行，总参数量不变。',
  common_mistakes = coalesce(q.common_mistakes, '["去掉 √dk 缩放训练会明显变差——缩放防止点积过大导致 softmax 梯度消失"]'::jsonb),
  source_freq = 18,
  is_featured = true,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q01"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'why-scaled-dot-product-attention-divides-by-sqrt-dk';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：推理退化场景要点：推理时单条序列（batch=1）BN 直接退化，LN 完全不受影响；训练/推理行为不一致（running 统计 vs batch 统计）是 BN 特有的坑。',
  common_mistakes = coalesce(q.common_mistakes, '["BN 推理期用的是训练期积累的 running mean/var，不是当前 batch 统计量", "小 batch 时 BN 抖动大、LN 更稳"]'::jsonb),
  source_freq = 14,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q03"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'batchnorm-layernorm-rmsnorm';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

Supplement (embodied-interview-qa): a common follow-up is why there is no KV cache during training — training runs teacher forcing, the whole sequence passes in one parallel forward, so there is no incremental decoding to cache for. Two precision points: the cache stores K/V tensors, not attention weights; and caching removes the redundant projection of the prefix, while each step still attends over the full history.',
  common_mistakes = coalesce(q.common_mistakes, '["The cache stores K and V tensors, not attention weights", "Caching removes redundant K/V projection of the prefix; each step still attends over all history"]'::jsonb),
  source_freq = 5,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q17"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'why-is-kv-cache-useful';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：粗略存储公式：2 × batch × layers × seq × H_kv × d_head × bytes（2 对应 K/V 两份）。GQA/MQA 只减少 K/V 头数，不减少注意力要看的历史长度。',
  common_mistakes = coalesce(q.common_mistakes, '["GQA 不是稀疏注意力，也不会把上下文长度变短", "它解决的是长上下文推理时 KV Cache 的显存/带宽问题"]'::jsonb),
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q17a"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'mha-vs-gqa';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：代表算法补全：on-policy 还有 REINFORCE / A2C / A3C / TRPO / SARSA；off-policy 有 Q-learning / DDPG / TD3 / SAC。VLA 语境的落点：动作策略本身多以 BC / LoRA / flow-matching 等监督方式训练，RL 更常见于语言与偏好后训练。',
  common_mistakes = coalesce(q.common_mistakes, '["PPO 用了重要性采样仍属 on-policy（epoch 数少、clip 只容忍轻度陈旧），不要说 PPO 是 off-policy"]'::jsonb),
  source_freq = 15,
  is_featured = true,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q27","eaq-v02-q01"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'on-policy-vs-off-policy-data-reuse';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：两大补位方法：HER——把失败轨迹实际到达的状态当作新目标重标注为成功，与 replay buffer 天然兼容，goal-conditioned 机器人任务最常用；内在奖励探索——RND / ICM 用新奇性提供内在动机，在奖励几乎全零时维持探索压力。',
  common_mistakes = coalesce(q.common_mistakes, '["Reward shaping 与真实目标不对齐时会刷虚假奖励（reward hacking），验收必须回到原始稀疏指标"]'::jsonb),
  source_freq = 10,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q29","eaq-v02-q33"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'sparse-reward-difficulties-and-shaping-validation';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：直觉与选型追问：最大熵让策略在等效动作间保持分布而不是过早塌缩——探索内化、多峰任务天然处理、对真机扰动更鲁棒；真机青睐 SAC 的工程理由是 off-policy + replay：每次昂贵的真机交互可被反复学习。α 自动调节的损失是 min_α E[−α(log π + H̄)]（熵低于目标熵则 α 升、反之降），初始 α≈0.2。',
  common_mistakes = coalesce(q.common_mistakes, '["soft 指软 Q-learning（熵正则化），不是软更新——虽然 SAC 也用软更新 target network", "α 是正则权重不是探索率；SAC 无 ε-greedy，策略随机性即探索来源"]'::jsonb),
  source_freq = 14,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q32","eaq-v02-q14"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'sac-maximum-entropy-objective-and-loss-signs';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：概念辨析：offline RL ≠ BC——BC 只模仿数据动作，offline RL 试图推断出优于数据策略的策略，因此才有 OOD 风险。OOD 链条要说完整：actor 迭代地找最大 Q → 走向数据集外区域 → 函数近似外推任意 → bootstrap 正反馈爆炸。菜单类比好用：模型会说「菜单上没有的菜最好吃」。',
  common_mistakes = coalesce(q.common_mistakes, '["Offline RL 不是有数据就行——数据覆盖度与质量是生命线，覆盖差时 CQL 等方法也会失效"]'::jsonb),
  source_freq = 11,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q33","eaq-v02-q22"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'online-vs-offline-rl-in-post-training';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：数量级速查：关节 PD 500Hz–1kHz；力控/阻抗 100–500Hz；视觉闭环 30–100Hz；VLA 策略层 5–25Hz（OpenVLA 串行 AR 解码约 5Hz、优化后 15Hz 上下；π0 用独立 action expert + flow matching chunk 跑到约 50Hz，GR00T 类似思路、频率因平台而异）。',
  common_mistakes = coalesce(q.common_mistakes, '["控制频率与推理频率是两层：VLA 推理 10Hz、底层 PD 仍 1kHz，靠 chunk 插值衔接"]'::jsonb),
  source_freq = 5,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v01-q44"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'real-time-control-concepts';

update public.questions q set
  common_mistakes = coalesce(q.common_mistakes, '["GAE 不是 PPO 专属，TRPO/A3C 也用；PPO+GAE 只是最常见组合"]'::jsonb),
  source_freq = 10,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v02-q04"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'gae-bias-variance-and-stability';

update public.questions q set
  source_freq = 8,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v02-q18"],"note":"重复题答案融合（原答案已完备，仅登记频次）"}'::jsonb
where q.slug = 'dqn-target-network-slow-update';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：报得出数字是加分项（Atari 原版配置）：replay buffer 10^6 转移、target 网络每 10^4 步硬同步、batch 32、ε-greedy 从 1.0 线性退火到 0.1。',
  common_mistakes = coalesce(q.common_mistakes, '["神经网络替代的是 Q-table：输出所有离散动作的 Q 值，不输出动作概率", "DQN 不能直接用于连续动作空间（需 DDPG/SAC 类 actor-critic）"]'::jsonb),
  source_freq = 10,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v02-q19"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'dqn-and-double-dqn';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

Supplement (embodied-interview-qa): implementation details worth citing — DeepSeekMath/R1 put the KL term directly into the loss rather than folding it into the reward; engineering-wise PPO keeps roughly 4 resident models (policy, critic, reward, reference) versus GRPO''s 3, saving about 25% memory at 7B scale. GRPO leans on verifiable rewards: pure reward-model scores inflate within-group variance and make the group-relative advantage noisy.',
  common_mistakes = coalesce(q.common_mistakes, '["GRPO depends on verifiable rewards; noisy RM scores make group-relative advantages noisy"]'::jsonb),
  source_freq = 8,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v02-q31"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'difference-between-ppo-and-grpo';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：实务模板与反例：Φ(s) = −‖s−g‖（到目标负距离）是典型安全形式；success bonus 属于原始奖励定义、不在势能约束讨论范围；避免依赖子目标顺序的多路径不一致中间奖励。经典反例：迷宫给「靠近墙壁 +1」，agent 学会在墙边徘徊而不去目标。',
  common_mistakes = coalesce(q.common_mistakes, '["势能条件只保证最优策略不变，不保证样本效率不变——好 shaping 可加速学习，但定理不承诺加速"]'::jsonb),
  source_freq = 6,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v02-q36"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'potential-based-shaping-policy-invariance';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：追问「为什么选 PaliGemma 而非 Llama」的答法：PaliGemma 自带 SigLIP 视觉编码与图文对齐预训练，开箱即有视觉语义，3B 量级兼顾机载算力；但这是论文的架构选择，不能据此断言 Llama 系不适合机器人。注意 PaliGemma 权重是 Gemma 条款、不是 Apache 2.0（license 说错是减分项）。',
  common_mistakes = coalesce(q.common_mistakes, '["动作按 50Hz 执行不代表 VLM 每 20ms 完整推理一次——重计算发生在小动作专家上"]'::jsonb),
  source_freq = 4,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q16"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'pi0-vlm-backbone-and-multimodal-token-fusion';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：「300M 为什么单独拆出来」的答法：动作生成的重计算发生在小网络上，VLM 每次重规划只前向一次——平衡预训练知识保留与推理频率。但注意原始 π0 是联合训练的双流 Transformer，不是两个独立模型各训各的；也不应把 π0.5 KI 的梯度隔离倒写成 π0 的机制。',
  common_mistakes = coalesce(q.common_mistakes, '["块长、动作执行频率与重规划频率是三个不同的数，勿混用"]'::jsonb),
  source_freq = 4,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q17"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'pi0-how-vlm-output-feeds-flow-matching-action-expert';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

Supplement (embodied-interview-qa): numbers to cite — forward noising a_k = sqrt(abar_k)·a* + sqrt(1−abar_k)·ε with the network predicting ε; sampling is ≈50 steps with DDPM, 10–20 with DDIM. Noise-perturbation training doubles as implicit data augmentation on the action space, which helps long-tail tasks. Precisely: it is a score-based generative head, not "BC loss with noise added".',
  common_mistakes = coalesce(q.common_mistakes, '["Diffusion Policy is a score-based framework, not BC loss plus noise"]'::jsonb),
  source_freq = 11,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q18"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'what-is-diffusion-policy';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：机器人圈流行的四点原因：① 推理快（ODE 求解 10 步量级 vs SDE 50 步）；② 训练稳（速度场回归目标数值范围紧凑，loss 不易爆炸）；③ 超参少（无需挑选 cosine/linear 噪声调度）；④ 理论统一（diffusion 是 FM 在特定路径下的特例）。',
  common_mistakes = coalesce(q.common_mistakes, '["FM 不是 diffusion 的「加速版」，是更一般的框架；diffusion 可看作 FM 在特定路径上的实例"]'::jsonb),
  source_freq = 8,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q20"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'what-is-flow-matching';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

Supplement (embodied-interview-qa): calibration against common overclaims — there is no universal 4–16 "sweet spot": ACT''s real-robot setting used k=100; the execution horizon and the replanning rate are two different numbers; ACT''s temporal ensembling queries at every control step and weights overlapping predictions, it is not low-frequency querying.',
  common_mistakes = coalesce(q.common_mistakes, '["No universal chunk-size sweet spot exists; ACT''s real setup used k=100"]'::jsonb),
  source_freq = 10,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q24"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'what-is-action-chunking';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：结构细节追问：训练时后验编码器从关节状态与示教动作块推断 z；解码器用 k 个位置查询并行预测整段动作（非自回归）；推理只移除后验编码器（视觉编码保留）并把 z 置零——z=0 是潜变量的确定性取值，不保证对应某条专家轨迹或分布众数。',
  common_mistakes = coalesce(q.common_mistakes, '["原始 ACT 不默认输入文本指令，也不是自回归生成动作"]'::jsonb),
  source_freq = 8,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q25"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'what-is-act';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：与 RMA 组合是标准实践：RMA 用 latent 在线编码当前 domain 参数，DR+RMA 比纯 DR 更鲁棒（纯 DR 要求策略记住所有环境，RMA 让它在线识别环境）。VLA 语境的典型用法：仿真大规模 DR 预训练 → 真机 demos 微调。',
  common_mistakes = coalesce(q.common_mistakes, '["随机化不是越大越好——过宽会使任务不可学，需 curriculum 由弱到强"]'::jsonb),
  source_freq = 8,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v02-q35","eaq-v03-q41","eaq-v04-q12"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'domain-randomization-parameters-and-ranges';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：命名辨析：π*0.6 指经 RECAP 后训练得到的策略，应与 π0.6 基座区分；RECAP 不是 reward-weighted regression，也不是「reward model + PPO」的默认在线 RL——优势离散化与 value 训练方式须按原文表述。',
  common_mistakes = coalesce(q.common_mistakes, '["不只是离线示教；优势如何离散化、value 如何训练须依原文说明"]'::jsonb),
  source_freq = 3,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q47"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'recap-full-procedure';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

外部题库补充（embodied-interview-qa）：项目化答题模板：R = 任务奖励 + 安全惩罚（碰撞 / 关节限位 / 力超限）+ 平滑惩罚（−α‖Δa‖²，α 大动作平滑但响应慢）的多分量结构，配早期 dense、后期切 sparse 的课程组合；纯 sparse 收敛慢、纯 dense 易 hacking，hybrid 是常见落点。',
  common_mistakes = coalesce(q.common_mistakes, '["判断 reward hacking 要看 rollout 视频是否真完成任务，不能只看 reward 曲线（模型常学「接近但不抓」刷分）"]'::jsonb),
  source_freq = 6,
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q54"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'reward-design-for-embodied-tasks';

update public.questions q set
  deep_answer = rtrim(coalesce(q.deep_answer, '')) || '

Supplement (embodied-interview-qa): two additions from practice — export the cleaned data to a unified schema (RLDS, LeRobot, or HDF5 + metadata), and split train/val/test by episode, never by frame, so adjacent frames cannot leak into the test set. One-line anchor: observation-action-time must be traceable.',
  common_mistakes = coalesce(q.common_mistakes, '["VLA data hinges on observation-action-time traceability, not a pile of videos"]'::jsonb),
  source_meta = '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d42","license":"MIT","merged_from":["eaq-v03-q59"],"note":"重复题答案融合"}'::jsonb
where q.slug = 'stages-of-robot-data-collection-pipeline';
