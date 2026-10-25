#!/usr/bin/env python3
"""Parse the vendored embodied-interview-qa volumes into RoboPrep seed SQL.

Source: https://github.com/WinstonJQ/embodied-interview-qa (MIT), vendored
verbatim under scripts/embodied_qa_source/ at commit
001e42385d421294066767f286e786e378595f13 (2026-10-19).

Pipeline (three phases, run in order):
  parse   → scripts/embodied_qa_source/parsed.json    (structured entries + stats)
  dups    → scripts/embodied_qa_source/dup-report.json (overlap vs existing seed.sql)
  sql     → supabase/seed_embodied_interview_qa.sql  (final seed, idempotent)

Phase `sql` additionally embeds scripts/embodied_qa_source/enrichments.sql
(hand-authored UPDATE statements that merge source answers into existing
duplicate questions) and scripts/embodied_qa_source/skip-fuzzy.json
(curated fuzzy-duplicate slugs to skip) when those files exist.

Entry-filter rules:
  - `N`-prefixed entries (低频备选未入主表) are skipped: the source curator
    deliberately keeps them out of the main table.
  - Everything else (Q / Q17A / ✍ H / ✍ CH / F) is imported.
"""

from __future__ import annotations

import json
import re
import sys
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SRC_DIR = REPO / "scripts" / "embodied_qa_source"
SEED_OUT = REPO / "supabase" / "seed_embodied_interview_qa.sql"
EXISTING_SEED = REPO / "supabase" / "seed.sql"

SOURCE_REPO = "https://github.com/WinstonJQ/embodied-interview-qa"
SOURCE_COMMIT = "001e42385d421294066767f286e786e378595f13"

VOLUMES = [
    ("01_basics", "卷一 · 通识基础"),
    ("02_rl_algo", "卷二 · RL 算法"),
    ("03_vla_il", "卷三 · VLA / 模仿学习"),
    ("04_world_sim", "卷四 · 世界模型 / Sim2Real"),
    ("05_engineering", "卷五 · 工程落地"),
    ("06_legged_control", "卷六 · 腿足控制 / 遥操作"),
    ("07_perception_nav", "卷七 · 3D 感知 / SLAM / 导航"),
    ("08_coding_systemdesign", "卷八 · LeetCode + 系统设计"),
    ("09_frontier", "卷九 · 近期热门方向与前沿题目"),
]

# ---------------------------------------------------------------------------
# Topic plan: new topics (uuid tail, name, slug, parent tail, description)
# and the section-header → topic-slug mapping. Existing topic slugs refer to
# supabase/seed.sql.
# ---------------------------------------------------------------------------

NEW_TOPICS = [
    ("000000000028", "深度学习基础", "deep-learning-fundamentals", None,
     "面试常考的深度学习基本盘：优化器、归一化、梯度问题与 Transformer 细节。"),
    ("000000000029", "离线强化学习", "offline-rl", "000000000009",
     "CQL、IQL、BCQ 等从固定数据集学习的离线 RL 方法。"),
    ("000000000030", "工程落地", "robot-engineering", "000000000001",
     "VLA 部署、推理加速、训练工程、数据飞轮与真机排障。"),
    ("000000000031", "腿足控制", "legged-control", "000000000012",
     "浮动基座动力学、MPC、全身控制 WBC 与 RL locomotion。"),
    ("000000000032", "遥操作", "teleoperation", "000000000012",
     "AVP/VR 主从遥操作、人形遥操作与数据采集系统。"),
    ("000000000033", "SLAM 与 3D 感知", "slam-3d-perception", "000000000001",
     "点云、NeRF/3DGS、SLAM 与状态估计。"),
    ("000000000034", "具身导航", "embodied-navigation", "000000000001",
     "经典导航栈、VLN、零样本 ObjectNav 与导航排障。"),
    ("000000000035", "LeetCode 手撕", "leetcode-coding", None,
     "具身/自动驾驶算法岗高频 LeetCode 手写题（CodeTop 统计口径）。"),
    ("000000000036", "系统设计", "system-design", None,
     "ML 系统设计与机器人系统设计开放题。"),
    ("000000000037", "前沿方向", "frontier-directions", "000000000001",
     "近期热门方向的学习型问答（Jev、Astra、具身 Agent、RSI 等，非面经）。"),
]

