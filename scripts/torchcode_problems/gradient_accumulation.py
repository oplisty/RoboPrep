"""梯度累积（源自 TorchCode `gradient_accumulation`，已获授权改写）。"""

PROBLEM = {
    "slug": "gradient-accumulation",
    "title": "实现梯度累积",
    "difficulty": "medium",
    "category": "robot-learning",
    "description": (
        "梯度累积是大批量训练的常用技巧：把 K 个微批（micro-batch）的梯度累加后取平均，"
        "再乘上损失缩放系数，等效于大批量梯度。实现：\n\n"
        "    total = ( sum_{k=1..K} micro_grads[k] / K ) * scale\n\n"
        "输入 micro_grads 为 (K, N) 张量，第 k 行是第 k 个微批的梯度向量；返回形状 (N,) 的张量。\n\n"
        "要求：\n"
        "- 先求和取均值、再乘 scale，顺序会影响数值，按上述公式实现；\n"
        "- 不要原地修改输入张量；\n"
        "- 计算必须可微（梯度检查会验证 micro_grads 上的梯度处处为 scale / K）。"
    ),
    "constraints": "micro_grads 为 float32 (K, N)，2 <= K <= 32，1 <= N <= 1024；scale 为非零 float，|scale| <= 100。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "accumulate_grads",
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

def accumulate_grads(micro_grads: torch.Tensor, scale: float) -> torch.Tensor:
    # micro_grads: (K, N)，第 k 行是第 k 个微批的梯度
    # TODO: 返回 (N,) 累积后的梯度
    return micro_grads[0]
"""

SOLUTION = """import torch

def accumulate_grads(micro_grads: torch.Tensor, scale: float) -> torch.Tensor:
    return micro_grads.sum(dim=0) * scale / micro_grads.shape[0]
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260927)

    mg_v = torch.tensor([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])

    mg_r = torch.randn(8, 16, generator=g)

    mg_neg = torch.randn(4, 8, generator=g)

    mg_eq = torch.ones(5, 3)  # 各微批梯度相同

    mg_g = torch.randn(4, 5, generator=g)

    return [
        visible_example("三个微批累积", args=[T(mg_v), 1.0], expected=VALUE()),
        case("八个随机微批", args=[T(mg_r), 2.0], expected=VALUE()),
        case("负缩放系数", args=[T(mg_neg), -0.5], expected=VALUE()),
        case("相同梯度平均", args=[T(mg_eq), 1.0], expected=VALUE()),
        case("梯度回传", args=[T(mg_g, rg=True), 4.0], expected=GRAD(), weight=1.5),
    ]
