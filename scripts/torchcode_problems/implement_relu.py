"""实现 ReLU 激活函数（源自 TorchCode `relu`，已获授权改写）。"""

PROBLEM = {
    "slug": "implement-relu",
    "title": "实现 ReLU 激活函数",
    "difficulty": "easy",
    "category": "algorithms",
    "description": (
        "从零实现 ReLU（修正线性单元）激活函数。给定张量 x，逐元素返回 y = max(0, x)。\n\n"
        "要求：\n"
        "- 用张量运算实现（如 torch.clamp / torch.maximum），不要写 Python 逐元素循环；\n"
        "- 计算必须可微：x > 0 处梯度为 1，x < 0 处梯度为 0；\n"
        "- 输出与输入同形状、同 dtype。"
    ),
    "constraints": "1 <= x.ndim <= 4；x 为 float32 张量，|x_i| <= 100。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "relu",
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

def relu(x: torch.Tensor) -> torch.Tensor:
    # x: 任意形状的 float32 张量
    # TODO: 返回与 x 同形状的 ReLU 结果
    return x
"""

SOLUTION = """import torch

def relu(x: torch.Tensor) -> torch.Tensor:
    return torch.maximum(x, torch.zeros_like(x))
"""


def build_cases():
    import torch

    from framework import GRAD, SHAPE, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260916)

    x_basic = torch.tensor([-2.0, -1.0, 0.0, 1.0, 2.0])
    x_2d = torch.randn(3, 4, generator=g) * 2
    x_neg = torch.randn(2, 3, generator=g) - 3.0  # 全负
    x_3d = torch.randn(2, 2, 3, generator=g)
    x_grad = torch.tensor([-2.0, -0.5, 0.5, 1.0], requires_grad=True)  # 避开 0 处次梯度歧义
    x_big = torch.tensor([-100.0, -0.001, 0.001, 100.0])

    return [
        visible_example("基本正负混合", args=[T(x_basic)], expected=VALUE()),
        case("二维随机张量", args=[T(x_2d)], expected=VALUE()),
        case("全负输入归零", args=[T(x_neg)], expected=VALUE()),
        case("三维形状保持", args=[T(x_3d)], expected=SHAPE()),
        case("边界大数值", args=[T(x_big)], expected=VALUE()),
        case("梯度回传", args=[T(x_grad, rg=True)], expected=GRAD(), weight=1.5),
    ]
