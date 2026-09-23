#!/usr/bin/env bash
# Builds template.tex into template.pdf and clears the auxiliary files pdflatex
# leaves behind. Run from anywhere; the script cd's to its own directory
# so that the relative \input{sections/...} paths in template.tex resolve.
#
# Override the output name with:  OUTPUT=my_name_cv.pdf ./build.sh

set -euo pipefail
cd "$(dirname "$0")"

target="${OUTPUT:-template.pdf}"

echo "Building ${target}..."

# Two passes. -halt-on-error stops at the first error rather than dropping into
# the interactive prompt, so a broken build fails the script instead of hanging.
# A fixed -jobname keeps the auxiliary filenames predictable for cleanup.
# The second pass settles hyperref's bookmark file, which is written on the
# first pass and read on the next; without it pdflatex warns on every build.
for pass in 1 2; do
    pdflatex -interaction=nonstopmode -halt-on-error -jobname=temp_build "\input{template.tex}" \
        > "pass${pass}.out" 2>&1 || { cat "pass${pass}.out" >&2; rm -f pass*.out; exit 1; }
done
rm -f pass1.out pass2.out

if [ ! -f temp_build.pdf ]; then
    echo "pdflatex failed: no PDF was produced." >&2
    exit 1
fi

mv temp_build.pdf "${target}"
rm -f temp_build.aux temp_build.log temp_build.out temp_build.fls temp_build.fdb_latexmk

echo "Built ${target}"
