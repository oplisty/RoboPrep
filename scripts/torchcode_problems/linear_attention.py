"""线性注意力（核函数版）（源自 TorchCode `linear_attention`，已获授权改写）。"""

PROBLEM = {
    "slug": "linear-attention",
    "title": "实现线性注意力（核函数版）",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "实现基于特征映射的线性注意力，把 O(S^2) 的注意力近似为 O(S)：\n\n"
        "    φ(x) = elu(x) + 1\n"
        "    out = φ(q) @ (φ(k)^T @ v) / (φ(q) @ (Σ_j φ(k_j))^T)\n\n"
        "其中分母是逐 query 位置的标量：den_i = φ(q_i) · (Σ_j φ(k_j))，形状 (B, H, S, 1)。"
        "等价地，out = (φq @ φk^T / 行归一化) @ v，但应按上面结合律的形式实现以体现 O(S) 结构。\n\n"
        "输入形状：q/k/v 均为 (B, H, S, D)，输出形状与 q 相同。\n\n"
        "要求：\n"
        "- 不要调用 softmax 或 scaled_dot_product_attention；\n"
        "- 计算必须可微；\n"
        "- φ 用 torch.nn.functional.elu(x) + 1。"
    ),
    "constraints": "B, H <= 2；S <= 32；D ∈ {8, 16}，全为 float32。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "linear_attention",
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

def linear_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    # q/k/v: (B, H, S, D)
    # TODO: 返回 (B, H, S, D)
    return q
"""

SOLUTION = """import torch
import torch.nn.functional as F

def linear_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    qf = F.elu(q) + 1.0
    kf = F.elu(k) + 1.0
    num = qf @ (kf.transpose(-2, -1) @ v)
    den = qf @ kf.sum(dim=-2, keepdim=True).transpose(-2, -1)
    return num / den
"""


def build_cases():
    import torch

    from framework import GRAD, SHAPE, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260930)

    q_v = torch.randn(1, 1, 8, 8, generator=g)
    k_v = torch.randn(1, 1, 8, 8, generator=g)
    v_v = torch.randn(1, 1, 8, 8, generator=g)

    q_r = torch.randn(1, 2, 16, 16, generator=g)
    k_r = torch.randn(1, 2, 16, 16, generator=g)
    v_r = torch.randn(1, 2, 16, 16, generator=g)

    q_b = torch.randn(2, 2, 10, 8, generator=g)
    k_b = torch.randn(2, 2, 10, 8, generator=g)
    v_b = torch.randn(2, 2, 10, 8, generator=g)

    q_s = torch.randn(1, 1, 32, 8, generator=g)
    k_s = torch.randn(1, 1, 32, 8, generator=g)
    v_s = torch.randn(1, 1, 32, 8, generator=g)

    q_g = torch.randn(1, 1, 8, 8, generator=g)
    k_g = torch.randn(1, 1, 8, 8, generator=g)
    v_g = torch.randn(1, 1, 8, 8, generator=g)

    return [
        visible_example("基础用例", args=[T(q_v), T(k_v), T(v_v)], expected=VALUE()),
        case("双头 D=16", args=[T(q_r), T(k_r), T(v_r)], expected=VALUE()),
        case("批量 2", args=[T(q_b), T(k_b), T(v_b)], expected=VALUE()),
        case("S=32 长序列", args=[T(q_s), T(k_s), T(v_s)], expected=VALUE()),
        case("输出形状检查", args=[T(q_v), T(k_v), T(v_v)], expected=SHAPE()),
        case("梯度回传", args=[T(q_g, rg=True), T(k_g), T(v_g)], expected=GRAD(), weight=1.5),
    ]
