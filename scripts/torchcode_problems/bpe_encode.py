"""BPE 分词（编码到 token id）（源自 TorchCode `bpe`，已获授权改写）。"""

PROBLEM = {
    "slug": "bpe-encode",
    "title": "实现 BPE 分词器编码",
    "difficulty": "medium",
    "category": "transformer",
    "description": (
        "从零实现 Byte Pair Encoding 编码。给定文本、按优先级排列的合并规则和词表，"
        "返回 token id 序列：\n\n"
        "    1. 把文本拆成字符列表作为初始 token；\n"
        "    2. 重复：找出所有相邻 token 对中**优先级最高**（merges 里下标最小）的对，"
        "把它在 token 列表中的所有出现（从左到右、不重叠）合并成一个新 token；\n"
        "    3. 直到没有任何相邻对出现在 merges 中；\n"
        "    4. 用 vocab 把每个 token 映射为 id，返回 list[int]。\n\n"
        "输入：text 为 str；merges 为 list[list[str]]（每项是 [left, right]）；"
        "vocab 为 dict[str, int]（包含所有字符和所有合并产物）。\n\n"
        "要求：\n"
        "- 一次合并必须处理该对在当前列表中的**所有**出现位置（从左到右扫描，合并后不重叠）；\n"
        "- 每轮只合并优先级最高的那一种对，然后重新扫描；\n"
        "- 不允许调用 transformers / tokenizers 等第三方库（framework=python，标准库即可）。"
    ),
    "constraints": "1 <= len(text) <= 200，text 只含小写字母和空格；len(merges) <= 100；vocab 覆盖所有需要的 token，id 唯一。",
    "evaluation_mode": "function",
    "entrypoint_type": "function",
    "entrypoint_name": "bpe_encode",
    "framework": "python",
    "resource_profile": "standard_python",
    "evaluator_config": {
        "comparison": "exact",
        "check_shape": False,
        "check_dtype": False,
        "check_gradient": False,
    },
}

STARTER = """def bpe_encode(text: str, merges: list, vocab: dict) -> list:
    # text: 输入文本；merges: [[left, right], ...] 按优先级排列；vocab: {token: id}
    # TODO: 返回 token id 列表
    return [vocab[c] for c in text]
"""

SOLUTION = """def bpe_encode(text: str, merges: list, vocab: dict) -> list:
    ranks = {(left, right): i for i, (left, right) in enumerate(merges)}
    tokens = list(text)
    while len(tokens) >= 2:
        best_rank = None
        best_pair = None
        for i in range(len(tokens) - 1):
            pair = (tokens[i], tokens[i + 1])
            rank = ranks.get(pair)
            if rank is not None and (best_rank is None or rank < best_rank):
                best_rank = rank
                best_pair = pair
        if best_pair is None:
            break
        merged = []
        i = 0
        while i < len(tokens):
            if i < len(tokens) - 1 and (tokens[i], tokens[i + 1]) == best_pair:
                merged.append(tokens[i] + tokens[i + 1])
                i += 2
            else:
                merged.append(tokens[i])
                i += 1
        tokens = merged
    return [vocab[token] for token in tokens]
"""


def build_cases():
    from framework import VALUE, case, visible_example

    # 经典 BPE 教材例子
    vocab_h = {"l": 0, "o": 1, "w": 2, "e": 3, "r": 4, " ": 5, "lo": 6, "low": 7, "er": 8, "low ": 9, "w e": 99}
    merges_h = [["l", "o"], ["lo", "w"], ["e", "r"], ["low", " "]]

    vocab_m = {"a": 0, "b": 1, "c": 2, "ab": 3, "abc": 4}
    merges_m = [["a", "b"], ["ab", "c"]]

    vocab_n = {"x": 0, "y": 1, "z": 2}
    merges_n = [["x", "y"]]

    vocab_i = {"h": 0, "i": 1, "ih": 2}

    return [
        visible_example(
            "经典 low 例子",
            args=["low low low", merges_h, vocab_h],
            expected=VALUE(),
        ),
        case("链式合并 abc", args=["abcbc", merges_m, vocab_m], expected=VALUE()),
        case("无可用合并", args=["zzyx", merges_n, vocab_n], expected=VALUE()),
        case("合并一次后停止", args=["ihi", [["i", "h"]], vocab_i], expected=VALUE()),
        case(
            "重叠对从左到右",
            args=["iiih", [["i", "i"], ["ii", "h"]], {"h": 0, "i": 1, "ii": 2}],
            expected=VALUE(),
        ),
    ]
