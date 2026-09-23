# Managing Variants

Optional. Skip this if you maintain one CV.

Most people eventually want more than one version of their CV — an academic one
and an industry one, or a version retargeted per application. There are two
ways to get them out of a single source, and the right choice depends on your
workload rather than on which is tidier in the abstract.

## Conditional macros

Keep one source tree and wrap version-specific content in toggles, using
`etoolbox`:

```latex
\newtoggle{academic}
\toggletrue{academic}
\newcommand{\academiconly}[1]{\iftoggle{academic}{#1}{}}
\newcommand{\industryonly}[1]{\iftoggle{academic}{}{#1}}
```

```latex
\academiconly{\item Investigated ...}\industryonly{\item Built ...}
```

One branch, one history, and every variant visibly in sync — you cannot forget
to propagate a shared edit, because there is nothing to propagate.

It stops scaling at about three variants. Each new one needs its own toggle,
and every conditional bullet grows another adjacent wrapper:

```latex
\academiconly{...}\industryonly{...}\quantonly{...}\mlonly{...}
```

Section files then clutter linearly with the number of variants, and editing
one means reading past the other N − 1 phrasings of the same fact. Adding a
variant means revisiting every conditional bullet in every file.

## Branch per variant

Put shared content on `main` and give each variant its own branch, where the
variant-specific section files are overwritten with that variant's content. The
checked-out branch *is* the variant; there is no toggle and no conditional.

Each branch's files contain only that branch's content, so editing the academic
version means looking at files with nothing but academic prose in them. That
property is what makes this scale: adding a twentieth variant costs the same as
adding the second.

The cost is manual propagation. A change that belongs in *every* variant — new
contact details, a new qualification, a typo in a shared section — is made on
`main` and then rebased outward, one operation per branch:

```bash
git checkout main
# edit, commit

git checkout academic  && git rebase main && git push --force-with-lease
git checkout industry  && git rebase main && git push --force-with-lease
```

`--force-with-lease` is required because rebasing rewrites history, and is safe
here only because nobody else works on these branches. With collaborators, use
`git merge main` instead and accept the messier history.

Rebasing a variant onto `main` will **conflict on every file the variant
overrides**, because `main`'s version and the variant's version disagree by
construction. That is expected, and it always resolves the same way — keep the
variant's content:

```bash
git checkout --theirs sections/experience.tex
git add sections/experience.tex
git rebase --continue
```

During a rebase `--theirs` means the commit being replayed, which is the
variant's, while `--ours` is the branch being replayed onto, which is `main`'s.
The naming is the reverse of what most people expect, and picking `--ours` here
silently replaces the variant's content with `main`'s.

### The silent case

A conflict is the *good* outcome, because you see it. The dangerous case is a
variant that overrides a shared file only lightly — a trimmed version of the
same list, in the same order. Git merges upstream additions straight into it
with no conflict at all, and the variant quietly acquires content it was
specifically edited to exclude.

Nothing warns you. The build still succeeds, and the page count often does not
change; the section is simply longer than it should be, and sometimes long
enough to push the last lines into the bottom margin without forcing a new
page. Check any lightly-overridden file after rebasing, and run the overrun
check in [verification.md](verification.md#content-stays-inside-the-text-block).
Marking such files with a header comment saying they are deliberate overrides
helps the next person, who will be you.

## Choosing

| Your situation | Use |
|---|---|
| Two variants, shared content changes often | Conditional macros |
| Three or more long-lived variants, shared content changes rarely | Branches |
| A new tailored variant per application | Branches |
| Variants must provably stay in lockstep | Conditional macros |

The deciding question is which kind of edit you make more often. Conditionals
charge you on every *read* of a section file, forever; branches charge you on
every *shared* edit. For a CV, where shared edits are rare and retargeting is
frequent, branches usually win.

### Naming

If you branch, separate the base template from the role with a hyphen —
`industry-quant`, not `industry/quant`. Git stores refs as files, so
`refs/heads/industry` cannot coexist with a directory `refs/heads/industry/`:
having a branch named `industry` rules out any branch named `industry/...`.

Archive finished variants as dated tags rather than leaving branches to
accumulate: `archive/industry-quant-2026-05-12`. The date suffix lets the same
role name be archived more than once, which happens whenever you apply to a
similar position a second time.

## Reference

- [Documentation index](index.md)
- [Structure and section files](structure.md) — what the overridable files are
- [Verification](verification.md) — checking a rebase did not change the layout
