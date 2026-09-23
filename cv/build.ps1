# Builds template.tex into template.pdf and clears the auxiliary files pdflatex
# leaves behind. Run from anywhere; the script moves to its own directory
# so that the relative \input{sections/...} paths in template.tex resolve.
#
# Override the output name with:  .\build.ps1 -Output my_name_cv.pdf

param([string]$Output = "template.pdf")

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host "Building $Output..."

# Two passes. -halt-on-error stops at the first error rather than dropping into
# the interactive prompt, so a broken build fails the script instead of hanging.
# A fixed -jobname keeps the auxiliary filenames predictable for cleanup.
# The second pass settles hyperref's bookmark file, which is written on the
# first pass and read on the next; without it pdflatex warns on every build.
foreach ($pass in 1..2) {
    pdflatex -interaction=nonstopmode -halt-on-error -jobname=temp_build "\input{template.tex}" | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Error "pdflatex failed on pass $pass."; exit 1 }
}

if (-not (Test-Path "temp_build.pdf")) {
    Write-Error "pdflatex failed: no PDF was produced."
    exit 1
}

Move-Item -Force "temp_build.pdf" $Output
Remove-Item -Force -ErrorAction SilentlyContinue `
    temp_build.aux, temp_build.log, temp_build.out, temp_build.fls, temp_build.fdb_latexmk

Write-Host "Built $Output"
