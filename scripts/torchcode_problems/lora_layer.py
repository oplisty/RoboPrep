"""LoRA 低秩适配层（源自 TorchCode `lora`，已获授权改写）。"""

PROBLEM = {
    "slug": "lora-layer",
    "title": "实现 LoRA 低秩适配层",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "实现 LoRA（Low-Rank Adaptation）。冻结的基础权重旁路挂上一个低秩分解的更新：\n\n"
        "    y = x @ W^T + (x @ A^T @ B^T) * (alpha / r)\n\n"
        "其中 W 为 (out_features, in_features) 的基础权重（理想情况下冻结，本题仅要求参与前向），"
        "A 为 (r, in_features)，B 为 (out_features, r)，r 为秩（A.shape[0]），"
        "alpha 为缩放超参数。输出形状 (B, out_features)。\n\n"
        "要求：\n"
        "- 类必须继承 torch.nn.Module；\n"
        "- `__init__(self, base_weight, lora_A, lora_B, alpha: float)`，把三个张量注册为名为 "
        "`base_weight`、`lora_A`、`lora_B` 的 nn.Parameter（梯度检查按这三个名字进行）；\n"
        "- 秩 r 必须从 lora_A 的形状推导，缩放系数为 alpha / r；\n"
        "- 不要调用 torch.nn.Linear。"
    ),
    "constraints": "base_weight 为 (out, in) float32；lora_A 为 (r, in)，lora_B 为 (out, r)，1 <= r <= 8；x 为 (B, in) float32，B <= 16，in/out <= 64。",
    "evaluation_mode": "class",
    "entrypoint_type": "class",
    "entrypoint_name": "LoRALinear",
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
import torch.nn as nn

class LoRALinear(nn.Module):
    def __init__(self, base_weight: torch.Tensor, lora_A: torch.Tensor, lora_B: torch.Tensor, alpha: float) -> None:
        # base_weight: (out, in)；lora_A: (r, in)；lora_B: (out, r)；alpha: 缩放超参
        # TODO: 注册为名为 base_weight / lora_A / lora_B 的 nn.Parameter
        super().__init__()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # x: (B, in)
        # TODO: 返回 (B, out)
        return x
"""

SOLUTION = """import torch
import torch.nn as nn

class LoRALinear(nn.Module):
    def __init__(self, base_weight: torch.Tensor, lora_A: torch.Tensor, lora_B: torch.Tensor, alpha: float) -> None:
        super().__init__()
        self.base_weight = nn.Parameter(base_weight)
        self.lora_A = nn.Parameter(lora_A)
        self.lora_B = nn.Parameter(lora_B)
        self.alpha = alpha
        self.rank = lora_A.shape[0]

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        base = x @ self.base_weight.T
        delta = (x @ self.lora_A.T @ self.lora_B.T) * (self.alpha / self.rank)
        return base + delta
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261001)

    W_v = torch.randn(4, 6, generator=g)
    A_v = torch.randn(2, 6, generator=g) * 0.1
    B_v = torch.randn(4, 2, generator=g) * 0.1
    x_v = torch.randn(3, 6, generator=g)

    W_r = torch.randn(8, 5, generator=g)
    A_r = torch.randn(4, 5, generator=g) * 0.1
    B_r = torch.randn(8, 4, generator=g) * 0.1
    x_r = torch.randn(6, 5, generator=g)

    W_1 = torch.randn(2, 3, generator=g)
    A_1 = torch.randn(1, 3, generator=g) * 0.1
    B_1 = torch.randn(2, 1, generator=g) * 0.1
    x_1 = torch.randn(2, 3, generator=g)

    W_z = torch.randn(4, 6, generator=g)
    A_z = torch.zeros(2, 6)
    B_z = torch.randn(4, 2, generator=g) * 0.1
    x_z = torch.randn(3, 6, generator=g)

    x_g = torch.randn(3, 6, generator=g)

    def C(W, A, B, alpha):
        return {"args": [T(W), T(A), T(B), alpha], "kwargs": {}}

    return [
        visible_example("基础前向 r=2", args=[T(x_v)], construct=C(W_v, A_v, B_v, 8.0), expected=VALUE()),
        case("随机权重 r=4", args=[T(x_r)], construct=C(W_r, A_r, B_r, 16.0), expected=VALUE()),
        case("秩 1", args=[T(x_1)], construct=C(W_1, A_1, B_1, 4.0), expected=VALUE()),
        case("LoRA 分支为零", args=[T(x_z)], construct=C(W_z, A_z, B_z, 8.0), expected=VALUE()),
        case("梯度回传（输入+三参数）", args=[T(x_g, rg=True)], construct=C(W_v, A_v, B_v, 8.0), expected=GRAD(), weight=2.0),
    ]
