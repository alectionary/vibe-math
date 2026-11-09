"""Compare the full exact replay of Chen's R code (1,000 replications, issue #118)
with the population values and with our Python run.

Input:  r-reproduction/out-full/condition_summary.csv (per condition and cutoff,
        mean and SD of each estimate over 1,000 of her seeded datasets),
        results/cells.csv (our run).
Output: results/r_full_comparison.csv (one row per condition, cutoff and effect)
        and results/r_full_comparison.json (summary).

    python3 secondary/r_full_comparison.py
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
EFFECTS = ["PNIE", "TNIE", "PNDE", "TNDE", "MINT"]


def population(effect, a, b, c, h):
    return {"PNIE": a * b, "TNIE": a * b + a * h, "PNDE": c, "TNDE": c + a * h, "MINT": a * h}[effect]


def main():
    r = pd.read_csv(ROOT / "r-reproduction" / "out-full" / "condition_summary.csv")
    ours = pd.read_csv(ROOT / "results" / "cells.csv")
    ours = ours.rename(columns={"a": "effa", "b": "effb", "c": "effcpr", "h": "effh", "n": "nobs"})
    key = ["nobs", "effa", "effb", "effcpr", "effh"]
    for k in key[1:]:
        r[k] = r[k].round(2)
        ours[k] = ours[k].round(2)
    rows = []
    for _, row in r.iterrows():
        for cut in (1, 2, 3):
            for eff in EFFECTS:
                truth = population(eff, row.effa, row.effb, row.effcpr, row.effh)
                mean, sd = row[f"mean_{eff}{cut}"], row[f"sd_{eff}{cut}"]
                rows.append({**{k: row[k] for k in key}, "cut_index": cut, "effect": eff,
                             "population": truth, "r_mean": mean, "r_sd": sd,
                             "r_bias": mean - truth, "r_mcse": sd / np.sqrt(row.reps)})
    out = pd.DataFrame(rows)
    out = out.merge(ours[key + ["cut_index", "effect", "bias", "sd"]].rename(
        columns={"bias": "our_bias", "sd": "our_sd"}), on=key + ["cut_index", "effect"], how="left")
    assert out.our_bias.notna().all(), "unmatched cells"
    out["r_bias_z"] = out.r_bias / out.r_mcse.replace(0, np.nan)
    out["diff_z"] = (out.r_bias - out.our_bias) / np.sqrt(out.r_mcse ** 2 + (out.our_sd / np.sqrt(1000)) ** 2)
    out.to_csv(ROOT / "results" / "r_full_comparison.csv", index=False, float_format="%.6g")

    summ = {"cells": int(len(out)), "replications_per_condition": int(r.reps.min())}
    summ["max_abs_r_bias"] = float(out.r_bias.abs().max())
    summ["max_abs_r_bias_by_effect"] = {e: round(float(g.r_bias.abs().max()), 4) for e, g in out.groupby("effect")}
    z = out.r_bias_z.dropna()
    summ["share_abs_bias_z_gt_1.96"] = round(float((z.abs() > 1.96).mean()), 4)
    summ["share_abs_bias_z_gt_3.29"] = round(float((z.abs() > 3.29).mean()), 4)
    summ["max_abs_bias_z"] = round(float(z.abs().max()), 2)
    dz = out.diff_z.dropna()
    summ["share_abs_diff_z_gt_1.96"] = round(float((dz.abs() > 1.96).mean()), 4)
    summ["share_abs_diff_z_gt_3.29"] = round(float((dz.abs() > 3.29).mean()), 4)
    summ["corr_r_bias_our_bias"] = round(float(np.corrcoef(out.r_bias, out.our_bias)[0, 1]), 3)
    summ["sd_ratio_ours_over_r_median"] = round(float((out.our_sd / out.r_sd).median()), 4)
    summ["sd_ratio_ours_over_r_p05_p95"] = [round(float(q), 4) for q in (out.our_sd / out.r_sd).quantile([.05, .95])]
    summ["pct_abs_bias_gt_.10"] = {e: round(100 * float((g.r_bias.abs() > .10).mean()), 2) for e, g in out.groupby("effect")}
    # h recovery and the m-model intercept, per cutoff
    summ["h_slope_by_cut"] = {}
    summ["mean_i0m_by_cut"] = {}
    for cut in (1, 2, 3):
        slope = np.polyfit(r.effh, r[f"mean_h{cut}"], 1)[0]
        summ["h_slope_by_cut"][cut] = round(float(slope), 4)
        summ["mean_i0m_by_cut"][cut] = round(float(r[f"mean_i0m{cut}"].mean()), 5)
    # MINT at the E4 cell: n = 500, a = .59, h = .34, all b, c', cutoffs
    e4 = out[(out.effect == "MINT") & (out.nobs == 500) & (out.effa == .59) & (out.effh == .34)]
    summ["e4_mint_mean_estimate"] = round(float(e4.r_mean.mean()), 4)
    summ["e4_mint_population"] = round(float(e4.population.mean()), 4)
    # TNDE power gap (DISAGREEMENTS tnde-power-gap): cutoff 1, c' = .39, a = .59, h = 0,
    # n = 500. Normal-approximation power from the estimates' mean and SD, on her
    # replayed datasets and on ours; the bootstrap is not replayed, so only the
    # difference between the two sets of datasets is read from this.
    from scipy.stats import norm
    g = out[(out.effect == "TNDE") & (out.cut_index == 1) & (out.effcpr == .39) & (out.effa == .59)
            & (out.effh == 0) & (out.nobs == 500)]
    power = lambda m, sd: norm.cdf(m / sd - 1.96) + norm.cdf(-m / sd - 1.96)
    summ["tnde_gap"] = {
        "cells": int(len(g)),
        "sd_ratio_ours_over_r": round(float((g.our_sd / g.r_sd).mean()), 4),
        "approx_power_her_datasets": round(float(power(g.r_mean, g.r_sd).mean()), 4),
        "approx_power_our_datasets": round(float(power(g.population + g.our_bias, g.our_sd).mean()), 4),
        "mean_bias_her_datasets": round(float(g.r_bias.mean()), 4),
        "mean_bias_our_datasets": round(float(g.our_bias.mean()), 4),
    }
    (ROOT / "results" / "r_full_comparison.json").write_text(json.dumps(summ, indent=2) + "\n")
    print(json.dumps(summ, indent=2))


if __name__ == "__main__":
    main()
