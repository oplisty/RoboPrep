"""Generate supabase/seed_torchcode_problems.sql from scripts/torchcode_problems/.

Run with the PINNED environment so expected values match the judge reference
(docs/judge-environment.md):

    PYTHON_EXECUTABLE=... python scripts/generate_coding_seed.py   # or just the venv binary

For every problem module the generator:

1. writes the module's SOLUTION source to a temp file and imports it,
2. rebuilds each case's inputs from their JSON specs exactly the way the judge
   harness does (np.array -> torch.from_numpy),
3. runs the reference entrypoint to fill in auto expected values (VALUE /
   auto SHAPE / GRAD under the sum(output).backward() convention),
4. emits the problem INSERT plus a coding_test_cases INSERT in the same
   column order as seed_week5_function_problems.sql.

Output is deterministic: problem ids start at ...0134, test-case ids at
...0400, and the module list below is explicit.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import math
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent / "torchcode_problems"))

from framework import RESOURCE_LIMITS, T as T_spec  # noqa: E402

OUT_DEFAULT = ROOT / "supabase" / "seed_torchcode_problems.sql"
PROBLEM_DIR = Path(__file__).resolve().parent / "torchcode_problems"

# Deterministic ordering; ids are assigned from this list.
PROBLEM_MODULES = [
    "implement_relu",
    "implement_gelu",
    "cross_entropy_loss",
    "embedding_lookup",
    "linear_layer",
    "batchnorm_forward",
    "conv2d_layer",
    "inverted_dropout",
    "linear_regression_gd",
    "adam_step",
    "cosine_lr_schedule",
    "clip_grad_norm",
    "gradient_accumulation",
    "gqa_attention",
    "sliding_window_attention",
    "linear_attention",
    "flash_attention_small",
    "lora_layer",
    "vit_patch_embed",
    "gpt2_block",
    "moe_layer",
    "beam_search_decode",
    "top_p_filter",
    "bpe_encode",
    "int8_quantize",
    "dpo_loss",
]

PROBLEM_ID_BASE = 134
CASE_ID_BASE = 400
COLLECTION_ID = "c1000000-0000-4000-8000-000000000107"

NP_DTYPE = {"float32": "float32", "float64": "float64", "int64": "int64", "bool": "bool"}


def load_problem_module(name: str):
    path = PROBLEM_DIR / f"{name}.py"
    spec = importlib.util.spec_from_file_location(f"torchcode_problems.{name}", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def load_solution_module(slug: str, source: str, tmpdir: Path):
    path = tmpdir / f"solution_{slug}.py"
    path.write_text(source, encoding="utf-8")
    spec = importlib.util.spec_from_file_location(f"solution_{slug}", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def rebuild(v):
    """Rebuild judge inputs from JSON specs exactly like the harness does."""
    import numpy as np
    import torch

    if isinstance(v, dict) and v.get("type") == "tensor":
        shape = list(v["shape"])
        values = v["values"]
        count = int(math.prod(shape)) if shape else 1
        if values and len(values) != count:
            raise ValueError(f"values/shape mismatch: {len(values)} vs prod({shape})")
        if not values:
            arr = np.zeros(shape, dtype=NP_DTYPE[v["dtype"]])
        else:
            arr = np.array(values, dtype=NP_DTYPE[v["dtype"]]).reshape(shape)
        t = torch.from_numpy(np.ascontiguousarray(arr))
        if v.get("requires_grad"):
            if v["dtype"] not in ("float32", "float64"):
                raise ValueError("requires_grad only valid on float dtypes")
            t.requires_grad_(True)
        return t
    if isinstance(v, list):
        return [rebuild(x) for x in v]
    if isinstance(v, dict):
        return {k: rebuild(x) for k, x in v.items()}
    return v


def to_structured(out, depth: int = 0):
    import torch

    if depth > 6:
        raise ValueError("output nesting too deep")
    if out is None:
        return None
    if isinstance(out, torch.Tensor):
        return T_spec(out)
    if isinstance(out, bool):
        return out
    if isinstance(out, int):
        return out
    if isinstance(out, float):
        if not math.isfinite(out):
            raise ValueError("non-finite float in reference output")
        r = round(out, 6)
        return 0.0 if r == 0 else r
    if isinstance(out, str):
        if len(out) > 10_000:
            raise ValueError("string output too long")
        return out
    if isinstance(out, (list, tuple)):
        if len(out) > 10_000:
            raise ValueError("list output too long")
        return [to_structured(x, depth + 1) for x in out]
    if isinstance(out, dict):
        return {str(k): to_structured(v, depth + 1) for k, v in out.items()}
    raise ValueError(f"unsupported output type: {type(out)!r}")


def call_entrypoint(fn, mode, case_spec, args, kwargs):
    if mode == "function":
        return fn(*args, **kwargs)
    construct = case_spec.get("construct") or {"args": [], "kwargs": {}}
    c_args = [rebuild(x) for x in (construct.get("args") or [])]
    c_kwargs = {k: rebuild(v) for k, v in (construct.get("kwargs") or {}).items()}
    instance = fn(*c_args, **c_kwargs)
    method = case_spec.get("method") or "forward"
    return getattr(instance, method)(*args, **kwargs)


def compute_expected(expected, fn, mode, case_spec, args, kwargs):
    import torch

    kind = expected["kind"]

    if kind == "exception":
        try:
            call_entrypoint(fn, mode, case_spec, args, kwargs)
        except Exception as e:  # noqa: BLE001 - mirrors harness catch-all
            actual = type(e).__name__
            want = expected["exception_type"]
            if actual != want:
                raise ValueError(f"reference raised {actual}, case expects {want}: {e}") from e
        else:
            raise ValueError(f"reference did not raise {expected['exception_type']}")
        return dict(expected)

    if kind == "shape":
        out = call_entrypoint(fn, mode, case_spec, args, kwargs)
        if expected.get("auto"):
            if not isinstance(out, torch.Tensor):
                raise ValueError("auto shape expectation requires a tensor output")
            return {"kind": "shape", "shape": list(out.shape)}
        return dict(expected)

    if kind == "gradient":
        import torch.nn as nn_torch

        grads = []
        if mode == "function":
            out = call_entrypoint(fn, mode, case_spec, args, kwargs)
            if not isinstance(out, torch.Tensor):
                raise ValueError("gradient expectation requires a tensor output")
            out.backward(torch.ones_like(out))
            for i, a in enumerate(args):
                if isinstance(a, torch.Tensor) and a.requires_grad:
                    if a.grad is None:
                        raise ValueError(f"reference produced no grad for arg{i}")
                    grads.append({"label": f"arg{i}", "value": T_spec(a.grad)})
            for k, v in kwargs.items():
                if isinstance(v, torch.Tensor) and v.requires_grad:
                    if v.grad is None:
                        raise ValueError(f"reference produced no grad for kwarg {k}")
                    grads.append({"label": k, "value": T_spec(v.grad)})
        else:
            # class mode: one forward+backward per instance, mirroring the
            # harness labels: requires_grad args first, then module params
            construct = case_spec.get("construct") or {"args": [], "kwargs": {}}
            c_args = [rebuild(x) for x in (construct.get("args") or [])]
            c_kwargs = {k: rebuild(v) for k, v in (construct.get("kwargs") or {}).items()}
            instance = fn(*c_args, **c_kwargs)
            method = getattr(instance, case_spec.get("method") or "forward")
            out = method(*args, **kwargs)
            if not isinstance(out, torch.Tensor):
                raise ValueError("gradient expectation requires a tensor output")
            out.backward(torch.ones_like(out))
            for i, a in enumerate(args):
                if isinstance(a, torch.Tensor) and a.requires_grad:
                    if a.grad is None:
                        raise ValueError(f"reference produced no grad for arg{i}")
                    grads.append({"label": f"arg{i}", "value": T_spec(a.grad)})
            for k, v in kwargs.items():
                if isinstance(v, torch.Tensor) and v.requires_grad:
                    if v.grad is None:
                        raise ValueError(f"reference produced no grad for kwarg {k}")
                    grads.append({"label": k, "value": T_spec(v.grad)})
            if isinstance(instance, nn_torch.Module):
                for name, p in sorted(instance.named_parameters()):
                    if p.grad is None:
                        raise ValueError(f"reference produced no grad for param {name}")
                    grads.append({"label": f"param:{name}", "value": T_spec(p.grad)})
        if not grads:
            raise ValueError("gradient expectation produced no labels")
        return {"kind": "gradient", "gradients": grads}

    if kind == "value":
        if expected.get("auto"):
            out = call_entrypoint(fn, mode, case_spec, args, kwargs)
            return {"kind": "value", "value": to_structured(out)}
        return dict(expected)

    raise ValueError(f"unknown expected kind: {kind}")


def check_problem(p, cases):
    if not cases:
        raise ValueError("no cases")
    if cases[0]["hidden"]:
        raise ValueError("first case must be the visible example")
    hidden = [c for c in cases if c["hidden"]]
    if len(hidden) < 3:
        raise ValueError(f"needs >=3 hidden cases, got {len(hidden)}")


def sql_str(tag: str, s: str) -> str:
    if f"${tag}$" in s:
        raise ValueError(f"content contains dollar-quote tag ${tag}$")
    return f"${tag}${s}${tag}$"


def emit_problem(p, cases, pid: str, case_id_start: int) -> tuple[str, int]:
    limits = RESOURCE_LIMITS[p["resource_profile"]]
    config_json = json.dumps(p["evaluator_config"], ensure_ascii=False, separators=(",", ":"))
    lines = []
    lines.append(f"-- {p['title']}  ({p['difficulty']} / {p['evaluation_mode']} / {p['framework']})")
    lines.append("insert into public.coding_problems (")
    lines.append("  id, title, slug, difficulty, category, description, constraints,")
    lines.append("  starter_code, solution_code, function_name, language, time_limit_ms,")
    lines.append("  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,")
    lines.append("  evaluation_mode, entrypoint_type, entrypoint_name, framework,")
    lines.append("  resource_profile, evaluator_config")
    lines.append(") values (")
    lines.append(f"  '{pid}', {sql_str('t', p['title'])}, '{p['slug']}',")
    lines.append(f"  '{p['difficulty']}', '{p['category']}',")
    lines.append(f"  {sql_str('d', p['description'])},")
    lines.append(f"  {sql_str('c', p['constraints'])},")
    lines.append(f"  {sql_str('code', p['starter'])}, {sql_str('code', p['solution'])},")
    lines.append(f"  '{p['entrypoint_name']}', 'python', {limits[0]}, {limits[1]},")
    # legacy comparison_mode column: DB CHECK only allows exact/trimmed/numeric;
    # the ML judge consumes evaluator_config, so use the closest legacy value
    lines.append("  'numeric', 0.0001, true, false,")
    lines.append(f"  '{p['evaluation_mode']}', '{p['entrypoint_type']}', '{p['entrypoint_name']}',")
    lines.append(f"  '{p['framework']}', '{p['resource_profile']}',")
    lines.append(f"  '{config_json}'")
    lines.append(");")
    lines.append("")

    values = []
    cid = case_id_start
    for order, c in enumerate(cases):
        input_json = {"args": c["args"], "kwargs": c["kwargs"], "seed": c["seed"]}
        if p["evaluation_mode"] == "class":
            input_json["construct"] = c["construct"] or {"args": [], "kwargs": {}}
            input_json["method"] = c["method"]
        metadata = {"visible_example": True} if not c["hidden"] else {}
        expected_json = c["expected_json"]
        row = (
            f"    ('b2000000-0000-4000-8000-{cid:012d}', '{pid}',"
            f" {sql_str('n', c['name'])}, '{c['ttype']}', '{c['group']}',"
            f" {'false' if not c['hidden'] else 'true'}, {c['weight']}, {order},"
            f" {sql_str('data', json.dumps(input_json, ensure_ascii=False, separators=(',', ':')))},"
            f" {sql_str('data', json.dumps(expected_json, ensure_ascii=False, separators=(',', ':')))},"
            f" {sql_str('m', json.dumps(metadata, ensure_ascii=False, separators=(',', ':')))})"
        )
        values.append(row)
        cid += 1
    lines.append("insert into public.coding_test_cases (")
    lines.append("  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,")
    lines.append("  input_json, expected_json, metadata")
    lines.append(") values")
    lines.append(",\n".join(values))
    lines.append(";")
    lines.append("")
    return "\n".join(lines), cid


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, default=OUT_DEFAULT)
    parser.add_argument("--only", type=str, default=None, help="comma-separated module names to include")
    args = parser.parse_args()

    modules = PROBLEM_MODULES
    if args.only:
        wanted = set(args.only.split(","))
        modules = [m for m in PROBLEM_MODULES if m in wanted]
        missing = wanted - set(modules)
        if missing:
            raise SystemExit(f"unknown modules: {sorted(missing)}")

    import torch  # noqa: F401 - fail fast when run outside the pinned env

    header = [
        "-- -------------------------------------------------------------------------",
        "-- RoboPrep — TorchCode-derived structured problems (authorized import)",
        "--",
        "-- GENERATED FILE — do not edit by hand.",
        "-- Source: scripts/torchcode_problems/*.py via scripts/generate_coding_seed.py",
        "-- Regenerate in the pinned env (Python 3.13.12 / torch 2.13.0 / numpy 2.5.2):",
        "--   /Users/oplisty/.workbuddy/binaries/python/envs/default/bin/python \\",
        "--     scripts/generate_coding_seed.py",
        "--",
        "-- IDs: problems b1000000-...-000000000134+, test cases b2000000-...-000000000400+,",
        "-- collection c1000000-...-000000000107.",
        "-- -------------------------------------------------------------------------",
        "",
        "begin;",
        "",
    ]

    body: list[str] = []
    case_id = CASE_ID_BASE
    pids: list[str] = []
    with tempfile.TemporaryDirectory() as td:
        tmpdir = Path(td)
        for i, mod_name in enumerate(modules):
            mod = load_problem_module(mod_name)
            p = mod.PROBLEM
            p["starter"] = mod.STARTER
            p["solution"] = mod.SOLUTION
            cases = mod.build_cases()
            check_problem(p, cases)

            sol = load_solution_module(p["slug"], mod.SOLUTION, tmpdir)
            fn = getattr(sol, p["entrypoint_name"], None)
            if fn is None:
                raise SystemExit(f"{mod_name}: solution does not define entrypoint {p['entrypoint_name']}")

            filled = []
            for c in cases:
                pos_args = [rebuild(x) for x in c["args"]]
                kw_args = {k: rebuild(v) for k, v in c["kwargs"].items()}
                c = dict(c)
                c["expected_json"] = compute_expected(c["expected"], fn, p["evaluation_mode"], c, pos_args, kw_args)
                filled.append(c)

            pid = f"b1000000-0000-4000-8000-{PROBLEM_ID_BASE + i:012d}"
            pids.append(pid)
            sql, case_id = emit_problem(p, filled, pid, case_id)
            body.append(sql)
            print(f"  {p['slug']}: {len(filled)} cases ok")

    collection = "\n".join(
        [
            "-- ---------------------------------------------------------------------------",
            "-- Collection: LLM 核心算子（TorchCode 整合）",
            "-- ---------------------------------------------------------------------------",
            "insert into public.coding_collections (",
            "  id, name, slug, description, is_published, order_index",
            ") values (",
            f"  '{COLLECTION_ID}',",
            f"  {sql_str('t', 'LLM 核心算子')},",
            "  'llm-core-operators',",
            f"  {sql_str('d', '从零手写大模型核心组件：基础算子、注意力变体、架构模块、训练与解码策略，覆盖 LLM 面试中最常考的 PyTorch 实现。')},",
            "  true, 6",
            ");",
            "",
            "insert into public.coding_collection_problems (collection_id, problem_id, order_index) values",
        ]
        + [f"  ('{COLLECTION_ID}', '{pid}', {i})," for i, pid in enumerate(pids)]
    )
    # trim trailing comma of last membership row
    collection = collection.rstrip(",") + ";"

    footer = ["", collection, "", "commit;", ""]
    args.out.write_text("\n".join(header + body + footer), encoding="utf-8")
    print(f"\nwrote {args.out} ({len(pids)} problems, {case_id - CASE_ID_BASE} cases)")


if __name__ == "__main__":
    main()
