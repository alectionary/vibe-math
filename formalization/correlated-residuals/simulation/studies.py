#!/usr/bin/env python3
"""Three seeded simulation studies for the Mi et al. (2010) SEM.

Study 1 replicates the printed RIL design in equations (7)-(8).
Study 2 fits a diagonal model and `recoverBow` to one bow-free law.
Study 3 refits the trait recursion to the Campbell et al. (2003)
Table 2 correlations and reruns that design.

Every choice the paper does not state is recorded in the JSON under
"assumptions".
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import numpy as np
from scipy.stats import chi2

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from delta_method import isserlis, pack_vech, recover_params, unpack_vech  # noqa: E402
from fit_bow import recover_bow  # noqa: E402

OUT = Path(__file__).resolve().parent / "out"

# Equation (7), PDF page 10. y = -M y + G x + e, so B = -M.
M_PAPER = np.array(
    [[0.0, 0.5, 0.25], [0.0, 0.0, 0.5], [0.0, 0.0, 0.0]], dtype=np.float64
)
G_PAPER = np.array(
    [[0.125, 0.25, 0.5], [0.5, 0.5, 0.5], [0.25, 0.125, 0.25]], dtype=np.float64
)
PSI_PAPER = np.diag([1.6, 1.8, 2.5])
B_PAPER = -M_PAPER
QTL_CM = np.array([22.0, 42.0, 78.0])
MARKER_CM = np.arange(0.0, 101.0, 10.0)
GRID_CM = np.arange(0.0, 101.0, 1.0)
# Midpoints between the three QTL, so the windows do not overlap.
WINDOWS = [(0.0, 32.0), (32.0, 60.0), (60.0, 100.0)]
THRESH_MULTI = float(chi2.ppf(0.995, 4))  # printed 14.86
THRESH_SINGLE = float(chi2.ppf(0.995, 2))  # printed 10.60
N_LINES = 150
N_REPS = 100
SELFING_GENERATIONS = 12
Z95 = 1.959963984540054


def algebraic_effects(b_mat: np.ndarray, gamma: np.ndarray):
    total = np.linalg.inv(np.eye(3) - b_mat) @ gamma
    direct = gamma.copy()
    indirect = total - direct
    return direct, indirect, total


def haldane_r(gaps_morgans: np.ndarray) -> np.ndarray:
    return 0.5 * (1.0 - np.exp(-2.0 * gaps_morgans))


def simulate_ril(rng: np.random.Generator, positions_cm: np.ndarray, n: int) -> np.ndarray:
    """±1 genotypes after 12 generations of Haldane selfing from an F1."""
    pos = np.asarray(positions_cm, dtype=np.float64) / 100.0
    gaps = np.diff(pos)
    rec = haldane_r(gaps)
    hap = np.zeros((n, 2, pos.size), dtype=np.int8)
    hap[:, 1, :] = 1
    for _ in range(SELFING_GENERATIONS):
        hap = _self_generation(rng, hap, rec)
    dosage = hap.sum(axis=1)
    code = np.empty(dosage.shape, dtype=np.float64)
    code[dosage == 0] = 1.0
    code[dosage == 2] = -1.0
    het = dosage == 1
    n_het = int(het.sum())
    if n_het:
        code[het] = rng.choice(np.array([-1.0, 1.0]), size=n_het)
    return code


def _self_generation(rng, hap, rec):
    return np.stack([_gamete(rng, hap, rec), _gamete(rng, hap, rec)], axis=1)


def _gamete(rng, hap, rec):
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


def _hap_index():
    haps = [(a, b, c) for a in (0, 1) for b in (0, 1) for c in (0, 1)]
    return haps


HAPS = _hap_index()


def _gamete_distribution(h0, h1, r01, r12):
    """Probability of each of the 8 haplotypes from one meiosis."""
    probs = np.zeros(8)
    for start in (0, 1):
        for sw1 in (0, 1):
            for sw2 in (0, 1):
                p = 0.5 * (r01 if sw1 else 1.0 - r01) * (r12 if sw2 else 1.0 - r12)
                h = start ^ sw1
                # locus 0 uses `start`, locus 1 uses start^sw1, locus 2 uses that ^ sw2
                src0 = h0 if start == 0 else h1
                src1 = h0 if (start ^ sw1) == 0 else h1
                src2 = h0 if (start ^ sw1 ^ sw2) == 0 else h1
                bits = (src0[0], src1[1], src2[2])
                probs[HAPS.index(bits)] += p
                del h
    return probs


def three_locus_law(left_cm: float, mid_cm: float, right_cm: float):
    """Joint law of three ±1 loci after the same 12 selfing generations."""
    d1 = (mid_cm - left_cm) / 100.0
    d2 = (right_cm - mid_cm) / 100.0
    r01 = float(haldane_r(np.array([d1]))[0]) if d1 > 0 else 0.0
    r12 = float(haldane_r(np.array([d2]))[0]) if d2 > 0 else 0.0
    n_hap = 8
    trans = np.zeros((n_hap * n_hap, n_hap * n_hap))
    gam = []
    for i, h0 in enumerate(HAPS):
        for j, h1 in enumerate(HAPS):
            gam.append(_gamete_distribution(h0, h1, r01, r12))
    gam = np.asarray(gam)
    for s, gprobs in enumerate(gam):
        # two independent gametes
        joint = np.outer(gprobs, gprobs)
        trans[:, s] = joint.ravel()
    state = np.zeros(n_hap * n_hap)
    # F1: haplotype (0,0,0) and (1,1,1)
    i0 = HAPS.index((0, 0, 0))
    i1 = HAPS.index((1, 1, 1))
    state[i0 * n_hap + i1] = 1.0
    for _ in range(SELFING_GENERATIONS):
        state = trans @ state
    # Mass on coded (c0, c1, c2) in {±1}^3. A heterozygous locus splits 50/50.
    mass = {}
    for s, p in enumerate(state):
        if p == 0.0:
            continue
        h0 = HAPS[s // n_hap]
        h1 = HAPS[s % n_hap]
        loci = []
        for k in range(3):
            if h0[k] == 0 and h1[k] == 0:
                loci.append((1.0,))
            elif h0[k] == 1 and h1[k] == 1:
                loci.append((-1.0,))
            else:
                loci.append((-1.0, 1.0))
        base = p
        splits = 1
        for loc in loci:
            splits *= len(loc)
        share = base / splits
        for a in loci[0]:
            for b in loci[1]:
                for c in loci[2]:
                    mass[(a, b, c)] = mass.get((a, b, c), 0.0) + share
    return mass


def conditional_expectation(left_cm, mid_cm, right_cm):
    mass = three_locus_law(left_cm, mid_cm, right_cm)
    table = {}
    for left in (-1.0, 1.0):
        for right in (-1.0, 1.0):
            num = 0.0
            den = 0.0
            for (a, b, c), p in mass.items():
                if a == left and c == right:
                    num += b * p
                    den += p
            table[(left, right)] = num / den if den > 0 else 0.0
    return table


def expectation_cache():
    cache = {}
    for t in GRID_CM:
        if t in MARKER_CM:
            continue
        left = float(np.floor(t / 10.0) * 10.0)
        right = left + 10.0
        key = (left, float(t), right)
        cache[key] = conditional_expectation(*key)
    return cache


def phenotype(rng, qtl, b_mat, gamma, psi):
    n = qtl.shape[0]
    noise = rng.multivariate_normal(np.zeros(3), psi, size=n)
    signal = qtl @ gamma.T + noise
    resolvent = np.linalg.inv(np.eye(3) - b_mat)
    return signal @ resolvent.T


def _center(x):
    return x - x.mean(axis=0)


def _rss(y, x):
    if x.size == 0:
        resid = y - y.mean()
        return float(resid @ resid), np.zeros(0)
    beta, _, _, _ = np.linalg.lstsq(x, y, rcond=None)
    resid = y - x @ beta
    return float(resid @ resid), beta


def _scan_position(y, qtl_reg, cof, threshold_joint):
    """SEM joint LR, LS joint LR, three single-trait LRs, and effect rows."""
    n = y.shape[0]
    y_c = _center(y)
    q = _center(qtl_reg.reshape(-1, 1))
    c = _center(cof) if cof.size else np.zeros((n, 0))
    # SEM unrestricted / restricted, traits ordered y3, y2, y1.
    direct = np.zeros(3)
    paths = np.zeros(3)  # b23, b12, b13
    rss_u = np.zeros(3)
    rss_r = np.zeros(3)
    # y3
    xu = np.hstack([q, c]) if c.size else q
    xr = c if c.size else np.zeros((n, 0))
    rss_u[2], beta_u = _rss(y_c[:, 2], xu)
    rss_r[2], _ = _rss(y_c[:, 2], xr)
    direct[2] = beta_u[0]
    # y2 on y3
    parent = _center(y[:, 2:3])
    xu = np.hstack([parent, q, c]) if c.size else np.hstack([parent, q])
    xr = np.hstack([parent, c]) if c.size else parent
    rss_u[1], beta_u = _rss(y_c[:, 1], xu)
    rss_r[1], _ = _rss(y_c[:, 1], xr)
    paths[0] = beta_u[0]  # b23
    direct[1] = beta_u[1]
    # y1 on y2, y3
    parents = _center(y[:, 1::-1])  # y2, y3? y[:, 1] is y2, y[:, 0] is y1. Want y2 and y3.
    parents = _center(np.column_stack([y[:, 1], y[:, 2]]))
    xu = np.hstack([parents, q, c]) if c.size else np.hstack([parents, q])
    xr = np.hstack([parents, c]) if c.size else parents
    rss_u[0], beta_u = _rss(y_c[:, 0], xu)
    rss_r[0], _ = _rss(y_c[:, 0], xr)
    paths[1] = beta_u[0]  # b12
    paths[2] = beta_u[1]  # b13
    direct[0] = beta_u[2]
    psi_u = np.maximum(rss_u / n, 1e-12)
    psi_r = np.maximum(rss_r / n, 1e-12)
    lr_sem = float(n * np.sum(np.log(psi_r) - np.log(psi_u)))
    b_hat = np.zeros((3, 3))
    b_hat[1, 2] = paths[0]
    b_hat[0, 1] = paths[1]
    b_hat[0, 2] = paths[2]
    indirect = np.array(
        [
            b_hat[0, 1] * direct[1] + b_hat[0, 2] * direct[2] + b_hat[0, 1] * b_hat[1, 2] * direct[2],
            b_hat[1, 2] * direct[2],
            0.0,
        ]
    )
    # Multivariate LS of all three traits on q and cofactors.
    xu = np.hstack([q, c]) if c.size else q
    xr = c if c.size else np.zeros((n, 0))
    bu, _, _, _ = np.linalg.lstsq(xu, y_c, rcond=None)
    resid_u = y_c - xu @ bu
    if xr.size:
        br, _, _, _ = np.linalg.lstsq(xr, y_c, rcond=None)
        resid_r = y_c - xr @ br
    else:
        resid_r = y_c
    su = resid_u.T @ resid_u / n
    sr = resid_r.T @ resid_r / n
    sign_u, log_u = np.linalg.slogdet(su)
    sign_r, log_r = np.linalg.slogdet(sr)
    lr_ls = float(n * (log_r - log_u)) if sign_u > 0 and sign_r > 0 else np.nan
    total_ls = bu[0].copy()
    # Single trait.
    lr_st = np.zeros(3)
    total_st = np.zeros(3)
    for k in range(3):
        rssu, betau = _rss(y_c[:, k], xu)
        rssr, _ = _rss(y_c[:, k], xr)
        lr_st[k] = n * (np.log(max(rssr, 1e-12)) - np.log(max(rssu, 1e-12)))
        total_st[k] = betau[0]
    return {
        "lr_sem": lr_sem,
        "lr_ls": lr_ls,
        "lr_st": lr_st,
        "direct": direct,
        "indirect": indirect,
        "total_sem": direct + indirect,
        "total_ls": total_ls,
        "total_st": total_st,
        "paths": paths,
        "lr_eq": n * (np.log(psi_r) - np.log(psi_u)),
    }


def cofactor_index(t, marker_index):
    if t in marker_index:
        flanking = {t - 10.0, t, t + 10.0}
    else:
        left = float(np.floor(t / 10.0) * 10.0)
        flanking = {left, left + 10.0}
    keep = [i for cm, i in marker_index.items() if cm not in flanking]
    return keep


def one_replicate(rng, cache, b_mat, gamma, psi):
    geno = simulate_ril(rng, GRID_CM, N_LINES)
    qtl_cols = [int(cm) for cm in QTL_CM]
    qtl = geno[:, qtl_cols]
    y = phenotype(rng, qtl, b_mat, gamma, psi)
    marker_index = {float(cm): int(cm) for cm in MARKER_CM}
    profiles = {
        "lr_sem": [],
        "lr_ls": [],
        "lr_st": [],
    }
    fits = []
    for t in GRID_CM:
        t = float(t)
        if t in marker_index:
            reg = geno[:, marker_index[t]]
        else:
            left = float(np.floor(t / 10.0) * 10.0)
            right = left + 10.0
            table = cache[(left, t, right)]
            left_g = geno[:, int(left)]
            right_g = geno[:, int(right)]
            reg = np.empty(N_LINES)
            for i in range(N_LINES):
                reg[i] = table[(float(left_g[i]), float(right_g[i]))]
        cof_cols = cofactor_index(t, marker_index)
        cof = geno[:, cof_cols] if cof_cols else np.zeros((N_LINES, 0))
        fit = _scan_position(y, reg, cof, THRESH_MULTI)
        profiles["lr_sem"].append(fit["lr_sem"])
        profiles["lr_ls"].append(fit["lr_ls"])
        profiles["lr_st"].append(fit["lr_st"])
        fits.append(fit)
    return profiles, fits


def _window_summary(values, grid):
    """values: list over grid of scalars. Return argmax cM and max."""
    arr = np.asarray(values, dtype=float)
    out = []
    for lo, hi in WINDOWS:
        mask = (grid >= lo) & (grid <= hi)
        idx = np.where(mask)[0]
        local = arr[idx]
        j = int(np.nanargmax(local))
        out.append((float(grid[idx[j]]), float(local[j])))
    return out


def summarize_replicate(profiles, fits, grid):
    sem_pos = _window_summary(profiles["lr_sem"], grid)
    ls_pos = _window_summary(profiles["lr_ls"], grid)
    st = np.asarray(profiles["lr_st"])
    rows = []
    for q, ((sem_cm, sem_lr), (ls_cm, ls_lr)) in enumerate(zip(sem_pos, ls_pos)):
        sem_fit = fits[int(sem_cm)]
        ls_fit = fits[int(ls_cm)]
        st_pos = []
        st_eff = []
        st_hit = []
        for trait in range(3):
            cm, lr = _window_summary(st[:, trait], grid)[q]
            st_pos.append(cm)
            st_eff.append(float(fits[int(cm)]["total_st"][trait]))
            st_hit.append(bool(lr > THRESH_SINGLE))
        rows.append(
            {
                "qtl": q + 1,
                "sem_position": sem_cm,
                "sem_lr": sem_lr,
                "sem_detected": bool(sem_lr > THRESH_MULTI),
                "sem_direct": sem_fit["direct"].tolist(),
                "sem_indirect": sem_fit["indirect"].tolist(),
                "sem_total": sem_fit["total_sem"].tolist(),
                "ls_position": ls_cm,
                "ls_lr": ls_lr,
                "ls_detected": bool(ls_lr > THRESH_MULTI),
                "ls_total": ls_fit["total_ls"].tolist(),
                "st_position": st_pos,
                "st_total": st_eff,
                "st_detected": st_hit,
                "st_any": bool(any(st_hit)),
            }
        )
    return rows


def _mean_sd(a):
    a = np.asarray(a, dtype=float)
    return float(np.mean(a)), float(np.std(a, ddof=1))


def run_scan(seed: int, reps: int, b_mat, gamma, psi, label: str):
    rng = np.random.default_rng(seed)
    cache = expectation_cache()
    rep_rows = []
    profile_sem = []
    profile_ls = []
    profile_st = []
    for r in range(reps):
        profiles, fits = one_replicate(rng, cache, b_mat, gamma, psi)
        rep_rows.append(summarize_replicate(profiles, fits, GRID_CM))
        profile_sem.append(profiles["lr_sem"])
        profile_ls.append(profiles["lr_ls"])
        profile_st.append(profiles["lr_st"])
        if (r + 1) % 10 == 0 or r == 0:
            print(f"{label} replicate {r + 1}/{reps}", flush=True)
    direct, indirect, total = algebraic_effects(b_mat, gamma)
    summary = []
    for q in range(3):
        block = [rep[q] for rep in rep_rows]
        def col(name, trait=None):
            if trait is None:
                return [row[name] for row in block]
            return [row[name][trait] for row in block]

        entry = {"qtl": q + 1, "truth_cm": float(QTL_CM[q])}
        for trait, name in enumerate(["Y1", "Y2", "Y3"]):
            entry[name] = {
                "truth_direct": float(direct[trait, q]),
                "truth_indirect": float(indirect[trait, q]),
                "truth_total": float(total[trait, q]),
            }
            for key, src in (
                ("sem_direct", "sem_direct"),
                ("sem_indirect", "sem_indirect"),
                ("sem_total", "sem_total"),
                ("ls_total", "ls_total"),
                ("st_total", "st_total"),
            ):
                mu, sd = _mean_sd(col(src, trait))
                entry[name][key] = {"mean": mu, "sd": sd}
            mu, sd = _mean_sd(col("st_position", trait))
            entry[name]["st_position"] = {"mean": mu, "sd": sd}
            entry[name]["st_power"] = float(np.mean(col("st_detected", trait)))
        for key in ("sem_position", "ls_position"):
            mu, sd = _mean_sd(col(key))
            entry[key] = {"mean": mu, "sd": sd}
        entry["sem_power"] = float(np.mean(col("sem_detected")))
        entry["ls_power"] = float(np.mean(col("ls_detected")))
        entry["st_overall_power"] = float(np.mean(col("st_any")))
        summary.append(entry)
    prof = {
        "cm": GRID_CM.tolist(),
        "sem_mean": np.mean(profile_sem, axis=0).tolist(),
        "ls_mean": np.mean(profile_ls, axis=0).tolist(),
        "st_mean": np.mean(profile_st, axis=0).tolist(),
    }
    return {"summary": summary, "profile": prof, "n_reps": reps, "seed": seed}


def population_phi(positions):
    mass = three_locus_law(*positions)
    phi = np.zeros((3, 3))
    for (a, b, c), p in mass.items():
        x = np.array([a, b, c])
        phi += p * np.outer(x, x)
    return phi


def joint_sigma(b_mat, gamma, psi, phi):
    resolvent = np.linalg.inv(np.eye(3) - b_mat)
    yy = resolvent @ (gamma @ phi @ gamma.T + psi) @ resolvent.T
    yx = resolvent @ gamma @ phi
    top = np.concatenate([yy, yx], axis=1)
    bot = np.concatenate([yx.T, phi], axis=1)
    return np.concatenate([top, bot], axis=0)


def numeric_jacobian(sigma, recover, step=1e-6):
    base = pack_vech(sigma)
    dim = sigma.shape[0]
    columns = []
    eye = np.eye(base.size)
    for k in range(base.size):
        plus = recover(unpack_vech(base + step * eye[k], dim))
        minus = recover(unpack_vech(base - step * eye[k], dim))
        columns.append((plus - minus) / (2 * step))
    return np.column_stack(columns)


def sample_moment(rng, sigma, n):
    # x is not Gaussian. Study 2 draws the RIL genotypes and Gaussian noise,
    # then forms the centered ML covariance. This helper is only for the
    # Gaussian-x check. The bow study uses draw_bow_sample.
    z = rng.multivariate_normal(np.zeros(sigma.shape[0]), sigma, size=n)
    z -= z.mean(axis=0)
    return z.T @ z / n


def draw_bow_sample(rng, positions, b_mat, gamma, psi, n):
    x = simulate_ril(rng, np.asarray(positions, dtype=float), n)
    noise = rng.multivariate_normal(np.zeros(3), psi, size=n)
    signal = x @ gamma.T + noise
    resolvent = np.linalg.inv(np.eye(3) - b_mat)
    y = signal @ resolvent.T
    z = np.concatenate([y, x], axis=1)
    z -= z.mean(axis=0)
    return z.T @ z / n


def bow_parameters(rho, b_base, psi_diag):
    v1, v2, v3 = psi_diag
    c = float(rho) * np.sqrt(v1 * v3)
    b_mat = b_base.copy()
    b_mat[0, 2] = 0.0
    psi = np.array([[v1, 0.0, c], [0.0, v2, 0.0], [c, 0.0, v3]])
    return b_mat, psi, c


def run_bow(seed: int, reps: int, rhos, b_base, gamma, psi_diag, phi, label: str):
    rng = np.random.default_rng(seed)
    rows = []
    positions = QTL_CM.tolist()
    for rho in rhos:
        b_mat, psi, c = bow_parameters(rho, b_base, psi_diag)
        if np.min(np.linalg.eigvalsh(psi)) <= 0:
            raise SystemExit(f"residual matrix is not positive definite at rho={rho}")
        sigma = joint_sigma(b_mat, gamma, psi, phi)
        plim_diag = recover_params(sigma)
        plim_bow = recover_bow(sigma)
        truth_bow = np.concatenate(
            [
                np.array([b_mat[0, 1], b_mat[1, 2], psi[0, 0], psi[1, 1], psi[2, 2], c]),
                gamma.reshape(-1),
                pack_vech(phi),
            ]
        )
        truth_diag_b13 = 0.0
        gamma_true = gamma.reshape(-1)
        cover = np.zeros(truth_bow.size)
        b13_reject = 0
        gamma_reject = 0
        finite = 0
        diag_ests = []
        bow_ests = []
        for _ in range(reps):
            s = draw_bow_sample(rng, positions, b_mat, gamma, psi, N_LINES)
            try:
                d_hat = recover_params(s)
                b_hat = recover_bow(s)
                j_b = numeric_jacobian(s, recover_bow)
                v_b = j_b @ isserlis(s) @ j_b.T
                se_b = np.sqrt(np.maximum(np.diag(v_b), 0.0) / N_LINES)
                j_d = numeric_jacobian(s, recover_params)
                v_d = j_d @ isserlis(s) @ j_d.T
            except np.linalg.LinAlgError:
                continue
            finite += 1
            diag_ests.append(d_hat)
            bow_ests.append(b_hat)
            cover += (np.abs(b_hat - truth_bow) <= Z95 * se_b).astype(float)
            se_b13 = np.sqrt(max(v_d[1, 1], 0.0) / N_LINES)
            if se_b13 > 0 and abs(d_hat[1] - truth_diag_b13) > Z95 * se_b13:
                b13_reject += 1
            g_idx = slice(6, 15)
            diff = d_hat[g_idx] - gamma_true
            vg = v_d[g_idx, g_idx] / N_LINES
            try:
                stat = float(diff @ np.linalg.solve(vg, diff))
            except np.linalg.LinAlgError:
                stat = np.nan
            if np.isfinite(stat) and stat > chi2.ppf(0.95, 9):
                gamma_reject += 1
        diag_ests = np.asarray(diag_ests)
        bow_ests = np.asarray(bow_ests)
        names_bow = (
            ["b12", "b23", "v1", "v2", "v3", "c"]
            + [f"gamma_{i}{j}" for i in range(3) for j in range(3)]
            + [f"phi_{i}{j}" for i in range(3) for j in range(i + 1)]
        )
        names_diag = (
            ["b12", "b13", "b23", "v1", "v2", "v3"]
            + [f"gamma_{i}{j}" for i in range(3) for j in range(3)]
        )
        def pack(est, names, truth):
            out = []
            for i, name in enumerate(names):
                out.append(
                    {
                        "name": name,
                        "truth": float(truth[i]),
                        "plim": float(truth[i]) if False else None,
                        "mean": float(np.mean(est[:, i])),
                        "sd": float(np.std(est[:, i], ddof=1)),
                    }
                )
            return out

        diag_truth = np.concatenate(
            [
                np.array([b_mat[0, 1], 0.0, b_mat[1, 2], psi[0, 0], psi[1, 1], psi[2, 2]]),
                gamma_true,
            ]
        )
        row = {
            "rho": float(rho),
            "c": c,
            "finite_reps": finite,
            "diagonal_plim": {
                name: float(plim_diag[i]) for i, name in enumerate(names_diag)
            },
            "bow_plim_max_abs_error": float(np.max(np.abs(plim_bow - truth_bow))),
            "diagonal_monte_carlo": pack(diag_ests, names_diag, diag_truth),
            "bow_monte_carlo": [
                {
                    "name": name,
                    "truth": float(truth_bow[i]),
                    "mean": float(np.mean(bow_ests[:, i])),
                    "sd": float(np.std(bow_ests[:, i], ddof=1)),
                    "delta_method_coverage": float(cover[i] / finite),
                }
                for i, name in enumerate(names_bow)
            ],
            "diagonal_b13_rejection_rate": b13_reject / finite,
            "diagonal_gamma_wald_rejection_rate": gamma_reject / finite,
            "diagonal_b13_plim": float(plim_diag[1]),
        }
        # attach plim onto the diagonal monte carlo rows
        for item in row["diagonal_monte_carlo"]:
            item["plim"] = row["diagonal_plim"][item["name"]]
        rows.append(row)
        print(
            f"{label} rho={rho:.2f} b13 plim={plim_diag[1]:.3f} "
            f"b13 reject={row['diagonal_b13_rejection_rate']:.3f} "
            f"bow c coverage={row['bow_monte_carlo'][5]['delta_method_coverage']:.3f}",
            flush=True,
        )
    return rows


def campbell_correlation():
    """3 x 3 correlation for (TKWT, KPS, SPSM).

    Magnitudes are Campbell et al. (2003) Table 2. The sign of TKWT with
    SPSM is the sign stated in the same section: SPSM was negatively
    correlated with TKWT. TKWT with KPS and KPS with SPSM are the signs
    in the extracted table; the prose does not restate them.
    """
    r_tkwt_kps = 0.08
    r_tkwt_spsm = -0.44
    r_kps_spsm = 0.59
    corr = np.array(
        [
            [1.0, r_tkwt_kps, r_tkwt_spsm],
            [r_tkwt_kps, 1.0, r_kps_spsm],
            [r_tkwt_spsm, r_kps_spsm, 1.0],
        ]
    )
    return corr


def fit_trait_sem(corr):
    """Diagonal recursive factorization, trait order (Y1, Y2, Y3)."""
    v3 = corr[2, 2]
    b23 = corr[1, 2] / v3
    c13 = corr[0, 2] / v3
    v2 = corr[1, 1] - b23**2 * v3
    b12 = (corr[0, 1] - b23 * c13 * v3) / v2
    b13 = c13 - b12 * b23
    v1 = corr[0, 0] - b12**2 * v2 - c13**2 * v3
    b_mat = np.zeros((3, 3))
    b_mat[0, 1] = b12
    b_mat[0, 2] = b13
    b_mat[1, 2] = b23
    psi = np.diag([v1, v2, v3])
    return b_mat, psi


def assumptions():
    return [
        "Map function is Haldane with no interference. The paper does not name one.",
        "An RIL is an F1 selfed for 12 generations. Residual heterozygotes are coded ±1 with equal probability. The paper says RILs and does not give the generation or a segregation-distortion model.",
        "Eleven markers sit at 0, 10, ..., 100 cM. The paper says 11 evenly spaced markers on a 100 cM segment.",
        "QTL genotype codes are +1 and -1, as printed under equation (7). Which parent is +1 is arbitrary.",
        "The analysis uses the centered ML covariance, divisor n, matching the fitting function (6). PROC TCALIS is not reimplemented.",
        "Flanking-marker conditional expectations are computed from the same 12-generation law. Cofactors are every marker except the flanking pair. A 10 cM exclusion window is stated for the wheat scan, not for this simulation.",
        "A QTL is counted as detected when the maximum LR in the midpoint window [0,32], (32,60], or (60,100] exceeds the printed threshold. The paper does not define the window.",
        "The printed thresholds 14.86 and 10.60 equal chi-square 0.005 quantiles on 4 and 2 degrees of freedom. The simulation text also says the LR has p degrees of freedom for p traits.",
        "Effects are the coefficients at the window argmax, not at the true position.",
        "Study 2 treats the three QTL genotypes as the observed exogenous variables. It is not a marker scan.",
        "Delta-method standard errors use the Gaussian Isserlis covariance of vech(zz^T). The QTL genotypes are ±1, so that covariance is an approximation.",
        "Study 3 maps Y1, Y2, Y3 to TKWT, KPS, SPSM. GYLD is the fourth trait in the wheat application and is not in equation (7).",
        "Study 3 copies the equation-(7) QTL coefficient matrix onto the correlation-scale path model. Those coefficients were not estimated from Campbell's correlations.",
    ]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--reps", type=int, default=N_REPS)
    parser.add_argument("--bow-reps", type=int, default=400)
    parser.add_argument("--studies", default="1,2,3")
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    selected = {int(s) for s in args.studies.split(",")}
    direct, indirect, total = algebraic_effects(B_PAPER, G_PAPER)
    meta = {
        "thresholds": {"multi": THRESH_MULTI, "single": THRESH_SINGLE},
        "algebraic_effects_from_equations_7_8": {
            "direct": direct.tolist(),
            "indirect": indirect.tolist(),
            "total": total.tolist(),
        },
        "assumptions": assumptions(),
        "n_lines": N_LINES,
        "selfing_generations": SELFING_GENERATIONS,
    }
    if 1 in selected:
        scan = run_scan(20101027, args.reps, B_PAPER, G_PAPER, PSI_PAPER, "study1")
        payload = {**meta, "scan": scan}
        (OUT / "study1.json").write_text(json.dumps(payload, indent=2) + "\n")
        print("wrote study1.json", flush=True)
    if 2 in selected or 3 in selected:
        phi = population_phi(QTL_CM.tolist())
        meta["qtl_second_moment"] = phi.tolist()
    if 2 in selected:
        rows = run_bow(
            20101028,
            args.bow_reps,
            [-0.6, -0.3, 0.0, 0.25, 0.3, 0.6],
            B_PAPER,
            G_PAPER,
            np.diag(PSI_PAPER).tolist(),
            phi,
            "study2",
        )
        (OUT / "study2.json").write_text(
            json.dumps({"meta": meta, "rows": rows}, indent=2) + "\n"
        )
        print("wrote study2.json", flush=True)
    if 3 in selected:
        corr = campbell_correlation()
        b_hat, psi_hat = fit_trait_sem(corr)
        scan = run_scan(20101029, args.reps, b_hat, G_PAPER, np.diag(np.diag(psi_hat)), "study3")
        rows = run_bow(
            20101030,
            args.bow_reps,
            [0.0, 0.25],
            b_hat,
            G_PAPER,
            np.diag(psi_hat).tolist(),
            phi,
            "study3-bow",
        )
        (OUT / "study3.json").write_text(
            json.dumps(
                {
                    "correlation": corr.tolist(),
                    "fitted_B": b_hat.tolist(),
                    "fitted_Psi": np.diag(psi_hat).tolist(),
                    "correlation_eigenvalues": np.linalg.eigvalsh(corr).tolist(),
                    "scan": scan,
                    "bow": rows,
                    "meta": meta,
                },
                indent=2,
            )
            + "\n"
        )
        print("wrote study3.json", flush=True)


if __name__ == "__main__":
    main()
