"""INT8 对称量化（源自 TorchCode `int8_quantization`，已获授权改写）。"""

PROBLEM = {
    "slug": "int8-quantize",
    "title": "实现 INT8 对称量化（per-tensor）",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "实现大模型推理部署中最常用的 per-tensor 对称量化与反量化：\n\n"
        "    amax = max(|w|)\n"
        "    scale = amax / 127                # amax == 0 时取 scale = 1.0\n"
        "    q = clamp(round(w / scale), -127, 127).to(int64)\n"
        "    w_hat = q.to(float32) * scale     # 反量化近似\n\n"
        "返回: 元组 (w_hat, scale)，w_hat 为与 w 同形状的 float32 张量，scale 为 Python float。\n\n"
        "要求：\n"
        "- round 用 torch.round（银行家舍入即可，与参考实现一致）；\n"
        "- clamp 在 round 之后、转 int64 之前；\n"
        "- 不要调用 torch.quantize_per_tensor 等现成量化 API；\n"
        "- 全零张量是合法输入（scale 兜底为 1.0，此时 w_hat 必须全零）。"
    ),
    "constraints": "w 为 float32 张量（ndim <= 4，元素数 <= 4096），|w_i| <= 1000。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "quantize_dequantize",
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

def quantize_dequantize(w: torch.Tensor):
    # w: 任意形状 float32
    # TODO: 返回 (w_hat, scale)
    return w, 1.0
"""

SOLUTION = """import torch

def quantize_dequantize(w: torch.Tensor):
    amax = w.abs().max().item()
    scale = amax / 127.0 if amax > 0 else 1.0
    q = torch.round(w / scale).clamp(-127, 127).to(torch.int64)
    w_hat = q.to(torch.float32) * scale
    return w_hat, float(scale)
"""


def build_cases():
    import torch

    from framework import VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261007)

    w_v = torch.tensor([0.1, -0.5, 0.25, 1.27, -2.54])

    w_r = torch.randn(4, 8, generator=g)

    w_2d = torch.randn(2, 3, 4, generator=g) * 50

    w_z = torch.zeros(3, 3)

    w_c = torch.tensor([127.0, -127.0, 63.5, -0.001])

    return [
        visible_example("一维小张量", args=[T(w_v)], expected=VALUE()),
        case("二维随机张量", args=[T(w_r)], expected=VALUE()),
        case("大数值三维张量", args=[T(w_2d)], expected=VALUE()),
        case("全零张量", args=[T(w_z)], expected=VALUE(), weight=1.5),
        case("边界值 127", args=[T(w_c)], expected=VALUE()),
    ]
