"""Audit noise, cohort divergence streams, paired effects and full traces."""
from collections import Counter
from pathlib import Path
from statistics import NormalDist
import base64,hashlib,json,math,random,subprocess,sys,tempfile,zlib
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent.parent;S=R/'formalization/cyclic-lifts/search'
sys.path.insert(0,str(S))
import benchmark_decoding as b
from representation_trajectory import reference_history
NAMES=['previous_best','minimum_4'];LABELS=['original','merged'];CLASSES=['exact','stabilizer','syndrome','logical']


def raw(encoded,n):
    data=zlib.decompress(base64.b64decode(encoded));assert len(data)==n;return data


def bits(encoded,n):
    data=raw(encoded,(n+7)//8)
    return bytearray(bool(data[i//8]&(1<<(i%8))) for i in range(n))


d=json.loads((S/'merged-million-results.json').read_text())
s=json.loads((S/'merged-million-selection.json').read_text())
v=json.loads((S/'degree-preserving-results.json').read_text())
assert d['selection_sha256']==hashlib.sha256((S/'merged-million-selection.json').read_bytes()).hexdigest()
for rel,digest in s['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
for rel,digest in v['sha256'].items():assert hashlib.sha256((R/rel).read_bytes()).hexdigest()==digest,rel
assert s['seed']==d['seed']==20261027 and s['p']==d['p']==.04
n=d['independent_noise_patterns'];assert n==s['trials']==1000000 and d['decoder_executions']==4000000
assert s['alpha']==.8 and s['max_iterations']==100 and s['batch']==20000
assert d['wrapper_stock_outcome_checks']==128 and d['batching_pair_checks']==64
assert d['decoder_checks']['total_decoder_checks']==1148 and d['decoder_checks']['engine_reference_cases']==128
arms={};cohort={};codes={};expected_trace_indices={};expected_reasons={}
for row in d['results']:
    key=(row['design'],row['representation']);assert row['trials']==n and row['p']==.04
    fail=bits(row['failure_flags_zlib_base64'],n);syn=bits(row['syndrome_flags_zlib_base64'],n)
    stab=bits(row['stabilizer_flags_zlib_base64'],n);iters=raw(row['iterations_zlib_base64'],n)
    assert all(not x or y for x,y in zip(syn,fail)) and all(not x or not y for x,y in zip(stab,fail))
    kind=bytearray(2 if a else 3 if z else 1 if t else 0 for a,z,t in zip(syn,fail,stab))
    counts=Counter(kind)
    assert all(counts[i]==row[name] for i,name in enumerate(CLASSES))
    assert sum(fail)==row['failure_count']==row['syndrome']+row['logical']
    assert row['failure_rate']==sum(fail)/n and row['wilson_95_interval']==b.wilson(sum(fail),n)
    assert max(iters)<=100 and sum(iters)==row['iteration_sum']
    assert sum(t for t,a in zip(iters,syn) if not a)==row['matched_iteration_sum']
    assert row['mean_iterations']==sum(iters)/n
    assert row['mean_iterations_given_syndrome_match']==row['matched_iteration_sum']/(n-row['syndrome'])
    arms[key]=dict(fail=fail,syn=syn,stab=stab,iters=iters,kind=kind)
assert len(arms)==4
for name in NAMES:
    rec=next(r for r in v['records'] if r['design']==name)
    meta=json.loads((S/'distance-matched-selection.json').read_text())['codes'][name]
    hx,hz,_=b.construction(meta['B'],14)
    codes[name]=dict(original=hx,merged=rec['hx_rows'],xm=list(map(b.rowmask,hx)),zp=b.basis(hz),
                     gained=[b.rowmask(x) for x in rec['gained_supports']],pair=rec['representative_pair'])
    cohort[name]={key.removesuffix('_zlib_base64'):raw(value,n) for key,value in d['trajectory_cohort'][name].items()}
    a,z=arms[name,'original'],arms[name,'merged'];h=cohort[name]
    first_hist=Counter();category_hist={};transition_hist=Counter();strata=Counter()
    seen=Counter();transitions_seen=set();wanted=[];reasons={}
    for i in range(n):
        x,y=a['kind'][i],z['kind'][i];fa=x>=2;fz=y>=2
        category='both_fail' if fa and fz else 'rescued' if fa else 'harmed' if fz else 'both_succeed'
        transition=CLASSES[x]+'->'+CLASSES[y];first=h['first_plus_one'][i]-1
        assert -1<=first<=100 and first!=0
        different,changed,inside=h['different'][i],h['changed'][i],h['inside'][i]
        assert inside<=changed and h['source_bits'][i]<=3 and h['contains'][i]<=1
        if first<0:
            assert different==changed==inside==0 and a['iters'][i]==z['iters'][i] and x==y
        else:
            assert 1<=first<=min(a['iters'][i],z['iters'][i])
            assert 1<=different<=min(a['iters'][i],z['iters'][i]) and changed>0
            if first==1:assert changed==inside
        if fa!=fz:assert first>=1
        first_hist[first]+=1;category_hist.setdefault(category,Counter())[first]+=1;transition_hist[transition]+=1
        source_bits=h['source_bits'][i];strata[f'{source_bits//2}{source_bits%2}|{transition}|{h["contains"][i]}']+=1
        why=[]
        if seen[category]<3:why.append('first_three_'+category)
        seen[category]+=1
        if transition not in transitions_seen:why.append('first_'+transition)
        transitions_seen.add(transition)
        if why:wanted.append(i);reasons[i]=why
    saved=d['histograms'][name]
    assert dict(first_hist)=={int(k):v for k,v in saved['first'].items()}
    assert {cat:dict(h) for cat,h in category_hist.items()}=={cat:{int(k):v for k,v in h.items()} for cat,h in saved['category'].items()}
    assert dict(transition_hist)==saved['transitions'] and dict(strata)==saved['strata']
    expected_trace_indices[name]=wanted;expected_reasons[name]=reasons
    c=next(c for c in d['contrasts'] if c['design']==name)
    better=sum(x and not y for x,y in zip(a['fail'],z['fail']));worse=sum(y and not x for x,y in zip(a['fail'],z['fail']))
    delta=(worse-better)/n;se=math.sqrt((better+worse-n*delta**2)/(n*(n-1)))
    assert (better,worse)==(c['original_failed_merged_succeeded'],c['original_succeeded_merged_failed'])
    assert delta==c['difference_merged_minus_original'] and se==c['standard_error']
    for quantile,key in [(.975,'paired_95_interval'),(.9875,'bonferroni_simultaneous_95_interval')]:
        zscore=NormalDist().inv_cdf(quantile);assert c[key]==[delta-zscore*se,delta+zscore*se]
    assert [t['index'] for t in d['traces'] if t['design']==name]==wanted
    print(name,'PASS: all cohort divergence summaries, selection and paired intervals reconstructed',flush=True)
rng=random.Random(s['seed']);stream=hashlib.sha256();trace_errors={(t['design'],t['index']):t['error'] for t in d['traces']}
assert [b['offset'] for b in d['batches']]==list(range(0,n,s['batch']))
for batch in d['batches']:
    start,size=batch['offset'],batch['trials'];assert size==min(s['batch'],n-start)
    errors=[''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for _ in range(size)]
    payload='\n'.join(errors).encode();assert hashlib.sha256(payload).hexdigest()==batch['error_sha256']
    if start:stream.update(b'\n')
    stream.update(payload)
    for name,c in codes.items():
        for j,error in enumerate(errors):
            i=start+j;mask=b.string_mask(error);h=cohort[name]
            if (name,i) in trace_errors:assert trace_errors[name,i]==error
            a,z=c['pair'];initial=2*(b.popcount(mask&c['xm'][a])%2)+(b.popcount(mask&c['xm'][z])%2)
            assert initial==h['source_bits'][i]
            assert bool(h['contains'][i])==any(mask&w==w for w in c['gained'])
        for label in LABELS:
            arm=arms[name,label];saved=batch['arms'][name+'/'+label];end=start+size
            cnt=Counter(arm['kind'][start:end]);assert all(cnt[i]==saved.get(name,0) for i,name in enumerate(CLASSES))
            assert sum(arm['iters'][start:end])==saved['iteration_sum']
            assert sum(t for t,a in zip(arm['iters'][start:end],arm['syn'][start:end]) if not a)==saved['matched_iteration_sum']
    if (start+size)%200000==0:print('Regenerated/checked',start+size,'errors including all gained-support containment annotations',flush=True)
assert stream.hexdigest()==d['error_stream_sha256']
checked_traces=0;checked_steps=0
with tempfile.TemporaryDirectory(prefix='merged-million-audit-') as tmp:
    binary=Path(tmp)/'stock';subprocess.run(['c++','-std=c++17','-O3',str(S/'minsum.cpp'),'-o',str(binary)],check=True)
    for trace in d['traces']:
        name=trace['design'];i=trace['index'];c=codes[name];error=b.string_mask(trace['error'])
        assert trace['reasons']==expected_reasons[name][i]
        for label in LABELS:
            history=trace['histories'][label];decisions=[r['estimate'] for r in history]
            assert decisions==reference_history(c[label],252,trace['error'])
            outcome=b.engine(binary,c[label],252,[(.04,trace['error'])],100,.8)[0]
            summary=trace['summary'][label]
            assert outcome==(summary[0],summary[1],summary[2])
            assert len(history)==outcome[0]+1 and decisions[-1]==outcome[2]
            previous=0
            for step,annotation in enumerate(history):
                assert annotation['iteration']==step
                correction=b.string_mask(annotation['estimate']);residual=error^correction
                assert annotation['changed_variables']==[v for v in range(252) if (correction^previous)>>v&1]
                assert annotation['full_original_syndrome_weight']==sum(b.syndrome(c['xm'],residual))
                assert annotation['residual_is_stabilizer']==b.in_span(residual,c['zp'])
                assert annotation['residual_contains_gained_support']==any(residual&w==w for w in c['gained'])
                previous=correction;checked_steps+=1
            terminal=arms[name,label]['kind'][i];residual=error^b.string_mask(outcome[2])
            expected=0 if not residual else 1 if b.in_span(residual,c['zp']) else 2 if not outcome[1] else 3
            assert expected==terminal and outcome[0]==arms[name,label]['iters'][i]
            if len(history)>1:
                syn=b.syndrome(list(map(b.rowmask,c[label])),error)
                predicted=''.join('1' if all(syn[row] for row,vs in enumerate(c[label]) if v in vs) else '0' for v in range(252))
                assert predicted==history[1]['estimate']
            checked_traces+=1
        left,right=[trace['histories'][l] for l in LABELS]
        different=[j for j,(a,z) in enumerate(zip(left,right)) if a['estimate']!=z['estimate']]
        first=different[0] if different else -1
        assert first==cohort[name]['first_plus_one'][i]-1 and len(different)==cohort[name]['different'][i]
        if first>=0:
            changed=[v for v in range(252) if left[first]['estimate'][v]!=right[first]['estimate'][v]]
            affected=set(c['original'][c['pair'][0]])|set(c['original'][c['pair'][1]])
            assert len(changed)==cohort[name]['changed'][i]
            assert len(affected.intersection(changed))==cohort[name]['inside'][i]
        print(name,'trace',i,'PASS',flush=True)
print(f'PASS: 1000000 regenerated shared errors, 4000000 outcomes, both adjusted contrasts, full-cohort divergence/containment summaries; {checked_traces} original-C++/Python trajectory replays and {checked_steps} per-iteration annotations. All frozen inputs unchanged.')
