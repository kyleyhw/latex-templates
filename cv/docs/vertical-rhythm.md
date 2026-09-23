# Vertical Rhythm

Every vertical gap in this template is declared in one place — the "Vertical
rhythm" block of `template.tex` — and is rigid. Nothing in a section file creates
space on its own. This document explains what the levels are, why they sit
where they do, how they are derived, and what goes wrong when the system is
abandoned.

## The problem this solves

A CV is a hierarchy: bullets belong to an entry, entries belong to a section,
sections belong to the document. A reader infers that hierarchy almost entirely
from spacing, before reading a word. If the spacing does not encode the
hierarchy, the reader has to reconstruct it from content, which is slower and
more error-prone than simply looking.

Left to its defaults, LaTeX will not encode it. `itemize` contributes `\topsep`
above and below itself, which varies with context; a blank line in a section
file contributes `\parskip`; a stray `\\` contributes a line. These accumulate
in ways nobody is tracking, and the resulting gaps are whatever fell out. The
fix is to zero every implicit source and declare the gaps explicitly.

## The six levels

`\setlist{nosep}` removes all list-supplied spacing and `\multicolsep` is
zeroed, so the only vertical space in the body comes from leading and from four
declared lengths. Ordered from tightest to loosest:

| Level | Mechanism | Declared | Effective gap | Multiple of leading |
|---|---|---|---|---|
| line → line within a paragraph | leading | — | 12.00pt | 1.00 |
| bullet → bullet | `\setlist{nosep}` | — | 12.00pt | 1.00 |
| entry header → its own bullets | `\cvlistgap` | `\cvListGap` = 3pt | 15.00pt | 1.25 |
| heading rule → first content | `\titlespacing` | `\cvHeadGap` = 9pt | 16.09–17.60pt | 1.34–1.47 |
| entry → entry | `\cventrygap` | `\cvEntryGap` = 8pt | 20.00pt | 1.67 |
| section → section | `\titlespacing` | `\cvSectionGap` = 12pt | 26.00pt | 2.17 |

The leading (`\baselineskip`) is 12pt at the 10pt body size, so the rightmost
column is the middle column divided by 12. Those multiples are the point of the
table: the levels form a strictly increasing sequence, 1.00 → 1.25 → ~1.4 →
1.67 → 2.17, with no two levels sharing a value and no level out of order. A
reader scanning the page sees five distinguishable degrees of separation and
maps them onto five degrees of the hierarchy without effort.

The figures are measured from the compiled PDF, not asserted. See
[verification.md](verification.md) for the extraction method, which you can
re-run after changing any length.

### Deriving the effective gaps

Each effective gap is leading plus a declared length, because `\cventrygap` and
`\cvlistgap` are `\par\vspace{...}`: the paragraph break ends the current line,
TeX then inserts its usual interline glue to place the next baseline one
`\baselineskip` below, and the `\vspace` adds on top of that.

$$\text{entry} \to \text{entry} = \texttt{\textbackslash baselineskip} + \texttt{\textbackslash cvEntryGap} = 12 + 8 = 20\,\text{pt}$$

$$\text{header} \to \text{bullets} = \texttt{\textbackslash baselineskip} + \texttt{\textbackslash cvListGap} = 12 + 3 = 15\,\text{pt}$$

The section gap works differently, because the heading is set in `\large`
(12pt), whose own leading is 14pt rather than 12pt:

$$\text{section} \to \text{section} = \texttt{\textbackslash cvSectionGap} + \texttt{\textbackslash baselineskip}_{\backslash\text{large}} = 12 + 14 = 26\,\text{pt}$$

The heading gap is the one level that is not a constant. `\titlespacing` places
`\cvHeadGap` of space after the rule, and the first content baseline then falls
a further distance equal to the *height of that line's tallest glyph*:

$$\text{rule} \to \text{first content} = \texttt{\textbackslash cvHeadGap} + h_{\max}$$

For a line opening with capitals or ascenders $h_{\max} \approx 7.1\,$pt, giving
16.1pt. For one opening with parentheses, which overshoot the cap height,
$h_{\max} \approx 7.7\,$pt, giving 16.7pt. The variation is well under half a
line and stays inside its slot in the ordering, so it is left alone rather than
pinned — pinning it would mean overriding the first line's natural height, which
costs more than the 0.6pt it buys.

### A note on units

Declared lengths are in TeX points (1/72.27 in). A PDF measuring tool reports
big points (1/72 in). The two differ by a factor of 72/72.27 = 0.996265, so
12pt of leading measures as 11.955 and the 20pt entry gap measures as 19.925.
The numbers in the table above are TeX points, matching what you type in
`template.tex`; expect measurements to come back about 0.4% smaller.

