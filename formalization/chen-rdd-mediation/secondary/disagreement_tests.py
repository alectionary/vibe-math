"""Tests of the competing explanations for each disagreement with Chen (2021).

Each block computes what one hypothesis predicts and what the data show. Inputs
are committed results: our cells (results/cells.csv), Chen's digitized figures
(results/digitized_*.csv), the fits of her bias (results/bias_structure.csv),
the statement checks (results/statement_checks.csv) and the exact replay of her
seeded R code (r-reproduction/out/estimates.csv). Writes
results/disagreement_tests.json; DISAGREEMENTS.yaml cites its keys.

    python3 secondary/disagreement_tests.py
"""

from __future__ import annotations

import csv
import json
import math
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
R = ROOT / "results"
OUT = {}

cells = pd.read_csv(R / "cells.csv")
rep = pd.read_csv(ROOT / "r-reproduction" / "out" / "estimates.csv")
fits = pd.read_csv(R / "bias_structure.csv", dtype={"figure": str})
rates = pd.read_csv(R / "digitized_rates.csv", dtype={"figure": str})
bars = pd.read_csv(R / "digitized_imbalance.csv", dtype={"figure": str})
agree = pd.read_csv(R / "rates_agreement.csv", dtype={"figure": str})
sc = pd.read_csv(R / "statement_checks.csv")
summary = sc[sc.cells.astype(str).str.startswith("all")]
TREATED = {1: 0.75, 2: 0.50, 3: 0.25}          # share of cases at or above each cutoff

# ---------------------------------------------------------------- h
a, b, c, h = rep.effa, rep.effb, rep.effcpr, rep.effh
pop = {"PNIE": a * b, "TNIE": a * b + a * h, "PNDE": c, "TNDE": c + a * h, "MINT": a * h}
replay = {}
for k in (1, 2, 3):
    slope, intercept = np.polyfit(h, rep[f"h{k}"], 1)
    worst = {}
    for e, p in pop.items():
        m = (rep[f"{e}{k}"] - p).groupby([rep.nobs, a, b, c, h]).mean()
        worst[e] = round(float(m.abs().max()), 4)
    replay[k] = {"slope_of_h_hat_on_h": round(float(slope), 4), "intercept": round(float(intercept), 5),
                 "mean_i0M": round(float(rep[f"i0m{k}"].mean()), 5),
                 "max_abs_condition_mean_bias_50_reps": worst}
OUT["h.replay_of_her_seeded_code"] = {
    "datasets": int(len(rep)), "replications_per_condition": int(rep.reps.max()), "by_cutoff": replay,
    "note": "Her own gendata() and lm() on her own seeded datasets (r-reproduction, literal check identical). "
            "With 50 replications a condition mean has Monte Carlo error up to about .03 at n = 500."}

rej = agree[agree.quantity == "reject"]
OUT["h.zero_h_reading"] = {
    "figures": {r.figure: {"pct_agree": r.pct_agree, "pct_agree_if_h_were_0": r.pct_agree_if_h_were_0}
                for r in rej.itertuples()},
    "statements_disagreeing": int((summary.verdict == "disagree").sum()),
    "statements_disagreeing_that_agree_if_h_were_0": int(((summary.verdict == "disagree")
                                                          & (summary.verdict_if_h_were_0 == "agree")).sum())}

pn = fits[fits.effect == "PNIE"][["cut_index", "coef_ab", "coef_ah", "coef_h", "max_abs_residual"]]
OUT["h.interaction_dropped_from_the_fitted_model"] = {
    "prediction": "if her y model omitted tm, b-hat would absorb the interaction (b + h times the treated share), "
                  "so her PNIE bias would carry a positive a*h term that grows with the treated share",
    "PNIE_bias_fit": pn.to_dict(orient="records"),
    "finding": "the a*h and h coefficients of her PNIE bias are zero to three decimals at every cutoff"}