# Keyed by (volume file stem, section header text without （N 题） suffix).
SECTION_TOPICS: dict[tuple[str, str], list[str]] = {
    ("01_basics", "深度学习基础"): ["deep-learning-fundamentals"],
    ("01_basics", "强化学习基础"): ["rl"],
    ("01_basics", "机器人学基础"): ["robotics"],
    ("01_basics", "手撕代码"): ["deep-learning-fundamentals"],
    ("02_rl_algo", "策略优化基础"): ["rl"],
    ("02_rl_algo", "PPO / TRPO"): ["ppo"],
    ("02_rl_algo", "SAC / TD3 / DDPG"): ["sac"],
    ("02_rl_algo", "DQN 与离散动作"): ["dqn"],
    ("02_rl_algo", "Offline RL"): ["offline-rl"],
    ("02_rl_algo", "RLHF / DPO / GRPO"): ["alignment", "grpo"],
    ("02_rl_algo", "工程 tricks 与机器人 RL"): ["rl", "reward-design"],
    ("02_rl_algo", "手撕代码"): ["rl"],
    ("03_vla_il", "模仿学习理论基础"): ["imitation-learning"],
    ("03_vla_il", "VLA 模型架构时间线"): ["vla"],
    ("03_vla_il", "Diffusion Policy / Flow Matching"): ["diffusion-policy", "flow-matching"],
    ("03_vla_il", "Action Chunking & ACT"): ["action-chunking"],
    ("03_vla_il", "视觉-语言对齐 & 数据"): ["vla", "robot-data"],
    ("03_vla_il", "推理优化 & 控制频率"): ["vla", "robot-engineering"],
    ("03_vla_il", "Sim2Real"): ["sim2real"],
    ("03_vla_il", "双系统 / 系统观 / 前沿判断"): ["vla"],
    ("03_vla_il", "项目拷打 / 工程实现"): ["vla", "robot-engineering"],
    ("03_vla_il", "手撕代码"): ["vla"],
    ("04_world_sim", "世界模型基础"): ["world-model"],
    ("04_world_sim", "Dreamer 系列进化"): ["world-model"],
    ("04_world_sim", "Sim2Real 基础"): ["sim2real"],
    ("04_world_sim", "Teacher-Student / 自适应方法"): ["sim2real"],
    ("04_world_sim", "仿真器选型与工程"): ["sim2real"],
    ("04_world_sim", "具身 Sim2Real 实战"): ["sim2real"],
    ("05_engineering", "感知-规划-控制系统架构"): ["robot-engineering"],
    ("05_engineering", "推理加速与边缘部署"): ["robot-engineering"],
    ("05_engineering", "训练工程"): ["distributed-training"],
    ("05_engineering", "数据飞轮与采集"): ["robot-data", "teleoperation"],
    ("05_engineering", "失败排查与调试"): ["robot-engineering"],
    ("05_engineering", "开放题与系统设计"): ["system-design", "robot-engineering"],
    ("05_engineering", "本次公开面经增补：Agent / Harness / 平台"): ["robot-engineering"],
    ("05_engineering", "本次公开面经增补：训练与真机现场"): ["robot-engineering"],
    ("05_engineering", "手撕代码"): ["robot-engineering"],
    ("06_legged_control", "浮动基座 / 动力学 / 接触建模"): ["legged-control"],
    ("06_legged_control", "MPC 系列"): ["legged-control"],
    ("06_legged_control", "全身控制 WBC"): ["legged-control"],
    ("06_legged_control", "RL-based locomotion"): ["legged-control", "rl"],
    ("06_legged_control", "人形遥操作 Teleop"): ["teleoperation"],
    ("06_legged_control", "Loco-manipulation / 上下身解耦"): ["legged-control"],
    ("06_legged_control", "Sim-to-Real for legged"): ["sim2real", "legged-control"],
    ("06_legged_control", "手撕代码"): ["legged-control"],
    ("07_perception_nav", "3D 感知基础"): ["slam-3d-perception"],
    ("07_perception_nav", "NeRF / 3DGS 在机器人里"): ["slam-3d-perception"],
    ("07_perception_nav", "SLAM 与状态估计"): ["slam-3d-perception"],
    ("07_perception_nav", "经典导航栈与地图表征"): ["embodied-navigation"],
    ("07_perception_nav", "VLN 视觉语言导航"): ["embodied-navigation"],
    ("07_perception_nav", "零样本 ObjectNav"): ["embodied-navigation"],
    ("07_perception_nav", "Embodied VLM"): ["vla"],
    ("07_perception_nav", "端到端 VLN-VLA 与前沿判断"): ["embodied-navigation", "vla"],
    ("07_perception_nav", "本次公开面经增补：数据筛选与导航排障"): ["embodied-navigation"],
    ("07_perception_nav", "手撕代码"): ["slam-3d-perception"],
    ("08_coding_systemdesign", "LeetCode 高频 30 题"): ["leetcode-coding"],
    ("08_coding_systemdesign", "ML 系统设计"): ["system-design"],
    ("08_coding_systemdesign", "机器人系统设计"): ["system-design", "robot-engineering"],
    ("09_frontier", "决策模型与机器人应用"): ["frontier-directions"],
    ("09_frontier", "通用模型控制与 VLA 协作"): ["frontier-directions", "vla"],
    ("09_frontier", "具身 Agent、Harness 与自我改进"): ["frontier-directions"],
}

