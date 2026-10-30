"""Joint fixed-law allocation discovery with independently accepted owner-star cuts.

Every semantic row is exact; numerical LP output requires exact recovery and a
separate consumer. A fixed-law contradiction is not a global moment exclusion.
The existing, reviewed local-face elimination is specific to this fixed law.
"""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm
import argparse
import gzip
import json
import time

import numpy as np
from scipy.linalg import qr
from scipy.optimize import linprog
from scipy.sparse import csr_matrix
from flint import fmpz_mat

from two_basis_structure_direct_allocation import (
    ROOT, sha, expr, plus, construct, evaluate, exact_check,
)
from two_basis_structure_direct_rank_closed import load_rows
from two_basis_structure import solve_unique
from verify_two_sided_full_basis_oracle import physical_source, target, point_owner


def read(path):
    path = Path(path)
    return json.loads(gzip.decompress(path.read_bytes()) if path.suffix == '.gz'
                      else path.read_bytes())


def shift(e, offset):
    return e[0], {j + offset: v for j, v in e[1].items()}


def compile_star(cut, E, lam, owner):
    assert cut['rhs'] == 0 and cut['side'] in ['X', 'Z']
    e = expr(sum(Q(v) * lam[m] for m, v in cut['lambda_coefficients']))
    e = plus(e, expr(sum(Q(v) * owner[j] for j, v in cut['T_coefficients'])))
    for side in ['X', 'Z']:
        for m, j, v in cut[side + '_coefficients']:
            assert type(v) is int and 0 <= m < 16 and 0 <= j < 720
            e = plus(e, E[side][m][j], Q(v))
    return e


def prepare(point, configs, star_bindings):
    X, Z, _ = physical_source()
    cfg = {s: read(p) for s, p in configs.items()}
    xx, zz = cfg['X']['X_anchors'], cfg['X']['Z_anchors']
    lam = list(map(Q, cfg['X']['lambda_masses']))
    assert min(lam) >= 0 and sum(lam) == 1
    assert all(not lam[m] for m in range(16) if m.bit_count() > 2)
    full = target(point, xx, zz)
    assert [sum(lam[m] for m in range(16) if m & t == t)
            for t in [0, 1, 2, 4, 8, 3, 5, 9, 6, 10, 12]] == full[:11]
    owner = point_owner(point)
    E, domains, wanted, rank_rows = {}, {}, {}, {}
    variables, equalities, inequalities, scales, labels = [], [], [], [], []
    sources = {str(point): sha(point)}
    for s, side in enumerate(['X', 'Z']):
        d = cfg[side]
        assert d['point_sha256'] == sha(point) and d['side'] == side
        assert (d['X_anchors'], d['Z_anchors']) == (xx, zz)
        assert list(map(Q, d['lambda_masses'])) == lam
        assert all(sha(ROOT / p) == h for p, h in d['source_hashes'].items())
        sources[str(configs[side])] = sha(configs[side])
        b = full[11 + 720*s:731 + 720*s] + [
            full[1451 + 1440*i + 720*s + j] for i in range(4) for j in range(720)]
        dd, ee, vv, eq, el, iq, meta, face, local = construct(X, Z, side, xx, zz, lam, b)
        rr, ss, bindings, omitted = load_rows(
            [Path(z['bank']) for z in d['rank_banks']],
            [Path(z['receipt']) for z in d['rank_banks']],
            X if side == 'X' else Z, dd, side, lam, xx, zz)
        assert rr == d['rank_rows'] and vv == d['variables']
        sources.update(ss)
        offset = len(variables)
        variables.extend([side, *v] for v in vv)
        E[side] = [[shift(e, offset) for e in row] for row in ee]
        domains[side], wanted[side], rank_rows[side] = dd, b, rr
        equalities.extend(shift(e, offset) for e in eq)
        for e, label in zip(iq, meta):
            inequalities.append(shift(e, offset))
            scales.append(lam[label[0]])
            labels.append([side, 'box', *label])
        for k, r in enumerate(rr):
            e = expr(-lam[r['mask']] * r['contraction_rank'])
            for j in r['indices']:
                e = plus(e, E[side][r['mask']][j])
            inequalities.append(e)
            scales.append(lam[r['mask']])
            labels.append([side, 'rank', k])
    star_count = 0
    for bank_path, receipt_path in star_bindings:
        bank, receipt = read(bank_path), read(receipt_path)
        assert receipt['status'] == 'PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS'
        assert receipt['bank_sha256'] == sha(bank_path)
        assert receipt['consumer_sha256'] == sha(ROOT / 'verify_conditional_owner_star.py')
        assert bank['X_anchors'] == xx and bank['Z_anchors'] == zz
        assert all(sha(ROOT / p) == h for p, h in receipt['source_hashes'].items())
        sources[str(bank_path)], sources[str(receipt_path)] = sha(bank_path), sha(receipt_path)
        for k, cut in enumerate(bank['cuts']):
            e = compile_star(cut, E, lam, owner)
            inequalities.append(e)
            # Fixed positive normalization only; no varying-lambda product.
            scales.append(max(Q(1), abs(e[0]), *map(abs, e[1].values())))
            labels.append(['star', str(bank_path), k])
            star_count += 1
    assert all(s > 0 for s in scales)
    return dict(E=E, domains=domains, wanted=wanted, rank_rows=rank_rows,
                variables=variables, equalities=equalities, inequalities=inequalities,
                scales=scales, labels=labels, lambda_masses=lam, X_anchors=xx,
                Z_anchors=zz, sources=sources, star_count=star_count)


