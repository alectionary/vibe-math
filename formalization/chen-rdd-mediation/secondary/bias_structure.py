"""Fit Chen's digitized mean bias (Figures 4.12-4.16) on design terms.

Every plotted point averages the cell biases over the factors its figure does not
show, so each candidate term is averaged the same way. A least-squares fit per
figure and cutoff on ab, ah, c', h, a, b and a constant shows how her plotted bias
depends on the design. Sample size is not a term: if her bias does not change with
n, the residuals stay small without it.

Writes results/bias_structure.csv.
    python3 secondary/bias_structure.py
"""

from __future__ import annotations

import csv
import itertools
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
LEVELS = [0.0, 0.14, 0.39, 0.59]
H_LEVELS = [0.0, 0.05, 0.15, 0.34]
TERMS = {
    "ab": lambda a, b, c, h: a * b,
    "ah": lambda a, b, c, h: a * h,
    "c": lambda a, b, c, h: c,
    "h": lambda a, b, c, h: h,
    "a": lambda a, b, c, h: a,
    "b": lambda a, b, c, h: b,
}


def _value(row, key):
    return None if row[key] == "" else float(row[key])


def averaged(row, f):
    grids = []
    for key, levels in (("a", LEVELS), ("b", LEVELS), ("c", LEVELS), ("h", H_LEVELS)):
        v = _value(row, key)
        grids.append([v] if v is not None else levels)
    return float(np.mean([f(*combo) for combo in itertools.product(*grids)]))


def main():
    rows = list(csv.DictReader(open(ROOT / "results" / "digitized_bias.csv")))
    out = []
    keys = sorted({(r["figure"], r["effect"], r["cut_index"]) for r in rows})
    for fig, effect, cut in keys:
        group = [r for r in rows if (r["figure"], r["effect"], r["cut_index"]) == (fig, effect, cut)]
        X = np.column_stack([[averaged(r, f) for r in group] for f in TERMS.values()] + [np.ones(len(group))])
        y = np.array([float(r["chen_mean_bias"]) for r in group])
        beta, *_ = np.linalg.lstsq(X, y, rcond=None)
        resid = y - X @ beta
        record = {"figure": fig, "effect": effect, "cut_index": int(cut), "points": len(group)}
        record.update({f"coef_{k}": round(float(v), 3) for k, v in zip(list(TERMS) + ["const"], beta)})
        record["max_abs_residual"] = round(float(np.abs(resid).max()), 4)
        record["max_reading_error"] = max(float(r["reading_error"]) for r in group)
        record["chen_pct_abs_bias_gt_.10"] = round(100 * float(np.mean(np.abs(y) > 0.10)), 2)
        ours = np.array([float(r["our_mean_bias"]) for r in group])
        record["our_pct_abs_bias_gt_.10"] = round(100 * float(np.mean(np.abs(ours) > 0.10)), 2)
        record["our_max_abs_bias"] = round(float(np.abs(ours).max()), 4)
        out.append(record)
    path = ROOT / "results" / "bias_structure.csv"
    with open(path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(out[0]))
        w.writeheader()
        w.writerows(out)
    print(f"{len(out)} fits -> {path}")


if __name__ == "__main__":
    main()