# Extra topic links inferred from the title (applied on top of section topics).
KEYWORD_TOPICS: list[tuple[str, str]] = [
    ("PPO", "ppo"), ("TRPO", "ppo"), ("GRPO", "grpo"), ("RLHF", "alignment"),
    ("DPO", "alignment"), ("SAC", "sac"), ("TD3", "sac"), ("DDPG", "sac"),
    ("DQN", "dqn"), ("Diffusion", "diffusion-policy"), ("扩散", "diffusion-policy"),
    ("Flow Matching", "flow-matching"), ("流匹配", "flow-matching"),
    ("Action Chunk", "action-chunking"), ("ACT", "action-chunking"),
    ("chunk", "action-chunking"), ("π", "pi-series"), ("OpenVLA", "vla"),
    ("VLA", "vla"), ("世界模型", "world-model"), ("Dreamer", "world-model"),
    ("JEPA", "world-model"), ("Sim2Real", "sim2real"), ("仿真", "sim2real"),
    ("Isaac", "sim2real"), ("LoRA", "peft"), ("FSDP", "distributed-training"),
    ("DeepSpeed", "distributed-training"), ("蒸馏", "distributed-training"),
    ("量化", "robot-engineering"), ("遥操作", "teleoperation"), ("Teleop", "teleoperation"),
    ("MPC", "legged-control"), ("WBC", "legged-control"), ("SLAM", "slam-3d-perception"),
    ("NeRF", "slam-3d-perception"), ("3DGS", "slam-3d-perception"), ("点云", "slam-3d-perception"),
    ("VLN", "embodied-navigation"), ("ObjectNav", "embodied-navigation"),
    ("导航", "embodied-navigation"), ("SE(3)", "se3"), ("DH", "robotics"),
    ("IK", "robotics"), ("运动学", "robotics"), ("动力学", "legged-control"),
    ("KL", "alignment"), ("奖励", "reward-design"), ("KF", "slam-3d-perception"),
    ("EKF", "slam-3d-perception"), ("卡尔曼", "slam-3d-perception"),
]

SUMMARY_RE = re.compile(
    r'<summary><span class="lv lv-l(\d)">L\d</span>'
    r'(?:\s*<span class="freq"(?:\s+title="([^"]*)")?>([^<]+)</span>)?'
    r'(?:\s*<b>([^<]+)</b>)?\s*·\s*(.+?)</summary>',
    re.S,
)

LABEL_RE = re.compile(r"\*\*([^*]{1,16}?)\*\*[：:]")

# Blocks that are metadata, not answer content. Everything else in the body
# stays in canonical_answer verbatim (the corpus uses hundreds of ad-hoc
# content labels: 复杂度 / 直觉 / 关键对比 / 破例说明 / $K_P$（比例） …).
META_LABELS = {"易错", "题源", "核验", "资料", "性质", "题源补证", "题源与核验", "破例说明", "破例"}

# Top-level structural labels: a meta block always ends at one of these.
TOP_LEVEL_LABELS = META_LABELS | {"答", "考察点", "实现", "关键对比"}


