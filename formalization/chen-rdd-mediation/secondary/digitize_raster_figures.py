"""Read Chen's Type I error, power and coverage figures (4.17-4.29, odd 4.31-4.37).

These figures are embedded raster images (about 200 dpi). For each panel:

- the panel border is found from long dark lines (projection profiles), and panels
  are grouped into facet grids and subfigures by their gaps;
- the y axis is calibrated from the grey reference line Chen draws at a stated
  value (.05 Type I, .80 power, .95 coverage) and the spacing of the tick marks,
  whose label step is read once per figure; the predicted tick values are checked
  to fall on multiples of that step;
- the x axis is calibrated from the tick marks at 2500, 5000, 7500 and 10000;
- each series is found by its ggplot hue at the five sample sizes: within a few
  pixels of each n, the rows where the series colour is widest (the marker) give
  its centre. A marker hidden under another series is reported as `occluded`, and
  its value is then the centre of the visible markers there, with a reading error
  of one marker radius. Where no series can be separated (small JPEG panels in
  which all series coincide), the centre of all coloured pixels there is reported
  as `merged`, with half their vertical spread as the reading error.

Writes results/digitized_rates.csv: one row per point with Chen's value, its
reading error, our mean rate over the same cells (results/cells.csv), and our
mean rate over the same cells with h set to 0 (a consistency reading, as in
statement_checks.py; not a claim about what Chen ran).

    python3 secondary/digitize_raster_figures.py source/chen2021.pdf
"""

from __future__ import annotations

import csv
import io
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from digitize import Axis  # noqa: E402

ROOT = HERE.parent
L = [0.0, 0.14, 0.39, 0.59]
LNZ = [0.14, 0.39, 0.59]
H = [0.0, 0.05, 0.15, 0.34]
HNZ = [0.05, 0.15, 0.34]
NS = [500, 1000, 2500, 5000, 10000]
HUES = {
    1: [(248, 118, 109)],
    2: [(248, 118, 109), (0, 191, 196)],
    3: [(248, 118, 109), (0, 186, 56), (97, 156, 255)],
    4: [(248, 118, 109), (124, 174, 0), (0, 191, 196), (199, 124, 255)],
}
CUT = "cut"


def grid(cols=None, rows=None):
    """Facet grid mapping: col and row factors with levels (either may be None)."""
    return {"cols": cols, "rows": rows}


