"""Fixed one-million-error, two-code merger comparison and cohort trajectories."""
from collections import Counter
from pathlib import Path
from statistics import NormalDist
import base64,hashlib,json,math,random,subprocess,tempfile,time,zlib
import benchmark_decoding as b
from merged_engine import compile_engine,run_engine
from representation_trajectory import reference_history,first_step
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
N,SEED,P,BATCH=1000000,20261027,.04,20000
NAMES=['previous_best','minimum_4'];LABELS=['original','merged']
CLASSES=['exact','stabilizer','syndrome','logical']


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def packed(raw):return base64.b64encode(zlib.compress(bytes(raw),9)).decode()


def contrast(left,right):
    better=sum(a and not z for a,z in zip(left,right));worse=sum(z and not a for a,z in zip(left,right))
    n=len(left);delta=(worse-better)/n
    se=math.sqrt((better+worse-n*delta**2)/(n*(n-1)))
    z=NormalDist().inv_cdf(.975);zb=NormalDist().inv_cdf(.9875)
    return dict(original_failed_merged_succeeded=better,original_succeeded_merged_failed=worse,
                difference_merged_minus_original=delta,standard_error=se,
                paired_95_interval=[delta-z*se,delta+z*se],
                bonferroni_simultaneous_95_interval=[delta-zb*se,delta+zb*se])


