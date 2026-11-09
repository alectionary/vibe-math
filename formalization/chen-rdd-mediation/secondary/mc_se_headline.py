"""Monte Carlo standard error of our E2 and E3 headline means (coverage shortfall and imbalance).

Each is a mean over the 15 effect-cutoff rows of Table 4.9, each row a mean of 256 condition cells with 1,000
replications. Two bounds: cells independent (binomial variance per cell), and cells within a condition fully
correlated across effects and cutoffs (the per-condition standard errors add linearly before averaging).

Input: results/cells.csv. Output: results/mc_se_headline.json.
    python3 secondary/mc_se_headline.py
"""
import json
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
c = pd.read_csv(ROOT / "results" / "cells.csv")
R = 1000
# E2: 95 - mean coverage (%). Per cell variance of coverage %: 100^2 p(1-p)/R.
c["var_cov"] = 1e4 * c.cover * (1 - c.cover) / R
# E3: (above - below) %. Multinomial variance of the difference: [pa + pb - (pa - pb)^2]/R.
c["var_imb"] = 1e4 * (c.truth_above_ci + c.truth_below_ci - (c.truth_above_ci - c.truth_below_ci) ** 2) / R
k = len(c)  # 15 rows x 1,280 conditions = 19,200 cells; the mean of row means is the mean over all cells
out = {}
for name, col in (("E2", "var_cov"), ("E3", "var_imb")):
    indep = float(np.sqrt(c[col].sum()) / k)
    corr = float((np.sqrt(c[col])).groupby(c["index"]).sum().pow(2).sum() ** 0.5 / k)
    out[name] = {"se_cells_independent": round(indep, 4), "se_cells_correlated_within_condition": round(corr, 4),
                 "units": "percentage points"}
out["cells"] = k
(ROOT / "results" / "mc_se_headline.json").write_text(json.dumps(out, indent=1) + "\n")
print(out)
