#!/usr/bin/env python3
"""Bounded shared higher-moment consistency across a frozen family of quads.

The exact finite row model is necessary only. It omits coupled cardinalities,
matroid ranks and unanchored mutual pairing. Numerical outcomes are not proofs.
"""
from pathlib import Path
from fractions import Fraction as Q
from functools import lru_cache
from collections import Counter
import argparse
import datetime
import gzip
import hashlib
import json
import sys
import time

import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csr_matrix, hstack
import two_basis_structure_zonotope as local
from two_basis_structure import HIGH
from verify_algebraic_model import physical
from verify_two_sided_anchor_count import domain
from run_integer_coupling_trial import local_imports

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def canonical_monomial(events):
    assert len(events) == len(set(events)) and len(events) in (3, 4)
    choices = []
    for swap in (0, 1):
        for shift in range(16):
            moved = []
            for event in events:
                sector, j = divmod(event, 720)
                orbit, phase = divmod(j, 16)
                moved.append(720*(sector ^ swap)+16*orbit+(phase+shift) % 16)
            choices.append(tuple(sorted(moved)))
    return min(choices)


def jsonable(v):
    if isinstance(v, Q):
        return str(v)
    if isinstance(v, dict):
        return {k: jsonable(x) for k, x in v.items()}
    if isinstance(v, (list, tuple)):
        return [jsonable(x) for x in v]
    return v


