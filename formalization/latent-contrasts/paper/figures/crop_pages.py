#!/usr/bin/env python3
"""Render Jeffries (2024) pages at 600 dpi and crop the disputed lines.

Usage:
  python3 formalization/latent-contrasts/paper/figures/crop_pages.py [pdf]
"""

import subprocess
import sys
from pathlib import Path

import fitz
from PIL import Image

ROOT = Path(__file__).resolve().parents[4]
DEFAULT_PDF = ROOT / "local-extraction/literature/unl-sem/retrieval-repair/UNL-SEM-D055.pdf"
OUT = Path(__file__).resolve().parent
RENDER = OUT / "render600"
SCALE = 600 / 72

# Portrait jobs: needle plus pad (left, up, right, down) in PDF points.
# Landscape jobs: an explicit rectangle in the unrotated crop box. Those pages
# carry /Rotate 90, and pdftoppm leaves the glyphs on their side. The script
# turns the bitmap clockwise into reading order before cropping.
PORTRAIT = [
    (44, "Table 2.2", "table22.png", (8, 4, 520, 150)),
    (44, "(2.4)", "eq24.png", (20, 36, 400, 28)),
    (89, "0.70", "population.png", (12, 8, 400, 80)),
    (91, "(3.3)", "eq33.png", (8, 6, 400, 80)),
]
LANDSCAPE = [
    (104, "table41.png", (70, 250, 730, 445)),
    (105, "table42.png", (70, 180, 730, 445)),
    (106, "table43.png", (70, 160, 730, 445)),
    (183, "appendix_intercept.png", (300, 300, 720, 480)),
    (184, "appendix_c3.png", (60, 140, 720, 440)),
]


def render_page(pdf: Path, page: int) -> Path:
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


def upright(page, png: Path):
    im = Image.open(png)
    expect = (int(page.rect.width * SCALE), int(page.rect.height * SCALE))
    if im.size != expect:
        raise SystemExit(f"png {png.name} is {im.size}, display rect is {expect}")
    if page.rotation == 0:
        return im
    if page.rotation != 90:
        raise SystemExit(f"unexpected rotation {page.rotation}")
    # PIL rotate(-90) is 90 degrees clockwise: (x, y) -> (H-1-y, x).
    return im.rotate(-90, expand=True)


def crop_rect(im: Image.Image, rect: fitz.Rect) -> Image.Image:
    return im.crop(
        (
            int(rect.x0 * SCALE),
            int(rect.y0 * SCALE),
            int(rect.x1 * SCALE),
            int(rect.y1 * SCALE),
        )
    )


def display_to_upright(page, rect: fitz.Rect) -> fitz.Rect:
    if page.rotation == 0:
        return rect
    height = page.rect.height
    # (x, y) -> (height - y, x), applied to both corners.
    xs = [height - rect.y0, height - rect.y1]
    ys = [rect.x0, rect.x1]
    return fitz.Rect(min(xs), min(ys), max(xs), max(ys))


def main() -> None:
    pdf = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_PDF
    doc = fitz.open(pdf)
    for page_no, needle, name, (dx0, dy0, dx1, dy1) in PORTRAIT:
        page = doc[page_no - 1]
        hits = page.search_for(needle)
        if not hits:
            raise SystemExit(f"no hit for {needle!r} on page {page_no}")
        box = hits[0]
        raw = fitz.Rect(box.x0 - dx0, box.y0 - dy0, box.x0 + dx1, box.y1 + dy1) & page.cropbox
        png = render_page(pdf, page_no)
        im = upright(page, png)
        crop = crop_rect(im, display_to_upright(page, raw * page.rotation_matrix))
        crop.save(OUT / name)
        print(f"{name}: page {page_no} needle {needle!r} hits {len(hits)} size {crop.size}")
    for page_no, name, (x0, y0, x1, y1) in LANDSCAPE:
        page = doc[page_no - 1]
        raw = fitz.Rect(x0, y0, x1, y1) & page.cropbox
        png = render_page(pdf, page_no)
        im = upright(page, png)
        crop = crop_rect(im, display_to_upright(page, raw * page.rotation_matrix))
        crop.save(OUT / name)
        print(f"{name}: page {page_no} rotation {page.rotation} size {crop.size}")


if __name__ == "__main__":
    main()
