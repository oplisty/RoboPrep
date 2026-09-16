# RoboPrep coding problem authoring guide

Date: 2026-09-01

Week 5 Task 44. This guide lets a contributor add a function- or class-level
problem **without reading evaluator internals**. Program-mode (stdin/stdout)
authoring is unchanged from Week 4 and is not covered here.

## 1. Pick a slug and ID

- **Slug**: kebab-case, globally unique (`implement-rmsnorm`).
- **ID**: use the `b1000000-0000-4000-8000-0000000001xx` namespace for
  problems and `b2000000-…-0000000002xx` for test cases. Pick the next free
  number (`...0133`, `...0312`, …) — never reuse.

## 2. Problem row

Insert into `coding_problems` with the structured columns:

| Column | Value | Meaning |
| ------ | ----- | ------- |
| `evaluation_mode` | `function` / `class` | What the harness instantiates |
| `entrypoint_type` | `function` / `class` | Must match `evaluation_mode` |
| `entrypoint_name` | e.g. `layer_norm` | Exact callable name the user must define |
| `framework` | `python` / `numpy` / `pytorch` | Controls import allowlist & tensor construction |
| `resource_profile` | `standard_python` / `ml_cpu_small` / `ml_cpu_medium` | Server-owned limits (see judge-environment.md) |
| `evaluator_config` | JSON, strict schema | See section 3 |
| `language` | `python` | Only Python is supported |

Legacy fields (`function_name`, `comparison_mode`, `tolerance`,
`time_limit_ms`, `memory_limit_mb`) remain required columns but the
structured fields above are what the ML judge consumes.

### Starter code

- Must define the entrypoint **with the exact name and a compatible
  signature**.
- Imports must be explicit (`import torch`, `import numpy as np`).
- Body is a `pass` / `return x` placeholder. Never include solution hints.
- Use type hints (`x: torch.Tensor`) — they double as docs.

```python
import torch

def layer_norm(x: torch.Tensor, weight: torch.Tensor, bias: torch.Tensor, eps: float = 1e-5) -> torch.Tensor:
    # x: (..., d) float32 ; weight, bias: (d,) float32
    # TODO: return a tensor of the same shape as x
    return x
```

### Solution code

The reference implementation the judge trusts (never shipped to clients).
Keep it simple and identical to the documented math so expected values match:

```python
import torch

def layer_norm(x: torch.Tensor, weight: torch.Tensor, bias: torch.Tensor, eps: float = 1e-5) -> torch.Tensor:
    mean = x.mean(dim=-1, keepdim=True)
    var = x.var(dim=-1, keepdim=True, unbiased=False)
    x_hat = (x - mean) / torch.sqrt(var + eps)
    return x_hat * weight + bias
```

## 3. Evaluator config

Strict JSON object; unknown keys are rejected:

```json
{
  "comparison": "allclose",
  "rtol": 0.0001,
  "atol": 0.00001,
  "check_shape": true,
  "check_dtype": false,
  "check_gradient": true
}
```

| Key | Allowed | Default |
| --- | ------- | ------- |
| `comparison` | `exact` / `allclose` / `absolute_error` / `relative_error` | `allclose` |
| `rtol` | 0…1 | `1e-5` (pytorch `1e-4`) |
| `atol` | 0…1 | `1e-6` (pytorch `1e-5`) |
| `check_shape` | bool | `true` |
| `check_dtype` | bool | `true` |
| `check_gradient` | bool | `false` |

## 4. Test cases

Insert into `coding_test_cases` with `input_json`, `expected_json`,
`test_type`, `test_group`, `is_hidden`.

### input_json

```json
{
  "args": [ <input values…> ],
  "kwargs": { "eps": 1e-5 },
  "seed": null
}
```

Inputs are plain JSON: `int`, `float`, `bool`, `string`, nested `list`,
`dict`, or a **tensor spec**:

```json
{ "type": "tensor", "shape": [2, 3], "dtype": "float32", "values": [1, 2, 3, 4, 5, 6], "requires_grad": true }
```

Rules:

- `values` is **flat row-major**; it must contain exactly
  `prod(shape)` numbers (empty means zeros).
- `dtype` is one of `float32 | float64 | int64 | bool`.
- `requires_grad: true` is required on every tensor whose gradient you want
  checked (only valid on float dtypes). Without it the tensor is detached.
- Class-mode problems may add `construct: { args, kwargs }` and
  `method: "forward"` to instantiate the class.

### expected_json

`kind` determines the check:

| kind | Payload | Checks |
| ---- | ------- | ------ |
| `value` | `value: <same shape as input>` | Numeric allclose + optional shape/dtype |
| `shape` | `shape: [2, 3, 4]` | Rank and dims only |
| `dtype` | `dtype: "float32"` | Dtype only |
| `gradient` | `gradients: [{label, value}]` | Backward pass vs reference gradients |
| `exception` | `exception_type`, `message_pattern?` | Expected exception |
| `performance` | `max_runtime_ms?` | Informational only |

### Gradient labels

