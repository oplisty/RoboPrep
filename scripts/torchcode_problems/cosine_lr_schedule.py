"""Cosine 学习率调度（带 warmup）（源自 TorchCode `cosine_lr`，已获授权改写）。"""

PROBLEM = {
    "slug": "cosine-lr-schedule",
    "title": "实现 Cosine 学习率调度",
    "difficulty": "easy",
    "category": "robot-learning",
    "description": (
        "实现带线性 warmup 的 cosine 学习率调度器，返回第 `step` 步的学习率（Python float）：\n\n"
        "    if step < warmup_steps:\n"
        "        lr = base_lr * (step + 1) / warmup_steps          # 线性升温\n"
        "    else:\n"
        "        progress = (step - warmup_steps) / (total_steps - warmup_steps)\n"
        "        progress = min(progress, 1.0)\n"
        "        lr = min_lr + 0.5 * (base_lr - min_lr) * (1 + cos(pi * progress))\n\n"
        "要求：\n"
        "- 严格按上述公式实现（warmup 从 (step+1)/warmup_steps 开始，第一步就能拿到非零学习率）；\n"
        "- step 超过 total_steps 时 progress 截断为 1.0，lr 恒为 min_lr；\n"
        "- 不要调用 transformers / torch.optim.lr_scheduler 等现成调度器。"
    ),
    "constraints": "0 <= warmup_steps < total_steps <= 100000；0 <= step <= 10^7；0 < min_lr <= base_lr <= 1。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "cosine_lr",
    "framework": "python",
    "resource_profile": "standard_python",
    "evaluator_config": {
        "comparison": "allclose",
        "rtol": 0.0001,
        "atol": 0.00001,
        "check_shape": False,
        "check_dtype": False,
        "check_gradient": False,
    },
}

STARTER = """import math

def cosine_lr(step: int, total_steps: int, warmup_steps: int, base_lr: float, min_lr: float) -> float:
    # TODO: 按公式返回第 step 步的学习率
    return base_lr
"""

SOLUTION = """import math

def cosine_lr(step: int, total_steps: int, warmup_steps: int, base_lr: float, min_lr: float) -> float:
    if step < warmup_steps:
        return base_lr * (step + 1) / warmup_steps
    progress = (step - warmup_steps) / (total_steps - warmup_steps)
    progress = min(progress, 1.0)
    return min_lr + 0.5 * (base_lr - min_lr) * (1.0 + math.cos(math.pi * progress))
"""


def build_cases():
    from framework import VALUE, case, visible_example

    kw = {"total_steps": 1000, "warmup_steps": 100, "base_lr": 0.1, "min_lr": 0.001}
    kw_no_warm = {"total_steps": 100, "warmup_steps": 0, "base_lr": 0.2, "min_lr": 0.01}

    return [
        visible_example("warmup 首步", args=[0], kwargs=kw, expected=VALUE()),
        case("warmup 中段", args=[49], kwargs=kw, expected=VALUE()),
        case("衰减起点", args=[100], kwargs=kw, expected=VALUE()),
        case("衰减中点", args=[550], kwargs=kw, expected=VALUE()),
        case("衰减终点", args=[999], kwargs=kw, expected=VALUE()),
        case("超出总步数", args=[5000], kwargs=kw, expected=VALUE()),
        case("无 warmup", args=[50], kwargs=kw_no_warm, expected=VALUE()),
    ]
