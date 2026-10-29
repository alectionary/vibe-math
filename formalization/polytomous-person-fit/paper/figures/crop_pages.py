#!/usr/bin/env python3
"""Render Beck (2023) pages at 600 dpi and crop the parameter displays.

Usage:
  python3 formalization/polytomous-person-fit/paper/figures/crop_pages.py [pdf]
"""

import subprocess
import sys
from pathlib import Path

from PIL import Image

DEFAULT = Path("/tmp/beck/beck-wayback.pdf")
OUT = Path(__file__).resolve().parent
RENDER = OUT / "render600"
SCALE = 600 / 72

# PDF page, output name, clip in PDF points (x0, y0, x1, y1).
CLIPS = [
    (74, "eq23.png", (40, 590, 570, 680)),
    (78, "eq24.png", (80, 395, 560, 450)),
    (78, "eq25.png", (80, 545, 560, 630)),
    (79, "eq26.png", (60, 215, 560, 275)),
    (80, "sdr_means.png", (50, 185, 560, 250)),
    (155, "table_a1.png", (60, 120, 560, 280)),
    # Page 156 is landscape, 792 by 612 points. Category 5 sits past x = 640.
    (156, "table_a2.png", (40, 140, 760, 250)),
]


def render(pdf: Path, page: int) -> Path:
    RENDER.mkdir(parents=True, exist_ok=True)
    prefix = RENDER / f"page-{page:03d}"
    png = Path(f"{prefix}-{page:03d}.png")
    if not png.exists():
        subprocess.check_call(
            ["pdftoppm", "-png", "-r", "600", "-f", str(page), "-l", str(page), str(pdf), str(prefix)]
        )
    if not png.exists():
        raise SystemExit(f"pdftoppm did not write {png}")
    return png


def main() -> None:
    pdf = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT
    if not pdf.exists():
        raise SystemExit(f"missing PDF: {pdf}")
    cache = {}
    for page, name, box in CLIPS:
        if page not in cache:
            cache[page] = Image.open(render(pdf, page))
        im = cache[page]
        x0, y0, x1, y1 = [int(v * SCALE) for v in box]
        im.crop((x0, y0, x1, y1)).save(OUT / name)
        print(f"wrote {name}")


if __name__ == "__main__":
    main()
