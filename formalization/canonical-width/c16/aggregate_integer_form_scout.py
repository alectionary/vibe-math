#!/usr/bin/env python3
"""Bounded LLL discovery of integer-form inequalities on phase-class counts.

For a literal integer count vector N, every integer affine L=c+w.N obeys
L(L-1)>=0. A lattice embedding proposes coefficients; exact rational target
evaluation accepts a proposal. This is not complete separation or a source
infeasibility certificate. A separate physical-coordinate consumer is required.
"""
from pathlib import Path
from fractions import Fraction
import argparse, datetime, gzip, hashlib, json, math, time
from flint import fmpz_mat
from physical_integer_form_rows import coordinate

ROOT = Path(__file__).resolve().parent


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--point', type=Path, required=True)
    ap.add_argument('--phase-modulus', type=int, choices=[1, 2, 4], required=True)
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    assert not a.output.exists()
    start = time.monotonic()
    q = a.phase_modulus
    n = 16 // q
    values = list(map(Fraction, json.loads(gzip.decompress(a.point.read_bytes()))['values']))
    D = math.lcm(*(v.denominator for v in values[:36495]))
    vi = [int(v * D) for v in values[:36495]]
    # Remove one count per sector, since each sector has total cardinality128.
    groups = [(s, o, r) for s in range(2) for o in range(45) for r in range(q)
              if (o, r) != (44, q-1)]
    d = len(groups) + 1
    G = [[0] * d for _ in range(d)]
    G[0][0] = D
    for i, (s, o, r) in enumerate(groups, 1):
        G[0][i] = G[i][0] = n * vi[o]
        for j, (t, p, u) in enumerate(groups[:i], 1):
            entry = n * sum(vi[coordinate(720*s + 16*o, 720*t + 16*p + h)]
                            for h in range((u-r) % q, 16, q))
            G[i][j] = G[j][i] = entry
    original = fmpz_mat(G)
    frozen_path = a.output.with_suffix('.frozen.json')
    assert not frozen_path.exists()
    frozen = dict(status='FROZEN_BEFORE_AGGREGATE_LLL',
                  utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  point_sha256=sha(a.point), producer_sha256=sha(__file__),
                  coordinate_sha256=sha(ROOT/'physical_integer_form_rows.py'),
                  phase_modulus=q, groups=groups, denominator=str(D),
                  gram_dimension=d, embedding_alpha_denominators=[4, 16, 64],
                  integer_gram_ridge=1, source_C16_answered=False,
                  scope='Three LLL embeddings on fixed physical count groups; no completeness claim.')
    frozen_path.write_text(json.dumps(frozen, indent=2)+'\n')
    # Tiny positive ridge is a discovery device, never part of cut evaluation.
    discovery = [[v + int(i == j) for j, v in enumerate(row)] for i, row in enumerate(G)]
    records = []
    cuts = []
    seen = set()
    for alpha_den in [4, 16, 64]:
        assert D % (alpha_den**2) == 0
        E = [[4*v for v in row] + [2*row[0]] for row in discovery]
        E.append([2*discovery[0][j] for j in range(d)] +
                 [discovery[0][0] + D // (alpha_den**2)])
        embed = fmpz_mat(E)
        t = time.monotonic()
        reduced, U = embed.lll(transform=True, rep='gram', gram='exact')
        assert U * embed * U.transpose() == reduced
        odd = 0
        minimum = None
        proposals = []
        for row in range(d+1):
            k = int(U[row, d])
            if k % 2 == 0:
                continue
            odd += 1
            c = int(U[row, 0]) + (k+1)//2
            w = [int(U[row, j]) for j in range(1, d)]
            z = fmpz_mat([[c, *w]])
            # E[L^2-L], with all target moments still exact integers / D.
            numerator = int((z * original * z.transpose())[0, 0]) - sum(int(z[0,j])*G[0][j] for j in range(d))
            minimum = numerator if minimum is None else min(minimum, numerator)
            if numerator >= 0 or not any(w):
                continue
            key = (c, *w)
            other = (1-c, *(-v for v in w))
            key = min(key, other)
            if key in seen:
                continue
            seen.add(key)
            c, *w = key
            cut = dict(constant=c, group_weights=w,
                       exact_violation=str(Fraction(-numerator, 2*D)),
                       embedding_alpha_denominator=alpha_den,
                       lll_row=row, odd_embedding_coefficient=k)
            cuts.append(cut)
            proposals.append(len(cuts)-1)
        records.append(dict(alpha_denominator=alpha_den, seconds=time.monotonic()-t,
                            exact_congruence_verified=True, odd_rows=odd,
                            minimum_integer_form_value=str(Fraction(minimum, 2*D)) if minimum is not None else None,
                            new_candidate_ids=proposals))
        print(records[-1], flush=True)
    out = dict(frozen, status='EXACT_AGGREGATE_FORM_CANDIDATES' if cuts else 'BOUNDED_AGGREGATE_LLL_NO_CUT',
               frozen_sha256=sha(frozen_path), records=records, cuts=cuts,
               seconds=time.monotonic()-start,
               independent_physical_replay_required=True)
    a.output.write_text(json.dumps(out, indent=2)+'\n')
    print(out['status'], len(cuts), flush=True)


if __name__ == '__main__':
    main()
