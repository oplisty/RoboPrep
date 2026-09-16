"""DPO 损失（源自 TorchCode `dpo_loss`，已获授权改写）。"""

PROBLEM = {
    "slug": "dpo-loss",
    "title": "实现 DPO 损失函数",
    "difficulty": "medium",
    "category": "rl",
    "description": (
        "实现 Direct Preference Optimization (DPO) 的损失函数。给定策略模型与参考模型"
        "在 chosen（更优回答）和 rejected（更差回答）上的序列对数概率，计算：\n\n"
        "    margin_i = (policy_logp_w[i] - ref_logp_w[i]) - (policy_logp_l[i] - ref_logp_l[i])\n"
        "    logits   = beta * margin\n"
        "    loss     = -log(σ(logits)) 的批均值        # 等价 softplus(-logits).mean()\n\n"
        "其中 σ 为 sigmoid，beta 为温度系数。返回标量张量。\n\n"
        "要求：\n"
        "- 用数值稳定的方式实现 -log σ(u)（如 F.logsigmoid 或 softplus(-u)，"
        "不要直接写 -torch.log(torch.sigmoid(u)) 后在 u 为大负数时溢出）；\n"
        "- 不要调用 TRL 等第三方库；\n"
        "- 计算必须可微（梯度检查会验证 policy_logp_w 上的梯度）。"
    ),
    "constraints": "四个 logp 输入均为 float32 (B,)，2 <= B <= 32，元素绝对值 <= 1000；0 < beta <= 1。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "dpo_loss",
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

def dpo_loss(policy_logp_w: torch.Tensor, policy_logp_l: torch.Tensor,
             ref_logp_w: torch.Tensor, ref_logp_l: torch.Tensor, beta: float) -> torch.Tensor:
    # policy_logp_w/l: (B,) 策略模型在 chosen/rejected 上的序列对数概率
    # ref_logp_w/l: (B,) 参考模型对应值；beta: 温度系数
    # TODO: 返回标量损失
    return (policy_logp_w + ref_logp_w + policy_logp_l + ref_logp_l).mean() * 0.0
"""

SOLUTION = """import torch
import torch.nn.functional as F

def dpo_loss(policy_logp_w: torch.Tensor, policy_logp_l: torch.Tensor,
             ref_logp_w: torch.Tensor, ref_logp_l: torch.Tensor, beta: float) -> torch.Tensor:
    logits = beta * ((policy_logp_w - ref_logp_w) - (policy_logp_l - ref_logp_l))
    return F.softplus(-logits).mean()
"""


def build_cases():
    import torch

    from framework import GRAD, VALUE, T, case, visible_example

    g = torch.Generator().manual_seed(20261008)

    pw_v = torch.tensor([-1.0, -2.0, -0.5])
    pl_v = torch.tensor([-3.0, -1.5, -2.5])
    rw_v = torch.tensor([-1.2, -1.8, -0.7])
    rl_v = torch.tensor([-1.4, -2.2, -1.9])

    pw_r = torch.randn(8, generator=g) * 3
    pl_r = torch.randn(8, generator=g) * 3
    rw_r = torch.randn(8, generator=g) * 3
    rl_r = torch.randn(8, generator=g) * 3

    pw_b = torch.tensor([-10.0, -20.0])
    pl_b = torch.tensor([-1.0, -1.0])
    rw_b = torch.tensor([-1.0, -1.0])
    rl_b = torch.tensor([-10.0, -20.0])

    pw_z = torch.zeros(4)
    pl_z = torch.zeros(4)
    rw_z = torch.zeros(4)
    rl_z = torch.zeros(4)

    pw_g = torch.randn(4, generator=g) * 2
    pl_g = torch.randn(4, generator=g) * 2
    rw_g = torch.randn(4, generator=g) * 2
    rl_g = torch.randn(4, generator=g) * 2

    return [
        visible_example("小批量 beta=0.1", args=[T(pw_v), T(pl_v), T(rw_v), T(rl_v), 0.1], expected=VALUE()),
        case("随机批量", args=[T(pw_r), T(pl_r), T(rw_r), T(rl_r), 0.5], expected=VALUE()),
        case("大 margin 数值稳定", args=[T(pw_b), T(pl_b), T(rw_b), T(rl_b), 0.5], expected=VALUE(), weight=1.5),
        case("全零输入", args=[T(pw_z), T(pl_z), T(rw_z), T(rl_z), 0.1], expected=VALUE()),
        case("梯度回传", args=[T(pw_g, rg=True), T(pl_g), T(rw_g), T(rl_g), 0.3], expected=GRAD(), weight=1.5),
    ]
