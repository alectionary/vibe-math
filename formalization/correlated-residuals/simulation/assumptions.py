#!/usr/bin/env python3
"""Family A: one change at a time from the glyph-reading scan, n=1000.

The baseline is the glyph reading of equation (7), 150 RILs, markers at
0,10,...,100, QTLs at 22, 42 and 78 cM, flanking conditional expectation,
cofactors equal to every marker except the flanking pair, and the printed
thresholds 14.86 and 10.60. Each other configuration changes one choice.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np
from scipy.stats import chi2, ncx2

import gaps
import studies as st

OUT = Path(__file__).resolve().parent / "out" / "assumptions"
GRID = st.GRID_CM.astype(float)
B = gaps.B_CORRECTED
G = gaps.G_SIGNED
PSI = {
    "paper": st.PSI_PAPER.copy(),
    "identity": np.eye(3),
    "entries_as_sd": np.diag(np.array([1.6, 1.8, 2.5]) ** 2),
    "sqrt_entries": np.diag(np.sqrt([1.6, 1.8, 2.5])),
}

# What the SAGMB simulation paragraph actually fixes. A change to a pinned
# choice is not a defensible reading of that paragraph.
PINNED = {
    "n_lines": "150 lines, PDF page 10",
    "qtl": "22, 42 and 78 cM, PDF page 10",
    "markers_ends": "11 evenly spaced markers on 100 cM; ends give a 10 cM step",
    "step": "a test at each 1 cM, PDF page 10",
    "cof_flank": "all except flanking markers, PDF page 10",
    "psi_paper": "residuals drawn from covariance (8)",
    "coding_pm1": "QTL codes +1 and -1, under equation (7)",
    "population_ril": "RIL population, PDF page 10",
    "threshold": "14.86 and 10.60, PDF page 10",
}


def rec_fraction(gaps_morgans, mapfun):
    gaps_morgans = np.asarray(gaps_morgans, dtype=float)
    if mapfun == "haldane":
        return 0.5 * (1.0 - np.exp(-2.0 * gaps_morgans))
    if mapfun == "kosambi":
        return 0.5 * np.tanh(2.0 * gaps_morgans)
    raise ValueError(mapfun)


def ril_expansion(r):
    return 2.0 * r / (1.0 + 2.0 * r)


def _markov(rng, n, n_loc, switch_p, n_hap=1):
    """n_hap independent haplotypes. Alleles in {0,1}."""
    h = np.zeros((n_hap, n, n_loc), dtype=np.int8)
    h[:, :, 0] = rng.integers(0, 2, size=(n_hap, n))
    if n_loc == 1:
        return h
    switch = rng.random((n_hap, n, n_loc - 1)) < switch_p
    for k in range(n_loc - 1):
        h[:, :, k + 1] = h[:, :, k] ^ switch[:, :, k]
    return h


def simulate_geno(rng, kind, mapfun, n_lines):
    pos = GRID / 100.0
    gaps = np.diff(pos)
    r = rec_fraction(gaps, mapfun)
    if kind == "ril12":
        # Finite selfing. Kosambi is not in studies.simulate_ril, so both
        # map functions go through the same 12-generation loop.
        rec = r
        hap = np.zeros((n_lines, 2, pos.size), dtype=np.int8)
        hap[:, 1, :] = 1
        for _ in range(st.SELFING_GENERATIONS):
            hap = np.stack(
                [_one_gamete(rng, hap, rec), _one_gamete(rng, hap, rec)], axis=1
            )
        dosage = hap.sum(axis=1)
        code = np.ones(dosage.shape)
        code[dosage == 2] = -1.0
        het = dosage == 1
        n_het = int(het.sum())
        if n_het:
            code[het] = rng.choice(np.array([-1.0, 1.0]), size=n_het)
        return code
    if kind == "rilinf":
        h = _markov(rng, n_lines, pos.size, ril_expansion(r), n_hap=1)[0]
        return np.where(h == 0, 1.0, -1.0)
    if kind == "f2":
        h = _markov(rng, n_lines, pos.size, r, n_hap=2)
        dosage_a = (h == 0).sum(axis=0)  # 0,1,2
        return dosage_a.astype(float) - 1.0  # +1, 0, -1
    if kind == "bc":
        h = _markov(rng, n_lines, pos.size, r, n_hap=1)[0]
        # Recurrent parent is allele 0. Homozygote +1, heterozygote -1,
        # so the two-genotype contrast stays 2, as in the RIL ±1 code.
        return np.where(h == 0, 1.0, -1.0)
    raise ValueError(kind)


def _one_gamete(rng, hap, rec):
    n, _, n_loc = hap.shape
    homolog = np.empty((n, n_loc), dtype=np.int8)
    homolog[:, 0] = rng.integers(0, 2, size=n)
    if n_loc > 1:
        switch = rng.random((n, n_loc - 1)) < rec
        for k in range(n_loc - 1):
            homolog[:, k + 1] = homolog[:, k] ^ switch[:, k]
    rows = np.arange(n)[:, None]
    cols = np.arange(n_loc)[None, :]
    return hap[rows, homolog, cols]


def expect_table(kind, mapfun, left, mid, right, formula):
    """Map (left code, right code) -> E[mid code]. Codes are -1,0,1."""
    if formula == "nodouble" and kind in ("ril12", "rilinf"):
        d1 = (mid - left) / 100.0
        d2 = (right - mid) / 100.0
        r1 = float(rec_fraction([d1], mapfun)[0])
        r2 = float(rec_fraction([d2], mapfun)[0])
        ra, rb = ril_expansion(r1), ril_expansion(r2)
        denom = ra + rb
        # ±1 coding. Concordant markers fix the QTL. Discordant markers
        # use (R_far - R_near) / (R_near + R_far), the 2008 conference table.
        gap = 0.0 if denom == 0 else (rb - ra) / denom
        return {
            (1.0, 1.0): 1.0,
            (-1.0, -1.0): -1.0,
            (1.0, -1.0): gap,
            (-1.0, 1.0): -gap,
        }
    if formula == "f2hk" or kind == "f2":
        return _enumerate_expectation("f2", mapfun, left, mid, right)
    if kind == "bc":
        return _enumerate_expectation("bc", mapfun, left, mid, right)
    if kind == "rilinf" or formula == "rilinf":
        return _enumerate_expectation("rilinf", mapfun, left, mid, right)
    # 12-generation Haldane law already coded in studies. Kosambi finite
    # selfing uses the same function with a Kosambi three-locus substitute.
    if mapfun == "haldane" and kind == "ril12" and formula == "exact":
        raw = st.conditional_expectation(left, mid, right)
        return raw
    return _enumerate_expectation(kind, mapfun, left, mid, right)


def _hap_probs(kind, mapfun, left, mid, right):
    d1 = (mid - left) / 100.0
    d2 = (right - mid) / 100.0
    r1 = float(rec_fraction([d1], mapfun)[0])
    r2 = float(rec_fraction([d2], mapfun)[0])
    if kind == "rilinf":
        p1, p2 = ril_expansion(r1), ril_expansion(r2)
    else:
        p1, p2 = r1, r2
    probs = {}
    for start in (0, 1):
        for s1 in (0, 1):
            for s2 in (0, 1):
                p = 0.5 * (p1 if s1 else 1.0 - p1) * (p2 if s2 else 1.0 - p2)
                a = start
                b = start ^ s1
                c = b ^ s2
                probs[(a, b, c)] = probs.get((a, b, c), 0.0) + p
    return probs


def _enumerate_expectation(kind, mapfun, left, mid, right):
    probs = _hap_probs(kind if kind != "ril12" else "rilinf", mapfun, left, mid, right)
    # Two independent haplotypes. rilinf is already homozygous: one haplotype.
    table = {}
    if kind == "rilinf" or kind == "ril12":
        for a in (0, 1):
            for c in (0, 1):
                num = den = 0.0
                for (ha, hb, hc), p in probs.items():
                    if ha == a and hc == c:
                        code = 1.0 if hb == 0 else -1.0
                        num += code * p
                        den += p
                table[(1.0 if a == 0 else -1.0, 1.0 if c == 0 else -1.0)] = (
                    num / den if den else 0.0
                )
        return table
    # F2 or BC: second haplotype.
    table_mass = {}
    keys = list(probs)
    for h1 in keys:
        for h2 in keys:
            if kind == "bc" and h2 != (0, 0, 0):
                continue
            p = probs[h1] * (1.0 if kind == "bc" else probs[h2])
            if kind == "bc":
                p = probs[h1]
            codes = []
            for k in range(3):
                dosage_a = (h1[k] == 0) + (h2[k] == 0 if kind != "bc" else 1)
                # BC second haplotype is allele 0, so dosage_a = (h1==0) + 1,
                # and the ±1 contrast used in simulate_geno is +1 if h1==0 else -1.
                if kind == "bc":
                    codes.append(1.0 if h1[k] == 0 else -1.0)
                else:
                    codes.append(float(dosage_a - 1))
            key = (codes[0], codes[2])
            mid = codes[1]
            acc = table_mass.setdefault(key, [0.0, 0.0])
            acc[0] += mid * p
            acc[1] += p
    return {k: v[0] / v[1] for k, v in table_mass.items() if v[1] > 0}


def marker_set(name):
    if name == "ends":
        return [float(m) for m in st.MARKER_CM]
    if name == "shifted":
        return [float(m) for m in np.arange(5.0, 96.0, 10.0)]
    if name == "interior":
        # Eleven markers, equal gaps, neither end is a marker, snapped to the 1 cM grid.
        raw = np.linspace(100.0 / 12.0, 100.0 * 11.0 / 12.0, 11)
        return [float(int(np.round(x))) for x in raw]
    raise ValueError(name)


def build_cache(spec):
    marks = marker_set(spec["markers"])
    cache = {}
    for t in GRID:
        if t <= min(marks) or t >= max(marks) or t in marks:
            continue
        left = max(m for m in marks if m < t)
        right = min(m for m in marks if m > t)
        cache[(left, t, right)] = expect_table(
            spec["pop"], spec["map"], left, t, right, spec["expect"]
        )
    return cache, marks


def lookup(table, left_g, right_g):
    # Codes are -1, 0, 1. Build an index.
    out = np.zeros(left_g.shape[0])
    for key, val in table.items():
        mask = (left_g == key[0]) & (right_g == key[1])
        out[mask] = val
    return out


def cofactor_columns(t, marks, mode):
    t = float(t)
    if mode == "none":
        return []
    if mode == "all":
        return [int(round(m)) for m in marks if abs(m - t) > 1e-8]
    if mode == "cm20":
        return [int(round(m)) for m in marks if abs(m - t) > 20.0]
    # flanking exclusion, the simulation sentence
    if t in marks:
        i = marks.index(t)
        bad = {t}
        if i > 0:
            bad.add(marks[i - 1])
        if i + 1 < len(marks):
            bad.add(marks[i + 1])
    else:
        left = max(m for m in marks if m < t)
        right = min(m for m in marks if m > t)
        bad = {left, right}
    return [int(round(m)) for m in marks if m not in bad]


def run_spec(spec, reps, save_profiles):
    rng = np.random.default_rng(spec["seed"])
    cache, marks = build_cache(spec)
    n = spec["n"]
    step = spec["step"]
    grid = GRID[::step]
    qtl = np.array(spec["qtl"], dtype=float)
    psi = PSI[spec["psi"]]
    n_pos = grid.size
    lr_sem = np.zeros((reps, n_pos))
    lr_ls = np.zeros((reps, n_pos))
    lr_st = np.zeros((reps, n_pos, 3))
    lr_eq = np.zeros((reps, n_pos, 3))
    for r in range(reps):
        geno = simulate_geno(rng, spec["pop"], spec["map"], n)
        x = geno[:, [int(round(q)) for q in qtl]]
        if spec["coding"] == "half":
            x = (1.0 - x) / 2.0
        y = st.phenotype(rng, x, B, G, psi)
        if spec["standardize"]:
            sd = y.std(axis=0, ddof=0)
            sd[sd == 0] = 1.0
            y = (y - y.mean(axis=0)) / sd
        for i, t in enumerate(grid):
            t = float(t)
            if spec["expect"] == "oracle":
                reg = geno[:, int(round(t))]
            elif t in marks or t <= min(marks) or t >= max(marks):
                if t in marks:
                    reg = geno[:, int(round(t))]
                else:
                    lr_sem[r, i] = np.nan
                    lr_ls[r, i] = np.nan
                    lr_st[r, i] = np.nan
                    lr_eq[r, i] = np.nan
                    continue
            else:
                left = max(m for m in marks if m < t)
                right = min(m for m in marks if m > t)
                reg = lookup(
                    cache[(left, t, right)],
                    geno[:, int(round(left))],
                    geno[:, int(round(right))],
                )
            cols = cofactor_columns(t, marks, spec["cof"])
            cof = geno[:, cols] if cols else np.zeros((n, 0))
            fit = st._scan_position(y, reg, cof, st.THRESH_MULTI)
            lr_sem[r, i] = fit["lr_sem"]
            lr_ls[r, i] = fit["lr_ls"]
            lr_st[r, i] = fit["lr_st"]
            lr_eq[r, i] = fit["lr_eq"]
        if (r + 1) % 100 == 0 or r + 1 == reps:
            print(f"{spec['name']} {r + 1}/{reps}", flush=True)
    summary = summarize(grid, qtl, lr_sem, lr_ls, lr_st, lr_eq)
    payload = {"spec": spec, "summary": summary, "n_reps": reps}
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / f"{spec['name']}.json").write_text(json.dumps(payload, indent=2))
    if save_profiles:
        np.savez_compressed(
            OUT / f"{spec['name']}_profiles.npz",
            grid=grid,
            qtl=qtl,
            lr_sem=lr_sem,
            lr_ls=lr_ls,
            lr_st=lr_st,
            lr_eq=lr_eq,
        )
    return payload


def _window_hit(lr, grid, qtl, half_width, threshold):
    """lr: (reps, positions) or (reps, positions, traits)."""
    reps = lr.shape[0]
    hits = np.zeros(3)
    pos = np.full((reps, 3), np.nan)
    for q, truth in enumerate(qtl):
        if half_width is None:
            mask = np.ones(grid.shape, dtype=bool)
            # midpoint windows of the original three-QTL design
            lo, hi = st.WINDOWS[q]
            mask = (grid >= lo) & (grid <= hi)
        else:
            mask = np.abs(grid - truth) <= half_width
        idx = np.where(mask)[0]
        if idx.size == 0:
            continue
        local = lr[:, idx] if lr.ndim == 2 else lr[:, idx, :]
        local = np.where(np.isnan(local), -np.inf, local)
        if local.ndim == 2:
            j = np.argmax(local, axis=1)
            mx = local[np.arange(reps), j]
            hits[q] = np.mean(mx > threshold)
            pos[:, q] = grid[idx[j]]
        else:
            # any trait: max over position and trait
            flat = local.reshape(reps, -1)
            j = np.argmax(flat, axis=1)
            mx = flat[np.arange(reps), j]
            hits[q] = np.mean(mx > threshold)
    return hits, pos


def summarize(grid, qtl, lr_sem, lr_ls, lr_st, lr_eq):
    out = {}
    rules = {
        "wide": (None, st.THRESH_MULTI, st.THRESH_SINGLE),
        "pm10": (10.0, st.THRESH_MULTI, st.THRESH_SINGLE),
        "pm5": (5.0, st.THRESH_MULTI, st.THRESH_SINGLE),
    }
    for name, (half, thr_m, thr_s) in rules.items():
        sem, pos = _window_hit(lr_sem, grid, qtl, half, thr_m)
        ls, _ = _window_hit(lr_ls, grid, qtl, half, thr_m)
        st1, _ = _window_hit(lr_st[:, :, 0], grid, qtl, half, thr_s)
        st_all = []
        for trait in range(3):
            h, _ = _window_hit(lr_st[:, :, trait], grid, qtl, half, thr_s)
            st_all.append(h)
        any_eq_1060, _ = _window_hit(lr_eq, grid, qtl, half, thr_s)
        any_eq_1486, _ = _window_hit(lr_eq, grid, qtl, half, thr_m)
        any_eq_df1, _ = _window_hit(lr_eq, grid, qtl, half, float(chi2.ppf(0.995, 1)))
        pos_sd = []
        pos_sd_det = []
        for q in range(3):
            col = pos[:, q]
            pos_sd.append(float(np.nanstd(col, ddof=1)))
            keep = col[np.isfinite(col)]
            # detection mask
            if half is None:
                lo, hi = st.WINDOWS[q]
                mask = (grid >= lo) & (grid <= hi)
            else:
                mask = np.abs(grid - qtl[q]) <= half
            idx = np.where(mask)[0]
            local = np.where(np.isnan(lr_sem[:, idx]), -np.inf, lr_sem[:, idx])
            j = np.argmax(local, axis=1)
            mx = local[np.arange(lr_sem.shape[0]), j]
            kept = col[mx > st.THRESH_MULTI]
            pos_sd_det.append(float(kept.std(ddof=1)) if kept.size > 2 else float("nan"))
        out[name] = {
            "sem": (100 * sem).tolist(),
            "ls": (100 * ls).tolist(),
            "st": (100 * np.vstack(st_all)).tolist(),
            "any_equation_10.60": (100 * any_eq_1060).tolist(),
            "any_equation_14.86": (100 * any_eq_1486).tolist(),
            "any_equation_df1_0.005": (100 * any_eq_df1).tolist(),
            "pos_sd": pos_sd,
            "pos_sd_if_detected": pos_sd_det,
        }
    # Top-three local peaks, each assigned to the nearest QTL if within 15 cM.
    reps = lr_sem.shape[0]
    assigned = np.full((reps, 3), -np.inf)
    for r in range(reps):
        curve = lr_sem[r]
        peaks = []
        for i in range(1, curve.size - 1):
            if np.isfinite(curve[i]) and curve[i] >= curve[i - 1] and curve[i] >= curve[i + 1]:
                peaks.append(i)
        peaks.sort(key=lambda i: -curve[i])
        used = set()
        for i in peaks:
            if len(used) == 3:
                break
            nearest = int(np.argmin(np.abs(qtl - grid[i])))
            if nearest in used:
                continue
            if abs(qtl[nearest] - grid[i]) <= 15.0:
                assigned[r, nearest] = curve[i]
                used.add(nearest)
    out["top3_within_15"] = {
        "sem": (100 * np.mean(assigned > st.THRESH_MULTI, axis=0)).tolist()
    }
    return out


def analytic(n_lines, n_draw=40000, seed=20101150):
    """Noncentral chi-square power at the true genotype, no cofactors.

    This is an approximation: the LR is compared with a chi-square tail,
    and the noncentrality is n times the population squared partial
    coefficient over the residual variance. It is not the power of the
    maximum over a grid.
    """
    rng = np.random.default_rng(seed)
    geno = simulate_geno(rng, "ril12", "haldane", n_draw)
    x = geno[:, [22, 42, 78]]
    # Noise-free signal plus a fresh residual, then the regressions.
    y = st.phenotype(rng, x, B, G, PSI["paper"])
    rows = []
    for q in range(3):
        xq = x[:, q]
        xq = xq - xq.mean()
        # single trait total-effect noncentrality
        st_pow = []
        for trait in range(3):
            yc = y[:, trait] - y[:, trait].mean()
            beta = float(xq @ yc) / float(xq @ xq)
            resid = yc - beta * xq
            sig2 = float(resid @ resid) / n_draw
            lam = n_lines * beta**2 * float(xq @ xq) / n_draw / sig2
            # The regression of the finite draw estimates lambda; rescale
            # as if the residual variance is the population one.
            st_pow.append(float(ncx2.sf(st.THRESH_SINGLE, 1, lam)))
        # joint direct-effect noncentrality, conditioning on parents
        lams = []
        # trait 3
        yc = y[:, 2] - y[:, 2].mean()
        beta = float(xq @ yc) / float(xq @ xq)
        sig2 = float((yc - beta * xq) @ (yc - beta * xq)) / n_draw
        lams.append(n_lines * beta**2 * float(xq @ xq) / n_draw / sig2)
        # trait 2 | trait 3
        parent = y[:, 2] - y[:, 2].mean()
        design = np.column_stack([parent, xq])
        b, _, _, _ = np.linalg.lstsq(design, y[:, 1] - y[:, 1].mean(), rcond=None)
        resid = y[:, 1] - y[:, 1].mean() - design @ b
        # partial SS of xq
        x_res = xq - parent * (float(parent @ xq) / float(parent @ parent))
        lam = n_lines * b[1] ** 2 * float(x_res @ x_res) / n_draw / (float(resid @ resid) / n_draw)
        lams.append(lam)
        parents = np.column_stack([y[:, 1] - y[:, 1].mean(), y[:, 2] - y[:, 2].mean()])
        design = np.column_stack([parents, xq])
        b, _, _, _ = np.linalg.lstsq(design, y[:, 0] - y[:, 0].mean(), rcond=None)
        resid = y[:, 0] - y[:, 0].mean() - design @ b
        coef, _, _, _ = np.linalg.lstsq(parents, xq, rcond=None)
        x_res = xq - parents @ coef
        lam = n_lines * b[2] ** 2 * float(x_res @ x_res) / n_draw / (float(resid @ resid) / n_draw)
        lams.append(lam)
        joint = float(ncx2.sf(st.THRESH_MULTI, 4, sum(lams)))
        rows.append(
            {
                "qtl": q + 1,
                "n": n_lines,
                "lambda_direct_y3_y2_y1": lams,
                "power_joint_df4": joint,
                "power_single_df1": st_pow,
            }
        )
    return rows


SPECS = []


def add(name, **kw):
    base = dict(
        name=name,
        pop="ril12",
        map="haldane",
        coding="pm1",
        markers="ends",
        qtl=[22.0, 42.0, 78.0],
        expect="exact",
        cof="flank",
        step=1,
        n=150,
        psi="paper",
        standardize=False,
        seed=20101101,
        note="",
        defensible=False,
    )
    base.update(kw)
    SPECS.append(base)


add("baseline", note="Glyph reading, every choice at its printed or previously used value.", defensible=True, seed=20101101)
add("seed_b", note="Same design, second seed.", defensible=True, seed=20101102)
add("coding_half", coding="half", note="Printed G applied to a 0/1 code, so the homozygote contrast is half the ±1 contrast. The simulation sentence says +1 and -1.", defensible=False, seed=20101103)
add("f2", pop="f2", note="F2 instead of RIL. The simulation sentence says RIL.", defensible=False, seed=20101104)
add("backcross", pop="bc", note="Backcross instead of RIL. The simulation sentence says RIL.", defensible=False, seed=20101105)
add("ril_infinite", pop="rilinf", expect="rilinf", note="Infinite-RIL map expansion 2r/(1+2r). The 2008 conference note prints this formula. SAGMB does not name the generation count.", defensible=True, seed=20101106)
add("kosambi", pop="rilinf", map="kosambi", expect="rilinf", note="Infinite RIL under the Kosambi map. SAGMB does not name a map function. The 2008 note names Haldane.", defensible=True, seed=20101107)
add("markers_shifted", markers="shifted", note="Eleven markers at 5,15,...,95. Equal spacing, ends omitted.", defensible=True, seed=20101108)
add("markers_interior", markers="interior", note="Eleven markers with equal gaps and neither end included, rounded to the scan grid.", defensible=True, seed=20101109)
add("qtl_on_markers", qtl=[20.0, 40.0, 80.0], note="QTLs moved onto markers. The simulation sentence says 22, 42 and 78.", defensible=False, seed=20101110)
add("expect_nodouble", expect="nodouble", note="No-double-crossover flanking expectation from the 2008 conference table. SAGMB cites Haley and Knott (1992) and Xu (1998).", defensible=True, seed=20101111)
add("expect_f2_on_ril", expect="f2hk", note="F2 conditional expectation used on RIL data.", defensible=True, seed=20101112)
add("oracle", expect="oracle", note="The scan uses the realized genotype at the tested cM. The paper says the QTL is replaced by its flanking expectation.", defensible=False, seed=20101113)
add("cof_none", cof="none", note="No cofactors. The simulation sentence fits every marker except the flanking pair.", defensible=False, seed=20101114)
add("cof_20", cof="cm20", note="Cofactors are markers more than 20 cM from the test point.", defensible=True, seed=20101115)
add("cof_all", cof="all", note="Every other marker is a cofactor, including the flanking markers.", defensible=False, seed=20101116)
add("psi_identity", psi="identity", note="Residual covariance replaced by I. The sentence says residuals are drawn from matrix (8).", defensible=False, seed=20101117)
add("psi_as_sd", psi="entries_as_sd", note="1.6, 1.8 and 2.5 used as standard deviations, so the variances are their squares.", defensible=False, seed=20101118)
add("psi_sqrt", psi="sqrt_entries", note="1.6, 1.8 and 2.5 used as variances of a generator that was handed their square roots by mistake: residual variances 1.6, 1.8, 2.5 become SDs and the variances are the square roots.", defensible=False, seed=20101119)
add("standardize", standardize=True, note="Each trait scaled to sample SD 1 before the scan.", defensible=True, seed=20101120)
add("step2", step=2, note="Scan every 2 cM. The sentence says every 1 cM.", defensible=False, seed=20101121)
add("step5", step=5, note="Scan every 5 cM. The sentence says every 1 cM.", defensible=False, seed=20101122)
add("n250", n=250, note="250 lines, the sample size of Mi et al. (2010) Genetics Research. SAGMB says 150.", defensible=False, seed=20101123)
add("n300", n=300, note="300 lines, the sample size of the 2008 conference note. SAGMB says 150.", defensible=False, seed=20101124)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--configs", default="baseline")
    parser.add_argument("--reps", type=int, default=1000)
    parser.add_argument("--analytic", action="store_true")
    args = parser.parse_args()
    if args.analytic:
        rows = []
        for n in (150, 250, 300):
            rows.extend(analytic(n))
            print("analytic", n, rows[-3:], flush=True)
        OUT.mkdir(parents=True, exist_ok=True)
        (OUT / "analytic.json").write_text(json.dumps(rows, indent=2))
        return
    wanted = set(args.configs.split(","))
    for spec in SPECS:
        if spec["name"] not in wanted:
            continue
        run_spec(spec, args.reps, save_profiles=spec["name"] == "baseline")


if __name__ == "__main__":
    main()
