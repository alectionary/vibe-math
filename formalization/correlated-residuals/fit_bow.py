#!/usr/bin/env python3
"""Plug-in fit of the equation-(7) bow-free specification.

The printed wheat coefficients are equation (7). Figure 5 also draws arrows
into GYLD; those arrows are not a matrix in the paper, so they are not used
here. The fitted model is the bow that drops the direct edge 2 → 0 (the
equation-(7) entry b13) and frees the residual covariance ψ02. The remaining
structural coefficients, Γ, the diagonal residual entries, and Φ = I are the
printed values, with b13 set to 0. The freed covariance is 1/2, which keeps
the residual matrix positive definite (the PD bound is |ψ02| < 2).

Samples are mean-zero Gaussian. The estimator is the closed form `recoverBow`
in `CorrelatedResiduals/BowFree.lean`, applied to the known-mean second-moment
matrix. Standard errors are the delta method: √n (ρ(Ŝ) − θ) has asymptotic
covariance J V Jᵀ, with V the Isserlis covariance of vech(zzᵀ) and J a
central-difference derivative of ρ.
"""

from __future__ import annotations

import json
from pathlib import Path

import numpy as np

from delta_method import isserlis, pack_vech, rel_frobenius, sample_cov, unpack_vech


def bow_population():
    """Printed equation-(7) coefficients with b13 removed and ψ02 = 1/2."""
    b12 = -1 / 2
    b23 = -1 / 2
    v1, v2, v3, c = 8 / 5, 9 / 5, 5 / 2, 1 / 2
    gamma = np.array(
        [
            [1 / 8, 1 / 4, 1 / 2],
            [1 / 2, 1 / 2, 1 / 2],
            [1 / 4, 1 / 8, 1 / 4],
        ],
        dtype=np.float64,
    )
    phi = np.eye(3, dtype=np.float64)
    eye = np.eye(3, dtype=np.float64)
    b = np.zeros((3, 3), dtype=np.float64)
    b[0, 1], b[1, 2] = b12, b23
    noise = np.array(
        [[v1, 0.0, c], [0.0, v2, 0.0], [c, 0.0, v3]],
        dtype=np.float64,
    )
    resolvent = np.linalg.inv(eye - b)
    yy = resolvent @ (gamma @ phi @ gamma.T + noise) @ resolvent.T
    yx = resolvent @ gamma @ phi
    sigma = np.block([[yy, yx], [yx.T, phi]])
    theta = np.concatenate(
        [
            np.array([b12, b23, v1, v2, v3, c], dtype=np.float64),
            gamma.reshape(-1, order="C"),
            pack_vech(phi),
        ]
    )
    return {
        "b12": b12,
        "b23": b23,
        "v1": v1,
        "v2": v2,
        "v3": v3,
        "c": c,
        "gamma": gamma,
        "phi": phi,
        "noise": noise,
        "sigma": sigma,
        "theta": theta,
    }


NAMES = (
    ["b12", "b23", "v1", "v2", "v3", "c"]
    + [f"gamma_{i}{j}" for i in range(3) for j in range(3)]
    + [f"phi_{i}{j}" for i in range(3) for j in range(i + 1)]
)


def recover_bow(sigma: np.ndarray) -> np.ndarray:
    """`recoverBow`: Schur complement, then the six-parameter inverse."""
    yy, yx, xx = sigma[:3, :3], sigma[:3, 3:], sigma[3:, 3:]
    phi_inv = np.linalg.inv(xx)
    omega = yy - yx @ phi_inv @ yx.T
    v3 = omega[2, 2]
    b23 = omega[1, 2] / v3
    den = omega[1, 1] * omega[2, 2] - omega[1, 2] ** 2
    v2 = den / v3
    b12 = (omega[0, 1] * omega[2, 2] - omega[0, 2] * omega[1, 2]) / den
    c = (omega[0, 2] * omega[1, 1] - omega[0, 1] * omega[1, 2]) * omega[2, 2] / den
    v1 = (
        omega[0, 0]
        - b12**2 * v2
        - 2 * b12 * b23 * c
        - b12**2 * b23**2 * v3
    )
    b = np.zeros((3, 3), dtype=np.float64)
    b[0, 1], b[1, 2] = b12, b23
    gamma = (np.eye(3) - b) @ yx @ phi_inv
    endogenous = np.array([b12, b23, v1, v2, v3, c], dtype=np.float64)
    return np.concatenate([endogenous, gamma.reshape(-1, order="C"), pack_vech(xx)])