def extract_parts(body: str) -> tuple[str, str | None, str | None]:
    """Return (canonical, mistakes, provenance) from a details body.

    Meta-labelled spans are removed from the body; all other text (including
    ad-hoc bold labels, formulas, code fences, tables) is preserved verbatim.
    A meta block ends at the next TOP_LEVEL_LABELS marker or at any bold label
    that starts a new paragraph (blank line before it) — inner ad-hoc labels
    on the same line (e.g. 易错 text containing **均值**：) stay inside the
    meta block instead of truncating it.
    """
    markers = [(m.start(), m.end(), m.group(1).strip()) for m in LABEL_RE.finditer(body)]

    def starts_new_block(pos: int) -> bool:
        prefix = body[:pos].rstrip(" \t")
        return prefix == "" or prefix.endswith("\n\n")

    def block_end(i: int) -> int:
        for j in range(i + 1, len(markers)):
            if markers[j][2] in TOP_LEVEL_LABELS or starts_new_block(markers[j][0]):
                return markers[j][0]
        return len(body)

    cut_spans: list[tuple[int, int]] = []
    mistakes = None
    provenance: list[str] = []
    for i, (start, end, label) in enumerate(markers):
        chunk_end = block_end(i)
        if label == "易错":
            mistakes = body[end:chunk_end].strip()
            cut_spans.append((start, chunk_end))
        elif label in META_LABELS:
            provenance.append(f"{label}：{body[end:chunk_end].strip()}")
            cut_spans.append((start, chunk_end))

    canonical_parts: list[str] = []
    pos = 0
    for start, end in sorted(cut_spans):
        canonical_parts.append(body[pos:start])
        pos = end
    canonical_parts.append(body[pos:])
    canonical = "".join(canonical_parts)
    canonical = re.sub(r"\n{3,}", "\n\n", canonical).strip()
    # The page already titles the section 标准答案; drop a leading 答 marker.
    canonical = re.sub(r"^\*\*答\*\*[：:]\s*", "", canonical)
    return canonical, mistakes, ("\n\n".join(provenance) or None)


def block_text(body: str, label: str) -> str | None:
    """Text of the first `**label**：` block, ended by the next bold label."""
    markers = [(m.start(), m.end(), m.group(1).strip()) for m in LABEL_RE.finditer(body)]
    for i, (start, end, lab) in enumerate(markers):
        if lab == label:
            chunk_end = markers[i + 1][0] if i + 1 < len(markers) else len(body)
            return body[end:chunk_end].strip()
    return None


def parse_freq(label: str | None) -> tuple[int | None, str]:
    """Return (freq_count, freq_label)."""
    if label is None:
        return None, "未标频次"
    label = label.strip()
    m = re.match(r"🔥×(\d+)", label)
    if m:
        return int(m.group(1)), label
    if label.startswith("低频实录"):
        m2 = re.search(r"(\d+)源", label)
        return (int(m2.group(1)) if m2 else 1), label
    if label.startswith("前沿拓展"):
        return 0, label
    return None, label


def split_blocks(body: str) -> dict[str, str]:
    """Split the answer body into `**label**：` blocks (first occurrence wins)."""
    markers = [(m.start(), m.end(), m.group(1).strip()) for m in LABEL_RE.finditer(body)]
    blocks: dict[str, str] = {}
    for i, (start, end, label) in enumerate(markers):
        chunk_end = markers[i + 1][0] if i + 1 < len(markers) else len(body)
        blocks.setdefault(label, body[end:chunk_end].strip())
    return blocks


def clean_title(raw: str) -> str:
    title = raw.strip()
    title = re.sub(r"【[^】]*】\s*$", "", title).strip()
    return re.sub(r"\s+", " ", title)


def first_sentence(text: str, limit: int = 110) -> str:
    text = text.strip()
    line = text.split("\n", 1)[0].strip()
    line = re.sub(r"^[-*•] +", "", line)  # strip a leading list bullet, not bold markers
    # Accumulate sentence fragments until one ends conclusively (not a colon).
    result = ""
    for part in re.split(r"(?<=[。；？！])", line):
        if not part:
            continue
        result += part
        if not result.rstrip().endswith("：") or len(result) > limit:
            break
    result = result.strip()
    if result.endswith("："):
        result = result[:-1] + "。"
    if len(result) > limit:
        result = result[: limit - 1] + "…"
    return result


def split_mistakes(text: str | None) -> list[str]:
    if not text:
        return []
    items: list[str] = []
    for raw in re.split(r"[；;\n]+", text):
        item = raw.strip()
        item = re.sub(r"^[-*•]\s*", "", item)
        item = re.sub(r"^\d+[.、)]\s*", "", item)
        if item:
            items.append(item)
    return items[:8]


