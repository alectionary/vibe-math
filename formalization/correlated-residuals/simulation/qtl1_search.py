#!/usr/bin/env python3
"""Search for a joint reading of Table 1's SEM powers 64, 77, 96.

Family A changes the data or the coefficient matrices. Family B changes
the scan or the counting rule. Family C compares the resulting triples
with transpositions, sample-size noise, and nearby printed numbers.
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np

import assumptions as A
import studies as st

OUT = Path(__file__).resolve().parent / "out" / "qtl1"
GRID = A.GRID
B0 = A.B.copy()
G0 = A.G.copy()
PSI0 = A.PSI["paper"].copy()
PRINTED = np.array(
    [
        [64.0, 57.0, 6.0, 29.0, 10.0, 40.0],
        [77.0, 69.0, 3.0, 43.0, 1.0, 45.0],
        [96.0, 94.0, 97.0, 33.0, 17.0, 97.0],
    ]
)


def marks_of(spec):
    if spec.get("marker_list"):
        return [float(m) for m in spec["marker_list"]]
    return A.marker_set(spec["markers"])


def build_cache(spec, marks):
    cache = {}
    for t in GRID:
        t = float(t)
        if t <= min(marks) or t >= max(marks) or t in marks:
            continue
        left = max(m for m in marks if m < t)
        right = min(m for m in marks if m > t)
        cache[(left, t, right)] = A.expect_table(
            spec["pop"], spec["map"], left, t, right, spec["expect"]
        )
    return cache


def windows_for(qtl):
    qtl = list(qtl)
    mids = [(qtl[i] + qtl[i + 1]) / 2.0 for i in range(len(qtl) - 1)]
    edges = [0.0, *mids, 100.0]
    return [(edges[i], edges[i + 1]) for i in range(3)]


def brackets(qtl, marks):
    out = []
    for q in qtl:
        lefts = [m for m in marks if m <= q + 1e-8]
        rights = [m for m in marks if m >= q - 1e-8]
        left = lefts[-1]
        right = rights[0]
        if abs(left - right) < 1e-8:
            i = marks.index(left)
            left = marks[i - 1] if i else left
            right = marks[i + 1] if i + 1 < len(marks) else right
        out.append((left, right))
    return out


def _hit_mask(lr, grid, intervals, threshold):
    reps = lr.shape[0]
    hits = np.zeros(3)
    for q, (lo, hi) in enumerate(intervals):
        idx = np.where((grid >= lo) & (grid <= hi))[0]
        if idx.size == 0:
            continue
        local = np.where(np.isnan(lr[:, idx]), -np.inf, lr[:, idx])
        hits[q] = np.mean(np.max(local, axis=1) > threshold)
    return hits


def _overall(lr_st, grid, intervals, threshold):
    """Fraction of replicates in which any trait exceeds the threshold."""
    reps = lr_st.shape[0]
    hits = np.zeros(3)
    for q, (lo, hi) in enumerate(intervals):
        idx = np.where((grid >= lo) & (grid <= hi))[0]
        if idx.size == 0:
            continue
        local = np.where(np.isnan(lr_st[:, idx, :]), -np.inf, lr_st[:, idx, :])
        hits[q] = np.mean(np.max(local, axis=(1, 2)) > threshold)
    return hits


def _trait(lr_st, grid, intervals, threshold, trait):
    return _hit_mask(lr_st[:, :, trait], grid, intervals, threshold)


def global_max_hits(lr, grid, qtl, threshold, radius=15.0):
    reps = lr.shape[0]
    hits = np.zeros(3)
    for r in range(reps):
        curve = lr[r]
        if not np.any(np.isfinite(curve)):
            continue
        i = int(np.nanargmax(curve))
        if not np.isfinite(curve[i]) or curve[i] <= threshold:
            continue
        nearest = int(np.argmin(np.abs(np.asarray(qtl) - grid[i])))
        if abs(qtl[nearest] - grid[i]) <= radius:
            hits[nearest] += 1
    return hits / reps


def separated_hits(lr, grid, qtl, threshold, min_sep):
    reps = lr.shape[0]
    hits = np.zeros(3)
    qtl = np.asarray(qtl, dtype=float)
    for r in range(reps):
        curve = np.where(np.isnan(lr[r]), -np.inf, lr[r])
        order = np.argsort(-curve)
        kept = []
        for i in order:
            if curve[i] <= threshold:
                break
            if all(abs(grid[i] - grid[j]) >= min_sep for j in kept):
                kept.append(int(i))
            if len(kept) == 3:
                break
        used = set()
        for i in kept:
            nearest = int(np.argmin(np.abs(qtl - grid[i])))
            if nearest in used:
                continue
            if abs(qtl[nearest] - grid[i]) <= min_sep:
                hits[nearest] += 1
                used.add(nearest)
    return hits / reps


def lod_drop_hits(lr, grid, qtl, threshold, drop):
    """Count a QTL when the peak clears the threshold and the drop interval contains it."""
    reps = lr.shape[0]
    hits = np.zeros(3)
    for r in range(reps):
        curve = lr[r]
        for q, truth in enumerate(qtl):
            # search a 20 cM neighborhood so a neighbor's peak is not borrowed
            idx = np.where(np.abs(grid - truth) <= 20.0)[0]
            if idx.size == 0:
                continue
            local = np.where(np.isnan(curve[idx]), -np.inf, curve[idx])
            j = int(np.argmax(local))
            peak = local[j]
            if peak <= threshold:
                continue
            support = idx[local >= peak - drop]
            # contiguous component containing the peak
            peak_pos = idx[j]
            lo = peak_pos
            hi = peak_pos
            support_set = set(int(s) for s in support)
            while lo - 1 in support_set:
                lo -= 1
            while hi + 1 in support_set:
                hi += 1
            if grid[lo] - 1e-8 <= truth <= grid[hi] + 1e-8:
                hits[q] += 1
    return hits / reps


def distance(mat):
    sse = float(np.sum((mat - PRINTED) ** 2))
    sse_sem = float(np.sum((mat[:, 0] - PRINTED[:, 0]) ** 2))
    p = np.clip(mat / 100.0, 1e-3, 1.0 - 1e-3)
    chisq = float(np.sum((PRINTED - 100.0 * p) ** 2 / (100.0 * p * (1.0 - p))))
    chisq_sem = float(
        np.sum((PRINTED[:, 0] - mat[:, 0]) ** 2 / (100.0 * p[:, 0] * (1.0 - p[:, 0])))
    )
    return {
        "sse_18": round(sse, 1),
        "sse_sem": round(sse_sem, 1),
        "chi2_18": round(chisq, 1),
        "chi2_sem": round(chisq_sem, 1),
    }


def matrix_from(sem, ls, st, overall):
    # st: traits x qtl, or qtl x traits? We store qtl x trait below.
    mat = np.zeros((3, 6))
    mat[:, 0] = sem
    mat[:, 1] = ls
    mat[:, 2:5] = st
    mat[:, 5] = overall
    return mat


def summarize(grid, qtl, marks, lr_sem, lr_ls, lr_st):
    wide = windows_for(qtl)
    brack = brackets(qtl, marks)
    sem = 100 * _hit_mask(lr_sem, grid, wide, st.THRESH_MULTI)
    ls = 100 * _hit_mask(lr_ls, grid, wide, st.THRESH_MULTI)
    traits = np.vstack(
        [100 * _trait(lr_st, grid, wide, st.THRESH_SINGLE, t) for t in range(3)]
    ).T
    overall = 100 * _overall(lr_st, grid, wide, st.THRESH_SINGLE)
    mat = matrix_from(sem, ls, traits, overall)
    extra = {
        "bracket_sem": (100 * _hit_mask(lr_sem, grid, brack, st.THRESH_MULTI)).tolist(),
        "global_max_sem": (100 * global_max_hits(lr_sem, grid, qtl, st.THRESH_MULTI)).tolist(),
        "sep20_sem": (100 * separated_hits(lr_sem, grid, qtl, st.THRESH_MULTI, 20.0)).tolist(),
        "lod1_sem": (
            100 * lod_drop_hits(lr_sem, grid, qtl, st.THRESH_MULTI, 2.0 * np.log(10.0))
        ).tolist(),
        "as_lod_sem": (
            100 * _hit_mask(lr_sem, grid, wide, st.THRESH_MULTI * 2.0 * np.log(10.0))
        ).tolist(),
        "df3_sem": (
            100
            * _hit_mask(lr_sem, grid, wide, float(__import__("scipy").stats.chi2.ppf(0.995, 3)))
        ).tolist(),
        "boundary_sem": (
            100
            * _hit_mask(
                np.where((grid < 10) | (grid > 90), np.nan, lr_sem),
                grid,
                wide,
                st.THRESH_MULTI,
            )
        ).tolist(),
    }
    return {
        "cells": np.round(mat, 1).tolist(),
        "distance": distance(mat),
        "rules": {k: [round(x, 1) for x in v] for k, v in extra.items()},
    }


def regressor(spec, cache, marks, geno, t):
    t = float(t)
    if spec["expect"] == "oracle":
        return geno[:, int(round(t))]
    if t in marks:
        return geno[:, int(round(t))]
    if t <= min(marks) or t >= max(marks):
        return None
    left = max(m for m in marks if m < t)
    right = min(m for m in marks if m > t)
    return A.lookup(cache[(left, t, right)], geno[:, int(round(left))], geno[:, int(round(right))])


def scan_profile(spec, y, geno, marks, cache, cof_mode, selected=None):
    grid = GRID[:: spec["step"]]
    n = y.shape[0]
    lr_sem = np.full(grid.size, np.nan)
    lr_ls = np.full(grid.size, np.nan)
    lr_st = np.full((grid.size, 3), np.nan)
    for i, t in enumerate(grid):
        t = float(t)
        reg = regressor(spec, cache, marks, geno, t)
        if reg is None or float(np.std(reg)) < 1e-8:
            continue
        if cof_mode == "selected":
            cols = [
                int(round(m))
                for m in selected
                if abs(m - t) > spec.get("drop_cm", 10.0)
            ]
        else:
            cols = A.cofactor_columns(t, marks, cof_mode)
        cof = geno[:, cols] if cols else np.zeros((n, 0))
        fit = st._scan_position(y, reg, cof, st.THRESH_MULTI)
        lr_sem[i] = fit["lr_sem"]
        lr_ls[i] = fit["lr_ls"]
        lr_st[i] = fit["lr_st"]
    return grid, lr_sem, lr_ls, lr_st


def select_markers(spec, y, geno, marks, cache):
    scores = []
    for m in marks:
        reg = geno[:, int(round(m))]
        fit = st._scan_position(y, reg, np.zeros((y.shape[0], 0)), st.THRESH_MULTI)
        scores.append(fit["lr_sem"])
    chosen = []
    for i in np.argsort(-np.asarray(scores)):
        if scores[i] < st.THRESH_MULTI:
            break
        if all(abs(marks[i] - marks[j]) > 10.0 for j in chosen):
            chosen.append(int(i))
        if len(chosen) == 4:
            break
    return [marks[i] for i in chosen]


def prepare_y(rng, spec, geno, qtl, b_mat, gamma, psi):
    x = geno[:, [int(round(q)) for q in qtl]].copy()
    if spec.get("line_reps"):
        r = spec["line_reps"]
        resolvent = np.linalg.inv(np.eye(3) - b_mat)
        signal = (x @ gamma.T) @ resolvent.T
        noise = rng.multivariate_normal(np.zeros(3), psi, size=(r, x.shape[0])).mean(axis=0)
        return signal + noise
    y = st.phenotype(rng, x, b_mat, gamma, psi)
    if spec.get("standardize"):
        sd = y.std(axis=0, ddof=0)
        sd[sd == 0] = 1.0
        y = (y - y.mean(axis=0)) / sd
    return y


def run_spec(spec, reps):
    rng = np.random.default_rng(spec["seed"])
    marks = marks_of(spec)
    cache = build_cache(spec, marks)
    qtl = [float(q) for q in spec["qtl"]]
    b_mat = np.array(spec.get("B", B0), dtype=float)
    gamma = np.array(spec.get("G", G0), dtype=float)
    psi = np.array(spec.get("psi_mat", PSI0), dtype=float)
    grid = GRID[:: spec["step"]]
    lr_sem = np.full((reps, grid.size), np.nan)
    lr_ls = np.full((reps, grid.size), np.nan)
    lr_st = np.full((reps, grid.size, 3), np.nan)
    for r in range(reps):
        geno = A.simulate_geno(rng, spec["pop"], spec["map"], spec["n"])
        if spec.get("het"):
            geno = geno.copy()
            geno[rng.random(geno.shape) < spec["het"]] = 0.0
        if spec.get("distort"):
            center, half, target = spec["distort"]
            geno = geno.copy()
            col = int(round(center))
            plus = np.where(geno[:, col] > 0)[0]
            k = int(round(plus.size - target * geno.shape[0]))
            k = max(0, min(k, plus.size))
            if k:
                chosen = rng.choice(plus, size=k, replace=False)
                lo = max(0, int(round(center - half)))
                hi = min(100, int(round(center + half)))
                geno[np.ix_(chosen, np.arange(lo, hi + 1))] *= -1.0
        y = prepare_y(rng, spec, geno, qtl, b_mat, gamma, psi)
        mode = spec["cof"]
        selected = None
        if mode == "stepwise":
            selected = select_markers(spec, y, geno, marks, cache)
            mode_run = "selected"
        elif mode == "twostage":
            g1, s1, _, _ = scan_profile(spec, y, geno, marks, cache, "none")
            peaks = []
            curve = np.where(np.isnan(s1), -np.inf, s1)
            for i in range(1, curve.size - 1):
                if curve[i] >= curve[i - 1] and curve[i] >= curve[i + 1] and curve[i] > st.THRESH_MULTI:
                    peaks.append(float(g1[i]))
            # nearest marker to each peak, at least 15 cM apart
            selected = []
            for peak in sorted(peaks, key=lambda p: -curve[int(round(p))]):
                m = min(marks, key=lambda m: abs(m - peak))
                if all(abs(m - s) > 15.0 for s in selected):
                    selected.append(m)
            mode_run = "selected"
        else:
            mode_run = mode
        g, s, ls, stt = scan_profile(spec, y, geno, marks, cache, mode_run, selected)
        lr_sem[r] = s
        lr_ls[r] = ls
        lr_st[r] = stt
        if (r + 1) % 100 == 0 or r + 1 == reps:
            print(f"{spec['name']} {r + 1}/{reps}", flush=True)
    summary = summarize(grid, qtl, marks, lr_sem, lr_ls, lr_st)
    # JSON-safe spec
    safe = {}
    for k, v in spec.items():
        if isinstance(v, np.ndarray):
            safe[k] = v.tolist()
        else:
            safe[k] = v
    payload = {"spec": safe, "summary": summary, "n_reps": reps}
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / f"{spec['name']}.json").write_text(json.dumps(payload, indent=2))
    return payload


def base_spec(name, **kw):
    spec = dict(
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
        seed=20101201,
        family="A",
        note="",
        text_consistent="",
    )
    spec.update(kw)
    return spec


def catalog():
    g_flip = G0.copy()
    g_flip[0, 0] *= -1
    g_half = G0.copy()
    g_half[1, 0] = 0.25
    gap = [0, 10, 20, 40, 50, 60, 70, 80, 90, 95, 100]
    specs = [
        base_spec(
            "g11_flip",
            G=g_flip,
            seed=20101201,
            note="G11 sign reversed to +0.125.",
            text_consistent="no; the minus at x=245.2 touches this 0.125",
        ),
        base_spec(
            "g21_half",
            G=g_half,
            seed=20101202,
            note="G21 read as 0.25 instead of 0.5.",
            text_consistent="no; the glyph is an unsigned 0.5",
        ),
        base_spec(
            "g_transpose",
            G=G0.T.copy(),
            seed=20101203,
            note="G transposed, so trait rows and QTL columns are exchanged.",
            text_consistent="no; the three columns are labeled QTL1, QTL2, QTL3",
        ),
        base_spec(
            "psi_y2_heavy",
            psi_mat=np.diag([1.6, 2.5, 1.8]),
            seed=20101204,
            note="Psi diagonal assigned as 1.6, 2.5, 1.8.",
            text_consistent="no; matrix (8) prints 1.6, 1.8, 2.5 in that order",
        ),
        base_spec(
            "qtl1_25",
            qtl=[25.0, 42.0, 78.0],
            seed=20101205,
            note="QTL1 at the midpoint of the 20–30 cM bracket.",
            text_consistent="no; the sentence says 22 cM",
        ),
        base_spec(
            "qtl1_32",
            qtl=[32.0, 42.0, 78.0],
            seed=20101206,
            note="QTL1 moved to 32 cM, 10 cM from QTL2.",
            text_consistent="no; the sentence says 22 and 42",
        ),
        base_spec(
            "qtl1_25_n200",
            qtl=[25.0, 42.0, 78.0],
            n=200,
            seed=20101207,
            family="A+C",
            note="QTL1 at 25 cM and 200 lines.",
            text_consistent="no; positions and 150 lines are both printed",
        ),
        base_spec(
            "qtl1_25_n250",
            qtl=[25.0, 42.0, 78.0],
            n=250,
            seed=20101208,
            family="A+C",
            note="QTL1 at 25 cM and 250 lines.",
            text_consistent="no; SAGMB prints 22 cM and 150 lines",
        ),
        base_spec(
            "gap_qtl1",
            marker_list=gap,
            seed=20101209,
            note="20 cM gap between the markers at 20 and 40, so QTL1 at 22 sits in a wide bracket.",
            text_consistent="no; the sentence says 11 evenly spaced markers",
        ),
        base_spec(
            "gap_n250",
            marker_list=gap,
            n=250,
            seed=20101210,
            family="A+C",
            note="Wide bracket around QTL1, 250 lines.",
            text_consistent="no",
        ),
        base_spec(
            "distort_p03",
            distort=(22.0, 15.0, 0.30),
            seed=20101211,
            note="Local allele frequency 0.30 in a 30 cM window around QTL1.",
            text_consistent="no; the RIL codes are an even ±1 cross",
        ),
        base_spec(
            "het15",
            het=0.15,
            seed=20101212,
            note="Each locus is heterozygous, coded 0, with probability 0.15.",
            text_consistent="no; 12 generations of selfing leave almost no heterozygotes, and the paper codes ±1",
        ),
        base_spec(
            "linemean_r2",
            line_reps=2,
            seed=20101213,
            note="Two plots per line, Psi is the plot covariance, the scan uses the line mean.",
            text_consistent="no; the simulation sentence says 150 lines and draws residuals once",
        ),
        base_spec(
            "qtl1_on_marker",
            qtl=[20.0, 42.0, 78.0],
            seed=20101214,
            note="QTL1 on the marker at 20 cM. QTL2 and QTL3 stay at 42 and 78.",
            text_consistent="no; QTL1 is printed at 22",
        ),
        base_spec(
            "stepwise",
            cof="stepwise",
            seed=20101215,
            family="B",
            note="Up to four markers with marginal LR above 14.86, at least 10 cM apart, dropped within 10 cM of the test.",
            text_consistent="no; the simulation sentence fits every marker except the flanking pair",
        ),
        base_spec(
            "twostage",
            cof="twostage",
            seed=20101216,
            family="B",
            note="Null scan, then the nearest markers to peaks above 14.86 are cofactors.",
            text_consistent="no; the sentence describes one scan with fixed cofactors",
        ),
    ]
    return specs


def main():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--configs", required=True)
    parser.add_argument("--reps", type=int, default=1000)
    args = parser.parse_args()
    wanted = set(args.configs.split(","))
    for spec in catalog():
        if spec["name"] in wanted:
            run_spec(spec, args.reps)


if __name__ == "__main__":
    main()
