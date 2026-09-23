# Structure and Section Files

`template.tex` carries no content. It sets up the page, declares the spacing
system, pulls in every file from `sections/`, and then emits whatever
`sections/section_order.tex` tells it to. This document covers how that works
and how to change what the CV contains.

## How a section file works

Each file in `sections/` defines exactly one macro and renders nothing by
itself:

```latex
\newcommand{\sectionExperience}{
\section*{EXPERIENCE}
... content ...
}
```

`template.tex` `\input{}`s the file, which makes the macro known. The section
appears in the document only when `section_order.tex` invokes it. Definition
and placement are therefore fully separated, which buys three things:

- **Reordering** is editing one short file, not moving blocks of LaTeX between
  positions in a long one.
- **Omitting** a section is commenting out one line. The content stays on disk,
  ready to come back, instead of being deleted or shunted into a comment block.
- **Editing** a section means opening a file that contains only that section.

The cost is the indirection: reading `template.tex` does not tell you what the CV
contains, and you have to look at `section_order.tex` as well. For a document
with a dozen sections that get reordered per application, that trade is
worthwhile. For a CV you write once and never retarget, it is overhead.

## The eight archetypes

Every section in this template demonstrates one distinct structural pattern,
and no pattern appears twice. When you add a section, start by copying the file
whose shape matches what you need.

| File | Pattern | Use it for |
|---|---|---|
| `education.tex` | Dated entry block, no bullets | Degrees, qualifications — anything where the detail is a few short lines |
| `experience.tex` | Header, subheader, bullets | Jobs and positions: title and place, then role and dates, then what you did |
| `projects.tex` | Header, bullets | Projects and repositories, where there is no separate role line |
| `honours.tex` | Flat list, right-aligned annotations | Awards, grants — a value or year pushed to the right margin |
| `skills.tex` | Labelled list | Anything where the categories carry as much weight as the items |
| `courses.tex` | Two-column list | Long lists of short items that would waste a full-width column |
| `additional_experience.tex` | Nested list | A labelled item whose detail is itself a list |
| `interests.tex` | Plain list | The simplest case: no annotation, no label, no nesting |

Two files are not sections. `header_summary.tex` holds the optional summary
paragraph that appears under the contact block, and is `\input{}` directly by
`template.tex` rather than invoked as a macro; emptying it removes the paragraph.
`section_order.tex` is the ordering list described below.

### Spacing obligations by archetype

Which gap macros a section needs follows from its shape, and getting this wrong
is the commonest way to break the layout:

- **Multiple entries** (`education`, `experience`, `projects`) need
  `\cventrygap` at every entry boundary, and nothing else. It replaces whatever
  used to make that gap — blank lines, a dangling `\\`, an ad-hoc `\vspace`.
  Leaving any of those in place alongside the macro double-counts the gap.
- **An entry with bullets** (`experience`, `projects`) needs `\cvlistgap`
  immediately before its `\begin{itemize}`. Where the entry has more than one
  header line, the gap goes after *all* of them: it separates the header block
  as a whole from its bullets, not the last header line from the list.
- **Single-list sections** (`honours`, `skills`, `interests`) need neither.
  They contain no inter-entry structure, so bullet-to-bullet spacing is already
  the correct level.
- **Nested lists** (`additional_experience`) likewise take no gap. The nesting
  supplies the hierarchy on its own.
- **Two-column sections** (`courses`) must use `\begin{cvcolumns}{2}` rather
  than `multicols` directly, for the baseline-alignment reason given in
  [vertical-rhythm.md](vertical-rhythm.md#multi-column-sections).

## Reordering sections

Edit `sections/section_order.tex`. It is a literal list of macro invocations in
document order:

```latex
\sectionEducation
\sectionExperience
\sectionProjects

\newpage

\sectionHonours
\sectionSkills
```

Place `\newpage` only after looking at the built PDF. A break that lands well
with one set of content can strand a heading at the foot of a page once a
bullet above it grows by a line. If you find yourself needing a `\newpage` to
stop a heading being orphaned, prefer shortening the content above it.

## Adding a section

1. Create `sections/new_section.tex` defining a single macro, starting from
   whichever archetype above matches the shape you want.
2. Add `\input{sections/new_section.tex}` to the section-definitions block of
   `template.tex`.
3. Add `\sectionNewName` to `sections/section_order.tex` at the position you
   want it.
4. Rebuild and check the result against
   [verification.md](verification.md).

Steps 1 and 2 make the section *available*; step 3 makes it *appear*. Skipping
step 3 is the usual reason a newly added section does not show up.

## Removing a section

Comment out its line in `section_order.tex`. Leave the file and the `\input{}`
in place — an unused macro definition costs nothing, and a section you have
dropped for one application is usually one you want back for the next.

## Page setup

The remaining layout decisions live in `template.tex`:

- **`\documentclass[letterpaper,10pt]{extarticle}`** — `extarticle` rather than
  `article` because `article` offers no 10pt-and-below sizes beyond its fixed
  set; `extarticle` accepts 8/9/10/11/12/14/17/20pt, so the body size is a free
  parameter if you need to fit an extra entry.
- **`\geometry{letterpaper, margin=0.75in}`** — 0.75in is about as narrow as a
  CV should go. Below roughly 0.6in the measure gets long enough to hurt
  readability, and some print services crop into the margin. To switch to A4,
  change the paper size **both** here and in the class option above; `\geometry`
  is what actually takes effect, so a mismatch between the two is silently
  resolved in its favour.
- **`fancyhdr`** — puts your name and the compilation date in the running
  header from page 2 onward. Page 1 is exempted with `\thispagestyle{empty}`,
  since the name block already appears there. The page number sits in the
  bottom margin, by design, which matters for the overrun check in
  [verification.md](verification.md).
- **`linkblue` at RGB (0, 0, 0.75)** — dark enough to survive greyscale
  printing. Pure blue prints as a light grey that is hard to read.
- **`\setlength{\parindent}{0pt}`** — no first-line indentation anywhere. In a
  document made of short blocks rather than running prose, indentation marks
  nothing useful and disturbs the left edge.

## Reference

- [Documentation index](index.md)
- [Vertical rhythm](vertical-rhythm.md) — the spacing system
- [Verification](verification.md) — checking a change did what you intended
- [Managing variants](variants.md) — optional, for maintaining several CVs
