-- ---------------------------------------------------------------------------
-- RoboPrep — Week 5 function/class coding problems (Task 34)
--
-- Adds 33 structured (function/class mode) problems on top of the 20 Week 4
-- program problems, bringing the catalog to 53. At least 20 use function/class
-- mode and at least 10 use PyTorch, satisfying the Task 34 acceptance criteria.
--
-- Every problem declares:
--   evaluation_mode = 'function' | 'class'
--   entrypoint_type / entrypoint_name
--   framework       = 'python' | 'numpy' | 'pytorch'
--   resource_profile= 'standard_python' | 'ml_cpu_small' | 'ml_cpu_medium'
--   evaluator_config= jsonb validated server-side by parseEvaluatorConfig
--
-- Structured test cases use coding_test_cases.input_json / expected_json:
--   input_json   = { args, kwargs, construct, method, seed }
--   expected_json= { kind: 'value'|'shape'|'dtype'|'gradient'|'exception', ... }
--   test_type    = 'example'|'value'|'shape'|'dtype'|'gradient'|'exception'|'performance'
--   test_group   = 'basic'|'edge'|'numerical'|'shape'|'gradient'|'performance'
--
-- IDs use distinct namespaces so they never collide with the Week 4 seed:
--   coding_problems  -> b1000000-...-0000000001xx
--   coding_test_cases-> b2000000-...-0000000002xx
--   coding_collections-> c1000000-...-0000000001xx
-- ---------------------------------------------------------------------------

begin;

-- ===========================================================================
-- TRANSFORMER PROBLEMS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 21. RMSNorm  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000101', 'Implement RMSNorm', 'implement-rmsnorm',
  'easy', 'transformer',
  'Implement RMS (root-mean-square) normalization for a 1-D tensor of floats. Given a vector x and epsilon, compute mean(x^2) over the vector, scale = sqrt(mean(x^2) + eps), and return x / scale. The operation must be differentiable, so build the computation with tensor ops (torch.mean / torch.sqrt) rather than in-place Python loops.',
  'x is a 1-D float32 tensor of length 2..16. eps is a positive float.',
  $code$
import torch

def rms_norm(x: torch.Tensor, eps: float) -> torch.Tensor:
    # x: (N,) float32
    # TODO: implement and return a tensor of the same shape
    return x
  $code$, $code$
import torch

def rms_norm(x: torch.Tensor, eps: float) -> torch.Tensor:
    ms = torch.mean(x * x)
    scale = torch.sqrt(ms + eps)
    return x / scale
  $code$, 'rms_norm',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'rms_norm', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000201', 'b1000000-0000-4000-8000-000000000101',
    'positive vector', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[1,2,3],"requires_grad":true}],"kwargs":{"eps":0.00001},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[0.46291,0.92582,1.388729]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000202', 'b1000000-0000-4000-8000-000000000101',
    'mixed signs', 'value', 'edge', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[1,-2,3],"requires_grad":true}],"kwargs":{"eps":0.00001},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[0.46291,-0.92582,1.388729]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000203', 'b1000000-0000-4000-8000-000000000101',
    'all equal', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[4],"dtype":"float32","values":[5,5,5,5],"requires_grad":true}],"kwargs":{"eps":0.001},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[0.99998,0.99998,0.99998,0.99998]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000204', 'b1000000-0000-4000-8000-000000000101',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[1,2,3],"requires_grad":true}],"kwargs":{"eps":0.00001},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[0.26452,0.066131,-0.132259]}}]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000205', 'b1000000-0000-4000-8000-000000000101',
    'length 2', 'value', 'edge', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,-1],"requires_grad":true}],"kwargs":{"eps":0.0},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[1.0,-1.0]}}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 22. Causal Attention Mask  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000102', 'Build a Causal Attention Mask', 'build-causal-attention-mask-v2',
  'easy', 'transformer',
  'Build a causal (upper-triangular) attention mask for a sequence of length n. Return an n x n matrix where entry (i, j) is 1 when position j is visible to position i (j <= i) and 0 otherwise. This prevents tokens from attending to future tokens.',
  'n is an integer 1..32.',
  $code$
def causal_mask(n: int) -> list:
    # TODO: return an n x n list-of-lists of 0/1 ints
    return []
  $code$, $code$
def causal_mask(n: int) -> list:
    return [[1 if j <= i else 0 for j in range(n)] for i in range(n)]
  $code$, 'causal_mask',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'function', 'function', 'causal_mask', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000206', 'b1000000-0000-4000-8000-000000000102',
    'length 3', 'example', 'basic', false, 1.0, 0,
    $data${"args":[3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,0,0],[1,1,0],[1,1,1]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000207', 'b1000000-0000-4000-8000-000000000102',
    'length 1', 'value', 'edge', false, 1.0, 1,
    $data${"args":[1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000208', 'b1000000-0000-4000-8000-000000000102',
    'length 4', 'value', 'basic', true, 1.0, 2,
    $data${"args":[4],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,0,0,0],[1,1,0,0],[1,1,1,0],[1,1,1,1]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000209', 'b1000000-0000-4000-8000-000000000102',
    'length 5 lower triangle', 'value', 'edge', true, 1.0, 3,
    $data${"args":[5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,0,0,0,0],[1,1,0,0,0],[1,1,1,0,0],[1,1,1,1,0],[1,1,1,1,1]]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 23. KV Cache Append  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000103', 'Append to a KV Cache', 'append-kv-cache',
  'easy', 'transformer',
  'Append a new key and value vector to an existing KV cache. The cache is represented as two lists of token vectors: k_cache (list of key vectors) and v_cache (list of value vectors). Given a single new key vector and value vector, return the updated (k_cache, v_cache) tuple with the new vectors appended at the end.',
  'Each key/value vector is a list of floats of equal length.',
  $code$
def kv_append(k_cache: list, v_cache: list, new_k: list, new_v: list):
    # TODO: return (k_cache_with_new_k, v_cache_with_new_v)
    return (k_cache, v_cache)
  $code$, $code$
def kv_append(k_cache: list, v_cache: list, new_k: list, new_v: list):
    return (k_cache + [new_k], v_cache + [new_v])
  $code$, 'kv_append',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'function', 'function', 'kv_append', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000210', 'b1000000-0000-4000-8000-000000000103',
    'empty cache', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[],[],[1,2],[3,4]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1,2]],[[3,4]]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000211', 'b1000000-0000-4000-8000-000000000103',
    'existing entries', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[[0,0]],[[0,0]],[1,1],[2,2]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[0,0],[1,1]],[[0,0],[2,2]]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000212', 'b1000000-0000-4000-8000-000000000103',
    'preserves originals', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[[1,1,1]],[[9,9,9]],[2,2,2],[8,8,8]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1,1,1],[2,2,2]],[[9,9,9],[8,8,8]]]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 24. RoPE Rotation  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000104', 'Apply RoPE Rotation', 'apply-rope-rotation',
  'medium', 'transformer',
  'Apply a rotary position embedding (RoPE) rotation to a 1-D tensor of even length 2n. Split the vector into two halves x_first = x[:n] and x_second = x[n:]. For each pair i, compute rotated values: out[i] = x_first[i]*cos[i] - x_second[i]*sin[i] and out[i+n] = x_first[i]*sin[i] + x_second[i]*cos[i]. Use tensor ops (torch.stack / slicing) so the rotation is differentiable.',
  'x has even length 2..16. cos and sin are 1-D tensors of length n.',
  $code$
import torch

def rope_rotate(x: torch.Tensor, cos: torch.Tensor, sin: torch.Tensor) -> torch.Tensor:
    # x: (2n,) float32 ; cos, sin: (n,)
    # TODO: return a (2n,) tensor
    return x
  $code$, $code$
import torch

def rope_rotate(x: torch.Tensor, cos: torch.Tensor, sin: torch.Tensor) -> torch.Tensor:
    n = x.shape[0] // 2
    x_first = x[:n]
    x_second = x[n:]
    first = x_first * cos - x_second * sin
    second = x_first * sin + x_second * cos
    return torch.cat([first, second])
  $code$, 'rope_rotate',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'rope_rotate', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000213', 'b1000000-0000-4000-8000-000000000104',
    'zero angle', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[4],"dtype":"float32","values":[1,0,0,1],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[1,1],"requires_grad":false},{"type":"tensor","shape":[2],"dtype":"float32","values":[0,0],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[1,0,0,1]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000214', 'b1000000-0000-4000-8000-000000000104',
    'rotation', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[4],"dtype":"float32","values":[1,2,3,4],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[0.8,0.6],"requires_grad":false},{"type":"tensor","shape":[2],"dtype":"float32","values":[0.6,0.8],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[-1.0,-2.0,3.0,4.0]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000215', 'b1000000-0000-4000-8000-000000000104',
    'quarter rotation', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1],"dtype":"float32","values":[0.0],"requires_grad":false},{"type":"tensor","shape":[1],"dtype":"float32","values":[1.0],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[0.0,1.0]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000216', 'b1000000-0000-4000-8000-000000000104',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[4],"dtype":"float32","values":[1,2,3,4],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[0.8,0.6],"requires_grad":false},{"type":"tensor","shape":[2],"dtype":"float32","values":[0.6,0.8],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[1.4,1.4,0.2,-0.2]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 25. Top-k Sampling  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000105', 'Top-k Token Selection', 'top-k-token-selection',
  'medium', 'transformer',
  'Given a list of logits and an integer k, return the sorted list of indices of the k logits with the highest values. This is the vocabulary-filter step of top-k sampling: only the k most likely tokens are kept. Ties are broken by lower index first. The result must be a sorted (ascending) list of indices.',
  'k is 1..len(logits). Logits may contain any finite floats.',
  $code$
def topk_indices(logits: list, k: int) -> list:
    # TODO: return sorted list of indices of the k largest logits
    return []
  $code$, $code$
def topk_indices(logits: list, k: int) -> list:
    ordered = sorted(range(len(logits)), key=lambda i: (-logits[i], i))
    return sorted(ordered[:k])
  $code$, 'topk_indices',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'function', 'function', 'topk_indices', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000217', 'b1000000-0000-4000-8000-000000000105',
    'pick top 2 of 4', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[3,1,2,5],2],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0,3]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000218', 'b1000000-0000-4000-8000-000000000105',
    'all tokens', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[10,9,8,7],4],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0,1,2,3]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000219', 'b1000000-0000-4000-8000-000000000105',
    'tie lower index', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[5,5,5,5],2],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0,1]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000220', 'b1000000-0000-4000-8000-000000000105',
    'negative logits', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[-1,-5,-2,-8],1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 26. Multi-Head Attention  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000106', 'Multi-Head Attention', 'multi-head-attention',
  'hard', 'transformer',
  'Implement a single step of multi-head attention given pre-projected query, key, and value tensors of shape (heads, seq, head_dim). Compute for each head h: scores = (q[h] @ k[h].T) / sqrt(head_dim), apply softmax over the key axis, and output the weighted sum of values. Return the concatenated head outputs as a single (heads, seq, head_dim) tensor. All operations must use tensor ops so the result is differentiable.',
  'All heads have the same head_dim. seq >= 1.',
  $code$
import torch

def multi_head_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    # q, k, v: (heads, seq, head_dim) float32
    # TODO: return (heads, seq, head_dim) tensor
    return q
  $code$, $code$
import torch
import torch.nn.functional as F

