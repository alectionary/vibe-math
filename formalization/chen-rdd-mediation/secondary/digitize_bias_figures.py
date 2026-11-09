"""Read Chen's bias figures (4.12-4.16) from the vector drawing paths in the PDF.

Each figure is three facet grids, one per cutoff (subfigures a-c). Within a panel,
x is mean bias, y is sample size, and colour is the level of a fourth factor. Every
point is drawn as a filled marker with a horizontal bar (mean +- one standard error
of the cell biases, ggplot's stat_summary default). The x axis of every panel is
calibrated from the dotted reference lines Chen draws at -.10, -.05, .05 and .10,
which are explicit line segments in the file, so the reading error is the fit of
those four lines (a few thousandths of a point).

Writes results/digitized_bias.csv: one row per plotted point, with the digitized
mean and bar, the facet levels, and our value for the same aggregate from
results/cells.csv.

    python3 secondary/digitize_bias_figures.py source/chen2021.pdf
"""

from __future__ import annotations

import csv
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from digitize import Axis  # noqa: E402  (copied from the replication-paper skill, PR #91)

ROOT = HERE.parent
LEVELS = [0.0, 0.14, 0.39, 0.59]
H_LEVELS = [0.0, 0.05, 0.15, 0.34]
NS = [500, 1000, 2500, 5000, 10000]
HUES = [(0.97, 0.46, 0.43), (0.49, 0.68, 0.0), (0.0, 0.75, 0.77), (0.78, 0.49, 1.0)]

# figure: (PDF page, effect, column factor, row factor or None, colour factor)
FIGURES = {
    "4.12": (104, "PNIE", "a", None, "b"),
    "4.13": (106, "TNIE", "a", "b", "h"),
    "4.14": (108, "PNDE", "c", None, "h"),
    "4.15": (110, "TNDE", "a", "c", "h"),
    "4.16": (112, "MINT", "a", None, "h"),
}


def _levels(factor):
    return H_LEVELS if factor == "h" else LEVELS


def _hue(rgb):
    for i, ref in enumerate(HUES):
        if rgb and all(abs(x - y) < 0.02 for x, y in zip(rgb, ref)):
            return i
    return None


def _close(rgb, ref, tol=0.02):
    return rgb is not None and all(abs(x - y) < tol for x, y in zip(rgb, ref))


def _groups(values, gap):
    """Cluster sorted values into runs separated by more than `gap`."""
    out = []
    for v in sorted(values):
        if out and v - out[-1][-1] <= gap:
            out[-1].append(v)
        else:
            out.append([v])
    return out


def read_page(pdf, page_number):
    import fitz

    with fitz.open(pdf) as doc:
        drawings = doc[page_number - 1].get_drawings()
    panels = []
    for d in drawings:
        r = d["rect"]
        if _close(d.get("color"), (0.2, 0.2, 0.2)) and any(i[0] == "qu" for i in d["items"]) \
                and r.width > 20 and r.height > 15:
            panels.append(r)
    # one border per panel; duplicates can occur
    uniq = []
    for r in panels:
        if not any(abs(r.x0 - u.x0) < 0.5 and abs(r.y0 - u.y0) < 0.5 for u in uniq):
            uniq.append(r)
    panels = uniq

    def panel_of(x, y):
        for k, r in enumerate(panels):
            if r.x0 - 0.5 <= x <= r.x1 + 0.5 and r.y0 - 0.5 <= y <= r.y1 + 0.5:
                return k
        return None

    markers, bars = [], []
    refs = {k: {"red": set(), "blue": set()} for k in range(len(panels))}
    for d in drawings:
        r = d["rect"]
        fill, color = d.get("fill"), d.get("color")
        hue = _hue(fill)
        if hue is not None and r.width < 4 and r.height < 4:
            k = panel_of((r.x0 + r.x1) / 2, (r.y0 + r.y1) / 2)
            if k is not None:
                markers.append({"panel": k, "hue": hue, "x": (r.x0 + r.x1) / 2, "y": (r.y0 + r.y1) / 2})
            continue
        if fill is None and _hue(color) is not None and r.height > 3:
            k = panel_of((r.x0 + r.x1) / 2, (r.y0 + r.y1) / 2)
            if k is not None:
                bars.append({"panel": k, "hue": _hue(color), "x0": r.x0, "x1": r.x1, "y": (r.y0 + r.y1) / 2})
            continue
        for name, ref in (("red", (1.0, 0.0, 0.0)), ("blue", (0.0, 0.0, 1.0))):
            if fill is None and _close(color, ref):
                for item in d["items"]:
                    if item[0] == "l" and abs(item[1].x - item[2].x) < 1e-3:
                        k = panel_of(item[1].x, (item[1].y + item[2].y) / 2)
                        if k is not None:
                            refs[k][name].add(round(item[1].x, 3))
    return panels, markers, bars, refs


