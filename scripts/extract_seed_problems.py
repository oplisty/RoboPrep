"""Extract coding_problems / coding_test_cases rows from a seed SQL file into
the JSON shape consumed by scripts/validate-seed-problems.ts.

Replaces the previously ad-hoc /tmp/extract_fixed.py so the seed validation
workflow is reproducible from the repo:

    python scripts/extract_seed_problems.py \
        supabase/seed_torchcode_problems.sql --out /tmp/torchcode_seed.json

    PYTHON_EXECUTABLE=<pinned venv python> node --experimental-strip-types \
        --loader ./scripts/tests/loader.mjs scripts/validate-seed-problems.ts \
        --input /tmp/torchcode_seed.json

The parser understands the seed files' regular INSERT shape: dollar-quoted
($tag$…$tag$) and single-quoted strings, line comments at paren depth 0, and
multi-row VALUES lists. It does not evaluate SQL expressions — values are
passed through as strings/JSON text.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def strip_comments_and_split_statements(sql: str) -> list[str]:
    statements: list[str] = []
    buf: list[str] = []
    i = 0
    n = len(sql)
    dollar_tag: str | None = None
    in_quote = False
    paren_depth = 0
    while i < n:
        ch = sql[i]
        if dollar_tag is not None:
            if sql.startswith(f"${dollar_tag}$", i):
                buf.append(sql[i : i + len(dollar_tag) + 2])
                i += len(dollar_tag) + 2
                dollar_tag = None
                continue
            buf.append(ch)
            i += 1
            continue
        if in_quote:
            if ch == "'":
                if i + 1 < n and sql[i + 1] == "'":
                    buf.append("''")
                    i += 2
                    continue
                in_quote = False
            buf.append(ch)
            i += 1
            continue
        if ch == "-" and i + 1 < n and sql[i + 1] == "-":
            while i < n and sql[i] != "\n":
                i += 1
            continue
        if ch == "'":
            in_quote = True
            buf.append(ch)
            i += 1
            continue
        if ch == "$":
            j = i + 1
            while j < n and (sql[j].isalnum() or sql[j] == "_"):
                j += 1
            if j < n and sql[j] == "$" and j > i + 1:
                tag = sql[i + 1 : j]
                buf.append(sql[i : j + 1])
                dollar_tag = tag
                i = j + 1
                continue
            buf.append(ch)
            i += 1
            continue
        if ch == "(":
            paren_depth += 1
        elif ch == ")":
            paren_depth -= 1
        elif ch == ";" and paren_depth == 0:
            stmt = "".join(buf).strip()
            if stmt:
                statements.append(stmt)
            buf = []
            i += 1
            continue
        buf.append(ch)
        i += 1
    tail = "".join(buf).strip()
    if tail:
        statements.append(tail)
    return statements


def split_top_level(s: str, sep: str = ",") -> list[str]:
    parts: list[str] = []
    buf: list[str] = []
    i = 0
    n = len(s)
    dollar_tag: str | None = None
    in_quote = False
    depth = 0
    while i < n:
        ch = s[i]
        if dollar_tag is not None:
            if s.startswith(f"${dollar_tag}$", i):
                buf.append(s[i : i + len(dollar_tag) + 2])
                i += len(dollar_tag) + 2
                dollar_tag = None
                continue
            buf.append(ch)
            i += 1
            continue
        if in_quote:
            if ch == "'":
                if i + 1 < n and s[i + 1] == "'":
                    buf.append("''")
                    i += 2
                    continue
                in_quote = False
            buf.append(ch)
            i += 1
            continue
        if ch == "$":
            j = i + 1
            while j < n and (s[j].isalnum() or s[j] == "_"):
                j += 1
            if j < n and sql_has_close(s, i, j):
                tag = s[i + 1 : j]
                buf.append(s[i : j + 1])
                dollar_tag = tag
                i = j + 1
                continue
            buf.append(ch)
            i += 1
            continue
        if ch == "'":
            in_quote = True
            buf.append(ch)
            i += 1
            continue
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif ch == sep and depth == 0:
            parts.append("".join(buf).strip())
            buf = []
            i += 1
            continue
        buf.append(ch)
        i += 1
    last = "".join(buf).strip()
    if last:
        parts.append(last)
    return parts


def sql_has_close(s: str, start: int, j: int) -> bool:
    return j < len(s) and s[j] == "$" and j > start + 1


def parse_literal(raw: str) -> str:
    raw = raw.strip()
    if raw.startswith("$"):
        j = raw.index("$", 1)
        tag = raw[1:j]
        close = f"${tag}$"
        if raw.endswith(close):
            return raw[j + 1 : -len(close)]
        raise ValueError(f"unterminated dollar quote: {raw[:40]!r}")
    if raw.startswith("'"):
        if not raw.endswith("'"):
            raise ValueError(f"unterminated string: {raw[:40]!r}")
        return raw[1:-1].replace("''", "'")
    return raw


def extract_insert(stmt: str, table: str) -> list[dict]:
    marker = f"insert into public.{table}"
    idx = stmt.lower().find(marker)
    if idx != 0:
        return []
    # columns list
    open_paren = stmt.index("(", len(marker))
    close_paren = stmt.index(")", open_paren)
    columns = [c.strip() for c in split_top_level(stmt[open_paren + 1 : close_paren])]
    values_idx = stmt.lower().index("values", close_paren)
    tail = stmt[values_idx + len("values") :]
    rows = split_top_level(tail)
    out = []
    for row in rows:
        row = row.strip()
        if not (row.startswith("(") and row.endswith(")")):
            raise ValueError(f"unexpected row shape: {row[:60]!r}")
        values = [parse_literal(v) for v in split_top_level(row[1:-1])]
        if len(values) != len(columns):
            raise ValueError(f"column/value count mismatch: {len(columns)} vs {len(values)}")
        out.append(dict(zip(columns, values)))
    return out


def extract_file(path: Path) -> dict:
    sql = path.read_text(encoding="utf-8")
    problems: list[dict] = []
    test_cases: list[dict] = []
    for stmt in strip_comments_and_split_statements(sql):
        problems.extend(extract_insert(stmt, "coding_problems"))
        test_cases.extend(extract_insert(stmt, "coding_test_cases"))
    return {"problems": problems, "testCases": test_cases}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("inputs", nargs="+", type=Path)
    parser.add_argument("--out", type=Path, default=None, help="default: stdout")
    args = parser.parse_args()

    merged: dict = {"problems": [], "testCases": []}
    for path in args.inputs:
        data = extract_file(path)
        merged["problems"].extend(data["problems"])
        merged["testCases"].extend(data["testCases"])

    text = json.dumps(merged, ensure_ascii=False, indent=1)
    if args.out:
        args.out.write_text(text, encoding="utf-8")
        print(f"extracted {len(merged['problems'])} problems, {len(merged['testCases'])} test cases -> {args.out}")
    else:
        print(text)


if __name__ == "__main__":
    main()
