"""Read plotted values from a source's figures, with the reading error attached.

Use when a source reports a result only in a figure. A comparison read from prose
("near zero", "below .80") is weaker than one read from the plotted values, so the
published-evidence inventory sends every plotted quantity here first.

Two modes:

  vector   The figure is drawn as PDF paths (most plots exported from R or
           matplotlib). Every filled marker is listed with its fill colour and the
           centre of its bounding box in PDF points, exactly as stored in the file.
               python3 digitize.py vector SOURCE.pdf PAGE > markers.json
  raster   The figure is an embedded image or a scan. Pixels close to a series
           colour are grouped into blobs and each blob's centroid is reported.
               python3 digitize.py raster IMAGE.png --rgb 248,118,109 [--tol 40]

Positions become values through `Axis`, built from two or more reference
positions whose values are known: labelled ticks, gridlines, or reference lines
the source draws at stated values (for example dotted lines at +-.05 and +-.10).
`Axis.error` gives the reading error in data units for a position uncertainty,
which is about 0.05 pt for vector paths and half a marker width for raster blobs.
The tolerance of any comparison to a digitized value must include that error.

Vector mode needs PyMuPDF (`import fitz`, as for first_page.py); raster mode needs
Pillow and NumPy.
"""

from __future__ import annotations

import json
import math
import sys
from dataclasses import dataclass


@dataclass
class Axis:
    """A linear (or log10) map from page or pixel position to data value."""

    scale: float
    offset: float
    log: bool = False

    @classmethod
    def from_references(cls, refs, log: bool = False) -> "Axis":
        """refs: [(position, value), ...], at least two distinct positions.

        Least squares when more than two are given; `residual` reports their fit.
        """
        pts = [(float(p), math.log10(v) if log else float(v)) for p, v in refs]
        if len(pts) < 2 or len({p for p, _ in pts}) < 2:
            raise ValueError("an axis needs at least two reference positions")
        n = len(pts)
        mp = sum(p for p, _ in pts) / n
        mv = sum(v for _, v in pts) / n
        sxx = sum((p - mp) ** 2 for p, _ in pts)
        scale = sum((p - mp) * (v - mv) for p, v in pts) / sxx
        axis = cls(scale, mv - scale * mp, log)
        axis.residual = max(abs(axis.raw(p) - v) for p, v in pts)
        return axis

    def raw(self, position: float) -> float:
        return self.scale * position + self.offset

    def value(self, position: float) -> float:
        v = self.raw(position)
        return 10 ** v if self.log else v

    def error(self, position_error: float, position: float = 0.0) -> float:
        """Reading error in data units for a position uncertainty (plus the reference fit)."""
        if self.log:
            hi, lo = self.value(position + position_error), self.value(position - position_error)
            return abs(hi - lo) / 2
        return abs(self.scale) * position_error + getattr(self, "residual", 0.0)


def vector_markers(pdf_path: str, page_number: int, min_items: int = 1) -> list:
    """Filled paths on a PDF page (1-based page number): fill colour and bbox centre in points.

    Small closed shapes (markers), larger fills (panels, bars) and filled glyph outlines
    (tick labels drawn as paths) are all listed with their size and item count, so the
    caller keeps markers by colour and size. A marker can be a single `re` item.
    """
    import fitz

    with fitz.open(pdf_path) as doc:
        page = doc[page_number - 1]
        out = []
        for d in page.get_drawings():
            fill = d.get("fill")
            if not fill or len(d.get("items", [])) < min_items:
                continue
            r = d["rect"]
            out.append({
                "fill": [round(c, 4) for c in fill],
                "x": round((r.x0 + r.x1) / 2, 4), "y": round((r.y0 + r.y1) / 2, 4),
                "width": round(r.width, 4), "height": round(r.height, 4),
                "items": len(d["items"]),
            })
        return out


def vector_lines(pdf_path: str, page_number: int) -> list:
    """Stroked paths (gridlines, reference lines, error bars): colour, dashes and endpoints in points."""
    import fitz

    with fitz.open(pdf_path) as doc:
        page = doc[page_number - 1]
        out = []
        for d in page.get_drawings():
            if not d.get("color"):
                continue
            for item in d.get("items", []):
                if item[0] == "l":
                    p, q = item[1], item[2]
                    out.append({"color": [round(c, 4) for c in d["color"]], "dashes": d.get("dashes"),
                                "x0": round(p.x, 4), "y0": round(p.y, 4), "x1": round(q.x, 4), "y1": round(q.y, 4)})
        return out


def raster_blobs(image, rgb, tol: float = 40.0, min_pixels: int = 4) -> list:
    """Centroids of connected pixel groups within `tol` (Euclidean RGB) of `rgb`.

    `image` is an H x W x 3 array (or a path). Reported positions are in pixels,
    with each blob's half-width as its position error.
    """
    import numpy as np

    if isinstance(image, str):
        from PIL import Image
        image = np.asarray(Image.open(image).convert("RGB"))
    arr = np.asarray(image, dtype=float)[..., :3]
    mask = np.sqrt(((arr - np.asarray(rgb, dtype=float)) ** 2).sum(axis=2)) <= tol
    h, w = mask.shape
    seen = np.zeros_like(mask)
    blobs = []
    for y0, x0 in zip(*np.nonzero(mask)):
        if seen[y0, x0]:
            continue
        stack, pix = [(y0, x0)], []
        seen[y0, x0] = True
        while stack:
            y, x = stack.pop()
            pix.append((y, x))
            for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                yy, xx = y + dy, x + dx
                if 0 <= yy < h and 0 <= xx < w and mask[yy, xx] and not seen[yy, xx]:
                    seen[yy, xx] = True
                    stack.append((yy, xx))
        if len(pix) < min_pixels:
            continue
        ys, xs = zip(*pix)
        blobs.append({"x": sum(xs) / len(xs), "y": sum(ys) / len(ys),
                      "x_error": (max(xs) - min(xs) + 1) / 2, "y_error": (max(ys) - min(ys) + 1) / 2,
                      "pixels": len(pix)})
    blobs.sort(key=lambda b: (b["y"], b["x"]))
    return blobs


def main(argv=None) -> int:
    args = list(sys.argv[1:] if argv is None else argv)
    if len(args) == 3 and args[0] == "vector":
        json.dump({"markers": vector_markers(args[1], int(args[2])),
                   "lines": vector_lines(args[1], int(args[2]))}, sys.stdout, indent=1)
        sys.stdout.write("\n")
        return 0
    if len(args) >= 4 and args[0] == "raster" and args[2] == "--rgb":
        tol = float(args[args.index("--tol") + 1]) if "--tol" in args else 40.0
        rgb = [int(v) for v in args[3].split(",")]
        json.dump(raster_blobs(args[1], rgb, tol), sys.stdout, indent=1)
        sys.stdout.write("\n")
        return 0
    sys.stderr.write(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main())
