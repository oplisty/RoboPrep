"""Top-p (nucleus) 过滤（源自 TorchCode `topk_sampling` 的 top-p 部分，已获授权改写）。"""

PROBLEM = {
    "slug": "top-p-filter",
    "title": "实现 Top-p（Nucleus）采样过滤",
    "difficulty": "easy",
    "category": "transformer",
    "description": (
        "实现 top-p（nucleus）采样的过滤步骤。给定归一化的概率分布和阈值 p，"
        "保留累计概率达到 p 的最小前缀（按概率从大到小），其余置零后重新归一化：\n\n"
        "    1. 按概率从大到小排序，计算累计和 cumsum；\n"
        "    2. 找到第一个使 cumsum >= p 的位置 k（0-based）；\n"
        "    3. 保留排序后的前 k+1 个 token（其余概率置 0，注意保留它们**原位置**的概率值）；\n"
        "    4. 返回过滤后除以剩余概率总和（重新归一化到 1）。\n\n"
        "输入：probs 为 (V,) float32 且求和为 1；p ∈ (0, 1]。输出 (V,) float32，求和为 1。\n\n"
        "要求：\n"
        "- 不要调用 torch.multinomial 等采样函数（本题只做过滤，不做采样）；\n"
        "- p = 1 时输出必须与输入完全一致；\n"
        "- 被保留的 token 的**相对比例**不能改变（只做整体缩放）；\n"
        "- 计算必须可微。"
    ),
    "constraints": "probs 为 (V,) float32，8 <= V <= 1000，sum(probs) = 1，每个元素 > 0；0 < p <= 1。测试输入保证排序无并列。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "top_p_filter",
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

def top_p_filter(probs: torch.Tensor, p: float) -> torch.Tensor:
    # probs: (V,) 概率分布，和为 1；p: 阈值
    # TODO: 返回过滤并重新归一化的 (V,) 张量
    return probs
"""

SOLUTION = """import torch

def top_p_filter(probs: torch.Tensor, p: float) -> torch.Tensor:
    sorted_probs, sorted_idx = torch.sort(probs, descending=True)
    cumsum = torch.cumsum(sorted_probs, dim=-1)
    num_keep = int((cumsum < p).sum().item()) + 1
    num_keep = min(num_keep, probs.shape[-1])
    mask = torch.zeros_like(probs, dtype=torch.bool)
    mask[sorted_idx[:num_keep]] = True
    filtered = torch.where(mask, probs, torch.zeros_like(probs))
    return filtered / filtered.sum()
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261006)

    logits_v = torch.randn(10, generator=g)
    probs_v = torch.softmax(logits_v, dim=-1)

    logits_peak = torch.tensor([6.0, 5.5, 1.0, 0.5, 0.1, 0.1, 0.1, 0.1])
    probs_peak = torch.softmax(logits_peak, dim=-1)  # 前两个 token 占绝大部分

    probs_unif = torch.full((16,), 1.0 / 16.0)

    logits_one = torch.tensor([8.0, 0.1, 0.2, 0.3, 0.0, 0.4])
    probs_one = torch.softmax(logits_one, dim=-1)

    logits_l = torch.randn(256, generator=g)
    probs_l = torch.softmax(logits_l, dim=-1)

    return [
        visible_example("随机分布 p=0.8", args=[T(probs_v), 0.8], expected=VALUE()),
        case("尖峰分布 p=0.9", args=[T(probs_peak), 0.9], expected=VALUE()),
        case("均匀分布 p=0.5", args=[T(probs_unif), 0.5], expected=VALUE()),
        case("单峰分布 p=0.5 只留一个", args=[T(probs_one), 0.5], expected=VALUE()),
        case("p=1 保持原分布", args=[T(probs_v), 1.0], expected=VALUE(), weight=1.5),
        case("长分布 p=0.6", args=[T(probs_l), 0.6], expected=VALUE()),
        case("梯度回传", args=[T(probs_v, rg=True), 0.9], expected=GRAD(), weight=1.5),
    ]
