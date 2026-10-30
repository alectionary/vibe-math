#!/usr/bin/env python3
"""Exact Wolfe refinement and a denominator-lattice rank-consistency gate."""
from pathlib import Path
from fractions import Fraction as Q
import argparse, hashlib, json, math, sys, time
import numpy as np
from flint import fmpq_mat
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from full_partner_projection_features import moment_target
from verify_projected_profile_moment_rows import point_vector
from weighted_matroid_separator import insert


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--seed', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=118)
    args = ap.parse_args()
    assert not args.output.exists() and 0 < args.seconds <= 118
    start = time.monotonic()
    seed = json.loads(args.seed.read_text()); assert seed['point_sha256'] == sha(args.point)
    owner = point_vector(args.point); p = owner[32]; q = [x/(16*p) for x in moment_target(owner)[55:]]
    D = math.lcm(*(x.denominator for x in q)); qn = [int(x*D) for x in q]
    X, Z = [[int(v, 16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz']
    ground = [j for j in range(720) if not ((X[512] & Z[j]).bit_count() % 2) and q[j] > 0]
    units = [j for j in range(720) if (X[512] & Z[j]).bit_count() % 2]
    pos = {j: i for i, j in enumerate(ground)}
    assert sum(qn[j] for j in ground) == 127*D and sum(qn[j] for j in units) == D
    bases = [seed['numerical_basis_archive'][i] for i in seed['final_numeric_active_columns']]
    weights = [Q(int(round(float(x)*(1 << 80))), 1 << 80) for x in seed['final_numeric_weights']]
    total = sum(weights); weights = [x/total for x in weights]
    assert min(weights) >= 0
    sources = {name: sha(ROOT/name) for name in ('physical-pool-source.json', 'pools/xcoords.txt', 'pools/zcoords.txt',
               'weighted_matroid_separator.py', 'full_partner_projection_features.py', 'verify_projected_profile_moment_rows.py')}
    frozen = {'status': 'FROZEN_EXACT_SINGLETON_WOLFE_REFINEMENT', 'point_sha256': sha(args.point),
              'seed_sha256': sha(args.seed), 'source_hashes': sources, 'producer_sha256': sha(Path(__file__)),
              'anchor_orbit': 32, 'seconds': args.seconds, 'conditional_probability': str(p),
              'lattice_denominator': str(D)}
    fp = args.output.with_suffix('.frozen.json'); assert not fp.exists(); fp.write_text(json.dumps(frozen, indent=2)+'\n')
    out = {**frozen, 'frozen_sha256': sha(fp), 'status': 'BOUNDED_INCONCLUSIVE', 'source_C16_answered': False,
           'physical_full_frame': False, 'rounds': []}
    reason = 'TIME_LIMIT'; historical = len(bases)
    for iteration in range(2000-len(bases)):
        if time.monotonic()-start >= args.seconds: break
        for minor in range(1000):
            if time.monotonic()-start >= args.seconds: break
            chosen_sets = list(map(set, bases))
            V = np.asarray([[int(j in chosen) for j in ground] for chosen in chosen_sets], dtype=np.int64)
            B = (V[1:]-V[0]).T
            G = B.T@B
            rhs = [Q(sum(int(B[i, k])*(qn[j]-int(V[0, i])*D) for i, j in enumerate(ground)), D)
                   for k in range(B.shape[1])]
            eta = fmpq_mat(G.tolist()).solve(fmpq_mat([[str(x)] for x in rhs]), algorithm='dixon')
            tail = [Q(str(eta[i, 0])) for i in range(B.shape[1])]
            alpha = [1-sum(tail)]+tail
            if min(alpha) >= 0:
                weights = alpha
                keep = [i for i, w in enumerate(weights) if w > 0]
                bases = [bases[i] for i in keep]; weights = [weights[i] for i in keep]
                break
            theta = min(weights[i]/(weights[i]-alpha[i]) for i in range(len(alpha)) if alpha[i] < 0)
            candidate = [(1-theta)*w+theta*a for w, a in zip(weights, alpha)]
            assert min(candidate) >= 0 and sum(candidate) == 1
            keep = [i for i, w in enumerate(candidate) if w > 0]
            bases = [bases[i] for i in keep]; weights = [candidate[i] for i in keep]
        if time.monotonic()-start >= args.seconds: break
        L = math.lcm(D, *(w.denominator for w in weights)); wn = [int(w*L) for w in weights]
        marginal = [0]*720
        for basis, w in zip(bases, wn):
            for j in basis: marginal[j] += w
        residual = [qn[j]*(L//D)-marginal[j] for j in ground]
        positive = sum(max(0, r) for r in residual)
        record = {'iteration': iteration, 'active_columns': len(bases), 'minor_cycles': minor+1,
                  'exact_positive_error': str(Q(positive, L)), 'lattice_scaled_error': str(Q(D*positive, L)),
                  'max_residual': float(max(map(abs, residual), default=0)/L)}
        out['rounds'].append(record)
        if D*positive < L:
            status = ('EXACT_SINGLETON_CONDITIONAL_BASIS_MIXTURE_CANDIDATE' if positive == 0
                      else 'EXACT_SINGLETON_RANK_LATTICE_CERTIFICATE_CANDIDATE')
            out.update(status=status, zero_bases=[{'indices': b, 'weight': str(w)} for b, w in zip(bases, weights)],
                       unit_probabilities=[{'index': j, 'probability': str(q[j])} for j in units if q[j]],
                       conditional_target=list(map(str, q)), exact_positive_error=str(Q(positive, L)),
                       lattice_scaled_error=str(Q(D*positive, L)))
            reason = 'EXACT_RANK_LATTICE_GATE_REQUIRES_INDEPENDENT_REPLAY'; break
        # Exact affine stationarity is checked before exact greedy pricing.
        scores = [sum(residual[pos[j]] for j in basis) for basis in bases]
        assert len(set(scores)) == 1
        order = sorted(ground, key=lambda j: (-residual[pos[j]], j)); rows, basis = {}, []
        for j in order:
            old = len(rows); insert(rows, Z[j])
            if len(rows) != old: basis.append(j)
            if len(basis) == 127: break
        assert len(basis) == 127
        support = sum(residual[pos[j]] for j in basis)
        value = Q(sum(residual[pos[j]]*qn[j] for j in ground), D)
        if value > support:
            prefix, rows, total = [], {}, 0
            for j in order:
                prefix.append(j); insert(rows, Z[j]); total += qn[j]
                if total > len(rows)*D:
                    out.update(status='EXACT_CONDITIONAL_RANK_CUT_CANDIDATE',
                               cut={'sector': 'T', 'anchor_orbit': 32, 'mandatory_index': None,
                                    'indices': sorted(prefix), 'bound': len(rows),
                                    'exact_violation': str(Q(total-len(rows)*D, D)*p)})
                    break
            assert 'cut' in out; reason = 'EXACT_PREFIX_RANK_VIOLATION'; break
        assert support > scores[0]
        bases.append(sorted(basis)); weights.append(Q(0)); historical += 1
        if iteration % 5 == 0:
            print(json.dumps({k: v for k, v in record.items() if k != 'exact_positive_error'}), flush=True)
    out.update(stopping_reason=reason, elapsed_seconds=time.monotonic()-start, feature_columns=historical)
    assert all(sha(ROOT/name) == digest for name, digest in sources.items())
    args.output.write_text(json.dumps(out, indent=2)+'\n')
    print(json.dumps({k: out[k] for k in ('status', 'stopping_reason', 'elapsed_seconds', 'feature_columns')}))


if __name__ == '__main__':
    main()
