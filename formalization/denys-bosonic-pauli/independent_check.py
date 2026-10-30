"""Fock-basis/channel check of Denys Figure 3.2, independent of replicate.py.

Shares thesis code definitions and the recovery objective, not constellation,
Gram-matrix, group-list, channel or SDP-construction implementation. Uses SCS
instead of Clarabel. Finite Fock and Kraus cutoffs are explicit approximations.
"""
import argparse
import json
import time
from pathlib import Path

import cvxpy as cp
import numpy as np
from scipy.linalg import svd
from scipy.special import gammaln, comb
from scipy.stats import poisson

ROOT = Path(__file__).resolve().parent
ALPHAS = np.linspace(.1, 2.5, 50)[[8, 17, 29, 39]]
CASES = ('equal', 'imaginary', 'extended')


def fock_encoding(case, alpha, cutoff):
    """Odd/even cats (3.60–61); central phase projection for extended group."""
    theta = {'equal': 0, 'imaginary': np.pi/2, 'extended': np.pi/4}[case]
    n = np.arange(cutoff+1)
    amplitude = np.exp(-alpha**2/2 + n*np.log(alpha)-gammaln(n+1)/2)
    state = np.outer(amplitude, amplitude*np.exp(1j*n*theta))
    allowed = (n[:, None] % 2 == 1) & (n[None, :] % 2 == 0)
    if case == 'extended':
        # Sum over central phases 1,i,-1,-i keeps total photon number 1 mod 4.
        allowed &= (n[:, None]+n[None, :]) % 4 == 1
    state *= allowed
    probability = float(np.linalg.norm(state)**2)
    state /= np.sqrt(probability)
    encoding = np.stack([state, state.T], axis=-1)
    fock_tail = min(1., 2*poisson.sf(cutoff, alpha**2)/probability)
    return encoding, dict(projector_probability_lower=probability,
                         fock_tail_probability_bound=float(fock_tail),
                         encoding_trace_distance_bound=float(2*np.sqrt(fock_tail)))


def kraus_images(encoding, loss, max_lost):
    """Apply binomial attenuation independently to the two Fock modes."""
    dim = encoding.shape[0]
    images = []
    for first in range(max_lost+1):
        for second in range(max_lost+1-first):
            if first >= dim or second >= dim:
                continue
            n1, n2 = np.arange(first, dim), np.arange(second, dim)
            scale1 = np.sqrt(comb(n1, first)*loss**first*(1-loss)**(n1-first))
            scale2 = np.sqrt(comb(n2, second)*loss**second*(1-loss)**(n2-second))
            image = np.zeros_like(encoding)
            image[:dim-first, :dim-second, :] = (encoding[first:, second:, :]
                *scale1[:, None, None]*scale2[None, :, None])
            images.append(image.reshape(dim*dim, 2))
    return images


def fock_objective(case, alpha, cutoff=32, max_lost=8, loss=.01):
    encoding, info = fock_encoding(case, alpha, cutoff)
    images = kraus_images(encoding, loss, max_lost)
    columns = np.concatenate(images, axis=1)
    u, singular, _ = svd(columns, full_matrices=False)
    keep = singular > 1e-10
    basis = u[:, keep]
    compressed = [basis.conj().T@image for image in images]
    h = np.zeros((2*basis.shape[1],)*2, complex)
    for image in compressed:
        vector = image.T.reshape(-1)
        h += np.outer(vector, vector.conj())/4
    retained = sum(image.conj().T@image for image in images)
    info.update(cutoff_per_mode=cutoff, maximum_total_lost=max_lost,
        retained_output_dimension=int(keep.sum()),
        discarded_singular_weight=float(np.sum(singular[~keep]**2)),
        channel_trace_deficit=float(np.max(np.abs(np.eye(2)-retained))),
        loss_tail_probability_bound=float(poisson.sf(max_lost, 2*alpha**2*loss)
                                          /info['projector_probability_lower']))
    return h, info


def optimize(h):
    """Independently assembled SCS recovery SDP; no imported solver wrapper."""
    physical = len(h)//2
    recovery = cp.Variable((2*physical, 2*physical), hermitian=True)
    trace_constraints = []
    for i in range(physical):
        for j in range(physical):
            trace_constraints.append(recovery[i,j]+recovery[physical+i,physical+j]
                                     == float(i == j))
    problem = cp.Problem(cp.Maximize(cp.real(cp.sum(cp.multiply(h.T, recovery)))),
                         [recovery >> 0]+trace_constraints)
    start = time.perf_counter()
    value = problem.solve(solver='SCS', eps=2e-9, max_iters=150000)
    if recovery.value is None:
        raise RuntimeError(problem.status)
    matrix = recovery.value
    return dict(fidelity=float(value), infidelity=float(1-value),
        status=problem.status, solver='SCS', seconds=time.perf_counter()-start,
        iterations=problem.solver_stats.num_iters,
        recovery_min_eigenvalue=float(np.linalg.eigvalsh(matrix)[0]),
        trace_constraint_residual=float(np.max(abs(matrix[:physical,:physical]
                                    +matrix[physical:,physical:]-np.eye(physical)))))


def limiting_checks():
    identity_vec = np.eye(2).T.reshape(-1)
    identity = np.outer(identity_vec, identity_vec)/4
    # Replacement maps both logical inputs to the same one-dimensional output.
    replacement = np.eye(2)/4
    a, b = optimize(identity), optimize(replacement)
    assert abs(a['fidelity']-1) < 1e-7
    assert abs(b['fidelity']-.25) < 1e-7
    no_loss_h, _ = fock_objective('extended', .9, cutoff=4, max_lost=0, loss=0)
    full_loss_h, _ = fock_objective('extended', .9, cutoff=4, max_lost=8, loss=1)
    no_loss, full_loss = optimize(no_loss_h), optimize(full_loss_h)
    assert abs(no_loss['fidelity']-1) < 1e-7
    assert abs(full_loss['fidelity']-.25) < 1e-7
    return dict(identity_expected=1, identity=a, replacement_expected=.25, replacement=b,
                fock_no_loss=no_loss, fock_full_loss=full_loss,
                fock_limit_scope='Normalized finite cutoff=4 code, all possible photon losses included at loss=1.')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--pilot', action='store_true')
    parser.add_argument('--cutoff', type=int, default=32)
    parser.add_argument('--max-lost', type=int, default=8)
    parser.add_argument('--output', default='outputs/independent.json')
    args = parser.parse_args()
    record = dict(method='Fock encoding + binomial loss Kraus + SVD + SCS',
        independence_limit='Shared thesis definitions, CVXPY frontend, and scientific objective; independent encoding, channel, and constraint construction.',
        limiting_checks=limiting_checks(), rows=[])
    for alpha in ([ALPHAS[-1]] if args.pilot else ALPHAS):
        for case in CASES:
            start = time.perf_counter()
            h, info = fock_objective(case, alpha, args.cutoff, args.max_lost)
            row = dict(case=case, alpha=float(alpha), loss=.01, **info, **optimize(h))
            row['total_seconds'] = time.perf_counter()-start
            record['rows'].append(row)
            print(json.dumps(row), flush=True)
            (ROOT/args.output).write_text(json.dumps(record, indent=2)+'\n')


if __name__ == '__main__':
    main()
