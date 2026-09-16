"""GPT-2 Transformer Block（简化版，权重注入）（源自 TorchCode `gpt2_block`，已获授权改写）。"""

PROBLEM = {
    "slug": "gpt2-block",
    "title": "实现 GPT-2 Transformer Block（简化版）",
    "difficulty": "hard",
    "category": "transformer",
    "description": (
        "实现一个简化版 GPT-2 block：pre-LN + 因果多头自注意力 + MLP，残差两次。"
        "为保证判题确定性，所有权重由构造函数注入（无偏置）：\n\n"
        "    h  = layer_norm(x; ln1_gamma, ln1_beta, eps=1e-5)\n"
        "    qkv = h @ w_qkv^T                      # (B, S, 3D)，按 q|k|v 沿最后一维切分\n"
        "    拆成 n_head 个头（每个头 d_head = D / n_head），做因果缩放点积注意力（1/sqrt(d_head)），\n"
        "    拼回头部后投影：attn = heads @ w_out^T\n"
        "    h2 = x + attn\n"
        "    h3 = layer_norm(h2; ln2_gamma, ln2_beta, eps=1e-5)\n"
        "    mlp = gelu(h3 @ w_fc^T) @ w_proj^T     # gelu 用精确 erf 版本\n"
        "    out = h2 + mlp\n\n"
        "layer_norm 定义：对最后一维做 (x - mean) / sqrt(var + eps) * gamma + beta"
        "（方差为有偏 var，等价 F.layer_norm）。注意力 softmax 对最后一维；"
        "因果掩码：token i 只能 attend 到 j <= i。\n\n"
        "要求：\n"
        "- 类必须继承 torch.nn.Module；\n"
        "- `__init__(self, ln1_gamma, ln1_beta, w_qkv, w_out, ln2_gamma, ln2_beta, w_fc, w_proj, n_head: int)`，"
        "八个张量注册为同名 nn.Parameter（如 self.w_qkv = nn.Parameter(w_qkv)）；\n"
        "- 可以调用 F.layer_norm / F.softmax / torch.erf，但不要调用 F.scaled_dot_product_attention、"
        "torch.nn.MultiheadAttention 或 torch.nn.Transformer；\n"
        "- 计算必须可微。"
    ),
    "constraints": "x 为 float32 (B, S, D)，B=1，S <= 16，D ∈ {16, 32}；n_head 整除 D；w_qkv (3D, D)、w_out (D, D)、w_fc (4D, D)、w_proj (D, 4D)；ln 的 gamma/beta 为 (D,)。",
    "evaluation_mode": "class",
    "entrypoint_type": "class",
    "entrypoint_name": "GPT2Block",
    "framework": "pytorch",
    "resource_profile": "ml_cpu_medium",
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
import torch.nn as nn

class GPT2Block(nn.Module):
    def __init__(self, ln1_gamma, ln1_beta, w_qkv, w_out, ln2_gamma, ln2_beta, w_fc, w_proj, n_head: int) -> None:
        # 八个张量请注册为同名 nn.Parameter
        super().__init__()

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # x: (B, S, D)
        # TODO: pre-LN + 因果 MHA + MLP，两次残差
        return x
"""

SOLUTION = """import math

import torch
import torch.nn as nn
import torch.nn.functional as F

class GPT2Block(nn.Module):
    def __init__(self, ln1_gamma, ln1_beta, w_qkv, w_out, ln2_gamma, ln2_beta, w_fc, w_proj, n_head: int) -> None:
        super().__init__()
        self.ln1_gamma = nn.Parameter(ln1_gamma)
        self.ln1_beta = nn.Parameter(ln1_beta)
        self.w_qkv = nn.Parameter(w_qkv)
        self.w_out = nn.Parameter(w_out)
        self.ln2_gamma = nn.Parameter(ln2_gamma)
        self.ln2_beta = nn.Parameter(ln2_beta)
        self.w_fc = nn.Parameter(w_fc)
        self.w_proj = nn.Parameter(w_proj)
        self.n_head = n_head

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        B, S, D = x.shape
        d_head = D // self.n_head

        h = F.layer_norm(x, (D,), self.ln1_gamma, self.ln1_beta, 1e-5)
        qkv = h @ self.w_qkv.T
        q, k, v = qkv.chunk(3, dim=-1)
        q = q.view(B, S, self.n_head, d_head).transpose(1, 2)
        k = k.view(B, S, self.n_head, d_head).transpose(1, 2)
        v = v.view(B, S, self.n_head, d_head).transpose(1, 2)
        scores = q @ k.transpose(-2, -1) / math.sqrt(d_head)
        causal = torch.tril(torch.ones(S, S, dtype=torch.bool, device=x.device))
        scores = scores.masked_fill(~causal, float("-inf"))
        attn = torch.softmax(scores, dim=-1)
        heads = (attn @ v).transpose(1, 2).contiguous().view(B, S, D)
        h2 = x + heads @ self.w_out.T

        h3 = F.layer_norm(h2, (D,), self.ln2_gamma, self.ln2_beta, 1e-5)
        mlp = 0.5 * h3 * (1.0 + torch.erf(h3 / math.sqrt(2.0)))
        mlp = mlp @ self.w_fc.T
        mlp = mlp @ self.w_proj.T
        return h2 + mlp
"""


def build_cases():
    import torch

    from framework import GRAD, SHAPE, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261003)

    D = 16
    H = 2

    def parts(d=D, h=H, scale=0.2):
        return dict(
            ln1g=torch.rand(d, generator=g) + 0.5,
            ln1b=torch.randn(d, generator=g) * 0.1,
            wqkv=torch.randn(3 * d, d, generator=g) * scale,
            wout=torch.randn(d, d, generator=g) * scale,
            ln2g=torch.rand(d, generator=g) + 0.5,
            ln2b=torch.randn(d, generator=g) * 0.1,
            wfc=torch.randn(4 * d, d, generator=g) * scale,
            wproj=torch.randn(d, 4 * d, generator=g) * scale,
            nh=h,
        )

    def C(p):
        return {
            "args": [T(p["ln1g"]), T(p["ln1b"]), T(p["wqkv"]), T(p["wout"]), T(p["ln2g"]), T(p["ln2b"]), T(p["wfc"]), T(p["wproj"]), p["nh"]],
            "kwargs": {},
        }

    p_v = parts()
    x_v = torch.randn(1, 8, D, generator=g)

    p_r = parts(d=32, h=4)
    x_r = torch.randn(1, 12, 32, generator=g)

    p_1 = parts(d=16, h=16)
    x_1 = torch.randn(1, 6, 16, generator=g)

    p_g = parts()
    x_g = torch.randn(1, 8, D, generator=g)

    return [
        visible_example("D=16 双头前向", args=[T(x_v)], construct=C(p_v), expected=VALUE()),
        case("D=32 四头 S=12", args=[T(x_r)], construct=C(p_r), expected=VALUE(), weight=1.5),
        case("单头退化", args=[T(x_1)], construct=C(p_1), expected=VALUE()),
        case("输出形状检查", args=[T(x_v)], construct=C(p_v), expected=SHAPE()),
        case("梯度回传（输入+八参数）", args=[T(x_g, rg=True)], construct=C(p_g), expected=GRAD(), weight=2.0),
    ]