# adding a constant to y changes only the intercept of an OLS fit that has one
rng = np.random.default_rng(20261108)
n = 2000
x = rng.standard_normal(n); cut = np.quantile(x, .25); t = (x >= cut).astype(float); r = x - cut
m = .39 * t + rng.normal(0, math.sqrt(1 - .39 ** 2), n)
e = rng.normal(0, math.sqrt(1 - .39 ** 2), n)
X = np.column_stack([np.ones(n), t, r, m, t * m])
y_none = .14 * t + .39 * m + e                        # no interaction at all
y_ones = .14 * t + .39 * m + .34 * 1.0 + e            # 'interaction' multiplying the pre-filled column of 1s
bn, *_ = np.linalg.lstsq(X, y_none, rcond=None)
bo, *_ = np.linalg.lstsq(X, y_ones, rcond=None)
OUT["h.which_no_interaction_mechanism"] = {
    "coefficients_no_interaction": [round(float(v), 6) for v in bn],
    "coefficients_tm_filled_with_1s": [round(float(v), 6) for v in bo],
    "difference": [round(float(v), 9) for v in bo - bn],
    "finding": "only the intercept differs (by h); t, r, m and tm coefficients are identical, so a y generated "
               "before tm was filled in and a y generated with h = 0 give the same a, b, c' and h estimates. "
               "The published results cannot tell these two apart; her y intercepts were not reported."}

# ---------------------------------------------------------------- population values
cov = rates[(rates.figure == "4.29") & (rates.status == "read") & (rates.a > 0) & (rates.b > 0)]
by = cov.groupby(["cut_index", "n"]).chen_value.mean().unstack().round(3)
slope_n = {int(k): round(float(np.polyfit(np.log10(by.columns.astype(float)), by.loc[k].values, 1)[0]), 4)
           for k in by.index}
nz = bars[(bars.figure == "4.30") & (bars.a > 0) & (bars.b > 0)]
bar_means = nz.groupby("cut_index")[["chen_below", "chen_within", "chen_above"]].mean().round(3)
ks = fits[fits.effect == "PNIE"].set_index("cut_index").coef_ab.abs()
lam = {int(k): round(float(ks[k] / TREATED[k]), 3) for k in ks.index}
kc = fits[fits.effect == "PNDE"].set_index("cut_index").coef_c.abs()
OUT["population.patterns"] = {
    "PNIE_coverage_by_cut_and_n_nonzero_paths": {int(k): by.loc[k].to_dict() for k in by.index},
    "slope_of_coverage_on_log10_n": slope_n,
    "imbalance_bars_nonzero_paths": {int(k): bar_means.loc[k].to_dict() for k in bar_means.index},
    "control_share": {k: 1 - v for k, v in TREATED.items()},
    "PNIE_bias_multiplier_k": {int(k): round(float(v), 3) for k, v in ks.items()},
    "PNDE_bias_multiplier_on_c": {int(k): round(float(v), 3) for k, v in kc.items()},
    "lambda_equals_k_over_treated_share": lam}
OUT["population.condition_level_value_wrong"] = {
    "prediction": "a wrong population value per condition (for example ab(1 + k)) would let coverage fall toward 0 "
                  "as n grows, because the interval shrinks around the estimate while the value stays away",
    "finding": "coverage falls with n only to a plateau at about the control share (.25, .49, .74 from "
               "n = 2,500), not toward 0; ruled out"}
OUT["population.per_case_value_by_treatment"] = {
    "prediction": "if the population value were computed per case and was right for control cases but not for "
                  "treated ones, coverage averaged over cases would fall with n (wide intervals still cover some "
                  "treated cases) to a plateau near the control share, imbalance 'above' would approach the treated "
                  "share and 'below' a small fraction of the control share, and bias would be -lambda x treated "
                  "share x the path product with one lambda for all cutoffs",
    "finding": "coverage plateaus at the control share and imbalance above at the treated share at every cutoff, "
               "with below at .008-.017; the bias multipliers fit with lambda = "
               + ", ".join(f"{v}" for v in lam.values()) + " (cutoffs 1-3), close for cutoffs 1-2 but not "
               "constant, so the same rule does not reproduce cutoff 3 exactly"}

