#!/usr/bin/env python3
"""Crop the printed statistics this note recomputes.

The dissertation PDF is not in git. The copy used here is
local-extraction/literature/sorenson-2015/Sorenson_Dissertation_To_Submit-augmented.pdf,
sha256 4debc9f5551d51ae00a5b6987c3c572a9c7221f6ab631928558c8c1f6b8414d6.
The public file is
https://stacks.stanford.edu/file/cv880bv1650/Sorenson_Dissertation_To_Submit-augmented.pdf

From the repository root:

    python3 formalization/overgeneral-memory/paper/figures/crop_pages.py \\
        --pdf local-extraction/literature/sorenson-2015/Sorenson_Dissertation_To_Submit-augmented.pdf

Each crop is a 600 dpi raster of one page, cut in PDF points measured
from the top of the page. pdftoppm does the raster. Pillow does the cut.
"""

from __future__ import annotations

import argparse
import subprocess
import tempfile
from pathlib import Path

from PIL import Image

DPI = 600

# (filename, pdf page, x0, y0, x1, y1) in PDF points from the top.
CROPS = (
    ("table1.png", 54, 48, 120, 560, 500),
    ("amt-tests.png", 36, 60, 90, 545, 350),
    ("clarity-df.png", 36, 60, 500, 545, 680),
    ("reward-comma.png", 37, 90, 140, 540, 320),
    ("comma-inset.png", 37, 155, 165, 250, 195),
    ("reinstatement.png", 38, 60, 300, 545, 430),
    ("chi-square.png", 54, 60, 175, 545, 310),
    ("bdi-panas.png", 54, 55, 345, 555, 475),
)


def rasterize(pdf: Path, page: int, work: Path) -> Path:
    prefix = work / f"page{page}"
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
    out = work / f"page{page}-{page}.png"
    if not out.exists():
        raise SystemExit(f"pdftoppm did not write {out}")
    return out


def crop_points(page: Image.Image, box: tuple[float, float, float, float]) -> Image.Image:
    scale = DPI / 72.0
    pixels = tuple(int(round(value * scale)) for value in box)
    return page.crop(pixels)


def main() -> None:
    here = Path(__file__).resolve().parent
    parser = argparse.ArgumentParser()
    parser.add_argument("--pdf", type=Path, required=True)
    parser.add_argument("--out", type=Path, default=here)
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    pages = sorted({item[1] for item in CROPS})
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        rasters = {page: rasterize(args.pdf, page, work) for page in pages}
        images = {page: Image.open(rasters[page]) for page in pages}
        for name, page, x0, y0, x1, y1 in CROPS:
            crop = crop_points(images[page], (x0, y0, x1, y1))
            dest = args.out / name
            crop.save(dest)
            print(f"wrote {dest} {crop.size[0]}x{crop.size[1]}")


if __name__ == "__main__":
    main()
