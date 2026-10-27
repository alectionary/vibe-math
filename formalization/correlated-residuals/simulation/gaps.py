#!/usr/bin/env python3
"""Seeded checks of the Mi et al. (2010) replication gaps.

Each hypothesis is one configuration. Detection rules that only change
the summary of a likelihood-ratio profile are applied to the same
replicates, so they are not a second Monte Carlo.
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np
from scipy.stats import binomtest, f as f_dist

import studies as st

OUT = Path(__file__).resolve().parent / "out"
GRID = st.GRID_CM

# Glyph reading of equation (7), PDF page 10. There is no operator between
# the equals sign and M. The minus at x=189 sits on M's middle row, so
# b23 = -1/2, while b12 = +1/2 and b13 = +1/4. Three entries of G carry
# their own minuses: G11, G22, and G32.
B_CORRECTED = np.array(
    [[0.0, 0.5, 0.25], [0.0, 0.0, -0.5], [0.0, 0.0, 0.0]], dtype=np.float64
)
G_SIGNED = np.array(
    [[-0.125, 0.25, 0.5], [0.5, -0.5, 0.5], [0.25, -0.125, 0.25]],
    dtype=np.float64,
)
B_NEG = -st.M_PAPER
B_POS = st.M_PAPER.copy()
G_POS = st.G_PAPER.copy()

PRINTED_SEM = np.array([64.0, 77.0, 96.0])
PRINTED_ST_Y1 = np.array([6.0, 3.0, 97.0])
PRINTED_POS_SD = np.array([2.83, 2.58, 2.16])
TABLE2_TOTAL = np.array(
    [[0.125, 0.0, 0.75], [0.375, -0.435, 0.375], [0.25, -0.125, 0.25]]
)


def cache_for(markers: np.ndarray):
    cache = {}
    marks = [float(m) for m in markers]
    lo, hi = min(marks), max(marks)
    for t in GRID:
        t = float(t)
        if t in marks or t <= lo or t >= hi:
            continue
        left = max(m for m in marks if m < t)
        right = min(m for m in marks if m > t)
        cache[(left, t, right)] = st.conditional_expectation(left, t, right)
    return cache


def flanks(t, markers):
    marks = [float(m) for m in markers]
    t = float(t)
    if t in marks:
        i = marks.index(t)
        bad = {t}
        if i > 0:
            bad.add(marks[i - 1])
        if i + 1 < len(marks):
            bad.add(marks[i + 1])
        return bad
    left = max(m for m in marks if m < t)
    right = min(m for m in marks if m > t)
    return {left, right}


def wheat_cofactors(y, geno, markers):
    """P < 0.1 single-marker screen, at most five markers. PDF page 11."""
    n = y.shape[0]
    scores = []
    for j, cm in enumerate(markers):
        x = geno[:, int(cm)].reshape(-1, 1)
        x = x - x.mean()
        pmin = 1.0
        for k in range(3):
            yc = y[:, k] - y[:, k].mean()
            rss_r = float(yc @ yc)
            rss_u, _ = st._rss(yc, x)
            if rss_u <= 1e-12 or n <= 3:
                pmin = 0.0
                break
            stat = ((rss_r - rss_u) / 1.0) / (rss_u / (n - 2))
            pmin = min(pmin, float(f_dist.sf(stat, 1, n - 2)))
        scores.append((pmin, float(cm)))
    chosen = [cm for p, cm in scores if p < 0.1]
    chosen.sort(key=lambda cm: next(p for p, c in scores if c == cm))
    return chosen[:5]


def regressor(t, geno, markers, cache, mode):
    t = float(t)
    marks = [float(m) for m in markers]
    if mode == "marker":
        nearest = min(marks, key=lambda m: (abs(m - t), m))
        return geno[:, int(nearest)]
    if t in marks:
        return geno[:, int(t)]
    left = max(m for m in marks if m < t)
    right = min(m for m in marks if m > t)
    table = cache[(left, t, right)]
    left_g = geno[:, int(left)]
    right_g = geno[:, int(right)]
    reg = np.empty(left_g.shape[0])
    for i in range(left_g.shape[0]):
        reg[i] = table[(float(left_g[i]), float(right_g[i]))]
    return reg


def cofactors_at(t, geno, markers, selected, mode):
    marks = [float(m) for m in markers]
    if mode == "none" or mode == "marker":
        cols = []
    elif mode == "wheat":
        bad = {m for m in selected if abs(m - float(t)) <= 10.0}
        cols = [int(m) for m in selected if m not in bad]
    else:
        bad = flanks(t, marks)
        cols = [int(m) for m in marks if m not in bad]
    if not cols:
        return np.zeros((geno.shape[0], 0))
    return geno[:, cols]


def one(rng, cache, b_mat, gamma, psi, markers, mode, standardize):
    geno = st.simulate_ril(rng, GRID, st.N_LINES)
    qtl = geno[:, [int(cm) for cm in st.QTL_CM]]
    y = st.phenotype(rng, qtl, b_mat, gamma, psi)
    if standardize:
        y = (y - y.mean(axis=0)) / y.std(axis=0, ddof=0)
    selected = wheat_cofactors(y, geno, markers) if mode == "wheat" else []
    lr_sem = np.zeros(GRID.size)
    lr_st = np.zeros((GRID.size, 3))
    for i, t in enumerate(GRID):
        # A test off the marker map has no flanking pair.
        if mode != "marker":
            marks = [float(m) for m in markers]
            if float(t) <= min(marks) or float(t) >= max(marks):
                if float(t) not in marks:
                    lr_sem[i] = np.nan
                    lr_st[i] = np.nan
                    continue
        reg = regressor(float(t), geno, markers, cache, mode)
        cof = cofactors_at(float(t), geno, markers, selected, mode)
        fit = st._scan_position(y, reg, cof, st.THRESH_MULTI)
        lr_sem[i] = fit["lr_sem"]
        lr_st[i] = fit["lr_st"]
    return lr_sem, lr_st


def window_masks():
    masks = {
        "wide": [],
        "pm10": [],
        "pm5": [],
        "interval": [],
        "at_truth": [],
    }
    intervals = [(20.0, 30.0), (40.0, 50.0), (70.0, 80.0)]
    for q, truth in enumerate(st.QTL_CM):
        lo, hi = st.WINDOWS[q]
        masks["wide"].append((GRID >= lo) & (GRID <= hi))
        masks["pm10"].append(np.abs(GRID - truth) <= 10.0)
        masks["pm5"].append(np.abs(GRID - truth) <= 5.0)
        a, b = intervals[q]
        masks["interval"].append((GRID >= a) & (GRID <= b))
        masks["at_truth"].append(np.isclose(GRID, truth))
    return masks


MASKS = window_masks()


def summarize(lr_sem, lr_st, sem_thr, st_thr, window):
    """lr_*: (reps, positions, ...). Return powers in percent and position SDs."""
    reps = lr_sem.shape[0]
    sem_hit = np.zeros(3)
    st_hit = np.zeros(3)
    pos = np.zeros((reps, 3))
    for q in range(3):
        mask = MASKS[window][q]
        idx = np.where(mask)[0]
        local = lr_sem[:, idx]
        # nanargmax-safe: replace nan with -inf
        local = np.where(np.isnan(local), -np.inf, local)
        j = np.argmax(local, axis=1)
        mx = local[np.arange(reps), j]
        sem_hit[q] = np.mean(mx > sem_thr)
        pos[:, q] = GRID[idx[j]]
        st_local = lr_st[:, idx, 0]
        st_local = np.where(np.isnan(st_local), -np.inf, st_local)
        st_hit[q] = np.mean(np.max(st_local, axis=1) > st_thr)
    # Position SD uses every replicate, matching a mean over 100 runs.
    pos_sd = pos.std(axis=0, ddof=1)
    detected = []
    for q in range(3):
        mask = MASKS[window][q]
        idx = np.where(mask)[0]
        local = np.where(np.isnan(lr_sem[:, idx]), -np.inf, lr_sem[:, idx])
        j = np.argmax(local, axis=1)
        mx = local[np.arange(reps), j]
        keep = pos[mx > sem_thr, q]
        detected.append(float(keep.std(ddof=1)) if keep.size > 2 else float("nan"))
    return {
        "sem_power": (100.0 * sem_hit).tolist(),
        "st_y1_power": (100.0 * st_hit).tolist(),
        "pos_sd": pos_sd.tolist(),
        "pos_sd_if_detected": detected,
        "n": int(reps),
    }


def closure(summary, algebraic_total):
    sem = np.array(summary["sem_power"])
    st = np.array(summary["st_y1_power"])
    sd = np.array(summary["pos_sd"])
    base_sem = np.array([59.0, 61.0, 86.0])
    base_st = np.array([6.0, 0.0, 13.0])
    base_sd = np.array([7.28, 5.25, 3.76])
    base_tot = 0.25

    def one(new, printed, base):
        gap0 = abs(base - printed)
        gap1 = abs(new - printed)
        if gap0 < 1e-9:
            return 1.0 if gap1 < 1e-9 else 0.0
        return float(1.0 - gap1 / gap0)

    return {
        "sem_power_l1": float(np.abs(sem - PRINTED_SEM).sum()),
        "st_y1_qtl3_abs": float(abs(st[2] - 97.0)),
        "st_y1_qtl2_abs": float(abs(st[1] - 3.0)),
        "pos_sd_l1": float(np.abs(sd - PRINTED_POS_SD).sum()),
        "total_qtl3_y1_abs": float(abs(algebraic_total - 0.75)),
        "sem_power_closed": [one(sem[i], PRINTED_SEM[i], base_sem[i]) for i in range(3)],
        "st_y1_qtl3_closed": one(st[2], 97.0, base_st[2]),
        "st_y1_qtl2_closed": one(st[1], 3.0, base_st[1]),
        "pos_sd_closed": [one(sd[i], PRINTED_POS_SD[i], base_sd[i]) for i in range(3)],
        "total_closed": one(algebraic_total, 0.75, base_tot),
    }


def binomial_rows(summary):
    rows = []
    n = summary["n"]
    for q in range(3):
        k = int(round(summary["sem_power"][q] / 100.0 * n))
        ci = binomtest(k, n).proportion_ci(confidence_level=0.95)
        rows.append(
            {
                "qtl": q + 1,
                "stat": "sem",
                "count": k,
                "ci95": [100.0 * ci.low, 100.0 * ci.high],
                "printed_inside": bool(ci.low * 100 <= PRINTED_SEM[q] <= ci.high * 100),
            }
        )
        k1 = int(round(summary["st_y1_power"][q] / 100.0 * n))
        ci1 = binomtest(k1, n).proportion_ci(confidence_level=0.95)
        rows.append(
            {
                "qtl": q + 1,
                "stat": "st_y1",
                "count": k1,
                "ci95": [100.0 * ci1.low, 100.0 * ci1.high],
                "printed_inside": bool(ci1.low * 100 <= PRINTED_ST_Y1[q] <= ci1.high * 100),
            }
        )
    return rows


def run_model(name, b_mat, gamma, psi, reps, seed, markers, mode, standardize=False):
    rng = np.random.default_rng(seed)
    cache = cache_for(markers)
    lr_sem = np.zeros((reps, GRID.size))
    lr_st = np.zeros((reps, GRID.size, 3))
    for r in range(reps):
        lr_sem[r], lr_st[r] = one(
            rng, cache, b_mat, gamma, psi, markers, mode, standardize
        )
        if (r + 1) % 50 == 0 or r + 1 == reps:
            print(f"{name} {r + 1}/{reps}", flush=True)
    direct, indirect, total = st.algebraic_effects(b_mat, gamma)
    return {
        "lr_sem": lr_sem,
        "lr_st": lr_st,
        "total": total,
        "direct": direct,
        "indirect": indirect,
    }


def pack(name, hypothesis, model, sem_thr, st_thr, window, note):
    summary = summarize(model["lr_sem"], model["lr_st"], sem_thr, st_thr, window)
    alg = float(model["total"][0, 2])
    return {
        "name": name,
        "hypothesis": hypothesis,
        "note": note,
        "window": window,
        "sem_threshold": sem_thr,
        "st_threshold": st_thr,
        "algebraic_total_qtl3_y1": alg,
        "algebraic_total": np.round(model["total"], 4).tolist(),
        "summary": summary,
        "closure": closure(summary, alg),
        "binomial": binomial_rows(summary),
    }


def main():
    markers = st.MARKER_CM
    shifted = np.arange(5.0, 96.0, 10.0)
    psi_I = np.eye(3)
    configs = []

    print("baseline 100", flush=True)
    base = run_model("baseline", B_NEG, G_POS, st.PSI_PAPER, 100, 20101027, markers, "flank")
    configs.append(pack(
        "H0 previous reading",
        "baseline",
        base,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "B=-M with every entry of M positive, G unsigned. Previous replication.",
    ))
    print("plus 100", flush=True)
    plus = run_model("plus", B_POS, G_POS, st.PSI_PAPER, 100, 20101031, markers, "flank")
    configs.append(pack(
        "H1 B=+M",
        "1",
        plus,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Every path positive. G unsigned.",
    ))
    print("corrected 100", flush=True)
    corr = run_model(
        "corrected", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 100, 20101032, markers, "flank"
    )
    configs.append(pack(
        "H1 glyph reading",
        "1",
        corr,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "b12=+1/2, b13=+1/4, b23=-1/2, and the three unary minuses on G.",
    ))
    print("no cofactor baseline", flush=True)
    bare = run_model("bare", B_NEG, G_POS, st.PSI_PAPER, 100, 20101033, markers, "none")
    configs.append(pack(
        "H2 no cofactors, previous reading",
        "2",
        bare,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Haley-Knott regressor, no cofactors.",
    ))
    print("no cofactor corrected", flush=True)
    bare_c = run_model(
        "bare-corrected", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 100, 20101034, markers, "none"
    )
    configs.append(pack(
        "H1+H2 glyph reading, no cofactors",
        "1+2",
        bare_c,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Glyph reading with interval mapping and no cofactors.",
    ))
    print("wheat cofactors corrected", flush=True)
    wheat = run_model(
        "wheat", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 100, 20101035, markers, "wheat"
    )
    configs.append(pack(
        "H1+H2 glyph reading, wheat cofactors",
        "1+2",
        wheat,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "P<0.1, at most five cofactors, 10 cM window. That rule is in the wheat section.",
    ))
    print("marker regression corrected", flush=True)
    mark = run_model(
        "marker", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 100, 20101036, markers, "marker"
    )
    configs.append(pack(
        "H2 nearest-marker regression",
        "2",
        mark,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Glyph reading. Regressor is the nearest marker, no cofactors.",
    ))
    print("psi I corrected", flush=True)
    psi = run_model(
        "psiI", B_CORRECTED, G_SIGNED, psi_I, 100, 20101037, markers, "flank"
    )
    configs.append(pack(
        "H4 Psi = I",
        "4",
        psi,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Glyph reading, residual covariance replaced by the identity.",
    ))
    print("standardized corrected", flush=True)
    std = run_model(
        "std", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 100, 20101038, markers, "flank", True
    )
    configs.append(pack(
        "H4 standardize traits",
        "4",
        std,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Glyph reading. Each trait is scaled to sample standard deviation 1 before the scan.",
    ))
    print("shifted markers", flush=True)
    shift = run_model(
        "shift", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 100, 20101039, shifted, "flank"
    )
    configs.append(pack(
        "H4 markers at 5,15,...,95",
        "4",
        shift,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Eleven markers, 10 cM apart, not placed on the ends. Our assumption.",
    ))

    # Detection rules on the two main Monte Carlo samples.
    for window in ("pm10", "pm5", "interval", "at_truth"):
        configs.append(pack(
            f"H3 window {window}, previous reading",
            "3",
            base,
            st.THRESH_MULTI,
            st.THRESH_SINGLE,
            window,
            "Same replicates as the previous reading. Only the detection window changes.",
        ))
        configs.append(pack(
            f"H1+H3 window {window}, glyph reading",
            "1+3",
            corr,
            st.THRESH_MULTI,
            st.THRESH_SINGLE,
            window,
            "Glyph reading, same replicates, narrower window.",
        ))
    # alpha = 0.05, df = 4 and 2, without the Bonferroni factor.
    from scipy.stats import chi2

    loose_m = float(chi2.ppf(0.95, 4))
    loose_s = float(chi2.ppf(0.95, 2))
    configs.append(pack(
        "H3 alpha=0.05 thresholds, previous reading",
        "3",
        base,
        loose_m,
        loose_s,
        "wide",
        f"Thresholds {loose_m:.2f} and {loose_s:.2f}. The simulation prints 14.86 and 10.60.",
    ))
    configs.append(pack(
        "H1+H3 alpha=0.05, glyph reading",
        "1+3",
        corr,
        loose_m,
        loose_s,
        "wide",
        f"Glyph reading with thresholds {loose_m:.2f} and {loose_s:.2f}.",
    ))
    df3 = float(chi2.ppf(0.995, 3))
    df1 = float(chi2.ppf(0.995, 1))
    configs.append(pack(
        "H3 df = number of traits",
        "3",
        corr,
        df3,
        df1,
        "wide",
        f"Glyph reading. Thresholds {df3:.2f} (df 3) and {df1:.2f} (df 1) at tail 0.005.",
    ))

    print("baseline 1000", flush=True)
    base_k = run_model(
        "baseline-1000", B_NEG, G_POS, st.PSI_PAPER, 1000, 20101040, markers, "flank"
    )
    configs.append(pack(
        "H5 1000 replicates, previous reading",
        "5",
        base_k,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Same population as the previous replication, 1000 replicates.",
    ))
    print("corrected 1000", flush=True)
    corr_k = run_model(
        "corrected-1000", B_CORRECTED, G_SIGNED, st.PSI_PAPER, 1000, 20101041, markers, "flank"
    )
    configs.append(pack(
        "H5 1000 replicates, glyph reading",
        "1+5",
        corr_k,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "wide",
        "Glyph reading, 1000 replicates, printed thresholds, wide windows.",
    ))
    configs.append(pack(
        "H1+H3+H5 glyph, pm10, 1000",
        "1+3+5",
        corr_k,
        st.THRESH_MULTI,
        st.THRESH_SINGLE,
        "pm10",
        "Glyph reading, 1000 replicates, detection within 10 cM of the true site.",
    ))

    # One null scan for a permutation-scale threshold. Phenotypes are shuffled
    # against the marker map, 100 times, on the glyph-reading design.
    print("permutation null", flush=True)
    rng = np.random.default_rng(20101042)
    cache = cache_for(markers)
    geno = st.simulate_ril(rng, GRID, st.N_LINES)
    qtl = geno[:, [int(cm) for cm in st.QTL_CM]]
    y = st.phenotype(rng, qtl, B_CORRECTED, G_SIGNED, st.PSI_PAPER)
    maxes = []
    for p in range(100):
        yp = y[rng.permutation(st.N_LINES)]
        lr = np.zeros(GRID.size)
        for i, t in enumerate(GRID):
            reg = regressor(float(t), geno, markers, cache, "flank")
            cof = cofactors_at(float(t), geno, markers, [], "flank")
            fit = st._scan_position(yp, reg, cof, st.THRESH_MULTI)
            lr[i] = fit["lr_sem"]
        maxes.append(float(np.nanmax(lr)))
        if (p + 1) % 25 == 0:
            print(f"perm {p + 1}/100", flush=True)
    maxes = np.array(maxes)
    perm = {
        "n_permutations": 100,
        "quantile_95": float(np.quantile(maxes, 0.95)),
        "quantile_995": float(np.quantile(maxes, 0.995)),
        "mean_max": float(maxes.mean()),
        "note": (
            "One corrected-population replicate, phenotypes shuffled 100 times. "
            "The simulation section prints a fixed chi-square threshold, not a permutation threshold. "
            "Five hundred permutations are described for the wheat scan."
        ),
    }
    configs.append(pack(
        "H3 permutation 95% threshold, glyph, 1000",
        "3",
        corr_k,
        float(np.quantile(maxes, 0.95)),
        float(np.quantile(maxes, 0.95)),
        "wide",
        "Genome-wide 95% threshold from 100 phenotype shuffles, applied to the 1000 glyph-reading replicates. Same number for the single-trait rows, which overstates that threshold.",
    ))

    payload = {
        "printed": {
            "sem_power": PRINTED_SEM.tolist(),
            "st_y1_power": PRINTED_ST_Y1.tolist(),
            "sem_position_sd": PRINTED_POS_SD.tolist(),
            "table2_total": TABLE2_TOTAL.tolist(),
            "table2_rounding": (
                "QTL2 on Y2: exact path product under the glyph reading is "
                "total -7/16 = -0.4375 and indirect 1/16 = 0.0625. "
                "Table 2 prints -0.435 and 0.065."
            ),
        },
        "permutation": perm,
        "rows": configs,
    }
    OUT.mkdir(exist_ok=True)
    # Drop the large arrays before writing.
    text = json.dumps(payload, indent=2)
    (OUT / "gaps.json").write_text(text)
    print("wrote", OUT / "gaps.json")
    for row in configs:
        s = row["summary"]
        c = row["closure"]
        print(
            f"{row['name']}: SEM {np.round(s['sem_power'],1)} "
            f"ST {np.round(s['st_y1_power'],1)} SD {np.round(s['pos_sd'],2)} "
            f"tot {row['algebraic_total_qtl3_y1']:.3f} "
            f"closed3 {c['st_y1_qtl3_closed']:.2f} totalc {c['total_closed']:.2f}"
        )


if __name__ == "__main__":
    main()