# figure -> page, effect, quantity, ref value, tick step, subfigure rule, grid, colour factor+levels, fixed
FIGURES = {
    "4.17": dict(page=115, effect="PNIE", q="reject", ref=0.05, step=0.02, subs="cut_by_row_two_sides",
                 sides=[dict(fixed={"b": 0.0}, colour=("a", L)), dict(fixed={"a": 0.0}, colour=("b", L))]),
    "4.18": dict(page=117, effect="TNIE", q="reject", ref=0.05, step=0.02, subs="cut_per_sub",
                 grid=grid(cols=("b", L)), fixed={"a": 0.0}, colour=("h", H)),
    "4.19": dict(page=119, effect="PNDE", q="reject", ref=0.05, step=0.01, subs="cut_per_sub",
                 grid=grid(), fixed={"c": 0.0, "h": 0.0}, colour=("h", [0.0])),
    "4.20": dict(page=121, effect="TNDE", q="reject", ref=0.05, step=0.01, subs="cut_per_sub",
                 grid=grid(), fixed={"c": 0.0, "h": 0.0}, colour=("a", L)),
    "4.21": dict(page=123, effect="MINT", q="reject", ref=0.05, step=0.02, subs="cut_by_row_two_sides",
                 sides=[dict(fixed={"h": 0.0}, colour=("a", L)), dict(fixed={"a": 0.0}, colour=("h", H))]),
    "4.22": dict(page=125, effect="PNIE", q="reject", ref=0.80, step=0.25, subs="one",
                 grid=grid(cols=("a", LNZ), rows=("b", LNZ)), fixed={}, colour=(CUT, [1, 2, 3])),
    "4.23": dict(page=127, effect="TNIE", q="reject", ref=0.80, step=0.25, subs="one", cut=1,
                 grid=grid(cols=("a", LNZ), rows=("b", L)), fixed={}, colour=("h", H)),
    "4.24": dict(page=129, effect="TNIE", q="reject", ref=0.80, step=0.25, subs="one",
                 grid=grid(cols=("a", LNZ), rows=("b", L)), fixed={"h": 0.15}, colour=(CUT, [1, 2, 3])),
    "4.25": dict(page=131, effect="PNDE", q="reject", ref=0.80, step=0.25, subs="one",
                 grid=grid(cols=("c", L), rows=("h", H)), fixed={}, colour=(CUT, [1, 2, 3])),
    "4.26": dict(page=133, effect="TNDE", q="reject", ref=0.80, step=0.25, subs="one", cut=1,
                 grid=grid(cols=("c", L), rows=("a", L)), fixed={}, colour=("h", H)),
    "4.27": dict(page=134, effect="TNDE", q="reject", ref=0.80, step=0.25, subs="one",
                 grid=grid(cols=("c", L), rows=("a", L)), fixed={"h": 0.15}, colour=(CUT, [1, 2, 3])),
    "4.28": dict(page=136, effect="MINT", q="reject", ref=0.80, step=0.20, subs="one",
                 grid=grid(cols=("a", LNZ), rows=("h", HNZ)), fixed={}, colour=(CUT, [1, 2, 3])),
    "4.29": dict(page=140, effect="PNIE", q="cover", ref=0.95, step=0.25, subs="one",
                 grid=grid(cols=("a", L), rows=("b", L)), fixed={}, colour=(CUT, [1, 2, 3])),
    "4.31": dict(page=144, effect="TNIE", q="cover", ref=0.95, step=0.25, subs="cut_per_sub",
                 grid=grid(cols=("a", L), rows=("b", L)), fixed={}, colour=("h", H)),
    "4.33": dict(page=147, effect="PNDE", q="cover", ref=0.95, step=0.25, subs="one",
                 grid=grid(cols=("c", L), rows=("h", H)), fixed={}, colour=(CUT, [1, 2, 3])),
    "4.35": dict(page=151, effect="TNDE", q="cover", ref=0.95, step=0.25, subs="cut_per_sub",
                 grid=grid(cols=("c", L), rows=("a", L)), fixed={}, colour=("h", H)),
    "4.37": dict(page=154, effect="MINT", q="cover", ref=0.95, step=0.25, subs="one",
                 grid=grid(cols=("a", L), rows=("h", H)), fixed={}, colour=(CUT, [1, 2, 3])),
}


# ---------------------------------------------------------------- image helpers

def page_image(pdf, page):
    import fitz
    from PIL import Image

    with fitz.open(pdf) as doc:
        pg = doc[page - 1]
        xref = pg.get_images(full=True)[0][0]
        raw = doc.extract_image(xref)["image"]
    return np.asarray(Image.open(io.BytesIO(raw)).convert("RGB")).astype(int)


def _peaks(prof, minval, merge=3):
    idx = np.nonzero(prof >= minval)[0]
    groups = []
    for i in idx:
        if groups and i - groups[-1][-1] <= merge:
            groups[-1].append(i)
        else:
            groups.append([i])
    return [int(round(np.average(g, weights=prof[g]))) for g in groups]


