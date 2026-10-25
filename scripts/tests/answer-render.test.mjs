import assert from "node:assert/strict";
import test from "node:test";

import { renderMathHtml } from "../../src/lib/math-text.ts";
import { renderAnswerHtml } from "../../src/lib/answer-markdown.ts";

test("renderMathHtml renders explicit $…$ LaTeX spans", () => {
  const html = renderMathHtml("输入 $X \\in \\mathbb{R}^{n \\times d}$ 得到投影");
  assert.ok(html.includes("katex"), "KaTeX output expected");
  assert.ok(!html.includes("$"), "delimiters must not leak into output");
});

test("renderMathHtml renders $$…$$ display math", () => {
  const html = renderMathHtml("公式：\n\n$$\\text{Attention}(Q, K, V) = \\mathrm{softmax}\\!\\left(\\frac{QK^\\top}{\\sqrt{d_k}}\\right)V$$\n\n结束");
  assert.ok(html.includes("katex-display"), "display mode expected");
  assert.ok(!html.includes("$$"), "display delimiters must not leak");
});

test("renderMathHtml keeps the legacy conservative heuristic for plain prose", () => {
  const html = renderMathHtml("Given embeddings X, attention computes QK^T without delimiters.");
  assert.ok(html.includes("katex") || html.includes("QK"), "legacy behaviour must not regress");
});

test("renderMathHtml leaves unmatched single $ as literal text", () => {
  const html = renderMathHtml("价格是 $5 与 $10 之间");
  assert.ok(!html.includes("katex"), "no math should be parsed from currency text");
});

test("renderAnswerHtml renders fenced code blocks without inline transforms", () => {
  const html = renderAnswerHtml("**实现**：\n\n```python\ndef f(x):\n    return x ** 2\n```\n");
  assert.ok(html.includes('<pre class="answer-code"><code class="language-python">'));
  assert.ok(html.includes("x ** 2"), "code content must be preserved verbatim");
  assert.ok(!html.includes("<strong>2</strong>"), "bold must not apply inside code");
});

test("renderAnswerHtml renders markdown tables", () => {
  const html = renderAnswerHtml("| 框架 | 目标 |\n|---|---|\n| SDE | 前向加噪 |\n| ODE | 沿路径走 |");
  assert.ok(html.includes("<table"));
  assert.ok(html.includes("<th>框架</th>"));
  assert.ok(!html.includes("|---"), "separator row must be consumed");
});

test("renderAnswerHtml renders bullet and numbered lists", () => {
  const bullets = renderAnswerHtml("- 第一项\n- 第二项 **加粗**");
  assert.ok(bullets.includes('<ul class="answer-list">'));
  assert.ok(bullets.includes("<strong>加粗</strong>"));
  const numbered = renderAnswerHtml("1. 步骤一\n2. 步骤二");
  assert.ok(numbered.includes('<ol class="answer-list">'));
});

test("renderAnswerHtml applies bold and inline code outside math", () => {
  const html = renderAnswerHtml("**考察点**：滑动窗口；用 `max(l, last[c]+1)` 防回退。");
  assert.ok(html.includes("<strong>考察点</strong>"));
  assert.ok(html.includes("<code>max(l, last[c]+1)</code>"));
});

test("renderAnswerHtml does not italicise single asterisks like π*0.6", () => {
  const html = renderAnswerHtml("π*0.6 与 π0.5 的对比，**关键**在路径。");
  assert.ok(!html.includes("<em>"), "single asterisks must stay literal");
  assert.ok(html.includes("<strong>关键</strong>"));
});