def write(p, v):
    raw = (json.dumps(jsonable(v), indent=2)+'\n').encode()
    Path(p).write_bytes(gzip.compress(raw, mtime=0) if str(p).endswith('.gz') else raw)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--prefix', type=Path, required=True)
    ap.add_argument('--X-additional', type=int, nargs='+', default=[512, 432, 434, 496])
    ap.add_argument('--Z-additional', type=int, nargs='+', default=[433, 514, 432, 512])
    ap.add_argument('--seconds', type=float, default=60)
    a = ap.parse_args()
    assert 0 < a.seconds <= 60
    assert len(set(a.X_additional)) == len(a.X_additional)
    assert len(set(a.Z_additional)) == len(a.Z_additional)
    assert 80 not in a.X_additional and 186 not in a.Z_additional
    assert all(0 <= j < 720 for j in a.X_additional+a.Z_additional)
    output = Path(str(a.prefix)+'.json.gz')
    frozen = Path(str(a.prefix)+'.frozen.json')
    assert not output.exists() and not frozen.exists()
    quads = [([80, i], [186, j]) for i in a.X_additional for j in a.Z_additional]
    sources = set()
    local_imports(Path(__file__).resolve(), sources)
    paths = [str(p.relative_to(ROOT)) for p in sorted(sources)]
    paths += ['physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
              'algebraic-results/hulls-16-rank.json.gz',
              'moment-resumption-results/symmetry-bridge-independent.json']
    hashes = {p: sha(ROOT/p) for p in paths}
    manifest = dict(status='FROZEN_SHARED_HIGHER_MOMENT_GATE', source_C16_answered=False,
                    utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                    point_c16_path=str(a.point.resolve().relative_to(ROOT)), point_sha256=sha(a.point),
                    quads=quads, source_hashes=hashes, solver_seconds=a.seconds,
                    command=[sys.executable, *sys.argv],
                    scope='Finite local-box rows with shared32-action higher moments; no full-basis or source-frame membership.')
    write(frozen, manifest)
    start = time.monotonic()
    X, Z, _ = physical()
    # Pure cache: generator-status facets depend only on this immutable tuple.
    local.status_normals = lru_cache(None)(local.status_normals)
    labels = {}
    rows = []
    records = []
    for number, (xx, zz) in enumerate(quads):
        assert all(domain(X, Z, xx, zz, m) is not None for m in range(16)), 'Initial prototype requires all16 count domains'
        tar = local.moment_target(a.point, xx, zz)
        original, classes = local.construct(X, Z, xx, zz, tar)
        anchors = [*xx, *[720+j for j in zz]]
        ids = []
        for subset in HIGH:
            label = canonical_monomial([e for k, e in enumerate(anchors) if subset >> k & 1])
            if label not in labels:
                labels[label] = len(labels)
            ids.append(labels[label])
        for index, row in enumerate(original):
            coefficients = Counter()
            for i, v in zip(ids, row['a']):
                coefficients[i] += v
            row_terms = sorted((i, v) for i, v in coefficients.items() if v)
            rows.append(dict(quad=number, local_index=index, terms=row_terms, rhs=row['b'], provenance=row))
        records.append(dict(X_anchors=xx, Z_anchors=zz, high_variable_indices=ids,
                            rows=len(original), classes=len(classes), all16_count_domains=True))
        print(json.dumps(dict(quad=number, rows=len(original), variables=len(labels), seconds=time.monotonic()-start)), flush=True)
    fixed_bad = [i for i, row in enumerate(rows) if not row['terms'] and row['rhs'] < 0]
    keep = [i for i, row in enumerate(rows) if row['terms']]
    ii, jj, vv = [], [], []
    for k, i in enumerate(keep):
        for j, v in rows[i]['terms']:
            ii.append(k); jj.append(j); vv.append(v)
    A = csr_matrix((np.array(vv, dtype=np.int64), (ii, jj)), shape=(len(keep), len(labels)))
    rhs = np.array([float(rows[i]['rhs']) for i in keep])
    solution = dict(status='NOT_RUN')
    if fixed_bad:
        solution = dict(status='EXACT_CONSTANT_ROW_OBSTRUCTION_CANDIDATE', row=fixed_bad[0])
    else:
        mat = hstack([A, np.ones((A.shape[0], 1))], format='csr')
        t = time.monotonic()
        lp = linprog(np.r_[np.zeros(len(labels)), -1.0], A_ub=mat, b_ub=rhs,
                     bounds=[(0, 1)]*len(labels)+[(None, None)], method='highs',
                     options={'presolve': False, 'time_limit': a.seconds,
                              'primal_feasibility_tolerance': 1e-9, 'dual_feasibility_tolerance': 1e-9})
        solution = dict(status='NUMERICAL_SHARED_MODEL_INCONCLUSIVE', solver_status=int(lp.status),
                        message=lp.message, solver_seconds=time.monotonic()-t,
                        numeric_margin=float(lp.x[-1]) if lp.x is not None else None)
        if lp.x is not None:
            solution['numeric_point'] = lp.x.tolist()
            for denominator in (1 << 24, 1 << 32, 1 << 40, 1 << 48, 1 << 56):
                candidate = [Q(float(x)).limit_denominator(denominator) for x in lp.x[:-1]]
                slacks = [r['rhs']-sum(v*candidate[j] for j, v in r['terms']) for r in rows]
                if all(0 <= x <= 1 for x in candidate) and min(slacks) >= 0:
                    solution.update(status='EXACT_FEASIBLE_SHARED_LOCAL_ROWS_CANDIDATE',
                                    higher_moments=candidate, minimum_exact_slack=min(slacks),
                                    rounding_denominator_cap=denominator)
                    break
        if lp.status == 0:
            numeric_z = -np.asarray(lp.ineqlin.marginals)
            solution['numeric_dual_nonzero'] = [[keep[k], float(v)] for k, v in enumerate(numeric_z) if v > 0]
            for scale in (1 << 16, 1 << 24, 1 << 32, 1 << 40):
                z = [max(0, int(round(float(v)*scale))) for v in numeric_z]
                residual = [0]*len(labels)
                value = Q(0)
                for i, weight in zip(keep, z):
                    value += weight*rows[i]['rhs']
                    for j, v in rows[i]['terms']:
                        residual[j] += weight*v
                lower = sum(min(0, v) for v in residual)
                if value < lower:
                    assert solution['status'] != 'EXACT_FEASIBLE_SHARED_LOCAL_ROWS_CANDIDATE'
                    solution.update(status='EXACT_SHARED_LOCAL_ROW_OBSTRUCTION_CANDIDATE',
                                    multipliers=[[i, w] for i, w in zip(keep, z) if w],
                                    residual=residual, exact_combined_rhs=value, residual_box_lower=lower,
                                    exact_contradiction_gap=lower-value)
                    break
    assert all(sha(ROOT/p) == h for p, h in hashes.items())
    out = {**manifest, 'status': solution['status'], 'frozen_sha256': sha(frozen),
           'shared_variable_monomials': [list(k) for k, _ in sorted(labels.items(), key=lambda item: item[1])],
           'uncoupled_high_variables': 5*len(quads), 'shared_high_variables': len(labels),
           'quad_records': records, 'rows': rows, 'solution': solution, 'seconds': time.monotonic()-start,
           'status_facet_cache': local.status_normals.cache_info()._asdict()}
    write(output, out)
    print(json.dumps(dict(status=out['status'], quads=len(quads), rows=len(rows), variables=len(labels),
                          numeric_margin=solution.get('numeric_margin'), seconds=out['seconds'])), flush=True)


if __name__ == '__main__':
    main()
