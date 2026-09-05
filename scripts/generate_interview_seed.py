#!/usr/bin/env python3
"""Generate the interview seed block in supabase/seed.sql from the OCR corpus.

Source corpus: 2026小红书具身智能面经_图片OCR问答版/ (97 posts, 34 companies).
The script is idempotent: it rewrites the region between the BEGIN/END markers
inside supabase/seed.sql. Everything outside the markers is left untouched.

Usage: python3 scripts/generate_interview_seed.py
"""

from __future__ import annotations

import re
import uuid
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CORPUS = ROOT / "2026小红书具身智能面经_图片OCR问答版"
SEED = ROOT / "supabase" / "seed.sql"

BEGIN_MARKER = "-- >>> BEGIN generated interview posts (2026小红书具身智能面经_图片OCR问答版) — DO NOT EDIT; regenerate with scripts/generate_interview_seed.py"
END_MARKER = "-- <<< END generated interview posts"

NS = uuid.uuid5(uuid.NAMESPACE_URL, "roboprep/seed-interviews")

# Existing placeholder companies in seed.sql reused for identical real companies.
EXISTING_COMPANY_IDS = {
    "字节跳动 Seed": ("c1000000-0000-4000-8000-000000000001", "字节跳动 Seed"),
    "宇树科技": ("c1000000-0000-4000-8000-000000000005", "宇树科技"),
    "智元机器人": ("c1000000-0000-4000-8000-000000000006", "智元机器人"),
}

COMPANY_SLUGS = {
    "乐聚机器人": "leju-robotics",
    "京东": "jd",
    "众擎机器人": "engineai",
    "优必选": "ubtech",
    "千寻智能": "spirit-ai",
    "华为": "huawei",
    "卓驭科技": "zhuoyu-tech",
    "卧安机器人": "woan-robotics",
    "原力灵机": "yuanli-lingji",
    "Momenta Mstar": "momenta-mstar",
    "银河通用": "galbot",
    "拓竹科技": "bambu-lab",
    "商汤科技": "sensetime",
    "它石智航": "tashi-zhihang",
    "宇树科技": "unitree",
    "小米": "xiaomi",
    "小马智行": "pony-ai",
    "小鹏汽车": "xpeng",
    "思灵机器人": "agilex-robotics",
    "星动纪元": "robot-era",
    "星海图": "galaxea",
    "普渡机器人": "pudu-robotics",
    "智元机器人": "agibot",
    "智源研究院": "baaai",
    "正行创新": "zhengxing-innovation",
    "灵初智能": "lingchu-zhineng",
    "米哈游": "mihoyo",
    "腾讯": "tencent",
    "自变量机器人": "zibianliang-robotics",
    "蜜雪冰城": "mixue-bingcheng",
    "逐际动力": "limx-dynamics",
    "阿里巴巴": "alibaba",
    "智谱 AI": "zhipu-ai",
    "字节跳动 Seed": "bytedance-seed",
}

BIG_TECH = {"京东", "华为", "小米", "小马智行", "小鹏汽车", "米哈游", "腾讯", "阿里巴巴", "字节跳动 Seed", "智谱 AI", "商汤科技", "卓驭科技"}

CN_NUM = {"一": 1, "二": 2, "三": 3, "四": 4, "五": 5, "六": 6, "七": 7}


def uid(kind: str, key: str) -> str:
    return str(uuid.uuid5(NS, f"{kind}/{key}"))


def sql(value: str | None) -> str:
    if value is None:
        return "null"
    return "'" + value.replace("'", "''") + "'"


def parse_meta(text: str, key: str) -> str | None:
    m = re.search(rf"^- {re.escape(key)}：(.*)$", text, re.M)
    return m.group(1).strip() if m else None


def parse_section(text: str, header_prefix: str) -> str | None:
    pattern = rf"^## {re.escape(header_prefix)}.*?$\n(.*?)(?=^## |\Z)"
    m = re.search(pattern, text, re.M | re.S)
    return m.group(1).strip() if m else None


