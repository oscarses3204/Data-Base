"""
Replace special math Unicode symbols with LaTeX in markdown files.
Runs from a .py file to avoid shell-escaping issues with backslashes.
Only processes text outside fenced code blocks and indented code.
"""
import re
from pathlib import Path

BASE = Path(r"D:\Learning\Comp\Data Base\Review\markdown")
FILES = [
    "COMP3311_Midterm_Practice_Test.md",
    "COMP3311_Final_Practice_Test.md",
    "COMP3311_Complete_Lecture_Notes.md",
]

# ── Unicode → LaTeX (safe replacements) ──
REPLACE = {
    # Arrows (FD: AB → C, only when between word chars)
    # Handled by regex below
    # Joins
    "⋈": "bowtie",        # ⋈ natural join
    "⟕": "leftouterjoin",  # ⟕ left outer join
    "⟖": "rightouterjoin", # ⟖ right outer join
    "⟗": "fullouterjoin",  # ⟗ full outer join
    # Greek (relational algebra)
    "σ": "sigma",          # σ selection
    "π": "pi",             # π projection
    "ρ": "rho",            # ρ rename
    # Set ops
    "∪": "cup",            # ∪ union
    "∩": "cap",            # ∩ intersection
    # Logic
    "⇒": "Rightarrow",     # ⇒
    "∧": "land",           # ∧
    "∨": "lor",            # ∨
    "¬": "neg",            # ¬
    # Comparisons
    "≠": "neq",            # ≠
    "≤": "le",             # ≤
    "≥": "ge",             # ≥
    # Set theory
    "⊆": "subseteq",       # ⊆
    "⊂": "subset",         # ⊂
    "⊃": "supset",         # ⊃
    "∅": "emptyset",       # ∅
    "∈": "in",             # ∈
    "∉": "notin",          # ∉
    "∃": "exists",         # ∃
    "∀": "forall",         # ∀
    # Ceiling / floor
    "⌈": "lceil",          # ⌈
    "⌉": "rceil",          # ⌉
    "⌊": "lfloor",         # ⌊
    "⌋": "rfloor",         # ⌋
    # Entails
    "⊨": "models",         # ⊨
    # Other
    "≡": "equiv",          # ≡
    "≈": "approx",         # ≈
    "∝": "propto",         # ∝
    "∞": "infty",          # ∞
    "∘": "circ",           # ∘
    "÷": "div",            # ÷
    "⟨": "langle",         # ⟨
    "⟩": "rangle",         # ⟩
    "∼": "sim",            # ∼
    "∑": "sum",            # ∑
    "∏": "prod",           # ∏
    "∫": "int",            # ∫
}


def fix_line(s: str) -> str:
    """Apply math-symbol replacements to a single non-code line."""

    # ── 1. Unicode → LaTeX ──
    for uni, latex in REPLACE.items():
        s = s.replace(uni, "$\\" + latex + "$")

    # ── 2. Arrow → in FD context only ──
    # FD notation: AB → C, X → Y (letter-identifier → letter-identifier)
    s = re.sub(r'([A-Za-z]\w*)\s*→\s*([A-Za-z]\w*)', r'$\1 \\rightarrow \2$', s)
    # Handle parenthesized LHS: (X,Y) → Z
    s = re.sub(r'(\))\s*→\s*([A-Za-z]\w*)', r'$\1 \\rightarrow \2$', s)
    # Don't replace → between numbers, Chinese chars, or prose flow arrows

    # ── 3. × (multiplication / Cartesian product) ──
    # number × number (match complete numbers with commas and decimals)
    s = re.sub(r'(\d[\d,]*(?:\.\d+)?)\s*×\s*(\d[\d,]*(?:\.\d+)?)', r'$\1 \\times \2$', s)
    # letter × letter (RA: R × S) — only letter-starting identifiers
    s = re.sub(r'([A-Za-z]\w*)\s*×\s*([A-Za-z]\w*)', r'$\1 \\times \2$', s)
    # ) × letter
    s = re.sub(r'(\))\s*×\s*([A-Za-z]\w*)', r'$\1 \\times \2$', s)

    # ── 4. Subscript digits: a₁ → $a_1$ ──
    subs = "₀₁₂₃₄₅₆₇₈₉"
    for ch in subs:
        if ch in s:
            val = str(subs.index(ch))
            s = re.sub(r'(\w+)' + ch, r'$\1_' + val + r'$', s)

    # ── 5. Superscript digits: a¹ → $a^1$ ──
    sups = "⁰¹²³⁴⁵⁶⁷⁸⁹"
    for ch in sups:
        if ch in s:
            val = str(sups.index(ch))
            s = re.sub(r'(\w+)' + ch, r'$\1^' + val + r'$', s)

    # ── 6. Superscript + (closure: X⁺ → $X^+$) ──
    if "⁺" in s:
        s = re.sub(r'(\w+)⁺', r'$\1^+$', s)
        s = re.sub(r'([)}])⁺', r'$\1^+$', s)

    return s


def is_diagram_line(line: str) -> bool:
    """Check if line is part of an ASCII-art diagram."""
    return bool(re.match(r'^[\s─-╿←-⇿∀-⋿┌└├┤┬┴┐┘│─⩚]+$', line))


def process_file(fp: Path):
    content = fp.read_text(encoding="utf-8")
    lines = content.split("\n")
    fixed = []
    in_fence = False

    for line in lines:
        stripped = line.strip()

        # Track fenced code blocks (```sql, ```javascript, ```, etc.)
        if stripped.startswith("```"):
            in_fence = not in_fence
            fixed.append(line)
            continue
        if in_fence:
            fixed.append(line)
            continue

        # Skip indented code blocks (4+ spaces followed by non-space)
        if re.match(r"^    \S", line):
            fixed.append(line)
            continue

        # Skip ASCII-art / box-drawing diagrams
        if is_diagram_line(line) and not any(c.isalpha() for c in stripped):
            fixed.append(line)
            continue

        fixed.append(fix_line(line))

    fp.write_text("\n".join(fixed), encoding="utf-8")


def main():
    for fname in FILES:
        fp = BASE / fname
        if fp.exists():
            process_file(fp)
            print(f"  OK  {fname}")
        else:
            print(f" SKIP {fname} (not found)")
    print("Done.")


if __name__ == "__main__":
    main()
