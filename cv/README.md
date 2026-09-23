# CV

A two-page curriculum vitae template. The content is placeholder throughout —
this is a formatting scaffold, and there is no personal information anywhere in
it.

## Building

Requires `pdflatex` from TeX Live, MacTeX, or MiKTeX. Every package used is
standard: `extarticle`, `geometry`, `titlesec`, `enumitem`, `xcolor`,
`hyperref`, `fancyhdr`, `datetime`, `multicol`, `lmodern`.

```bash
./build.sh                          # macOS / Linux -> template.pdf
OUTPUT=your_name_cv.pdf ./build.sh  # different output name
```

```powershell
.\build.ps1                          # Windows      -> template.pdf
.\build.ps1 -Output your_name_cv.pdf
```

Both run two `pdflatex` passes and remove the by-products. `template.pdf` is
the committed preview.

## Structure

```
cv/
├── template.tex          page setup, the spacing system, section includes
├── build.sh / build.ps1
├── sections/
│   ├── education.tex             dated entry block
│   ├── experience.tex            header, subheader, bullets
│   ├── projects.tex              header, bullets
│   ├── honours.tex               flat list, right-aligned annotations
│   ├── skills.tex                labelled list
│   ├── courses.tex               two-column list
│   ├── additional_experience.tex nested list
│   ├── interests.tex             plain list
│   ├── header_summary.tex        optional summary paragraph
│   └── section_order.tex         which sections appear, and in what order
└── docs/
```

A section file defines one `\sectionX` macro and renders nothing by itself; it
appears in the document only when `section_order.tex` invokes it. Reordering
the CV is therefore editing one short list, and dropping a section is
commenting out one line rather than deleting content.

The eight sections demonstrate eight distinct structural patterns, with no
pattern repeated. When you add a section, copy whichever file matches the shape
you need; each opens with a comment naming its archetype and the spacing rules
that apply to it.

## The spacing system

The template exists for this. A CV is a hierarchy — bullets belong to an entry,
entries to a section, sections to the document — and a reader infers that
hierarchy from spacing alone, before reading a word. LaTeX's defaults do not
encode it: `itemize` contributes `\topsep` that varies with context, blank
lines contribute `\parskip`, stray `\\`s contribute lines, and the gaps that
result are whatever happened to fall out.

So every implicit source of vertical space is switched off — `\setlist{nosep}`,
`\multicolsep` at zero — and the gaps are declared instead, as four lengths in
`template.tex`:

```latex
\newlength{\cvEntryGap}   \setlength{\cvEntryGap}{8pt}    % entry   -> entry
\newlength{\cvSectionGap} \setlength{\cvSectionGap}{12pt} % before a section
\newlength{\cvHeadGap}    \setlength{\cvHeadGap}{9pt}     % rule -> first content
\newlength{\cvListGap}    \setlength{\cvListGap}{3pt}     % header -> its bullets
```

Section files create space only through `\cventrygap` and `\cvlistgap`, which
expand to `\par\vspace{...}` of those lengths. A paragraph break places the next
baseline one `\baselineskip` below and the `\vspace` adds to that, so each
effective gap is leading plus a declared length — with body leading
$b = 12\,\mathrm{pt}$ at the 10pt body size:

$$\text{entry} \to \text{entry} = b + \texttt{cvEntryGap} = 12 + 8 = 20\,\mathrm{pt}$$

$$\text{header} \to \text{bullets} = b + \texttt{cvListGap} = 12 + 3 = 15\,\mathrm{pt}$$

Section headings are set in `\large`, whose own leading is 14pt, so the
section-to-section gap is $\texttt{cvSectionGap} + 14 = 26\,\mathrm{pt}$.

That gives six levels, measured from the compiled PDF rather than asserted:

| Level | Gap | Multiple of leading |
|---|---|---|
| line → line within a paragraph | 12.00pt | 1.00 |
| bullet → bullet | 12.00pt | 1.00 |
| entry header → its own bullets | 15.00pt | 1.25 |
| heading rule → first content | 16.09–17.60pt | 1.34–1.47 |
| entry → entry | 20.00pt | 1.67 |
| section → section | 26.00pt | 2.17 |

The rightmost column is the point. The levels form a strictly increasing
sequence — 1.00, 1.25, ~1.4, 1.67, 2.17 — with no two sharing a value and none
out of order, so a reader scanning the page sees five distinguishable degrees
of separation and maps them onto five degrees of the hierarchy without effort.
Looking at `template.pdf`, the thing to watch is the spacing rather than the
words: bullets sit visibly closer to the header they belong to than two entries
sit to each other, and sections stand further apart again. The placeholder text
is written at realistic lengths precisely so those ratios are visible.

Two things break this, and both have happened to real documents. The levels can
**invert**, putting an entry's bullets further from their own header than from
the section heading above, so the bullets read as belonging to the section. Or
they can **collapse**, with several levels set to 1.0 line: perfectly
consistent, and cramped, because nothing inside a section is articulated any
more. The collapse is the harder one to catch, since the page count and the
text are unchanged — the document just stops being readable at a glance.

The one rule that follows from all of this: to create vertical space, use
`\cventrygap` or `\cvlistgap`, never a bare `\vspace`, a trailing `\\`, or a
blank line.

## First edits

1. Replace the name, contact lines and positioning line in the header block of
   `template.tex`, and the name in `\fancyhead[L]`.
2. Empty `sections/header_summary.tex` if your field does not expect a summary
   paragraph. Keep the file — `template.tex` includes it unconditionally.
3. Work through `sections/`, replacing the placeholder content.
4. Comment out the sections you do not need in `section_order.tex`.
5. Rebuild and check against [docs/verification.md](docs/verification.md).

## Documentation

- [Documentation hub](docs/index.md)
- [Vertical rhythm](docs/vertical-rhythm.md): the six levels, how each is
  derived, the two failure modes, and how to retune.
- [Structure and section files](docs/structure.md): the section-file
  convention, the eight archetypes, page setup.
- [Verification](docs/verification.md): text comparison, page count,
  margin-overrun check, and a script that measures the rhythm levels straight
  out of the PDF.
- [Managing variants](docs/variants.md): optional, for maintaining several CVs.