def multi_head_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    d = q.shape[-1]
    scores = torch.matmul(q, k.transpose(-2, -1)) / (d ** 0.5)
    weights = F.softmax(scores, dim=-1)
    return torch.matmul(weights, v)
  $code$, 'multi_head_attention',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'multi_head_attention', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000221', 'b1000000-0000-4000-8000-000000000106',
    'single head identity', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[1,0]},{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[1,0]},{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[5,7]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[5,7]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000222', 'b1000000-0000-4000-8000-000000000106',
    'two tokens focus', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[1,2,2],"dtype":"float32","values":[1,0,0,1]},{"type":"tensor","shape":[1,2,2],"dtype":"float32","values":[1,0,0,1]},{"type":"tensor","shape":[1,2,2],"dtype":"float32","values":[10,0,0,20]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[1,2,2],"dtype":"float32","values":[6.697615,6.604769,3.302385,13.395231]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000223', 'b1000000-0000-4000-8000-000000000106',
    'two heads', 'value', 'shape', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[2,1,2],"dtype":"float32","values":[1,0,0,1]},{"type":"tensor","shape":[2,1,2],"dtype":"float32","values":[1,0,0,1]},{"type":"tensor","shape":[2,1,2],"dtype":"float32","values":[1,0,0,2]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"shape","shape":[2,1,2]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000224', 'b1000000-0000-4000-8000-000000000106',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[2,3],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg2","value":{"type":"tensor","shape":[1,1,2],"dtype":"float32","values":[1.0,1.0]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 27. Cross Attention  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000107', 'Cross Attention', 'cross-attention',
  'medium', 'transformer',
  'Implement cross attention where a query attends over a separate key/value memory. Given a query vector q (dim,) and memory key/value matrices (m, dim), compute scores = q @ K.T / sqrt(dim), softmax over the m memory slots, then return the weighted sum of V (a vector of length dim). This is used when a decoder token attends to encoder output.',
  'q has length dim; K and V are (m, dim) matrices.',
  $code$
import torch
import torch.nn.functional as F

def cross_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    # q: (dim,) ; k, v: (m, dim) float32
    # TODO: return a (dim,) tensor
    return q
  $code$, $code$
import torch
import torch.nn.functional as F

def cross_attention(q: torch.Tensor, k: torch.Tensor, v: torch.Tensor) -> torch.Tensor:
    d = q.shape[-1]
    scores = torch.matmul(q, k.transpose(-2, -1)) / (d ** 0.5)
    weights = F.softmax(scores, dim=-1)
    return torch.matmul(weights, v)
  $code$, 'cross_attention',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'cross_attention', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000225', 'b1000000-0000-4000-8000-000000000107',
    'attend single slot', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1,2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1,2],"dtype":"float32","values":[7,9],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[7.0,9.0]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000226', 'b1000000-0000-4000-8000-000000000107',
    'equal memory', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,1],"requires_grad":true},{"type":"tensor","shape":[2,2],"dtype":"float32","values":[1,0,0,1],"requires_grad":true},{"type":"tensor","shape":[2,2],"dtype":"float32","values":[10,0,0,20],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[5.0,10.0]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000227', 'b1000000-0000-4000-8000-000000000107',
    'output shape', 'value', 'shape', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[4],"dtype":"float32","values":[1,0,1,0],"requires_grad":true},{"type":"tensor","shape":[3,4],"dtype":"float32","values":[1,0,0,1,0,1,1,0,1,1,0,0],"requires_grad":true},{"type":"tensor","shape":[3,4],"dtype":"float32","values":[1,0,0,1,0,1,1,0,1,1,0,0],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"shape","shape":[4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000228', 'b1000000-0000-4000-8000-000000000107',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1,2],"dtype":"float32","values":[1,0],"requires_grad":true},{"type":"tensor","shape":[1,2],"dtype":"float32","values":[7,9],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg2","value":{"type":"tensor","shape":[1,2],"dtype":"float32","values":[1.0,1.0]}}]}$data$,
    $data${}$data$
  )
;

-- ===========================================================================
-- RL PROBLEMS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 28. Discounted Returns  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000108', 'Compute Discounted Returns', 'discounted-returns',
  'easy', 'rl',
  'Given a list of rewards and a discount factor gamma, compute the discounted return G_t = reward_t + gamma * G_{t+1} for each time step (the final step has G = reward). Return the list of returns. Round each value to six decimal places.',
  'gamma is in [0, 1]. rewards is a non-empty list of floats.',
  $code$
def discounted_returns(rewards: list, gamma: float) -> list:
    # TODO: return a list of discounted returns
    return []
  $code$, $code$
def discounted_returns(rewards: list, gamma: float) -> list:
    out = [0.0] * len(rewards)
    acc = 0.0
    for i in range(len(rewards) - 1, -1, -1):
        acc = rewards[i] + gamma * acc
        out[i] = round(acc, 6)
    return out
  $code$, 'discounted_returns',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'discounted_returns', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000229', 'b1000000-0000-4000-8000-000000000108',
    'unit rewards', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,1,1],0.9],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[2.71,1.9,1.0]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000230', 'b1000000-0000-4000-8000-000000000108',
    'no discount', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[1,0,2],1.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[3.0,2.0,2.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000231', 'b1000000-0000-4000-8000-000000000108',
    'zero discount', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[3,-1,5],0.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[3.0,-1.0,5.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000232', 'b1000000-0000-4000-8000-000000000108',
    'single step', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[-2.5],0.9],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[-2.5]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 29. GAE  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000109', 'Generalized Advantage Estimation', 'generalized-advantage-estimation-torch',
  'hard', 'rl',
  'Compute the Generalized Advantage Estimate (GAE) for a trajectory. Given rewards r[0..T-1], value estimates v[0..T] (one extra terminal value), discount gamma and trace-decay lambda, compute delta_t = r_t + gamma * v[t+1] - v[t], then accumulate advantages backward: A_t = delta_t + (gamma * lambda) * A_{t+1}. Return the list of advantages for t = 0..T-1, rounded to six decimals.',
  'len(v) == len(r) + 1. gamma, lambda are in [0, 1].',
  $code$
def gae(rewards: list, values: list, gamma: float, lam: float) -> list:
    # TODO: return a list of advantages
    return []
  $code$, $code$
def gae(rewards: list, values: list, gamma: float, lam: float) -> list:
    t = len(rewards)
    adv = [0.0] * t
    acc = 0.0
    for i in range(t - 1, -1, -1):
        delta = rewards[i] + gamma * values[i + 1] - values[i]
        acc = delta + gamma * lam * acc
        adv[i] = round(acc, 6)
    return adv
  $code$, 'gae',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'gae', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000233', 'b1000000-0000-4000-8000-000000000109',
    'unit bootstrap', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,0,2],[0,0,1,0],1.0,1.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[3.0,2.0,1.0]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000234', 'b1000000-0000-4000-8000-000000000109',
    'partial trace', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[0,1],[0,0,0],0.9,0.5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.45,1.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000235', 'b1000000-0000-4000-8000-000000000109',
    'terminal reward', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[0,0,1],[0,0,0,0],1.0,0.5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.25,0.5,1.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 30. PPO Ratio  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000110', 'PPO Probability Ratio', 'ppo-probability-ratio',
  'easy', 'rl',
  'Compute the importance-sampling ratio used in PPO: ratio = new_prob / old_prob. This compares the new policy probability of an action to the old policy probability. Return the ratio rounded to six decimal places. Both probabilities are strictly positive.',
  'new_prob and old_prob are floats in (0, 1].',
  $code$
def ppo_ratio(new_prob: float, old_prob: float) -> float:
    # TODO: return new_prob / old_prob
    return 0.0
  $code$, $code$
def ppo_ratio(new_prob: float, old_prob: float) -> float:
    return round(new_prob / old_prob, 6)
  $code$, 'ppo_ratio',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'ppo_ratio', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000236', 'b1000000-0000-4000-8000-000000000110',
    'increase', 'example', 'basic', false, 1.0, 0,
    $data${"args":[0.6,0.5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":1.2}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000237', 'b1000000-0000-4000-8000-000000000110',
    'decrease', 'value', 'basic', false, 1.0, 1,
    $data${"args":[0.4,0.8],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.5}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000238', 'b1000000-0000-4000-8000-000000000110',
    'same probability', 'value', 'edge', true, 1.0, 2,
    $data${"args":[0.25,0.25],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":1.0}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 31. PPO Clip Loss  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000111', 'PPO Clipped Objective', 'ppo-clipped-objective-torch',
  'medium', 'rl',
  'Implement the PPO clipped surrogate objective (negative, for gradient descent). Given ratio tensor (batch,), advantages (batch,), and clip epsilon, compute per-item surrogate = min(ratio * adv, clip(ratio, 1-eps, 1+eps) * adv), then return the NEGATIVE mean so that minimizing the output improves the policy. Must be differentiable and operate on tensors.',
  'ratio and adv are 1-D float32 tensors of equal length 1..8.',
  $code$
import torch

def ppo_loss(ratio: torch.Tensor, adv: torch.Tensor, eps: float) -> torch.Tensor:
    # ratio, adv: (B,) float32
    # TODO: return a scalar tensor (the negative mean clipped objective)
    return torch.tensor(0.0, dtype=torch.float32)
  $code$, $code$
import torch

def ppo_loss(ratio: torch.Tensor, adv: torch.Tensor, eps: float) -> torch.Tensor:
    clipped = torch.clamp(ratio, 1.0 - eps, 1.0 + eps)
    surrogate = torch.min(ratio * adv, clipped * adv)
    return -surrogate.mean()
  $code$, 'ppo_loss',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'ppo_loss', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000239', 'b1000000-0000-4000-8000-000000000111',
    'unclipped mean', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1.0,1.0],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[1.0,-1.0],"requires_grad":false}],"kwargs":{"eps":0.2},"seed":null}$data$,
    $data${"kind":"value","value":0.0}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000240', 'b1000000-0000-4000-8000-000000000111',
    'clipped ratio', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[1],"dtype":"float32","values":[1.5],"requires_grad":true},{"type":"tensor","shape":[1],"dtype":"float32","values":[1.0],"requires_grad":false}],"kwargs":{"eps":0.2},"seed":null}$data$,
    $data${"kind":"value","value":-1.2}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000241', 'b1000000-0000-4000-8000-000000000111',
    'negative advantage', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[1],"dtype":"float32","values":[1.5],"requires_grad":true},{"type":"tensor","shape":[1],"dtype":"float32","values":[-1.0],"requires_grad":false}],"kwargs":{"eps":0.2},"seed":null}$data$,
    $data${"kind":"value","value":1.5}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000242', 'b1000000-0000-4000-8000-000000000111',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[0.9,1.1],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[1.0,-1.0],"requires_grad":false}],"kwargs":{"eps":0.2},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[-0.5,0.5]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 32. GRPO Group Advantage  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000112', 'GRPO Group Advantage', 'grpo-group-advantage',
  'medium', 'rl',
  'Normalize a group of reward scores into advantages for GRPO. Given a list of scores, subtract the group mean and divide by the group standard deviation (population, sqrt of mean squared deviation). Round each advantage to six decimal places. If the standard deviation is zero, return a list of zeros.',
  'scores is a non-empty list of floats.',
  $code$
import math

def group_advantage(scores: list) -> list:
    # TODO: return normalized advantages
    return []
  $code$, $code$
import math

def group_advantage(scores: list) -> list:
    mean = sum(scores) / len(scores)
    var = sum((s - mean) ** 2 for s in scores) / len(scores)
    std = math.sqrt(var)
    if std == 0:
        return [0.0] * len(scores)
    return [round((s - mean) / std, 6) for s in scores]
  $code$, 'group_advantage',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'group_advantage', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000243', 'b1000000-0000-4000-8000-000000000112',
    'linear group', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,2,3,4]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[-1.341641,-0.447214,0.447214,1.341641]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000244', 'b1000000-0000-4000-8000-000000000112',
    'two values', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[3,5]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[-1.0,1.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000245', 'b1000000-0000-4000-8000-000000000112',
    'zero variance', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[7,7,7]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,0.0,0.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000246', 'b1000000-0000-4000-8000-000000000112',
    'negative spread', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[10,0,5]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1.224745,-1.224745,0.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 33. KL Penalty  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000113', 'Approximate KL Penalty', 'approximate-kl-penalty',
  'medium', 'rl',
  'Estimate the KL divergence between a new policy and a reference policy using the log-probability lists logp (new) and logq (reference). Use the approximation: kl = mean( exp(logq - logp) * ((logq - logp) - 1) + 1 ). This is a biased low-variance estimator commonly used in RLHF/GRPO to penalize policy drift. Return the scalar, rounded to six decimals.',
  'logp and logq are lists of equal length of finite floats.',
  $code$
import math

def kl_penalty(logp: list, logq: list) -> float:
    # TODO: return the approximate KL divergence
    return 0.0
  $code$, $code$
import math

def kl_penalty(logp: list, logq: list) -> float:
    total = 0.0
    for p, q in zip(logp, logq):
        diff = q - p
        ratio = math.exp(diff)
        total += ratio * (diff - 1) + 1
    return round(total / len(logp), 6)
  $code$, 'kl_penalty',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'kl_penalty', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000247', 'b1000000-0000-4000-8000-000000000113',
    'identical policies', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[-1,-2],[-1,-2]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.0}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000248', 'b1000000-0000-4000-8000-000000000113',
    'small drift', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[-1,-2],[-1.2,-1.5]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.096581}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000249', 'b1000000-0000-4000-8000-000000000113',
    'larger drift', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[-1.0,-2.0],[-2.0,-3.0]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.264241}$data$,
    $data${}$data$
  )
;

-- ===========================================================================
-- ROBOTICS PROBLEMS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 34. Euler to Quaternion  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000114', 'Euler Angles to Quaternion', 'euler-to-quaternion',
  'medium', 'robotics',
  'Convert a roll-pitch-yaw (ZYX intrinsic) Euler angle triple into a unit quaternion (w, x, y, z). Use the standard half-angle formulas: w = cr*cp*cy + sr*sp*sy, x = sr*cp*cy - cr*sp*sy, y = cr*sp*cy + sr*cp*sy, z = cr*cp*sy - sr*sp*cy, where c*/s* are cos/sin of the half-angles. Input is a 3-D tensor; return a 4-D tensor.',
  'euler is a float32 tensor of shape (3,) in radians.',
  $code$
import torch

def euler_to_quat(euler: torch.Tensor) -> torch.Tensor:
    # euler: (3,) = (roll, pitch, yaw) radians
    # TODO: return a (4,) tensor (w, x, y, z)
    return torch.zeros(4)
  $code$, $code$