def clean(text: str) -> str:
    lines = [ln for ln in text.splitlines() if ln.strip() != "--- 图片分隔 ---"]
    return re.sub(r"[ \t]+", " ", "\n".join(lines)).strip()


# Items that are the blogger's narration/marketing, never an interviewer's question.
EMOJI_RE = re.compile(r"[\U0001F000-\U0001FAFF\u2600-\u27BF\u2B00-\u2BFF\uFE0F\u20E3]")
META_RE = re.compile(
    r"(看完最大感受|今天解析|主包|朋友们|我的笔记|笔记里|专题讲解|视频讲解|精讲"
    r"|公众号|点赞|收藏|私信|评论区|上一篇|下一篇|求关注|欢迎关注|一键三连|内推"
    r"|投递简历|独家面经|工作日常|成长体验)"
)
META_ITEMS = {"轻微八股拷打", "八股拷打", "纯八股拷打", "整体感受", "总结"}


def clean_question(text: str) -> tuple[str, str | None]:
    """Strip emoji/blogger meta from a question; return (wording, context).

    Text before the last `第N题` marker is blogger commentary — kept as
    question_context only when it carries expected-answer points.
    """
    text = re.sub(r"[ \t]+", " ", clean(text))
    text = EMOJI_RE.sub("", text)
    text = re.sub(r"\s+", " ", text).strip()
    context = None
    markers = list(re.finditer(r"第[一二三四五六七八九十\d]+\s*题(?:继续|更狠|更进一步)?[:：]?", text))
    if markers:
        last = markers[-1]
        head = text[: last.start()].strip(" ：:，,")
        if head and not META_RE.search(head):
            context = head
        text = text[last.end():].strip()
    text = re.sub(r"^(?:追问|follow[\s-]*up|面试官问?|考官|问)[:：]\s*", "", text, flags=re.I)
    text = re.sub(r"[（(]附[^）)]*[）)]$", "", text).strip()
    if "思路：" in text or "思路:" in text:
        parts = re.split(r"思路[:：]", text, maxsplit=1)
        if len(parts[0].strip()) >= 8:
            return parts[0].strip(" ，。"), parts[1].strip()
    if "答：" in text or "答:" in text:
        return "", None  # OCR merged a Q with its answer; not usable as a question
    return text.strip(" 👉✅➡•、，。 "), context


def is_real_question(wording: str) -> bool:
    if not wording or wording in META_ITEMS:
        return False
    if wording.startswith("原帖记录了哪些"):
        return False
    if len(wording) < 150 and STRONG_STATUS_RE.search(wording):
        return False
    if META_RE.search(wording):
        return False
    return True


BOILER_RE = re.compile(r"(页面正文未提供可复制文字|原帖没有可复制正文|原帖正文没有可复制文字|未识别出有效文字|未提供可识别的具体面试内容|不具参考价值)")
STATUS_RE = re.compile(r"(一面[过挂]|二面[过挂]|[三四五]面[过挂]|面后挂|hr\s*面|等\s*oc|已\s*oc|已拒|待面试|复活|投递|面试中|拒|等开奖|开奖|泡池子|测评挂|出面经|已力竭|待转正)")
STRONG_STATUS_RE = re.compile(r"(泡池子|等开奖|待投递|测评挂|已力竭|出面经|面后挂|已\s*oc|待面试|等[一二三四五]面)")


def has_interview_value(questions: list[dict], summary: str | None) -> bool:
    """A post is worth importing when it has real questions, or a summary that
    describes the interviews instead of being an empty shell or a status tracker."""
    if questions:
        return True
    text = clean(summary or "")
    if not text or BOILER_RE.search(text):
        return False
    # pure progress trackers ("一面过 二面过 已oc 拒 …") carry no interview content
    if len(text) < 90 and STATUS_RE.search(text) and "？" not in text:
        return False
    if len(text) < 150 and STRONG_STATUS_RE.search(text):
        return False
    return True


