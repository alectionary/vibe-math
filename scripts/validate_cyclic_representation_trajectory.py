"""Rebuild the fixed same-code pilot's noise, contrasts and traced outcomes."""
from pathlib import Path
from collections import Counter
import base64,hashlib,json,math,random,subprocess,sys,tempfile,zlib
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b


def unpack(encoded,n):
    raw=zlib.decompress(base64.b64decode(encoded));assert len(raw)==(n+7)//8
    return [bool(raw[i//8]&(1<<(i%8))) for i in range(n)]


d=json.loads((S/'representation-trajectory-results.json').read_text())
selection=json.loads((S/'representation-trajectory-selection.json').read_text())
f=json.loads((S/'representation-results.json').read_text())
assert d['sha256']==selection['sha256']
for rel,digest in d['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
assert d['seed']==selection['seed']==20261026 and d['p']==selection['p']==.04
n=d['independent_error_patterns'];assert n==50000 and d['decoder_executions']==300000
assert d['row_order_exact_outcome_checks']==100000
rng=random.Random(d['seed'])
errors=[''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for _ in range(n)]
assert hashlib.sha256('\n'.join(errors).encode()).hexdigest()==d['error_stream_sha256']
flags={};syndrome_flags={}
for rec in d['results']:
    key=(rec['design'],rec['representation'])
    a=unpack(rec['failure_flags_zlib_base64'],n);sf=unpack(rec['syndrome_failure_flags_zlib_base64'],n)
    assert sum(a)==rec['failure_count']==rec['syndrome_failure']+rec['matched_logical_failure']
    assert sum(sf)==rec['syndrome_failure'] and all(not x or y for x,y in zip(sf,a))
    assert rec['failure_count']+rec['exact_recovery']+rec['stabilizer_equivalent_success']==n
    assert rec['failure_rate']==sum(a)/n
    flags[key]=a;syndrome_flags[key]=sf
for c in d['contrasts']:
    name=c['design'];a=flags[name,'original'];z=flags[name,'delete_one']
    assert a==flags[name,'row_order_control']
    better=sum(x and not y for x,y in zip(a,z));worse=sum(y and not x for x,y in zip(a,z))
    assert (better,worse)==(c['original_failed_deletion_succeeded'],c['original_succeeded_deletion_failed'])
    delta=(worse-better)/n;se=math.sqrt((better+worse-n*delta**2)/(n*(n-1)))
    assert delta==c['difference'] and c['pointwise_paired_95_interval']==[delta-1.959963984540054*se,delta+1.959963984540054*se]
    wanted=[];counts=Counter()
    for i,(x,y) in enumerate(zip(a,z)):
        category='both_fail' if x and y else 'rescued' if x else 'harmed' if y else 'both_succeed'
        if counts[category]<3:wanted.append((i,category));counts[category]+=1
    assert wanted==[(t['index'],t['category']) for t in d['traces'] if t['design']==name]
replays=0;steps=0
with tempfile.TemporaryDirectory(prefix='representation-trace-audit-') as temp:
    binary=Path(temp)/'minsum';subprocess.run(['c++','-std=c++17','-O3',str(S/'minsum.cpp'),'-o',str(binary)],check=True)
    for trace in d['traces']:
        name=trace['design'];i=trace['index'];error=b.string_mask(errors[i])
        assert trace['error']==errors[i]
        original=next(r for r in f['records'] if r['design']==name and r['representation']=='original')
        deletion=next(r for r in f['records'] if r['design']==name and r['representation']=='delete_one')
        lost={tuple(s) for s in original['supports']}-{tuple(s) for s in deletion['supports']}
        assert trace['contains_lost_absorbing_support']==any(error&b.rowmask(s)==b.rowmask(s) for s in lost)
        meta=json.loads((S/'distance-matched-selection.json').read_text())['codes'][name]
        hx,hz,_=b.construction(meta['B'],meta['r']);xm=list(map(b.rowmask,hx));zp=b.basis(hz)
        for arm in trace['trajectories']:
            label=arm['representation'];rows=original['hx_rows'] if label=='original' else deletion['hx_rows']
            actual=b.engine(binary,rows,252,[(.04,errors[i])],100,.8)[0]
            assert actual==b.reference_decode(rows,252,errors[i],.04,100,.8)
            history=arm['history'];assert len(history)==actual[0]+1 and history[-1]['estimate']==actual[2]
            previous=0
            for j,step in enumerate(history):
                assert step['iteration']==j
                correction=b.string_mask(step['estimate']);residual=error^correction
                assert step['changed_variables']==[v for v in range(252) if (previous^correction)>>v&1]
                assert step['full_code_residual_syndrome_weight']==sum(b.syndrome(xm,residual))
                assert step['residual_is_stabilizer']==b.in_span(residual,zp)
                previous=correction;steps+=1
            residual=error^b.string_mask(actual[2])
            assert flags[name,label][i]==(not b.in_span(residual,zp))
            assert syndrome_flags[name,label][i]==(not actual[1])
            replays+=1
        left,right=[a['history'] for a in trace['trajectories']]
        divergence=next((j for j,(a,z) in enumerate(zip(left,right)) if a['estimate']!=z['estimate']),None)
        assert divergence==trace['first_common_iteration_divergence']
arithmetic=d['first_iteration_arithmetic'];prior=math.floor(math.log(24)*(1<<20)+.5);message=(800*prior+500)//1000
assert arithmetic==dict(prior=prior,message=message,syndrome_bit_cases=8)
assert 0<message<prior<2*message
print(f'PASS: all 50000 shared errors regenerated; six outcome streams and both paired contrasts reconstructed; 100000 row-order control comparisons archived; {replays} traced outcomes replayed in original C++ and direct Python; {steps} per-iteration annotations checked; first-three category selection and exact first-step arithmetic verified.')
