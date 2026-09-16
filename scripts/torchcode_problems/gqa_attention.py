"""GQA 分组查询注意力（源自 TorchCode `gqa`，已获授权改写）。"""

PROBLEM = {
    "slug": "gqa-attention",
    "title": "实现分组查询注意力（GQA）",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "实现分组查询注意力（Grouped-Query Attention）。Q 有 H 个查询头，K/V 只有 H_kv 个头"
        "（H 是 H_kv 的整数倍），每个 KV 头被相邻的 H/H_kv 个查询头共享：\n\n"
        "    1. 把 k、v 的每个头沿头维度重复 H/H_kv 次（等价于 repeat_interleave，"
        "即 kv 头 0 分给查询头 0..rep-1，kv 头 1 分给 rep..2*rep-1，以此类推）；\n"
        "    2. 按标准缩放点积注意力计算：scores = q @ k^T / sqrt(d_k)，d_k = D；\n"
        "    3. 对最后一维做 softmax 后加权求和 v。\n\n"
        "输入形状：q 为 (B, H, S, D)，k/v 为 (B, H_kv, S, D)，输出形状与 q 相同。\n\n"
        "要求：\n"
        "- 不要调用 torch.nn.functional.scaled_dot_product_attention；\n"
        "- 计算必须可微；\n"
        "- 注意 repeat_interleave（每头连续重复）与 repeat（交错平铺）的区别。"
    ),
    "constraints": "B <= 2；H ∈ {4, 8}；H_kv 整除 H；S <= 16；D ∈ {8, 16}，全为 float32。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "gqa",
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

def gqa(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor, n_kv_heads: int) -> torch.Tensor:
    # q: (B, H, S, D)；k/v: (B, H_kv, S, D)
    # TODO: 返回 (B, H, S, D)
    return q
"""

SOLUTION = """import math

import torch

def gqa(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor, n_kv_heads: int) -> torch.Tensor:
    rep = q.shape[1] // n_kv_heads
    k_full = k.repeat_interleave(rep, dim=1)
    v_full = v.repeat_interleave(rep, dim=1)
    d_k = q.shape[-1]
    scores = q @ k_full.transpose(-2, -1) / math.sqrt(d_k)
    attn = torch.softmax(scores, dim=-1)
    return attn @ v_full
"""


def build_cases():
    import torch

    from framework import GRAD, SHAPE, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260928)

    # H == Hkv 退化为标准 MHA
    q_v = torch.randn(1, 4, 6, 8, generator=g)
    k_v = torch.randn(1, 4, 6, 8, generator=g)
    v_v = torch.randn(1, 4, 6, 8, generator=g)

    # H=4, Hkv=2
    q_g = torch.randn(1, 4, 6, 8, generator=g)
    k_g = torch.randn(1, 2, 6, 8, generator=g)
    v_g = torch.randn(1, 2, 6, 8, generator=g)

    # H=8, Hkv=2, 批量 2
    q_b = torch.randn(2, 8, 10, 16, generator=g)
    k_b = torch.randn(2, 2, 10, 16, generator=g)
    v_b = torch.randn(2, 2, 10, 16, generator=g)

    q_s = torch.randn(1, 4, 1, 8, generator=g)  # 单 token
    k_s = torch.randn(1, 2, 1, 8, generator=g)
    v_s = torch.randn(1, 2, 1, 8, generator=g)

    q_sh = torch.randn(1, 8, 8, 8, generator=g)
    k_sh = torch.randn(1, 2, 8, 8, generator=g)
    v_sh = torch.randn(1, 2, 8, 8, generator=g)

    q_gr = torch.randn(1, 4, 6, 8, generator=g)
    k_gr = torch.randn(1, 1, 6, 8, generator=g)  # MQA：单 KV 头
    v_gr = torch.randn(1, 1, 6, 8, generator=g)

    return [
        visible_example("退化为标准 MHA", args=[T(q_v), T(k_v), T(v_v), 4], expected=VALUE()),
        case("H=4 Hkv=2", args=[T(q_g), T(k_g), T(v_g), 2], expected=VALUE()),
        case("H=8 Hkv=2 批量 2", args=[T(q_b), T(k_b), T(v_b), 2], expected=VALUE(), weight=1.5),
        case("单 token 解码", args=[T(q_s), T(k_s), T(v_s), 2], expected=VALUE()),
        case("输出形状检查", args=[T(q_sh), T(k_sh), T(v_sh), 2], expected=SHAPE()),
        case("MQA 单 KV 头梯度", args=[T(q_gr, rg=True), T(k_gr), T(v_gr), 1], expected=GRAD(), weight=1.5),
    ]
