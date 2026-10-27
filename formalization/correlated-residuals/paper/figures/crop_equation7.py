#!/usr/bin/env python3
"""Crop equation (7) from the 2010 ARS manuscript (Man850), page 10.

The PDF is not in git. The copy used for the committed figures is
local-extraction/literature/unl-sem/mi-qtl2010.pdf, SHA-256
27c4f3926c9b5af9b399c9b3ef36918c28e7967ef777444b620279dd91628a81.
The public file is
https://www.ars.usda.gov/ARSUserFiles/60820000/Manuscripts/2010/Man850.pdf

From the repository root:

    python3 formalization/correlated-residuals/paper/figures/crop_equation7.py \\
        --pdf local-extraction/literature/unl-sem/mi-qtl2010.pdf

The raster command, run in a temporary directory, is:

    pdftoppm -png -r 600 -f 10 -l 10 Man850.pdf page

Crops are in PDF points from the top of the page, then converted at 600 dpi.
"""

from __future__ import annotations

import argparse
import subprocess
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

DPI = 600
PAGE = 10
# Points from the top of the page. pdftoppm uses the same origin.
EQUATION = (112, 100, 520, 162)
# (label, x0, y0, x1, y1) around each unary minus and the digits it signs.
INSETS = (
    ("G11 = -0.125", 232, 102, 285, 124),
    ("M23 = -0.5", 160, 116, 220, 142),
    ("G22 = -0.5", 288, 116, 345, 142),
    ("G32 = -0.125", 292, 130, 360, 158),
)


def rasterize(pdf: Path, work: Path) -> Path:
    prefix = work / "page"
    subprocess.run(
        [
            "pdftoppm",
            "-png",
            "-r",
            str(DPI),
            "-f",
            str(PAGE),
            "-l",
            str(PAGE),
            str(pdf),
            str(prefix),
        ],
        check=True,
    )
    out = work / f"page-{PAGE}.png"
    if not out.exists():
        raise SystemExit(f"pdftoppm did not write {out}")
    return out


def crop_points(page: Image.Image, box: tuple[float, float, float, float]) -> Image.Image:
    scale = DPI / 72.0
    pixels = tuple(int(round(value * scale)) for value in box)
    return page.crop(pixels)


def font(size: int) -> ImageFont.ImageFont:
    for path in (
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    ):
        if Path(path).exists():
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def inset_strip(page: Image.Image) -> Image.Image:
    panels = []
    label_font = font(28)
    for label, x0, y0, x1, y1 in INSETS:
        image = crop_points(page, (x0, y0, x1, y1))
        # Nearest-neighbor enlargement keeps the ink edges visible.
        image = image.resize((image.width * 2, image.height * 2), Image.Resampling.NEAREST)
        caption_h = 40
        panel = Image.new("RGB", (image.width, image.height + caption_h), "white")
        panel.paste(image, (0, 0))
        draw = ImageDraw.Draw(panel)
        draw.text((8, image.height + 6), label, fill="black", font=label_font)
        panels.append(panel)
    gap = 24
    width = sum(panel.width for panel in panels) + gap * (len(panels) - 1)
    height = max(panel.height for panel in panels)
    strip = Image.new("RGB", (width, height), "white")
    x = 0
    for panel in panels:
        strip.paste(panel, (x, 0))
        x += panel.width + gap
    return strip


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pdf", type=Path, required=True)
    args = parser.parse_args()
    out_dir = Path(__file__).resolve().parent
    with tempfile.TemporaryDirectory() as tmp:
        page = Image.open(rasterize(args.pdf, Path(tmp))).convert("RGB")
        crop_points(page, EQUATION).save(out_dir / "equation7.png")
        inset_strip(page).save(out_dir / "equation7-minuses.png")
    print(f"wrote {out_dir / 'equation7.png'}")
    print(f"wrote {out_dir / 'equation7-minuses.png'}")


if __name__ == "__main__":
    main()
