# Verification

A layout change is easy to make and easy to get subtly wrong. Three checks
catch nearly everything, in increasing order of effort. Run the first two after
any edit to a section file; run the third after touching the spacing lengths in
`template.tex`.

## Content is unchanged

Most edits to structure or spacing are meant to move nothing. Extract the text
layer before and after and compare:

```bash
./build.sh                       # before your change
pdftotext -layout template.pdf before.txt

# ... make the change ...

./build.sh
pdftotext -layout template.pdf after.txt
diff before.txt after.txt        # must be empty for a layout-only change
```

`-layout` preserves the column structure, so a two-column section comes out as
two columns rather than interleaved. A pure spacing change will sometimes shift
whitespace within a line; if `diff` reports only whitespace differences,
`diff -w` confirms that is all they are.

Any difference that is not whitespace means the edit changed content, which for
a layout change means it did something you did not intend.

## Page count is unchanged

```bash
pdfinfo template.pdf | grep Pages
```

The template as shipped is 2 pages. A CV that silently grows a page is the most
expensive layout regression there is, because the extra page is usually almost
empty and reads as padding.

Page count alone is a weak check, though, for a reason worth understanding:
**content overruns the text block before it forces a new page.** A CV can be
one page and already broken, with its last lines sitting in the bottom margin.
So do not stop at the page count.

## Content stays inside the text block

The text block runs from the top margin to `\textheight` below it. With
`margin=0.75in` on letter paper, that is 54pt to 738pt in PDF coordinates.
Anything below 738pt has spilled.

One complication: `fancyhdr` places the page number in the bottom margin by
design, about 30pt below the text block. On any multi-page CV the lowest text
on the page is therefore the folio, not body content, and a naive check flags
every page. Discount a lone word that is exactly the page's own number and
treat anything else down there as a genuine overrun.

```bash
pdftotext -bbox template.pdf - | grep -oE 'yMax="[0-9.]+"' | \
  sort -t'"' -k2 -g | tail -5
```

Compare the largest values against 738. Anything above it that is not the folio
needs attention.

## Measuring the rhythm

After changing any of the four lengths, confirm the levels still hold and still
sit in order. This needs exact baseline positions, which `pdftotext` does not
provide; `mutool` (from MuPDF) does. The script below extracts every text
baseline, groups the gaps between consecutive baselines by whether they touch a
section heading, and reports each level in units of leading.

```bash
mutool draw -F stext -o stext.xml template.pdf
python3 measure.py
```

```python
# measure.py
import re

src = open("stext.xml", encoding="utf-8").read()
tok = re.compile(r'<font name="[^"]*" size="([\d.]+)"'
                 r'|<char [^>]*\by="([-\d.]+)"')

BP   = 72 / 72.27   # PDF big points -> TeX points
LEAD = 12.0         # \baselineskip at the 10pt body size
BIG  = 11.0         # larger than this is a heading or the name block

groups = {"body": {}, "into heading": {}, "out of heading": {}}

for page in src.split("<page ")[1:]:
    rows, size = {}, 0.0
    for m in tok.finditer(page):
        if m.group(1):
            size = float(m.group(1))
        else:
            rows.setdefault(float(m.group(2)), size)
    lines = sorted(rows.items())
    for (y1, s1), (y2, s2) in zip(lines, lines[1:]):
        gap = (y2 - y1) / BP
        if gap > 30:                       # spans a page region, not a gap
            continue
        kind = ("into heading"   if s2 > BIG else
                "out of heading" if s1 > BIG else "body")
        groups[kind].setdefault(round(gap / LEAD, 2), []).append(gap)

for kind, buckets in groups.items():
    print(f"-- {kind}")
    for mult in sorted(buckets):
        v = buckets[mult]
        print(f"   {mult:5.2f} lines  {sum(v)/len(v):7.3f}pt   n={len(v)}")
```

Run against the template as shipped, it reports:

```
-- body
    1.00 lines   12.000pt   n=38
    1.25 lines   15.000pt   n=5
    1.67 lines   20.000pt   n=5
    1.83 lines   22.000pt   n=1
-- into heading
    2.17 lines   26.000pt   n=7
-- out of heading
    1.67 lines   20.001pt   n=1
    1.71 lines   20.489pt   n=2
    1.72 lines   20.591pt   n=4
    1.76 lines   21.100pt   n=1
    1.83 lines   22.000pt   n=1
```

Read it as a histogram of the document's vertical gaps, one row per distinct
gap size. The multiplier on the left is the gap in units of leading, and it is
the figure that matters, because it is the ratio a reader actually perceives.
`n` is how many times that gap occurs.

The **body** group is the core of the rhythm and should be the cleanest. Here
it resolves to exactly three levels — 1.00 for line-to-line and
bullet-to-bullet, 1.25 for `\cvlistgap`, 1.67 for `\cventrygap` — plus a single
1.83 which is the `\vspace{1em}` above the optional summary paragraph, the one
sanctioned exception described in
[vertical-rhythm.md](vertical-rhythm.md#what-not-to-do). Every value is a round
number of points, because each is leading plus a declared length.

**Into heading** is the section-to-section gap, a single clean 2.17 across all
seven interior headings. The eighth heading is the first thing on page 2, where
the preceding text is the running header; that gap spans the page's top margin
rather than the rhythm, and the `gap > 30` guard drops it.

**Out of heading** is the heading-to-first-content gap and is legitimately
ragged, spanning 20.5 to 22.0. This is the one level that is not a constant:
the first content baseline falls at `\cvHeadGap` plus the height of that line's
tallest glyph, so a section opening with parentheses (1.76, `SELECTED PROJECTS`)
sits slightly lower than one opening with capitals (1.71–1.72), and a
`cvcolumns` section (1.83, `SELECTED COURSES`) lower still because a strut is
taller than the glyphs it stands in for. The lone 1.67 is not a section at all
— it is the gap under the name block, which is set at 17.2pt and so trips the
same size test as a heading.

Note that these are measured **heading baseline to content baseline**, whereas
the heading-gap row in the rhythm table is measured **from the rule**, which is
the visually meaningful reference. The two differ by the constant 4.40pt that
separates a heading's baseline from its rule.

Two properties make the output healthy. Within the body group the multipliers
must be **distinct** — two levels reported at the same value means they have
collapsed into each other and one degree of the hierarchy has stopped being
visible. And across groups they must fall in the **order** the hierarchy
requires, tightest inside an entry and loosest between sections; see the
ordering inequality in [vertical-rhythm.md](vertical-rhythm.md#retuning).

A body row you cannot account for is a gap something created outside the
system, usually a stray `\\`, a blank line left beside a deleted gap macro, or
a bare `\vspace`.

To measure the heading gap from the rule instead, extract the rule positions:

```bash
mutool draw -F trace -o trace.xml template.pdf
grep -oE 'transform="1 0 0 -1 54 ([0-9.]+)"' trace.xml
```

Each match is the vertical position of one section rule, in big points. The
distance from a rule down to the next text baseline is the heading gap proper:
16.09pt for most sections, 17.60pt for a `cvcolumns` section.

### A unit trap

`mutool` and `pdftotext` report PDF big points (1/72 in). LaTeX lengths are TeX
points (1/72.27 in). The `BP` constant in the script converts between them.
Without it every measurement comes back 0.4% short — 12pt of leading reads as
11.955, the 20pt entry gap as 19.925 — which is small enough to look like
rounding error and large enough to make a set of exact round numbers look
arbitrary.

## Reference

- [Documentation index](index.md)
- [Vertical rhythm](vertical-rhythm.md) — what the levels mean
- [Structure and section files](structure.md) — what to edit