def question_type_for(volume: str, section: str, prefix: str) -> str:
    if volume == "08_coding_systemdesign":
        return "coding" if section.startswith("LeetCode") else "system_design"
    if volume == "09_frontier":
        return "research"
    if prefix in ("H", "CH"):
        return "coding"
    return "knowledge"


def estimated_minutes(qtype: str, level: int) -> int:
    if qtype in ("coding", "system_design"):
        return 10
    return {1: 3, 2: 5, 3: 8}.get(level, 4)


def apply_corrections(entries: list[dict]) -> int:
    """Apply reviewed content fixes from corrections.json (see review pass).

    Each item: {"slug", "reason", "patches": [{"field": "canonical_answer",
    "old": "...", "new": "..."}], "mistakes": [{"index": 0, "new": "..."}]}.
    Patches assert the old text exists so stale corrections fail loudly.
    """
    path = SRC_DIR / "corrections.json"
    if not path.exists():
        return 0
    fixes = json.loads(path.read_text(encoding="utf-8"))
    by_slug = {e["slug"]: e for e in entries}
    applied = 0
    for fix in fixes:
        e = by_slug.get(fix["slug"])
        if e is None:
            raise SystemExit(f"corrections: unknown slug {fix['slug']}")
        for p in fix.get("patches", []):
            field = p["field"]
            if p["old"] not in (e[field] or ""):
                raise SystemExit(f"corrections: stale patch for {fix['slug']} ({field}): {p['old'][:40]!r}")
            e[field] = (e[field] or "").replace(p["old"], p["new"])
            applied += 1
        for m in fix.get("mistakes", []):
            e["common_mistakes"][m["index"]] = m["new"]
            applied += 1
    print(f"corrections applied: {applied} (from {len(fixes)} items)")
    return applied


# ---------------------------------------------------------------------------
# Phase 1: parse
# ---------------------------------------------------------------------------

