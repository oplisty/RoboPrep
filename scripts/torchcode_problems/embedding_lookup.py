"""实现 Embedding 查表（源自 TorchCode `embedding`，已获授权改写）。"""

PROBLEM = {
    "slug": "embedding-lookup",
    "title": "实现 Embedding 查表",
    "difficulty": "easy",
    "category": "algorithms",
    "description": (
        "从零实现词嵌入查表。给定词元索引序列和嵌入矩阵，返回每个索引对应的嵌入向量：\n\n"
        "    out[s] = weight[indices[s]]，输出形状 (S, D)\n\n"
        "要求：\n"
        "- 不要调用 torch.nn.Embedding / torch.nn.functional.embedding；\n"
        "- 查表必须对嵌入矩阵可微（weight 设置 requires_grad 后，损失对 weight 的梯度"
        "按索引出现次数累加）；\n"
        "- 不要修改 weight 本身。"
    ),
    "constraints": "weight 为 float32 张量 (V, D)，2 <= V <= 1000，1 <= D <= 256；indices 为 int64 张量 (S,)，每个元素满足 0 <= idx < V。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "embedding",
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

def embedding(indices: torch.Tensor, weight: torch.Tensor) -> torch.Tensor:
    # indices: (S,) int64 词元索引
    # weight: (V, D) float32 嵌入矩阵
    # TODO: 返回 (S, D) 的嵌入向量
    return weight
"""

SOLUTION = """import torch

def embedding(indices: torch.Tensor, weight: torch.Tensor) -> torch.Tensor:
    return weight.index_select(0, indices)
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, TI, case, visible_example

    g = torch.Generator().manual_seed(20260919)

    weight_v = torch.tensor([[0.1, 0.2, 0.3], [0.4, 0.5, 0.6], [0.7, 0.8, 0.9]])
    idx_v = torch.tensor([1, 0, 2, 1], dtype=torch.int64)

    weight_r = torch.randn(10, 6, generator=g)
    idx_r = torch.randint(0, 10, (12,), generator=g, dtype=torch.int64)

    weight_s = torch.randn(5, 4, generator=g)
    idx_s = torch.zeros(6, dtype=torch.int64)  # 重复同一索引

    weight_b = torch.randn(8, 5, generator=g)
    idx_b = torch.tensor([0, 7], dtype=torch.int64)  # 边界索引

    weight_g = torch.randn(6, 3, generator=g)
    idx_g = torch.tensor([2, 2, 5, 0, 2], dtype=torch.int64)  # 索引 2 出现 3 次

    return [
        visible_example("基础查表", args=[TI(idx_v), T(weight_v)], expected=VALUE()),
        case("随机查表", args=[TI(idx_r), T(weight_r)], expected=VALUE()),
        case("重复索引", args=[TI(idx_s), T(weight_s)], expected=VALUE()),
        case("边界索引", args=[TI(idx_b), T(weight_b)], expected=VALUE()),
        case("梯度按出现次数累加", args=[TI(idx_g), T(weight_g, rg=True)], expected=GRAD(), weight=1.5),
    ]