TOPIC_SIGNAL_RE = re.compile(
    r"(介绍|原理|区别|如何|怎么|为什么|哪些|了解|设计|选取|架构|流程|因素|速率|定律|认知"
    r"|方向|模式|布局|放置|趋势|模型|电路|芯片|传感器|机器人|灵巧手|项目|采样|通信"
    r"|电容|电阻|晶振|JD|手撕|框架|亮点|采集|外围|滤波|等效|谐振|阻抗|培养|就业"
    r"|八股|笔试|选型|器件|参数|规划|仿真|部署|训练|微调|规划)"
)
NARRATION_RE = re.compile(
    r"(答了|问了|问的|挂了|过了|聊了|学了|答不上|收获|没想到|居然|竟然|面试官|本人"
    r"|主包|问我|我都|已经|我投|投的|投了|拿到的|挖简历|面了|约了|很深|很快|感动|体验|压力"
    r"|就OK|就行了|个人感觉|导师|经验贴|背诵|掺杂|基本没|一直问|公司$|印象|启发|给你讲|基本都|没怎么|非常快|较多较细)"
)
LEAD_RE = re.compile(r"^(?:先是|首先|然后|接着|最后|再|另外|同时|所以|因为|由于|其中|包括|此外|整体|还有|以及|加上|是|就是)+")
LABEL_RE = re.compile(r"^[^：:，,]{2,8}相关[:：]\s*")


def split_topic_list(text: str) -> list[dict]:
    """Last resort for posts that enumerate asked topics with commas
    ("自我介绍，传感器的采集原理，……，SPI通信速率，奈奎斯特采样定律")."""
    text = clean(text)
    if not text:
        return []
    # blogger asides like "(问的很深，我都已经把电偶极子，感应电荷都答了)" become separators
    text = re.sub(r"[（(][^（）()]*?(?:问的|我都|答了|层面|投的|投了)[^（）()]*[）)]", "，", text)
    segs: list[str] = []
    buf: list[str] = []
    depth = 0
    for ch in text:
        if ch in "（(":
            depth += 1
        elif ch in "）)":
            depth = max(0, depth - 1)
        if (ch in "，,；;、。\n" or (ch == " " and depth == 0 and buf and re.match(r"[\u4e00-\u9fff]", buf[-1]))) and depth == 0:
            segs.append("".join(buf))
            buf = []
        else:
            buf.append(ch)
    segs.append("".join(buf))

    items: list[dict] = []
    for raw in segs:
        seg = re.sub(r"^(?:面试内容|面试过程|面试问题|面试题型)[:：]\s*", "", clean(raw)).strip()
        seg = LABEL_RE.sub("", seg).strip()
        seg = re.sub(r"\s*(?:最后|然后|接着)[^，,；;。\s]{0,8}$", "", seg).strip()
        seg = LEAD_RE.sub("", seg).strip(" ：:。，、")
        if not (4 <= len(seg) <= 50):
            continue
        # drop blogger asides inside parentheses, keep the substantive remainder
        seg = re.sub(r"[（(][^（）()]*[）)]", "", seg).strip()
        if not (4 <= len(seg) <= 50):
            continue
        if NARRATION_RE.search(seg):
            continue
        if not TOPIC_SIGNAL_RE.search(seg):
            continue
        cleaned = make_item(seg, None)
        if cleaned:
            items.append(cleaned)
    return items if len(items) >= 3 else []


def split_numbered(text: str) -> list[str]:
    segs = re.split(r"(?:(?<=^)|(?<=[\s；。]))(?=\d{1,2}[\.、])", text)
    segs = [s.strip() for s in segs if re.match(r"^\d{1,2}[\.、]", s.strip())]
    if len(segs) >= 3 and segs[0].startswith(("1.", "1、")):
        return [re.sub(r"^\d{1,2}[\.、]\s*", "", s).strip() for s in segs]
    return []


def make_item(q: str, a: str | None) -> dict | None:
    q, ctx = clean_question(q)
    if not is_real_question(q):
        return None
    return {"wording": q, "answer": a, "notes": None, "context": ctx}