def jacobian(sigma: np.ndarray, step: float = 1e-6) -> np.ndarray:
    base = pack_vech(sigma)
    dim = sigma.shape[0]
    eye = np.eye(base.size)
    columns = []
    for k in range(base.size):
        plus = recover_bow(unpack_vech(base + step * eye[k], dim))
        minus = recover_bow(unpack_vech(base - step * eye[k], dim))
        columns.append((plus - minus) / (2 * step))
    return np.column_stack(columns)


def asymptotic_variance(sigma: np.ndarray) -> np.ndarray:
    jac = jacobian(sigma)
    cov = isserlis(sigma)
    return jac @ cov @ jac.T


def fit_once(rng: np.random.Generator, sigma: np.ndarray, n: int) -> np.ndarray:
    draws = rng.multivariate_normal(np.zeros(6), sigma, size=n, check_valid="ignore")
    moment = draws.T @ draws / n
    return recover_bow(moment)


def main():
    spec = bow_population()
    sigma = spec["sigma"]
    theta = spec["theta"]
    noise_eigs = np.linalg.eigvalsh(spec["noise"])
    if np.min(noise_eigs) <= 0:
        raise SystemExit(f"residual matrix is not positive definite: {noise_eigs}")
    sigma_eigs = np.linalg.eigvalsh(sigma)
    if np.min(sigma_eigs) <= 1e-10:
        raise SystemExit(f"joint covariance is not positive definite: {sigma_eigs}")

    recovered = recover_bow(sigma)
    recovery_err = float(np.max(np.abs(recovered - theta)))
    if not np.isfinite(recovery_err) or recovery_err > 1e-8:
        raise SystemExit(f"population recovery failed: {recovery_err}")

    av = asymptotic_variance(sigma)
    asy_var = np.diag(av)
    if np.any(asy_var < -1e-8):
        raise SystemExit("delta-method variance has a negative diagonal")
    asy_sd = np.sqrt(np.maximum(asy_var, 0.0))

    n_fit = 5000
    rng = np.random.default_rng(102)
    estimate = fit_once(rng, sigma, n_fit)
    se = asy_sd / np.sqrt(n_fit)

    n_mc, reps = 4000, 800
    draws = []
    for _ in range(reps):
        draws.append(np.sqrt(n_mc) * (fit_once(rng, sigma, n_mc) - theta))
    mc = sample_cov(np.asarray(draws))
    endog = slice(0, 6)
    endog_err = rel_frobenius(mc[endog, endog], av[endog, endog])

    rows = []
    for name, truth, est, one_se, sd in zip(NAMES, theta, estimate, se, asy_sd):
        rows.append(
            {
                "name": name,
                "truth": float(truth),
                "estimate": float(est),
                "delta_method_se": float(one_se),
                "asymptotic_sd": float(sd),
            }
        )

    report = {
        "specification": (
            "equation-(7) bow: drop edge 2→0 (b13 = 0), free ψ02 = 1/2; "
            "remaining coefficients are the printed equation-(7) values; Φ = I. "
            "Figure 5 GYLD arrows are not in the printed matrix and are not fitted."
        ),
        "law": "mean-zero Gaussian, known-mean second moment S = n^{-1} Σ zzᵀ",
        "n_fit": n_fit,
        "seed": 102,
        "population_recovery_max_abs": recovery_err,
        "noise_eigenvalues": noise_eigs.tolist(),
        "fit": rows,
        "monte_carlo": {
            "n": n_mc,
            "reps": reps,
            "endogenous_relative_frobenius": endog_err,
            "endogenous_names": NAMES[:6],
            "endogenous_mc_sd": np.sqrt(np.diag(mc[endog, endog])).tolist(),
            "endogenous_asymptotic_sd": asy_sd[:6].tolist(),
        },
    }
    out = Path(__file__).with_name("fit_bow.json")
    out.write_text(json.dumps(report, indent=2) + "\n")
    summary = {
        "population_recovery_max_abs": recovery_err,
        "endogenous_relative_frobenius": endog_err,
        "fit": [
            {
                "name": row["name"],
                "estimate": row["estimate"],
                "se": row["delta_method_se"],
            }
            for row in rows
            if row["name"] in NAMES[:6]
        ],
    }
    print(json.dumps(summary, indent=2))
    if endog_err > 0.15:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
