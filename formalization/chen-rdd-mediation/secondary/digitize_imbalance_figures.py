"""Read Chen's imbalance figures (4.30, 4.32, 4.34, 4.36, 4.38).

Each panel holds five stacked bars, one per sample size (500 ... 10,000), each
summing to 100%: the share of replications whose interval lies with the true
value above it ("Above", blue, bottom), contains it ("Within", green), or lies
with the true value below it ("Below", red, top). The shares are read as segment
heights over the bar's full height, so no axis calibration is needed; the reading
error is one pixel over the bar height (about 1.3 percentage points) plus the
anti-aliased segment boundaries.

Bars are found as connected components of the three series colours; five bars
side by side make a panel; panels are grouped into facet grids and subfigures by
their gaps.

Writes results/digitized_imbalance.csv with our shares for the same cells.
    python3 secondary/digitize_imbalance_figures.py source/chen2021.pdf
"""

from __future__ import annotations

import csv
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from digitize_raster_figures import page_image, _clusters, layout  # noqa: E402

ROOT = HERE.parent
L = [0.0, 0.14, 0.39, 0.59]
H = [0.0, 0.05, 0.15, 0.34]
NS = [500, 1000, 2500, 5000, 10000]
BELOW, WITHIN, ABOVE = (248, 118, 109), (0, 186, 56), (97, 156, 255)

# figure: page, effect, subfigure factor (cut or h), row factor, column factor, fixed cut
FIGURES = {
    "4.30": dict(page=142, effect="PNIE", sub=("cut", [1, 2, 3]), rows=("a", L), cols=("b", L)),
    "4.32": dict(page=145, effect="TNIE", sub=("h", H), rows=("a", L), cols=("b", L), cut=1),
    "4.34": dict(page=149, effect="PNDE", sub=("cut", [1, 2, 3]), rows=("c", L), cols=("h", H)),
    "4.36": dict(page=152, effect="TNDE", sub=("h", H), rows=("a", L), cols=("c", L), cut=1),
    "4.38": dict(page=156, effect="MINT", sub=("cut", [1, 2, 3]), rows=("a", L), cols=("h", H)),
}


def _near(img, rgb, tol=45):
    return np.sqrt(((img - np.asarray(rgb)) ** 2).sum(axis=2)) <= tol


def bars(img):
    from scipy import ndimage

    masks = [_near(img, c) for c in (BELOW, WITHIN, ABOVE)]
    coloured = masks[0] | masks[1] | masks[2]
    lab, n = ndimage.label(coloured)
    out = []
    for k, sl in enumerate(ndimage.find_objects(lab), start=1):
        ys, xs = sl
        h, w = ys.stop - ys.start, xs.stop - xs.start
        if h < 40 or w < 8 or w > 60:
            continue      # legend keys, text and slivers
        xc = (xs.start + xs.stop) // 2
        half = max(1, w // 4)
        cols = slice(xc - half, xc + half + 1)
        region = lab[ys, cols] == k
        heights = []
        for m in masks:
            heights.append(float((m[ys, cols] & region).sum(axis=0).mean()))
        total = sum(heights)
        out.append({"x0": xs.start, "x1": xs.stop - 1, "y0": ys.start, "y1": ys.stop - 1,
                    "below": heights[0] / total, "within": heights[1] / total, "above": heights[2] / total,
                    "height": total})
    return out


def panels_from_bars(bs):
    """Five bars with the same baseline and small gaps make a panel."""
    rows = _clusters([b["y1"] for b in bs], 3)
    panels = []
    for row in rows:
        members = sorted([b for b in bs if b["y1"] in row], key=lambda b: b["x0"])
        width = np.median([b["x1"] - b["x0"] for b in members])
        group = [members[0]]
        for b in members[1:]:
            if b["x0"] - group[-1]["x1"] <= 0.4 * width:
                group.append(b)
            else:
                panels.append(group)
                group = [b]
        panels.append(group)
    return panels


def our_shares(effect):
    out = {}
    for r in csv.DictReader(open(ROOT / "results" / "cells.csv")):
        if r["effect"] != effect:
            continue
        key = (int(r["cut_index"]), int(r["n"]), float(r["a"]), float(r["b"]), float(r["c"]), float(r["h"]))
        out[key] = (float(r["truth_below_ci"]), float(r["cover"]), float(r["truth_above_ci"]))
    return out


def main(pdf):
    rows_out, problems = [], []
    for fig, cfg in FIGURES.items():
        img = page_image(pdf, cfg["page"])
        bs = bars(img)
        groups = panels_from_bars(bs)
        bad = [g for g in groups if len(g) != 5]
        if bad:
            problems.append(f"{fig}: {len(bad)} bar groups without 5 bars: {[len(g) for g in bad]}")
        groups = [g for g in groups if len(g) == 5]
        rects = [(g[0]["x0"], min(b["y0"] for b in g), g[-1]["x1"], g[0]["y1"]) for g in groups]
        pos, nsub = layout(rects, gap=40)
        expect = len(cfg["sub"][1])
        if nsub != expect:
            problems.append(f"{fig}: {nsub} subfigures, expected {expect}")
            continue
        ours = our_shares(cfg["effect"])
        for i, g in enumerate(groups):
            s, r, c = pos[i]
            facets = {cfg["rows"][0]: cfg["rows"][1][r], cfg["cols"][0]: cfg["cols"][1][c]}
            subf, sublev = cfg["sub"]
            cut = cfg.get("cut")
            if subf == "cut":
                cut = sublev[s]
            else:
                facets[subf] = sublev[s]
            for b, n in zip(g, NS):
                vals = [v for k, v in ours.items() if k[0] == cut and k[1] == n
                        and all(abs(dict(zip("abch", k[2:]))[f] - val) < 1e-9 for f, val in facets.items())]
                mean = [sum(v[j] for v in vals) / len(vals) for j in range(3)] if vals else [None] * 3
                err = 1.5 / b["height"]
                rows_out.append({
                    "figure": fig, "effect": cfg["effect"], "cut_index": cut, "n": n,
                    "a": facets.get("a", ""), "b": facets.get("b", ""), "c": facets.get("c", ""), "h": facets.get("h", ""),
                    "chen_below": round(b["below"], 4), "chen_within": round(b["within"], 4), "chen_above": round(b["above"], 4),
                    "reading_error": round(err, 4),
                    "our_below": "" if vals == [] else round(mean[0], 4),
                    "our_within": "" if vals == [] else round(mean[1], 4),
                    "our_above": "" if vals == [] else round(mean[2], 4),
                    "cells_averaged": len(vals),
                })
    path = ROOT / "results" / "digitized_imbalance.csv"
    with open(path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows_out[0]))
        w.writeheader()
        w.writerows(rows_out)
    print(f"{len(rows_out)} bars -> {path}")
    for p in problems:
        print("PROBLEM", p)


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else str(ROOT / "source" / "chen2021.pdf"))