def split_narrative(text: str) -> list[dict]:
    """Decompose a narrative-only post into per-item entries.

    Layered: 问/答 dialogue pairs → numbered question lists → sentence split.
    Only genuine interviewer questions survive; narration stays in the summary.
    """
    text = clean(text)
    if not text:
        return []
    item = make_item

    if re.search(r"问[：:]", text):
        items = []
        for part in re.split(r"(?=问[：:])", text):
            m = re.match(r"问[：:](.*)", part, re.S)
            if not m:
                continue
            seg = m.group(1)
            pieces = re.split(r"答[：:]?", seg, maxsplit=1)
            q = clean(pieces[0])
            ans = clean(pieces[1]) if len(pieces) > 1 and pieces[1].strip() else None
            if len(q) >= 4:
                cleaned = item(q, ans)
                if cleaned:
                    items.append(cleaned)
        if items:
            return items

    numbered = split_numbered(text)
    if numbered:
        items = [i for i in (item(s, None) for s in numbered) if i]
        if items:
            return items

    if re.search(r"[①②③]", text):
        segs = re.split(r"(?=[①②③④⑤⑥⑦⑧⑨⑩])", text)
        segs = [re.sub(r"^[①-⑩]", "", s.strip()).strip() for s in segs if re.match(r"^[①-⑩]", s.strip())]
        if len(segs) >= 3:
            items = [i for i in (item(s, None) for s in segs) if i]
            if items:
                return items

    items = []
    for sent in re.split(r"(?<=[。！？?!；])", text):
        sent = sent.strip()
        if len(sent) >= 4 and sent.endswith("？"):
            cleaned = item(sent, None)
            if cleaned:
                items.append(cleaned)
    if items:
        return items
    return split_topic_list(text)


def parse_round(meta: str | None) -> tuple[int, int, str | None, str]:
    """Return (round_count, primary_round_number, round_title, round_type)."""
    if not meta or meta == "未说明":
        return 1, 1, None, "unknown"
    title = meta
    nums = [CN_NUM[ch] for ch in meta if ch in CN_NUM]
    count = max(nums) if nums else 1
    rtype = "behavioral" if "HR" in meta.upper() else "technical"
    return count, (nums[0] if nums else 1), title, rtype


