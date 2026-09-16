"""实现数值稳定的交叉熵损失（源自 TorchCode `cross_entropy`，已获授权改写）。"""

PROBLEM = {
    "slug": "cross-entropy-loss",
    "title": "实现数值稳定的交叉熵损失",
    "difficulty": "medium",
    "category": "algorithms",
    "description": (
        "从零实现多分类交叉熵损失（mean reduction）。给定未归一化的 logits 和整数类别标签，返回标量损失：\n\n"
        "    loss = mean_i( logsumexp(logits[i]) - logits[i, targets[i]] )\n\n"
        "要求：\n"
        "- 实现必须数值稳定：输入 logits 含 ±1000 量级的极端值时不能产生 inf/NaN"
        "（提示：减去每行最大值再做 log-sum-exp）；\n"
        "- 不要直接调用 torch.nn.functional.cross_entropy / torch.nn.CrossEntropyLoss；\n"
        "- 计算必须可微（对 logits 的梯度应为 softmax(labels) - onehot(targets) 的批均值）；\n"
        "- 返回形状为标量张量（torch.shape 为 []）。"
    ),
    "constraints": "logits 为 float32 张量 (B, V)，2 <= B <= 8，2 <= V <= 64；targets 为 int64 张量 (B,)，0 <= targets[i] < V；|logits| <= 1000。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "cross_entropy",
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

def cross_entropy(logits: torch.Tensor, targets: torch.Tensor) -> torch.Tensor:
    # logits: (B, V) float32，未归一化
    # targets: (B,) int64，类别索引
    # TODO: 返回标量损失（mean reduction），要求数值稳定
    return (logits + targets.float().sum()).sum() * 0.0
"""

SOLUTION = """import torch

def cross_entropy(logits: torch.Tensor, targets: torch.Tensor) -> torch.Tensor:
    lse = torch.logsumexp(logits, dim=-1)
    picked = logits.gather(1, targets.unsqueeze(1)).squeeze(1)
    return (lse - picked).mean()
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, TI, case, visible_example

    g = torch.Generator().manual_seed(20260918)

    logits_v = torch.tensor([[1.0, 2.0, 3.0], [0.5, -0.5, 0.0]])
    targets_v = torch.tensor([2, 0], dtype=torch.int64)

    logits_r = torch.randn(4, 5, generator=g)
    targets_r = torch.randint(0, 5, (4,), generator=g, dtype=torch.int64)

    logits_u = torch.zeros(3, 4)  # 均匀分布
    targets_u = torch.tensor([0, 1, 3], dtype=torch.int64)

    logits_big = torch.randn(4, 6, generator=g) * 0.1
    logits_big[0, 0] += 1000.0
    logits_big[1, 3] -= 1000.0
    targets_big = torch.randint(0, 6, (4,), generator=g, dtype=torch.int64)

    logits_g = torch.randn(3, 4, generator=g)
    targets_g = torch.randint(0, 4, (3,), generator=g, dtype=torch.int64)

    return [
        visible_example("小批量基础用例", args=[T(logits_v), TI(targets_v)], expected=VALUE()),
        case("随机批量", args=[T(logits_r), TI(targets_r)], expected=VALUE()),
        case("均匀 logits", args=[T(logits_u), TI(targets_u)], expected=VALUE()),
        case("极端大数值稳定性", args=[T(logits_big), TI(targets_big)], expected=VALUE(), weight=1.5),
        case("梯度回传", args=[T(logits_g, rg=True), TI(targets_g)], expected=GRAD(), weight=1.5),
    ]
