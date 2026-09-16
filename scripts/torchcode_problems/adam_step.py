"""手写 Adam 单步更新（源自 TorchCode `adam`，已获授权改写）。"""

PROBLEM = {
    "slug": "adam-optimizer-step",
    "title": "手写 Adam 优化器单步更新",
    "difficulty": "medium",
    "category": "robot-learning",
    "description": (
        "从零实现 Adam 优化器的一步参数更新。给定参数、梯度、一阶/二阶动量状态和超参数，"
        "执行带偏差修正的 Adam 更新，返回更新后的参数：\n\n"
        "    m' = beta1 * m + (1 - beta1) * grad\n"
        "    v' = beta2 * v + (1 - beta2) * grad ** 2\n"
        "    m_hat = m' / (1 - beta1 ** t)            # 偏差修正\n"
        "    v_hat = v' / (1 - beta2 ** t)\n"
        "    param' = param - lr * m_hat / (sqrt(v_hat) + eps)\n\n"
        "返回: 更新后的参数张量（形状与输入 param 相同）。\n\n"
        "要求：\n"
        "- 不要调用 torch.optim.Adam / torch.optim._functional；\n"
        "- 严格按上述公式顺序实现（先更新动量，再做偏差修正）；\n"
        "- 不要原地修改传入的 param/m/v 张量。"
    ),
    "constraints": "param/grad/m/v 均为同形状 float32 张量（ndim <= 3，元素数 <= 4096）；0 < lr <= 0.1；beta1, beta2 ∈ (0, 1)；eps > 0；t 为正整数（1 <= t <= 10^6）。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "adam_step",
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

def adam_step(param: torch.Tensor, grad: torch.Tensor, m: torch.Tensor, v: torch.Tensor,
              lr: float, beta1: float, beta2: float, eps: float, t: int) -> torch.Tensor:
    # param/grad/m/v: 同形状张量；t: 当前步数（从 1 开始）
    # TODO: 返回更新后的参数张量
    return param
"""

SOLUTION = """import torch

def adam_step(param: torch.Tensor, grad: torch.Tensor, m: torch.Tensor, v: torch.Tensor,
              lr: float, beta1: float, beta2: float, eps: float, t: int) -> torch.Tensor:
    m_new = beta1 * m + (1.0 - beta1) * grad
    v_new = beta2 * v + (1.0 - beta2) * grad * grad
    m_hat = m_new / (1.0 - beta1 ** t)
    v_hat = v_new / (1.0 - beta2 ** t)
    return param - lr * m_hat / (torch.sqrt(v_hat) + eps)
"""


def build_cases():
    import torch

    from framework import VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260925)

    p_v = torch.tensor([1.0, -2.0, 0.5])
    g_v = torch.tensor([0.1, -0.3, 0.0])
    m_0 = torch.zeros(3)
    v_0 = torch.zeros(3)

    p_r = torch.randn(4, 5, generator=g)
    g_r = torch.randn(4, 5, generator=g)
    m_r = torch.randn(4, 5, generator=g) * 0.1
    v_r = torch.rand(4, 5, generator=g) * 0.05

    p_l = torch.randn(2, 2, 2, generator=g)
    g_l = torch.randn(2, 2, 2, generator=g)
    m_l = torch.zeros(2, 2, 2)
    v_l = torch.zeros(2, 2, 2)

    p_z = torch.tensor([1.0, 2.0])
    g_z = torch.zeros(2)  # 零梯度：动量不变，只有 eps 防零除
    m_z = torch.tensor([0.01, -0.02])
    v_z = torch.tensor([0.0001, 0.0004])

    return [
        visible_example("首步更新 t=1", args=[T(p_v), T(g_v), T(m_0), T(v_0)], kwargs={"lr": 0.01, "beta1": 0.9, "beta2": 0.999, "eps": 1e-8, "t": 1}, expected=VALUE()),
        case("带状态的后续步 t=5", args=[T(p_r), T(g_r), T(m_r), T(v_r)], kwargs={"lr": 0.001, "beta1": 0.9, "beta2": 0.999, "eps": 1e-8, "t": 5}, expected=VALUE(), weight=1.5),
        case("长时间步 t=10000", args=[T(p_l), T(g_l), T(m_l), T(v_l)], kwargs={"lr": 0.05, "beta1": 0.9, "beta2": 0.99, "eps": 1e-8, "t": 10000}, expected=VALUE()),
        case("零梯度更新", args=[T(p_z), T(g_z), T(m_z), T(v_z)], kwargs={"lr": 0.01, "beta1": 0.9, "beta2": 0.999, "eps": 1e-8, "t": 2}, expected=VALUE()),
    ]