import torch

def euler_to_quat(euler: torch.Tensor) -> torch.Tensor:
    r, p, y = euler[0], euler[1], euler[2]
    cr, cp, cy = torch.cos(r / 2), torch.cos(p / 2), torch.cos(y / 2)
    sr, sp, sy = torch.sin(r / 2), torch.sin(p / 2), torch.sin(y / 2)
    w = cr * cp * cy + sr * sp * sy
    x = sr * cp * cy - cr * sp * sy
    y = cr * sp * cy + sr * cp * sy
    z = cr * cp * sy - sr * sp * cy
    return torch.stack([w, x, y, z])
  $code$, 'euler_to_quat',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'euler_to_quat', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000250', 'b1000000-0000-4000-8000-000000000114',
    'zero rotation', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[0,0,0],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[1.0,0.0,0.0,0.0]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000251', 'b1000000-0000-4000-8000-000000000114',
    'yaw 90 degrees', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[0,0,1.570796],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[0.707107,0.0,0.0,0.707107]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000252', 'b1000000-0000-4000-8000-000000000114',
    'roll 90 degrees', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[1.570796,0,0],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[4],"dtype":"float32","values":[0.707107,0.707107,0.0,0.0]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000253', 'b1000000-0000-4000-8000-000000000114',
    'unit norm', 'value', 'shape', true, 1.0, 3,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[0.5,-0.5,0.3],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"shape","shape":[4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000254', 'b1000000-0000-4000-8000-000000000114',
    'differentiable', 'gradient', 'gradient', true, 1.5, 4,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[0.3,0.2,0.1],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[0.384013,0.336594,0.493314]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 35. Quaternion Multiply  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000115', 'Quaternion Multiplication', 'quaternion-multiply',
  'medium', 'robotics',
  'Multiply two quaternions a and b, each represented as [w, x, y, z]. The product (Hamilton product) represents the composition of the two rotations. Compute: w = aw*bw - ax*bx - ay*by - az*bz, x = aw*bx + ax*bw + ay*bz - az*by, y = aw*by - ax*bz + ay*bw + az*bx, z = aw*bz + ax*by - ay*bx + az*bw. Return [w, x, y, z].',
  'Each input is a length-4 list of floats.',
  $code$
def quat_multiply(a: list, b: list) -> list:
    # a, b: [w, x, y, z]
    # TODO: return [w, x, y, z]
    return [0.0, 0.0, 0.0, 0.0]
  $code$, $code$
def quat_multiply(a: list, b: list) -> list:
    aw, ax, ay, az = a
    bw, bx, by, bz = b
    w = aw * bw - ax * bx - ay * by - az * bz
    x = aw * bx + ax * bw + ay * bz - az * by
    y = aw * by - ax * bz + ay * bw + az * bx
    z = aw * bz + ax * by - ay * bx + az * bw
    return [round(v, 6) for v in (w, x, y, z)]
  $code$, 'quat_multiply',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'quat_multiply', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000255', 'b1000000-0000-4000-8000-000000000115',
    'identity times rotation', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,0,0,0],[0,1,0,0]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,1.0,0.0,0.0]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000256', 'b1000000-0000-4000-8000-000000000115',
    'double 90 deg rotation', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[0.707107,0,0,0.707107],[0.707107,0,0,0.707107]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,0.0,0.0,1.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000257', 'b1000000-0000-4000-8000-000000000115',
    'inverse composition', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[1,0,0,0],[0,0,1,0]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,0.0,1.0,0.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 36. SE(3) Point Transform  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000116', 'SE(3) Point Transform', 'se3-point-transform',
  'easy', 'robotics',
  'Transform a 3-D point by an SE(3) pose (rotation matrix R and translation t). Compute p'' = R @ p + t and return the transformed point. Use numpy for the linear algebra.',
  'R is a 3x3 rotation matrix; t and p are length-3 vectors.',
  $code$
import numpy as np

def se3_transform(R: np.ndarray, t: np.ndarray, p: np.ndarray) -> np.ndarray:
    # R: (3,3), t: (3,), p: (3,)
    # TODO: return a (3,) transformed point
    return p
  $code$, $code$
import numpy as np

def se3_transform(R: np.ndarray, t: np.ndarray, p: np.ndarray) -> np.ndarray:
    return (R @ p + t).astype(np.float64)
  $code$, 'se3_transform',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'se3_transform', 'numpy', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000258', 'b1000000-0000-4000-8000-000000000116',
    'pure translation', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,2,3]},{"type":"tensor","shape":[3],"dtype":"float64","values":[4,5,6]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[5.0,7.0,9.0]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000259', 'b1000000-0000-4000-8000-000000000116',
    '90 degree z-rotation', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,0]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,1.0,0.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000260', 'b1000000-0000-4000-8000-000000000116',
    'rotation and translation', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,5]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,1.0,5.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 37. Compose SE(3)  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000117', 'Compose SE(3) Poses', 'compose-se3',
  'medium', 'robotics',
  'Compose two SE(3) poses into one: given pose A = (R1, t1) applied first, then pose B = (R2, t2), the composed pose is C = A * B with R = R1 @ R2 and t = t1 + R1 @ t2. Return the tuple (R, t). Use numpy.',
  'R1 and R2 are 3x3 rotation matrices; t1 and t2 are length-3 vectors.',
  $code$
import numpy as np

def compose_se3(R1: np.ndarray, t1: np.ndarray, R2: np.ndarray, t2: np.ndarray):
    # TODO: return (R, t)
    return (R1, t1)
  $code$, $code$
import numpy as np

def compose_se3(R1: np.ndarray, t1: np.ndarray, R2: np.ndarray, t2: np.ndarray):
    R = R1 @ R2
    t = t1 + R1 @ t2
    return (R.astype(np.float64), t.astype(np.float64))
  $code$, 'compose_se3',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'compose_se3', 'numpy', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000261', 'b1000000-0000-4000-8000-000000000117',
    'identity composition', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,0]},{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,2,3]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[0.0,-1.0,0.0],[1.0,0.0,0.0],[0.0,0.0,1.0]],[1.0,2.0,3.0]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000262', 'b1000000-0000-4000-8000-000000000117',
    'translation composition', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,0,0]},{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[2,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1.0,0.0,0.0],[0.0,1.0,0.0],[0.0,0.0,1.0]],[3.0,0.0,0.0]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000263', 'b1000000-0000-4000-8000-000000000117',
    'rotation then translation', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,0]},{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,1,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[0.0,-1.0,0.0],[1.0,0.0,0.0],[0.0,0.0,1.0]],[-1.0,0.0,0.0]]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 38. Linear Trajectory Interpolation  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000118', 'Linear Trajectory Interpolation', 'linear-trajectory-interpolation',
  'easy', 'robotics',
  'Linearly interpolate between two points a and b to produce n evenly spaced points (inclusive of both endpoints). For i in 0..n-1, point_i = a + (i/(n-1)) * (b - a). Return a list of n points. Handle n == 1 by returning just [a].',
  'a and b are equal-length lists of floats; n >= 1.',
  $code$
def interpolate(a: list, b: list, n: int) -> list:
    # TODO: return a list of n interpolated points
    return []
  $code$, $code$
def interpolate(a: list, b: list, n: int) -> list:
    if n == 1:
        return [a]
    return [[round(a[i] + (k / (n - 1)) * (b[i] - a[i]), 6) for i in range(len(a))]
            for k in range(n)]
  $code$, 'interpolate',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'interpolate', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000264', 'b1000000-0000-4000-8000-000000000118',
    'midpoint', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[0,0],[2,4],3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[0.0,0.0],[1.0,2.0],[2.0,4.0]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000265', 'b1000000-0000-4000-8000-000000000118',
    'two points', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[1,1],[3,3],2],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1.0,1.0],[3.0,3.0]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000266', 'b1000000-0000-4000-8000-000000000118',
    'single point', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[5,6],[7,8],1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[5.0,6.0]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000267', 'b1000000-0000-4000-8000-000000000118',
    '3d five points', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[0,0,0],[0,0,10],5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[0.0,0.0,0.0],[0.0,0.0,2.5],[0.0,0.0,5.0],[0.0,0.0,7.5],[0.0,0.0,10.0]]}$data$,
    $data${}$data$
  )
;

-- ===========================================================================
-- DIFFUSION PROBLEMS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 39. Linear Beta Schedule  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000119', 'Linear Beta Schedule', 'linear-beta-schedule',
  'easy', 'diffusion',
  'Build a linear noise schedule for a DDPM diffusion process. Given total timesteps T, a start beta and an end beta, return a list of T values beta_t = beta_start + (t / T) * (beta_end - beta_start) for t = 1..T (1-indexed), each rounded to six decimal places.',
  'T is an integer 2..64. beta_start and beta_end are floats in (0, 1).',
  $code$
def linear_beta_schedule(T: int, beta_start: float, beta_end: float) -> list:
    # TODO: return a list of T beta values
    return []
  $code$, $code$
def linear_beta_schedule(T: int, beta_start: float, beta_end: float) -> list:
    return [round(beta_start + (t / T) * (beta_end - beta_start), 6) for t in range(1, T + 1)]
  $code$, 'linear_beta_schedule',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'linear_beta_schedule', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000268', 'b1000000-0000-4000-8000-000000000119',
    'two steps', 'example', 'basic', false, 1.0, 0,
    $data${"args":[2,0.0001,0.02],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.01005,0.02]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000269', 'b1000000-0000-4000-8000-000000000119',
    'five steps', 'value', 'basic', false, 1.0, 1,
    $data${"args":[5,0.0001,0.02],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.00408,0.00806,0.01204,0.01602,0.02]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000270', 'b1000000-0000-4000-8000-000000000119',
    'monotonic and clamped', 'value', 'edge', true, 1.0, 2,
    $data${"args":[4,0.0,1.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.25,0.5,0.75,1.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 40. DDPM Forward Noise  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000120', 'DDPM Forward Diffusion', 'ddpm-forward-diffusion',
  'medium', 'diffusion',
  'Apply the DDPM forward (noising) process at a given timestep. Given a clean sample x0, the cumulative product alpha_bar at step t, and a noise tensor eps, compute x_t = sqrt(alpha_bar_t) * x0 + sqrt(1 - alpha_bar_t) * eps. Return the noised tensor. Must be differentiable with respect to x0.',
  'x0 and eps are equal-length float32 tensors (batch of scalars). alpha_bar_t is a float in (0, 1).',
  $code$
import torch

def ddpm_forward_noise(x0: torch.Tensor, alpha_bar_t: float, eps: torch.Tensor) -> torch.Tensor:
    # x0, eps: (B,) float32
    # TODO: return a (B,) noised tensor
    return x0
  $code$, $code$
import torch

def ddpm_forward_noise(x0: torch.Tensor, alpha_bar_t: float, eps: torch.Tensor) -> torch.Tensor:
    return torch.sqrt(torch.tensor(alpha_bar_t, dtype=x0.dtype)) * x0 + \
           torch.sqrt(torch.tensor(1.0 - alpha_bar_t, dtype=x0.dtype)) * eps
  $code$, 'ddpm_forward_noise',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'ddpm_forward_noise', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000271', 'b1000000-0000-4000-8000-000000000120',
    'noiseless', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,0],"requires_grad":true},0.81,{"type":"tensor","shape":[2],"dtype":"float32","values":[0.1,0.2],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[0.943589,0.087178]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000272', 'b1000000-0000-4000-8000-000000000120',
    'pure noise', 'value', 'edge', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,0],"requires_grad":true},0.0001,{"type":"tensor","shape":[2],"dtype":"float32","values":[3,4],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[3.00985,3.9998]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000273', 'b1000000-0000-4000-8000-000000000120',
    'shape check', 'value', 'shape', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[4],"dtype":"float32","values":[1,2,3,4],"requires_grad":true},0.5,{"type":"tensor","shape":[4],"dtype":"float32","values":[0,0,0,0],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"shape","shape":[4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000274', 'b1000000-0000-4000-8000-000000000120',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,0],"requires_grad":true},0.729,{"type":"tensor","shape":[2],"dtype":"float32","values":[0.1,0.2],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[0.853815,0.853815]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 41. Predict x0  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000121', 'Predict Clean Sample x0', 'predict-x0',
  'medium', 'diffusion',
  'Recover the clean sample from a noised sample given a predicted noise. Given the noised value x_t, the cumulative alpha_bar at step t, and the predicted noise eps_pred, compute x0_pred = (x_t - sqrt(1 - alpha_bar) * eps_pred) / sqrt(alpha_bar). This is the x0-prediction parameterization used by DDPM/DDIM samplers. Return the scalar tensor. Must be differentiable with respect to x_t.',
  'x_t and eps_pred are scalars (0-dim float32 tensors); alpha_bar is a float in (0, 1).',
  $code$
import torch

def predict_x0(x_t: torch.Tensor, alpha_bar: float, eps_pred: torch.Tensor) -> torch.Tensor:
    # x_t, eps_pred: scalar tensors
    # TODO: return a scalar tensor
    return x_t
  $code$, $code$
import torch

def predict_x0(x_t: torch.Tensor, alpha_bar: float, eps_pred: torch.Tensor) -> torch.Tensor:
    ab = torch.tensor(alpha_bar, dtype=x_t.dtype)
    return (x_t - torch.sqrt(1.0 - ab) * eps_pred) / torch.sqrt(ab)
  $code$, 'predict_x0',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'predict_x0', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000275', 'b1000000-0000-4000-8000-000000000121',
    'basic recovery', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[],"dtype":"float32","values":[0.5],"requires_grad":true},0.81,{"type":"tensor","shape":[],"dtype":"float32","values":[0.1],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[],"dtype":"float32","values":[0.507123]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000276', 'b1000000-0000-4000-8000-000000000121',
    'no noise', 'value', 'edge', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[],"dtype":"float32","values":[1.0],"requires_grad":true},1.0,{"type":"tensor","shape":[],"dtype":"float32","values":[0.0],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[],"dtype":"float32","values":[1.0]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000277', 'b1000000-0000-4000-8000-000000000121',
    'fully noised', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[],"dtype":"float32","values":[2.0],"requires_grad":true},0.01,{"type":"tensor","shape":[],"dtype":"float32","values":[1.0],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[],"dtype":"float32","values":[10.050125]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000278', 'b1000000-0000-4000-8000-000000000121',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[],"dtype":"float32","values":[0.5],"requires_grad":true},0.81,{"type":"tensor","shape":[],"dtype":"float32","values":[0.1],"requires_grad":false}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[],"dtype":"float32","values":[1.111111]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 42. Flow Matching Target  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000122', 'Flow Matching Target', 'flow-matching-target',
  'easy', 'diffusion',
  'Compute the flow-matching (conditional flow) regression target. For a straight-line path from a noise sample x0 to a clean sample x1, the target velocity at any point on the path is v = x1 - x0. Return this vector. Must be differentiable with respect to both x1 and x0.',
  'x0 and x1 are equal-length float32 tensors.',
  $code$
import torch

def flow_matching_target(x0: torch.Tensor, x1: torch.Tensor) -> torch.Tensor:
    # x0, x1: (D,) float32
    # TODO: return a (D,) velocity target
    return x0
  $code$, $code$
import torch

def flow_matching_target(x0: torch.Tensor, x1: torch.Tensor) -> torch.Tensor:
    return x1 - x0
  $code$, 'flow_matching_target',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'flow_matching_target', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000279', 'b1000000-0000-4000-8000-000000000122',
    'from origin', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[0,0],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[2,3],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[2.0,3.0]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000280', 'b1000000-0000-4000-8000-000000000122',
    'offset noise', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,1],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[4,2],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[3.0,1.0]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000281', 'b1000000-0000-4000-8000-000000000122',
    'differentiable x1', 'gradient', 'gradient', true, 1.5, 2,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[0,0],"requires_grad":true},{"type":"tensor","shape":[2],"dtype":"float32","values":[2,3],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg1","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[1.0,1.0]}}]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 43. Euler ODE Step  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000123', 'Euler ODE Step', 'euler-ode-step',
  'easy', 'diffusion',
  'Take a single Euler integration step of an ODE used by diffusion samplers. Given a current state x, a velocity field v, and a step size dt, compute x_next = x + dt * v. Return the updated state, rounded to six decimal places.',
  'x and v are equal-length lists of floats; dt > 0.',
  $code$