# ---------------------------------------------------------------- PNDE definition
pnde = fits[fits.effect.isin(["PNDE", "TNDE"])][["effect", "cut_index", "coef_c", "coef_h", "coef_ah"]]
OUT["pnde.definition"] = {
    "her_definition": "PNDE = c' + h (printed p. 104); the true value under her data-generating model is "
                      "c' + h * i0M with i0M = 0",
    "i0M_in_her_own_replay": {k: replay[k]["mean_i0M"] for k in replay},
    "bias_fit": pnde.to_dict(orient="records"),
    "finding": "with h-hat near 0, a population value of c' + h predicts a PNDE bias coefficient of -1 on h; "
               "the fits give about -0.93 (PNDE) and -1.0 (TNDE)"}

# ---------------------------------------------------------------- thresholds and prose
def mc_se(p, k):
    return math.sqrt(max(p * (1 - p), 1e-6) / (1000 * k))


rows = []
cell_rows = sc[~sc.cells.astype(str).str.startswith("all")]
for num in (2, 10, 11, 30, 41, 43, 44):
    srow = summary[summary.number == num].iloc[0]
    rows.append({"statement": num, "text": srow.statement, "ours": srow.verdict,
                 "ours_with_.01_slack": srow["verdict_with_.01_slack"], "ours_if_h_were_0": srow.verdict_if_h_were_0,
                 "chen_own_figures": srow.verdict_on_chen_figures})
OUT["statements.residuals"] = rows

# knife-edge distances for the h = 0 cells of statements 10 and 41
knife = []
for eff, kw, cut, nn, thr, k in [("TNIE", dict(a=0, b=.14, h=0), 3, 1000, .025, 4),
                                 ("TNDE", dict(a=.59, c=.39, h=0), 1, 500, .70, 4)]:
    sel = cells[(cells.effect == eff) & (cells.cut_index == cut) & (cells.n == nn)]
    for f, v in kw.items():
        sel = sel[np.isclose(sel[f], v)]
    ours = float(sel.reject.mean())
    fig = rates[(rates.effect == eff) & (rates.cut_index == cut) & (rates.n == nn) & (rates.status == "read")]
    for f, v in kw.items():
        fig = fig[np.isclose(fig[f].astype(float), v)]
    chen = float(fig.chen_value.mean()) if len(fig) else None
    knife.append({"effect": eff, "cells": kw, "cutoff": cut, "n": nn, "threshold": thr, "ours": round(ours, 4),
                  "ours_minus_threshold_in_mc_se": round((ours - thr) / mc_se(ours, len(sel)), 2),
                  "chen_figure": None if chen is None else round(chen, 4),
                  "ours_minus_chen_in_combined_se": None if chen is None else
                  round((ours - chen) / math.hypot(mc_se(ours, len(sel)), mc_se(chen, len(sel)), .003), 2)})
OUT["statements.knife_edge"] = knife

# TNDE1 power gap at c' = .39, a = .59, n = 500: is our estimator's spread the same as her code's?
sub = rep[np.isclose(rep.effcpr, .39) & np.isclose(rep.effa, .59) & (rep.nobs == 500) & np.isclose(rep.effh, 0)]
ours_sd = cells[(cells.effect == "TNDE") & (cells.cut_index == 1) & (cells.n == 500)
                & np.isclose(cells.c, .39) & np.isclose(cells.a, .59) & np.isclose(cells.h, 0)]["sd"]
