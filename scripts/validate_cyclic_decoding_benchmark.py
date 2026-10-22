"""Audit search coverage, symmetry actions and saved decoder experiments."""
from pathlib import Path
import base64
import hashlib
import json
import math
import random
import sys
import zlib

R = Path(__file__).resolve().parents[1]
S = R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
from optimize_absorbing import run, matrix
from benchmark_decoding import construction, basis, wilson, rowmask, syndrome, in_span
from scan import voltage_graph
from decoding import cycles8_dfs


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def flags(s,n):
    data=zlib.decompress(base64.b64decode(s))
    assert len(data)==(n+7)//8
    return [bool(data[i//8] & (1 << (i%8))) for i in range(n)]


def iso(B,T,mapping,r):
    g,h=voltage_graph(B,r),voltage_graph(T,r)
    assert {mapping(v) for v in g}==set(h)
    for v in g:
        assert {mapping(w) for w in g[v]}==h[mapping(v)]


def symmetry_checks():
    rng=random.Random(231014)
    r=14
    for _ in range(6):
        B=[[rng.randrange(r) for _ in range(3)] for _ in range(3)]
        u,v=[rng.randrange(r) for _ in range(3)],[rng.randrange(r) for _ in range(3)]
        T=[[(B[i][j]+u[i]+v[j])%r for j in range(3)] for i in range(3)]
        def gauge(x):
            t,i,j,a=x
            shift=u[i]-v[j] if t=='c' else (-v[i]-v[j] if t=='l' else u[i]+u[j])
            return t,i,j,(a+shift)%r
        iso(B,T,gauge,r)
        T=[list(row) for row in zip(*B)]
        iso(B,T,lambda x:({'c':'c','l':'r','r':'l'}[x[0]],x[2],x[1],-x[3]%r),r)
        unit=rng.choice([1,3,5,9,11,13])
        T=[[unit*b%r for b in row] for row in B]
        iso(B,T,lambda x:(x[0],x[1],x[2],unit*x[3]%r),r)
        rows,cols=rng.sample(range(3),3),rng.sample(range(3),3)
        ir,ic={v:i for i,v in enumerate(rows)},{v:i for i,v in enumerate(cols)}
        T=[[B[i][j] for j in cols] for i in rows]
        def perm(x):
            t,i,j,a=x
            return t,(ic[i] if t=='l' else ir[i]),(ir[j] if t=='r' else ic[j]),a
        iso(B,T,perm,r)


symmetry_checks()
search=json.loads((S/'optimization-r14.json').read_text())
assert json.loads(json.dumps(run(14)))==search
assert search['minimum_eight_cycles']==2520
assert search['connected_girth_eight_bases']==10368
assert search['minimizer_count']==1728
# A second cycle-count algorithm on every orbit representative, not just winners.
for orb in search['orbits']:
    counts=cycles8_dfs(voltage_graph(matrix(orb['interior']),14))
    assert counts==orb['eight_cycles_by_left_variable_count']

for filename in ['benchmark-results.json','benchmark-confirmation.json']:
    doc=json.loads((S/filename).read_text())
    for f,h in doc['sources_sha256'].items():
        assert sha(S/f)==h,(filename,f)
    for name,meta in doc['designs'].items():
        hx,hz,m=construction(meta['B'],meta['r'])
        assert m==meta and m['n']==252
        assert len(basis(hz))==m['rank_hz']
    exp=doc['experiment']
    by_p={}
    for row in exp['results']:
        n=row['trials']
        assert n==exp['trials_per_probability']
        f=flags(row['failure_flags_zlib_base64'],n)
        sf=flags(row['syndrome_failure_flags_zlib_base64'],n)
        assert sum(f)==row['failure_count']
        assert sum(sf)==row['syndrome_failure']
        assert all(not s or b for s,b in zip(sf,f))
        assert row['failure_count']==row['syndrome_failure']+row['matched_logical_failure']
        assert n==sum(row[k] for k in ['exact_recovery','stabilizer_equivalent_success',
                                      'syndrome_failure','matched_logical_failure'])
        assert row['failure_rate']==sum(f)/n
        assert row['wilson_95_interval']==wilson(sum(f),n)
        by_p.setdefault(row['p'],{})[row['design']]=(f,row)
    for group in by_p.values():
        assert len({row['error_stream_sha256'] for _,row in group.values()})==1
    for row in exp['paired_comparisons']:
        n=row['trials']
        b=by_p[row['p']]['baseline'][0]
        d=by_p[row['p']][row['design']][0]
        better=sum(x and not y for x,y in zip(b,d))
        worse=sum(y and not x for x,y in zip(b,d))
        assert better==row['baseline_failed_design_succeeded']
        assert worse==row['baseline_succeeded_design_failed']
        delta=(worse-better)/n
        se=math.sqrt(max(0,better+worse-n*delta**2)/(n*(n-1)))
        assert delta==row['failure_rate_difference_design_minus_baseline']
        assert row['paired_normal_95_interval']==[delta-1.959963984540054*se,
                                                 delta+1.959963984540054*se]
    if filename=='benchmark-confirmation.json':
        assert exp['seed']==20261023 and exp['trials_per_probability']==100000
        assert all(m['k']==10 for m in doc['designs'].values())

target=json.loads((S/'targeted-results.json').read_text())
designs=json.loads((S/'benchmark-confirmation.json').read_text())['designs']
for f,h in target['sources_sha256'].items():
    assert sha(S/f)==h,f
for row in target['results']:
    meta=designs[row['design']]
    hx,hz,_=construction(meta['B'],meta['r'])
    for entry in row['by_probability']:
        assert entry['failures']<=row['enumerated_absorbing_supports']
        assert entry['failures']==entry['syndrome_failures']+entry['matched_logical_failures']
        assert entry['exact_bernoulli_failure_contribution']==entry['failures']*entry['p']**4*(1-entry['p'])**248
        assert entry['exact_recovery']+entry['stabilizer_equivalent_success']+entry['failures']==row['enumerated_absorbing_supports']
        assert sum(entry['failure_counts_by_left_variable_count'].values())==entry['failures']
        assert sum(entry['failed_residual_weight_histogram'].values())==entry['failures']
        for weight,example in entry['failed_residual_examples'].items():
            residual=rowmask(example['residual_support'])
            assert residual==rowmask(example['error_support'])^rowmask(example['correction_support'])
            assert len(example['residual_support'])==int(weight)
            assert not any(syndrome(list(map(rowmask,hx)),residual))
            assert not in_span(residual,basis(hz))

manifest=json.loads((S.parent/'optimization-verification.json').read_text())
for f,h in manifest['sha256'].items():
    assert sha(R/f)==h,f
log=(S.parent/'optimized-checks.log').read_text()
assert log.count('depends on axioms:')==3 and 'sorryAx' not in log
print('Validated exhaustive 28,561-base search, 25 symmetry orbits, all orbit DFS counts, exact code ranks, paired outcomes/intervals, targeted error contributions and supplementary Lean hashes.')
