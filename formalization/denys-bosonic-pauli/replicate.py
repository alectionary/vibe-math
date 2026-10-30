"""Independent coherent-span reconstruction of Denys (2024), Figure 3.2.

Original implementation from the stated group action and pure-loss channel;
no upstream code is copied. See README.md for scope and commands.
"""
import argparse
import json
import time
from pathlib import Path

import cvxpy as cp
import numpy as np
from scipy.linalg import eigh

ROOT = Path(__file__).resolve().parent
CASES = ('equal', 'imaginary', 'extended')
ALPHAS = np.linspace(.1, 2.5, 50)[[8, 17, 29, 39]]


def gram(points):
    norms = np.sum(abs(points)**2, axis=1)
    return np.exp(points.conj() @ points.T - (norms[:, None]+norms[None, :])/2)


def sqrt_psd(matrix):
    vals, vecs = eigh((matrix+matrix.conj().T)/2)
    if vals.min() < -1e-10:
        raise ValueError('not positive semidefinite')
    return (vecs*np.sqrt(np.maximum(vals, 0))) @ vecs.conj().T


def constellation(case, alpha):
    """Group-average encoding, thesis (3.57), for all three Figure 3.2 arms."""
    x = np.array([[0, 1], [1, 0]], complex)
    z = np.diag([1, -1])
    generators = [np.eye(2), x, z, x@z]
    phases = [1, -1] if case != 'extended' else [1, 1j, -1, -1j]
    theta = dict(equal=0, imaginary=np.pi/2, extended=np.pi/4)[case]
    seed = alpha*np.array([1, np.exp(1j*theta)])
    points, coefficients = [], []
    for phase in phases:
        for base in generators:
            g = phase*base
            point = g@seed
            coeff = g[:, 0].conj().astype(complex)
            matches = [i for i, p in enumerate(points) if np.max(abs(p-point)) < 1e-12]
            if matches:
                coefficients[matches[0]] += coeff
            else:
                points.append(point)
                coefficients.append(coeff.copy())
    points, coefficients = np.array(points), np.array(coefficients)
    metric = coefficients.conj().T @ gram(points) @ coefficients
    w, v = eigh(metric)
    coefficients = coefficients @ ((v/np.sqrt(w))@v.conj().T)
    return points, coefficients


def coherent_channel(case, alpha, loss=.01):
    """Exact finite coherent span; environment overlap implements pure loss."""
    points, coeff = constellation(case, alpha)
    output = sqrt_psd(gram(np.sqrt(1-loss)*points))
    environment = gram(np.sqrt(loss)*points)
    blocks = [[output @ (np.outer(coeff[:, i], coeff[:, j].conj()) * environment.T)
               @ output.conj().T for j in range(2)] for i in range(2)]
    # H yields F=Tr(J H) for recovery-adjoint J with partial logical trace I.
    h = np.block(blocks)/4
    diagnostics = dict(constellation_size=len(points),
        encoding_gram_error=float(np.max(abs(coeff.conj().T@gram(points)@coeff-np.eye(2)))),
        channel_trace=float(np.trace(h).real),
        h_min_eigenvalue=float(eigh(h, eigvals_only=True)[0]))
    return (h+h.conj().T)/2, diagnostics


def solve_recovery(h, solver='CLARABEL', tolerance=1e-9):
    """Primal/dual SDP with numerical feasibility repair and objective bracket."""
    start = time.perf_counter()
    n = h.shape[0]//2
    j = cp.Variable((2*n, 2*n), hermitian=True)
    equality = j[:n, :n]+j[n:, n:] == np.eye(n)
    problem = cp.Problem(cp.Maximize(cp.real(cp.trace(h@j))), [j >> 0, equality])
    options = (dict(tol_gap_abs=tolerance, tol_gap_rel=tolerance, tol_feas=tolerance,
                    max_iter=300) if solver == 'CLARABEL' else
               dict(eps=tolerance, max_iters=200000))
    value = problem.solve(solver=solver, **options)
    if j.value is None:
        raise RuntimeError(problem.status)
    primal = (j.value+j.value.conj().T)/2
    w, v = eigh(primal)
    repaired = (v*np.maximum(w, 0))@v.conj().T
    b = repaired[:n, :n]+repaired[n:, n:]
    wb, vb = eigh(b)
    whitening = np.kron(np.eye(2), (vb/np.sqrt(wb))@vb.conj().T)
    repaired = whitening@repaired@whitening
    y = equality.dual_value
    y = (y+y.conj().T)/2
    dual_min = eigh(np.kron(np.eye(2), y)-h, eigvals_only=True)[0]
    y = y + np.eye(n)*max(0, -dual_min+1e-12)
    lower = float(np.trace(h@repaired).real)
    upper = float(np.trace(y).real)
    return dict(solver=solver, status=problem.status, fidelity=float(value),
        infidelity=float(1-value), fidelity_lower=lower, fidelity_upper=upper,
        numerical_gap=upper-lower, primal_min_eigenvalue=float(w[0]),
        primal_trace_residual=float(np.max(abs(primal[:n,:n]+primal[n:,n:]-np.eye(n)))),
        repaired_trace_residual=float(np.max(abs(repaired[:n,:n]+repaired[n:,n:]-np.eye(n)))),
        dual_min_eigenvalue_before_repair=float(dual_min), seconds=time.perf_counter()-start)


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--pilot', action='store_true')
    p.add_argument('--solver', default='CLARABEL', choices=['CLARABEL', 'SCS'])
    p.add_argument('--output', default='outputs/primary.json')
    a = p.parse_args()
    rows = []
    for alpha in ([ALPHAS[-1]] if a.pilot else ALPHAS):
        for case in CASES:
            h, diagnostics = coherent_channel(case, alpha)
            row = dict(case=case, alpha=float(alpha), loss=.01, **diagnostics,
                       **solve_recovery(h, a.solver))
            rows.append(row)
            print(json.dumps(row), flush=True)
            (ROOT/a.output).write_text(json.dumps(rows, indent=2)+'\n')


if __name__ == '__main__':
    main()
