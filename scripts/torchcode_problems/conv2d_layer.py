"""实现 Conv2d 前向（源自 TorchCode `conv2d`，已获授权改写）。"""

PROBLEM = {
    "slug": "conv2d-layer",
    "title": "实现 Conv2d 前向传播",
    "difficulty": "medium",
    "category": "algorithms",
    "description": (
        "从零实现二维卷积层的前向传播。实现类 `Conv2D`，构造时接收卷积核、偏置、步幅与填充，"
        "forward 对输入做 2D 互相关（cross-correlation，与 PyTorch nn.Conv2d 语义一致）：\n\n"
        "    out[b, o, i, j] = bias[o] + sum_{c,u,v} weight[o, c, u, v] * x[b, c, i*stride+u-pad, j*stride+v-pad]\n\n"
        "要求：\n"
        "- 类必须继承 torch.nn.Module；\n"
        "- `__init__(self, weight, bias, stride: int, padding: int)`，把 weight/bias 注册为"
        "名为 `weight` 和 `bias` 的 nn.Parameter（梯度检查按这两个名字进行）；\n"
        "- padding 用零填充，只支持对称填充和正方形卷积核；\n"
        "- 可以用 F.conv2d 自查，但本题练手建议手写循环或 unfold 实现（判题只看数值）；\n"
        "- 不要调用 torch.nn.Conv2d / torch.nn.functional.conv2d。"
    ),
    "constraints": "x 为 float32 (B, C_in, H, W)，H, W <= 16；weight 为 (C_out, C_in, K, K)，K ∈ {1, 3, 5}；bias 为 (C_out,)；stride ∈ {1, 2}；padding ∈ {0, 1, 2}；B, C_in, C_out <= 4。",
    "evaluation_mode": "class",
    "entrypoint_type": "class",
    "entrypoint_name": "Conv2D",
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

class Conv2D(nn.Module):
    def __init__(self, weight: torch.Tensor, bias: torch.Tensor, stride: int, padding: int) -> None:
        # weight: (C_out, C_in, K, K)；bias: (C_out,)
        # TODO: 注册为名为 weight / bias 的 nn.Parameter
        super().__init__()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # x: (B, C_in, H, W)
        # TODO: 2D 互相关 + 零填充 + 步幅
        return x
"""

SOLUTION = """import torch
import torch.nn as nn
import torch.nn.functional as F

class Conv2D(nn.Module):
    def __init__(self, weight: torch.Tensor, bias: torch.Tensor, stride: int, padding: int) -> None:
        super().__init__()
        self.weight = nn.Parameter(weight)
        self.bias = nn.Parameter(bias)
        self.stride = stride
        self.padding = padding

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return F.conv2d(x, self.weight, self.bias, stride=self.stride, padding=self.padding)
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260922)

    w_v = torch.randn(2, 1, 3, 3, generator=g)
    b_v = torch.randn(2, generator=g)
    x_v = torch.randn(1, 1, 5, 5, generator=g)

    w_1 = torch.randn(3, 2, 1, 1, generator=g)
    b_1 = torch.randn(3, generator=g)
    x_1 = torch.randn(2, 2, 4, 4, generator=g)

    w_p = torch.randn(2, 3, 3, 3, generator=g)
    b_p = torch.randn(2, generator=g)
    x_p = torch.randn(1, 3, 6, 6, generator=g)

    w_s = torch.randn(4, 2, 3, 3, generator=g)
    b_s = torch.randn(4, generator=g)
    x_s = torch.randn(2, 2, 8, 8, generator=g)

    w_k5 = torch.randn(1, 1, 5, 5, generator=g)
    b_k5 = torch.randn(1, generator=g)
    x_k5 = torch.randn(1, 1, 7, 7, generator=g)

    x_g = torch.randn(1, 1, 5, 5, generator=g)
    w_g = torch.randn(2, 1, 3, 3, generator=g)
    b_g = torch.randn(2, generator=g)

    def C(w, b, stride=1, padding=0):
        return {"args": [T(w), T(b), stride, padding], "kwargs": {}}

    return [
        visible_example("单通道 3x3 无填充", args=[T(x_v)], construct=C(w_v, b_v), expected=VALUE()),
        case("1x1 卷积", args=[T(x_1)], construct=C(w_1, b_1), expected=VALUE()),
        case("padding=1", args=[T(x_p)], construct=C(w_p, b_p, padding=1), expected=VALUE()),
        case("stride=2 下采样", args=[T(x_s)], construct=C(w_s, b_s, stride=2, padding=1), expected=VALUE()),
        case("5x5 大核", args=[T(x_k5)], construct=C(w_k5, b_k5), expected=VALUE()),
        case("梯度回传（输入+参数）", args=[T(x_g, rg=True)], construct=C(w_g, b_g, padding=1), expected=GRAD(), weight=2.0),
    ]
