"""Fixed-code min-sum trajectory census and sign/min-support partition certificates."""
from collections import Counter
from pathlib import Path
import hashlib,json,subprocess,tempfile
import pilot as p
import quantum_css as q
import targeted as t

HERE=Path(__file__).resolve().parent


def edge_data(h,n):
    edges=[(c,v) for c,row in enumerate(h) for v in row]
    ce=[[j for j,(cc,v) in enumerate(edges) if cc==c] for c in range(len(h))]
    ve=[[j for j,(c,vv) in enumerate(edges) if vv==v] for v in range(n)]
    return edges,ce,ve


def partition(h,n,target):
    edges,ce,ve=edge_data(h,n)
    def renumber(signatures):
        table={value:i for i,value in enumerate(sorted(set(signatures)))}
        return [table[x] for x in signatures]
    qc=[0]*len(edges)
    for iteration in range(len(edges)+1):
        signatures=[]
        for j,(c,v) in enumerate(edges):
            counts=Counter(qc[k] for k in ce[c] if k!=j)
            signatures.append((target[c],tuple(sorted(counts)),tuple(sorted(k for k,num in counts.items() if num%2))))
        rc=renumber(signatures)
        refined=renumber([(qc[j],tuple(sorted(rc[k] for k in ve[v] if k!=j))) for j,(c,v) in enumerate(edges)])
        if len(set(refined))==len(set(qc)):
            pc=renumber([tuple(sorted(rc[j] for j in js)) for js in ve])
            return {'q_classes':qc,'r_classes':rc,'posterior_classes':pc,'refinement_steps':iteration}
        qc=refined
    raise AssertionError('partition did not stabilize')


def certify(h,n,target,part):
    """Static local identities, independent of the observed integer messages."""
    edges,ce,ve=edge_data(h,n);qc,rc,pc=[part[k] for k in ('q_classes','r_classes','posterior_classes')]
    rs,qs,ps={},{},{}
    for j,(c,v) in enumerate(edges):
        counts=Counter(qc[k] for k in ce[c] if k!=j)
        sig=(target[c],tuple(sorted(counts)),tuple(sorted(k for k,num in counts.items() if num%2)))
        assert rc[j] not in rs or rs[rc[j]]==sig;rs[rc[j]]=sig
        sig=tuple(sorted(rc[k] for k in ve[v] if k!=j))
        assert qc[j] not in qs or qs[qc[j]]==sig;qs[qc[j]]=sig
    for v,js in enumerate(ve):
        sig=tuple(sorted(rc[j] for j in js))
        assert pc[v] not in ps or ps[pc[v]]==sig;ps[pc[v]]=sig
    supports=[sum(1<<v for v in range(n) if pc[v]==col) for col in sorted(set(pc))]
    hm=list(map(p.decoder.rowmask,h))
    columns=[sum(bit<<c for c,bit in enumerate(p.decoder.syndrome(hm,mask))) for mask in supports]
    syndrome=sum(bit<<c for c,bit in enumerate(target))
    return {'q_class_count':len(qs),'r_class_count':len(rs),'posterior_class_count':len(ps),
            'posterior_supports_hex':list(map(hex,supports)),
            'posterior_syndrome_generators_hex':list(map(hex,columns)),
            'syndrome_obstruction':not p.decoder.in_span(syndrome,p.decoder.basis(columns))}


def run():
    selection=json.loads((HERE/'targeted-selection.json').read_text())
    previous=json.loads((HERE/'targeted-results.json').read_text())
    records=[];all_counts=[]
    with tempfile.TemporaryDirectory(prefix='p11-trajectories-') as temp:
        binary=Path(temp)/'observe'
        subprocess.run(['c++','-std=c++17','-O2',str(HERE/'trajectory.cpp'),'-o',str(binary)],check=True)
        for pid in (0,2):
            for ri,selected in enumerate(selection['families'][0]['profiles'][pid]['representatives']):
                code=selected['code'];hx,hz,vx,vz=q.expansion(code['bx'],code['bz'],2)
                for sector,h in [('x',hz),('z',hx)]:
                    stored=previous['families'][0]['profiles'][pid]['representatives'][ri]['low_weight']['sector_'+sector]
                    hm=list(map(p.decoder.rowmask,h));cache={};trials=[];lines=[]
                    data=['32 16 496 50 0.8']+[str(len(row))+' '+' '.join(map(str,row)) for row in h]
                    for index,e in enumerate(t.binary_errors(32)[33:],33):
                        target=p.decoder.syndrome(hm,e);assert any(target)
                        if target not in cache:
                            part=partition(h,32,target);static=certify(h,32,target,part);cache[target]=(part,static)
                        part,static=cache[target]
                        keep=ri==0 and sector=='x' and e in (0x20001,0x5,0x11)
                        data.append('.02 '+p.decoder.bit_string(e,32)+' '+str(int(keep)))
                        data.extend(' '.join(map(str,part[key])) for key in ('q_classes','r_classes','posterior_classes'))
                        trials.append({'support':[v for v in range(32) if e>>v&1],'error_hex':hex(e),
                                       'target_syndrome_hex':hex(sum(bit<<c for c,bit in enumerate(target))),
                                       'archived_status':stored['status_codes'][index],**static,
                                       'partition_sha256':hashlib.sha256(json.dumps(part,sort_keys=True).encode()).hexdigest()})
                        if keep:trials[-1]['partition']=part
                    proc=subprocess.run([str(binary)],input='\n'.join(data)+'\n',capture_output=True,text=True,check=True)
                    outputs=[json.loads(line) for line in proc.stdout.splitlines()];assert len(outputs)==496
                    counts=Counter()
                    for index,(trial,out) in enumerate(zip(trials,outputs),33):
                        assert out['estimate_hex']==stored['estimate_hex'][index]
                        assert out['matched']==(trial['archived_status']!='2')
                        assert out['prior']==4080869
                        if trial['syndrome_obstruction']:assert not out['matched']
                        trial['trajectory']=out
                        counts[(trial['archived_status'],trial['syndrome_obstruction'])]+=1
                    record={'profile':pid,'representative':ri,'sector':sector,'parameters':code['parameters'],
                            'bx':code['bx'],'bz':code['bz'],'check_rows':h,
                            'source_pool':selected['pool_id'],'source_candidate':selected['candidate_id'],
                            'counts':[{'status':status,'obstruction':obs,'count':num} for (status,obs),num in sorted(counts.items())],
                            'pairs':trials}
                    records.append(record)
                    print(pid,ri,sector,record['counts'],flush=True)
    paths=[Path(__file__),HERE/'trajectory.cpp',HERE.parent/'TRAJECTORY-PROTOCOL.md',
           HERE/'targeted-selection.json',HERE/'targeted-results.json',HERE/'pilot.py',HERE/'quantum_css.py',
           p.OLD/'minsum.cpp',p.OLD/'benchmark_decoding.py']
    result={'status':'fixed_32_qubit_trajectory_census_and_static_min_sum_symmetry_certificates',
            'pairs':3968,'codes_reused':4,'sector_graph_instances':8,'witness_full_traces':6,
            'new_noise_samples':0,'settings':{'p':.02,'alpha':.8,'iterations':50,'scale':1<<20,'prior':4080869,'saturation':50*(1<<20)},
            'records':records,'sha256':{str(path.relative_to(p.ROOT)):hashlib.sha256(path.read_bytes()).hexdigest() for path in paths}}
    (HERE/'trajectory-results.json').write_text(json.dumps(result,indent=2)+'\n')


if __name__=='__main__':run()