## Two failure modes

Both of these are real regressions that this layout has had, not hypotheticals.

### Levels must not invert

Anything *inside* an entry has to be closer than the gap *separating* two
entries, which has to be closer than the gap separating two sections. Violating
this attaches content to the wrong parent visually.

An earlier version of this layout set entry headers 18.15pt from their own
bullets while sitting only 12.66pt below the section heading above them. The
bullets were nearer to the next thing than to the header they belonged to, so
they read as belonging to the section rather than to their entry. The content
was correct and the hierarchy was still wrong.

### Levels must not collapse

Setting an entry's bullet gap, the bullet-to-bullet gap and the heading gap all
to 1.0 line is perfectly *consistent*, and reads as cramped. Consistency is not
the goal. With every level equal, nothing inside a section is articulated: a
heading ends up no better separated from its content than two wrapped lines of
a single sentence, and the page becomes an undifferentiated block.

This is the failure that catches people who "clean up" the spacing by removing
the gap macros. The page count often does not change, and the text is
identical, so nothing obviously breaks — the document just stops being
readable at a glance.

### Space has to be spent, not only saved

Retiring the implicit `\topsep` reclaimed roughly 48pt on the first page. Left
unspent, that made the CV simultaneously denser *and* half-empty — worse on
both counts. The declared lengths above put it back deliberately. After
retuning, check how full the pages are, not only whether the gaps look right.

## Retuning

Change the four lengths in `template.tex` and rebuild. Nothing else needs touching,
and the change applies uniformly:

```latex
\setlength{\cvEntryGap}{8pt}     % entry   -> entry
\setlength{\cvSectionGap}{12pt}  % before a section heading
\setlength{\cvHeadGap}{9pt}      % heading rule -> first content
\setlength{\cvListGap}{3pt}      % entry header -> its bullets
```

Keep the ordering invariant when you do. Expressed in the declared lengths,
with $b = 12\,$pt of leading and $b_{\text{large}} = 14\,$pt:

$$b < b + \texttt{cvListGap} < \texttt{cvHeadGap} + h_{\max} < b + \texttt{cvEntryGap} < \texttt{cvSectionGap} + b_{\text{large}}$$

To make the CV tighter overall, scale the four lengths down together rather
than cutting one; cutting one alone is how the ordering gets broken.

## What not to do

Never create space in a section file with a bare `\vspace`, a trailing `\\`, or
a blank line. Each of these works locally and none of them is visible from
`template.tex`, so the document's spacing stops being accountable to any single
place. The version of this layout that permitted them ended up with three
different entry gaps — 18.16pt, 23.14pt and 23.91pt — all nominally
representing the same level of hierarchy.

If a gap you need does not exist, add a fifth length to `template.tex` and give it
a macro. Do not improvise it at the call site.

There is exactly one sanctioned exception, marked in the file where it occurs:
the `\vspace{1em}` in `sections/header_summary.tex`. That paragraph sits in the
document header, outside the section machinery, so no rhythm length governs it.

## Blank lines inside macro bodies

Under `\setlist{nosep}`, a blank line inside a `\newcommand` body produces a
`\par` that contributes no space. Blank lines are therefore free to use for
legibility of the source, and carry no layout meaning. The corollary matters
more: they cannot be used to *create* space either. If you delete a
`\cventrygap` and leave the blank line that used to sit beside it, the gap
disappears entirely.

## Multi-column sections

Use the `cvcolumns` environment, never `multicols` directly. `multicols` seats
each column's first baseline on `\topskip`, which defaults to 10pt and
overrides the rhythm, dropping a two-column section about 3pt below where every
other section starts.

Setting `\topskip` to `0pt` fixes that but introduces a subtler problem: each
column's first baseline then follows its own first line's height, so two
columns whose first lines have different tallest glyphs start about 0.6pt out
of alignment with each other. `cvcolumns` sets `\topskip` to `\ht\strutbox`
instead. A strut is by construction at least as tall as any normal line, so
both columns are forced onto a common baseline.

The cost is that a `cvcolumns` section's heading gap runs to 17.60pt rather
than the usual 16.1pt, about 1.5pt looser, because the strut is taller than the
glyphs it replaces. Cross-column alignment is worth considerably more than
1.5pt, so this is the right trade. It is also why the heading-gap row in the
table above quotes a range.

## Reference

- [Documentation index](index.md)
- [Structure and section files](structure.md) — where content lives
- [Verification](verification.md) — measuring the gaps yourself
