-- -------------------------------------------------------------------------
-- RoboPrep — Knowledge 题库补充：embodied-interview-qa 全量导入
--
-- 题源：WinstonJQ/embodied-interview-qa（MIT License）
--       https://github.com/WinstonJQ/embodied-interview-qa @ 001e42385d42 (2026-10-19)
-- 导入口径：跳过源库「N 备选」（19 条，维护者明确不入主表）；与现有题重复的
-- 条目不重复插入，改为在文件末尾以 UPDATE 融合答案（见 enrichments 段）。
-- 幂等：topics / questions / question_topics 均 on conflict do nothing。
-- 生成方式：python3 scripts/generate_embodied_qa_seed.py sql（勿手改）。
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- 新增 topics（复用 seed.sql 既有 topic 体系）
-- -------------------------------------------------------------------------
insert into public.topics (id, name, slug, parent_id, description) values
  ('d1000000-0000-4000-8000-000000000028', '深度学习基础', 'deep-learning-fundamentals', null, '面试常考的深度学习基本盘：优化器、归一化、梯度问题与 Transformer 细节。'),
  ('d1000000-0000-4000-8000-000000000029', '离线强化学习', 'offline-rl', 'd1000000-0000-4000-8000-000000000009', 'CQL、IQL、BCQ 等从固定数据集学习的离线 RL 方法。'),
  ('d1000000-0000-4000-8000-000000000030', '工程落地', 'robot-engineering', 'd1000000-0000-4000-8000-000000000001', 'VLA 部署、推理加速、训练工程、数据飞轮与真机排障。'),
  ('d1000000-0000-4000-8000-000000000031', '腿足控制', 'legged-control', 'd1000000-0000-4000-8000-000000000012', '浮动基座动力学、MPC、全身控制 WBC 与 RL locomotion。'),
  ('d1000000-0000-4000-8000-000000000032', '遥操作', 'teleoperation', 'd1000000-0000-4000-8000-000000000012', 'AVP/VR 主从遥操作、人形遥操作与数据采集系统。'),
  ('d1000000-0000-4000-8000-000000000033', 'SLAM 与 3D 感知', 'slam-3d-perception', 'd1000000-0000-4000-8000-000000000001', '点云、NeRF/3DGS、SLAM 与状态估计。'),
  ('d1000000-0000-4000-8000-000000000034', '具身导航', 'embodied-navigation', 'd1000000-0000-4000-8000-000000000001', '经典导航栈、VLN、零样本 ObjectNav 与导航排障。'),
  ('d1000000-0000-4000-8000-000000000035', 'LeetCode 手撕', 'leetcode-coding', null, '具身/自动驾驶算法岗高频 LeetCode 手写题（CodeTop 统计口径）。'),
  ('d1000000-0000-4000-8000-000000000036', '系统设计', 'system-design', null, 'ML 系统设计与机器人系统设计开放题。'),
  ('d1000000-0000-4000-8000-000000000037', '前沿方向', 'frontier-directions', 'd1000000-0000-4000-8000-000000000001', '近期热门方向的学习型问答（Jev、Astra、具身 Agent、RSI 等，非面经）。')
on conflict (slug) do nothing;

-- -------------------------------------------------------------------------
-- 新增 questions
-- -------------------------------------------------------------------------
insert into public.questions (id, title, slug, question_type, difficulty, summary, short_answer, canonical_answer, deep_answer, key_points, common_mistakes, interview_tips, estimated_minutes, is_featured, is_published, source_freq, source_meta) values
  ('f1000000-0000-4000-8000-000000000080', '梯度消失和梯度爆炸的原因是什么？各有哪些解决方法？', 'eaq-v01-q02', 'knowledge', 'easy', '**消失**：链式法则反传时，若激活函数（如 sigmoid）导数 < 1，多层连乘后梯度指数衰减 → 浅层几乎不更新。',
   '**消失**：链式法则反传时，若激活函数（如 sigmoid）导数 < 1，多层连乘后梯度指数衰减 → 浅层几乎不更新。', '**消失**：链式法则反传时，若激活函数（如 sigmoid）导数 < 1，多层连乘后梯度指数衰减 → 浅层几乎不更新。

**爆炸**：权重矩阵乘积特征值 > 1，梯度指数增长 → 更新步过大、训练发散。

**解决梯度消失**：① **换激活函数**：ReLU/Leaky ReLU 导数在正区间为 1；② **残差连接**（skip connection）提供梯度高速公路；③ **BatchNorm/LayerNorm** 归一化激活分布；④ **LSTM 门机制**（序列模型）。

**解决梯度爆炸**：① **梯度裁剪**（Gradient Clipping）：若 $\|g\| > \tau$ 则 $g \leftarrow g \cdot \tau / \|g\|$；② **权重初始化**（Xavier/He）；③ **BatchNorm**。',
   null, null, '["ReLU 有 dying ReLU 问题（负值区梯度永久为 0），大批量 + 大学习率下死亡神经元显著，Leaky ReLU / ELU 可缓解。"]'::jsonb, null, 3, true, true, 15, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q02","freq_label":"🔥×15"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000081', 'Adam 优化器原理是什么？和 SGD、AdamW 的区别？', 'eaq-v01-q04', 'knowledge', 'easy', '**Adam** = 一阶矩（梯度 EMA）+ 二阶矩（梯度平方 EMA），各参数有独立自适应学习率；',
   '**Adam** = 一阶矩（梯度 EMA）+ 二阶矩（梯度平方 EMA），各参数有独立自适应学习率；更新：$\theta \leftarrow \theta - \alpha \hat{m}/(\sqrt{\hat{v}}+\epsilon)$（偏差修正后），$\beta_1=0.9, \beta_2=0.999$。', '**Adam** = 一阶矩（梯度 EMA）+ 二阶矩（梯度平方 EMA），各参数有独立自适应学习率；更新：$\theta \leftarrow \theta - \alpha \hat{m}/(\sqrt{\hat{v}}+\epsilon)$（偏差修正后），$\beta_1=0.9, \beta_2=0.999$。

**vs SGD**：SGD 用统一学习率，收敛稳但慢；Adam 自适应、前期快，但大规模视觉任务泛化有时弱于 SGD+momentum。

**vs AdamW**：Adam 加 L2 正则后 weight decay 强度被 $\hat{v}$ 缩放（不均匀）；AdamW 把 weight decay 直接加在权重更新上（解耦），效果一致且可控——VLA 微调几乎都用 AdamW。',
   null, null, '["Adam + L2 ≠ AdamW，两者在自适应学习率下行为不同", "LLM/VLA 微调必须用 AdamW，否则 weight decay 强度因参数而异。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q04","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000082', 'Dropout 的原理是什么？训练和推理阶段有何不同？', 'eaq-v01-q05', 'knowledge', 'easy', '**训练时**：每个神经元以概率 $p$ 被随机置 0（"丢弃"），保留的神经元输出乘以 $1/(1-p)$ 缩放（Inverted Dropout），使期望与完整网络一致。',
   '**训练时**：每个神经元以概率 $p$ 被随机置 0（"丢弃"），保留的神经元输出乘以 $1/(1-p)$ 缩放（Inverted Dropout），使期望与完整网络一致。', '**训练时**：每个神经元以概率 $p$ 被随机置 0（"丢弃"），保留的神经元输出乘以 $1/(1-p)$ 缩放（Inverted Dropout），使期望与完整网络一致。

**推理时**：所有神经元保留，**不做 Dropout**，直接用完整网络输出。（如果训练时没用 Inverted Dropout，推理时需将输出乘以 $(1-p)$。）

**作用**：① 减少神经元共适应（co-adaptation），相当于隐式集成多个子网络；② 正则化，防止过拟合。',
   null, null, '["model.eval() 会自动关 Dropout", "忘调会导致推理时随机性——**这是 PyTorch 面试高频陷阱**。BatchNorm 在 eval() 也切换到 running stats，两者必须同时切换。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q05","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000083', 'ResNet 的残差连接解决了什么问题？为什么不是直接加深网络？', 'eaq-v01-q06', 'knowledge', 'easy', '**问题背景**：直接堆叠深层网络（如 56 层）训练误差反而高于浅层（20 层）——不是过拟合，是**网络退化**（degradation）：优化器难以找到恒等映射。',
   '**问题背景**：直接堆叠深层网络（如 56 层）训练误差反而高于浅层（20 层）——不是过拟合，是**网络退化**（degradation）：优化器难以找到恒等映射。', '**问题背景**：直接堆叠深层网络（如 56 层）训练误差反而高于浅层（20 层）——不是过拟合，是**网络退化**（degradation）：优化器难以找到恒等映射。

**残差连接**：$H(x) = F(x) + x$，让网络学习残差 $F(x) = H(x) - x$ 而非直接学 $H(x)$。当最优映射接近恒等时，$F(x) \approx 0$ 比让所有层学恒等映射容易得多。

**附加好处**：① Skip connection 为梯度提供直通路径（等效更短的梯度路径），缓解梯度消失；② 实现了深度 scalable（ResNet-50/101/152 都可用）；③ 残差块输出方差较稳定，训练更容易。',
   null, null, '["残差连接不是\"自动防止过拟合\"，过拟合靠 Dropout/L2/数据增强", "残差解决的是**优化难度**（欠拟合+退化），不是泛化。"]'::jsonb, null, 3, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q06","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000084', '交叉熵损失和 MSE 损失分别适合什么场景？用错了会怎样？', 'eaq-v01-q07', 'knowledge', 'easy', '**交叉熵（CE）**：$L = -\sum_c y_c \log \hat{p}_c$；',
   '- **交叉熵（CE）**：$L = -\sum_c y_c \log \hat{p}_c$；适合**分类**任务，与 softmax/sigmoid 配合，梯度形式简洁（$\hat{p}-y$），不会在输出层饱和时梯度消失。
- **MSE**：$L = \|y - \hat{y}\|^2$；适合**回归**任务（预测连续值，如关节角度、末端坐标）；与 sigmoid 配合时，当 $\hat{y}$ 饱和（近 0/1）梯度会消失。', '- **交叉熵（CE）**：$L = -\sum_c y_c \log \hat{p}_c$；适合**分类**任务，与 softmax/sigmoid 配合，梯度形式简洁（$\hat{p}-y$），不会在输出层饱和时梯度消失。
- **MSE**：$L = \|y - \hat{y}\|^2$；适合**回归**任务（预测连续值，如关节角度、末端坐标）；与 sigmoid 配合时，当 $\hat{y}$ 饱和（近 0/1）梯度会消失。

**用错后果**：
- 分类用 MSE：梯度消失严重（sigmoid 饱和区），收敛慢，概率解释也不对；
- 回归用 CE：值域不匹配，CE 假设输出是概率，连续回归输出 > 1 时 log 无意义。

**延伸**：机器人连续动作回归常用 **Huber Loss**（MSE 和 MAE 的拼接），对异常值（outlier）更鲁棒。',
   null, null, '["CE 中 $\\log 0$ 需要 clip，PyTorch 的 `CrossEntropyLoss` 内部已处理，不用手动加 $\\epsilon$。"]'::jsonb, null, 3, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q07","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000085', 'Transformer 的位置编码（Positional Encoding）为什么必要？常见方案有哪些？', 'eaq-v01-q08', 'knowledge', 'medium', 'Self-Attention 的计算对序列顺序**天然无感**（permutation equivariant）——打乱 token 顺序，attention 输出值相同（只是对应位置互换）。',
   'Self-Attention 的计算对序列顺序**天然无感**（permutation equivariant）——打乱 token 顺序，attention 输出值相同（只是对应位置互换）。对于语言/时序，顺序信息极关键，必须额外注入。', 'Self-Attention 的计算对序列顺序**天然无感**（permutation equivariant）——打乱 token 顺序，attention 输出值相同（只是对应位置互换）。对于语言/时序，顺序信息极关键，必须额外注入。

**方案对比**：
| 方案 | 原理 | 优缺点 |
|---|---|---|
| 正弦位置编码（原始 Transformer） | 固定公式 $\sin/\cos$ | 无需训练，可外推到更长序列；但绝对位置，相对位置弱 |
| 可学习位置嵌入（BERT/GPT） | 每个位置有可训练向量 | 简单有效，不可外推（超训练长度退化） |
| RoPE（LLaMA / VLA） | 旋转矩阵编码**相对**位置 | 相对位置敏感，目前 LLM 主流；直接外推会退化，需位置插值/NTK/YaRN 扩展 |
| ALiBi | 在 attention score 上加线性偏置 | 极简、外推好，速度快 |',
   null, null, '["原始 Transformer 和 BERT 的位置编码方案不同", "RoPE 不是加在 embedding 上，而是在 Q/K 乘以旋转矩阵。"]'::jsonb, null, 5, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q08","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000086', '过拟合的判断标准是什么？有哪些对策？数据少时首选什么？', 'eaq-v01-q09', 'knowledge', 'medium', '**判断**：训练 loss 持续下降但验证 loss 不降或反升；',
   '**判断**：训练 loss 持续下降但验证 loss 不降或反升；Train/Val 准确率差距持续扩大。', '**判断**：训练 loss 持续下降但验证 loss 不降或反升；Train/Val 准确率差距持续扩大。

**对策（按有效性排序，数据少时）**：

1. **数据增强**：旋转/翻转/裁剪/颜色抖动（CV）或轨迹噪声/镜像（机器人）—— **首选**，增效显著
2. **Early Stopping**：监控 val loss，停在最低点
3. **Dropout / L2 正则**：限制权重大小或神经元依赖
4. **降低模型容量**：层数/隐层宽度减半（不够数据撑不住大模型）
5. **迁移学习 + 冻结大部分层**：预训练权重 + 只训练 head（少样本首选）',
   null, null, '["L2 和 Weight Decay 在 Adam 下**不等价**（见 AdamW）", "简单堆 Dropout 不如先看数据是否充分/分布是否覆盖测试集。"]'::jsonb, null, 5, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q09","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000087', '学习率调度（LR Schedule）有哪些常用策略？Warmup 为什么重要？', 'eaq-v01-q10', 'knowledge', 'medium', '**Cosine Annealing**：LR 按余弦从 $\eta_{max}$ 降到 $\eta_{min}$，后期细粒度收敛；',
   '- **Cosine Annealing**：LR 按余弦从 $\eta_{max}$ 降到 $\eta_{min}$，后期细粒度收敛；最常见。
- **Step Decay**：每 N epoch 乘以 decay 因子（如 0.1）；简单但台阶式，可能跳过最优。
- **Linear Decay**：线性下降；简单，GPT 类常用。
- **Warmup + Cosine**（主流组合）：先从 0 线性升到 $\eta_{max}$（Warmup），再 cosine 衰减。', '- **Cosine Annealing**：LR 按余弦从 $\eta_{max}$ 降到 $\eta_{min}$，后期细粒度收敛；最常见。
- **Step Decay**：每 N epoch 乘以 decay 因子（如 0.1）；简单但台阶式，可能跳过最优。
- **Linear Decay**：线性下降；简单，GPT 类常用。
- **Warmup + Cosine**（主流组合）：先从 0 线性升到 $\eta_{max}$（Warmup），再 cosine 衰减。

**Warmup 为什么重要**：训练初期权重随机，梯度方向不稳；大学习率直接更新会破坏预训练权重（fine-tune 场景）或让 Adam 的二阶矩估计（$v_t$）在统计不稳时误导更新方向。Warmup 让模型先"摸清地形"再大步更新。',
   null, null, '["Warmup 步数一般是总 steps 的 1-5%", "太长 warmup 浪费训练", "微调大模型（如 VLA）几乎必须用 warmup，否则容易灾难性遗忘。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q10","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000088', '卷积神经网络中感受野是什么？如何增大感受野？', 'eaq-v01-q11', 'knowledge', 'medium', '**感受野**：输出特征图上一个像素对应输入图像的区域大小。',
   '**感受野**：输出特征图上一个像素对应输入图像的区域大小。$k \times k$ 卷积单层感受野 = $k$；L 层叠加后理论感受野 = $1 + L(k-1)$（无 pooling）。', '**感受野**：输出特征图上一个像素对应输入图像的区域大小。$k \times k$ 卷积单层感受野 = $k$；L 层叠加后理论感受野 = $1 + L(k-1)$（无 pooling）。

**增大感受野的方法**：
- **叠加层数**：最简单，但参数量增大
- **Pooling / Stride > 1**：降采样同时扩感受野，但丢失空间精度
- **空洞卷积（Dilated Convolution）**：在 $k \times k$ 卷积中插入 dilation $r$，等效感受野 $k + (k-1)(r-1)$，参数量不变——**感知野扩大的首选**
- **大核卷积**：如 7×7、11×11；效果直接但参数多

**机器人应用**：视觉策略网络需要大感受野捕捉全局位置关系（末端位姿 vs 目标位置），常用 ViT（全局感受野）或多尺度 CNN。',
   null, null, '["有效感受野（ERF）比理论感受野小得多——高斯分布中心权重大，边缘贡献极低", "不要以为理论感受野就是真正利用的区域。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q11","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000089', '权重初始化为什么重要？Xavier 和 He 初始化各适合什么激活函数？', 'eaq-v01-q12', 'knowledge', 'medium', '**为什么重要**：全 0 初始化 → 所有神经元梯度相同（对称性破坏失败）；',
   '**为什么重要**：全 0 初始化 → 所有神经元梯度相同（对称性破坏失败）；过大初始值 → 激活饱和+梯度消失；过小 → 梯度消失+信号衰减。好的初始化让各层激活和梯度的方差在正向/反向传播中保持稳定。', '**为什么重要**：全 0 初始化 → 所有神经元梯度相同（对称性破坏失败）；过大初始值 → 激活饱和+梯度消失；过小 → 梯度消失+信号衰减。好的初始化让各层激活和梯度的方差在正向/反向传播中保持稳定。

**Xavier（Glorot）初始化**：$\text{Var}(W) = \frac{2}{n_{in} + n_{out}}$；假设激活函数**线性（near zero）**，适合 **tanh / sigmoid**（在零点近似线性）。

**He（Kaiming）初始化**：$\text{Var}(W) = \frac{2}{n_{in}}$；考虑 ReLU 把一半神经元置 0，方差要加倍补偿，适合 **ReLU / Leaky ReLU**。',
   null, null, '["PyTorch 默认初始化对大多数层已用 Kaiming Uniform，但自定义层/Embedding 等要手动检查", "使用 SELU 激活时有专门的 LeCun 初始化。"]'::jsonb, null, 5, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q12","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000090', '什么是 L1 正则和 L2 正则？它们对权重的影响有何不同？', 'eaq-v01-q13', 'knowledge', 'easy', '**L2 正则**（权重衰减）：$L_{total} = L + \lambda \|w\|_2^2$；',
   '- **L2 正则**（权重衰减）：$L_{total} = L + \lambda \|w\|_2^2$；梯度 $\partial/\partial w = \partial L/\partial w + 2\lambda w$，效果是每次更新时权重**等比例收缩**（权重趋于小而稠密）。
- **L1 正则**：$L_{total} = L + \lambda \|w\|_1$；梯度为 $\pm\lambda$（恒定），将小权重推为精确 **0**（稀疏权重），等效特征选择。', '- **L2 正则**（权重衰减）：$L_{total} = L + \lambda \|w\|_2^2$；梯度 $\partial/\partial w = \partial L/\partial w + 2\lambda w$，效果是每次更新时权重**等比例收缩**（权重趋于小而稠密）。
- **L1 正则**：$L_{total} = L + \lambda \|w\|_1$；梯度为 $\pm\lambda$（恒定），将小权重推为精确 **0**（稀疏权重），等效特征选择。

**实践差异**：L2 在深度学习中更常用（weight decay）；L1 在稀疏特征选择（如 Lasso 回归）中有用；Elastic Net = L1 + L2 组合。

**机器人策略网络**：通常用 L2/weight decay + Dropout，L1 导致的权重稀疏不利于连续动作的平滑输出。',
   null, null, '["Adam 下直接加 L2 不等于 weight decay（二阶矩缩放了梯度），要用 AdamW 才是真正解耦的 weight decay。"]'::jsonb, null, 3, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q13","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000091', '为什么 Softmax 输出可以当作概率？数值稳定性如何保证？', 'eaq-v01-q14', 'knowledge', 'medium', '**概率解释**：Softmax 把实值 logit 向量 $z$ 映射到 $(0,1)$ 且和为 1。',
   '**概率解释**：Softmax 把实值 logit 向量 $z$ 映射到 $(0,1)$ 且和为 1：', '**概率解释**：Softmax 把实值 logit 向量 $z$ 映射到 $(0,1)$ 且和为 1：

$$\hat{p}_i = \frac{e^{z_i}}{\sum_j e^{z_j}}$$

连接到最大熵原理：当约束为期望值已知时，Softmax 是最大熵分布；结合交叉熵损失等价于最大化对数似然（MLE），有良好的概率理论支撑。

**数值稳定**：直接计算 $e^{z_i}$ 会在 $z_i$ 很大时溢出 → 实践中用 **Stable Softmax**：先减最大值 $c = \max_j z_j$，即 $\hat{p}_i = e^{z_i - c} / \sum_j e^{z_j - c}$，数学等价但数值无溢出。',
   null, null, '["PyTorch 的 `F.cross_entropy` 内部等价于 LogSoftmax + NLLLoss（数值稳定）。**不要**先手动 softmax 再喂给 NLLLoss——NLLLoss 直接把输入当 log-prob 取负求均值，若输入是概率（非 log 域），loss 和梯度都会错误。正确做法：直接 `F.cross_entropy(logits, labels)`，不需要手动 softmax。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q14","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000092', '什么是混合精度训练（Mixed Precision Training）？为什么机器人训练常用？', 'eaq-v01-q15', 'knowledge', 'medium', '**混合精度**：权重存 FP32，前向/反向计算用 FP16（或 BF16），梯度更新在 FP32 主权重上进行。',
   '**混合精度**：权重存 FP32，前向/反向计算用 FP16（或 BF16），梯度更新在 FP32 主权重上进行。', '**混合精度**：权重存 FP32，前向/反向计算用 FP16（或 BF16），梯度更新在 FP32 主权重上进行。

**关键技术**：① **Loss Scaling**：FP16 精度低，微小梯度下溢 → 先把 loss 乘以大系数，计算梯度后再除回；② **Master Weights**：维护 FP32 副本保证更新精度。

**好处**：① FP16 显存占用约为 FP32 的 1/2，允许更大 batch / 更多序列帧；② Tensor Core 加速，速度提升 2-3×；③ VLA 模型（7B+）几乎必须用混合精度才能在单机跑。

**BF16 vs FP16**：BF16 指数位更宽（不易溢出），训练稳定性优于 FP16，A100/H100 首选 BF16，不需 loss scaling。',
   null, null, '["FP16 推理不等于 INT8 量化", "量化是进一步压缩权重到整数，精度/速度权衡更极端。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q15","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000093', 'Flash Attention 解决了什么问题？核心思路是什么？', 'eaq-v01-q16', 'knowledge', 'hard', '**问题**：标准 Self-Attention 的 $O(n^2)$ 注意力矩阵（$n \times n$）必须写回 HBM（高带宽显存），内存带宽是瓶颈，而不是计算本身。',
   '**问题**：标准 Self-Attention 的 $O(n^2)$ 注意力矩阵（$n \times n$）必须写回 HBM（高带宽显存），内存带宽是瓶颈，而不是计算本身。对长序列（n=4096+）显存 OOM 且极慢。', '**问题**：标准 Self-Attention 的 $O(n^2)$ 注意力矩阵（$n \times n$）必须写回 HBM（高带宽显存），内存带宽是瓶颈，而不是计算本身。对长序列（n=4096+）显存 OOM 且极慢。

**核心思路（IO-aware）**：① **Tiling**：把 $Q, K, V$ 分块，每块完整在 SRAM（共享内存，快但小）内完成 attention 计算，避免反复读写 HBM；② **Online softmax**：用 log-sum-exp trick 做数值稳定的分块 softmax，无需等整行算完；③ 不存中间 $n \times n$ 矩阵（只存最终输出和反传所需的 $\log$-sum），显存从 $O(n^2)$ 降到 $O(n)$。

**结果**：速度 2-4×，显存 5-20× 节省，数学等价（无近似）。Flash Attention 2/3 进一步优化并行度。',
   null, null, '["Flash Attention 是精确计算，不是近似——不同于 Linformer/Performer 的低秩近似", "结果与标准实现完全相同。"]'::jsonb, null, 8, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q16","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000094', 'ViT（Vision Transformer）与 CNN 的本质区别是什么？在机器人视觉中各有什么优劣？', 'eaq-v01-q18', 'knowledge', 'medium', '| | ViT | CNN |',
   '| | ViT | CNN |
|---|---|---|
| 感受野 | 全局（每层 token 互相 attend） | 局部（逐层扩大） |
| 归纳偏置 | 弱（无平移等变性假设） | 强（平移等变、局部性） |
| 参数效率 | 数据少时差（需大量数据弥补归纳偏置缺失） | 数据少时好 |
| 可扩展性 | 强（patch 数量可变、序列建模自然） | 弱（固定感受野，改分辨率麻烦） |', '| | ViT | CNN |
|---|---|---|
| 感受野 | 全局（每层 token 互相 attend） | 局部（逐层扩大） |
| 归纳偏置 | 弱（无平移等变性假设） | 强（平移等变、局部性） |
| 参数效率 | 数据少时差（需大量数据弥补归纳偏置缺失） | 数据少时好 |
| 可扩展性 | 强（patch 数量可变、序列建模自然） | 弱（固定感受野，改分辨率麻烦） |

**机器人视觉**：
- **ViT 优势**：抓全局空间关系（末端 vs 目标位置远处相关），适合 VLA（视觉 + 语言 + 动作联合建模）；SigLIP / DINOv2 预训练的 ViT 在 OpenVLA 表现超越 CLIP-only；
- **CNN 优势**：小数据集（真机 50 demos）、实时推理（低延迟）；局部纹理/接触检测（细粒度操作）。
- 实务：VLA 主流用 ViT 作视觉 backbone + Transformer LM；实时控制头（非语言部分）可用小 CNN。',
   null, null, '["DINOv2 虽是 ViT，但自监督预训练让它比监督 ViT 更有空间几何感", "不要混淆预训练方式和架构选择。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q18","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000095', '训练集/验证集/测试集的划分原则是什么？数据泄露是什么？', 'eaq-v01-q19', 'knowledge', 'easy', '**划分原则**。',
   '**划分原则**：
- 训练集：用于学习参数
- 验证集（dev set）：用于超参调整（不能反复用来"选"模型后再报它的指标）
- 测试集：最终一次性评估，**严禁在调参中使用**', '**划分原则**：
- 训练集：用于学习参数
- 验证集（dev set）：用于超参调整（不能反复用来"选"模型后再报它的指标）
- 测试集：最终一次性评估，**严禁在调参中使用**

**常见比例**：数据充足时 60/20/20；数据少时用 k-fold（k=5/10）让每条数据都当过验证。

**数据泄露（Data Leakage）**：测试/验证集的信息提前"流入"训练，导致指标虚高。常见形式：① 归一化用全量（含测试集）的均值/方差；② 时序数据随机打乱（未来信息混入历史）；③ 图像增强用了测试集样本。

**机器人场景**：演示数据来自同一任务实例时，必须按**任务/场景**划分而非随机划帧（同场景的帧高度相关，随机划分严重高估泛化）。',
   null, null, '["sklearn 的 StandardScaler 必须在训练集 `.fit()`，测试集只 `.transform()`，用 `.fit_transform()` 对全量是数据泄露。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q19","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000096', '什么是 Knowledge Distillation（知识蒸馏）？在机器人策略压缩中怎么用？', 'eaq-v01-q20', 'knowledge', 'medium', '**知识蒸馏**：用大模型（Teacher）的 soft 输出（softmax 概率分布，含类间相似性信息）作为小模型（Student）的训练目标，而非 one-hot 标签。',
   '**知识蒸馏**：用大模型（Teacher）的 soft 输出（softmax 概率分布，含类间相似性信息）作为小模型（Student）的训练目标，而非 one-hot 标签。温度参数 $T > 1$ 让分布变软，信息量更多。', '**知识蒸馏**：用大模型（Teacher）的 soft 输出（softmax 概率分布，含类间相似性信息）作为小模型（Student）的训练目标，而非 one-hot 标签。温度参数 $T > 1$ 让分布变软，信息量更多。

**损失**：$L = \alpha L_{CE}(y, \hat{p}) + (1-\alpha) T^2 L_{KL}(\sigma(z_T/T), \sigma(z_S/T))$

**机器人策略压缩**：① VLA（7B）蒸馏到小策略网络（100M-300M），保留连续动作的分布知识；② 用大 diffusion policy 的多模态输出作为 soft target 训练快速 MLP 策略；③ 离线 RL 中 behavior cloning + teacher soft label 的组合。',
   null, null, '["蒸馏不是\"把大模型权重复制给小模型\"", "小模型容量不足时蒸馏也无法弥补", "温度 $T$ 太小退化回 one-hot，太大噪声过多。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"深度学习基础","qid":"Q20","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000097', '什么是 MDP（马尔可夫决策过程）？五元组分别是什么？', 'eaq-v01-q21', 'knowledge', 'easy', 'MDP 是强化学习的数学框架：$\langle S, A, P, R, \gamma \rangle$',
   'MDP 是强化学习的数学框架：$\langle S, A, P, R, \gamma \rangle$', 'MDP 是强化学习的数学框架：$\langle S, A, P, R, \gamma \rangle$

- $S$：状态空间（机器人关节角度、视觉观测等）
- $A$：动作空间（连续关节速度/位置，或离散动作）
- $P(s'' \mid s, a)$：状态转移概率（环境动力学）
- $R(s, a, s'')$：即时奖励函数
- $\gamma \in [0,1)$：折扣因子，权衡即时 vs 长期奖励

**Markov 性质**：$P(s_{t+1} \mid s_t, a_t, s_{<t}) = P(s_{t+1} \mid s_t, a_t)$，下一状态只依赖当前状态和动作，与历史无关。

**机器人现实**：几乎都是 POMDP（观测不完整），但以 MDP 作近似或用历史帧 stack 来还原 Markov 性。',
   null, null, '["Markov 性是对**状态**的假设，不是对**观测**的假设", "如果状态包含足够历史信息（如 RNN 隐状态），POMDP 也可被 MDP 框架处理。"]'::jsonb, null, 3, false, true, 14, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q21","freq_label":"🔥×14"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000098', 'Bellman 方程是什么？V 和 Q 的关系？', 'eaq-v01-q22', 'knowledge', 'easy', '**Bellman 期望方程**（某策略 $\pi$ 下）。',
   '**Bellman 期望方程**（某策略 $\pi$ 下）：', '**Bellman 期望方程**（某策略 $\pi$ 下）：

$$V^\pi(s) = \sum_a \pi(a \mid s) \sum_{s''} P(s'' \mid s,a)[R(s,a,s'') + \gamma V^\pi(s'')]$$

$$Q^\pi(s, a) = \sum_{s''} P(s'' \mid s,a)[R(s,a,s'') + \gamma \sum_{a''} \pi(a'' \mid s'') Q^\pi(s'', a'')]$$

**关系**：$V^\pi(s) = \sum_a \pi(a \mid s) Q^\pi(s,a)$（对动作的加权期望）；$Q^\pi(s,a) = R + \gamma \mathbb{E}_{s''}[V^\pi(s'')]$（即时奖励 + 折扣后继状态值）。

**最优 Bellman**：$V^*(s) = \max_a Q^*(s,a)$；$Q^*(s,a) = R + \gamma \mathbb{E}_{s''}[\max_{a''} Q^*(s'', a'')]$。',
   null, null, '["Bellman 方程是递推定义（自洽方程），不是显式解", "Q-learning 正是通过 TD 更新迭代逼近 $Q^*$，无需知道 $P$。"]'::jsonb, null, 3, false, true, 13, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q22","freq_label":"🔥×13"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000099', 'Q-learning 的更新公式是什么？DQN 相比 Q-learning 加了哪些改进？', 'eaq-v01-q23', 'knowledge', 'easy', '**Q-learning 更新**（off-policy TD）。',
   '**Q-learning 更新**（off-policy TD）：', '**Q-learning 更新**（off-policy TD）：

$$Q(s_t, a_t) \leftarrow Q(s_t, a_t) + \alpha \underbrace{\big[r_t + \gamma \max_{a''} Q(s_{t+1}, a'') - Q(s_t, a_t)\big]}_{\text{TD error}}$$

**DQN 三大改进**：
1. **Experience Replay**：将 $(s, a, r, s'')$ 存入 replay buffer，随机采样打破样本相关性，提升数据效率
2. **Target Network**：用参数 $\theta^-$（定期硬拷贝或软更新）计算 $\max_{a''} Q(s'', a''; \theta^-)$，稳定训练目标（否则目标也在变动 → 振荡）
3. **函数近似（神经网络）**：用 CNN 直接从像素输入端到端估计 $Q$ 值',
   null, null, '["Q-learning 是 off-policy（目标用 max，不管行为策略）", "SARSA 是 on-policy（用实际选择的 $a''$）", "区别在 TD target 的动作来源。"]'::jsonb, null, 3, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q23","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000100', 'Monte Carlo 和 TD 方法的区别？各自适合什么情况？', 'eaq-v01-q24', 'knowledge', 'easy', '| | Monte Carlo (MC) | TD (Temporal Difference) |',
   '| | Monte Carlo (MC) | TD (Temporal Difference) |
|---|---|---|
| 更新时机 | Episode 结束后（用完整回报 $G_t$） | 每步（用下一状态估计 bootstrap） |
| 方差 | 高（完整轨迹噪声叠加） | 低 |
| 偏差 | 无偏（真实样本 return） | 有偏（bootstrap 引入估计误差） |
| 适合场景 | 回合制、非 Markov 环境 | 持续交互、长 episode |', '| | Monte Carlo (MC) | TD (Temporal Difference) |
|---|---|---|
| 更新时机 | Episode 结束后（用完整回报 $G_t$） | 每步（用下一状态估计 bootstrap） |
| 方差 | 高（完整轨迹噪声叠加） | 低 |
| 偏差 | 无偏（真实样本 return） | 有偏（bootstrap 引入估计误差） |
| 适合场景 | 回合制、非 Markov 环境 | 持续交互、长 episode |

**联系**：TD($\lambda$) 通过 $\lambda$ 在 MC 和 TD 之间插值；GAE 是 TD($\lambda$) 在 advantage 估计中的应用（PPO 的核心组件）。',
   null, null, '["MC 不需要 Markov 假设（用真实 return），但 variance 太高、数据利用率低", "TD 需要 bootstrap（依赖 Markov 性），但在线学习效率高。机器人长任务（500步以上）用 TD 而非 MC。"]'::jsonb, null, 3, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q24","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000101', '策略梯度（Policy Gradient）的核心思想是什么？REINFORCE 算法怎么工作？', 'eaq-v01-q25', 'knowledge', 'easy', '**核心**：直接参数化策略 $\pi_\theta(a \mid s)$，对 $J(\theta) = \mathbb{E}_\tau[G_0]$ 做梯度上升。',
   '**核心**：直接参数化策略 $\pi_\theta(a \mid s)$，对 $J(\theta) = \mathbb{E}_\tau[G_0]$ 做梯度上升。策略梯度定理：$\nabla J = \mathbb{E}[\sum_t \nabla \log \pi_\theta(a_t|s_t) \cdot G_t]$。', '**核心**：直接参数化策略 $\pi_\theta(a \mid s)$，对 $J(\theta) = \mathbb{E}_\tau[G_0]$ 做梯度上升。策略梯度定理：$\nabla J = \mathbb{E}[\sum_t \nabla \log \pi_\theta(a_t|s_t) \cdot G_t]$。

**REINFORCE**：① 采样完整轨迹；② 计算 $G_t = \sum_{k \geq t}\gamma^{k-t}r_k$；③ 用 $\nabla \log \pi_\theta \cdot G_t$ 更新参数（on-policy）。

**直觉**：$G_t$ 大 → 增大 $a_t$ 的概率；$G_t$ 小 → 减小概率。等同于"奖励加权的最大似然"。',
   null, null, '["REINFORCE 方差极高（$G_t$ 是完整轨迹的累积奖励，噪声大）→ 引入 baseline $b(s_t) = V(s_t)$，用 $A_t = G_t - V(s_t)$ 替代 $G_t$。Baseline 不改变期望梯度（$\\mathbb{E}[\\nabla \\log \\pi \\cdot b] = 0$），但大幅降方差。这就是 Actor-Critic 的起点。"]'::jsonb, null, 3, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q25","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000102', 'Actor-Critic 是什么？为什么它结合了 PG 和值函数估计？', 'eaq-v01-q26', 'knowledge', 'easy', '**Actor-Critic** = Actor（策略网络 $\pi_\theta$）+ Critic（值函数估计器 $V_\phi$ 或 $Q_\phi$）。',
   '**Actor-Critic** = Actor（策略网络 $\pi_\theta$）+ Critic（值函数估计器 $V_\phi$ 或 $Q_\phi$）。', '**Actor-Critic** = Actor（策略网络 $\pi_\theta$）+ Critic（值函数估计器 $V_\phi$ 或 $Q_\phi$）。

**Actor**：用策略梯度更新，目标是选更好的动作；
**Critic**：用 TD 误差训练，目标是准确估计 $V(s)$ 或 $Q(s,a)$；
**Critic 作 baseline**：$A_t = r_t + \gamma V_\phi(s_{t+1}) - V_\phi(s_t)$（TD advantage）直接作 Actor 的加权项，替代 REINFORCE 中的高方差 $G_t$。

**优势**：① 比纯 MC（REINFORCE）方差低（用 $A_t$）；② 比纯值方法（DQN）可以处理连续动作；③ 在线学习（不需要等 episode 结束）。

**延伸路径**：A2C（同步）→ A3C（异步）→ PPO（clip 截断比例）→ SAC（max-entropy AC）。',
   null, null, '["Actor 和 Critic 可以共享主干（节省参数），也可以完全分开", "机器人长程任务通常分开，防止两个目标梯度互相干扰。"]'::jsonb, null, 3, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q26","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000103', '折扣因子 gamma 的作用是什么？设置过大/过小会怎样？', 'eaq-v01-q28', 'knowledge', 'easy', '$\gamma \in [0,1)$ 对未来奖励的权重指数衰减：$G_t = \sum_{k=0}^\infty \gamma^k r_{t+k}$。',
   '$\gamma \in [0,1)$ 对未来奖励的权重指数衰减：$G_t = \sum_{k=0}^\infty \gamma^k r_{t+k}$。', '$\gamma \in [0,1)$ 对未来奖励的权重指数衰减：$G_t = \sum_{k=0}^\infty \gamma^k r_{t+k}$。

**直觉**：① 数学上保证无限 horizon 的回报收敛（$\gamma < 1$）；② 语义上表示"对未来不确定性的折价"，近期奖励更可靠。

**$\gamma$ 太大（如 → 1）**：对遥远未来奖励权重高，bootstrap 误差远程传播，训练不稳定；长期规划强但 credit assignment 难（某奖励追溯很多步前的动作）。

**$\gamma$ 太小（如 → 0）**：只看即时奖励，变成贪心策略（myopic）；长程任务中错过关键延迟奖励。

**机器人取值**：通常 $\gamma \in [0.95, 0.99]$；稀疏奖励长程任务（200步以上）用 0.99；短程密集奖励（10步内）可用 0.95。',
   null, null, '["$\\gamma = 1$ 仅在有限 horizon + episode 一定结束的场景才可用", "无限 horizon 时 $\\gamma = 1$ 导致 return 不收敛。"]'::jsonb, null, 3, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q28","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000104', '什么是 Advantage 函数？它为什么比直接用 Q 值更好？', 'eaq-v01-q30', 'knowledge', 'medium', '**Advantage 函数**：$A^\pi(s, a) = Q^\pi(s, a) - V^\pi(s)$，表示在状态 $s$ 执行动作 $a$ 相对于"平均水平"的超额价值。',
   '**Advantage 函数**：$A^\pi(s, a) = Q^\pi(s, a) - V^\pi(s)$，表示在状态 $s$ 执行动作 $a$ 相对于"平均水平"的超额价值。', '**Advantage 函数**：$A^\pi(s, a) = Q^\pi(s, a) - V^\pi(s)$，表示在状态 $s$ 执行动作 $a$ 相对于"平均水平"的超额价值。

**为什么更好**：
- 纯用 $Q(s,a)$ 作 PG 的权重：量纲大（$Q$ 的绝对值可能很大），方差高；
- $A(s,a)$ 零中心化（某些动作正、某些负），梯度信号更清晰——好于平均的动作被强化，差于平均的被抑制；
- 方差显著降低（baseline = $V(s)$ 的效果）；
- PPO 的 clip 目标就是 $\hat{A}_t$，没有 advantage 就没有 PPO。

**GAE（广义优势估计）**：$\hat{A}_t^{\text{GAE}} = \sum_{l \geq 0} (\gamma\lambda)^l \delta_{t+l}$（TD 残差加权求和），$\lambda$ 在低方差 TD 和低偏差 MC 之间插值，实务 $\lambda \approx 0.95$。',
   null, null, '["理论上 $\\mathbb{E}_{a \\sim \\pi}[A^\\pi(s,a)] = 0$（对任意状态 $s$ 成立），但实践中 Critic 的 $V$ 是估计值，批量计算的 $\\hat{A}_t$ 不一定严格零均值", "对 mini-batch 内 advantage 做归一化（减均值除标准差）是常见 trick，可稳定训练但不等同于真实 advantage 值。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q30","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000105', '什么是 Reward Hacking？举一个机器人场景的例子。', 'eaq-v01-q34', 'knowledge', 'medium', '**Reward Hacking**：策略找到一种刷奖励但不完成真实任务目标的方式——最大化了代理奖励（proxy reward）但不是真实意图。',
   '**Reward Hacking**：策略找到一种刷奖励但不完成真实任务目标的方式——最大化了代理奖励（proxy reward）但不是真实意图。', '**Reward Hacking**：策略找到一种刷奖励但不完成真实任务目标的方式——最大化了代理奖励（proxy reward）但不是真实意图。

**机器人例子**：
- 任务：把物体放到目标位置；奖励函数：$r = -\|p_{ee} - p_{goal}\|$（末端接近目标）→ 策略学会用末端**压住**目标物体（距离为 0，奖励最大），而非"把物体放到目标位置"。
- 更极端：擦桌子任务，奖励用"摄像头亮度变化"衡量清洁程度 → 策略学会遮挡摄像头（最高变化）。

**根本原因**：奖励函数是真实目标的不完美代理；优化器（RL agent）总能找到"钻空子"路径。

**对策**：① Reward 设计时多场景验证（用 test 场景检查有无异常行为）；② RLHF（人类反馈）反复审查；③ Constrained RL（加硬约束）；④ 多奖励信号互相制衡。',
   null, null, '["Reward hacking 不是\"bug\"，是优化成功——只是目标函数写错了。调试时关键要看策略实际行为，而不只看奖励曲线。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"强化学习基础","qid":"Q34","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000106', '旋转矩阵、欧拉角、四元数三种姿态表示的区别和联系？', 'eaq-v01-q35', 'knowledge', 'easy', '| 表示 | 参数数 | 优点 | 缺点 |',
   '| 表示 | 参数数 | 优点 | 缺点 |
|---|---|---|---|
| 旋转矩阵 $R \in SO(3)$ | 9（实际 3 自由度） | 无奇异、组合简单（矩阵乘法） | 冗余参数，存储/传输大 |
| 欧拉角（roll/pitch/yaw） | 3 | 直观（人类可理解） | **万向节死锁**（Gimbal Lock），依赖轴顺序 |
| 四元数 $q = [w,x,y,z]$，$\|q\|=1$ | 4（实际 3 自由度） | 无奇异、插值平滑（SLERP）、计算高效 | 不直观，有双倍映射（$q$ 和 $-q$ 表示同一转） |', '| 表示 | 参数数 | 优点 | 缺点 |
|---|---|---|---|
| 旋转矩阵 $R \in SO(3)$ | 9（实际 3 自由度） | 无奇异、组合简单（矩阵乘法） | 冗余参数，存储/传输大 |
| 欧拉角（roll/pitch/yaw） | 3 | 直观（人类可理解） | **万向节死锁**（Gimbal Lock），依赖轴顺序 |
| 四元数 $q = [w,x,y,z]$，$\|q\|=1$ | 4（实际 3 自由度） | 无奇异、插值平滑（SLERP）、计算高效 | 不直观，有双倍映射（$q$ 和 $-q$ 表示同一转） |

**联系**：三者等价，可互相转换（旋转矩阵 ↔ 四元数 ↔ 轴角 ↔ 欧拉角）。

**机器人实践**：运动规划/插值用四元数；人机界面 / 调试显示用欧拉角；姿态矩阵运算用旋转矩阵；神经网络输出姿态通常用 6D 旋转表示（$R$ 的前两列）或四元数。',
   null, null, '["欧拉角的旋转顺序（ZYX vs XYZ vs ZYZ）不同结果完全不同——拿到欧拉角必须确认约定", "Gimbal Lock 发生在 pitch = ±90° 时 roll 和 yaw 轴重合。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q35","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000107', '齐次变换矩阵（Homogeneous Transformation Matrix）是什么？如何用它表示坐标系变换？', 'eaq-v01-q36', 'knowledge', 'easy', '**齐次变换矩阵** $T \in SE(3)$，将旋转 $R$ 和平移 $p$ 合并为 4×4 矩阵。',
   '**齐次变换矩阵** $T \in SE(3)$，将旋转 $R$ 和平移 $p$ 合并为 4×4 矩阵：', '**齐次变换矩阵** $T \in SE(3)$，将旋转 $R$ 和平移 $p$ 合并为 4×4 矩阵：

$$T = \begin{bmatrix} R_{3\times3} & p_{3\times1} \\ 0_{1\times3} & 1 \end{bmatrix}$$

**坐标变换**：若点在 frame B 中坐标为 $\tilde{q}_B = [x, y, z, 1]^\top$，在 frame A 中：$\tilde{q}_A = {}^A T_B \cdot \tilde{q}_B$。

**链式组合**：多个变换可直接矩阵连乘：${}^0 T_n = {}^0 T_1 \cdot {}^1 T_2 \cdots {}^{n-1} T_n$（正向运动学本质）。

**逆变换**：$T^{-1} = \begin{bmatrix} R^\top & -R^\top p \\ 0 & 1 \end{bmatrix}$，旋转部分取转置（正交矩阵性质）。',
   null, null, '["旋转矩阵的逆是其转置（$R^{-1} = R^\\top$），但整个齐次矩阵的逆**不是**直接转置 $T^\\top$（平移部分要另外处理）。"]'::jsonb, null, 3, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q36","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000108', 'D-H 参数法（Denavit-Hartenberg）是什么？四个参数各代表什么？', 'eaq-v01-q37', 'knowledge', 'easy', 'D-H 参数法是用**最少 4 个参数**描述相邻关节坐标系变换的标准化方法。',
   'D-H 参数法是用**最少 4 个参数**描述相邻关节坐标系变换的标准化方法：', 'D-H 参数法是用**最少 4 个参数**描述相邻关节坐标系变换的标准化方法：

| 参数 | 含义 | 变化/固定 |
|---|---|---|
| $\theta_i$（关节角） | 绕 $Z_{i-1}$ 轴的旋转角 | **旋转关节变量**（固定关节为常数）|
| $d_i$（连杆偏距） | 沿 $Z_{i-1}$ 轴的平移距离 | **移动关节变量**（旋转关节为常数）|
| $a_i$（连杆长度） | 沿 $X_i$ 轴的距离（$Z_{i-1}$ 到 $Z_i$ 的公垂线长） | 固定（几何参数）|
| $\alpha_i$（连杆扭转角） | 绕 $X_i$ 轴从 $Z_{i-1}$ 转到 $Z_i$ 的角度 | 固定（几何参数）|

**正运动学**：给定所有关节变量 $\theta_i$（或 $d_i$），连乘 $T_i$ 得末端位姿：${}^0 T_n = \prod_{i=1}^n {}^{i-1}T_i$。

**两种约定**：标准 D-H（Denavit-Hartenberg 原始约定，Spong 教材沿用） vs 改进 D-H（MDH / Craig）参数定义顺序略有不同，拿到参数表必须确认约定。',
   null, null, '["标准 D-H 每帧 $X_i$ 沿公垂线方向，并不是\"随便放\"", "如果机器人有平行或相交关节轴，D-H 坐标系有歧义，需额外约定。"]'::jsonb, null, 3, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q37","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000109', '逆运动学（IK）的解析解和数值解各有什么优劣？哪种更常用于 VLA 策略执行？', 'eaq-v01-q38', 'knowledge', 'easy', '**解析解（Analytical IK）**。',
   '**解析解（Analytical IK）**：
- 对特殊构型（如满足 Pieper 准则：3 轴交于一点的 6-DOF 机器人）可求闭式解；
- 优点：速度极快（毫秒级）、确定性强；
- 缺点：仅适用于特定构型，通用性差，解可能有多解需选优。', '**解析解（Analytical IK）**：
- 对特殊构型（如满足 Pieper 准则：3 轴交于一点的 6-DOF 机器人）可求闭式解；
- 优点：速度极快（毫秒级）、确定性强；
- 缺点：仅适用于特定构型，通用性差，解可能有多解需选优。

**数值解（Numerical IK）**：
- 基于雅可比矩阵的迭代法（梯度下降 / Newton-Raphson / Damped Least Squares）；
- 优点：通用（任意构型）、可加约束（关节限位、奇异回避）；
- 缺点：迭代耗时（ms 到 tens of ms），可能陷入局部最优，初值敏感。

**VLA 策略**：不同 VLA 的动作空间不同——OpenVLA 官方动作空间是**末端执行器 7 维增量**（$\Delta x, \Delta y, \Delta z, \Delta$roll, $\Delta$pitch, $\Delta$yaw + gripper），底层执行层需要 IK/OSC（操作空间控制）将其转换为关节指令。部分 VLA 直接输出关节角度，不需要 IK。**结论**：VLA 动作空间因模型而异，不能一概而论；但相比传统离线规划，VLA 的 IK 调用是实时嵌在控制循环中的。',
   null, null, '["7-DOF 冗余机械臂有无穷多 IK 解（冗余自由度），需加零空间运动（null space motion）约束来选择\"最优\"解（如避开奇异形位）。"]'::jsonb, null, 3, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q38","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000110', '雅可比矩阵（Jacobian）是什么？奇异性是怎么产生的？', 'eaq-v01-q39', 'knowledge', 'medium', '$J(\theta) \in \mathbb{R}^{6 \times n}$ 把关节速度映射到末端速度：$\dot{x} = J\dot{\theta}$。',
   '$J(\theta) \in \mathbb{R}^{6 \times n}$ 把关节速度映射到末端速度：$\dot{x} = J\dot{\theta}$。上 3 行线速度 $J_v$，下 3 行角速度 $J_\omega$。旋转关节 $i$：$J_v^{(i)} = z_{i-1} \times (p_n - p_{i-1})$，$J_\omega^{(i)} = z_{i-1}$。', '$J(\theta) \in \mathbb{R}^{6 \times n}$ 把关节速度映射到末端速度：$\dot{x} = J\dot{\theta}$。上 3 行线速度 $J_v$，下 3 行角速度 $J_\omega$。旋转关节 $i$：$J_v^{(i)} = z_{i-1} \times (p_n - p_{i-1})$，$J_\omega^{(i)} = z_{i-1}$。

**奇异性**：$J$ 行秩降低（不满秩）时某些末端运动方向不可达（或需无穷大关节速度）。典型：手腕三轴共线、连杆完全伸直。此时 Moore-Penrose 伪逆病态（满行秩情况下 $J^\dagger = J^\top(JJ^\top)^{-1}$）→ 关节速度爆炸。

**缓解**：① 阻尼最小二乘（DLS）：$J^\dagger_{dls} = J^\top(JJ^\top + \lambda I)^{-1}$，$\lambda$ 引入阻尼，用精度换稳定；② 路径规划提前绕开奇异形位；③ 控制层限速。',
   null, null, '["6-DOF 方阵 $J$ 直接取逆仅在满秩时有效", "7-DOF 冗余臂 $J \\in \\mathbb{R}^{6 \\times 7}$ 必须用伪逆，存在无穷多解，需加零空间约束来选优。"]'::jsonb, null, 5, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q39","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000111', 'PID 控制的三个参数各起什么作用？机器人关节 PID 调参时的典型问题？', 'eaq-v01-q40', 'knowledge', 'medium', '**PID**：$u(t) = K_P e(t) + K_I \int e \,dt + K_D \dot{e}(t)$，$e = q_{desired} - q_{actual}$（关节角误差）。',
   '**PID**：$u(t) = K_P e(t) + K_I \int e \,dt + K_D \dot{e}(t)$，$e = q_{desired} - q_{actual}$（关节角误差）。', '**PID**：$u(t) = K_P e(t) + K_I \int e \,dt + K_D \dot{e}(t)$，$e = q_{desired} - q_{actual}$（关节角误差）。

- **$K_P$（比例）**：误差大则控制量大；太大 → 震荡；太小 → 稳态误差大。
- **$K_I$（积分）**：消除稳态误差（gravity compensation 不完美时的偏置）；太大 → 积分饱和（windup），超调 + 慢恢复。
- **$K_D$（微分）**：阻尼，预测趋势提前减速；太大 → 对噪声极敏感（放大高频噪声）；关节位置传感器有噪声时慎用大 $K_D$。

**机器人典型问题**：
- 负载变化（搬不同重物）→ 有效惯量变化 → 固定 PID 参数可能失稳，需自适应控制或惯量辨识。
- 重力补偿不完整 → 靠 $K_I$ 修正，易积分饱和。
- 柔性关节（弹性）→ 纯 PID 可能激发弹性振动，需加低通滤波或更高级控制（如弹性关节模型控制）。',
   null, null, '["PID 是线性控制器，机器人动力学非线性（惯量、离心力、科里奥利力、重力随形位变化）", "PID 在工作点附近可用，大范围运动需非线性补偿或现代控制。"]'::jsonb, null, 5, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q40","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000112', '关节空间控制和任务空间（笛卡尔）控制的区别？各适合什么场景？', 'eaq-v01-q41', 'knowledge', 'medium', '**关节空间控制**：控制目标是关节角度/速度 $\theta$，PD 控制在关节空间运行，无需 IK。',
   '- **关节空间控制**：控制目标是关节角度/速度 $\theta$，PD 控制在关节空间运行，无需 IK。**优点**：简单稳定、无奇异问题；**缺点**：末端路径不直（关节线性插值 ≠ 笛卡尔直线）。
- **任务空间（Cartesian）控制**：控制目标是末端位姿 $x$，需通过 Jacobian 或 IK 转换到关节空间。**优点**：末端路径可控（直线/圆弧）、易与视觉感知对接；**缺点**：奇异点附近不稳定，需 IK 计算开销。', '- **关节空间控制**：控制目标是关节角度/速度 $\theta$，PD 控制在关节空间运行，无需 IK。**优点**：简单稳定、无奇异问题；**缺点**：末端路径不直（关节线性插值 ≠ 笛卡尔直线）。
- **任务空间（Cartesian）控制**：控制目标是末端位姿 $x$，需通过 Jacobian 或 IK 转换到关节空间。**优点**：末端路径可控（直线/圆弧）、易与视觉感知对接；**缺点**：奇异点附近不稳定，需 IK 计算开销。

**适合场景**：
- Pick-and-place、点到点运动 → 关节空间够用
- 精密装配（要求末端走直线）、力控 → 任务空间
- VLA 策略输出 → 因模型而异（OpenVLA 为末端增量、需底层 IK；部分模型直接输出关节角）',
   null, null, '["\"笛卡尔控制\"不等于\"不需要 IK\"——只是 IK 在每个控制循环内完成（数值迭代），且控制频率要够高（>100 Hz）才能近实时。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q41","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000113', '阻抗控制（Impedance Control）和力控制的区别？具身机器人什么时候用力控？', 'eaq-v01-q42', 'knowledge', 'medium', '**纯位置控制**：仅跟踪位置目标，接触时力无法限制（硬接触易损伤）。',
   '- **纯位置控制**：仅跟踪位置目标，接触时力无法限制（硬接触易损伤）。
- **力控制（Force Control）**：直接控制接触力，需要力/力矩传感器或力矩估计；精度高但刚性差（力变化时位置漂移）。
- **阻抗控制**：在期望位置轨迹上叠加弹簧-阻尼模型 $F = K(x_d - x) + B(\dot{x}_d - \dot{x})$，**将力偏差转化为位置偏差允许**；不需要显式力控制器，只要能控制关节力矩或末端位置。', '- **纯位置控制**：仅跟踪位置目标，接触时力无法限制（硬接触易损伤）。
- **力控制（Force Control）**：直接控制接触力，需要力/力矩传感器或力矩估计；精度高但刚性差（力变化时位置漂移）。
- **阻抗控制**：在期望位置轨迹上叠加弹簧-阻尼模型 $F = K(x_d - x) + B(\dot{x}_d - \dot{x})$，**将力偏差转化为位置偏差允许**；不需要显式力控制器，只要能控制关节力矩或末端位置。

**具身机器人使用场景**：
- 装配（轴孔配合/插拔连接器）：位置不确定时力控防止过载 → **阻抗/力控**
- 拧螺丝/研磨打磨：需要恒定接触力 → **力控**
- 普通 pick-and-place（抓轻物）：位置控制即可
- 人机协作（安全要求）：阻抗控制让机器人"柔软"，碰到人自动退让',
   null, null, '["阻抗控制中 $K$（刚度）高 ≈ 位置控制", "$K$ 低 ≈ 力控", "调 $K/B$ 是在\"硬度\"和\"力控精度\"间权衡，不是随意设。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q42","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000114', '什么是工作空间（Workspace）？奇异形位和工作空间边界有什么关系？', 'eaq-v01-q43', 'knowledge', 'easy', '**工作空间**：机器人末端执行器能到达的所有**位置**集合（注：完整意义的可达性还需考虑姿态约束）。',
   '**工作空间**：机器人末端执行器能到达的所有**位置**集合（注：完整意义的可达性还需考虑姿态约束）。分：
- **可达工作空间**（Reachable）：至少以某一姿态能到达的位置集合；
- **灵巧工作空间**（Dexterous）：以任意姿态都能到达的位置集合（往往小得多）。', '**工作空间**：机器人末端执行器能到达的所有**位置**集合（注：完整意义的可达性还需考虑姿态约束）。分：
- **可达工作空间**（Reachable）：至少以某一姿态能到达的位置集合；
- **灵巧工作空间**（Dexterous）：以任意姿态都能到达的位置集合（往往小得多）。

**与奇异形位的关系**：位置工作空间**边界**通常恰好是奇异形位（完全伸展或极度折叠）——此时 Jacobian 降秩，末端某方向运动需无穷大关节速度。内奇异点（如腕部奇异）在工作空间内部也可能存在。

**机器人设计取舍**：7-DOF 冗余臂扩大灵巧工作空间 + 提供零空间运动绕奇异，但增加控制复杂度。',
   null, null, '["灵巧工作空间既受位置限制又受姿态约束，两者分开分析", "可达工作空间描述的是位置可达性，不自动保证任意姿态下的可达性。"]'::jsonb, null, 3, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"机器人学基础","qid":"Q43","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000115', '手撕 scaled dot-product attention', 'eaq-v01-h01', 'coding', 'medium', '`Attention(Q,K,V) = softmax(QK^T/√d_k) V` 公式；',
   '`Attention(Q,K,V) = softmax(QK^T/√d_k) V` 公式；为何要除 √d_k（防 softmax 饱和、梯度消失）。', '**考察点**：`Attention(Q,K,V) = softmax(QK^T/√d_k) V` 公式；为何要除 √d_k（防 softmax 饱和、梯度消失）。

**实现**：

```python
import math
import torch
import torch.nn.functional as F

def sdpa(q, k, v, mask=None):
    # q,k,v: [B, ..., L, d_k]；mask: True 处屏蔽
    d_k = q.size(-1)
    scores = q @ k.transpose(-2, -1) / math.sqrt(d_k)  # 缩放避免 softmax 饱和
    if mask is not None:
        scores = scores.masked_fill(mask, float(''-inf''))  # 加性 -inf 而非乘 0
    attn = F.softmax(scores, dim=-1)
    return attn @ v  # [B, ..., L, d_v]
```',
   null, null, '["忘 transpose", "scale 用 `d_k` 而非 `√d_k`", "mask 用乘性 0/1（softmax 后非 0 项不为 0）。"]'::jsonb, null, 10, true, true, 15, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H01","freq_label":"🔥×15"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000116', '手撕 multi-head attention', 'eaq-v01-h02', 'coding', 'medium', '拆头/合头流程；',
   '拆头/合头流程；4 个 Linear（W_q/W_k/W_v/W_o）；mask 广播形状。', '**考察点**：拆头/合头流程；4 个 Linear（W_q/W_k/W_v/W_o）；mask 广播形状。

**实现**：

```python
import math
import torch.nn as nn
import torch.nn.functional as F

class MHA(nn.Module):
    def __init__(self, d, h):
        super().__init__()
        assert d % h == 0  # 必须整除
        self.h, self.d_k = h, d // h
        self.qkv = nn.Linear(d, 3 * d)
        self.o = nn.Linear(d, d)

    def forward(self, x, mask=None):
        B, L, _ = x.shape
        q, k, v = self.qkv(x).chunk(3, dim=-1)
        # 拆头：[B, L, d] -> [B, h, L, d_k]
        q, k, v = [t.view(B, L, self.h, self.d_k).transpose(1, 2) for t in (q, k, v)]
        scores = q @ k.transpose(-2, -1) / math.sqrt(self.d_k)
        if mask is not None:  # mask 形状 [B,1,1,L] 自动广播
            scores = scores.masked_fill(mask, float(''-inf''))
        out = F.softmax(scores, -1) @ v
        # 合头：transpose 后必须 contiguous 才能 view
        out = out.transpose(1, 2).contiguous().view(B, L, -1)
        return self.o(out)
```',
   null, null, '["`d % h != 0` 维度错", "忘 `contiguous()` 直接 `view()` 报 stride 错", "mask 广播形状不对。"]'::jsonb, null, 10, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H02","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000117', '手撕 sinusoidal positional encoding', 'eaq-v01-h03', 'coding', 'easy', '`PE(pos,2i)=sin(pos/10000^(2i/d))`、`PE(pos,2i+1)=cos(...)`；',
   '`PE(pos,2i)=sin(pos/10000^(2i/d))`、`PE(pos,2i+1)=cos(...)`；相对位置可由线性变换编码。', '**考察点**：`PE(pos,2i)=sin(pos/10000^(2i/d))`、`PE(pos,2i+1)=cos(...)`；相对位置可由线性变换编码。

**实现**：

```python
import math
import torch
import torch.nn as nn

class SinPE(nn.Module):
    def __init__(self, d, max_len=5000):
        super().__init__()
        assert d % 2 == 0, "d 必须偶数；奇数会让 sin/cos 列数不匹配"
        pe = torch.zeros(max_len, d)
        pos = torch.arange(max_len).unsqueeze(1).float()
        # 用 exp(log) 形式避免直接做 10000^(2i/d) 的大幂溢出
        div = torch.exp(torch.arange(0, d, 2) * (-math.log(10000.0) / d))
        pe[:, 0::2] = torch.sin(pos * div)  # 偶数列 sin
        pe[:, 1::2] = torch.cos(pos * div)  # 奇数列 cos
        self.register_buffer(''pe'', pe)  # 不参与梯度

    def forward(self, x):  # x: [B, L, d]
        return x + self.pe[:x.size(1)]
```',
   null, null, '["d 为奇数时切片错", "忘 `register_buffer` 导致每次重算 & 设备不同步", "与 token embedding 维度不齐。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H03","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000118', '手撕 LayerNorm', 'eaq-v01-h04', 'coding', 'easy', '沿最后特征维 norm；',
   '沿最后特征维 norm；γ/β 形状等于 `normalized_shape`；LN 不依赖 batch，batch=1 也稳（vs BN）。', '**考察点**：沿最后特征维 norm；γ/β 形状等于 `normalized_shape`；LN 不依赖 batch，batch=1 也稳（vs BN）。

**实现**：

```python
import torch
import torch.nn as nn

class LayerNorm(nn.Module):
    def __init__(self, d, eps=1e-5):
        super().__init__()
        self.gamma = nn.Parameter(torch.ones(d))
        self.beta = nn.Parameter(torch.zeros(d))
        self.eps = eps

    def forward(self, x):  # x: [..., d]
        mean = x.mean(-1, keepdim=True)
        # 用有偏方差 (unbiased=False)，与 PyTorch nn.LayerNorm 一致
        var = x.var(-1, keepdim=True, unbiased=False)
        return (x - mean) / torch.sqrt(var + self.eps) * self.gamma + self.beta
```',
   null, null, '["var 写成 std", "忘 `eps` 导致除零", "用 `unbiased=True`（默认）与官方实现差异", "与 BN 的归一化维度记混。"]'::jsonb, null, 10, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H04","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000119', '手撕 RMSNorm', 'eaq-v01-h05', 'coding', 'easy', '与 LN 的区别（去掉减均值与 β，只做 re-scale）；',
   '与 LN 的区别（去掉减均值与 β，只做 re-scale）；LLaMA / Mistral / π0 为何选 RMSNorm。', '**考察点**：与 LN 的区别（去掉减均值与 β，只做 re-scale）；LLaMA / Mistral / π0 为何选 RMSNorm。

**实现**：

```python
import torch
import torch.nn as nn

class RMSNorm(nn.Module):
    def __init__(self, d, eps=1e-6):
        super().__init__()
        self.gamma = nn.Parameter(torch.ones(d))
        self.eps = eps

    def forward(self, x):  # x: [..., d]
        # 不减均值，只用平方均值开方做 re-scale；省一次减法
        rms = torch.sqrt(x.pow(2).mean(-1, keepdim=True) + self.eps)
        return x / rms * self.gamma
```',
   null, null, '["还减 mean（变回 LN）", "忘 `keepdim` 导致广播错", "无 β 但实现里加上（破坏 RMSNorm 定义）。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H05","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000120', '手撕 BatchNorm（区分训练 vs 推理）', 'eaq-v01-h06', 'coding', 'medium', 'train 用 mini-batch 统计 + 滑动平均更新 running；',
   'train 用 mini-batch 统计 + 滑动平均更新 running；eval 用 running；BN 在 batch=1 失效。', '**考察点**：train 用 mini-batch 统计 + 滑动平均更新 running；eval 用 running；BN 在 batch=1 失效。

**实现**：

```python
import torch
import torch.nn as nn

class BatchNorm2d(nn.Module):
    def __init__(self, C, eps=1e-5, momentum=0.1):
        super().__init__()
        self.gamma = nn.Parameter(torch.ones(C))
        self.beta = nn.Parameter(torch.zeros(C))
        # running 用 buffer 不参与梯度；momentum 0.1 = 新值占 0.1
        self.register_buffer(''running_mean'', torch.zeros(C))
        self.register_buffer(''running_var'', torch.ones(C))
        self.eps, self.m = eps, momentum

    def forward(self, x):  # x: [N, C, H, W]
        if self.training:
            mean = x.mean(dim=(0, 2, 3))           # 沿 N+spatial
            var = x.var(dim=(0, 2, 3), unbiased=False)
            # in-place 更新 running（detach 防梯度回传）
            self.running_mean.mul_(1 - self.m).add_(self.m * mean.detach())
            self.running_var.mul_(1 - self.m).add_(self.m * var.detach())
        else:
            mean, var = self.running_mean, self.running_var
        x = (x - mean[None, :, None, None]) / torch.sqrt(var[None, :, None, None] + self.eps)
        return x * self.gamma[None, :, None, None] + self.beta[None, :, None, None]
```',
   null, null, '["忘 `model.eval()` 导致推理还更新", "PyTorch 与 TF 的 `momentum` 方向相反", "batch=1 且 H·W=1 时 var=0 训练崩溃。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H06","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000121', '手撕 Bellman 方程（V/Q/Advantage 三个版本）', 'eaq-v01-h07', 'coding', 'medium', '期望 vs 最优方程；',
   '期望 vs 最优方程；Q-learning 用 max（off-policy）/ SARSA 不用 max（on-policy）；`done` 截断 bootstrap。', '**考察点**：期望 vs 最优方程；Q-learning 用 max（off-policy）/ SARSA 不用 max（on-policy）；`done` 截断 bootstrap。

**实现**：

```python
import numpy as np

# 期望方程 V^π：策略评估一步迭代
def bellman_expect(V, pi, P, R, gamma=0.99):
    # P[s,a,s'']: 转移概率；R[s,a]: 即时回报；pi[s,a]: 策略
    Q = R + gamma * (P * V[None, None, :]).sum(-1)  # E_{s''}[R + γV(s'')]
    return (pi * Q).sum(-1)  # 沿 a 加权 -> V[s]

# 最优方程 V*：值迭代一步
def bellman_optimal(V, P, R, gamma=0.99):
    Q = R + gamma * (P * V[None, None, :]).sum(-1)
    return Q.max(-1)  # 把 Σ_a π 换成 max_a

# Q-learning TD 目标（带 done 截断）
def q_target(r, q_next, done, gamma=0.99):
    # 终止时 V(s_T)=0，必须乘 (1-done) 截断 bootstrap
    return r + gamma * q_next.max(-1) * (1.0 - done)

# Advantage：A(s,a) = Q(s,a) - V(s)
def advantage(Q, V):
    return Q - V[:, None]  # 沿动作维广播
```',
   null, null, '["把期望与最优混", "γ 设 1 → 长 horizon 不收敛", "`done` 不截断导致跨 episode bootstrap。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H07","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000122', '手撕 REINFORCE / Policy Gradient 推导', 'eaq-v01-h08', 'coding', 'medium', '`∇J(θ) = E[∇log π(a|s)·G_t]`；',
   '`∇J(θ) = E[∇log π(a|s)·G_t]`；baseline 与动作无关 → 不引入 bias 但降方差。', '**考察点**：`∇J(θ) = E[∇log π(a|s)·G_t]`；baseline 与动作无关 → 不引入 bias 但降方差。

**实现**：

```python
import torch

def returns_to_go(rewards, gamma=0.99):
    # G_t = r_t + γG_{t+1}，必须从后向前算
    G, out = 0.0, []
    for r in reversed(rewards):
        G = r + gamma * G
        out.append(G)
    return torch.tensor(list(reversed(out)))

def reinforce_loss(log_probs, rewards, values=None, gamma=0.99):
    # log_probs: [T] 当前策略对所采动作的 log π(a|s)
    G = returns_to_go(rewards, gamma).to(log_probs.device)
    if values is not None:
        adv = (G - values).detach()  # baseline 须 detach，不让其进策略梯度
    else:
        adv = G
    # 最大化期望回报 -> loss 取负
    return -(log_probs * adv).mean()
```',
   null, null, '["忘负号（最大化）", "`G_t` 正向算（应反向）", "baseline 未 detach 导致梯度回灌", "γ=1 在长 episode 方差爆炸。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H08","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000123', '手撕高斯 KL 闭式（一维 & VAE 特例）', 'eaq-v01-h09', 'coding', 'medium', '`KL(N(μ1,σ1²)‖N(μ2,σ2²))` 闭式；',
   '`KL(N(μ1,σ1²)‖N(μ2,σ2²))` 闭式；VAE 中对 `N(0,I)` 的特例；用 `log_σ²` 参数化更稳。', '**考察点**：`KL(N(μ1,σ1²)‖N(μ2,σ2²))` 闭式；VAE 中对 `N(0,I)` 的特例；用 `log_σ²` 参数化更稳。

**实现**：

```python
import torch

def kl_gauss(mu1, logvar1, mu2, logvar2):
    # 对角高斯之间 KL；输入是 log(σ²) 而非 σ，数值稳定
    # KL = 0.5 * (log(σ2²/σ1²) + (σ1² + (μ1-μ2)²)/σ2² - 1)
    var1, var2 = logvar1.exp(), logvar2.exp()
    return 0.5 * ((logvar2 - logvar1) + (var1 + (mu1 - mu2).pow(2)) / var2 - 1).sum(-1)

def kl_to_std_normal(mu, logvar):
    # VAE 特例：q(z|x)=N(μ,σ²)，p(z)=N(0,I)
    # KL = 0.5 * Σ(μ² + σ² - 1 - log σ²)
    return 0.5 * (mu.pow(2) + logvar.exp() - 1 - logvar).sum(-1)
```',
   null, null, '["`log` 用 σ 还是 σ²（差一倍）", "维度 d 漏减", "用 σ 但模型实际输出 `log σ²`", "忘 sum 沿 latent 维。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H09","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000124', '手撕 VAE ELBO + 重参数化', 'eaq-v01-h10', 'coding', 'medium', '`ELBO = E_q[log p(x|z)] - KL(q(z|x)‖p(z))`；',
   '`ELBO = E_q[log p(x|z)] - KL(q(z|x)‖p(z))`；reparameterize 让梯度穿过采样。', '**考察点**：`ELBO = E_q[log p(x|z)] - KL(q(z|x)‖p(z))`；reparameterize 让梯度穿过采样。

**实现**：

```python
import torch
import torch.nn.functional as F

def reparameterize(mu, logvar):
    # z = μ + σ·ε，σ=exp(0.5·log_σ²)；ε 独立采样断开图，避免梯度断
    std = (0.5 * logvar).exp()
    eps = torch.randn_like(std)
    return mu + std * eps

def vae_loss(x, x_recon, mu, logvar, beta=1.0):
    # recon 对 [0,1] 图像用 BCE（logits 版本数值稳）
    recon = F.binary_cross_entropy_with_logits(x_recon, x, reduction=''sum'') / x.size(0)
    # KL(q‖N(0,I)) 闭式
    kl = 0.5 * (mu.pow(2) + logvar.exp() - 1 - logvar).sum(-1).mean()
    return recon + beta * kl
```',
   null, null, '["直接采样 `N(μ,σ)` 梯度断", "把 `log σ` 当 σ", "KL 符号错", "BCE 对已 sigmoid 的输出再用 `binary_cross_entropy_with_logits`。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"01","volume_title":"卷一 · 通识基础","section":"手撕代码","qid":"H10","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000125', '策略梯度定理是什么？为什么要减去 baseline？', 'eaq-v02-q02', 'knowledge', 'easy', '**策略梯度定理**：$\nabla_\theta J(\theta) = \mathbb{E}_{\tau \sim \pi_\theta}\!\left[\sum_t \nabla_\theta \log \pi_…',
   '**策略梯度定理**：$\nabla_\theta J(\theta) = \mathbb{E}_{\tau \sim \pi_\theta}\!\left[\sum_t \nabla_\theta \log \pi_\theta(a_t|s_t) \cdot G_t\right]$，其中 $G_t$ 是从时刻 $t$ 起的累积回报。', '**策略梯度定理**：$\nabla_\theta J(\theta) = \mathbb{E}_{\tau \sim \pi_\theta}\!\left[\sum_t \nabla_\theta \log \pi_\theta(a_t|s_t) \cdot G_t\right]$，其中 $G_t$ 是从时刻 $t$ 起的累积回报。

**为什么减 baseline**：$G_t$ 方差极大（随机轨迹可达 $\pm$几百），导致梯度噪声大、收敛慢。减去与动作无关的 baseline $b(s_t)$（常取 $V^\pi(s_t)$）后：
- **不影响期望**（$b$ 与动作无关，减去后梯度期望不变）
- **方差显著降低**：$G_t - V(s_t) = A_t$（优势函数），只保留"这个动作比平均好多少"的信号',
   null, null, '["baseline 必须与动作 $a_t$ 无关，否则会引入 bias", "用 $V(s_t)$ 作 baseline 是最常见选择。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"策略优化基础","qid":"Q02","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000126', 'Actor-Critic 框架是什么？与纯 Policy Gradient 的区别？', 'eaq-v02-q03', 'knowledge', 'easy', '**Actor-Critic (AC)** 同时维护两个网络。',
   '**Actor-Critic (AC)** 同时维护两个网络：
- **Actor**（策略网络）：$\pi_\theta(a|s)$，负责选动作；
- **Critic**（值函数网络）：$V_\phi(s)$ 或 $Q_\phi(s,a)$，负责评估动作好坏。', '**Actor-Critic (AC)** 同时维护两个网络：
- **Actor**（策略网络）：$\pi_\theta(a|s)$，负责选动作；
- **Critic**（值函数网络）：$V_\phi(s)$ 或 $Q_\phi(s,a)$，负责评估动作好坏。

Actor 用 Critic 的输出（advantage 或 TD 误差）代替 MC 累积回报 $G_t$ 来更新，**把 baseline 从 V 变成实时 TD 估计**，大幅降低方差。

**vs 纯 PG（REINFORCE）**：
- REINFORCE 需等轨迹结束才能计算 $G_t$，高方差、慢收敛；
- AC 可在线（每步）更新，方差更低，但 Critic 引入 bias（若 $V_\phi$ 估不准）。',
   null, null, '["AC 的\"两网络\"说法是概念层面", "实际实现中 Actor 和 Critic 常共享前几层特征，只在输出头分叉。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"策略优化基础","qid":"Q03","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000127', 'A3C 和 A2C 的区别？为什么 A3C 提出时被认为是突破？', 'eaq-v02-q05', 'knowledge', 'medium', '**A3C（Asynchronous Advantage Actor-Critic, 2016）**：多个**异步** worker 各自与独立环境交互，将梯度推送给全局网络，不需要经验回放；',
   '- **A3C（Asynchronous Advantage Actor-Critic, 2016）**：多个**异步** worker 各自与独立环境交互，将梯度推送给全局网络，不需要经验回放；去相关化的异步更新相当于天然正则。DeepMind 原作在 CPU 集群上效果极好。
- **A2C**：**同步**版本，等所有 worker 完成一批再统一更新；实现更简单，在 GPU 上 batch 更友好，实际性能常与 A3C 持平或略强。', '- **A3C（Asynchronous Advantage Actor-Critic, 2016）**：多个**异步** worker 各自与独立环境交互，将梯度推送给全局网络，不需要经验回放；去相关化的异步更新相当于天然正则。DeepMind 原作在 CPU 集群上效果极好。
- **A2C**：**同步**版本，等所有 worker 完成一批再统一更新；实现更简单，在 GPU 上 batch 更友好，实际性能常与 A3C 持平或略强。

**A3C 突破点**：① 证明异步并行可替代经验回放去相关化；② 无 replay buffer 降低内存；③ on-policy 不需要重要性采样。

**当前地位**：A3C/A2C 已基本被 PPO 取代，但仍是理解 Actor-Critic 并行训练的经典范例。',
   null, null, '["A3C 不是 off-policy，仍是 on-policy", "它的\"异步\"指的是数据收集异步，不是说能复用旧数据。"]'::jsonb, null, 5, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"策略优化基础","qid":"Q05","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000128', 'TD 误差（TD error）是什么？和 Bellman 方程有什么关系？', 'eaq-v02-q06', 'knowledge', 'easy', '**TD 误差**（时序差分误差）：$\delta_t = r_t + \gamma V(s_{t+1}) - V(s_t)$，表示"实际得到的 bootstrap 估计"与"当前估计"之差。',
   '**TD 误差**（时序差分误差）：$\delta_t = r_t + \gamma V(s_{t+1}) - V(s_t)$，表示"实际得到的 bootstrap 估计"与"当前估计"之差。', '**TD 误差**（时序差分误差）：$\delta_t = r_t + \gamma V(s_{t+1}) - V(s_t)$，表示"实际得到的 bootstrap 估计"与"当前估计"之差。

**与 Bellman 方程的关系**：Bellman 期望方程 $V^\pi(s) = \mathbb{E}[r + \gamma V^\pi(s'')]$，若 $V$ 满足 Bellman 方程，则 $\mathbb{E}[\delta_t] = 0$；TD 学习就是用随机梯度把 $\delta_t$ 向 0 推。

**核心作用**：① 提供单步可计算的 critic 更新信号（不需等轨迹结束）；② 等于 GAE 公式里的 $\delta_{t+l}$ 基本单元；③ Prioritized Replay 用 $|\delta_t|$ 衡量样本重要性。',
   null, null, '["$\\delta_t$ 是带符号的误差，正值表示\"实际比预期好\"、负值表示\"实际比预期差\"", "直接用 $\\delta_t^2$ 做损失就是 critic 的 MSE loss。"]'::jsonb, null, 3, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"策略优化基础","qid":"Q06","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000129', '重要性采样（Importance Sampling）在 RL 中的作用？PPO 怎么用的？', 'eaq-v02-q07', 'knowledge', 'medium', '**重要性采样（IS）**：当数据分布 $q$ 与目标分布 $p$ 不一致时，用比值 $w = p(x)/q(x)$ 纠正：$\mathbb{E}_p[f(x)] = \mathbb{E}_q[w \cdot f(x)…',
   '**重要性采样（IS）**：当数据分布 $q$ 与目标分布 $p$ 不一致时，用比值 $w = p(x)/q(x)$ 纠正：$\mathbb{E}_p[f(x)] = \mathbb{E}_q[w \cdot f(x)]$。', '**重要性采样（IS）**：当数据分布 $q$ 与目标分布 $p$ 不一致时，用比值 $w = p(x)/q(x)$ 纠正：$\mathbb{E}_p[f(x)] = \mathbb{E}_q[w \cdot f(x)]$。

**RL 中的用途**：① 允许 on-policy 算法用旧策略数据做多轮 mini-batch 更新（提升数据效率）；② off-policy 评估（用行为策略数据评估目标策略）。

**PPO 怎么用**：定义比值 $r_t(\theta) = \pi_\theta(a|s) / \pi_{\theta_{\text{old}}}(a|s)$，梯度目标变为：
$$L^{\text{CLIP}} = \mathbb{E}_t\!\left[\min\!\left(r_t \hat{A}_t, \text{clip}(r_t, 1-\varepsilon, 1+\varepsilon)\hat{A}_t\right)\right]$$
**Clip 机制**不是 IS 本身，而是限制 $r_t$ 偏离 1 太远（$\varepsilon$ 通常 0.2），防止比值失控、方差爆炸。',
   null, null, '["PPO 的 clip 只影响梯度计算，不是完整 IS 校正", "当 $r_t$ 被 clip 后梯度等效为 0，策略不会继续沿该方向走远。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"策略优化基础","qid":"Q07","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000130', '多步回报（n-step return）是什么？和 TD(0) / MC 的关系？', 'eaq-v02-q08', 'knowledge', 'medium', '**n-step return**：$G_t^{(n)} = r_t + \gamma r_{t+1} + \ldots + \gamma^{n-1}r_{t+n-1} + \gamma^n V(s_{t+n})$，即…',
   '**n-step return**：$G_t^{(n)} = r_t + \gamma r_{t+1} + \ldots + \gamma^{n-1}r_{t+n-1} + \gamma^n V(s_{t+n})$，即向前展 n 步后接 bootstrap。', '**n-step return**：$G_t^{(n)} = r_t + \gamma r_{t+1} + \ldots + \gamma^{n-1}r_{t+n-1} + \gamma^n V(s_{t+n})$，即向前展 n 步后接 bootstrap。

**关系**：
- $n=1$：单步 TD（TD(0)）；低方差、高 bias（V 估计不准影响大）
- $n \to \infty$：蒙特卡洛（MC）；高方差、零 bias（用真实 G）
- 中间值：bias-variance 权衡；$\lambda$-return（GAE 是其指数加权版本）

**实务选 n 的经验**：短任务（episode < 50 步）可用较大 n；长任务（> 500 步）n 过大会导致方差爆炸，通常 n=3-10 + GAE。',
   null, null, '["TD(λ) 和 GAE 的关系——GAE 是从 offline 轨迹计算的 λ-return advantage", "TD(λ) 是 online 更新规则", "计算方法不同，但在正向累积 δ 的公式上等价。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"策略优化基础","qid":"Q08","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000131', 'PPO 的 Clip 机制是什么？为什么 ε 通常取 0.2？', 'eaq-v02-q09', 'knowledge', 'easy', '**PPO（Proximal Policy Optimization, Schulman 2017）**的核心是 Clip 目标。',
   '**PPO（Proximal Policy Optimization, Schulman 2017）**的核心是 Clip 目标：', '**PPO（Proximal Policy Optimization, Schulman 2017）**的核心是 Clip 目标：

$$L^{\text{CLIP}}(\theta) = \mathbb{E}_t\!\left[\min\!\left(r_t\hat{A}_t,\ \text{clip}(r_t, 1-\varepsilon, 1+\varepsilon)\hat{A}_t\right)\right]$$

其中 $r_t = \pi_\theta / \pi_{\theta_\text{old}}$。

**直觉**：advantage 为正时想升高 $r_t$，但若 $r_t > 1+\varepsilon$ 已涨太多，clip 截断梯度，防止过激更新；advantage 为负时同理，$r_t < 1-\varepsilon$ 则截断。"先设上下限、再取 min"确保保守更新。

**ε = 0.2**：Schulman 原论文实验甜区；太小更新保守、样本浪费；太大接近无约束 PG。RLHF 常用 0.1-0.2。',
   null, null, '["PPO-Clip ≠ PPO-KL", "后者在损失里显式加 KL penalty", "前者更常用且稳定。"]'::jsonb, null, 3, true, true, 18, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"PPO / TRPO","qid":"Q09","freq_label":"🔥×18"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000132', 'TRPO 和 PPO 的联系与区别？为什么 PPO 更流行？', 'eaq-v02-q10', 'knowledge', 'easy', '**TRPO（Trust Region PO, Schulman 2015）**：用二阶优化（共轭梯度 + Hessian-vector 乘积）在**KL 约束** $D_\text{KL}(\pi_{\theta_\…',
   '**TRPO（Trust Region PO, Schulman 2015）**：用二阶优化（共轭梯度 + Hessian-vector 乘积）在**KL 约束** $D_\text{KL}(\pi_{\theta_\text{old}} \| \pi_\theta) \le \delta$（旧策略到新策略的 KL）下求最优更新；理论保证单调策略改进。', '**TRPO（Trust Region PO, Schulman 2015）**：用二阶优化（共轭梯度 + Hessian-vector 乘积）在**KL 约束** $D_\text{KL}(\pi_{\theta_\text{old}} \| \pi_\theta) \le \delta$（旧策略到新策略的 KL）下求最优更新；理论保证单调策略改进。

**PPO**：TRPO 的轻量化替代，用 clip 机制隐式限制策略变化，**不需要共轭梯度**，一阶优化（Adam）即可；代码量从数百行降到数十行。

| | TRPO | PPO-Clip |
|---|---|---|
| 约束方式 | 显式 KL 约束 | Clip ratio |
| 优化器 | 二阶（CG+线搜） | 一阶（Adam） |
| 代码复杂度 | 高 | 低 |
| 效果 | 理论保证单调 | 实务近似等效 |
| 分布式 | 难 | 容易 |

**PPO 更流行的原因**：① 实现简单；② GPU batch 友好；③ 效果接近 TRPO；④ 与 LLM RLHF 对齐流程无缝集成（VLA 微调主流仍是 BC/flow matching）。',
   null, null, '["TRPO 的\"单调改进\"在神经网络参数化下只是近似保证（Fisher 矩阵近似），并非绝对。"]'::jsonb, null, 3, false, true, 14, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"PPO / TRPO","qid":"Q10","freq_label":"🔥×14"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000133', 'PPO 的 entropy bonus 是什么？什么时候需要加？', 'eaq-v02-q11', 'knowledge', 'medium', '**Entropy bonus**：在 PPO 目标里加 $\beta \cdot \mathcal{H}[\pi_\theta(\cdot|s)]$（策略熵），鼓励策略保持随机性。',
   '**Entropy bonus**：在 PPO 目标里加 $\beta \cdot \mathcal{H}[\pi_\theta(\cdot|s)]$（策略熵），鼓励策略保持随机性。', '**Entropy bonus**：在 PPO 目标里加 $\beta \cdot \mathcal{H}[\pi_\theta(\cdot|s)]$（策略熵），鼓励策略保持随机性。

**直觉**：若策略过早收敛（熵趋 0），actor 只会走一条路，探索停止——这在稀疏奖励 / 多峰任务中灾难性。熵 bonus 提供额外梯度驱动策略"多尝试几种动作"。

**什么时候用**：① 奖励稀疏（初期没信号，需探索维持）；② 离散动作空间（熵易计算 $-\sum p \log p$）；③ 任务有多条最优路径（不想早期锁死一条）。

**什么时候不加**：连续控制精细任务（机械臂插针）——过多探索引入噪声反而有害；SAC 已内置熵最大化，不需要额外加。

**超参 $\beta$ 建议**：通常 0.01-0.05；RLHF 场景有时用 0.001 以下（微调阶段需保守）。',
   null, null, '["entropy bonus 是可选项，PPO 原论文的联合目标中包含该项，但实验中系数可设为 0", "SAC 的熵机制来自 max-entropy RL 框架（正则化目标），与 PPO 的 entropy bonus（探索辅助）不要混淆。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"PPO / TRPO","qid":"Q11","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000134', 'PPO 训练的完整流程是什么（采样 → 优势估计 → 多轮更新 → 截断）？', 'eaq-v02-q12', 'knowledge', 'medium', '**PPO 一个迭代周期**。',
   '**PPO 一个迭代周期**：', '**PPO 一个迭代周期**：

1. **Rollout**：用 $\pi_{\theta_\text{old}}$ 交互 T 步，存 $(s_t, a_t, r_t, s_{t+1}, \log\pi_\text{old})$。
2. **GAE**：计算 $\hat{A}_t$ + target value $\hat{V}_t = \hat{A}_t + V_\phi(s_t)$。
3. **多 epoch 更新**：mini-batch 采样 K 次（K=3-10），计算 Actor $L^{\text{CLIP}}$ + Critic MSE + entropy bonus（可选）。
4. **Early stopping**：KL 超阈值时提前退出 epoch。
5. 更新 $\theta_\text{old} \leftarrow \theta$，重复。

**关键超参**：T（256-2048）、batch（32-256）、K（3-10）、ε（0.2）、λ（0.95）。',
   null, null, '["多 epoch 是 PPO 核心优势", "但 K 太大 → IS ratio 失控", "K 通常不超过 10。"]'::jsonb, null, 5, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"PPO / TRPO","qid":"Q12","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000135', 'PPO 在机器人连续控制中常见的失败模式有哪些？如何诊断？', 'eaq-v02-q13', 'knowledge', 'hard', '**常见失败模式**。',
   '**常见失败模式**：', '**常见失败模式**：

1. **Reward hacking / mode collapse**：奖励函数有漏洞，agent 找到"不物理"的高分动作（如原地振荡换高速度奖励）。诊断：reward 高但实际任务失败；对策：奖励工程审查 + 额外约束项。

2. **训练不稳定（loss 剧烈震荡）**：学习率或 clip ε 太大；Critic 估计跟不上 Actor 更新节奏。诊断：entropy 先升后崩、KL 突增；对策：降 lr、减 epoch 数、共享 encoder 冻层。

3. **过早收敛到次优策略**：entropy 过快降至接近 0，探索停止。对策：增大 entropy bonus $\beta$ 或使用 curriculum。

4. **仿真 sim2real gap**：仿真里 PPO 高分，真机泛化差。诊断：Domain Randomization 覆盖不足；对策：增大 DR 范围 + 感知扰动。

5. **稀疏奖励不收敛**：长期无信号，梯度消失。对策：奖励 shaping（如势能函数）+ HER（Hindsight Experience Replay）。',
   null, null, '["PPO 失败首先看 entropy 曲线——熵崩塌是早期预警信号", "不要先调 clip ε，先检查奖励函数和数据分布。"]'::jsonb, null, 8, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"PPO / TRPO","qid":"Q13","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000136', 'TD3 相比 DDPG 做了哪三点改进？分别解决什么问题？', 'eaq-v02-q15', 'knowledge', 'easy', '**TD3（Twin Delayed DDPG, Fujimoto 2018）**针对 DDPG，做了 3 点改进。',
   '**TD3（Twin Delayed DDPG, Fujimoto 2018）**针对 DDPG，做了 3 点改进：', '**TD3（Twin Delayed DDPG, Fujimoto 2018）**针对 DDPG，做了 3 点改进：

1. **双 Q 网络**：维护 $Q_{\phi_1}, Q_{\phi_2}$，取 min：$y = r + \gamma \min_i Q_{\phi_i}(s'', \pi(s''))$ → 解决过估计。

2. **Actor 延迟更新**：Actor 每 d 步更新一次（d=2），Critic 每步更新 → 防止 Actor 过快追高估 Q 值。

3. **Target Policy Smoothing**：target action 加裁剪高斯噪声 $\tilde{a} = \pi(s'') + \text{clip}(\mathcal{N}(0,\sigma), -c, c)$ → 平滑 Q 面，防止在 Q 峰值上过拟合。',
   null, null, '["TD3 是确定性策略，SAC 是随机策略", "3 个改进必须**全部组合**才达到论文效果，缺一不可。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"SAC / TD3 / DDPG","qid":"Q15","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000137', 'DDPG 是什么？为什么在实务中不稳定？', 'eaq-v02-q16', 'knowledge', 'easy', '**DDPG（Deep Deterministic Policy Gradient, Lillicrap 2016）**：off-policy Actor-Critic，专为连续动作设计。',
   '**DDPG（Deep Deterministic Policy Gradient, Lillicrap 2016）**：off-policy Actor-Critic，专为连续动作设计：
- Actor 输出**确定性动作** $\mu_\theta(s)$（不是概率分布）
- Critic 用 Q-learning 更新：$y = r + \gamma Q_{\phi''}(s'', \mu_{\theta''}(s''))$
- 使用**经验回放 + target 网络**（从 DQN 借来）', '**DDPG（Deep Deterministic Policy Gradient, Lillicrap 2016）**：off-policy Actor-Critic，专为连续动作设计：
- Actor 输出**确定性动作** $\mu_\theta(s)$（不是概率分布）
- Critic 用 Q-learning 更新：$y = r + \gamma Q_{\phi''}(s'', \mu_{\theta''}(s''))$
- 使用**经验回放 + target 网络**（从 DQN 借来）

**实务不稳定的原因**：
1. **Q 值过估计**：actor 持续追最大 Q，Q 值单调高估，最终 NaN；
2. **超参极度敏感**：batch size / lr / 噪声 σ 调错就崩；
3. **探索困难**：确定性策略靠人为加 Ornstein-Uhlenbeck 噪声，效果有限；
4. **Critic 和 Actor 互相污染**：Q 估计不准 → 策略更新方向错 → Q 更不准（恶性循环）。

**TD3 / SAC 的出现**基本淘汰了裸 DDPG 的实际使用。',
   null, null, '["DDPG 的\"确定性\"是指策略不是概率分布——推理时输出是单个动作", "探索靠加外部噪声，不是策略本身的随机性。"]'::jsonb, null, 3, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"SAC / TD3 / DDPG","qid":"Q16","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000138', 'replay buffer（经验回放）的作用？uniform 采样有什么缺陷？PER 怎么改进？', 'eaq-v02-q17', 'knowledge', 'medium', '**Replay buffer**：存储历史 $(s, a, r, s'', \text{done})$ 元组，off-policy 算法随机采样训练。',
   '**Replay buffer**：存储历史 $(s, a, r, s'', \text{done})$ 元组，off-policy 算法随机采样训练。', '**Replay buffer**：存储历史 $(s, a, r, s'', \text{done})$ 元组，off-policy 算法随机采样训练。

**作用**：① **去相关**：相邻时间步高度相关，随机采样打破 temporal correlation；② **数据复用**：每条数据可被多次学习，提升 sample efficiency；③ **稳定分布**：避免 online 数据分布漂移太快导致不稳定。

**均匀采样缺陷**：TD 误差大的（难学、重要的）样本和 TD 误差小的（已学好的）样本同等概率采到 → 训练低效。

**PER（Prioritized Experience Replay, Schaul 2016）**：用 $|\delta_t|^\alpha$（TD 误差绝对值的 α 次方）设优先级，高 TD 误差样本更频繁采样；同时用**重要性采样权重** $w_i = (1/N \cdot 1/p_i)^\beta$ 纠正采样 bias（$\beta$ 从 0.4 退火到 1.0）。',
   null, null, '["PER 不是\"总采最难的样本\"——是概率高，不是必然采", "重要性权重不是可选项，缺失会引入 bias 导致价值函数偏移。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"SAC / TD3 / DDPG","qid":"Q17","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000139', 'Double DQN / Dueling DQN / Noisy Nets：各自解决什么问题？', 'eaq-v02-q20', 'knowledge', 'medium', '**Double DQN（van Hasselt 2016）**：解决 Q 值**过估计**（max 操作对估计误差有正偏差）。',
   '- **Double DQN（van Hasselt 2016）**：解决 Q 值**过估计**（max 操作对估计误差有正偏差）。改法：选动作用当前网络 $\phi$，计算 Q 值用 target 网络 $\phi''$：$y = r + \gamma Q_{\phi''}(s'', \arg\max_{a''} Q_\phi(s'', a''))$。解耦"选哪个动作"与"评估这个动作"。', '- **Double DQN（van Hasselt 2016）**：解决 Q 值**过估计**（max 操作对估计误差有正偏差）。改法：选动作用当前网络 $\phi$，计算 Q 值用 target 网络 $\phi''$：$y = r + \gamma Q_{\phi''}(s'', \arg\max_{a''} Q_\phi(s'', a''))$。解耦"选哪个动作"与"评估这个动作"。

- **Dueling DQN（Wang 2016）**：解决 Q 值的**状态无关冗余**。把 Q 分解为：$Q(s,a) = V(s) + A(s,a)$（state value + advantage）。好处：能同时更新所有动作的 V 值（即使该 step 没采到某个动作），更新效率高。

- **Noisy Nets（Fortunato 2018）**：解决 $\varepsilon$-greedy **探索低效**问题（均匀随机探索浪费）。把网络权重换成带可学噪声的参数 $\mu + \sigma \cdot \varepsilon$（参数化探索），探索自适应地集中在不确定动作上。',
   null, null, '["三者可叠加（Rainbow DQN = 六种改进叠加）", "Dueling 的标准归一化为减**均值**：$Q(s,a) = V(s) + A(s,a) - \\frac{1}{|A|}\\sum_{a''} A(s,a'')$，保证 V/A 分解唯一且梯度覆盖所有动作", "不减任何量 → V/A 分解不唯一、不稳定。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"DQN 与离散动作","qid":"Q20","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000140', 'HER（Hindsight Experience Replay）是什么？为什么对稀疏奖励机器人任务特别有效？', 'eaq-v02-q21', 'knowledge', 'medium', '**HER（Andrychowicz 2017）**：将失败的轨迹"回头重写目标"为实际达到的结果，从而产生有效学习信号。',
   '**HER（Andrychowicz 2017）**：将失败的轨迹"回头重写目标"为实际达到的结果，从而产生有效学习信号。', '**HER（Andrychowicz 2017）**：将失败的轨迹"回头重写目标"为实际达到的结果，从而产生有效学习信号。

**流程**：机械臂试图把方块推到位置 $g$ 但失败（最终停在 $g''$），HER 将该 episode 的目标 $g$ 替换为 $g''$，**逐 transition 重新计算奖励**（$r = \mathbb{1}[\|s - g''\| < \delta]$，仅最后几步为 +1）→ 这段失败轨迹变成"成功到达 $g''$"的有效经验加入 buffer。

**为什么有效**：① 稀疏奖励下 agent 几乎得不到任何正信号，HER 把每次失败都变成"成功到达某个地方"的经验，信号密度大幅提升；② 不需要改奖励函数；③ 与任何 off-policy 算法（DDPG/TD3/SAC）无缝组合。

**适用场景**：目标条件策略（Goal-conditioned RL），如机器人 pick-and-place、推物体到目标位置等。',
   null, null, '["HER 用的不是任意随机目标，而是从同 episode 实际达到的状态中重标（strategy = \"future\" / \"final\" / \"episode\"），语义上是\"已经发生的真实结果\"", "若奖励不是 goal-conditioned（如 $r = \\mathbb{1}[s=g]$），HER 无法应用。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"DQN 与离散动作","qid":"Q21","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000141', 'CQL（Conservative Q-Learning）的核心思想是什么？如何防止 OOD 过估计？', 'eaq-v02-q23', 'knowledge', 'medium', '**CQL（Kumar 2020）**在 Q 值目标里加一个**保守惩罚**。',
   '**CQL（Kumar 2020）**在 Q 值目标里加一个**保守惩罚**：', '**CQL（Kumar 2020）**在 Q 值目标里加一个**保守惩罚**：

$$\min_\phi \mathbb{E}_{(s,a)\sim\mathcal{D}}[(Q-y)^2] + \alpha\!\left(\mathbb{E}_{s\sim\mathcal{D}, a\sim\mu(s)}\!\left[Q(s,a)\right] - \mathbb{E}_{(s,a)\sim\mathcal{D}}\!\left[Q(s,a)\right]\right)$$

**直觉**：第二项**压低** OOD（随机/当前策略 μ 采样）的 Q；第三项**抬高**数据集中动作的 Q → 数据内高、数据外低 → 策略不走 OOD。

**理论保证**：CQL 的 $Q^\pi$ 是真实 $Q^\pi$ 的保守下界，在下界上优化策略是安全的。

**超参 α**：α 大 → 过保守（性能跌破 BC）；α 小 → 退化为普通 Q-learning（OOD 复现）。实务用 Lagrangian 自动调。',
   null, null, '["CQL 不是纯 BC——它仍尝试找比 behavior policy 更好的策略，只是用保守 Q 防 OOD。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"Offline RL","qid":"Q23","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000142', 'IQL（Implicit Q-Learning）如何在不查询 OOD 动作的情况下做 offline RL？', 'eaq-v02-q24', 'knowledge', 'medium', '**IQL（Kostrikov 2021）**的关键创新是**完全避免**评估 OOD 动作。',
   '**IQL（Kostrikov 2021）**的关键创新是**完全避免**评估 OOD 动作：', '**IQL（Kostrikov 2021）**的关键创新是**完全避免**评估 OOD 动作：

**三个组件**：
1. **V(s)**：expectile 回归（τ 常取 0.7-0.9，官方 D4RL 默认 0.7）近似最优 V 值，完全在数据动作上计算；
2. **Q(s,a)**：用 $Q = r + \gamma V(s'')$ TD 更新，**不查询 $\max_{a''}$**；
3. **策略提取**：advantage-weighted 回归：$\exp(\beta A(s,a))\cdot\log\pi_\theta(a|s)$

**优势**：无 OOD 动作查询，训练稳定；在 locomotion 基准上优于或接近 CQL。',
   null, null, '["expectile 回归 ≠ quantile 回归——前者是不对称加权期望，后者是精确分位点估计", "τ 越大越激进（越接近最优 Q），不是\"百分位\"。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"Offline RL","qid":"Q24","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000143', 'BCQ（Batch-Constrained Q-learning）和行为克隆的区别？为什么叫"batch-constrained"？', 'eaq-v02-q25', 'knowledge', 'medium', '**BCQ（Fujimoto 2019）**：在做 Q 最大化时，**只在与数据集分布相近的动作上做 max**，而不是全动作空间 max。',
   '**BCQ（Fujimoto 2019）**：在做 Q 最大化时，**只在与数据集分布相近的动作上做 max**，而不是全动作空间 max。', '**BCQ（Fujimoto 2019）**：在做 Q 最大化时，**只在与数据集分布相近的动作上做 max**，而不是全动作空间 max。

**核心机制**：训练一个生成模型 $G_\omega$（通常 VAE）来建模数据集的动作分布 $\beta(a|s)$，推理时：
- 从 $G_\omega$ 采样 N 个候选动作 $a_1, \ldots, a_N$
- 每个动作通过扰动网络 $\xi_\phi$ 微调（有限范围内）
- 选 $Q$ 值最大的候选 → 这些候选都在数据支持范围内

**与 BC 的区别**：BC 只克隆 $\pi_{\text{data}}$（学 $P(a|s)$），不优化 Q；BCQ 仍在优化 Q 值，只是把 max 操作限制在数据支持集内，**可以超越 behavior policy 的性能**（若 behavior policy 本身次优）。

**"Batch-Constrained"含义**：策略受到 batch 数据的约束——选动作受限于 batch 中见过的动作分布。',
   null, null, '["BCQ 的 VAE 是建模数据分布，不是生成目标动作", "扰动网络的范围用 $\\Phi$ 控制，$\\Phi=0$ 退化为纯 BC，$\\Phi=\\infty$ 退化为无约束 Q-learning。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"Offline RL","qid":"Q25","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000144', 'Decision Transformer（DT）如何把 Offline RL 变成序列建模？有什么局限？', 'eaq-v02-q26', 'knowledge', 'medium', '**DT（Chen 2021）**：把 Offline RL 重构为**条件序列预测**，用 GPT 风格 Transformer 自回归建模 $(R^g_1, s_1, a_1, R^g_2, s_2, a_2, \…',
   '**DT（Chen 2021）**：把 Offline RL 重构为**条件序列预测**，用 GPT 风格 Transformer 自回归建模 $(R^g_1, s_1, a_1, R^g_2, s_2, a_2, \ldots)$，条件是 Return-to-Go（RTG）$R^g_t = \sum_{t''\geq t} r_{t''}$。', '**DT（Chen 2021）**：把 Offline RL 重构为**条件序列预测**，用 GPT 风格 Transformer 自回归建模 $(R^g_1, s_1, a_1, R^g_2, s_2, a_2, \ldots)$，条件是 Return-to-Go（RTG）$R^g_t = \sum_{t''\geq t} r_{t''}$。

**训练**：给定历史 RTG + 状态，预测当前动作（监督学习）。**推理**：设定期望 RTG（如"我想得 1000 分"），模型自回归生成动作序列。

**优势**：① 不需要 Bellman 方程，无 OOD 过估计问题；② 直接复用 Transformer 预训练能力；③ 长程依赖建模好。

**局限**：
1. **依赖 RTG 设置**：测试时必须知道"目标 RTG"，稀疏/未知回报场景难设置；
2. **不能 stitch**：无法组合数据集中不同片段找出最优路径（Bellman 方程做的事）；
3. 在简单 D4RL benchmark 上不如 IQL/CQL，但在长序列 / 自然语言条件任务上有优势。',
   null, null, '["DT 不做 Q 值优化，是纯监督学习", "不能从次优数据提升到远超 behavior policy 的性能（这是值函数方法的优势）。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"Offline RL","qid":"Q26","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000145', 'AWAC / IQL offline-to-online 的流程是什么？为什么在具身机器人里受关注？', 'eaq-v02-q27', 'knowledge', 'hard', '**Offline-to-Online RL**：先用大量离线数据（人工演示 / 历史轨迹）做 offline 预训练，再通过少量 online 交互精调，避免从零开始 online 探索的高昂成本。',
   '**Offline-to-Online RL**：先用大量离线数据（人工演示 / 历史轨迹）做 offline 预训练，再通过少量 online 交互精调，避免从零开始 online 探索的高昂成本。', '**Offline-to-Online RL**：先用大量离线数据（人工演示 / 历史轨迹）做 offline 预训练，再通过少量 online 交互精调，避免从零开始 online 探索的高昂成本。

**AWAC（Nair 2021）**：actor 更新用 $\exp(\lambda A)$ 权重（advantage-weighted 回归），offline 预训练后 online 阶段直接续跑 off-policy，无需特殊切换。

**IQL offline-to-online**：offline 用 IQL 训 V/Q/policy；online 直接继续采集 + IQL 更新；无 OOD 查询，稳定性优于 AWAC。

**具身场景价值**：真机探索代价高；遥操作演示数据丰富；offline 预训练 + 少量 online 精调是主流路线（代表：RLPD / Cal-QL）。',
   null, null, '["不是\"先 BC 后 RL\"", "CQL 预训练的 Q 值过保守时，online 阶段需 warm-up 解禁。"]'::jsonb, null, 8, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"Offline RL","qid":"Q27","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000146', 'RLHF 的三阶段是什么？每阶段目标是什么？', 'eaq-v02-q28', 'knowledge', 'easy', '**RLHF（Reinforcement Learning from Human Feedback）**是 LLM 对齐的标准流程（VLA 微调主流仍是 BC/flow matching，RLHF 在 VLA 属新兴探…',
   '**RLHF（Reinforcement Learning from Human Feedback）**是 LLM 对齐的标准流程（VLA 微调主流仍是 BC/flow matching，RLHF 在 VLA 属新兴探索方向）：', '**RLHF（Reinforcement Learning from Human Feedback）**是 LLM 对齐的标准流程（VLA 微调主流仍是 BC/flow matching，RLHF 在 VLA 属新兴探索方向）：

**阶段 1：监督微调（SFT）**
- 目标：在高质量示范数据上做监督学习，让模型有基础能力
- 输出：SFT 模型（同时作为 PPO 阶段的参考模型）

**阶段 2：奖励模型训练（Reward Model）**
- 目标：学一个 $R_\phi(s, a)$，使人类对"输出 A 比 B 好"的偏好得分一致
- 数据：同一提示下多个输出 → 人类排序 → Bradley-Terry 模型训练 RM
- 关键：RM 是对齐信号的代理，质量决定 PPO 阶段的方向

**阶段 3：PPO 精调（RL fine-tuning）**
- 目标：最大化 RM 打分同时限制与 SFT 模型的 KL 散度：$r'' = R_\phi(s, a) - \beta \cdot D_\text{KL}(\pi_\theta \| \pi_\text{SFT})$
- 四模型：Actor（被训）、Critic（价值估计）、Reference（SFT，冻结）、RM（冻结）',
   null, null, '["RLHF 的 PPO 阶段不是普通 RL——Reward 来自 RM 而非环境", "KL 项是必须的，不加会导致模型\"奖励黑客\"（对 RM 钻漏洞）。"]'::jsonb, null, 3, false, true, 13, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"RLHF / DPO / GRPO","qid":"Q28","freq_label":"🔥×13"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000147', 'RLHF 中 KL 散度约束的作用是什么？β 过大 / 过小各有什么问题？', 'eaq-v02-q29', 'knowledge', 'medium', '**KL 约束目标**：$r'' = R_\phi(x, y) - \beta \cdot D_\text{KL}(\pi_\theta(y|x) \| \pi_\text{ref}(y|x))$',
   '**KL 约束目标**：$r'' = R_\phi(x, y) - \beta \cdot D_\text{KL}(\pi_\theta(y|x) \| \pi_\text{ref}(y|x))$', '**KL 约束目标**：$r'' = R_\phi(x, y) - \beta \cdot D_\text{KL}(\pi_\theta(y|x) \| \pi_\text{ref}(y|x))$

KL 项的作用：防止 actor 策略偏离参考模型（SFT 初始化）太远，避免"奖励黑客"（reward hacking）——模型找到 RM 的漏洞，产生高分但无意义 / 有害输出。

**β 过大（过度约束）**：
- KL 项主导，策略几乎不动，等效于仍是 SFT 模型
- RM 信号对训练影响极小，对齐效果差
- 训练效率低下

**β 过小（约束不足）**：
- 策略过度优化 RM，产生 reward hacking（如输出全是特定格式的高分废话）
- 与 SFT 模型偏离太远，语言质量下降（重复 / 无意义）
- 模型通用能力退化（catastrophic forgetting）

**实务 β 选择**：InstructGPT 原文 β = 0.02-0.04；实务中通常从 0.1 开始，监控 KL divergence 曲线决定调整方向。',
   null, null, '["KL 不是 PPO clip 机制——clip 是限制策略比值 $r_t$，KL 约束是限制策略输出分布距离", "两者都是防止策略更新过大，但机制不同。"]'::jsonb, null, 5, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"RLHF / DPO / GRPO","qid":"Q29","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000148', 'DPO（Direct Preference Optimization）和 RLHF+PPO 的核心区别？DPO 为什么不需要显式 RM？', 'eaq-v02-q30', 'knowledge', 'medium', '**DPO（Rafailov 2023）**：通过数学推导将 RLHF 的 RL 目标化简为纯监督学习，**绕过了显式 RM 训练和 PPO**。',
   '**DPO（Rafailov 2023）**：通过数学推导将 RLHF 的 RL 目标化简为纯监督学习，**绕过了显式 RM 训练和 PPO**。', '**DPO（Rafailov 2023）**：通过数学推导将 RLHF 的 RL 目标化简为纯监督学习，**绕过了显式 RM 训练和 PPO**。

**推导**：RLHF 最优策略满足 $\pi^*(y|x) \propto \pi_\text{ref}(y|x)\exp(R/\beta)$；代回 Bradley-Terry 模型后 R 消掉：

$$L_\text{DPO} = -\mathbb{E}\!\left[\log\sigma\!\left(\beta\log\frac{\pi_\theta(y_w|x)}{\pi_\text{ref}(y_w|x)} - \beta\log\frac{\pi_\theta(y_l|x)}{\pi_\text{ref}(y_l|x)}\right)\right]$$

$y_w$ 偏好输出，$y_l$ 非偏好输出。RM 被消掉，所有信号来自偏好对 + 参考模型。

**DPO vs PPO**：DPO 简单、无在线采样、稳定；PPO 可在线探索、处理新场景。DPO 用固定偏好数据，无法自适应更新。',
   null, null, '["DPO 仍源于 RL 推导，不是\"去掉了 RL\"", "它是 RLHF 最优解的解析等价，不是启发式简化。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"RLHF / DPO / GRPO","qid":"Q30","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000149', 'VLA 微调中用 PPO 还是 BC？RLHF 和行为克隆的结合方式？', 'eaq-v02-q32', 'knowledge', 'hard', '先按数据、奖励和动作表示选方法。',
   '先按数据、奖励和动作表示选方法。有示教时可用 BC，具体损失依离散动作、连续回归或 flow/diffusion 参数化而定；能获得可靠任务反馈时，再考虑 RL 后训练。PPO 需要定义可计算的动作概率和轨迹采样流程。RECAP 使用示教、自主执行及人工纠正，学习优势条件策略，推理时条件化生成较好动作。', '先按数据、奖励和动作表示选方法。有示教时可用 BC，具体损失依离散动作、连续回归或 flow/diffusion 参数化而定；能获得可靠任务反馈时，再考虑 RL 后训练。PPO 需要定义可计算的动作概率和轨迹采样流程。RECAP 使用示教、自主执行及人工纠正，学习优势条件策略，推理时条件化生成较好动作。',
   null, null, '["任务成功奖励不等于人类偏好 RLHF", "RECAP 不是 PPO 或简单好样本加权，也不能把 LLM token 的概率比值直接套到任意 flow 动作头。"]'::jsonb, null, 8, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"RLHF / DPO / GRPO","qid":"Q32","freq_label":"🔥×5","provenance":"核验：[RECAP 原论文](https://arxiv.org/abs/2511.14759)、[OpenVLA 原论文](https://arxiv.org/html/2406.09246)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000150', 'Curriculum Learning 在机器人 RL 中怎么设计？有哪些维度可以 curriculate？', 'eaq-v02-q34', 'knowledge', 'medium', '**课程学习（Curriculum Learning）**：将任务难度按序排列，从易到难训练，类似人类学习过程。',
   '**课程学习（Curriculum Learning）**：将任务难度按序排列，从易到难训练，类似人类学习过程。', '**课程学习（Curriculum Learning）**：将任务难度按序排列，从易到难训练，类似人类学习过程。

**机器人 RL 中可 curriculate 的维度**：

1. **初始状态分布**：从目标附近随机化（easy）→ 逐步扩大到全状态空间（hard）；GoalGAN / ALP-GMM 自动生成适当难度的初始状态。

2. **目标距离**：先训练短程（目标近）→ 扩展到远距离；或 HER + 课程。

3. **物体属性**：形状简单（正方形）→ 复杂（细长棒）；摩擦系数从高（好抓）到低（滑）。

4. **任务子目标分解**：把长任务分解为子目标链（抓起 → 移动 → 放下），分别学再组合。

5. **Domain Randomization 强度**：从低扰动（接近真实）→ 高扰动（鲁棒 sim2real）。

**自动课程（ACL）**：不人工设计难度，用 competence-progress 信号（最近成功率变化量）自动选下一批任务；ALP-GMM 是经典实现。',
   null, null, '["课程不能\"难度跳跃\"——若简单任务能力尚未泛化就进入难任务，容易 catastrophic forgetting", "Critic 从 easy 到 hard 的价值估计分布会剧变，需要特殊处理。"]'::jsonb, null, 5, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"工程 tricks 与机器人 RL","qid":"Q34","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000151', '机器人 RL 选算法的基本原则？PPO vs SAC 怎么选？', 'eaq-v02-q37', 'knowledge', 'easy', '选算法的核心考量。',
   '选算法的核心考量：', '选算法的核心考量：

| 维度 | PPO（on-policy） | SAC（off-policy） |
|---|---|---|
| Sample efficiency | 低（每 batch 用完丢） | 高（replay buffer 复用） |
| 真机适用性 | 差（需大量 rollout） | 好（少量数据可学） |
| 稳定性 | 高（clip 约束） | 中（过估计可能） |
| 超参敏感度 | 中 | 中-高（α / lr 敏感） |
| 与仿真并行 | 好（多 worker） | 好（异步采样） |
| LLM RLHF 对齐 | 标配 | 少用 |

**选 PPO 的场景**：① 仿真并行训练可生成大量样本；② LLM RLHF（标配）；③ 需要稳定收敛、对超参不敏感时。注：VLA 微调主流仍是 BC/flow matching，PPO 用于机器人仍在探索阶段。

**选 SAC 的场景**：① 真机 sample 极贵（每次 rollout 几十秒）；② 连续控制 + 探索要求高；③ 数据可复用（replay buffer 价值大）。

**混合路线**：仿真用 PPO / TD3 预训练 → 真机用 SAC 精调（少量 online 步骤）。',
   null, null, '["不要在真机 from scratch 用 PPO——样本太贵、无法承受 on-policy 的数据丢弃。"]'::jsonb, null, 3, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"工程 tricks 与机器人 RL","qid":"Q37","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000152', '梯度裁剪（Gradient Clipping）在 RL 里为什么比在 SL 里更重要？', 'eaq-v02-q38', 'knowledge', 'medium', '**SL 里**：损失函数通常较平滑（CE / MSE），梯度爆炸主要出现在深层 RNN 或早期训练；',
   '**SL 里**：损失函数通常较平滑（CE / MSE），梯度爆炸主要出现在深层 RNN 或早期训练；可以靠良好的 BatchNorm / ResNet 结构缓解。', '**SL 里**：损失函数通常较平滑（CE / MSE），梯度爆炸主要出现在深层 RNN 或早期训练；可以靠良好的 BatchNorm / ResNet 结构缓解。

**RL 里更重要的原因**：

1. **优势函数高方差**：$\hat{A}_t$ 可以是很大的正/负值（尤其 GAE $\lambda=1$ 接近 MC），梯度 $= \nabla \log\pi \cdot \hat{A}$，单个 batch 梯度剧烈波动；

2. **Critic 估计不准早期**：Q / V 网络初期估计误差大，TD 误差大 → 反向传播梯度大；

3. **策略 Clip 不完全保护**：PPO Clip 只限制策略更新方向，不限制梯度 L2 范数，大梯度仍可通过；

4. **非平稳目标**：RL 目标随策略变化，等于一直在非平稳问题上学，梯度范数波动比 SL 大。

**实务**：PPO 代码通常 `max_grad_norm = 0.5`；SAC 通常 `max_grad_norm = 1.0`；不裁剪则训练前 1000 步容易 NaN。',
   null, null, '["梯度裁剪是裁剪 L2 范数（整体缩放），不是截断每个参数梯度（那是 clip by value，效果差得多）。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"工程 tricks 与机器人 RL","qid":"Q38","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000153', 'Intrinsic Motivation（内在动机 / 好奇心驱动）是什么？RND 怎么实现？', 'eaq-v02-q39', 'knowledge', 'hard', '**内在动机（IM）**：给 agent 额外的内在奖励（intrinsic reward）$r^i$，奖励"新颖"或"信息量大"的状态，解决稀疏/无外部奖励场景下的探索。',
   '**内在动机（IM）**：给 agent 额外的内在奖励（intrinsic reward）$r^i$，奖励"新颖"或"信息量大"的状态，解决稀疏/无外部奖励场景下的探索。', '**内在动机（IM）**：给 agent 额外的内在奖励（intrinsic reward）$r^i$，奖励"新颖"或"信息量大"的状态，解决稀疏/无外部奖励场景下的探索。

$$r_t = r_t^e + \beta \cdot r_t^i, \quad r_t^i = \text{novelty}(s_t)$$

**RND（Burda 2019）**：
- 固定随机目标网络 $f$（冻结）+ 可训练预测网络 $\hat{f}$
- 内在奖励 $r^i = \|f(s) - \hat{f}(s)\|^2$：未见状态误差大 → 高奖励；已访问状态误差小 → 低奖励

**优点**：简单有效，无需建动力学模型；用于 Montezuma''s Revenge 达超人类水平。',
   null, null, '["RND 对观测归一化极敏感（状态非平稳时 $r^i$ 会漂移）", "$\\beta$ 需随训练 annealing，后期逐步减小内在奖励权重。"]'::jsonb, null, 8, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"工程 tricks 与机器人 RL","qid":"Q39","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000154', 'Hierarchical RL（层级强化学习）的基本思路？在机器人长程任务中的优势？', 'eaq-v02-q40', 'knowledge', 'hard', '**层级 RL（HRL）**：把复杂长程任务分解为 high-level（HL）策略 + low-level（LL）策略的两层（或多层）结构。',
   '**层级 RL（HRL）**：把复杂长程任务分解为 high-level（HL）策略 + low-level（LL）策略的两层（或多层）结构：
- **HL 策略**：在粗粒度时间步 $(t, t+k, t+2k, \ldots)$ 做决策，输出子目标 $g_t$（如"移动到箱子旁边"）；
- **LL 策略**：在每步执行，接收子目标 $g_t$ 作为条件，输出底层控制命令（关节力矩）。', '**层级 RL（HRL）**：把复杂长程任务分解为 high-level（HL）策略 + low-level（LL）策略的两层（或多层）结构：
- **HL 策略**：在粗粒度时间步 $(t, t+k, t+2k, \ldots)$ 做决策，输出子目标 $g_t$（如"移动到箱子旁边"）；
- **LL 策略**：在每步执行，接收子目标 $g_t$ 作为条件，输出底层控制命令（关节力矩）。

**代表框架**：HIRO（Data-efficient HRL）——HL 每 c 步发一次子目标，LL 在 c 步内追子目标；子目标用相对状态表示。

**长程任务优势**：
1. 时间尺度分离：HL 不需要管每步细节，学"大方向"；LL 专注精细控制；
2. 缓解信用分配（credit assignment）问题：LL 的任务有明确子目标，短期奖励密集；
3. 复用性：LL"抓取"策略可被多个 HL 任务复用（如"开门后放物体 → 两个任务共享抓取 LL"）。',
   null, null, '["HL 和 LL 的训练需要协调——HL 给不可达子目标会导致 LL 不知所措", "子目标空间设计（状态空间 vs 潜在空间）对效果影响大。"]'::jsonb, null, 8, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"工程 tricks 与机器人 RL","qid":"Q40","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000155', '手撕 Q-learning 更新（TD(0) 表格版）', 'eaq-v02-h01', 'coding', 'easy', '`Q[s,a] += α·(r + γ·max_a'' Q[s'',a''] - Q[s,a])`；',
   '`Q[s,a] += α·(r + γ·max_a'' Q[s'',a''] - Q[s,a])`；off-policy 因为 target 用 max 而非实际所采动作。', '**考察点**：`Q[s,a] += α·(r + γ·max_a'' Q[s'',a''] - Q[s,a])`；off-policy 因为 target 用 max 而非实际所采动作。

**实现**：

```python
import numpy as np

def q_learning_step(Q, s, a, r, s2, done, alpha=0.1, gamma=0.99):
    # 终止时 V(s_T)=0：用 (1-done) 截断，避免跨 episode bootstrap
    td_target = r + gamma * Q[s2].max() * (1.0 - done)
    Q[s, a] += alpha * (td_target - Q[s, a])
    return Q

def eps_greedy(Q, s, eps, n_actions, rng):
    # 探索-利用平衡；ε 通常从 1.0 退到 0.05
    if rng.random() < eps:
        return rng.integers(n_actions)
    return int(Q[s].argmax())  # argmax 平 tie 时取索引最小
```',
   null, null, '["α 太大不收敛、太小爬太慢", "终止还加 `γ·max Q(s'')` 导致跨 episode bootstrap", "连续动作不能 max → 换 DDPG/SAC。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H01","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000156', '手撕 DQN（含 target net + replay buffer）', 'eaq-v02-h02', 'coding', 'medium', 'replay buffer 打破时序相关性；',
   'replay buffer 打破时序相关性；target net 稳定 bootstrap；target 上必须 `detach`。', '**考察点**：replay buffer 打破时序相关性；target net 稳定 bootstrap；target 上必须 `detach`。

**实现**：

```python
import random
from collections import deque
import torch
import torch.nn.functional as F

class ReplayBuffer:
    def __init__(self, cap): self.buf = deque(maxlen=cap)
    def push(self, *t): self.buf.append(t)
    def sample(self, n):
        s, a, r, s2, d = zip(*random.sample(self.buf, n))
        # 一次性堆叠为 batch tensor
        return [torch.as_tensor(x).float() if i != 1 else torch.as_tensor(x).long()
                for i, x in enumerate([s, a, r, s2, d])]

def dqn_loss(q_net, q_target_net, batch, gamma=0.99):
    s, a, r, s2, d = batch
    q_sa = q_net(s).gather(1, a.unsqueeze(1)).squeeze(1)
    with torch.no_grad():  # target net 不回传梯度
        target = r + gamma * q_target_net(s2).max(1).values * (1.0 - d)
    return F.smooth_l1_loss(q_sa, target)  # Huber 比 MSE 更稳
```',
   null, null, '["target 未 detach 导致梯度回灌", "done=True 还加 `γV(s'')`", "replay 容量太小样本相关性高。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H02","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000157', '手撕 PPO clipped objective（含 value loss + entropy）', 'eaq-v02-h03', 'coding', 'hard', '`min(r·A, clip(r,1-ε,1+ε)·A)`；',
   '`min(r·A, clip(r,1-ε,1+ε)·A)`；为何用 min（取悲观下界）；多 epoch 更新 ratio 偏离。', '**考察点**：`min(r·A, clip(r,1-ε,1+ε)·A)`；为何用 min（取悲观下界）；多 epoch 更新 ratio 偏离。

**实现**：

```python
import torch
import torch.nn.functional as F

def ppo_loss(logp_new, logp_old, adv, value, ret, entropy,
             clip=0.2, c1=0.5, c2=0.01):
    # logp_old 来自采样时旧策略，必须已 detach；adv 已做 GAE+归一化
    ratio = torch.exp(logp_new - logp_old)
    # advantage 标准化降方差；unbiased=False 防 batch=1 时 NaN
    adv = (adv - adv.mean()) / (adv.std(unbiased=False) + 1e-8)
    # min 取悲观下界：A>0 时上裁、A<0 时下裁
    unclipped = ratio * adv
    clipped = torch.clamp(ratio, 1 - clip, 1 + clip) * adv
    policy_loss = -torch.min(unclipped, clipped).mean()
    value_loss = F.mse_loss(value, ret)  # 或 clipped value loss
    # entropy 鼓励探索，整体 loss 取负 entropy
    return policy_loss + c1 * value_loss - c2 * entropy.mean()
```',
   null, null, '["`logp_old` 没 detach → 重复梯度", "entropy 符号错（loss 里应 -c2·H）", "多 epoch 不监控 KL，ratio 漂太远。"]'::jsonb, null, 10, false, true, 14, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H03","freq_label":"🔥×14"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000158', '手撕 GAE 优势估计', 'eaq-v02-h04', 'coding', 'medium', 'λ 在 0/1 之间权衡 bias/variance；',
   'λ 在 0/1 之间权衡 bias/variance；必须从后向前递归；`done` 处截断 bootstrap。', '**考察点**：λ 在 0/1 之间权衡 bias/variance；必须从后向前递归；`done` 处截断 bootstrap。

**实现**：

```python
import torch

def compute_gae(rewards, values, dones, last_value, gamma=0.99, lam=0.95):
    # rewards/values/dones: [T]；last_value: V(s_T)（bootstrap 用）
    T = len(rewards)
    adv = torch.zeros(T)
    gae = 0.0
    for t in reversed(range(T)):  # 必须反向
        # done 处截断：next_value 与 next_gae 都被 mask 掉
        next_v = last_value if t == T - 1 else values[t + 1]
        mask = 1.0 - dones[t]
        delta = rewards[t] + gamma * next_v * mask - values[t]
        gae = delta + gamma * lam * mask * gae
        adv[t] = gae
    # V_target 用旧 critic 的 values + adv，避免 critic 自指漂移
    returns = adv + values
    return adv, returns
```',
   null, null, '["正向遍历", "`done` 处没 mask", "`V_target` 用当前 critic 输出而非 `V_old` 导致训练抖。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H04","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000159', '手撕 DDPG / TD3 critic update', 'eaq-v02-h05', 'coding', 'medium', 'DDPG = 连续动作 Q-learning；',
   'DDPG = 连续动作 Q-learning；TD3 三大改进——双 Q、actor 延迟、target policy smoothing。', '**考察点**：DDPG = 连续动作 Q-learning；TD3 三大改进——双 Q、actor 延迟、target policy smoothing。

**实现**：

```python
import torch
import torch.nn.functional as F

def td3_critic_loss(q1, q2, q1_tgt, q2_tgt, mu_tgt, batch,
                    gamma=0.99, sigma=0.2, c=0.5):
    s, a, r, s2, d = batch
    with torch.no_grad():  # target 必须 detach
        # target policy smoothing：给 target 动作加 clipped noise
        noise = (torch.randn_like(a) * sigma).clamp(-c, c)
        a2 = (mu_tgt(s2) + noise).clamp(-1.0, 1.0)
        # 双 Q 取 min 抑制高估
        y = r + gamma * torch.min(q1_tgt(s2, a2), q2_tgt(s2, a2)) * (1.0 - d)
    return F.mse_loss(q1(s, a), y) + F.mse_loss(q2(s, a), y)

def td3_actor_loss(q1, mu, s):
    # actor 只用 Q1 上升（用 min 反而抑制学习）；每 2 个 critic step 调一次
    return -q1(s, mu(s)).mean()
```',
   null, null, '["target 未 detach", "actor 用 `min(Q1,Q2)` 抑制学习", "探索 noise 与 target smoothing noise 混淆（两件事）。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H05","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000160', '手撕 SAC（reparameterize + 可学温度 α）', 'eaq-v02-h06', 'coding', 'hard', 'max-entropy RL 目标；',
   'max-entropy RL 目标；reparam 让梯度穿过采样；tanh 雅可比修正保证 `log π` 归一化。', '**考察点**：max-entropy RL 目标；reparam 让梯度穿过采样；tanh 雅可比修正保证 `log π` 归一化。

**实现**：

```python
import torch
import torch.nn.functional as F
from torch.distributions import Normal

def sample_action(mu, log_std):
    # reparameterize：u = μ + σ·ε，ε 与策略参数独立
    std = log_std.exp()
    normal = Normal(mu, std)
    u = normal.rsample()  # rsample 走 reparam path，sample 会断梯度
    a = torch.tanh(u)
    # tanh 雅可比修正：log π(a) = log p(u) - Σ log(1 - tanh(u)²)
    log_p = normal.log_prob(u) - torch.log(1 - a.pow(2) + 1e-6)
    return a, log_p.sum(-1, keepdim=True)

def sac_critic_target(r, s2, mu_t, logstd_t, q1_t, q2_t, log_alpha,
                      gamma=0.99, done=0.0):
    with torch.no_grad():
        a2, logp2 = sample_action(mu_t(s2), logstd_t(s2))
        # 双 Q min 抑制高估；减 α·log π 体现 max-entropy 目标
        q_next = torch.min(q1_t(s2, a2), q2_t(s2, a2)) - log_alpha.exp() * logp2
        return r + gamma * q_next * (1.0 - done)

def alpha_loss(log_alpha, log_pi, target_ent):
    # target_ent 一般 -|A|；log π 须 detach
    return -(log_alpha * (log_pi.detach() + target_ent)).mean()
```',
   null, null, '["用 `sample()` 而非 `rsample()` 断梯度", "忘 tanh 雅可比 → π 不归一", "`α` 不学卡死", "`target_ent` 设错。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H06","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000161', '手撕 DPO loss', 'eaq-v02-h07', 'coding', 'medium', '从 RLHF 推导；',
   '从 RLHF 推导；只需 ref + policy 两个模型（无 reward model）；β 控制 KL 强度。', '**考察点**：从 RLHF 推导；只需 ref + policy 两个模型（无 reward model）；β 控制 KL 强度。

**实现**：

```python
import torch
import torch.nn.functional as F

def dpo_loss(policy, ref, batch, beta=0.1):
    # batch: prompt + chosen/rejected response token ids + mask（标记 response 段）
    # 只在 response token 上累加 log_prob，prompt 段必须屏蔽
    def logp_seq(model, ids, resp_mask):
        logits = model(ids).logits[:, :-1]  # 预测下一 token
        tgt = ids[:, 1:]
        m = resp_mask[:, 1:].float()  # 与 tgt 对齐
        # gather token-level log_prob，再按 response mask 求和
        lp = F.log_softmax(logits, -1).gather(-1, tgt.unsqueeze(-1)).squeeze(-1)
        return (lp * m).sum(-1)

    lp_w_pi = logp_seq(policy, batch[''ids_w''], batch[''mask_w''])
    lp_l_pi = logp_seq(policy, batch[''ids_l''], batch[''mask_l''])
    with torch.no_grad():  # ref 必须 freeze
        lp_w_ref = logp_seq(ref, batch[''ids_w''], batch[''mask_w''])
        lp_l_ref = logp_seq(ref, batch[''ids_l''], batch[''mask_l''])
    # 隐式 reward 差：β·[(logπ-logπ_ref)_w - (logπ-logπ_ref)_l]
    logits = beta * ((lp_w_pi - lp_w_ref) - (lp_l_pi - lp_l_ref))
    return -F.logsigmoid(logits).mean()
```',
   null, null, '["ref 未 freeze 协同漂移", "β 跟温度混淆", "prompt token 的 log_prob 未屏蔽", "padding token 也累加。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H07","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000162', '手撕 GRPO loss（group relative policy opt）', 'eaq-v02-h08', 'coding', 'hard', 'DeepSeek-R1 用的 RL；',
   'DeepSeek-R1 用的 RL；group baseline 替代 critic（省一份 value 模型显存）；在线 RL（vs DPO 离线）。', '**考察点**：DeepSeek-R1 用的 RL；group baseline 替代 critic（省一份 value 模型显存）；在线 RL（vs DPO 离线）。

**实现**：

```python
import torch

def grpo_advantage(rewards):
    # rewards: [B, G]，每 prompt 采 G 个 response
    # baseline=组内均值；除组内 std 做 z-score；unbiased=False 防 G=1 NaN
    mean = rewards.mean(dim=-1, keepdim=True)
    std = rewards.std(dim=-1, keepdim=True, unbiased=False) + 1e-8
    return (rewards - mean) / std

def grpo_loss(logp_new, logp_old, logp_ref, rewards, resp_mask,
              clip=0.2, kl_coef=0.04):
    # logp_*: [B, G, T]；resp_mask: [B, G, T] 标记 response token（屏蔽 prompt/padding）
    adv = grpo_advantage(rewards).unsqueeze(-1)            # [B, G, 1]
    ratio = torch.exp(logp_new - logp_old.detach())
    unclipped = ratio * adv
    clipped = torch.clamp(ratio, 1 - clip, 1 + clip) * adv
    pg = -torch.min(unclipped, clipped)                    # token-level
    # k3 KL 估计（DeepSeekMath 用法）：log(p/q)+(q/p)-1，对 ref 做正则
    log_r = logp_ref.detach() - logp_new
    kl = log_r.exp() - log_r - 1
    loss = (pg + kl_coef * kl) * resp_mask                 # 只在 response 段计 loss
    return loss.sum() / resp_mask.sum().clamp(min=1.0)     # 按有效 token 数归一
```',
   null, null, '["把 GRPO 当 DPO（GRPO 在线 RL）", "忘 response mask 把 prompt/padding 也算进 loss", "漏 KL/ref 正则", "`std` 用 `unbiased=True` 在 G=1 时 NaN。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H08","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000163', '手撕 importance sampling 比率', 'eaq-v02-h09', 'coding', 'medium', '`E_p[f]=E_q[f·p/q]`；',
   '`E_p[f]=E_q[f·p/q]`；off-policy 必须用；多步累乘 IS 方差指数爆炸 → PPO clip / V-trace 截断。', '**考察点**：`E_p[f]=E_q[f·p/q]`；off-policy 必须用；多步累乘 IS 方差指数爆炸 → PPO clip / V-trace 截断。

**实现**：

```python
import torch

def is_ratio(logp_new, logp_old):
    # 用 log_prob 之差再 exp，避免概率小数下溢
    # logp_old 必须来自采样时旧策略（detach），不可用当前网络重算
    return torch.exp(logp_new - logp_old.detach())

def vtrace_truncated(logp_new, logp_old, rho_bar=1.0, c_bar=1.0):
    # V-trace 双截断：ρ 控 target、c 控 trace 传播
    log_r = logp_new - logp_old.detach()
    rho = torch.exp(log_r).clamp(max=rho_bar)
    c = torch.exp(log_r).clamp(max=c_bar)
    return rho, c
```',
   null, null, '["用 `probs` 比例而非 `log_prob` 之差 → 数值不稳", "忘 detach old", "多步累乘不截断方差爆炸。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H09","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000164', '手撕 Categorical 采样 + log_prob', 'eaq-v02-h10', 'coding', 'easy', '多项式采样；',
   '多项式采样；为何 `logits` 比 `probs` 数值稳（避免 `log(0)`）；与 `multinomial` 区别。', '**考察点**：多项式采样；为何 `logits` 比 `probs` 数值稳（避免 `log(0)`）；与 `multinomial` 区别。

**实现**：

```python
import torch
import torch.nn.functional as F
from torch.distributions import Categorical

def categorical_sample(logits):
    # logits: [B, n_actions]；推荐用 logits 入参，内部做 log_softmax
    dist = Categorical(logits=logits)
    a = dist.sample()                # [B]
    log_prob = dist.log_prob(a)      # [B]，等价于下方 gather 公式
    entropy = dist.entropy()         # [B]，policy 正则常用
    return a, log_prob, entropy

def manual_log_prob(logits, a):
    # 等价于 Categorical.log_prob，但展示底层
    # F.log_softmax 比 log(softmax) 数值稳（用 LogSumExp）
    return F.log_softmax(logits, -1).gather(-1, a.unsqueeze(-1)).squeeze(-1)
```',
   null, null, '["用 `probs` 输入但概率为 0 时 `log(0)`", "`torch.multinomial` 不直接返回 log_prob", "gather 维度未 unsqueeze。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"02","volume_title":"卷二 · RL 算法","section":"手撕代码","qid":"H10","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000165', 'Behavior Cloning（BC）是什么？为什么会有 covariate shift？怎么缓解？', 'eaq-v03-q01', 'knowledge', 'easy', 'BC 用专家示教做监督学习，拟合给定观测下的动作。',
   'BC 用专家示教做监督学习，拟合给定观测下的动作。部署时策略偏离专家轨迹，会访问训练覆盖不足的状态，误差可能继续放大，这就是策略诱导的分布偏移。可用 DAgger 查询策略访问态的专家动作，补充恢复与失败数据，提高场景覆盖，并结合反馈重规划。动作块有助于时间一致性，但不是解决分布偏移的保证。', 'BC 用专家示教做监督学习，拟合给定观测下的动作。部署时策略偏离专家轨迹，会访问训练覆盖不足的状态，误差可能继续放大，这就是策略诱导的分布偏移。可用 DAgger 查询策略访问态的专家动作，补充恢复与失败数据，提高场景覆盖，并结合反馈重规划。动作块有助于时间一致性，但不是解决分布偏移的保证。',
   null, null, '["单步监督误差小不保证长程成功", "DAgger 的效果依赖专家查询和学习条件，不能简单说它“几乎消除”所有偏移。"]'::jsonb, null, 3, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q01","freq_label":"🔥×12","provenance":"核验：[DAgger 原论文](https://proceedings.mlr.press/v15/ross11a.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000166', 'BC、DAgger、GAIL、IRL 的区别与适用场景？', 'eaq-v03-q02', 'knowledge', 'easy', '**BC**：监督学习直接学 $\pi(a\mid s)$；',
   '- **BC**：监督学习直接学 $\pi(a\mid s)$；简单、需要大量演示，有 shift。**场景**：数据足、任务短。
- **DAgger**：BC + 主动学习，迭代让策略访问的新状态由专家标注；几乎消除 shift。**场景**：专家在线可查询（仿真 / 人在回路）。
- **GAIL**：生成对抗 IL，判别器区分"策略 vs 专家"轨迹，policy 通过 RL 最大化欺骗判别器；无需 reward。**场景**：复杂行为、reward 难写。
- **IRL**：反推 reward function $R(s,a)$，再 RL 求解；可解释、可泛化。**场景**：想理解专家"为什么这么做"。', '- **BC**：监督学习直接学 $\pi(a\mid s)$；简单、需要大量演示，有 shift。**场景**：数据足、任务短。
- **DAgger**：BC + 主动学习，迭代让策略访问的新状态由专家标注；几乎消除 shift。**场景**：专家在线可查询（仿真 / 人在回路）。
- **GAIL**：生成对抗 IL，判别器区分"策略 vs 专家"轨迹，policy 通过 RL 最大化欺骗判别器；无需 reward。**场景**：复杂行为、reward 难写。
- **IRL**：反推 reward function $R(s,a)$，再 RL 求解；可解释、可泛化。**场景**：想理解专家"为什么这么做"。',
   null, null, '["DAgger 不是 BC 的\"训练 trick\"，是要持续访问专家", "GAIL 训练不稳（GAN 通病），机器人上较少用。"]'::jsonb, null, 3, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q02","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000167', 'DDPG / PPO / TD3 / SAC 的区别？哪些更适合机器人连续控制？', 'eaq-v03-q03', 'knowledge', 'easy', '**DDPG**：off-policy actor-critic，确定性策略 + Q-learning；',
   '- **DDPG**：off-policy actor-critic，确定性策略 + Q-learning；连续动作开山之作，但 Q 易过估、超参敏感。
- **TD3**：DDPG + **双 Q**（取 min 缓过估）+ **delayed actor update** + **target policy smoothing**；稳但保守。
- **SAC**：max-entropy 框架，policy 输出 $\pi(\cdot\mid s) = \mathcal{N}(\mu_\theta, \sigma_\theta)$ + **自动 temperature**；探索好、sample efficient。
- **PPO**：on-policy，clip ratio 限制策略更新；样本贵但稳，常用于 RLHF / VLA 微调。', '- **DDPG**：off-policy actor-critic，确定性策略 + Q-learning；连续动作开山之作，但 Q 易过估、超参敏感。
- **TD3**：DDPG + **双 Q**（取 min 缓过估）+ **delayed actor update** + **target policy smoothing**；稳但保守。
- **SAC**：max-entropy 框架，policy 输出 $\pi(\cdot\mid s) = \mathcal{N}(\mu_\theta, \sigma_\theta)$ + **自动 temperature**；探索好、sample efficient。
- **PPO**：on-policy，clip ratio 限制策略更新；样本贵但稳，常用于 RLHF / VLA 微调。

**机器人推荐**：① 真机 sample 贵 → **SAC**（off-policy + 探索强）；② 仿真大规模 + 稳定性优先 → **PPO**；③ VLA + LLM 风格微调 → **PPO**（与 RLHF 一致）。',
   null, null, '["SAC 的 entropy 不是\"探索 trick\"，是 max-entropy RL 的正则项", "temperature α 自动调比手调好得多。"]'::jsonb, null, 3, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q03","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000168', 'Mobile ALOHA 怎么解决"移动 + 双臂"协同？它和静态 ALOHA 的数据怎么联合训练？', 'eaq-v03-q04', 'knowledge', 'medium', 'Mobile ALOHA 在双臂系统上加入移动底盘和全身遥操作接口，同步记录移动与操作示教；',
   'Mobile ALOHA 在双臂系统上加入移动底盘和全身遥操作接口，同步记录移动与操作示教；策略可联合预测手臂、夹爪和底盘动作。训练时将移动任务数据与静态 ALOHA 数据混合，利用后者的操作经验提高数据效率。原论文以每任务 50 条移动示教评估，收益随任务与方法变化。', 'Mobile ALOHA 在双臂系统上加入移动底盘和全身遥操作接口，同步记录移动与操作示教；策略可联合预测手臂、夹爪和底盘动作。训练时将移动任务数据与静态 ALOHA 数据混合，利用后者的操作经验提高数据效率。原论文以每任务 50 条移动示教评估，收益随任务与方法变化。',
   null, null, '["不能把论文不同任务汇总成统一“30% 提升到 90%”", "动作维数须先说明是关节加夹爪还是仅机械自由度。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q04","freq_label":"🔥×5","provenance":"核验：[Mobile ALOHA 作者页](https://mobile-aloha.github.io/)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000169', '解释 Markov 性质，为什么 RL 假设 MDP？POMDP 是怎么扩展的？', 'eaq-v03-q05', 'knowledge', 'easy', '**Markov 性质**：$P(s_{t+1} \mid s_t, a_t, s_{<t}, a_{<t}) = P(s_{t+1} \mid s_t, a_t)$，即下一状态只依赖当前 $(s, a)$，与历史无关。',
   '**Markov 性质**：$P(s_{t+1} \mid s_t, a_t, s_{<t}, a_{<t}) = P(s_{t+1} \mid s_t, a_t)$，即下一状态只依赖当前 $(s, a)$，与历史无关。', '**Markov 性质**：$P(s_{t+1} \mid s_t, a_t, s_{<t}, a_{<t}) = P(s_{t+1} \mid s_t, a_t)$，即下一状态只依赖当前 $(s, a)$，与历史无关。

**MDP**：$\langle S, A, P, R, \gamma \rangle$，假设 **fully observable**（agent 看到的就是真实 state）；Bellman 方程可解，DP/RL 算法都依赖它。

**POMDP**：加观测函数 $O$，agent 收到 $o_t = O(s_t)$ 而非真实 $s_t$；用 **belief state** $b_t = P(s_t \mid o_{\leq t}, a_{<t})$ 替代 $s_t$，或用 RNN/Transformer 编码历史。

**机器人现实**：几乎都是 POMDP（相机有限视野、力觉噪声、遮挡）；这是为什么 VLA 多用 history 帧 + 序列模型，而非单帧。',
   null, null, '["POMDP 不等于\"不能 RL\"，只是要换 belief 或 history-conditioning。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q05","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000170', '值迭代和策略迭代的区别？最优值函数为什么直接对应最优策略？', 'eaq-v03-q06', 'knowledge', 'easy', '**值迭代（VI）**：反复迭代 $V_{k+1}(s) = \max_a [R(s,a) + \gamma \mathbb{E}_{s''} V_k(s'')]$ 直到收敛 $V^*$，最后 $\pi^*(s) = \a…',
   '- **值迭代（VI）**：反复迭代 $V_{k+1}(s) = \max_a [R(s,a) + \gamma \mathbb{E}_{s''} V_k(s'')]$ 直到收敛 $V^*$，最后 $\pi^*(s) = \arg\max_a Q^*(s, a)$。
- **策略迭代（PI）**：两步交替——① **评估**：解线性方程组求 $V^\pi$；② **改进**：$\pi''(s) = \arg\max_a Q^\pi(s, a)$。', '- **值迭代（VI）**：反复迭代 $V_{k+1}(s) = \max_a [R(s,a) + \gamma \mathbb{E}_{s''} V_k(s'')]$ 直到收敛 $V^*$，最后 $\pi^*(s) = \arg\max_a Q^*(s, a)$。
- **策略迭代（PI）**：两步交替——① **评估**：解线性方程组求 $V^\pi$；② **改进**：$\pi''(s) = \arg\max_a Q^\pi(s, a)$。

**区别**：VI 每步只做"局部 max + 一步 lookahead"，便宜但需更多迭代；PI 每步评估完整 $V^\pi$，贵但收敛步数少。两者都收敛到 $V^*$。

**最优值 → 最优策略**：定义 $\pi^*(s) = \arg\max_a [R(s,a) + \gamma \,\mathbb{E}_{s'' \sim P(\cdot \mid s,a)}\, V^*(s'')]$，由 Bellman 最优方程，这就是 greedy w.r.t. $V^*$；所以 $V^*$ 解出来策略也"白送"。',
   null, null, '["PI 的\"评估\"步在状态多时需要近似（GPI 即 partial PI）", "VI 在大状态空间退化成 Q-learning。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q06","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000171', 'model-based RL 和 model-free RL 的区别？哪种更适合 sample-expensive 的真机训练？', 'eaq-v03-q07', 'knowledge', 'easy', '**Model-free**：直接学策略 $\pi$ 或值函数 $Q$，不显式建模环境（PPO/SAC/DQN）；',
   '- **Model-free**：直接学策略 $\pi$ 或值函数 $Q$，不显式建模环境（PPO/SAC/DQN）；简单、稳，但 sample efficiency 差。
- **Model-based**：先学环境动力学 $\hat{P}(s''\mid s,a)$ 与 $\hat{R}$，再用模型做规划（CEM/MPPI）或 imagination 训 policy（Dreamer/MuZero）；sample efficient 5-100×。', '- **Model-free**：直接学策略 $\pi$ 或值函数 $Q$，不显式建模环境（PPO/SAC/DQN）；简单、稳，但 sample efficiency 差。
- **Model-based**：先学环境动力学 $\hat{P}(s''\mid s,a)$ 与 $\hat{R}$，再用模型做规划（CEM/MPPI）或 imagination 训 policy（Dreamer/MuZero）；sample efficient 5-100×。

**真机首选 model-based**：真机数据贵（1 次抓取 30s + reset），model-based 用 1/10 数据达到 model-free 效果。

**但有坑**：① **Model error 累积**：长程 rollout 误差爆炸（→ short horizon / 不确定性正则）；② 真机分布与模型分布不一致（→ DAgger 思路收集 on-policy 数据回训模型）。

**实务路线**：仿真 model-free 预训练 → 真机 model-based 精调；或 offline RL 先吃所有历史数据，再 model-based 精调。',
   null, null, '["Dreamer 不是 model-free，是 model-based + latent dynamics + imagination。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q07","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000172', 'GAE（Generalized Advantage Estimation）是什么？为什么 PPO 离不开它？', 'eaq-v03-q08', 'knowledge', 'easy', '**GAE** 是 advantage 估计器，在 high-variance MC 和 high-bias TD 之间用 $\lambda$ 插值。',
   '**GAE** 是 advantage 估计器，在 high-variance MC 和 high-bias TD 之间用 $\lambda$ 插值：', '**GAE** 是 advantage 估计器，在 high-variance MC 和 high-bias TD 之间用 $\lambda$ 插值：

$$\hat{A}_t^{\text{GAE}(\gamma, \lambda)} = \sum_{l=0}^\infty (\gamma\lambda)^l \delta_{t+l}, \quad \delta_t = r_t + \gamma V(s_{t+1}) - V(s_t)$$

- $\lambda=1$：纯 MC，方差大、无 bias；
- $\lambda=0$：纯 TD，方差小、有 bias；
- 实务 $\lambda \approx 0.95$, $\gamma \approx 0.99$ 是甜区。

**PPO 离不开**：PPO 的目标是 $\mathbb{E}[\min(r_t \hat{A}_t, \text{clip}(r_t, 1\pm\epsilon)\hat{A}_t)]$，**没有 $\hat{A}$ 就没有 PPO**。GAE 给 $\hat{A}$ 提供低方差估计，是 PPO 在机器人/RLHF 上稳定收敛的关键。',
   null, null, '["GAE 不是\"PPO 专属\"，TRPO / A3C 都能用", "但 PPO clip + GAE 是最常见组合。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"模仿学习理论基础","qid":"Q08","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000173', 'OpenVLA 和 RT-2 在架构上的主要区别？OpenVLA 用 7B Llama-2 凭什么打过 55B 的 RT-2-X？', 'eaq-v03-q09', 'knowledge', 'medium', '| | OpenVLA | RT-2 / RT-2-X |',
   '| | OpenVLA | RT-2 / RT-2-X |
|---|---|---|
| Backbone | Llama-2 **7B**（Prismatic 框架） | PaLI-X **55B** 或 PaLM-E **12B**（闭源） |
| 视觉 | **SigLIP + DINOv2 双路** | PaLI-X / PaLM-E 内置 ViT（含 ViT-22B 等） |
| 动作头 | 每维 256 bin 离散化 → 复用 LLM 词表最不常用 256 token | 同 |
| 训练数据 | Open-X-Embodiment **970K** 轨迹 | Google 内部 + Open-X |
| 开源 | ✅ 全开源 + LoRA-friendly | ❌ 闭源 |', '| | OpenVLA | RT-2 / RT-2-X |
|---|---|---|
| Backbone | Llama-2 **7B**（Prismatic 框架） | PaLI-X **55B** 或 PaLM-E **12B**（闭源） |
| 视觉 | **SigLIP + DINOv2 双路** | PaLI-X / PaLM-E 内置 ViT（含 ViT-22B 等） |
| 动作头 | 每维 256 bin 离散化 → 复用 LLM 词表最不常用 256 token | 同 |
| 训练数据 | Open-X-Embodiment **970K** 轨迹 | Google 内部 + Open-X |
| 开源 | ✅ 全开源 + LoRA-friendly | ❌ 闭源 |

**胜出原因**：① **DINOv2 补足空间几何**——CLIP/SigLIP 偏语义弱几何，DINOv2 自监督预训练对空间结构更敏感；② Llama-2 web 文本 + 代码预训练更稳；③ 全开源使社区微调迭代更快。',
   null, null, '["OpenVLA 不是\"小胜大\"玄学——是同等 fine-tune 量上的工程整合优势", "零样本新任务上 RT-2-X 仍可能更强。"]'::jsonb, null, 5, true, true, 15, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q09","freq_label":"🔥×15"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000174', 'RT-2 是怎么把动作编码成 token 的？为什么这种"动作即文本 token"方案有效但效率不高？', 'eaq-v03-q10', 'knowledge', 'medium', 'RT-2 将动作表示为八个离散字段：结束标志、末端三维平移、三维旋转和夹爪；',
   'RT-2 将动作表示为八个离散字段：结束标志、末端三维平移、三维旋转和夹爪；连续量按范围量化为 256 档，再以模型可输出的 token 序列表示，与视觉语言任务联合微调。好处是复用 VLM 的语义知识与序列建模能力；代价是逐 token 生成带来的延迟，以及动作量化误差。具体 token 映射随 VLM 实现而异。', 'RT-2 将动作表示为八个离散字段：结束标志、末端三维平移、三维旋转和夹爪；连续量按范围量化为 256 档，再以模型可输出的 token 序列表示，与视觉语言任务联合微调。好处是复用 VLM 的语义知识与序列建模能力；代价是逐 token 生成带来的延迟，以及动作量化误差。具体 token 映射随 VLM 实现而异。',
   null, null, '["RT-2 的八字段含结束标志", "不要与 OpenVLA 常见的七维动作及词表映射混为一谈，也不能由 256 档推出某类插针任务必然失败。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q10","freq_label":"🔥×9","provenance":"核验：[RT-2 原论文](https://arxiv.org/html/2307.15818)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000175', 'π0、π0.5、π0.6／π*0.6 的差异是什么？KI 与 RECAP 怎样区分？', 'eaq-v03-q11', 'knowledge', 'hard', 'π0 结合预训练 VLM 与 flow 动作专家；',
   'π0 结合预训练 VLM 与 flow 动作专家；π0.5 侧重多源联合训练和开放场景泛化。π0.6 是后续基座，π*0.6 使用 RECAP，从示教、自主执行和人工纠正数据中做优势条件策略学习。KI 是控制连续动作专家梯度对 VLM 影响的训练方法，不等于完全冻结主干。π0.7 的官方发布日期是 2026-04-16，强调多样条件与组合泛化。', 'π0 结合预训练 VLM 与 flow 动作专家；π0.5 侧重多源联合训练和开放场景泛化。π0.6 是后续基座，π*0.6 使用 RECAP，从示教、自主执行和人工纠正数据中做优势条件策略学习。KI 是控制连续动作专家梯度对 VLM 影响的训练方法，不等于完全冻结主干。π0.7 的官方发布日期是 2026-04-16，强调多样条件与组合泛化。',
   null, null, '["不能把 π0.6 基座与 π*0.6／RECAP 等同，也不能把优势条件化简写成“高质量 token 加权”", "版本能力须按各自原文与实验设置说明。"]'::jsonb, null, 8, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q11","freq_label":"🔥×8","provenance":"核验：[KI 原论文](https://arxiv.org/abs/2505.23705)、[RECAP 原论文](https://arxiv.org/abs/2511.14759)、[π0.7 官方说明](https://www.pi.website/blog/pi07)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000176', 'RDT-1B、Octo、GR00T-N1 都是 VLA，它们的动作头分别长什么样？哪种结构更"重"？', 'eaq-v03-q12', 'knowledge', 'medium', '| 模型 | 总参 | 动作头 | "重量" |',
   '| 模型 | 总参 | 动作头 | "重量" |
|---|---|---|---|
| **RDT-1B**（2024-10） | 1.2B | 整个 1.2B Transformer 当 **diffusion denoiser** | **最重** |
| **Octo**（2024-05） | ~93M | 小 Transformer encoder + **小 diffusion head（~10M）** | **最轻** |
| **GR00T-N1**（2025） | 2.2B | VLM 1.34B + **Action Expert 0.86B**（Flow Matching） | 中重 |', '| 模型 | 总参 | 动作头 | "重量" |
|---|---|---|---|
| **RDT-1B**（2024-10） | 1.2B | 整个 1.2B Transformer 当 **diffusion denoiser** | **最重** |
| **Octo**（2024-05） | ~93M | 小 Transformer encoder + **小 diffusion head（~10M）** | **最轻** |
| **GR00T-N1**（2025） | 2.2B | VLM 1.34B + **Action Expert 0.86B**（Flow Matching） | 中重 |

**trade-off**：
- Head 太轻（Octo）→ 多模态动作分布建模能力受限，复杂任务难。
- Head 太重（RDT）→ 表达力强但推理慢、训练贵。
- GR00T-N1 中庸路线，借鉴 π0 的 backbone + expert 拆分思路。',
   null, null, '["RDT-1B 不是\"另一个 OpenVLA\"——它没用 LLM token 离散化，直接 backbone 当 denoiser", "这是与 OpenVLA / RT-2 范式不同的\"端到端 diffusion VLA\"。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q12","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000177', 'FAST tokenizer 怎么结合 DCT 与 BPE？动作压缩率和推理加速是一回事吗？', 'eaq-v03-q13', 'knowledge', 'medium', '先归一化动作块，对各动作维的时间序列做 DCT，缩放并量化系数，按频率顺序展开，再用针对动作系数训练的 BPE 压缩重复模式。',
   '先归一化动作块，对各动作维的时间序列做 DCT，缩放并量化系数，按频率顺序展开，再用针对动作系数训练的 BPE 压缩重复模式。它利用动作的时间相关性，使自回归模型用较少 token 表达整段动作。作者报告典型每块 30–60 token；压缩率、失真和速度取决于数据、块长及实现。', '先归一化动作块，对各动作维的时间序列做 DCT，缩放并量化系数，按频率顺序展开，再用针对动作系数训练的 BPE 压缩重复模式。它利用动作的时间相关性，使自回归模型用较少 token 表达整段动作。作者报告典型每块 30–60 token；压缩率、失真和速度取决于数据、块长及实现。',
   null, null, '["论文的最高约 5 倍是训练加速", "不能写成固定 5–10 倍推理加速，作者明确指出 π0-FAST 的 AR 推理比原 π0 的 flow 解码慢。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q13","freq_label":"🔥×6","provenance":"核验：[FAST 作者说明](https://www.pi.website/research/fast)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000178', 'OpenVLA 如何把动作离散化为 256 个 bin？量化和动作解码有哪些局限？', 'eaq-v03-q14', 'knowledge', 'medium', 'OpenVLA 将七维动作各自按训练数据的分位数范围归一化，再划分为 256 档，映射到动作 token，使用条件自回归分布训练。',
   'OpenVLA 将七维动作各自按训练数据的分位数范围归一化，再划分为 256 档，映射到动作 token，使用条件自回归分布训练。局限包括量化分辨率、超范围截断，以及连续动作块需要较多串行 token。量化误差须结合动作量程、控制接口和闭环容差评估；可比较连续动作头或压缩动作块。', 'OpenVLA 将七维动作各自按训练数据的分位数范围归一化，再划分为 256 档，映射到动作 token，使用条件自回归分布训练。局限包括量化分辨率、超范围截断，以及连续动作块需要较多串行 token。量化误差须结合动作量程、控制接口和闭环容差评估；可比较连续动作头或压缩动作块。',
   null, null, '["categorical 分布可以有多个高概率峰", "不能说“256 档就是单峰”。离散精度不足、解码选取和多模态建模是不同问题。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q14","freq_label":"🔥×5","provenance":"核验：[OpenVLA 原论文](https://arxiv.org/html/2406.09246)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000179', 'RT-1 → RT-2 → RT-X 的演进逻辑是什么？每一代的关键创新是什么？', 'eaq-v03-q15', 'knowledge', 'easy', '**RT-1**（2022）：EfficientNet + FiLM + Token Learner；',
   '- **RT-1**（2022）：EfficientNet + FiLM + Token Learner；**130K 真机数据**；首个 large-scale robot Transformer paradigm，但无 web 知识。
- **RT-2**（2023）：PaLI-X 55B / PaLM-E 12B + 动作 token + **co-finetune（web + robot data）**；**首次把 web 知识灌入 robot policy**。
- **RT-X**（2023-10）：RT-1 / RT-2 在 **Open-X-Embodiment**（~60 datasets / 22 embodiments / 1M+ trajectories）上跨形态训练（实验用 robotics mixture 子集），验证跨 embodiment 泛化。OpenVLA 后续用 OXE 中约 **970K** curated demos 微调。', '- **RT-1**（2022）：EfficientNet + FiLM + Token Learner；**130K 真机数据**；首个 large-scale robot Transformer paradigm，但无 web 知识。
- **RT-2**（2023）：PaLI-X 55B / PaLM-E 12B + 动作 token + **co-finetune（web + robot data）**；**首次把 web 知识灌入 robot policy**。
- **RT-X**（2023-10）：RT-1 / RT-2 在 **Open-X-Embodiment**（~60 datasets / 22 embodiments / 1M+ trajectories）上跨形态训练（实验用 robotics mixture 子集），验证跨 embodiment 泛化。OpenVLA 后续用 OXE 中约 **970K** curated demos 微调。

**主线**：RT-1 证 paradigm → RT-2 引 web 先验 → RT-X 验证联合训练。OpenVLA 是 RT-X 路线的开源版。',
   null, null, '["RT-2 核心是 **co-finetune** 引入 web 数据，不是\"放大版 RT-1\"。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"VLA 模型架构时间线","qid":"Q15","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000180', 'π0 为什么用 Flow Matching 而不是 Diffusion？50 Hz 控制频率背后的工程考量是什么？', 'eaq-v03-q19', 'knowledge', 'medium', '**Flow Matching 优点**。',
   '**Flow Matching 优点**：
1. **训练更稳**：学速度场 $v_\theta$ 回归 $v^* = x_1 - x_0$，数值范围紧凑；diffusion 学 $\varepsilon$ 范围大、训练易抖。
2. **推理步数少**：10 步 ODE 即可 vs DDPM 50 步；省去 cosine/linear schedule 超参。
3. **路径显式**：$x_\tau = \tau x_1 + (1-\tau) x_0$，方差 $(1-\tau)^2 I$（不是 $(1-\tau) I$，常见笔误）。', '**Flow Matching 优点**：
1. **训练更稳**：学速度场 $v_\theta$ 回归 $v^* = x_1 - x_0$，数值范围紧凑；diffusion 学 $\varepsilon$ 范围大、训练易抖。
2. **推理步数少**：10 步 ODE 即可 vs DDPM 50 步；省去 cosine/linear schedule 超参。
3. **路径显式**：$x_\tau = \tau x_1 + (1-\tau) x_0$，方差 $(1-\tau)^2 I$（不是 $(1-\tau) I$，常见笔误）。

**50 Hz 工程考量**：控制频率 50 Hz（20 ms / step）由底层执行端按 chunk 消耗动作。H=50 = **覆盖时长** ≈1 秒；**重规划频率**由 execution horizon / temporal ensemble / 异步队列决定，不是固定 1 Hz。',
   null, null, '["50 Hz = 控制频率，H=50 = 覆盖时长，两者不要混成\"每秒重算一次 chunk\"。"]'::jsonb, null, 5, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Diffusion Policy / Flow Matching","qid":"Q19","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000181', 'Diffusion Policy 推理时用 DDPM 还是 DDIM？步数怎么选才能既快又准？', 'eaq-v03-q21', 'knowledge', 'medium', '**训练同一 $\varepsilon_\theta$**，部署时按需选采样器。',
   '**训练同一 $\varepsilon_\theta$**，部署时按需选采样器。', '**训练同一 $\varepsilon_\theta$**，部署时按需选采样器。

- **DDPM**：reverse SDE，**stochastic**，50+ step；高质量但慢；适合离线生成/训练监督。
- **DDIM**：reverse ODE，**deterministic**，10-20 step 可达 DDPM 50 步质量；适合实时机器人。

**步数选择**：
- 实时 50 Hz 控制 → DDIM 10 步（≈ 20 ms / chunk）。
- 离线评估 / 高质量生成 → DDPM 50 步。
- 一般任务 → DDIM 20 步是甜区。

**DDIM 早期 OOD 坑**：DDIM 在去噪**早期步**（$\tau$ 接近 1，即接近纯噪声）对 OOD 状态敏感，可能输出非平滑动作；Reactive DP / 调度优化可缓解。',
   null, null, '["DDIM 不是\"绝对不如 DDPM\"——它在 chunk 中段/后段表现一致，只是早期 OOD 步需要小心。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Diffusion Policy / Flow Matching","qid":"Q21","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000182', 'ACT 和 Diffusion Policy 各自适合什么任务？硬件 / 任务复杂度上谁更稳？', 'eaq-v03-q22', 'knowledge', 'medium', '| | ACT | Diffusion Policy |',
   '| | ACT | Diffusion Policy |
|---|---|---|
| 结构 | CVAE + Transformer | Diffusion 模型 |
| 推理 | 单 forward（快） | 10-50 step（慢） |
| 多模态 | 通过 latent z 建模 | 天然多模态 |
| 适合任务 | **精细 manipulation**（插针、烹饪、ALOHA） | **多解 / 长程任务**（推杆、堆叠、避障） |
| 硬件 | 单卡可跑实时 | 需并行解码或蒸馏 |', '| | ACT | Diffusion Policy |
|---|---|---|
| 结构 | CVAE + Transformer | Diffusion 模型 |
| 推理 | 单 forward（快） | 10-50 step（慢） |
| 多模态 | 通过 latent z 建模 | 天然多模态 |
| 适合任务 | **精细 manipulation**（插针、烹饪、ALOHA） | **多解 / 长程任务**（推杆、堆叠、避障） |
| 硬件 | 单卡可跑实时 | 需并行解码或蒸馏 |

**口诀**：**"ACT 出拳快，DP 内功深"**。

**选择**：
1. 任务有多专家路径（多解）→ DP。
2. 任务单解但精度高 → ACT。
3. 实时 50 Hz 严苛 → ACT。
4. 多任务通用 backbone → DP（配合并行加速）。',
   null, null, '["DP 不是\"通用更好\"", "在 ALOHA 一类精细任务上 ACT 仍是 SOTA 之一。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Diffusion Policy / Flow Matching","qid":"Q22","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000183', 'Reactive Diffusion Policy / Slow-Fast Diffusion Policy 是怎么解决 DP 推理慢的？', 'eaq-v03-q23', 'knowledge', 'hard', '**问题**：DP 推理 10-50 step，高频接触控制不可行。',
   '**问题**：DP 推理 10-50 step，高频接触控制不可行。', '**问题**：DP 推理 10-50 step，高频接触控制不可行。

**Reactive Diffusion Policy（RDP）**：双层架构——**slow planner**（重型 visual-tactile diffusion，低频生成 chunk）+ **fast reactive policy / controller**（轻量、高频，根据实时触觉/力觉做微调）。针对接触丰富任务，关键是低延迟反馈。

**Slow-Fast Diffusion Policy**：思路类似——slow 大模型离线/低频生成动作 chunk 候选，fast 小 policy 在线选择 + 调整；与双系统 VLA 的"S1 / S2"同构。

**共同思路**：把"慢的多模态生成"和"快的反应执行"解耦，重 DP 推理移到低频通路，高频通路用轻量 head；接触任务上比纯 DP 显著更稳。',
   null, null, '["RDP 不只是\"并行去噪 / streaming\"——核心是 slow planner + fast reactive controller 的双层", "模型权重也分两套。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Diffusion Policy / Flow Matching","qid":"Q23","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000184', '模仿学习里"复合误差"指什么？Action Chunking 是怎么缓解它的？理论解释是什么？', 'eaq-v03-q26', 'knowledge', 'easy', 'BC 在专家状态上训练，但部署中的小误差会使策略进入未见状态，后续错误继续放大；',
   'BC 在专家状态上训练，但部署中的小误差会使策略进入未见状态，后续错误继续放大；经典最坏情形下累计代价差可随任务时域二次增长。动作块联合预测一段行为，可能缩短有效决策时域并保持时序一致性，ACT 实验中能缓解复合误差。', 'BC 在专家状态上训练，但部署中的小误差会使策略进入未见状态，后续错误继续放大；经典最坏情形下累计代价差可随任务时域二次增长。动作块联合预测一段行为，可能缩短有效决策时域并保持时序一致性，ACT 实验中能缓解复合误差。',
   null, null, '["块内开环执行仍会受扰动和模型误差影响", "不能直接把理论界中的 T 换成 T/K 就宣称误差降阶，更不能保证 chunk 内不累积偏差。"]'::jsonb, null, 3, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Action Chunking & ACT","qid":"Q26","freq_label":"🔥×7","provenance":"核验：[ACT 原论文](https://arxiv.org/html/2304.13705)、[DAgger 原论文](https://proceedings.mlr.press/v15/ross11a.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000185', 'ACT 推理时把 z 固定为 0 有什么局限？为什么不随机采样？KL 权重 β 怎么调？', 'eaq-v03-q27', 'knowledge', 'medium', '**$z = 0$ 的局限**：取 prior 的 mode → 在多模态任务上退化为"代表性单解"路径，丢失探索性；',
   '**$z = 0$ 的局限**：取 prior 的 mode → 在多模态任务上退化为"代表性单解"路径，丢失探索性；如果训练分布里多策略权重接近，$z = 0$ 可能落在"平均路"附近，物理仍不可执行。', '**$z = 0$ 的局限**：取 prior 的 mode → 在多模态任务上退化为"代表性单解"路径，丢失探索性；如果训练分布里多策略权重接近，$z = 0$ 可能落在"平均路"附近，物理仍不可执行。

**为什么不随机采样 $z \sim \mathcal{N}(0, I)$**：连续步骤独立采样 → 策略不连续（前 1 秒走左、后 1 秒走右）。解法是 **chunk 边界冻结 $z$**（同一 episode 内固定）或 **temporal ensemble** 平均；纯随机采样实务上比 $z = 0$ 还差。

**KL 权重 β 调参（β-VAE 视角）**：
- β 过大 → **posterior collapse**，$z$ 失活（编码器输出近 $\mathcal{N}(0, I)$，无信息），decoder 退化为 MSE。
- β 过小 → $z$ 太"任性"，推理 $z = 0$ 不再"代表性"。
- ACT 实务：β 取 $\sim$10 或更小；动作 reconstruction loss 权重 1.0；常监控 KL 项是否近 0（collapse 信号）。',
   null, null, '["KL collapse 是 ACT 训练最常见陷阱——KL → 0 不等于\"训练好了\"，是 latent 失活", "要看 reconstruction 是否真的依赖 $z$。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Action Chunking & ACT","qid":"Q27","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000186', '介绍一下 Open-X-Embodiment 数据集，它解决了什么问题？数据多样性对 VLA 泛化的影响？', 'eaq-v03-q28', 'knowledge', 'easy', '**Open-X-Embodiment（OXE）**：2023-10 Google 联合 21 个 lab 发布，约 **60 个数据集 / 22 种 embodiment / 1M+ 轨迹**（OpenVLA 训练用…',
   '**Open-X-Embodiment（OXE）**：2023-10 Google 联合 21 个 lab 发布，约 **60 个数据集 / 22 种 embodiment / 1M+ 轨迹**（OpenVLA 训练用其中 curated **~970K** 子集）。是迄今最大的跨实验室、跨形态机器人数据集。', '**Open-X-Embodiment（OXE）**：2023-10 Google 联合 21 个 lab 发布，约 **60 个数据集 / 22 种 embodiment / 1M+ 轨迹**（OpenVLA 训练用其中 curated **~970K** 子集）。是迄今最大的跨实验室、跨形态机器人数据集。

**解决的问题**：
1. **单 lab 数据量太小**（< 100K），scale 不起来。
2. **跨形态无数据**：每 lab 用不同机器人，无法对比/合并。
3. **任务覆盖窄**：单数据集多为 pick & place，缺多样性。

**对 VLA 泛化的影响**：
- RT-X 论文实证：在 OXE 上联合训练比单数据集训练，跨场景成功率显著提升。
- 数据多样性（任务 / 场景 / embodiment）比数据量本身更关键。
- OpenVLA / π0 都以 OXE 为预训练基础。',
   null, null, '["OXE ≠ 一个统一格式的数据集，是 ~60 个原始数据集 + RLDS 统一接口", "动作空间标准化到 7 维末端 + gripper（不足补 0）。"]'::jsonb, null, 3, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q28","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000187', 'OpenVLA 的视觉编码器为什么用 SigLIP + DINOv2 双路融合？只用 CLIP 行不行？', 'eaq-v03-q29', 'knowledge', 'medium', '**SigLIP** 与 **DINOv2** 各有所长。',
   '**SigLIP** 与 **DINOv2** 各有所长：
- **SigLIP**（image-text contrastive）：偏**语义**（"杯子" → 杯子图像），对自然语言强对齐。
- **DINOv2**（自监督）：偏**空间几何**（深度、表面纹理、空间结构），对场景结构敏感。', '**SigLIP** 与 **DINOv2** 各有所长：
- **SigLIP**（image-text contrastive）：偏**语义**（"杯子" → 杯子图像），对自然语言强对齐。
- **DINOv2**（自监督）：偏**空间几何**（深度、表面纹理、空间结构），对场景结构敏感。

**双路融合**：两个编码器各出 patch tokens，**channel-wise concat**（不是 cross-attention），喂给 LLM。

**只用 SigLIP 不行**：
1. SigLIP / CLIP 对**空间几何弱**——能识别"杯子"但不知"杯子距夹爪 5 cm 偏左"。
2. 机器人操作高度依赖空间推理（抓取位姿、避障）。
3. **Prismatic VLM** 论文实证：双路 > SigLIP > DINOv2 > CLIP，在 robotics benchmark 上差距明显。',
   null, null, '["双路融合不是 ensemble，是同时给 LLM 输入两套 tokens", "LLM 自己学如何用。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q29","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000188', 'VLM 和 VLA 的区别是什么？VLA 多了什么模块？token 化方案怎么变？', 'eaq-v03-q30', 'knowledge', 'easy', '| | VLM（Vision-Language Model） | VLA（Vision-Language-Action） |',
   '| | VLM（Vision-Language Model） | VLA（Vision-Language-Action） |
|---|---|---|
| 输入 | 图像 + 文本 | 图像 + 文本指令 + 历史 proprio |
| 输出 | 文本 token | **动作**（连续 / 离散 token） |
| 训练数据 | web 图文 | web + **机器人轨迹** |
| 多出模块 | — | **Action head**（离散 token 或 Flow Matching 头） |', '| | VLM（Vision-Language Model） | VLA（Vision-Language-Action） |
|---|---|---|
| 输入 | 图像 + 文本 | 图像 + 文本指令 + 历史 proprio |
| 输出 | 文本 token | **动作**（连续 / 离散 token） |
| 训练数据 | web 图文 | web + **机器人轨迹** |
| 多出模块 | — | **Action head**（离散 token 或 Flow Matching 头） |

**Token 化方案**：
- VLM：仅 text token（如 32K vocab）。
- VLA：text token + **action token**——
  - 离散方案（RT-2 / OpenVLA）：每维动作 256 bin，复用 LLM 词表最不常用 256 token；一步 7 维 = 7 token。
  - 连续方案（π0 / RDT）：action 不 token 化，直接由独立 Action Expert（Flow Matching / Diffusion）输出。
  - FAST：DCT + BPE 把 chunk 压成更少 token，介于两者之间。',
   null, null, '["VLA 不是 \"VLM 加个 head\" 就完事——训练时要 co-finetune 机器人数据，否则 VLM 在动作分布上零样本不行。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q30","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000189', '多模态对齐里 Q-Former、projection、cross-attention 这几种 connector 的区别？', 'eaq-v03-q31', 'knowledge', 'medium', '**Connector** = 把视觉特征对齐到 LLM 输入空间的模块。',
   '**Connector** = 把视觉特征对齐到 LLM 输入空间的模块。', '**Connector** = 把视觉特征对齐到 LLM 输入空间的模块。

| Connector | 代表 | 机制 | token 数 |
|---|---|---|---|
| **Projection** | LLaVA | MLP 直接映射 patch → token | = patch 数（多） |
| **Q-Former** | BLIP-2 | 可学 query 通过 cross-attn 提取关键视觉特征 | **可压缩**（少） |
| **Cross-Attention** | Flamingo | 在 LLM 每层插 cross-attn 与视觉特征交互 | 不增 input token，但**改 LLM 结构** |

**VLA 实务**：
- **Projection（OpenVLA / Prismatic）**：简单、稳；token 数多（256-576 / 图）但 LLM 能扛。
- **Q-Former**：复杂、训练不稳；VLA 上较少用。
- **Cross-Attention**：需改 LLM 架构；不便于直接用现成 VLM 权重。',
   null, null, '["Q-Former 不是\"更先进\"——LLaVA 系列证明 projection 简单 + 数据多反而更好。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q31","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000190', 'DROID 和 Bridge 数据集的特点分别是什么？它们和 Open-X 是什么关系？', 'eaq-v03-q32', 'knowledge', 'medium', '**Bridge / BridgeData V2**（2023）：多场景多任务，约 **60K 轨迹**；',
   '- **Bridge / BridgeData V2**（2023）：多场景多任务，约 **60K 轨迹**；早期跨任务 IL 基础数据集；任务集中在 pick & place + 简单 manipulation。
- **DROID**（2024）：约 **564 个场景 / 350 小时 / 76K demonstrations / ~86 tasks**（arXiv 摘要写 84，项目页 86，版本口径差异）；多样性 SOTA，被誉为"野外"机器人数据集。', '- **Bridge / BridgeData V2**（2023）：多场景多任务，约 **60K 轨迹**；早期跨任务 IL 基础数据集；任务集中在 pick & place + 简单 manipulation。
- **DROID**（2024）：约 **564 个场景 / 350 小时 / 76K demonstrations / ~86 tasks**（arXiv 摘要写 84，项目页 86，版本口径差异）；多样性 SOTA，被誉为"野外"机器人数据集。

**Open-X 关系**：**Bridge V2 是 OXE 子集**；**DROID 不在 OXE 原始发布的约 60 个数据集中**——OXE（2023-10）早于 DROID（2024）发布，但二者常被联合用于后续训练 / fine-tune。

**训练用法**：
- OpenVLA / π0：先在 OXE 上预训练（含 Bridge 等）。
- DROID 常作为后续大规模 fine-tune 源（场景泛化）。
- Bridge 常作为评估 baseline。',
   null, null, '["DROID 不是\"OXE 子集\"——它是后续发布、独立维护的数据集", "常与 OXE 联合用但出处不同。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q32","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000191', '怎么解决 VLA 训练里"多任务相互干扰 / 灾难性遗忘"？跨域联合训练怎么做？', 'eaq-v03-q33', 'knowledge', 'medium', '**现象**：fine-tune VLA on task A 后，task B 性能掉；',
   '**现象**：fine-tune VLA on task A 后，task B 性能掉；或 web 知识被动作微调"洗掉"。', '**现象**：fine-tune VLA on task A 后，task B 性能掉；或 web 知识被动作微调"洗掉"。

**解法**：
1. **LoRA** — 冻结大部分参数，只训低秩适配；保留预训练知识。
2. **Co-training（联合训练）** — 把所有任务 / 多数据集混训，共享 backbone；OpenVLA 在 OXE ~60 datasets 上的做法。
3. **Rehearsal** — 持续学习时保留旧任务数据，定期 replay 防遗忘。
4. **KI（Knowledge Insulation，π0.5）** — 隔离 VLM 与 Action Expert 的梯度，VLM 不被动作训练污染。
5. **Task-conditional LoRA** — 每任务一组 LoRA 权重，推理时按 task ID 加载。

**跨域联合训练**：① 按比例采样（按 dataset 大小开根号防大数据集 dominate）；② Embodiment token 告诉模型当前数据集；③ Action 标准化到统一 7 维末端 + gripper（不足补 0）。',
   null, null, '["LoRA 不能完全避免遗忘——LoRA 矩阵也会\"污染\"前向", "真正抗遗忘还需配合 KI 或 frozen backbone。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q33","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000192', '跨 embodiment 训练（手臂数不同 / 自由度不同）怎么对齐动作空间？Octo / RT-X 怎么做的？', 'eaq-v03-q34', 'knowledge', 'medium', '**问题**：不同机器人 DoF 不同（**7-DoF Franka/Panda**、**6-DoF UR5e**、**14-DoF ALOHA 双臂**、**16-DoF Mobile ALOHA**）。',
   '**问题**：不同机器人 DoF 不同（**7-DoF Franka/Panda**、**6-DoF UR5e**、**14-DoF ALOHA 双臂**、**16-DoF Mobile ALOHA**）。', '**问题**：不同机器人 DoF 不同（**7-DoF Franka/Panda**、**6-DoF UR5e**、**14-DoF ALOHA 双臂**、**16-DoF Mobile ALOHA**）。

**RT-X / OpenVLA（单臂主流）**：canonicalize 到 **7 维 end-effector** [Δx, Δy, Δz, Δroll, Δpitch, Δyaw, gripper]——不同关节配置通过 IK 映射到同一末端空间。

**双臂 / 移动**：保留原维度（14 / 16），用 **embodiment-specific action head** 或 **padding mask** 兼容；**不能截断到 7D**，否则丢第二臂或底盘动作。

**Octo**：可变长 action token + padding mask。

**关键技巧**：① embodiment-conditional token 告诉模型形态；② 动作按数据集 1%-99% 分位归一化；③ dataset 按大小开根号采样。',
   null, null, '["单臂场景才能 7D canonicalization", "双臂/移动需 embodiment-specific head + mask。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"视觉-语言对齐 & 数据","qid":"Q34","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000193', '原始 OpenVLA 推理的瓶颈是什么？怎样评价优化后的速度和控制效果？', 'eaq-v03-q35', 'knowledge', 'medium', '先区分视觉编码、prefill、逐 token 解码、动作头与数据传输的耗时。',
   '先区分视觉编码、prefill、逐 token 解码、动作头与数据传输的耗时。原始 OpenVLA 的串行动作 token 生成会限制低延迟控制；OFT 通过并行解码、动作块和连续回归改变这一瓶颈。量化、编译和缓存可进一步优化，但必须在目标输入、设备和控制接口下测量成功率与延迟。', '先区分视觉编码、prefill、逐 token 解码、动作头与数据传输的耗时。原始 OpenVLA 的串行动作 token 生成会限制低延迟控制；OFT 通过并行解码、动作块和连续回归改变这一瓶颈。量化、编译和缓存可进一步优化，但必须在目标输入、设备和控制接口下测量成功率与延迟。',
   null, null, '["“6 Hz”不是模型常数", "报告硬件、精度、动作块长、推理调用频率和动作执行频率。吞吐提高不代表端到端延迟等比例下降。"]'::jsonb, null, 5, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"推理优化 & 控制频率","qid":"Q35","freq_label":"🔥×9","provenance":"核验：[OpenVLA-OFT 作者页](https://openvla-oft.github.io/)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000194', '如果模型推理只能跑 5 Hz 而机器人需要 50 Hz 控制，怎么办？说说工程方案。', 'eaq-v03-q36', 'knowledge', 'medium', '先区分策略调用频率与动作执行频率。',
   '先区分策略调用频率与动作执行频率。策略可一次预测动作块，控制器按更快周期执行；执行部分动作后重新观测，平衡反应性与推理开销。异步方案让旧块执行与新块生成重叠，但需处理推理期间已执行的前缀和切块连续性。RTC 将此建模为动作补全，让新预测衔接已承诺的动作。', '先区分策略调用频率与动作执行频率。策略可一次预测动作块，控制器按更快周期执行；执行部分动作后重新观测，平衡反应性与推理开销。异步方案让旧块执行与新块生成重叠，但需处理推理期间已执行的前缀和切块连续性。RTC 将此建模为动作补全，让新预测衔接已承诺的动作。',
   null, null, '["插值或简单平均不能补回缺失反馈，也不保证切块可行", "需测端到端延迟、状态陈旧度、约束与任务成功率。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"推理优化 & 控制频率","qid":"Q36","freq_label":"🔥×5","provenance":"核验：[RTC 作者说明](https://www.pi.website/research/real_time_chunking)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000195', 'LoRA 微调一个 VLA 有哪些注意点？冻结哪部分？为什么 OpenVLA 推荐 LoRA？', 'eaq-v03-q37', 'knowledge', 'medium', '**LoRA**：在 attention 的 $Q/K/V/O$ 矩阵上加低秩适配 $\Delta W = BA$（$r \ll d$）。',
   '**LoRA**：在 attention 的 $Q/K/V/O$ 矩阵上加低秩适配 $\Delta W = BA$（$r \ll d$）。', '**LoRA**：在 attention 的 $Q/K/V/O$ 矩阵上加低秩适配 $\Delta W = BA$（$r \ll d$）。

**冻结策略**（VLA 实务）：
- **全冻结**：视觉编码器（SigLIP / DINOv2）+ LLM backbone。
- **训练**：LoRA 矩阵 + **action head**（含 Action Expert 等）+ optional 视觉 projector LoRA。

**超参经验**：
- rank $r$ = 4-16；
- alpha = $2r$（缩放因子）；
- 学习率 1e-4 ~ 5e-4；
- 目标模块：attention 的 $Q, K, V, O$（不一定全加）。

**OpenVLA 推荐 LoRA 原因**：
1. **消费级硬件友好**：7B 全参微调需 8×A100；LoRA 单 4090（24 GB）可微调。
2. **不破坏 web 知识**：大部分参数 frozen，VLM 通识保留。
3. **社区迭代快**：每任务 ~MB 级 LoRA 权重，易共享。
4. **可组合**：多任务 LoRA 可加权组合。',
   null, null, '["LoRA rank 不是越大越好", "rank 太大 = 全参微调，丢了\"防遗忘\"的优势。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"推理优化 & 控制频率","qid":"Q37","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000196', 'PaliGemma 为什么用 prefix-LM 注意力（图像 token 互看，动作 token 因果）？', 'eaq-v03-q38', 'knowledge', 'medium', '**Prefix-LM attention**。',
   '**Prefix-LM attention**：
- **Prefix 部分**（图像 token + 系统 prompt）：**bidirectional**，互相可见。
- **Suffix 部分**（生成 / 动作 token）：**causal mask**，只能看前面。', '**Prefix-LM attention**：
- **Prefix 部分**（图像 token + 系统 prompt）：**bidirectional**，互相可见。
- **Suffix 部分**（生成 / 动作 token）：**causal mask**，只能看前面。

**对比**：
- 纯 **causal LM**（GPT 风格）：所有 token 都因果；图像 token 只能看到自己之前的，视觉理解受限。
- 纯 **bidirectional**（BERT 风格）：不能 AR 生成。
- **Prefix-LM**：兼顾——图像 token 间信息充分流通，生成 token 仍是 AR。

**对 VLA 的价值**：
1. 图像 patch token 互相可见 → 空间推理更强。
2. 动作 token 因果 → 仍是 AR 解码，与 LLM 训练范式兼容。
3. π0 借鉴此设计：visual + text prefix（双向） + action token（因果）。',
   null, null, '["Prefix-LM 不是\"所有 token 都双向\"——只有 prefix 部分双向", "suffix 仍是 causal，否则没法 AR 生成。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"推理优化 & 控制频率","qid":"Q38","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000197', 'OpenVLA-OFT 加速 VLA 的三大关键设计是什么（并行解码 / 连续动作 / L1 回归）？', 'eaq-v03-q39', 'knowledge', 'hard', '**OFT recipe** = **parallel decoding + action chunking + continuous actions + L1 regression**（OpenVLA-OFT, ar…',
   '**OFT recipe** = **parallel decoding + action chunking + continuous actions + L1 regression**（OpenVLA-OFT, arXiv:2502.19645）。', '**OFT recipe** = **parallel decoding + action chunking + continuous actions + L1 regression**（OpenVLA-OFT, arXiv:2502.19645）。

1. **Parallel Decoding**：抛弃 AR 串行（原 OpenVLA: 7 token/步），一次 forward 同时出 chunk 全部 $K \times 7$ 个动作分量（[ACTION] 占位 + bidirectional attention）。
2. **Action Chunking**：与 parallel 协同放大加速。
3. **Continuous Action Head**：放弃 256-bin，小 MLP 直接回归连续动作，无量化误差。
4. **L1 Loss**：比 L2 对 outlier / 噪声专家动作更鲁棒。

**论文报告**：action 生成吞吐 ≈ **26×**、单 step latency ≈ **3×** 改善；精度也提升。',
   null, null, '["OFT 重训了 action head，不能直接套用 OpenVLA checkpoint。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"推理优化 & 控制频率","qid":"Q39","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000198', 'OpenVLA 输出是离散 token，怎么在推理时还原成连续动作？反量化误差怎么处理？', 'eaq-v03-q40', 'knowledge', 'medium', '**还原流程**。',
   '**还原流程**：
1. LLM 输出动作 token → 查表得 bin index $i \in [0, 255]$。
2. **Bin 中心还原**：每维动作在训练集 1%-99% 分位区间等分 256 bin，token $i$ → bin 中心值 $\hat{a}_{\text{norm}} = -1 + (i + 0.5)/256 \times 2$。
3. **反归一化**：用训练集的 $(\min, \max)$ 还原到物理量纲 $a = \hat{a}_{\text{norm}} \cdot (\max - \min)/2 + \text{mid}$。', '**还原流程**：
1. LLM 输出动作 token → 查表得 bin index $i \in [0, 255]$。
2. **Bin 中心还原**：每维动作在训练集 1%-99% 分位区间等分 256 bin，token $i$ → bin 中心值 $\hat{a}_{\text{norm}} = -1 + (i + 0.5)/256 \times 2$。
3. **反归一化**：用训练集的 $(\min, \max)$ 还原到物理量纲 $a = \hat{a}_{\text{norm}} \cdot (\max - \min)/2 + \text{mid}$。

**反量化误差**：
- 每维 ~ $1/256 \approx 0.39\%$ 量程；
- 在 ±10 cm 末端位置上 ≈ 0.78 mm 精度；
- 对粗操作够用，对插针 / 拧螺丝（< 0.1 mm）不够。

**处理方法**：
1. 任务允许就直接用。
2. 高精度任务换 OpenVLA-OFT 连续头。
3. 加 **PID / impedance** 后端 closed-loop 兜底（模型出 desired，控制器精确跟踪）。',
   null, null, '["256 bin 不是\"够细\"，是 VLM 复用的权衡", "精度需求高必须换连续头。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"推理优化 & 控制频率","qid":"Q40","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000199', 'Sim-to-Real Gap 主要来自哪？怎么缩小？在你项目里是怎么处理的？', 'eaq-v03-q42', 'knowledge', 'easy', '**Gap 来源**：① 视觉（渲染 vs 真实噪声/光照）；',
   '**Gap 来源**：① 视觉（渲染 vs 真实噪声/光照）；② 物理（摩擦/接触/软体/关节弹性仿不准）；③ 控制（仿真无延迟 vs 真机 5-20 ms 延迟）；④ 传感器（IMU 漂移、力觉噪声）。', '**Gap 来源**：① 视觉（渲染 vs 真实噪声/光照）；② 物理（摩擦/接触/软体/关节弹性仿不准）；③ 控制（仿真无延迟 vs 真机 5-20 ms 延迟）；④ 传感器（IMU 漂移、力觉噪声）。

**缩小方法**：
1. **DR**（sim 端扩分布）；
2. **System ID**（真机数据校准仿真参数）；
3. **Real-world fine-tune**：sim 预训练 + 真机 200-500 demos 精调（最稳）；
4. **Visual transfer**（GAN / NeRF 渲染 photo-realistic）；
5. **Privileged + Distillation**（sim 用真值训，蒸馏给只用图像的 student，RMA 思路）。

**项目实务**：Isaac Gym + DR 预训练（~100 GPU 小时）→ 真机 ~300 demos fine-tune（~1 小时）。',
   null, null, '["sim 训好不能直接用", "真机 fine-tune 几乎必须，差异只是 demos 数量。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"Sim2Real","qid":"Q42","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000200', '双系统（System 1 / System 2）VLA 是什么思路？解决了什么问题？快慢系统怎么协同？', 'eaq-v03-q43', 'knowledge', 'hard', '源自 Kahneman 双系统理论：S1 直觉快、S2 推理慢。',
   '源自 Kahneman 双系统理论：S1 直觉快、S2 推理慢。', '源自 Kahneman 双系统理论：S1 直觉快、S2 推理慢。

**VLA 映射**：
- **System 1**：小模型（< 1B），**50-100 Hz**，执行 atomic skills。
- **System 2**：大 VLM（3-10B），**1-5 Hz**，做高层任务分解 / 推理 / 重规划。

**协同**：① S2 → S1 输出语义子目标（"抓杯子"）或 latent goal；② S1 检测异常 / 完成 → trigger S2 重规划；③ S2 在 S1 执行间隙异步推理，streaming 喂给 S1。

**代表**：Figure Helix、GR00T-N1、FiS、Hume。

**解决**：单端到端 VLA 无法同时满足"long-horizon planning + high-freq control"——双系统兼顾推理深度 + 控制频率。',
   null, null, '["双系统是**分工 + 异步**，不是集成学习", "S1 / S2 是完全不同的模型，频率差 10-50×。"]'::jsonb, null, 8, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q43","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000201', '谈一下 VLA 在自动驾驶里的两种范式（模仿学习派 vs 模拟器 RL 派）的优劣？', 'eaq-v03-q44', 'knowledge', 'medium', '| | 模仿学习派 | 模拟器 RL 派 |',
   '| | 模仿学习派 | 模拟器 RL 派 |
|---|---|---|
| 代表 | Tesla FSD、小鹏 XNGP、Wayve | Waymo（部分）、CARLA 研究 |
| 数据源 | **海量真人驾驶视频** | 仿真器 rollout |
| 训练 | BC / VLA 端到端 | RL（PPO / SAC） |
| 优点 | scale 好；数据现成 | 可控、安全、可枚举边界场景 |
| 缺点 | 长尾安全难（demos 不覆盖罕见事件） | Sim2Real gap 严；仿真行为模型不真 |', '| | 模仿学习派 | 模拟器 RL 派 |
|---|---|---|
| 代表 | Tesla FSD、小鹏 XNGP、Wayve | Waymo（部分）、CARLA 研究 |
| 数据源 | **海量真人驾驶视频** | 仿真器 rollout |
| 训练 | BC / VLA 端到端 | RL（PPO / SAC） |
| 优点 | scale 好；数据现成 | 可控、安全、可枚举边界场景 |
| 缺点 | 长尾安全难（demos 不覆盖罕见事件） | Sim2Real gap 严；仿真行为模型不真 |

**主流**：当前模仿学习派**规模化能力更强**（Tesla / 小鹏量产）；但安全和长尾上 hybrid 仍是趋势——主体 IL + 关键场景 RL 兜底。

**与机器人 VLA 区别**：
- 自动驾驶动作维度小（2-4 维：转向 + 油门 + 刹车）；机器人 7-16+ 维。
- 自动驾驶任务结构化（道路 / 路标 / 信号灯），机器人开放场景。
- 自动驾驶决策周期长（秒级），机器人毫秒级。',
   null, null, '["自动驾驶 VLA 和机器人物理操作 VLA 是**两个赛道**，技术栈重叠但落地路径完全不同。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q44","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000202', '为什么"缺乏实机经验的多模态大模型研究"在具身岗竞争力有限？VLA 求职者除了懂模型还要懂什么？', 'eaq-v03-q45', 'knowledge', 'easy', '**核心矛盾**：纯模型研究者擅长 sim / dataset SOTA，但具身岗的真正需求是**"模型 + 系统 + 落地"三栖人才**。',
   '**核心矛盾**：纯模型研究者擅长 sim / dataset SOTA，但具身岗的真正需求是**"模型 + 系统 + 落地"三栖人才**。', '**核心矛盾**：纯模型研究者擅长 sim / dataset SOTA，但具身岗的真正需求是**"模型 + 系统 + 落地"三栖人才**。

**真机部署的隐藏成本**：
1. **控制频率约束**——50 Hz 控制 + 6 Hz 推理怎么协调。
2. **硬件接口**——ROS / 自研 SDK / EtherCAT 通讯。
3. **数据采集 pipeline**——teleop / VR / kinematic retargeting。
4. **长程任务稳定性**——多步串联时累积误差。
5. **安全机制**——力限 / 紧急停止 / 错误恢复。

**求职者要懂**：
1. **真机数据采集**（teleop 至少跑通一次）。
2. **部署 pipeline**（ROS 基础 + 至少一种实时通讯）。
3. **控制基础**（PID / impedance / MPC 概念）。
4. **至少一个 closed-loop 真机 demo**（哪怕是 LeRobot 复现的简单任务）。

**面试官的潜台词**：能不能让模型在真机上跑起来 ≠ paper SOTA。',
   null, null, '["在简历里写\"OpenVLA / π0 实现\"但没真机验证，面试官会重点拷打你的 demo 视频。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q45","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000203', 'VLA 的 scaling law 存在吗？数据 / 模型 / 算力哪个维度最难 scale？', 'eaq-v03-q46', 'knowledge', 'hard', '**现状**：**没有公认的 robot scaling law**——曲线远不如 LLM Chinchilla 清晰。',
   '**现状**：**没有公认的 robot scaling law**——曲线远不如 LLM Chinchilla 清晰。', '**现状**：**没有公认的 robot scaling law**——曲线远不如 LLM Chinchilla 清晰。

**论据**：
- RT-2（55B）比 OpenVLA（7B）提升幅度有限；
- 数据量（OXE 970K）远小于 LLM 训练量（10T+ tokens）；
- closed-loop 评估稀缺，scaling 曲线难稳定测量。

**最难 scale 的维度**：
1. **数据 >> 模型 >> 算力**——
2. **数据**：① 真机数据采集 1 人 1 天 100 demos，scale 到 10M+ 需上千人年；② 跨 embodiment / 任务多样性是数据，不是数量；③ 缺乏 self-supervised pretrain 路径（视频是 action-free）。
3. **模型**：参数好加，但小模型 + 多数据当前回报更高。
4. **算力**：单次训练成本可控（OpenVLA 数千 GPU 小时）；瓶颈在数据。

**关键观察**：scaling 的回报在 **"跨 embodiment / 跨任务"** 上比 "单任务参数量" 明显——这是为什么 OXE 比 single-lab 数据有用。',
   null, null, '["不要照搬 Chinchilla 20:1 token:param——机器人 token 信息密度远低于自然语言。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q46","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000204', '现在的通用具身大模型（OpenVLA / π0 / GR00T）还差什么才能"落地"？说说你的判断。', 'eaq-v03-q48', 'knowledge', 'hard', '**核心差距 = 数据 > 模型 > 算力 > 评估**。',
   '**核心差距 = 数据 > 模型 > 算力 > 评估**。', '**核心差距 = 数据 > 模型 > 算力 > 评估**。

**具体差距**：
1. **数据规模**：OXE 970K 远不够覆盖家庭长尾；需 100M+ trajectories（约现量 100×）。
2. **数据多样性**：场景多样性、任务多样性、长尾事件覆盖（罕见物体、突发干扰）。
3. **推理速度**：6 Hz 不够工业 50 Hz；硬件加速 + 模型蒸馏待突破。
4. **闭环评估**：sim 评估不靠谱；真机 benchmark 太贵；缺统一标准。
5. **安全机制**：紧急停止 / 错误恢复 / 力觉异常未集成到端到端 VLA。
6. **长程任务**：> 30 秒的多步任务稳定性差，需 hierarchical 或 World Model。
7. **经济性**：单台机器人成本 + 训练成本 > 量产替代单价时才商用。

**最难突破的是数据**——硬件 / 模型 / 算力都可"用钱解决"，数据靠人力时间无法压缩；这也是为什么 RoboNet / DROID / OXE 这种共享数据集是行业关键。',
   null, null, '["不要只说\"模型还不够大\"——这是 LLM 思维", "具身的瓶颈一直在数据。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q48","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000205', '端到端 VLA 与高层规划加低层技能如何取舍，系统接口要说明什么？', 'eaq-v03-q49', 'knowledge', 'hard', '先说明端到端的边界：模型可以从观测预测连续动作，也可由高层模型选择工具／技能再执行。',
   '先说明端到端的边界：模型可以从观测预测连续动作，也可由高层模型选择工具／技能再执行。前者减少手工接口，后者便于组合已有能力和局部恢复，但依赖状态、技能契约与结果验证。PyRUA-Lean 展示了将 VLA 等 primitives 纳入代码执行框架的具体方案；不能从个别论文推出唯一工业路线。', '先说明端到端的边界：模型可以从观测预测连续动作，也可由高层模型选择工具／技能再执行。前者减少手工接口，后者便于组合已有能力和局部恢复，但依赖状态、技能契约与结果验证。PyRUA-Lean 展示了将 VLA 等 primitives 纳入代码执行框架的具体方案；不能从个别论文推出唯一工业路线。',
   null, null, '["不要把“分层”简单等同于特定频率或任务时长", "大模型、动作策略与控制器分别输出什么、怎样反馈才是比较重点。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q49","freq_label":"🔥×3","provenance":"核验：[π0 原论文](https://arxiv.org/abs/2410.24164)、[PyRUA-Lean 原论文](https://arxiv.org/abs/2610.01939)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000206', '哪些情况下值得使用世界模型与规划？和直接学习动作策略有什么取舍？', 'eaq-v03-q50', 'knowledge', 'hard', '世界模型学习状态在动作作用下的变化，可用于预测、候选动作比较或想象轨迹训练。',
   '世界模型学习状态在动作作用下的变化，可用于预测、候选动作比较或想象轨迹训练。直接策略把计算更多集中在动作生成。选择取决于动力学可预测性、交互成本、任务时域、规划预算与模型误差；两者也能结合，例如动作条件潜在预测用于目标导向规划。需在相同数据和评测条件下比较。', '世界模型学习状态在动作作用下的变化，可用于预测、候选动作比较或想象轨迹训练。直接策略把计算更多集中在动作生成。选择取决于动力学可预测性、交互成本、任务时域、规划预算与模型误差；两者也能结合，例如动作条件潜在预测用于目标导向规划。需在相同数据和评测条件下比较。',
   null, null, '["潜在状态并不天然可解释", "世界模型也可能累积误差，不能保证用固定十分之一数据解决所有任务或必然优于直接策略。"]'::jsonb, null, 8, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q50","freq_label":"历史低频·待核","provenance":"核验：[V-JEPA 2 原论文](https://arxiv.org/abs/2506.09985)、[DreamerV3 原论文](https://arxiv.org/abs/2301.04104)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000207', '具身智能里"操作（manipulation）"和"运动控制（locomotion）"哪个落地更难？为什么操作是"前途无量"但卡点更多？', 'eaq-v03-q51', 'knowledge', 'medium', '| | Locomotion | Manipulation |',
   '| | Locomotion | Manipulation |
|---|---|---|
| 落地成熟度 | **已商用**（Boston Dynamics、宇树 Go2） | **实验室阶段**（少量量产） |
| 物理建模 | 浮动基座动力学，仿真较准 | 接触 / 摩擦 / 软体物，仿真极难 |
| 数据稀缺度 | 中（步态数据有共性） | **极高**（每类操作都需新数据） |
| 闭环反馈 | IMU + 关节位置足够 | 需视觉 + 力觉，多模态对齐难 |
| 任务多样性 | 行走 / 跳跃 / 跑步 | **几乎无限**（抓 / 放 / 拧 / 插 / 切...） |', '| | Locomotion | Manipulation |
|---|---|---|
| 落地成熟度 | **已商用**（Boston Dynamics、宇树 Go2） | **实验室阶段**（少量量产） |
| 物理建模 | 浮动基座动力学，仿真较准 | 接触 / 摩擦 / 软体物，仿真极难 |
| 数据稀缺度 | 中（步态数据有共性） | **极高**（每类操作都需新数据） |
| 闭环反馈 | IMU + 关节位置足够 | 需视觉 + 力觉，多模态对齐难 |
| 任务多样性 | 行走 / 跳跃 / 跑步 | **几乎无限**（抓 / 放 / 拧 / 插 / 切...） |

**Locomotion 已是"基础设施"**：Sim2Real + RL 是成熟 pipeline；Unitree、宇树等量产；技术风险已收敛。

**Manipulation 是"前途无量但卡点多"**：
- 卡点：物体多样、接触建模难、数据稀缺、长尾任务无穷。
- 前途：家庭服务 / 工业精细装配 / 医疗 / 物流的核心。

**求职建议**：
- 想长期需求大 → **Manipulation**（容量未饱和）。
- 想短期商用 → **Locomotion**（已成熟，需求集中在工程优化）。',
   null, null, '["Locomotion 不是\"简单\"——只是\"已知怎么做\"", "Manipulation 是\"前沿但慢\"。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q51","freq_label":"历史低频·待核"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000208', '多模态预训练怎样帮助具身泛化？它与 IL、RL、世界模型分别解决什么问题？', 'eaq-v03-q52', 'knowledge', 'medium', '先定义泛化维度：新物体、场景、指令、任务组合或本体。',
   '先定义泛化维度：新物体、场景、指令、任务组合或本体。VLM 预训练能提供视觉语义先验，IL 和 RL 提供行为学习信号；二者组合是重要路线，但效果仍依赖训练覆盖和物理接口。动作条件世界模型、表征学习、规划与控制也能提高特定泛化能力，应在明确的未见分布上比较。', '先定义泛化维度：新物体、场景、指令、任务组合或本体。VLM 预训练能提供视觉语义先验，IL 和 RL 提供行为学习信号；二者组合是重要路线，但效果仍依赖训练覆盖和物理接口。动作条件世界模型、表征学习、规划与控制也能提高特定泛化能力，应在明确的未见分布上比较。',
   null, null, '["不能把“多模态大模型是唯一泛化路径”当定理", "VLM、IL、RL 也不是互斥类别，预训练语义能力不自动保证精确控制。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"双系统 / 系统观 / 前沿判断","qid":"Q52","freq_label":"历史低频·待核","provenance":"核验：[V-JEPA 2 原论文](https://arxiv.org/abs/2506.09985)、[π0 原论文](https://arxiv.org/abs/2410.24164)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000209', '强化学习和模仿学习如何结合？在你的项目里是怎么用的？', 'eaq-v03-q53', 'knowledge', 'easy', '常见组合包括用示教学初始策略，再通过交互与奖励改进；',
   '常见组合包括用示教学初始策略，再通过交互与奖励改进；也可联合示教损失与 RL 目标，或从含演示的离线数据学习。具体做法依赖动作分布、可计算的概率、奖励和交互预算。RECAP 是优势条件策略路线，结合自主执行与人工纠正，不等同于统一套 PPO。项目回答应交代真实做过的组合、数据、对照和失败。', '常见组合包括用示教学初始策略，再通过交互与奖励改进；也可联合示教损失与 RL 目标，或从含演示的离线数据学习。具体做法依赖动作分布、可计算的概率、奖励和交互预算。RECAP 是优势条件策略路线，结合自主执行与人工纠正，不等同于统一套 PPO。项目回答应交代真实做过的组合、数据、对照和失败。',
   null, null, '["IL 与 RL 不是模型架构分类", "不能保证混合后最稳，更不能把未做过的 BC→PPO 流程当自己的实践经历。"]'::jsonb, null, 3, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q53","freq_label":"🔥×7","provenance":"核验：[RECAP 原论文](https://arxiv.org/abs/2511.14759)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000210', '你怎么收集数据？真机示教 vs 仿真 vs 人类视频，各自的优劣和落地代价？', 'eaq-v03-q55', 'knowledge', 'easy', '| 来源 | 优点 | 缺点 |',
   '| 来源 | 优点 | 缺点 |
|---|---|---|
| **真机示教**（teleop/VR） | 保真度最高、含接触反馈 | 1 demo 30-60s，人工最贵（ALOHA / DROID / Bridge） |
| **仿真** | 无限量、可标注 | Sim2Real gap，接触/软体仿不准（RLBench / ManiSkill / Isaac） |
| **人类视频** | 海量、多样 | 无 action label，需 retargeting（Ego4D / Something / Epic-Kitchens） |', '| 来源 | 优点 | 缺点 |
|---|---|---|
| **真机示教**（teleop/VR） | 保真度最高、含接触反馈 | 1 demo 30-60s，人工最贵（ALOHA / DROID / Bridge） |
| **仿真** | 无限量、可标注 | Sim2Real gap，接触/软体仿不准（RLBench / ManiSkill / Isaac） |
| **人类视频** | 海量、多样 | 无 action label，需 retargeting（Ego4D / Something / Epic-Kitchens） |

**实务路线**：① 人类视频做 representation 预训练（R3M / VC-1 / VIP）→ ② 仿真大规模 DR pretrain → ③ 真机 ~300 demos fine-tune。',
   null, null, '["不要单一数据源——三者结合才 scale", "纯真机太贵，纯仿真 gap 大。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q55","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000211', '末端力控有噪声怎么办？阻抗控制 / 导纳控制怎么选？', 'eaq-v03-q56', 'knowledge', 'medium', '**阻抗控制**（Impedance）：输入**期望位置** $x_d$，输出 **force/torque**；',
   '- **阻抗控制**（Impedance）：输入**期望位置** $x_d$，输出 **force/torque**；行为类似弹簧 + 阻尼，$F = K(x_d - x) + D \dot{x}$。
- **导纳控制**（Admittance）：输入**外力** $F_{\text{ext}}$，输出**位置变化**；行为是"外力推 → 位置响应"。', '- **阻抗控制**（Impedance）：输入**期望位置** $x_d$，输出 **force/torque**；行为类似弹簧 + 阻尼，$F = K(x_d - x) + D \dot{x}$。
- **导纳控制**（Admittance）：输入**外力** $F_{\text{ext}}$，输出**位置变化**；行为是"外力推 → 位置响应"。

**选择**：
| 场景 | 选哪个 |
|---|---|
| 机器人**主动**接触（打磨、装配、插针） | **阻抗** |
| 人**主动**引导机器人（co-bot 教学） | **导纳** |
| 高刚度任务（精确定位） | 阻抗（高 K） |
| 高顺应性任务（抓软物） | 阻抗（低 K）或导纳 |

**力觉噪声处理**：
1. **低通滤波**（一阶 IIR / 卡尔曼）去高频抖动；
2. **死区**：小于阈值视为 0；
3. **力 / 力矩传感器标定**：去重力 + 偏置；
4. **冗余传感融合**：关节扭矩 + 末端 F/T 双重估算。',
   null, null, '["阻抗 / 导纳是**对偶**关系，不是同义", "阻抗高刚 / 导纳高柔，相反。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q56","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000212', '你的观测空间为什么这么设？图像 + proprio + force 多模态怎么对齐 / 归一化？', 'eaq-v03-q57', 'knowledge', 'easy', '**典型 VLA 观测**。',
   '**典型 VLA 观测**：
- **图像**：1-4 帧 RGB，224×224 或 256×256，多视角（手腕相机 + 第三人称）。
- **Proprio**：关节位置（rad）+ 关节速度（rad/s）+ 末端位姿（SE(3)）。
- **Force/Torque**：末端 F/T 传感器 6 维 + 关节扭矩 N 维（可选）。', '**典型 VLA 观测**：
- **图像**：1-4 帧 RGB，224×224 或 256×256，多视角（手腕相机 + 第三人称）。
- **Proprio**：关节位置（rad）+ 关节速度（rad/s）+ 末端位姿（SE(3)）。
- **Force/Torque**：末端 F/T 传感器 6 维 + 关节扭矩 N 维（可选）。

**对齐 / 归一化**：
1. **图像**：CHW float，预训练 mean/std 归一化（如 ImageNet 的 `[0.485, 0.456, 0.406]`）；多视角 concat 在 channel 维。
2. **Proprio**：每维 $(x - \mu) / \sigma$，$\mu / \sigma$ 来自训练集统计。
3. **Force**：通常归一化到 $[-1, 1]$（±10 N / 1 Nm 量程）；力觉噪声大需先低通滤波。

**时序同步**：相机、关节、F/T 频率不同，训练样本通常以策略频率 / 样本频率为基准（如 10/20/50 Hz）。相机取最近且不晚于样本时刻的帧，或先估计链路延迟后做 offset 校正；高频 proprio、F/T 按样本时刻插值或窗口聚合。底层伺服 / PD 控制仍可保持数百 Hz 到 1 kHz。

**历史窗口**：常用 4-8 帧图像 + 同步 proprio 序列；用 Transformer / RNN 编码时序。',
   null, null, '["图像忘记归一化（直接喂 [0, 255]，权重崩）", "proprio 不归一化（不同关节量纲差 100 倍，训练不稳）。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q57","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000213', '在双臂 / 移动操作场景里，你怎么设计动作空间？关节空间 vs 末端空间，trade-off 在哪？', 'eaq-v03-q58', 'knowledge', 'medium', '**两种动作空间**。',
   '**两种动作空间**：
| | 关节空间（joint） | 末端空间（end-effector） |
|---|---|---|
| 输出 | N 维关节位置 / 速度 / 扭矩 | 6-DoF SE(3) 末端位姿 + gripper |
| 优点 | 直接给电机，无 IK 奇异 | 任务直观（"抓 cup"），数据效率高 |
| 缺点 | 模型需学复杂关节耦合 | 需 IK 解算，奇异点问题 |
| 数据需求 | 高（耦合复杂） | 低（任务对齐自然） |', '**两种动作空间**：
| | 关节空间（joint） | 末端空间（end-effector） |
|---|---|---|
| 输出 | N 维关节位置 / 速度 / 扭矩 | 6-DoF SE(3) 末端位姿 + gripper |
| 优点 | 直接给电机，无 IK 奇异 | 任务直观（"抓 cup"），数据效率高 |
| 缺点 | 模型需学复杂关节耦合 | 需 IK 解算，奇异点问题 |
| 数据需求 | 高（耦合复杂） | 低（任务对齐自然） |

**VLA 实务**：大多数 VLA 用**末端空间**——
- OpenVLA / RT-2：7 维（6-DoF 末端位姿 + 1 维 gripper）。
- π0：同上 + 多形态适配。
- 双臂：两套末端 = 14 维（ALOHA）。
- Mobile + 双臂：+ 2 维 base = **16 维**（Mobile ALOHA）。

**绝对 / 相对动作**：绝对动作输出目标关节值或目标末端位姿，适合标定稳定、低频轨迹复现；相对动作输出相邻控制步的 $\Delta q$ / $\Delta x$，对标定误差和物体扰动有一定鲁棒性，但会累积漂移，需要限幅、闭环校正和安全检查。答题时必须说清坐标系、单位、姿态表示、控制频率，以及夹爪 / 底盘维度。

**Trade-off**：
- **数据效率**：末端空间任务对齐好，少 demos 也能学（ACT 50 demos）。
- **物理稳定**：关节空间避免 IK 奇异，但模型要学更复杂映射。
- **跨 embodiment**：末端空间易标准化；关节空间因 DoF 不同难统一。',
   null, null, '["末端空间的 IK 奇异 / 关节限位问题需要**底层控制器 + 安全检查**兜底，不能让模型完全裸跑。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q58","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000214', '多频率传感器如何时间同步？为什么必须同步？', 'eaq-v03-q60', 'knowledge', 'easy', '真实机器人里相机、关节、力传感器和控制器频率通常不同，我会先统一时钟或记录硬件时间戳，再以策略训练的采样频率生成样本。',
   '真实机器人里相机、关节、力传感器和控制器频率通常不同，我会先统一时钟或记录硬件时间戳，再以策略训练的采样频率生成样本。相机取最近且不晚于样本时刻的帧，或在估计相机链路延迟后做 offset 校正；高频关节和力信号再按样本时刻插值、均值 / 末值聚合。同步的目的不是让底层控制降频，底层伺服仍常见于数百 Hz 到 1 kHz，而是让模型看到的 observation 对应它要模仿的 action。', '真实机器人里相机、关节、力传感器和控制器频率通常不同，我会先统一时钟或记录硬件时间戳，再以策略训练的采样频率生成样本。相机取最近且不晚于样本时刻的帧，或在估计相机链路延迟后做 offset 校正；高频关节和力信号再按样本时刻插值、均值 / 末值聚合。同步的目的不是让底层控制降频，底层伺服仍常见于数百 Hz 到 1 kHz，而是让模型看到的 observation 对应它要模仿的 action。',
   null, null, '["错位一两帧在视频里不明显，但 BC 会学成\"滞后控制\"，真机表现就是抓取慢半拍、接触时过冲。"]'::jsonb, null, 3, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q60","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000215', '机器人数据异常值如何清洗？归一化怎么做？', 'eaq-v03-q61', 'knowledge', 'easy', '清洗要分三层：帧级异常，如图像黑屏、时间戳跳变、关节速度尖峰；',
   '清洗要分三层：帧级异常，如图像黑屏、时间戳跳变、关节速度尖峰；片段级异常，如遥操作中断、夹爪未响应；episode 级异常，如任务失败或碰撞。普通 BC 通常以成功演示和有效动作片段为主，明显坏帧和无效 episode 不直接混入同一个监督目标；如果失败片段带有恢复动作、偏好标注或奖励信息，可以用于恢复策略、offline RL、偏好学习，甚至作为纠错示范的一部分。归一化上，图像按 backbone 要求做 mean / std，proprio 和 action 用训练集均值方差或固定物理范围，夹爪二值 / 连续值要单独处理。', '清洗要分三层：帧级异常，如图像黑屏、时间戳跳变、关节速度尖峰；片段级异常，如遥操作中断、夹爪未响应；episode 级异常，如任务失败或碰撞。普通 BC 通常以成功演示和有效动作片段为主，明显坏帧和无效 episode 不直接混入同一个监督目标；如果失败片段带有恢复动作、偏好标注或奖励信息，可以用于恢复策略、offline RL、偏好学习，甚至作为纠错示范的一部分。归一化上，图像按 backbone 要求做 mean / std，proprio 和 action 用训练集均值方差或固定物理范围，夹爪二值 / 连续值要单独处理。',
   null, null, '["归一化统计只能 fit 训练集", "用全量数据统计就是数据泄露。"]'::jsonb, null, 3, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q61","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000216', '多任务混合训练 vs 单任务微调怎么取舍？什么时候会互相干扰？', 'eaq-v03-q62', 'knowledge', 'medium', '多任务混训适合想要泛化能力，尤其任务共享视觉、抓取、放置等底层技能时，它能让模型学到更稳的表征；',
   '多任务混训适合想要泛化能力，尤其任务共享视觉、抓取、放置等底层技能时，它能让模型学到更稳的表征；单任务微调适合上线前追求某个任务的成功率和稳定性。互相干扰通常出现在任务动作分布冲突、语言指令不清、数据量极不均衡，或机器人形态不同却硬混时。工程上会用 task balancing、按任务采样、混入旧任务数据、LoRA adapter，或先通用预训练再小学习率微调。', '多任务混训适合想要泛化能力，尤其任务共享视觉、抓取、放置等底层技能时，它能让模型学到更稳的表征；单任务微调适合上线前追求某个任务的成功率和稳定性。互相干扰通常出现在任务动作分布冲突、语言指令不清、数据量极不均衡，或机器人形态不同却硬混时。工程上会用 task balancing、按任务采样、混入旧任务数据、LoRA adapter，或先通用预训练再小学习率微调。',
   null, null, '["多任务不必然提升，防遗忘也不是靠\"混在一起\"自动解决，要靠采样比例、保留集和分任务评测。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q62","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000217', '训练中 loss 下降但真机成功率不升，怎么排查？', 'eaq-v03-q63', 'knowledge', 'easy', '我会先判断这是离线指标和闭环执行不一致。',
   '我会先判断这是离线指标和闭环执行不一致。第一步看 validation loss 是否同步下降，排除过拟合；第二步按任务、物体、场景、操作者分桶统计成功率和失败类型；第三步回放模型输出，看动作是否平滑、是否饱和、夹爪时机是否错；第四步查数据切分、归一化、坐标系、action delay 和推理频率。很多时候 loss 下降只是模型更会拟合平均动作，真机需要的是闭环纠偏和关键接触时刻的正确动作。', '我会先判断这是离线指标和闭环执行不一致。第一步看 validation loss 是否同步下降，排除过拟合；第二步按任务、物体、场景、操作者分桶统计成功率和失败类型；第三步回放模型输出，看动作是否平滑、是否饱和、夹爪时机是否错；第四步查数据切分、归一化、坐标系、action delay 和推理频率。很多时候 loss 下降只是模型更会拟合平均动作，真机需要的是闭环纠偏和关键接触时刻的正确动作。',
   null, null, '["不要只盯总 loss", "机器人策略要看 rollout 视频、动作分布和真机分桶成功率。"]'::jsonb, null, 3, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q63","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000218', '真机上机械臂停滞、动作不连续或漂移，怎么排查？', 'eaq-v03-q64', 'knowledge', 'easy', '我会按"模型输出、通信链路、控制器、机器人状态"四层排。',
   '我会按"模型输出、通信链路、控制器、机器人状态"四层排。先记录模型 action、反归一化 action、发送到控制器的 command、机器人实际 joint / EEF 轨迹，确认是不是单位、坐标系、限幅或 action chunk 拼接出了问题；再查推理耗时和通信延迟，看是否控制频率掉帧；最后看 IK 是否到奇异点、关节限位、安全保护或速度 / 加速度约束触发。漂移常见于相对动作累积误差，停滞常见于动作被安全层裁掉或夹爪 / 末端坐标系错。', '我会按"模型输出、通信链路、控制器、机器人状态"四层排。先记录模型 action、反归一化 action、发送到控制器的 command、机器人实际 joint / EEF 轨迹，确认是不是单位、坐标系、限幅或 action chunk 拼接出了问题；再查推理耗时和通信延迟，看是否控制频率掉帧；最后看 IK 是否到奇异点、关节限位、安全保护或速度 / 加速度约束触发。漂移常见于相对动作累积误差，停滞常见于动作被安全层裁掉或夹爪 / 末端坐标系错。',
   null, null, '["不要一句话归因\"模型不行\"，必须用日志对齐 commanded、desired 和 actual trajectory。"]'::jsonb, null, 3, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q64","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000219', '长序列任务成功率低，或物体随机摆放就失败，原因和优化？', 'eaq-v03-q65', 'knowledge', 'medium', '长序列失败通常是复合误差，前面每一步的小偏差都会把后续状态带出训练分布；',
   '长序列失败通常是复合误差，前面每一步的小偏差都会把后续状态带出训练分布；随机摆放失败则多半是视觉定位、相机外参、深度尺度、语言 grounding 或训练数据覆盖不足。优化上，短期可以加 action chunking、重规划频率、失败恢复数据和关键子任务检测；数据上要做位置、背景、光照、物体实例的覆盖；架构上可用分层规划，把长任务拆成 pick、place、open 等技能。', '长序列失败通常是复合误差，前面每一步的小偏差都会把后续状态带出训练分布；随机摆放失败则多半是视觉定位、相机外参、深度尺度、语言 grounding 或训练数据覆盖不足。优化上，短期可以加 action chunking、重规划频率、失败恢复数据和关键子任务检测；数据上要做位置、背景、光照、物体实例的覆盖；架构上可用分层规划，把长任务拆成 pick、place、open 等技能。',
   null, null, '["随机化不是只换背景图，末端与物体的几何关系、遮挡和接触状态也要覆盖。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q65","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000220', '如果加触觉、力反馈或 3D 信息，数据采集和模型要怎么改？', 'eaq-v03-q66', 'knowledge', 'medium', '加这些模态首先是数据问题：触觉、力、点云都要有时间戳、标定和单位；',
   '加这些模态首先是数据问题：触觉、力、点云都要有时间戳、标定和单位；力传感器要视安装方式做 bias / gravity compensation；点云要处理外参、深度尺度和缺失点。模型上可以把 3D 用 point encoder 或 voxel / BEV encoder，触觉和力用 MLP / Transformer 编成 token，再和视觉语言 token 融合。输出端是否预测力或阻抗目标取决于底层控制栈；很多项目只是把力觉作为 observation 和安全约束，不直接让 VLA 输出力。', '加这些模态首先是数据问题：触觉、力、点云都要有时间戳、标定和单位；力传感器要视安装方式做 bias / gravity compensation；点云要处理外参、深度尺度和缺失点。模型上可以把 3D 用 point encoder 或 voxel / BEV encoder，触觉和力用 MLP / Transformer 编成 token，再和视觉语言 token 融合。输出端是否预测力或阻抗目标取决于底层控制栈；很多项目只是把力觉作为 observation 和安全约束，不直接让 VLA 输出力。',
   null, null, '["模态越多不一定越好", "同步、标定和噪声处理不到位会让模型更不稳定。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q66","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000221', '本地评测、官方榜单和真机结果不一致，怎么解释和验证？', 'eaq-v03-q67', 'knowledge', 'medium', '我会把三者看成不同分布。',
   '我会把三者看成不同分布。本地评测可能和训练集接近，官方榜单强调标准 benchmark，真机还多了延迟、标定、控制器和环境扰动。解释时先确认 action space、图像预处理、相机视角、任务成功定义和容差是否一致，再看是否用了同一 checkpoint、同一归一化统计和同一推理频率。验证上要固定随机种子和评测脚本，同时保留 rollout 视频和失败分类，最后用真机 A / B test 决策。', '我会把三者看成不同分布。本地评测可能和训练集接近，官方榜单强调标准 benchmark，真机还多了延迟、标定、控制器和环境扰动。解释时先确认 action space、图像预处理、相机视角、任务成功定义和容差是否一致，再看是否用了同一 checkpoint、同一归一化统计和同一推理频率。验证上要固定随机种子和评测脚本，同时保留 rollout 视频和失败分类，最后用真机 A / B test 决策。',
   null, null, '["榜单高不代表真机稳，真机低也不一定是模型差，可能是部署接口或标定错。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q67","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000222', 'LoRA / PEFT 微调 VLA 时冻结哪里？怎么验证没有灾难性遗忘？', 'eaq-v03-q68', 'knowledge', 'medium', '常见做法是冻结大部分视觉 backbone 和语言 backbone，只在 LLM attention / MLP 的低秩矩阵、action head 或 projector 上训练；',
   '常见做法是冻结大部分视觉 backbone 和语言 backbone，只在 LLM attention / MLP 的低秩矩阵、action head 或 projector 上训练；数据很少时冻结更多，数据充足且 embodiment 差异大时可以开放 action head、adapter 或后几层。验证不能只看新任务成功率，还要保留一组旧任务、基础语言理解和原始机器人任务作为 replay eval，看是否出现旧任务成功率下降、语言指令理解退化或动作分布漂移。', '常见做法是冻结大部分视觉 backbone 和语言 backbone，只在 LLM attention / MLP 的低秩矩阵、action head 或 projector 上训练；数据很少时冻结更多，数据充足且 embodiment 差异大时可以开放 action head、adapter 或后几层。验证不能只看新任务成功率，还要保留一组旧任务、基础语言理解和原始机器人任务作为 replay eval，看是否出现旧任务成功率下降、语言指令理解退化或动作分布漂移。',
   null, null, '["LoRA 省显存但不自动防遗忘", "学习率、rank、训练步数和 replay 数据同样关键。"]'::jsonb, null, 5, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"项目拷打 / 工程实现","qid":"Q68","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000223', '手撕 Behavior Cloning（连续 / 离散动作）', 'eaq-v03-h01', 'coding', 'easy', 'BC 本质是监督学习；',
   'BC 本质是监督学习；连续 MSE / Gaussian NLL、离散 CE；根本限制是 distribution shift（无 reward 信号）。', '**考察点**：BC 本质是监督学习；连续 MSE / Gaussian NLL、离散 CE；根本限制是 distribution shift（无 reward 信号）。

**实现**：

```python
import torch
import torch.nn.functional as F

def bc_loss_mse(pi, s, a_star):
    # 连续 deterministic：action 须先归一化到 [-1,1]，否则量纲不一压不住
    return F.mse_loss(pi(s), a_star)

def bc_loss_gaussian(pi, s, a_star, log_std_min=-5.0, log_std_max=2.0):
    # 连续 stochastic：模型出 μ, log_σ；clamp log_σ 防数值发散
    mu, log_std = pi(s)
    log_std = log_std.clamp(log_std_min, log_std_max)
    # -log N(a*; μ, σ) 的可降项：0.5·((a-μ)/σ)² + log σ + const
    return (0.5 * ((a_star - mu) / log_std.exp()).pow(2) + log_std).sum(-1).mean()

def bc_loss_ce(pi, s, a_token):
    # 离散（OpenVLA-style）：a_token 是离散 bin id
    return F.cross_entropy(pi(s), a_token)
```',
   null, null, '["把 BC 当 RL", "忘 action 归一化", "`log_σ` 不 clamp 数值发散", "离散用 MSE（应 CE）。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H01","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000224', '手撕 Diffusion Policy 训练 step（DDPM ε-prediction）', 'eaq-v03-h02', 'coding', 'hard', '`x_t=√ᾱ_t·x_0+√(1-ᾱ_t)·ε`；',
   '`x_t=√ᾱ_t·x_0+√(1-ᾱ_t)·ε`；ε-prediction 目标；视觉 obs 作为 cross-attn condition。', '**考察点**：`x_t=√ᾱ_t·x_0+√(1-ᾱ_t)·ε`；ε-prediction 目标；视觉 obs 作为 cross-attn condition。

**实现**：

```python
import torch
import torch.nn.functional as F

def make_alpha_bar(T=1000):
    # cosine schedule (Nichol & Dhariwal)：ᾱ_t = f(t)/f(0)，比 linear 末段更稳
    steps = torch.arange(T + 1) / T
    f = torch.cos((steps + 0.008) / 1.008 * torch.pi / 2).pow(2)
    return (f / f[0])[1:]  # 长度 T，单调递减，保证 1-ᾱ_t ∈ (0,1)

def dp_train_step(model, x0, cond, alpha_bar):
    # x0: [B, H, action_dim] 未来 H 步 action chunk
    # cond: [B, D_cond] 视觉特征（不能漏，否则退化为无条件采样）
    B = x0.size(0)
    t = torch.randint(0, len(alpha_bar), (B,), device=x0.device)
    ab = alpha_bar[t].view(B, 1, 1)  # 广播到 [B,H,action_dim]
    eps = torch.randn_like(x0)
    xt = ab.sqrt() * x0 + (1 - ab).sqrt() * eps  # forward q(x_t|x_0)
    eps_pred = model(xt, t, cond=cond)
    return F.mse_loss(eps_pred, eps)  # ε-prediction 目标
```',
   null, null, '["漏掉视觉 cond 进 UNet", "把 action 当图像 spatial 维", "推理 K 步太多（DDIM 10-50 即可）", "不用 EMA 生成抖。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H02","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000225', '手撕 ACT action chunking loss', 'eaq-v03-h03', 'coding', 'medium', 'chunk 长度 k 缓解 distribution shift；',
   'chunk 长度 k 缓解 distribution shift；CVAE latent z 建模动作多模态；temporal ensemble 推理。', '**考察点**：chunk 长度 k 缓解 distribution shift；CVAE latent z 建模动作多模态；temporal ensemble 推理。

**实现**：

```python
import torch
import torch.nn.functional as F

def act_loss(decoder, encoder, qpos, action_chunk, cond, beta=10.0):
    # action_chunk: [B, k, action_dim]；cond: 视觉特征
    # encoder 输入 [qpos, action_chunk]，[CLS] token 出 μ, log_σ²
    mu, logvar = encoder(qpos, action_chunk)             # [B, z_dim] each
    std = (0.5 * logvar).exp()
    z = mu + std * torch.randn_like(std)                  # 训练时采样 (reparam)
    # decoder：cross-attn(query=fixed pos, k/v = cond ⊕ qpos ⊕ z)
    a_hat = decoder(qpos=qpos, cond=cond, z=z)            # [B, k, action_dim]
    # 重建损失用 L1（ACT 论文实验上比 MSE 更稳）
    recon = F.l1_loss(a_hat, action_chunk)
    # KL(q‖N(0,I)) 闭式
    kl = 0.5 * (mu.pow(2) + logvar.exp() - 1 - logvar).sum(-1).mean()
    return recon + beta * kl

def act_inference(decoder, qpos, cond, z_dim):
    # 推理时 z=0 不再采样，避免 latent 抖动
    z = torch.zeros(qpos.size(0), z_dim, device=qpos.device)
    return decoder(qpos=qpos, cond=cond, z=z)
```',
   null, null, '["chunk 太短退化为 BC", "β 太大压死 latent", "推理仍从 latent 采样导致抖动", "recon 用 MSE 反而不如 L1 稳。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H03","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000226', '手撕 OpenVLA 风格 action token CE loss', 'eaq-v03-h04', 'coding', 'medium', '连续动作离散到 256 bin → LM head next-token CE；',
   '连续动作离散到 256 bin → LM head next-token CE；用 quantile 切分（非 min/max）匹配数据分布。', '**考察点**：连续动作离散到 256 bin → LM head next-token CE；用 quantile 切分（非 min/max）匹配数据分布。

**实现**：

```python
import torch
import torch.nn.functional as F

def fit_bins_quantile(actions, n_bin=256):
    # actions: [N, D]；按 quantile 而非 min/max 切分，防长尾压缩
    qs = torch.linspace(0, 1, n_bin + 1, device=actions.device)
    # 每维独立切：返回 [D, n_bin+1] 的边界
    return torch.stack([torch.quantile(actions[:, d], qs) for d in range(actions.size(1))])

def discretize(action, bins, vocab_offset):
    # action: [B, D]；bins: [D, n_bin+1]
    # 用 bucketize 找落在哪个区间 → token id（偏移到词表预留段）
    token_ids = torch.stack([
        torch.bucketize(action[:, d], bins[d, 1:-1])  # 去掉首尾哨兵
        for d in range(action.size(1))
    ], dim=1)
    return token_ids + vocab_offset  # 落到词表预留的 action token 段

def openvla_loss(logits, target_ids, action_mask):
    # logits: [B, L, V]；target_ids: [B, L]；action_mask 仅在 action token 处为 1
    # 屏蔽 prompt/image token 的 loss，只学 action 段
    return F.cross_entropy(logits.transpose(1, 2), target_ids,
                           reduction=''none'').mul(action_mask).sum() / action_mask.sum().clamp(min=1)
```',
   null, null, '["用全局 min/max 切 bin 长尾压缩", "mask 后 target_ids 仍要是合法 vocab id（用 `ignore_index=-100` 时改写法）", "推理用 sampling 而非 argmax 致动作抖。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H04","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000227', '手撕 CLIP / InfoNCE 对比损失', 'eaq-v03-h05', 'coding', 'medium', '对称 CE；',
   '对称 CE；温度 τ 用可学的 `exp(t)` + clamp；为何 i→t 与 t→i 各算一次（对齐两个方向）。', '**考察点**：对称 CE；温度 τ 用可学的 `exp(t)` + clamp；为何 i→t 与 t→i 各算一次（对齐两个方向）。

**实现**：

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

class CLIPLoss(nn.Module):
    def __init__(self, init_t=0.07):
        super().__init__()
        # 学 log(1/τ)；用 exp 保证 τ>0；clamp 防梯度爆炸
        self.log_inv_t = nn.Parameter(torch.tensor(1.0 / init_t).log())

    def forward(self, img_feat, txt_feat):
        # 必须 L2 归一化，否则点积≠cosine
        img_emb = F.normalize(img_feat, dim=-1)
        txt_emb = F.normalize(txt_feat, dim=-1)
        # 对照官方 CLIP：clamp log(1/τ) ≤ ln(100) ≈ 4.605
        scale = self.log_inv_t.clamp(max=4.605).exp()
        logits = scale * img_emb @ txt_emb.T  # [N, N]
        labels = torch.arange(img_emb.size(0), device=img_emb.device)
        # 对称：i→t 沿行做 softmax；t→i 沿列做 softmax
        return (F.cross_entropy(logits, labels) +
                F.cross_entropy(logits.T, labels)) / 2
```',
   null, null, '["忘 L2 归一化点积≠cosine", "τ 未 clamp 梯度爆炸", "batch 太小负样本不足", "只算单向 CE 失对称性。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H05","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000228', '手撕 DAgger（数据聚合）训练流程', 'eaq-v03-h06', 'coding', 'medium', '解决 BC 的 distribution shift；',
   '解决 BC 的 distribution shift；每轮 rollout 拿专家标注新数据回灌；β-mix 早期靠专家、后期靠 π。', '**考察点**：解决 BC 的 distribution shift；每轮 rollout 拿专家标注新数据回灌；β-mix 早期靠专家、后期靠 π。

**实现**：

```python
import random

def dagger_train(pi, expert, env, train_fn, n_iter=10, rollout_T=200):
    # train_fn(pi, dataset) -> 新 pi；专家与环境为黑箱
    dataset = expert.collect()  # D_0：纯专家轨迹（先 BC 起步）
    pi = train_fn(pi, dataset)
    for i in range(1, n_iter + 1):
        beta = max(0.05, 0.9 ** i)  # 退火不要太快，保留早期专家引导
        obs = env.reset()
        traj_obs, traj_act = [], []
        for _ in range(rollout_T):
            # β-mix rollout：以 β 用专家动作走、否则用 π；标注始终来自专家
            a_exec = expert.act(obs) if random.random() < beta else pi.act(obs)
            traj_obs.append(obs)
            traj_act.append(expert.act(obs))  # 关键：标注用专家在该 obs 的动作
            obs, _, done, _ = env.step(a_exec)
            if done:
                break
        dataset.extend(list(zip(traj_obs, traj_act)))  # 只加不替换
        pi = train_fn(pi, dataset)
    return pi
```',
   null, null, '["标注用执行动作而非专家在该 obs 的动作（破坏 DAgger 本质）", "β 退火太快首轮就全靠 π", "数据集替换而非累加", "忽略 query 选择策略致标注爆炸。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H06","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000229', '手撕 cross-attention（视觉-语言融合）', 'eaq-v03-h07', 'coding', 'medium', '与 self-attn 唯一区别 = K/V 来自另一序列；',
   '与 self-attn 唯一区别 = K/V 来自另一序列；输出长度跟 Q；mask 形状 `[L_q, L_kv]`。', '**考察点**：与 self-attn 唯一区别 = K/V 来自另一序列；输出长度跟 Q；mask 形状 `[L_q, L_kv]`。

**实现**：

```python
import math
import torch.nn as nn
import torch.nn.functional as F

class CrossAttention(nn.Module):
    def __init__(self, d_q, d_kv, d_model, h):
        super().__init__()
        assert d_model % h == 0
        self.h, self.d_k = h, d_model // h
        self.Wq = nn.Linear(d_q, d_model)
        self.Wk = nn.Linear(d_kv, d_model)  # K/V 从另一序列投影
        self.Wv = nn.Linear(d_kv, d_model)
        self.Wo = nn.Linear(d_model, d_model)

    def forward(self, x_q, x_kv, mask=None):
        # x_q: [B, Lq, d_q]; x_kv: [B, Lkv, d_kv]
        B, Lq, _ = x_q.shape
        Lkv = x_kv.size(1)
        q = self.Wq(x_q).view(B, Lq, self.h, self.d_k).transpose(1, 2)
        k = self.Wk(x_kv).view(B, Lkv, self.h, self.d_k).transpose(1, 2)
        v = self.Wv(x_kv).view(B, Lkv, self.h, self.d_k).transpose(1, 2)
        scores = q @ k.transpose(-2, -1) / math.sqrt(self.d_k)
        if mask is not None:  # mask: [B, 1, Lq, Lkv]
            scores = scores.masked_fill(mask, float(''-inf''))
        out = F.softmax(scores, -1) @ v  # 输出长度 = Lq
        return self.Wo(out.transpose(1, 2).contiguous().view(B, Lq, -1))
```',
   null, null, '["把 K/V 也从 `x_q` 投影（变 self-attn）", "mask 形状按 self-attn 设", "V 忘换序列。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H07","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000230', '手撕 KV cache（增量解码）', 'eaq-v03-h08', 'coding', 'medium', 'prefill 后单步只算新 token 的 Q；',
   'prefill 后单步只算新 token 的 Q；旧 K/V 复用而非重算；显存随序列线性增长。', '**考察点**：prefill 后单步只算新 token 的 Q；旧 K/V 复用而非重算；显存随序列线性增长。

**实现**：

```python
import math
import torch
import torch.nn.functional as F

def attn_with_kv_cache(q_new, k_new, v_new, kv_cache, layer_idx):
    # q_new/k_new/v_new: 当前 step token 的 q,k,v，形状 [B, h, 1, d_k]
    # kv_cache[layer_idx] = (K_past, V_past)，shape [B, h, L_past, d_k]
    if kv_cache[layer_idx] is None:
        K, V = k_new, v_new  # prefill 首步
    else:
        K_past, V_past = kv_cache[layer_idx]
        # 沿序列维 concat；旧 K/V 不再重算（这是 cache 核心）
        K = torch.cat([K_past, k_new], dim=2)
        V = torch.cat([V_past, v_new], dim=2)
    kv_cache[layer_idx] = (K, V)  # 写回
    d_k = q_new.size(-1)
    # decode 单步只算 [B,h,1,L_new] 的 scores，不需要 causal mask
    scores = q_new @ K.transpose(-2, -1) / math.sqrt(d_k)
    return F.softmax(scores, -1) @ V  # [B, h, 1, d_k]
```',
   null, null, '["每步把整段重算（失去 cache 意义）", "忘对新 K 也加 RoPE（位置错）", "显存爆但没 paged 管理", "并发请求共享同一 cache。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H08","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000231', '手撕 Flow Matching 训练 step', 'eaq-v03-h09', 'coding', 'medium', '这是 rectified / linear path 版本的 Flow Matching。',
   '这是 rectified / linear path 版本的 Flow Matching。把归一化后的动作 $x_1$ 和噪声 $x_0$ 连成直线路径，随机采样 $t$ 得到 $x_t=(1-t)x_0+t x_1$，目标速度是 $v^*=x_1-x_0$，模型学习 $v_\theta(o,x_t,t)$。', '**考察点**：这是 rectified / linear path 版本的 Flow Matching。把归一化后的动作 $x_1$ 和噪声 $x_0$ 连成直线路径，随机采样 $t$ 得到 $x_t=(1-t)x_0+t x_1$，目标速度是 $v^*=x_1-x_0$，模型学习 $v_\theta(o,x_t,t)$。

**实现**：

```python
import torch
import torch.nn.functional as F

def flow_matching_loss(model, obs, action):
    # action 通常先归一化；形状可为 [B, D] 或 [B, horizon, D]
    x1 = action
    x0 = torch.randn_like(x1)
    t_shape = (x1.size(0),) + (1,) * (x1.ndim - 1)
    t = torch.rand(t_shape, device=x1.device, dtype=x1.dtype)
    xt = (1 - t) * x0 + t * x1
    v_target = x1 - x0
    v_pred = model(obs, xt, t)
    return F.mse_loss(v_pred, v_target)
```

**推理**：从噪声动作开始，用欧拉积分多步更新：$x \leftarrow x + \Delta t \cdot v_\theta(o,x,t)$，最后得到单步 action 或 action chunk。',
   null, null, '["不要把 Flow Matching 说成\"预测噪声 $\\epsilon$\"", "这里回归的是速度场。也不要说所有 Flow Matching 都必须用这条直线路径，它只是机器人动作生成里常见、好讲的一种形式。"]'::jsonb, null, 10, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"03","volume_title":"卷三 · VLA / 模仿学习","section":"手撕代码","qid":"H09","freq_label":"补充"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000232', 'RSSM（循环状态空间模型）是什么？Dreamer 系列如何用它做"想象训练"？', 'eaq-v04-q01', 'knowledge', 'medium', 'RSSM（Recurrent State-Space Model，Hafner 2019 PlaNet）包含两条路径。',
   'RSSM（Recurrent State-Space Model，Hafner 2019 PlaNet）包含两条路径：
- **确定性路径** $h_t$（GRU 递归记忆）：保留长序列的历史信息
- **随机路径** $z_t$（随机隐变量：V1 用 Gaussian，V2/V3 用 Categorical 离散）：表达单步不确定性', 'RSSM（Recurrent State-Space Model，Hafner 2019 PlaNet）包含两条路径：
- **确定性路径** $h_t$（GRU 递归记忆）：保留长序列的历史信息
- **随机路径** $z_t$（随机隐变量：V1 用 Gaussian，V2/V3 用 Categorical 离散）：表达单步不确定性

两路拼接得到 latent state $(h_t, z_t)$。在训练时，$z_t$ 从观测中后验推断；在"想象"时，$z_t$ 从 RSSM 的先验中直接采样，无需真实环境交互。

**Dreamer 的想象训练**：世界模型在 latent 空间中前向 rollout 若干步，actor-critic 从这些"想象轨迹"中通过 BPTT（截断梯度）更新策略——样本效率比 model-free 高 5-20 倍。',
   null, null, '["RSSM 不是 VAE，它的 deterministic path（h_t）是必须的，使得模型能记忆历史", "纯 VAE 缺少这条路径会导致长程记忆消失。"]'::jsonb, null, 5, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"世界模型基础","qid":"Q01","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000233', 'PlaNet 是什么？和 Dreamer 的核心区别？RSSM 中"确定性路径 + 随机路径"分别起什么作用？', 'eaq-v04-q02', 'knowledge', 'medium', '**PlaNet**（Hafner et al., 2019）是第一个用 RSSM 从像素做规划的模型。',
   '**PlaNet**（Hafner et al., 2019）是第一个用 RSSM 从像素做规划的模型。策略是**基于模型的规划**（CEM/随机射击搜索），在 latent 空间内采样动作序列、评估价值，选最优序列的第一步执行。', '**PlaNet**（Hafner et al., 2019）是第一个用 RSSM 从像素做规划的模型。策略是**基于模型的规划**（CEM/随机射击搜索），在 latent 空间内采样动作序列、评估价值，选最优序列的第一步执行。

**与 Dreamer 的区别**：PlaNet 不学独立 actor，每步都要在线规划（慢）。Dreamer 额外学了 actor-critic，规划由 actor 网络"内化"，推理时直接前向过 actor，无需每步优化。

**两路的作用**：
- **确定性路径 $h_t$**（GRU）：跨步传递历史，提供给随机路径作上下文
- **随机路径 $z_t$**（随机隐变量，防止后验崩塌）：建模单步观测的随机性/不确定性',
   null, null, '["PlaNet 已经用 RSSM，但策略仍是 MPC 式在线规划，不是学习到的 actor", "Dreamer 才是\"梦中学 actor\"。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"世界模型基础","qid":"Q02","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000234', '什么是 latent imagination？Dreamer 如何在隐空间里学策略而不需要真实交互？', 'eaq-v04-q03', 'knowledge', 'medium', '**Latent imagination**：在 RSSM 学好后，从任意 latent state 出发，纯在模型内部（latent 空间）前向模拟 H 步，得到"想象轨迹"。',
   '**Latent imagination**：在 RSSM 学好后，从任意 latent state 出发，纯在模型内部（latent 空间）前向模拟 H 步，得到"想象轨迹"。这些轨迹不需要渲染成图像、不需要真实物理引擎，只在低维隐向量间运算，极速高效。', '**Latent imagination**：在 RSSM 学好后，从任意 latent state 出发，纯在模型内部（latent 空间）前向模拟 H 步，得到"想象轨迹"。这些轨迹不需要渲染成图像、不需要真实物理引擎，只在低维隐向量间运算，极速高效。

**Dreamer 的策略学习步骤**：
1. 用真实数据训练 RSSM（重建损失 + KL 正则）
2. 从 replay buffer 中的已见 latent 出发，通过 RSSM 前向展开 H=15 步想象轨迹
3. actor（策略网络）用 BPTT 在这些想象轨迹上最大化折扣奖励
4. critic（价值网络）拟合回报，给 actor 提供低方差梯度

**优势**：真实数据采集量少（用来训 RSSM），策略迭代在"梦中"完成，可做数百次 gradient step 对应一次真实 rollout。',
   null, null, '["Dreamer 的 imagination 不是视频生成（不解码到像素），而是在 latent 向量空间中的前向传播", "解码器只用于 RSSM 训练的重建损失。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"世界模型基础","qid":"Q03","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000235', 'model-based RL（Dreamer 类）和 model-free RL（PPO/SAC 类）在 sample efficiency 上的对比？', 'eaq-v04-q04', 'knowledge', 'easy', '| | Model-Free（PPO/SAC） | Model-Based（Dreamer/TD-MPC） |',
   '| | Model-Free（PPO/SAC） | Model-Based（Dreamer/TD-MPC） |
|---|---|---|
| 环境步数需求 | 高（百万级） | 低（十万级） |
| 算法复杂度 | 低 | 高（需训世界模型） |
| 计算成本/步 | 低 | 高（想象 rollout） |
| 真机部署适合度 | 低（样本贵） | 高（用数据想象学策略） |
| 模型偏差风险 | 无 | 有（world model error 累积） |', '| | Model-Free（PPO/SAC） | Model-Based（Dreamer/TD-MPC） |
|---|---|---|
| 环境步数需求 | 高（百万级） | 低（十万级） |
| 算法复杂度 | 低 | 高（需训世界模型） |
| 计算成本/步 | 低 | 高（想象 rollout） |
| 真机部署适合度 | 低（样本贵） | 高（用数据想象学策略） |
| 模型偏差风险 | 无 | 有（world model error 累积） |

**实务选择**：
- 真机直接训练（无仿真）→ **model-based 首选**，1 小时内学四足行走（DayDreamer）
- 大规模仿真 + GPU 并行 → model-free（PPO）足够，parallelism 弥补了样本效率劣势
- 数据稀缺的精细操作 → model-based + offline RL 混合',
   null, null, '["model-based 不等于更快收敛（wall-clock time），因为每步需要训世界模型并做想象 rollout", "但**环境交互次数**（环境 step 数）确实减少。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"世界模型基础","qid":"Q04","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000236', 'MuZero 和 Dreamer 的核心区别？各自适合什么场景？', 'eaq-v04-q05', 'knowledge', 'medium', '| | Dreamer / PlaNet | MuZero |',
   '| | Dreamer / PlaNet | MuZero |
|---|---|---|
| 观测重建 | **有**（解码器重建图像/状态） | **无**（decoder-free，隐式模型） |
| 规划方式 | 想象 rollout + actor-critic | MCTS（树搜索）+ 动力学网络 |
| 动作空间 | 连续为主 | 离散为主（board games / Atari） |
| 真机适用 | 强（连续控制，低采样数） | 弱（MCTS 开销大，实时性差） |
| 世界模型目标 | 最小化重建 + KL | 最小化 value/policy/reward 预测误差（价值等价原则） |', '| | Dreamer / PlaNet | MuZero |
|---|---|---|
| 观测重建 | **有**（解码器重建图像/状态） | **无**（decoder-free，隐式模型） |
| 规划方式 | 想象 rollout + actor-critic | MCTS（树搜索）+ 动力学网络 |
| 动作空间 | 连续为主 | 离散为主（board games / Atari） |
| 真机适用 | 强（连续控制，低采样数） | 弱（MCTS 开销大，实时性差） |
| 世界模型目标 | 最小化重建 + KL | 最小化 value/policy/reward 预测误差（价值等价原则） |

**关键差异**：MuZero 的世界模型不需要还原真实观测，只需要能做价值等价的预测（Schrittwieser 2020）；Dreamer 用重建损失保证世界模型学到有意义的 latent。

**适合场景**：MuZero → 离散决策、棋类、Atari；Dreamer → 连续控制、视觉机器人、仿真和真机。',
   null, null, '["MuZero 不是\"更先进的 Dreamer\"，两者是不同范式", "MuZero 的规划开销在实时连续控制中通常无法接受。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"世界模型基础","qid":"Q05","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000237', 'DreamerV3 相比 DreamerV1/V2 做了哪些改进？symlog 和 KL balancing 分别解决什么问题？', 'eaq-v04-q06', 'knowledge', 'hard', '**V1**（2020 ICLR）：RSSM + 连续 latent + actor-critic 想象训练，首次像素级机器人控制',
   '- **V1**（2020 ICLR）：RSSM + 连续 latent + actor-critic 想象训练，首次像素级机器人控制
- **V2**（2021 ICLR）：离散 latent（Categorical 分布）+ KL balancing（α=0.8 偏先验），Atari 超人类
- **V3**（2023 Hafner，Nature 2025）：symlog 归一化 + free bits + 固定超参，7 类 domain 无需调参', '- **V1**（2020 ICLR）：RSSM + 连续 latent + actor-critic 想象训练，首次像素级机器人控制
- **V2**（2021 ICLR）：离散 latent（Categorical 分布）+ KL balancing（α=0.8 偏先验），Atari 超人类
- **V3**（2023 Hafner，Nature 2025）：symlog 归一化 + free bits + 固定超参，7 类 domain 无需调参

**symlog 解决什么**：奖励尺度跨任务差异巨大，直接学习梯度不稳定。symlog(x) = sign(x)·ln(|x|+1) 压缩大值、线性化小值，稳定 reward/value 预测。

**KL balancing（α=0.8）解决什么**：若 posterior 和 prior 同等更新，prior 容易学得太简单。α=0.8 使更多梯度流向 prior，令其主动贴近 posterior，提升动力学预测质量。',
   null, null, '["free bits（KL 低于阈值不惩罚）是 V1 就有的技巧，不是 V3 新增", "V3 的创新是 symlog + percentage normalization + 规模化固定超参。"]'::jsonb, null, 8, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Dreamer 系列进化","qid":"Q06","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000238', 'DreamerV3 为什么能"一套超参跨 7 大 domain"？固定超参的背后是什么设计？', 'eaq-v04-q07', 'knowledge', 'hard', 'DreamerV3 的"固定超参"核心在于消除了**奖励尺度依赖**和**任务特定归一化**。',
   'DreamerV3 的"固定超参"核心在于消除了**奖励尺度依赖**和**任务特定归一化**：', 'DreamerV3 的"固定超参"核心在于消除了**奖励尺度依赖**和**任务特定归一化**：

1. **symlog 统一奖励尺度**：不同任务奖励量级不一，symlog 压缩后 critic 和 actor 的学习率无需逐任务调整
2. **percentage-based value normalization**：用百分位数（5th / 95th）归一化 advantage，消除绝对数值的影响
3. **固定 KL free bits = 1 nat**：使 latent 既有足够信息量又不过度正则化，无需按任务调 β
4. **规模化鲁棒性**：模型够大（200M 参数），容量充足以应对不同 domain 的复杂性

**跨越的 7 类 domain**：Atari（离散）/ DMControl（连续）/ MineCraft（3D 探索）/ Crafter（多任务）/ DMLab（记忆） / BSuite（系统性测试）/ proprio state（低维）。',
   null, null, '["固定超参不代表\"不需要训练更多步\"，不同任务环境步数仍有差异", "固定的是**算法超参**，不是训练步数。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Dreamer 系列进化","qid":"Q07","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000239', 'DayDreamer 实验说明了什么？世界模型是否能在真机上在线训练？', 'eaq-v04-q08', 'knowledge', 'medium', '**DayDreamer**（Wu et al., CoRL 2022，UC Berkeley）是 Dreamer 的真机版本，关键结论。',
   '**DayDreamer**（Wu et al., CoRL 2022，UC Berkeley）是 Dreamer 的真机版本，关键结论：', '**DayDreamer**（Wu et al., CoRL 2022，UC Berkeley）是 Dreamer 的真机版本，关键结论：

- **四足行走从零学会**：Unitree A1 四足机器人从随机初始化出发，在**真机不重置**的情况下，约 **1 小时**内学会站立和行走（无需仿真、无需演示）
- **在线学习可行**：世界模型实时更新（边交互边训），策略在 latent imagination 中迭代，真机数据需求比 model-free 少 5-10×
- **真机 adaptation**：学会走后 10 分钟内适应扰动（推动/地形变化）

**意义**：证明世界模型在真机上在线训练是可行的，不是只适合仿真；为无需 sim2real 的真机模型学习路线提供了可行 baseline。

**限制**：四足行走任务相对简单（无精细操作），高维操作任务在真机上的实时世界模型学习仍是开放问题。',
   null, null, '["DayDreamer 不是\"不需要 sim2real\"的方案，而是\"不依赖仿真\"的替代方向", "两条路线（sim2real 和真机在线学习）各有适用场景。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Dreamer 系列进化","qid":"Q08","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000240', 'TD-MPC2 的"隐式世界模型"是什么概念？它和 DreamerV3 的 RSSM 有什么区别？', 'eaq-v04-q09', 'knowledge', 'medium', '**TD-MPC2**（Hansen et al., ICLR 2024）的隐式世界模型（implicit world model）是 **decoder-free** 设计。',
   '**TD-MPC2**（Hansen et al., ICLR 2024）的隐式世界模型（implicit world model）是 **decoder-free** 设计：', '**TD-MPC2**（Hansen et al., ICLR 2024）的隐式世界模型（implicit world model）是 **decoder-free** 设计：

| | DreamerV3 | TD-MPC2 |
|---|---|---|
| 世界模型类型 | 显式（explicit）：有解码器，重建观测 | 隐式（implicit）：无解码器，不还原观测 |
| 训练信号 | 重建损失 + KL + reward 预测 | TD 误差 + reward + consistency loss |
| 规划方式 | actor-critic 想象（BPTT） | MPC + CEM/MPPI（latent 空间规划） |
| 适用规模 | 较大模型（200M+） | 较小模型（1M~317M，多任务单权重） |
| 任务多样性 | 跨 7 大 domain | 104 任务，单套超参，包含操作和运动 |

**隐式的好处**：不需要重建观测，节省容量；用 SimNorm 归一化 latent，防止 latent 坍缩；decoder-free 使模型更轻量。',
   null, null, '["TD-MPC2 的\"world model\"不学重建，所以无法\"看\"世界模型的想象", "它的 latent 只对 value/reward 预测有意义，不是可解释的图像 latent。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Dreamer 系列进化","qid":"Q09","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000241', '世界模型用于 planning（MCTS/CEM/MPPI）的思路？MuZero 怎么做 planning？', 'eaq-v04-q10', 'knowledge', 'medium', '**世界模型 + Planning**：在 latent 空间中搜索最优动作序列，而无需真实执行。',
   '**世界模型 + Planning**：在 latent 空间中搜索最优动作序列，而无需真实执行：', '**世界模型 + Planning**：在 latent 空间中搜索最优动作序列，而无需真实执行：

- **CEM**：采样动作序列，前向展开评估价值，选 top-k 迭代更新分布（TD-MPC 采用）
- **MPPI**：重要性采样加权多条 rollout，适合连续控制
- **MCTS**（MuZero）：树搜索 + 展开/模拟/回传，适合离散任务

**MuZero 的 Planning**：① representation（obs → latent）② dynamics（latent + action → next latent + reward）③ prediction（latent → policy + value）。MCTS 在这三个网络构成的虚拟树中搜索，policy/value 指导方向，无需真实环境交互。',
   null, null, '["CEM/MPPI 是无梯度采样优化", "MCTS 开销大（每步数百次前向），在连续控制实时场景中通常太慢，不要认为 MuZero 也适合机器人控制。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Dreamer 系列进化","qid":"Q10","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000242', 'Sim2Real 中的 reality gap 主要来源有哪些？如何系统性解决？', 'eaq-v04-q11', 'knowledge', 'easy', '**Reality gap 的主要来源**。',
   '**Reality gap 的主要来源**：', '**Reality gap 的主要来源**：

1. **物理参数不精确**：摩擦系数、质量惯性张量、关节阻尼——仿真默认值与真机不符
2. **接触/碰撞模型误差**：真实接触面非点接触，仿真的 point-contact / spring-damper 模型过于简化
3. **执行器（actuator）模型误差**：电机动态、传动比、延迟、反向间隙（backlash）在仿真中通常被忽略
4. **传感器噪声差异**：IMU 漂移、相机曝光变化、深度传感器噪声模式
5. **视觉外观差异**：光照、纹理、材质反射率不同（渲染真实感不足）

**系统解决策略**：
- **物理 gap** → Domain Randomization（DR）或 System Identification
- **执行器 gap** → actuator delay 建模 + torque/PD 控制 matching
- **视觉 gap** → Photo-realistic rendering + 视觉 DR（颜色/纹理/光照随机化）
- **自适应** → Teacher-Student + online adaptation（RMA）',
   null, null, '["并非所有 gap 都能靠 DR 覆盖", "contact model 误差是\"硬性\"误差，DR 只是用分布包住，无法从根本消除接触力学的模拟误差。"]'::jsonb, null, 3, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Sim2Real 基础","qid":"Q11","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000243', 'Automatic Domain Randomization（ADR）是什么？比手动 DR 好在哪里？', 'eaq-v04-q13', 'knowledge', 'medium', '**ADR**（Akkaya et al., 2019 OpenAI，Rubik''s Cube 论文 arXiv 1910.07113）：自动调节 DR 参数分布范围的方法。',
   '**ADR**（Akkaya et al., 2019 OpenAI，Rubik''s Cube 论文 arXiv 1910.07113）：自动调节 DR 参数分布范围的方法。核心机制：', '**ADR**（Akkaya et al., 2019 OpenAI，Rubik''s Cube 论文 arXiv 1910.07113）：自动调节 DR 参数分布范围的方法。核心机制：

1. 每个随机化参数都有一个当前分布（如摩擦 [0.5, 2.0]）
2. 根据策略在**边界条件**（分布上/下端采样）下的成功率动态调整：若成功率 > 上阈值，扩宽分布范围；若 < 下阈值，收窄
3. 分布自动渐进扩展，只要策略能跟上就持续变难

**比手动 DR 好的地方**：
- 无需逐参数手调范围，省去繁琐 hyperparameter tuning
- 自适应课程：跟策略学习进度对齐，不会"一步跳太难"导致训练崩溃
- 可扩展到几十个随机化维度，手动调 50+ 参数不现实

**局限**：ADR 假设成功率是好的反馈信号，稀疏奖励任务中难以判断"是否在进步"；另外计算开销比固定分布 DR 大。',
   null, null, '["ADR 不是一种新的随机化类型，而是一种**自动调整 DR 参数范围**的调度策略。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Sim2Real 基础","qid":"Q13","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000244', 'Domain Adaptation 和 Domain Randomization 是什么关系？Sim2Real 中各自的应用场景？', 'eaq-v04-q14', 'knowledge', 'medium', '| | Domain Randomization（DR） | Domain Adaptation（DA） |',
   '| | Domain Randomization（DR） | Domain Adaptation（DA） |
|---|---|---|
| 时机 | 训练期间 | 测试时（有少量真实数据） |
| 思路 | 扩大 source domain 覆盖 target | 对齐 source 和 target 的分布 |
| 真实数据需求 | 不需要真实数据 | 需要少量真实数据（labeled or not） |
| 典型方法 | 随机化仿真参数 | DANN、MMD、GAN-based alignment |
| 部署场景 | zero-shot 迁移 | 有一定 real world 收集预算 |', '| | Domain Randomization（DR） | Domain Adaptation（DA） |
|---|---|---|
| 时机 | 训练期间 | 测试时（有少量真实数据） |
| 思路 | 扩大 source domain 覆盖 target | 对齐 source 和 target 的分布 |
| 真实数据需求 | 不需要真实数据 | 需要少量真实数据（labeled or not） |
| 典型方法 | 随机化仿真参数 | DANN、MMD、GAN-based alignment |
| 部署场景 | zero-shot 迁移 | 有一定 real world 收集预算 |

**具身中的组合使用**：
- 先 DR 训练 → zero-shot 迁移（效果 60-80%）
- 再用少量真实数据 fine-tune（DA）→ 效果提升到 90%+
- 或用 sim-to-real 感知模块（视觉特征对齐）+ DR 策略组合',
   null, null, '["DA 不是\"比 DR 更好的替代\"，两者互补", "没有真实数据时 DR 是唯一选择，有少量真实数据时 DA 是高效的补充。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Sim2Real 基础","qid":"Q14","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000245', 'Digital Twin 在 sim2real 中的作用？与传统 DR 方法有什么区别？', 'eaq-v04-q15', 'knowledge', 'easy', '**Digital Twin（数字孪生）**：对特定真实场景/机器人进行精确建模（几何、动力学、外观），使仿真尽量还原真实个体，目标是"仿真精度高到不需要大范围 DR"。',
   '**Digital Twin（数字孪生）**：对特定真实场景/机器人进行精确建模（几何、动力学、外观），使仿真尽量还原真实个体，目标是"仿真精度高到不需要大范围 DR"。', '**Digital Twin（数字孪生）**：对特定真实场景/机器人进行精确建模（几何、动力学、外观），使仿真尽量还原真实个体，目标是"仿真精度高到不需要大范围 DR"。

**和 DR 的对比**：

| | Digital Twin | Domain Randomization |
|---|---|---|
| 策略 | "精确仿真" → 减小 gap | "宽泛仿真" → 覆盖 gap |
| 构建成本 | 高（3D 扫描、系统辨识） | 低（随机化参数设范围） |
| 泛化性 | 绑定特定环境 | 泛化到更多场景 |
| 适合场景 | 工厂固定工位、已知机器人型号 | 多样化部署场景 |

**前沿融合**：用 3D Gaussian Splatting 快速构建数字孪生（分钟级），与 RL 训练流程结合；ManiSkill3 的数字孪生 RL 接口仍在开发中（WIP），是研究前沿方向。',
   null, null, '["Digital Twin 不是\"替代 DR\"的方案，在动态场景（人群、随机光照）中精确孪生不可能，仍需 DR 补充。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Sim2Real 基础","qid":"Q15","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000246', '仿真到真机的"zero-shot transfer"和"fine-tuning transfer"有何区别？哪种更常用？', 'eaq-v04-q16', 'knowledge', 'easy', '**Zero-shot transfer**：仿真训练后**直接部署**到真机，无需真实数据；',
   '- **Zero-shot transfer**：仿真训练后**直接部署**到真机，无需真实数据；依赖 DR 或精确仿真覆盖真实分布。典型：ANYmal 四足行走（Lee 2020）、OpenAI dexterous hand（Andrychowicz 2020）。
- **Fine-tuning transfer**：仿真训练后用少量真实数据 fine-tune；真实环境数据几十到几千条即可显著提升成功率。典型：机械臂精细操作（夹夹手、拧瓶盖）。', '- **Zero-shot transfer**：仿真训练后**直接部署**到真机，无需真实数据；依赖 DR 或精确仿真覆盖真实分布。典型：ANYmal 四足行走（Lee 2020）、OpenAI dexterous hand（Andrychowicz 2020）。
- **Fine-tuning transfer**：仿真训练后用少量真实数据 fine-tune；真实环境数据几十到几千条即可显著提升成功率。典型：机械臂精细操作（夹夹手、拧瓶盖）。

**哪种更常用**：
- 运动控制（四足/双足步态）→ **zero-shot 更主流**，因为策略对精确接触力不敏感，DR 覆盖足够
- 灵巧操作（抓取/插针/翻转）→ **fine-tuning 更必要**，接触力精度要求高，仿真永远有残差

**实务建议**：先尝试 zero-shot，若成功率 < 70% 再收集少量真实数据 fine-tune；节省数据采集成本。',
   null, null, '["fine-tuning 不等于从头在真机上训练（那是 online RL，成本高）", "fine-tuning 的基础是仿真预训练，只需少量真实 step 微调。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Sim2Real 基础","qid":"Q16","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000247', 'Teacher-Student 框架在 sim2real 中怎么用？privileged observation 是什么？', 'eaq-v04-q17', 'knowledge', 'medium', '**Teacher-Student 框架**：仿真中训练两个策略。',
   '**Teacher-Student 框架**：仿真中训练两个策略：
- **Teacher**（教师策略）：可访问仿真中的**特权观测**（privileged observations）——真实机器人无法获取的信息，如精确地形高度图、摩擦系数、外力值等
- **Student**（学生策略）：只能访问真机上的传感器数据（IMU、关节角、相机图像）', '**Teacher-Student 框架**：仿真中训练两个策略：
- **Teacher**（教师策略）：可访问仿真中的**特权观测**（privileged observations）——真实机器人无法获取的信息，如精确地形高度图、摩擦系数、外力值等
- **Student**（学生策略）：只能访问真机上的传感器数据（IMU、关节角、相机图像）

训练流程：
1. 仿真中训练 Teacher 达到高性能（有特权信息，容易）
2. Student 用 DAgger / BC 蒸馏 Teacher：给定相同状态，让 Student 模仿 Teacher 的动作
3. Student 部署到真机（无需特权信息）

**为什么有效**：Teacher 利用特权信息找到了好策略，Student 蒸馏保留了策略质量，真机只需要 Student 可获取的传感器——打通了"仿真特权"和"真机局限"之间的桥梁。',
   null, null, '["Teacher-Student 不是 knowledge distillation 的一般版本", "特权观测是仿真专属的，不是\"从大模型蒸馏小模型\"", "若 Student 观测与 Teacher 动作之间信息量差距太大，蒸馏也会失败。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Teacher-Student / 自适应方法","qid":"Q17","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000248', 'RMA（Rapid Motor Adaptation）的核心思路是什么？为什么比纯 DR 更鲁棒？', 'eaq-v04-q18', 'knowledge', 'medium', '**RMA**（Kumar et al., RSS 2021）= Teacher-Student + 在线自适应模块，两阶段训练。',
   '**RMA**（Kumar et al., RSS 2021）= Teacher-Student + 在线自适应模块，两阶段训练：', '**RMA**（Kumar et al., RSS 2021）= Teacher-Student + 在线自适应模块，两阶段训练：

- **Phase 1（仿真）**：训练 base policy（输入 proprio + extrinsics 向量 $e$，$e$ 编码地形/摩擦等特权信息）+ extrinsics encoder
- **Phase 2**：冻结 base policy，训 adaptation module：用历史本体感觉序列（IMU/关节角）预测 $\hat{e} \approx e$

**真机部署**：adaptation module 实时估计 $\hat{e}$，base policy 用 $\hat{e}$ 适应未知环境，无需外感传感器。

**比纯 DR 更鲁棒**：DR 是"被动覆盖"，策略不知当前处于哪种环境；RMA 是"主动适应"，根据历史本体感觉动态估计当前参数，策略能"感知"到地形变化。',
   null, null, '["adaptation module 只用 IMU/关节角（真机都有），不依赖外感", "估计误差 $\\hat{e} \\ne e$ 由 module 的鲁棒性吸收，不要求完美匹配。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Teacher-Student / 自适应方法","qid":"Q18","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000249', 'curriculum learning 在 sim2real 中怎么用？常见 curriculum 设计策略有哪些？', 'eaq-v04-q19', 'knowledge', 'medium', '**Curriculum Learning（课程学习）**：从简单任务/环境逐步加难，让策略稳定收敛，避免直接在"全难度"下训练失败。',
   '**Curriculum Learning（课程学习）**：从简单任务/环境逐步加难，让策略稳定收敛，避免直接在"全难度"下训练失败。', '**Curriculum Learning（课程学习）**：从简单任务/环境逐步加难，让策略稳定收敛，避免直接在"全难度"下训练失败。

**在 Sim2Real 中的常见 Curriculum 策略**：

1. **地形 Curriculum**（运动控制）：从平地开始 → 加坡度 → 加台阶 → 加随机不规则地形。Isaac Lab 标配地形课程。
2. **随机化范围 Curriculum**（DR Curriculum）：DR 范围从窄到宽逐步扩展；ADR 本质上是自动化的 DR curriculum
3. **任务难度 Curriculum**（操作）：从接近成功位置开始 → 逐步增大初始距离；从固定目标 → 随机目标位置
4. **奖励塑造 Curriculum**（dense → sparse）：初期用稠密奖励引导，后期切换稀疏奖励增强泛化

**何时用**：策略在完整难度下无法启动时（cold start）；或 DR 范围过大导致训练崩溃时。',
   null, null, '["Curriculum 不一定总能提升最终性能——有时直接暴力训 full random 效果一样甚至更好（任务简单时）", "Curriculum 主要解决\"训练启动难\"问题，不是性能上界问题。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Teacher-Student / 自适应方法","qid":"Q19","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000250', '什么是 system identification（系统辨识）？如何与 DR 结合？', 'eaq-v04-q20', 'knowledge', 'medium', '**System Identification（系统辨识，SysID）**：用真实机器人数据（如施加已知力矩后测量关节角度轨迹）估计物理模型参数（质量、惯量、摩擦、阻尼），使仿真参数尽量接近真实值。',
   '**System Identification（系统辨识，SysID）**：用真实机器人数据（如施加已知力矩后测量关节角度轨迹）估计物理模型参数（质量、惯量、摩擦、阻尼），使仿真参数尽量接近真实值。', '**System Identification（系统辨识，SysID）**：用真实机器人数据（如施加已知力矩后测量关节角度轨迹）估计物理模型参数（质量、惯量、摩擦、阻尼），使仿真参数尽量接近真实值。

**与 DR 的结合（标准实践）**：
1. 用 SysID 找到"最优估计"参数 $\theta^*$（均值）
2. 以 $\theta^*$ 为中心，在 ±uncertainty 范围内做 DR
3. 这样 DR 的覆盖是**有根据的分布**，不是盲猜范围

**好处**：DR 范围精准，不会过宽（浪费训练容量）也不会过窄（漏掉真实参数）。

**常见 SysID 方法**：最小二乘辨识（线性系统）/ 贝叶斯辨识（给出后验分布，直接指导 DR 范围）/ RMA 风格的在线辨识。',
   null, null, '["SysID 是\"一次性标定\"，真机磨损/环境变化后需要重新辨识", "RMA 等在线自适应方法是 SysID 的动态替代，无需离线标定步骤。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"Teacher-Student / 自适应方法","qid":"Q20","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000251', 'Isaac Gym 和 Isaac Lab 的关系？与 MuJoCo 在仿真精度/速度上的对比？', 'eaq-v04-q21', 'knowledge', 'easy', '**Isaac Gym**（2021 NVIDIA）：第一款 GPU 加速 RL 仿真器，基于 PhysX，支持数千并行 env，已于 2024 年**正式 deprecated**，推荐迁移到 Isaac Lab',
   '- **Isaac Gym**（2021 NVIDIA）：第一款 GPU 加速 RL 仿真器，基于 PhysX，支持数千并行 env，已于 2024 年**正式 deprecated**，推荐迁移到 Isaac Lab
- **Isaac Lab**（2024 NVIDIA）：Isaac Gym 的官方继任，基于 Isaac Sim（Omniverse 平台）+ PhysX，提供模块化 RL 环境接口，支持 USD 场景格式，功能更完整（sensor 插件、物理材质 API）', '- **Isaac Gym**（2021 NVIDIA）：第一款 GPU 加速 RL 仿真器，基于 PhysX，支持数千并行 env，已于 2024 年**正式 deprecated**，推荐迁移到 Isaac Lab
- **Isaac Lab**（2024 NVIDIA）：Isaac Gym 的官方继任，基于 Isaac Sim（Omniverse 平台）+ PhysX，提供模块化 RL 环境接口，支持 USD 场景格式，功能更完整（sensor 插件、物理材质 API）

| | Isaac Lab（PhysX） | MuJoCo（Newton/CG/PGS） |
|---|---|---|
| 速度（GPU 并行） | 极快（100K+ FPS，千级 env） | 较快（MJX GPU 后端，但单核慢） |
| 接触精度 | PhysX：速度优先，精度中等 | Newton/CG/PGS：接触精细，适合精细操作 |
| 开源 | Isaac Lab 开源，Isaac Sim 闭源依赖 | 完全开源 |
| 常用场景 | 大规模 RL 训练、四足/人形步态 | 控制研究、操作任务、学术基准 |',
   null, null, '["Isaac Gym 已 deprecated，不要在新项目中使用", "Isaac Lab 需要 Isaac Sim 作为底层，而 Isaac Sim 是 NVIDIA 闭源商业软件（学术免费）。"]'::jsonb, null, 3, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"仿真器选型与工程","qid":"Q21","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000252', 'MuJoCo、PyBullet、SAPIEN、Genesis 的特点对比？各自适合什么场景？', 'eaq-v04-q22', 'knowledge', 'easy', '| 仿真器 | 优势 | 局限 | 适合场景 |',
   '| 仿真器 | 优势 | 局限 | 适合场景 |
|---|---|---|---|
| **MuJoCo** | 接触精细（Newton/CG/PGS 求解器），学术标配，DMControl 基准 | 慢（CPU 主）；MJX 是 GPU 后端但较新 | 控制研究、精细操作、学术对比 |
| **PyBullet** | 开源免费，易上手，社区大 | 接触精度差，性能低，已逐渐式微 | 快速原型，教学 |
| **SAPIEN** | 关节/铰链精确，articulated 对象建模好 | 并行性有限，生态较小 | 多关节操作（抽屉、门）；ManiSkill 基础 |
| **Genesis** | 号称最快（43M FPS），多物理后端 | 成熟度低，纯物理比 ManiSkill 慢 3-10x（基准测试） | 超大规模 RL 探索，数据生成 |', '| 仿真器 | 优势 | 局限 | 适合场景 |
|---|---|---|---|
| **MuJoCo** | 接触精细（Newton/CG/PGS 求解器），学术标配，DMControl 基准 | 慢（CPU 主）；MJX 是 GPU 后端但较新 | 控制研究、精细操作、学术对比 |
| **PyBullet** | 开源免费，易上手，社区大 | 接触精度差，性能低，已逐渐式微 | 快速原型，教学 |
| **SAPIEN** | 关节/铰链精确，articulated 对象建模好 | 并行性有限，生态较小 | 多关节操作（抽屉、门）；ManiSkill 基础 |
| **Genesis** | 号称最快（43M FPS），多物理后端 | 成熟度低，纯物理比 ManiSkill 慢 3-10x（基准测试） | 超大规模 RL 探索，数据生成 |

**MJX（MuJoCo with JAX）**：MuJoCo 的 GPU 并行后端，2023 发布，接触精度保持，支持 JAX 自动微分，逐步成为精细操作研究的 GPU 方案。',
   null, null, '["Genesis 宣称\"最快\"基于特定场景", "在物理仿真精度可比的条件下，ManiSkill3 的 GPU 并行效率（3.5GB vs 14.1GB，128 env）比 Isaac Lab 更高效。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"仿真器选型与工程","qid":"Q22","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000253', 'GPU 并行仿真（tensorized envs）的原理和关键优势？', 'eaq-v04-q23', 'knowledge', 'medium', '**GPU 并行仿真**：将 N 个独立仿真环境的物理状态张量化，通过 GPU 的 SIMD（单指令多数据）并行架构同时计算 N 个环境的物理步。',
   '**GPU 并行仿真**：将 N 个独立仿真环境的物理状态张量化，通过 GPU 的 SIMD（单指令多数据）并行架构同时计算 N 个环境的物理步。', '**GPU 并行仿真**：将 N 个独立仿真环境的物理状态张量化，通过 GPU 的 SIMD（单指令多数据）并行架构同时计算 N 个环境的物理步。

**核心原理**：
- 所有 env 的物理状态（关节角、速度、接触力）打包为 [N, D] 的 GPU 张量
- 物理引擎（PhysX / JAX MuJoCo）在 GPU 上一次前向计算 N 个 env
- RL 的 policy 网络也在 GPU 上批量推断，无 CPU-GPU 数据传输瓶颈

**关键优势**：
- 吞吐量：Isaac Lab 单卡 4090 可跑 4096 个 ANYmal env，效果相当于 4096 块 CPU 核
- 数据去相关：并行 env 采样多样轨迹，减少 on-policy 算法的 variance
- 训练加速：PPO 在 4096 env 下 wall-clock 时间比 1 env 快近 100×

**注意**：GPU env 数量不能无限增大——内存受限（128 env 约 3.5 GB GPU 内存，ManiSkill3 测试）；N 太大时 batch too large 导致策略更新步过大。',
   null, null, '["GPU 并行仿真不等于仿真精度更高，速度和精度是不同维度", "PhysX 为了速度做了精度妥协，精细接触任务仍需 MuJoCo。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"仿真器选型与工程","qid":"Q23","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000254', 'URDF / MJCF / USD 三种机器人描述格式的区别？各仿真器对它们的支持情况？', 'eaq-v04-q24', 'knowledge', 'easy', '| 格式 | 来源 | 核心特点 | 适用场景 |',
   '| 格式 | 来源 | 核心特点 | 适用场景 |
|---|---|---|---|
| **URDF** | ROS | XML 树形链结构；不支持 loop closure；无物理材质细节 | ROS / PyBullet / 快速原型 |
| **MJCF** | MuJoCo | 功能丰富（接触参数、肌腱、equality 约束），支持闭链 | MuJoCo 精细仿真、控制研究 |
| **USD** | Pixar / NVIDIA | 场景层级管理，支持传感器/光照/动态物体，工业级扩展 | Isaac Sim / Isaac Lab / 大规模渲染 |', '| 格式 | 来源 | 核心特点 | 适用场景 |
|---|---|---|---|
| **URDF** | ROS | XML 树形链结构；不支持 loop closure；无物理材质细节 | ROS / PyBullet / 快速原型 |
| **MJCF** | MuJoCo | 功能丰富（接触参数、肌腱、equality 约束），支持闭链 | MuJoCo 精细仿真、控制研究 |
| **USD** | Pixar / NVIDIA | 场景层级管理，支持传感器/光照/动态物体，工业级扩展 | Isaac Sim / Isaac Lab / 大规模渲染 |

**转换**：URDF → USD（Isaac Lab 官方工具）；URDF → MJCF（dm_control 工具）；信息量不同，转换有损失。

**选型**：学术研究 → URDF；精细操作 → MJCF；大规模 GPU 训练/渲染 → USD。',
   null, null, '["URDF 不支持闭链（loop closure），平行四杆等机构必须用 MJCF 的 equality 约束", "直接用 URDF 会出现关节约束错误。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"仿真器选型与工程","qid":"Q24","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000255', '仿真器的接触/碰撞模型（contact model）对 sim2real 的影响？为什么抓取任务难做？', 'eaq-v04-q25', 'knowledge', 'medium', '**接触模型的核心问题**：真实接触是面接触（有面积、有变形、有摩擦锥），但主流仿真器用点接触近似（point contact）+ 弹簧阻尼模型（spring-damper），引入两类误差。',
   '**接触模型的核心问题**：真实接触是面接触（有面积、有变形、有摩擦锥），但主流仿真器用点接触近似（point contact）+ 弹簧阻尼模型（spring-damper），引入两类误差：', '**接触模型的核心问题**：真实接触是面接触（有面积、有变形、有摩擦锥），但主流仿真器用点接触近似（point contact）+ 弹簧阻尼模型（spring-damper），引入两类误差：

1. **接触力方向误差**：点接触无法模拟接触面的力矩分布（如抓取时手指包裹物体的摩擦力）
2. **接触刚度误差**：仿真的"软体接触"系数很难与真实物体材质匹配

**为什么抓取任务特别难**：
- 抓取稳定性取决于接触点分布和摩擦系数，仿真误差直接影响是否抓住
- 物体几何细节（倒角、表面粗糙度）在 CAD 模型中往往简化，真实接触面与仿真不同
- 插针（peg-in-hole）等精密操作误差仅 1mm，仿真接触力方向偏差就可能导致失败

**缓解策略**：使用 MuJoCo（Newton/CG/PGS 精细接触）+ 合适摩擦参数 / 收集少量真实数据 fine-tune / 用力传感器反馈替代精确接触建模。',
   null, null, '["PhysX（Isaac Lab）速度快但接触精度低于 MuJoCo，精细抓取研究应优先选 MuJoCo", "不要因为 Isaac Lab 并行速度快就用它做高精度接触任务。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"仿真器选型与工程","qid":"Q25","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000256', 'ManiSkill 和 Isaac Lab 的 GPU 并行能力对比？哪个适合操作任务训练？', 'eaq-v04-q26', 'knowledge', 'easy', '| | ManiSkill3（SAPIEN/Vulkan） | Isaac Lab（Isaac Sim/PhysX） |',
   '| | ManiSkill3（SAPIEN/Vulkan） | Isaac Lab（Isaac Sim/PhysX） |
|---|---|---|
| 物理引擎 | SAPIEN（基于 PhysX 5 + Vulkan） | PhysX（NVIDIA 官方） |
| 128 env GPU 内存 | **3.5 GB** | 14.1 GB |
| 并行渲染 | 原生支持，速度极快 | 支持但资源占用高 |
| 操作任务丰富度 | 12+ 类操作域，human-artist 设计场景 | 操作任务少，步态类为主 |
| 学习框架集成 | RL + IL，直接支持视觉 obs RL | RL 为主 |
| 开源程度 | 完全开源 | Isaac Lab 开源，依赖闭源 Isaac Sim |', '| | ManiSkill3（SAPIEN/Vulkan） | Isaac Lab（Isaac Sim/PhysX） |
|---|---|---|
| 物理引擎 | SAPIEN（基于 PhysX 5 + Vulkan） | PhysX（NVIDIA 官方） |
| 128 env GPU 内存 | **3.5 GB** | 14.1 GB |
| 并行渲染 | 原生支持，速度极快 | 支持但资源占用高 |
| 操作任务丰富度 | 12+ 类操作域，human-artist 设计场景 | 操作任务少，步态类为主 |
| 学习框架集成 | RL + IL，直接支持视觉 obs RL | RL 为主 |
| 开源程度 | 完全开源 | Isaac Lab 开源，依赖闭源 Isaac Sim |

**结论**：
- 操作任务（抓取/灵巧操作/移动操作）→ **ManiSkill3 更合适**（内存效率高、操作任务丰富、可从视觉训练）
- 步态/人形运动 → **Isaac Lab 更合适**（四足/双足步态生态更完整，官方 ANYmal/G1 模板）',
   null, null, '["Genesis 号称最快，但在物理精度可比的基准下，ManiSkill3 GPU 内存效率更高", "Genesis 2024 年仍在成熟中，生产环境慎用。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"仿真器选型与工程","qid":"Q26","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000257', '人形机器人 sim2real 面临哪些特有挑战？和四足机器人 sim2real 有何不同？', 'eaq-v04-q27', 'knowledge', 'medium', '两者都面对接触、执行器、时延和状态估计误差。',
   '两者都面对接触、执行器、时延和状态估计误差。人形常多出双足平衡、上肢负载与全身协调，摔倒风险和接触模式也更复杂；但自由度、稳定裕度及控制量取决于具体本体和步态。先校准执行器与时序，再结合参数辨识、域随机化、特权训练/学生蒸馏和真机分阶段测试。', '两者都面对接触、执行器、时延和状态估计误差。人形常多出双足平衡、上肢负载与全身协调，摔倒风险和接触模式也更复杂；但自由度、稳定裕度及控制量取决于具体本体和步态。先校准执行器与时序，再结合参数辨识、域随机化、特权训练/学生蒸馏和真机分阶段测试。',
   null, null, '["不能用固定自由度、接触点数或“误差1厘米就摔倒”概括所有平台", "四足腾空和动态步态也有显著平衡挑战。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"具身 Sim2Real 实战","qid":"Q27","freq_label":"🔥×4","provenance":"核验：[VIRAL 原论文](https://arxiv.org/abs/2511.15200)、[快速腿足学习原论文](https://proceedings.mlr.press/v164/rudin22a/rudin22a.pdf)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000258', '操作任务的 sim2real（抓取/插针/双臂）和运动控制的 sim2real 有何核心区别？', 'eaq-v04-q28', 'knowledge', 'medium', '两类任务都依赖动力学、接触、感知与执行器建模，但权重随任务变化。',
   '两类任务都依赖动力学、接触、感知与执行器建模，但权重随任务变化。行走侧重平衡、足地接触和扰动恢复；抓取、插接等常更敏感于物体几何、摩擦、遮挡和接触状态。分别检查视觉与动力学 gap，用标定、随机化、闭环感知/力控及必要的真机数据验证修正。', '两类任务都依赖动力学、接触、感知与执行器建模，但权重随任务变化。行走侧重平衡、足地接触和扰动恢复；抓取、插接等常更敏感于物体几何、摩擦、遮挡和接触状态。分别检查视觉与动力学 gap，用标定、随机化、闭环感知/力控及必要的真机数据验证修正。',
   null, null, '["运动控制的 gap 并未被域随机化普遍解决，操作也并非总要真机微调", "是否 zero-shot 只能依具体任务与保留测试结果判断。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"具身 Sim2Real 实战","qid":"Q28","freq_label":"🔥×3","provenance":"核验：[VIRAL 原论文](https://arxiv.org/abs/2511.15200)、[动力学随机化原论文](https://arxiv.org/abs/1710.06537)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000259', 'Genie / 视频生成世界模型和具身智能的关联？它能否直接作为机器人 policy？', 'eaq-v04-q29', 'knowledge', 'medium', '视频世界模型预测动作或交互条件下的后续观测，可作为训练环境、想象 rollout 或规划的组成部分。',
   '视频世界模型预测动作或交互条件下的后续观测，可作为训练环境、想象 rollout 或规划的组成部分。Genie 3 官方展示的是可交互生成环境，视觉帧率不是机器人控制频率。成为机器人策略仍需定义观测、目标、动作接口和决策规则，验证物理一致性、时延与迁移。', '视频世界模型预测动作或交互条件下的后续观测，可作为训练环境、想象 rollout 或规划的组成部分。Genie 3 官方展示的是可交互生成环境，视觉帧率不是机器人控制频率。成为机器人策略仍需定义观测、目标、动作接口和决策规则，验证物理一致性、时延与迁移。',
   null, null, '["世界模型与策略是不同角色，但可以联合构建", "不能由“能生成视频”推出能控关节，也不能断言所有视频模型永远不能参与策略。π0 的动作专家本身不是视频世界模型。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"具身 Sim2Real 实战","qid":"Q29","freq_label":"🔥×3","provenance":"核验：[Genie 3 官方说明](https://deepmind.google/blog/genie-3-a-new-frontier-for-world-models/)、[DreamerV3 原论文](https://arxiv.org/abs/2301.04104)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000260', 'JEPA（Joint-Embedding Predictive Architecture）和 Dreamer 世界模型的差异？', 'eaq-v04-q30', 'knowledge', 'hard', 'JEPA 是预测目标表征的架构原则。',
   'JEPA 是预测目标表征的架构原则。V-JEPA 2 先从无动作视频学习特征预测；其动作条件版本 V-JEPA 2-AC 再利用机器人交互数据学习动作对潜在状态的影响，可用于目标导向规划。Dreamer 则从带动作与奖励的交互数据学习潜在动力学，通过想象轨迹训练行为策略；常见 RSSM 配有观测解码与奖励预测。', 'JEPA 是预测目标表征的架构原则。V-JEPA 2 先从无动作视频学习特征预测；其动作条件版本 V-JEPA 2-AC 再利用机器人交互数据学习动作对潜在状态的影响，可用于目标导向规划。Dreamer 则从带动作与奖励的交互数据学习潜在动力学，通过想象轨迹训练行为策略；常见 RSSM 配有观测解码与奖励预测。',
   null, null, '["应区分无动作预训练与动作条件后训练", "不能把所有 JEPA 都写成“只能间接控制”，也不能把 latent planning 与 Dreamer 的想象 actor 训练混为一谈。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"具身 Sim2Real 实战","qid":"Q30","freq_label":"🔥×3","provenance":"核验：[V-JEPA 2 原论文](https://arxiv.org/abs/2506.09985)、[DreamerV3 原论文](https://arxiv.org/abs/2301.04104)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000261', 'TD-MPC 的 temporal difference + MPC 是如何结合的？和纯 MPC 有何区别？（**破例**：TD-MPC2 ICLR 2024 顶会，面试中正在新增）', 'eaq-v04-q31', 'knowledge', 'hard', '**TD-MPC**（Hansen et al., 2022；',
   '**TD-MPC**（Hansen et al., 2022；TD-MPC2 ICLR 2024）结合 TD 学 value 和 MPC 做规划：', '**TD-MPC**（Hansen et al., 2022；TD-MPC2 ICLR 2024）结合 TD 学 value 和 MPC 做规划：

**TD 部分**：学 latent 动力学 $z_{t+1}=f(z_t,a_t)$、Q 函数（TD 误差监督）、reward 预测；latent 用 SimNorm 防坍缩。

**MPC 部分**：每步用 CEM 在 latent 空间搜索 H 步最优序列，序列末端价值用学到的 Q 评估（解决纯 MPC 只看 H 步的近视问题）；选第一步执行，下步重规划。

**与纯 MPC 的区别**：纯 MPC 依赖精确物理模型、无 value function；TD-MPC 用 TD 提供无限 horizon 的价值估计，精度和泛化性更强。',
   null, null, '["TD-MPC2 是 decoder-free（不重建观测），latent 只对 TD/reward 预测有意义，不是可视化状态", "和 Dreamer 的重建式 latent 本质不同。"]'::jsonb, null, 8, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"04","volume_title":"卷四 · 世界模型 / Sim2Real","section":"具身 Sim2Real 实战","qid":"Q31","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000262', '感知-规划-控制三层架构各层的实时性要求是什么？为什么不能统一成一个频率？', 'eaq-v05-q01', 'knowledge', 'easy', '频率由被控对象带宽、传感器更新、计算延迟和允许的状态陈旧度共同决定。',
   '频率由被控对象带宽、传感器更新、计算延迟和允许的状态陈旧度共同决定。电机驱动或关节伺服通常比视觉感知和任务规划更快，但具体数值依硬件与接口确定。常用异步分层：感知输出带时间戳的状态，策略输出目标或动作块，实时控制器在自己的周期跟踪，并处理超时和约束。', '频率由被控对象带宽、传感器更新、计算延迟和允许的状态陈旧度共同决定。电机驱动或关节伺服通常比视觉感知和任务规划更快，但具体数值依硬件与接口确定。常用异步分层：感知输出带时间戳的状态，策略输出目标或动作块，实时控制器在自己的周期跟踪，并处理超时和约束。',
   null, null, '["动作执行频率、策略调用频率和底层伺服频率不能混为一谈", "VLA 可以输出连续动作目标，不只输出任务指令。"]'::jsonb, null, 3, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"感知-规划-控制系统架构","qid":"Q01","freq_label":"🔥×7","provenance":"核验：[ROS 2 实时编程说明](https://design.ros2.org/articles/realtime_background.html)、[RTC 作者说明](https://www.pi.website/research/real_time_chunking)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000263', '机器人生产系统如何评估 ROS 2 和自研中间件？DDS 与实时性有哪些边界？', 'eaq-v05-q02', 'knowledge', 'medium', 'ROS 2 提供通信、工具与组件生态；',
   'ROS 2 提供通信、工具与组件生态；常见 DDS 实现支持发现和 QoS，其他通信实现也须按发行版核对。生产是否采用取决于最坏延迟、抖动、可靠性、部署约束和可维护性。实时表现是内核、调度、执行器、内存、驱动与通信的系统属性，可将关键控制路径与非实时感知/服务隔离，再测目标周期下的时限违约率。', 'ROS 2 提供通信、工具与组件生态；常见 DDS 实现支持发现和 QoS，其他通信实现也须按发行版核对。生产是否采用取决于最坏延迟、抖动、可靠性、部署约束和可维护性。实时表现是内核、调度、执行器、内存、驱动与通信的系统属性，可将关键控制路径与非实时感知/服务隔离，再测目标周期下的时限违约率。',
   null, null, '["不能断言“大公司不用 ROS 2”或给 DDS 固定微秒延迟", "PREEMPT_RT 不是单独的保证，EtherCAT 也不是替代操作系统的实时调度器。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"感知-规划-控制系统架构","qid":"Q02","freq_label":"🔥×5","provenance":"核验：[ROS 2 实时编程说明](https://design.ros2.org/articles/realtime_background.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000264', '状态机（FSM）和行为树（BT）在机器人任务编排中的区别？各有什么适用场景？', 'eaq-v05-q03', 'knowledge', 'medium', 'FSM 用状态与转移表达流程，少量明确状态时容易实现与验证；',
   'FSM 用状态与转移表达流程，少量明确状态时容易实现与验证；行为树用条件、动作和控制节点组合任务，便于复用、响应条件变化和组织回退。选型取决于流程复杂度、中断语义与可观测性。机器人 Agent 也可在更高层选择工具或技能，由 FSM/BT/控制器落实执行；这些层可以共存。', 'FSM 用状态与转移表达流程，少量明确状态时容易实现与验证；行为树用条件、动作和控制节点组合任务，便于复用、响应条件变化和组织回退。选型取决于流程复杂度、中断语义与可观测性。机器人 Agent 也可在更高层选择工具或技能，由 FSM/BT/控制器落实执行；这些层可以共存。',
   null, null, '["行为树不天然解决所有中断，也不能断言 VLA 指令通常都会先转成 BT", "工具返回成功仍须结合物理状态判断任务是否完成。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"感知-规划-控制系统架构","qid":"Q03","freq_label":"🔥×4","provenance":"核验：[Nav2 行为树说明](https://docs.nav2.org/rolling/getting_started/navigation_concepts/behavior_trees/)、[Thea 技术报告](https://eit-hai.github.io/thea/index.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000265', '共享内存 vs 消息队列 vs ROS2 Topic，在低延迟控制回路中应该选哪种？', 'eaq-v05-q04', 'knowledge', 'medium', '先按最坏延迟、抖动、负载和故障语义选通信路径。',
   '先按最坏延迟、抖动、负载和故障语义选通信路径。共享内存减少复制但要设计所有权、同步与进程故障处理；消息队列提供解耦和背压；ROS 2 Topic 提供类型、QoS 与生态集成。关键控制链路还应检查调度优先级、内存分配、锁竞争与数据时效，并在目标硬件压力下测量。', '先按最坏延迟、抖动、负载和故障语义选通信路径。共享内存减少复制但要设计所有权、同步与进程故障处理；消息队列提供解耦和背压；ROS 2 Topic 提供类型、QoS 与生态集成。关键控制链路还应检查调度优先级、内存分配、锁竞争与数据时效，并在目标硬件压力下测量。',
   null, null, '["通信方式不能对应固定微秒数字。直接禁用抢占或无界自旋可能拖住实时任务", "双缓冲也必须有正确的发布与读取同步协议。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"感知-规划-控制系统架构","qid":"Q04","freq_label":"🔥×4","provenance":"核验：[ROS 2 实时编程说明](https://design.ros2.org/articles/realtime_background.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000266', '什么是阻抗控制（Impedance Control）？与位置控制和力控制的区别？机器人操作任务里怎么选？', 'eaq-v05-q05', 'knowledge', 'easy', '**阻抗控制**：让机器人末端呈现可调"弹簧-阻尼-质量"特性：$F = K \Delta x + D \dot{x} + M \ddot{x}$，通过调节虚拟刚度 K、阻尼 D，控制机器人与环境交互时的柔顺性。',
   '**阻抗控制**：让机器人末端呈现可调"弹簧-阻尼-质量"特性：$F = K \Delta x + D \dot{x} + M \ddot{x}$，通过调节虚拟刚度 K、阻尼 D，控制机器人与环境交互时的柔顺性。', '**阻抗控制**：让机器人末端呈现可调"弹簧-阻尼-质量"特性：$F = K \Delta x + D \dot{x} + M \ddot{x}$，通过调节虚拟刚度 K、阻尼 D，控制机器人与环境交互时的柔顺性。

- **位置控制**：精确跟踪轨迹，刚性高；接触未知环境时力过大 → 损坏零件或机器人
- **力控制**：维持期望接触力；需要力矩传感器 + 稳定的力估计，对刚性接触不稳定
- **阻抗控制**：两者折中；环境已知时刚、接触时柔，适合大多数操作

**选型**：无接触精密移动 → 位置控制；稳定接触力（如打磨/拧螺丝） → 力控制；插销/组装/接触不确定 → 阻抗控制。',
   null, null, '["阻抗控制不是\"只要有力矩传感器就能用\"——需要精确的动力学模型（质量矩阵 M）", "低成本机器人通常用导纳控制（Admittance Control，在位置控制外环）替代。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"感知-规划-控制系统架构","qid":"Q05","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000267', 'VLA 推理有哪些瓶颈？自回归动作与扩散／Flow 动作头如何分别提速？', 'eaq-v05-q06', 'knowledge', 'medium', '先做分段 profiling：视觉编码、主干条件编码、动作 token 解码或扩散/flow 迭代、传输和控制等待。',
   '先做分段 profiling：视觉编码、主干条件编码、动作 token 解码或扩散/flow 迭代、传输和控制等待。AR 策略可考虑动作压缩或并行回归；迭代动作头可考虑减少采样步数或蒸馏；再评估量化、算子融合和异步动作块执行。方案应以目标硬件上的任务成功率、尾延迟和闭环稳定性验收。', '先做分段 profiling：视觉编码、主干条件编码、动作 token 解码或扩散/flow 迭代、传输和控制等待。AR 策略可考虑动作压缩或并行回归；迭代动作头可考虑减少采样步数或蒸馏；再评估量化、算子融合和异步动作块执行。方案应以目标硬件上的任务成功率、尾延迟和闭环稳定性验收。',
   null, null, '["VLA 不全是自回归模型，GR00T/π0 类迭代动作头也不等于“一次 forward”", "FAST 压缩动作不保证比 flow 解码更快。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q06","freq_label":"🔥×6","provenance":"核验：[OpenVLA-OFT 作者页](https://openvla-oft.github.io/)、[FAST 作者说明](https://www.pi.website/research/fast)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000268', 'INT8 / FP16 / AWQ / GPTQ 量化的区别？机器人推理部署推荐哪种？', 'eaq-v05-q07', 'knowledge', 'medium', 'FP16/BF16 是浮点精度，不是量化算法；',
   'FP16/BF16 是浮点精度，不是量化算法；INT8 是表示精度，可配 PTQ 或 QAT。AWQ 利用校准激活寻找敏感通道，通过等价缩放降低低比特权重量化误差；GPTQ 用近似二阶信息逐步补偿权重量化误差。选择须同时考虑目标芯片内核、权重/激活精度、运行时内存及机器人闭环精度。', 'FP16/BF16 是浮点精度，不是量化算法；INT8 是表示精度，可配 PTQ 或 QAT。AWQ 利用校准激活寻找敏感通道，通过等价缩放降低低比特权重量化误差；GPTQ 用近似二阶信息逐步补偿权重量化误差。选择须同时考虑目标芯片内核、权重/激活精度、运行时内存及机器人闭环精度。',
   null, null, '["AWQ 并非简单把显著通道保留为不量化", "AWQ/GPTQ 不等于只能 INT4，也不能预先保证谁更稳或给出通用 Hz。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q07","freq_label":"🔥×6","provenance":"核验：[AWQ 原论文](https://arxiv.org/abs/2306.00978)、[GPTQ 原论文](https://arxiv.org/abs/2210.17323)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000269', 'TensorRT、ONNX Runtime 与 PyTorch 导出／编译路径如何选？旧 TorchScript 工程怎么处理？', 'eaq-v05-q08', 'knowledge', 'medium', 'TensorRT 面向 NVIDIA 平台，需核对算子、动态形状和构建配置；',
   'TensorRT 面向 NVIDIA 平台，需核对算子、动态形状和构建配置；ONNX Runtime 通过不同执行后端适配多平台；PyTorch 的 torch.export 捕获可供后端处理的图，torch.compile 用于编译优化。既有 TorchScript 工程可维护兼容，新项目应优先核对当前导出及部署路径，端侧可进一步评估 ExecuTorch。', 'TensorRT 面向 NVIDIA 平台，需核对算子、动态形状和构建配置；ONNX Runtime 通过不同执行后端适配多平台；PyTorch 的 torch.export 捕获可供后端处理的图，torch.compile 用于编译优化。既有 TorchScript 工程可维护兼容，新项目应优先核对当前导出及部署路径，端侧可进一步评估 ExecuTorch。',
   null, null, '["TorchScript 已被官方弃用，不宜继续作为新项目默认推荐", "torch.export、ONNX 是图表达/导出路径，与具体推理运行时承担的职责不同。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q08","freq_label":"🔥×5","provenance":"核验：[PyTorch 官方弃用说明](https://pytorch.org/blog/pytorch-2-12-release-blog/)、[Torch-TensorRT legacy 文档](https://docs.pytorch.org/TensorRT/legacy.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000270', 'Jetson Orin AGX 跑 7B VLA 的典型配置和瓶颈在哪？如何估算推理吞吐？', 'eaq-v05-q09', 'knowledge', 'medium', '**Jetson Orin AGX 64GB**（2023，275 TOPS INT8，64 GB LPDDR5 统一内存）。',
   '**Jetson Orin AGX 64GB**（2023，275 TOPS INT8，64 GB LPDDR5 统一内存）：', '**Jetson Orin AGX 64GB**（2023，275 TOPS INT8，64 GB LPDDR5 统一内存）：

**典型配置**：
- 7B VLA INT8 量化 → ~8-10 GB 显存
- 推理吞吐：**8-12 Hz**（取决于视觉 encoder 大小和 chunk 长度）
- 功耗：~40-60W（vs A100 ~400W）

**估算方法**：FP16 模型 = 参数量 × 2 bytes；INT8 = 参数量 × 1 byte；7B × 1 byte = 7 GB，加 KV cache + 激活 ≈ 9-11 GB。推理延迟 ≈ forward FLOPs / 峰值算力（考虑 memory-bound 效率 40-60%）。

**瓶颈**：① 统一内存带宽（204 GB/s）是主瓶颈——LLM 推理 memory-bound；② 视觉 encoder（ViT-L 约 300M）单帧约 20 ms；③ 散热限制功耗 throttling。',
   null, null, '["TOPS 是 INT8 峰值，实际 LLM 推理用不满（带宽受限）", "不要用 TOPS 直接估算真实 token/s。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q09","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000271', '知识蒸馏（Knowledge Distillation）的流程是什么？机器人场景有哪些适配挑战？', 'eaq-v05-q10', 'knowledge', 'medium', '**KD 流程**：Teacher（大模型）软化输出（temperature T > 1 的 softmax 分布）→ Student 模仿 teacher 的"暗知识"（soft label + 中间层特征对齐），在…',
   '**KD 流程**：Teacher（大模型）软化输出（temperature T > 1 的 softmax 分布）→ Student 模仿 teacher 的"暗知识"（soft label + 中间层特征对齐），在小模型上实现接近大模型的性能。', '**KD 流程**：Teacher（大模型）软化输出（temperature T > 1 的 softmax 分布）→ Student 模仿 teacher 的"暗知识"（soft label + 中间层特征对齐），在小模型上实现接近大模型的性能。

**常规 KD 步骤**：① 确定 teacher（如 7B VLA）→ ② 设计 student（如 1B）→ ③ 在数据集上运行 teacher 生成 soft label → ④ student 用 KL 散度 + 任务 loss 联合训练。

**机器人场景挑战**：
- 动作输出是**多模态分布**（Diffusion/Flow Matching），KL 散度对多模态效果差；改用 **feature-level 蒸馏** 或 **score distillation**
- 训练数据量小（1K-50K demos），student 易过拟合 teacher
- 真机评估成本高，无法像 NLP 那样快速迭代 student 质量

**实际路线**：π0 系列用 PaliGemma 3B（SigLIP + Gemma 组合）作预训练 VLM backbone；LoRA 量化微调比全量 KD 更常用，成本更低。',
   null, null, '["KD 不是\"直接 copy teacher 权重 + 减小网络\"，是软标签驱动的训练过程。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q10","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000272', 'Flash Attention 在 VLA 推理中的收益是什么？KV cache 在 VLA 长 context 场景的必要性与局限？', 'eaq-v05-q11', 'knowledge', 'medium', 'FlashAttention 分块计算精确注意力，减少显存读写与中间注意力矩阵存储，标准 dense attention 的二次算术量并未消失。',
   'FlashAttention 分块计算精确注意力，减少显存读写与中间注意力矩阵存储，标准 dense attention 的二次算术量并未消失。KV cache 保存已处理前缀的 K/V，避免自回归解码重复投影；每个新 token 仍需关注历史，生成整段序列的注意力计算通常仍是二次量级。缓存内存按实际缓存 token 数增长。', 'FlashAttention 分块计算精确注意力，减少显存读写与中间注意力矩阵存储，标准 dense attention 的二次算术量并未消失。KV cache 保存已处理前缀的 K/V，避免自回归解码重复投影；每个新 token 仍需关注历史，生成整段序列的注意力计算通常仍是二次量级。缓存内存按实际缓存 token 数增长。',
   null, null, '["动作块覆盖 50 个控制步，不等于缓存里新增 50 帧视觉 token", "跨观测复用还取决于位置、掩码及条件是否改变。激活重计算也不是 KV cache 的替代品。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q11","freq_label":"🔥×4","provenance":"核验：[FlashAttention 原论文](https://arxiv.org/abs/2205.14135)、[Hugging Face 缓存说明](https://huggingface.co/docs/transformers/cache_explanation)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000273', 'batched inference 与机器人实时控制的矛盾如何解决？', 'eaq-v05-q12', 'knowledge', 'medium', '**矛盾**：batched inference 通过聚合多个请求摊销固定 overhead，吞吐提升 N×；',
   '**矛盾**：batched inference 通过聚合多个请求摊销固定 overhead，吞吐提升 N×；但单个请求必须等 batch 凑满才发，**延迟增加** = 等待时间 + 计算时间，与机器人实时控制的低延迟需求（< 100 ms）冲突。', '**矛盾**：batched inference 通过聚合多个请求摊销固定 overhead，吞吐提升 N×；但单个请求必须等 batch 凑满才发，**延迟增加** = 等待时间 + 计算时间，与机器人实时控制的低延迟需求（< 100 ms）冲突。

**解决思路**：
1. **单路独占**：单机器人 → batch_size=1，不凑批，延迟最低但 GPU 利用率低
2. **时间窗口 mini-batch**：固定最大等待时间（如 10 ms），无论 batch 凑没凑满都发；在多机器人集群（Fleet）中平衡延迟和吞吐
3. **持续批处理（Continuous Batching）**：vLLM 实现，请求随到随入 batch，不固定等待窗口；适合云端推理服务
4. **Action Chunking 预计算**：一次 VLA forward 生成 H=50 步动作，低层控制器跑完再请求下次推理；实际推理频率 1-2 Hz，对 batch 要求低',
   null, null, '["Action Chunking 不是\"减少 VLA 调用频率\"的妥协，而是 ACT 的核心设计思想（降低复合误差）", "推理频率低是副产品。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q12","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000274', '投机解码（Speculative Decoding）的原理是什么？机器人 VLA 能用吗？有哪些挑战？', 'eaq-v05-q13', 'knowledge', 'hard', '**原理**：用小 draft 模型（如 1B）串行快速生成 k 个候选 token，再用大 target 模型（如 7B）**并行验证**所有 k 个 token（一次 forward）；',
   '**原理**：用小 draft 模型（如 1B）串行快速生成 k 个候选 token，再用大 target 模型（如 7B）**并行验证**所有 k 个 token（一次 forward）；若验证通过则接受，否则截断重生成。理论加速比 = k / (1 + k × rejection_rate)，实测 NLP 场景 2-3×。', '**原理**：用小 draft 模型（如 1B）串行快速生成 k 个候选 token，再用大 target 模型（如 7B）**并行验证**所有 k 个 token（一次 forward）；若验证通过则接受，否则截断重生成。理论加速比 = k / (1 + k × rejection_rate)，实测 NLP 场景 2-3×。

**机器人 VLA 的可行性**：
- **可行**：动作 token 分布相对简单（7 维连续动作离散化），draft 模型命中率可能较高
- **挑战 1**：VLA 动作 token 只有 7-350 个（chunk），speculation benefit 小（NLP 句子上千 token）
- **挑战 2**：需要维护两个模型（draft + target）的显存，Jetson 上极为紧张
- **挑战 3**：VLA 带视觉 token，draft 模型也需要处理图像 → 不是纯 LLM 投机

**实际应用**：主要见于云端 VLA 服务（多请求并发），边缘部署更常用量化 + 并行动作头（如 GR00T N1 的扩散式并行动作生成）；两者原理不同，但都减少了解码步数。',
   null, null, '["投机解码不改变模型精度（验证步保证与 target 分布一致），是纯推理加速技巧。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"推理加速与边缘部署","qid":"Q13","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000275', 'DDP / FSDP / DeepSpeed ZeRO 三者区别？VLA（7B）训练用哪个？', 'eaq-v05-q14', 'knowledge', 'medium', '| 方案 | 切分内容 | 每卡所需显存 | 通信量 | 适用 |',
   '| 方案 | 切分内容 | 每卡所需显存 | 通信量 | 适用 |
|---|---|---|---|---|
| **DDP** | 不切分（每卡完整模型） | 完整参数 + 梯度 + 优化器 | all-reduce 梯度 | < 3B，单机多卡 |
| **FSDP（ZeRO-3）** | 参数/梯度/优化器全切分 | 1/N（+临时通信开销） | all-gather + reduce-scatter | ≥ 7B，多机 |
| **DeepSpeed ZeRO-1/2/3** | 逐级切分优化器/梯度/参数 | 递减 | 递增 | ≥ 7B，灵活配置 |', '| 方案 | 切分内容 | 每卡所需显存 | 通信量 | 适用 |
|---|---|---|---|---|
| **DDP** | 不切分（每卡完整模型） | 完整参数 + 梯度 + 优化器 | all-reduce 梯度 | < 3B，单机多卡 |
| **FSDP（ZeRO-3）** | 参数/梯度/优化器全切分 | 1/N（+临时通信开销） | all-gather + reduce-scatter | ≥ 7B，多机 |
| **DeepSpeed ZeRO-1/2/3** | 逐级切分优化器/梯度/参数 | 递减 | 递增 | ≥ 7B，灵活配置 |

**7B VLA 推荐**：
- **4×A100（40GB）**：FSDP or ZeRO-2（切梯度+优化器，不切参数）→ 稳定快
- **8×A100（80GB）**：ZeRO-1（只切优化器）足够，通信少
- **多机（≥4 节点）**：ZeRO-3 / FSDP + NVLink 节点内、InfiniBand 跨节点

**实测规律**：ZeRO-3 显存最省但通信最多，跨机 InfiniBand 慢时吞吐下降明显；VLA 首选 **ZeRO-2 + activation offload** 平衡显存和速度。',
   null, null, '["FSDP 是 PyTorch 原生的 ZeRO-3 等价实现，不是比 ZeRO 更先进，是平台选择（PyTorch vs DeepSpeed）。"]'::jsonb, null, 5, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"训练工程","qid":"Q14","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000276', 'VLA 训练需要多少显存？如何估算 7B 模型的训练显存？', 'eaq-v05-q15', 'knowledge', 'medium', '**估算公式（混合精度训练，Adam optimizer）**。',
   '**估算公式（混合精度训练，Adam optimizer）**：', '**估算公式（混合精度训练，Adam optimizer）**：

显存 ≈ 参数 × (2 B FP16 参数 + 2 B FP16 梯度 + 4 B FP32 主参数 + 4 B Adam m + 4 B Adam v) + 激活值

= 参数量 × **16 bytes** + 激活值

**7B VLA 示例**：7 × 10⁹ × 16 = **112 GB**（仅模型状态），+ 激活值（batch 依赖，约 20-60 GB）→ 总计 **130-170 GB**。

**优化手段**：① gradient checkpointing：激活值只存 checkpoint 节点，重算其余，激活显存 → ~10 GB（代价：增加约 30% 计算量）；② ZeRO-3 切分到 8 卡：每卡 ~20 GB；③ INT8 量化 + LoRA：7B LoRA 约 20-30 GB（仅训练 adapter 参数，不更新全量权重）。

**典型配置**：7B VLA 全参数微调 → **8 × A100 80GB**（ZeRO-2）；LoRA 微调 → **4 × A100 40GB**。',
   null, null, '["\"7B 模型 = 7 GB\" 是 INT8 推理权重估算（1 byte/param）", "FP16 推理权重约 14 GB", "训练还需 Adam 优化器状态（额外 8 bytes/param），总量完全不同数量级。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"训练工程","qid":"Q15","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000277', '混合精度训练（AMP）原理？FP16 vs BF16，VLA 训练建议用哪个？', 'eaq-v05-q16', 'knowledge', 'easy', '**AMP 原理**：前向/反向用低精度（FP16/BF16）计算，维护 FP32 主参数副本用于更新；',
   '**AMP 原理**：前向/反向用低精度（FP16/BF16）计算，维护 FP32 主参数副本用于更新；梯度放大（GradScaler）防 FP16 下溢（underflow）。节省显存约 50%，训练加速 2-3×（Tensor Core 专为低精度优化）。', '**AMP 原理**：前向/反向用低精度（FP16/BF16）计算，维护 FP32 主参数副本用于更新；梯度放大（GradScaler）防 FP16 下溢（underflow）。节省显存约 50%，训练加速 2-3×（Tensor Core 专为低精度优化）。

**FP16 vs BF16**：
| | FP16（E5M10） | BF16（E8M7） |
|---|---|---|
| 指数位 | 5 位（范围小） | 8 位（与 FP32 同范围） |
| 精度位 | 10 位（精度高） | 7 位（精度略低） |
| 溢出风险 | 高（需 GradScaler） | 极低（范围与 FP32 一致） |
| 硬件支持 | A100/V100 均支持 | A100/H100 强支持；V100 不支持 |

**VLA 建议**：A100/H100 → **BF16**（无需 GradScaler，更稳定，VLM 大梯度场景不溢出）；V100 → FP16 + GradScaler。',
   null, null, '["AMP 不是\"全程 FP16\"——优化器更新和权重维护仍是 FP32，只是前反向低精度。BF16 不需要 GradScaler。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"训练工程","qid":"Q16","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000278', 'gradient checkpointing 原理？VLA 训练中怎么用？与 ZeRO 如何配合？', 'eaq-v05-q18', 'knowledge', 'medium', '**原理**：标准反向传播缓存所有前向激活（显存 $O(L \times depth)$）。',
   '**原理**：标准反向传播缓存所有前向激活（显存 $O(L \times depth)$）。Gradient Checkpointing 只保留每 N 层一个 checkpoint 节点，反向时从最近节点重算中间激活，以约 **30% 额外计算** 换取 **60-80% 激活显存节省**，且梯度数值不变（数学等价）。', '**原理**：标准反向传播缓存所有前向激活（显存 $O(L \times depth)$）。Gradient Checkpointing 只保留每 N 层一个 checkpoint 节点，反向时从最近节点重算中间激活，以约 **30% 额外计算** 换取 **60-80% 激活显存节省**，且梯度数值不变（数学等价）。

**VLA 配置**：对 LLM backbone 每层开 `gradient_checkpointing=True`；视觉 ViT 层数少，可不开。

**与 ZeRO 配合**：ZeRO-2/3 切分参数/梯度显存；gradient checkpointing 切分激活显存，两者正交互补。典型：7B + ZeRO-2 + checkpointing → 4 × A100 40GB 可跑。',
   null, null, '["不是\"保存 ckpt 文件\"，是激活重计算", "开启后训练速度降低约 30%，不影响梯度准确性。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"训练工程","qid":"Q18","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000279', '单机多卡 vs 多机训练：VLA 常见配置与跨机通信的瓶颈在哪？', 'eaq-v05-q19', 'knowledge', 'medium', '| | 单机多卡（8 × A100） | 多机（如 4 × 8 卡） |',
   '| | 单机多卡（8 × A100） | 多机（如 4 × 8 卡） |
|---|---|---|
| 卡间带宽 | NVLink 600 GB/s（A100 SXM） | InfiniBand 200-400 Gb/s（~25-50 GB/s）|
| 通信延迟 | 极低（µs） | ms 级 |
| 扩展性 | 受机器限制 | 水平扩展 |
| 常见瓶颈 | 单机内存（8 × 80GB = 640GB） | 跨机 all-reduce 等待 |', '| | 单机多卡（8 × A100） | 多机（如 4 × 8 卡） |
|---|---|---|
| 卡间带宽 | NVLink 600 GB/s（A100 SXM） | InfiniBand 200-400 Gb/s（~25-50 GB/s）|
| 通信延迟 | 极低（µs） | ms 级 |
| 扩展性 | 受机器限制 | 水平扩展 |
| 常见瓶颈 | 单机内存（8 × 80GB = 640GB） | 跨机 all-reduce 等待 |

**VLA 常见配置**：
- 7B 全参数：8 × A100 80GB（ZeRO-2），单机足够
- 13B-70B 或大批量：多机，用 InfiniBand + NCCL，ZeRO-3
- 通信优化：gradient compression（梯度稀疏化/1-bit）or Async SGD（有精度损失）

**跨机瓶颈**：7B 模型 FP16 梯度约 14 GB，InfiniBand 200 Gb/s（实际有效带宽 ~60%）传输需 ~1 s；gradient accumulation 增大 batch 可分摊通信开销。',
   null, null, '["多机不是\"卡越多越快\"——强扩展效率（Strong Scaling Efficiency）在 8+ 节点后常见 < 80%", "通信开销随节点数增加。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"训练工程","qid":"Q19","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000280', 'torch.compile 在 VLA 训练中的加速收益与常见坑？', 'eaq-v05-q20', 'knowledge', 'medium', '**torch.compile**（PyTorch 2.0+）：基于 TorchDynamo（Python 字节码捕获计算图）+ TorchInductor（生成 Triton GPU kernel），将 eager …',
   '**torch.compile**（PyTorch 2.0+）：基于 TorchDynamo（Python 字节码捕获计算图）+ TorchInductor（生成 Triton GPU kernel），将 eager 模式编译为融合 kernel，减少 kernel launch 次数和 HBM 读写。', '**torch.compile**（PyTorch 2.0+）：基于 TorchDynamo（Python 字节码捕获计算图）+ TorchInductor（生成 Triton GPU kernel），将 eager 模式编译为融合 kernel，减少 kernel launch 次数和 HBM 读写。

**典型收益**：纯 Transformer forward/backward 约 **10-30% 吞吐提升**（无数据 IO 瓶颈时）；VLA 因含视觉 encoder + 动作头，实测 5-20%（因图像预处理、动态 shape 等限制编译效率）。

**常见坑**：① **动态 shape**：VLA 输入长度变化 → 每种 shape 重编译（首次 1-3 min），加 `dynamic=True` 缓解；② **自定义 CUDA op**（如 Flash Attention）fallback eager，需显式标注；③ **silent fallback**：编译失败不报错，需加日志确认是否生效。

**VLA 建议**：主要对 LLM backbone 开，视觉 encoder 保持 eager 避免动态 shape 坑。',
   null, null, '["torch.compile 不能替代 Flash Attention（解决不同层面），两者可叠加。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"训练工程","qid":"Q20","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000281', 'teleop 遥操设备如何选型？VR / leader-follower / exoskeleton / Aloha-style 各适合什么场景？', 'eaq-v05-q21', 'knowledge', 'medium', '| 设备 | 示例 | 优势 | 劣势 | 适用场景 |',
   '| 设备 | 示例 | 优势 | 劣势 | 适用场景 |
|---|---|---|---|---|
| **Leader-follower arm** | ALOHA, Lerobot SO-ARM100 | 力反馈自然，学习曲线低 | 需配套夹爪，双臂协调难 | 桌面操作、精细抓取 |
| **VR 手柄** | Quest 3 + ROS bridge | 低成本，6-DoF 追踪 | 无力觉，远端操作抖动大 | 大范围移动任务，数据量级 |
| **动作捕捉套装** | Rokoko / Vicon | 全身 DoF，丰富表达 | 昂贵，标注后处理复杂 | 人形全身操控 |
| **外骨骼** | Inspire Dexterous Hand + arm | 手指级灵巧度 | 穿戴复杂，延迟高 | 5 指灵巧操作（如拧瓶盖） |
| **数据手套** | SenseGlove / HaptX | 触觉反馈 | 贵，续航 | 精密触感任务 |', '| 设备 | 示例 | 优势 | 劣势 | 适用场景 |
|---|---|---|---|---|
| **Leader-follower arm** | ALOHA, Lerobot SO-ARM100 | 力反馈自然，学习曲线低 | 需配套夹爪，双臂协调难 | 桌面操作、精细抓取 |
| **VR 手柄** | Quest 3 + ROS bridge | 低成本，6-DoF 追踪 | 无力觉，远端操作抖动大 | 大范围移动任务，数据量级 |
| **动作捕捉套装** | Rokoko / Vicon | 全身 DoF，丰富表达 | 昂贵，标注后处理复杂 | 人形全身操控 |
| **外骨骼** | Inspire Dexterous Hand + arm | 手指级灵巧度 | 穿戴复杂，延迟高 | 5 指灵巧操作（如拧瓶盖） |
| **数据手套** | SenseGlove / HaptX | 触觉反馈 | 贵，续航 | 精密触感任务 |

**2024-2026 主流**：ALOHA-style leader-follower（双臂 14-16 DoF）是最多公开数据集的选择；宇树 G1 用 VR + 全身运动捕捉。选型核心：**操作的 DoF 要求**（精细 → exo，范围 → VR，双臂 → leader-follower）。',
   null, null, '["VR 手柄抖动会污染数据（需平滑滤波 / 仅用关键帧），不能直接当 GT 动作。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"数据飞轮与采集","qid":"Q21","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000282', 'Open-X-Embodiment / DROID / Ego4D 三大数据集的区别与各自定位？', 'eaq-v05-q22', 'knowledge', 'medium', '| 数据集 | 规模 | 载体 | 特点 | 适用 |',
   '| 数据集 | 规模 | 载体 | 特点 | 适用 |
|---|---|---|---|---|
| **Open-X-Embodiment** | 1M+ 轨迹，22 种机器人 | 多 embodiment | 最大多体系开放数据集；任务短/简单，多样性强 | VLA 预训练，跨机器人泛化 |
| **DROID** | 76K 轨迹，~350h，Franka Panda | 单 embodiment | 564 场景、86 个任务、50 名采集者；自然语言指令 | 真实场景操作，policy 微调 |
| **Ego4D** | 3500+ 小时视频，74 个地点 | 纯视频，非机器人 | 以人为主视角，活动多样；无动作标签 | 视觉表征预训练（视觉理解），不直接训策略 |', '| 数据集 | 规模 | 载体 | 特点 | 适用 |
|---|---|---|---|---|
| **Open-X-Embodiment** | 1M+ 轨迹，22 种机器人 | 多 embodiment | 最大多体系开放数据集；任务短/简单，多样性强 | VLA 预训练，跨机器人泛化 |
| **DROID** | 76K 轨迹，~350h，Franka Panda | 单 embodiment | 564 场景、86 个任务、50 名采集者；自然语言指令 | 真实场景操作，policy 微调 |
| **Ego4D** | 3500+ 小时视频，74 个地点 | 纯视频，非机器人 | 以人为主视角，活动多样；无动作标签 | 视觉表征预训练（视觉理解），不直接训策略 |

**关键区别**：OXE 多体系宽泛，DROID 单体系高质量，Ego4D 无动作标签（只能做视觉预训练）。VLA 预训练通常：Ego4D + OXE 做视觉/语言预训练 → 任务数据微调 → DROID 验证泛化。',
   null, null, '["Ego4D 不能直接训练机器人策略（缺动作标签），只用于视觉表征学习", "不要说\"用 Ego4D 训策略\"。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"数据飞轮与采集","qid":"Q22","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000283', '如何设计高质量机器人数据采集流程？数据清洗与标注的关键点是什么？', 'eaq-v05-q23', 'knowledge', 'medium', '**采集流程设计**。',
   '**采集流程设计**：
1. **环境标准化**：固定照明/背景/相机位姿（减少无关变量），但 DROID-style 也需多场景覆盖泛化
2. **Operator 培训**：操作员统一培训（避免动作风格差异），多 operator 增加多样性（Mobile ALOHA 策略）
3. **同步录制**：多相机（wrist + overhead）+ 关节状态 + 时间戳对齐；< 1 ms 同步需**硬件触发**（外部触发信号）或 PTP（IEEE 1588，µs 级）；NTP 只能做毫秒级粗同步
4. **在线质量筛**：任务完成检测（如物体位置传感器）自动过滤失败轨迹', '**采集流程设计**：
1. **环境标准化**：固定照明/背景/相机位姿（减少无关变量），但 DROID-style 也需多场景覆盖泛化
2. **Operator 培训**：操作员统一培训（避免动作风格差异），多 operator 增加多样性（Mobile ALOHA 策略）
3. **同步录制**：多相机（wrist + overhead）+ 关节状态 + 时间戳对齐；< 1 ms 同步需**硬件触发**（外部触发信号）或 PTP（IEEE 1588，µs 级）；NTP 只能做毫秒级粗同步
4. **在线质量筛**：任务完成检测（如物体位置传感器）自动过滤失败轨迹

**数据清洗关键**：
- **抖动过滤**：VR 手柄输入需低通滤波（截止频率 5-10 Hz）
- **动作平滑**：去除突变（速度超阈值的帧）
- **失败轨迹剔除**：夹爪未闭合 / 末端超出工作空间 → 自动剔除
- **标注**：自然语言任务描述（多人标注取一致）；成功/失败标签',
   null, null, '["不要只收集\"成功轨迹\"——失败轨迹（负样本）对 RLHF / offline RL 有价值", "完全清洗掉失败数据使策略无法学习恢复。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"数据飞轮与采集","qid":"Q23","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000284', '互联网视频预训练（Ego4D/Something-Something/YouTube）对机器人策略有什么用？有哪些根本局限？', 'eaq-v05-q24', 'knowledge', 'medium', '**用处**：① 学习视觉表征（物体形状、纹理、手部运动先验）→ 下游机器人任务 fine-tune 数据需求减少 5-10×；',
   '**用处**：① 学习视觉表征（物体形状、纹理、手部运动先验）→ 下游机器人任务 fine-tune 数据需求减少 5-10×；② 学习物理常识（物体如何掉落、液体如何流动）→ 减少仿真的 domain gap；③ 语言-视觉对齐（理解任务指令）。', '**用处**：① 学习视觉表征（物体形状、纹理、手部运动先验）→ 下游机器人任务 fine-tune 数据需求减少 5-10×；② 学习物理常识（物体如何掉落、液体如何流动）→ 减少仿真的 domain gap；③ 语言-视觉对齐（理解任务指令）。

**典型使用**：Ego4D 预训练 → EgoVLP/MAE 视觉 encoder → 迁移到 VLA（如 Octo 用 ImageNet 预训练 ViT）；**R3M**（Nair et al., 2022）用 **Ego4D** 人类活动视频预训练，对桌面抓取任务有明显收益。

**根本局限**：
- **无动作标签**：视频只有像素，不知道机器人该输出什么关节角 / 力矩
- **视角不匹配**：人手视角 vs 机器人腕部相机视角有巨大 domain gap
- **物理差异**：人手柔顺，机器人刚性，力的分布完全不同
- **长尾分布**：互联网视频大量是日常活动，机器人精密操作数据极少',
   null, null, '["视频预训练的收益主要在**视觉感知**层，不会\"自动学会如何操控\"——策略学习仍需机器人专属数据。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"数据飞轮与采集","qid":"Q24","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000285', '数据飞轮（Data Flywheel）的核心闭环是什么？为什么 scale 起来很难？', 'eaq-v05-q25', 'knowledge', 'medium', '**数据飞轮闭环**：部署机器人 → 采集交互数据（成功+失败）→ 过滤/标注 → 训练改进策略 → 更好的策略 → 更多/更难任务 → 继续采集。',
   '**数据飞轮闭环**：部署机器人 → 采集交互数据（成功+失败）→ 过滤/标注 → 训练改进策略 → 更好的策略 → 更多/更难任务 → 继续采集。理论上闭环越快越强。', '**数据飞轮闭环**：部署机器人 → 采集交互数据（成功+失败）→ 过滤/标注 → 训练改进策略 → 更好的策略 → 更多/更难任务 → 继续采集。理论上闭环越快越强。

**为什么难 scale**：
1. **数据采集速度瓶颈**：teleop 需要人工操作，单台机器人采集约 1-5 demos/小时，1000 demos = 200-1000 人时
2. **数据多样性 vs 质量矛盾**：多场景保证泛化，但每场景样本少 → long-tail 问题
3. **标注成本**：自然语言任务描述 + 成功/失败标签 + 关键帧标注，人工成本非线性增长
4. **分布 shift**：旧数据与新策略的状态分布不一致 → 需 DAgger-style 在线数据收集
5. **Reset 成本**：真机每次 demo 后需 reset 场景，人工耗时大

**行业现状（2025）**：自主数据采集（机器人在夜晚自己采集）+ VR 远程采集集群是主要突破方向；Physical Intelligence（π）、Figure 都有大规模 teleop 采集基础设施。',
   null, null, '["数据飞轮不是\"有了数据就飞轮\"，闭环的关键是**数据质量筛选 + 增量训练策略**，垃圾数据会反向拖累策略。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"数据飞轮与采集","qid":"Q25","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000286', '自主数据采集（Autonomous Data Collection）有哪些思路？与 teleop 相比的优势和局限？', 'eaq-v05-q26', 'knowledge', 'medium', '**主要思路**。',
   '**主要思路**：
1. **Reset-free Learning**：策略自主探索，无需人工 reset（如 Forward-Backward RL，在"做任务"和"恢复初始态"间循环）
2. **Curiosity-Driven Exploration**：自动选择"信心低"状态收集数据（DAGGER 风格在线查询）
3. **Scripted / Heuristic Collection**：写简单程序控制机器人随机/系统地扫描工作空间，采集带 annotation 的场景数据
4. **Human-in-the-Loop**：策略自主运行，失败时触发远程 teleoperation 补全', '**主要思路**：
1. **Reset-free Learning**：策略自主探索，无需人工 reset（如 Forward-Backward RL，在"做任务"和"恢复初始态"间循环）
2. **Curiosity-Driven Exploration**：自动选择"信心低"状态收集数据（DAGGER 风格在线查询）
3. **Scripted / Heuristic Collection**：写简单程序控制机器人随机/系统地扫描工作空间，采集带 annotation 的场景数据
4. **Human-in-the-Loop**：策略自主运行，失败时触发远程 teleoperation 补全

**vs teleop 优势**：24/7 无人工，单机器人日采集量可达 teleop 的 10-50×；边际成本极低。

**局限**：
- 初始策略不够强时，自主探索只采到低价值数据（随机碰撞）
- 缺乏任务目标驱动（需要 reward 定义或任务成功检测）
- 安全性：无人监督下需硬件安全限位',
   null, null, '["自主数据采集不是\"让机器人自己学\"——仍需要明确的成功/失败检测和数据标注机制。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"数据飞轮与采集","qid":"Q26","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000287', '训练好的策略真机表现差，第一步怎么排查 sim2real gap？系统化排查流程是什么？', 'eaq-v05-q27', 'knowledge', 'medium', '**系统化排查流程（由浅入深）**。',
   '**系统化排查流程（由浅入深）**：', '**系统化排查流程（由浅入深）**：

**Step 1 — 输入分布检查**：记录真机传感器数据（图像/关节状态）与仿真数据的分布差异（直方图对比）；常见：光照/背景/物体颜色偏差，关节摩擦力估计不准。

**Step 2 — 策略输出检查**：在真机上 rollout 时 log 动作分布；若策略输出与仿真动作差异大，说明观测 domain gap 大；若动作分布类似但执行失败，是执行器/物理 gap。

**Step 3 — 逐模块 ablation**：
- 关掉感知，直接输入仿真参考状态 → 排查控制 gap
- 用仿真相机 → 排查视觉 gap
- 用真实图像 + ground truth 状态 → 排查策略泛化

**Step 4 — 常见 gap 原因**：
- 物体质量/摩擦系数不准 → 加 domain randomization 重训
- 相机内参/外参偏差 → 重新标定
- 控制频率 / 延迟不匹配 → 统一仿真和真机延迟设置',
   null, null, '["不要第一步就调超参数，先定位 gap 来源再针对性修", "盲目加 DR 有时反而降低真机策略质量（过度泛化导致精度下降）。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"失败排查与调试","qid":"Q27","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000288', '灾难性遗忘（Catastrophic Forgetting）在 VLA 微调中怎么出现？如何缓解？', 'eaq-v05-q29', 'knowledge', 'medium', '**出现场景**：将预训练 VLA（在大规模数据上训练的通用能力）在特定任务数据上**全参数微调**时，模型快速过拟合新任务 → 遗忘预训练时的语言理解/视觉泛化能力，在新任务上成功，其他任务失败。',
   '**出现场景**：将预训练 VLA（在大规模数据上训练的通用能力）在特定任务数据上**全参数微调**时，模型快速过拟合新任务 → 遗忘预训练时的语言理解/视觉泛化能力，在新任务上成功，其他任务失败。', '**出现场景**：将预训练 VLA（在大规模数据上训练的通用能力）在特定任务数据上**全参数微调**时，模型快速过拟合新任务 → 遗忘预训练时的语言理解/视觉泛化能力，在新任务上成功，其他任务失败。

**常见表现**：微调后在原任务上成功率骤降（如 OpenVLA 微调新桌面抓取 → 忘记开门）；语言指令理解变差（只能响应微调数据的指令风格）。

**缓解策略**：
1. **LoRA / PEFT**：只更新 < 1% 参数，冻结主干 → 最常用
2. **EWC**：Fisher 信息矩阵指导，惩罚重要参数大幅改变
3. **Replay / Co-training**：混入预训练数据（Mobile ALOHA co-train 策略）
4. **KI（Knowledge Insulation）**：π0.5 思路，stop-gradient 隔离 VLM 和 Action Expert
5. **差异 lr**：VLM backbone 用极小 lr（1e-5），action head 用较大 lr（1e-4）',
   null, null, '["LoRA 不能完全防遗忘", "彻底防遗忘仍需 co-training 混入原始数据。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"失败排查与调试","qid":"Q29","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000289', '关节控制振荡的常见原因与调参思路？PID 和阻抗控制各怎么调？', 'eaq-v05-q30', 'knowledge', 'medium', '**振荡原因**。',
   '**振荡原因**：
- PID P 增益过大 → 超调 + 振荡（欠阻尼）
- 控制频率低（> 10 ms 周期）→ 相位滞后 → 条件不稳定
- 关节静摩擦（stiction）→ 低速黏滑（stick-slip）现象
- VLA 动作 chunk 末端不连续 → 关节速度跳变', '**振荡原因**：
- PID P 增益过大 → 超调 + 振荡（欠阻尼）
- 控制频率低（> 10 ms 周期）→ 相位滞后 → 条件不稳定
- 关节静摩擦（stiction）→ 低速黏滑（stick-slip）现象
- VLA 动作 chunk 末端不连续 → 关节速度跳变

**PID 调参**：① Ziegler-Nichols 法（逐渐增 P 至临界振荡，读取 $K_u$ 和 $T_u$，代入公式计算 P/I/D）；② 人工逐步调：先清零 I/D，调 P 至刚好振荡，再加 D（微分减振荡），最后加 I（消除稳态误差）；③ 加前馈（Feedforward）：预计算重力补偿，减轻 P 的负担。

**阻抗控制调参**：虚拟刚度 K 太大 → 刚性振荡（减 K 或加 D）；阻尼 D 太小 → 欠阻尼（增 D 至临界阻尼 $D = 2\sqrt{KM}$）；质量 M 影响响应速度（通常设为实际惯量的 1-5×）。

**VLA chunk 振荡**：Chunk 边界加速度不连续 → 用三次样条插值平滑相邻 chunk 的连接；或减小 chunk 长度 H。',
   null, null, '["不要把\"振荡\"和\"稳态误差\"混淆，两者病根不同（前者是 P/D 问题，后者是 I 问题）。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"失败排查与调试","qid":"Q30","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000290', 'Diffusion Policy 训练时的 Mode Collapse（模式坍塌）如何排查？', 'eaq-v05-q31', 'knowledge', 'hard', '**Diffusion Policy 的 Mode Collapse**：多模态动作分布下，策略只学会一种模式（如总是选同一抓取方向），丢失其他合法方案。',
   '**Diffusion Policy 的 Mode Collapse**：多模态动作分布下，策略只学会一种模式（如总是选同一抓取方向），丢失其他合法方案。', '**Diffusion Policy 的 Mode Collapse**：多模态动作分布下，策略只学会一种模式（如总是选同一抓取方向），丢失其他合法方案。

**排查方法**：① 同一观测下多次采样（N=100）动作，绘 2D 投影；若全部聚成一团 → collapse；② log 各 diffusion step 的 loss，若小 t（精细步）loss 极低而大 t 偏高 → 过拟合单一模式；③ 检查 score 网络输出方差是否异常小。

**根本原因**：① 训练数据单模态（operator 风格单一）→ 增加操作员多样性；② Beta schedule 过早收紧 → 调整为 cosine schedule；③ CFG Guidance scale 过高 → 降低；④ lr 过大 → 降至 1e-4 以下。',
   null, null, '["Diffusion Policy 本设计防 mode collapse，若仍 collapse 先查数据", "与 GAN collapse 机制不同，无需改判别器。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"失败排查与调试","qid":"Q31","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000291', '传感器漂移（Sensor Drift）怎么检测和补偿？以 IMU 和力矩传感器为例？', 'eaq-v05-q32', 'knowledge', 'medium', '**IMU 漂移**：陀螺仪积分误差随时间累积（Gyro bias），表现为姿态估计随时间漂移（静止时角速度输出非零）。',
   '**IMU 漂移**：陀螺仪积分误差随时间累积（Gyro bias），表现为姿态估计随时间漂移（静止时角速度输出非零）。
- 检测：静置机器人采集 N 秒数据，计算静态时 bias 均值和方差
- 补偿：① 开机标定（校准 bias offset）；② **互补滤波 / EKF**：融合加速度计（无漂移但噪声大）和陀螺仪（短期精准但长期漂），EKF 状态量含 bias 项自动估计', '**IMU 漂移**：陀螺仪积分误差随时间累积（Gyro bias），表现为姿态估计随时间漂移（静止时角速度输出非零）。
- 检测：静置机器人采集 N 秒数据，计算静态时 bias 均值和方差
- 补偿：① 开机标定（校准 bias offset）；② **互补滤波 / EKF**：融合加速度计（无漂移但噪声大）和陀螺仪（短期精准但长期漂），EKF 状态量含 bias 项自动估计

**力矩传感器漂移**：温度变化导致零点漂移（Thermal Drift），表现为无负载时力/力矩读数随温度升高缓慢变化。
- 检测：预热机器人 5-10 分钟，监测空载读数变化（> 0.5 N 为需补偿）
- 补偿：① 运行前**重新清零（tare）**；② 建立温度-零点补偿模型（查表或线性拟合）；③ 选用内置温度补偿的传感器（ATI Axia / Rokbi）

**通用原则**：定期标定（每月或每 N 小时作业）；记录环境温度、湿度与漂移量，建补偿表。',
   null, null, '["不要把\"漂移\"和\"噪声\"混淆——漂移是系统性偏差（低频），噪声是随机（高频）", "滤波器设计不同。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"失败排查与调试","qid":"Q32","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000292', 'VLA 推理时序抖动（Inference Jitter）如何影响控制？有哪些工程解决方案？', 'eaq-v05-q33', 'knowledge', 'medium', '先测观测年龄、排队、预处理、推理、通信及控制执行的延迟分布，而非只看均值。',
   '先测观测年龄、排队、预处理、推理、通信及控制执行的延迟分布，而非只看均值。动作块异步生成时维护绝对时间与执行位置，检测过期、缺块和超时；RTC 等方法让新块与已承诺动作对齐。再检查控制器的速度/加速度限制、缓冲下溢与停止/保持策略，并用实际负载压力测试。', '先测观测年龄、排队、预处理、推理、通信及控制执行的延迟分布，而非只看均值。动作块异步生成时维护绝对时间与执行位置，检测过期、缺块和超时；RTC 等方法让新块与已承诺动作对齐。再检查控制器的速度/加速度限制、缓冲下溢与停止/保持策略，并用实际负载压力测试。',
   null, null, '["双缓冲或平滑并不自动消除新旧块冲突", "较长块也可能增加观测陈旧。抖动可能来自调度、驱动、网络或设备，不能一概排除硬件。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"失败排查与调试","qid":"Q33","freq_label":"🔥×3","provenance":"核验：[RTC 作者说明](https://www.pi.website/research/real_time_chunking)、[ROS 2 实时系统设计](https://design.ros2.org/articles/realtime_background.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000293', '遥操示教 + 模仿学习有哪些工程优势和局限？', 'eaq-v05-q34', 'knowledge', 'medium', '遥操作提供与机器人观测对齐的动作示教，可先用 BC、ACT、diffusion/flow 等方法建立任务基线，省去早期大量探索与奖励设计。',
   '遥操作提供与机器人观测对齐的动作示教，可先用 BC、ACT、diffusion/flow 等方法建立任务基线，省去早期大量探索与奖励设计。数据采集、质量检查和真机评测也较易形成可控流程。但示教覆盖、重置成本、跨本体迁移和分布偏移仍是限制；可结合仿真、离线数据及 RL 后训练逐步补足。', '遥操作提供与机器人观测对齐的动作示教，可先用 BC、ACT、diffusion/flow 等方法建立任务基线，省去早期大量探索与奖励设计。数据采集、质量检查和真机评测也较易形成可控流程。但示教覆盖、重置成本、跨本体迁移和分布偏移仍是限制；可结合仿真、离线数据及 RL 后训练逐步补足。',
   null, null, '["不存在统一最优范式或固定“几个月胜过几年”的周期", "自主执行数据采集与人工遥操要分开说明，RL 也不只是对 BC 模型简单套 PPO。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"开放题与系统设计","qid":"Q34","freq_label":"🔥×5","provenance":"核验：[ACT 原论文](https://arxiv.org/html/2304.13705)、[RECAP 原论文](https://arxiv.org/abs/2511.14759)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000294', 'VLA 端到端方案 vs 传统模块化方案：2026 年你会怎么选？', 'eaq-v05-q35', 'knowledge', 'hard', '从任务多样性、可用数据、精度、时延、调试成本及验收约束比较。',
   '从任务多样性、可用数据、精度、时延、调试成本及验收约束比较。模块化便于逐层诊断和复用已知几何/控制结构；VLA 可学习语言与视觉条件到动作的映射，但泛化与恢复需实测。可以组合高层模型、技能/策略和底层控制，先定义接口与故障归属，再以同任务、同预算比较成功率和成本。', '从任务多样性、可用数据、精度、时延、调试成本及验收约束比较。模块化便于逐层诊断和复用已知几何/控制结构；VLA 可学习语言与视觉条件到动作的映射，但泛化与恢复需实测。可以组合高层模型、技能/策略和底层控制，先定义接口与故障归属，再以同任务、同预算比较成功率和成本。',
   null, null, '["VLA 不必只负责高层规划，也并非天然解决长尾", "端到端策略可以输出关节目标，各层控制频率不能统一写死。"]'::jsonb, null, 8, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"开放题与系统设计","qid":"Q35","freq_label":"🔥×6","provenance":"核验：[Helix 02 官方说明](https://www.figure.ai/news/helix-02)、[PyRUA-Lean 原论文](https://arxiv.org/abs/2610.01939)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000295', '如果给你 2 台 A100（80GB × 8）、3 个月，从零搭建一套 Humanoid VLA pipeline，你的规划是什么？', 'eaq-v05-q36', 'knowledge', 'hard', '先澄清“2台”指服务器还是GPU，以及是否每台8张80GB A100；',
   '先澄清“2台”指服务器还是GPU，以及是否每台8张80GB A100；再确认本体、数据、团队、可用时段与交付范围。第一阶段跑通采集—训练—回放—受控真机基线；第二阶段围绕失败类型补数据与适配模型；第三阶段固定保留任务做鲁棒性、恢复和部署验收。按实测显存、吞吐与数据质量选择模型和微调方法。', '先澄清“2台”指服务器还是GPU，以及是否每台8张80GB A100；再确认本体、数据、团队、可用时段与交付范围。第一阶段跑通采集—训练—回放—受控真机基线；第二阶段围绕失败类型补数据与适配模型；第三阶段固定保留任务做鲁棒性、恢复和部署验收。按实测显存、吞吐与数据质量选择模型和微调方法。',
   null, null, '["资源数量和交付范围未清楚前不能承诺成功率", "桌面双臂原型不等于全身 humanoid pipeline，参数量也不能单独确定能否全参微调。"]'::jsonb, null, 8, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"开放题与系统设计","qid":"Q36","freq_label":"🔥×5","provenance":"核验：[OpenVLA 原论文](https://arxiv.org/html/2406.09246)、[TorchData StatefulDataLoader](https://github.com/meta-pytorch/data/blob/main/torchdata/stateful_dataloader/README.md)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000296', '讨论未来几年的具身技术路线时，怎样区分证据、假设与验证计划？', 'eaq-v05-q37', 'knowledge', 'hard', '先定义要解决的任务、成本和可靠性目标，再区分已发表结果、尚待验证的假设与自己的路线选择。',
   '先定义要解决的任务、成本和可靠性目标，再区分已发表结果、尚待验证的假设与自己的路线选择。示教预训练、RL 后训练、仿真/合成数据及模型编排已有不同设定的研究；可选择其中一条提出可测里程碑，如保留场景成功率、人工介入率与每次成功成本，并解释失败时的替代方案。', '先定义要解决的任务、成本和可靠性目标，再区分已发表结果、尚待验证的假设与自己的路线选择。示教预训练、RL 后训练、仿真/合成数据及模型编排已有不同设定的研究；可选择其中一条提出可测里程碑，如保留场景成功率、人工介入率与每次成功成本，并解释失败时的替代方案。',
   null, null, '["不要把发布演示称为普遍 SOTA，也不要给无人数据飞轮或世界模型落地写确定年份", "预印本结论只能在其任务、接口和预算下比较。"]'::jsonb, null, 8, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"开放题与系统设计","qid":"Q37","freq_label":"🔥×5","provenance":"核验：[RECAP 原论文](https://arxiv.org/abs/2511.14759)、[PyRUA-Lean 原论文](https://arxiv.org/abs/2610.01939)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000297', '你认为具身智能当前最难突破的工程瓶颈是什么？怎么理解？', 'eaq-v05-q38', 'knowledge', 'medium', '围绕具体系统选瓶颈，给出测量：数据覆盖看保留场景与失败簇；',
   '围绕具体系统选瓶颈，给出测量：数据覆盖看保留场景与失败簇；实时性看观测年龄和延迟分位数；长程可靠性看完成率、恢复率、人工介入与失败步骤。再设计单因素改进或消融，报告成本和剩余限制。数据、模型、控制、硬件和系统集成都可能成为主要约束。', '围绕具体系统选瓶颈，给出测量：数据覆盖看保留场景与失败簇；实时性看观测年龄和延迟分位数；长程可靠性看完成率、恢复率、人工介入与失败步骤。再设计单因素改进或消融，报告成本和剩余限制。数据、模型、控制、硬件和系统集成都可能成为主要约束。',
   null, null, '["不能用未经测量的演示数量、采集工时或“当前最好系统成功率”充当行业事实", "算力和带宽也可能是真实瓶颈，不能先验排除。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"开放题与系统设计","qid":"Q38","freq_label":"🔥×4","provenance":"核验：[Thea 机器人 Harness 报告](https://eit-hai.github.io/thea/index.html)、[OpenVLA-OFT 项目](https://openvla-oft.github.io/)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000298', '如何向非 AI 背景的机械 / 电气 / 产品同学解释 VLA 的局限性？跨部门沟通的要点是什么？', 'eaq-v05-q39', 'knowledge', 'medium', '按协作者关心的指标解释：机械侧谈可达空间、负载、接触和实测精度；',
   '按协作者关心的指标解释：机械侧谈可达空间、负载、接触和实测精度；电气/控制侧明确指令类型、单位、时间戳、超时与停止语义；产品侧给出已验证任务、环境、失败模式及人工介入条件。用成功和失败样例、接口文档及同一验收集建立共同预期。', '按协作者关心的指标解释：机械侧谈可达空间、负载、接触和实测精度；电气/控制侧明确指令类型、单位、时间戳、超时与停止语义；产品侧给出已验证任务、环境、失败模式及人工介入条件。用成功和失败样例、接口文档及同一验收集建立共同预期。',
   null, null, '["VLA 没有通用的毫米精度、100ms 延迟或成功率", "数字必须附具体本体、任务、版本与测试条件。“可继续采数据训练”也不等于上线后会自动学会。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"开放题与系统设计","qid":"Q39","freq_label":"🔥×3","provenance":"核验：[Helix 02 官方说明](https://www.figure.ai/news/helix-02)、[ROS 2 实时系统设计](https://design.ros2.org/articles/realtime_background.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000299', 'Agent 的 Harness 应承担哪些职责，怎样与模型分工？', 'eaq-v05-q40', 'knowledge', 'medium', '模型负责给出候选决策；',
   '模型负责给出候选决策；Harness 管理工具发现与调用、上下文、任务状态、执行循环、权限与预算，并记录可复查的运行轨迹。按可测试接口拆开，模型或工具替换时仍能定位失败。若连接机器人，还要把状态观测、动作执行和任务完成验证接入闭环。', '模型负责给出候选决策；Harness 管理工具发现与调用、上下文、任务状态、执行循环、权限与预算，并记录可复查的运行轨迹。按可测试接口拆开，模型或工具替换时仍能定位失败。若连接机器人，还要把状态观测、动作执行和任务完成验证接入闭环。',
   null, null, '["Harness 没有唯一固定分层", "不能把换一段提示词等同于已经实现可靠的执行系统。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q40","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0bf23431c64b495ea22deefc575c1034?sourceSSR=dynamic)；具身企业前端／平台岗，非机器人策略算法岗；原帖创建 2026-09-03（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Thea 机器人 Harness 报告](https://eit-hai.github.io/thea/index.html)、[LangGraph 工作流与 Agent](https://docs.langchain.com/oss/python/langgraph/workflows-agents)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000300', '怎样定义工具输入、返回结果和失败信息，便于 Agent 正确使用？', 'eaq-v05-q41', 'knowledge', 'medium', '输入用明确的类型、单位、必填项和约束，并在运行时验证；',
   '输入用明确的类型、单位、必填项和约束，并在运行时验证；返回区分业务结果、执行状态和结构化错误，附请求标识与必要证据。说明超时、取消、重复调用和重试语义；工具描述告诉模型何时适用，运行时负责实际检查。', '输入用明确的类型、单位、必填项和约束，并在运行时验证；返回区分业务结果、执行状态和结构化错误，附请求标识与必要证据。说明超时、取消、重复调用和重试语义；工具描述告诉模型何时适用，运行时负责实际检查。',
   null, null, '["JSON 合法或工具调用成功不等于业务目标完成", "运动指令已接收也不证明物体已经抓稳。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q41","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0bf23431c64b495ea22deefc575c1034?sourceSSR=dynamic)；具身企业前端／平台岗，非机器人策略算法岗；原帖创建 2026-09-03（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[MCP 工具规范](https://modelcontextprotocol.io/specification/2026-07-28/server/tools)、[Thea 机器人 Harness 报告](https://eit-hai.github.io/thea/index.html)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000301', '短期上下文与长期记忆各存什么，怎样控制增长和错误传播？', 'eaq-v05-q42', 'knowledge', 'medium', '短期状态保存当前目标、已执行步骤、最近观测与待解决问题；',
   '短期状态保存当前目标、已执行步骤、最近观测与待解决问题；长期记忆保存跨任务可复用且有来源的信息。用结构化摘要、按需检索和过期策略限制上下文，保留来源、时间与版本。写入前验证，发现冲突时重新观测或查询，而非把旧摘要直接当事实。', '短期状态保存当前目标、已执行步骤、最近观测与待解决问题；长期记忆保存跨任务可复用且有来源的信息。用结构化摘要、按需检索和过期策略限制上下文，保留来源、时间与版本。写入前验证，发现冲突时重新观测或查询，而非把旧摘要直接当事实。',
   null, null, '["长期记忆不必全放向量库", "模型猜测、工具错误和已经过期的机器人位置不应自动升级为可信记忆。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q42","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0bf23431c64b495ea22deefc575c1034?sourceSSR=dynamic)；具身企业前端／平台岗，非机器人策略算法岗；原帖创建 2026-09-03（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[LangGraph 记忆说明](https://docs.langchain.com/oss/python/concepts/memory)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000302', 'ReAct 和先规划再执行的 Agent，应该怎样选择与组合？', 'eaq-v05-q43', 'knowledge', 'medium', 'ReAct 根据当前信息选择动作，再用观测决定下一步，适合执行中不断获得新信息；',
   'ReAct 根据当前信息选择动作，再用观测决定下一步，适合执行中不断获得新信息；先规划再执行先形成子任务及依赖，再交给执行器，便于跟踪长任务。实际可先规划、逐步执行，在前置条件不成立或结果偏离时局部修订计划。', 'ReAct 根据当前信息选择动作，再用观测决定下一步，适合执行中不断获得新信息；先规划再执行先形成子任务及依赖，再交给执行器，便于跟踪长任务。实际可先规划、逐步执行，在前置条件不成立或结果偏离时局部修订计划。',
   null, null, '["先规划不意味着计划必须一路不变", "观测也不能只读模型自己的文字总结，应保留工具和环境反馈。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q43","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0bf23431c64b495ea22deefc575c1034?sourceSSR=dynamic)；具身企业前端／平台岗，非机器人策略算法岗；原帖创建 2026-09-03（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[LangGraph 工作流与 Agent](https://docs.langchain.com/oss/python/langgraph/workflows-agents)、[ReAct 原论文](https://arxiv.org/abs/2210.03629)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000303', '怎样让 Agent 的调用—观测循环及时结束，避免卡死和反复调用？', 'eaq-v05-q44', 'knowledge', 'medium', '每轮记录目标、调用及结果，由明确的完成条件决定成功退出；',
   '每轮记录目标、调用及结果，由明确的完成条件决定成功退出；另设步数、时间、token 和重试预算。对重复动作、状态无进展、连续失败及观测缺失做检测，触发恢复、降级或失败退出。日志要能区分模型决策问题与工具一直未完成。', '每轮记录目标、调用及结果，由明确的完成条件决定成功退出；另设步数、时间、token 和重试预算。对重复动作、状态无进展、连续失败及观测缺失做检测，触发恢复、降级或失败退出。日志要能区分模型决策问题与工具一直未完成。',
   null, null, '["“模型说完成”不是充分验收", "预算耗尽应报告未完成，不能当成任务成功。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q44","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0bf23431c64b495ea22deefc575c1034?sourceSSR=dynamic)；具身企业前端／平台岗，非机器人策略算法岗；原帖创建 2026-09-03（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Thea 机器人 Harness 报告](https://eit-hai.github.io/thea/index.html)、[LangGraph 工作流与 Agent](https://docs.langchain.com/oss/python/langgraph/workflows-agents)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000304', '什么情况下需要 Agent，什么时候把查询流程沉淀成脚本或工具？', 'eaq-v05-q45', 'knowledge', 'medium', '先判断输入和执行路径是否稳定。',
   '先判断输入和执行路径是否稳定。可枚举、可验证的固定流程优先编码为工具或工作流；需要结合新上下文选择工具、调整步骤时再引入 Agent。把反复成功的查询封装成有契约的可测试工具，保留参数化和失败处理，让 Agent 负责选择与组合。', '先判断输入和执行路径是否稳定。可枚举、可验证的固定流程优先编码为工具或工作流；需要结合新上下文选择工具、调整步骤时再引入 Agent。把反复成功的查询封装成有契约的可测试工具，保留参数化和失败处理，让 Agent 负责选择与组合。',
   null, null, '["沉淀工具不是照搬一次聊天记录", "应剥离临时状态、硬编码凭据和偶然成功的假设，并用回归用例验证。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q45","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/aa9d624ef29445b6b62ae2aa25695b2f?sourceSSR=dynamic)；具身企业全栈／平台岗，非机器人策略算法岗；原帖创建 2026-08-13，编辑/展示 2026-08-28（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[LangGraph 工作流与 Agent](https://docs.langchain.com/oss/python/langgraph/workflows-agents)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000305', '高层已经生成 plan，落到机器人关节动作还需要哪些接口与反馈？', 'eaq-v05-q46', 'knowledge', 'medium', '先把目标绑定到可观测对象和状态，检查技能前置条件；',
   '先把目标绑定到可观测对象和状态，检查技能前置条件；技能或策略生成末端目标、关节目标或轨迹，按输出类型接入适配器、必要的运动规划／IK 与控制器执行。回传执行进度、异常和新观测，并独立检查目标是否达成，失败时重新规划或恢复。', '先把目标绑定到可观测对象和状态，检查技能前置条件；技能或策略生成末端目标、关节目标或轨迹，按输出类型接入适配器、必要的运动规划／IK 与控制器执行。回传执行进度、异常和新观测，并独立检查目标是否达成，失败时重新规划或恢复。',
   null, null, '["任务规划的“抓杯子”、末端目标和电机命令是不同抽象层", "具体系统可合并部分环节，但接口、坐标系与完成语义必须明确。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q46","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/aa9d624ef29445b6b62ae2aa25695b2f?sourceSSR=dynamic)；具身企业全栈／平台岗；问题明确涉及机器人执行；原帖创建 2026-08-13，编辑/展示 2026-08-28（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Thea 机器人 Harness 报告](https://eit-hai.github.io/thea/index.html)、[PyRUA-Lean 原论文](https://arxiv.org/abs/2610.01939)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000306', 'Agent 项目如何报告功能测试成功率，避免只展示成功样例？', 'eaq-v05-q47', 'knowledge', 'medium', '先定义一个完整任务何时成功，固定测试集、工具环境、模型／提示词版本和调用预算，按任务统计成功、失败和超时。',
   '先定义一个完整任务何时成功，固定测试集、工具环境、模型／提示词版本和调用预算，按任务统计成功、失败和超时。除成功率外记录完成时间、调用成本及失败类别；重复随机运行时说明次数和聚合方式，保留失败轨迹。迭代与最终验收使用分开的样本。', '先定义一个完整任务何时成功，固定测试集、工具环境、模型／提示词版本和调用预算，按任务统计成功、失败和超时。除成功率外记录完成时间、调用成本及失败类别；重复随机运行时说明次数和聚合方式，保留失败轨迹。迭代与最终验收使用分开的样本。',
   null, null, '["工具返回率、单步正确率和端到端任务成功率不同", "不能让同一个模型的自评代替可验证结果，也不能挑最好一次代表全部。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q47","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/90412c695d64469699c0e1d05f7fd153)；具身企业数据引擎岗；原问为数据分析 Agent 项目；原帖创建 2026-09-04，编辑/展示 2026-09-09（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Thea 机器人 Harness 报告](https://eit-hai.github.io/thea/index.html)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000307', 'MCP 与 Skill 解决的问题有什么不同，能怎样一起使用？', 'eaq-v05-q48', 'knowledge', 'medium', 'MCP 规范客户端与服务端发现和调用工具等能力的交互；',
   'MCP 规范客户端与服务端发现和调用工具等能力的交互；Skill 通常把任务说明、流程和可复用资源组织成可加载的能力包。Skill 可以指导何时调用 MCP 暴露的工具，工具执行仍经过宿主运行时。比较时先约定这里的 Skill 指哪种实现。', 'MCP 规范客户端与服务端发现和调用工具等能力的交互；Skill 通常把任务说明、流程和可复用资源组织成可加载的能力包。Skill 可以指导何时调用 MCP 暴露的工具，工具执行仍经过宿主运行时。比较时先约定这里的 Skill 指哪种实现。',
   null, null, '["注册了工具不等于模型一定会正确选择", "Skill 文本也不自动赋予权限或保证步骤执行顺序。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q48","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0710cc2eecc9444299dc38be78de3f76)；具身企业平台开发岗；与千寻全栈二面同一求职流程；原帖创建 2026-08-08，编辑/展示 2026-08-26（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[MCP 工具规范](https://modelcontextprotocol.io/specification/2026-07-28/server/tools)、[Agent Skills 规范](https://agentskills.io/specification)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000308', 'Skill 只写在文本里，怎样判断并约束 Agent 是否遵循流程？', 'eaq-v05-q49', 'knowledge', 'medium', '将必须满足的条件落实为运行时校验、状态机或工作流门控，文本负责解释目的和可选策略；',
   '将必须满足的条件落实为运行时校验、状态机或工作流门控，文本负责解释目的和可选策略；每一步记录输入、调用、结果和状态转移，用正常与异常用例做回归。允许偏离的部分预先界定，例如工具等价替换；关键前置条件与验收要求不能仅靠模型自觉。', '将必须满足的条件落实为运行时校验、状态机或工作流门控，文本负责解释目的和可选策略；每一步记录输入、调用、结果和状态转移，用正常与异常用例做回归。允许偏离的部分预先界定，例如工具等价替换；关键前置条件与验收要求不能仅靠模型自觉。',
   null, null, '["提示词遵循率不是执行保证", "把所有偏离都视为错误也会损失灵活性，需区分硬约束和可调整步骤。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q49","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0710cc2eecc9444299dc38be78de3f76)；具身企业平台开发岗；与千寻全栈二面同一求职流程；原帖创建 2026-08-08，编辑/展示 2026-08-26（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Agent Skills 规范](https://agentskills.io/specification)、[LangGraph 工作流与 Agent](https://docs.langchain.com/oss/python/langgraph/workflows-agents)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000309', '多 Agent 之间怎样交接上下文，减少信息丢失和状态冲突？', 'eaq-v05-q50', 'knowledge', 'medium', '把任务标识、目标、已确认事实、待办、工具结果引用和版本组成显式交接状态；',
   '把任务标识、目标、已确认事实、待办、工具结果引用和版本组成显式交接状态；必要上下文随任务传递，大文件与长轨迹按引用读取。区分共享状态与各 Agent 的局部上下文，对并行更新规定所有权或合并规则，交接后检查关键信息是否齐全。', '把任务标识、目标、已确认事实、待办、工具结果引用和版本组成显式交接状态；必要上下文随任务传递，大文件与长轨迹按引用读取。区分共享状态与各 Agent 的局部上下文，对并行更新规定所有权或合并规则，交接后检查关键信息是否齐全。',
   null, null, '["共享同一个长聊天记录不等于状态一致", "摘要可能漏约束，旧版本结果也不能直接覆盖较新的执行事实。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q50","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/1d05dbe48b314a81804c2ffdd51ab569)；具身企业 Agent 平台开发岗，非机器人策略算法岗；原帖创建 2026-08-05，编辑/展示 2026-08-26（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[LangGraph 记忆说明](https://docs.langchain.com/oss/python/concepts/memory)、[RegenHarness 原论文](https://arxiv.org/abs/2609.27612)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000310', 'Agent 工具失败时怎样维护状态、分类错误并决定是否重试？', 'eaq-v05-q51', 'knowledge', 'medium', '先记录实际已发生的操作及当前状态。',
   '先记录实际已发生的操作及当前状态。连接超时等暂态故障可在预算内退避重试；参数或权限错误应先修正条件；副作用是否发生不明时先查询确认。写操作采用请求标识和去重机制，不能保证幂等的动作需要恢复策略，失败记录要进入追踪与回归。', '先记录实际已发生的操作及当前状态。连接超时等暂态故障可在预算内退避重试；参数或权限错误应先修正条件；副作用是否发生不明时先查询确认。写操作采用请求标识和去重机制，不能保证幂等的动作需要恢复策略，失败记录要进入追踪与回归。',
   null, null, '["超时不代表操作没发生", "重复运动或重复写入可能产生额外副作用，不能把“全部重试三次”当通用容错。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：Agent / Harness / 平台","qid":"Q51","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/1d05dbe48b314a81804c2ffdd51ab569)；具身企业 Agent 平台开发岗，非机器人策略算法岗；原帖创建 2026-08-05，编辑/展示 2026-08-26（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[MCP 工具规范](https://modelcontextprotocol.io/specification/2026-07-28/server/tools)、[RegenHarness 原论文](https://arxiv.org/abs/2609.27612)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000311', 'DDP 在 epoch 中途恢复训练，怎样尽量延续原来的采样顺序？', 'eaq-v05-q52', 'knowledge', 'medium', '除模型外，保存优化器、调度器、随机数、训练步与梯度累积状态，以及各 rank 的 sampler／dataset／DataLoader 进度。',
   '除模型外，保存优化器、调度器、随机数、训练步与梯度累积状态，以及各 rank 的 sampler／dataset／DataLoader 进度。分片、种子、shuffle epoch 和数据版本必须对应。可用 StatefulDataLoader 保存迭代状态，但仍需各 rank 协调；恢复后按 sampler 的补齐／丢尾规则核对样本 ID。', '除模型外，保存优化器、调度器、随机数、训练步与梯度累积状态，以及各 rank 的 sampler／dataset／DataLoader 进度。分片、种子、shuffle epoch 和数据版本必须对应。可用 StatefulDataLoader 保存迭代状态，但仍需各 rank 协调；恢复后按 sampler 的补齐／丢尾规则核对样本 ID。',
   null, null, '["只保存 batch 下标或调用 set_epoch 不够", "worker 预取、随机增强、world size 改动都会影响复现，不能无条件保证逐位一致，也要区分预期的补齐重复与异常重放。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：训练与真机现场","qid":"Q52","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/0f6cc57190264448bf1647dc36de4622)；具身企业通用大模型后训练实习岗，非 VLA 策略后训练专项；原帖创建 2026-02-10（公开 HTML 结构化记录核实）；面试年份未核，属旧帖补缺，非本季度面经证明。\n\n核验：[TorchData StatefulDataLoader](https://github.com/meta-pytorch/data/blob/main/torchdata/stateful_dataloader/README.md)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000312', '机器人运行中一只机械臂突然不动，怎样逐层定位？', 'eaq-v05-q53', 'knowledge', 'medium', '先确认现场安全并保存故障时刻日志；',
   '先确认现场安全并保存故障时刻日志；从急停、安全状态、电源和驱动报警查起，再查总线链路、设备状态与周期数据。沿命令生成、发送、驱动接收、实际反馈逐层比对，检查是否限位、超时或保护触发。用同一时间线关联其他关节和传感器，定位第一处异常。', '先确认现场安全并保存故障时刻日志；从急停、安全状态、电源和驱动报警查起，再查总线链路、设备状态与周期数据。沿命令生成、发送、驱动接收、实际反馈逐层比对，检查是否限位、超时或保护触发。用同一时间线关联其他关节和传感器，定位第一处异常。',
   null, null, '["“模型还在输出”不证明命令已到驱动", "盲目重启会丢失现场，也可能使尚未结束的命令重新生效。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：训练与真机现场","qid":"Q53","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://ac.nowcoder.com/discuss/1710893?type=0)；机器人软件工程岗；原帖为真机现场排查；原帖创建 2026-10-14（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Beckhoff 诊断说明（TwinCAT 示例）](https://infosys.beckhoff.com/content/1033/tcsystemmanager/1089009035.html)、[ROS 2 实时系统设计](https://design.ros2.org/articles/realtime_background.html)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000313', '相机偶发丢帧或没有图像，怎样区分采集、通信和处理故障？', 'eaq-v05-q54', 'knowledge', 'medium', '沿相机采集、驱动缓冲、编码传输、订阅回调到推理消费逐段测帧号、时间戳、频率与队列积压。',
   '沿相机采集、驱动缓冲、编码传输、订阅回调到推理消费逐段测帧号、时间戳、频率与队列积压。先看原始流是否存在，再核对带宽、CPU/GPU 负载、复制和解码开销，以及 ROS 2 QoS 是否兼容。区分采集时间与到达时间，回放复现并关联控制异常。', '沿相机采集、驱动缓冲、编码传输、订阅回调到推理消费逐段测帧号、时间戳、频率与队列积压。先看原始流是否存在，再核对带宽、CPU/GPU 负载、复制和解码开销，以及 ROS 2 QoS 是否兼容。区分采集时间与到达时间，回放复现并关联控制异常。',
   null, null, '["增大缓存可能只把丢帧变成更大延迟", "收到旧图不等于拥有当前观测，重传可靠性也不等于实时性。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"本次公开面经增补：训练与真机现场","qid":"Q54","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://ac.nowcoder.com/discuss/1710893?type=0)；机器人软件工程岗；原帖为相机链路与同步排查；原帖创建 2026-10-14（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[ROS 2 QoS 设计](https://design.ros2.org/articles/qos.html)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000314', '手撕数值稳定 softmax', 'eaq-v05-h01', 'coding', 'easy', '减 max 防 `exp` 溢出；',
   '减 max 防 `exp` 溢出；`keepdim=True` 保证 broadcast 正确；float32 仍可能极端 -inf 输入致除零。', '**考察点**：减 max 防 `exp` 溢出；`keepdim=True` 保证 broadcast 正确；float32 仍可能极端 -inf 输入致除零。

**实现**：

```python
import torch

def softmax_stable(x, dim=-1):
    # 减 max 后所有元素 ≤ 0，exp 不会上溢
    x_max = x.max(dim=dim, keepdim=True).values
    exp_x = (x - x_max).exp()
    # keepdim=True 让 sum 形状与 exp_x 可广播
    return exp_x / exp_x.sum(dim=dim, keepdim=True)
```',
   null, null, '["忘 `keepdim` 致广播错", "全 -inf 输入（如整行 padding）exp=0、sum=0 → 除零，应在 mask 时先过滤。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H01","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000315', '手撕 LogSumExp / log_softmax', 'eaq-v05-h02', 'coding', 'medium', '`log Σ exp(x) = x_max + log Σ exp(x - x_max)`；',
   '`log Σ exp(x) = x_max + log Σ exp(x - x_max)`；log_softmax 必须一步算（不要 `log(softmax(x))`）。', '**考察点**：`log Σ exp(x) = x_max + log Σ exp(x - x_max)`；log_softmax 必须一步算（不要 `log(softmax(x))`）。

**实现**：

```python
import torch

def logsumexp(x, dim=-1):
    x_max = x.max(dim=dim, keepdim=True).values
    # log-sum-exp 标准式：把 max 提出 exp 防上溢
    return x_max.squeeze(dim) + (x - x_max).exp().sum(dim=dim).log()

def log_softmax(x, dim=-1):
    # 等价 x - logsumexp(x)；一步算避免 log(softmax) 在 prob≈0 处 log(0) = -inf
    x_max = x.max(dim=dim, keepdim=True).values
    shifted = x - x_max
    return shifted - shifted.exp().sum(dim=dim, keepdim=True).log()
```',
   null, null, '["用 `log(softmax(x))`", "忘 `keepdim` 致广播错", "float16 下 LSE 仍可能上溢，应用 float32 中间量。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H02","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000316', '手撕 cross-entropy（含数值稳定）', 'eaq-v05-h03', 'coding', 'easy', 'CE = NLL + log_softmax 的组合；',
   'CE = NLL + log_softmax 的组合；padding 用 `ignore_index` 屏蔽；soft label 走另一公式。', '**考察点**：CE = NLL + log_softmax 的组合；padding 用 `ignore_index` 屏蔽；soft label 走另一公式。

**实现**：

```python
import torch
import torch.nn.functional as F

def cross_entropy_hard(logits, target, ignore_index=-100):
    # logits: [B, C]；target: [B]，padding 处填 -100 屏蔽
    log_p = F.log_softmax(logits, dim=-1)        # 一步算，避免 log(softmax)
    nll = -log_p.gather(-1, target.clamp(min=0).unsqueeze(-1)).squeeze(-1)
    mask = (target != ignore_index).float()
    # mean 必须按有效样本数归一，否则 ignore 多时被稀释
    return (nll * mask).sum() / mask.sum().clamp(min=1.0)

def cross_entropy_soft(logits, soft_target):
    # soft_target: [B, C] 概率分布（label smoothing / 蒸馏常用）
    log_p = F.log_softmax(logits, dim=-1)
    return -(soft_target * log_p).sum(-1).mean()
```',
   null, null, '["先 softmax 再 log 数值不稳", "padding 未 mask 拉偏 loss", "`reduction=''mean''` 但分母用 batch 大小（应用有效样本数）。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H03","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000317', '手撕 KL divergence（离散 / 高斯 / forward vs reverse）', 'eaq-v05-h04', 'coding', 'medium', 'KL 不对称（forward mode-covering / reverse mode-seeking）；',
   'KL 不对称（forward mode-covering / reverse mode-seeking）；高斯闭式；`F.kl_div` 首参约定 `log_q`。', '**考察点**：KL 不对称（forward mode-covering / reverse mode-seeking）；高斯闭式；`F.kl_div` 首参约定 `log_q`。

**实现**：

```python
import torch
import torch.nn.functional as F

def kl_discrete(log_p, log_q):
    # 离散 KL(p‖q) = Σ p·(log p - log q)；用 log_prob 入参数值稳
    # p=0 处约定 0·log(0/q)=0；mask 掉 log_p=-inf 项避免 0·inf=NaN
    p = log_p.exp()
    term = p * (log_p - log_q)
    return term.masked_fill(log_p == float(''-inf''), 0.0).sum(-1)

def kl_gauss_to_std(mu, logvar):
    # VAE 特例：KL(N(μ,σ²) ‖ N(0,I)) 闭式
    # 0.5 · Σ(μ² + σ² - 1 - log σ²)
    return 0.5 * (mu.pow(2) + logvar.exp() - 1 - logvar).sum(-1)

def kl_via_F(log_q, p_prob):
    # PyTorch 约定：第一参传 log_q，第二参传 p（prob，非 log）
    # 等价 Σ p·(log p - log q)
    return F.kl_div(log_q, p_prob, reduction=''batchmean'')
```',
   null, null, '["log 用 σ 还是 σ²（差一倍）", "`F.kl_div` 首参传 prob 而非 log_prob", "forward/reverse 方向反", "离散输入 p,q 都用 prob 致 `log(0)`。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H04","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000318', '手撕 mini-batch 训练循环', 'eaq-v05-h05', 'coding', 'easy', '`zero_grad → forward → backward → step` 顺序；',
   '`zero_grad → forward → backward → step` 顺序；梯度累加 + AMP 顺序；推理用 `eval()` + `no_grad()`。', '**考察点**：`zero_grad → forward → backward → step` 顺序；梯度累加 + AMP 顺序；推理用 `eval()` + `no_grad()`。

**实现**：

```python
import torch
from torch.cuda.amp import autocast, GradScaler

def train_epoch(model, loader, opt, crit, device, accum=1):
    model.train()
    scaler = GradScaler()
    opt.zero_grad(set_to_none=True)  # set_to_none 比置 0 更省显存
    for i, (x, y) in enumerate(loader):
        x, y = x.to(device), y.to(device)
        with autocast():
            loss = crit(model(x), y) / accum         # 梯度累加要先除步数
        scaler.scale(loss).backward()                # AMP loss 先 scale 再 backward
        if (i + 1) % accum == 0:
            scaler.step(opt); scaler.update()
            opt.zero_grad(set_to_none=True)          # step 之后清梯度

    # 处理 loader 长度非 accum 整数倍：末尾残余梯度也 step
    if len(loader) % accum != 0:
        scaler.step(opt); scaler.update()
        opt.zero_grad(set_to_none=True)

@torch.no_grad()
def evaluate(model, loader, crit, device):
    model.eval()  # 关 dropout / 停 BN running 更新
    return sum(crit(model(x.to(device)), y.to(device)) for x, y in loader)
```',
   null, null, '["`zero_grad` 漏 → 梯度累加错", "忘 `model.eval()` BN/Dropout 异常", "`no_grad` 没包显存炸", "AMP loss 没 scale。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H05","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000319', '手撕 warmup + cosine 学习率 schedule', 'eaq-v05-h06', 'coding', 'easy', 'warmup 防初始 lr 过大；',
   'warmup 防初始 lr 过大；cosine 末期渐降；边界 `t=t_w` 处 lr 必须连续（=lr_max）。', '**考察点**：warmup 防初始 lr 过大；cosine 末期渐降；边界 `t=t_w` 处 lr 必须连续（=lr_max）。

**实现**：

```python
import math
from torch.optim.lr_scheduler import LambdaLR

def warmup_cosine(opt, t_warm, t_total, min_ratio=0.0):
    # t_total 用 step 数而非 epoch（step 粒度更细）
    def lr_lambda(t):
        if t < t_warm:
            # 线性 warmup：t=0 → 0；t=t_warm → 1（边界连续）
            return float(t) / max(1, t_warm)
        # cosine 末期：t=t_warm → 1；t=t_total → min_ratio
        progress = (t - t_warm) / max(1, t_total - t_warm)
        cos = 0.5 * (1.0 + math.cos(math.pi * progress))
        return min_ratio + (1.0 - min_ratio) * cos
    return LambdaLR(opt, lr_lambda)
```',
   null, null, '["`t_warm=0` 致除零", "`t_total` 用 epoch 数末期未降到底", "warmup 公式从 1 开始致 `t=0` 时 `lr=lr_max`", "边界 `t=t_warm` lr 跳变。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H06","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000320', '手撕 Adam / AdamW 更新规则', 'eaq-v05-h07', 'coding', 'medium', '一阶/二阶 momentum + bias correction；',
   '一阶/二阶 momentum + bias correction；AdamW 解耦 weight decay（不混进 momentum）。', '**考察点**：一阶/二阶 momentum + bias correction；AdamW 解耦 weight decay（不混进 momentum）。

**实现**：

```python
import torch

def adamw_step(params, grads, state, lr=1e-3, betas=(0.9, 0.999),
               eps=1e-8, wd=1e-2):
    # state[i] = {''m'': ..., ''v'': ..., ''t'': int}；外层维护
    b1, b2 = betas
    for p, g, s in zip(params, grads, state):
        s[''t''] += 1
        # 一阶/二阶 momentum 指数滑动
        s[''m''].mul_(b1).add_(g, alpha=1 - b1)
        s[''v''].mul_(b2).addcmul_(g, g, value=1 - b2)
        # bias correction：消除初期 m,v 偏向 0 的偏置
        m_hat = s[''m''] / (1 - b1 ** s[''t''])
        v_hat = s[''v''] / (1 - b2 ** s[''t''])
        # AdamW：weight decay 直接乘 p，不进 m/v
        # （若改为 Adam，把 wd*p 那项加到 g 里、再走主更新即为 L2 正则）
        p.data.mul_(1 - lr * wd).addcdiv_(m_hat, v_hat.sqrt().add_(eps), value=-lr)
```',
   null, null, '["忘 bias correction（初期步太小）", "把 `wd*p` 加到 grad（变 L2 正则非 AdamW）", "`v̂` 算根之前没存独立副本，多组 param 共享 buffer 时被破坏。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H07","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000321', '手撕 dropout（train vs eval + inverted scale）', 'eaq-v05-h08', 'coding', 'easy', 'train 随机置零并 scale；',
   'train 随机置零并 scale；eval 直接通过；inverted dropout 把 `1/(1-p)` 放训练侧让推理零开销。', '**考察点**：train 随机置零并 scale；eval 直接通过；inverted dropout 把 `1/(1-p)` 放训练侧让推理零开销。

**实现**：

```python
import torch
import torch.nn as nn

class Dropout(nn.Module):
    def __init__(self, p=0.5):
        super().__init__()
        assert 0.0 <= p < 1.0
        self.p = p

    def forward(self, x):
        if not self.training or self.p == 0.0:
            return x  # 推理无开销
        # mask ~ Bernoulli(1-p)：保留概率 1-p；用 x.dtype 防 fp16/bf16 被提升
        mask = (torch.rand_like(x) >= self.p).to(x.dtype)
        # inverted dropout：除 (1-p) 让 E[out] = x，无需推理时 scale
        return x * mask / (1.0 - self.p)
```',
   null, null, '["推理还 drop（`F.dropout` 忘传 `training=self.training`）", "忘 scale 致 E[out] 不一致", "位置放错（残差里 dropout 在 add 之后破坏恒等映射）。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"05","volume_title":"卷五 · 工程落地","section":"手撕代码","qid":"H08","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000322', '什么是浮动基座（floating base）？腿足机器人为什么不能直接用固定基座机器人的运动学 / 动力学公式？', 'eaq-v06-q01', 'knowledge', 'easy', '**浮动基座**：躯干在世界坐标系无固定连接，姿态由 6 自由度自由变量描述（3 平动 + 3 旋转），靠脚-地接触约束被动维持位置。',
   '**浮动基座**：躯干在世界坐标系无固定连接，姿态由 6 自由度自由变量描述（3 平动 + 3 旋转），靠脚-地接触约束被动维持位置。', '**浮动基座**：躯干在世界坐标系无固定连接，姿态由 6 自由度自由变量描述（3 平动 + 3 旋转），靠脚-地接触约束被动维持位置。

**与固定基座区别**：
- 固定机械臂：广义坐标 $q \in \mathbb{R}^n$；动力学 $M\ddot q + C\dot q + g = \tau$
- 浮动基座：$q = [q_b, q_j]$，前 6 维基座**无主动驱动**，需接触力"驱动"基座

**实务建模**：base 作 6-DoF 虚拟关节挂到 world，用 Featherstone 浮动基 RNEA / ABA 求解——Pinocchio / Drake / RBDL 都这么做。',
   null, null, '["不要把\"浮动基座\"和\"欠驱动\"混为一谈——浮动基座说的是建模方式，欠驱动说的是控制特性。是否欠驱动取决于接触模型 / 约束秩：飞行相、点足接触、动态步态通常欠驱动", "平足刚性支撑可近似为受约束全驱动。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q01","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000323', '雅可比矩阵在腿足机器人里的作用？接触雅可比和任务空间雅可比的区别？', 'eaq-v06-q02', 'knowledge', 'medium', '雅可比 $J(q)$ 把广义速度映射到笛卡尔速度。',
   '雅可比 $J(q)$ 把广义速度映射到笛卡尔速度。腿足里两类雅可比：', '雅可比 $J(q)$ 把广义速度映射到笛卡尔速度。腿足里两类雅可比：

| | 接触雅可比 $J_c$ | 任务雅可比 $J_t$ |
|---|---|---|
| 作用 | 把接触力反向映射到广义力 $\tau_c = J_c^\top \lambda$ | 描述足端 / 质心 / 躯干姿态速度 |
| 用途 | 浮动基座动力学约束 / MPC 摩擦锥 | WBC / OSC 跟踪目标 |

**关键约束**：脚不滑时 $J_c \dot{q} = 0$；微分得 $J_c \ddot{q} + \dot{J}_c \dot{q} = 0$，是 WBC 等式约束的标准形式。',
   null, null, '["浮动基座的雅可比形状是 $J \\in \\mathbb{R}^{m \\times (6+n_j)}$，前 6 列对应 base——不要只对关节求导", "两类雅可比都必须包含 base 部分才能在浮动基座下成立。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q02","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000324', '摩擦锥 friction cone 是什么？为什么在 MPC / WBC 里通常做成线性化金字塔约束？', 'eaq-v06-q03', 'knowledge', 'medium', '**摩擦锥**：地面接触力的物理可行域，约束法向力 $f_n \ge 0$（不能拉脚）和切向力 $|f_t| \le \mu f_n$（库伦摩擦不滑）。',
   '**摩擦锥**：地面接触力的物理可行域，约束法向力 $f_n \ge 0$（不能拉脚）和切向力 $|f_t| \le \mu f_n$（库伦摩擦不滑）。几何上是一个以法向为轴、半角 $\arctan\mu$ 的圆锥。', '**摩擦锥**：地面接触力的物理可行域，约束法向力 $f_n \ge 0$（不能拉脚）和切向力 $|f_t| \le \mu f_n$（库伦摩擦不滑）。几何上是一个以法向为轴、半角 $\arctan\mu$ 的圆锥。

**为什么线性化**：原始摩擦锥是二阶圆锥约束（SOCP），求解器慢；常用 4 边或 8 边金字塔近似，把约束变成**4 / 8 条线性不等式**，整个优化变成 QP，OSQP / qpOASES 这类 QP 求解器可以 < 1 ms 解。

**线性化代价**：4 边**内接**金字塔保守（切平面面积比圆锥小约 36%）但**安全**——不会让机器人违反真实摩擦；8 边内接更贴近圆锥；**外接矩形**（$|f_x|, |f_y| \le \mu f_z$）反而**不保守**，角点会超出圆锥。生产里 4 / 8 边内接是常见取舍。',
   null, null, '["摩擦锥约束 $|f_t| \\le \\mu f_n$ 是非线性的，不是简单 $|f_t| \\le \\mu f_{n,\\max}$", "不要在写 QP 时把 $f_n$ 当常数。MIT Cheetah Convex MPC 通过同时把法向力和切向力作为决策变量、配合金字塔近似，把整个问题变 QP。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q03","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000325', '质心动力学（centroidal dynamics）和单刚体模型（SRBM）有什么区别？为什么 MPC 常用 SRBM？', 'eaq-v06-q04', 'knowledge', 'medium', '两者都是**简化模型**，但抽象层次不同。',
   '两者都是**简化模型**，但抽象层次不同：', '两者都是**简化模型**，但抽象层次不同：

| | 单刚体模型 SRBM | 质心动力学 |
|---|---|---|
| 假设 | 把整机当一个刚体，惯量矩阵常数 | 用整机的质心动量 $h_G$ 描述系统状态 |
| 状态 | 质心位置 / 姿态 / 速度 / 角速度 | 线动量 + 角动量 + 质心位置 |
| 输入 | 各支撑足的接触力 $f_i$ | 同上（接触力直接产生动量变化率） |
| 用途 | MIT Cheetah 凸 MPC、Convex MPC | 更精细的 NMPC / WBC 内的质心任务 |

**为什么 MPC 偏爱 SRBM**：① 假设腿质量小 + 惯量近似常数后整个动力学**变线性**；② 加上摩擦锥金字塔近似后整个问题是 QP，可 100-500 Hz 解；③ 实测在四足上效果已经够好。',
   null, null, '["SRBM **忽略了腿的惯量**——快速摆腿时会有几个百分点的建模误差", "高动态任务（跳跃、奔跑）需要全身动力学或质心动力学补偿。质心动力学不等同于 SRBM，前者是更通用的降阶表达。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q04","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000326', '什么是 ZMP（零力矩点）？和 CoP、Capture Point、DCM 是什么关系？', 'eaq-v06-q05', 'knowledge', 'easy', '**ZMP（Zero Moment Point）**：地面上一个虚拟点，绕该点地面反力对水平面的力矩为零。',
   '**ZMP（Zero Moment Point）**：地面上一个虚拟点，绕该点地面反力对水平面的力矩为零。**当 ZMP 严格落在支撑多边形内**，机器人不会绕支撑边沿翻倒；落到边沿则机器人即将倒下。', '**ZMP（Zero Moment Point）**：地面上一个虚拟点，绕该点地面反力对水平面的力矩为零。**当 ZMP 严格落在支撑多边形内**，机器人不会绕支撑边沿翻倒；落到边沿则机器人即将倒下。

**几个概念对比**：
- **CoP（压力中心）**：实际地面反力的"加权重心"。**ZMP = CoP 当 ZMP 落在支撑多边形内**；落出去 ZMP 不再有物理意义，CoP 仍在边界上
- **Capture Point**：机器人当前状态下，若立即把脚踩到该点上，就能在不再迈步的情况下回到静止
- **DCM（Divergent Component of Motion）**：质心动量的发散分量，是 Capture Point 的通用化连续形式；DCM 轨迹规划可以反推质心 + 落脚点

**应用**：传统人形（ASIMO/HRP）用 ZMP 离线规划质心轨迹；现代人形多用 DCM / Capture Point 做在线规划，对扰动响应更快。',
   null, null, '["ZMP 是静态稳定性判据，对快速动态（如跑步飞行相）失效——飞行相没有 ZMP，需要质心动量守恒分析。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q05","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000327', 'Pinocchio / Drake / RBDL 这几个动力学库各自的定位？为什么腿足机器人圈 Pinocchio 最常用？', 'eaq-v06-q06', 'knowledge', 'medium', '| 库 | 定位 | 优势 | 劣势 |',
   '| 库 | 定位 | 优势 | 劣势 |
|---|---|---|---|
| **Pinocchio** | Featherstone 体系 C++ / Python | 浮动基座原生支持；ABA / RNEA / CRBA 全有；**解析微分**；快（约 1 µs 操作臂 / 3 µs 腿足） | 学习曲线陡 |
| **Drake** | TRI / MIT 大库 | 内建优化（MathematicalProgram）/ 仿真 / 控制一体 | 体量大、编译复杂 |
| **RBDL** | 轻量 C++ 实现 | 与 Featherstone 书完全对齐，易学 | 工具链生态弱 |', '| 库 | 定位 | 优势 | 劣势 |
|---|---|---|---|
| **Pinocchio** | Featherstone 体系 C++ / Python | 浮动基座原生支持；ABA / RNEA / CRBA 全有；**解析微分**；快（约 1 µs 操作臂 / 3 µs 腿足） | 学习曲线陡 |
| **Drake** | TRI / MIT 大库 | 内建优化（MathematicalProgram）/ 仿真 / 控制一体 | 体量大、编译复杂 |
| **RBDL** | 轻量 C++ 实现 | 与 Featherstone 书完全对齐，易学 | 工具链生态弱 |

**为什么 Pinocchio 主流**：① 速度最快（HPP 项目优化十年）；② **解析雅可比 + 解析微分** 让上层 MPC / WBC 的代价梯度可以闭式得到，比数值差分稳定；③ TSID / Crocoddyl 等主流腿足栈都以 Pinocchio 为基；④ Python 绑定方便快速原型。',
   null, null, '["KDL（ROS 自带）**不支持浮动基座**——只能做固定基机械臂，所以 ROS 默认动力学库在腿足圈基本用不上。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q06","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000328', 'RNEA、CRBA、ABA 三种动力学算法各自解决什么问题？复杂度怎么样？', 'eaq-v06-q07', 'knowledge', 'medium', '刚体动力学三大经典算法（Featherstone）。',
   '刚体动力学三大经典算法（Featherstone）：', '刚体动力学三大经典算法（Featherstone）：

| 算法 | 问题 | 复杂度 | 用途 |
|---|---|---|---|
| **RNEA** | 逆动力学 $\tau = f(q, \dot{q}, \ddot{q})$ | $O(n)$ | WBC 控制律 |
| **CRBA** | 求质量矩阵 $M(q)$ | $O(n^2)$ | KKT 系统 / 解析微分 |
| **ABA** | 正动力学 $\ddot{q} = f(q, \dot{q}, \tau)$ | $O(n)$ | 仿真器内核 |

**三件套关系**：WBC 需要 $M$（CRBA）+ 逆动力学算力矩（RNEA）；仿真器要正推状态（ABA）。',
   null, null, '["RNEA 是**逆动力学**——给加速度算力矩，不是反过来", "常见误用。复杂度 $n$ 是连杆数", "腿足 30 关节场景下三者实测都在 µs 级。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"浮动基座 / 动力学 / 接触建模","qid":"Q07","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000329', 'MIT Cheetah 提出的 Convex MPC 怎么把腿足运动控制问题做成凸优化？', 'eaq-v06-q08', 'knowledge', 'easy', 'MIT Carlo & Wensing 2018 的 Convex MPC（应用于 Cheetah 3）做了几个关键近似把非凸 NMPC 化简到 QP。',
   'MIT Carlo & Wensing 2018 的 Convex MPC（应用于 Cheetah 3）做了几个关键近似把非凸 NMPC 化简到 QP：', 'MIT Carlo & Wensing 2018 的 Convex MPC（应用于 Cheetah 3）做了几个关键近似把非凸 NMPC 化简到 QP：

1. **单刚体模型 SRBM**：忽略腿质量，整机当一个固定惯量的刚体
2. **小角度假设**：在 hover frame 里把 roll/pitch 当小量，旋转动力学 $I\dot{\omega} = \tau - \omega \times I\omega$ 中的 $\omega \times I\omega$ 项忽略（线性化）
3. **接触序列预先给定**：哪只脚什么时间落地由 gait scheduler 输出，不作为决策变量，避免组合优化
4. **摩擦锥金字塔近似**：4-边线性化（见 Q03）

化简后状态线性、约束线性、代价二次，是标准 QP；用 dense QP 求解器约 1 ms 内可解，30 Hz 跑实时，时域 0.5 s / 10-16 步。',
   null, null, '["原论文 30 Hz 是 MPC 重规划频率，**底层关节力矩控制器跑 1 kHz 甚至更高**——别把 MPC 频率和电机控制频率混为一谈。"]'::jsonb, null, 3, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q08","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000330', 'MPC 的预测时域 / 控制时域怎么选？为什么腿足 MPC 一般 0.3-0.5 s、10-20 个时步？', 'eaq-v06-q09', 'knowledge', 'medium', '选时域的两个权衡。',
   '选时域的两个权衡：', '选时域的两个权衡：

- **太短**：看不到未来一个完整步态周期，控制器决策短视（脚还没落地就结束）
- **太长**：① 模型误差累积；② QP 规模 $\propto$ 时步数，10 步 vs 30 步求解时间差 5-10 倍

**腿足实务**：典型步态周期 0.3-0.5 s，覆盖 1-2 个完整周期最佳，于是 10-20 步、每步 25-50 ms。MIT Cheetah 论文用 0.5 s / 16 步 / 30 Hz，是一个长期被沿用的配方。

**控制时域 vs 预测时域**：MPC 标准定义中"控制时域 ≤ 预测时域"——预测时域看远，控制时域内的控制变量做决策变量；腿足里通常**两者相等**简化实现。',
   null, null, '["不要假设\"时域越长越好\"——长时域要求模型在 0.5 s 内仍准确，超过这个时间 SRBM 误差会显著上升。NMPC（非线性 MPC）可以用更长时域（1 s+），但算力代价大。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q09","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000331', 'MPC 求解器对比：OSQP vs qpOASES vs HPIPM，腿足实时控制怎么选？', 'eaq-v06-q10', 'knowledge', 'medium', '| 求解器 | 算法 | 优势 | 劣势 |',
   '| 求解器 | 算法 | 优势 | 劣势 |
|---|---|---|---|
| **OSQP** | ADMM | 稀疏问题快、warm-start 好、BSD 开源 | 一阶，迭代多 |
| **qpOASES** | active-set | 中小问题快、解精确 | 不适合超大稀疏 |
| **HPIPM** | 内点 + Riccati | 对 MPC 时序结构最优 | 接口较复杂 |', '| 求解器 | 算法 | 优势 | 劣势 |
|---|---|---|---|
| **OSQP** | ADMM | 稀疏问题快、warm-start 好、BSD 开源 | 一阶，迭代多 |
| **qpOASES** | active-set | 中小问题快、解精确 | 不适合超大稀疏 |
| **HPIPM** | 内点 + Riccati | 对 MPC 时序结构最优 | 接口较复杂 |

**腿足典型选择**：四足 Convex MPC → OSQP / qpOASES 都 < 1 ms；人形 30 自由度 WBC → HPIPM / ProxQP 适配 MPC 时序；嵌入式 → 自研 ADMM。

**实务**：先用 OSQP（开源、接口干净），延迟不达再换 HPIPM。',
   null, null, '["OSQP 是一阶方法，对 ill-conditioned 问题收敛慢——MPC 代价矩阵尺度差异大时要先做预处理 / 缩放。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q10","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000332', 'PID、LQR、MPC 与 RL 在腿足控制中的定位和取舍是什么？', 'eaq-v06-q11', 'knowledge', 'medium', 'PID 以误差反馈实现局部跟踪；',
   'PID 以误差反馈实现局部跟踪；LQR 在给定线性模型和二次代价下计算反馈增益；MPC 滚动优化有限时域，可显式处理接触力、摩擦与状态约束。腿足也广泛研究 RL 策略，既可输出关节目标，也可与模型控制结合。选型要看模型误差、算力、接触变化、训练覆盖及安全要求。', 'PID 以误差反馈实现局部跟踪；LQR 在给定线性模型和二次代价下计算反馈增益；MPC 滚动优化有限时域，可显式处理接触力、摩擦与状态约束。腿足也广泛研究 RL 策略，既可输出关节目标，也可与模型控制结合。选型要看模型误差、算力、接触变化、训练覆盖及安全要求。',
   null, null, '["不能说“四足都用 MPC”或“PID 只能用于最低层”。MPC 的约束优势不代表所有问题都能在固定 1 ms 内求解，LQR 也有有限时域形式。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q11","freq_label":"🔥×4","provenance":"核验：[MIT Convex MPC 论文](https://dspace.mit.edu/entities/publication/bc8c7e1e-5830-443f-a879-787947111fcf)、[大规模并行腿足 RL 论文](https://proceedings.mlr.press/v164/rudin22a/rudin22a.pdf)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000333', '接触时序（contact schedule / gait scheduler）在 MPC 里是怎么编码进去的？热切换怎么避免抖动？', 'eaq-v06-q12', 'knowledge', 'medium', '**接触时序**：一个 0/1 矩阵 $s_i^k$，表示第 $k$ 个 MPC 时步、第 $i$ 只脚是否接触地面。',
   '**接触时序**：一个 0/1 矩阵 $s_i^k$，表示第 $k$ 个 MPC 时步、第 $i$ 只脚是否接触地面。Convex MPC 把它**预先给定**（gait scheduler 输出），不作为优化变量，这才能保持凸性。', '**接触时序**：一个 0/1 矩阵 $s_i^k$，表示第 $k$ 个 MPC 时步、第 $i$ 只脚是否接触地面。Convex MPC 把它**预先给定**（gait scheduler 输出），不作为优化变量，这才能保持凸性。

**怎么用**：
- $s_i^k = 1$（支撑相）：摩擦锥 + 力上限约束生效；摆动相约束变为 $f_i^k = 0$
- 与 swing-leg 控制器协作：摆动期 $f_i^k = 0$，足端轨迹由独立的 swing leg 控制器（如五次多项式插值）执行

**避免抖动**：① 落地 / 离地切换瞬间，QP 解会有跳变 → **力的差分项**加入代价（$\| f^{k+1} - f^k \|^2$）；② 接触序列由 finite state machine 维护，不允许中途修改；③ 接触检测用低通滤波 + 滞回。',
   null, null, '["步态切换时（如 trot → bound）整张时序表会重写，热切换需要把\"未来 0.3 s\"的接触模式一次性更新，否则 MPC 看着旧时序解出错误力。生产代码里通常做\"phase 锁定\"，切换在某只脚刚落地时执行。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q12","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000334', '摆动腿（swing leg）轨迹一般怎么设计？为什么常用五次多项式或 Bezier？', 'eaq-v06-q13', 'knowledge', 'medium', '摆动腿轨迹要求：① 起飞点与落地点匹配；',
   '摆动腿轨迹要求：① 起飞点与落地点匹配；② 起飞 / 落地速度 = 0（避免冲击）；③ 中间有抬腿高度（避障）。', '摆动腿轨迹要求：① 起飞点与落地点匹配；② 起飞 / 落地速度 = 0（避免冲击）；③ 中间有抬腿高度（避障）。

**为什么五次多项式（quintic / minimum-jerk）**：六个边界条件（起 / 落各一对 位置 / 速度 / 加速度）刚好对应五次多项式的 6 个系数，解析可求；jerk 最小 ⇒ 加速度平滑 ⇒ 电机受力舒缓。MIT Cheetah 用五次 + 可调最高点（apex height）。

**Bezier 曲线**：通过控制点直观调形，常用于希望"前快后慢"或"避开高障碍"的轨迹；ANYmal 系列也常用。

**落脚点怎么算**：常用 Raibert heuristic $p_{foot} = p_{hip} + \frac{v T_{st}}{2} + k(v - v_{des})$，其中 $T_{st}$ 是支撑相时长、$k$ 是反馈增益。RL 训练的策略可以学到更精细的落脚点选择。',
   null, null, '["摆动期不能假设质心匀速——MPC 给的质心轨迹是变速的，落脚点要用 MPC 输出的预测质心位置而不是当前位置。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q13","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000335', 'NMPC（非线性 MPC）和 Convex MPC 比，哪些场景值得为额外算力换更优解？', 'eaq-v06-q14', 'knowledge', 'hard', 'NMPC 不做小角度近似、不做 SRBM，保留全身动力学和圆锥摩擦锥；',
   'NMPC 不做小角度近似、不做 SRBM，保留全身动力学和圆锥摩擦锥；用 SQP / DDP / iLQR 求解，单次 5-20 ms。', 'NMPC 不做小角度近似、不做 SRBM，保留全身动力学和圆锥摩擦锥；用 SQP / DDP / iLQR 求解，单次 5-20 ms。

**值得换 NMPC 的场景**：
- 大姿态机动（深蹲、跳跃落地、滚翻）—— 小角度假设崩
- loco-manipulation（推门、扛物）—— SRBM 忽略的腿惯量影响显著
- 高动态奔跑 / 飞行相 —— 线性化误差大
- contact-implicit MPC（接触时序也作决策变量）

**Convex MPC 够用**：四足 trot / walk、人形低速行走；Unitree / ANYmal 主线产品仍用 Convex。

**前沿**：Crocoddyl（INRIA）DDP-NMPC、IIT contact-implicit MPC 在 ANYmal 跳跃；RL policy 也在抢这个生态位。',
   null, null, '["NMPC ≠ \"更好\"——SQP 易陷局部最优，warm-start 不好比 Convex MPC 还慢", "产线优先 Convex MPC，Convex 失败才考虑 NMPC。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"MPC 系列","qid":"Q14","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000336', 'WBC（whole-body controller）的核心思想是什么？为什么需要任务优先级？', 'eaq-v06-q15', 'knowledge', 'medium', '**WBC**：在每个控制周期（典型 1 kHz）解一个**约束二次规划**，同时满足多个相互冲突的运动学/动力学任务（质心位置、躯干姿态、足端力、关节限位等），输出关节力矩。',
   '**WBC**：在每个控制周期（典型 1 kHz）解一个**约束二次规划**，同时满足多个相互冲突的运动学/动力学任务（质心位置、躯干姿态、足端力、关节限位等），输出关节力矩。', '**WBC**：在每个控制周期（典型 1 kHz）解一个**约束二次规划**，同时满足多个相互冲突的运动学/动力学任务（质心位置、躯干姿态、足端力、关节限位等），输出关节力矩。

**为什么要优先级**：多任务常冲突。例如人形要"跟踪末端轨迹"+"维持平衡"+"避免关节超限"，冲突时**平衡必须赢**。两种实现：

| 实现 | 写法 | 行为 |
|---|---|---|
| **加权 QP** | 所有任务加权进单一代价 | 调权重难 |
| **严格 HQP** | 高优先级先解，零空间留给低优先级 | 严格不冲突，但难实现 |

**实务**：人形产线多用加权 QP；学术界爱严格 HQP。TSID 是 Task-Space Inverse Dynamics 框架（开源 stack-of-tasks/tsid 库内部用 HQP solver 做严格层级，同层内可用权重软化任务）。',
   null, null, '["WBC 不能替代 MPC——WBC 只看当前一拍（无预测），平衡 / 落脚等长期规划必须靠 MPC / 步态规划器", "典型架构是 **MPC（10-100 Hz）输出参考 → WBC（1 kHz）跟踪 + 力分配**。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"全身控制 WBC","qid":"Q15","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000337', 'TSID 和 HQP（hierarchical QP）的区别？weighted QP 和 strict hierarchy 各自的取舍？', 'eaq-v06-q16', 'knowledge', 'medium', 'TSID 是 Task-Space Inverse Dynamics 框架（Saab 2013 + stack-of-tasks/tsid 库），内部 solver 实际做 HQP 严格分层，但**同一层可用权重软化*…',
   'TSID 是 Task-Space Inverse Dynamics 框架（Saab 2013 + stack-of-tasks/tsid 库），内部 solver 实际做 HQP 严格分层，但**同一层可用权重软化**多个任务；HQP 特指严格层级。常用对比 weighted vs strict hierarchy：', 'TSID 是 Task-Space Inverse Dynamics 框架（Saab 2013 + stack-of-tasks/tsid 库），内部 solver 实际做 HQP 严格分层，但**同一层可用权重软化**多个任务；HQP 特指严格层级。常用对比 weighted vs strict hierarchy：

| | 加权 QP（单层） | 严格 HQP（多层） |
|---|---|---|
| 结构 | 任务加权，单 QP | 多层，高层零空间传给低层 |
| 调参 | 权重，**任务间偷量** | 严格不冲突，但难实现 |
| 计算 | 单 QP（毫秒） | k 层 QP（更慢） |
| 代表实现 | OpenSoT 加权 / Pink IK QP | tsid SolverHQP、OpenSoT 严格 |

**取舍**：加权简单快、调参直观，但极端配置下低优先级会拽偏高优先级；严格 HQP 理论严格但实现复杂。

**实务**：产线多用加权 QP；研究界爱严格 HQP。',
   null, null, '["一个\"任务\"通常是一组等式 + 不等式（关节限位、摩擦锥），不是单一约束", "层级指这一组的优先级。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"全身控制 WBC","qid":"Q16","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000338', 'OSC（operational space control）vs TSID：本质区别在哪？', 'eaq-v06-q17', 'knowledge', 'medium', '两者都把任务空间映射到关节力矩，但范式不同。',
   '两者都把任务空间映射到关节力矩，但范式不同：', '两者都把任务空间映射到关节力矩，但范式不同：

| | OSC（Khatib 1987） | TSID（Saab 2013） |
|---|---|---|
| 形式 | 闭式 $\tau = J^\top (\Lambda \ddot{x}_{des} + \mu + p)$ | QP 优化 |
| 不等式约束 | 不自然支持 | 原生支持（摩擦锥 / 关节限位） |
| 速度 | 矩阵运算，超快 | QP 求解，几毫秒 |
| 浮动基座 | 需额外处理 | 原生支持 |

**OSC 本质**：把动力学投影到任务空间 $\Lambda \ddot{x} = F + \mu + p$ 反解力矩；固定基机械臂上单层任务优于 TSID。

**TSID 优势**：统一处理浮动基座 + 接触约束 + 多任务，是腿足/人形的天然选择。

**实务**：腿足圈 TSID 主流（stack-of-tasks/tsid 是事实标准）；OSC 思想仍以"任务空间投影"融入 WBC。',
   null, null, '["OSC 不是\"过时\"——单任务 + 已知接触状态时仍更快", "TSID 的优势在多任务 + 不等式约束。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"全身控制 WBC","qid":"Q17","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000339', 'WBC 和 MPC 一般怎么配合？层次频率怎么分？', 'eaq-v06-q18', 'knowledge', 'medium', '典型分层（OpenLoong / Cheetah / ANYmal 通用）。',
   '典型分层（OpenLoong / Cheetah / ANYmal 通用）：', '典型分层（OpenLoong / Cheetah / ANYmal 通用）：

- **高层规划 1-10 Hz**：任务编排 / VLA / 视觉，给目标
- **MPC 30-100 Hz**：输出未来 0.5 s 质心轨迹 + 接触力
- **WBC 500-1000 Hz**：跟踪 MPC 输出 + 全身动力学 + 力分配，出关节力矩
- **关节伺服 > 2 kHz**：电流环 / 力矩闭环

**为什么分层**：MPC 单次 QP 约 1-5 ms 不能 1 kHz；WBC QP 规模小可 1 kHz；电机伺服需 > 1 kHz 稳定。

**通信**：MPC → WBC 通过共享内存 / ROS2；传递的是**力 + 加速度参考**，不是关节力矩。',
   null, null, '["MPC 直接生成关节力矩跳过 WBC 在简单四足上可行，但**复杂人形不行**——MPC 模型粗（SRBM）不能直接出 30+ 关节力矩", "WBC 是必经中间层。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"全身控制 WBC","qid":"Q18","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000340', '零空间投影（null-space projection）在 WBC 里怎么用？为什么这样能保任务优先级？', 'eaq-v06-q19', 'knowledge', 'medium', '**零空间投影**：把低优先级任务的控制信号投影到高优先级任务的零空间（不会改变高优先级任务的输出），从而实现"低优先级不干扰高优先级"。',
   '**零空间投影**：把低优先级任务的控制信号投影到高优先级任务的零空间（不会改变高优先级任务的输出），从而实现"低优先级不干扰高优先级"。', '**零空间投影**：把低优先级任务的控制信号投影到高优先级任务的零空间（不会改变高优先级任务的输出），从而实现"低优先级不干扰高优先级"。

**数学形式**：若高优先级任务雅可比 $J_1$，则零空间投影矩阵 $N_1 = I - J_1^+ J_1$。低优先级 $\ddot{q}_2$ 控制律变为：
$$\ddot{q} = J_1^+ \ddot{x}_{1,des} + N_1 \ddot{q}_2$$
左边任意 $\ddot{q}_2$ 都不影响 $\ddot{x}_1$，因为 $J_1 N_1 = 0$。

**HQP 中的用法**：每一层解完后，把它的零空间作为下一层的"可用动作空间"，递归到底。等价于多层 QP，每层在前层零空间内优化。',
   null, null, '["*零空间维度可能不够**——高优先级任务用了 $k$ 个自由度，只剩 $n-k$ 个给低优先级", "机械臂 7 关节时只剩 1 维，几乎没法干次要任务。这是 redundancy（冗余度）不足的根本限制，加任务前要算清楚自由度账。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"全身控制 WBC","qid":"Q19","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000341', '阻抗控制、导纳控制、力位混合控制在腿足里的应用场景对比？', 'eaq-v06-q20', 'knowledge', 'medium', '三者都是含柔顺性的控制策略，关键区别在输入-输出因果方向。',
   '三者都是含柔顺性的控制策略，关键区别在输入-输出因果方向：', '三者都是含柔顺性的控制策略，关键区别在输入-输出因果方向：

| | 阻抗 Impedance | 导纳 Admittance | 力位混合 Hybrid |
|---|---|---|---|
| 输入→输出 | 运动偏差 → 力 | 力偏差 → 运动 | 分方向：力 / 位置正交 |
| 适用机器人 | 力矩控制电机 | 位置控制电机 + 外置 F/T | 两者皆可 |
| 接触稳定性 | 接触刚硬环境也稳 | 刚硬环境易振 | 力方向稳，位置方向精确 |

**腿足应用**：
- **支撑腿** = 阻抗控制：虚拟弹簧-阻尼吸收着地冲击；摆动腿 = 位置控制
- **loco-manipulation** = 阻抗 + 力位混合：抓物方向位置，接触方向力
- **早期人形（ASIMO 等位置控电机）** = 导纳控制：F/T 外环算位置参考、内环 PID 跟踪',
   null, null, '["PD 控制 = 简化阻抗（无虚拟惯量项），仍属于阻抗范式（位移 → 力），不是导纳", "导纳的因果方向反过来（力 → 位移），需要 F/T 传感器读力做反馈。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"全身控制 WBC","qid":"Q20","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000342', '用 PPO 训腿足 locomotion，为什么 IsaacGym / IsaacLab 这种 GPU 并行仿真是事实标准？', 'eaq-v06-q21', 'knowledge', 'easy', '腿足 RL 的样本需求极大（百万级 step），CPU 仿真吞吐太低。',
   '腿足 RL 的样本需求极大（百万级 step），CPU 仿真吞吐太低。', '腿足 RL 的样本需求极大（百万级 step），CPU 仿真吞吐太低。

**GPU 并行三大优势**：① 数千环境并行（IsaacGym 典型 4096 envs，加速 100-1000 倍）；② 观测/动作驻留显存，无 CPU↔GPU 拷贝；③ PPO 与仿真同卡，端到端吞吐百万 step/分钟。

**典型配置**：4096 envs、PPO、horizon 32-50、几千万 step 几小时收敛（Humanoid-Gym / legged_gym）。

**仿真器选择**：
- **IsaacGym**（已停更）：legged_gym 等经典仓库依赖
- **IsaacLab**：NVIDIA 接班，物理后端可换 Newton
- **MJX / MuJoCo Playground**：JAX + MuJoCo，开源跨厂',
   null, null, '["envs 不是越多越好——超过 4096 batch 内方差减小、PPO 优势估计噪声小反而**收敛更慢**（Brax 论文实测）。"]'::jsonb, null, 3, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q21","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000343', '腿足 locomotion 的 reward 一般怎么设计？为什么常拆 task / style / regularization 三类？', 'eaq-v06-q22', 'knowledge', 'medium', 'legged_gym / Humanoid-Gym 等主流框架通常拆三类。',
   'legged_gym / Humanoid-Gym 等主流框架通常拆三类：', 'legged_gym / Humanoid-Gym 等主流框架通常拆三类：

| 类别 | 例子 | 作用 |
|---|---|---|
| **Task** | 跟踪速度命令、保持高度 | 完成任务 |
| **Style** | 步态周期、抬腿高度、对称 | 让运动像走路 |
| **Regularization** | 关节力矩平方、动作平滑、限位惩罚 | 节能、防过载 |

**为什么必须拆**：只设 task reward 会出现"姿态崩但完成任务"的解；style + regularization 才能引导到自然可部署步态。论文里 reward 项常达 15-25 个。

**常见坑**：① 系数失衡——style 太重不学动、reg 太重不动；② Reward hacking——策略找漏洞（来回小步刷 air time），要加约束。',
   null, null, '["*不要直接奖励\"前进距离\"**——会鼓励冲刺然后摔倒", "用速度命令跟踪误差作为 task reward 更稳。"]'::jsonb, null, 5, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q22","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000344', '课程学习（curriculum）在腿足 RL 里怎么搭？常见做法有哪些？', 'eaq-v06-q23', 'knowledge', 'medium', '直接训复杂地形 / 高速 / 强扰动会让 PPO 早期完全摔倒——curriculum 是事实标配。',
   '直接训复杂地形 / 高速 / 强扰动会让 PPO 早期完全摔倒——curriculum 是事实标配。', '直接训复杂地形 / 高速 / 强扰动会让 PPO 早期完全摔倒——curriculum 是事实标配。

**常见类型**：
1. **速度命令**：从 ±0.5 m/s 开始按成功率扩到 ±2 m/s
2. **地形**：平地 → 斜坡 → 阶梯 → 碎石，game-style 关卡进阶
3. **扰动**：早期不推、后期加大随机外力 / 质量随机化
4. **机器人姿态**（人形特有）：上身先固定、下身学走，再放开上身

**实务**：按 episode return 或成功率触发难度提升；停滞太久回退一级。IsaacLab / Newton 内置 progress-based terrain curriculum 模板。',
   null, null, '["curriculum 不是越激进越好——过快进阶会催化策略遗忘早期能力（catastrophic forgetting）", "通常保留旧难度环境做\"经验回放\"。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q23","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000345', 'RMA（Rapid Motor Adaptation）的核心思想是什么？两阶段训练分别学什么？', 'eaq-v06-q24', 'knowledge', 'medium', 'RMA（Kumar et al, RSS 2021, UC Berkeley + CMU + FAIR）解决"训练时有特权信息（摩擦、质量、扰动力），部署时只有本体感觉"的 gap。',
   'RMA（Kumar et al, RSS 2021, UC Berkeley + CMU + FAIR）解决"训练时有特权信息（摩擦、质量、扰动力），部署时只有本体感觉"的 gap。', 'RMA（Kumar et al, RSS 2021, UC Berkeley + CMU + FAIR）解决"训练时有特权信息（摩擦、质量、扰动力），部署时只有本体感觉"的 gap。

**两阶段**：
- **阶段一**：策略输入 = 本体感觉 + privileged info 的 latent $z$，PPO 训到收敛
- **阶段二 · Adaptation Module**：从近 N 步本体感觉历史**监督预测** $z$；部署时 adaptation module 替代特权编码器

**部署**：adaptation module 约 100 Hz，几百毫秒内适应新环境（不同摩擦、负载）。原论文 A1 在沙地、草地、徒步路径上零 fine-tune 走过。

**为什么 work**：本体感觉历史**隐含**环境信息（打滑、扭矩异常对应低摩擦），encoder 学的就是从隐含信号恢复 latent。',
   null, null, '["RMA 不是 sim2real 银弹——处理的是\"训练分布内的物理参数变化\"，对训练时未见过的极端情况（雪地）仍可能崩", "ASAP 等用残差 action model 进一步弥补。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q24","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000346', '教师-学生（teacher-student）蒸馏在腿足 RL 里为什么几乎是标配？privileged info 一般有哪些？', 'eaq-v06-q25', 'knowledge', 'medium', '腿足部署时只有本体感觉（关节编码器、IMU），但仿真训练时可以"作弊"看到更多信息——教师-学生蒸馏让仿真效率最大化。',
   '腿足部署时只有本体感觉（关节编码器、IMU），但仿真训练时可以"作弊"看到更多信息——教师-学生蒸馏让仿真效率最大化。', '腿足部署时只有本体感觉（关节编码器、IMU），但仿真训练时可以"作弊"看到更多信息——教师-学生蒸馏让仿真效率最大化。

**典型 privileged info（教师独占）**：
- 摩擦系数、地面材质、阻尼
- 机器人当前质量、惯量
- 外力大小方向（随机推力）
- 完整地形高度图（足下 ± 0.5 m）
- 关节摩擦、电机响应延迟

**学生（部署用）输入**：
- 本体感觉历史（关节角、关节速度、IMU）
- 命令向量（速度命令、步态参数）
- 可选：视觉（depth / RGB）—— RMA / PIM / Walk These Ways 多用本体感觉为主，视觉是后期补加

**蒸馏方法**：① DAgger（学生在仿真里跑、教师在线给标）；② BC（教师轨迹存离线集学生 BC）；③ 用教师 latent 监督学生 latent。',
   null, null, '["教师不能太强—— privileged info 让教师拿到\"超人类\"信号，学生本体感觉就是恢复不出来时，蒸馏永远失败", "要保证 privileged info 与本体感觉有可学习的映射关系。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q25","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000347', 'Walk These Ways 提出的 MoB（Multiplicity of Behavior）想解决什么问题？', 'eaq-v06-q26', 'knowledge', 'medium', '传统 locomotion 策略一个模型只学一种步态/速度风格，调速度命令仍是同一步态——**新任务（爬阶、推门）就要重新训**。',
   '传统 locomotion 策略一个模型只学一种步态/速度风格，调速度命令仍是同一步态——**新任务（爬阶、推门）就要重新训**。', '传统 locomotion 策略一个模型只学一种步态/速度风格，调速度命令仍是同一步态——**新任务（爬阶、推门）就要重新训**。

**MoB 的洞察**：让单个策略学一个**结构化的行为族**（family），通过外部参数（步态周期、抬腿高、躯干姿态）切换行为；新任务时**不重训，只调参数**。

**做法**：
- Reward 里加入 gait-encoding 项，强制策略在不同周期/相位下都能跟踪
- 训练时随机抽样所有行为参数（速度、步态周期、抬腿高、躯干俯仰）
- 部署时人 / 高层 / 脚本动态指定参数

**结果**：Margolis & Agrawal 在 Unitree Go1 上展示一个策略可以做：跑、跳、爬阶、蹲下、舞蹈、抗推——**全是同一个网络权重**。CoRL 2022 (arXiv 2212.03238) 开源 walk-these-ways 仓库被广泛复用。',
   null, null, '["MoB 不是\"无限通用\"——策略仍只能在训练时随机化过的参数范围内泛化", "完全没见过的动作（如倒立行走）仍需要重新训。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q26","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000348', 'ASAP 通过什么机制对齐仿真和真机？delta action model 起什么作用？', 'eaq-v06-q27', 'knowledge', 'hard', 'ASAP（CMU + NVIDIA, 2025-02, arXiv 2502.01143）解决人形 sim-to-real 剩余 gap——IsaacGym 训得好的策略到 Unitree G1 上仍会摔。',
   'ASAP（CMU + NVIDIA, 2025-02, arXiv 2502.01143）解决人形 sim-to-real 剩余 gap——IsaacGym 训得好的策略到 Unitree G1 上仍会摔。', 'ASAP（CMU + NVIDIA, 2025-02, arXiv 2502.01143）解决人形 sim-to-real 剩余 gap——IsaacGym 训得好的策略到 Unitree G1 上仍会摔。

**两阶段**：① 仿真预训练，retargeted 人体动作 + PPO 训运动跟踪；② 实机收集 (state, sim_action, real_outcome)，训 delta action model $\Delta a = a_{real} - a_{sim}$，装进仿真器后 fine-tune 原策略。

**为什么是 action**：相比改 dynamics（actuator net），改 action 更简单——少量真机数据、小 MLP 即可。

**关键贡献**：IsaacGym → IsaacSim / Genesis / Unitree G1 三套迁移都验证；与 RMA / actuator net **互补**可叠加。',
   null, null, '["ASAP 不是纯零样本 sim2real——需真机数据", "零样本场景仍要回到 actuator network + 域随机化。"]'::jsonb, null, 8, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q27","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000349', 'HIM（Hybrid Internal Model）/ belief encoder 在 RL locomotion 里起什么作用？', 'eaq-v06-q28', 'knowledge', 'medium', '把本体感觉历史 + 视觉编码成 latent state，让策略"看懂"环境隐含信息，是 RMA 思路的进化版。',
   '把本体感觉历史 + 视觉编码成 latent state，让策略"看懂"环境隐含信息，是 RMA 思路的进化版。', '把本体感觉历史 + 视觉编码成 latent state，让策略"看懂"环境隐含信息，是 RMA 思路的进化版。

**HIM（Hybrid Internal Model）核心**：用本体感觉历史预测"下一步本体感觉 + 速度"，迫使 encoder 学环境动力学的内部模型；与 RMA 不同**不需要 privileged info**——完全自监督。

**belief encoder（感知 locomotion）**：输入本体感觉历史 + 高度图 / depth；输出 latent（融合本体动力学 + 地形）；用 attention 或 GRU 编码。

**典型应用**：PIM（arXiv 2411.14386）把 LiDAR 高度图 + 本体感觉送进 belief encoder，让 humanoid 走阶梯。

**实务好处**：① 训练不依赖 privileged info；② sim2real gap 小；③ 对地形泛化好。',
   null, null, '["belief encoder 比纯 MLP 慢，需 latency 权衡——典型做法 encoder 50 Hz、策略 200 Hz，encoder latent 喂多次。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"RL-based locomotion","qid":"Q28","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000350', 'OPEN-TeleVision 这套系统的核心组件是什么？为什么要用 Apple Vision Pro？', 'eaq-v06-q29', 'knowledge', 'medium', 'OPEN-TeleVision（Cheng et al, arXiv 2407.01512, UCSD + MIT）是 2024-2026 人形 teleop 事实标准之一。',
   'OPEN-TeleVision（Cheng et al, arXiv 2407.01512, UCSD + MIT）是 2024-2026 人形 teleop 事实标准之一。', 'OPEN-TeleVision（Cheng et al, arXiv 2407.01512, UCSD + MIT）是 2024-2026 人形 teleop 事实标准之一。

**核心组件**：① VR 头盔（Apple Vision Pro / Quest）捕获头 / 手腕 / 手指 pose；② 机器人头部双目相机流回 VR 做 immersive 反馈；③ 服务器做 human-to-robot retargeting（IK）；④ 底层控制器把末端目标转关节力矩。

**为什么 Apple Vision Pro**：① 手部跟踪毫米级，SDK 直出 6-DoF；② 眼动 + 视野追踪，机器人头部跟随，沉浸感高；③ 延迟 < 50 ms，比开源 OpenVR 稳。

**典型成果**：MIT 操作员远程控制 UCSD 的 Unitree H1 抓物——推动了一波 humanoid teleop 工作。',
   null, null, '["主要解决\"上身\"teleop——腿部仍由 RL/MPC 自主控制，操作员不直接控腿", "这是与 Mobile ALOHA \"全身遥操\"的关键差别。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"人形遥操作 Teleop","qid":"Q29","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000351', '人形 teleop 的 motion retargeting 怎么做？SMPL 到机器人骨架的尺寸校准为什么麻烦？', 'eaq-v06-q30', 'knowledge', 'medium', '**Motion retargeting**：把人体动作映射到机器人关节空间，输出可执行关节目标。',
   '**Motion retargeting**：把人体动作映射到机器人关节空间，输出可执行关节目标。', '**Motion retargeting**：把人体动作映射到机器人关节空间，输出可执行关节目标。

**两条主流路线**：① **几何/IK 法**：机器人骨架做 IK 匹配末端位置，SEW-Mimic 用闭式几何解；② **学习法**：神经网络从人体姿态回归机器人关节角，GAN/VAE 都用过。

**SMPL 校准的麻烦**：
- SMPL 是 24 关节 + 形状参数 $\beta$（10 维），骨长由 $\beta$ 决定
- 机器人骨长固定，关节定义也不同（多数没腰 yaw / 锁骨）
- 直接复制关节角不行——同样肩角，人抬 90° 机器人可能 70°（限位 + 骨长）
- 标准做法：用 12 个对应关节优化 $\beta$ 让 SMPL 体型最接近机器人，再复制关节角',
   null, null, '["忽略骨长差异直接 retarget 会让\"摸鼻子\"变成\"机器人手在面前 30 cm\"——这是 H2O / HumanPlus 强调先做体型对齐的原因。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"人形遥操作 Teleop","qid":"Q30","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000352', 'Mobile ALOHA / ALOHA 2 的 leader-follower 双臂遥操方案为什么比 VR 抓握主流？', 'eaq-v06-q31', 'knowledge', 'medium', '**Leader-follower**：操作员手握两支小臂（leader），实时同步映射到机器人本体大臂（follower）；',
   '**Leader-follower**：操作员手握两支小臂（leader），实时同步映射到机器人本体大臂（follower）；50 Hz 流 14-DoF 关节角。', '**Leader-follower**：操作员手握两支小臂（leader），实时同步映射到机器人本体大臂（follower）；50 Hz 流 14-DoF 关节角。

**主流原因**（桌面操作场景）：① **0 retargeting**：leader / follower 关节同构，直接复制角，无需 IK；② **天然力反馈**：leader 用同款电机，能感受 follower 接触阻力；③ **数据质量高**：精细操作（穿针、扣纽扣）远超 VR 手势；④ **成本低**：套件约 $32K，比工业方案便宜一个数量级。

**Mobile ALOHA**：底盘装轮 + 全身 teleop（推车 + 手控双臂）；50 demos 协同训练，扫地 / 炒菜成功率 80%+。

**VR 抓握的位置**：人形上身（OPEN-TeleVision）；leader-follower 适合双臂工作站。两者不冲突，是不同 form factor 的最佳实践。',
   null, null, '["Mobile ALOHA \"低成本\"是相对工业级——开源套件仍约 $32K，不是\"几千块业余项目\"。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"人形遥操作 Teleop","qid":"Q31","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000353', 'H2O / OmniH2O 的训练流程：人体动作怎么变成机器人能执行的可行轨迹？', 'eaq-v06-q32', 'knowledge', 'medium', 'H2O / OmniH2O（CMU LeCAR Lab, arXiv 2403.04436）从大规模人类动作（AMASS / Motion-X）训人形模仿任意动作的策略。',
   'H2O / OmniH2O（CMU LeCAR Lab, arXiv 2403.04436）从大规模人类动作（AMASS / Motion-X）训人形模仿任意动作的策略。', 'H2O / OmniH2O（CMU LeCAR Lab, arXiv 2403.04436）从大规模人类动作（AMASS / Motion-X）训人形模仿任意动作的策略。

**流程**：① Retargeting：SMPL → 机器人骨架；② 可行性过滤：privileged imitation policy（教师）跟踪每条动作，跟不上的丢弃（剔除约 20-30%）；③ 教师-学生蒸馏：cleaned 数据集训学生，输入 SMPL keypoints + 本体感觉，输出关节力矩。

**部署**：实时输入操作员 SMPL keypoints（VR / 视觉 pose），策略出关节动作。

**OmniH2O 升级**（CoRL 2024, arXiv 2406.08858）：通用接口（VR / RGB / 语言）+ dexterous 全身 teleop + 自主策略 + OmniH2O-6 数据集。',
   null, null, '["H2O 不是零样本 retargeting——先要大量人类动作训策略", "罕见动作仍需重训。与 Mobile ALOHA 的 demo→BC 路径完全不同。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"人形遥操作 Teleop","qid":"Q32","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000354', 'teleop 数据采集为什么对模仿学习这么关键？数据飞轮里它处于什么位置？', 'eaq-v06-q33', 'knowledge', 'medium', '模仿学习 / VLA 完全靠演示数据，质量直接决定策略上限——teleop 是大规模收集"高质量带因果性"演示的事实标准。',
   '模仿学习 / VLA 完全靠演示数据，质量直接决定策略上限——teleop 是大规模收集"高质量带因果性"演示的事实标准。', '模仿学习 / VLA 完全靠演示数据，质量直接决定策略上限——teleop 是大规模收集"高质量带因果性"演示的事实标准。

**为什么 teleop > 视频 / 动捕**：
- **视频**：缺力交互信号（不知接触瞬间力）
- **动捕**：缺机器人本体感觉（人关节 ≠ 机器人关节）
- **teleop**：直接在目标机器人上演示，观测+动作天然对齐

**数据飞轮位置**：teleop demo → 训 BC / Diffusion Policy → 真机 rollout → 失败接管 → 追加 demo → 再训。teleop 是飞轮的种子 + 燃料。

**典型成本**：单 task 200-500 demos 起步；每 demo 1-3 分钟；π0 / GR00T 一次训需 1000+ 小时多任务 teleop。

**实务**：质量 > 数量——10 完美 demos > 100 抖动 demos；操作员熟手再录。Mobile ALOHA / UMI / DROID 是著名数据集。',
   null, null, '["teleop 不能涵盖\"机器人自遇失败状态\"——DAgger / 真机 RL 在飞轮后期仍不可或缺。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"人形遥操作 Teleop","qid":"Q33","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000355', '闭环 teleop 中的延迟（视觉反馈 + 控制下行）一般多少？怎么补偿？', 'eaq-v06-q34', 'knowledge', 'medium', '典型闭环延迟（OPEN-TeleVision 类系统实测）。',
   '典型闭环延迟（OPEN-TeleVision 类系统实测）：', '典型闭环延迟（OPEN-TeleVision 类系统实测）：

| 环节 | 延迟 |
|---|---|
| 相机采集 + 编码 | 15-30 ms |
| 网络到 VR | 20-50 ms（WiFi）/ 10-20 ms（有线） |
| VR 渲染 | 10-20 ms |
| 操作员反应 | 50-200 ms |
| VR → 服务器 → 机器人 | 10-30 ms |
| 控制器响应 | 5-10 ms |
| **总闭环** | **~150-300 ms** |

**补偿手段**：① 机器人本体 1 kHz 自主（WBC、平衡），人只负责高层目标；② 预测补偿——按命令推断 100 ms 后位置，用预测态做控制；③ 视频压缩（H.265 低延迟 profile）降到 30 ms 以下；④ 同地部署，避免广域网。',
   null, null, '["延迟不能完全消除——人反应时间是物理极限", "好的设计是让人**感觉不到延迟**（VR 浸入 + 机器人本体局部自主），不是真把延迟降到 0。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"人形遥操作 Teleop","qid":"Q34","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000356', 'HumanPlus 的 shadowing + imitation 两阶段方案是怎么走的？', 'eaq-v06-q35', 'knowledge', 'medium', 'HumanPlus（Stanford, arXiv 2406.10454）目标是"机器人实时跟一个人的动作，再从这些 shadowing 数据学自主执行任务"。',
   'HumanPlus（Stanford, arXiv 2406.10454）目标是"机器人实时跟一个人的动作，再从这些 shadowing 数据学自主执行任务"。', 'HumanPlus（Stanford, arXiv 2406.10454）目标是"机器人实时跟一个人的动作，再从这些 shadowing 数据学自主执行任务"。

**两阶段**：① **Shadowing**：操作员做动作 → RGB pose estimation → retarget → 机器人模仿（10 Hz）。底层 Humanoid Shadowing Transformer 接 32 维姿态出 19 维关节命令；② **Imitation**：shadowing 演示当 demo，训 HIT（类 ACT）出动作 chunk，机器人自主执行。

**为什么这套**：① shadowing 只要 RGB 门槛低；② 同时拿到"人体动作 + 机器人本体感觉"对齐数据；③ 跑跳拳击抓物都验证过。

**真机**：Unitree H1，几十 demo 后自主穿鞋、写字、抓物。',
   null, null, '["shadowing 不等同 OPEN-TeleVision——前者\"机器人跟人模仿\"（无 VR），后者\"沉浸式控机器人\"（有 VR）", "用途不同。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Loco-manipulation / 上下身解耦","qid":"Q35","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000357', 'ExBody 为什么解耦上下身控制？上身跟模仿、下身只跟踪速度有什么取舍？', 'eaq-v06-q36', 'knowledge', 'medium', 'ExBody（UC San Diego, arXiv 2402.16796）观察到：整体模仿人体动作太难——下身要平衡、上身要做表达动作，目标冲突。',
   'ExBody（UC San Diego, arXiv 2402.16796）观察到：整体模仿人体动作太难——下身要平衡、上身要做表达动作，目标冲突。', 'ExBody（UC San Diego, arXiv 2402.16796）观察到：整体模仿人体动作太难——下身要平衡、上身要做表达动作，目标冲突。

**解耦方案**：上身跟踪 retargeted 人体动作（精确模仿），下身只跟踪速度命令（forward / yaw），允许步态自适应。

**为什么 work**：上身模仿对**平衡稳定性要求低**——不极端可容错；下身平衡对**末端动作精度要求低**——走对方向就行。两者独立优化，难度大幅下降。

**取舍**：
- 优势：训练简单、sim2real 稳、表现力强（边走边跳舞）
- 局限：上下身完全独立无法做全身高动态动作（如蹲下抓地物）；后续 ExBody2 / ASAP / KungfuBot 引入耦合改进',
   null, null, '["解耦不等于上下身没耦合——下身仍承受上身反作用力", "只是控制器不直接同时优化两者。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Loco-manipulation / 上下身解耦","qid":"Q36","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000358', 'Loco-manipulation 任务里，腿的运动会扰动臂的精度——主流怎么处理这种耦合？', 'eaq-v06-q37', 'knowledge', 'medium', '人形 / 移动机械臂的 loco-manipulation 中，腿（locomotion）和臂（manipulation）有强耦合。',
   '人形 / 移动机械臂的 loco-manipulation 中，腿（locomotion）和臂（manipulation）有强耦合：
- 走路时躯干周期性晃动 → 末端轨迹有几厘米抖动
- 臂伸出时重心前移 → 腿要补偿', '人形 / 移动机械臂的 loco-manipulation 中，腿（locomotion）和臂（manipulation）有强耦合：
- 走路时躯干周期性晃动 → 末端轨迹有几厘米抖动
- 臂伸出时重心前移 → 腿要补偿

**主流处理思路**：
1. **分层 + 通信**（最常见）：locomotion 控制器把"未来质心轨迹"广播给 manipulation 控制器，manipulation 用这个轨迹做 feed-forward 补偿。如 ANYmal 的 multi-task WBC
2. **联合 QP**：把臂末端跟踪和腿落脚同写进一个 WBC QP，让优化器自动找折中（计算开销大，但精度高）
3. **学习联合策略**：用 RL 学一个端到端"全身策略"，省掉显式建模耦合。如 OmniH2O、HumanPlus
4. **解耦但加补偿**：上身用 IK 时把 IMU 测到的躯干姿态变化做实时补偿

**实务**：产线多用方案 1+4 组合（成熟、可调试）；研究多用方案 3（端到端、效果好）。',
   null, null, '["不要假设手臂用 PD 跟踪就万事大吉——走路时关节震动会激起手臂二阶振动，需要主动补偿，否则末端轨迹完全飞掉。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Loco-manipulation / 上下身解耦","qid":"Q37","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000359', '人形 stand-up 起立 policy（HoST）和 walking policy 为什么分开训？', 'eaq-v06-q38', 'knowledge', 'medium', 'HoST（SJTU + Shanghai AI Lab + HKU, arXiv 2502.08378）是首个让人形在多姿态下自主起立的工作（Unitree G1 上验证）。',
   'HoST（SJTU + Shanghai AI Lab + HKU, arXiv 2502.08378）是首个让人形在多姿态下自主起立的工作（Unitree G1 上验证）。', 'HoST（SJTU + Shanghai AI Lab + HKU, arXiv 2502.08378）是首个让人形在多姿态下自主起立的工作（Unitree G1 上验证）。

**为什么不和 walking 一起训**：
1. **状态空间不同**：起立从 lying / kneeling / leaning 等极端姿态，walking 从直立——一个策略两边都做难度爆炸
2. **奖励冲突**：起立要"低→高"渐进奖励，walking 要维持高姿态，混训不收敛
3. **课程顺序**：先训 walking（基础），起立训练时 walking 已稳，可以当结束条件用

**HoST 核心技巧**：
- 把起立分阶段（lying → kneeling → squat → stand），各阶段单独奖励 + 自动 curriculum
- 训练时随机化跌倒姿态（不只平躺）
- 部署时跌倒检测 → 切起立 policy → 站起后切回 walking',
   null, null, '["产线\"自动起立\"（如宇树 G1）多用两段式 + FSM 调度——不是单一全能策略", "面试说\"一体化全能策略\"不准确。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Loco-manipulation / 上下身解耦","qid":"Q38","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000360', '全身 VLA 与分层控制怎样结合？“从像素到动作”是否等于一个模型直接输出力矩？', 'eaq-v06-q39', 'knowledge', 'hard', '全身视觉运动策略已有公开系统案例，但“端到端”并不自动意味着同一个大模型每周期直接输出力矩。',
   '全身视觉运动策略已有公开系统案例，但“端到端”并不自动意味着同一个大模型每周期直接输出力矩。Figure 的 Helix 02 官方说明中，S2 处理语义，S1 生成全身关节目标，S0 在更快时标跟踪并处理全身协调。讨论方案要明确输出是目标位姿、关节目标还是执行器命令，以及闭环反馈和约束由谁负责。', '全身视觉运动策略已有公开系统案例，但“端到端”并不自动意味着同一个大模型每周期直接输出力矩。Figure 的 Helix 02 官方说明中，S2 处理语义，S1 生成全身关节目标，S0 在更快时标跟踪并处理全身协调。讨论方案要明确输出是目标位姿、关节目标还是执行器命令，以及闭环反馈和约束由谁负责。',
   null, null, '["不要沿用“VLA 只能管上身”或“只能做高层规划”的结论", "厂商演示说明其架构与特定任务表现，不证明所有人形任务已解决。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Loco-manipulation / 上下身解耦","qid":"Q39","freq_label":"🔥×3","provenance":"核验：[Figure Helix 02 官方架构](https://www.figure.ai/news/helix-02)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000361', '域随机化 domain randomization 在腿足 sim2real 里怎么用？哪些参数必须随机？', 'eaq-v06-q40', 'knowledge', 'easy', '**域随机化（DR）**：训练时随机化仿真器参数，让策略学到对参数分布鲁棒的特征——部署到真机时把真机当作"分布中的一个样本"。',
   '**域随机化（DR）**：训练时随机化仿真器参数，让策略学到对参数分布鲁棒的特征——部署到真机时把真机当作"分布中的一个样本"。', '**域随机化（DR）**：训练时随机化仿真器参数，让策略学到对参数分布鲁棒的特征——部署到真机时把真机当作"分布中的一个样本"。

**腿足必须随机化的参数（高优先级）**：
1. **质量 / 惯量**：±20-30%（电池电量、负载变化）
2. **摩擦系数**：脚 - 地接触摩擦 0.4-1.2（不同地面）
3. **电机参数**：扭矩限制、PD 增益（actuator delay）
4. **观测噪声**：IMU 漂移、关节编码器抖动
5. **外部扰动力**：随机推力 50-100 N，持续 0.1-0.3 s

**次优先级**：
- 关节摩擦 / 阻尼、连杆质心偏移
- 地面接触刚度（软泥 / 硬地）
- 地形高度噪声（凹凸不平）

**实务范围设定**：从真机标称值 ±20% 起步，policy 不收敛就降到 ±10%；可部署后再扩展。',
   null, null, '["DR 不是越宽越好——randomization 过大会让 policy 学不出明确策略（变保守的 \"走得最慢但永远不摔\"）", "与 curriculum 配合，从窄到宽逐步扩展是惯例。"]'::jsonb, null, 3, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Sim-to-Real for legged","qid":"Q40","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000362', 'Hwangbo 等人的 actuator network 解决了什么问题？为什么单纯随机化电机参数不够？', 'eaq-v06-q41', 'knowledge', 'medium', 'Hwangbo et al, Science Robotics 2019（ANYmal 上验证），是腿足 sim2real 奠基工作之一。',
   'Hwangbo et al, Science Robotics 2019（ANYmal 上验证），是腿足 sim2real 奠基工作之一。', 'Hwangbo et al, Science Robotics 2019（ANYmal 上验证），是腿足 sim2real 奠基工作之一。

**问题**：仿真器电机简化为"指令 → 力矩"线性模型，真实电机有：① 谐波减速器非线性摩擦 / 间隙；② 电流环动态（ms 级低通）；③ 编码器延迟；④ 高速扭矩-速度耦合。单纯随机化 PD 增益 + 力矩限制抓不到这些——sim 中走得好的策略到真机抖。

**Actuator Network**：在真机记录大量 (位置/速度/指令 → 实际力矩) 数据，训 MLP 拟合，然后**换掉仿真器的电机模型**。

**效果**：ANYmal 学到敏捷动态技能（如跑跳、从倒地起身），sim 训练后直接零样本部署到真机——2019 年的标杆结果之一。

**与 DR 关系**：互补。actuator net 抓**确定性**非线性，DR 抓**随机性**变化（样机差异、温度漂移）；两者并用是腿足 sim2real 黄金组合。',
   null, null, '["actuator network 每代硬件要重训——换电机或减速器后旧网络失效，是 product life cycle 的 hidden cost。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Sim-to-Real for legged","qid":"Q41","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000363', 'IsaacGym → IsaacLab → MJX / MuJoCo Playground 这条仿真器演进路线，每一代解决了什么痛点？', 'eaq-v06-q42', 'knowledge', 'medium', '| 仿真器 | 解决了什么 |',
   '| 仿真器 | 解决了什么 |
|---|---|
| **IsaacGym**（2021-2024 EOL） | GPU 并行（数千 envs），RL 训腿足从天降到小时 |
| **IsaacLab**（2024-） | 接班 IsaacGym；物理后端可换 Newton；统一 IsaacSim 渲染 |
| **MJX / MuJoCo Playground**（2024-） | JAX-MuJoCo，**全 GPU + 全开源**，不绑 NVIDIA |', '| 仿真器 | 解决了什么 |
|---|---|
| **IsaacGym**（2021-2024 EOL） | GPU 并行（数千 envs），RL 训腿足从天降到小时 |
| **IsaacLab**（2024-） | 接班 IsaacGym；物理后端可换 Newton；统一 IsaacSim 渲染 |
| **MJX / MuJoCo Playground**（2024-） | JAX-MuJoCo，**全 GPU + 全开源**，不绑 NVIDIA |

**痛点演进**：IsaacGym 解算力但视觉弱 + 接触粗糙 + 私有 PhysX；IsaacLab 解视觉 + 资产但仍绑 NVIDIA；MJX 解开源但工业级视觉仍弱。

**实务选择**：腿足本体感觉 RL → MJX；视觉 + 多机器人 + 工业部署 → IsaacLab；老项目 → IsaacGym（新项目不建议，已 EOL）。',
   null, null, '["legged_gym 等老仓库迁到 IsaacLab 不是无痛，资产格式 / API 都有 breaking changes。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Sim-to-Real for legged","qid":"Q42","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000364', '仿真到真机一般会先做 sim-to-sim（如 IsaacGym → MuJoCo）验证，为什么这一步很关键？', 'eaq-v06-q43', 'knowledge', 'medium', 'sim-to-sim（在第二个不同仿真器里跑同一策略）是 sim2real 前的"廉价金丝雀"。',
   'sim-to-sim（在第二个不同仿真器里跑同一策略）是 sim2real 前的"廉价金丝雀"。', 'sim-to-sim（在第二个不同仿真器里跑同一策略）是 sim2real 前的"廉价金丝雀"。

**为什么有用**：① 接触模型差异——IsaacGym（PhysX）和 MuJoCo（软接触）对接触建模不同，策略只在一个仿真器 work 说明对仿真细节过拟合；② 零成本验证，先发现问题；③ 跨仿真器表现是 sim2real readiness 的代理指标。

**Humanoid-Gym 等流程**：训练 IsaacGym（4096 envs 快）→ 验证 MuJoCo（接触模型不同）→ 真机 Unitree H1/G1。

**典型失败模式**：sim1 跑得好 → sim2 摔 → 必然 sim2real 失败。常见原因：接触延迟假设不一致；学到特定接触模型的 trick（利用 PhysX 不准做能量回收）；关节限位边界处理不同。',
   null, null, '["sim-to-sim 不能替代 actuator network / DR——它只验证\"策略对仿真细节的鲁棒性\"，不能补偿真机的非建模动力学。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Sim-to-Real for legged","qid":"Q43","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000365', '腿足机器人感知 locomotion（perceptive）里 height map / elevation map / depth camera 各自的取舍？', 'eaq-v06-q44', 'knowledge', 'medium', '| 表示 | 优势 | 劣势 |',
   '| 表示 | 优势 | 劣势 |
|---|---|---|
| **Height map** | 紧凑（16×16）、维度低 | 离散化误差、遮挡需 inpaint |
| **Elevation map** | 历史融合、抗短时遮挡 | 计算 / 内存开销大 |
| **Depth 原始** | 最丰富、保留 3D | 数据量大、样本需求高 |', '| 表示 | 优势 | 劣势 |
|---|---|---|
| **Height map** | 紧凑（16×16）、维度低 | 离散化误差、遮挡需 inpaint |
| **Elevation map** | 历史融合、抗短时遮挡 | 计算 / 内存开销大 |
| **Depth 原始** | 最丰富、保留 3D | 数据量大、样本需求高 |

**主流选择**：ANYmal / Unitree → LiDAR + height map（PIM）；Boston Dynamics Spot → 双目 + elevation map；GA-PHL → 下方 depth + U-Net 实时重建 height map。

**为什么不用 RGB**：腿足策略对几何（高度）敏感，对颜色不敏感——depth 信息密度匹配需求。',
   null, null, '["height map 不是单帧 depth——而是投影到机器人下方网格后的图", "坐标变换 + 遮挡处理是工程难点，新手常忽略。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Sim-to-Real for legged","qid":"Q44","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000366', '触地接触瞬间的非连续性怎么处理？仿真器里软接触 vs 硬接触的取舍？', 'eaq-v06-q45', 'knowledge', 'hard', '脚接触瞬间速度 / 力跳变——仿真和真机最容易不一致的地方。',
   '脚接触瞬间速度 / 力跳变——仿真和真机最容易不一致的地方。', '脚接触瞬间速度 / 力跳变——仿真和真机最容易不一致的地方。

**两种接触模型**：

| | 硬接触 / 冲量 | 软接触 / 罚函数 |
|---|---|---|
| 形式 | LCP / NCP | $f = k\delta + b\dot\delta$ |
| 代表 | Bullet、ODE、PhysX | MuJoCo |
| 优势 | 无穿透、物理正确 | 快、可微 |
| 劣势 | 解器迭代多、冲量模型速度非连续 | 有可感知穿透 |

**MuJoCo 特殊做法**：soft constraint with stiff parameters——可调到接近刚体但仍数学连续，求解快且稳；这是 MuJoCo 成 RL 主流的关键。

**腿足 sim2real 实务**：① 软接触穿透会让策略学"利用穿透做能量回收"trick → 真机失败；② 接触刚度调到 1e5-1e7 N/m；③ 加 actuator network 补差异。',
   null, null, '["MuJoCo 默认软接触对快速跑跳偏弹——训练后策略会\"利用弹力\"", "要主动调硬或加阻尼，否则真机零样本失败。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"Sim-to-Real for legged","qid":"Q45","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000367', '手撕位置型 / 增量型 PID', 'eaq-v06-ch01', 'coding', 'easy', 'PID 三项物理意义；',
   'PID 三项物理意义；位置型 vs 增量型公式差异；离散化 dt 处理；D 项放反馈避免设定值阶跃尖峰。', '**考察点**：PID 三项物理意义；位置型 vs 增量型公式差异；离散化 dt 处理；D 项放反馈避免设定值阶跃尖峰。

**实现**：

```python
class PID:
    def __init__(self, Kp, Ki, Kd, dt):
        self.Kp, self.Ki, self.Kd, self.dt = Kp, Ki, Kd, dt
        self.integral = 0.0
        self.prev_err = 0.0      # e(k-1)
        self.prev_prev_err = 0.0 # e(k-2)，增量型 D 项要
        self.prev_meas = 0.0     # 位置型 D 项放反馈量

    def position(self, sp, y):
        # 位置型：u(k) = Kp·e + Ki·Σe·dt + Kd·(-Δy/dt)
        e = sp - y
        self.integral += e * self.dt
        d = -(y - self.prev_meas) / self.dt   # 反馈微分，避免设定值阶跃尖峰
        self.prev_meas = y
        return self.Kp * e + self.Ki * self.integral + self.Kd * d

    def incremental(self, sp, y):
        # 增量型：Δu = Kp·(e-e₁) + Ki·e·dt + Kd·(e-2e₁+e₂)/dt
        e = sp - y
        du = (self.Kp * (e - self.prev_err)
              + self.Ki * e * self.dt
              + self.Kd * (e - 2 * self.prev_err + self.prev_prev_err) / self.dt)
        self.prev_prev_err, self.prev_err = self.prev_err, e
        return du   # 累加到上一步 u 上由调用方负责
```',
   null, null, '["位置型必须配 anti-windup（→ CH02）", "增量型需保存 e(k-2) 才能算 D", "D 项放误差时 setpoint 阶跃 → 微分尖峰，工程上一律放反馈量。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH01","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000368', '手撕 PID 抗积分饱和（anti-windup）', 'eaq-v06-ch02', 'coding', 'medium', '饱和来自执行器限幅 + 积分持续累加；',
   '饱和来自执行器限幅 + 积分持续累加；clamping / back-calculation 两种主流做法；只限输出不限积分仍会 windup。', '**考察点**：饱和来自执行器限幅 + 积分持续累加；clamping / back-calculation 两种主流做法；只限输出不限积分仍会 windup。

**实现**：

```python
class PIDAW:
    def __init__(self, Kp, Ki, Kd, dt, u_min, u_max, Kb=None):
        self.Kp, self.Ki, self.Kd, self.dt = Kp, Ki, Kd, dt
        self.u_min, self.u_max = u_min, u_max
        # 反算增益典型 Kb = 1/T_t，T_t≈T_i=Kp/Ki → Kb≈Ki/Kp（Åström 经验）
        self.Kb = Kb if Kb is not None else Ki / max(Kp, 1e-6)
        self.integral = 0.0
        self.prev_err = 0.0

    def step_backcalc(self, sp, y):
        # back-calculation：用 (u_sat - u_unsat) 反推压制积分
        e = sp - y
        d = (e - self.prev_err) / self.dt
        u_unsat = self.Kp * e + self.Ki * self.integral + self.Kd * d
        u_sat = max(self.u_min, min(self.u_max, u_unsat))
        # 积分更新含饱和反馈项；若未饱和该项为 0，退化为普通 PID
        self.integral += (e + self.Kb * (u_sat - u_unsat)) * self.dt
        self.prev_err = e
        return u_sat

    def step_clamp(self, sp, y):
        # clamping：积分项与误差同号且输出已饱和 → 暂停积分
        e = sp - y
        d = (e - self.prev_err) / self.dt
        u_unsat = self.Kp * e + self.Ki * self.integral + self.Kd * d
        saturated = (u_unsat >= self.u_max) or (u_unsat <= self.u_min)
        if not (saturated and (e * u_unsat > 0)):
            self.integral += e * self.dt
        self.prev_err = e
        return max(self.u_min, min(self.u_max, u_unsat))
```',
   null, null, '["只限 u 不限 integral → 仍 windup", "Kb 过大过度补偿 → 欠调", "双向饱和需上下限都判。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH02","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000369', '手撕一维 / 多维卡尔曼滤波（KF）', 'eaq-v06-ch03', 'coding', 'medium', '预测 + 更新两步；',
   '预测 + 更新两步；Kalman gain 在 prior 与 measurement 间权衡；Joseph form 协方差更新数值稳定；Q / R 物理含义。', '**考察点**：预测 + 更新两步；Kalman gain 在 prior 与 measurement 间权衡；Joseph form 协方差更新数值稳定；Q / R 物理含义。

**实现**：

```python
import numpy as np

class KF:
    def __init__(self, A, B, H, Q, R, x0, P0):
        # x_{k+1} = A x + B u + w,  z = H x + v;  w~N(0,Q), v~N(0,R)
        self.A, self.B, self.H = A, B, H
        self.Q, self.R = Q, R
        self.x, self.P = x0.copy(), P0.copy()

    def predict(self, u):
        self.x = self.A @ self.x + self.B @ u
        self.P = self.A @ self.P @ self.A.T + self.Q

    def update(self, z):
        S = self.H @ self.P @ self.H.T + self.R                  # 创新协方差
        K = self.P @ self.H.T @ np.linalg.inv(S)                 # Kalman gain
        y = z - self.H @ self.x                                  # innovation
        self.x = self.x + K @ y
        # Joseph form：对 K 任意值都保证 P 对称半正定，比 (I-KH)P 稳
        I = np.eye(self.P.shape[0])
        IKH = I - K @ self.H
        self.P = IKH @ self.P @ IKH.T + K @ self.R @ K.T

# 一维退化：A=B=H=1，所有矩阵 → 标量，K = P_pred / (P_pred + R)
```',
   null, null, '["Q（过程噪声）与 R（测量噪声）颠倒", "用 `(I-KH)P` 朴素式数值上易破坏对称性", "初始 P₀ 过小 → 滤波器过度自信、收敛慢甚至发散。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH03","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000370', '手撕 EKF 预测 + 更新步', 'eaq-v06-ch04', 'coding', 'medium', '非线性 → 工作点 Jacobian 线性化；',
   '非线性 → 工作点 Jacobian 线性化；innovation 用 h(x) 而非 H·x；F、H 必须在最新状态处重算。', '**考察点**：非线性 → 工作点 Jacobian 线性化；innovation 用 h(x) 而非 H·x；F、H 必须在最新状态处重算。

**实现**：

```python
import numpy as np

def ekf_step(x, P, u, z, f, h, F_jac, H_jac, Q, R):
    # f(x,u), h(x) 是非线性函数；F_jac/H_jac 返回相应 Jacobian
    # —— 预测 ——
    x_pred = f(x, u)
    F = F_jac(x, u)              # ∂f/∂x 在 (x,u) 处
    P_pred = F @ P @ F.T + Q
    # —— 更新 ——
    H = H_jac(x_pred)            # ∂h/∂x 在 x_pred 处（务必重算）
    S = H @ P_pred @ H.T + R
    K = P_pred @ H.T @ np.linalg.inv(S)
    y = z - h(x_pred)            # 均值用非线性 h，不要用 H·x_pred
    x_new = x_pred + K @ y
    I = np.eye(P.shape[0])
    IKH = I - K @ H
    P_new = IKH @ P_pred @ IKH.T + K @ R @ K.T   # Joseph form
    return x_new, P_new
```',
   null, null, '["innovation 写成 `z - H·x_pred`（线性化只用于协方差传递，均值预测仍用 h）", "F / H 在旧 x 处算未更新", "强非线性下不切 UKF / IEKF 会发散。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH04","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000371', '手撕 LQR 离散 Riccati 迭代', 'eaq-v06-ch05', 'coding', 'hard', '离散代数 Riccati 方程（DARE）不动点迭代；',
   '离散代数 Riccati 方程（DARE）不动点迭代；反馈律 u = -K x；与 KF 对偶（LQG）；Q 半正定 / R 正定要求。', '**考察点**：离散代数 Riccati 方程（DARE）不动点迭代；反馈律 u = -K x；与 KF 对偶（LQG）；Q 半正定 / R 正定要求。

**实现**：

```python
import numpy as np

def dlqr(A, B, Q, R, eps=1e-9, max_iter=2000):
    # 离散系统 x_{k+1} = A x + B u，二次代价 J = Σ(x''Qx + u''Ru)
    # 反向迭代 DARE：P_{k+1} = A''P A - A''P B (R + B''P B)^{-1} B''P A + Q
    P = Q.copy()
    for _ in range(max_iter):
        BtPB = B.T @ P @ B
        K = np.linalg.solve(R + BtPB, B.T @ P @ A)          # 暂存当前 K
        P_next = A.T @ P @ A - A.T @ P @ B @ K + Q
        if np.max(np.abs(P_next - P)) < eps:
            P = P_next
            break
        P = P_next
    # 收敛后用最终 P 算稳态反馈增益
    K = np.linalg.solve(R + B.T @ P @ B, B.T @ P @ A)
    return K, P   # 控制律 u = -K @ x
```',
   null, null, '["连续 / 离散 Riccati 公式弄混", "R 必须正定（否则 R+B''PB 可能奇异）", "用 `inv()` 而非 `solve()` 数值不稳", "工作点必须是平衡点（线性化前提）。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH05","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000372', '手撕四元数 ↔ 旋转矩阵互转', 'eaq-v06-ch06', 'coding', 'medium', 'q = (w, x, y, z)；',
   'q = (w, x, y, z)；q → R 闭式；R → q 按 trace 分支避数值不稳；Hamilton vs JPL 约定；ROS / Eigen 顺序差。', '**考察点**：q = (w, x, y, z)；q → R 闭式；R → q 按 trace 分支避数值不稳；Hamilton vs JPL 约定；ROS / Eigen 顺序差。

**实现**：

```python
import numpy as np

def quat_to_rot(q):
    # q = (w, x, y, z)，单位四元数
    w, x, y, z = q
    return np.array([
        [1 - 2*(y*y + z*z), 2*(x*y - w*z),     2*(x*z + w*y)],
        [2*(x*y + w*z),     1 - 2*(x*x + z*z), 2*(y*z - w*x)],
        [2*(x*z - w*y),     2*(y*z + w*x),     1 - 2*(x*x + y*y)],
    ])

def rot_to_quat(R):
    # Shepperd 法：先看 trace，再按对角最大分量分支以避免 0 除
    tr = R[0, 0] + R[1, 1] + R[2, 2]
    if tr > 0:
        s = 2.0 * np.sqrt(1.0 + tr)        # s = 4w
        w = 0.25 * s
        x = (R[2, 1] - R[1, 2]) / s
        y = (R[0, 2] - R[2, 0]) / s
        z = (R[1, 0] - R[0, 1]) / s
    else:
        i = np.argmax(np.diag(R))          # 选最大对角分量分支
        j, k = (i + 1) % 3, (i + 2) % 3
        s = 2.0 * np.sqrt(1.0 + R[i, i] - R[j, j] - R[k, k])
        q = [0.0] * 4
        q[0] = (R[k, j] - R[j, k]) / s     # w
        q[i + 1] = 0.25 * s
        q[j + 1] = (R[j, i] + R[i, j]) / s
        q[k + 1] = (R[k, i] + R[i, k]) / s
        w, x, y, z = q
    q = np.array([w, x, y, z])
    return q / np.linalg.norm(q)           # 浮点漂移后归一化
```',
   null, null, '["(x,y,z,w) vs (w,x,y,z) 顺序弄反", "R → q 不分支 trace 接近 -1 时 sqrt 内值 → 0 数值爆炸", "忘记 q 与 -q 双覆盖（插值 / loss 要 disambiguate）。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH06","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000373', '手撕数值 IK（Jacobian 伪逆 / DLS）', 'eaq-v06-ch07', 'coding', 'medium', '循环 残差→Jacobian→Δq→更新；',
   '循环 残差→Jacobian→Δq→更新；伪逆奇异处发散；DLS 加阻尼防爆炸；步长 clamp。', '**考察点**：循环 残差→Jacobian→Δq→更新；伪逆奇异处发散；DLS 加阻尼防爆炸；步长 clamp。

**实现**：

```python
import numpy as np

def ik_dls(fk, jac, q0, x_target, lam=0.05, alpha=0.5,
           tol=1e-4, max_iter=200, dq_max=0.2):
    # fk(q) → 末端位姿向量；jac(q) → 雅可比 (m×n)
    q = q0.copy()
    for _ in range(max_iter):
        e = x_target - fk(q)
        if np.linalg.norm(e) < tol:
            return q, True
        J = jac(q)
        # Damped Least Squares：J⁺_DLS = J''·(J·J'' + λ²·I)^{-1}，奇异处仍数值稳
        JJt = J @ J.T
        damp = (lam ** 2) * np.eye(JJt.shape[0])
        dq = J.T @ np.linalg.solve(JJt + damp, e)
        # 步长 clamp 防单步过大震荡 / 跨越奇异
        n = np.linalg.norm(dq)
        if n > dq_max:
            dq *= dq_max / n
        q = q + alpha * dq
    return q, False
```',
   null, null, '["奇异附近用纯伪逆 → 关节速度爆炸", "α 过大震荡发散、过小收敛慢", "忽略关节限位（重活岗会追问 weighted clamping / null-space）。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH07","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000374', '手撕互补滤波（IMU 姿态估计）', 'eaq-v06-ch08', 'coding', 'easy', '陀螺仪短期准但漂移、加速度计长期稳但噪声大；',
   '陀螺仪短期准但漂移、加速度计长期稳但噪声大；互补 = 高/低通组合；yaw 仅 acc + gyro 不可观要靠磁力计。', '**考察点**：陀螺仪短期准但漂移、加速度计长期稳但噪声大；互补 = 高/低通组合；yaw 仅 acc + gyro 不可观要靠磁力计。

**实现**：

```python
import numpy as np

class CompFilter:
    def __init__(self, alpha=0.98, dt=0.005):
        # alpha 大 → 更信陀螺（短期）；alpha 小 → 更信加速度（长期）
        self.alpha, self.dt = alpha, dt
        self.roll = 0.0
        self.pitch = 0.0

    def step(self, gyro, acc):
        # gyro = (gx, gy, gz) rad/s；acc = (ax, ay, az) m/s²
        gx, gy, _ = gyro
        ax, ay, az = acc
        # 加速度反算静态 roll / pitch（去重力分量）
        roll_acc = np.arctan2(ay, az)
        pitch_acc = np.arctan2(-ax, np.sqrt(ay * ay + az * az))
        # 陀螺积分给短期；加速度给长期校正
        self.roll = self.alpha * (self.roll + gx * self.dt) + (1 - self.alpha) * roll_acc
        self.pitch = self.alpha * (self.pitch + gy * self.dt) + (1 - self.alpha) * pitch_acc
        return self.roll, self.pitch   # yaw 不可观，需 mag / 视觉补
```',
   null, null, '["α 取反（应陀螺权重大）", "单位 deg/s 与 rad/s 混", "忘记 yaw 不可观", "角度跨 ±π 跳变没 unwrap。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH08","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000375', '手撕齐次变换 / DH 正向运动学', 'eaq-v06-ch09', 'coding', 'easy', '齐次矩阵 T = [R, p; 0, 1]；',
   '齐次矩阵 T = [R, p; 0, 1]；DH 4 参数 (a, α, d, θ)；本实现用改进 DH（Craig），与标准 DH（Spong）矩阵形式不同；FK 由 T 连乘。', '**考察点**：齐次矩阵 T = [R, p; 0, 1]；DH 4 参数 (a, α, d, θ)；本实现用改进 DH（Craig），与标准 DH（Spong）矩阵形式不同；FK 由 T 连乘。

**实现**：

```python
import numpy as np

def dh_link(a, alpha, d, theta):
    # 改进 DH（Craig）：T_i^{i-1} = Rot_x(α_{i-1})·Trans_x(a_{i-1})·Rot_z(θ_i)·Trans_z(d_i)
    ct, st = np.cos(theta), np.sin(theta)
    ca, sa = np.cos(alpha), np.sin(alpha)
    return np.array([
        [ct,       -st,       0.0,   a],
        [st * ca,  ct * ca,  -sa,   -sa * d],
        [st * sa,  ct * sa,   ca,    ca * d],
        [0.0,      0.0,       0.0,   1.0],
    ])

def fk(dh_params, q):
    # dh_params: [(a, alpha, d, theta_offset), ...]；q: 关节角向量
    T = np.eye(4)
    for (a, alpha, d, theta_off), qi in zip(dh_params, q):
        T = T @ dh_link(a, alpha, d, theta_off + qi)
    # 末端位姿：左上 3×3 为 R，右上 3×1 为 p
    return T   # T[:3,:3] = R_end, T[:3,3] = p_end
```',
   null, null, '["Craig 与 Spong 不可整链混用（前者坐标系固定在近端、Rot_x 先做", "后者固定在远端、Rot_z 先做）", "连乘顺序应 base → end。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH09","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000376', '手撕 MPC 的 QP 矩阵构造', 'eaq-v06-ch10', 'coding', 'hard', 'N 步预测视域展开 X = Â·x₀ + B̂·U；',
   'N 步预测视域展开 X = Â·x₀ + B̂·U；二次代价整理为 0.5·U''HU + g''U；不等式约束写成 A·U ≤ b；H 对称化 + 正则。', '**考察点**：N 步预测视域展开 X = Â·x₀ + B̂·U；二次代价整理为 0.5·U''HU + g''U；不等式约束写成 A·U ≤ b；H 对称化 + 正则。

**实现**：

```python
import numpy as np

def build_mpc_qp(A, B, Q, R, Qf, x0, N, u_min, u_max):
    # x_{k+1} = A x + B u；预测 X = [x_1; ...; x_N] = Ahat·x0 + Bhat·U
    n, m = A.shape[0], B.shape[1]
    Ahat = np.zeros((N * n, n))
    Bhat = np.zeros((N * n, N * m))
    Ai = np.eye(n)
    for i in range(N):
        Ai = A @ Ai                                  # A^{i+1}
        Ahat[i * n:(i + 1) * n] = Ai
        for j in range(i + 1):
            # 第 i 行第 j 列块 = A^{i-j} · B
            Bhat[i * n:(i + 1) * n, j * m:(j + 1) * m] = np.linalg.matrix_power(A, i - j) @ B
    # 堆叠权重：terminal cost 用 Qf，否则 Q
    Qbar = np.kron(np.eye(N), Q); Qbar[-n:, -n:] = Qf
    Rbar = np.kron(np.eye(N), R)
    H = Bhat.T @ Qbar @ Bhat + Rbar
    H = 0.5 * (H + H.T) + 1e-8 * np.eye(H.shape[0])  # 对称化 + 正则保证 PSD
    g = Bhat.T @ Qbar @ Ahat @ x0                    # 线性项依赖初始状态
    # 输入约束 u_min ≤ U ≤ u_max（broadcast 到长度 m 向量后再堆叠 N 次）
    u_lo = np.broadcast_to(u_min, (m,)).ravel()
    u_hi = np.broadcast_to(u_max, (m,)).ravel()
    G = np.vstack([np.eye(N * m), -np.eye(N * m)])
    h = np.hstack([np.tile(u_hi, N), -np.tile(u_lo, N)])
    return H, g, G, h   # 交给 OSQP / quadprog；取 U[:m] 作为本步控制
```',
   null, null, '["H 不强制对称正定数值上不收敛", "漏 terminal Qf 短视域不稳定", "friction cone 直接二次约束变 SOCP（必须线性化为金字塔）", "预测 dt 与控制 dt 不一致。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"06","volume_title":"卷六 · 腿足控制 / 遥操作","section":"手撕代码","qid":"CH10","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000377', 'PointNet 怎么解决点云的"无序性 / 置换不变性"问题？为什么能做点云分类的开山工作？', 'eaq-v07-q01', 'knowledge', 'easy', '点云的根本性质是**无序集合**——同一个物体的 $N$ 个点排列方式有 $N!$ 种，网络对任意置换必须输出同一个特征。',
   '点云的根本性质是**无序集合**——同一个物体的 $N$ 个点排列方式有 $N!$ 种，网络对任意置换必须输出同一个特征。PointNet（Qi 等 CVPR 2017）的解决方案：', '点云的根本性质是**无序集合**——同一个物体的 $N$ 个点排列方式有 $N!$ 种，网络对任意置换必须输出同一个特征。PointNet（Qi 等 CVPR 2017）的解决方案：

1. **共享 MLP**：每个点独立过同一个 MLP 升维，逐点变换不会引入顺序依赖
2. **对称聚合函数**：用 max-pooling 把 $N$ 个点的特征聚合成全局特征——max 是对称函数，对置换天然不变
3. **T-Net**：轻量 STN-like 子网络估计 $3\times3$ / $64\times64$ 变换矩阵，对齐输入和特征

**为什么开山**：之前主流是把点云体素化（voxelization）后用 3D CNN，分辨率受限于内存；PointNet 直接吃点、参数少（约 3.5 M），ModelNet40 准确率 89.2%。',
   null, null, '["max-pooling 对**离群点敏感**——异常远的一两个点会主导全局特征", "PointNet++ 用层次化 FPS + grouping 缓解。\"置换不变\"和\"旋转不变\"是两回事，T-Net 只对**仿射变换**部分对齐，不能完全解决旋转不变。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"3D 感知基础","qid":"Q01","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000378', 'PointNet++ 相比 PointNet 改进了什么？hierarchical FPS + grouping 解决什么问题？', 'eaq-v07-q02', 'knowledge', 'medium', 'PointNet 的核心缺陷是**没有局部结构**——只有 per-point MLP + 全局 max-pool，丢掉"哪些点是邻居"的几何信息，复杂场景（语义分割、室内检测）效果差。',
   'PointNet 的核心缺陷是**没有局部结构**——只有 per-point MLP + 全局 max-pool，丢掉"哪些点是邻居"的几何信息，复杂场景（语义分割、室内检测）效果差。PointNet++（NeurIPS 2017）三步改造：', 'PointNet 的核心缺陷是**没有局部结构**——只有 per-point MLP + 全局 max-pool，丢掉"哪些点是邻居"的几何信息，复杂场景（语义分割、室内检测）效果差。PointNet++（NeurIPS 2017）三步改造：

1. **FPS**（Farthest Point Sampling）：从 N 个点采 M 个中心点，比随机均匀
2. **Grouping**：以每中心点 ball-query 半径 r 内邻居形成局部簇
3. **局部 PointNet**：每簇上小 PointNet 提特征 → 再 FPS+Group → 层次化

**密度自适应**：MSG（multi-scale）多尺度并联；MRG（multi-resolution）多层级拼接——稀疏区粗特征兜底。',
   null, null, '["ball-query 半径是**超参数**，调不对漏邻居或纳入太多噪声", "近年 PointMLP / Point Transformer 都用 KNN 省掉此超参。ModelNet40 ↑1.3pt 不大，**真正提升在 ScanNet**：PointNet 53% mIoU → PointNet++ 64%。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"3D 感知基础","qid":"Q02","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000379', 'Point Transformer / PointMLP / PVCNN 各自定位？为什么近几年 PointNet++ 仍是 baseline 但很少作 SOTA？', 'eaq-v07-q03', 'knowledge', 'medium', '| 方法 | 核心机制 | 优势 / 劣势 |',
   '| 方法 | 核心机制 | 优势 / 劣势 |
|---|---|---|
| **PointNet++** | FPS + ball-query + 局部 MLP | 简单兼容 / 局部表达力弱 |
| **PVCNN** | Point + Voxel 双分支并联 | 快、内存低 / 体素分辨率受限 |
| **Point Transformer**（Zhao 2021） | vector self-attention 替 MLP | 几何感强 SOTA / 慢，$O(Nk)$ |
| **PointMLP**（ICLR 2022） | 纯 MLP + 几何 affine 归一 | 训练快超 Transformer / 缺解释性 |', '| 方法 | 核心机制 | 优势 / 劣势 |
|---|---|---|
| **PointNet++** | FPS + ball-query + 局部 MLP | 简单兼容 / 局部表达力弱 |
| **PVCNN** | Point + Voxel 双分支并联 | 快、内存低 / 体素分辨率受限 |
| **Point Transformer**（Zhao 2021） | vector self-attention 替 MLP | 几何感强 SOTA / 慢，$O(Nk)$ |
| **PointMLP**（ICLR 2022） | 纯 MLP + 几何 affine 归一 | 训练快超 Transformer / 缺解释性 |

**为什么 PN++ 还在**：① 代码极轻；② 工业部署友好（无 attention）；③ "Revisiting PointNet++"（BAAI 2022）显示改训练策略 + 大模型 PN++ 也能逼近 SOTA。',
   null, null, '["sparse convolution（Minkowski / SPVNAS）是**另一条线**——对大规模室外场景（自驾 LiDAR）显著有优势", "室内点数 < 100k，点级方法仍主流。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"3D 感知基础","qid":"Q03","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000380', '单目深度估计：metric depth 和 relative depth 的区别？什么时候必须用 metric？', 'eaq-v07-q04', 'knowledge', 'easy', '**Relative depth**：只输出**相对**深度（哪个点更远），整体可以差一个未知缩放和偏移因子。',
   '- **Relative depth**：只输出**相对**深度（哪个点更远），整体可以差一个未知缩放和偏移因子。训练时用"尺度无关" loss（如 SSI-MAE）；可在跨数据集预训练得到强泛化
- **Metric depth**：输出**绝对**深度（米为单位），必须有相机内参、训练数据有真值标定。跨域泛化差，相机 FoV / 焦距变了就崩', '- **Relative depth**：只输出**相对**深度（哪个点更远），整体可以差一个未知缩放和偏移因子。训练时用"尺度无关" loss（如 SSI-MAE）；可在跨数据集预训练得到强泛化
- **Metric depth**：输出**绝对**深度（米为单位），必须有相机内参、训练数据有真值标定。跨域泛化差，相机 FoV / 焦距变了就崩

**什么时候必须用 metric**：
- **导航 / 避障**：要知道"墙在 1.2 m 外"才能给出速度命令
- **建图 / SLAM 融合**：把单目深度灌进占用栅格必须米单位
- **抓取**：末端位置需要绝对距离

**什么时候 relative 够用**：纯视觉显著性、portrait 模式背景虚化、单图深度可视化。',
   null, null, '["MiDaS 是 **relative**，直接拿来做导航**必崩**", "ZoeDepth / Metric3D / Depth Anything v2（metric 微调版）是 metric。Depth Anything v1 默认是 relative，需要在 NYU / KITTI 上 metric 微调才能给绝对深度。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"3D 感知基础","qid":"Q04","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000381', 'Depth Anything v2 vs MiDaS vs ZoeDepth 怎么选？室内 / 室外有差别吗？', 'eaq-v07-q05', 'knowledge', 'medium', '| 模型 | 类型 | 强项 / 弱项 |',
   '| 模型 | 类型 | 强项 / 弱项 |
|---|---|---|
| **MiDaS v3.1**（2022） | relative | 跨域鲁棒老 baseline / 不是 metric，细节模糊 |
| **ZoeDepth**（2023） | metric | 真米单位零样本可用 / 边缘退化，室外一般 |
| **Depth Anything v2**（2024） | relative + metric | SOTA 细节 + 强泛化 / 算量比 v1 大 |', '| 模型 | 类型 | 强项 / 弱项 |
|---|---|---|
| **MiDaS v3.1**（2022） | relative | 跨域鲁棒老 baseline / 不是 metric，细节模糊 |
| **ZoeDepth**（2023） | metric | 真米单位零样本可用 / 边缘退化，室外一般 |
| **Depth Anything v2**（2024） | relative + metric | SOTA 细节 + 强泛化 / 算量比 v1 大 |

**选择**：室内导航 / 抓取 → DA v2 metric 或 Metric3D v2；室外远距 → ZoeDepth (KITTI) 或 Metric3D v2；只要相对结构 → DA v2 relative 默认版。',
   null, null, '["DA v2 默认输出是 **disparity**（视差），需 $1/d$ 反演才是深度", "KB/KITTI 模式直接输出米。ViT-L 单帧 CUDA / TensorRT 约 30-80 ms，端到端实时需要 ViT-S。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"3D 感知基础","qid":"Q05","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000382', 'occupancy network 和 2D occupancy grid map 的本质区别？BEV 和 voxel 各自适用什么场景？', 'eaq-v07-q06', 'knowledge', 'medium', '两类思想不同。',
   '两类思想不同：', '两类思想不同：

| | 2D Occupancy Grid | Occupancy Network |
|---|---|---|
| 结构 | 平面栅格 + 占用概率 | 3D voxel / 隐式连续 |
| 学习 | log-odds Bayes 更新 | 神经网络端到端预测 |
| 代表 | gmapping / Cartographer | Tesla Occupancy / SurroundOcc |
| 用途 | 2D 规划 / SLAM | 自驾 BEV / 机械臂避障 |

**BEV vs 体素**：BEV 省内存规划友好但**忽略高度**（桌下椅腿、低矮障碍物会丢）；Voxel 保 z 维能表达悬空 / 透空 / 多层，但内存 $O(LWH)$ 分辨率受限。

**实务**：自驾 2023 后从纯 BEV 转向 occupancy（Tesla AI Day 2022 推动）；室内移动机器人仍以 2D grid 为主。',
   null, null, '["occupancy network 是**端到端学习**输出，与 grid map 的 Bayesian filter 累积是两种范式", "别说成\"grid map 的 3D 版\"。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"3D 感知基础","qid":"Q06","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000383', 'NeRF 和 3D Gaussian Splatting 的核心区别？为什么 3DGS 在机器人圈快速取代 NeRF？', 'eaq-v07-q07', 'knowledge', 'easy', '| | NeRF | 3DGS |',
   '| | NeRF | 3DGS |
|---|---|---|
| 表征 | 隐式 MLP $(x,y,z,\theta,\phi) \to (\sigma, c)$ | 显式高斯椭球 $\{\mu, \Sigma, c, \alpha\}$ |
| 渲染 | volumetric ray marching | 光栅化 splatting（GPU 友好） |
| 训练 | 数小时（原文 12h） | 几十分钟（20-30 min）|
| 渲染速度 | ~1 FPS（原版） | 100+ FPS |
| 编辑 | 难（黑箱 MLP） | 容易（增删高斯） |', '| | NeRF | 3DGS |
|---|---|---|
| 表征 | 隐式 MLP $(x,y,z,\theta,\phi) \to (\sigma, c)$ | 显式高斯椭球 $\{\mu, \Sigma, c, \alpha\}$ |
| 渲染 | volumetric ray marching | 光栅化 splatting（GPU 友好） |
| 训练 | 数小时（原文 12h） | 几十分钟（20-30 min）|
| 渲染速度 | ~1 FPS（原版） | 100+ FPS |
| 编辑 | 难（黑箱 MLP） | 容易（增删高斯） |

**为什么 3DGS 在机器人圈走红**：实时渲染 100+ FPS（closed-loop 控制 / VR teleop 可行）；可编辑（物体级增删移动）；显式几何（高斯中心可直接当点云用，GaussianGrasper / SplatSim 下游友好）。',
   null, null, '["3DGS 训练快主要是**前向便宜**", "反光 / 透明 / 大尺度室外仍劣于最强 NeRF（Zip-NeRF）。\"SLAM 后端拿稀疏 GS 当地图\"这条路还在演进，没有定论。"]'::jsonb, null, 3, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"NeRF / 3DGS 在机器人里","qid":"Q07","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000384', 'F3RM（Feature Fields for Robotic Manipulation）是怎么把 CLIP 特征蒸馏到 NeRF 里的？为什么操作场景 view 少是个大问题？', 'eaq-v07-q08', 'knowledge', 'medium', 'F3RM（Shen 等 CoRL 2023）思路。',
   'F3RM（Shen 等 CoRL 2023）思路：', 'F3RM（Shen 等 CoRL 2023）思路：

1. 用 **DINO + CLIP** 对每帧图像抽 patch 级特征
2. NeRF 学一个**额外的特征通道** $f(x)$：把多视角特征"提升"到 3D 空间
3. 推理时给文本 query（如"红色杯子"），用 CLIP 文本编码器算 cosine similarity 选最相关 3D 区域
4. 用经典 Anti-Podal grasp planner 在该区域生成抓取候选

**为什么 view 少是大问题**：原版 NeRF 需要 ~30 个视角才能 converge；操作任务里相机机位往往**只能从机械臂第三视角扫几个角度**（5-10 view），稀疏视角下 NeRF 会出现"漂浮云""空洞"伪影。F3RM 用 50 view 已经算比较奢侈。',
   null, null, '["F3RM 蒸馏的是 **patch 级**特征，不是 pixel 级——细节上的对象边界仍模糊", "后续 GaussianGrasper / LERF-TOGO 都改进了这一点。F3RM 不是 zero-shot，每个新场景**仍需要重训 NeRF**（虽然 patch encoder 是预训练的）。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"NeRF / 3DGS 在机器人里","qid":"Q08","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000385', 'GaussianGrasper 相对 F3RM 的优势是什么？怎么做 open-vocabulary grasping？', 'eaq-v07-q09', 'knowledge', 'medium', 'GaussianGrasper（Zheng 等 IEEE RA-L 2024，arXiv 2403.09637）三大改进。',
   'GaussianGrasper（Zheng 等 IEEE RA-L 2024，arXiv 2403.09637）三大改进：', 'GaussianGrasper（Zheng 等 IEEE RA-L 2024，arXiv 2403.09637）三大改进：

1. **3DGS 代替 NeRF**：训练 30 min → < 10 min；推理 100+ FPS vs F3RM 1-2 FPS
2. **少视角友好**：原文用 ~10 view RGB-D 就能重建（F3RM 需 50 view）
3. **EFD 蒸馏 + 对比学习**：把 SAM 分割 + CLIP 特征在 GS 上做对比学习蒸馏，特征更精确

**open-vocabulary grasping 流程**：
- 文本 query → CLIP 编码 → 与每个高斯的特征 cos similarity → 阈值得 mask → 该 mask 区域作为抓取候选 region → 经典 GraspNet 或 AnyGrasp 在该 region 生成 6-DoF 抓取',
   null, null, '["GaussianGrasper 仍**每场景重训**，不是 zero-shot 部署。其优势更多在\"**特征蒸馏 + GS 几何**联合\"，而不仅是\"换了 GS 就快\"。真正实时 zero-shot grasping 还得靠 RGB-D 端到端模型（如 AnyGrasp）。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"NeRF / 3DGS 在机器人里","qid":"Q09","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000386', 'NeRF / 3DGS 实时性瓶颈在哪？训练 / 渲染 / 编辑 哪个最难做 < 30 Hz？', 'eaq-v07-q10', 'knowledge', 'hard', '三环节延迟来源不同。',
   '三环节延迟来源不同：', '三环节延迟来源不同：

| | NeRF 瓶颈 | 3DGS 瓶颈 |
|---|---|---|
| 训练 | 每像素数百次 MLP 前向 | 每像素排序 + α-blend |
| 渲染 | volumetric ray marching | tile-based 光栅化（已较快） |
| 编辑 | 改一处需重训 | 改局部高斯即可 |

**< 30 Hz 难点**：
- NeRF：**渲染就难**——Instant-NGP / NeRFAcc 加速到 30+ FPS（中分辨率），但训练仍 5-10 min
- 3DGS：**渲染稳定 100+ FPS**；**训练**是真正瓶颈（10+ min/场景，不能在线建图）
- **编辑**：NeRF 几乎无法在线编辑；3DGS 可逐高斯增删，但保持自洽（光照、阴影）仍困难

**实务**：机器人圈"地图建好后查询"做到了实时，"在线建图同时控制"仍是 2025-2026 开放问题。Gaussian-SLAM（SplaTAM / MonoGS）能 10-30 FPS 在线建图，但精度鲁棒性显著低于 ORB-SLAM3。',
   null, null, '[]'::jsonb, null, 8, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"NeRF / 3DGS 在机器人里","qid":"Q10","freq_label":"历史低频·待核","provenance":"破例说明：频次 2 但来自具身/SLAM 圈\"实时性瓶颈\"高频开放题，来源多 work（Instant-NGP / SplaTAM）权威。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000387', '端到端 NeRF / GS-based policy（如 SplatRL / GaussianActor）相比传统 BC + RGB-D 输入有什么收益和代价？', 'eaq-v07-q11', 'knowledge', 'hard', '**收益**。',
   '**收益**：
- **显式 3D 几何**：策略不需要从 RGB-D 隐式重建空间，几何先验更强 → **样本效率 +**
- **跨视角一致**：相机视角变了 GS 表征不变，**视角泛化 +**
- **多模态融合**：可灌 CLIP/SAM 特征到高斯上，**语义一致性 +**', '**收益**：
- **显式 3D 几何**：策略不需要从 RGB-D 隐式重建空间，几何先验更强 → **样本效率 +**
- **跨视角一致**：相机视角变了 GS 表征不变，**视角泛化 +**
- **多模态融合**：可灌 CLIP/SAM 特征到高斯上，**语义一致性 +**

**代价**：
- **训练管线复杂**：每个新场景要先建 GS（10+ min），不能像 BC 那样直接吃 RGB
- **GS 可微渲染但策略联合优化难**：GS 渲染本身是可微的，但 densification / pruning / 在线 map 更新与策略联合优化困难，多数工作把 GS 当**固定输入**
- **泛化到新场景**：依赖 GS 重建质量，未见物体 / 遮挡仍易崩
- **算力**：高斯数 100k-1M 量级，单帧策略推理慢于纯 vision encoder

**实务**：2025 端到端 GS-policy 仍是研究阶段，**没有像 Diffusion Policy 那样可即插即用**的工业方案；主流仍是"GS 当 perception 输入"+"DP / ACT 当 policy"分离架构。',
   null, null, '["不要把\"GS-based policy\"等同于\"GS 重建后查询\"——前者是**联合学习**，后者是**两阶段**", "只有联合学习才有\"端到端\"含义。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"NeRF / 3DGS 在机器人里","qid":"Q11","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000388', 'ORB-SLAM3 和 VINS-Fusion 的核心区别？工程上一般怎么选？', 'eaq-v07-q12', 'knowledge', 'easy', '两者都是经典 VIO / V-SLAM，路线不同。',
   '两者都是经典 VIO / V-SLAM，路线不同：', '两者都是经典 VIO / V-SLAM，路线不同：

| | **ORB-SLAM3**（Campos 2021） | **VINS-Fusion**（Qin 2019） |
|---|---|---|
| 前端 | ORB 特征点匹配 | 光流跟踪（KLT） |
| 后端 | BA | 滑动窗口 BA + 边缘化 |
| 回环 | DBoW2 + 全局 BA | 词袋 + pose graph |
| 多地图 | Atlas | 单地图 |
| 传感器 | mono/stereo/RGB-D + IMU | mono/stereo + IMU + GPS |

**工程选择**：室内相机不快 → ORB-SLAM3（精度高、回环鲁棒、长期建图）；快速运动 / 弱纹理 / 无人机 → VINS-Fusion（光流动态下更稳，IMU 紧耦合更激进）；嵌入式 → VINS-Fusion 略轻，ORB3 全套 1-2 GB RAM。',
   null, null, '["两者都用 **GPLv3** copyleft 协议——开源但商用闭源产品要谨慎（衍生必须同 GPL）", "商用闭源首选 OpenVINS / Kimera / Maplab 等 BSD/MIT 系。"]'::jsonb, null, 3, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"SLAM 与状态估计","qid":"Q12","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000389', 'VIO 相比纯视觉里程计的优势？IMU 预积分解决了什么核心问题？', 'eaq-v07-q13', 'knowledge', 'medium', '**VIO 优势**。',
   '**VIO 优势**：
- **绝对尺度**：单目纯视觉**只能恢复相对尺度**（5 倍小或大都对），IMU 给出加速度积分提供米单位真尺度
- **快速运动鲁棒**：相机在快速旋转 / 模糊时跟踪失败，IMU 在毫秒级仍稳定
- **退化恢复**：低纹理 / 黑屋子里相机失效时 IMU 可以"撑过"
- **频率高**：IMU 100-1000 Hz，能给控制器更频繁的位姿', '**VIO 优势**：
- **绝对尺度**：单目纯视觉**只能恢复相对尺度**（5 倍小或大都对），IMU 给出加速度积分提供米单位真尺度
- **快速运动鲁棒**：相机在快速旋转 / 模糊时跟踪失败，IMU 在毫秒级仍稳定
- **退化恢复**：低纹理 / 黑屋子里相机失效时 IMU 可以"撑过"
- **频率高**：IMU 100-1000 Hz，能给控制器更频繁的位姿

**IMU 预积分（Forster 2017）**：
- **问题**：每次优化变量（位姿）更新，都要把窗口内全部 IMU 测量重新积分——计算爆炸
- **解决**：用"**相对量** $\Delta R, \Delta v, \Delta p$"代替绝对积分，把窗口的 IMU 测量预积分到一个**与状态无关**的常量。状态更新时只需对常量做一阶修正，不必重积分',
   null, null, '["预积分是**离散 SO(3) 流形上的积分**，不能直接用欧氏空间公式", "常用 Lie group exp/log 处理旋转。预积分**仍受 IMU 零偏 / 噪声**影响，零偏估计是 VIO 收敛关键。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"SLAM 与状态估计","qid":"Q13","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000390', '回环检测的两条主流路线：词袋（BoW）vs 学习型（NetVLAD / EigenPlaces）。优劣势？', 'eaq-v07-q14', 'knowledge', 'medium', '| | **BoW**（DBoW2 / DBoW3 / FBoW） | **学习型**（NetVLAD / EigenPlaces / SuperGlue） |',
   '| | **BoW**（DBoW2 / DBoW3 / FBoW） | **学习型**（NetVLAD / EigenPlaces / SuperGlue） |
|---|---|---|
| 原理 | ORB/SIFT 特征聚类成视觉词典，TF-IDF 检索 | CNN 全局描述子 + 度量学习 |
| 内存 | 字典约 10-100 MB | 模型 < 100 MB，描述子 256-4096 维 |
| 速度 | < 10 ms / query | 50-200 ms / query（GPU） |
| 鲁棒性 | 光照 / 视角变化敏感 | 强（端到端学到不变性） |
| 部署 | 嵌入式友好 | 依赖 GPU |', '| | **BoW**（DBoW2 / DBoW3 / FBoW） | **学习型**（NetVLAD / EigenPlaces / SuperGlue） |
|---|---|---|
| 原理 | ORB/SIFT 特征聚类成视觉词典，TF-IDF 检索 | CNN 全局描述子 + 度量学习 |
| 内存 | 字典约 10-100 MB | 模型 < 100 MB，描述子 256-4096 维 |
| 速度 | < 10 ms / query | 50-200 ms / query（GPU） |
| 鲁棒性 | 光照 / 视角变化敏感 | 强（端到端学到不变性） |
| 部署 | 嵌入式友好 | 依赖 GPU |

**ORB-SLAM3 / VINS-Fusion 都用 BoW**——工业稳定、可解释。**机器学习时代**学习型方法在跨季节 / 昼夜 / 视角变换上显著更鲁棒（VPR benchmark 上 NetVLAD recall@1 比 BoW 高 10-20pt）。',
   null, null, '["回环**检测**和回环**校正**是两件事——检测告诉你\"这里来过\"，校正用 pose graph 优化把累积漂移摊平", "BoW 只解决检测。学习型方法可与几何验证（如 RANSAC + PnP）级联，避免 false positive。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"SLAM 与状态估计","qid":"Q14","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000391', '因子图优化和滤波（EKF）的区别？为什么现代 SLAM 几乎都用因子图？', 'eaq-v07-q15', 'knowledge', 'medium', '| | **EKF** | **因子图 / 非线性优化** |',
   '| | **EKF** | **因子图 / 非线性优化** |
|---|---|---|
| 思想 | 高斯递推 + 一阶线性化 | 所有约束建图，全局优化 |
| 时序 | 增量式（一来一更新） | 批处理 / 滑动窗口 |
| 线性化点 | 当前状态（一固定无法修） | 每次迭代重线性化 |
| 多假设 / 回环 | 难 | 容易（加一条因子边） |
| 计算量 | $O(n^2)$ | 稀疏 $O(n)$-$O(n^{1.5})$ |', '| | **EKF** | **因子图 / 非线性优化** |
|---|---|---|
| 思想 | 高斯递推 + 一阶线性化 | 所有约束建图，全局优化 |
| 时序 | 增量式（一来一更新） | 批处理 / 滑动窗口 |
| 线性化点 | 当前状态（一固定无法修） | 每次迭代重线性化 |
| 多假设 / 回环 | 难 | 容易（加一条因子边） |
| 计算量 | $O(n^2)$ | 稀疏 $O(n)$-$O(n^{1.5})$ |

**因子图胜出根本原因**：① 可重新线性化（EKF 卡死，因子图每次重算雅可比，对非线性/大旋转友好）；② 信息矩阵天然稀疏（Cholesky / iSAM 高效）；③ 多传感器融合干净（IMU/轮速/GPS/回环都"加一条因子"）。',
   null, null, '["EKF 在**算力极小**场景仍在用（小型微控制器）。现代 SLAM \"用因子图\"通常是**滑动窗口优化**，保留最近 N 帧因子老的 marginalize，不是真正全局 BA。GTSAM 的 iSAM2 是增量因子图，复杂度接近 EKF 但精度逼近批 BA。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"SLAM 与状态估计","qid":"Q15","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000392', 'Bundle Adjustment 在 SLAM 后端的角色？滑动窗口 BA 怎么控制规模？', 'eaq-v07-q16', 'knowledge', 'medium', '**BA**：以**重投影误差**为代价，联合优化关键帧位姿 $\{T_i\}$ 和路标点 $\{P_j\}$。',
   '**BA**：以**重投影误差**为代价，联合优化关键帧位姿 $\{T_i\}$ 和路标点 $\{P_j\}$：', '**BA**：以**重投影误差**为代价，联合优化关键帧位姿 $\{T_i\}$ 和路标点 $\{P_j\}$：

$$\min \sum_{i,j} \rho\left( \| u_{ij} - \pi(T_i, P_j) \|^2 \right)$$

求解器：Levenberg-Marquardt + Schur complement 利用稀疏性消除路标点。

**滑动窗口 BA 控制规模**：① 关键帧选择（旋转/平移阈值）；② 窗口大小（最近 10-20 关键帧 + 共视帧，老帧 marginalize）；③ 共视图 covisibility graph（local BA，全局 BA 仅回环触发）。',
   null, null, '["滑动窗口边缘化老变量时**信息矩阵 fill-in**（变稠密），用 first-estimate Jacobian / iSAM2 保持稀疏。路标点数 >> 位姿数，BA 计算量主要被路标点 dominated，必须 Schur 消元。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"SLAM 与状态估计","qid":"Q16","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000393', 'sparse SLAM（ORB-SLAM）和 dense SLAM（KinectFusion / NICE-SLAM）的取舍？', 'eaq-v07-q17', 'knowledge', 'easy', '| | sparse SLAM | dense SLAM |',
   '| | sparse SLAM | dense SLAM |
|---|---|---|
| 地图 | 数百 - 数千 ORB 路标点 | 体素 / TSDF / mesh / NeRF |
| 内存 | 几 MB - 几十 MB | 几百 MB - 几 GB |
| 用途 | 定位 / 路径回放 | 建图 / 避障 / 重建 |
| 实时性 | 30+ Hz | KinectFusion 30 Hz（小场景）；NeRF-SLAM 1-10 Hz |
| 代表 | ORB-SLAM3 / VINS-Fusion | KinectFusion / ElasticFusion / NICE-SLAM / Gaussian-SLAM |', '| | sparse SLAM | dense SLAM |
|---|---|---|
| 地图 | 数百 - 数千 ORB 路标点 | 体素 / TSDF / mesh / NeRF |
| 内存 | 几 MB - 几十 MB | 几百 MB - 几 GB |
| 用途 | 定位 / 路径回放 | 建图 / 避障 / 重建 |
| 实时性 | 30+ Hz | KinectFusion 30 Hz（小场景）；NeRF-SLAM 1-10 Hz |
| 代表 | ORB-SLAM3 / VINS-Fusion | KinectFusion / ElasticFusion / NICE-SLAM / Gaussian-SLAM |

**取舍核心**：
- 只要"机器人在哪" → sparse 够用
- 要"机器人能不能撞墙 / 抓桌子" → dense（要稠密几何）
- 现代实践常**分离**：sparse SLAM 做实时定位，dense map 离线后处理或低频构建',
   null, null, '["dense SLAM 不等于\"更准\"——稀疏 SLAM 的**关键帧位姿精度**通常更高（路标点少，BA 更稳）", "dense 的优势是**几何完整性**。NeRF-SLAM / Gaussian-SLAM 是近 2 年的方向，工业可用度低于 ORB-SLAM3。"]'::jsonb, null, 3, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"SLAM 与状态估计","qid":"Q17","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000394', 'A* / Dijkstra / RRT / RRT* 怎么选？哪个能找最优？哪个能高维？', 'eaq-v07-q18', 'knowledge', 'easy', '| 算法 | 类型 | 最优性 | 维度 | 适用 |',
   '| 算法 | 类型 | 最优性 | 维度 | 适用 |
|---|---|---|---|---|
| **Dijkstra** | 图搜索 | 全局最优 | 低（2D） | 已知静态地图、规模小 |
| **A\*** | 图搜索 + 启发 | 启发可采纳时最优 | 低 | 加速版 Dijkstra |
| **RRT** | 采样 | 概率完备**非**最优 | 高 | 高维状态空间 / 复杂约束 |
| **RRT\*** | 采样 + rewire | **渐近最优** | 高 | RRT 但允许迭代到最优 |', '| 算法 | 类型 | 最优性 | 维度 | 适用 |
|---|---|---|---|---|
| **Dijkstra** | 图搜索 | 全局最优 | 低（2D） | 已知静态地图、规模小 |
| **A\*** | 图搜索 + 启发 | 启发可采纳时最优 | 低 | 加速版 Dijkstra |
| **RRT** | 采样 | 概率完备**非**最优 | 高 | 高维状态空间 / 复杂约束 |
| **RRT\*** | 采样 + rewire | **渐近最优** | 高 | RRT 但允许迭代到最优 |

**选择**：2D 平面 / 栅格 → A\*（最常用）；机械臂 7-DoF → RRT-Connect / RRT\*；移动机器人已知地图要最优 → A\*；动态环境 → A\* 全局 + DWA/MPC 局部。',
   null, null, '["A\\* 启发函数必须**可采纳**（不高估真实代价）才保证最优——曼哈顿距离对 4-邻接可采纳，8-邻接要用欧氏。RRT 不能保证最优解（可能绕大圈），必须 RRT\\* 的 rewire 才能逼近最优。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"经典导航栈与地图表征","qid":"Q18","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000395', 'Nav2 vs ROS1 move_base：behavior tree + lifecycle 解决了什么痛点？', 'eaq-v07-q19', 'knowledge', 'medium', 'ROS1 `move_base` 是单体大节点，状态机硬编码在 C++ 里——**痛点**：故障恢复策略写死难定制；',
   'ROS1 `move_base` 是单体大节点，状态机硬编码在 C++ 里——**痛点**：故障恢复策略写死难定制；单节点宕机整栈崩；状态机不可视化不可热改。', 'ROS1 `move_base` 是单体大节点，状态机硬编码在 C++ 里——**痛点**：故障恢复策略写死难定制；单节点宕机整栈崩；状态机不可视化不可热改。

**Nav2 三大改造**：① **Behavior Tree**：导航流程用 BT XML 描述，节点（ComputePathToPose / FollowPath / Recovery）可拖拽组合——故障恢复可写"先转 30 度再重规划"；② **lifecycle 节点**：每 server 独立 unconfigured → configured → activated 生命周期，单点故障可重启不影响整栈；③ **插件化**：planner / controller / behavior / costmap layer 都 pluginlib 动态加载——可热插拔 A\* / NavFn / Smac / TEB / DWB。',
   null, null, '["Nav2 不只\"move_base 移植到 ROS2\"——是**架构重写**。但学习曲线陡（BT + lifecycle + 插件），新手项目慎用，BT 调试难（状态多日志多）。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"经典导航栈与地图表征","qid":"Q19","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000396', '全局规划 vs 局部规划（DWA / TEB）：分工和接口是什么？', 'eaq-v07-q20', 'knowledge', 'medium', '| | **全局 Planner** | **局部 Controller** |',
   '| | **全局 Planner** | **局部 Controller** |
|---|---|---|
| 目的 | 起点到终点长程最优路径 | 沿全局路径短程避障 |
| 输入 | 全局 costmap | 局部 costmap（实时传感器） |
| 输出 | path 路径点 | cmd_vel ($v, \omega$) |
| 算法 | A* / Dijkstra / NavFn / Smac | DWA / TEB / MPC / Pure Pursuit |
| 频率 | 1-5 Hz | 10-30 Hz |', '| | **全局 Planner** | **局部 Controller** |
|---|---|---|
| 目的 | 起点到终点长程最优路径 | 沿全局路径短程避障 |
| 输入 | 全局 costmap | 局部 costmap（实时传感器） |
| 输出 | path 路径点 | cmd_vel ($v, \omega$) |
| 算法 | A* / Dijkstra / NavFn / Smac | DWA / TEB / MPC / Pure Pursuit |
| 频率 | 1-5 Hz | 10-30 Hz |

**接口**：全局发 `Path`，局部订阅 path + odom + scan 输出 `Twist`。两者解耦可独立替换。

**DWA vs TEB**：DWA 速度空间采样 + 评分（路径偏离、目标距离、速度），快稳但只算下一步；TEB 轨迹建成弹性带 + 时间维度优化整段，能处理倒车 / 复杂动态约束，但慢。',
   null, null, '["局部规划器**不应**重规划全局——会死锁。卡住时触发 Recovery Behavior（旋转 / 后退 / 清 costmap），不是叫起全局规划器。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"经典导航栈与地图表征","qid":"Q20","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000397', '占用栅格地图：log-odds 更新、未知/空闲/占用三态怎么编码？', 'eaq-v07-q21', 'knowledge', 'medium', '栅格地图本质：每个 cell 维护占用概率 $p \in [0,1]$，0 空闲 / 1 占用 / 0.5 未知。',
   '栅格地图本质：每个 cell 维护占用概率 $p \in [0,1]$，0 空闲 / 1 占用 / 0.5 未知。', '栅格地图本质：每个 cell 维护占用概率 $p \in [0,1]$，0 空闲 / 1 占用 / 0.5 未知。

**为什么用 log-odds**：直接用 $p$ 更新数值不稳（接近 0/1 时溢出）；log-odds $l = \log \frac{p}{1-p}$ 无界，更新变加法 $l_t = l_{t-1} + l_\text{sensor}$。

**典型实现**：三个常量 $l_\text{free} = -0.4$、$l_\text{occ} = +0.85$、$l_0 = 0$；ray casting 从机器人到激光击中点，沿途 cell 减 $|l_\text{free}|$，击中点加 $l_\text{occ}$；加 clamp 防饱和。

**三态查询**：$p < 0.3$ free / $p > 0.7$ occupied / 否则 unknown。',
   null, null, '["cell 独立假设其实不成立（邻居相关），但工程够用。激光 ray casting $O(L)$/ray，LiDAR 一帧 1000+ 线量大，gmapping / Cartographer 用 Bresenham 加速。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"经典导航栈与地图表征","qid":"Q21","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000398', '拓扑地图 vs 度量地图 vs 语义地图 各自适用于什么任务？', 'eaq-v07-q22', 'knowledge', 'medium', '| | **度量地图** | **拓扑地图** | **语义地图** |',
   '| | **度量地图** | **拓扑地图** | **语义地图** |
|---|---|---|---|
| 表征 | 占用栅格 / 点云 / mesh | 节点（场所）+ 边（连通） | 度量 + 物体类别 / 关系 |
| 精度 | 厘米级 | 房间级 | 厘米 + 类别 |
| 内存 | 大 | 极小 | 中-大 |
| 适合查询 | "距离墙 0.5 m" | "客厅到厨房怎么走" | "找冰箱" |
| 代表 | gmapping / Cartographer | 老式 NavGraph、Hyam | VLMaps / ConceptFusion / SemExp 语义图 |', '| | **度量地图** | **拓扑地图** | **语义地图** |
|---|---|---|---|
| 表征 | 占用栅格 / 点云 / mesh | 节点（场所）+ 边（连通） | 度量 + 物体类别 / 关系 |
| 精度 | 厘米级 | 房间级 | 厘米 + 类别 |
| 内存 | 大 | 极小 | 中-大 |
| 适合查询 | "距离墙 0.5 m" | "客厅到厨房怎么走" | "找冰箱" |
| 代表 | gmapping / Cartographer | 老式 NavGraph、Hyam | VLMaps / ConceptFusion / SemExp 语义图 |

**实务组合**：
- 长程 VLN / ObjectNav → **语义图**（VLMaps）+ 度量底图（占用栅格）
- 多楼层导航 → **拓扑图**（楼层节点）+ 每层度量图
- 局部避障 → 纯度量栅格',
   null, null, '["语义地图不等于\"在度量图上贴标签\"——更现代的做法是**特征场**（VLMaps / ConceptFusion）：每个体素存 CLIP / SigLIP 特征向量，查询时用文本编码做 cos similarity，**零样本**支持任意类别。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"经典导航栈与地图表征","qid":"Q22","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000399', 'R2R / RxR / REVERIE / SOON 这几个 VLN 数据集的差别？指令复杂度和任务定义', 'eaq-v07-q23', 'knowledge', 'easy', '| 数据集 | 平台 / 长度 | 任务定义 | 核心差别 |',
   '| 数据集 | 平台 / 长度 | 任务定义 | 核心差别 |
|---|---|---|---|
| **R2R**（Anderson CVPR 2018） | MP3D / ~29 词 | 指令导航到点 | VLN 鼻祖，step-by-step |
| **R4R / R8R**（Jain 2019） | MP3D / 58-116 词 | R2R 路径拼接 | 长路径泛化压测 |
| **RxR**（Ku EMNLP 2020） | MP3D / ~78 词 | 英语 + 印地语 + 泰卢固语 | 多语 + 长指令 + 全程动作对齐 |
| **REVERIE**（Qi CVPR 2020） | MP3D / ~21 词 | 找物体并指认 | 任务变"找物体" + 输出 bbox ID |
| **SOON**（Zhu CVPR 2021） | MP3D / ~38 词 | 找属性匹配物体 | 加空间关系 + 属性（颜色、相对位置） |', '| 数据集 | 平台 / 长度 | 任务定义 | 核心差别 |
|---|---|---|---|
| **R2R**（Anderson CVPR 2018） | MP3D / ~29 词 | 指令导航到点 | VLN 鼻祖，step-by-step |
| **R4R / R8R**（Jain 2019） | MP3D / 58-116 词 | R2R 路径拼接 | 长路径泛化压测 |
| **RxR**（Ku EMNLP 2020） | MP3D / ~78 词 | 英语 + 印地语 + 泰卢固语 | 多语 + 长指令 + 全程动作对齐 |
| **REVERIE**（Qi CVPR 2020） | MP3D / ~21 词 | 找物体并指认 | 任务变"找物体" + 输出 bbox ID |
| **SOON**（Zhu CVPR 2021） | MP3D / ~38 词 | 找属性匹配物体 | 加空间关系 + 属性（颜色、相对位置） |

**难度演进**：动作级（R2R） → 目标级（REVERIE/SOON） → 多语长指令（RxR）。',
   null, null, '["REVERIE 是\"**找物体 + 指认**\"，最后必须输出 **bbox ID**，是\"指代消解 + 导航\"联合任务，不要等同于 ObjectNav 的\"接近物体\"。"]'::jsonb, null, 3, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q23","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000400', 'VLN-CE 相比离散 VLN 的核心区别？waypoint predictor 解决了什么问题？', 'eaq-v07-q24', 'knowledge', 'medium', '**离散 VLN**（R2R 原版）：MP3D 每房间预定义**有向图**（节点 + 边），agent 在节点间跳跃。',
   '**离散 VLN**（R2R 原版）：MP3D 每房间预定义**有向图**（节点 + 边），agent 在节点间跳跃。**与真机脱节**——真机要走米单位连续动作。', '**离散 VLN**（R2R 原版）：MP3D 每房间预定义**有向图**（节点 + 边），agent 在节点间跳跃。**与真机脱节**——真机要走米单位连续动作。

**VLN-CE**（Krantz ECCV 2020）：Habitat 里跑 R2R，agent 输出**低层离散动作**（前进 0.25 m / 转 15° / 停止——动作集是离散的，但状态空间连续）。**搜索空间爆炸**——每步十几动作连乘，长指令规划难。

**waypoint predictor 折中**：先预测"下一个可达候选点"集合（12 方向、0.5/1/2 m），选一个候选再用 PointNav controller 走过去。代表：CMA-Waypoint（Hong 2022）、ETPNav（An et al. TPAMI 2024）。',
   null, null, '["VLN-CE 难度**远高于**离散 VLN——SOTA SR 从 70%+ 掉到 50% 上下", "很多论文报\"VLN 60% SR\"不区分 VLN / VLN-CE 是面试雷点。NaVid / VLN-R1 都直接在 VLN-CE 上做评测。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q24","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000401', 'VLN-BERT / HAMT / DUET 的演进路线？history memory / panorama / cross-modal attention', 'eaq-v07-q25', 'knowledge', 'medium', 'VLN 模型架构三代演进。',
   'VLN 模型架构三代演进：', 'VLN 模型架构三代演进：

1. **VLN-BERT**（Hong CVPR 2021）：BERT 套 VLN，文本-视觉 cross-attention，每步独立看 panorama，**无显式历史**——长指令易迷路
2. **HAMT**（Chen NeurIPS 2021）：引入**历史 transformer**，把过去 K 步 panorama + 动作编码成 history tokens 与当前一起 cross-attention；解决"看 panorama 不记得"
3. **DUET**（Chen CVPR 2022）：**dual-scale 双尺度**——粗尺度 topology graph（去过哪些节点）+ 细尺度局部 panorama（当前看到啥），两分支 cross-fuse

**演进核心**：无历史 → 时序历史 → 拓扑空间历史。R2R SR：VLN-BERT 63% → HAMT 66% → DUET 72%。',
   null, null, '["DUET topology graph **在线构建**——agent 走过自动加，不需要先验地图。HAMT history token 不是无限增长——窗口 K 是超参，过长 token 数太多。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q25","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000402', 'NaVid 怎么做到"无地图、无深度、无里程计"也能做 VLN-CE？', 'eaq-v07-q26', 'knowledge', 'medium', 'NaVid 用视频 VLM 将单目 RGB 历史与语言指令映射为导航动作，不显式输入深度、里程计或地图。',
   'NaVid 用视频 VLM 将单目 RGB 历史与语言指令映射为导航动作，不显式输入深度、里程计或地图。作者架构以 Vicuna-7B 为语言主干：历史帧压缩为每帧 4 个 token，当前帧保留 64 个 token，以兼顾长历史与当前细节。其导航训练集规模按 samples 统计，不能写成相同数量的独立完整轨迹。', 'NaVid 用视频 VLM 将单目 RGB 历史与语言指令映射为导航动作，不显式输入深度、里程计或地图。作者架构以 Vicuna-7B 为语言主干：历史帧压缩为每帧 4 个 token，当前帧保留 64 个 token，以兼顾长历史与当前细节。其导航训练集规模按 samples 统计，不能写成相同数量的独立完整轨迹。',
   null, null, '["不显式使用地图不等于没有空间表征，也不等于 zero-shot", "任务、训练数据和评测划分必须说明，不能混用导航样本数与 trajectory 数。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q26","freq_label":"🔥×4","provenance":"核验：[NaVid 作者项目页](https://pku-epic.github.io/NaVid/)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000403', 'Uni-NaVid 怎么统一 VLN / ObjectNav / EQA / 人物跟随四类任务？token merging 起什么作用？', 'eaq-v07-q27', 'knowledge', 'medium', 'Uni-NaVid（Zhang RSS 2025，arXiv 2412.06224）三大设计。',
   'Uni-NaVid（Zhang RSS 2025，arXiv 2412.06224）三大设计：', 'Uni-NaVid（Zhang RSS 2025，arXiv 2412.06224）三大设计：

1. **统一任务模板**：四类任务都改写为"指令 + 视频流 → 文本动作"——VLN（自然语言指令）/ ObjectNav（`find a chair`）/ EQA（`Q: where is the bed?`）/ Tracking（`follow the person in red`）
2. **3.6M 多任务联合训练**：4 类任务轨迹混合微调
3. **在线 token merging**：类似 ToMe 逐帧合并相似 token，把单帧 4 token 压到全程 < 100 token

**token merging 作用**：推理加速（单 A100 5 Hz）+ 长程记忆（100+ 帧不爆显存）+ 隐式去冗余（相似帧合并 = 自动 keyframe）。',
   null, null, '["Uni-NaVid 是 **NaVid 统一升级版**——四个任务都跑赢专门 baseline 但通常不及最强专家。task synergy 中等收益（+2-5pt）不是\"涌现\"。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q27","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000404', 'NaVILA 的两级框架：VLM 出 mid-level action + RL low-level locomotion，分层为什么必要？', 'eaq-v07-q28', 'knowledge', 'hard', 'NaVILA（Lin RSS 2025，UC San Diego）针对**腿足机器人 VLN**——四足/人形不能"瞬移到 waypoint"，必须考虑步态、平衡、地形。',
   'NaVILA（Lin RSS 2025，UC San Diego）针对**腿足机器人 VLN**——四足/人形不能"瞬移到 waypoint"，必须考虑步态、平衡、地形。', 'NaVILA（Lin RSS 2025，UC San Diego）针对**腿足机器人 VLN**——四足/人形不能"瞬移到 waypoint"，必须考虑步态、平衡、地形。

**两级架构**：High-level VLM 吃图像 + 指令输出 mid-level action（"右转 30°"/"前进 1 m"），1-2 Hz；Low-level RL locomotion 吃 mid-level + 本体状态输出关节力矩，50-100 Hz。

**为什么分层必要**：① 频率失配（VLM 1 Hz vs 控制 50+ Hz）单网难兼顾；② 语义 vs 动力学训练数据来源不同（VLM 互联网视频；locomotion sim2real RL），**分别迭代不互相干扰**。

**对比 NaVid**：NaVid 输出"前进 0.25 m"适合**轮式**；NaVILA 输出"前进 1 m"让 locomotion 自己规划步态，适合腿足。',
   null, null, '["NaVILA low-level 仍是预训练 RL 策略（如 Walk These Ways），非端到端联合学习", "两级解耦意味着 mid-level command 不合理（\"穿墙\"）底层不会反馈纠错。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q28","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000405', 'VLN 评估指标 SR / SPL / nDTW 各自衡量什么？SR 高但 SPL 低说明什么？', 'eaq-v07-q29', 'knowledge', 'medium', '**SR（Success Rate）**：最终停止时距目标 < 3 m（R2R 阈值）的轨迹占比。',
   '- **SR（Success Rate）**：最终停止时距目标 < 3 m（R2R 阈值）的轨迹占比。**只关心是否到达**
- **SPL（Success weighted by Path Length）**：$\text{SPL} = \text{SR} \cdot \frac{\ell^*}{\max(\ell^*, \ell_\text{agent})}$。**惩罚绕路**——agent 走的越远 SPL 越低
- **nDTW（normalized Dynamic Time Warping）**：把 agent 轨迹和参考轨迹做 DTW 对齐，归一化到 $[0, 1]$。**衡量轨迹形状是否贴近参考**——更适合 RxR 这种"按指令走"任务
- **NE（Navigation Error）**：终点距目标的距离，越小越好
- **OSR（Oracle SR）**：路径中**任一点**离目标 < 3 m 就算成功——衡量"看到过没"', '- **SR（Success Rate）**：最终停止时距目标 < 3 m（R2R 阈值）的轨迹占比。**只关心是否到达**
- **SPL（Success weighted by Path Length）**：$\text{SPL} = \text{SR} \cdot \frac{\ell^*}{\max(\ell^*, \ell_\text{agent})}$。**惩罚绕路**——agent 走的越远 SPL 越低
- **nDTW（normalized Dynamic Time Warping）**：把 agent 轨迹和参考轨迹做 DTW 对齐，归一化到 $[0, 1]$。**衡量轨迹形状是否贴近参考**——更适合 RxR 这种"按指令走"任务
- **NE（Navigation Error）**：终点距目标的距离，越小越好
- **OSR（Oracle SR）**：路径中**任一点**离目标 < 3 m 就算成功——衡量"看到过没"

**SR 高 SPL 低意味着**：到达目标但**绕了一大圈**——典型如随机探索 + 偶然撞上。reward 设计偏向 SR 时（如 IL）会出现此情况；reward 加入路径长度惩罚后 SPL 提升。',
   null, null, '["R2R 的\"成功\"阈值 3 m 是**任务约定**，不是物理意义——agent 可能\"看到了目标但没靠近\"也算失败。SPL 是 SR 的**严格上界**（$\\text{SPL} \\le \\text{SR}$），看到 SPL > SR 就是 bug。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q29","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000406', 'low-level action space vs high-level action space 在 VLN 里的取舍？', 'eaq-v07-q30', 'knowledge', 'medium', '| | **low-level**（VLN-CE 默认） | **high-level**（waypoint） |',
   '| | **low-level**（VLN-CE 默认） | **high-level**（waypoint） |
|---|---|---|
| 动作 | 前进 0.25 m / 转 15° / 停 | 选 N 个候选 waypoint 之一 |
| 决策频率 | 每米 ~4 步 | 每路口 1 步 |
| 序列长度 | 长（30-100 步） | 短（5-15 步） |
| 真机迁移 | 接近真实控制 | 需 PointNav controller 落地 |
| 长程规划 | 容易迷路（短视） | 容易（macro 决策） |', '| | **low-level**（VLN-CE 默认） | **high-level**（waypoint） |
|---|---|---|
| 动作 | 前进 0.25 m / 转 15° / 停 | 选 N 个候选 waypoint 之一 |
| 决策频率 | 每米 ~4 步 | 每路口 1 步 |
| 序列长度 | 长（30-100 步） | 短（5-15 步） |
| 真机迁移 | 接近真实控制 | 需 PointNav controller 落地 |
| 长程规划 | 容易迷路（短视） | 容易（macro 决策） |

**实务**：学术 R2R 离散 benchmark → high-level；VLN-CE / 真机 → 多数论文用 **waypoint predictor 折中**（high-level 决策 + low-level 跟踪）；端到端 VLM（NaVid / VLN-R1）→ 直接 low-level，靠大模型容量克服短视。',
   null, null, '["high-level action ≠ \"真机可部署\"——你仍需 PointNav 控制器把\"去那个 waypoint\"落到 cmd_vel。真正的 sim2real gap 在 PointNav，不在 VLN 上层决策。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q30","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000407', 'VLN-R1：RFT（reinforcement fine-tuning）解决了 SFT 的什么短板？', 'eaq-v07-q31', 'knowledge', 'hard', 'VLN-R1（Qi 等 2025，arXiv 2506.17221）针对 SFT 核心问题：**仅模仿专家无法处理 OOD**——没见过的环境就崩。',
   'VLN-R1（Qi 等 2025，arXiv 2506.17221）针对 SFT 核心问题：**仅模仿专家无法处理 OOD**——没见过的环境就崩。', 'VLN-R1（Qi 等 2025，arXiv 2506.17221）针对 SFT 核心问题：**仅模仿专家无法处理 OOD**——没见过的环境就崩。

**RFT 改造**：SFT 阶段在 VLN-Ego 数据集（HK 大 + 上海 AI Lab）模仿专家；RFT 阶段用 **GRPO**（DeepSeek-R1 同款）微调，reward = 成功 + SPL；关键 trick **Time-Decayed Reward**——离目标近的步奖励越大。

**收益**：R2R-CE val-unseen SR：SFT 41% → RFT 49%（+8pt）；OOD 长指令鲁棒性提升；sim→real gap 缩小。RFT 有效原因：SFT 教模仿，RFT 教达成目标，目标导向 reward 更鲁棒。',
   null, null, '["VLN-R1 仍**两阶段**——纯 RL from scratch 在 VLN 上不收敛（探索太难），SFT 必须先做。RFT ≠ RLHF，前者是任务奖励，后者是偏好建模。"]'::jsonb, null, 8, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q31","freq_label":"历史低频·待核","provenance":"破例说明：频次 2 但来源权威（HK 大 + 上海 AI Lab arXiv 高引），代表 2025\"RL 微调 VLM\" 大方向，主表保留。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000408', 'panorama 全景输入 vs 单目 RGB 输入：哪种更接近真实部署？SmartWay / Fast-SmartWay 怎么取舍？', 'eaq-v07-q32', 'knowledge', 'medium', '| | **panorama**（12 视角 RGB-D） | **单目 RGB** |',
   '| | **panorama**（12 视角 RGB-D） | **单目 RGB** |
|---|---|---|
| FoV | 360° 无盲区 | 60-90° 有盲区 |
| 硬件 | 12 路相机 / 全景相机（贵） | 普通单目 |
| 计算 | 视觉特征 ×12 | 单帧 |
| 主要工作 | HAMT / DUET / ETPNav | NaVid / Fast-SmartWay / VLN-R1 |', '| | **panorama**（12 视角 RGB-D） | **单目 RGB** |
|---|---|---|
| FoV | 360° 无盲区 | 60-90° 有盲区 |
| 硬件 | 12 路相机 / 全景相机（贵） | 普通单目 |
| 计算 | 视觉特征 ×12 | 单帧 |
| 主要工作 | HAMT / DUET / ETPNav | NaVid / Fast-SmartWay / VLN-R1 |

**SmartWay / Fast-SmartWay**（2025）：前者用 panorama 简化 waypoint 预测 + MLLM；后者 **panoramic-free**——只 3 张前向 RGB-D 做端到端 MLLM 决策，速度 +50%，真机友好。

**实务**：学术 SOTA 仍 panorama 为主（信息全），**工业趋势是单目 + 头部转动**。NaVid / Fast-SmartWay 是后路线代表。',
   null, null, '["单目 ≠ 无空间感——agent 可转身获等效信息，只是多几步。真正取舍在\"训练时是否给 panorama\"，给了再单目蒸馏比直接单目训练好。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"VLN 视觉语言导航","qid":"Q32","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000409', 'ObjectNav 任务定义？success / SPL 在 HM3D-Sem / MP3D 上的标准评测设定', 'eaq-v07-q33', 'knowledge', 'easy', '**任务**：给定一个**类别名**（如 `chair` / `bed` / `tv`），agent 从随机起点开始探索房屋，最终停在目标类物体附近视野内。',
   '**任务**：给定一个**类别名**（如 `chair` / `bed` / `tv`），agent 从随机起点开始探索房屋，最终停在目标类物体附近视野内。', '**任务**：给定一个**类别名**（如 `chair` / `bed` / `tv`），agent 从随机起点开始探索房屋，最终停在目标类物体附近视野内。

**成功条件**（Habitat ObjectNav Challenge 标准）：
- 停止时距任意目标类物体实例 < 1 m
- 目标类物体在 agent 视野内
- 不超过 500 步

**指标**：
- **Success**：满足上述三条件
- **SPL**：成功率 × 最短路径占比
- **SoftSPL**：放宽 SPL 阈值（部分成功）

**数据集**：
- **HM3D-Sem**（Yadav 2022，1000+ 真实扫描场景）：当前 Challenge 主数据集
- **MP3D**：90 场景，更老
- **Gibson**：早期室内数据集',
   null, null, '["ObjectNav 的\"目标\"是**类别**而不是具体实例——房间里有 3 把椅子都行，只要走到任意一把视野内。这与 InstanceNav（找特定实例）和 ImageNav（找特定图像目标）不同。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q33","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000410', 'SemExp 的语义探索是怎么做的？为什么是 CVPR 2020 Habitat Challenge 冠军 baseline？', 'eaq-v07-q34', 'knowledge', 'medium', 'SemExp（Chaplot NeurIPS 2020）三模块：① **Semantic Map**：Mask R-CNN 检测 RGB-D 投到 2D BEV（每类一通道）；',
   'SemExp（Chaplot NeurIPS 2020）三模块：① **Semantic Map**：Mask R-CNN 检测 RGB-D 投到 2D BEV（每类一通道）；② **Goal-Oriented Semantic Policy**：在 semantic map 上**用 RL（PPO）学**选 long-term goal（哪个 frontier）；③ **Local Policy**：Fast Marching 走到 goal。', 'SemExp（Chaplot NeurIPS 2020）三模块：① **Semantic Map**：Mask R-CNN 检测 RGB-D 投到 2D BEV（每类一通道）；② **Goal-Oriented Semantic Policy**：在 semantic map 上**用 RL（PPO）学**选 long-term goal（哪个 frontier）；③ **Local Policy**：Fast Marching 走到 goal。

**为什么 work**：模块化（感知/探索/规划解耦）、类别先验（"chair 在客厅"等共现学到）、长期记忆（map 累积避免重搜）。

**Habitat 2020 Challenge 冠军**——SR 17.85%（当时 SOTA）；后续 PIRLNav 等在其上加 RL fine-tune。',
   null, null, '["SemExp **不是 zero-shot**——Mask R-CNN 闭集，新类别（不在 COCO 80）不行", "VLFM / OpenFMNav 才是\"open-set 升级\"。SemExp 强在 closed-set + 数据驱动，给足训练数据仍有竞争力。"]'::jsonb, null, 5, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q34","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000411', 'ZSON 怎么实现 zero-shot？image-goal pretraining + text/image goal embedding 共享', 'eaq-v07-q35', 'knowledge', 'medium', 'ZSON（Majumdar NeurIPS 2022）核心：**zero-shot 来自 CLIP 跨模态对齐**。',
   'ZSON（Majumdar NeurIPS 2022）核心：**zero-shot 来自 CLIP 跨模态对齐**。', 'ZSON（Majumdar NeurIPS 2022）核心：**zero-shot 来自 CLIP 跨模态对齐**。

**做法**：
1. **预训练**：在 ImageNav（给目标图像导航到拍照地）训 RL agent，目标用 CLIP image encoder 编码
2. **零样本部署到 ObjectNav**：把目标类别名走 CLIP text encoder，**text embedding 直接替代 image embedding** 喂给 agent
3. CLIP 图文对齐保证两者空间相近，agent 不微调可用

**巧妙之处**：避开了 ObjectNav 数据少的问题——ImageNav 合成便宜（任意场景任意位置都能合成图像目标），训了 100M+ 帧。

**结果**：HM3D ObjectNav zero-shot SR 25.5%（原文）；与 CoW 等不同 setting 数字不可直比，但 ZSON 是首个 image-goal 预训练 + CLIP 跨模态做到 SOTA 的方法。',
   null, null, '["ZSON 的\"zero-shot\"指**对 ObjectNav**——其 ImageNav 训练仍是大规模监督，不是完全无监督。CLIP 对齐精度也限制 ZSON 上限。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q35","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000412', 'L3MVN：LLM 怎么参与 frontier 选择？相比 SemExp 的核心收益？', 'eaq-v07-q36', 'knowledge', 'medium', 'L3MVN（Yu IROS 2023）思路：**用 LLM 作 frontier 选择的语义打分器**。',
   'L3MVN（Yu IROS 2023）思路：**用 LLM 作 frontier 选择的语义打分器**。', 'L3MVN（Yu IROS 2023）思路：**用 LLM 作 frontier 选择的语义打分器**。

**做法**：① 维护 semantic map；② 在边界 cell 提取 frontier 候选；③ 对每个 frontier 拼接 prompt：`"I want to find {goal}. Around frontier-i, I see {nearby_objects}. Score 0-10."`；④ LLM 输出分数选最高分作 long-term goal。

**相比 SemExp 收益**：零样本类别支持（LLM 知道 "toaster 在 kitchen" 常识）；解释性强（每步有 LLM 解释）；数据效率（不需要海量 ObjectNav 训练轨迹）。

**结果**：HM3D zero-shot SR 35.2%（vs SemExp 22.7% same setting）。',
   null, null, '["L3MVN 仍需**闭集语义分割**（COCO/LVIS）填 semantic map——只是 LLM 替代 goal policy，不是端到端零样本。完全开放词汇要等 VLFM/OpenFMNav。LLM 推理延迟（每步调一次）也是工程瓶颈。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q36","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000413', 'VLFM 的 value map 是什么？怎么把 BLIP-2 cos similarity 灌到 frontier 选择？', 'eaq-v07-q37', 'knowledge', 'medium', 'VLFM（Yokoyama ICRA 2024，arXiv 2312.03275）三步。',
   'VLFM（Yokoyama ICRA 2024，arXiv 2312.03275）三步：', 'VLFM（Yokoyama ICRA 2024，arXiv 2312.03275）三步：

1. **occupancy map**：深度反投影 → 2D 占用栅格 + frontier
2. **value map**：每帧 RGB 用 BLIP-2 算 `"a photo of {goal}"` cos similarity → 投到对应 BEV cell（前向 cone 内），多帧累积取 max
3. **frontier 选择**：选 value map 最大的 frontier 作 long-term goal，Fast Marching 走过去

**核心创新**：把 VLM 图文 similarity 当**密集的目标存在性 prior**——不是闭集类别，而是任意 prompt。完全开放词汇 + 空间记忆 + 零训练。

**结果**：HM3D zero-shot SR 52.5%——VLM-based zero-shot ObjectNav 2024 SOTA baseline。',
   null, null, '["prompt 工程敏感——`\"a photo of {goal}\"` 比裸 `\"{goal}\"` 显著更好。value map 投影是前向 cone，假设目标在视野中央方向，侧向目标会丢。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q37","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000414', 'OpenFMNav 相比 VLFM 的优势？open-set 怎么做？', 'eaq-v07-q38', 'knowledge', 'medium', 'OpenFMNav（Kuang NAACL 2024）针对 VLFM 两问题：① BLIP-2 query 粗粒度（全图 cos sim）不精确；',
   'OpenFMNav（Kuang NAACL 2024）针对 VLFM 两问题：① BLIP-2 query 粗粒度（全图 cos sim）不精确；② 自由形式指令（"找绿色马克杯"）效果差。', 'OpenFMNav（Kuang NAACL 2024）针对 VLFM 两问题：① BLIP-2 query 粗粒度（全图 cos sim）不精确；② 自由形式指令（"找绿色马克杯"）效果差。

**改造**：① **PNP**（Prompt-based Navigation Planner）：LLM 解析指令拆出关键物体 + 属性；② **Open-Set Detector**：GLIP / Grounding DINO 替代 BLIP-2 cos sim 给 bbox；③ **VSSM**（Versatile Semantic Score Map）：聚合 open-set 检测分数到地图，支持 PNP 引导下的目标 / 中间物体打分。

**核心区别**：VLFM 图文整体 similarity 粒度粗；OpenFMNav 开放词汇 detection 粒度精 + 属性可控。结果：HM3D zero-shot SR ~54.9%（vs VLFM 52.5%，不同 setting 略有出入）；自由形式指令 +10pt。',
   null, null, '["OpenFMNav 调用链长（LLM + Grounding DINO + LLM scoring）单步 1-3 s", "VLFM BLIP-2 单步 300-500 ms 更接近实时。工程上 VLFM 仍是首选 baseline。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q38","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000415', 'CoW (CLIP-on-Wheels)：为什么 zero-shot 简单方法能打过学习方法？', 'eaq-v07-q39', 'knowledge', 'medium', 'CoW（Gadre CVPR 2023，arXiv 2203.10421）极简方案：CLIP 定位（每帧 RGB 拆 patch + image-text similarity 找最像目标的 patch）+ 经典 FB…',
   'CoW（Gadre CVPR 2023，arXiv 2203.10421）极简方案：CLIP 定位（每帧 RGB 拆 patch + image-text similarity 找最像目标的 patch）+ 经典 FBE 探索（1997 算法）+ depth 反投影；**无任何训练**。', 'CoW（Gadre CVPR 2023，arXiv 2203.10421）极简方案：CLIP 定位（每帧 RGB 拆 patch + image-text similarity 找最像目标的 patch）+ 经典 FBE 探索（1997 算法）+ depth 反投影；**无任何训练**。

**为什么打过学习方法**：当时学习方法（SemExp、ZER）**强依赖训练分布**，HM3D 训练在 Gibson 测就崩；CLIP 4 亿图文对预训练泛化强；经典 FBE 简单可靠不受数据漂移影响。

**结果**：HM3D ObjectNav zero-shot SR 12-25%（不同 CLIP backbone），在零样本设定下优于同期 ZSON / SemExp。

**深层意义**：CoW 揭示了"**学习方法在 OOD 上 vs zero-shot 基线**"——2023 之后 zero-shot ObjectNav 主线开端。',
   null, null, '["CoW 在**复杂指令**（自由形式）上不行——只能吃单类别名，属性 / 关系 / 空间介词都 handle 不了。VLFM / OpenFMNav 是 CoW 思路的 \"VLM 升级版\"。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q39","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000416', 'Frontier + LLM 评分 vs 端到端 RL：哪种更适合零样本泛化？训练-推理代价对比', 'eaq-v07-q40', 'knowledge', 'hard', '| | **Frontier + LLM 评分**（L3MVN / VLFM 系） | **端到端 RL**（DD-PPO / Habitat-Web） |',
   '| | **Frontier + LLM 评分**（L3MVN / VLFM 系） | **端到端 RL**（DD-PPO / Habitat-Web） |
|---|---|---|
| 训练 | 零训练 | 1B+ steps RL（数千 GPU 小时） |
| 推理延迟 | 每步 0.3-3 s（VLM call） | 单帧 < 30 ms |
| 零样本类别 | ✅ 任意类别 | ❌ 只能训练集见过 |
| 跨场景泛化 | ✅ 强（VLM 内置常识） | ⚠️ 弱（OOD 易崩） |
| 真机迁移 | ✅ 不依赖训练数据分布 | ❌ sim-to-real gap 大 |
| 长程效率 | ⚠️ FBE 探索次优 | ✅ RL 能学到高效路径 |', '| | **Frontier + LLM 评分**（L3MVN / VLFM 系） | **端到端 RL**（DD-PPO / Habitat-Web） |
|---|---|---|
| 训练 | 零训练 | 1B+ steps RL（数千 GPU 小时） |
| 推理延迟 | 每步 0.3-3 s（VLM call） | 单帧 < 30 ms |
| 零样本类别 | ✅ 任意类别 | ❌ 只能训练集见过 |
| 跨场景泛化 | ✅ 强（VLM 内置常识） | ⚠️ 弱（OOD 易崩） |
| 真机迁移 | ✅ 不依赖训练数据分布 | ❌ sim-to-real gap 大 |
| 长程效率 | ⚠️ FBE 探索次优 | ✅ RL 能学到高效路径 |

**实务结论**：
- **零样本必须用** frontier + LLM 路线（VLFM / OpenFMNav）
- **闭集 + 大量训练数据** RL 仍最优（HM3D 闭集 SR 70%+）
- **混合**：PIRLNav 先 IL 后 RL 是闭集 SOTA；VLFM + RL 微调是 2025 新方向',
   null, null, '["不是\"zero-shot 一定比 RL 强\"——闭集设定下端到端 RL 仍 dominate", "只是工业部署需要 zero-shot，所以前者更受关注。延迟敏感场景（如人形实时反应）frontier+LLM 路线仍有挑战。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q40","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000417', 'PIRLNav 的 IL+RL 两阶段：IL warm-up 解决什么？RL fine-tune 又解决什么？', 'eaq-v07-q41', 'knowledge', 'medium', 'PIRLNav（Ramrakhya CVPR 2023）针对纯 RL 在 ObjectNav 上不收敛——**reward 稀疏**（只在终点给）+ 探索空间大。',
   'PIRLNav（Ramrakhya CVPR 2023）针对纯 RL 在 ObjectNav 上不收敛——**reward 稀疏**（只在终点给）+ 探索空间大。', 'PIRLNav（Ramrakhya CVPR 2023）针对纯 RL 在 ObjectNav 上不收敛——**reward 稀疏**（只在终点给）+ 探索空间大。

**两阶段**：① **IL warm-up**：在 70k 人类演示上 behavior cloning，先学"基础行走 + 看到物体停下"；② **RL fine-tune**：PPO 在 IL 检查点继续 1B steps，reward = 成功 + 接近 + 探索。

**为什么必须两阶段**：纯 IL 模仿专家但 OOD 崩；纯 RL reward 太稀疏（500 步 episode 通常 0 reward）；IL 提供可执行 baseline，RL 扩张优化效率。

**结果**：HM3D **closed-set** ObjectNav SR 65%（IL+RL 工作 SOTA）。',
   null, null, '["PIRLNav 是**闭集** SOTA，不是 zero-shot——和 VLFM / OpenFMNav 不在同一赛道。两路\"SR 数字\"不可直比（PIRLNav 训练见过 chair，VLFM 没见过）。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q41","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000418', '零样本 ObjectNav 在真实机器人上的核心瓶颈是什么？sim-to-real 最大 gap 在哪？', 'eaq-v07-q42', 'knowledge', 'hard', '三大瓶颈：① **深度感知**（仿真 GT depth vs 真实 RealSense 噪声 / 反光 / 黑色物体丢深度 → VLFM value map 投影直接受影响）；',
   '三大瓶颈：① **深度感知**（仿真 GT depth vs 真实 RealSense 噪声 / 反光 / 黑色物体丢深度 → VLFM value map 投影直接受影响）；② **场景结构**（HM3D 真实扫描但**无动态物体**，真机场景常变，frontier 探索逻辑要重设计）；③ **语义检测**（Grounding DINO 仿真 mAP ~50，真机相机畸变/光照下掉 10-15pt，错传到上层选 frontier）。', '三大瓶颈：① **深度感知**（仿真 GT depth vs 真实 RealSense 噪声 / 反光 / 黑色物体丢深度 → VLFM value map 投影直接受影响）；② **场景结构**（HM3D 真实扫描但**无动态物体**，真机场景常变，frontier 探索逻辑要重设计）；③ **语义检测**（Grounding DINO 仿真 mAP ~50，真机相机畸变/光照下掉 10-15pt，错传到上层选 frontier）。

**次级**：控制器 sim2real（PointNav 仿真 95% → 真机 70-80%）、指令歧义（"那个红色杯子"agent 不知道哪个房间）、长程可靠性（500 步真机 5-10 分钟，传感器漂移 / 电量 / 网络）。

**缓解**：VLM 真机相机微调（域适应）、保守 frontier 策略、failure 检测 + recover。',
   null, null, '["不要以为\"零样本\"就 sim2real 友好——VLM 在网络图像训练，**与真机相机仍有 gap**", "零样本只是不需要场景级训练，但 VLM 训练分布仍重要。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"零样本 ObjectNav","qid":"Q42","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000419', 'CLIP 和 SigLIP 在 embodied 里的角色？为什么 SigLIP 在小 batch 下更好？', 'eaq-v07-q43', 'knowledge', 'easy', '**CLIP**（Radford OpenAI 2021）：图文对比预训练 + softmax；',
   '**CLIP**（Radford OpenAI 2021）：图文对比预训练 + softmax；4 亿图文对（OpenCLIP/LAION 系 2B+）；图文 encoder 独立。', '**CLIP**（Radford OpenAI 2021）：图文对比预训练 + softmax；4 亿图文对（OpenCLIP/LAION 系 2B+）；图文 encoder 独立。

**SigLIP**（Zhai Google 2023）：把 softmax 换成 **sigmoid 二分类**——每对图文独立判断 match，不再相互归一化。

**为什么 SigLIP 小 batch 更好**：CLIP softmax 的 partition function 在 batch 内归一化，需超大 batch（32k+）；SigLIP 每对独立计算，batch 影响小，小 batch 下 ImageNet 0-shot 高 CLIP 5-10pt。

**embodied 应用**：大批量预训练 → CLIP / OpenCLIP；实时 query / 端侧 → SigLIP（推理快、batch=1 稳）；多语长文 → SigLIP-So400m / SigLIP2。',
   null, null, '["SigLIP **不是 CLIP 升级版**——大 batch 充足时 CLIP 仍持平", "embodied 圈用 CLIP 多是因生态成熟，不是 SigLIP 更弱。"]'::jsonb, null, 3, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q43","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000420', 'Grounding DINO 是怎么做开放词汇检测的？vs OWL-ViT 区别？', 'eaq-v07-q44', 'knowledge', 'easy', '**Grounding DINO**（Liu IDEA 2023，arXiv 2303.05499）：基于 DINO 检测器（Zhang ICLR 2023，与 Caron 自监督 DINO 同名不同），文本 prom…',
   '**Grounding DINO**（Liu IDEA 2023，arXiv 2303.05499）：基于 DINO 检测器（Zhang ICLR 2023，与 Caron 自监督 DINO 同名不同），文本 prompt 经 BERT 编码后在 backbone + transformer 多层与图像做 **deep fusion**。', '**Grounding DINO**（Liu IDEA 2023，arXiv 2303.05499）：基于 DINO 检测器（Zhang ICLR 2023，与 Caron 自监督 DINO 同名不同），文本 prompt 经 BERT 编码后在 backbone + transformer 多层与图像做 **deep fusion**。

**OWL-ViT**（Minderer Google 2022）：ViT + DETR 头，**晚期融合**——CLIP 预训练 + detection 微调，编码器独立最后点积；OWL-v2 加 self-training 提升。

| | Grounding DINO | OWL-ViT/v2 |
|---|---|---|
| 融合 | 多层 cross-attention | 最后点积 |
| LVIS mAP | ~40 | ~36 |
| 速度 | 150-300 ms | 50-100 ms |

**实务**：高精度离线 → GD 1.5；实时机器人 → OWL-v2 / GD-Tiny。',
   null, null, '["开放词汇检测 ≠ zero-shot 分类——前者要 bbox。Grounding DINO 也不是\"任意 prompt 都行\"，长 phrase / 抽象概念（\"舒适的椅子\"）效果差。"]'::jsonb, null, 3, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q44","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000421', 'SAM 2 相比 SAM v1 的核心进步？视频 / 流式怎么做？', 'eaq-v07-q45', 'knowledge', 'medium', '**SAM v1**（Kirillov Meta 2023）：单图像分割，prompt（点/框/mask）→ mask；',
   '**SAM v1**（Kirillov Meta 2023）：单图像分割，prompt（点/框/mask）→ mask；1B+ mask 训练。', '**SAM v1**（Kirillov Meta 2023）：单图像分割，prompt（点/框/mask）→ mask；1B+ mask 训练。

**SAM 2**（Ravi Meta 2024，SA-V 数据集 5 万视频 + 60 万 masklets）加 **memory bank + streaming attention**：
- 前帧 mask + features 入 memory，下一帧 decoder 通过 cross-attention 访问 → **时序一致**
- 第 1 帧给 prompt，后续帧自动 propagate；单帧 ~30 ms（v1 ~100 ms）

**embodied 应用**：物体跟踪（teleop / VLN 长程记忆）、地面分割（locomotion controller 输入）。',
   null, null, '["SAM 2 仍**需要 prompt**，不主动检测——要 open-vocab 自动分割得配 Grounding DINO（Grounded-SAM 2 组合）。memory bank 是隐式特征 cache，不是显式物体级 ID，多个相似物体易 mask 混淆。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q45","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000422', 'VLMaps 是怎么构建的？landmark indexing 怎么做？', 'eaq-v07-q46', 'knowledge', 'medium', 'VLMaps（Huang ICRA 2023）核心：**把 LSeg/CLIP 的 pixel-level 特征反投影到 BEV 体素地图**。',
   'VLMaps（Huang ICRA 2023）核心：**把 LSeg/CLIP 的 pixel-level 特征反投影到 BEV 体素地图**。', 'VLMaps（Huang ICRA 2023）核心：**把 LSeg/CLIP 的 pixel-level 特征反投影到 BEV 体素地图**。

**构建步骤**：
1. agent 走过环境采 RGB-D
2. 每帧 RGB 过 **LSeg**（CLIP 像素级版本）得 pixel-level 特征图
3. depth + camera pose 反投影 3D → 压到 BEV grid
4. 多帧累积：同一 cell 多帧特征加权平均（按视角置信度）

**landmark indexing**：给文本 query（"go to the sofa"），CLIP 文本编码 → BEV map 每个 cell 算 cos similarity → top-K cell 作 landmark，规划器走到 max 处。

**强项**：零样本开放词汇 + 空间结构化（BEV 可直接规划） + 跨任务通用（landmark / region / spatial relation 都能查）。',
   null, null, '["VLMaps 特征聚合是**简单平均**，不分前/背景——天花板地板会污染同一 cell", "ConceptFusion / OpenScene 用 mask-aware 聚合改进。LSeg 训练数据小，long-tail 物体仍弱。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q46","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000423', 'ConceptFusion：open-set 3D map 怎么把多模态特征融合进去？', 'eaq-v07-q47', 'knowledge', 'medium', 'ConceptFusion（Jatavallabhula RSS 2023）思路：**多基础模型（CLIP / DINO / AudioCLIP）特征统一融合到 3D map**。',
   'ConceptFusion（Jatavallabhula RSS 2023）思路：**多基础模型（CLIP / DINO / AudioCLIP）特征统一融合到 3D map**。', 'ConceptFusion（Jatavallabhula RSS 2023）思路：**多基础模型（CLIP / DINO / AudioCLIP）特征统一融合到 3D map**。

**做法**：走环境采 RGB-D → 每帧用 Mask2Former 分割，每个 instance 用 CLIP 抽特征 + 全图 CLIP global feature → pixel 特征 = global + per-mask 加权（防背景污染）→ 反投影 3D 体素，多帧累积。

**multimodal 查询**：text / image / audio / 3D click 全部映射到同一特征空间做 cos similarity。

**对比 VLMaps**：VLMaps BEV 2.5D，只 CLIP 文本；ConceptFusion 完整 3D + 多模态查询 + mask-aware 聚合。',
   null, null, '["ConceptFusion **离线建图**——非实时增量，建图后查询很快但建图本身需要走全场景。multimodal 主要是**查询模态多样**，存储仍是 CLIP 特征", "audio query 先转 CLIP-aligned vector 再查。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q47","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000424', 'Grounded-SAM (DINO + SAM) 在 embodied pipeline 里典型用法？', 'eaq-v07-q48', 'knowledge', 'medium', '**Grounded-SAM**（IDEA 2023）= Grounding DINO 给 bbox + SAM 给 mask 的级联。',
   '**Grounded-SAM**（IDEA 2023）= Grounding DINO 给 bbox + SAM 给 mask 的级联：', '**Grounded-SAM**（IDEA 2023）= Grounding DINO 给 bbox + SAM 给 mask 的级联：

```
RGB → Grounding DINO("the red cup") → bbox →
SAM (prompt=bbox) → pixel-precise mask
```

**embodied 典型用法**：
1. **抓取目标定位**：text → mask → mask 内点云均值作抓取中心
2. **导航语义地图**：每帧 detect + segment → 投影到 BEV semantic map
3. **遥操作辅助**：人指 "拿那个杯子"，自动框选 + 提示
4. **数据标注**：teleop 数据后处理时自动给物体 mask

**vs Grounded-SAM 2**：SAM v1 → SAM 2 升级后视频流式 mask 跟踪，对**连续操作 / VLN**更友好。',
   null, null, '["Grounded-SAM 是**两次模型调用**，单帧延迟 300-800 ms（GPU），实时场景需要 model distillation 或 cache。Grounding DINO 给的 bbox 不准时，SAM 的 mask 也跟着错——上下游都有失效模式。"]'::jsonb, null, 5, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q48","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000425', 'VLM 在 zero-shot nav 里的幻觉问题怎么处理？常见缓解策略', 'eaq-v07-q49', 'knowledge', 'medium', 'VLM 幻觉两类典型场景：① 目标不存在但 VLM 说存在（把茶几误判为 sofa → frontier 偏向假目标）；',
   'VLM 幻觉两类典型场景：① 目标不存在但 VLM 说存在（把茶几误判为 sofa → frontier 偏向假目标）；② 指令偏差（"绿色马克杯"被 VLM 关注"绿色"忽略"马克杯"找到绿色背包）。', 'VLM 幻觉两类典型场景：① 目标不存在但 VLM 说存在（把茶几误判为 sofa → frontier 偏向假目标）；② 指令偏差（"绿色马克杯"被 VLM 关注"绿色"忽略"马克杯"找到绿色背包）。

**缓解策略**：
- **多帧验证**：同物体 K 帧一致检测才确认
- **几何先验**：sofa 高度 0.4-0.8 m，与 depth-derived 高度矛盾就拒
- **多 prompt ensemble**：`"a photo of a sofa"` / `"sofa in a living room"` 取平均
- **score 阈值**：cos sim < 0.25 直接不算
- **VLM 二次确认**：找到候选后让 GPT-4V "is this {goal}? yes/no"
- **闭环 verification**：靠近后再确认

**实务**：VLFM / OpenFMNav 默认用前 2-3 个策略；真机部署加入 VLM 二次确认。',
   null, null, '["幻觉**不能完全消除**——VLM 内在限制", "只能降低概率到可接受水平。调试时优先看 false positive（看到不存在的目标）而非 false negative，因 FP 直接导致任务失败。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q49","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000426', 'VLM 推理延迟 vs 准确率 trade-off：cloud-edge 协同 / cache / batched query 怎么取舍？', 'eaq-v07-q50', 'knowledge', 'medium', '**延迟**：Grounding DINO 单帧 150-300 ms（A100）；',
   '**延迟**：Grounding DINO 单帧 150-300 ms（A100）；BLIP-2 / SigLIP 50-100 ms；GPT-4V API 1-3 s。', '**延迟**：Grounding DINO 单帧 150-300 ms（A100）；BLIP-2 / SigLIP 50-100 ms；GPT-4V API 1-3 s。

**策略**：
| 策略 | 收益 | 代价 |
|---|---|---|
| 小模型蒸馏 | 5-10× 速度 | 5-15pt 精度损失 |
| cloud-edge 协同 | 准 + 低端侧算力 | 网络抖动 / 隐私 |
| frame skip | 线性加速 | 错过快速变化 |
| VLM cache | 同场景同 query 重用 | 动态场景失效 |
| batched query | 多 frontier 一次过 | 跨帧不行 |
| Cascade 早退 | 简单帧用小模型 | 复杂度判断难 |

**实务架构**：高频感知（30 Hz）用蒸馏小 VLM；低频规划（1 Hz）用大 VLM / LLM；二者通过 semantic map 解耦。',
   null, null, '["不是\"VLM 越大越准\"——小 VLM + 任务微调反而更稳。**真实瓶颈往往不是 VLM**：相机 IO（USB 30 FPS）、网络（云端 200+ ms）、控制频率上限。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q50","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000427', 'prompt 工程在 zero-shot nav 中的重要性？chain-of-thought 真的有用吗？', 'eaq-v07-q51', 'knowledge', 'hard', '**prompt 工程**对 zero-shot nav 收益**显著**：`"a photo of a {goal}"` 比裸 `"{goal}"` 在 VLFM 上 +5-10pt SR；',
   '**prompt 工程**对 zero-shot nav 收益**显著**：`"a photo of a {goal}"` 比裸 `"{goal}"` 在 VLFM 上 +5-10pt SR；`"the goal is in {room_type}"`（加 room context）+3-5pt；多 prompt ensemble +2-4pt。', '**prompt 工程**对 zero-shot nav 收益**显著**：`"a photo of a {goal}"` 比裸 `"{goal}"` 在 VLFM 上 +5-10pt SR；`"the goal is in {room_type}"`（加 room context）+3-5pt；多 prompt ensemble +2-4pt。

**CoT 在导航里**：
- **有用**：高层任务规划——"bedroom 先看床、kitchen 先看橱柜"；NaVILA / NaviLLM 都用 CoT-style prompt
- **无用 / 有害**：低层动作选择——"前进 0.25 m 还是 0.5 m" 用 CoT 反而引入噪声 + 延迟
- **VLN-R1 / Nav-R1 (2025)**：把 CoT 蒸馏到 SFT 阶段，推理时无需显式 CoT 效果保留

**关键判断**：CoT 用于**语义推理**有效，用于**几何 / 控制**无效——LLM 不擅长空间数值推理。',
   null, null, '["CoT 不是免费午餐——token 数翻倍 → 延迟翻倍", "CoT 输出可能\"圆滑而错\"。生产代码 CoT 通常**离线评估**保留，在线折叠成 SFT 数据。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q51","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000428', 'open-vocabulary 检测 vs 闭集检测在导航里：什么时候必须开放词汇？', 'eaq-v07-q52', 'knowledge', 'medium', '| | **闭集**（COCO 80 / LVIS 1200） | **open-vocabulary** |',
   '| | **闭集**（COCO 80 / LVIS 1200） | **open-vocabulary** |
|---|---|---|
| 类别 | 训练集固定 | 任意文本 prompt |
| 精度 | 高（per-class fine-tuned） | 略低 |
| 速度 | 快（YOLO 5-30 ms） | 慢（150-500 ms） |
| 训练 | 一次性 | 不需要 |', '| | **闭集**（COCO 80 / LVIS 1200） | **open-vocabulary** |
|---|---|---|
| 类别 | 训练集固定 | 任意文本 prompt |
| 精度 | 高（per-class fine-tuned） | 略低 |
| 速度 | 快（YOLO 5-30 ms） | 慢（150-500 ms） |
| 训练 | 一次性 | 不需要 |

**必须开放词汇**：REVERIE/SOON 含未知物体（"我的眼镜"）；自由形式 ObjectNav；长 tail 操作（古董花瓶）。

**闭集够用**：家庭服务（类别预定义）；实时性硬约束（自驾 30 Hz）；嵌入式资源受限。

**实务混合**：高频通道闭集快速检测（YOLO），低频通道（1-2 Hz）开放词汇兜底新类别——zero-shot ObjectNav 常见工程方案。',
   null, null, '["开放词汇**不等于\"无所不知\"**——Grounding DINO 在 long tail / 抽象概念上仍弱。\"开放词汇 → 解决一切\"是误区", "闭集 + 大量训练在已知任务上仍最强。"]'::jsonb, null, 5, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"Embodied VLM","qid":"Q52","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000429', 'Habitat vs AI2-THOR vs iGibson 三大仿真器的区别？为什么 ObjectNav 主流用 Habitat？', 'eaq-v07-q53', 'knowledge', 'hard', '| | **Habitat 2/3** | **AI2-THOR** | **iGibson 2.0** |',
   '| | **Habitat 2/3** | **AI2-THOR** | **iGibson 2.0** |
|---|---|---|---|
| 场景 | MP3D / HM3D 真实扫描 | Unity 交互式资产场景（ProcTHOR 是程序化扩展） | 真实 + 程序混合 |
| 物理 / 交互 | 简化（Habitat 3 加 humanoid） | 符号化交互强 | PyBullet 完整物理 |
| 渲染速度 | **10000+ FPS** | 100-1000 FPS | 10-100 FPS |
| 主用 | ObjectNav / VLN-CE | 任务规划 / 长程交互 | 操作 + 导航联合 |', '| | **Habitat 2/3** | **AI2-THOR** | **iGibson 2.0** |
|---|---|---|---|
| 场景 | MP3D / HM3D 真实扫描 | Unity 交互式资产场景（ProcTHOR 是程序化扩展） | 真实 + 程序混合 |
| 物理 / 交互 | 简化（Habitat 3 加 humanoid） | 符号化交互强 | PyBullet 完整物理 |
| 渲染速度 | **10000+ FPS** | 100-1000 FPS | 10-100 FPS |
| 主用 | ObjectNav / VLN-CE | 任务规划 / 长程交互 | 操作 + 导航联合 |

**为什么 ObjectNav 主流用 Habitat**：① 渲染速度（RL 需 1B+ frames，唯一可大规模）；② HM3D 1000+ 真实房屋扫描，规模/真实/标注最优；③ Habitat Challenge 每年办，CVPR Embodied AI 默认平台。',
   null, null, '["Habitat 3 加 humanoid + 物理交互，已追赶 AI2-THOR", "别按 2020 旧知识答\"Habitat 不能交互\"。NeurIPS 2024 / 2025 Embodied AI 主流仍 Habitat-Lab。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"端到端 VLN-VLA 与前沿判断","qid":"Q53","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000430', 'VLN 在真实机器人 vs 仿真的最大 gap 在哪？哪些 trick 能拉近？', 'eaq-v07-q54', 'knowledge', 'hard', '主要差距包括图像和深度成像、动态场景、定位与控制误差、通信延迟，以及真实语言指令的分布。',
   '主要差距包括图像和深度成像、动态场景、定位与控制误差、通信延迟，以及真实语言指令的分布。先对齐动作接口、坐标系、相机预处理、成功定义和评测时限，再分模块回放定位问题；可用有针对性的随机化、真实数据适配、闭环反馈和失败恢复验证改进。报告成功率、路径效率及失败类别。', '主要差距包括图像和深度成像、动态场景、定位与控制误差、通信延迟，以及真实语言指令的分布。先对齐动作接口、坐标系、相机预处理、成功定义和评测时限，再分模块回放定位问题；可用有针对性的随机化、真实数据适配、闭环反馈和失败恢复验证改进。报告成功率、路径效率及失败类别。',
   null, null, '["不能通过放宽成功距离、延长时限或挑选场景后，直接宣称原指标提升", "协议变更必须单列，不能与原结果作同口径比较。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"端到端 VLN-VLA 与前沿判断","qid":"Q54","freq_label":"🔥×3","provenance":"核验：[具身导航评测建议](https://arxiv.org/abs/1807.06757)、[NaVid 作者页](https://pku-epic.github.io/NaVid/)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000431', '怎样判断 VLM 直接做导航策略的可行性？应与任务规划和机器人操作怎样区分？', 'eaq-v07-q55', 'knowledge', 'hard', '可行性要按具体系统的输入输出、地图依赖、训练数据和动作空间讨论。',
   '可行性要按具体系统的输入输出、地图依赖、训练数据和动作空间讨论。例如 NaVid 从视频与指令预测导航动作；RoboFlamingo 的原工作研究语言条件操作、主要使用 CALVIN，不能据此称其为端到端 VLN。判断真机价值还需测延迟、反馈频率、失败恢复、未见场景与底层接口，而非只比较单一成功率。', '可行性要按具体系统的输入输出、地图依赖、训练数据和动作空间讨论。例如 NaVid 从视频与指令预测导航动作；RoboFlamingo 的原工作研究语言条件操作、主要使用 CALVIN，不能据此称其为端到端 VLN。判断真机价值还需测延迟、反馈频率、失败恢复、未见场景与底层接口，而非只比较单一成功率。',
   null, null, '["VLM 作为任务规划器、直接动作策略、经典控制器的条件输入，是不同架构", "“端到端”本身不证明更强，也不能给出无统计依据的行业占比。"]'::jsonb, null, 8, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"端到端 VLN-VLA 与前沿判断","qid":"Q55","freq_label":"🔥×3","provenance":"核验：[NaVid 作者页](https://pku-epic.github.io/NaVid/)、[RoboFlamingo ICLR 论文](https://proceedings.iclr.cc/paper_files/paper/2024/hash/71639c317fb0bf398835627b4418693e-Abstract-Conference.html)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000432', 'VLFM vs OpenFMNav 选哪个作 zero-shot baseline？', 'eaq-v07-q56', 'knowledge', 'hard', '实务推荐 **VLFM** 作首选 baseline，OpenFMNav 在以下情况下用。',
   '实务推荐 **VLFM** 作首选 baseline，OpenFMNav 在以下情况下用：', '实务推荐 **VLFM** 作首选 baseline，OpenFMNav 在以下情况下用：

| 选择 | 理由 |
|---|---|
| **VLFM 优先** | ① 单 VLM 调用（BLIP-2），延迟稳定；② 代码极简，复现快；③ HM3D zero-shot SR 52.5% 已经够 benchmark |
| **OpenFMNav 优先** | ① 自由形式指令（属性 + 关系）；② 罕见类别需要开放词汇检测；③ 不在意延迟（OpenFMNav 单步 1-3 s） |

**复现成本**：VLFM 在 Habitat 上 1-2 周可复现 → 论文 baseline 大部分都引用 VLFM。',
   null, null, '["不要在文章里写\"我们的 baseline 是 VLFM\"然后用 OpenFMNav 设置 evaluate ——两者**任务定义和数据 split 都需对齐**才能公平比较。HM3D ObjectNav 与 HM3D-Sem **不是同一个评测**——有些工作混用。"]'::jsonb, null, 8, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"端到端 VLN-VLA 与前沿判断","qid":"Q56","freq_label":"历史低频·待核","provenance":"破例说明：本题频次 2 但来自论文 baseline 选择实务问题，权威工作（VLFM ICRA 2024 / OpenFMNav NAACL 2024）双独立来源，主表保留。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000433', '怎样有依据地讨论导航的未来方向，并设计验证方案？', 'eaq-v07-q57', 'knowledge', 'hard', '把观点写成可检验假设：预测模型能否减少长程规划错误，记忆与结果验证能否改善多步任务，多机器人共享信息能否提升覆盖率。',
   '把观点写成可检验假设：预测模型能否减少长程规划错误，记忆与结果验证能否改善多步任务，多机器人共享信息能否提升覆盖率。每项都说明基线、未见场景、额外算力与通信成本，以及失败时的替代方案。区分已有实验结论、自己的推论和仍待验证的目标，不给没有证据的实现年份。', '把观点写成可检验假设：预测模型能否减少长程规划错误，记忆与结果验证能否改善多步任务，多机器人共享信息能否提升覆盖率。每项都说明基线、未见场景、额外算力与通信成本，以及失败时的替代方案。区分已有实验结论、自己的推论和仍待验证的目标，不给没有证据的实现年份。',
   null, null, '["开放题允许判断，不允许把预测当事实", "不能由单机或操作论文推出所有导航任务已接近天花板。"]'::jsonb, null, 8, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"端到端 VLN-VLA 与前沿判断","qid":"Q57","freq_label":"历史低频·待核","provenance":"核验：[具身导航评测建议](https://arxiv.org/abs/1807.06757)。本题频次沿用历史记录，本轮只修订答案。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000434', '百万张图里只有少量目标类别，怎样筛出有效且类别均衡的检测训练集？', 'eaq-v07-q58', 'knowledge', 'medium', '先定义目标类别、场景覆盖和标注标准，留出独立验证集；',
   '先定义目标类别、场景覆盖和标注标准，留出独立验证集；用已有检测器、视觉语言检索或元数据做粗筛，再人工抽检估计误检与漏检。按类别、场景、难度和重复度分层采样，补充困难负例及稀有类，迭代训练与清洗，并保存筛选规则和版本。', '先定义目标类别、场景覆盖和标注标准，留出独立验证集；用已有检测器、视觉语言检索或元数据做粗筛，再人工抽检估计误检与漏检。按类别、场景、难度和重复度分层采样，补充困难负例及稀有类，迭代训练与清洗，并保存筛选规则和版本。',
   null, null, '["模型高分不等于标签正确", "只取最高分容易丢掉困难样本，连续帧近重复也不能当成新的数据多样性。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"本次公开面经增补：数据筛选与导航排障","qid":"Q58","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/2848ed4b83034fbaad17f0166c956d2b?sourceSSR=post)；具身智能算法实习岗；原问是检测数据筛选，不是 VLA 示教筛选；原帖创建 2026-07-16，编辑/展示 2026-07-17（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[CLIP 原论文](https://arxiv.org/abs/2103.00020)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000435', 'Nav2 控制机器人直行却左右摇摆，怎样区分规划问题和底层执行问题？', 'eaq-v07-q59', 'knowledge', 'medium', '同步查看全局路径、局部控制输出、实际速度、odom 和 TF。',
   '同步查看全局路径、局部控制输出、实际速度、odom 和 TF。若路径或角速度指令先振荡，查局部代价地图、定位跳变、控制器参数及速度／加速度约束；若指令平稳而机器人摆动，查轮速闭环、左右轮尺度、机械间隙和通信时延。逐层回放或替换固定指令定位。', '同步查看全局路径、局部控制输出、实际速度、odom 和 TF。若路径或角速度指令先振荡，查局部代价地图、定位跳变、控制器参数及速度／加速度约束；若指令平稳而机器人摆动，查轮速闭环、左右轮尺度、机械间隙和通信时延。逐层回放或替换固定指令定位。',
   null, null, '["加平滑器不是通用修复", "不准确或高延迟的里程计、时间戳和 TF 应先校正。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"本次公开面经增补：数据筛选与导航排障","qid":"Q59","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/dc466dc7d2b74b0281f4d852735159cb)；匿名机器人初创企业导航算法岗；原帖创建 2026-08-24（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Nav2 速度平滑器说明](https://docs.nav2.org/rolling/configuration_and_development/configuration_guide/core_servers/configuring_velocity_smoother/)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000436', 'Nav2 缩小障碍物膨胀区能否帮助通过窄道？怎样评估碰撞风险？', 'eaq-v07-q60', 'knowledge', 'medium', '膨胀层把障碍物周围的距离转换为代价，让规划器倾向保留安全间隙；',
   '膨胀层把障碍物周围的距离转换为代价，让规划器倾向保留安全间隙；半径决定影响范围，代价缩放参数影响随距离的衰减。调参前核对 footprint、地图分辨率、障碍物标记和定位误差，再观察路径与局部控制器评分。保留真实碰撞约束，通过窄道与贴障测试验证。', '膨胀层把障碍物周围的距离转换为代价，让规划器倾向保留安全间隙；半径决定影响范围，代价缩放参数影响随距离的衰减。调参前核对 footprint、地图分辨率、障碍物标记和定位误差，再观察路径与局部控制器评分。保留真实碰撞约束，通过窄道与贴障测试验证。',
   null, null, '["膨胀层的软代价与机器人真实外形不同", "为“能通过”而缩小 footprint 或忽视定位误差可能掩盖碰撞风险。"]'::jsonb, null, 5, false, true, 1, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"本次公开面经增补：数据筛选与导航排障","qid":"Q60","freq_label":"低频实录·1源","provenance":"题源：[公开面经原帖](https://www.nowcoder.com/feed/main/detail/dc466dc7d2b74b0281f4d852735159cb)；匿名机器人初创企业导航算法岗；原帖创建 2026-08-24（公开 HTML 结构化记录核实）；面试年份未核。\n\n核验：[Nav2 Inflation Layer](https://docs.nav2.org/rolling/configuration_and_development/configuration_guide/core_servers/costmap_2d/costmap_plugins/inflation/)。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000437', '手撕 IoU（两个矩形框）', 'eaq-v07-h01', 'coding', 'easy', '交并比；',
   '交并比；`max(0,·)` 防负宽高；axis-aligned 与 rotated 求法差异。', '**考察点**：交并比；`max(0,·)` 防负宽高；axis-aligned 与 rotated 求法差异。

**实现**：

```python
import numpy as np

def iou(a, b):
    # a, b: [x1, y1, x2, y2]，axis-aligned
    # 交集左上角取 max、右下角取 min
    x1 = max(a[0], b[0]); y1 = max(a[1], b[1])
    x2 = min(a[2], b[2]); y2 = min(a[3], b[3])
    # 不相交时 x2<x1 或 y2<y1，用 max(0,·) clip 防负面积
    inter = max(0.0, x2 - x1) * max(0.0, y2 - y1)
    area_a = (a[2] - a[0]) * (a[3] - a[1])
    area_b = (b[2] - b[0]) * (b[3] - b[1])
    return inter / (area_a + area_b - inter + 1e-6)  # +eps 防除零

def iou_batch(boxes_a, boxes_b):
    # boxes: [N, 4]、[M, 4]；返回 [N, M]，向量化
    a, b = boxes_a[:, None], boxes_b[None]
    x1 = np.maximum(a[..., 0], b[..., 0]); y1 = np.maximum(a[..., 1], b[..., 1])
    x2 = np.minimum(a[..., 2], b[..., 2]); y2 = np.minimum(a[..., 3], b[..., 3])
    inter = np.clip(x2 - x1, 0, None) * np.clip(y2 - y1, 0, None)
    area_a = (a[..., 2] - a[..., 0]) * (a[..., 3] - a[..., 1])
    area_b = (b[..., 2] - b[..., 0]) * (b[..., 3] - b[..., 1])
    return inter / (area_a + area_b - inter + 1e-6)
```',
   null, null, '["负宽/高没 clip 致 IoU>1", "除零", "边界半开/闭区间约定（+1 偏移）", "旋转框直接套此式错（应 polygon 求交）。"]'::jsonb, null, 10, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H01","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000438', '手撕 NMS（非极大值抑制）', 'eaq-v07-h02', 'coding', 'medium', '排序 + 贪心 + IoU 过滤；',
   '排序 + 贪心 + IoU 过滤；soft-NMS 按 IoU 衰减而非删；多类应分类做。', '**考察点**：排序 + 贪心 + IoU 过滤；soft-NMS 按 IoU 衰减而非删；多类应分类做。

**实现**：

```python
import numpy as np

def nms(boxes, scores, iou_thresh=0.5):
    # boxes: [N, 4] (x1,y1,x2,y2)；scores: [N]
    order = scores.argsort()[::-1]  # 按 score 降序索引
    keep = []
    x1, y1 = boxes[:, 0], boxes[:, 1]
    x2, y2 = boxes[:, 2], boxes[:, 3]
    areas = (x2 - x1) * (y2 - y1)
    while order.size > 0:
        i = order[0]
        keep.append(i)
        # 当前框与剩余框做向量化 IoU
        xx1 = np.maximum(x1[i], x1[order[1:]])
        yy1 = np.maximum(y1[i], y1[order[1:]])
        xx2 = np.minimum(x2[i], x2[order[1:]])
        yy2 = np.minimum(y2[i], y2[order[1:]])
        inter = np.clip(xx2 - xx1, 0, None) * np.clip(yy2 - yy1, 0, None)
        iou = inter / (areas[i] + areas[order[1:]] - inter + 1e-6)
        # 保留 iou <= thresh 的；+1 因为 order[0] 已剔除
        order = order[1:][iou <= iou_thresh]
    return keep
```',
   null, null, '["未按类别分别 NMS（不同类不该互抑）", "忘 score thresh 预过滤 → N 大 TLE", "`iou_thresh` 取 1.0 等于不抑制。"]'::jsonb, null, 10, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H02","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000439', '手撕 Conv2d 输出维度 / 感受野', 'eaq-v07-h03', 'coding', 'easy', '`out=⌊(in+2P-D·(K-1)-1)/S⌋+1`；',
   '`out=⌊(in+2P-D·(K-1)-1)/S⌋+1`；感受野是累加而非累乘；pooling 层也算 stride。', '**考察点**：`out=⌊(in+2P-D·(K-1)-1)/S⌋+1`；感受野是累加而非累乘；pooling 层也算 stride。

**实现**：

```python
def conv_out_dim(in_size, kernel, stride=1, padding=0, dilation=1):
    # PyTorch 标准公式（与 nn.Conv2d 一致）
    return (in_size + 2 * padding - dilation * (kernel - 1) - 1) // stride + 1

def deconv_out_dim(in_size, kernel, stride, padding=0, out_pad=0, dilation=1):
    # 转置卷积输出尺寸
    return (in_size - 1) * stride - 2 * padding + dilation * (kernel - 1) + out_pad + 1

def receptive_field(layers):
    # layers: [(kernel, stride), ...] 顺序排列；pooling 也按 (k,s) 计入
    rf, jump = 1, 1
    for k, s in layers:
        # RF_{l} = RF_{l-1} + (k-1)·∏_{i<l} s_i；累加而非累乘
        rf += (k - 1) * jump
        jump *= s
    return rf
```',
   null, null, '["忘 `dilation`", "以为感受野累乘（实是累加）", "忽略 pooling 层 stride 贡献", "same padding 在 stride>1 时含义模糊。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H03","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000440', '手撕 BFS / DFS 在 grid 上找最短路径', 'eaq-v07-h04', 'coding', 'medium', 'BFS 必给最短（无权图）；',
   'BFS 必给最短（无权图）；visited 入队即标（非出队）；DFS 求所有路径不能求最短。', '**考察点**：BFS 必给最短（无权图）；visited 入队即标（非出队）；DFS 求所有路径不能求最短。

**实现**：

```python
from collections import deque

def bfs_shortest(grid, start, goal):
    # grid: 2D list；0 通行、1 障碍；返回最短步数或 -1
    R, C = len(grid), len(grid[0])
    if grid[start[0]][start[1]] or grid[goal[0]][goal[1]]:
        return -1
    visited = [[False] * C for _ in range(R)]
    q = deque([(start[0], start[1], 0)])
    visited[start[0]][start[1]] = True  # 入队即标，防重复入队 TLE
    dx, dy = (-1, 1, 0, 0), (0, 0, -1, 1)  # 四邻居
    while q:
        x, y, d = q.popleft()
        if (x, y) == goal:
            return d
        for k in range(4):
            nx, ny = x + dx[k], y + dy[k]
            # 边界 + 障碍 + visited 三道闸
            if 0 <= nx < R and 0 <= ny < C and not visited[nx][ny] and not grid[nx][ny]:
                visited[nx][ny] = True
                q.append((nx, ny, d + 1))
    return -1
```',
   null, null, '["visited 出队才标 → 重复入队 TLE", "用 DFS 求最短（应 BFS）", "八邻居斜走代价应 √2 而非 1。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H04","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000441', '手撕 A* / Dijkstra 路径规划', 'eaq-v07-h05', 'coding', 'medium', 'Dijkstra h=0、A* `f=g+h`；',
   'Dijkstra h=0、A* `f=g+h`；h 必须 admissible（≤真实代价）保证最优；用 `g_best` 替代 closed set。', '**考察点**：Dijkstra h=0、A* `f=g+h`；h 必须 admissible（≤真实代价）保证最优；用 `g_best` 替代 closed set。

**实现**：

```python
import heapq

def heuristic(p, goal):
    # 4 邻居用 Manhattan；8 邻居/自由方向用 Euclidean；都 admissible
    return abs(p[0] - goal[0]) + abs(p[1] - goal[1])

def astar(grid, start, goal):
    R, C = len(grid), len(grid[0])
    g_best = {start: 0}
    pq = [(heuristic(start, goal), 0, start)]  # (f, g, pos)
    dx, dy = (-1, 1, 0, 0), (0, 0, -1, 1)
    while pq:
        f, g, p = heapq.heappop(pq)
        if p == goal:
            return g
        if g > g_best.get(p, float(''inf'')):  # 懒删除：过期条目跳过
            continue
        for k in range(4):
            nx, ny = p[0] + dx[k], p[1] + dy[k]
            if not (0 <= nx < R and 0 <= ny < C) or grid[nx][ny]:
                continue
            ng = g + 1
            np_ = (nx, ny)
            # 仅当新 g 更小才入队（替代 closed set，更简洁）
            if ng < g_best.get(np_, float(''inf'')):
                g_best[np_] = ng
                heapq.heappush(pq, (ng + heuristic(np_, goal), ng, np_))
    return -1
```',
   null, null, '["`h` 不 admissible（高估）→ 解不最优", "按 `g` 入堆而非 `f`", "同节点重复入队忘懒删除致路径错。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H05","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000442', '手撕 K-Means 聚类', 'eaq-v07-h06', 'coding', 'easy', 'E-step 分配 + M-step 更新；',
   'E-step 分配 + M-step 更新；K-Means++ 初始化远胜随机；空簇要重选远点。', '**考察点**：E-step 分配 + M-step 更新；K-Means++ 初始化远胜随机；空簇要重选远点。

**实现**：

```python
import numpy as np

def kmeans_pp_init(X, k, rng):
    # K-Means++：第一个中心随机；后续按距已选中心最近距离的平方加权采样
    n = X.shape[0]
    centers = [X[rng.integers(n)]]
    for _ in range(1, k):
        d2 = np.min(((X[:, None] - np.array(centers)[None]) ** 2).sum(-1), axis=1)
        probs = d2 / d2.sum()
        centers.append(X[rng.choice(n, p=probs)])
    return np.array(centers)

def kmeans(X, k, max_iter=100, tol=1e-4, rng=None):
    rng = rng or np.random.default_rng(0)
    centers = kmeans_pp_init(X, k, rng)
    for _ in range(max_iter):
        # E-step：每点找最近中心（argmin |x - μ_k|²）
        dist = ((X[:, None] - centers[None]) ** 2).sum(-1)  # [N, k]
        labels = dist.argmin(axis=1)
        # M-step：更新中心；空簇用全局最远点替换
        new_centers = np.array([
            X[labels == j].mean(0) if (labels == j).any()
            else X[dist.min(1).argmax()]  # 空簇 → 取目前最难拟合的点
            for j in range(k)
        ])
        if np.linalg.norm(new_centers - centers) < tol:
            break
        centers = new_centers
    return centers, labels
```',
   null, null, '["用随机初始化局部最优", "空簇未处理", "用 `==` 比 `float` 距离判收敛", "k 选错（用肘部法 / silhouette）。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H06","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000443', '手撕 ViT patch embedding', 'eaq-v07-h07', 'coding', 'easy', '用 `Conv2d` 一步切+映射；',
   '用 `Conv2d` 一步切+映射；patch 大小决定序列长度 `N=(H/p)·(W/p)`；CLS token + learnable PE。', '**考察点**：用 `Conv2d` 一步切+映射；patch 大小决定序列长度 `N=(H/p)·(W/p)`；CLS token + learnable PE。

**实现**：

```python
import torch
import torch.nn as nn

class PatchEmbed(nn.Module):
    def __init__(self, img_size=224, patch=16, in_c=3, dim=768):
        super().__init__()
        assert img_size % patch == 0, "img_size 必须能被 patch 整除"
        self.n_patch = (img_size // patch) ** 2
        # Conv2d 同时实现切 patch + 线性投影：kernel=stride=patch
        self.proj = nn.Conv2d(in_c, dim, kernel_size=patch, stride=patch)
        self.cls_token = nn.Parameter(torch.zeros(1, 1, dim))
        # PE 长度 = n_patch+1（含 CLS）；换分辨率需 interpolate
        self.pos_embed = nn.Parameter(torch.zeros(1, self.n_patch + 1, dim))

    def forward(self, x):  # x: [B, 3, H, W]
        B = x.size(0)
        # Conv 输出 [B, dim, H/p, W/p] → 展平为 [B, N, dim]
        x = self.proj(x).flatten(2).transpose(1, 2)
        # 拼 CLS token 到序列首
        cls = self.cls_token.expand(B, -1, -1)
        x = torch.cat([cls, x], dim=1)
        return x + self.pos_embed
```',
   null, null, '["H/W 不被 patch 整除（要 pad/crop）", "忘加 CLS token", "PE 长度与 patch 数不一致致换分辨率失败。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"07","volume_title":"卷七 · 3D 感知 / SLAM / 导航","section":"手撕代码","qid":"H07","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000444', 'LC3 无重复字符的最长子串', 'eaq-v08-q01', 'coding', 'medium', '滑动窗口；',
   '滑动窗口；哈希记字符最后一次位置；左指针只能右移（用 max 防回退）。', '**考察点**：滑动窗口；哈希记字符最后一次位置；左指针只能右移（用 max 防回退）。

**实现**：

```python
def length_of_longest_substring(s):
    last = {}      # 字符 -> 最后出现下标
    l, ans = 0, 0
    for r, c in enumerate(s):
        # 关键：max(l, last[c]+1)；last[c] 可能已在窗口外，l 不能回退
        if c in last and last[c] >= l:
            l = last[c] + 1
        last[c] = r
        ans = max(ans, r - l + 1)
    return ans
```',
   null, null, '["忘 `max` 致 `l` 回退", "用 set 删旧元素逻辑复杂", "用 `l = last[c]+1` 不判区间漏过窗口外旧位置。"]'::jsonb, null, 10, true, true, 30, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q01","freq_label":"🔥×30"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000445', 'LC206 反转链表', 'eaq-v08-q02', 'coding', 'easy', '三指针迭代 O(1) 空间；',
   '三指针迭代 O(1) 空间；递归 O(n) 栈空间；断尾防成环。', '**考察点**：三指针迭代 O(1) 空间；递归 O(n) 栈空间；断尾防成环。

**实现**：

```python
def reverse_list(head):
    prev, cur = None, head
    while cur:
        nxt = cur.next      # 先存下一节点，否则反转后丢失
        cur.next = prev     # 反转当前节点指针
        prev, cur = cur, nxt
    return prev             # prev 为新头

def reverse_recursive(head):
    if not head or not head.next:  # 空或单节点直接返回（base case）
        return head
    new_head = reverse_recursive(head.next)
    head.next.next = head   # 让下一节点指回当前
    head.next = None        # 断尾防成环
    return new_head
```',
   null, null, '["忘 `head.next=None` 致成环", "指针顺序错（先改 next 再保存致丢失）", "递归 base case 漏判 head 空。"]'::jsonb, null, 10, true, true, 25, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q02","freq_label":"🔥×25"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000446', 'LC15 三数之和', 'eaq-v08-q03', 'coding', 'medium', '排序 + 双指针；',
   '排序 + 双指针；三处去重（i / l / r）；命中后双指针必须同时移动。', '**考察点**：排序 + 双指针；三处去重（i / l / r）；命中后双指针必须同时移动。

**实现**：

```python
def three_sum(nums):
    nums.sort()
    n, res = len(nums), []
    for i in range(n - 2):
        if nums[i] > 0:
            break                       # 已排序，最小值>0 不可能和为 0
        if i > 0 and nums[i] == nums[i - 1]:
            continue                    # ① i 去重：跳过相同首元素
        l, r = i + 1, n - 1
        while l < r:
            s = nums[i] + nums[l] + nums[r]
            if s == 0:
                res.append([nums[i], nums[l], nums[r]])
                # ②③ l/r 同时去重
                while l < r and nums[l] == nums[l + 1]: l += 1
                while l < r and nums[r] == nums[r - 1]: r -= 1
                l += 1; r -= 1          # 必须同步移动，否则死循环
            elif s < 0:
                l += 1
            else:
                r -= 1
    return res
```',
   null, null, '["忘排序", "只对 `i` 去重", "命中后只动一侧指针致死循环", "漏 `nums[i]>0` 早停。"]'::jsonb, null, 10, true, true, 20, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q03","freq_label":"🔥×20"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000447', 'LC146 LRU 缓存机制', 'eaq-v08-q04', 'coding', 'medium', '哈希 + 双向链表 → get/put 都 O(1)；',
   '哈希 + 双向链表 → get/put 都 O(1)；Python `OrderedDict.move_to_end` 一行解决。', '**考察点**：哈希 + 双向链表 → get/put 都 O(1)；Python `OrderedDict.move_to_end` 一行解决。

**实现**：

```python
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cap = capacity
        self.cache = OrderedDict()  # 内置双向链表，有序

    def get(self, key):
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)  # 访问后移到尾（最近用）
        return self.cache[key]

    def put(self, key, value):
        if key in self.cache:
            self.cache.move_to_end(key)
        self.cache[key] = value
        if len(self.cache) > self.cap:
            # popitem(last=False) 弹最旧；同步从哈希删（OrderedDict 一并删）
            self.cache.popitem(last=False)
```',
   null, null, '["用单链表无法 O(1) 删中间节点", "超容量后只删链表忘删哈希", "`get` 已存在 key 忘 `move_to_end`。"]'::jsonb, null, 10, true, true, 18, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q04","freq_label":"🔥×18"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000448', 'LC215 数组中第 K 个最大元素', 'eaq-v08-q05', 'coding', 'medium', '小顶堆 O(n log K) vs 快选 O(n) 期望；',
   '小顶堆 O(n log K) vs 快选 O(n) 期望；快选必须随机 pivot 防排序数据退化。', '**考察点**：小顶堆 O(n log K) vs 快选 O(n) 期望；快选必须随机 pivot 防排序数据退化。

**实现**：

```python
import heapq
import random

def kth_largest_heap(nums, k):
    # 小顶堆维护 top-K：堆顶就是第 K 大
    heap = []
    for x in nums:
        heapq.heappush(heap, x)
        if len(heap) > k:
            heapq.heappop(heap)
    return heap[0]

def kth_largest_quickselect(nums, k):
    # 找第 k 大 = 找第 (n-k) 小
    target = len(nums) - k

    def partition(l, r):
        pivot = random.randint(l, r)            # 随机 pivot 防排序数据 O(n²)
        nums[pivot], nums[r] = nums[r], nums[pivot]
        store = l
        for i in range(l, r):
            if nums[i] < nums[r]:
                nums[i], nums[store] = nums[store], nums[i]
                store += 1
        nums[store], nums[r] = nums[r], nums[store]
        return store

    l, r = 0, len(nums) - 1
    while True:
        p = partition(l, r)
        if p == target: return nums[p]
        elif p < target: l = p + 1
        else: r = p - 1
```',
   null, null, '["堆方向反（求第 K 大用小顶堆，反直觉）", "快选不随机 pivot 退化", "维护全量堆浪费空间。"]'::jsonb, null, 10, true, true, 15, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q05","freq_label":"🔥×15"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000449', 'LC53 最大子序和', 'eaq-v08-q06', 'coding', 'easy', 'Kadane 算法 O(n)/O(1)；',
   'Kadane 算法 O(n)/O(1)；`dp[i]` 定义是"以 i 结尾"而非"前 i 项最大"。', '**考察点**：Kadane 算法 O(n)/O(1)；`dp[i]` 定义是"以 i 结尾"而非"前 i 项最大"。

**实现**：

```python
def max_subarray(nums):
    # cur 必须初始化为 nums[0]，不是 0：全负数组时 0 会错
    cur = ans = nums[0]
    for x in nums[1:]:
        # 在线扩展 vs 重启：max(x, cur+x)
        # 等价于 "以 x 结尾的最大子段和"
        cur = max(x, cur + x)
        ans = max(ans, cur)
    return ans
```',
   null, null, '["`cur=0` 在全负数组上返回 0（应 `nums[0]`）", "定义记成\"前 i 项最大\"丢失子串约束", "遍历从 0 而非 1 致重复计入 nums[0]。"]'::jsonb, null, 10, false, true, 14, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q06","freq_label":"🔥×14"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000450', 'LC25 K 个一组翻转链表', 'eaq-v08-q07', 'coding', 'hard', 'dummy 哨兵；',
   'dummy 哨兵；不足 K 个保持原序；接回时四个边界指针更新。', '**考察点**：dummy 哨兵；不足 K 个保持原序；接回时四个边界指针更新。

**实现**：

```python
def reverse_k_group(head, k):
    dummy = type(head)(0) if head else None
    if not dummy:
        return None
    dummy.next = head
    pre = dummy                          # 上一组的末尾
    while True:
        # 先看后面是否还有 K 个节点；不足 K 直接 break（题目要求保留原序）
        tail = pre
        for _ in range(k):
            tail = tail.next
            if not tail:
                return dummy.next
        nxt_group = tail.next            # 下一组起点，反转前先存
        # 反转 [pre.next, tail] 这一段
        prev, cur = nxt_group, pre.next
        while cur != nxt_group:
            tmp = cur.next
            cur.next = prev
            prev, cur = cur, tmp
        # 接回：原 head 现在是这一组的尾
        new_tail = pre.next
        pre.next = prev                  # 新头接到 pre 后
        pre = new_tail                   # pre 推进到本组末尾
```',
   null, null, '["不足 K 个反了（应保留原序）", "`pre` 未更新致后续段错位", "递归写法 O(n/K) 栈深大输入炸。"]'::jsonb, null, 10, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q07","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000451', 'LC121 买卖股票的最佳时机', 'eaq-v08-q08', 'coding', 'easy', '一次买卖；',
   '一次买卖；一趟扫维护历史最低 + 最大差；变体（多次买卖 / 含冷冻 / 含费）走状态机 DP。', '**考察点**：一次买卖；一趟扫维护历史最低 + 最大差；变体（多次买卖 / 含冷冻 / 含费）走状态机 DP。

**实现**：

```python
def max_profit(prices):
    if not prices:
        return 0
    # min_price 初始为 prices[0] 而非 inf，保证遍历从 i=1 开始时不错算
    min_price, ans = prices[0], 0
    for p in prices[1:]:
        ans = max(ans, p - min_price)   # 先更答案：不能在同一天卖出
        min_price = min(min_price, p)
    return ans
```',
   null, null, '["把题目当多次买卖", "先更新 `min_price` 再算差致同日买卖", "DP 写成 O(n²) 双重循环", "空数组未判返回错。"]'::jsonb, null, 10, false, true, 12, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q08","freq_label":"🔥×12"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000452', 'LC42 接雨水', 'eaq-v08-q09', 'coding', 'hard', '双指针 O(n)/O(1) 最优；',
   '双指针 O(n)/O(1) 最优；挪当前两端柱中较短的那侧（短板锁定本列水位）。', '**考察点**：双指针 O(n)/O(1) 最优；挪当前两端柱中较短的那侧（短板锁定本列水位）。

**实现**：

```python
def trap(height):
    # 双指针：比较两端当前高度；较短的一侧的水位由它那侧的 max 锁定
    l, r = 0, len(height) - 1
    lmax, rmax = 0, 0
    ans = 0
    while l < r:
        if height[l] < height[r]:
            # 左边短：左侧 max 比 height[r] 小，水位即 lmax
            lmax = max(lmax, height[l])
            ans += lmax - height[l]
            l += 1
        else:
            # 右边短或相等：水位由 rmax 锁定
            rmax = max(rmax, height[r])
            ans += rmax - height[r]
            r -= 1
    return ans
```',
   null, null, '["挪错方向（应挪当前两端中较短那侧）", "单调栈版漏减底高", "预处理左右最大值版下标越界。"]'::jsonb, null, 10, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q09","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000453', 'LC102 二叉树层序遍历', 'eaq-v08-q10', 'coding', 'medium', 'BFS 按层分组的关键 = 内层用 `n=len(q)` 固定本层数量。',
   'BFS 按层分组的关键 = 内层用 `n=len(q)` 固定本层数量。', '**考察点**：BFS 按层分组的关键 = 内层用 `n=len(q)` 固定本层数量。

**实现**：

```python
from collections import deque

def level_order(root):
    if not root:
        return []                       # 漏判 None 致后续异常
    res, q = [], deque([root])
    while q:
        n = len(q)                      # 关键：固定本层数量，再分批出队
        level = []
        for _ in range(n):
            node = q.popleft()
            level.append(node.val)
            if node.left:  q.append(node.left)
            if node.right: q.append(node.right)
        res.append(level)
    return res
```',
   null, null, '["忘 `n=len(q)` 致分层失败", "`root=None` 漏判异常", "用 DFS+depth 写也行但不直观。"]'::jsonb, null, 10, false, true, 11, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q10","freq_label":"🔥×11"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000454', 'LC1 两数之和', 'eaq-v08-q11', 'coding', 'easy', '一趟哈希；',
   '一趟哈希；边查边插防自配对；返回下标非数值。', '**考察点**：一趟哈希；边查边插防自配对；返回下标非数值。

**实现**：

```python
def two_sum(nums, target):
    seen = {}                # val -> idx，已遍历过的数
    for i, x in enumerate(nums):
        need = target - x
        if need in seen:     # 先查再插：防自身和自身配对
            return [seen[need], i]
        seen[x] = i
    return []                # 题目通常保证有解
```',
   null, null, '["预先全塞哈希再查致 `[i,i]` 自配对", "返回值是下标但返回了数值", "用排序+双指针失下标信息。"]'::jsonb, null, 10, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q11","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000455', 'LC200 岛屿数量', 'eaq-v08-q12', 'coding', 'medium', '网格连通分量；',
   '网格连通分量；DFS/BFS 任选；原地改 `''0''` 替代 visited 节省空间。', '**考察点**：网格连通分量；DFS/BFS 任选；原地改 `''0''` 替代 visited 节省空间。

**实现**：

```python
def num_islands(grid):
    if not grid:
        return 0
    R, C = len(grid), len(grid[0])

    def dfs(r, c):
        # 边界 + 已访问/水 三道闸防越界
        if r < 0 or r >= R or c < 0 or c >= C or grid[r][c] != ''1'':
            return
        grid[r][c] = ''0''                # 原地标记访问（题目允许改）
        dfs(r + 1, c); dfs(r - 1, c)
        dfs(r, c + 1); dfs(r, c - 1)    # 四邻居（题目是四邻居）

    count = 0
    for r in range(R):
        for c in range(C):
            if grid[r][c] == ''1'':
                count += 1
                dfs(r, c)
    return count
```',
   null, null, '["递归无终止条件爆栈", "八邻居（题目是四邻居）", "不允许改原数组时漏 visited 数组", "DFS 大网格用 BFS 更安全。"]'::jsonb, null, 10, false, true, 10, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q12","freq_label":"🔥×10"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000456', 'LC141 环形链表', 'eaq-v08-q13', 'coding', 'easy', 'Floyd 快慢指针；',
   'Floyd 快慢指针；fast 每步走 2、slow 走 1，有环必相遇。', '**考察点**：Floyd 快慢指针；fast 每步走 2、slow 走 1，有环必相遇。

**实现**：

```python
def has_cycle(head):
    slow = fast = head
    # 边界：fast 与 fast.next 都不能为 None（fast 要走两步）
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False

def find_cycle_entry(head):
    # LC142 进阶：相遇后 slow 回 head、fast 留原地、同步走 1 步直到相遇
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            slow = head
            while slow != fast:
                slow = slow.next
                fast = fast.next
            return slow
    return None
```',
   null, null, '["边界写 `while fast.next` 漏判 `fast=None`", "slow 起点写 `head.next` 同步关系乱", "用 set 存访问节点占 O(n) 空间。"]'::jsonb, null, 10, false, true, 9, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q13","freq_label":"🔥×9"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000457', 'LC560 和为 K 的子数组', 'eaq-v08-q14', 'coding', 'medium', '前缀和差 `s_i - s_j = k`；',
   '前缀和差 `s_i - s_j = k`；含负数滑窗不单调必用哈希；`cnt[0]=1` 表空前缀。', '**考察点**：前缀和差 `s_i - s_j = k`；含负数滑窗不单调必用哈希；`cnt[0]=1` 表空前缀。

**实现**：

```python
from collections import defaultdict

def subarray_sum(nums, k):
    # cnt[前缀和] = 出现次数；初始 cnt[0]=1 让"从头开始就等于 k"被算到
    cnt = defaultdict(int)
    cnt[0] = 1
    s = ans = 0
    for x in nums:
        s += x
        # 先查再插：避免 [i,i] 自配对（含 0 元素时）
        ans += cnt[s - k]
        cnt[s] += 1
    return ans
```',
   null, null, '["含负数用滑窗（窗口和非单调）", "漏 `cnt[0]=1` 致全数组和为 k 时漏算", "先插再查自配对。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q14","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000458', 'LC236 二叉树最近公共祖先', 'eaq-v08-q15', 'coding', 'medium', '递归后序；',
   '递归后序；返回值语义 = "子树里找到 p 或 q 的那个节点"，左右都非空 = 分居两侧 → 当前是 LCA。', '**考察点**：递归后序；返回值语义 = "子树里找到 p 或 q 的那个节点"，左右都非空 = 分居两侧 → 当前是 LCA。

**实现**：

```python
def lowest_common_ancestor(root, p, q):
    # base case：root=None 或 root 就是 p/q，直接返回
    if not root or root == p or root == q:
        return root
    left = lowest_common_ancestor(root.left, p, q)
    right = lowest_common_ancestor(root.right, p, q)
    # 左右子树都找到目标 → root 是 LCA
    if left and right:
        return root
    # 否则返回非空那侧（携带 p 或 q 的子树或 LCA 本身）
    return left if left else right
```',
   null, null, '["返回值用 bool 而非节点丢信息", "BST 题（LC235）可用大小关系 O(log n)，普通树不行", "漏 `root==p or root==q` 早返回。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q15","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000459', 'LC20 有效的括号', 'eaq-v08-q16', 'coding', 'easy', '栈匹配；',
   '栈匹配；用 dict 存右→左配对；结束栈空才合法。', '**考察点**：栈匹配；用 dict 存右→左配对；结束栈空才合法。

**实现**：

```python
def is_valid(s):
    pair = {'')'': ''('', '']'': ''['', ''}'': ''{''}
    stack = []
    for c in s:
        if c in pair:
            # 遇右括号：栈空或顶不匹配都失败
            if not stack or stack[-1] != pair[c]:
                return False
            stack.pop()
        else:
            stack.append(c)             # 左括号入栈
    return not stack                    # 结束时必须栈空
```',
   null, null, '["栈空时直接 `stack[-1]` 致 IndexError", "只判最终栈空但中间错配漏", "用计数器无法区分 `()[]` 与 `(]` 的合法性。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q16","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000460', 'LC239 滑动窗口最大值', 'eaq-v08-q17', 'coding', 'hard', '单调递减队列；',
   '单调递减队列；队中存**下标**才能判窗口边界；摊还 O(n)。', '**考察点**：单调递减队列；队中存**下标**才能判窗口边界；摊还 O(n)。

**实现**：

```python
from collections import deque

def max_sliding_window(nums, k):
    dq = deque()                        # 存下标，对应值单调递减
    res = []
    for i, x in enumerate(nums):
        # 队头超出窗口：i - k + 1 是窗口左端
        if dq and dq[0] < i - k + 1:
            dq.popleft()
        # 维护单调递减：尾部小于 x 的全弹
        while dq and nums[dq[-1]] < x:
            dq.pop()
        dq.append(i)
        # i 到达 k-1 才形成第一个完整窗口
        if i >= k - 1:
            res.append(nums[dq[0]])
    return res
```',
   null, null, '["deque 存值而非下标 → 无法判窗口边界", "窗口左端 `i-k+1` 算错", "首次取答案的边界条件 `i>=k-1` 写成 `i>=k`。"]'::jsonb, null, 10, false, true, 8, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q17","freq_label":"🔥×8"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000461', 'LC155 最小栈', 'eaq-v08-q18', 'coding', 'easy', '辅助栈与主栈**同步** push/pop（不能只在更小时才压辅助栈）；',
   '辅助栈与主栈**同步** push/pop（不能只在更小时才压辅助栈）；`getMin` O(1)。', '**考察点**：辅助栈与主栈**同步** push/pop（不能只在更小时才压辅助栈）；`getMin` O(1)。

**实现**：

```python
class MinStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []             # 与 stack 同步，存历史最小

    def push(self, x):
        self.stack.append(x)
        # 关键：辅助栈每次都压，压的是 min(top, x)；这样 pop 才同步
        m = x if not self.min_stack else min(self.min_stack[-1], x)
        self.min_stack.append(m)

    def pop(self):
        self.stack.pop()
        self.min_stack.pop()            # 同步 pop

    def top(self):
        return self.stack[-1]

    def getMin(self):
        return self.min_stack[-1]       # O(1)
```',
   null, null, '["辅助栈仅在 `x` 更小时压 → pop 时不同步", "`getMin` 用 `min(stack)` 退化 O(n)", "忘判空栈。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q18","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000462', 'LC56 合并区间', 'eaq-v08-q19', 'coding', 'medium', '按起点排序 + 一次扫描；',
   '按起点排序 + 一次扫描；端点相接（`s<=ce`）也算合并。', '**考察点**：按起点排序 + 一次扫描；端点相接（`s<=ce`）也算合并。

**实现**：

```python
def merge(intervals):
    if not intervals:
        return []
    intervals.sort(key=lambda x: x[0])  # 按起点排序
    res = [intervals[0][:]]
    for s, e in intervals[1:]:
        # 端点相接也算合并（用 <= 不是 <）
        if s <= res[-1][1]:
            res[-1][1] = max(res[-1][1], e)
        else:
            res.append([s, e])
    return res
```',
   null, null, '["按 end 排序错", "`s <= ce` 写成 `<` 漏端点相接", "`max(ce, e)` 忘 `max`（新区间可能比旧短）。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q19","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000463', 'LC23 合并 K 个升序链表', 'eaq-v08-q20', 'coding', 'hard', '小顶堆 O(N log K)；',
   '小顶堆 O(N log K)；堆元素加 `idx` tie-break 防比较 `node` 报错；分治也行。', '**考察点**：小顶堆 O(N log K)；堆元素加 `idx` tie-break 防比较 `node` 报错；分治也行。

**实现**：

```python
import heapq

def merge_k_lists(lists):
    # 寻找任一非空节点拿到节点类型，构造 dummy；只看 lists[0] 会漏 [None, node] 情况
    sample = next((h for h in lists if h), None)
    if sample is None:
        return None
    dummy = type(sample)(0)
    heap = []
    # 所有头节点入堆；(val, idx, node)：idx 是 tie-break 防 val 相同时比较 node 报错
    for i, head in enumerate(lists):
        if head:
            heapq.heappush(heap, (head.val, i, head))
    cur = dummy
    counter = len(lists)
    while heap:
        val, _, node = heapq.heappop(heap)
        cur.next = node
        cur = node
        if node.next:
            heapq.heappush(heap, (node.next.val, counter, node.next))
            counter += 1
    return dummy.next
```',
   null, null, '["堆元素 `(val, node)` val 相等时比较 node 报 TypeError", "直接 K 路合并 O(N·K) 而非 O(N log K)", "分治区间边界算错。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q20","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000464', 'LC300 最长递增子序列', 'eaq-v08-q21', 'coding', 'medium', 'tails 二分 O(n log n)；',
   'tails 二分 O(n log n)；tails 不是答案序列但长度=LIS 长度；严格 vs 非严格选 `bisect_left/right`。', '**考察点**：tails 二分 O(n log n)；tails 不是答案序列但长度=LIS 长度；严格 vs 非严格选 `bisect_left/right`。

**实现**：

```python
import bisect

def length_of_lis(nums):
    # tails[k] = 所有长度 k+1 LIS 中末尾的最小值；自然单调递增
    tails = []
    for x in nums:
        # 严格递增用 bisect_left（替换第一个 >= x 的位置）
        # 若题目要求非严格递增则用 bisect_right
        i = bisect.bisect_left(tails, x)
        if i == len(tails):
            tails.append(x)             # x 比所有尾部都大，扩展长度
        else:
            tails[i] = x                # 否则更新让该长度的尾部更小
    return len(tails)

def length_of_lis_dp(nums):
    # O(n²) 经典 DP，便于讲解
    if not nums:
        return 0
    dp = [1] * len(nums)                # 每个元素自己就是长度 1
    for i in range(len(nums)):
        for j in range(i):
            if nums[j] < nums[i]:
                dp[i] = max(dp[i], dp[j] + 1)
    return max(dp)
```',
   null, null, '["把 `tails` 直接当 LIS 输出（错", "只长度对）", "严格/非严格用错 `bisect_left/right`", "DP 初值漏 1 致全 0。"]'::jsonb, null, 10, false, true, 7, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q21","freq_label":"🔥×7"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000465', 'LC994 腐烂的橘子', 'eaq-v08-q22', 'coding', 'medium', '多源 BFS（所有腐烂橘子同时入队）；',
   '多源 BFS（所有腐烂橘子同时入队）；初始层不计时间；`fresh>0` 返回 -1。', '**考察点**：多源 BFS（所有腐烂橘子同时入队）；初始层不计时间；`fresh>0` 返回 -1。

**实现**：

```python
from collections import deque

def oranges_rotting(grid):
    R, C = len(grid), len(grid[0])
    q = deque()
    fresh = 0
    # 多源 BFS：所有腐烂橘子先入队
    for r in range(R):
        for c in range(C):
            if grid[r][c] == 2:
                q.append((r, c))
            elif grid[r][c] == 1:
                fresh += 1
    if fresh == 0:
        return 0                        # 没新鲜橘子直接 0 分钟
    minutes = 0
    while q and fresh > 0:
        for _ in range(len(q)):
            r, c = q.popleft()
            for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < R and 0 <= nc < C and grid[nr][nc] == 1:
                    grid[nr][nc] = 2    # 标记腐烂
                    fresh -= 1
                    q.append((nr, nc))
        minutes += 1                    # 一轮 BFS 后才 +1（初始层不计）
    return minutes if fresh == 0 else -1
```',
   null, null, '["单源 BFS 漏远处腐烂源", "`minutes` 多算一层", "`fresh==0` 时未直接返回 0 进入 BFS 多算 0→1。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q22","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000466', 'LC32 最长有效括号', 'eaq-v08-q23', 'coding', 'hard', '栈底放 `-1` 哨兵，`i - stack[-1]` 算长度；',
   '栈底放 `-1` 哨兵，`i - stack[-1]` 算长度；''('' 入栈、'')'' 弹栈后栈空则用 `i` 作新哨兵。', '**考察点**：栈底放 `-1` 哨兵，`i - stack[-1]` 算长度；''('' 入栈、'')'' 弹栈后栈空则用 `i` 作新哨兵。

**实现**：

```python
def longest_valid_parentheses(s):
    stack = [-1]                        # 哨兵：例如 "()" 在 i=1 处弹出后，长度 = 1-(-1)=2 正确
    ans = 0
    for i, c in enumerate(s):
        if c == ''('':
            stack.append(i)
        else:                           # '')''
            stack.pop()
            if not stack:
                # 栈空说明当前 '')'' 多余，用 i 作新哨兵
                stack.append(i)
            else:
                # 当前合法段长度 = i - 上一未匹配位置
                ans = max(ans, i - stack[-1])
    return ans
```',
   null, null, '["忘哨兵 `-1` 致首段长度算错", "'')'' 弹栈后忘判空致后续算法挂", "用计数器无法处理 `()(()` 这类嵌套+并列。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q23","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000467', 'LC72 编辑距离', 'eaq-v08-q24', 'coding', 'hard', '二维 DP；',
   '二维 DP；三种操作（删 / 增 / 改）对应 `dp[i-1][j]`、`dp[i][j-1]`、`dp[i-1][j-1]`；边界 `dp[0][j]=j、dp[i][0]=i`。', '**考察点**：二维 DP；三种操作（删 / 增 / 改）对应 `dp[i-1][j]`、`dp[i][j-1]`、`dp[i-1][j-1]`；边界 `dp[0][j]=j、dp[i][0]=i`。

**实现**：

```python
def min_distance(word1, word2):
    m, n = len(word1), len(word2)
    # dp[i][j] = word1[:i] -> word2[:j] 的最少操作数
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(m + 1):
        dp[i][0] = i                    # 删 i 个变空串
    for j in range(n + 1):
        dp[0][j] = j                    # 插 j 个变 word2[:j]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if word1[i - 1] == word2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1]
            else:
                # 删 word1[i-1] / 在 word1 插 word2[j-1] / 改字符
                dp[i][j] = 1 + min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1])
    return dp[m][n]
```',
   null, null, '["下标 1 偏移（`word1[i-1]`）", "`min` 三项漏一项", "空间优化时左上角 `dp[i-1][j-1]` 被覆盖前忘暂存。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q24","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000468', 'LC5 最长回文子串', 'eaq-v08-q25', 'coding', 'medium', '中心扩展 O(n²)；',
   '中心扩展 O(n²)；每个位置同时考虑奇中心（i,i）与偶中心（i,i+1）。', '**考察点**：中心扩展 O(n²)；每个位置同时考虑奇中心（i,i）与偶中心（i,i+1）。

**实现**：

```python
def longest_palindrome(s):
    if not s:
        return ""

    def expand(l, r):
        # 从中心向两侧扩展，返回最长回文的 (start, length)
        while l >= 0 and r < len(s) and s[l] == s[r]:
            l -= 1; r += 1
        return l + 1, r - l - 1         # 退出时 l/r 已越过端点

    start, max_len = 0, 1
    for i in range(len(s)):
        s1, l1 = expand(i, i)           # 奇中心
        s2, l2 = expand(i, i + 1)       # 偶中心（必算，不能漏）
        if l1 > max_len:
            start, max_len = s1, l1
        if l2 > max_len:
            start, max_len = s2, l2
    return s[start:start + max_len]
```',
   null, null, '["只算奇中心漏偶", "扩展时未判 `l>=0 and r<n` 越界", "返回时起点/长度计算错误。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q25","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000469', 'LC46 全排列', 'eaq-v08-q26', 'coding', 'medium', '回溯模板；',
   '回溯模板；`used[]` 数组标已用；进出递归时成对地"做选择/撤销选择"。', '**考察点**：回溯模板；`used[]` 数组标已用；进出递归时成对地"做选择/撤销选择"。

**实现**：

```python
def permute(nums):
    n = len(nums)
    res = []
    used = [False] * n
    path = []

    def dfs():
        if len(path) == n:
            res.append(path[:])         # 收集时必须拷贝快照
            return
        for i in range(n):
            if used[i]:
                continue
            # 做选择
            used[i] = True
            path.append(nums[i])
            dfs()
            # 撤销选择（成对出现）
            path.pop()
            used[i] = False

    dfs()
    return res
```',
   null, null, '["收集 `res.append(path)` 而非 `path[:]` 致引用共享被改污染", "忘撤销 `used[i]=False`", "LC47 去重时条件方向反（应在 `not used[i-1]` 时跳过同层重复枝）。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q26","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000470', 'LC19 删除链表倒数第 N 个节点', 'eaq-v08-q27', 'coding', 'medium', '快慢指针一次遍历；',
   '快慢指针一次遍历；dummy 防删头节点；`fast` 先走 n 步后再与 `slow` 同步。', '**考察点**：快慢指针一次遍历；dummy 防删头节点；`fast` 先走 n 步后再与 `slow` 同步。

**实现**：

```python
def remove_nth_from_end(head, n):
    # dummy 解决"待删的是头节点"的边界
    dummy = type(head)(0)
    dummy.next = head
    slow = fast = dummy
    # fast 先走 n 步；之后 slow 与 fast 同步走到 fast.next 为 None
    # 此时 slow 恰好在待删节点的前一个
    for _ in range(n):
        fast = fast.next
    while fast.next:
        slow = slow.next
        fast = fast.next
    slow.next = slow.next.next          # 跳过待删节点
    return dummy.next
```',
   null, null, '["不用 dummy 时删 head 失败", "`fast` 走 n+1 步致 slow 停错位（取决于循环写法）", "`fast.next` 判空写成 `fast` 致越界。"]'::jsonb, null, 10, false, true, 6, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q27","freq_label":"🔥×6"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000471', 'LC22 括号生成', 'eaq-v08-q28', 'coding', 'medium', '回溯剪枝；',
   '回溯剪枝；`left<n` 才加 ''(''、`right<left` 才加 '')''；两 if 都要尝试（不是 elif）。', '**考察点**：回溯剪枝；`left<n` 才加 ''(''、`right<left` 才加 '')''；两 if 都要尝试（不是 elif）。

**实现**：

```python
def generate_parenthesis(n):
    res = []

    def dfs(path, left, right):
        if len(path) == 2 * n:
            res.append(''''.join(path))
            return
        if left < n:                    # 还能加左括号
            path.append(''('')
            dfs(path, left + 1, right)
            path.pop()
        if right < left:                # 关键：right<left 才合法（不是 <=）
            path.append('')'')
            dfs(path, left, right + 1)
            path.pop()

    dfs([], 0, 0)
    return res
```',
   null, null, '["剪枝写 `right<=left` 致 `())` 类非法解漏过", "用 `elif` 替代两 if 致漏解", "忘 `path.pop` 回溯。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q28","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000472', 'LC1143 最长公共子序列', 'eaq-v08-q29', 'coding', 'medium', '二维 DP；',
   '二维 DP；子序列（可不连续）与子串（必连续）转移区别——子串错位时 `dp[i][j]=0`，子序列取 `max(dp[i-1][j], dp[i][j-1])`。', '**考察点**：二维 DP；子序列（可不连续）与子串（必连续）转移区别——子串错位时 `dp[i][j]=0`，子序列取 `max(dp[i-1][j], dp[i][j-1])`。

**实现**：

```python
def longest_common_subsequence(text1, text2):
    m, n = len(text1), len(text2)
    # dp[i][j] = text1[:i] 与 text2[:j] 的 LCS 长度
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i - 1] == text2[j - 1]:
                # 字符匹配：继承左上 + 1
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                # 不匹配：放弃 text1[i-1] 或 text2[j-1]，取大
                # 注意：子串（非子序列）这里应是 0，转移方式完全不同
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    return dp[m][n]
```',
   null, null, '["与最长公共子串混淆（子串错位清零）", "下标 1 偏移", "`max` 漏一项。"]'::jsonb, null, 10, false, true, 5, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q29","freq_label":"🔥×5"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000473', 'LC169 多数元素', 'eaq-v08-q30', 'coding', 'easy', 'Boyer-Moore 投票；',
   'Boyer-Moore 投票；多数元素（出现 > n/2）必能胜出；O(n)/O(1)。', '**考察点**：Boyer-Moore 投票；多数元素（出现 > n/2）必能胜出；O(n)/O(1)。

**实现**：

```python
def majority_element(nums):
    # cand: 当前候选；count: 净计数
    cand, count = None, 0
    for x in nums:
        if count == 0:
            cand = x                    # 重置候选
            count = 1
        elif x == cand:
            count += 1
        else:
            count -= 1                  # 互相抵消
    # 题目保证存在多数元素；不保证时再扫一遍验证 count(cand) > n/2
    return cand
```',
   null, null, '["把多数元素当\"出现最多\"（不一定 >n/2）", "`count=0` 时不重置 `cand` 致结果错", "LC229（>n/3）需要两个候选。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"LeetCode 高频 30 题","qid":"Q30","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000474', '设计一个 VLA 训练 pipeline（数据 → 训练 → 部署）', 'eaq-v08-q31', 'system_design', 'hard', '先确认本体、任务分布、数据规模、硬件与验收条件。',
   '先确认本体、任务分布、数据规模、硬件与验收条件。数据层保留轨迹、标定、时间戳、动作单位和版本，按场景/任务隔离训练与评测；训练层先建立可复现基线，再据实测显存与吞吐选择微调、分布式和恢复方案；部署层校验接口与时延，管理模型/数据/配置版本，分阶段上线并保留遥测、失败回流和回滚。', '先确认本体、任务分布、数据规模、硬件与验收条件。数据层保留轨迹、标定、时间戳、动作单位和版本，按场景/任务隔离训练与评测；训练层先建立可复现基线，再据实测显存与吞吐选择微调、分布式和恢复方案；部署层校验接口与时延，管理模型/数据/配置版本，分阶段上线并保留遥测、失败回流和回滚。',
   null, null, '["参数量不能单独决定必须用 FSDP，vLLM 也不直接适配任意 VLA 动作头", "多工厂部署还需处理环境差异、版本一致性和运维成本。"]'::jsonb, null, 10, false, true, null, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"ML 系统设计","qid":"Q31","freq_label":"历史频次·待核","provenance":"题源补证：[2026-09-24 原始面经](https://www.1point3acres.com/bbs/thread-1190520-1-1.html)：作者自述前一周参加西雅图匿名具身初创 MLE 面试，要求设计数据、训练与部署流程并考虑 50 家工厂。是相近的系统场景，原问未指定 VLA；仅一份经历，不证明本题旧版“5次”记录，也不支持把本文各实现细节称为原问。\n\n核验：[OpenVLA 原论文](https://arxiv.org/html/2406.09246)、[TorchData StatefulDataLoader](https://github.com/meta-pytorch/data/blob/main/torchdata/stateful_dataloader/README.md)。技术资料核答案，不证明面试频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000475', '设计 VLA 推理服务（多机器人并发调用一个 endpoint）', 'eaq-v08-q32', 'system_design', 'hard', '**Batching**：动态 batch（continuous batching, vLLM 风格）；',
   '**Batching**：动态 batch（continuous batching, vLLM 风格）；prefill 与 decode 分别 batch。', '**Batching**：动态 batch（continuous batching, vLLM 风格）；prefill 与 decode 分别 batch。

**KV cache**：PagedAttention 思想避免内存碎片；多请求共享 system prompt 复用 prefix cache。

**频率解耦**：控制环 50-1000 Hz，VLA 推理 5-25 Hz → action chunking（一次预测 H 步动作，底层控制器以高频插值）。

**多模型路由**：按任务类型 / embodiment 分流到不同 backbone；统一 API。

**SLO**：p50 / p99 延迟、QPS、actions/sec；监控 OOM、cache hit rate。',
   null, null, '["用同步 batch 等慢请求致控制环抖", "KV cache 跨请求不共享浪费显存", "忽略 streaming（首 token 即可触发下游）。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"ML 系统设计","qid":"Q32","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000476', '设计 RLHF / preference 数据采集系统', 'eaq-v08-q33', 'system_design', 'medium', '**采集 UI**：pairwise comparison 界面，展示同 prompt 下两条 response 选偏好；',
   '**采集 UI**：pairwise comparison 界面，展示同 prompt 下两条 response 选偏好；可选"难以判断"档。', '**采集 UI**：pairwise comparison 界面，展示同 prompt 下两条 response 选偏好；可选"难以判断"档。

**Schema**：`(prompt_id, response_a, response_b, choice, annotator_id, ts, confidence)`；prompt / response 单独去重表。

**一致性**：多标注员（≥3）对同一对判断算 Fleiss'' κ 或 Krippendorff''s α（Cohen''s κ 仅适合 2 人对比）；κ<0.4 舍弃或重标；定期注入 gold sample 校准。

**RM 训练**：解耦数据与训练；周期 dump → 训新 RM → A/B 上线 → 版本控制。

**隐私**：脱敏 PII；annotator 看不到 user_id；prompt 含敏感词过滤。',
   null, null, '["不校验 annotator bias", "RM 用全部数据无 hold-out 致过拟合", "忘存 confidence 字段。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"ML 系统设计","qid":"Q33","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000477', '设计 multi-robot fleet 数据采集系统', 'eaq-v08-q34', 'system_design', 'hard', '**异构汇总**：按 RLDS / OpenX-Embodiment 统一 schema；',
   '**异构汇总**：按 RLDS / OpenX-Embodiment 统一 schema；保 `embodiment_id` 便于按机型筛。', '**异构汇总**：按 RLDS / OpenX-Embodiment 统一 schema；保 `embodiment_id` 便于按机型筛。

**Action 标准化**：delta vs absolute 各自归一化；末端用 SE(3)；joint space 按 dof 切分。

**时间同步**：硬件 PTP / hardware trigger 优于软件时间戳；每帧打 `(robot_ts, server_ts)` 双时间戳。

**传感器对齐**：相机内外参标定文件入 metadata；点云时间戳对齐到 RGB。

**隐私**：人脸 / 车牌 blur；GPS 改为室内相对坐标。

**存储**：原始冷存 S3 / OSS；训练用切片走 WebDataset / Parquet。',
   null, null, '["不同控制频率混致 action chunk 长度不一", "忘 calibration 跨 robot 不可用", "时间戳跨节点偏差需 NTP / PTP。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"ML 系统设计","qid":"Q34","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000478', '设计 LLM offline batch inference for trajectory labeling', 'eaq-v08-q35', 'system_design', 'medium', '**框架**：vLLM / SGLang 做批量推理；',
   '**框架**：vLLM / SGLang 做批量推理；DeepSpeed-MII 备选。', '**框架**：vLLM / SGLang 做批量推理；DeepSpeed-MII 备选。

**Prefix cache**：同一 system prompt 跨样本共享 KV cache（模板固定、user input 变）→ 吞吐 2-5×。

**Sharding**：数据按 GPU 数切片；调 `vllm.LLM.generate(prompts, sampling_params)` 批跑。

**失败 / 重试**：每 100 样本写 checkpoint；挂了从 checkpoint 恢复；OOM 时降 batch 重试。

**质量监控**：抽样 N=100 人工检查；与小模型答案对比检测 outlier。

**Cost**：input + output tokens × 单价；用 `tiktoken` 预估。',
   null, null, '["没用 prefix cache 浪费算力", "OOM 后没自动降 batch", "output 没 streaming 写盘致跑完才存。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"ML 系统设计","qid":"Q35","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000479', '设计 perception-planning-control 完整栈', 'eaq-v08-q36', 'system_design', 'hard', '**模块（频率）**。',
   '**模块（频率）**：
- Perception：LiDAR / camera fusion（10-30 Hz）。
- State Estimation：IMU + 编码器 + VO（100-200 Hz）。
- Planning：global A* / RRT（1-5 Hz）+ local DWA / MPC（10-50 Hz）。
- Control：PID / MPC / impedance（100-1000 Hz）。', '**模块（频率）**：
- Perception：LiDAR / camera fusion（10-30 Hz）。
- State Estimation：IMU + 编码器 + VO（100-200 Hz）。
- Planning：global A* / RRT（1-5 Hz）+ local DWA / MPC（10-50 Hz）。
- Control：PID / MPC / impedance（100-1000 Hz）。

**通信**：ROS 2 + DDS；topic / service / action 按场景选。

**安全层**：emergency stop（硬+软双重）；collision check 在 planning 前；watchdog 心跳。

**Sim-to-Real**：模块单测；Isaac Lab / MuJoCo regression；真机灰度。',
   null, null, '["所有模块同频运行浪费算力", "忘 safety layer 出事故", "perception 直送 control 缺 state estimation 中间层。"]'::jsonb, null, 10, false, true, 4, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"机器人系统设计","qid":"Q36","freq_label":"🔥×4"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000480', '设计 multi-sensor fusion 系统（camera + LiDAR + IMU）', 'eaq-v08-q37', 'system_design', 'hard', '**时间同步**：hardware trigger（PTP / GPS PPS）μs 级，远优于软件时间戳（ms 级）；',
   '**时间同步**：hardware trigger（PTP / GPS PPS）μs 级，远优于软件时间戳（ms 级）；车端常用 GMSL 相机硬触发。', '**时间同步**：hardware trigger（PTP / GPS PPS）μs 级，远优于软件时间戳（ms 级）；车端常用 GMSL 相机硬触发。

**标定**：内参（焦距、畸变）+ 外参（相机-LiDAR-IMU SE(3) 变换）；用 Kalibr / lidar_align 工具链。

**融合算法**：
- EKF / UKF：状态 = pose + vel + IMU bias；VIO 主流，适实时。
- Factor graph（GTSAM / Ceres）：批量优化，精度高但延迟大。

**故障处理**：sensor health monitor 检测 dropout / outlier；降级模式（如 LiDAR 失效退回纯视觉 VIO）。

**Covariance**：由传感器规格表 + Allan variance 标定，不要随手填。',
   null, null, '["用软同步致 BA 漂移", "忘 IMU 预积分", "故障检测漏致错误数据污染 fusion。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"机器人系统设计","qid":"Q37","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000481', '设计 VLN agent 系统（自然语言指令 → 导航）', 'eaq-v08-q38', 'system_design', 'hard', '**语义地图**：边走边用 CLIP / Grounding DINO 标 voxel grid 或 BEV map，把"红色椅子"对应到地图坐标。',
   '**语义地图**：边走边用 CLIP / Grounding DINO 标 voxel grid 或 BEV map，把"红色椅子"对应到地图坐标。', '**语义地图**：边走边用 CLIP / Grounding DINO 标 voxel grid 或 BEV map，把"红色椅子"对应到地图坐标。

**指令解析**：LLM 拆 subgoal（"先到沙发再到厨房"→ list of waypoint queries）；CoT 提取空间关系。

**Waypoint policy**：每步预测 next waypoint 像素坐标，反投影到 3D；NaVid / NaVILA / VLN-R1 类 VLM 推理。

**Low-level**：waypoint → A* / RRT → 局部 DWA → motor cmd。

**Failure recovery**：卡死检测（pose 不变 > T s）；重规划或回到上一 waypoint；ask-for-help。

**Closed-loop**：每 1-2 s 重新评估当前 vs goal，不开环跑完。',
   null, null, '["open-loop 跑完才发现卡死", "hallucination 无置信度过滤", "LLM 调用频率过高致延迟爆掉。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"机器人系统设计","qid":"Q38","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000482', '设计 SLAM 状态估计模块', 'eaq-v08-q39', 'system_design', 'hard', '**Frontend**：特征提取（ORB / SuperPoint）+ 匹配（FLANN / SuperGlue）+ 相对位姿求解（PnP / 5-point + RANSAC）。',
   '**Frontend**：特征提取（ORB / SuperPoint）+ 匹配（FLANN / SuperGlue）+ 相对位姿求解（PnP / 5-point + RANSAC）。', '**Frontend**：特征提取（ORB / SuperPoint）+ 匹配（FLANN / SuperGlue）+ 相对位姿求解（PnP / 5-point + RANSAC）。

**Backend**：因子图 / 位姿图优化（GTSAM / g2o / Ceres）；BA 联合优化相机 pose + 地图点；滑窗 BA 控制规模。

**IMU**：预积分把测量打包成相对位姿增量，作为因子加入因子图（VIO 主流）。

**Loop closure**：DBoW / NetVLAD 词袋检测候选；几何校验（PnP RANSAC）+ pose graph 优化纠正累积漂移。

**鲁棒性**：动态物体过滤（语义 / 运动一致性）；初始化判稳；故障时切 odometry-only 模式。',
   null, null, '["frontend / backend 划分不清", "忘 loop closure 致长轨迹漂移", "IMU 没预积分（重积分巨慢）", "动态物体不过滤致 ego-motion 错乱。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"机器人系统设计","qid":"Q39","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000483', '设计 ROS 2 节点架构（双臂操作 demo）', 'eaq-v08-q40', 'system_design', 'medium', '**节点拆分**：Perception（相机驱动 + 6D pose） / Planning（MoveIt 2 双臂） / Arm_controller × 2 + Gripper_controller / Coord…',
   '**节点拆分**：Perception（相机驱动 + 6D pose） / Planning（MoveIt 2 双臂） / Arm_controller × 2 + Gripper_controller / Coordinator（状态机或 behavior tree 编排）。', '**节点拆分**：Perception（相机驱动 + 6D pose） / Planning（MoveIt 2 双臂） / Arm_controller × 2 + Gripper_controller / Coordinator（状态机或 behavior tree 编排）。

**通信**：topic（高频 telemetry）；service（同步如 `compute_ik`）；action（长时任务 `move_to_pose`，含 feedback / cancel）。

**QoS**：sensor 用 `BEST_EFFORT + KEEP_LAST(10)`；控制指令用 `RELIABLE + KEEP_LAST(1)`。

**Launch**：分层（hardware / perception / planning / app），便于真机 / 仿真切换。',
   null, null, '["所有功能塞一个节点", "长时任务用 service 阻塞主循环（应 action）", "QoS 默认全 reliable 致传感器 topic 卡顿。"]'::jsonb, null, 10, false, true, 3, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"08","volume_title":"卷八 · LeetCode + 系统设计","section":"机器人系统设计","qid":"Q40","freq_label":"🔥×3"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000484', 'Jev／System One／RLCD 在公开资料中分别指什么？与 JEPA 有何区别？', 'eaq-v09-f01', 'research', 'medium', 'TypeSafe 将 Jev 定位为首个 System One 模型：对给定状态和预定义问题输出类型化、带概率的决策。',
   'TypeSafe 将 Jev 定位为首个 System One 模型：对给定状态和预定义问题输出类型化、带概率的决策。RLCD 是其公布的训练方法名称，意为“面向校准决策的强化学习”。Meta 的 JEPA 是联合嵌入预测架构，研究目标与接口均不同。', 'TypeSafe 将 Jev 定位为首个 System One 模型：对给定状态和预定义问题输出类型化、带概率的决策。RLCD 是其公布的训练方法名称，意为“面向校准决策的强化学习”。Meta 的 JEPA 是联合嵌入预测架构，研究目标与接口均不同。',
   null, null, '["名称相近不代表同一模型", "官方未公开足以复现的 RLCD 损失、网络细节与训练数据，不能自行补写算法。"]'::jsonb, null, 5, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"决策模型与机器人应用","qid":"F01","freq_label":"前沿拓展·非面经","provenance":"资料：[TypeSafe 原始公告](https://typesafe.ai/blog/introducing-system-one-models-and-jev)、[Meta I-JEPA 原始研究页](https://ai.meta.com/research/publications/self-supervised-learning-from-images-with-a-joint-embedding-predictive-architecture/)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000485', 'RoboJEV 怎样让 Jev 控制机械臂？为什么不能只看 schema 和置信度验收？', 'eaq-v09-f02', 'research', 'medium', 'RoboJEV 把 MuJoCo 的末端／物体位姿、夹爪与接触等特权结构化状态交给 TypeSafe Jev；',
   'RoboJEV 把 MuJoCo 的末端／物体位姿、夹爪与接触等特权结构化状态交给 TypeSafe Jev；先选意图，再选 XYZ 方向和夹爪指令，由笛卡尔控制器执行、物理判据验收。schema 只约束输出形状；`confidence` 是概率分布集中度，校准也不保证当前动作成功。', 'RoboJEV 把 MuJoCo 的末端／物体位姿、夹爪与接触等特权结构化状态交给 TypeSafe Jev；先选意图，再选 XYZ 方向和夹爪指令，由笛卡尔控制器执行、物理判据验收。schema 只约束输出形状；`confidence` 是概率分布集中度，校准也不保证当前动作成功。',
   null, null, '["该项目无相机输入，API 等待时仿真暂停，演示视频省略等待，未验证真机", "Jev 另有实验性图像接口，不代表本项目采用视觉。"]'::jsonb, null, 5, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"决策模型与机器人应用","qid":"F02","freq_label":"前沿拓展·非面经","provenance":"资料：[RoboJEV 作者仓库](https://github.com/lykycy123/RoboJEV)、[TypeSafe 入门文档](https://docs.typesafe.ai/introduction)、[概率校准说明](https://docs.typesafe.ai/introduction/machine-learning-primer)、[置信度说明](https://docs.typesafe.ai/confidence)、[实验性图像文档](https://docs.typesafe.ai/images)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000486', 'Astranomy 的 Direct、Agentic、Orchestrated 三种 Astra 机器人接口如何分工？', 'eaq-v09-f03', 'research', 'medium', 'Direct 每次由 Astra 直接给末端／关节目标或轨迹段，不保留跨调用会话；',
   'Direct 每次由 Astra 直接给末端／关节目标或轨迹段，不保留跨调用会话；Agentic 用持久会话保留交互历史并生成动作；Orchestrated 审阅动作模型的候选，可接受、修改或接管。动作段执行后再送新图像、机器人状态和反馈。模型推理耗时与底层控制频率应分别测量。', 'Direct 每次由 Astra 直接给末端／关节目标或轨迹段，不保留跨调用会话；Agentic 用持久会话保留交互历史并生成动作；Orchestrated 审阅动作模型的候选，可接受、修改或接管。动作段执行后再送新图像、机器人状态和反馈。模型推理耗时与底层控制频率应分别测量。',
   null, null, '["报告的 15 Hz 是控制步频率", "成功回合中的 Direct 末端接口平均单次推理约 18.56 秒，不能写成 Astra 以 15 Hz 决策", "其仿真在推理期间暂停。"]'::jsonb, null, 5, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"通用模型控制与 VLA 协作","qid":"F03","freq_label":"前沿拓展·非面经","provenance":"资料：[NVIDIA Astranomy 作者报告](https://research.nvidia.com/labs/srl/projects/astranomy/)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000487', 'RoboDojo 的 Astra 演示能证明什么？为什么不能据此认定动态真机控制可靠？', 'eaq-v09-f04', 'research', 'medium', 'RoboDojo 主评测是 42 个任务、2100 次仿真试验，说明模型在该动作接口和基准下能完成部分任务。',
   'RoboDojo 主评测是 42 个任务、2100 次仿真试验，说明模型在该动作接口和基准下能完成部分任务。真机仅为选择性诊断；作者因不合理或不安全动作及设备损伤中止正式真机协议。因此需另测推理等待期间的环境变化、接触扰动、安全停止与实际成功率。', 'RoboDojo 主评测是 42 个任务、2100 次仿真试验，说明模型在该动作接口和基准下能完成部分任务。真机仅为选择性诊断；作者因不合理或不安全动作及设备损伤中止正式真机协议。因此需另测推理等待期间的环境变化、接触扰动、安全停止与实际成功率。',
   null, null, '["选出的真机片段不是完整真机基准", "仿真任务成功也不能推出连续动态环境或硬件上的实时闭环可靠性。"]'::jsonb, null, 5, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"通用模型控制与 VLA 协作","qid":"F04","freq_label":"前沿拓展·非面经","provenance":"资料：[RoboDojo Astra 原论文](https://arxiv.org/html/2609.24170v1)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000488', 'Astra＋VLA：候选轨迹审阅与 Python 原语编排有何不同？', 'eaq-v09-f05', 'research', 'hard', '银河通用研究让任务微调 π0.5 先给候选关节轨迹，Astra 选择沿用前段或用短末端动作局部覆盖。',
   '银河通用研究让任务微调 π0.5 先给候选关节轨迹，Astra 选择沿用前段或用短末端动作局部覆盖。PyRUA-Lean 则由 Astra 写 Python cell，组合含冻结 VLA 的原语、检查中间结果并决定后续调用。前者改候选动作，后者编排可复用执行接口。', '银河通用研究让任务微调 π0.5 先给候选关节轨迹，Astra 选择沿用前段或用短末端动作局部覆盖。PyRUA-Lean 则由 Astra 写 Python cell，组合含冻结 VLA 的原语、检查中间结果并决定后续调用。前者改候选动作，后者编排可复用执行接口。',
   null, null, '["银河通用结果是 RoboDojo 仿真子集", "PyRUA 的无 VLA 扩展是另设实验，4B Coder 未在该设置测试。不能混成同一系统或泛化到真机。"]'::jsonb, null, 8, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"通用模型控制与 VLA 协作","qid":"F05","freq_label":"前沿拓展·非面经","provenance":"资料：[银河通用候选轨迹研究](https://arxiv.org/html/2609.38537v1)、[PyRUA-Lean 原论文 v2](https://arxiv.org/html/2610.01939v2)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000489', '机器人 harness 如何把观测、动作执行和验收接成物理闭环？', 'eaq-v09-f06', 'research', 'medium', 'Thea 每轮汇入新鲜物理观测，模型选工具，执行后由 harness 触发操作评价；',
   'Thea 每轮汇入新鲜物理观测，模型选工具，执行后由 harness 触发操作评价；Show-Harness 让 VLM 输出离散语义动作，再由本体解释器转成有工作空间限制的控制目标。二者均让模型动作经过执行层，并据后续观测继续决策；Thea 另设强制操作评价。', 'Thea 每轮汇入新鲜物理观测，模型选工具，执行后由 harness 触发操作评价；Show-Harness 让 VLM 输出离散语义动作，再由本体解释器转成有工作空间限制的控制目标。二者均让模型动作经过执行层，并据后续观测继续决策；Thea 另设强制操作评价。',
   null, null, '["模型说“完成”、工具返回成功或评价器给分都不能单独充当物理真值", "不同论文的工具调用与语义动作接口也不能混写。"]'::jsonb, null, 5, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"具身 Agent、Harness 与自我改进","qid":"F06","freq_label":"前沿拓展·非面经","provenance":"资料：[Thea 作者系统说明](https://eit-hai.github.io/thea/system.html)、[Show-Harness 原论文](https://arxiv.org/html/2609.10522v1)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000490', '具身 Agent 的“递归自我改进”（RSI）究竟在修改什么？', 'eaq-v09-f07', 'research', 'hard', '先标明改动对象与生效时点。',
   '先标明改动对象与生效时点。RegenHarness 提议跨任务修订上下文、模板和路由等配置；COAP 由 coding agent 在开发期改共享代码，执行期冻结；EmbodiedEvo 继承代码技能和文字经验；ENPIRE 在人工协助建立任务接口后，还可改训练算法并更新策略权重。', '先标明改动对象与生效时点。RegenHarness 提议跨任务修订上下文、模板和路由等配置；COAP 由 coding agent 在开发期改共享代码，执行期冻结；EmbodiedEvo 继承代码技能和文字经验；ENPIRE 在人工协助建立任务接口后，还可改训练算法并更新策略权重。',
   null, null, '["一次失败重试不等于跨任务改进", "这里 RSI 是 Recursive Self-Improvement，运动模仿论文中的 RSI 也可指 Reference State Initialization。"]'::jsonb, null, 8, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"具身 Agent、Harness 与自我改进","qid":"F07","freq_label":"前沿拓展·非面经","provenance":"资料：[RegenHarness 原论文](https://arxiv.org/html/2609.27612v1)、[COAP 原论文](https://arxiv.org/html/2610.12369v1)、[EmbodiedEvo 原论文](https://arxiv.org/html/2610.18867v1)、[ENPIRE 原论文](https://arxiv.org/html/2606.19980v1)、[Reference State Initialization 原论文](https://arxiv.org/abs/1907.11842)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb),
  ('f1000000-0000-4000-8000-000000000491', '如何验证机器人 RSI 不是回归、评测泄漏，或只有改进协议没有增益？', 'eaq-v09-f08', 'research', 'hard', '保留旧版，比较时固定或记录模型／策略版本与预算，使用独立验收指标；',
   '保留旧版，比较时固定或记录模型／策略版本与预算，使用独立验收指标；开发、选优、留出测试按任务与布局隔离，记录每次改动、失败和回滚，在新场景重复比较并单列真机验证。RegenHarness 提出版本门禁，尚未证明持续量化增益；COAP 的结果限于使用已知资产的仿真；ENPIRE 与 EmbodiedRSI 的真机证据限于各自配置的任务。', '保留旧版，比较时固定或记录模型／策略版本与预算，使用独立验收指标；开发、选优、留出测试按任务与布局隔离，记录每次改动、失败和回滚，在新场景重复比较并单列真机验证。RegenHarness 提出版本门禁，尚未证明持续量化增益；COAP 的结果限于使用已知资产的仿真；ENPIRE 与 EmbodiedRSI 的真机证据限于各自配置的任务。',
   null, null, '["验证集单调上升不是未见任务或无限轮次自我进化", "EmbodiedRSI 真机底层策略先按任务示教微调，再冻结，不能称本体零样本。"]'::jsonb, null, 8, false, true, 0, '{"source":"embodied-interview-qa","repo":"https://github.com/WinstonJQ/embodied-interview-qa","commit":"001e42385d421294066767f286e786e378595f13","license":"MIT","volume":"09","volume_title":"卷九 · 近期热门方向与前沿题目","section":"具身 Agent、Harness 与自我改进","qid":"F08","freq_label":"前沿拓展·非面经","provenance":"资料：[RegenHarness 原论文](https://arxiv.org/html/2609.27612v1)、[COAP 原论文](https://arxiv.org/html/2610.12369v1)、[ENPIRE 原论文](https://arxiv.org/html/2606.19980v1)、[EmbodiedRSI 原论文](https://arxiv.org/html/2610.10498v1)。\n\n性质：依据技术资料整理的学习问答，非面经，不计频次。"}'::jsonb)
on conflict (slug) do nothing;

-- -------------------------------------------------------------------------
-- question_topics 关联
-- -------------------------------------------------------------------------
insert into public.question_topics (question_id, topic_id, weight) values
  ('f1000000-0000-4000-8000-000000000080', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000081', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000082', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000083', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000084', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000085', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000086', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000087', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000088', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000089', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000090', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000091', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000092', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000093', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000094', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000095', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000096', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000096', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000097', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000098', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000099', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000099', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000026', 1.0),
  ('f1000000-0000-4000-8000-000000000100', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000101', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000102', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000102', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000103', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000104', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000105', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000106', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000107', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000108', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000109', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000109', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000110', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000111', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000112', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000113', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000114', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000115', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000116', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000117', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000118', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000119', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000120', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000121', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000122', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000123', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000123', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000124', 'd1000000-0000-4000-8000-000000000028', 1.0),
  ('f1000000-0000-4000-8000-000000000125', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000126', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000126', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000127', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000128', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000129', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000129', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000130', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000131', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000132', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000133', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000134', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000135', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000136', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000137', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000138', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000139', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000026', 1.0),
  ('f1000000-0000-4000-8000-000000000140', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000026', 1.0),
  ('f1000000-0000-4000-8000-000000000140', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000027', 1.0),
  ('f1000000-0000-4000-8000-000000000141', 'd1000000-0000-4000-8000-000000000029', 1.0),
  ('f1000000-0000-4000-8000-000000000142', 'd1000000-0000-4000-8000-000000000029', 1.0),
  ('f1000000-0000-4000-8000-000000000143', 'd1000000-0000-4000-8000-000000000029', 1.0),
  ('f1000000-0000-4000-8000-000000000144', 'd1000000-0000-4000-8000-000000000029', 1.0),
  ('f1000000-0000-4000-8000-000000000145', 'd1000000-0000-4000-8000-000000000029', 1.0),
  ('f1000000-0000-4000-8000-000000000146', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000146', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000147', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000147', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000148', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000148', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000148', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000149', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000149', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000149', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000149', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000150', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000150', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000027', 1.0),
  ('f1000000-0000-4000-8000-000000000151', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000151', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000027', 1.0),
  ('f1000000-0000-4000-8000-000000000151', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000151', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000152', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000152', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000027', 1.0),
  ('f1000000-0000-4000-8000-000000000153', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000153', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000027', 1.0),
  ('f1000000-0000-4000-8000-000000000154', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000154', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000027', 1.0),
  ('f1000000-0000-4000-8000-000000000155', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000156', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000156', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000026', 1.0),
  ('f1000000-0000-4000-8000-000000000157', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000157', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000158', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000159', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000159', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000160', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000160', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000161', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000161', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000162', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000162', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000011', 1.0),
  ('f1000000-0000-4000-8000-000000000163', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000164', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000165', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000166', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000167', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000167', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000167', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000168', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000169', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000170', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000171', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000172', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000022', 1.0),
  ('f1000000-0000-4000-8000-000000000172', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000173', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000174', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000175', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000175', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000015', 1.0),
  ('f1000000-0000-4000-8000-000000000176', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000177', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000178', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000178', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000179', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000180', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000180', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000016', 1.0),
  ('f1000000-0000-4000-8000-000000000180', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000015', 1.0),
  ('f1000000-0000-4000-8000-000000000181', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000181', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000016', 1.0),
  ('f1000000-0000-4000-8000-000000000182', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000182', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000016', 1.0),
  ('f1000000-0000-4000-8000-000000000182', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000183', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000183', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000016', 1.0),
  ('f1000000-0000-4000-8000-000000000183', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000184', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000185', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000185', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000186', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000186', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000187', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000187', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000188', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000188', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000189', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000189', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000190', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000190', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000191', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000191', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000192', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000192', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000193', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000193', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000194', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000194', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000195', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000195', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000195', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000019', 1.0),
  ('f1000000-0000-4000-8000-000000000196', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000196', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000197', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000197', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000198', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000198', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000199', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000200', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000201', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000202', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000203', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000204', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000204', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000015', 1.0),
  ('f1000000-0000-4000-8000-000000000205', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000206', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000206', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000207', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000208', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000208', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000209', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000209', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000210', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000210', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000210', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000211', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000211', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000212', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000212', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000213', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000213', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000214', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000214', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000215', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000215', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000216', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000216', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000217', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000217', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000218', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000218', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000219', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000219', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000220', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000220', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000221', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000221', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000222', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000222', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000222', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000019', 1.0),
  ('f1000000-0000-4000-8000-000000000223', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000224', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000224', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000225', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000225', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000226', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000226', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000227', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000228', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000229', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000230', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000231', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000231', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000016', 1.0),
  ('f1000000-0000-4000-8000-000000000232', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000233', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000234', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000235', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000235', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000235', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000025', 1.0),
  ('f1000000-0000-4000-8000-000000000236', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000237', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000237', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000238', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000239', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000240', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000240', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000241', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000242', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000243', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000244', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000245', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000246', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000247', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000248', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000249', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000250', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000251', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000252', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000253', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000254', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000255', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000255', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000256', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000257', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000258', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000259', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000259', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000260', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000260', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000261', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000261', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000262', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000263', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000264', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000265', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000266', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000267', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000267', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000267', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000268', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000269', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000270', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000270', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000271', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000271', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000272', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000272', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000273', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000274', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000274', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000275', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000275', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000276', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000276', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000277', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000277', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000278', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000278', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000279', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000279', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000280', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000280', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000281', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000281', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000282', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000282', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000283', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000283', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000284', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000284', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000285', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000285', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000286', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000013', 1.0),
  ('f1000000-0000-4000-8000-000000000286', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000287', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000287', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000288', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000288', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000289', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000290', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000290', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000008', 1.0),
  ('f1000000-0000-4000-8000-000000000291', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000292', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000292', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000293', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000293', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000294', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000294', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000294', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000295', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000295', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000295', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000296', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000296', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000297', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000297', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000298', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000298', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000298', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000299', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000300', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000301', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000302', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000302', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000303', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000304', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000305', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000306', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000307', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000308', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000309', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000310', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000311', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000312', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000313', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000314', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000315', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000316', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000317', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000317', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000318', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000319', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000320', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000321', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000322', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000322', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000323', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000324', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000325', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000326', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000327', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000328', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000329', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000330', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000331', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000332', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000333', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000333', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000334', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000335', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000336', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000337', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000338', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000339', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000340', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000341', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000342', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000342', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000342', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000010', 1.0),
  ('f1000000-0000-4000-8000-000000000342', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000343', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000343', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000344', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000344', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000345', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000345', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000346', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000346', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000346', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000347', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000347', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000348', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000348', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000348', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000348', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000349', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000349', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000009', 1.0),
  ('f1000000-0000-4000-8000-000000000350', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000351', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000352', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000353', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000354', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000355', 'd1000000-0000-4000-8000-000000000032', 1.0),
  ('f1000000-0000-4000-8000-000000000356', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000357', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000358', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000359', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000360', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000360', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000361', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000361', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000362', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000362', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000362', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000363', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000363', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000364', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000364', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000365', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000365', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000366', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000366', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000367', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000368', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000369', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000369', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000370', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000370', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000371', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000372', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000373', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000373', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000374', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000375', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000375', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000012', 1.0),
  ('f1000000-0000-4000-8000-000000000376', 'd1000000-0000-4000-8000-000000000031', 1.0),
  ('f1000000-0000-4000-8000-000000000377', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000378', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000379', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000380', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000381', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000382', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000383', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000384', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000384', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000020', 1.0),
  ('f1000000-0000-4000-8000-000000000385', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000386', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000387', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000387', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000388', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000389', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000390', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000390', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000391', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000392', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000393', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000394', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000395', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000396', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000397', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000398', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000399', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000400', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000401', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000402', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000403', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000404', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000404', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000405', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000406', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000406', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000017', 1.0),
  ('f1000000-0000-4000-8000-000000000407', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000408', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000409', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000410', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000411', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000412', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000413', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000414', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000415', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000416', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000417', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000418', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000419', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000420', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000421', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000422', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000423', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000424', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000425', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000426', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000427', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000428', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000428', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000429', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000429', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000429', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000430', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000430', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000430', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000023', 1.0),
  ('f1000000-0000-4000-8000-000000000431', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000431', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000432', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000432', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000433', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000433', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000434', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000435', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000436', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000437', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000438', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000439', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000440', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000441', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000442', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000443', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000444', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000445', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000446', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000447', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000448', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000449', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000450', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000451', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000452', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000453', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000454', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000455', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000456', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000457', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000458', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000459', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000460', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000461', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000462', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000463', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000464', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000465', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000466', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000467', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000468', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000469', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000470', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000471', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000472', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000473', 'd1000000-0000-4000-8000-000000000035', 1.0),
  ('f1000000-0000-4000-8000-000000000474', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000474', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000475', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000475', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000475', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000476', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000476', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000021', 1.0),
  ('f1000000-0000-4000-8000-000000000477', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000478', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000479', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000479', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000480', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000480', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000481', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000481', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000481', 'd1000000-0000-4000-8000-000000000034', 1.0),
  ('f1000000-0000-4000-8000-000000000482', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000482', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000482', 'd1000000-0000-4000-8000-000000000033', 1.0),
  ('f1000000-0000-4000-8000-000000000483', 'd1000000-0000-4000-8000-000000000036', 1.0),
  ('f1000000-0000-4000-8000-000000000483', 'd1000000-0000-4000-8000-000000000030', 1.0),
  ('f1000000-0000-4000-8000-000000000484', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000484', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000007', 1.0),
  ('f1000000-0000-4000-8000-000000000485', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000486', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000486', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000487', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000487', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000488', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000488', 'd1000000-0000-4000-8000-d1000000-0000-4000-8000-000000000006', 1.0),
  ('f1000000-0000-4000-8000-000000000489', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000490', 'd1000000-0000-4000-8000-000000000037', 1.0),
  ('f1000000-0000-4000-8000-000000000491', 'd1000000-0000-4000-8000-000000000037', 1.0)
on conflict (question_id, topic_id) do nothing;

-- -------------------------------------------------------------------------
-- 答案融合：源题库与现有重复题的答案合并（人工撰写，逐条复核）
-- -------------------------------------------------------------------------
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

