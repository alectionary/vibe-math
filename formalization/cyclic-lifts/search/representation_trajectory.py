"""Fixed same-code deletion pilot with independently checked full histories."""
from collections import Counter
from itertools import product
from math import floor,log,sqrt
from pathlib import Path
import hashlib,json,random,subprocess,tempfile
import benchmark_decoding as b

HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
N,SEED,P=50000,20261026,.04
LABELS=['original','row_order_control','delete_one']


def reference_history(h,n,error,p=.04,max_iter=100,alpha=.8):
    target=b.syndrome(list(map(b.rowmask,h)),b.string_mask(error))
    scale=1<<20;prior=floor(log((1-p)/p)*scale+.5);a=floor(alpha*1000+.5)
    q={(c,v):prior for c,row in enumerate(h) for v in row}
    incident=[[c for c,row in enumerate(h) if v in row] for v in range(n)]
    history=['0'*n]
    if not any(target):return history
    clip=lambda x:max(-50*scale,min(50*scale,x))
    for _ in range(max_iter):
        messages={}
        for c,row in enumerate(h):
            for v in row:
                others=[q[c,w] for w in row if w!=v]
                sign=(-1 if target[c] else 1)
                for x in others:
                    if x<0:sign=-sign
                messages[c,v]=clip(sign*((a*min(map(abs,others))+500)//1000))
        post=[prior+sum(messages[c,v] for c in incident[v]) for v in range(n)]
        estimate=''.join('1' if x<0 else '0' for x in post)
        history.append(estimate)
        if b.syndrome(list(map(b.rowmask,h)),b.string_mask(estimate))==target:return history
        q={(c,v):clip(prior+sum(messages[d,v] for d in incident[v] if d!=c)) for c,v in q}
    return history


def first_step(h,error):
    syn=b.syndrome(list(map(b.rowmask,h)),b.string_mask(error))
    scale=1<<20;prior=floor(log(24)*scale+.5);message=(800*prior+500)//1000
    return ''.join('1' if prior+sum(message*(-1 if syn[c] else 1) for c,row in enumerate(h) if v in row)<0 else '0' for v in range(252))


def run():
    feasibility=json.loads((HERE/'representation-results.json').read_text())
    for rel,digest in feasibility['sha256'].items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==digest
    paths=[Path(__file__),HERE/'representation-results.json',HERE/'benchmark_decoding.py',HERE/'minsum.cpp',
           HERE.parent/'REPRESENTATION-TRAJECTORY-PROTOCOL.md']
    frozen=dict(seed=SEED,trials=N,p=P,representations=LABELS,
                sha256={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths})
    (HERE/'representation-trajectory-selection.json').write_text(json.dumps(frozen,indent=2)+'\n')
    rng=random.Random(SEED)
    errors=[''.join('1' if rng.random()<P else '0' for _ in range(252)) for _ in range(N)]
    masks=list(map(b.string_mask,errors));trials=[(P,e) for e in errors]
    stream=hashlib.sha256('\n'.join(errors).encode()).hexdigest()
    records=[];contrasts=[];traces=[];control_checks=0
    scale=1<<20;prior=floor(log(24)*scale+.5);message=(800*prior+500)//1000
    assert 0<message<prior<2*message
    for bits in product([0,1],repeat=3):
        original=int(prior+sum(message*(-1 if bit else 1) for bit in bits)<0)
        deletion=int(prior+sum(message*(-1 if bit else 1) for bit in bits[1:])<0)
        assert original==int(all(bits)) and deletion==int(all(bits[1:]))
    with tempfile.TemporaryDirectory(prefix='same-code-trajectories-') as tmp:
        binary=Path(tmp)/'minsum';tracer=Path(tmp)/'trace';trace_source=Path(tmp)/'trace.cpp'
        source=(HERE/'minsum.cpp').read_text()
        needle0='if (h.syndrome(estimate)==s) return {estimate,0,true};'
        needle1='if (h.syndrome(estimate)==s) return {estimate,it,true};'
        assert source.count(needle0)==source.count(needle1)==1
        instrumented=source.replace(needle0,'std::cerr << "TRACE 0 " << estimate << "\\n";\n  '+needle0)
        instrumented=instrumented.replace(needle1,'std::cerr << "TRACE " << it << " " << estimate << "\\n";\n    '+needle1)
        trace_source.write_text(instrumented)
        for src,out in [(HERE/'minsum.cpp',binary),(trace_source,tracer)]:
            subprocess.run(['c++','-std=c++17','-O3',str(src),'-o',str(out)],check=True)
        for name in ['previous_best','minimum_4']:
            subset={r['representation']:r for r in feasibility['records'] if r['design']==name and r['representation'] in LABELS}
            meta=json.loads((HERE/'distance-matched-selection.json').read_text())['codes'][name]
            hx,hz,_=b.construction(meta['B'],meta['r']);xm=list(map(b.rowmask,hx));zp=b.basis(hz)
            outcomes={};failed={}
            for label in LABELS:
                rows=subset[label]['hx_rows'];out=b.engine(binary,rows,252,trials,100,.8)
                flags=bytearray();sf=bytearray();counts=Counter()
                for error,(it,matched,estimate) in zip(masks,out):
                    residual=error^b.string_mask(estimate)
                    assert matched==(not any(b.syndrome(xm,residual)))
                    assert matched==(not any(b.syndrome(list(map(b.rowmask,rows)),residual)))
                    ok=b.in_span(residual,zp);assert not ok or matched
                    counts['exact_recovery']+=residual==0
                    counts['stabilizer_equivalent_success']+=ok and residual!=0
                    counts['syndrome_failure']+=not matched
                    counts['matched_logical_failure']+=matched and not ok
                    counts['iteration_sum']+=it
                    flags.append(not ok);sf.append(not matched)
                outcomes[label]=out;failed[label]=flags
                records.append(dict(design=name,representation=label,trials=N,p=P,**counts,
                                    failure_count=sum(flags),failure_rate=sum(flags)/N,
                                    failure_flags_zlib_base64=b.pack(flags),syndrome_failure_flags_zlib_base64=b.pack(sf)))
                print(name,label,'failures',sum(flags),flush=True)
            assert outcomes['original']==outcomes['row_order_control'];control_checks+=N
            left,right=failed['original'],failed['delete_one']
            better=sum(a and not z for a,z in zip(left,right));worse=sum(z and not a for a,z in zip(left,right))
            delta=(worse-better)/N;se=sqrt((better+worse-N*delta**2)/(N*(N-1)))
            contrasts.append(dict(design=name,original_failed_deletion_succeeded=better,
                                  original_succeeded_deletion_failed=worse,difference=delta,
                                  pointwise_paired_95_interval=[delta-1.959963984540054*se,delta+1.959963984540054*se]))
            lost={tuple(s) for s in subset['original']['supports']}-{tuple(s) for s in subset['delete_one']['supports']}
            lost_masks=[b.rowmask(s) for s in sorted(lost)]
            selected=Counter()
            for i,(a,z) in enumerate(zip(left,right)):
                category=('both_fail' if a and z else 'rescued' if a else 'harmed' if z else 'both_succeed')
                if selected[category]>=3:continue
                selected[category]+=1;pair=[]
                for label in ['original','delete_one']:
                    rows=subset[label]['hx_rows']
                    data=[f'252 {len(rows)} 1 100 0.8']+[str(len(row))+' '+' '.join(map(str,row)) for row in rows]+[f'.04 {errors[i]}']
                    proc=subprocess.run([str(tracer)],input='\n'.join(data)+'\n',capture_output=True,text=True,check=True)
                    it,matched,estimate=proc.stdout.split()
                    assert (int(it),bool(int(matched)),estimate)==outcomes[label][i]
                    history=[]
                    for j,line in enumerate(proc.stderr.splitlines()):
                        tag,step,decision=line.split();assert tag=='TRACE' and int(step)==j
                        history.append(decision)
                    assert history==reference_history(rows,252,errors[i])
                    assert history[-1]==estimate
                    if len(history)>1:assert history[1]==first_step(rows,errors[i])
                    annotated=[];previous=0
                    for step,decision in enumerate(history):
                        correction=b.string_mask(decision);residual=masks[i]^correction
                        annotated.append(dict(iteration=step,estimate=decision,
                                              changed_variables=[v for v in range(252) if (correction^previous)>>v&1],
                                              full_code_residual_syndrome_weight=sum(b.syndrome(xm,residual)),
                                              residual_is_stabilizer=b.in_span(residual,zp)))
                        previous=correction
                    pair.append(dict(representation=label,history=annotated))
                divergence=next((j for j,(x,y) in enumerate(zip(pair[0]['history'],pair[1]['history'])) if x['estimate']!=y['estimate']),None)
                traces.append(dict(design=name,index=i,error=errors[i],category=category,
                                   contains_lost_absorbing_support=any(masks[i]&w==w for w in lost_masks),
                                   first_common_iteration_divergence=divergence,trajectories=pair))
    for rel,digest in frozen['sha256'].items():assert hashlib.sha256((ROOT/rel).read_bytes()).hexdigest()==digest
    out=dict(status='fixed_same_code_generator_deletion_mechanism_pilot',seed=SEED,p=P,
             independent_error_patterns=N,decoder_executions=6*N,error_stream_sha256=stream,
             row_order_exact_outcome_checks=control_checks,results=records,contrasts=contrasts,traces=traces,
             first_iteration_arithmetic=dict(prior=prior,message=message,syndrome_bit_cases=8),sha256=frozen['sha256'])
    (HERE/'representation-trajectory-results.json').write_text(json.dumps(out,indent=2)+'\n')


if __name__=='__main__':run()