| Position | Label |
| -------- | ----- |
| Positional arg #k | `arg0`, `arg1`, … |
| Keyword arg | the keyword name (e.g. `weight`) |
| Class parameter | `param:<name>` |

Reference gradients must be computed under the **`sum(output).backward()`
convention** (see docs/judge-reproducibility.md) and rounded to 6 decimals.

### Required coverage (integrity)

- At least **1 visible** example (`is_hidden = false`, `test_type = example`)
  with `metadata: {"visible_example": true}`.
- At least **3 hidden** cases spanning `basic`/`edge`/`numerical`,
  `shape`, and `gradient` groups where applicable.
- Every non-trivial problem must include hidden cases; example-only
  problems fail `check:coding`.

## 5. Verifying a new problem

```bash
# 1. Re-extract the seed and run every solution_code through the real judge
python /tmp/extract_fixed.py
PYTHON_EXECUTABLE=<venv python> node --experimental-strip-types \
  --loader ./scripts/tests/loader.mjs scripts/validate-seed-problems.ts
# → Problems: N, failing: 0

# 2. Offline unit tests (incl. new integrity-logic tests)
pnpm test

# 3. Against a live database (after supabase db reset)
pnpm check:coding
```

## 6. Conventions checklist

- Math conventions are explicit in the description (e.g. "biased variance,
  `ddof=0`", "quaternion order `(w, x, y, z)`", "GRPO advantage is
  standardized per group").
- Reference expected values come from the pinned environment
  (Python 3.13.12 / torch 2.13.0 / numpy 2.5.2, CPU).
- No CUDA, no distributed code, no random behavior without a fixed `seed`.
- Hidden tests never leak through Run: `check:coding` and the API boundary
  enforce visible-only execution for Run.

## 7. Batch authoring workflow (TorchCode import)

For batches of structured problems, write problem modules and let the
generator compute the expected values — no hand-rounded constants:

1. **Author a module** `scripts/torchcode_problems/<module_name>.py` with:
   - `PROBLEM`: metadata dict — Chinese `title`/`description`/`constraints`,
     `difficulty`, `category`, `slug`, `evaluation_mode`, `entrypoint_type`,
     `entrypoint_name`, `framework`, `resource_profile`, `evaluator_config`;
   - `STARTER` / `SOLUTION`: verbatim code blocks (SOLUTION is executed to
     produce expected values, so keep it exactly consistent with the
     documented math);
   - `build_cases()`: list built with `framework.case` / `visible_example`;
     inputs are always literal tensor specs created from a seeded
     `torch.Generator` (`framework.T`). Expected specs: `VALUE()` /
     `VALUE_LIT(x)` / `SHAPE()` / `GRAD()` / `EXC(type, pattern?)` — the
     `auto` ones are filled in by running SOLUTION.
2. **Register the module** in `PROBLEM_MODULES` in
   `scripts/generate_coding_seed.py` (explicit list = deterministic IDs;
   problems start at `...0134`, cases at `...0400`).
3. **Generate + validate** in the pinned env:

   ```bash
   PY=/Users/oplisty/.workbuddy/binaries/python/envs/default/bin/python
   $PY scripts/generate_coding_seed.py --out supabase/seed_torchcode_problems.sql
   $PY scripts/extract_seed_problems.py supabase/seed_torchcode_problems.sql \
     --out /tmp/seed_data.json
   PYTHON_EXECUTABLE=$PY node --experimental-strip-types \
     --loader ./scripts/tests/loader.mjs scripts/validate-seed-problems.ts \
     --input /tmp/seed_data.json
   # → Problems: N, failing: 0
   ```

   Output is deterministic — regenerating must produce a byte-identical file.

4. **Apply locally and audit**: the seed file is applied manually (not via
   `supabase db reset`, which only runs `seed.sql`):

   ```bash
   docker exec -i supabase_db_roboprep psql -U postgres -d postgres -v ON_ERROR_STOP=1 \
     < supabase/seed_torchcode_problems.sql
   pnpm check:coding   # needs .env.local pointing at the local stack
   ```

   Note the legacy `comparison_mode` column only accepts
   `exact/trimmed/numeric` (DB CHECK) — the generator emits `numeric`; the
   ML judge itself reads `evaluator_config`.

Authoring gotchas baked into the generator (still worth knowing):

- Gradient cases must avoid the ReLU/max kink at exactly 0 — subgradient
  conventions differ between `torch.maximum` and `clamp`, so keep gradient
  inputs away from ties.
- Class-mode gradient labels require the entrypoint to subclass
  `torch.nn.Module` (labels are `param:<name>` from `named_parameters()`),
  and every injected weight must be registered as an `nn.Parameter` with the
  exact name stated in the description.
- String outputs are not compared numerically: `numeric_comparison` flattens
  numbers only. If a problem returns tokens, return **ids** (list[int]) via a
  vocab lookup, not strings.
- Randomized-looking problems (dropout, sampling) are made deterministic by
  passing masks/seeds as literal inputs instead of sampling inside the
  solution.
