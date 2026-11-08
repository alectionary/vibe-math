"""Independent transcription of the Appendix A finite-population draw.

The random numbers are supplied by the caller so this file can be checked
against the R generator on a shared stream. It is not a second Monte Carlo.
"""

from __future__ import annotations

import numpy as np


def _scale_var2(z: np.ndarray) -> np.ndarray:
    return ((z - z.mean()) / z.std(ddof=1)) * np.sqrt(2.0)


def draw_sample(
    wj, u0, delta, rij, x, u_noise, r_noise, unif_j, unif_i,
    icc: float, nj_target: int, design: str,
):
    tau00 = icc / (1.0 - icc)
    gamma10 = np.sqrt(0.06 / 0.94)
    gamma01 = np.sqrt(tau00 * 0.06 / 0.94)
    M = wj.shape[0]
    Nj_ave = 25 if nj_target == 5 else 100
    cap = 1.5 * np.sqrt(0.2)
    delta = np.clip(delta, -cap, cap)
    Nj = np.where(
        delta <= 0,
        np.rint(Nj_ave * np.exp(delta)),
        np.rint(2 * Nj_ave - Nj_ave * np.exp(-delta)),
    ).astype(int)
    Nj = np.maximum(Nj, 1)
    school = np.repeat(np.arange(M), Nj)
    # population group means
    sum_x = np.bincount(school, weights=x, minlength=M)
    n_x = np.bincount(school, minlength=M).astype(float)
    xgmc = x - (sum_x / n_x)[school]
    ystar = gamma01 * wj[school] + u0[school] + gamma10 * xgmc + rij
    if design == "informative":
        u_used = _scale_var2(u0)
        r_used = _scale_var2(rij)
    elif design == "noninformative":
        u_used = _scale_var2(u_noise)
        r_used = _scale_var2(r_noise)
    else:
        raise ValueError(design)
    prob_j = 1.0 / (1.0 + np.exp((-u_used / 2.0) + 4.12))
    prob_i = 1.0 / (1.0 + np.exp((-r_used / 2.0) + 1.53))
    keep = prob_j[school] > unif_j[school]
    keep = keep & (prob_i > unif_i)
    sch = school[keep]
    m = np.unique(sch).size
    w_j = 1.0 / prob_j
    w_cond = 1.0 / prob_i
    return {
        "n": int(keep.sum()),
        "m": int(m),
        "N": int(Nj.sum()),
        "mean_y": float(ystar[keep].mean()) if keep.any() else np.nan,
        "mean_wj": float(w_j[sch].mean()) if keep.any() else np.nan,
        "schools": sch.astype(int),
        "y": ystar[keep],
        "gamma01": float(gamma01),
        "gamma10": float(gamma10),
    }
