#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
pdflatex -interaction=nonstopmode -halt-on-error -jobname=numerical-main numerical-standalone.tex > numerical-build.log
bibtex numerical-main >> numerical-build.log
pdflatex -interaction=nonstopmode -halt-on-error -jobname=numerical-main numerical-standalone.tex >> numerical-build.log
pdflatex -interaction=nonstopmode -halt-on-error -jobname=numerical-main numerical-standalone.tex >> numerical-build.log