def matrix(rows, n, scales=None, margin=False):
    rr, cc, vv, rhs = [], [], [], []
    for i, (c, terms) in enumerate(rows):
        scale = Q(1) if scales is None else scales[i]
        rhs.append(float(-c / scale))
        for j, v in terms.items():
            rr.append(i); cc.append(j); vv.append(float(v / scale))
        if margin and terms:
            rr.append(i); cc.append(n); vv.append(1.)
    return csr_matrix((vv, (rr, cc)), shape=(len(rows), n+1)), np.array(rhs)


def recover(model, numeric):
    n, eq = len(model['variables']), model['equalities']
    x = [Q(float(v)) for v in numeric[:n]]
    den = [lcm(*(z.denominator for z in [e[0], *e[1].values()])) for e in eq]
    A = [[int(e[1].get(j, 0)*d) for j in range(n)] for e, d in zip(eq, den)]
    rhs = [-e[0]*d for e, d in zip(eq, den)]
    rk = int(fmpz_mat(A).rank())
    _, _, ro = qr(np.array(A, dtype=float).T, pivoting=True, mode='economic')
    rows = list(map(int, ro[:rk]))
    _, _, co = qr(np.array(A, dtype=float)[rows], pivoting=True, mode='economic')
    cols = list(map(int, co[:rk]))
    res = [rhs[k] - sum(v*z for v, z in zip(A[k], x)) for k in rows]
    correction = solve_unique([[A[k][j] for j in cols] for k in rows], res)
    for j, v in zip(cols, correction):
        x[j] += v
    assert all(sum(v*z for v, z in zip(row, x)) == t for row, t in zip(A, rhs))
    failures, allocations = [], {}
    for side in ['X', 'Z']:
        y = evaluate(model['E'][side], x)
        failures.extend([side, *v] for v in exact_check(
            y, model['lambda_masses'], model['domains'][side], model['wanted'][side]))
        allocations[side] = [[str(v) for v in row] for row in y]
    gaps = [c + sum(v*x[j] for j, v in r.items()) for c, r in model['inequalities']]
    bad = [[i, str(v)] for i, v in enumerate(gaps) if v > 0]
    return dict(status='EXACT_JOINT_FIXED_ALLOCATION_REQUIRES_REPLAY' if not failures and not bad
                else 'EXACT_JOINT_FIXED_RECOVERY_FAILED',
                exact_allocations=allocations, exact_box_failures=failures,
                exact_inequality_failures=bad, minimum_exact_slack=str(-max(gaps)),
                equation_rank=rk, recovery_pivot_rows=rows, recovery_pivot_columns=cols,
                maximum_parameter_correction=str(max([Q(0), *map(abs, correction)])))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--x-config', type=Path, required=True)
    ap.add_argument('--z-config', type=Path, required=True)
    ap.add_argument('--star-bank', type=Path, action='append', default=[])
    ap.add_argument('--star-receipt', type=Path, action='append', default=[])
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=120)
    ap.add_argument('--prepare-only', action='store_true')
    args = ap.parse_args()
    assert len(args.star_bank) == len(args.star_receipt) and 0 < args.seconds <= 120
    prefix = args.output.with_suffix('')
    frozen_path = prefix.with_suffix('.frozen.json')
    assert not args.output.exists() and not frozen_path.exists()
    start = time.monotonic()
    model = prepare(args.point, dict(X=args.x_config, Z=args.z_config),
                    list(zip(args.star_bank, args.star_receipt)))
    n = len(model['variables'])
    Aub, bub = matrix(model['inequalities'], n, model['scales'], True)
    Aeq, beq = matrix(model['equalities'], n)
    sources = dict(model['sources'])
    sources['two_basis_joint_fixed_star.py'] = sha(Path(__file__))
    frozen = dict(status='FROZEN_JOINT_FIXED_LAW_OWNER_STAR_ALLOCATION_GATE',
                  point=str(args.point), point_sha256=sha(args.point), source_hashes=sources,
                  X_anchors=model['X_anchors'], Z_anchors=model['Z_anchors'],
                  lambda_masses=list(map(str, model['lambda_masses'])),
                  variables=model['variables'], variable_count=n,
                  equation_count=len(model['equalities']), inequality_count=len(model['inequalities']),
                  star_cut_count=model['star_count'], seconds=args.seconds,
                  x_config=str(args.x_config), z_config=str(args.z_config),
                  star_banks=[dict(bank=str(b), receipt=str(r))
                              for b, r in zip(args.star_bank, args.star_receipt)],
                  scope='Fixed chosen anchor law only. No global moment or source exclusion.')
    frozen_path.write_text(json.dumps(frozen, indent=2) + '\n')
    print('PREPARED', n, len(model['equalities']), len(model['inequalities']),
          model['star_count'], flush=True)
    out = dict(status='JOINT_FIXED_LAW_PREPARED', frozen_sha256=sha(frozen_path))
    if not args.prepare_only:
        c = np.zeros(n+1); c[-1] = -1
        lp = linprog(c, A_ub=Aub, b_ub=bub, A_eq=Aeq, b_eq=beq,
                     bounds=[(None, None)]*n + [(0, .5)], method='highs-ipm',
                     options=dict(presolve=False, time_limit=args.seconds,
                                  primal_feasibility_tolerance=1e-10,
                                  dual_feasibility_tolerance=1e-10,
                                  ipm_optimality_tolerance=1e-10))
        out.update(status='JOINT_FIXED_LAW_NUMERICAL_INCONCLUSIVE',
                   numerical_status=int(lp.status), numerical_message=lp.message,
                   iterations=int(lp.nit), numerical_margin=None if lp.x is None else float(lp.x[-1]))
        if lp.x is not None:
            np.savez_compressed(prefix.with_suffix('.numeric.npz'), x=lp.x)
            try:
                out.update(recover(model, lp.x))
            except (AssertionError, ValueError, ZeroDivisionError) as error:
                out['exact_recovery_error'] = str(error)
    assert all(sha(ROOT / p) == h for p, h in sources.items())
    out['elapsed_seconds'] = time.monotonic() - start
    args.output.write_text(json.dumps(out, indent=2) + '\n')
    print({k: v for k, v in out.items() if k not in
           ['exact_allocations', 'exact_box_failures', 'exact_inequality_failures']}, flush=True)


if __name__ == '__main__':
    main()
