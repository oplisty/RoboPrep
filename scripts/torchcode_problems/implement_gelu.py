"""实现 GELU 激活函数（源自 TorchCode `gelu`，已获授权改写）。"""

PROBLEM = {
    "slug": "implement-gelu",
    "title": "实现 GELU 激活函数",
    "difficulty": "easy",
    "category": "algorithms",
    "description": (
        "从零实现 GELU（Gaussian Error Linear Unit）激活函数的**精确 erf 版本**（GPT-2 论文公式）：\n\n"
        "    gelu(x) = 0.5 * x * (1 + erf(x / sqrt(2)))\n\n"
        "要求：\n"
        "- 用 torch.erf（或等价张量运算）实现，不要写 Python 逐元素循环；\n"
        "- 不要用 tanh 近似版本，本题按精确公式判题（近似版本误差约 1e-3，会判错）；\n"
        "- 计算必须可微，输出与输入同形状。"
    ),
    "constraints": "1 <= x.ndim <= 4；x 为 float32 张量，|x_i| <= 50。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "gelu",
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

def gelu(x: torch.Tensor) -> torch.Tensor:
    # x: 任意形状的 float32 张量
    # TODO: 精确 erf 版本 GELU，返回与 x 同形状的张量
    return x
"""

SOLUTION = """import math

import torch

def gelu(x: torch.Tensor) -> torch.Tensor:
    return 0.5 * x * (1.0 + torch.erf(x / math.sqrt(2.0)))
"""


def build_cases():
    import torch

    from framework import GRAD, SHAPE, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260917)

    x_basic = torch.tensor([0.0, 1.0, -1.0, 0.5, -0.5])
    x_2d = torch.randn(3, 4, generator=g)
    x_pos = torch.rand(2, 3, generator=g) + 0.5  # 全正
    x_neg = torch.randn(2, 3, generator=g) - 4.0  # 深度负区
    x_3d = torch.randn(2, 2, 3, generator=g)
    x_grad = torch.tensor([-1.2, -0.3, 0.4, 1.5], requires_grad=True)

    return [
        visible_example("基本对称取值", args=[T(x_basic)], expected=VALUE()),
        case("二维随机张量", args=[T(x_2d)], expected=VALUE()),
        case("全正输入", args=[T(x_pos)], expected=VALUE()),
        case("深度负区接近零", args=[T(x_neg)], expected=VALUE()),
        case("三维形状保持", args=[T(x_3d)], expected=SHAPE()),
        case("梯度回传", args=[T(x_grad, rg=True)], expected=GRAD(), weight=1.5),
    ]
