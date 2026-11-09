"""Agreement between Chen's digitized rates (Figures 4.17-4.37) and ours.

A point agrees when |Chen - ours| <= reading error + 3 Monte Carlo standard errors
of the difference of two means of k cells x 1,000 replications each:
3 * sqrt(2 p (1 - p) / (1000 k)), with p our rate. An occluded coverage point whose
value disagrees with Chen's own stacked-bar reading of the same cell
(results/digitize_crosscheck.csv) is excluded as unreliable and counted separately.

An "occluded" point is not a reading: its series is hidden under the others, and
digitize_raster_figures.py fills it in as the mean of the visible series at the same n,
with the spread of those series as its reading error. "Merged" points are panels where all
series coincide in one marker. The *_read columns use directly read points only.
Imbalance bars are summarised the same way on the "Above" share.
Writes results/rates_agreement.csv.
"""
import csv
import math
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
rows = list(csv.DictReader(open(ROOT / "results" / "digitized_rates.csv")))
cross = {(c["line_figure"], c["cut_index"], c["n"], c["a"], c["b"], c["c"], c["h"]): c["agree"] == "True"
         for c in csv.DictReader(open(ROOT / "results" / "digitize_crosscheck.csv"))}
agg = defaultdict(lambda: [0, 0, 0, 0.0, 0, 0, 0, 0, 0])
for r in rows:
    if r["chen_value"] == "" or r["our_value"] == "":
        continue
    ck = (r["figure"], r["cut_index"], r["n"], r["a"], r["b"], r["c"], r["h"])
    if r["status"] == "occluded" and cross.get(ck) is False:
        agg[(r["figure"], r["effect"], r["quantity"])][4] += 1
        continue
    chen, ours, k = float(r["chen_value"]), float(r["our_value"]), int(r["cells_averaged"])
    tol = float(r["reading_error"]) + 3 * math.sqrt(max(2 * ours * (1 - ours), 1e-4) / (1000 * k))
    key = (r["figure"], r["effect"], r["quantity"])
    agg[key][0] += 1
    agg[key][1] += abs(chen - ours) <= tol
    agg[key][2] += r["status"] == "occluded"
    agg[key][3] = max(agg[key][3], abs(chen - ours))
    h0 = float(r["our_value_if_h_were_0"])
    tol0 = float(r["reading_error"]) + 3 * math.sqrt(max(2 * h0 * (1 - h0), 1e-4) / (1000 * k))
    agg[key][5] += abs(chen - h0) <= tol0
    if r["status"] == "read":
        agg[key][6] += 1
        agg[key][7] += abs(chen - ours) <= tol
        agg[key][8] += abs(chen - h0) <= tol0
out = ROOT / "results" / "rates_agreement.csv"
with open(out, "w", newline="") as fh:
    w = csv.writer(fh)
    w.writerow(["figure", "effect", "quantity", "points", "agree", "pct_agree", "occluded", "max_abs_diff",
                "excluded_unreliable", "pct_agree_if_h_were_0", "points_read", "pct_agree_read",
                "pct_agree_if_h_were_0_read"])
    for key in sorted(agg):
        n, a, o, m, x, a0, nr, ar, a0r = agg[key]
        w.writerow([*key, n, a, round(100 * a / n, 1), o, round(m, 3), x, round(100 * a0 / n, 1), nr,
                    round(100 * ar / nr, 1) if nr else "", round(100 * a0r / nr, 1) if nr else ""])
    for fig in sorted({b["figure"] for b in csv.DictReader(open(ROOT / "results" / "digitized_imbalance.csv"))}):
        bars = [b for b in csv.DictReader(open(ROOT / "results" / "digitized_imbalance.csv")) if b["figure"] == fig]
        n = a = 0
        m = 0.0
        for b in bars:
            ours, k = float(b["our_above"]), int(b["cells_averaged"])
            tol = float(b["reading_error"]) + 3 * math.sqrt(max(2 * ours * (1 - ours), 1e-4) / (1000 * k))
            d = abs(float(b["chen_above"]) - ours)
            n += 1; a += d <= tol; m = max(m, d)
        w.writerow([fig, bars[0]["effect"], "above_share", n, a, round(100 * a / n, 1), 0, round(m, 3), 0, "",
                    "", "", ""])
print(open(out).read())
