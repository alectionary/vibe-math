#!/bin/sh
set -eu
python3 formalization/moss-score-reliability/scripts/build_tables.py
cd formalization/moss-score-reliability/paper
name=score_weighting_and_reliability__a_replication_of_moss_2020
pdflatex -interaction=nonstopmode -halt-on-error "$name.tex" > ../outputs/paper-build-first.log 2>&1
pdflatex -interaction=nonstopmode -halt-on-error "$name.tex" > ../outputs/paper-build.log 2>&1