def euler_step(x: list, v: list, dt: float) -> list:
    # TODO: return x + dt * v
    return []
  $code$, $code$
def euler_step(x: list, v: list, dt: float) -> list:
    return [round(a + dt * b, 6) for a, b in zip(x, v)]
  $code$, 'euler_step',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'euler_step', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000282', 'b1000000-0000-4000-8000-000000000123',
    'positive drift', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[0,1],[1,1],0.1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.1,1.1]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000283', 'b1000000-0000-4000-8000-000000000123',
    'large step', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[1,2],[1,-1],0.5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1.5,1.5]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000284', 'b1000000-0000-4000-8000-000000000123',
    'decay step', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[1,1],[-0.5,-0.25],1.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.5,0.75]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 44. Classifier-Free Guidance  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000124', 'Classifier-Free Guidance', 'classifier-free-guidance',
  'easy', 'diffusion',
  'Combine an unconditional and a conditional prediction with classifier-free guidance. Given the unconditional output v_uncond, the conditional output v_cond, and a guidance weight w, compute v = v_uncond + w * (v_cond - v_uncond). Return the guided vector, rounded to six decimal places.',
  'v_uncond and v_cond are equal-length lists of floats; w >= 0.',
  $code$
def cfg_combine(v_uncond: list, v_cond: list, w: float) -> list:
    # TODO: return v_uncond + w * (v_cond - v_uncond)
    return []
  $code$, $code$
def cfg_combine(v_uncond: list, v_cond: list, w: float) -> list:
    return [round(a + w * (b - a), 6) for a, b in zip(v_uncond, v_cond)]
  $code$, 'cfg_combine',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'cfg_combine', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000285', 'b1000000-0000-4000-8000-000000000124',
    'no guidance', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,0],[2,1],0.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1.0,0.0]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000286', 'b1000000-0000-4000-8000-000000000124',
    'standard weight', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[1,0],[2,1],2.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[3.0,2.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000287', 'b1000000-0000-4000-8000-000000000124',
    'strong guidance', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[1,0],[2,1],3.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[4.0,3.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 45. Diffusion Action Chunk Reshape  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000125', 'Diffusion Action Chunk Reshape', 'diffusion-action-chunk-reshape',
  'easy', 'diffusion',
  'Flatten a (T, D) action chunk into a 1-D vector of length T*D, preserving row-major (time-major) order. Diffusion policies predict a flattened action chunk; this helper reshapes it back into a (T, D) table. Return the flattened list.',
  'actions is a T x D table of floats.',
  $code$
def flatten_action_chunk(actions: list) -> list:
    # TODO: return a flattened 1-D list
    return []
  $code$, $code$
def flatten_action_chunk(actions: list) -> list:
    return [v for row in actions for v in row]
  $code$, 'flatten_action_chunk',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'function', 'function', 'flatten_action_chunk', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000288', 'b1000000-0000-4000-8000-000000000125',
    'small chunk', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[[1,2],[3,4]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,2,3,4]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000289', 'b1000000-0000-4000-8000-000000000125',
    'single row', 'value', 'edge', false, 1.0, 1,
    $data${"args":[[[7,8,9]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[7,8,9]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000290', 'b1000000-0000-4000-8000-000000000125',
    'three rows', 'value', 'basic', true, 1.0, 2,
    $data${"args":[[[1,0],[0,1],[1,1]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,0,0,1,1,1]}$data$,
    $data${}$data$
  )
;

-- ===========================================================================
-- ROBOT LEARNING PROBLEMS
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- 46. Replay Buffer  (class, python)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000126', 'Replay Buffer', 'replay-buffer',
  'medium', 'robot-learning',
  'Implement a minimal replay buffer as a class with an add(transition) method that appends a transition and a sample(n) method that returns the last n transitions (in insertion order, most recent last). If fewer than n transitions exist, return all of them. The buffer stores transitions in a Python list.',
  'n is a non-negative integer.',
  $code$class ReplayBuffer:
    def __init__(self, initial=None):
        self._transitions = list(initial) if initial else []

    def add(self, transition):
        # TODO: append transition
        pass

    def sample(self, n):
        # TODO: return the last n transitions
        return []
  $code$, $code$class ReplayBuffer:
    def __init__(self, initial=None):
        self._transitions = list(initial) if initial else []

    def add(self, transition):
        self._transitions.append(transition)

    def sample(self, n):
        if n == 0:
            return []
        return self._transitions[-n:]
  $code$, 'ReplayBuffer',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'class', 'class', 'ReplayBuffer', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000291', 'b1000000-0000-4000-8000-000000000126',
    'single add', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,2]],"kwargs":{},"seed":null,"construct":{"args":[],"kwargs":{}},"method":"add"}$data$,
    $data${"kind":"value","value":null}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000292', 'b1000000-0000-4000-8000-000000000126',
    'sample last n', 'value', 'basic', false, 1.0, 1,
    $data${"args":[2],"kwargs":{},"seed":null,"construct":{"args":[[[1,2],[3,4],[5,6]]],"kwargs":{}},"method":"sample"}$data$,
    $data${"kind":"value","value":[[3,4],[5,6]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000293', 'b1000000-0000-4000-8000-000000000126',
    'fewer than n returns all', 'value', 'edge', true, 1.0, 2,
    $data${"args":[5],"kwargs":{},"seed":null,"construct":{"args":[[[1,2]]],"kwargs":{}},"method":"sample"}$data$,
    $data${"kind":"value","value":[[1,2]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000294', 'b1000000-0000-4000-8000-000000000126',
    'zero sample', 'value', 'edge', true, 1.0, 3,
    $data${"args":[0],"kwargs":{},"seed":null,"construct":{"args":[],"kwargs":{}},"method":"sample"}$data$,
    $data${"kind":"value","value":[]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 47. Action Chunking  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000127', 'Action Chunking', 'action-chunking',
  'easy', 'robot-learning',
  'Extract an action chunk (a fixed window of future actions) starting at the current step. Given the full trajectory of actions and a chunk length h, return the first h actions if the trajectory has at least h remaining actions, otherwise return all remaining actions (a shorter chunk).',
  'actions is a non-empty list; h is a positive integer.',
  $code$
def action_chunk(actions: list, h: int) -> list:
    # TODO: return an action chunk of length min(h, len(actions))
    return []
  $code$, $code$
def action_chunk(actions: list, h: int) -> list:
    return actions[:h]
  $code$, 'action_chunk',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'function', 'function', 'action_chunk', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000316', 'b1000000-0000-4000-8000-000000000127',
    'full chunk', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,2,3,4,5],3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,2,3]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000295', 'b1000000-0000-4000-8000-000000000127',
    'truncated chunk', 'value', 'edge', false, 1.0, 1,
    $data${"args":[[1,2],5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,2]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000296', 'b1000000-0000-4000-8000-000000000127',
    'unit chunk', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[4,5,6],1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[4]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 48. Normalize Robot Actions  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000128', 'Normalize Robot Actions', 'normalize-robot-actions',
  'medium', 'robot-learning',
  'Normalize a batch of robot actions per dimension. Given an array of shape (T, D) representing T action vectors each of dimension D, standardize each dimension d independently across the T rows: subtract the column mean and divide by the column standard deviation (population). If a column has zero standard deviation, leave that column unchanged (all values map to 0.0). Use numpy.',
  'actions is a (T, D) array with T >= 1, D >= 1.',
  $code$
import numpy as np

def normalize_actions(actions: np.ndarray) -> np.ndarray:
    # actions: (T, D)
    # TODO: return a (T, D) normalized array
    return actions
  $code$, $code$
import numpy as np

def normalize_actions(actions: np.ndarray) -> np.ndarray:
    mean = actions.mean(axis=0)
    var = ((actions - mean) ** 2).mean(axis=0)
    std = np.sqrt(var)
    std[std == 0] = 1.0
    return (actions - mean) / std
  $code$, 'normalize_actions',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'normalize_actions', 'numpy', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000297', 'b1000000-0000-4000-8000-000000000128',
    'linear ramp', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[3,2],"dtype":"float64","values":[1,2,2,3,3,4]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[-1.224745,-1.224745],[0.0,0.0],[1.224745,1.224745]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000298', 'b1000000-0000-4000-8000-000000000128',
    'two samples', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[2,2],"dtype":"float64","values":[3,5,7,1]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[-1.0,1.0],[1.0,-1.0]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000299', 'b1000000-0000-4000-8000-000000000128',
    'constant column', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[3,2],"dtype":"float64","values":[4,1,4,2,4,3]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[0.0,-1.224745],[0.0,0.0],[0.0,1.224745]]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 49. Mask Padded Actions  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000129', 'Mask Padded Actions', 'mask-padded-actions',
  'medium', 'robot-learning',
  'Zero-out the padding in a batched action tensor. Given a batch of padded actions of shape (B, T, D) and the valid sequence lengths lens (B,), set every element at time step t >= lens[b] for sample b to 0.0 (masking the padded positions), leaving valid positions unchanged. Use numpy.',
  'Each lens[b] is in 1..T. actions is a (B, T, D) array.',
  $code$
import numpy as np

def mask_padded(actions: np.ndarray, lens: np.ndarray) -> np.ndarray:
    # actions: (B, T, D) ; lens: (B,)
    # TODO: return a (B, T, D) masked array
    return actions
  $code$, $code$
import numpy as np

def mask_padded(actions: np.ndarray, lens: np.ndarray) -> np.ndarray:
    B, T, D = actions.shape
    time = np.arange(T)[None, :, None]
    valid = time < lens[:, None, None]
    return np.where(valid, actions, 0.0)
  $code$, 'mask_padded',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'mask_padded', 'numpy', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000300', 'b1000000-0000-4000-8000-000000000129',
    'no padding', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[2,2,2],"dtype":"float64","values":[1,2,3,4,5,6,7,8]},{"type":"tensor","shape":[2],"dtype":"int64","values":[2,2]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1.0,2.0],[3.0,4.0]],[[5.0,6.0],[7.0,8.0]]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000301', 'b1000000-0000-4000-8000-000000000129',
    'masked second step', 'value', 'basic', false, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[2,2,2],"dtype":"float64","values":[1,2,3,4,5,6,7,8]},{"type":"tensor","shape":[2],"dtype":"int64","values":[2,1]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1.0,2.0],[3.0,4.0]],[[5.0,6.0],[0.0,0.0]]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000302', 'b1000000-0000-4000-8000-000000000129',
    'fully masked sample', 'value', 'edge', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[2,2,2],"dtype":"float64","values":[1,2,3,4,5,6,7,8]},{"type":"tensor","shape":[2],"dtype":"int64","values":[1,1]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1.0,2.0],[0.0,0.0]],[[5.0,6.0],[0.0,0.0]]]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 50. Trajectory Window Sampling  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000130', 'Trajectory Window Sampling', 'trajectory-window-sampling',
  'easy', 'robot-learning',
  'Generate all sliding windows of a fixed size from a trajectory. Given a list of length L and a window size w, return a list of all length-w sublists at every start index i = 0..L-w (inclusive), in order. There are exactly L - w + 1 windows.',
  '1 <= w <= L.',
  $code$
