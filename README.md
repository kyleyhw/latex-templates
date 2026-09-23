# LaTeX templates

Document classes and starting templates for recurring kinds of writing.
Each template is a self-contained directory: the class, a `template.tex`
that uses every element once with placeholder text, the compiled PDF, and
its own documentation. Copy the directory, rename the `.tex` file, and
replace the content.

```
latex-templates/
├── README.md                          this file
├── PROJECT_PLAN.md                    development plan
├── lecture-notes/                     first-principles lecture notes
│   ├── lecturenotes.cls
│   ├── template.tex
│   ├── template.pdf
│   ├── README.md
│   └── docs/
│       └── formatting-guide.md
└── tests/
    └── reports/
        └── lecture-notes-compile.md   compile and render verification
```

## Templates

| Template | Class | For |
| :--- | :--- | :--- |
| [Lecture notes](lecture-notes/README.md) | `lecturenotes.cls` | self-contained teaching documents that derive a subject from first principles and close on a worked case |

## Documentation

- [Lecture notes: README](lecture-notes/README.md): usage, note structure
  and class internals.
- [Lecture notes: formatting guide](lecture-notes/docs/formatting-guide.md):
  every formatting rule with its rationale, the class reference, and the
  design values.
- [Test reports](tests/reports/lecture-notes-compile.md): compile and
  render verification of each template.

## Building

Every template compiles with pdfLaTeX from a standard TeX Live or MiKTeX
installation, in two passes:

```bash
cd lecture-notes
pdflatex template.tex && pdflatex template.tex
```

Build by-products (`*.aux`, `*.log`, `*.out`, `*.toc`, …) are git-ignored.
The compiled `template.pdf` is committed as a preview.
