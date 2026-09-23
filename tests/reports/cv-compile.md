# CV: compile and layout verification

**Date:** 2026-09-23 · **Runtime:** 0.66 s total (pass 1: 0.29 s, pass 2: 0.37 s) ·
**Engine:** pdfTeX 3.141592653-2.6-1.40.25 (TeX Live 2023, Debian packages)

## What was done

`cv/template.tex` was compiled from a clean directory with two
`pdflatex -interaction=nonstopmode -halt-on-error` passes. The log and the
resulting PDF were then inspected programmatically: page geometry, diagnostics,
link annotations and metadata, the position of every text baseline, the
position of every section rule, and the text layer.

The vertical spacing was measured rather than eyeballed. Baselines were
extracted with `mutool draw -F stext` and rules with `mutool draw -F trace`,
and the gaps between consecutive baselines bucketed by size — the procedure
documented in [`cv/docs/verification.md`](../../cv/docs/verification.md#measuring-the-rhythm).

## Why

The template's entire purpose is its spacing, and spacing is exactly what
compiling successfully does not verify. A CV whose rhythm levels have collapsed
into each other compiles cleanly, has the right page count, and contains the
right words; it is simply no longer readable at a glance. Every number quoted
in the documentation is therefore taken from the build rather than asserted, so
that a later edit which breaks the system is caught by re-running the
measurement instead of by noticing.

The second purpose is the absence of personal information. The template was
derived from a real CV, so this was checked rather than assumed.

## Test data rationale

The placeholder content is not filler. Each of the eight sections demonstrates
exactly one structural archetype and no archetype is repeated, so the set is
complete by construction with respect to the patterns the template supports:
dated entry block, header/subheader/bullets, header/bullets, annotated flat
list, labelled list, two-column list, nested list, plain list.

Three placeholder entries are deliberately awkward, because the easy cases do
not exercise the layout:

- an `EXPERIENCE` header long enough to wrap onto a second line, which tests
  that `\cvlistgap` measures from the end of the whole header block rather
  than from its last line;
- an award whose text wraps before its right-aligned annotation, which tests
  `\hfill` against a broken line;
- a course title that wraps inside a narrow column, which tests the
  `cvcolumns` baseline correction under the condition that motivates it.

Bullet text is written at realistic sentence length throughout, so that the
ratios between the rhythm levels are visible in the rendered preview rather
than merely correct in the numbers.

## Checks and results

| Check | Method | Result |
| :--- | :--- | :--- |
| Compiles | exit code of both passes | ✓ 0, 0 |
| No diagnostics | count of `!` errors, `Warning` lines and over/underfull boxes in the log | ✓ 0 / 0 / 0 |
| Page count | `pdfinfo` | ✓ 2 |
| Page geometry | `pdfinfo` | ✓ 612 × 792 pt (letter), matching both the class option and `\geometry` |
| Rhythm: body levels | baseline gaps, `mutool -F stext` | ✓ exactly three levels at 12.000 / 15.000 / 20.000 pt (1.00 / 1.25 / 1.67 lines), plus the sanctioned 22.000 pt above the summary paragraph |
| Rhythm: section gap | baseline gaps into a heading | ✓ single value, 26.000 pt (2.17 lines), across all 7 interior headings |
| Rhythm: heading gap | section rules, `mutool -F trace`, to next baseline | ✓ 16.09 pt for 7 sections; 17.60 pt for the `cvcolumns` section, as designed |
| Ordering invariant | the above, compared pairwise | ✓ strictly increasing: 1.00 < 1.25 < 1.34–1.47 < 1.67 < 2.17, no two levels equal |
| No stray gaps | any baseline gap not attributable to a declared length | ✓ none |
| Margin overrun | largest `yMax` in `pdftotext -bbox` against the 738 pt text-block edge | ✓ 652.35 pt; the only value below the edge is the page-2 folio at 771.37 pt, which `fancyhdr` places in the bottom margin by design |
| Links | link annotations in the PDF, including compressed object streams | ✓ 4 — three contact URLs and one project URL |
| Metadata | `pdfinfo` title/author/subject/keywords | ✓ all empty; no identifying data embedded |
| No personal information | case-insensitive sweep of all `.tex`, `.md`, `.sh`, `.ps1` sources and of the PDF text layer against names, institutions, collaborators, project names and award names from the CV this was derived from | ✓ no matches |
| Documentation links | every relative Markdown link and `#anchor` resolved against the files and headings on disk | ✓ all resolve |
| Documented commands | the `OUTPUT=` override and the `pdftotext -bbox` one-liner run verbatim as printed in the docs | ✓ both behave as documented |

## Failures found and fixed

1. **`\verb` inside a `\newcommand` body.** Three placeholder bullets used
   `\verb|\cventrygap|` to name a macro in running text. *Cause:* `\verb`
   cannot appear in a macro argument — the argument is tokenised before
   `\verb` can reassign category codes, so the build fails. *Fix:* replaced
   with `\texttt{\textbackslash cventrygap}`, which is robust in that
   position. Caught before the first compile, by reading the source.

2. **The documented measurement script printed more than was documented.**
   `verification.md` originally quoted four output rows; the script actually
   produced nine, because gaps adjacent to a section heading fall into their
   own buckets and the heading gap is legitimately ragged. *Cause:* the
   documented output was written from the expected levels rather than from a
   run. *Fix:* the script now classifies each gap by whether it touches a
   heading, reducing the body group to the three clean levels; the documented
   output was replaced with the real output and every row accounted for,
   including the one produced by the name block tripping the same font-size
   test as a heading.

3. **Paper size declared twice, inconsistently.** The class option said
   `a4paper` while `\geometry` said `letterpaper`. *Cause:* inherited from the
   source document, where `\geometry` silently wins. *Fix:* both set to
   `letterpaper`, with a comment at each site noting they must agree and that
   `\geometry` is what takes effect. Verified cosmetic: `pdftotext -layout`
   output is byte-identical before and after.

4. **`rerunfilecheck` warning on every build.** A single `pdflatex` pass left
   hyperref's `.out` bookmark file newer than the run that read it. *Cause:*
   the build script ran one pass. *Fix:* both build scripts run two passes and
   clean up afterwards, matching the convention of the other templates in this
   repository. The second pass produces no warnings.

## What this does not cover

The measurement establishes that the gaps are what `template.tex` declares and
that they stand in the required order. It does not establish that those
particular values are the best ones — that is a design judgement, argued in
[`cv/docs/vertical-rhythm.md`](../../cv/docs/vertical-rhythm.md) rather than
tested here.

Page breaks depend on the TeX distribution. This was built against TeX Live
2023; another distribution may break pages differently, which is why the page
count is verified rather than assumed and why the margin-overrun check exists
alongside it.