her_sd = float(sub.TNDE1.std(ddof=1))
OUT["tnde.power_gap"] = {
    "cells": "TNDE, cutoff 1, n = 500, c' = .39, a = .59, h = 0 (averaged over b)",
    "her_code_sd_of_estimates": round(her_sd, 4), "her_code_datasets": int(len(sub)),
    "our_sd_of_estimates_mean_over_b": round(float(ours_sd.mean()), 4),
    "sd_ratio_ours_over_hers": round(float(ours_sd.mean()) / her_sd, 3),
    "sd_ratio_95pct_interval": [round(float(ours_sd.mean()) / her_sd * math.sqrt(len(sub) / v), 3)
                                for v in (np.percentile(np.random.default_rng(1).chisquare(len(sub) - 1, 20000), 97.5),
                                          np.percentile(np.random.default_rng(1).chisquare(len(sub) - 1, 20000), 2.5))],
    "power_ours": round(float(cells[(cells.effect == "TNDE") & (cells.cut_index == 1) & (cells.n == 500)
                                    & np.isclose(cells.c, .39) & np.isclose(cells.a, .59)
                                    & np.isclose(cells.h, 0)].reject.mean()), 4),
    "power_chen_figure": knife[1]["chen_figure"],
    "note": "her_code_* use the 50-replication replay (#92); the full_replay block uses all 1,000 (#118)",
    "full_replay": json.loads((ROOT / "results" / "r_full_comparison.json").read_text())["tnde_gap"]}

# statements 30 and 44 read loosely: "similar patterns" = power rises with n at every cutoff
def rises(vals, dip=.02):
    return all(b >= a - dip for a, b in zip(vals, vals[1:]))


loose = {}
for num, fig, eff, fac in ((30, "4.24", "TNIE", ("a", "b")), (44, "4.27", "TNDE", ("a", "c"))):
    pts = rates[(rates.figure == fig) & (rates.status != "missing")]
    ok_fig, ok_ours, n_sets = True, True, 0
    for key, g in pts.groupby(["cut_index"] + list(fac)):
        g = g.sort_values("n")
        n_sets += 1
        ok_fig &= rises(list(g.chen_value))
        ok_ours &= rises(list(g.our_value))
    spread_fig = float(pts[pts.n == 500].groupby(list(fac)).chen_value.agg(lambda v: v.max() - v.min()).max())
    spread_ours = float(pts[pts.n == 500].groupby(list(fac)).our_value_if_h_were_0.agg(lambda v: v.max() - v.min()).max())
    loose[num] = {"figure": fig, "cell_sets": n_sets, "rises_with_n_chen_figure": bool(ok_fig),
                  "rises_with_n_ours": bool(ok_ours),
                  "largest_cutoff_spread_at_n500_chen_figure": round(spread_fig, 3),
                  "largest_cutoff_spread_at_n500_ours_if_h_were_0": round(spread_ours, 3)}
OUT["statements.loose_reading"] = loose

# ---------------------------------------------------------------- n = 5,000
zz = cells[(cells.effect == "PNIE") & np.isclose(cells.a, 0) & np.isclose(cells.b, 0)].groupby("n").reject.mean()
fz = rates[(rates.figure == "4.17") & np.isclose(rates.a.astype(float), 0) & np.isclose(rates.b.astype(float), 0)
           & (rates.status == "read")].groupby("n").chen_value.mean()
OUT["n5000.both_paths_zero"] = {
    "ours_PNIE_type1_a_b_0_by_n": {int(k): round(float(v), 4) for k, v in zz.items()},
    "chen_figure_4_17_a_b_0_by_n": {int(k): round(float(v), 4) for k, v in fz.items()},
    "finding": "with both paths zero the product test is conservative at every n, in her own figure as in ours; "
               "no sample size brings these cells into Bradley's range"}

# ---------------------------------------------------------------- Head Start divisor
ta = list(csv.DictReader(open(ROOT / "secondary" / "table_arithmetic.csv")))
OUT["headstart.sb_divisor"] = {"rows": len(ta), "columns": list(ta[0].keys()) if ta else [],
                               "note": "see secondary/table_arithmetic.py: the differences match; the "
                                       "standardized biases match only with the RCT estimate's SE as divisor"}

(R / "disagreement_tests.json").write_text(json.dumps(OUT, indent=1, default=str) + "\n", encoding="utf-8")
print(json.dumps({k: OUT[k] for k in ("h.replay_of_her_seeded_code",)}, indent=1)[:1500])
for k in ("population.patterns", "statements.knife_edge", "tnde.power_gap", "n5000.both_paths_zero"):
    print(k, json.dumps(OUT[k], default=str)[:900])
