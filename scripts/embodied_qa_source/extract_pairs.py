#!/usr/bin/env python3
"""Extract existing-question rows from seed.sql + paired new answers from
parsed.json into review files for hand-authoring enrichments."""
import json
import re
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent.parent
SRC = BASE / "scripts" / "embodied_qa_source"


def parse_question_rows(sql: str) -> dict[str, list[str]]:
    """id-tail -> list of field values (string literals, '' unescaped)."""
    rows: dict[str, list[str]] = {}
    for m in re.finditer(r"'(f1000000-0000-4000-8000-[0-9a-f]{12})'", sql):
        i = m.end()
        fields = []
        # scan forward: expect sequences of  ,  'literal'  until ')'
        while True:
            # skip whitespace
            while i < len(sql) and sql[i] in " \t\r\n,":
                i += 1
            if i >= len(sql) or sql[i] != "'":
                break
            i += 1
            buf = []
            while i < len(sql):
                if sql[i] == "'":
                    if i + 1 < len(sql) and sql[i + 1] == "'":
                        buf.append("'")
                        i += 2
                        continue
                    i += 1
                    break
                buf.append(sql[i])
                i += 1
            fields.append("".join(buf))
        if len(fields) >= 7 and m.group(1) not in rows:
            rows[m.group(1)] = fields
    return rows


def main() -> None:
    sql = (BASE / "supabase" / "seed.sql").read_text(encoding="utf-8")
    rows = parse_question_rows(sql)
    by_slug = {}
    # questions inserts: (id, title, slug, type, difficulty, summary, canonical, deep, ...)
    for tail, f in rows.items():
        if f[2] in ("knowledge", "coding", "system_design", "research", "behavioral"):
            by_slug[f[1]] = {"id": tail, "title": f[0], "type": f[2], "difficulty": f[3],
                             "summary": f[4], "canonical": f[5], "deep": f[6]}
    print(f"existing questions: {len(by_slug)}")

    pairs = json.loads((SRC / "dup-pairs.json").read_text())
    parsed = json.loads((SRC / "parsed.json").read_text())
    by_new_slug = {e["slug"]: e for e in parsed["entries"]}

    out = []
    for new_slug, existing_slug in pairs:
        e = by_new_slug[new_slug]
        out.append("=" * 90)
        out.append(f"NEW {new_slug}  [{e['question_type']}/{e['difficulty']}/freq={e['freq']}]  {e['title']}")
        out.append(f"NEW-ANSWER:\n{e['canonical_answer']}")
        if e["common_mistakes"]:
            out.append(f"NEW-MISTAKES: {' | '.join(e['common_mistakes'])}")
        if existing_slug:
            q = by_slug.get(existing_slug)
            if q is None:
                out.append(f"!! EXISTING NOT FOUND: {existing_slug}")
                continue
            out.append("-" * 60)
            out.append(f"EXISTING {existing_slug}  id={q['id'][-12:]}  {q['title']}")
            out.append(f"EXISTING-CANONICAL:\n{q['canonical']}")
            out.append(f"EXISTING-DEEP:\n{q['deep']}")
        else:
            out.append("(no existing target — intra-import dup, handled by sibling new question)")
        out.append("")
    (SRC / "dup-review.txt").write_text("\n".join(out), encoding="utf-8")
    print(f"wrote {SRC / 'dup-review.txt'} ({len(pairs)} pairs)")


if __name__ == "__main__":
    main()
