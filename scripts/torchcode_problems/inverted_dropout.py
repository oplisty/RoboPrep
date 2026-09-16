"""实现 inverted dropout（确定性改版：mask 由外部传入）（源自 TorchCode `dropout`，已获授权改写）。"""

PROBLEM = {
    "slug": "inverted-dropout",
    "title": "实现 Inverted Dropout（给定 mask）",
    "difficulty": "easy",
    "category": "algorithms",
    "description": (
        "实现 inverted dropout 的核心缩放逻辑。真实 dropout 会随机采样 mask；为保证判题确定性，"
        "本题把 0/1 掩码直接传入，你只需实现缩放：\n\n"
        "    y = x * mask / (1 - p)\n\n"
        "其中保留的元素（mask=1）被放大 1/(1-p) 倍，被丢弃的元素（mask=0）归零。"
        "这是 inverted dropout 在训练时保持期望值不变的关键。\n\n"
        "要求：\n"
        "- 用张量运算实现，不要写 Python 逐元素循环；\n"
        "- 当 p == 0 时必须等价于恒等映射（此时 mask 全 1）；\n"
        "- 当 p >= 1 或 p < 0 时抛出 ValueError（异常用例会检查）；\n"
        "- 计算必须可微（梯度检查会验证 x 上的梯度为 mask / (1 - p)）。"
    ),
    "constraints": "x 为 float32 张量，|x_i| <= 100；mask 为与 x 同形状的 float32 张量，元素只能是 0.0 或 1.0；0 <= p < 1。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "dropout",
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

def dropout(x: torch.Tensor, mask: torch.Tensor, p: float) -> torch.Tensor:
    # x: 任意形状 float32；mask: 同形状 0/1 掩码；p: 丢弃概率
    # TODO: inverted dropout 缩放，p 非法时抛 ValueError
    return x
"""

SOLUTION = """import torch

def dropout(x: torch.Tensor, mask: torch.Tensor, p: float) -> torch.Tensor:
    if p < 0 or p >= 1:
        raise ValueError("p 必须在 [0, 1) 区间内")
    return x * mask / (1.0 - p)
"""


def build_cases():
    import torch

    from framework import EXC, GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260923)

    x_v = torch.tensor([1.0, 2.0, 3.0, 4.0])
    mask_v = torch.tensor([1.0, 0.0, 1.0, 0.0])

    x_r = torch.randn(3, 4, generator=g)
    mask_r = (torch.rand(3, 4, generator=g) > 0.5).float()

    x_p0 = torch.randn(2, 3, generator=g)
    mask_p0 = torch.ones(2, 3)

    mask_all0 = torch.zeros(2, 3)
    x_a = torch.randn(2, 3, generator=g)

    x_e = torch.tensor([0.5, -1.5])
    mask_e = torch.tensor([0.0, 1.0])

    x_g = torch.randn(4, generator=g)
    mask_g = torch.tensor([1.0, 0.0, 1.0, 1.0])

    return [
        visible_example("基础 50% 丢弃", args=[T(x_v), T(mask_v), 0.5], expected=VALUE()),
        case("随机掩码", args=[T(x_r), T(mask_r), 0.4], expected=VALUE()),
        case("p=0 恒等", args=[T(x_p0), T(mask_p0), 0.0], expected=VALUE()),
        case("掩码全零", args=[T(x_a), T(mask_all0), 0.25], expected=VALUE()),
        case("非法 p 抛异常", args=[T(x_e), T(mask_e), 1.0], expected=EXC("ValueError")),
        case("梯度回传", args=[T(x_g, rg=True), T(mask_g), 0.25], expected=GRAD(), weight=1.5),
    ]
