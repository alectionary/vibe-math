"""Internal check of the two raster readers: Chen plots coverage twice, once as a line
(Figures 4.29, 4.31, 4.33, 4.35, 4.37) and once as the "Within" share of a stacked bar
(Figures 4.30, 4.32, 4.34, 4.36, 4.38). Where both show the same cells, the two readings
of her own figures should agree within their combined reading error.
Writes results/digitize_crosscheck.csv."""
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
rates = [r for r in csv.DictReader(open(ROOT / "results" / "digitized_rates.csv"))
         if r["quantity"] == "cover" and r["chen_value"] != ""]
bars = list(csv.DictReader(open(ROOT / "results" / "digitized_imbalance.csv")))
key = lambda r: (r["effect"], r["cut_index"], r["n"], r["a"], r["b"], r["c"], r["h"])
bar_by = {key(r): r for r in bars}
out, agree = [], 0
for r in rates:
    b = bar_by.get(key(r))
    if not b:
        continue
    diff = float(r["chen_value"]) - float(b["chen_within"])
    tol = float(r["reading_error"]) + float(b["reading_error"])
    ok = abs(diff) <= tol
    agree += ok
    out.append({"line_figure": r["figure"], "bar_figure": b["figure"], "effect": r["effect"], "cut_index": r["cut_index"],
                "n": r["n"], "a": r["a"], "b": r["b"], "c": r["c"], "h": r["h"], "line_status": r["status"],
                "line_value": r["chen_value"], "bar_within": b["chen_within"], "diff": round(diff, 4),
                "tolerance": round(tol, 4), "agree": ok})
with open(ROOT / "results" / "digitize_crosscheck.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(out[0]))
    w.writeheader()
    w.writerows(out)
by = {}
for o in out:
    k = (o["line_figure"], o["bar_figure"], o["line_status"])
    by.setdefault(k, [0, 0, 0.0])
    by[k][0] += 1; by[k][1] += o["agree"]; by[k][2] = max(by[k][2], abs(o["diff"]))
for k, (n, a, m) in sorted(by.items()):
    print(*k, f"{a}/{n} agree, max |diff| {m:.3f}")
print(f"total {agree}/{len(out)}")
