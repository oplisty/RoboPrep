"""实现 Linear 层前向（源自 TorchCode `linear`，已获授权改写）。"""

PROBLEM = {
    "slug": "linear-layer",
    "title": "实现 Linear 层前向传播",
    "difficulty": "easy",
    "category": "algorithms",
    "description": (
        "从零实现 nn.Linear 的前向传播。实现一个类 `MyLinear`，构造时接收权重和偏置张量，"
        "forward 接收输入张量 x，计算：\n\n"
        "    y = x @ weight.T + bias，输出形状 (B, out_features)\n\n"
        "要求：\n"
        "- 类必须继承 torch.nn.Module；\n"
        "- `__init__(self, weight: torch.Tensor, bias: torch.Tensor)`，并把它们注册为"
        "名为 `weight` 和 `bias` 的 nn.Parameter（梯度检查按这两个名字进行）；\n"
        "- 不要在构造函数内随机初始化任何参数（权重由外部注入）；\n"
        "- 不要调用 torch.nn.Linear / torch.nn.functional.linear。"
    ),
    "constraints": "weight 为 (out_features, in_features) float32，bias 为 (out_features,) float32；x 为 (B, in_features) float32，1 <= B <= 16，1 <= in/out_features <= 128。",
    "evaluation_mode": "class",
    "entrypoint_type": "class",
    "entrypoint_name": "MyLinear",
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

class MyLinear(nn.Module):
    def __init__(self, weight: torch.Tensor, bias: torch.Tensor) -> None:
        # weight: (out_features, in_features)；bias: (out_features,)
        # TODO: 注册为名为 weight / bias 的 nn.Parameter
        super().__init__()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # x: (B, in_features)
        # TODO: 返回 (B, out_features)
        return x
"""

SOLUTION = """import torch
import torch.nn as nn

class MyLinear(nn.Module):
    def __init__(self, weight: torch.Tensor, bias: torch.Tensor) -> None:
        super().__init__()
        self.weight = nn.Parameter(weight)
        self.bias = nn.Parameter(bias)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return x @ self.weight.T + self.bias
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260920)

    w_v = torch.randn(3, 4, generator=g)
    b_v = torch.randn(3, generator=g)
    x_v = torch.randn(2, 4, generator=g)

    w_r = torch.randn(8, 5, generator=g)
    b_r = torch.randn(8, generator=g)
    x_r = torch.randn(6, 5, generator=g)

    w_1 = torch.randn(1, 1, generator=g)
    b_1 = torch.randn(1, generator=g)
    x_1 = torch.randn(1, 1, generator=g)

    w_b = torch.randn(4, 16, generator=g)
    b_b = torch.randn(4, generator=g)
    x_b = torch.randn(3, 16, generator=g)

    x_g = torch.randn(2, 4, generator=g)
    w_g = torch.randn(3, 4, generator=g)
    b_g = torch.randn(3, generator=g)

    def C(w, b):
        return {"args": [T(w), T(b)], "kwargs": {}}

    return [
        visible_example("基础前向", args=[T(x_v)], construct=C(w_v, b_v), expected=VALUE()),
        case("随机批量", args=[T(x_r)], construct=C(w_r, b_r), expected=VALUE()),
        case("单维输入", args=[T(x_1)], construct=C(w_1, b_1), expected=VALUE()),
        case("宽输入高维", args=[T(x_b)], construct=C(w_b, b_b), expected=VALUE()),
        case("梯度回传（输入+参数）", args=[T(x_g, rg=True)], construct=C(w_g, b_g), expected=GRAD(), weight=2.0),
    ]