def trajectory_windows(trajectory: list, w: int) -> list:
    # TODO: return all sliding windows of size w
    return []
  $code$, $code$
def trajectory_windows(trajectory: list, w: int) -> list:
    return [trajectory[i:i + w] for i in range(len(trajectory) - w + 1)]
  $code$, 'trajectory_windows',
  'python', 3000, 256, 'exact', 0.0, true, false,
  'function', 'function', 'trajectory_windows', 'python', 'standard_python',
  '{"comparison":"exact","check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000303', 'b1000000-0000-4000-8000-000000000130',
    'size 3', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,2,3,4,5],3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,2,3],[2,3,4],[3,4,5]]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000304', 'b1000000-0000-4000-8000-000000000130',
    'full window', 'value', 'edge', false, 1.0, 1,
    $data${"args":[[10,20,30],3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[10,20,30]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000305', 'b1000000-0000-4000-8000-000000000130',
    'long trajectory', 'value', 'basic', true, 1.0, 2,
    $data${"args":[[1,2,3,4],2],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,2],[2,3],[3,4]]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 51. Episode Return  (python, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000131', 'Episode Return', 'episode-return',
  'easy', 'robot-learning',
  'Compute the total undiscounted return of an episode by summing all rewards. This is the scalar used to score an episode during robot-learning rollout collection. Return the sum rounded to six decimal places.',
  'rewards is a non-empty list of floats.',
  $code$
def episode_return(rewards: list) -> float:
    # TODO: return the sum of rewards
    return 0.0
  $code$, $code$
def episode_return(rewards: list) -> float:
    return round(sum(rewards), 6)
  $code$, 'episode_return',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'episode_return', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000306', 'b1000000-0000-4000-8000-000000000131',
    'positive rewards', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[1,2,3]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":6.0}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000307', 'b1000000-0000-4000-8000-000000000131',
    'mixed signs', 'value', 'edge', false, 1.0, 1,
    $data${"args":[[1,-2,3]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":2.0}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000308', 'b1000000-0000-4000-8000-000000000131',
    'fractional', 'value', 'basic', true, 1.0, 2,
    $data${"args":[[0.5,0.25,0.25]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":1.0}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 52. Temporal Ensemble  (numpy, function)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000132', 'Temporal Ensemble', 'temporal-ensemble',
  'medium', 'robot-learning',
  'Average a set of predicted action chunks that share overlapping time steps, weighting each prediction equally. Given a list of action chunks (each a 1-D vector of equal length) for the same horizon, compute the element-wise mean across chunks and round each value to six decimal places. This smooths a diffusion policy output across overlapping predictions.',
  'chunks is a list of 2+ equal-length 1-D float vectors.',
  $code$
def temporal_ensemble(chunks: list) -> list:
    # TODO: return the element-wise mean of the chunks
    return []
  $code$, $code$
def temporal_ensemble(chunks: list) -> list:
    n = len(chunks)
    d = len(chunks[0])
    out = []
    for j in range(d):
        total = sum(chunk[j] for chunk in chunks)
        out.append(round(total / n, 6))
    return out
  $code$, 'temporal_ensemble',
  'python', 3000, 256, 'numeric', 0.000001, true, false,
  'function', 'function', 'temporal_ensemble', 'python', 'standard_python',
  '{"comparison":"allclose","rtol":0.00001,"atol":0.000001,"check_shape":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000309', 'b1000000-0000-4000-8000-000000000132',
    'two chunks', 'example', 'basic', false, 1.0, 0,
    $data${"args":[[[1,2],[3,4]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[2.0,3.0]}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000310', 'b1000000-0000-4000-8000-000000000132',
    'three chunks', 'value', 'basic', false, 1.0, 1,
    $data${"args":[[[1,0],[3,0],[2,0]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[2.0,0.0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000311', 'b1000000-0000-4000-8000-000000000132',
    'longer chunks', 'value', 'edge', true, 1.0, 2,
    $data${"args":[[[0,0,0],[0,0,2],[0,0,4]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.0,0.0,2.0]}$data$,
    $data${}$data$
  )
;

-- ---------------------------------------------------------------------------
-- 53. LayerNorm  (PyTorch, function, value + shape + gradient)
-- ---------------------------------------------------------------------------
insert into public.coding_problems (
  id, title, slug, difficulty, category, description, constraints,
  starter_code, solution_code, function_name, language, time_limit_ms,
  memory_limit_mb, comparison_mode, tolerance, is_published, is_featured,
  evaluation_mode, entrypoint_type, entrypoint_name, framework,
  resource_profile, evaluator_config
) values (
  'b1000000-0000-4000-8000-000000000133', 'Implement LayerNorm', 'implement-layernorm',
  'medium', 'transformer',
  'Implement layer normalization over the last dimension of a tensor. Given an input x of shape (..., d), compute the mean and biased variance over the last dimension, normalize to zero mean and unit variance, then apply per-channel weight and bias: y = ((x - mean) / sqrt(var + eps)) * weight + bias. The operation must be differentiable, so build the computation with tensor ops (torch.mean / torch.var / torch.sqrt) rather than in-place Python loops.',
  'x has shape (..., d) with d >= 2. weight and bias are (d,) tensors. eps is a positive float.',
  $code$
import torch

def layer_norm(x: torch.Tensor, weight: torch.Tensor, bias: torch.Tensor, eps: float = 1e-5) -> torch.Tensor:
    # x: (..., d) float32 ; weight, bias: (d,) float32
    # TODO: return a tensor of the same shape as x
    return x
  $code$, $code$
import torch

def layer_norm(x: torch.Tensor, weight: torch.Tensor, bias: torch.Tensor, eps: float = 1e-5) -> torch.Tensor:
    mean = x.mean(dim=-1, keepdim=True)
    var = x.var(dim=-1, keepdim=True, unbiased=False)
    x_hat = (x - mean) / torch.sqrt(var + eps)
    return x_hat * weight + bias
  $code$, 'layer_norm',
  'python', 15000, 512, 'numeric', 0.0001, true, false,
  'function', 'function', 'layer_norm', 'pytorch', 'ml_cpu_small',
  '{"comparison":"allclose","rtol":0.0001,"atol":0.00001,"check_shape":true,"check_dtype":false,"check_gradient":true}'
);

insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000312', 'b1000000-0000-4000-8000-000000000133',
    'normalize two rows', 'example', 'basic', false, 1.0, 0,
    $data${"args":[{"type":"tensor","shape":[2,3],"dtype":"float32","values":[1,2,3,4,5,6]},{"type":"tensor","shape":[3],"dtype":"float32","values":[1,1,1]},{"type":"tensor","shape":[3],"dtype":"float32","values":[0,0,0]}],"kwargs":{"eps":0.00001},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2,3],"dtype":"float32","values":[-1.224736,0.0,1.224736,-1.224736,0.0,1.224736]}}$data$,
    $data${"visible_example":true}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000313', 'b1000000-0000-4000-8000-000000000133',
    'affine shift and constant row', 'value', 'edge', true, 1.0, 1,
    $data${"args":[{"type":"tensor","shape":[2,4],"dtype":"float32","values":[1,-2,3,0.5,2,2,2,2]},{"type":"tensor","shape":[4],"dtype":"float32","values":[0.5,1.0,1.5,2.0]},{"type":"tensor","shape":[4],"dtype":"float32","values":[0.1,-0.2,0.3,-0.4]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2,4],"dtype":"float32","values":[0.205279,-1.673909,2.300305,-0.540372,0.1,-0.2,0.3,-0.4]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000314', 'b1000000-0000-4000-8000-000000000133',
    'batched shape', 'shape', 'shape', true, 1.0, 2,
    $data${"args":[{"type":"tensor","shape":[2,3,4],"dtype":"float32","values":[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]},{"type":"tensor","shape":[4],"dtype":"float32","values":[1,1,1,1]},{"type":"tensor","shape":[4],"dtype":"float32","values":[0,0,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"shape","shape":[2,3,4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000315', 'b1000000-0000-4000-8000-000000000133',
    'differentiable', 'gradient', 'gradient', true, 1.5, 3,
    $data${"args":[{"type":"tensor","shape":[2,3],"dtype":"float32","values":[1,2,4,3,1,2],"requires_grad":true},{"type":"tensor","shape":[3],"dtype":"float32","values":[0.5,1.0,1.5],"requires_grad":true},{"type":"tensor","shape":[3],"dtype":"float32","values":[0.1,-0.2,0.3],"requires_grad":true}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"gradient","gradients":[{"label":"arg0","value":{"type":"tensor","shape":[2,3],"dtype":"float32","values":[-0.057272,0.085905,-0.028632,-0.306189,-0.306179,0.612368]}},{"label":"arg1","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[0.155694,-1.491996,1.336302]}},{"label":"arg2","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[2.0,2.0,2.0]}}]}$data$,
    $data${}$data$
  )
;

-- ===========================================================================
-- PROBLEM COLLECTIONS (Task 45)
--
-- Six curated learning paths over the Week 5 function/class problems. A
-- problem may appear in multiple collections (many-to-many via
-- coding_collection_problems). Collection IDs use the c1000000 namespace.
-- ===========================================================================

-- 1. Embodied AI Top 30 — flagship cross-category path
insert into public.coding_collections (
  id, name, slug, description, is_published, order_index
) values (
  'c1000000-0000-4000-8000-000000000101',
  'Embodied AI Top 30',
  'embodied-ai-top-30',
  'The flagship Embodied AI interview path: the 30 most frequently asked function/class implementation problems across transformers, RL post-training, robotics math, diffusion, and robot learning.',
  true, 0
);

-- 2. Transformer Essentials
insert into public.coding_collections (
  id, name, slug, description, is_published, order_index
) values (
  'c1000000-0000-4000-8000-000000000102',
  'Transformer Essentials',
  'transformer-essentials',
  'Core normalization, attention, positional encoding, and sampling building blocks every LLM interview covers.',
  true, 1
);

-- 3. RL Post-Training Core
insert into public.coding_collections (
  id, name, slug, description, is_published, order_index
) values (
  'c1000000-0000-4000-8000-000000000103',
  'RL Post-Training Core',
  'rl-post-training-core',
  'The advantage estimation, clipping, and KL machinery behind PPO / GRPO post-training pipelines.',
  true, 2
);

-- 4. Robotics Math Essentials
insert into public.coding_collections (
  id, name, slug, description, is_published, order_index
) values (
  'c1000000-0000-4000-8000-000000000104',
  'Robotics Math Essentials',
  'robotics-math-essentials',
  'Quaternion, SE(3), and trajectory math for embodied systems and manipulation policies.',
  true, 3
);

-- 5. Diffusion Fundamentals
insert into public.coding_collections (
  id, name, slug, description, is_published, order_index
) values (
  'c1000000-0000-4000-8000-000000000105',
  'Diffusion Fundamentals',
  'diffusion-fundamentals',
  'Noise schedules, forward processes, flow matching, and ODE sampling steps for diffusion policy training.',
  true, 4
);

-- 6. Robot Learning Utilities
insert into public.coding_collections (
  id, name, slug, description, is_published, order_index
) values (
  'c1000000-0000-4000-8000-000000000106',
  'Robot Learning Utilities',
  'robot-learning-utilities',
  'Replay buffers, action chunking, normalization, and window-sampling utilities used in imitation-learning pipelines.',
  true, 5
);

-- ---------------------------------------------------------------------------
-- Collection membership (ordered learning progression)
-- ---------------------------------------------------------------------------
insert into public.coding_collection_problems (collection_id, problem_id, order_index) values
  -- Embodied AI Top 30
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000101', 0),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000102', 1),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000133', 2),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000104', 3),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000106', 4),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000107', 5),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000103', 6),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000105', 7),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000108', 8),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000109', 9),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000110', 10),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000111', 11),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000112', 12),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000113', 13),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000114', 14),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000115', 15),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000116', 16),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000117', 17),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000118', 18),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000119', 19),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000120', 20),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000121', 21),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000122', 22),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000123', 23),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000124', 24),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000125', 25),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000126', 26),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000127', 27),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000128', 28),
  ('c1000000-0000-4000-8000-000000000101', 'b1000000-0000-4000-8000-000000000130', 29),

  -- Transformer Essentials
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000101', 0),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000133', 1),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000102', 2),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000106', 3),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000107', 4),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000103', 5),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000104', 6),
  ('c1000000-0000-4000-8000-000000000102', 'b1000000-0000-4000-8000-000000000105', 7),

  -- RL Post-Training Core
  ('c1000000-0000-4000-8000-000000000103', 'b1000000-0000-4000-8000-000000000108', 0),
  ('c1000000-0000-4000-8000-000000000103', 'b1000000-0000-4000-8000-000000000109', 1),
  ('c1000000-0000-4000-8000-000000000103', 'b1000000-0000-4000-8000-000000000110', 2),
  ('c1000000-0000-4000-8000-000000000103', 'b1000000-0000-4000-8000-000000000111', 3),
  ('c1000000-0000-4000-8000-000000000103', 'b1000000-0000-4000-8000-000000000112', 4),
  ('c1000000-0000-4000-8000-000000000103', 'b1000000-0000-4000-8000-000000000113', 5),

  -- Robotics Math Essentials
  ('c1000000-0000-4000-8000-000000000104', 'b1000000-0000-4000-8000-000000000114', 0),
  ('c1000000-0000-4000-8000-000000000104', 'b1000000-0000-4000-8000-000000000115', 1),
  ('c1000000-0000-4000-8000-000000000104', 'b1000000-0000-4000-8000-000000000116', 2),
  ('c1000000-0000-4000-8000-000000000104', 'b1000000-0000-4000-8000-000000000117', 3),
  ('c1000000-0000-4000-8000-000000000104', 'b1000000-0000-4000-8000-000000000118', 4),

  -- Diffusion Fundamentals
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000119', 0),
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000120', 1),
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000121', 2),
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000122', 3),
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000123', 4),
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000124', 5),
  ('c1000000-0000-4000-8000-000000000105', 'b1000000-0000-4000-8000-000000000125', 6),

  -- Robot Learning Utilities
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000126', 0),
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000127', 1),
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000128', 2),
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000129', 3),
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000130', 4),
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000131', 5),
  ('c1000000-0000-4000-8000-000000000106', 'b1000000-0000-4000-8000-000000000132', 6)
