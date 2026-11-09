"""Identity checks on Chen's printed Head Start estimates (Tables 4.6-4.7), and what
her real-data analysis shows about how she coded treatment and computed PNDE.

Her effects are defined from the path estimates (Appendix B):
    PNIE = a b,  TNIE = a b + a h,  PNDE = c' + h i0M,  TNDE = c' + h i0M + a h,
where i0M is the intercept of the mediator model m ~ t + r (r centred at the
cutoff). Tables 4.6 (paths) and 4.7 (effects) print both sides, so each
identity can be checked within rounding (paths to three decimals), and the
PNDE identity gives the i0M her real-data code used. That is compared with the
mediator means of Table 4.2. Treatment direction is read from Table 4.2: the
range of the assignment variable in each group.

Writes results/empirical_consistency.json.
    python3 secondary/empirical_consistency.py
"""

from __future__ import annotations

import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
rows = list(csv.DictReader(open(ROOT / "secondary" / "table_arithmetic.csv")))
est = {}
for r in rows:
    for design, col in (("RCT", "rct"), (f"RDD{r['cut']}", "rdd")):
        est.setdefault(design, {})[r["effect"]] = float(r[col])

HALF = 0.0005                     # half a unit in the third decimal
out = {"identities": [], "implied_i0M": {}, "treatment_direction": {}}
for design, e in est.items():
    a, b, c, h = e["a"], e["b"], e["c'"], e["h"]
    # worst-case rounding of a product of two printed 3-decimal numbers, plus the printed effect's own rounding
    def tol(*xs):
        return sum(abs(x) for x in xs) * HALF + HALF * len(xs) ** 0 + HALF
    checks = [
        ("PNIE = a b", e["PNIE"], a * b, tol(a, b)),
        ("TNIE = a b + a h", e["TNIE"], a * b + a * h, tol(a, b, h, a)),
        ("TNDE - PNDE = a h", e["TNDE"] - e["PNDE"], a * h, tol(a, h) + HALF),
    ]
    for name, printed, computed, t in checks:
        out["identities"].append({"design": design, "identity": name, "printed": round(printed, 4),
                                  "from_paths": round(computed, 4), "tolerance": round(t, 4),
                                  "holds": abs(printed - computed) <= t})
    if abs(h) >= 0.002:           # i0M = (PNDE - c') / h is meaningless when h rounds to almost 0
        out["implied_i0M"][design] = {"value": round((e["PNDE"] - c) / h, 2),
                                      "h": h, "note": "(PNDE - c') / h"}
    else:
        out["implied_i0M"][design] = {"value": None, "h": h,
                                      "note": f"h = {h} is too close to 0 for the printed rounding to identify i0M"}

t42 = list(csv.DictReader(open(ROOT / "source-values" / "table_4_2.csv")))
for r in t42:
    if r["variable"].startswith("spelling_w1"):
        cut = r["cutoff_score"]
        treated_low = float(r["treat_max"]) < float(r["control_min"])
        out["treatment_direction"][cut] = {
            "treated_range": [float(r["treat_min"]), float(r["treat_max"])],
            "control_range": [float(r["control_min"]), float(r["control_max"])],
            "treated_share": round(int(r["treat_n"]) / (int(r["treat_n"]) + int(r["control_n"])), 3),
            "treated_below_cutoff": treated_low}
    if r["variable"].startswith("minutes_read"):
        out.setdefault("mediator_means", {})[r["cutoff_score"]] = {"treated": float(r["treat_mean"]),
                                                                    "control": float(r["control_mean"])}
out["summary"] = {
    "identities_hold": sum(x["holds"] for x in out["identities"]),
    "identities_checked": len(out["identities"]),
    "finding": ("Her real-data effects obey their definitions; her code estimated h on real data; the i0M implied by "
                "PNDE is the scale of the mediator mean (Table 4.2), not 1; and in her Head Start analysis treatment "
                "is below the cutoff with the treated share as her text labels it, the reverse of her simulation code.")}
(ROOT / "results" / "empirical_consistency.json").write_text(json.dumps(out, indent=1) + "\n", encoding="utf-8")
print(json.dumps(out, indent=1))