def find_panels(img, dark=170, minw=100, minh=50, cover=0.85):
    g = img.mean(axis=2)
    lowsat = (img.max(axis=2) - img.min(axis=2)) < 45
    d = (g < dark) & lowsat
    dd = d | np.roll(d, 1, 0) | np.roll(d, -1, 0) | np.roll(d, 1, 1) | np.roll(d, -1, 1)
    # a 1-px line drawn between pixel columns spreads over two lighter ones
    dx = (np.minimum(g, np.roll(g, -1, 1)) < dark) & lowsat
    dy = (np.minimum(g, np.roll(g, -1, 0)) < dark) & lowsat
    xs = _peaks(dx.sum(axis=0).astype(float), minh, merge=1)
    ys = _peaks(dy.sum(axis=1).astype(float), minw, merge=1)

    def ok(x0, y0, x1, y1):
        return (dd[y0, x0:x1 + 1].mean() >= cover and dd[y1, x0:x1 + 1].mean() >= cover
                and dd[y0:y1 + 1, x0].mean() >= cover and dd[y0:y1 + 1, x1].mean() >= cover)

    out = []
    for x0 in xs:
        for y0 in ys:
            hit = None
            for x1 in [x for x in xs if x - x0 >= minw]:
                for y1 in [y for y in ys if y - y0 >= minh]:
                    if ok(x0, y0, x1, y1):
                        hit = (x0, y0, x1, y1)
                        break
                if hit:
                    break
            if hit:
                out.append(hit)
    # panels drawn without a left border (first facet column in some figures):
    # follow the top and bottom border lines left from a neighbour's left edge
    added = True
    while added:
        added = False
        for (x0, y0, x1, y1) in list(out):
            # the neighbour's right edge is this panel's left edge, or a line just left of it
            xr = next((x for x in range(x0, max(x0 - 14, 0), -1)
                       if x == x0 or dd[y0:y1 + 1, x].mean() >= cover), None)
            if xr is None:
                continue
            xl = xr - 2
            while xl > 0 and dd[y0, xl - 1] and dd[y1, xl - 1]:
                xl -= 1
            cand = (xl, y0, xr, y1)
            if xr - xl >= minw and not any(o[0] <= xl + 3 and o[2] >= xr - 3 and abs(o[1] - y0) <= 3 for o in out):
                out.append(cand)
                added = True
    out = sorted(set(trim_strip(img, r) for r in out))
    return [r for r in out if not any(o != r and o[0] >= r[0] and o[1] >= r[1] and o[2] <= r[2] and o[3] <= r[3]
                                     for o in out)]


def trim_strip(img, rect):
    """Drop a facet strip (grey85 fill) that was taken into the top of a panel."""
    x0, y0, x1, y1 = rect
    y = y0 + 1
    while y < y1 - 20:
        row = img[y, x0 + 3:x1 - 2]
        g = row.mean(axis=1)
        if ((g > 200) & (g < 228) & ((row.max(axis=1) - row.min(axis=1)) < 20)).mean() > 0.7:
            y += 1
            continue
        break
    if y == y0 + 1:
        return rect
    while y < y1 - 20 and img[y, x0 + 3:x1 - 2].mean() < 200:   # the strip's lower border
        y += 1
    return (x0, y, x1, y1)


def _clusters(values, gap):
    out = []
    for v in sorted(values):
        if out and v - out[-1][-1] <= gap:
            out[-1].append(v)
        else:
            out.append([v])
    return out


def layout(panels, gap=16):
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
            dx = max(a[0] - b[2], b[0] - a[2], 0)
            dy = max(a[1] - b[3], b[1] - a[3], 0)
            if dx < gap and dy < gap:
                parent[find(i)] = find(j)
    groups = {}
    for i in range(n):
        groups.setdefault(find(i), []).append(i)
    subs = sorted(groups.values(), key=lambda g: (round(min(panels[i][1] for i in g) / 60), min(panels[i][0] for i in g)))
    pos = {}
    for s, members in enumerate(subs):
        cols = _clusters([panels[i][0] for i in members], 12)
        rows = _clusters([panels[i][3] for i in members], 12)
        for i in members:
            c = next(k for k, gg in enumerate(cols) if panels[i][0] in gg)
            r = next(k for k, gg in enumerate(rows) if panels[i][3] in gg)
            pos[i] = (s, r, c)
    return pos, len(subs)


def ticks_left(img, p):
    x0, y0, x1, y1 = p
    strip = img[y0:y1 + 1, max(x0 - 4, 0):x0].mean(axis=2)
    rows = np.nonzero((strip < 150).mean(axis=1) >= 0.75)[0]
    return [y0 + float(np.mean(g)) for g in _clusters(list(rows), 1)]


def ticks_below(img, p):
    x0, y0, x1, y1 = p
    strip = img[y1 + 1:y1 + 5, x0:x1 + 1].mean(axis=2)
    cols = np.nonzero((strip < 150).mean(axis=0) >= 0.75)[0]
    return [x0 + float(np.mean(g)) for g in _clusters(list(cols), 1)]


