"""Fixed-protocol classical dyadic pilot. Standard library + C++17 only.

No Lean theorem or quantum performance claim is produced by this program.
"""
from collections import Counter
from itertools import combinations
from pathlib import Path
import base64
import hashlib
import json
import math
import random
import subprocess
import sys
import tempfile
import zlib

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
OLD = ROOT / 'formalization/cyclic-lifts/search'
sys.path.insert(0, str(OLD))
import benchmark_decoding as decoder

popcount = decoder.popcount


def construction(B, ell):
    N = 1 << ell
    m, n = len(B), len(B[0])
    h = [sorted(j*N + (x ^ B[i][j]) for j in range(n)
                if B[i][j] is not None) for i in range(m) for x in range(N)]
    # Independent dense entry definition, without enumerating block edges.
    dense = [[v for v in range(n*N)
              if B[c//N][v//N] is not None
              and B[c//N][v//N] == ((c % N) ^ (v % N))]
             for c in range(m*N)]
    assert h == dense
    vn = [[] for _ in range(n*N)]
    for c, row in enumerate(h):
        for v in row:
            vn[v].append(c)
    return h, vn


def connected(h, vn):
    seen, todo = {0}, [0]
    while todo:
        v = todo.pop()
        for c in vn[v]:
            for w in h[c]:
                if w not in seen:
                    seen.add(w); todo.append(w)
    return len(seen) == len(vn)


def cycle_counts(h, vn):
    """Each undirected simple cycle counted once, smallest variable root."""
    n = len(vn)
    adj = [tuple(n+c for c in cs) for cs in vn] + [tuple(row) for row in h]
    counts = Counter()
    for root in range(n):
        def visit(u, path, seen):
            for v in adj[u]:
                if v == root:
                    if len(path) >= 4 and path[1] < path[-1]:
                        counts[len(path)] += 1
                elif v > root and v not in seen and len(path) < 8:
                    visit(v, path+(v,), seen | {v})
        visit(root, (root,), {root})
    return [counts[k] for k in (4, 6, 8)]


def absorbing(vn, max_a=4):
    masks = [sum(1 << c for c in cs) for cs in vn]
    spectrum = Counter()
    for a in range(2, max_a+1):
        for support in combinations(range(len(vn)), a):
            odd = 0
            for v in support:
                odd ^= masks[v]
            if not all(2*popcount(odd & masks[v]) < len(vn[v]) for v in support):
                continue
            degrees = Counter(c for v in support for c in vn[v])
            elementary = max(degrees.values()) <= 2
            seen, todo = {support[0]}, [support[0]]
            while todo:
                v = todo.pop()
                for w in support:
                    if w not in seen and masks[v] & masks[w]:
                        seen.add(w); todo.append(w)
            spectrum[(a, popcount(odd), elementary, len(seen) == a)] += 1
    return [{'a': a, 'b': b, 'elementary': e, 'connected': c, 'count': count}
            for (a, b, e, c), count in sorted(spectrum.items())]


def abs_features(spectrum):
    return [sum(s['count'] for s in spectrum if s['a'] == a and (s['b'] == 0) == zero)
            for a in range(2, 5) for zero in (False, True)]


def wilson(k, n):
    z = 1.959963984540054
    center = (k/n + z*z/(2*n))/(1+z*z/n)
    radius = z*math.sqrt(k/n*(1-k/n)/n+z*z/(4*n*n))/(1+z*z/n)
    return [max(0., center-radius), min(1., center+radius)]


def pack(bits):
    raw = bytes(int(''.join(str(int(x)) for x in bits[i:i+8]).ljust(8, '0'), 2)
                for i in range(0, len(bits), 8))
    return base64.b64encode(zlib.compress(raw, 9)).decode()


def solve(A, b):
    mat = [list(row)+[v] for row, v in zip(A, b)]
    for i in range(len(b)):
        pivot = max(range(i, len(b)), key=lambda j: abs(mat[j][i]))
        mat[i], mat[pivot] = mat[pivot], mat[i]
        divisor = mat[i][i]
        assert abs(divisor) > 1e-12
        mat[i] = [v/divisor for v in mat[i]]
        for j in range(len(b)):
            if j != i:
                factor = mat[j][i]
                mat[j] = [u-factor*v for u, v in zip(mat[j], mat[i])]
    return [row[-1] for row in mat]


def predictions(features, y, groups):
    out = []
    for held in groups:
        train = [i for i, group in enumerate(groups) if group != held]
        assert train
        d = len(features[0])
        means = [sum(features[i][j] for i in train)/len(train) for j in range(d)]
        scales = [math.sqrt(sum((features[i][j]-means[j])**2 for i in train)/len(train))
                  or 1. for j in range(d)]
        x = [[1.] + [(row[j]-means[j])/scales[j] for j in range(d)] for row in features]
        A = [[sum(x[i][j]*x[i][k] for i in train)+(1. if j == k and j else 0.)
              for k in range(d+1)] for j in range(d+1)]
        beta = solve(A, [sum(x[i][j]*y[i] for i in train) for j in range(d+1)])
        idx = len(out)
        out.append(sum(u*v for u, v in zip(x[idx], beta)))
    return out


def ranks(values):
    out = [0.]*len(values)
    for value in set(values):
        ids = [i for i, x in enumerate(values) if x == value]
        rank = sum(x < value for x in values)+(len(ids)+1)/2
        for i in ids:
            out[i] = rank
    return out


def spearman(x, y):
    x, y = ranks(x), ranks(y)
    mx, my = sum(x)/len(x), sum(y)/len(y)
    denom = math.sqrt(sum((v-mx)**2 for v in x)*sum((v-my)**2 for v in y))
    return sum((u-mx)*(v-my) for u, v in zip(x, y))/denom if denom else None


def checks(binary):
    # Complete bipartite K3,6: precisely even nonempty supports absorb.
    h, vn = construction([[0]*6 for _ in range(3)], 0)
    spectrum = absorbing(vn)
    assert sum(s['count'] for s in spectrum) == math.comb(6, 2)+math.comb(6, 4)
    assert all(s['b'] == 0 and s['a'] % 2 == 0 for s in spectrum)
    assert cycle_counts(h, vn) == [45, 120, 0]  # Only three checks: no eight-cycle.
    # A single 8-cycle and no repeated traversal masquerading as a simple cycle.
    h = [[0, 1], [1, 2], [2, 3], [3, 0]]
    vn = [[0, 3], [0, 1], [1, 2], [2, 3]]
    assert cycle_counts(h, vn) == [0, 0, 1]
    tree = [[0, 1], [1, 2]]
    trials = [(.05, decoder.bit_string(x, 3)) for x in range(8)]
    for alpha in (.8, 1.):
        for trial, actual in zip(trials, decoder.engine(binary, tree, 3, trials, 50, alpha)):
            assert actual == decoder.reference_decode(tree, 3, trial[1], trial[0], 50, alpha)
            assert actual[1] and actual[2].count('1') <= 1
    return 16


def run():
    rng = random.Random(20261023)
    codes, rejected, accepted, target_rank = [], Counter(), set(), None
    attempts = 0
    while len(codes) < 32:
        attempts += 1
        B = [[0]*6]+[[0]+[rng.randrange(8) for _ in range(5)] for _ in range(2)]
        key = tuple(map(tuple, B))
        h, vn = construction(B, 3)
        if not connected(h, vn):
            rejected['disconnected'] += 1; continue
        rank = len(decoder.basis(list(map(decoder.rowmask, h))))
        if target_rank is None:
            target_rank = rank
        if rank != target_rank:
            rejected['rank_mismatch'] += 1; continue
        if key in accepted:
            rejected['duplicate_array'] += 1; continue
        accepted.add(key)
        assert all(len(row) == 6 for row in h) and all(len(cs) == 3 for cs in vn)
        cycles, spectrum = cycle_counts(h, vn), absorbing(vn)
        codes.append({'id': len(codes), 'B': B, 'n': 48, 'rank': rank, 'k': 48-rank,
                      'cycles': cycles, 'absorbing_spectrum': spectrum,
                      'absorbing_features': abs_features(spectrum), 'conditions': []})
        print(f'graph {len(codes)}/32', flush=True)
    conditions = []
    with tempfile.TemporaryDirectory(prefix='dyadic-performance-') as temp:
        binary = Path(temp)/'minsum'
        subprocess.run(['c++', '-std=c++17', '-O2', str(OLD/'minsum.cpp'), '-o', str(binary)], check=True)
        reference_checks = checks(binary)
        for code in codes[:2]:
            h, _ = construction(code['B'], 3)
            trials = [(.05, decoder.bit_string(rng.getrandbits(48), 48)) for _ in range(4)]
            for alpha in (.8, 1.):
                for trial, actual in zip(trials, decoder.engine(binary, h, 48, trials, 50, alpha)):
                    assert actual == decoder.reference_decode(h, 48, trial[1], .05, 50, alpha)
                    reference_checks += 1
        # Separate seed makes samples independent of rejection counts and reference checks.
        noise = random.Random(20261024)
        samples = {p: [''.join('1' if noise.random() < p else '0' for _ in range(48))
                       for _ in range(3000)] for p in (.02, .05, .08)}
        exact = [decoder.bit_string(sum(1 << v for v in support), 48)
                 for w in range(3) for support in combinations(range(48), w)]
        for alpha in (.8, 1.):
            for p in (.02, .05, .08):
                conditions.append({'alpha': alpha, 'p': p, 'frames': 3000})
            for code in codes:
                h, _ = construction(code['B'], 3)
                for p in (.02, .05, .08):
                    errors = samples[p]
                    actual = decoder.engine(binary, h, 48, [(p, e) for e in errors], 50, alpha)
                    fail = [e != result[2] for e, result in zip(errors, actual)]
                    nonconv = [not result[1] for result in actual]
                    masks = list(map(decoder.rowmask, h))
                    assert all(result[1] == (decoder.syndrome(masks, decoder.string_mask(result[2]))
                                            == decoder.syndrome(masks, decoder.string_mask(e)))
                               for e, result in zip(errors, actual))
                    assert all(f or not nc for f, nc in zip(fail, nonconv))
                    code['conditions'].append({'alpha': alpha, 'p': p, 'failures': sum(fail),
                        'nonconverged': sum(nonconv), 'wrong_converged': sum(fail)-sum(nonconv),
                        'fer': sum(fail)/3000, 'wilson95': wilson(sum(fail), 3000),
                        'failure_bitmap_zlib_base64': pack(fail)})
                out = decoder.engine(binary, h, 48, [(.05, e) for e in exact], 50, alpha)
                code.setdefault('exact_weight_le2', []).append({'alpha': alpha,
                    'failures_by_weight': {str(w): sum(e != r[2] for e, r in zip(exact, out)
                                                           if e.count('1') == w) for w in range(3)},
                    'failure_bitmap_zlib_base64': pack([e != r[2] for e, r in zip(exact, out)])})
                print(f'decoder {alpha}: graph {code["id"]+1}/32', flush=True)
    groups = [json.dumps([c['cycles'], c['absorbing_spectrum']], sort_keys=True) for c in codes]
    analyses = []
    feature_names = ['cycles4', 'cycles6', 'cycles8']+[f'abs{a}_{kind}' for a in range(2, 5)
                                                            for kind in ('positive_b', 'zero_b')]
    rows = [c['cycles']+c['absorbing_features'] for c in codes]
    for idx, condition in enumerate(conditions):
        y = [math.log((c['conditions'][idx]['failures']+.5)/
                      (3000-c['conditions'][idx]['failures']+.5)) for c in codes]
        models = {}
        for name, indices in [('intercept', []), ('cycles', list(range(3))),
                              ('absorbing', list(range(3, 9))), ('combined', list(range(9)))]:
            features = [[math.log1p(row[j]) for j in indices] for row in rows]
            pred = predictions(features, y, groups)
            models[name] = {'rmse_logit': math.sqrt(sum((u-v)**2 for u, v in zip(y, pred))/len(y)),
                            'held_out_predictions': pred}
        analyses.append({**condition, 'models': models,
            'marginal_spearman': {name: spearman([row[j] for row in rows], y)
                                 for j, name in enumerate(feature_names)}})
    paths = [HERE/'pilot.py', OLD/'minsum.cpp', OLD/'benchmark_decoding.py',
             OLD/'decoding.py', OLD/'optimize_absorbing.py', OLD/'scan.py',
             HERE.parent/'PROTOCOL.md', HERE.parent/'PRIOR-ART.md']
    result = {'status': 'exploratory_classical_pilot_not_full_P11_resolution',
        'seed': 20261023, 'noise_seed': 20261024, 'attempts': attempts, 'rejected': dict(rejected),
        'codes': codes, 'reference_checks': reference_checks, 'feature_names': feature_names,
        'fingerprint_groups': len(set(groups)), 'analysis': analyses,
        'sample_sha256': {str(p): hashlib.sha256(''.join(errors).encode()).hexdigest()
                          for p, errors in samples.items()},
        'sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}}
    (HERE/'results.json').write_text(json.dumps(result, indent=2)+'\n')
    print(json.dumps({'rank': target_rank, 'groups': len(set(groups)),
          'analyses': [{k: v for k, v in a.items() if k != 'marginal_spearman'} for a in analyses]}, indent=2))


if __name__ == '__main__':
    run()
