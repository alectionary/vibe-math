"""Paired code-capacity experiment for optimized 3x3 circulant LP codes.

Standard library only; compiles minsum.cpp using a C++17 compiler in a
temporary directory. No binaries are stored in the repository. Decoding
uses only H_X, syndrome and p. H_Z and the true error are used only to score
the residual, never to choose a correction. This simulates one Pauli sector
with perfect syndrome measurements, not a full depolarizing/circuit model.
"""
from collections import Counter
from itertools import combinations, product
from math import floor, log, sqrt
from pathlib import Path
import argparse
import base64
import hashlib
import json
import random
import shutil
import subprocess
import tempfile
import zlib
from optimize_absorbing import matrix
from scan import voltage_graph, matrix_graph, girth
from decoding import components, cycles8_projection

HERE = Path(__file__).resolve().parent
popcount = getattr(int, 'bit_count', lambda value: bin(value).count('1'))


def basis(rows):
    out = {}
    for row in rows:
        while row:
            p = row.bit_length()-1
            if p in out:
                row ^= out[p]
            else:
                out[p] = row
                break
    return out


def in_span(row, pivots):
    while row:
        p = row.bit_length()-1
        if p not in pivots:
            return False
        row ^= pivots[p]
    return True


def rowmask(indices):
    return sum(1 << v for v in indices)


def syndrome(rows, error):
    return tuple(popcount(h & error) % 2 for h in rows)


def construction(B, r):
    adj = voltage_graph(B, r)
    assert adj == matrix_graph(B, r)
    variables = sorted(v for v in adj if v[0] != 'c')
    checks = sorted(c for c in adj if c[0] == 'c')
    vi = {v: i for i, v in enumerate(variables)}
    hx = [sorted(vi[v] for v in adj[c]) for c in checks]
    # Directly expand [I_n tensor B | B* tensor I_m], with the same columns
    # as H_X. Z check (q,t,a), left (k,j,b), right (i,l,b).
    m, n = len(B), len(B[0])
    hz = []
    for q, t, a in product(range(n), range(m), range(r)):
        row = [vi[('l', q, j, (a-B[t][j]) % r)] for j in range(n)]
        row += [vi[('r', i, t, (a+B[i][q]) % r)] for i in range(m)]
        hz.append(sorted(row))
    xm, zm = list(map(rowmask, hx)), list(map(rowmask, hz))
    assert all(popcount(x & z) % 2 == 0 for x in xm for z in zm)
    assert all(len(row) == 6 for row in hx+hz)
    assert Counter(v for row in hx for v in row) == Counter({v: 3 for v in range(len(variables))})
    ranks = len(basis(xm)), len(basis(zm))
    k = len(variables)-sum(ranks)
    assert k > 0, 'Do not compare zero-logical-qubit codes as quantum memories'
    assert girth(adj) == 8 and components(adj) == [len(adj)]
    return hx, zm, {'B': B, 'r': r, 'n': len(variables), 'rank_hx': ranks[0],
                     'rank_hz': ranks[1], 'k': k, 'girth': 8, 'connected': True,
                     'four_variable_absorbing_sets': sum(cycles8_projection(adj).values())}