def cmd_parse() -> None:
    entries = []
    skipped_n = 0
    errors = []

    for volume, volume_title in VOLUMES:
        lines = (SRC_DIR / f"{volume}.md").read_text(encoding="utf-8").split("\n")
        section = None
        idx = 0
        while idx < len(lines):
            line = lines[idx]
            if line.startswith("## "):
                header = line[3:].strip()
                header = re.sub(r"^§[A-Za-z0-9]+\s*", "", header)  # drop §1 / §H / §A prefix
                section = re.sub(r"[（(][^）)]*[）)]\s*$", "", header).strip()
            if "<details" in line:
                block_lines = [line]
                while "</details>" not in block_lines[-1] and idx + 1 < len(lines):
                    idx += 1
                    block_lines.append(lines[idx])
                block = "\n".join(block_lines)

                m = SUMMARY_RE.search(block)
                if not m:
                    errors.append(f"{volume} L{idx + 1}: unparsable summary")
                    idx += 1
                    continue
                level_raw, _note, freq_label, qid_raw, title_raw = m.groups()
                qid = (qid_raw or "").replace("✍", "").strip()
                prefix_match = re.match(r"([A-Z]+)", qid)
                prefix = prefix_match.group(1) if prefix_match else ""

                if prefix == "N" or (section or "").startswith("低频备选"):
                    skipped_n += 1
                    idx += 1
                    continue

                body = block[block.find("</summary>") + len("</summary>"):]
                body = body[: body.rfind("</details>")].strip()
                canonical, mistakes_raw, provenance = extract_parts(body)
                freq, freq_label_norm = parse_freq(freq_label)
                title = clean_title(title_raw)
                qtype = question_type_for(volume, section or "", prefix)

                if qtype == "coding":
                    keypoints = block_text(body, "考察点") or ""
                    short_answer = keypoints or canonical.split("\n\n", 1)[0]
                else:
                    short_answer = canonical.split("\n\n", 1)[0].strip()
                summary = first_sentence(short_answer or canonical)

                slug = f"eaq-v{volume[:2]}-{qid.lower()}"

                section_key = (volume, section or "")
                topics = list(SECTION_TOPICS.get(section_key, []))
                if not topics:
                    errors.append(f"{volume} §{section}: NO TOPIC MAPPING for {qid} {title[:30]}")
                for kw, topic in KEYWORD_TOPICS:
                    if kw.lower() in title.lower() and topic not in topics:
                        topics.append(topic)
                topics = topics[:4]

                entries.append({
                    "volume": volume,
                    "volume_no": volume[:2],
                    "volume_title": volume_title,
                    "section": section,
                    "qid": qid,
                    "slug": slug,
                    "title": title,
                    "level": int(level_raw),
                    "difficulty": {1: "easy", 2: "medium", 3: "hard"}[int(level_raw)],
                    "question_type": qtype,
                    "freq": freq,
                    "freq_label": freq_label_norm,
                    "summary": summary,
                    "short_answer": short_answer or None,
                    "canonical_answer": canonical or None,
                    "common_mistakes": split_mistakes(mistakes_raw),
                    "estimated_minutes": estimated_minutes(qtype, int(level_raw)),
                    "is_featured": bool(freq is not None and freq >= 15),
                    "topics": topics,
                    "provenance": provenance or None,
                })
            idx += 1

    slugs = [e["slug"] for e in entries]
    assert len(slugs) == len(set(slugs)), "duplicate slugs!"
    apply_corrections(entries)

    by_title: dict[str, list[str]] = {}
    for e in entries:
        by_title.setdefault(e["title"], []).append(e["slug"])
    intra_dups = {t: s for t, s in by_title.items() if len(s) > 1}

    parsed = {"entries": entries, "errors": errors, "skipped_n": skipped_n, "intra_dups": intra_dups}
    (SRC_DIR / "parsed.json").write_text(json.dumps(parsed, ensure_ascii=False, indent=1), encoding="utf-8")

    print(f"parsed: {len(entries)} entries, skipped N/低频备选: {skipped_n}, errors: {len(errors)}")
    print("by type:", dict(Counter(e["question_type"] for e in entries)))
    print("by volume:", dict(Counter(e["volume"] for e in entries)))
    print("with freq:", sum(1 for e in entries if e["freq"] is not None),
          "| featured:", sum(1 for e in entries if e["is_featured"]),
          "| with mistakes:", sum(1 for e in entries if e["common_mistakes"]))
    if intra_dups:
        print(f"intra-title dups: {len(intra_dups)}")
        for t, slugs in list(intra_dups.items())[:12]:
            print("  -", t[:44], slugs)
    for err in errors[:30]:
        print("ERR:", err)


# ---------------------------------------------------------------------------
# Phase 2: dups vs existing seed
# ---------------------------------------------------------------------------

def norm_title(t: str) -> str:
    t = re.sub(r"【[^】]*】", "", t)
    return re.sub(r"[^\w\u4e00-\u9fff]+", "", t).lower()


def bigrams(s: str) -> set[str]:
    return {s[i:i + 2] for i in range(len(s) - 1)} if len(s) > 1 else {s}


def jaccard(a: set[str], b: set[str]) -> float:
    return len(a & b) / len(a | b) if a | b else 0.0


def load_existing_questions() -> list[dict]:
    sql = EXISTING_SEED.read_text(encoding="utf-8")
    pattern = re.compile(
        r"'(f1000000-0000-4000-8000-[0-9a-f]{12})'\s*,\s*\n?\s*'((?:[^']|'')+?)'\s*,"
        r"\s*\n?\s*'([a-z0-9-]+)'\s*,\s*\n?\s*'(knowledge|coding|system_design|research|behavioral)'",
    )
    return [
        {"id": m.group(1), "title": m.group(2).replace("''", "'"), "slug": m.group(3), "type": m.group(4)}
        for m in pattern.finditer(sql)
    ]


