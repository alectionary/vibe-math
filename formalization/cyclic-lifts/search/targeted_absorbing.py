"""Decode every minimum absorbing-set support of each rate-matched design.

This is exact enumeration of this error subclass, not the full weight-four
error set. Bernoulli-probability contributions are lower bounds on total FER.
"""
from collections import Counter
from itertools import combinations
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import tempfile
from benchmark_decoding import (HERE, basis, in_span, construction, engine,
                                bit_string, string_mask, rowmask, syndrome)
from decoding import cycles8_projection, profile
from scan import voltage_graph


def supports(adj):
    checks = sorted(c for c in adj if c[0] == 'c')
    projection = {c:{} for c in checks}
    for v in adj:
        if v[0] == 'c':
            continue
        for a,b in combinations(sorted(adj[v]),2):
            assert b not in projection[a]
            projection[a][b] = projection[b][a] = v
    sets = set()
    for a,c in combinations(checks,2):
        for b,d in combinations(sorted(projection[a].keys() & projection[c].keys()),2):
            S = frozenset([projection[a][b],projection[b][c],projection[c][d],projection[d][a]])
            if len(S) == 4:
                sets.add(S)
    assert len(sets) == sum(cycles8_projection(adj).values())
    # Check absorption directly for every set, without relying solely on
    # the written girth-eight equivalence.
    for S in sets:
        p = profile(adj,S)
        assert p['absorbing'] and p['syndrome_weight'] == 4
        assert p['positive_check_degree_counts'] == {1:4,2:4}
    return sets


def main():
    benchmark = json.loads((HERE/'benchmark-confirmation.json').read_text())
    compiler = shutil.which('c++') or shutil.which('g++')
    results = []
    with tempfile.TemporaryDirectory(prefix='cyclic-targeted-') as td:
        binary = Path(td)/'minsum'
        subprocess.run([compiler,'-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(binary)],check=True)
        for name,meta in benchmark['designs'].items():
            B,r,n = meta['B'],meta['r'],meta['n']
            hx,hz,checked = construction(B,r)
            assert checked == meta
            adj = voltage_graph(B,r)
            variables = sorted(v for v in adj if v[0] != 'c')
            vi = {v:i for i,v in enumerate(variables)}
            errors = sorted(rowmask(vi[v] for v in S) for S in supports(adj))
            type_by_error = {e:sum(variables[v][0] == 'l' for v in range(n) if e >> v & 1)
                             for e in errors}
            zp,xm = basis(hz),list(map(rowmask,hx))
            by_p = []
            for p in [.01,.02,.04]:
                trials = [(p,bit_string(e,n)) for e in errors]
                outcomes = engine(binary,hx,n,trials,100,.8)
                failed = syndrome_failed = matched_logical = 0
                exact = stabilizer = 0
                failure_types, residual_weights = Counter(), Counter()
                examples = {}
                for error,(it,matched,estimate) in zip(errors,outcomes):
                    correction = string_mask(estimate)
                    assert matched == (syndrome(xm,correction) == syndrome(xm,error))
                    bad = not in_span(error ^ correction,zp)
                    exact += error == correction
                    stabilizer += not bad and error != correction
                    failed += bad
                    syndrome_failed += not matched
                    matched_logical += matched and bad
                    if bad:
                        failure_types[type_by_error[error]] += 1
                        weight = bin(error ^ correction).count('1')
                        residual_weights[weight] += 1
                        if weight not in examples:
                            examples[weight] = {
                                'error_support':[v for v in range(n) if error >> v & 1],
                                'correction_support':[v for v in range(n) if correction >> v & 1],
                                'residual_support':[v for v in range(n) if (error ^ correction) >> v & 1]}
                by_p.append({'p':p,'failures':failed,'syndrome_failures':syndrome_failed,
                             'matched_logical_failures':matched_logical,
                             'exact_recovery':exact,'stabilizer_equivalent_success':stabilizer,
                             'failure_counts_by_left_variable_count':dict(sorted(failure_types.items())),
                             'failed_residual_weight_histogram':dict(sorted(residual_weights.items())),
                             'failed_residual_examples':examples,
                             'conditional_failure_fraction':failed/len(errors),
                             'exact_bernoulli_failure_contribution':failed*p**4*(1-p)**(n-4)})
            results.append({'design':name,'enumerated_absorbing_supports':len(errors),
                            'all_profiles_directly_checked':True,'by_probability':by_p})
    result = {'scope':'Every four-variable absorbing support, one error per selected variable and no other errors; not all weight-four patterns.',
              'decoder':'Same fixed-point normalized min-sum alpha=.8, max_iter=100 as confirmation experiment.',
              'probability_interpretation':'For a Bernoulli(p) channel these disjoint exact supports contribute failures*p^4*(1-p)^(n-4) to total FER; this is only one error subclass, not a FER estimate.',
              'results':results,
              'sources_sha256':{f:hashlib.sha256((HERE/f).read_bytes()).hexdigest()
                                for f in ['targeted_absorbing.py','minsum.cpp','benchmark_decoding.py','benchmark-confirmation.json']}}
    (HERE/'targeted-results.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result,indent=2))


if __name__ == '__main__':
    main()
