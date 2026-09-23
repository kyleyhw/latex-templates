# Lecture notes: compile and render verification

**Date:** 2026-09-23 · **Runtime:** 1.52 s total (pass 1: 0.76 s, pass 2: 0.76 s) ·
**Engine:** pdfTeX 3.141592653-2.6-1.40.25 (TeX Live 2023, Debian packages)

## What was done

`lecture-notes/template.tex` was compiled from a clean directory with two
`pdflatex -interaction=nonstopmode -halt-on-error` passes. The log, the aux
file and the resulting PDF were then inspected programmatically, and every
page was rendered to PNG (PyMuPDF, 70 dpi) and inspected visually against
the design the class was built to reproduce.

## Why

The class is a template: its defects would propagate into every note built
on it. Clean compilation does not establish correct *behaviour*. The three
defects recorded below all compiled with exit code 0, or failed only on the
second pass, and were found only by inspecting the aux file or the rendered
pages.

## Test data rationale

`template.tex` uses every element of the format exactly once:

- all seven statement kinds;
- `\cref` and `\Cref` against sections, subsections, statements, an
  equation, a figure and the appendix;
- a Part 0, a middle Part and a closing Part;
- a notation table, the verification table, both box types, a framed
  result, a figure with credit, and the bibliography.

Coverage is therefore complete by construction. The filler text is short on
purpose: it stresses the page-break and float logic (a figure that does not
fit before a forced `\clearpage`), which a long note would rarely exercise.

## Checks and results

| Check | Method | Result |
| :--- | :--- | :--- |
| Compiles | exit code of both passes | ✓ 0, 0 |
| No diagnostics | count of `!` errors, `Warning` lines and over/underfull boxes in the log | ✓ 0 / 0 / 0 |
| Cross-reference kinds | kind recorded in each of the 18 `@cref` entries in the aux file | ✓ each statement records its own kind (`lemma`, `fact`, `ln@algorithm`, …) |
| Contents | rendered page 2 | ✓ "Part 0 — …" entries bold, sections numbered "0." with leaders, appendix "Appendix A: …", black entries |
| Bookmarks | PDF outline | ✓ Parts at level 1; numbered sections, the appendix and References at level 2, each with its own target |
| Page structure | first text lines of each of the 7 pages | ✓ title page; contents; front matter; each Part at the top of a fresh page |
| Headers and footers | rendered pages | ✓ title left, series right, "x of y" footer; none on the title page |
| Links | link annotations in the PDF | ✓ 38 internal links |
| Metadata | PDF title/author | ✓ "Title of the Note" / "Author Name" |

## Failures found and fixed

1. **Every statement cited as "Theorem".** The aux file recorded
   `[theorem]` as the kind of every counter-sharing statement, so
   `\cref{lem:x}` would print "Theorem 0.2". *Cause:* the statements were
   declared before `cleveref` was loaded. *Fix:* the declarations moved to
   after `cleveref`; the aux file now records each environment's own kind.
2. **`\Cref` to a section failed on the second pass** ("Argument of
   `\cref@hyperlink` has an extra }"). *Cause:* only the lower-case
   `\crefformat` was set for sections, and `cleveref` derived the capitalised
   form by upper-casing the format's first token, which is the link
   argument. *Fix:* the `\Cref…` formats are set explicitly.
3. **Part entries in the contents read "0 Title"**, not "Part 0 — Title".
   *Cause:* `titlesec` leaves `article`'s `\part` contents writer in place,
   and that writer omits `\numberline`. *Fix:* `\part` is hand-written.
4. **A figure was deferred to a centred float-only page, and the algorithm's
   first step ran into its heading.** *Fix:* figure placement is `htb`, and
   float-only pages are top-aligned. The algorithm environment starts a
   paragraph after its heading, because an `amsthm` body that opens with a
   list otherwise attaches the heading to the first item.

## Caveat

Verified on TeX Live 2023 only. MiKTeX was not tested. The class avoids the
one package combination known to break there (`colortbl` with some
`array.sty` releases), but compatibility is not demonstrated.