def run():
    started=time.monotonic()
    verified=json.loads((HERE/'degree-preserving-results.json').read_text())
    for rel,digest in verified['sha256'].items():assert sha(ROOT/rel)==digest,rel
    paths=[Path(__file__),HERE/'merged_engine.py',HERE/'merged_pair.cpp',HERE/'minsum.cpp',
           HERE/'benchmark_decoding.py',HERE/'representation_trajectory.py',
           HERE/'degree-preserving-results.json',HERE/'distance-matched-selection.json',
           HERE.parent/'MERGED-MILLION-PROTOCOL.md']
    frozen=dict(status='fixed_before_new_noise_and_outcomes',seed=SEED,trials=N,p=P,batch=BATCH,
                alpha=.8,max_iterations=100,contrasts=['merged minus original within '+n for n in NAMES],
                sha256={str(p.relative_to(ROOT)):sha(p) for p in paths})
    selection_path=HERE/'merged-million-selection.json'
    selection_path.write_text(json.dumps(frozen,indent=2)+'\n');selection_sha=sha(selection_path)
    source=json.loads((HERE/'distance-matched-selection.json').read_text())
    codes={};selected={}
    for name in NAMES:
        meta=source['codes'][name];hx,hz,_=b.construction(meta['B'],14)
        rec=next(r for r in verified['records'] if r['design']==name)
        assert (meta['d_x'],meta['d_z'])==(10,10)
        codes[name]=dict(original=hx,merged=rec['hx_rows'],pair=rec['representative_pair'],
                         gained=rec['gained_supports'],xm=list(map(b.rowmask,hx)),zp=b.basis(hz),hz=hz,
                         original_count=rec['original_absorbing_count'],merged_count=rec['merged_absorbing_count'])
        for label in LABELS:selected[name+'/'+label]=(codes[name][label],hz,meta)
    flags={(n,l):bytearray() for n in NAMES for l in LABELS}
    synflags={key:bytearray() for key in flags};stabs={key:bytearray() for key in flags}
    iterations={key:bytearray() for key in flags};counts={key:Counter() for key in flags}
    cohort={name:{key:bytearray() for key in ['first_plus_one','different','changed','inside','contains','source_bits']} for name in NAMES}
    histograms={name:dict(first=Counter(),category={},transitions=Counter(),strata=Counter()) for name in NAMES}
    category_seen={name:Counter() for name in NAMES};transition_seen={name:set() for name in NAMES}
    chosen={name:{} for name in NAMES};stream=hashlib.sha256();rng=random.Random(SEED)
    batches=[];traces=[];wrapper_checks=0
    with tempfile.TemporaryDirectory(prefix='merged-million-') as tmp:
        binary=Path(tmp)/'paired';stock=Path(tmp)/'stock'
        compile_engine(binary)
        subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
        decoder_checks=b.validate(stock,selected)
        control_rng=random.Random(881903)
        test=[(P,''.join('1' if control_rng.random()<P else '0' for _ in range(252))) for _ in range(32)]
        for name,c in codes.items():
            whole,_=run_engine(binary,c['original'],c['merged'],c['pair'],c['gained'],test)
            left,_=run_engine(binary,c['original'],c['merged'],c['pair'],c['gained'],test[:13])
            right,_=run_engine(binary,c['original'],c['merged'],c['pair'],c['gained'],test[13:])
            assert whole==left+right
            for label in LABELS:
                expected=b.engine(stock,c[label],252,test,100,.8)
                assert expected==[r[label] for r in whole];wrapper_checks+=len(test)
        for offset in range(0,N,BATCH):
            size=min(BATCH,N-offset)
            errors=[''.join('1' if rng.random()<P else '0' for _ in range(252)) for _ in range(size)]
            masks=list(map(b.string_mask,errors));trials=[(P,e) for e in errors]
            payload='\n'.join(errors).encode()
            if offset:stream.update(b'\n')
            stream.update(payload)
            batch=dict(offset=offset,trials=size,error_sha256=hashlib.sha256(payload).hexdigest(),arms={})
            for name,c in codes.items():
                paired,_=run_engine(binary,c['original'],c['merged'],c['pair'],c['gained'],trials)
                local={label:Counter() for label in LABELS}
                for j,(error,outcome) in enumerate(zip(masks,paired)):
                    terminal=[]
                    for label in LABELS:
                        key=(name,label);it,matched,estimate=outcome[label]
                        residual=error^b.string_mask(estimate)
                        assert matched==(not any(b.syndrome(c['xm'],residual)))
                        ok=b.in_span(residual,c['zp']);assert not ok or matched
                        kind=0 if residual==0 else 1 if ok else 2 if not matched else 3
                        terminal.append(kind)
                        local[label][CLASSES[kind]]+=1
                        local[label]['iteration_sum']+=it
                        local[label]['matched_iteration_sum']+=it if matched else 0
                        flags[key].append(not ok);synflags[key].append(not matched)
                        stabs[key].append(kind==1);iterations[key].append(it)
                    a,z=terminal;failed_a=a>=2;failed_z=z>=2
                    category='both_fail' if failed_a and failed_z else 'rescued' if failed_a else 'harmed' if failed_z else 'both_succeed'
                    transition=CLASSES[a]+'->'+CLASSES[z]
                    first=outcome['first'];assert -1<=first<=100 and first!=0
                    if failed_a!=failed_z:assert first>=1
                    i,jcheck=c['pair']
                    source_bits=[b.popcount(error&c['xm'][q])%2 for q in [i,jcheck]]
                    assert outcome['source_syndrome']==source_bits
                    for key,value in [('first_plus_one',first+1),('different',outcome['different']),
                                      ('changed',outcome['changed']),('inside',outcome['inside']),
                                      ('contains',int(outcome['contains'])),('source_bits',2*source_bits[0]+source_bits[1])]:
                        cohort[name][key].append(value)
                    h=histograms[name];h['first'][first]+=1;h['category'].setdefault(category,Counter())[first]+=1
                    h['transitions'][transition]+=1
                    h['strata'][f'{source_bits[0]}{source_bits[1]}|{transition}|{int(outcome["contains"])}']+=1
                    reasons=[]
                    if category_seen[name][category]<3:reasons.append('first_three_'+category)
                    category_seen[name][category]+=1
                    if transition not in transition_seen[name]:reasons.append('first_'+transition)
                    transition_seen[name].add(transition)
                    if reasons:chosen[name][offset+j]=dict(index=offset+j,error=errors[j],category=category,
                                                         transition=transition,reasons=reasons,summary=outcome)
                for label in LABELS:
                    counts[name,label].update(local[label]);batch['arms'][name+'/'+label]=dict(local[label])
            batches.append(batch)
            print(f'{offset+size}/{N} shared errors; '+', '.join(f'{name}/{label}={sum(flags[name,label])}' for name in NAMES for label in LABELS)+f'; elapsed {time.monotonic()-started:.1f}s',flush=True)
        # All outcome-based trace selection is fixed by the protocol; no hand picks.
        for name,c in codes.items():
            gained_masks=[b.rowmask(s) for s in c['gained']]
            for index,selected_trace in sorted(chosen[name].items()):
                error=b.string_mask(selected_trace['error'])
                outcomes,histories=run_engine(binary,c['original'],c['merged'],c['pair'],c['gained'],[(P,selected_trace['error'])],full=True)
                assert outcomes==[selected_trace['summary']]
                annotations={}
                for label in LABELS:
                    history=histories[label]
                    assert history==reference_history(c[label],252,selected_trace['error'])
                    assert b.engine(stock,c[label],252,[(P,selected_trace['error'])],100,.8)[0]==selected_trace['summary'][label]
                    if len(history)>1:assert history[1]==first_step(c[label],selected_trace['error'])
                    previous=0;annotated=[]
                    for it,decision in enumerate(history):
                        correction=b.string_mask(decision);residual=error^correction
                        annotated.append(dict(iteration=it,estimate=decision,
                                              changed_variables=[v for v in range(252) if (correction^previous)>>v&1],
                                              full_original_syndrome_weight=sum(b.syndrome(c['xm'],residual)),
                                              residual_is_stabilizer=b.in_span(residual,c['zp']),
                                              residual_contains_gained_support=any(residual&w==w for w in gained_masks)))
                        previous=correction
                    annotations[label]=annotated
                assert selected_trace['summary']['contains']==any(error&w==w for w in gained_masks)
                traces.append(dict(design=name,**selected_trace,histories=annotations))
            print(name,'complete checked trace pairs',len(chosen[name]),flush=True)
    results=[]
    for name in NAMES:
        for label in LABELS:
            key=(name,label);c=counts[key];assert sum(c[k] for k in CLASSES)==N
            failures=sum(flags[key])
            results.append(dict(design=name,representation=label,trials=N,p=P,**c,
                                failure_count=failures,failure_rate=failures/N,wilson_95_interval=b.wilson(failures,N),
                                mean_iterations=c['iteration_sum']/N,
                                mean_iterations_given_syndrome_match=c['matched_iteration_sum']/(N-c['syndrome']),
                                failure_flags_zlib_base64=b.pack(flags[key]),syndrome_flags_zlib_base64=b.pack(synflags[key]),
                                stabilizer_flags_zlib_base64=b.pack(stabs[key]),iterations_zlib_base64=packed(iterations[key])))
    contrasts=[dict(design=name,**contrast(flags[name,'original'],flags[name,'merged'])) for name in NAMES]
    for rel,digest in frozen['sha256'].items():assert sha(ROOT/rel)==digest,rel
    assert sha(selection_path)==selection_sha
    out=dict(status='fixed_one_million_shared_errors_original_vs_merged',seed=SEED,p=P,independent_noise_patterns=N,
             decoder_executions=4*N,selection_sha256=selection_sha,error_stream_sha256=stream.hexdigest(),
             decoder_checks=decoder_checks,wrapper_stock_outcome_checks=wrapper_checks,batching_pair_checks=64,
             results=results,contrasts=contrasts,batches=batches,traces=traces,
             trajectory_cohort={name:{key+'_zlib_base64':packed(raw) for key,raw in data.items()} for name,data in cohort.items()},
             histograms={name:dict(first=dict(h['first']),category={k:dict(v) for k,v in h['category'].items()},
                                   transitions=dict(h['transitions']),strata=dict(h['strata'])) for name,h in histograms.items()},
             elapsed_seconds=time.monotonic()-started)
    (HERE/'merged-million-results.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(contrasts,indent=2),flush=True)


if __name__=='__main__':run()
