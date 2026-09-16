"""Mixture of Experts 层（top-k 路由）（源自 TorchCode `moe`，已获授权改写）。"""

PROBLEM = {
    "slug": "moe-layer",
    "title": "实现 Mixture of Experts 层（top-k 路由）",
    "difficulty": "hard",
    "category": "transformer",
    "description": (
        "实现带 top-k 路由的 Mixture of Experts 前向。路由器按输入打分选出 k 个专家，"
        "输出是各选中专家的加权组合：\n\n"
        "    1. 路由打分：logits = x @ gate_weight^T，形状 (B, E)；\n"
        "    2. probs = softmax(logits, dim=-1)；按 prob 从大到小选出前 top_k 个专家"
        "（用 torch.topk，值相同的平序按索引从小到大）；\n"
        "    3. 选中专家的 prob 重新归一化：w_i = prob_i / sum(选中 prob)；\n"
        "    4. 专家 e 的输出：expert_e(x) = silu(x @ w_up[e]^T) @ w_down[e]^T，形状 (B, D)；\n"
        "    5. 输出 = Σ_i w_i * expert_{i}(x)。\n\n"
        "输入：x 为 (B, D)，top_k 为 int；输出 (B, D)。\n\n"
        "要求：\n"
        "- 类必须继承 torch.nn.Module；\n"
        "- `__init__(self, gate_weight, w_up, w_down)`，三个张量注册为同名 nn.Parameter；\n"
        "- gate_weight (E, D)；w_up (E, D, D_f)；w_down (E, D_f, D)；E 为专家数；\n"
        "- silu(x) = x * sigmoid(x)；\n"
        "- 计算必须可微（含路由权重；topk 选择本身不需要可微）。"
    ),
    "constraints": "x 为 float32 (B, D)，B <= 4，D <= 32；E ∈ {4, 8}；1 <= top_k <= E；D_f <= 64。",
    "evaluation_mode": "class",
    "entrypoint_type": "class",
    "entrypoint_name": "MoE",
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
import torch.nn as nn

class MoE(nn.Module):
    def __init__(self, gate_weight: torch.Tensor, w_up: torch.Tensor, w_down: torch.Tensor) -> None:
        # gate_weight: (E, D)；w_up: (E, D, D_f)；w_down: (E, D_f, D)
        # TODO: 注册为同名 nn.Parameter
        super().__init__()

    def forward(self, x: torch.Tensor, top_k: int) -> torch.Tensor:
        # x: (B, D)
        # TODO: 返回 (B, D)
        return x
"""

SOLUTION = """import torch
import torch.nn as nn
import torch.nn.functional as F

class MoE(nn.Module):
    def __init__(self, gate_weight: torch.Tensor, w_up: torch.Tensor, w_down: torch.Tensor) -> None:
        super().__init__()
        self.gate_weight = nn.Parameter(gate_weight)
        self.w_up = nn.Parameter(w_up)
        self.w_down = nn.Parameter(w_down)

    def forward(self, x: torch.Tensor, top_k: int) -> torch.Tensor:
        logits = x @ self.gate_weight.T
        probs = torch.softmax(logits, dim=-1)
        top_prob, top_idx = torch.topk(probs, top_k, dim=-1)
        weights = top_prob / top_prob.sum(dim=-1, keepdim=True)
        out = torch.zeros_like(x)
        for e in range(top_idx.shape[-1]):
            idx = top_idx[:, e]
            h = torch.bmm(x.unsqueeze(1), self.w_up[idx]).squeeze(1)
            expert_out = torch.bmm(F.silu(h).unsqueeze(1), self.w_down[idx]).squeeze(1)
            out = out + expert_out * weights[:, e].unsqueeze(-1)
        return out
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261004)

    E, D, DF = 4, 8, 16

    gate_v = torch.randn(E, D, generator=g)
    up_v = torch.randn(E, D, DF, generator=g) * 0.3
    down_v = torch.randn(E, DF, D, generator=g) * 0.3
    x_v = torch.randn(2, D, generator=g)

    E8, D32, DF64 = 8, 32, 64
    gate_r = torch.randn(E8, D32, generator=g)
    up_r = torch.randn(E8, D32, DF64, generator=g) * 0.3
    down_r = torch.randn(E8, DF64, D32, generator=g) * 0.3
    x_r = torch.randn(4, D32, generator=g)

    x_k1 = torch.randn(2, D, generator=g)

    gate_s = torch.randn(E, D, generator=g)
    up_s = torch.randn(E, D, DF, generator=g) * 0.3
    down_s = torch.randn(E, DF, D, generator=g) * 0.3
    x_s = torch.randn(1, D, generator=g)

    x_g = torch.randn(2, D, generator=g)

    def C(gate, up, down):
        return {"args": [T(gate), T(up), T(down)], "kwargs": {}}

    return [
        visible_example("4 专家 top-2", args=[T(x_v), 2], construct=C(gate_v, up_v, down_v), expected=VALUE()),
        case("8 专家 top-2 D=32", args=[T(x_r), 2], construct=C(gate_r, up_r, down_r), expected=VALUE(), weight=1.5),
        case("top-1 硬路由", args=[T(x_k1), 1], construct=C(gate_v, up_v, down_v), expected=VALUE()),
        case("top-4 全专家", args=[T(x_s), 4], construct=C(gate_s, up_s, down_s), expected=VALUE()),
        case("梯度回传（输入+路由+专家）", args=[T(x_g, rg=True), 2], construct=C(gate_v, up_v, down_v), expected=GRAD(), weight=2.0),
    ]
