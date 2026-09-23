# CV Template Documentation

A LaTeX CV template built around one idea: **every vertical gap in the document
is declared in one place and is rigid.** Nothing in a section file creates
space on its own, so the spacing that encodes the document's hierarchy cannot
drift as content changes.

## Pages

- **[Vertical rhythm](vertical-rhythm.md)** — the spacing system: six ordered
  levels, how each is derived, the two ways the system fails, and how to
  retune it. Read this before changing any spacing.
- **[Structure and section files](structure.md)** — how section files and the
  ordering list work, the eight structural archetypes and which to copy, and
  how to add, remove or reorder a section.
- **[Verification](verification.md)** — how to confirm an edit did what you
  intended: text comparison, page count, margin-overrun check, and a script
  that measures the rhythm levels directly from the PDF.
- **[Managing variants](variants.md)** — optional. Two ways to maintain several
  CVs from one source, and how to choose between them.

## Orientation

Three files determine what the CV looks like:

| File | Governs |
|---|---|
| `template.tex` | Page setup, the four spacing lengths, the gap macros |
| `sections/*.tex` | Content, one section per file |
| `sections/section_order.tex` | Which sections appear, and in what order |

A section file defines a macro and renders nothing by itself; it appears in the
document only when `section_order.tex` invokes it. That separation is what
makes reordering and omitting sections cheap.

## First edits

1. Replace the name, contact lines and positioning line in the header block of
   `template.tex`, and the name in `\fancyhead[L]`.
2. Empty `sections/header_summary.tex` if your field does not expect a summary
   paragraph. Keep the file — `template.tex` includes it unconditionally.
3. Work through `sections/`, replacing the placeholder content. Each file
   opens with a comment naming its archetype and the spacing rules that apply
   to it.
4. Delete the sections you do not need by commenting out their lines in
   `section_order.tex`.
5. Rebuild with `./build.sh` (or `.\build.ps1`) and check the result against
   [verification.md](verification.md).

The one rule that matters throughout: to create vertical space, use
`\cventrygap` or `\cvlistgap`. Never a bare `\vspace`, a trailing `\\`, or a
blank line. The reasoning is in
[vertical-rhythm.md](vertical-rhythm.md#what-not-to-do).
