"""Shared helpers for authoring TorchCode-derived coding problems.

Problem modules in this package expose:

- ``PROBLEM``: metadata dict (title/description/constraints/evaluator config…)
- ``STARTER``: starter code shown to the user
- ``SOLUTION``: reference solution source (executed by the generator to
  compute expected values, and emitted verbatim as ``solution_code``)
- ``build_cases()``: list of case dicts built with :func:`case` and the
  expected-value helpers (:func:`VALUE`, :func:`SHAPE`, :func:`GRAD`,
  :func:`EXC`, :func:`VALUE_LIT`).

Inputs are always literal: builders create tensors from a seeded
``torch.Generator`` and immediately convert them to flat JSON specs, so the
seed never depends on runtime RNG state.
"""

from __future__ import annotations

from typing import Any

DTYPE_TO_TORCH = {"float32": "torch.float32", "float64": "torch.float64", "int64": "torch.int64", "bool": "torch.bool"}

RESOURCE_LIMITS = {
    "standard_python": (5000, 256),
    "ml_cpu_small": (15000, 512),
    "ml_cpu_medium": (40000, 1024),
}

ROUND_DIGITS = 6


def _round(v: float) -> float:
    r = round(float(v), ROUND_DIGITS)
    return 0.0 if r == 0 else r  # normalize -0.0


def T(t: Any, *, dtype: str | None = None, rg: bool = False) -> dict[str, Any]:
    """Build a TensorSpec from a torch.Tensor (values rounded to 6 decimals)."""
    import numpy as np
    import torch

    arr = t.detach().cpu()
    if dtype is None:
        dtype = {"torch.float32": "float32", "torch.float64": "float64", "torch.int64": "int64", "torch.bool": "bool"}[str(arr.dtype)]
    if dtype == "int64":
        values = [int(v) for v in arr.reshape(-1).tolist()]
    elif dtype == "bool":
        values = [bool(v) for v in arr.reshape(-1).tolist()]
    else:
        values = [_round(v) for v in arr.to(torch.float64).reshape(-1).tolist()]
    shape = list(arr.shape)
    if len(shape) > 8:
        raise ValueError(f"tensor spec has {len(shape)} dims (max 8)")
    if len(values) != int(np.prod(shape)) if shape else False:
        raise ValueError(f"values/shape mismatch: {len(values)} vs prod({shape})")
    if len(values) > 100_000:
        raise ValueError(f"tensor spec too large: {len(values)} values (max 100000)")
    return {"type": "tensor", "shape": shape, "dtype": dtype, "values": values, "requires_grad": rg}


def TI(t: Any, *, rg: bool = False) -> dict[str, Any]:
    return T(t, dtype="int64", rg=rg)


# ---------------------------------------------------------------------------
# Expected-value specs
# ---------------------------------------------------------------------------

def VALUE() -> dict[str, Any]:
    """Auto-computed value expectation (generator runs the reference solution)."""
    return {"kind": "value", "auto": True}


def VALUE_LIT(v: Any) -> dict[str, Any]:
    return {"kind": "value", "value": v}


def SHAPE(shape: list[int] | None = None) -> dict[str, Any]:
    """Literal shape, or auto-derived from the reference output when omitted."""
    if shape is None:
        return {"kind": "shape", "auto": True}
    return {"kind": "shape", "shape": list(shape)}


def GRAD() -> dict[str, Any]:
    """Auto-computed gradient expectation for every labeled source of grads."""
    return {"kind": "gradient"}


def EXC(exception_type: str, message_pattern: str | None = None) -> dict[str, Any]:
    e: dict[str, Any] = {"kind": "exception", "exception_type": exception_type}
    if message_pattern is not None:
        e["message_pattern"] = message_pattern
    return e


# ---------------------------------------------------------------------------
# Case definition
# ---------------------------------------------------------------------------

_DEFAULT_GROUP = {"value": "basic", "shape": "shape", "gradient": "gradient", "exception": "edge", "performance": "performance"}


def case(
    name: str,
    *,
    args: list[Any] | None = None,
    kwargs: dict[str, Any] | None = None,
    construct: dict[str, Any] | None = None,
    method: str | None = None,
    expected: dict[str, Any],
    hidden: bool = True,
    weight: float = 1.0,
    seed: int | None = None,
    ttype: str | None = None,
    group: str | None = None,
) -> dict[str, Any]:
    kind = expected["kind"]
    return {
        "name": name,
        "args": args or [],
        "kwargs": kwargs or {},
        "construct": construct,
        "method": method,
        "expected": expected,
        "hidden": hidden,
        "weight": weight,
        "seed": seed,
        "ttype": ttype or ("example" if not hidden and kind == "value" else kind),
        "group": group or _DEFAULT_GROUP[kind],
    }


def visible_example(name: str, *, args=None, kwargs=None, construct=None, method=None, expected=None, weight: float = 1.0) -> dict[str, Any]:
    c = case(
        name,
        args=args,
        kwargs=kwargs,
        construct=construct,
        method=method,
        expected=expected if expected is not None else VALUE(),
        hidden=False,
        weight=weight,
    )
    return c