def parse_post(company: str, path: Path) -> dict | None:
    text = path.read_text(encoding="utf-8")
    title_h1 = re.search(r"^# (.+)$", text, re.M)
    title = title_h1.group(1).strip() if title_h1 else path.stem

    note_id = parse_meta(text, "小红书笔记 ID") or ""
    post_date = parse_meta(text, "发布日期")
    source_url = parse_meta(text, "来源")
    job = parse_meta(text, "岗位")
    round_meta = parse_meta(text, "面试轮次")
    result = parse_meta(text, "面试结果")

    overview = parse_section(text, "面试概况")
    qa = parse_section(text, "面试问答") or ""

    questions: list[dict] = []
    for block in re.split(r"^### ", qa, flags=re.M)[1:]:
        head, _, body = block.partition("\n")
        m = re.match(r"Q\d+\.\s*(.*)", head.strip())
        raw = m.group(1).strip() if m else head.strip()
        am = re.search(r"\*\*A（.*?）：\*\*\s*(.*)", body, re.S)
        answer = clean(am.group(1)) if am else None
        if answer:
            answer = re.split(r"问[：:]", answer)[0].strip() or None
        if answer and answer.startswith("原帖未提供答案"):
            answer = None
        # One structured question may embed a whole numbered question list.
        embedded = split_numbered(raw)
        if embedded:
            for seg in embedded:
                wording, ctx = clean_question(seg)
                if is_real_question(wording):
                    questions.append({"wording": wording, "answer": None, "notes": None, "context": ctx})
            continue
        wording, ctx = clean_question(raw)
        if is_real_question(wording):
            questions.append({"wording": wording, "answer": answer, "notes": None, "context": ctx})
    is_official_marketing = "官方面经" in title
    if is_official_marketing:
        # Official HR-marketing posts contain no real interviewer questions.
        questions = []
    elif len(questions) <= 1 and overview:
        narrative = split_narrative(overview)
        if narrative:
            questions = narrative
    seen: set[str] = set()
    deduped = []
    for q in questions:
        key = re.sub(r"\s+", "", q["wording"])
        if key in seen:
            continue
        seen.add(key)
        deduped.append(q)
    questions = deduped
    summary_text = clean(overview) if overview else None

    if not has_interview_value(questions, summary_text):
        return None

    year = month = None
    if post_date:
        try:
            d = date.fromisoformat(post_date)
            year, month = d.year, d.month
        except ValueError:
            pass
    if year is None:
        m = re.match(r"^(\d{4})-(\d{2})-", path.name)
        year, month = int(m.group(1)), int(m.group(2))
    season = {12: "Winter", 1: "Winter", 2: "Winter", 3: "Spring", 4: "Spring", 5: "Spring",
              6: "Summer", 7: "Summer", 8: "Summer", 9: "Autumn", 10: "Autumn", 11: "Autumn"}[month]

    round_count, round_number, round_title, round_type = parse_round(round_meta)
    is_intern = bool(re.search(r"实习|暑期|日常", f"{job or ''}{title}"))

    return {
        "company": company,
        "note_id": note_id,
        "title": title,
        "job": job,
        "result": result,
        "source_url": source_url,
        "summary": summary_text,
        "year": year,
        "season": season,
        "published_at": f"{year}-{month:02d}-01 00:00:00+00" if post_date else None,
        "round_count": round_count,
        "round_number": round_number,
        "round_title": round_title,
        "round_type": round_type,
        "experience_level": "intern" if is_intern else "unknown",
        "employment_type": "internship" if is_intern else "unknown",
        "slug": f"{COMPANY_SLUGS.get(company, 'company')}-{year}-{month:02d}-{(note_id or path.stem)[-6:]}",
        "questions": questions,
    }


