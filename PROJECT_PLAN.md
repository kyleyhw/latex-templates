# Project Development Plan
This document outlines the planned phases and tasks for developing latex-templates.

## Phase 1: Lecture notes
1.  [completed] Distil the formatting of an existing lecture-note series into a written specification.
    - [completed] Document skeleton, statement system, typography, figures, tables, references
    - [completed] Design values with rationale
2.  [completed] Native LaTeX class reproducing the design (`lecture-notes/lecturenotes.cls`).
3.  [completed] Generic `template.tex` exercising every element with placeholder text.
4.  [completed] Compile and render verification (`tests/reports/lecture-notes-compile.md`).

## Phase 2: CV
5.  [completed] Extract the layout machinery of an existing CV into a reusable template, with placeholder content and no personal information.
    - [completed] Vertical rhythm: four declared lengths, `\cventrygap` / `\cvlistgap`, `cvcolumns`
    - [completed] Eight section files, one per structural archetype, no archetype repeated
6.  [completed] Build scripts for macOS/Linux and Windows (`cv/build.sh`, `cv/build.ps1`).
7.  [completed] Formatting guide (`cv/docs/`): rhythm and its failure modes, section-file convention, verification, optional variant strategies.
8.  [completed] Compile and layout verification (`tests/reports/cv-compile.md`).

