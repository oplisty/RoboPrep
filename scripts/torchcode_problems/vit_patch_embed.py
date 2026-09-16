"""ViT patch embedding（源自 TorchCode `vit_patch`，已获授权改写）。"""

PROBLEM = {
    "slug": "vit-patch-embed",
    "title": "实现 ViT 图像分块嵌入",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "实现 Vision Transformer 的第一步：把图像切成 patch 并线性投影到模型维度。\n\n"
        "    1. 图像 img (B, C, H, W) 按步长 P=patch_size 切成不重叠的 patch，共 "
        "N = (H//P) * (W//P) 个；\n"
        "    2. patch (行 i, 列 j) 的索引为 i * (W//P) + j（行优先），每个 patch 按 "
        "(C, P, P) 展平为长度 C*P*P 的向量；\n"
        "    3. 投影：y = patches @ proj_weight^T，输出 (B, N, D)。\n\n"
        "输入：img 为 (B, C, H, W)，proj_weight 为 (D, C*P*P)，patch_size 为 int。\n\n"
        "要求：\n"
        "- 不要调用 torch.nn.Conv2d（等价实现是 kernel=stride=P 的卷积，但请用 reshape/unfold+矩阵乘）；\n"
        "- patch 的展平顺序必须严格按上述约定（这是判题关键）；\n"
        "- 计算必须可微（梯度检查会验证 img 上的梯度）。"
    ),
    "constraints": "img 为 float32 (B, C, H, W)，B <= 2，C ∈ {1, 3}，H, W <= 32 且能被 P 整除；P ∈ {2, 4, 7, 8}；proj_weight 为 (D, C*P*P) float32，D <= 64。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "patch_embed",
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

def patch_embed(img: torch.Tensor, proj_weight: torch.Tensor, patch_size: int) -> torch.Tensor:
    # img: (B, C, H, W)；proj_weight: (D, C*P*P)；patch_size: P
    # TODO: 返回 (B, N, D)
    return img
"""

SOLUTION = """import torch
import torch.nn.functional as F

def patch_embed(img: torch.Tensor, proj_weight: torch.Tensor, patch_size: int) -> torch.Tensor:
    patches = F.unfold(img, kernel_size=patch_size, stride=patch_size)
    patches = patches.transpose(1, 2)
    return patches @ proj_weight.T
"""


def build_cases():
    import torch

    from framework import GRAD, SHAPE, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261002)

    img_v = torch.arange(16, dtype=torch.float32).reshape(1, 1, 4, 4)
    proj_v = torch.randn(3, 4, generator=g)

    img_r = torch.randn(2, 3, 8, 8, generator=g)
    proj_r = torch.randn(16, 48, generator=g)

    img_p2 = torch.randn(1, 1, 6, 6, generator=g)
    proj_p2 = torch.randn(8, 4, generator=g)

    img_p8 = torch.randn(1, 3, 32, 32, generator=g)
    proj_p8 = torch.randn(16, 192, generator=g)

    img_g = torch.randn(1, 1, 4, 4, generator=g)
    proj_g = torch.randn(3, 4, generator=g)

    return [
        visible_example("4x4 确定性图像", args=[T(img_v), T(proj_v), 2], expected=VALUE()),
        case("RGB 8x8", args=[T(img_r), T(proj_r), 4], expected=VALUE(), weight=1.5),
        case("P=2 非方形 patch 数", args=[T(img_p2), T(proj_p2), 2], expected=VALUE()),
        case("P=8 大 patch", args=[T(img_p8), T(proj_p8), 8], expected=VALUE()),
        case("输出形状检查", args=[T(img_v), T(proj_v), 2], expected=SHAPE()),
        case("梯度回传（图像侧）", args=[T(img_g, rg=True), T(proj_g), 2], expected=GRAD(), weight=1.5),
    ]
