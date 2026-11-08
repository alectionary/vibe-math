"""Bounded exact screen: append one selected opposite anchor to a basis domain.

An impossible augmented opposite-sector basis domain forces the probe's
conditional allocation to zero. This is a source-structural implication, not
a full-frame search. Every numerical or incomplete negative screen is avoided.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse
import json
import time

from verify_two_sided_full_basis_oracle import (
    ROOT, sha, read, physical_source, sector_domain, rank,
)


def literal_bases(U, V, dim, own, forced, opposite):
    result = []
    for B in combinations(range(len(U)), dim):
        if rank(U[j] for j in B) != dim:
            continue
        if not set(forced) <= set(B) or (set(own)-set(forced)) & set(B):
            continue
        A = [[(U[j] & V[i]).bit_count() % 2 for i in opposite] for j in B]
        if all(sum(row) <= 1 for row in A) and all(
                sum(row[k] for row in A) == 1 for k in range(len(opposite))):
            result.append(B)
    return result


def controls():
    U = list(range(1, 8))
    checks, feasible = 0, 0
    for own in [[0, 1], [2, 3]]:
        for ownmask in range(4):
            forced = [j for k, j in enumerate(own) if ownmask >> k & 1]
            for k in range(4):
                for opposite in combinations(range(7), k):
                    d = sector_domain(U, U, 3, own, forced, opposite)
                    bases = literal_bases(U, U, 3, own, forced, opposite)
                    assert d['feasible'] == bool(bases)
                    if d['feasible']:
                        feasible += 1
                        allowed = set(d['zero_forced'] + d['zero_free'] +
                                      [j for b in d['bins'] for j in b])
                        for B in bases:
                            assert set(B) <= allowed
                            assert sum(j in d['zero_forced'] + d['zero_free'] for j in B) == d['zero_required']
                            assert all(len(set(B) & set(b)) == 1 for b in d['bins'])
                    checks += 1
    return dict(exhaustive_dimension3_domain_checks=checks,
                feasible_domains=feasible, physical_full_bases_per_domain=35)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--x-allocation', type=Path, required=True)
    ap.add_argument('--z-allocation', type=Path, required=True)
    ap.add_argument('--x-config', type=Path, required=True)
    ap.add_argument('--z-config', type=Path, required=True)
    ap.add_argument('--output', type=Path, required=True)
    ap.add_argument('--seconds', type=float, default=120)
    a = ap.parse_args()
    assert 0 < a.seconds <= 120 and not a.output.exists()
    control = controls()
    X, Z, _ = physical_source()
    configs = {s: read(p) for s, p in [('X', a.x_config), ('Z', a.z_config)]}
    xx, zz = configs['X']['X_anchors'], configs['X']['Z_anchors']
    assert (xx, zz) == (configs['Z']['X_anchors'], configs['Z']['Z_anchors'])
    lam = list(map(Q, configs['X']['lambda_masses']))
    assert lam == list(map(Q, configs['Z']['lambda_masses']))
    allocation = {s: [[Q(v) for v in row] for row in read(p)['exact_allocations']]
                  for s, p in [('X', a.x_allocation), ('Z', a.z_allocation)]}
    paths = [Path(__file__), Path('verify_two_sided_full_basis_oracle.py'),
             Path('verify_algebraic_model.py'), Path('physical-pool-source.json'),
             Path('pools/xcoords.txt'), Path('pools/zcoords.txt'),
             a.x_allocation, a.z_allocation, a.x_config, a.z_config]
    sources = {str(p): sha(p) for p in paths}
    frozen_path = a.output.with_suffix('.frozen.json')
    assert not frozen_path.exists()
    frozen_path.write_text(json.dumps(dict(
        source_hashes=sources, X_anchors=xx, Z_anchors=zz,
        seconds=a.seconds, deterministic_order='side X,Z; probe0..719;mask0..15',
        probe_scope='Unanchored probes with positive supplied conditional allocation only',
        proof_rule='No full opposite basis satisfying an extra selected probe implies y[mask,probe]=0',
        scope='A missing domain excludes an allocation coordinate only; no source answer.'), indent=2)+'\n')
    start = time.monotonic()
    examined = []
    cuts = []
    capped = False
    for side in ['X', 'Z']:
        own, opposite_anchors = (zz, xx) if side == 'X' else (xx, zz)
        U, V = (Z, X) if side == 'X' else (X, Z)
        ownbits, oppositebits = (2, 0) if side == 'X' else (0, 2)
        for probe in range(720):
            if probe in opposite_anchors:
                continue
            for m in range(16):
                value = allocation[side][m][probe]
                if not value:
                    continue
                if time.monotonic()-start > a.seconds:
                    capped = True
                    break
                forced = [j for k, j in enumerate(own) if m >> (ownbits+k) & 1]
                selected = [j for k, j in enumerate(opposite_anchors) if m >> (oppositebits+k) & 1]
                d = sector_domain(U, V, 128, own, forced, [*selected, probe])
                examined.append([side, probe, m, d['feasible'], d['reason']])
                if not d['feasible']:
                    cuts.append(dict(side=side, probe=probe, mask=m,
                                     exact_violation=str(value), domain=d))
            if capped:
                break
        if capped:
            break
    out = dict(status='EXACT_AUGMENTED_OWNER_DOMAIN_SCREEN_REQUIRES_REPLAY',
               frozen_sha256=sha(frozen_path), source_hashes=sources,
               controls=control, examined=examined, cuts=cuts,
               source_answered=False, completed_requested_positive_coordinates=not capped,
               elapsed_seconds=time.monotonic()-start)
    assert all(sha(ROOT/p) == h for p, h in sources.items())
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(dict(examined=len(examined), cuts=len(cuts), capped=capped,
               elapsed_seconds=out['elapsed_seconds']), flush=True)


if __name__ == '__main__':
    main()
