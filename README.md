# LaTeX templates

Document classes and starting templates for recurring kinds of writing.
Each template is a self-contained directory: the class or preamble, a
`template.tex` that uses every element once with placeholder text, the
compiled PDF, and its own documentation. Copy the directory, rename the
`.tex` file, and replace the content.

```
latex-templates/
├── README.md                          this file
├── PROJECT_PLAN.md                    development plan
├── LICENSE
├── lecture-notes/                     first-principles lecture notes
│   ├── lecturenotes.cls
│   ├── template.tex
│   ├── template.pdf
│   ├── README.md
│   └── docs/
│       └── formatting-guide.md
├── cv/                                curriculum vitae
│   ├── template.tex                   page setup, spacing system, includes
│   ├── template.pdf
│   ├── build.sh                       build script (macOS / Linux)
│   ├── build.ps1                      build script (Windows)
│   ├── README.md
│   ├── sections/                      one file per section, plus the order list
│   └── docs/
│       ├── index.md                   documentation hub
│       ├── vertical-rhythm.md         the spacing system
│       ├── structure.md               section files and page setup
│       ├── verification.md            checking a change
│       └── variants.md                maintaining several CVs
└── tests/
    └── reports/
        ├── lecture-notes-compile.md   compile and render verification
        └── cv-compile.md              compile and layout verification
```

## Templates

| Template | Class | For |
| :--- | :--- | :--- |
| [Lecture notes](lecture-notes/README.md) | `lecturenotes.cls` | self-contained teaching documents that derive a subject from first principles and close on a worked case |
| [CV](cv/README.md) | none — `extarticle` preamble | a two-page curriculum vitae whose vertical spacing is declared as an explicit, ordered rhythm rather than inherited from list defaults |

## Documentation

- [Lecture notes: README](lecture-notes/README.md): usage, note structure
  and class internals.
- [Lecture notes: formatting guide](lecture-notes/docs/formatting-guide.md):
  every formatting rule with its rationale, the class reference, and the
  design values.
- [CV: README](cv/README.md): usage, the spacing system in brief, and the
  structural archetypes each section file demonstrates.
- [CV: documentation hub](cv/docs/index.md): the vertical rhythm and its
  failure modes, the section-file convention, verification, and optional
  strategies for maintaining several CVs.
- [Test reports](tests/reports/): compile and render verification of each
  template.

## Building

Every template compiles with pdfLaTeX from a standard TeX Live or MiKTeX
installation, in two passes:

```bash
cd lecture-notes
pdflatex template.tex && pdflatex template.tex
```

The CV ships a build script that runs both passes and clears the
by-products afterwards:

```bash
cd cv
./build.sh              # macOS / Linux
```
```powershell
cd cv
.\build.ps1             # Windows
```

Build by-products (`*.aux`, `*.log`, `*.out`, `*.toc`, …) are git-ignored.
The compiled `template.pdf` is committed as a preview.

## License

MIT. See [LICENSE](LICENSE).
