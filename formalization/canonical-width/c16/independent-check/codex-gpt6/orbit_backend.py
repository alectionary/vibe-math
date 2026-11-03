#!/usr/bin/env python3
import argparse,json,os,pathlib,subprocess,time
from solve import read,check,tau
HERE=pathlib.Path(__file__).resolve().parent

def run(pools,kind,seconds,output):
    start=time.monotonic();x,z=read(pools);n=len(x);k={'A':8,'quarter':4}[kind];size=16//k
    g=[[(v&w).bit_count()%2 for w in z] for v in x]
    if pools=='real':assert sum(map(sum,g))==99808
    assert all(g[i][j]==g[tau(i,k)][tau(j,k)] for i in range(n) for j in range(n)), 'Orbit reduction requires checked simultaneous invariance'
    groups=[[tau(i,r*k) for r in range(size)] for i in range(n) if i%16<k]
    h=[]
    for a in groups:
        row=''
        for b in groups:
            degrees=[sum(g[i][j] for j in b) for i in a]
            columns=[sum(g[i][j] for i in a) for j in b]
            assert len(set(degrees+columns))==1
            row+='0' if degrees[0]==0 else '1' if degrees[0]==1 else '2'
        h.append(row)
    output=pathlib.Path(output);output.parent.mkdir(parents=True,exist_ok=True)
    matrix=output.with_suffix('.matrix');matrix.write_text(str(len(groups))+'\n'+'\n'.join(h)+'\n')
    details=None
    for direction in (1,-1):
        chosen=[]
        for i in sorted(range(n),key=lambda i:(direction*(x[i].bit_count()+z[i].bit_count()),i)):
            if g[i][i] and all(not g[i][j] and not g[j][i] for j in chosen):chosen.append(i)
        selected=set(chosen)
        if len(selected)==128 and {tau(i,k) for i in selected}==selected:
            details={'status':'COMPLETE','found':True,'method':'generic weight-order diagonal search','orbit_pairs':[(a,a) for a,group in enumerate(groups) if set(group)<=selected]}
            break
    if details is None:
        remaining=max(.001,seconds-(time.monotonic()-start))
        result=subprocess.run([str(HERE/'orbit_clique'),str(matrix),str(128//size),str(remaining)],capture_output=True,text=True,check=True)
        details=json.loads(result.stdout)
    output.with_suffix('.log').write_text(json.dumps(details,indent=2)+'\n')
    frame=None
    if details['found']:
        frame=[(i,j) for a,b in details['orbit_pairs'] for i in groups[a] for j in groups[b] if g[i][j]]
        check(x,z,frame,kind,128)
    r={'pools':pools,'class':kind,'status':details['status'],'frames_found':int(frame is not None),'frame':frame,'seconds':time.monotonic()-start,'notes':'Exact invariant-orbit reduction and clique coloring search; existence decision, not count.','details':details}
    output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True);return r
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--pools',choices=['real','planted1'],required=True);p.add_argument('--class',dest='kind',choices=['A','quarter'],required=True);p.add_argument('--seconds',type=float,default=7200);p.add_argument('--output',required=True);a=p.parse_args()
    if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
    run(a.pools,a.kind,a.seconds,a.output)
