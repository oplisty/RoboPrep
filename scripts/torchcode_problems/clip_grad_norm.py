"""全局范数梯度裁剪（源自 TorchCode `gradient_clipping`，已获授权改写）。"""

PROBLEM = {
    "slug": "clip-grad-norm",
    "title": "实现全局范数梯度裁剪",
    "difficulty": "easy",
    "category": "robot-learning",
    "description": (
        "实现 PyTorch `clip_grad_norm_` 的核心逻辑。把多个张量视为一组梯度，计算它们的"
        "全局 L2 范数，超出 max_norm 时整体等比缩放：\n\n"
        "    total_norm = sqrt( sum_i ||g_i||_2^2 )            # 所有元素平方和的平方根\n"
        "    if total_norm > max_norm:\n"
        "        clip_coef = max_norm / (total_norm + 1e-6)\n"
        "        g_i' = g_i * clip_coef\n"
        "    else: 不缩放\n\n"
        "返回: 元组 (clipped, total_norm)，其中 clipped 是与输入同形状列表对应的堆叠张量，"
        "total_norm 是 Python float。\n\n"
        "为便于声明式判题，本题把「一组形状相同的梯度」表示为一个 (K, N) 张量："
        "第 i 行是第 i 个梯度向量；返回值 clipped 形状与输入相同。\n\n"
        "要求：\n"
        "- 不要调用 torch.nn.utils.clip_grad_norm_ / torch.nn.utils；\n"
        "- 不超阈值时必须原样返回（注意 clip_coef 分母里的 1e-6 只在裁剪时使用）。"
    ),
    "constraints": "grads 为 float32 (K, N) 张量，1 <= K <= 16，1 <= N <= 1024；max_norm > 0。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "clip_grad_norm",
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

def clip_grad_norm(grads: torch.Tensor, max_norm: float):
    # grads: (K, N) float32，每行是一个梯度向量
    # TODO: 返回 (clipped, total_norm)
    return grads, 0.0
"""

SOLUTION = """import torch

def clip_grad_norm(grads: torch.Tensor, max_norm: float):
    total_norm = torch.linalg.vector_norm(grads).item()
    if total_norm > max_norm:
        clip_coef = max_norm / (total_norm + 1e-6)
        return grads * clip_coef, float(total_norm)
    return grads, float(total_norm)
"""


def build_cases():
    import torch

    from framework import VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20260926)

    g_v = torch.tensor([[3.0, 4.0], [0.0, 0.0]])  # total_norm = 5

    g_r = torch.randn(4, 8, generator=g) * 3

    g_s = torch.randn(3, 5, generator=g) * 0.01  # 范数远小于阈值

    g_z = torch.zeros(2, 4)  # 零梯度

    g_b = torch.randn(2, 16, generator=g)  # 边界附近阈值

    tn_b = float(torch.linalg.vector_norm(g_b))

    return [
        visible_example("超阈值裁剪", args=[T(g_v), 1.0], expected=VALUE()),
        case("随机张量大幅裁剪", args=[T(g_r), 0.5], expected=VALUE(), weight=1.5),
        case("不超阈值原样返回", args=[T(g_s), 10.0], expected=VALUE()),
        case("零梯度", args=[T(g_z), 1.0], expected=VALUE()),
        case("阈值取在范数附近", args=[T(g_b), round(tn_b, 3)], expected=VALUE()),
    ]
