#!/usr/bin/env python3
"""Delta-method variance of the equation-(7) plug-in estimator.

The population map is `recover` from `CorrelatedResiduals/Diagonal.lean`.
At a mean-zero Gaussian law the empirical second-moment matrix has the
Isserlis covariance, and the delta method pushes it through the derivative
of `recover`. The numeric check compares that matrix with a Monte Carlo
estimate at the printed equation-(7) point.
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from check_witness import paper_point, sigma_closed


def to_float(m):
    return np.array([[float(entry) for entry in row] for row in m], dtype=np.float64)


def pack_vech(s: np.ndarray) -> np.ndarray:
    dim = s.shape[0]
    return np.array([s[i, j] for i in range(dim) for j in range(i + 1)], dtype=np.float64)


def unpack_vech(v: np.ndarray, dim: int) -> np.ndarray:
    s = np.zeros((dim, dim), dtype=np.float64)
    k = 0
    for i in range(dim):
        for j in range(i + 1):
            s[i, j] = v[k]
            s[j, i] = v[k]
            k += 1
    return s


def assemble_sigma(blocks: dict) -> np.ndarray:
    yy, yx, xx = to_float(blocks["yy"]), to_float(blocks["yx"]), to_float(blocks["xx"])
    top = np.concatenate([yy, yx], axis=1)
    bot = np.concatenate([yx.T, xx], axis=1)
    return np.concatenate([top, bot], axis=0)


def split_sigma(s: np.ndarray):
    return s[:3, :3], s[:3, 3:], s[3:, 3:]


def recover_params(s: np.ndarray) -> np.ndarray:
    """Stack `(b12,b13,b23,v1,v2,v3)`, row-major `Γ`, and lower `vech Φ`."""
    yy, yx, xx = split_sigma(s)
    phi_inv = np.linalg.inv(xx)
    omega = yy - yx @ phi_inv @ yx.T
    v3 = omega[2, 2]
    b23 = omega[1, 2] / v3
    c13 = omega[0, 2] / v3
    v2 = omega[1, 1] - b23 * b23 * v3
    b12 = (omega[0, 1] - b23 * c13 * v3) / v2
    b13 = c13 - b12 * b23
    v1 = omega[0, 0] - b12 * b12 * v2 - c13 * c13 * v3
    b = np.zeros((3, 3), dtype=np.float64)
    b[0, 1], b[0, 2], b[1, 2] = b12, b13, b23
    gamma = (np.eye(3) - b) @ yx @ phi_inv
    endogenous = np.array([b12, b13, b23, v1, v2, v3], dtype=np.float64)
    return np.concatenate([endogenous, gamma.reshape(-1, order="C"), pack_vech(xx)])


def isserlis(sigma: np.ndarray) -> np.ndarray:
    """Covariance of `vech(zzᵀ)` for `z ~ N(0, Σ)`."""
    dim = sigma.shape[0]
    idx = [(i, j) for i in range(dim) for j in range(i + 1)]
    m = len(idx)
    v = np.empty((m, m), dtype=np.float64)
    for a, (i, j) in enumerate(idx):
        for b, (k, l) in enumerate(idx):
            v[a, b] = sigma[i, k] * sigma[j, l] + sigma[i, l] * sigma[j, k]
    return v


def jacobian(sigma: np.ndarray, step: float = 1e-6) -> np.ndarray:
    base = pack_vech(sigma)
    dim = sigma.shape[0]
    columns = []
    eye_v = np.eye(base.size)
    for k in range(base.size):
        plus = recover_params(unpack_vech(base + step * eye_v[k], dim))
        minus = recover_params(unpack_vech(base - step * eye_v[k], dim))
        columns.append((plus - minus) / (2 * step))
    return np.column_stack(columns)


def schur_differential(sigma: np.ndarray, a: np.ndarray, c: np.ndarray, h: np.ndarray) -> np.ndarray:
    yy, yx, xx = split_sigma(sigma)
    phi_inv = np.linalg.inv(xx)
    return (
        a
        - c @ phi_inv @ yx.T
        - yx @ phi_inv @ c.T
        + yx @ phi_inv @ h @ phi_inv @ yx.T
    )


def true_theta(point) -> np.ndarray:
    b = to_float(point["B"])
    gamma = to_float(point["Gamma"])
    psi = to_float(point["Psi"])
    phi = to_float(point["Phi"])
    endogenous = np.array(
        [b[0, 1], b[0, 2], b[1, 2], psi[0, 0], psi[1, 1], psi[2, 2]], dtype=np.float64
    )
    return np.concatenate([endogenous, gamma.reshape(-1, order="C"), pack_vech(phi)])


def xx_positions(dim: int = 6) -> list[int]:
    idx = [(i, j) for i in range(dim) for j in range(i + 1)]
    return [t for t, (i, j) in enumerate(idx) if i >= 3 and j >= 3]


def rel_frobenius(a: np.ndarray, b: np.ndarray) -> float:
    denom = np.linalg.norm(b, ord="fro")
    if denom == 0:
        return float(np.linalg.norm(a, ord="fro"))
    return float(np.linalg.norm(a - b, ord="fro") / denom)


def sample_cov(rows: np.ndarray) -> np.ndarray:
    return np.cov(rows, rowvar=False, ddof=1)


def monte_carlo(rng, sigma: np.ndarray, theta: np.ndarray, n: int, reps: int, batch: int = 40):
    draws = []
    done = 0
    while done < reps:
        size = min(batch, reps - done)
        z = rng.multivariate_normal(np.zeros(6), sigma, size=(size, n), check_valid="ignore")
        moment = np.einsum("bni,bnj->bij", z, z) / n
        for r in range(size):
            draws.append(np.sqrt(n) * (recover_params(moment[r]) - theta))
        done += size
    return sample_cov(np.asarray(draws))


def second_moment_control(rng, sigma: np.ndarray, v: np.ndarray, reps: int = 20000) -> float:
    z = rng.multivariate_normal(np.zeros(6), sigma, size=reps, check_valid="ignore")
    outer = np.einsum("bi,bj->bij", z, z)
    packed = np.stack([pack_vech(outer[r]) for r in range(reps)])
    return rel_frobenius(sample_cov(packed), v)


def main():
    point = paper_point()
    sigma = assemble_sigma(sigma_closed(point["B"], point["Gamma"], point["Psi"], point["Phi"]))
    theta = true_theta(point)
    recovered = recover_params(sigma)
    recovery_err = float(np.max(np.abs(recovered - theta)))
    if not np.isfinite(recovery_err) or recovery_err > 1e-9:
        raise SystemExit(f"population recovery failed: {recovery_err}")

    v = isserlis(sigma)
    jac = jacobian(sigma)
    av = jac @ v @ jac.T

    xx = xx_positions()
    # Φ is copied from Σ_xx, so its asymptotic block is the Isserlis block.
    phi_block_err = float(np.max(np.abs(av[np.ix_(range(15, 21), range(15, 21))] - v[np.ix_(xx, xx)])))

    rng = np.random.default_rng(102)
    # One random symmetric increment checks the written Schur differential.
    raw = rng.normal(size=(6, 6))
    increment = 0.5 * (raw + raw.T)
    a, c, h = split_sigma(increment)
    step = 1e-6
    plus = split_sigma(sigma + step * increment)
    minus = split_sigma(sigma - step * increment)
    omega = lambda blocks: blocks[0] - blocks[1] @ np.linalg.inv(blocks[2]) @ blocks[1].T
    numeric_domega = (omega(plus) - omega(minus)) / (2 * step)
    analytic_domega = schur_differential(sigma, a, c, h)
    schur_err = float(np.max(np.abs(numeric_domega - analytic_domega)))

    moment_err = second_moment_control(rng, sigma, v)
    mc = monte_carlo(rng, sigma, theta, n=20000, reps=2000)
    mc_err = rel_frobenius(mc, av)
    endog = slice(0, 6)
    endog_err = rel_frobenius(mc[endog, endog], av[endog, endog])

    endogenous_names = ["b12", "b13", "b23", "v1", "v2", "v3"]
    report = {
        "point": "equation-7",
        "law": "mean-zero Gaussian, known-mean second moment",
        "coordinates": "vech lower triangle including diagonal, row i >= column j",
        "parameter_order": endogenous_names + [f"gamma_{i}{j}" for i in range(3) for j in range(3)]
        + [f"phi_{i}{j}" for i in range(3) for j in range(i + 1)],
        "finite_difference_step": 1e-6,
        "population_recovery_max_abs": recovery_err,
        "schur_differential_max_abs": schur_err,
        "phi_block_matches_isserlis_max_abs": phi_block_err,
        "second_moment_monte_carlo": {"reps": 20000, "n": 1, "relative_frobenius": moment_err},
        "plug_in_monte_carlo": {"reps": 2000, "n": 20000, "seed": 102,
                                "relative_frobenius": mc_err,
                                "endogenous_relative_frobenius": endog_err},
        "endogenous_asymptotic_variance": av[endog, endog].tolist(),
        "endogenous_asymptotic_sd": np.sqrt(np.diag(av[endog, endog])).tolist(),
    }
    out = Path(__file__).with_name("delta_check.json")
    out.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({
        "population_recovery_max_abs": recovery_err,
        "schur_differential_max_abs": schur_err,
        "phi_block_max_abs": phi_block_err,
        "second_moment_relative_frobenius": moment_err,
        "plug_in_relative_frobenius": mc_err,
        "endogenous_relative_frobenius": endog_err,
        "endogenous_sd": report["endogenous_asymptotic_sd"],
    }, indent=2))
    if schur_err > 1e-6 or phi_block_err > 1e-6 or moment_err > 0.08 or mc_err > 0.12:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
