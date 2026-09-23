# Lecture notes

A LaTeX class for self-contained, first-principles lecture notes: a centred
title page, contents on their own page, each Part on a fresh page under a
ruled navy heading, one shared counter for every numbered statement, boxed
summaries and algorithms, figures whose captions carry the interpretation,
thin-ruled tables, a numerical-verification appendix, and clickable
kind-aware cross-references.

```
lecture-notes/
├── lecturenotes.cls          the document class
├── template.tex              every element once, with placeholder text
├── template.pdf              template.tex, compiled
├── README.md                 this file
└── docs/
    └── formatting-guide.md   the specification: every rule and its rationale
```

## Documentation

- [Formatting guide](docs/formatting-guide.md): the document skeleton, the
  statement system, mathematical typography, figures, tables,
  cross-references, citations, the verification appendix, and the design
  values with the reasons for each.

## Usage

Copy `lecturenotes.cls` and `template.tex` into the note's directory, rename
the `.tex` file, and replace the placeholder text. Keep the skeleton. Build
with two pdfLaTeX passes (contents, cross-references and the "*x* of *y*"
footer need the second):

```bash
pdflatex template.tex && pdflatex template.tex
```

[`template.pdf`](template.pdf) shows the result.

## Structure of a note

Every note has the same skeleton, which the reading order of the document
enforces:

```
title page ─► contents ─► front matter ─► Part 0 ─► Parts I…N-1 ─► Part N ─► Appendix A ─► References
                          (prerequisites,   notation,   the subject,   practice:   numerical
                           outcomes,        results     derived from   case study, verification
                           reading map)     used, terms first principles limits    table
```

Numbering is designed so that a number alone locates anything.

- **Sections** are numbered from 0, continuously across Parts, so §4.3 is
  unique within the note.
- **Numbered statements** (Theorem, Proposition, Lemma, Corollary,
  Definition, Fact, Algorithm) share one counter within each section, so
  Lemma 0.5 is followed by Definition 0.6.

`\cref` reads each statement's kind from its environment, so a reference
cannot mislabel it.

## Class internals

The class loads `article` at A4/11 pt and builds the design from standard
packages. The non-obvious choices are documented in comments in the class
and in the guide's § *Design values*. Four of them matter when modifying it:

- **Theorems are declared after `cleveref`.** Only then does `cleveref`
  record each counter-sharing environment's own kind. Declared earlier,
  every statement would cite as "Theorem".
- **`\part` is hand-written, not built with `titlesec`.** `titlesec` leaves
  `article`'s contents writer in place for `\part`, which omits
  `\numberline` and so defeats the "Part 0 — Title" contents format.
- **Table row rules are `\noalign` + `\hrule`, not `colortbl`.** Some
  `colortbl` releases are incompatible with `array.sty`.
- **The `algorithm` box starts a paragraph after its heading.** Otherwise an
  `amsthm` body that opens with a list runs the first item into the heading
  line.
