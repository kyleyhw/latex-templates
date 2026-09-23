# Lecture-notes formatting guide

The specification of the lecture-notes format implemented by
[`lecturenotes.cls`](../lecturenotes.cls). The format is for **teaching
documents**: self-contained, first-principles treatments of one subject,
written for a reader with a mathematical background and no prior exposure
to the topic, closing with a worked case. [`template.tex`](../template.tex)
contains every element below once, filled with placeholder text; start a
new note by copying it.

Each rule is followed by its rationale. The rules are conventions, not
things the class enforces; the class makes the conventional form the easy
one.

## Contents

1. [Principles](#1-principles)
2. [Document skeleton](#2-document-skeleton)
3. [Title page and running headers](#3-title-page-and-running-headers)
4. [Front matter](#4-front-matter)
5. [Parts and sections](#5-parts-and-sections)
6. [Part 0: notation and vocabulary](#6-part-0-notation-and-vocabulary)
7. [Numbered statements](#7-numbered-statements)
8. [Mathematics](#8-mathematics)
9. [Summary and algorithm boxes](#9-summary-and-algorithm-boxes)
10. [Figures](#10-figures)
11. [Tables](#11-tables)
12. [Cross-references](#12-cross-references)
13. [Citations and references](#13-citations-and-references)
14. [Closing Part: case study and limits](#14-closing-part-case-study-and-limits)
15. [Appendix A: numerical verification](#15-appendix-a-numerical-verification)
16. [Emphasis and voice](#16-emphasis-and-voice)
17. [Building](#17-building)
18. [Class reference](#18-class-reference)
19. [Design values](#19-design-values)

---

## 1. Principles

Five commitments drive every rule that follows.

1. **Self-contained.** The note assumes a stated level of mathematics and
   defines everything beyond it, mathematical and domain-specific alike,
   before first use. *Rationale:* a teaching document that sends the reader
   elsewhere for a definition has failed at its one job.
2. **Derived, not quoted.** Every result has a derivation above it. The one
   exception is a **Fact**, which is explicitly marked as taken on trust.
   *Rationale:* the reader should be able to reconstruct each result, and
   should never have to guess which results they are being asked to accept.
3. **Every analytic claim is checked numerically**, and the checks are
   tabulated in Appendix A. *Rationale:* algebra errors survive proofreading.
   An independent computation catches them, and recording it lets the reader
   see what was verified and how tightly.
4. **Interpretation travels with the figure.** A caption says what the axes
   are, what pattern to look for and what to conclude. *Rationale:* a figure
   without its reading is ambiguous, and prose placed elsewhere gets
   separated from it by float placement.
5. **The theory closes on a worked case.** *Rationale:* the case study is
   where the reader checks that the machinery answers a real question.

## 2. Document skeleton

The order is fixed. Items marked *optional* may be omitted; nothing is
reordered.

| # | Element | Markup | Status |
| :--- | :--- | :--- | :--- |
| 1 | Title page | `\maketitle` | required |
| 2 | Contents | `\tableofcontents` | required |
| 3 | One-line description | a plain paragraph | required |
| 4 | Prerequisites | `\paragraph{Prerequisites.}` | required |
| 5 | Learning outcomes | `\paragraph{What you should be able to do afterwards.}` | required |
| 6 | Companion notes | `\paragraph{Companion notes.}` | optional (series only) |
| 7 | Separator | `\separator` | required |
| 8 | Reading map | `\subsubsection*{Reading map}` + one `\paragraph` per Part | required |
| 9 | Part 0 — Notation and vocabulary | `\part{Notation and vocabulary}` | required |
| 10 | Parts I … N−1 — the subject | `\part{...}` | required |
| 11 | Part N — Practice | `\part{Practice}` | required |
| 12 | Appendix A — Numerical verification | `\appendix` `\section{Numerical verification}` | required |
| 13 | References | `thebibliography` | required |

Items 3–8 form the front matter. Because every `\part` opens a fresh page,
the front matter automatically occupies its own page(s) between the contents
and Part 0.

## 3. Title page and running headers

```latex
\title{Title of the Note}
\subtitle{The one question this note answers?}
\author{Author Name}
\series{Series name --- lecture notes}
\runningtitle{Short title}   % optional; defaults to \title
\date{...}                   % optional; defaults to "Month Year"
```

- **The subtitle is a question**, namely the one the note answers ("Why does
  gradient descent converge?"). *Rationale:* it tells a reader at
  a glance whether this is the note they need, and in a series the subtitles
  together form a map of the series.
- **The title page carries nothing else**: title, subtitle, author, date,
  vertically centred. It counts as page 1 but carries no header or number.
- **Running header:** the note's title on the left, the series name on the
  right. The footer reads "*x* of *y*". *Rationale:* a printed page taken out
  of the stack still identifies its document and position.
- **The date is a month and year.** Notes are revised, and a day-level date
  suggests more precision than the version history has.
- Keep macros such as `\,` and `~` out of `\title` and `\author`. They are
  copied into the PDF metadata, where they produce hyperref warnings.

## 4. Front matter

A one-sentence description of the subject, then three bold run-in paragraphs
(`\paragraph{...}`), each heading ending in a full stop:

- **Prerequisites.** List the assumed mathematics concretely (e.g. "second-year
  undergraduate: multivariable calculus, linear algebra, elementary
  probability"). Follow it with the bold sentence **Nothing beyond that is
  assumed.**, then name the advanced machinery the note develops for itself.
  *Rationale:* this is the contract that the self-containment principle is
  checked against.
- **What you should be able to do afterwards.** Three or four capabilities,
  phrased as verbs: *derive*, *state exactly*, *distinguish*, *apply*. Prefer
  "derive X rather than recall it". *Rationale:* verb-phrased outcomes can be
  tested; "understand X" cannot.
- **Companion notes.** State how this note connects to the others in the
  series, and which sections carry the connections. Omit it for a standalone
  note.

Then `\separator` (a short grey rule) and the **Reading map**: an unnumbered
`\subsubsection*{Reading map}` followed by one run-in paragraph per Part,
`\paragraph{Part I --- Foundations.}`. Each paragraph says in one or two
sentences what each of that Part's sections does, cited by `\cref`. The Part 0
entry ends "Skip it and refer back as needed."

## 5. Parts and sections

| Level | Command | Numbering | Appearance |
| :--- | :--- | :--- | :--- |
| Part | `\part{Title}` | 0, I, II, … | "Part I — Title", large navy, ruled, **fresh page** |
| Section | `\section{Title}` | 0, 1, 2, … continuous across Parts | "3. Title", navy |
| Subsection | `\subsection{Title}` | 3.1, 3.2, … | bold |
| Sub-subsection | `\subsubsection*{Title}` | none | bold |
| Run-in lead | `\paragraph{Lead.}` | none | bold, run into the text |

- **Parts group sections by role; they do not restart section numbers.**
  §4.3 is unique across the whole note, so a section number alone locates
  any passage.
- **Part 0 is always *Notation and vocabulary*; the last Part is always
  *Practice*.** The Parts between are named by the role of their content
  (*Foundations*, *The algorithm*, *Regularisation*, …).
- **Each Part opens on a fresh page.** A Part is a unit of study, and a
  reader returning to one should find it at the top of a page.
- **Headings are noun phrases**: "The line search and its limitation", not
  "Why the line search is limited". Explanation belongs in the text below the
  heading.
- Contents depth is Parts and sections. Subsections are left out so the
  contents fit on one page and read as an outline.

## 6. Part 0: notation and vocabulary

Part 0 holds a single section, **0. Everything used but not derived**. It
opens with a paragraph of the form:

> These notes are self-contained. §0.1 fixes notation; §0.2 states the
> results used …; §0.3 defines every domain term. Nothing later uses a
> symbol, result or term that does not appear here or at its point of first
> use.

Its subsections, in order:

1. **0.1 Notation.** A two-column table, Symbol | Meaning, one row per symbol
   or group of related symbols. Where a symbol is defined formally later,
   point to it: "(Definition 2.3)". The table ends with the conventions:
   `\log` is the natural logarithm, units (e.g. nats), common abbreviations
   (i.i.d.), and $\blacksquare$ = end of proof.
2. **0.2 Mathematical results used.** Every result from outside the stated
   prerequisites. Short results are stated as Lemmas with proofs; longer
   standard results are stated as Facts, with a citation. After each result,
   one line says where it is used ("Theorem 6.2 applies Lemma 0.6 to …").
3. **0.3 Vocabulary** (or several subsections by topic). The domain terms,
   as Definitions.

*Rationale:* collecting the prerequisites in one place lets an expert skip
them and a novice find them. The "where it is used" lines make each item
justify its presence.

## 7. Numbered statements

| Kind | Environment | Use | Proof |
| :--- | :--- | :--- | :--- |
| Theorem | `theorem` | a main result of the note | required |
| Proposition | `proposition` | an intermediate result | required |
| Lemma | `lemma` | an auxiliary result used to prove others | required |
| Corollary | `corollary` | an immediate consequence of the preceding result | required (may be one line) |
| Definition | `definition` | introduces a term; the term is **bold** | — |
| Fact | `fact` | a result used without proof, **taken on trust**; cite where a proof lives | forbidden |
| Algorithm | `algorithm` | a procedure, as an enumerated list in a box | — |

- **One shared counter, numbered within section.** Lemma 0.5 is followed by
  Definition 0.6, so a number alone locates any statement, and "Theorem 4.4"
  sits between 4.3 and 4.5 whatever their kinds.
- **Give statements a name** in the optional argument, e.g.
  `\begin{lemma}[Jensen's inequality]`. It is printed bold in parentheses.
  Attribute results in the name: `[gradient boosting, Friedman~\cite{f01}]`.
- **Statement bodies are upright**, not italic. A body carries inline
  mathematics, and italic prose around italic symbols is hard to read.
- **Proofs** use `proof` and end with $\blacksquare$ automatically. Show
  every intermediate step, and cite what is used by `\cref`.
- **Fact is the honesty device.** Anything not proved is either in the
  prerequisites or stated as a Fact. There is no third category.

## 8. Mathematics

- **Derive from first principles and show intermediate steps.** Do not skip
  from a setup to a result "by algebra"; the reader should be able to check
  every line.
- **Pad top-level relations in displays with thick spaces:**
  `F \;=\; G \;+\; H`. Spaced displays read as structure at a glance, which
  matters in dense derivations.
- **Separate juxtaposed factors with a thin space** where they could be
  misread: `\eta\thinspace h_m(x)`, `f\thinspace\mathbb E[X]`.
- **Frame the result of a derivation** with `\keyresult{...}` inside a
  display. Frame only results that are *derived above* and *used later*,
  about one per section at most. A frame marks where to look first when
  revising.
- **Number an equation only if it is referenced** (`equation` + `\label`);
  otherwise use `\[ ... \]`. Numbers are per section, `(4.1)`, and cited as
  "Eq. (4.1)" by `\cref`.
- **Define every symbol** in the notation table or at its first use.
  $\log$ is the natural logarithm throughout.

## 9. Summary and algorithm boxes

**Summary box** (`summary`): a light-blue box with a navy bar on the left,
set in small type, with no label. Place one immediately after a derivation.
It restates the result in plain language, in two or three sentences, with
as few symbols as possible.

```latex
\begin{summary}
Prediction error splits into irreducible noise, squared bias and variance.
Bigger models cut bias and raise variance; regularisation trades back.
\end{summary}
```

*Rationale:* the reader who skims should still get the result, and the
reader who worked through the derivation gets a check on their
understanding. A box is used sparingly: one per major derivation, not one
per paragraph.

**Algorithm box** (`algorithm`): a numbered Algorithm statement in the same
box, with the heading on its own line and the steps below as an `enumerate`.
Each step cites the result it relies on.

```latex
\begin{algorithm}[name of the procedure]\label{alg:x}
\begin{enumerate}
  \item First step (\cref{thm:main}).
  \item ...
\end{enumerate}
\end{algorithm}
```

The class's `algorithm` environment clashes with the `algorithm` package; do
not load both.

## 10. Figures

- **The caption is the interpretation.** Its first sentence names the subject
  or states the finding. Never title a caption by its function ("How to read
  this figure"). Then give, in order:
  1. what the axes are (and the units);
  2. what each panel shows, with panel labels in bold: **(a)**, **(b)**;
  3. what pattern to look for;
  4. **The takeaway:** in bold as a lead-in, followed by the single
     conclusion;
  5. `\figcredit{path/to/script.py}`, which renders an italic "*Generated by
     `path/to/script.py`.*"
- **Every figure is generated by a committed script**, named in the credit,
  so it can be regenerated when the data or the code changes.
- **Full text width** is the default (`\includegraphics` needs no width).
  Draw multi-panel figures side by side in one image rather than as separate
  floats.
- **Placement** is here, top or bottom (`htb`), never a float page of its
  own. Place the `figure` environment just after the paragraph that first
  refers to it.
- **Supplementary media** (e.g. an animation) goes in a line of its own after
  the figure, in italics: *Animated version: \href{url}{the fit assembling
  stage by stage} (video, 20 s).*

## 11. Tables

- `booktabs` rules only: `\toprule`, `\midrule` under the header row,
  `\bottomrule`. Use no vertical rules.
- Separate body rows with `\rowrule`, a thin grey hairline, written after the
  row's `\\`. Omit it after the last row.
- Use `tabularx` at `\linewidth`, with the class's `L` column (ragged-right
  `X`) for prose cells.
- Column headers are nouns ("Symbol", "Meaning", "Result").
- Inline reference tables (notation, verification) carry no caption. A
  table that presents *evidence* goes in a `table` float with a caption that
  states the finding, placed above the table.

```latex
\begin{tabularx}{\linewidth}{@{}l L@{}}
\toprule
Symbol & Meaning \\
\midrule
$x$ & first row \\ \rowrule
$y$ & last row \\
\bottomrule
\end{tabularx}
```

## 12. Cross-references

- **Always `\cref` / `\Cref`** (the latter at the start of a sentence), never
  a hand-typed number and never `Theorem~\ref{...}`. cleveref prints the kind
  from the label's environment, so a Lemma cannot be mis-cited as a Theorem,
  and renumbering is automatic. Every reference is a link.
- Sections cite as **§4.3** (`\cref{sec:x}`), ranges as §§3.2–3.3,
  appendices as "Appendix A", equations as "Eq. (4.1)".
- **Label prefixes:** `sec:`, `thm:`, `lem:`, `prop:`, `cor:`, `def:`,
  `fact:`, `alg:`, `eq:`, `fig:`, `tab:`, `app:`.
- **Forward pointers are allowed; forward use is not.** "(§7.5 discusses
  choosing it well)" is fine. A proof that relies on a result stated later is
  not.

## 13. Citations and references

- In-text: numbered brackets via `\cite{key}`, which renders as "[1]" and
  links to the entry.
- The References section is a `thebibliography` at the very end, numbered in
  order of appearance. Each entry follows the pattern:

  > Surname, A., & Surname, B. (Year). *Title.* Venue, Volume(Issue),
  > pages. [Link](https://doi.org/...)

  ```latex
  \bibitem{friedman-2001} Friedman, J.\,H. (2001). \textit{Greedy function
  approximation: a gradient boosting machine.} Annals of Statistics, 29(5),
  1189--1232. \href{https://doi.org/10.1214/aos/1013203451}{Link}
  ```

- Prefer a DOI link, and give none rather than a guessed URL. After a book
  entry, a parenthetical may say what the source is cited for: "(The
  function-space view of §2 in its original form.)"
- Keys follow `surname-year`.

## 14. Closing Part: case study and limits

The last Part, **Practice**, contains at least:

- **Case study.** The method applied to a real instance, with the measured
  numbers and what they mean. It ends with the lesson stated once,
  generally and in bold. *Rationale:* the case study tests the theory, and a
  negative result is reported as fully as a positive one, together with
  what it indicts (the method, or its inputs).
- **Assumptions and where they fail** (or *When X wins, and when it cannot*):
  each assumption the derivation made, when it breaks, and what goes wrong.

## 15. Appendix A: numerical verification

`\appendix` followed by `\section{Numerical verification}`, opening with
"Every analytic claim above was checked numerically; seeds are fixed so the
checks reproduce." Then the `verification` table:

```latex
\begin{verification}
Optimal leaf value $w^\ast$ & \ref{sec:leaf} & vs.\ numerical minimisation, 3 leaf sets & exact to $10^{-7}$ \\ \rowrule
Score function              & \ref{sec:score} & central differences, 3 configurations  & agree to $10^{-5}$ \\
\end{verification}
```

| Column | Content |
| :--- | :--- |
| Claim | the result, stated compactly, often as its formula |
| § | the section it is derived in (`\ref`, not `\cref`: the header supplies §) |
| Check | the independent computation and its test inputs |
| Result | the measured agreement: tolerance, digits, or both numbers |

The check scripts are committed alongside the note. *Rationale:* see §1,
principle 3. Tabulating the checks makes an unverified claim conspicuous by
its absence.

## 16. Emphasis and voice

- **Bold** marks (i) a term at its point of definition, and (ii) the one
  sentence per paragraph or section that carries the conclusion ("**The
  method fails here for lack of signal, not lack of capacity.**"). Bold
  is rationed: a reader skimming only the bold text should get the
  argument.
- *Italics* mark emphasis and informally introduced terms ("*Stagewise* means
  …").
- The tone is academic and direct: state claims plainly when they are
  established, and name the source of any uncertainty when they are not.
- Define jargon at first use, even when it appears in the notation table.
- No emoji, and no decorative symbols in running text.

## 17. Building

```bash
pdflatex template.tex
pdflatex template.tex   # second pass: contents, cross-references, "x of y"
```

Compile with **pdflatex**. The class uses `newpxtext`/`newpxmath` (Type 1
Palatino), which is pdfLaTeX-specific; under XeLaTeX or LuaLaTeX, replace
them with `fontspec` and a Palatino-family OpenType font. Required packages
are all in standard TeX Live / MiKTeX: `geometry`, `amsmath`, `amsthm`,
`newpx`, `microtype`, `xcolor`, `titlesec` (with `titletoc`), `fancyhdr`,
`lastpage`, `framed`, `graphicx`, `caption`, `array`, `booktabs`,
`tabularx`, `hyperref`, `cleveref`. `colortbl` is deliberately avoided (see
§19).

To use the class, place `lecturenotes.cls` next to the `.tex` file, or in a
directory on `TEXINPUTS`.

## 18. Class reference

| Command / environment | Purpose |
| :--- | :--- |
| `\subtitle{...}` | question the note answers (title page) |
| `\series{...}` | right-hand running header (default "Lecture notes") |
| `\runningtitle{...}` | left-hand running header (default `\title`) |
| `\part{...}` | Part heading on a fresh page, numbered 0, I, II, … |
| `\separator` | short grey thematic rule |
| `theorem`, `proposition`, `lemma`, `corollary`, `definition`, `fact` | numbered statements, one shared counter |
| `algorithm[name]` | numbered Algorithm in a box |
| `proof` | proof ending in $\blacksquare$ |
| `summary` | plain-language restatement box |
| `\keyresult{...}` | framed result, used inside display maths |
| `\figcredit{path}` | italic "Generated by *path*." at the end of a caption |
| `\rowrule` | thin grey rule between table body rows |
| `L` column | ragged-right `tabularx` column |
| `verification` | Appendix A table: Claim, §, Check, Result |
| `\cref`, `\Cref` | kind-aware, linked cross-references |

## 19. Design values

| Element | Value | Reason |
| :--- | :--- | :--- |
| Paper, body size, margins | A4, 11 pt, 2.4 cm | about 80 characters per line, the upper end of comfortable reading width, leaving room for wide displays |
| Text and maths font | Palatino (`newpxtext`, `newpxmath`) + `microtype` | text and maths from one design, so inline symbols match the surrounding prose |
| Accent colour | navy `#14507E` | a deep step of matplotlib's default blue `#1f77b4`, so headings harmonise with default-colour figures; dark enough to print as near-black |
| Summary box | bar `#5B87AC`, 2.5 pt; wash `#F3F7FA`; 7 pt padding; small type | visibly set apart from the text without competing with it |
| Paragraphs | no indent; 6 pt (+2/−1 pt) skip | block paragraphs separate the short, statement-dense paragraphs of mathematical text more clearly than indents |
| Table rows | `\arraystretch` 1.2; hairline 0.4 pt at 20 % black, 1.5 pt padding | rules guide the eye along long rows without the weight of `\midrule`; built from `\noalign` + `\hrule` because some `colortbl` releases are incompatible with `array.sty` |
| Captions | small, bold label, 7 pt skip | captions are paragraphs of interpretation, so they need to be readable text |
| Page breaks | club/widow/display-widow penalties 10000; `emergencystretch` 1.5 em; `nobottomtitles*` | no stranded lines or headings; a slightly loose line is preferred to one that runs into the margin |
| Figure placement | `htb`; float-only pages top-aligned | a figure stays near its first reference and is never deferred to the end of a Part |
| Contents | Parts + sections, black entries, own page | an outline that fits on one page; navy links on every entry would be loud |
