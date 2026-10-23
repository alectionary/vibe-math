"""Check the local XOR-sign rule against all two million paired first steps."""
from pathlib import Path
from collections import Counter
import base64,hashlib,json,random,sys,zlib
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b
d=json.loads((S/'merged-million-results.json').read_text())
v=json.loads((S/'degree-preserving-results.json').read_text())
source=json.loads((S/'distance-matched-selection.json').read_text())
codes={};stats={}
for name,meta in source['codes'].items():
    hx,_,_=b.construction(meta['B'],14);rows=list(map(b.rowmask,hx))
    record=next(r for r in v['records'] if r['design']==name);a,z=record['representative_pair']
    other={c:{var:[i for i,row in enumerate(hx) if var in row and i!=c] for var in hx[c]} for c in [a,z]}
    assert all(len(checks)==2 for block in other.values() for checks in block.values())
    raw={key:zlib.decompress(base64.b64decode(value)) for key,value in d['trajectory_cohort'][name].items()}
    codes[name]=dict(rows=rows,a=a,z=z,other=other,raw=raw)
    stats[name]=Counter()
rng=random.Random(d['seed']);digest=hashlib.sha256()
for index in range(d['independent_noise_patterns']):
    error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
    if index:digest.update(b'\n')
    digest.update(error.encode());word=b.string_mask(error)
    for name,c in codes.items():
        sa=b.popcount(word&c['rows'][c['a']])%2;sz=b.popcount(word&c['rows'][c['z']])%2
        predicted=0
        for check,other_bit in [(c['a'],sz),(c['z'],sa)]:
            if other_bit:
                predicted+=sum(all(b.popcount(word&c['rows'][j])%2 for j in checks) for checks in c['other'][check].values())
        first=c['raw']['first_plus_one_zlib_base64'][index]-1
        assert (first==1)==(predicted>0)
        if predicted:
            assert c['raw']['changed_zlib_base64'][index]==predicted
            assert c['raw']['inside_zlib_base64'][index]==predicted
        stats[name][f'{sa}{sz}_patterns']+=1
        stats[name][f'{sa}{sz}_first_iteration_divergences']+=predicted>0
assert digest.hexdigest()==d['error_stream_sha256']
result=dict(status='exact_first_iteration_xor_rule_matches_all_paired_frames',paired_first_steps_checked=2000000,
            new_decoder_executions=0,codes={name:dict(counts) for name,counts in stats.items()},
            results_sha256=hashlib.sha256((S/'merged-million-results.json').read_bytes()).hexdigest(),
            audit_source_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
(S/'merged-first-step-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS: exact XOR-sign rule predicts presence and size/location of every first-iteration hard-decision divergence across 2000000 code/error pairs; full regenerated error hash matches; no new decoder executions.')
