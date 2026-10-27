#!/usr/bin/env python3
"""Crop the Man850 and 2008 tables and the simulation sentences at 600 dpi.

The PDFs are not in git. From the repository root:

    python3 formalization/correlated-residuals/paper/figures/crop_checks.py \
        --man850 local-extraction/literature/unl-sem/mi-qtl2010.pdf \
        --conference local-extraction/literature/unl-sem/mi-conference2008.pdf

Each crop is a rectangle in PDF points from the top of the page. The raster
command for a page is pdftoppm -png -r 600 -f N -l N.
"""

from __future__ import annotations

import argparse
import subprocess
import tempfile
from pathlib import Path

from PIL import Image

DPI = 600

# (output name, page, x0, y0, x1, y1) in points from the top of the page.
MAN850 = (
    ("table1.png", 12, 95, 370, 530, 545),
    ("table2-parameters.png", 13, 95, 100, 530, 275),
    ("design-sentence.png", 9, 90, 525, 540, 670),
    ("thresholds.png", 10, 90, 400, 540, 520),
)
CONFERENCE = (
    ("conference2008-table2.png", 10, 60, 80, 560, 260),
    ("conference2008-design.png", 6, 60, 170, 560, 260),
)


def rasterize(pdf: Path, page: int, work: Path) -> Path:
    prefix = work / f"p{page}"
    subprocess.run(
        [
            "pdftoppm",
            "-png",
            "-r",
            str(DPI),
            "-f",
            str(page),
            "-l",
            str(page),
            str(pdf),
            str(prefix),
        ],
        check=True,
    )
    matches = sorted(work.glob(f"p{page}-*.png"))
    if len(matches) != 1:
        raise SystemExit(f"pdftoppm wrote {matches} for page {page}")
    return matches[0]


def crop(page: Image.Image, box: tuple[float, float, float, float]) -> Image.Image:
    scale = DPI / 72.0
    pixels = tuple(int(round(value * scale)) for value in box)
    return page.crop(pixels)


def write_crops(pdf: Path, spec: tuple, out_dir: Path, cache: dict[int, Image.Image]) -> None:
    for name, page_no, x0, y0, x1, y1 in spec:
        if page_no not in cache:
            with tempfile.TemporaryDirectory() as tmp:
                cache[page_no] = Image.open(rasterize(pdf, page_no, Path(tmp))).convert("RGB")
                cache[page_no].load()
        dest = out_dir / name
        crop(cache[page_no], (x0, y0, x1, y1)).save(dest)
        print(f"wrote {dest}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--man850", type=Path, required=True)
    parser.add_argument("--conference", type=Path, required=True)
    args = parser.parse_args()
    out_dir = Path(__file__).resolve().parent
    write_crops(args.man850, MAN850, out_dir, {})
    write_crops(args.conference, CONFERENCE, out_dir, {})


if __name__ == "__main__":
    main()