def main() -> None:
    posts: dict[tuple[str, str], dict] = {}
    dropped = 0
    for path in sorted(CORPUS.glob("*/*.md")):
        company = path.parent.name
        post = parse_post(company, path)
        if post is None:
            dropped += 1
            print(f"  dropped (no interview value): {company}/{path.name}")
            continue
        posts.setdefault((company, post["note_id"] or path.stem), post)
    ordered = sorted(posts.values(), key=lambda p: (p["published_at"] or "", p["company"]))

    companies = sorted({p["company"] for p in ordered})
    lines: list[str] = []
    lines.append("-- companies added for real interview posts")
    new_companies = [c for c in companies if c not in EXISTING_COMPANY_IDS]
    values = []
    for c in new_companies:
        industry = "互联网 / AI" if c in BIG_TECH else "机器人 / AI"
        values.append(f"  ({sql(uid('company', c))}, {sql(c)}, {sql(COMPANY_SLUGS.get(c, 'company'))}, 'CN', {sql(industry)}, null)")
    lines.append("insert into public.companies (id, name, slug, country, industry, description) values\n" + ",\n".join(values) + "\n;")
    renamed = [c for c in companies if c in EXISTING_COMPANY_IDS]
    if renamed:
        lines.append("-- align existing placeholder company names with the real posts")
        for c in renamed:
            cid, name = EXISTING_COMPANY_IDS[c]
            lines.append(f"update public.companies set name = {sql(name)} where id = '{cid}';")

    lines.append("")
    lines.append("-- interviews (published, sourced from 小红书 2026 具身智能面经)")

    def company_id(c: str) -> str:
        return EXISTING_COMPANY_IDS[c][0] if c in EXISTING_COMPANY_IDS else uid("company", c)

    iv_values = []
    for p in ordered:
        key = f"{p['company']}/{p['note_id'] or p['slug']}"
        iv_values.append(
            "  ({}, {}, null, {}, {}, null, null, 'candidate_report', {}, {}, {}, {}, {}, {}, 'published', null, {}, {}, 'unknown', 'unknown', 'zh-CN', true, null)".format(
                sql(uid("interview", key)), sql(company_id(p["company"])), p["year"], sql(p["season"]),
                sql(p["source_url"]), sql(p["title"]), sql(p["slug"]), p["round_count"],
                sql(p["summary"]), sql(p["published_at"]),
                sql(p["experience_level"]), sql(p["employment_type"]),
            )
        )
    lines.append(
        "insert into public.interviews (\n"
        "  id, company_id, position_id, year, season, location, interview_type, source_type, source_url,\n"
        "  title, slug, round_count, summary, published_at, status, verified_at,\n"
        "  experience_level, employment_type, application_stage, difficulty_overall,\n"
        "  language, is_anonymous, quality_score\n"
        ") values\n" + ",\n".join(iv_values) + "\n;"
    )

    lines.append("")
    lines.append("-- interview rounds (one aggregated round per post)")
    rd_values = []
    for p in ordered:
        key = f"{p['company']}/{p['note_id'] or p['slug']}"
        rd_values.append(
            "  ({}, {}, 1, {}, {}, null, null)".format(
                sql(uid("round", key)), sql(uid("interview", key)),
                sql(p["round_title"]), sql(p["round_type"]),
            )
        )
    lines.append(
        "insert into public.interview_rounds (id, interview_id, round_number, title, round_type, duration_minutes, interviewer_role) values\n"
        + ",\n".join(rd_values) + "\n;"
    )

    lines.append("")
    lines.append("-- interview questions (wording and answers as recorded in the posts)")
    iq_values = []
    for p in ordered:
        ikey = f"{p['company']}/{p['note_id'] or p['slug']}"
        for idx, q in enumerate(p["questions"], start=1):
            iq_values.append(
                "  ({}, {}, null, 1, {}, {}, null, {}, {}, null)".format(
                    sql(uid("iq", f"{ikey}/{idx}")), sql(uid("interview", ikey)),
                    idx, sql(q["wording"]), sql(q.get("context")), sql(q["answer"]),
                )
            )
    lines.append(
        "insert into public.interview_questions (id, interview_id, question_id, round_number, order_index, original_wording, notes, question_context, answer_summary, difficulty) values\n"
        + ",\n".join(iq_values) + "\n;"
    )

    lines.append("")
    lines.append("-- link interview questions to their round")
    lines.append("update public.interview_questions iq")
    lines.append("set round_id = r.id")
    lines.append("from public.interview_rounds r")
    lines.append("where r.interview_id = iq.interview_id and r.round_number = coalesce(iq.round_number, 1);")
    lines.append("")
    lines.append("-- interview tags")
    tag_values = []
    for p in ordered:
        key = uid("interview", f"{p['company']}/{p['note_id'] or p['slug']}")
        tag_values.append(f"  ({sql(key)}, '小红书面经')")
        tag_values.append(f"  ({sql(key)}, '2026')")
    lines.append("insert into public.interview_tags (interview_id, tag) values\n" + ",\n".join(tag_values) + "\n;")

    generated = BEGIN_MARKER + "\n" + "\n".join(lines) + "\n" + END_MARKER + "\n"

    seed_text = SEED.read_text(encoding="utf-8")
    if BEGIN_MARKER in seed_text:
        pattern = re.compile(re.escape(BEGIN_MARKER) + r"\n.*?" + re.escape(END_MARKER) + r"\n", re.S)
        seed_text, n = pattern.subn(generated, seed_text)
        assert n == 1, "expected exactly one generated block"
    else:
        raise SystemExit("markers not found in seed.sql; run the one-time splice first")
    SEED.write_text(seed_text, encoding="utf-8")

    n_q = sum(len(p["questions"]) for p in ordered)
    print(f"posts: {len(ordered)} (dropped {dropped}), companies: {len(companies)} ({len(new_companies)} new), questions: {n_q}")


if __name__ == "__main__":
    main()
