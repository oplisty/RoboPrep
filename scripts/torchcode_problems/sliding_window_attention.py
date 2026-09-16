"""滑窗注意力（源自 TorchCode `sliding_window`，已获授权改写）。"""

PROBLEM = {
    "slug": "sliding-window-attention",
    "title": "实现滑动窗口注意力",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "实现滑动窗口（局部带状）注意力。位置 i 只能 attend 到窗口内的位置：\n\n"
        "    i - window + 1 <= j <= i（j 需在 [0, S) 内）\n\n"
        "即窗口大小为 window（含当前位置本身）。窗口外的注意力权重强制为 0，"
        "等价于在 scores 上把非法位置置为 -inf 后做 softmax：\n\n"
        "    scores = q @ k^T / sqrt(D)\n"
        "    scores[非法位置] = -inf\n"
        "    out = softmax(scores, dim=-1) @ v\n\n"
        "输入形状：q/k/v 均为 (B, H, S, D)，输出形状与 q 相同。\n\n"
        "要求：\n"
        "- 不要调用 torch.nn.functional.scaled_dot_product_attention；\n"
        "- 计算必须可微；\n"
        "- 注意 -inf 位置的 softmax 权重必须严格为 0（不产生 NaN）。"
    ),
    "constraints": "B, H <= 2；1 <= window <= S <= 32；D ∈ {8, 16}，全为 float32。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "sliding_window_attention",
    "framework": "pytorch",
    "resource_profile": "ml_cpu_small",
    "evaluator_config": {
        "comparison": "allclose",
        "rtol": 0.0001,
        "atol": 0.00001,
        "check_shape": True,
        "check_dtype": False,
        "check_gradient": True,
    },
}

STARTER = """import torch

def sliding_window_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor, window: int) -> torch.Tensor:
    # q/k/v: (B, H, S, D)；window: 窗口大小（含当前位置）
    # TODO: 返回 (B, H, S, D)
    return q
"""

SOLUTION = """import math

import torch

def sliding_window_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor, window: int) -> torch.Tensor:
    S = q.shape[-2]
    scores = q @ k.transpose(-2, -1) / math.sqrt(q.shape[-1])
    idx = torch.arange(S)
    mask = (idx.unsqueeze(0) >= idx.unsqueeze(1) - window + 1) & (idx.unsqueeze(0) <= idx.unsqueeze(1))
    scores = scores.masked_fill(~mask, float("-inf"))
    attn = torch.softmax(scores, dim=-1)
    return attn @ v
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260929)

    q_v = torch.randn(1, 1, 8, 8, generator=g)
    k_v = torch.randn(1, 1, 8, 8, generator=g)
    v_v = torch.randn(1, 1, 8, 8, generator=g)

    q_w = torch.randn(1, 2, 16, 8, generator=g)
    k_w = torch.randn(1, 2, 16, 8, generator=g)
    v_w = torch.randn(1, 2, 16, 8, generator=g)

    q_f = torch.randn(1, 1, 8, 8, generator=g)
    k_f = torch.randn(1, 1, 8, 8, generator=g)
    v_f = torch.randn(1, 1, 8, 8, generator=g)

    q_1 = torch.randn(1, 2, 12, 16, generator=g)
    k_1 = torch.randn(1, 2, 12, 16, generator=g)
    v_1 = torch.randn(1, 2, 12, 16, generator=g)

    q_g = torch.randn(1, 1, 8, 8, generator=g)
    k_g = torch.randn(1, 1, 8, 8, generator=g)
    v_g = torch.randn(1, 1, 8, 8, generator=g)

    return [
        visible_example("窗口=3 基础用例", args=[T(q_v), T(k_v), T(v_v), 3], expected=VALUE()),
        case("窗口=4 双头", args=[T(q_w), T(k_w), T(v_w), 4], expected=VALUE(), weight=1.5),
        case("窗口=全序列（等价全局）", args=[T(q_f), T(k_f), T(v_f), 8], expected=VALUE()),
        case("窗口=1（只看自己）", args=[T(q_1), T(k_1), T(v_1), 1], expected=VALUE()),
        case("梯度回传", args=[T(q_g, rg=True), T(k_g), T(v_g), 3], expected=GRAD(), weight=1.5),
    ]
