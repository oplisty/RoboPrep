import katex from "katex";

/**
 * Render curated answer text with lightweight math support.
 *
 * The question bank is authored in plain Chinese prose where formulas are
 * written as text (`Q_{t+1}`, `δ_t = r_t + γV(s_{t+1}) − V(s_t)`). This module
 * splits each paragraph into CJK runs (rendered as escaped text) and
 * math-looking runs (converted to LaTeX and rendered server-side via KaTeX),
 * so answers display real sub/superscripts without any client-side JavaScript.
 *
 * Detection is intentionally conservative: a segment only becomes math when it
 * carries an unmistakable math marker (=, _, ^, √, Σ, ≤, ≥, ≈, ∈, ×, −, ← or a
 * `sqrt(` call) plus at least one letter or digit. Names like `π0.5`, model
 * comparisons like `π*0.6` and ranges like `10-50 Hz` never qualify because
 * their separators are absent from the trigger set.
 */

const CJK_SPLIT =
  /([\u3000-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff01-\uff5e\u2018\u2019\u201c\u201d\u2026\u2013\u2014\u3008-\u3011]+)|([^\u3000-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff01-\uff5e\u2018\u2019\u201c\u201d\u2026\u2013\u2014\u3008-\u3011]+)/g;

const MATH_TRIGGER =
  /[_^=≤≥≈∈Σ√×−←±]|sqrt\s*\(/;

const SUPERSCRIPTS: Record<string, string> = {
  "⁰": "0", "¹": "1", "²": "2", "³": "3", "⁴": "4",
  "⁵": "5", "⁶": "6", "⁷": "7", "⁸": "8", "⁹": "9",
  "⁺": "+", "⁻": "-", "⁽": "(", "⁾": ")",
};

const SUBSCRIPTS: Record<string, string> = {
  "₀": "0", "₁": "1", "₂": "2", "₃": "3", "₄": "4",
  "₅": "5", "₆": "6", "₇": "7", "₈": "8", "₉": "9",
  "₊": "+", "₋": "-",
};

const GREEK: Record<string, string> = {
  "α": "\\alpha ", "β": "\\beta ", "γ": "\\gamma ", "δ": "\\delta ",
  "ε": "\\epsilon ", "θ": "\\theta ", "λ": "\\lambda ", "μ": "\\mu ",
  "π": "\\pi ", "ρ": "\\rho ", "σ": "\\sigma ", "τ": "\\tau ",
  "φ": "\\phi ", "ψ": "\\psi ", "ω": "\\omega ",
  "Γ": "\\Gamma ", "Δ": "\\Delta ", "Θ": "\\Theta ", "Λ": "\\Lambda ",
  "Π": "\\Pi ", "Φ": "\\Phi ", "Ψ": "\\Psi ", "Ω": "\\Omega ",
};

function escapeHtml(text: string): string {
  return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function toLatex(segment: string): string {
  let s = segment;

  // Unicode super/subscript runs first, before the ASCII bracing pass.
  s = s.replace(/[⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁽⁾]+/g, (run) => `^{${[...run].map((c) => SUPERSCRIPTS[c]).join("")}}`);
  s = s.replace(/[₀₁₂₃₄₅₆₇₈₉₊₋]+/g, (run) => `_{${[...run].map((c) => SUBSCRIPTS[c]).join("")}}`);

  s = s.replace(/′/g, "'").replace(/−/g, "-");
  s = s.replace(/←/g, "\\leftarrow ").replace(/→/g, "\\rightarrow ");
  s = s.replace(/·/g, "\\cdot ").replace(/×/g, "\\times ");
  s = s.replace(/≈/g, "\\approx ").replace(/≤/g, "\\le ").replace(/≥/g, "\\ge ");
  s = s.replace(/∈/g, "\\in ").replace(/Σ/g, "\\sum ");
  s = s.replace(/√\s*\(([^()]*)\)/g, (_m, inner: string) => `\\sqrt{${inner}}`);
  s = s.replace(/√\s*([A-Za-z0-9]+)/g, (_m, atom: string) => `\\sqrt{${atom}}`);

  for (const [char, cmd] of Object.entries(GREEK)) {
    s = s.replaceAll(char, cmd);
  }

  // KaTeX specials that the corpus may contain literally.
  s = s.replace(/&/g, "\\& ").replace(/#/g, "\\# ").replace(/%/g, "\\% ");

  // Brace bare sub/superscripts: `s_t+1` → `s_{t+1}`… but keep existing braces.
  s = s.replace(/_(?!\{)([A-Za-z0-9]+)(?!\})/g, (_m, atom: string) => `_{${atom}}`);
  s = s.replace(/\^(?!\{)([A-Za-z0-9]+)(?!\})/g, (_m, atom: string) => `^{${atom}}`);

  return s;
}

function renderMath(segment: string): string {
  try {
    return katex.renderToString(toLatex(segment), {
      throwOnError: false,
      strict: "ignore",
      output: "html",
    });
  } catch {
    return escapeHtml(segment);
  }
}

/** Convert an answer paragraph into HTML with inline KaTeX for math runs. */
export function renderMathHtml(text: string): string {
  let html = "";
  for (const match of text.matchAll(CJK_SPLIT)) {
    const [raw, cjk, rest] = match;
    if (cjk !== undefined) {
      html += escapeHtml(cjk);
    } else if (rest !== undefined) {
      const trimmed = rest.trim();
      if (trimmed.length > 0 && trimmed.length <= 220 && MATH_TRIGGER.test(rest)) {
        html += renderMath(rest);
      } else {
        html += escapeHtml(rest);
      }
    } else {
      html += escapeHtml(raw);
    }
  }
  return html;
}
