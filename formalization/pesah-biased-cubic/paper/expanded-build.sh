#!/bin/sh
set -eu
cd "$(dirname "$0")"
pdflatex -interaction=nonstopmode -halt-on-error expanded-manuscript.tex
bibtex expanded-manuscript
pdflatex -interaction=nonstopmode -halt-on-error expanded-manuscript.tex
pdflatex -interaction=nonstopmode -halt-on-error expanded-manuscript.tex
cp expanded-manuscript.pdf biased_noise_thresholds_of_cubic_and_rhombic_codes__replication_of_pesah_2021.pdf
