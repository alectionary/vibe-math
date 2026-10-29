#!/usr/bin/env python3
"""600 dpi crops of the dissertation pages cited in the note.

The PDF is not in git. Default path:
  local-extraction/literature/unl-sem/chumney2013.pdf
"""
import argparse
from pathlib import Path

import fitz

ROOT = Path(__file__).resolve().parents[2]
DEFAULT_PDF = ROOT.parents[1] / "local-extraction/literature/unl-sem/chumney2013.pdf"
OUT = Path(__file__).resolve().parent

# PDF page numbers are 1-based. Rectangles are in PDF points (72 per inch).
CROPS = {
    # Dissertation p. 118, the headline sentence.
    "headline": (127, (90, 500, 540, 690)),
    # Table 1, convergence counts.
    "table1": (61, (70, 150, 560, 430)),
    # Table 2 header and the ML / PLS block through n = 1000 reflective.
    "table2": (63, (40, 175, 580, 520)),
    # Equation (15), absolute percent bias.
    "equation15": (56, (70, 140, 560, 250)),
    # Population paragraph for the reflective model, dissertation p. 38.
    "population": (47, (90, 250, 540, 430)),
    # Figure 3, the cross-loading labeled 1 (0.21) on Y8.
    "crossloading": (50, (180, 145, 280, 230)),
}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--pdf", type=Path, default=DEFAULT_PDF)
    args = p.parse_args()
    doc = fitz.open(args.pdf)
    # 600 dpi: 600/72 = 8.333...
    mat = fitz.Matrix(600 / 72, 600 / 72)
    for name, (page_no, rect) in CROPS.items():
        page = doc[page_no - 1]
        pix = page.get_pixmap(matrix=mat, clip=fitz.Rect(*rect))
        dest = OUT / f"{name}.png"
        pix.save(dest)
        print(dest, pix.width, pix.height)


if __name__ == "__main__":
    main()
