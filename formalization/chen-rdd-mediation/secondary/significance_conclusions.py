"""Do RDD and RCT intervals reach opposite significance conclusions (Chen 2021, abstract and p. 143)?

Chen's abstract says the 95% CIs for RDD estimates "made opposite significance conclusions than the RCT
estimates", and Chapter 5 (printed p. 143) adds "if the RCT was significant, the RDD estimate would not be
significant". Her printed Table 4.7 gives every interval, so the claim can be read off her own table:
an estimate is significant when its printed 95% CI excludes 0.

Input: source-values/table_4_7.csv. Output: results/significance_conclusions.json.
    python3 secondary/significance_conclusions.py
"""
import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
rows = list(csv.DictReader(open(ROOT / "source-values" / "table_4_7.csv")))
sig = {(r["effect"], r["design"]): float(r["ci_low"]) > 0 or float(r["ci_high"]) < 0 for r in rows}
cells = []
for effect in ["PNIE", "TNIE", "PNDE", "TNDE", "MINT"]:
    for cut in (1, 2, 3):
        rct, rdd = sig[(effect, "RCT")], sig[(effect, f"RDD{cut}")]
        cells.append({"effect": effect, "cut_index": cut, "rct_significant": rct, "rdd_significant": rdd,
                      "opposite": rct != rdd})
opp = [c for c in cells if c["opposite"]]
rct_sig = [c for c in cells if c["rct_significant"]]
out = {
    "comparisons": len(cells),
    "opposite": len(opp),
    "same": len(cells) - len(opp),
    "rct_significant_then_rdd_not": sum(not c["rdd_significant"] for c in rct_sig),
    "rct_significant": len(rct_sig),
    "rct_not_significant_but_rdd_significant": sum(c["rdd_significant"] and not c["rct_significant"] for c in cells),
    "same_conclusion_cells": [f'{c["effect"]} cut {c["cut_index"]}' for c in cells if not c["opposite"]],
    "rdd_significant_cells": [f'{c["effect"]} cut {c["cut_index"]}' for c in cells if c["rdd_significant"]],
    "cells": cells,
}
(ROOT / "results" / "significance_conclusions.json").write_text(json.dumps(out, indent=1) + "\n")
print({k: v for k, v in out.items() if k != "cells"})
