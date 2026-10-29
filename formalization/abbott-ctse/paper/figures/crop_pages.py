#!/usr/bin/env python3
"""Render Abbott (2010) pages at 600 dpi and crop the lines cited in the note.

The dissertation PDF is not in git. The default path is the UNL copy used
for the fits.
"""

from __future__ import annotations

import subprocess
from pathlib import Path

from PIL import Image

PDF = Path("local-extraction/literature/unl-sem/abbott-2010-unl.pdf")
OUT = Path(__file__).resolve().parent
DPI = 600
SCALE = DPI / 72.0

# PDF points, origin at the top left. Boxes come from pdftotext -bbox.
CROPS = [
    # Printed p.129. "orientation" and the initial-model fit line.
    ("initial_fit.png", 143, 90, 190, 560, 330),
    # Printed p.130. Refined fit and the scaled difference.
    ("refined_fit.png", 144, 90, 240, 560, 380),
    # Printed p.131. General-factor fit, the negative difference, the parenthetical.
    ("general_factor.png", 145, 90, 100, 560, 340),
    # Printed p.95. CTFu4 standard deviation and a minus sign on the next rows.
    ("table32_ctfu4.png", 109, 70, 220, 560, 360),
    # Printed p.135. Latent correlations, including BCSE with CPSE and CTSE.
    ("table41.png", 149, 80, 140, 560, 400),
]


def render(page: int, dest: Path) -> None:
    if dest.exists():
        return
    subprocess.check_call(
        [
            "pdftoppm",
            "-png",
            "-r",
            str(DPI),
            "-f",
            str(page),
            "-l",
            str(page),
            str(PDF),
            str(dest.with_suffix("")),
        ]
    )
    produced = dest.with_name(dest.stem + f"-{page}.png")
    if produced != dest and produced.exists():
        produced.replace(dest)


def main() -> None:
    if not PDF.exists():
        raise SystemExit(f"missing PDF: {PDF}")
    scratch = Path("/tmp/abbott/render600")
    scratch.mkdir(exist_ok=True)
    pages = {}
    for name, page, x0, y0, x1, y1 in CROPS:
        if page not in pages:
            raw = scratch / f"page-{page}.png"
            render(page, raw)
            pages[page] = Image.open(raw)
        image = pages[page]
        box = (
            int(x0 * SCALE),
            int(y0 * SCALE),
            int(x1 * SCALE),
            int(y1 * SCALE),
        )
        image.crop(box).save(OUT / name)
        print(name, box)


if __name__ == "__main__":
    main()
