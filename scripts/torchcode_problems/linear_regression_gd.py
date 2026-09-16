"""线性回归：全批量梯度下降（源自 TorchCode `linear_regression`，已获授权改写）。"""

PROBLEM = {
    "slug": "linear-regression-gd",
    "title": "线性回归：手写梯度下降",
    "difficulty": "easy",
    "category": "algorithms",
    "description": (
        "不调用任何优化器，从零实现线性回归的全批量梯度下降训练。给定数据 X, y 和学习率 lr，"
        "从零初始化参数出发，执行 `steps` 步梯度下降，返回训练得到的 (w, b)：\n\n"
        "    初始化: w = zeros(D), b = 0.0\n"
        "    损失:   L = mean((X @ w + b - y) ** 2)          # MSE，对全部样本取均值\n"
        "    每步:   w -= lr * dL/dw ； b -= lr * dL/db\n\n"
        "返回: 元组 (w, b)，其中 w 为形状 (D,) 的 float32 张量，b 为 Python float。\n\n"
        "要求：\n"
        "- 严格按上述初始化和更新顺序实现（先更新 w 再更新 b，或两者用同一步的梯度，"
        "注意不要用更新后的 w 重新计算 dL/db）；\n"
        "- 不要调用 torch.optim 中的任何优化器；\n"
        "- 判题按 allclose 比较每一步收敛后的参数值。"
    ),
    "constraints": "X 为 float32 (N, D)，2 <= N <= 64，1 <= D <= 8；y 为 float32 (N,)；0.001 <= lr <= 0.5；0 <= steps <= 500。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "linear_regression",
    "framework": "pytorch",
    "resource_profile": "ml_cpu_small",
    "evaluator_config": {
        "comparison": "allclose",
        "rtol": 0.0001,
        "atol": 0.00001,
        "check_shape": True,
        "check_dtype": False,
        "check_gradient": False,
    },
}

STARTER = """import torch

def linear_regression(X: torch.Tensor, y: torch.Tensor, lr: float, steps: int):
    # X: (N, D)；y: (N,)；训练 steps 步全批量梯度下降
    # TODO: 返回 (w, b)，w 为 (D,) 张量，b 为 float
    return torch.zeros(X.shape[1]), 0.0
"""

SOLUTION = """import torch

def linear_regression(X: torch.Tensor, y: torch.Tensor, lr: float, steps: int):
    w = torch.zeros(X.shape[1], dtype=torch.float32)
    b = 0.0
    n = X.shape[0]
    for _ in range(steps):
        err = X @ w + b - y
        gw = 2.0 * (X.T @ err) / n
        gb = 2.0 * err.sum().item() / n
        w = w - lr * gw
        b = b - lr * gb
    return w, float(b)
"""


def build_cases():
    import torch

    from framework import VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260924)

    # 精确线性数据（有唯一解）
    X_v = torch.tensor([[1.0, 0.0], [0.0, 1.0], [1.0, 1.0], [2.0, 1.0]])
    y_v = torch.tensor([1.0, 2.0, 4.0, 6.0])  # w≈[2,2), b≈0 附近

    X_r = torch.randn(20, 3, generator=g)
    w_true = torch.tensor([1.5, -2.0, 0.5])
    y_r = X_r @ w_true + 0.7 + torch.randn(20, generator=g) * 0.1

    X_1 = torch.randn(16, 1, generator=g)
    y_1 = 3.0 * X_1.squeeze(1) - 1.0

    X_s = torch.randn(8, 2, generator=g)
    y_s = X_s @ torch.tensor([1.0, 1.0])

    X_0 = torch.randn(5, 2, generator=g)
    y_0 = torch.randn(5, generator=g)

    return [
        visible_example("小数据集 50 步", args=[T(X_v), T(y_v), 0.1, 50], expected=VALUE()),
        case("三维带噪数据", args=[T(X_r), T(y_r), 0.05, 200], expected=VALUE(), weight=1.5),
        case("一元回归 100 步", args=[T(X_1), T(y_1), 0.1, 100], expected=VALUE()),
        case("小学习率欠收敛", args=[T(X_s), T(y_s), 0.01, 10], expected=VALUE()),
        case("零步返回初始值", args=[T(X_0), T(y_0), 0.1, 0], expected=VALUE()),
    ]