def ref_line(img, p):
    """Row of the grey reference line inside the panel: the darkest wide grey row."""
    x0, y0, x1, y1 = p
    inner = img[y0 + 3:y1 - 2, x0 + 3:x1 - 2]
    g = inner.mean(axis=2)
    lowsat = (inner.max(axis=2) - inner.min(axis=2)) < 25
    grey = lowsat & (g > 120) & (g < 222)
    frac = grey.mean(axis=1)
    rows = np.nonzero(frac >= 0.5)[0]
    if len(rows) == 0:
        return None
    best = max(_clusters(list(rows), 1), key=lambda gg: (frac[gg].max(), -g[gg].mean(axis=1).min()))
    w = 230 - g[best].mean(axis=1)
    return y0 + 3 + float(np.average(best, weights=np.clip(w, 1e-6, None)))


def read_series(img, p, x_at, colours, tol):
    x0, y0, x1, y1 = p
    inner = img[y0 + 2:y1 - 1]
    spacing = abs(x_at[1] - x_at[0])
    half = max(2, int(min(5, spacing * 0.3)))
    out = {}
    for k, rgb in enumerate(colours):
        dist = np.sqrt(((inner - np.asarray(rgb)) ** 2).sum(axis=2))
        mask = dist <= tol
        for n, xc in zip(NS, x_at):
            xa, xb = int(round(xc)) - half, int(round(xc)) + half + 1
            win = mask[:, xa:xb]
            counts = win.sum(axis=1)
            if counts.sum() < 4 or counts.max() < 2:
                out[(k, n)] = None
                continue
            top = counts.max()
            rows = np.nonzero(counts >= max(2, 0.6 * top))[0]
            # keep the widest run (the marker), not a line passing through
            runs = _clusters(list(rows), 1)
            run = max(runs, key=lambda r: counts[r].sum())
            out[(k, n)] = (y0 + 2 + float(np.average(run, weights=counts[run])), (len(run) + 1) / 2)
    # all series together: any saturated pixel, for points where the series are merged
    sat = (inner.max(axis=2) - inner.min(axis=2)) > 30
    for n, xc in zip(NS, x_at):
        xa, xb = int(round(xc)) - half, int(round(xc)) + half + 1
        counts = sat[:, xa:xb].sum(axis=1)
        rows = np.nonzero(counts >= 1)[0]
        if len(rows) >= 2:
            run = max(_clusters(list(rows), 2), key=lambda r: counts[r].sum())
            out[("any", n)] = (y0 + 2 + float(np.average(run, weights=counts[run])), (run[-1] - run[0] + 2) / 2)
        else:
            out[("any", n)] = None
    return out


# ---------------------------------------------------------------- our values

def our_rates():
    rows = list(csv.DictReader(open(ROOT / "results" / "cells.csv")))
    out = []
    for r in rows:
        out.append((r["effect"], int(r["cut_index"]), int(r["n"]), float(r["a"]), float(r["b"]), float(r["c"]),
                    float(r["h"]), float(r["reject"]), float(r["cover"])))
    return out


def our_mean(cells, effect, cut, n, facets, q):
    idx = {"a": 3, "b": 4, "c": 5, "h": 6}
    vals = [c[7] if q == "reject" else c[8] for c in cells
            if c[0] == effect and c[1] == cut and c[2] == n
            and all(abs(c[idx[f]] - v) < 1e-9 for f, v in facets.items())]
    return (sum(vals) / len(vals), len(vals)) if vals else (None, 0)


# ---------------------------------------------------------------- main