def cmd_dups() -> None:
    parsed = json.loads((SRC_DIR / "parsed.json").read_text(encoding="utf-8"))
    existing = load_existing_questions()
    print(f"existing questions parsed from seed.sql: {len(existing)}")

    norm_existing = [(norm_title(q["title"]), q) for q in existing]
    exact, fuzzy = [], []
    for e in parsed["entries"]:
        ne = norm_title(e["title"])
        exact_hit = None
        for nt, q in norm_existing:
            if ne == nt:
                exact_hit = q
                break
        if exact_hit:
            exact.append({"new": e, "existing": exact_hit})
            continue
        be = bigrams(ne)
        best, best_score = None, 0.0
        for nt, q in norm_existing:
            if min(len(nt), len(ne)) < 6:
                continue
            score = jaccard(be, bigrams(nt))
            if score > best_score:
                best, best_score = q, score
        if best and best_score >= 0.40:
            fuzzy.append({"new": e, "existing": best, "score": round(best_score, 3)})

    report = {
        "exact": [{"slug": d["new"]["slug"], "title_new": d["new"]["title"],
                   "existing_slug": d["existing"]["slug"], "title_existing": d["existing"]["title"]}
                  for d in exact],
        "fuzzy": [{"slug": d["new"]["slug"], "title_new": d["new"]["title"],
                   "existing_slug": d["existing"]["slug"], "title_existing": d["existing"]["title"],
                   "score": d["score"]} for d in sorted(fuzzy, key=lambda x: -x["score"])],
    }
    (SRC_DIR / "dup-report.json").write_text(json.dumps(report, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"exact dups: {len(exact)}, fuzzy candidates: {len(fuzzy)}")
    for d in exact:
        print(f"  EXACT  {d['new']['slug']}  ⇄  {d['existing']['slug']}")
    for d in report["fuzzy"]:
        print(f"  FUZZY {d['score']:.2f}  {d['slug']}「{d['title_new'][:38]}」 ⇄ 「{d['title_existing'][:38]}」")


# ---------------------------------------------------------------------------
# Phase 3: SQL emission
# ---------------------------------------------------------------------------

def sql_str(value: str | None) -> str:
    if value is None:
        return "null"
    return "'" + value.replace("'", "''") + "'"


def sql_json(value) -> str:
    return sql_str(json.dumps(value, ensure_ascii=False, separators=(",", ":")))


def load_topic_uuids() -> dict[str, str]:
    """slug → FULL uuid for both new topics here and topics in seed.sql."""
    lookup = {
        slug: uuid
        for uuid, slug in re.findall(
            r"'(d1000000-0000-4000-8000-[0-9a-f]{12})',\s*'[^']+',\s*'([a-z0-9-]+)'",
            EXISTING_SEED.read_text(encoding="utf-8"),
        )
    }
    for tail, _name, slug, _parent, _desc in NEW_TOPICS:
        lookup[slug] = f"d1000000-0000-4000-8000-{tail}"
    # Guard: every value must be a well-formed uuid (catches double-prefix bugs).
    bad = [v for v in lookup.values() if not re.fullmatch(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", v)]
    if bad:
        raise SystemExit(f"malformed topic uuids: {bad}")
    return lookup


def cmd_sql() -> None:
    parsed = json.loads((SRC_DIR / "parsed.json").read_text(encoding="utf-8"))
    dup_report = json.loads((SRC_DIR / "dup-report.json").read_text(encoding="utf-8"))
    entries = parsed["entries"]

    skip_slugs = {d["slug"] for d in dup_report["exact"]}
    curated = SRC_DIR / "skip-fuzzy.json"
    if curated.exists():
        skip_slugs |= set(json.loads(curated.read_text(encoding="utf-8")))
    entries = [e for e in entries if e["slug"] not in skip_slugs]

    topic_uuid = load_topic_uuids()
    out: list[str] = []
    w = out.append
    w("-- -------------------------------------------------------------------------")
    w("-- RoboPrep — Knowledge 题库补充：embodied-interview-qa 全量导入")
    w("--")
    w("-- 题源：WinstonJQ/embodied-interview-qa（MIT License）")
    w(f"--       {SOURCE_REPO} @ {SOURCE_COMMIT[:12]} (2026-10-19)")
    w("-- 导入口径：跳过源库「N 备选」（19 条，维护者明确不入主表）；与现有题重复的")
    w("-- 条目不重复插入，改为在文件末尾以 UPDATE 融合答案（见 enrichments 段）。")
    w("-- 幂等：topics / questions / question_topics 均 on conflict do nothing。")
    w("-- 生成方式：python3 scripts/generate_embodied_qa_seed.py sql（勿手改）。")
    w("-- -------------------------------------------------------------------------")
    w("")

    w("-- -------------------------------------------------------------------------")
    w("-- 新增 topics（复用 seed.sql 既有 topic 体系）")
    w("-- -------------------------------------------------------------------------")
    w("insert into public.topics (id, name, slug, parent_id, description) values")
    rows = []
    for tail, name, slug, parent, desc in NEW_TOPICS:
        parent_ref = f"'d1000000-0000-4000-8000-{parent}'" if parent else "null"
        rows.append(f"  ('d1000000-0000-4000-8000-{tail}', {sql_str(name)}, {sql_str(slug)}, {parent_ref}, {sql_str(desc)})")
    w(",\n".join(rows))
    w("on conflict (slug) do nothing;")
    w("")

    w("-- -------------------------------------------------------------------------")
    w("-- 新增 questions")
    w("-- -------------------------------------------------------------------------")
    cols = ("id, title, slug, question_type, difficulty, summary, short_answer, "
            "canonical_answer, deep_answer, key_points, common_mistakes, interview_tips, "
            "estimated_minutes, is_featured, is_published, source_freq, source_meta")

    next_id = 80  # seed.sql 目前用到 …0079
    id_by_slug: dict[str, str] = {}
    values = []
    for e in entries:
        qid = f"f1000000-0000-4000-8000-{next_id:012d}"
        next_id += 1
        id_by_slug[e["slug"]] = qid
        meta = {
            "source": "embodied-interview-qa",
            "repo": SOURCE_REPO,
            "commit": SOURCE_COMMIT,
            "license": "MIT",
            "volume": e["volume_no"],
            "volume_title": e["volume_title"],
            "section": e["section"],
            "qid": e["qid"],
            "freq_label": e["freq_label"],
        }
        if e["provenance"]:
            meta["provenance"] = e["provenance"][:600]
        values.append(
            "  ('{id}', {title}, {slug}, {type}, {diff}, {summary},\n"
            "   {short}, {canonical},\n"
            "   null, null, {mistakes}::jsonb, null, {minutes}, {featured}, true, {freq}, {meta}::jsonb)".format(
                id=qid,
                title=sql_str(e["title"]),
                slug=sql_str(e["slug"]),
                type=sql_str(e["question_type"]),
                diff=sql_str(e["difficulty"]),
                summary=sql_str(e["summary"]),
                short=sql_str(e["short_answer"]),
                canonical=sql_str(e["canonical_answer"]),
                mistakes=sql_str(json.dumps(e["common_mistakes"], ensure_ascii=False)),
                minutes=e["estimated_minutes"],
                featured="true" if e["is_featured"] else "false",
                freq=str(e["freq"]) if e["freq"] is not None else "null",
                meta=sql_json(meta),
            )
        )
    w(f"insert into public.questions ({cols}) values")
    w(",\n".join(values))
    w("on conflict (slug) do nothing;")
    w("")

    w("-- -------------------------------------------------------------------------")
    w("-- question_topics 关联")
    w("-- -------------------------------------------------------------------------")
    links = []
    for e in entries:
        for t in e["topics"]:
            tu = topic_uuid.get(t)
            if not tu:
                raise SystemExit(f"unknown topic slug: {t} (question {e['slug']})")
            links.append(f"  ('{id_by_slug[e['slug']]}', '{tu}', 1.0)")
    w("insert into public.question_topics (question_id, topic_id, weight) values")
    w(",\n".join(links))
    w("on conflict (question_id, topic_id) do nothing;")
    w("")

    enrich_path = SRC_DIR / "enrichments.sql"
    if enrich_path.exists():
        w("-- -------------------------------------------------------------------------")
        w("-- 答案融合：源题库与现有重复题的答案合并（人工撰写，逐条复核）")
        w("-- -------------------------------------------------------------------------")
        w(enrich_path.read_text(encoding="utf-8").rstrip())
        w("")

    SEED_OUT.write_text("\n".join(out) + "\n", encoding="utf-8")
    # Post-write guard: no double-prefixed uuid may ever reach the database.
    final_sql = SEED_OUT.read_text(encoding="utf-8")
    for marker in ("8000-d1000000", "8000-f1000000"):
        if marker in final_sql:
            raise SystemExit(f"malformed double-prefixed uuid in generated seed near {marker}")
    print(f"wrote {SEED_OUT}")
    print(f"questions: {len(entries)} (skipped {len(skip_slugs)} dups), topic links: {len(links)}")


def main() -> None:
    if len(sys.argv) != 2 or sys.argv[1] not in ("parse", "dups", "sql"):
        print(__doc__)
        sys.exit(1)
    {"parse": cmd_parse, "dups": cmd_dups, "sql": cmd_sql}[sys.argv[1]]()


if __name__ == "__main__":
    main()
