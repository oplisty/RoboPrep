"""因果注意力（Flash Attention 风格分块在线 softmax 的数值验证）（源自 TorchCode `flash_attention`，已获授权改写）。"""

PROBLEM = {
    "slug": "flash-attention-small",
    "title": "实现因果自注意力（Flash Attention 数值版）",
    "difficulty": "hard",
    "category": "transformer",
    "description": (
        "实现带因果掩码的自注意力，数值上等价于 Flash Attention 的输出。"
        "Flash Attention 的关键是通过分块在线 softmax 避免物化 S×S 矩阵，"
        "本题在小规模上验证你实现的**数值正确性**（与直接计算的结果完全一致）：\n\n"
        "    scores = q @ k^T / sqrt(D)\n"
        "    scores[i, j] = -inf   当 j > i（因果掩码，不允许看未来）\n"
        "    out = softmax(scores, dim=-1) @ v\n\n"
        "输入形状：q/k/v 均为 (B, H, S, D)，输出形状与 q 相同。\n\n"
        "建议按 Flash Attention 的思路做块级在线 softmax（block_size 建议取 8~16）；"
        "判题只看数值（与标准实现的 allclose 偏差）。注意分块累加时用 max 值做平移校正，"
        "避免中间结果溢出。\n\n"
        "要求：\n"
        "- 不要调用 torch.nn.functional.scaled_dot_product_attention 或 torch.nn.functional.softmax"
        "（请自己实现带在线 max 平移的 softmax，这也是 Flash Attention 的核心技巧）；\n"
        "- 计算必须可微。"
    ),
    "constraints": "B, H <= 2；S <= 64；D = 8，全为 float32。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "flash_attention",
    "framework": "pytorch",
    "resource_profile": "ml_cpu_medium",
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

def flash_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    # q/k/v: (B, H, S, D)；因果掩码：位置 i 只能看到 j <= i
    # TODO: 分块在线 softmax 实现，返回 (B, H, S, D)
    return q
"""

SOLUTION = """import math

import torch

def flash_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    S = q.shape[-2]
    d_k = q.shape[-1]
    scores = q @ k.transpose(-2, -1) / math.sqrt(d_k)
    causal = torch.tril(torch.ones(S, S, dtype=torch.bool, device=q.device))
    scores = scores.masked_fill(~causal, float("-inf"))
    row_max = scores.max(dim=-1, keepdim=True).values
    exp = torch.exp(scores - row_max)
    exp = torch.where(torch.isfinite(exp), exp, torch.zeros_like(exp))
    denom = exp.sum(dim=-1, keepdim=True)
    attn = exp / denom
    return attn @ v
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260931)

    q_v = torch.randn(1, 1, 8, 8, generator=g)
    k_v = torch.randn(1, 1, 8, 8, generator=g)
    v_v = torch.randn(1, 1, 8, 8, generator=g)

    q_r = torch.randn(1, 2, 32, 8, generator=g)
    k_r = torch.randn(1, 2, 32, 8, generator=g)
    v_r = torch.randn(1, 2, 32, 8, generator=g)

    q_b = torch.randn(2, 2, 16, 8, generator=g)
    k_b = torch.randn(2, 2, 16, 8, generator=g)
    v_b = torch.randn(2, 2, 16, 8, generator=g)

    # 大数值输入检验在线 max 平移是否防溢出
    q_bigi = torch.randn(1, 1, 64, 8, generator=g) * 10
    k_bigi = torch.randn(1, 1, 64, 8, generator=g) * 10
    v_bigi = torch.randn(1, 1, 64, 8, generator=g)

    q_g = torch.randn(1, 1, 16, 8, generator=g)
    k_g = torch.randn(1, 1, 16, 8, generator=g)
    v_g = torch.randn(1, 1, 16, 8, generator=g)

    return [
        visible_example("S=8 基础用例", args=[T(q_v), T(k_v), T(v_v)], expected=VALUE()),
        case("S=32 双头", args=[T(q_r), T(k_r), T(v_r)], expected=VALUE(), weight=1.5),
        case("批量 2", args=[T(q_b), T(k_b), T(v_b)], expected=VALUE()),
        case("大数值稳定性 S=64", args=[T(q_bigi), T(k_bigi), T(v_bigi)], expected=VALUE(), weight=1.5),
        case("梯度回传", args=[T(q_g, rg=True), T(k_g), T(v_g)], expected=GRAD(), weight=1.5),
    ]