def main(pdf):
    cells = our_rates()
    out = []
    problems = []
    for fig, cfg in FIGURES.items():
        img = page_image(pdf, cfg["page"])
        jpeg = False
        panels = find_panels(img)
        pos, nsub = layout(panels)
        tol = 70 if fig in ("4.20", "4.29", "4.31", "4.33", "4.35") else 45
        # axis ticks shared along rows and columns of each subfigure
        lt = {i: ticks_left(img, p) for i, p in enumerate(panels)}
        bt = {i: ticks_below(img, p) for i, p in enumerate(panels)}
        refs = {i: ref_line(img, p) for i, p in enumerate(panels)}
        for i, p in enumerate(panels):
            s, r, c = pos[i]
            sub_rule = cfg["subs"]
            if sub_rule == "cut_by_row_two_sides":
                cut, side = s // 2 + 1, cfg["sides"][s % 2]
                fixed, (cf, clev), facets_base = side["fixed"], side["colour"], {}
            else:
                cut = cfg.get("cut") or (s + 1 if sub_rule == "cut_per_sub" else None)
                fixed, (cf, clev) = cfg["fixed"], cfg["colour"]
                facets_base = {}
                gcols, grows = cfg["grid"]["cols"], cfg["grid"]["rows"]
                if gcols:
                    facets_base[gcols[0]] = gcols[1][c]
                if grows:
                    facets_base[grows[0]] = grows[1][r]
            # y calibration: this panel's reference line plus left ticks of its row
            yt = lt[i] or next((lt[j] for j in lt if pos[j][0] == s and pos[j][1] == r and lt[j]), [])
            xt = bt[i] or next((bt[j] for j in bt if pos[j][0] == s and pos[j][2] == c and bt[j]), [])
            yref = refs[i]
            if yref is None:   # the series covers the line here; panels in one facet row share the y scale
                yref = next((refs[j] - panels[j][3] + p[3] for j in refs
                             if refs[j] is not None and pos[j][0] == s and pos[j][1] == r), None)
            if yref is None or len(yt) < 2 or len(xt) != 4:
                problems.append(f"{fig} panel {i} sub {s} r{r} c{c}: ref={yref} yticks={len(yt)} xticks={len(xt)}")
                continue
            spacing = float(np.median(np.diff(sorted(yt))))
            yaxis = Axis.from_references([(yref, cfg["ref"]), (yref - spacing, cfg["ref"] + cfg["step"])])
            tick_vals = [yaxis.value(t) / cfg["step"] for t in yt]
            if max(abs(v - round(v)) for v in tick_vals) > 0.12:
                problems.append(f"{fig} panel {i}: ticks off the {cfg['step']} grid: {[round(v, 2) for v in tick_vals]}")
                continue
            xaxis = Axis.from_references(list(zip(sorted(xt), (2500, 5000, 7500, 10000))))
            inv = 1 / xaxis.scale
            x_at = [(n - xaxis.offset) * inv for n in NS]
            colours = HUES[len(clev)]
            got = read_series(img, p, x_at, colours, tol)
            for k, lev in enumerate(clev):
                for n in NS:
                    facets = dict(fixed)
                    facets.update(facets_base)
                    this_cut = cut
                    if cf == CUT:
                        this_cut = lev
                    else:
                        facets[cf] = lev
                    hit = got[(k, n)]
                    status = "read"
                    if hit is None:
                        others = [got[(j, n)] for j in range(len(clev)) if j != k and got[(j, n)] is not None]
                        if not others and got[("any", n)] is not None:
                            status = "merged"
                            yv, rad = got[("any", n)]
                        elif not others:
                            status, yv, rad = "missing", None, None
                        else:
                            status = "occluded"
                            yv = float(np.mean([o[0] for o in others]))
                            rad = max(o[1] for o in others) + max(abs(o[0] - yv) for o in others)
                    else:
                        yv, rad = hit
                    ours, k_cells = our_mean(cells, cfg["effect"], this_cut, n, facets, cfg["q"])
                    # the same cells read as if h were 0 (h facet replaced, or hidden h fixed at 0)
                    ours_h0, _ = our_mean(cells, cfg["effect"], this_cut, n, dict(facets, h=0.0), cfg["q"])
                    out.append({
                        "figure": fig, "effect": cfg["effect"], "quantity": cfg["q"], "cut_index": this_cut, "n": n,
                        "a": facets.get("a", ""), "b": facets.get("b", ""), "c": facets.get("c", ""), "h": facets.get("h", ""),
                        "status": status,
                        "chen_value": "" if yv is None else round(yaxis.value(yv), 4),
                        "reading_error": "" if yv is None else round(yaxis.error(rad or 1.0) + 0.002, 4),
                        "our_value": "" if ours is None else round(ours, 4), "cells_averaged": k_cells,
                        "our_value_if_h_were_0": "" if ours_h0 is None else round(ours_h0, 4),
                    })
    path = ROOT / "results" / "digitized_rates.csv"
    with open(path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(out[0]))
        w.writeheader()
        w.writerows(out)
    print(f"{len(out)} points -> {path}")
    for msg in problems:
        print("PROBLEM", msg)


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else str(ROOT / "source" / "chen2021.pdf"))