def reference_decode(h, n, error_string, p, max_iter, alpha):
    """Slow independent extrinsic-message definition for engine validation."""
    target = syndrome(list(map(rowmask, h)), string_mask(error_string))
    scale = 1 << 20
    prior = floor(log((1-p)/p)*scale+.5)
    alpha_thousandths = floor(alpha*1000+.5)
    q = {(c, v): prior for c, row in enumerate(h) for v in row}
    zero = '0'*n
    if not any(target):
        return 0, True, zero
    clip = lambda x: max(-50*scale, min(50*scale, x))
    for iteration in range(1, max_iter+1):
        messages = {}
        for c, row in enumerate(h):
            for v in row:
                sign = (-1 if target[c] else 1)
                others = [q[c, w] for w in row if w != v]
                for x in others:
                    if x < 0:
                        sign = -sign
                messages[c, v] = clip(sign*((alpha_thousandths*min(map(abs, others))+500)//1000))
        post = [prior + sum(messages[c, v] for c in range(len(h)) if (c, v) in messages)
                for v in range(n)]
        estimate = ''.join('1' if x < 0 else '0' for x in post)
        if syndrome(list(map(rowmask, h)), string_mask(estimate)) == target:
            return iteration, True, estimate
        q = {(c, v): clip(prior + sum(messages[d, v] for d in range(len(h))
                                      if d != c and (d, v) in messages))
             for c, v in q}
    return max_iter, False, estimate


def bit_string(mask, n):
    return ''.join('1' if mask >> j & 1 else '0' for j in range(n))


def string_mask(s):
    return int(s[::-1], 2)


def engine(binary, h, n, trials, max_iter=100, alpha=.8):
    data = [f'{n} {len(h)} {len(trials)} {max_iter} {alpha:.17g}']
    data.extend(str(len(row))+' '+' '.join(map(str, row)) for row in h)
    data.extend(f'{p:.17g} {error}' for p, error in trials)
    proc = subprocess.run([str(binary)], input='\n'.join(data)+'\n', text=True,
                          capture_output=True, check=True)
    lines = proc.stdout.splitlines()
    assert len(lines) == len(trials)
    out = []
    for line in lines:
        it, matched, estimate = line.split()
        assert len(estimate) == n and set(estimate) <= {'0','1'}
        out.append((int(it), bool(int(matched)), estimate))
    return out


def validate(binary, selected):
    checks = 0
    h = [[0,1], [1,2]]
    trials = [(.03, bit_string(x, 3)) for x in range(8)]
    results = engine(binary, h, 3, trials, 10, 1.)
    for (p, error), actual in zip(trials, results):
        assert actual == reference_decode(h,3,error,p,10,1.)
        # The repetition-code coset has two elements; alpha=1 on the tree
        # must choose the lower-weight one (there is no odd-length tie).
        assert actual[1] and actual[2].count('1') <= 1
        checks += 1
    rng = random.Random(480213)
    for alpha in [.6,.8,1.]:
        h = [sorted(rng.sample(range(9),4)) for _ in range(6)]
        trials = [(.07, bit_string(rng.randrange(1<<9),9)) for _ in range(40)]
        for trial, actual in zip(trials, engine(binary,h,9,trials,20,alpha)):
            expected = reference_decode(h,9,trial[1],trial[0],20,alpha)
            assert actual == expected, (alpha,trial,actual,expected)
            checks += 1
    for hx, hz, meta in selected.values():
        n = meta['n']
        xm = list(map(rowmask,hx))
        zp = basis(hz)
        # Every stabilizer is a genuine zero-syndrome success even when
        # the decoder outputs zero instead of the original error.
        assert all(in_span(z,zp) and not any(syndrome(xm,z)) for z in hz)
        trials = [(.01,'0'*n)] + [(.01,bit_string(1<<v,n)) for v in range(n)]
        trials += [(.01,bit_string(hz[0],n))]
        result = engine(binary,hx,n,trials)
        assert all(matched and in_span(string_mask(e)^string_mask(est),zp)
                   for (_,e),(_,matched,est) in zip(trials,result))
        checks += len(trials)
        # Construct an actual zero-syndrome logical operator. A zero
        # correction must be scored as failure, in contrast to a stabilizer.
        xb = basis(xm)
        logical = None
        for free in range(n):
            if free in xb:
                continue
            v = 1 << free
            for pivot in sorted(xb):
                if popcount(xb[pivot] & v) % 2:
                    v ^= 1 << pivot
            assert not any(syndrome(xm,v))
            if not in_span(v,zp):
                logical = v
                break
        assert logical is not None
        [(it,matched,estimate)] = engine(binary,hx,n,[(.01,bit_string(logical,n))])
        assert it == 0 and matched and string_mask(estimate) == 0
        assert not in_span(logical ^ string_mask(estimate),zp)
        checks += 1
    # Cross-check GF(2) membership against brute-force spans.
    toy = [rng.randrange(1<<8) for _ in range(5)]
    span = {0}
    for row in toy:
        span |= {x^row for x in list(span)}
    assert all(in_span(x,basis(toy)) == (x in span) for x in range(1<<8))
    return {'engine_reference_cases':128, 'total_decoder_checks':checks,
            'additional_checks':['CSS orthogonality of every selected matrix pair',
                                 'GF(2) membership against exhaustive toy span',
                                 'all selected single errors and a stabilizer error',
                                 'constructed zero-syndrome logical error scores as failure']}


def wilson(k, n):
    z = 1.959963984540054
    p = k/n
    center = (p+z*z/(2*n))/(1+z*z/n)
    radius = z*sqrt(p*(1-p)/n+z*z/(4*n*n))/(1+z*z/n)
    return [max(0,center-radius), min(1,center+radius)]


def pack(bits):
    data = bytearray((len(bits)+7)//8)
    for i, b in enumerate(bits):
        if b:
            data[i//8] |= 1 << (i % 8)
    return base64.b64encode(zlib.compress(bytes(data),9)).decode()


def run(binary, trials_per_p, seed, selected, probabilities, max_iter=100, alpha=.8):
    results = []
    paired = []
    n = next(iter(selected.values()))[2]['n']
    for pi, p in enumerate(probabilities):
        rng = random.Random(seed+1000003*pi)
        trials = [(p, ''.join('1' if rng.random()<p else '0' for _ in range(n)))
                  for _ in range(trials_per_p)]
        trial_hash = hashlib.sha256('\n'.join(e for _,e in trials).encode()).hexdigest()
        failures = {}
        for name,(hx,hz,meta) in selected.items():
            xp = list(map(rowmask,hx))
            zp = basis(hz)
            outcomes = engine(binary,hx,n,trials,max_iter,alpha)
            counts = Counter()
            flags, sf = [], []
            iterations = 0
            matched_iterations = 0
            for (_,e),(it,matched,estimate) in zip(trials,outcomes):
                error = string_mask(e)
                correction = string_mask(estimate)
                residual = error ^ correction
                # Independent syndrome check: do not trust engine status.
                assert matched == (syndrome(xp,correction)==syndrome(xp,error))
                ok = in_span(residual,zp)
                assert not ok or matched
                counts['exact_recovery'] += residual == 0
                counts['stabilizer_equivalent_success'] += ok and residual != 0
                counts['syndrome_failure'] += not matched
                counts['matched_logical_failure'] += matched and not ok
                flags.append(not ok)
                sf.append(not matched)
                iterations += it
                matched_iterations += it if matched else 0
            fail = sum(flags)
            assert sum(counts.values()) == trials_per_p
            failures[name] = flags
            results.append({'design':name, 'p':p, 'trials':trials_per_p,
                            'failure_count':fail,'failure_rate':fail/trials_per_p,
                            'wilson_95_interval':wilson(fail,trials_per_p),
                            **counts,'mean_iterations':iterations/trials_per_p,
                            'mean_iterations_given_syndrome_match':
                                matched_iterations/(trials_per_p-counts['syndrome_failure']),
                            'error_stream_sha256':trial_hash,
                            'failure_flags_zlib_base64':pack(flags),
                            'syndrome_failure_flags_zlib_base64':pack(sf)})
            print(f'{name} p={p}: failures {fail}/{trials_per_p}',flush=True)
        base = failures['baseline']
        for name, flags in failures.items():
            if name == 'baseline':
                continue
            better = sum(b and not f for b,f in zip(base,flags))
            worse = sum(f and not b for b,f in zip(base,flags))
            delta = (worse-better)/trials_per_p
            se = sqrt(max(0,(better+worse)-trials_per_p*delta**2)/
                      (trials_per_p*(trials_per_p-1)))
            paired.append({'design':name,'p':p,'trials':trials_per_p,
                           'same_encoded_dimension_as_baseline':
                               selected[name][2]['k'] == selected['baseline'][2]['k'],
                           'baseline_failed_design_succeeded':better,
                           'baseline_succeeded_design_failed':worse,
                           'failure_rate_difference_design_minus_baseline':delta,
                           'paired_normal_95_interval':[delta-1.959963984540054*se,
                                                        delta+1.959963984540054*se]})
    return {'probabilities':probabilities,'trials_per_probability':trials_per_p,
            'seed':seed,'max_iterations':max_iter,'alpha':alpha,
            'results':results,'paired_comparisons':paired}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--trials',type=int,default=10000)
    parser.add_argument('--seed',type=int,default=20261022)
    parser.add_argument('--alpha',type=float,default=.8)
    parser.add_argument('--max-iter',type=int,default=100)
    parser.add_argument('--output',default='benchmark-results.json')
    parser.add_argument('--probabilities',type=float,nargs='+',default=[.0025,.005,.01,.02,.04])
    parser.add_argument('--primary-only',action='store_true')
    parser.add_argument('--validate-only',action='store_true')
    args = parser.parse_args()
    assert args.trials > 1 and 0 < args.alpha <= 1
    assert all(0 < p < .5 for p in args.probabilities)
    search = json.loads((HERE/'optimization-r14.json').read_text())
    designs = {'baseline':[[0,0,0],[0,1,2],[0,3,6]],
               'previous_best':[[0,0,0],[0,1,2],[0,3,8]]}
    for i,orbit in enumerate(search['minimizing_orbits']):
        designs[f'minimum_{i+1}'] = matrix(orbit['interior'])
    if args.primary_only:
        for name in ['minimum_1','minimum_3']:
            del designs[name]
    selected = {name:construction(B,14) for name,B in designs.items()}
    # Compare rate-preserving minima as the primary controlled experiment.
    # Lower-rate minima remain labeled exploratory rather than conflated.
    assert len({meta['n'] for _,_,meta in selected.values()}) == 1
    assert all(selected[name][2]['k'] == selected['baseline'][2]['k']
               for name in ['previous_best','minimum_2','minimum_4'])
    compiler = shutil.which('c++') or shutil.which('g++') or shutil.which('clang++')
    assert compiler, 'A C++17 compiler is required'
    with tempfile.TemporaryDirectory(prefix='cyclic-decoder-') as td:
        binary = Path(td)/'minsum'
        subprocess.run([compiler,'-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(binary)],check=True)
        validation = validate(binary,selected)
        print(json.dumps({'validation':validation,'designs':{n:m for n,(_,_,m) in selected.items()}},indent=2),flush=True)
        if args.validate_only:
            return
        experiment = run(binary,args.trials,args.seed,selected,args.probabilities,args.max_iter,args.alpha)
    result = {'scope':'One Pauli error sector, independent Bernoulli(p) errors, perfect syndrome, normalized min-sum flooding; code-capacity experiment, not full depolarizing or circuit-level performance.',
              'scoring':'Success iff error XOR correction is in row(H_Z). Failure is nonconvergence/syndrome mismatch OR matched nonstabilizer residual. Exact error recovery is separately reported.',
              'decoder':'Syndrome normalized min-sum; constant prior log((1-p)/p), fixed point with 20 fractional bits, prior rounded to nearest integer, normalization in integer thousandths with nonnegative magnitudes rounded to nearest (ties up), zero LLR sign +1, hard bit 1 iff posterior<0, all messages clipped to +/-50; stop at first syndrome match, including iteration zero. No OSD, restarts or use of true error during decoding.',
              'reference':'https://link.springer.com/article/10.1140/epjqt/s40507-023-00201-1#Sec4',
              'selection':'All four minimum-count orbit representatives selected structurally, before decoding. Baseline and previous best are included. Primary rate-preserving comparisons: previous_best, minimum_2, minimum_4 (k=10). minimum_1 and minimum_3 have k=8 and are exploratory, not rate-matched. No winner chosen using decoding trials.',
              'statistics':'Wilson marginal 95% intervals; paired normal 95% intervals for design-minus-baseline failure-rate differences. Pointwise, not adjusted for multiple comparisons.',
              'flag_encoding':'zlib compressed packed bits, least significant bit first in each byte, base64; one bit per trial in stream order.',
              'validation':validation,'designs':{n:m for n,(_,_,m) in selected.items()},
              'experiment':experiment,
              'sources_sha256':{f:hashlib.sha256((HERE/f).read_bytes()).hexdigest()
                                for f in ['benchmark_decoding.py','minsum.cpp','optimization-r14.json']}}
    (HERE/args.output).write_text(json.dumps(result,indent=2)+'\n')


if __name__ == '__main__':
    main()