def layout(panels):
    """Assign each panel to (subfigure, row, column).

    Panels inside one facet grid are a few points apart; subfigures are separated
    by titles and axes. Subfigures are ordered top to bottom, then left to right.
    """
    n = len(panels)
    parent = list(range(n))

    def find(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    for i in range(n):
        for j in range(i + 1, n):
            a, b = panels[i], panels[j]
            dx = max(a.x0 - b.x1, b.x0 - a.x1, 0)
            dy = max(a.y0 - b.y1, b.y0 - a.y1, 0)
            if dx < 16 and dy < 16:
                parent[find(i)] = find(j)
    groups = {}
    for i in range(n):
        groups.setdefault(find(i), []).append(i)
    subs = sorted(groups.values(), key=lambda g: (round(min(panels[i].y0 for i in g) / 50), min(panels[i].x0 for i in g)))
    out = {}
    for s, members in enumerate(subs):
        cols = _groups([panels[i].x0 for i in members], 5)
        rows = _groups([panels[i].y0 for i in members], 5)
        for i in members:
            c = next(k for k, g in enumerate(cols) if any(abs(panels[i].x0 - v) < 1e-6 for v in g))
            r = next(k for k, g in enumerate(rows) if any(abs(panels[i].y0 - v) < 1e-6 for v in g))
            out[i] = (s, r, c)
    return out, len(subs)


def our_aggregates(effect):
    rows = list(csv.DictReader(open(ROOT / "results" / "cells.csv")))
    by = {}
    for row in rows:
        if row["effect"] != effect:
            continue
        key = (int(row["cut_index"]), int(row["n"]), float(row["a"]), float(row["b"]), float(row["c"]), float(row["h"]))
        by[key] = float(row["bias"])
    return by


def main(pdf):
    out_rows = []
    for fig, (page, effect, colf, rowf, huef) in FIGURES.items():
        panels, markers, bars, refs = read_page(pdf, page)
        pos, nsub = layout(panels)
        assert nsub == 3, (fig, nsub)
        ours = our_aggregates(effect)
        for k, panel in enumerate(panels):
            s, r, c = pos[k]
            red, blue = sorted(refs[k]["red"]), sorted(refs[k]["blue"])
            assert len(red) == 2 and len(blue) == 2, (fig, k, red, blue)
            axis = Axis.from_references([(blue[0], -0.10), (red[0], -0.05), (red[1], 0.05), (blue[1], 0.10)])
            mk = [m for m in markers if m["panel"] == k]
            ys = _groups([m["y"] for m in mk], 2.0)
            assert len(ys) == 5, (fig, k, len(ys))
            for m in mk:
                yi = next(i for i, g in enumerate(ys) if any(abs(m["y"] - v) < 1e-9 for v in g))
                n = NS[4 - yi]  # top of the panel is n = 10000
                facets = {colf: _levels(colf)[c], huef: _levels(huef)[m["hue"]]}
                if rowf:
                    facets[rowf] = _levels(rowf)[r]
                bar = [b for b in bars if b["panel"] == k and b["hue"] == m["hue"] and abs(b["y"] - m["y"]) < 1.0]
                lo = hi = None
                if bar:
                    best = min(bar, key=lambda b: abs((b["x0"] + b["x1"]) / 2 - m["x"]))
                    lo, hi = axis.value(best["x0"]), axis.value(best["x1"])
                cells = [v for key, v in ours.items()
                         if key[0] == s + 1 and key[1] == n
                         and all(abs(dict(zip("abch", key[2:]))[f] - val) < 1e-9 for f, val in facets.items())]
                mean = sum(cells) / len(cells)
                sd = math.sqrt(sum((v - mean) ** 2 for v in cells) / (len(cells) - 1)) if len(cells) > 1 else 0.0
                out_rows.append({
                    "figure": fig, "effect": effect, "cut_index": s + 1, "n": n,
                    "a": facets.get("a", ""), "b": facets.get("b", ""), "c": facets.get("c", ""), "h": facets.get("h", ""),
                    "chen_mean_bias": round(axis.value(m["x"]), 4),
                    "chen_bar_low": "" if lo is None else round(lo, 4),
                    "chen_bar_high": "" if hi is None else round(hi, 4),
                    "reading_error": round(axis.error(0.05), 4),
                    "our_mean_bias": round(mean, 4), "our_se": round(sd / math.sqrt(len(cells)), 4),
                    "cells_averaged": len(cells),
                })
    out = ROOT / "results" / "digitized_bias.csv"
    with open(out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(out_rows[0]))
        w.writeheader()
        w.writerows(sorted(out_rows, key=lambda r: (r["figure"], r["cut_index"], str(r["a"]), str(r["b"]), str(r["c"]), str(r["h"]), r["n"])))
    print(f"{len(out_rows)} points -> {out}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else str(ROOT / "source" / "chen2021.pdf"))
