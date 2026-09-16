"""Beam Search 解码（源自 TorchCode `beam_search`，已获授权改写）。"""

PROBLEM = {
    "slug": "beam-search-decode",
    "title": "实现 Beam Search 解码",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "从零实现 beam search 解码。给定每一步的词表对数概率（已算好，不需要模型），"
        "维护 beam_width 条候选序列，返回累计对数概率最高的序列：\n\n"
        "    1. 初始候选：一条空序列（已生成 0 个 token），累计分数 0.0；\n"
        "    2. 每一步：把每个候选与词表中每个 token v 组合，新分数 = 累计分数 + log_probs[step][v]；\n"
        "    3. 从所有候选中保留累计分数最大的 beam_width 条"
        "（分数相同时保留在展开列表中更靠前的候选）；\n"
        "    4. 处理完 S 步后，返回分数最高的一条：元组 (sequence, score)。\n\n"
        "sequence 为 list[int]（token id，长度 S），score 为 Python float"
        "（整条序列所有步的 log_probs 之和）。\n\n"
        "要求：\n"
        "- 不要调用 torch.topk / torch.sort 等排序原语来实现保留逻辑"
        "（beam search 常考手写排序，建议用 sorted + key）；\n"
        "- beam_width = 1 时必须等价于贪心解码。"
    ),
    "constraints": "log_probs 为 float32 张量 (S, V)，1 <= S <= 16，2 <= V <= 64；1 <= beam_width <= V；保证每步不存在分数并列。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "beam_search",
    "framework": "pytorch",
    "resource_profile": "ml_cpu_small",
    "evaluator_config": {
        "comparison": "allclose",
        "rtol": 0.0001,
        "atol": 0.00001,
        "check_shape": False,
        "check_dtype": False,
        "check_gradient": False,
    },
}

STARTER = """import torch

def beam_search(log_probs: torch.Tensor, beam_width: int):
    # log_probs: (S, V)，第 s 步的词表对数概率
    # TODO: 返回 (sequence, score)，sequence 为 list[int]，score 为 float
    return [], 0.0
"""

SOLUTION = """import torch

def beam_search(log_probs: torch.Tensor, beam_width: int):
    beams = [([], 0.0)]
    for step in range(log_probs.shape[0]):
        step_lp = log_probs[step].tolist()
        candidates = []
        for seq, score in beams:
            for v, lp in enumerate(step_lp):
                candidates.append((seq + [v], score + lp))
        candidates.sort(key=lambda item: item[1], reverse=True)
        beams = candidates[:beam_width]
    return beams[0]
"""


def build_cases():
    import torch

    from framework import VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261005)

    lp_v = torch.log_softmax(torch.randn(4, 5, generator=g), dim=-1)

    lp_greedy = torch.log_softmax(torch.randn(6, 8, generator=g), dim=-1)

    lp_bv = torch.log_softmax(torch.randn(3, 4, generator=g), dim=-1)

    lp_1 = torch.log_softmax(torch.randn(1, 10, generator=g), dim=-1)

    lp_s = torch.log_softmax(torch.randn(16, 32, generator=g), dim=-1)

    return [
        visible_example("S=4 V=5 beam=2", args=[T(lp_v), 2], expected=VALUE()),
        case("beam=1 等价贪心", args=[T(lp_greedy), 1], expected=VALUE(), weight=1.5),
        case("beam=V 穷举", args=[T(lp_bv), 4], expected=VALUE()),
        case("单步解码", args=[T(lp_1), 3], expected=VALUE()),
        case("长序列 beam=4", args=[T(lp_s), 4], expected=VALUE()),
    ]
