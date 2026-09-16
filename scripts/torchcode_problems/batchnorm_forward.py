"""实现 BatchNorm 前向（训练模式批统计）（源自 TorchCode `batchnorm`，已获授权改写）。"""

PROBLEM = {
    "slug": "batchnorm-forward",
    "title": "实现 BatchNorm 前向传播（训练模式）",
    "difficulty": "medium",
    "category": "algorithms",
    "description": (
        "从零实现批归一化（Batch Normalization）训练模式的前向传播。实现类 `BatchNorm`，"
        "构造时接收缩放/平移参数与 eps，forward 对输入的**批维度（dim 0）**做归一化：\n\n"
        "    mean = x.mean(dim=0)\n"
        "    var  = x.var(dim=0, unbiased=False)   # 有偏方差（除以 N，不是 N-1）\n"
        "    y = (x - mean) / sqrt(var + eps) * gamma + beta\n\n"
        "要求：\n"
        "- 类必须继承 torch.nn.Module；\n"
        "- `__init__(self, gamma: torch.Tensor, beta: torch.Tensor, eps: float)`，把 gamma/beta"
        "注册为名为 `gamma` 和 `beta` 的 nn.Parameter（梯度检查按这两个名字进行）；\n"
        "- gamma/beta 形状为 (C,)，x 形状为 (N, C)，统计量按批维度逐特征计算；\n"
        "- 不要调用 torch.nn.BatchNorm1d 等现成模块；不要维护 running stats。"
    ),
    "constraints": "x 为 float32 (N, C)，2 <= N <= 32，1 <= C <= 64；gamma/beta 为 (C,) float32；eps > 0 且通常为 1e-5。",
    "evaluation_mode": "class",
    "entrypoint_type": "class",
    "entrypoint_name": "BatchNorm",
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

class BatchNorm(nn.Module):
    def __init__(self, gamma: torch.Tensor, beta: torch.Tensor, eps: float) -> None:
        # gamma/beta: (C,)；eps: 数值稳定项
        # TODO: 注册为名为 gamma / beta 的 nn.Parameter
        super().__init__()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # x: (N, C) float32，按批维度 dim=0 归一化
        # TODO: 返回与 x 同形状的张量
        return x
"""

SOLUTION = """import torch
import torch.nn as nn

class BatchNorm(nn.Module):
    def __init__(self, gamma: torch.Tensor, beta: torch.Tensor, eps: float) -> None:
        super().__init__()
        self.gamma = nn.Parameter(gamma)
        self.beta = nn.Parameter(beta)
        self.eps = eps

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        mean = x.mean(dim=0)
        var = x.var(dim=0, unbiased=False)
        x_hat = (x - mean) / torch.sqrt(var + self.eps)
        return x_hat * self.gamma + self.beta
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260921)

    C = 4
    gamma_1 = torch.ones(C)
    beta_0 = torch.zeros(C)
    eps = 1e-5

    x_v = torch.randn(6, C, generator=g) * 3 + 1.5

    gamma_r = torch.rand(8, generator=g) + 0.5
    beta_r = torch.randn(8, generator=g)
    x_r = torch.randn(10, 8, generator=g) * 2

    x_same = torch.randn(4, 3, generator=g)
    x_same[1] = x_same[0]  # 一批里两行相同
    gamma_s = torch.rand(3, generator=g) + 0.5
    beta_s = torch.randn(3, generator=g)

    x_two = torch.randn(2, 2, generator=g)
    gamma_2 = torch.rand(2, generator=g) + 0.5
    beta_2 = torch.randn(2, generator=g)

    x_g = torch.randn(5, C, generator=g)
    gamma_g = torch.rand(C, generator=g) + 0.5

    def C_(gamma, beta):
        return {"args": [T(gamma), T(beta), eps], "kwargs": {}}

    return [
        visible_example("单位缩放基础用例", args=[T(x_v)], construct=C_(gamma_1, beta_0), expected=VALUE()),
        case("随机缩放平移", args=[T(x_r)], construct=C_(gamma_r, beta_r), expected=VALUE()),
        case("批内重复样本", args=[T(x_same)], construct=C_(gamma_s, beta_s), expected=VALUE()),
        case("最小批量 N=2", args=[T(x_two)], construct=C_(gamma_2, beta_2), expected=VALUE()),
        case("梯度回传（输入+参数）", args=[T(x_g, rg=True)], construct=C_(gamma_g, beta_0), expected=GRAD(), weight=2.0),
    ]
