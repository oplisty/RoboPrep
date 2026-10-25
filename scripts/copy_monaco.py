#!/usr/bin/env python3
"""Self-host the Monaco Editor runtime under public/monaco/vs.

@monaco-editor/react loads Monaco from cdn.jsdelivr.net by default, which the
site CSP (script-src 'self') blocks — the coding editor therefore never mounts
in production. This script copies the pinned monaco-editor package's min/vs
runtime (AMD build) into public/ so the editor loader can serve it same-origin.

Run after `pnpm install` (monaco-editor version changes require a re-run):

    python3 scripts/copy_monaco.py

public/monaco is committed to the repo so Vercel serves it without any extra
build step.
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SRC = REPO / "node_modules" / "monaco-editor" / "min" / "vs"
DST = REPO / "public" / "monaco" / "vs"


def main() -> None:
    if not SRC.is_dir():
        sys.exit("monaco-editor not installed — run `pnpm install` first")
    version = (REPO / "node_modules" / "monaco-editor" / "package.json").read_text()
    import json

    ver = json.loads(version)["version"]
    if DST.exists():
        shutil.rmtree(DST)
    DST.mkdir(parents=True)
    shutil.copytree(SRC, DST, dirs_exist_ok=True)
    (DST / "VERSION.txt").write_text(f"monaco-editor {ver}\n", encoding="utf-8")
    size_mb = sum(f.stat().st_size for f in DST.rglob("*") if f.is_file()) / 1e6
    print(f"copied monaco-editor {ver} min/vs -> public/monaco/vs ({size_mb:.1f} MB)")


if __name__ == "__main__":
    main()
