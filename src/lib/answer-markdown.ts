import { renderMathHtml } from "@/lib/math-text";

/**
 * Lightweight block renderer for imported question-bank answers.
 *
 * The curated answer corpus is plain prose handled by math-text.ts alone.
 * Answers imported from external banks (MIT question banks such as
 * embodied-interview-qa) additionally carry fenced code blocks, markdown
 * tables, bullet/numbered lists, `**bold**` and `` `inline code` ``. This
 * module adds exactly those block constructs on top of the math pipeline —
 * deliberately not a general markdown parser.
 *
 * All text still flows through renderMathHtml (HTML-escaped + KaTeX), and
 * bold/code are applied afterwards: escaped prose contains no raw `<`, and
 * KaTeX output contains neither `**` nor backticks, so the substitutions
 * cannot corrupt math spans.
 */

function escapeHtml(text: string): string {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

/** Inline polish applied after math rendering: bold and inline code. */
function inlinePolish(html: string): string {
  return html
    .replace(/\*\*([^*\n]+)\*\*/g, "<strong>$1</strong>")
    .replace(/`([^`\n]+)`/g, "<code>$1</code>");
}

function renderInline(text: string): string {
  return inlinePolish(renderMathHtml(text));
}

/** Inline-only rendering (math + bold + code) for one-line previews like summaries. */
export function renderInlineHtml(text: string): string {
  return renderInline(text);
}

function renderTableCell(cell: string): string {
  return `<td>${renderInline(cell.trim())}</td>`;
}

function splitTableRow(line: string): string[] {
  return line.replace(/^\|/, "").replace(/\|$/, "").split("|");
}

function isTableSeparator(line: string): boolean {
  return /^\|?[\s:|-]+\|[\s:|-]*$/.test(line) && line.includes("-");
}

function renderTable(lines: string[]): string {
  const rows = lines.map(splitTableRow);
  const hasHeader = rows.length >= 2 && rows[1].every((c) => /^:?-{2,}:?$/.test(c.trim()));
  const body = hasHeader ? rows.slice(2) : rows;
  const head = hasHeader
    ? `<thead><tr>${rows[0].map((c) => `<th>${renderInline(c.trim())}</th>`).join("")}</tr></thead>`
    : "";
  return `<div class="answer-table-wrap"><table class="answer-table">${head}<tbody>${body
    .map((r) => `<tr>${r.map(renderTableCell).join("")}</tr>`)
    .join("")}</tbody></table></div>`;
}

/** Render a multi-paragraph answer into HTML block elements. */
export function renderAnswerHtml(text: string): string {
  const lines = text.replace(/\r\n/g, "\n").split("\n");
  const out: string[] = [];
  let i = 0;

  while (i < lines.length) {
    const line = lines[i];

    // Fenced code block
    if (line.startsWith("```")) {
      const lang = line.slice(3).trim();
      const code: string[] = [];
      i += 1;
      while (i < lines.length && !lines[i].startsWith("```")) {
        code.push(lines[i]);
        i += 1;
      }
      i += 1; // consume closing fence
      const langClass = lang ? ` class="language-${escapeHtml(lang)}"` : "";
      out.push(`<pre class="answer-code"><code${langClass}>${escapeHtml(code.join("\n"))}</code></pre>`);
      continue;
    }

    // Blank line
    if (line.trim() === "") {
      i += 1;
      continue;
    }

    // Markdown table: a run of consecutive pipe-delimited lines
    if (line.trimStart().startsWith("|")) {
      const tableLines: string[] = [];
      while (i < lines.length && lines[i].trimStart().startsWith("|")) {
        tableLines.push(lines[i]);
        i += 1;
      }
      if (tableLines.length >= 2 || !isTableSeparator(tableLines[0] ?? "")) {
        out.push(renderTable(tableLines));
        continue;
      }
    }

    // Bullet / numbered list
    if (/^[-*] +/.test(line) || /^\d+[.、)] +/.test(line)) {
      const ordered = /^\d+[.、)] +/.test(line);
      const items: string[] = [];
      while (i < lines.length && lines[i].trim() !== "") {
        const item = lines[i].replace(/^[-*] +/, "").replace(/^\d+[.、)] +/, "");
        if (item === lines[i]) break; // not a list line any more
        items.push(item);
        i += 1;
      }
      const tag = ordered ? "ol" : "ul";
      out.push(`<${tag} class="answer-list">${items.map((it) => `<li>${renderInline(it)}</li>`).join("")}</${tag}>`);
      continue;
    }

    // Paragraph: accumulate until blank line / next block construct
    const para: string[] = [];
    while (
      i < lines.length &&
      lines[i].trim() !== "" &&
      !lines[i].startsWith("```") &&
      !lines[i].trimStart().startsWith("|") &&
      !/^[-*] +/.test(lines[i]) &&
      !/^\d+[.、)] +/.test(lines[i])
    ) {
      para.push(lines[i]);
      i += 1;
    }
    out.push(`<p>${renderInline(para.join("\n"))}</p>`);
  }

  return out.join("\n");
}
