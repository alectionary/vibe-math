#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pdflatex -interaction=nonstopmode -halt-on-error -jobname=a0-main a0-standalone.tex > a0-build.log
bibtex a0-main >> a0-build.log
pdflatex -interaction=nonstopmode -halt-on-error -jobname=a0-main a0-standalone.tex >> a0-build.log
pdflatex -interaction=nonstopmode -halt-on-error -jobname=a0-main a0-standalone.tex >> a0-build.log