;

-- ---------------------------------------------------------------------------
-- Hidden test coverage completion (Task 57 audit)
-- Adds value-kind hidden tests so every published problem has >= 3 hidden tests.
-- Expected values were computed by running the reference solution for each problem.
-- ---------------------------------------------------------------------------
insert into public.coding_test_cases (
  id, problem_id, name, test_type, test_group, is_hidden, weight, order_index,
  input_json, expected_json, metadata
) values
  (
    'b2000000-0000-4000-8000-000000000317', 'b1000000-0000-4000-8000-000000000102',
    'length 6 lower triangle', 'value', 'edge', true, 1.0, 4,
    $data${"args":[6],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,0,0,0,0,0],[1,1,0,0,0,0],[1,1,1,0,0,0],[1,1,1,1,0,0],[1,1,1,1,1,0],[1,1,1,1,1,1]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000318', 'b1000000-0000-4000-8000-000000000103',
    'multi-entry append', 'value', 'basic', true, 1.0, 3,
    $data${"args":[[[1,2],[3,4]],[[5,6],[7,8]],[9,10],[11,12]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1,2],[3,4],[9,10]],[[5,6],[7,8],[11,12]]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000319', 'b1000000-0000-4000-8000-000000000103',
    'append long rows to empty', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[],[],[1,2,3],[4,5,6]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1,2,3]],[[4,5,6]]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000320', 'b1000000-0000-4000-8000-000000000104',
    'identity rotation length 6', 'value', 'edge', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[6],"dtype":"float32","values":[1,2,3,4,5,6]},{"type":"tensor","shape":[3],"dtype":"float32","values":[1,1,1]},{"type":"tensor","shape":[3],"dtype":"float32","values":[0,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[6],"dtype":"float32","values":[1,2,3,4,5,6]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000321', 'b1000000-0000-4000-8000-000000000105',
    'pick top 3 of 5', 'value', 'basic', true, 1.0, 4,
    $data${"args":[[7,3,9,1,5],3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0,2,4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000322', 'b1000000-0000-4000-8000-000000000106',
    'three tokens batch', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[1,3,2],"dtype":"float32","values":[1,0,0,1,1,1]},{"type":"tensor","shape":[1,3,2],"dtype":"float32","values":[1,0,0,1,1,1]},{"type":"tensor","shape":[1,3,2],"dtype":"float32","values":[1,2,3,4,5,6]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[1,3,2],"dtype":"float32","values":[3,4,3.406672,4.406672,3.51047,4.510469]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000323', 'b1000000-0000-4000-8000-000000000107',
    'multiple queries', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[3,2],"dtype":"float32","values":[1,0,0,1,1,1]},{"type":"tensor","shape":[2,2],"dtype":"float32","values":[1,0,0,1]},{"type":"tensor","shape":[2,2],"dtype":"float32","values":[5,7,9,11]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[3,2],"dtype":"float32","values":[6.320954,8.320953,7.679046,9.679047,7,9]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000324', 'b1000000-0000-4000-8000-000000000108',
    'mid discount multi step', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[[5,-2,3,1],0.5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[4.875,-0.25,3.5,1]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000325', 'b1000000-0000-4000-8000-000000000109',
    'decay trace', 'value', 'numerical', true, 1.0, 3,
    $data${"args":[[1,2],[0.5,0.5,0.5],0.9,0.95],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[2.61725,1.95]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000326', 'b1000000-0000-4000-8000-000000000109',
    'long horizon', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[1,0,0,0],[0,0,0,0,0],0.99,0.95],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,0,0,0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000327', 'b1000000-0000-4000-8000-000000000110',
    'large increase', 'value', 'edge', true, 1.0, 3,
    $data${"args":[0.9,0.1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":9}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000328', 'b1000000-0000-4000-8000-000000000110',
    'non round ratio', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[0.3,0.7],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.428571}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000329', 'b1000000-0000-4000-8000-000000000111',
    'both clipped', 'value', 'edge', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[0.5,1.5]},{"type":"tensor","shape":[2],"dtype":"float32","values":[1.0,1.0]}],"kwargs":{"eps":0.2},"seed":null}$data$,
    $data${"kind":"value","value":-0.85}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000330', 'b1000000-0000-4000-8000-000000000112',
    'two mode group', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[1,1,2,2]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[-1,-1,1,1]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000331', 'b1000000-0000-4000-8000-000000000113',
    'mixed drift three terms', 'value', 'numerical', true, 1.0, 3,
    $data${"args":[[-1,-2,-3],[-0.8,-2.2,-2.8]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.021093}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000332', 'b1000000-0000-4000-8000-000000000113',
    'positive drift', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[-2,-1],[-1.5,-0.5]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.175639}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000333', 'b1000000-0000-4000-8000-000000000115',
    'axis composition', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[0,1,0,0],[0,0,0,1]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0,0,-1,0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000334', 'b1000000-0000-4000-8000-000000000115',
    'scaling identity parts', 'value', 'basic', true, 1.0, 4,
    $data${"args":[[2,0,0,0],[3,0,0,0]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[6,0,0,0]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000335', 'b1000000-0000-4000-8000-000000000116',
    'identity translate negative point', 'value', 'numerical', true, 1.0, 3,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,2,3]},{"type":"tensor","shape":[3],"dtype":"float64","values":[-1,0,2]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0,2,5]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000336', 'b1000000-0000-4000-8000-000000000116',
    'half turn about z', 'value', 'edge', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[-1,0,0,0,-1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,0]},{"type":"tensor","shape":[3],"dtype":"float64","values":[2,3,4]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[-2,-3,4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000337', 'b1000000-0000-4000-8000-000000000117',
    'double rotation', 'value', 'edge', true, 1.0, 3,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,0]},{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[0,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[-1,0,0],[0,-1,0],[0,0,1]],[0,0,0]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000338', 'b1000000-0000-4000-8000-000000000117',
    'rotation then translation', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[3,3],"dtype":"float64","values":[0,-1,0,1,0,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,1,1]},{"type":"tensor","shape":[3,3],"dtype":"float64","values":[1,0,0,0,1,0,0,0,1]},{"type":"tensor","shape":[3],"dtype":"float64","values":[1,0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[0,-1,0],[1,0,0],[0,0,1]],[1,2,1]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000339', 'b1000000-0000-4000-8000-000000000118',
    'four points 4d', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[[0,0,0,0],[1,2,3,4],4],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[0,0,0,0],[0.333333,0.666667,1,1.333333],[0.666667,1.333333,2,2.666667],[1,2,3,4]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000340', 'b1000000-0000-4000-8000-000000000119',
    'single step', 'value', 'edge', true, 1.0, 3,
    $data${"args":[1,0.0001,0.02],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.02]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000341', 'b1000000-0000-4000-8000-000000000119',
    'ten steps', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[10,0.0,0.1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000342', 'b1000000-0000-4000-8000-000000000120',
    'quarter noise clean eps', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[2,2]},0.25,{"type":"tensor","shape":[2],"dtype":"float32","values":[0,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[1,1]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000343', 'b1000000-0000-4000-8000-000000000121',
    'two element recovery', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[1,2]},0.25,{"type":"tensor","shape":[2],"dtype":"float32","values":[0.1,0.2]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[1.826795,3.65359]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000344', 'b1000000-0000-4000-8000-000000000122',
    'reverse direction', 'value', 'edge', true, 1.0, 3,
    $data${"args":[{"type":"tensor","shape":[2],"dtype":"float32","values":[5,5]},{"type":"tensor","shape":[2],"dtype":"float32","values":[2,1]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[2],"dtype":"float32","values":[-3,-4]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000345', 'b1000000-0000-4000-8000-000000000122',
    'three dims', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[3],"dtype":"float32","values":[1,2,3]},{"type":"tensor","shape":[3],"dtype":"float32","values":[4,5,6]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":{"type":"tensor","shape":[3],"dtype":"float32","values":[3,3,3]}}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000346', 'b1000000-0000-4000-8000-000000000123',
    'negative dt', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[1,1],[1,1],-0.5],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[0.5,0.5]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000347', 'b1000000-0000-4000-8000-000000000123',
    'zero velocity', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[3,4],[0,0],10.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[3,4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000348', 'b1000000-0000-4000-8000-000000000124',
    'unity weight', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[2,4],[6,8],1.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[6,8]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000349', 'b1000000-0000-4000-8000-000000000124',
    'negative weight', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[1,1],[3,3],-1.0],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[-1,-1]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000350', 'b1000000-0000-4000-8000-000000000125',
    'single column rows', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[[1],[2],[3]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,2,3]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000351', 'b1000000-0000-4000-8000-000000000125',
    'wide rows', 'value', 'basic', true, 1.0, 4,
    $data${"args":[[[1,2,3],[4,5,6]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,2,3,4,5,6]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000352', 'b1000000-0000-4000-8000-000000000126',
    'sample middle of buffer', 'value', 'basic', true, 1.0, 4,
    $data${"args":[2],"kwargs":{},"seed":null,"construct":{"args":[[[1,2],[3,4],[5,6],[7,8]]],"kwargs":{}},"method":"sample"}$data$,
    $data${"kind":"value","value":[[5,6],[7,8]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000353', 'b1000000-0000-4000-8000-000000000127',
    'exact fit', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[1,2,3,4],4],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[1,2,3,4]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000354', 'b1000000-0000-4000-8000-000000000127',
    'head window', 'value', 'basic', true, 1.0, 4,
    $data${"args":[[5,6,7,8],2],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[5,6]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000355', 'b1000000-0000-4000-8000-000000000128',
    'all constant', 'value', 'edge', true, 1.0, 3,
    $data${"args":[{"type":"tensor","shape":[2,2],"dtype":"float64","values":[2,2,2,2]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[0,0],[0,0]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000356', 'b1000000-0000-4000-8000-000000000128',
    'larger batch', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[4,2],"dtype":"float64","values":[1,10,2,20,3,30,4,40]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[-1.341641,-1.341641],[-0.447214,-0.447214],[0.447214,0.447214],[1.341641,1.341641]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000357', 'b1000000-0000-4000-8000-000000000129',
    'zero and one lengths', 'value', 'edge', true, 1.0, 3,
    $data${"args":[{"type":"tensor","shape":[2,2,2],"dtype":"float64","values":[1,2,3,4,5,6,7,8]},{"type":"tensor","shape":[2],"dtype":"int64","values":[0,1]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[0,0],[0,0]],[[5,6],[0,0]]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000358', 'b1000000-0000-4000-8000-000000000129',
    'three samples', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[{"type":"tensor","shape":[3,1,2],"dtype":"float64","values":[1,2,3,4,5,6]},{"type":"tensor","shape":[3],"dtype":"int64","values":[1,1,0]}],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[[1,2]],[[3,4]],[[0,0]]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000359', 'b1000000-0000-4000-8000-000000000130',
    'unit windows', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[1,2,3],1],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1],[2],[3]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000360', 'b1000000-0000-4000-8000-000000000130',
    'full trajectory', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[1,2,3],3],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[[1,2,3]]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000361', 'b1000000-0000-4000-8000-000000000131',
    'negative rewards', 'value', 'edge', true, 1.0, 3,
    $data${"args":[[-1,-2,-3]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":-6}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000362', 'b1000000-0000-4000-8000-000000000131',
    'float sum', 'value', 'numerical', true, 1.0, 4,
    $data${"args":[[0.1,0.2,0.3]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":0.6}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000363', 'b1000000-0000-4000-8000-000000000132',
    'four chunks', 'value', 'numerical', true, 1.0, 3,
    $data${"args":[[[1,2],[2,3],[3,4],[4,5]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[2.5,3.5]}$data$,
    $data${}$data$
  ),
  (
    'b2000000-0000-4000-8000-000000000364', 'b1000000-0000-4000-8000-000000000132',
    'single chunk', 'value', 'edge', true, 1.0, 4,
    $data${"args":[[[5,6,7]]],"kwargs":{},"seed":null}$data$,
    $data${"kind":"value","value":[5,6,7]}$data$,
    $data${}$data$
  );

-- ---------------------------------------------------------------------------
-- Chinese display copy for the supplemental Week 5 catalog.
-- Keep slugs, identifiers, code, and technical terms stable for integrations.
-- ---------------------------------------------------------------------------
update public.coding_problems as p
set
  title = v.title,
  description = v.description,
  constraints = v.constraints,
  starter_code = regexp_replace(
    p.starter_code,
    E'(?m)# TODO:.*$',
    $zh$# TODO：请完成该题的实现$zh$,
    'g'
  )
from (
  values
    ('implement-rmsnorm', $zh$实现 RMSNorm$zh$, $zh$为一维浮点张量实现 RMS（均方根）归一化。给定向量 x 和 epsilon，先计算向量上的 mean(x^2)，再令 scale = sqrt(mean(x^2) + eps)，最后返回 x / scale。该运算必须可微，因此请使用张量算子（torch.mean / torch.sqrt）完成，不要使用原地 Python 循环。$zh$, $zh$x 是长度为 2 到 16 的一维 float32 张量；eps 是正浮点数。$zh$),
    ('build-causal-attention-mask-v2', $zh$构建 Causal Attention Mask$zh$, $zh$构建长度为 n 的 causal（因果）Attention Mask。返回 n × n 矩阵：当位置 j 对位置 i 可见（j ≤ i）时，元素 (i, j) 为 1，否则为 0。这样可以阻止 token 关注未来 token。$zh$, $zh$n 是 1 到 32 的整数。$zh$),
    ('append-kv-cache', $zh$追加 KV Cache$zh$, $zh$将新的 key 和 value 向量追加到已有 KV Cache。Cache 由两个 token 向量列表组成：k_cache（key 向量列表）和 v_cache（value 向量列表）。给定一个新的 key 向量和 value 向量，返回追加新向量后的（k_cache, v_cache）元组。$zh$, $zh$每个 key/value 向量都是长度相同的浮点数列表。$zh$),
    ('apply-rope-rotation', $zh$应用 RoPE Rotation$zh$, $zh$对长度为 2n 的偶数维一维张量应用 rotary position embedding（RoPE）旋转。将向量拆分为两半 x_first = x[:n] 和 x_second = x[n:]，对每个位置 i 计算：out[i] = x_first[i] * cos[i] - x_second[i] * sin[i]，out[i+n] = x_first[i] * sin[i] + x_second[i] * cos[i]。请使用张量算子（torch.stack / 切片）实现，以保证旋转过程可微。$zh$, $zh$x 的长度为 2 到 16 的偶数；cos 和 sin 是长度为 n 的一维张量。$zh$),
    ('top-k-token-selection', $zh$选择 Top-k Token$zh$, $zh$给定 logits 列表和整数 k，返回数值最大的 k 个 logits 对应的索引，并按升序排列。这是 Top-k sampling 的词表过滤步骤：只保留概率最高的 k 个 token。若数值相同，优先选择索引较小的项。结果必须是按升序排列的索引列表。$zh$, $zh$k 的范围是 1 到 len(logits)；logits 可以包含任意有限浮点数。$zh$),
    ('multi-head-attention', $zh$Multi-Head Attention$zh$, $zh$给定已经完成投影的 query、key、value 张量，实现单步 Multi-Head Attention，三者形状均为（heads, seq, head_dim）。对每个 head h 计算 scores = (q[h] @ k[h].T) / sqrt(head_dim)，沿 key 维度应用 softmax，再计算 value 的加权和。返回拼接后的（heads, seq, head_dim）张量。所有运算必须使用张量算子，以保证结果可微。$zh$, $zh$所有 head 的 head_dim 相同；seq ≥ 1。$zh$),
    ('cross-attention', $zh$Cross Attention$zh$, $zh$实现 Cross Attention，让一个 query 在独立的 key/value memory 上进行注意力计算。给定 query 向量 q（dim,）以及 memory 的 key/value 矩阵（m, dim），计算 scores = q @ K.T / sqrt(dim)，沿 m 个 memory 槽位应用 softmax，最后返回 V 的加权和（长度为 dim 的向量）。这对应 decoder token 关注 encoder 输出的场景。$zh$, $zh$q 的长度为 dim；K 和 V 是（m, dim）矩阵。$zh$),
    ('discounted-returns', $zh$计算 Discounted Returns$zh$, $zh$给定奖励列表和折扣因子 gamma，计算每个时间步的折扣回报 G_t = reward_t + gamma * G_{t+1}，最后一步的 G 等于该步奖励。返回回报列表，并将每个值四舍五入到小数点后 6 位。$zh$, $zh$gamma 的范围是 [0, 1]；rewards 是非空浮点数列表。$zh$),
    ('generalized-advantage-estimation-torch', $zh$Generalized Advantage Estimation$zh$, $zh$计算一条轨迹的 Generalized Advantage Estimate（GAE）。给定奖励 r[0..T-1]、价值估计 v[0..T]（多出的一个是终止状态价值）、折扣 gamma 和 Trace 衰减系数 lambda，先计算 delta_t = r_t + gamma * v[t+1] - v[t]，再从后向前累积 A_t = delta_t + (gamma * lambda) * A_{t+1}。返回 t = 0..T-1 的 advantage 列表，并四舍五入到小数点后 6 位。$zh$, $zh$len(v) = len(r) + 1；gamma 和 lambda 的范围都是 [0, 1]。$zh$),
    ('ppo-probability-ratio', $zh$PPO Probability Ratio$zh$, $zh$计算 PPO 使用的重要性采样比率：ratio = new_prob / old_prob。它用于比较新旧策略对同一动作的概率。返回四舍五入到小数点后 6 位的 ratio。两个概率都必须严格为正。$zh$, $zh$new_prob 和 old_prob 是 (0, 1] 范围内的浮点数。$zh$),
    ('ppo-clipped-objective-torch', $zh$PPO Clipped Objective$zh$, $zh$实现 PPO 的 clipped surrogate objective（负值，用于梯度下降）。给定 ratio 张量（batch,）、advantages 张量（batch,）和 clip epsilon，先计算每个样本的 surrogate = min(ratio * adv, clip(ratio, 1-eps, 1+eps) * adv)，再返回负均值，使最小化输出能够改善策略。必须使用张量运算并保持可微。$zh$, $zh$ratio 和 adv 是长度为 1 到 8 且形状相同的一维 float32 张量。$zh$),
    ('grpo-group-advantage', $zh$GRPO Group Advantage$zh$, $zh$为 GRPO 将一组 reward score 归一化为 advantage。给定一组 scores，减去组均值，再除以总体标准差（均方偏差的平方根），并将每个 advantage 四舍五入到小数点后 6 位。如果标准差为零，则返回全零列表。$zh$, $zh$scores 是非空浮点数列表。$zh$),
    ('approximate-kl-penalty', $zh$Approximate KL Penalty$zh$, $zh$使用新策略与参考策略的 log-probability 列表估计 KL divergence。采用公式 kl = mean(exp(logq - logp) * ((logq - logp) - 1) + 1)。这是 RLHF/GRPO 中常用的、有偏但低方差的策略漂移惩罚估计量。返回标量，并四舍五入到小数点后 6 位。$zh$, $zh$logp 和 logq 是长度相同且包含有限浮点数的列表。$zh$),
    ('euler-to-quaternion', $zh$Euler Angles 转 Quaternion$zh$, $zh$将 roll-pitch-yaw（ZYX intrinsic）欧拉角三元组转换为单位四元数（w, x, y, z）。使用标准半角公式，其中 c*/s* 分别表示半角的 cos/sin：w = cr*cp*cy + sr*sp*sy，x = sr*cp*cy - cr*sp*sy，y = cr*sp*cy + sr*cp*sy，z = cr*cp*sy - sr*sp*cy。输入为 3 维张量，返回 4 维张量。$zh$, $zh$euler 是形状为（3,）且单位为弧度的 float32 张量。$zh$),
    ('quaternion-multiply', $zh$Quaternion Multiplication$zh$, $zh$将两个四元数相乘，每个四元数都表示为 [w, x, y, z]。乘积（Hamilton product）表示两个旋转的组合。按给定公式计算 w、x、y、z，并返回 [w, x, y, z]。$zh$, $zh$每个输入都是长度为 4 的浮点数列表。$zh$),
    ('se3-point-transform', $zh$SE(3) Point Transform$zh$, $zh$使用 SE(3) 位姿（旋转矩阵 R 和平移向量 t）变换一个三维点。计算 p_transformed = R @ p + t，并返回变换后的点。线性代数请使用 numpy。$zh$, $zh$R 是 3 × 3 旋转矩阵；t 和 p 是长度为 3 的向量。$zh$),
    ('compose-se3', $zh$组合 SE(3) Poses$zh$, $zh$组合两个 SE(3) 位姿：先应用位姿 A =（R1, t1），再应用位姿 B =（R2, t2），组合结果 C = A * B，其中 R = R1 @ R2，t = t1 + R1 @ t2。返回（R, t）元组，并使用 numpy 实现。$zh$, $zh$R1 和 R2 是 3 × 3 旋转矩阵；t1 和 t2 是长度为 3 的向量。$zh$),
    ('linear-trajectory-interpolation', $zh$线性 Trajectory Interpolation$zh$, $zh$在两个点 a 和 b 之间进行线性插值，生成包含两个端点在内的 n 个等间距点。对 i = 0..n-1，point_i = a + (i / (n-1)) * (b - a)。返回 n 个点的列表；当 n = 1 时只返回 [a]。$zh$, $zh$a 和 b 是长度相同的浮点数列表；n ≥ 1。$zh$),
    ('linear-beta-schedule', $zh$线性 Beta Schedule$zh$, $zh$为 DDPM diffusion process 构建线性噪声 schedule。给定总步数 T、起始 beta 和结束 beta，返回 T 个 beta_t = beta_start + (t / T) * (beta_end - beta_start)，其中 t = 1..T，结果四舍五入到小数点后 6 位。$zh$, $zh$T 是 2 到 64 的整数；beta_start 和 beta_end 都在 (0, 1) 内。$zh$),
    ('ddpm-forward-diffusion', $zh$DDPM Forward Diffusion$zh$, $zh$在指定时间步执行 DDPM forward（加噪）过程。给定干净样本 x0、时间步 t 的累计 alpha_bar 以及噪声张量 eps，计算 x_t = sqrt(alpha_bar_t) * x0 + sqrt(1 - alpha_bar_t) * eps，并返回加噪后的张量。该运算必须对 x0 可微。$zh$, $zh$x0 和 eps 是长度相同的 float32 张量（标量 batch）；alpha_bar_t 是 (0, 1) 内的浮点数。$zh$),
    ('predict-x0', $zh$预测干净样本 x0$zh$, $zh$给定加噪样本 x_t、时间步的累计 alpha_bar 和预测噪声 eps_pred，恢复干净样本：x0_pred = (x_t - sqrt(1 - alpha_bar) * eps_pred) / sqrt(alpha_bar)。这是 DDPM/DDIM sampler 使用的 x0-prediction 参数化。返回标量张量，并确保对 x_t 可微。$zh$, $zh$x_t 和 eps_pred 是 0 维 float32 标量张量；alpha_bar 是 (0, 1) 内的浮点数。$zh$),
    ('flow-matching-target', $zh$Flow Matching Target$zh$, $zh$计算 flow-matching（conditional flow）回归目标。从噪声样本 x0 到干净样本 x1 的直线路径上，任意位置的目标 velocity 都是 v = x1 - x0。返回该向量，并确保对 x1 和 x0 都可微。$zh$, $zh$x0 和 x1 是长度相同的 float32 张量。$zh$),
    ('euler-ode-step', $zh$Euler ODE Step$zh$, $zh$对 diffusion sampler 使用的 ODE 执行一次 Euler 积分。给定当前状态 x、velocity field v 和步长 dt，计算 x_next = x + dt * v。返回更新后的状态，并四舍五入到小数点后 6 位。$zh$, $zh$x 和 v 是长度相同的浮点数列表；dt > 0。$zh$),
    ('classifier-free-guidance', $zh$Classifier-Free Guidance$zh$, $zh$组合 unconditional prediction 和 conditional prediction，实现 classifier-free guidance。给定 v_uncond、v_cond 和 guidance weight w，计算 v = v_uncond + w * (v_cond - v_uncond)。返回 guidance 后的向量，并四舍五入到小数点后 6 位。$zh$, $zh$v_uncond 和 v_cond 是长度相同的浮点数列表；w ≥ 0。$zh$),
    ('diffusion-action-chunk-reshape', $zh$Diffusion Action Chunk Reshape$zh$, $zh$将（T, D）形状的 action chunk 按 row-major（time-major）顺序展平为长度 T*D 的一维向量。Diffusion policy 会预测展平后的 action chunk；该辅助函数负责将它重新整理为（T, D）表格。返回展平后的列表。$zh$, $zh$actions 是 T × D 的浮点数表格。$zh$),
    ('replay-buffer', $zh$Replay Buffer$zh$, $zh$实现一个最小 Replay Buffer 类。add(transition) 方法追加 transition，sample(n) 方法返回最近 n 个 transition（按插入顺序排列，最新项在最后）。如果当前 transition 少于 n 个，则返回全部内容。Buffer 使用 Python 列表存储 transition。$zh$, $zh$n 是非负整数。$zh$),
    ('action-chunking', $zh$Action Chunking$zh$, $zh$提取一个 action chunk，也就是从当前步骤开始的固定长度未来动作窗口。给定完整动作轨迹和 chunk 长度 h：如果剩余轨迹至少有 h 个动作，返回前 h 个动作；否则返回全部剩余动作，形成更短的 chunk。$zh$, $zh$actions 是非空列表；h 是正整数。$zh$),
    ('normalize-robot-actions', $zh$归一化 Robot Actions$zh$, $zh$按维度归一化一批 robot actions。给定形状为（T, D）的数组，表示 T 个 D 维动作向量，分别在 T 行上对每个维度 d 做标准化：减去列均值，再除以总体标准差。如果某列标准差为零，则将该列保持为全 0。请使用 numpy。$zh$, $zh$actions 是形状为（T, D）的数组，且 T ≥ 1、D ≥ 1。$zh$),
    ('mask-padded-actions', $zh$屏蔽 Padding Actions$zh$, $zh$将批量 action tensor 中的 padding 清零。给定形状为（B, T, D）的 padded actions 和长度向量 lens（B,），对样本 b 将所有 t ≥ lens[b] 的元素设为 0.0，合法位置保持不变。请使用 numpy。$zh$, $zh$每个 lens[b] 都在 1..T 范围内；actions 是（B, T, D）数组。$zh$),
    ('trajectory-window-sampling', $zh$Trajectory Window Sampling$zh$, $zh$从一条轨迹中生成固定大小的所有滑动窗口。给定长度为 L 的列表和窗口大小 w，按顺序返回起始索引 i = 0..L-w 的所有长度为 w 的子列表，窗口总数恰好为 L - w + 1。$zh$, $zh$1 ≤ w ≤ L。$zh$),
    ('episode-return', $zh$Episode Return$zh$, $zh$将一条 episode 的所有 reward 相加，计算未折扣的总回报。这是 robot-learning rollout 收集过程中评价 episode 的标量。返回总和，并四舍五入到小数点后 6 位。$zh$, $zh$rewards 是非空浮点数列表。$zh$),
    ('temporal-ensemble', $zh$Temporal Ensemble$zh$, $zh$对共享重叠时间步的一组预测 action chunk 做等权平均。给定一组长度相同的一维 action chunk，计算各 chunk 的逐元素均值，并将每个值四舍五入到小数点后 6 位。这可以平滑 diffusion policy 在重叠预测上的输出。$zh$, $zh$chunks 是由至少 2 个等长一维浮点向量组成的列表。$zh$),
    ('implement-layernorm', $zh$实现 LayerNorm$zh$, $zh$在张量最后一个维度上实现 LayerNorm。给定形状为（..., d）的输入 x，计算最后一维的均值和有偏方差，将其归一化为零均值和单位方差，再应用逐通道 weight 和 bias：y = ((x - mean) / sqrt(var + eps)) * weight + bias。该运算必须可微，因此请使用张量算子（torch.mean / torch.var / torch.sqrt）实现，不要使用原地 Python 循环。$zh$, $zh$x 的形状为（..., d），其中 d ≥ 2；weight 和 bias 是形状为（d,）的张量；eps 是正浮点数。$zh$)
) as v(slug, title, description, constraints)
where p.slug = v.slug;

update public.coding_collections as c
set
  name = v.name,
  description = v.description
from (
  values
    ('embodied-ai-top-30', $zh$具身智能 Top 30$zh$, $zh$具身智能面试主线：覆盖 Transformer、RL 后训练、机器人学数学、Diffusion 和 Robot Learning 的 30 道高频 function/class 实现题。$zh$),
    ('transformer-essentials', $zh$Transformer 基础$zh$, $zh$覆盖 LLM 面试常考的归一化、Attention、位置编码和采样基础模块。$zh$),
    ('rl-post-training-core', $zh$RL 后训练核心$zh$, $zh$掌握 PPO / GRPO 后训练流程中的 advantage estimation、clipping 和 KL 机制。$zh$),
    ('robotics-math-essentials', $zh$机器人学数学基础$zh$, $zh$学习具身系统和 manipulation policy 所需的 Quaternion、SE(3) 以及轨迹数学。$zh$),
    ('diffusion-fundamentals', $zh$Diffusion 基础$zh$, $zh$覆盖 Diffusion policy 训练中的 noise schedule、forward process、flow matching 和 ODE sampling step。$zh$),
    ('robot-learning-utilities', $zh$Robot Learning 工具$zh$, $zh$练习 imitation-learning pipeline 中常用的 replay buffer、action chunking、归一化和窗口采样工具。$zh$)
) as v(slug, name, description)
where c.slug = v.slug;

update public.coding_test_cases as c
set name = v.name
from (
  values
    ('b2000000-0000-4000-8000-000000000201', $zh$正数向量$zh$),
    ('b2000000-0000-4000-8000-000000000202', $zh$混合符号$zh$),
    ('b2000000-0000-4000-8000-000000000206', $zh$长度 3$zh$),
    ('b2000000-0000-4000-8000-000000000207', $zh$长度 1$zh$),
    ('b2000000-0000-4000-8000-000000000210', $zh$空 Cache$zh$),
    ('b2000000-0000-4000-8000-000000000211', $zh$已有条目$zh$),
    ('b2000000-0000-4000-8000-000000000213', $zh$零角度$zh$),
    ('b2000000-0000-4000-8000-000000000214', $zh$旋转$zh$),
    ('b2000000-0000-4000-8000-000000000217', $zh$从 4 个 Token 中选择 Top 2$zh$),
    ('b2000000-0000-4000-8000-000000000218', $zh$全部 Token$zh$),
    ('b2000000-0000-4000-8000-000000000221', $zh$单头恒等映射$zh$),
    ('b2000000-0000-4000-8000-000000000222', $zh$双 Token 聚焦$zh$),
    ('b2000000-0000-4000-8000-000000000225', $zh$关注单个槽位$zh$),
    ('b2000000-0000-4000-8000-000000000226', $zh$相同 Memory$zh$),
    ('b2000000-0000-4000-8000-000000000229', $zh$单位奖励$zh$),
    ('b2000000-0000-4000-8000-000000000230', $zh$不折扣$zh$),
    ('b2000000-0000-4000-8000-000000000233', $zh$单位 Bootstrap$zh$),
    ('b2000000-0000-4000-8000-000000000234', $zh$部分 Trace$zh$),
    ('b2000000-0000-4000-8000-000000000236', $zh$增大$zh$),
    ('b2000000-0000-4000-8000-000000000237', $zh$减小$zh$),
    ('b2000000-0000-4000-8000-000000000239', $zh$未裁剪均值$zh$),
    ('b2000000-0000-4000-8000-000000000240', $zh$裁剪 Ratio$zh$),
    ('b2000000-0000-4000-8000-000000000243', $zh$线性分组$zh$),
    ('b2000000-0000-4000-8000-000000000244', $zh$两个数值$zh$),
    ('b2000000-0000-4000-8000-000000000247', $zh$相同策略$zh$),
    ('b2000000-0000-4000-8000-000000000248', $zh$轻微漂移$zh$),
    ('b2000000-0000-4000-8000-000000000250', $zh$零旋转$zh$),
    ('b2000000-0000-4000-8000-000000000251', $zh$Yaw 90 度$zh$),
    ('b2000000-0000-4000-8000-000000000255', $zh$恒等变换乘旋转$zh$),
    ('b2000000-0000-4000-8000-000000000256', $zh$两次 90 度旋转$zh$),
    ('b2000000-0000-4000-8000-000000000258', $zh$纯平移$zh$),
    ('b2000000-0000-4000-8000-000000000259', $zh$绕 Z 轴旋转 90 度$zh$),
    ('b2000000-0000-4000-8000-000000000261', $zh$恒等组合$zh$),
    ('b2000000-0000-4000-8000-000000000262', $zh$平移组合$zh$),
    ('b2000000-0000-4000-8000-000000000264', $zh$中点$zh$),
    ('b2000000-0000-4000-8000-000000000265', $zh$两个点$zh$),
    ('b2000000-0000-4000-8000-000000000268', $zh$两步$zh$),
    ('b2000000-0000-4000-8000-000000000269', $zh$五步$zh$),
    ('b2000000-0000-4000-8000-000000000271', $zh$无噪声$zh$),
    ('b2000000-0000-4000-8000-000000000272', $zh$纯噪声$zh$),
    ('b2000000-0000-4000-8000-000000000275', $zh$基础恢复$zh$),
    ('b2000000-0000-4000-8000-000000000276', $zh$无噪声$zh$),
    ('b2000000-0000-4000-8000-000000000279', $zh$从原点出发$zh$),
    ('b2000000-0000-4000-8000-000000000280', $zh$偏移噪声$zh$),
    ('b2000000-0000-4000-8000-000000000282', $zh$正向漂移$zh$),
    ('b2000000-0000-4000-8000-000000000283', $zh$大步长$zh$),
    ('b2000000-0000-4000-8000-000000000285', $zh$不使用 Guidance$zh$),
    ('b2000000-0000-4000-8000-000000000286', $zh$标准权重$zh$),
    ('b2000000-0000-4000-8000-000000000288', $zh$小 Chunk$zh$),
    ('b2000000-0000-4000-8000-000000000289', $zh$单行$zh$),
    ('b2000000-0000-4000-8000-000000000291', $zh$单次添加$zh$),
    ('b2000000-0000-4000-8000-000000000292', $zh$采样最后 n 项$zh$),
    ('b2000000-0000-4000-8000-000000000316', $zh$完整 Chunk$zh$),
    ('b2000000-0000-4000-8000-000000000295', $zh$截断 Chunk$zh$),
    ('b2000000-0000-4000-8000-000000000297', $zh$线性递增$zh$),
    ('b2000000-0000-4000-8000-000000000298', $zh$两个样本$zh$),
    ('b2000000-0000-4000-8000-000000000300', $zh$无 Padding$zh$),
    ('b2000000-0000-4000-8000-000000000301', $zh$屏蔽第二步$zh$),
    ('b2000000-0000-4000-8000-000000000303', $zh$大小 3$zh$),
    ('b2000000-0000-4000-8000-000000000304', $zh$完整窗口$zh$),
    ('b2000000-0000-4000-8000-000000000306', $zh$正奖励$zh$),
    ('b2000000-0000-4000-8000-000000000307', $zh$混合符号$zh$),
    ('b2000000-0000-4000-8000-000000000309', $zh$两个 Chunk$zh$),
    ('b2000000-0000-4000-8000-000000000310', $zh$三个 Chunk$zh$),
    ('b2000000-0000-4000-8000-000000000312', $zh$归一化两行$zh$)
) as v(id, name)
where c.id = v.id::uuid;

commit;
