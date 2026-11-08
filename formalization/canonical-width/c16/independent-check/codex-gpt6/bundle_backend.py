#!/usr/bin/env python3
"""Exact B/C reduction to weighted compatibility cliques, after symmetry check."""
import argparse,contextlib,io,json,os,pathlib,subprocess,time
from solve import read,check,tau
HERE=pathlib.Path(__file__).resolve().parent

def run(pools,kind,seconds,output):
    start=time.monotonic();x,z=read(pools);n=len(x)
    assert kind in ('B','C')
    g=[[(v&w).bit_count()%2 for w in z] for v in x]
    if pools=='real':assert sum(map(sum,g))==99808
    mapped=lambda i:i if kind=='B' else tau(i)
    h=[[g[i][mapped(j)] for j in range(n)] for i in range(n)]
    symmetric=all(h[i][j]==h[j][i] for i in range(n) for j in range(n))
    output=pathlib.Path(output);output.parent.mkdir(parents=True,exist_ok=True)
    matrix=output.with_suffix('.matrix');matrix.write_text(str(n)+'\n'+'\n'.join(''.join(map(str,row)) for row in h)+'\n')
    frame=None;details=None
    for direction in (1,-1):
        chosen=[]
        for i in sorted(range(n),key=lambda i:(direction*(x[i].bit_count()+z[i].bit_count()),i)):
            if g[i][i] and all(not g[i][j] and not g[j][i] for j in chosen):chosen.append(i)
        selected=set(chosen)
        if len(selected)==128 and (kind=='B' or {tau(i) for i in selected}==selected):
            frame=[(i,i) for i in chosen];details={'status':'COMPLETE','found':True,'method':'generic weight-order diagonal search'};break
    if details is None and not symmetric:
        from sat_backend import run as general_run
        with contextlib.redirect_stdout(io.StringIO()):
            fallback=general_run(pools,kind,max(.001,seconds-(time.monotonic()-start)),output)
        fallback['seconds']=time.monotonic()-start
        fallback['notes']+=' General SAT fallback because mapped matrix was not symmetric.'
        output.write_text(json.dumps(fallback,indent=2)+'\n');print(json.dumps(fallback),flush=True)
        return fallback
    if details is None:
        result=subprocess.run([str(HERE/'bundle_clique'),str(matrix),'128',str(max(.001,seconds-(time.monotonic()-start)))],capture_output=True,text=True,check=True)
        details=json.loads(result.stdout)
        if details['found']:
            frame=[]
            for a,b in details['bundles']:
                frame.append((a,mapped(b)))
                if a!=b:frame.append((b,mapped(a)))
    details['matrix_symmetric']=symmetric
    if frame is not None:check(x,z,frame,kind,128)
    output.with_suffix('.log').write_text(json.dumps(details,indent=2)+'\n')
    r={'pools':pools,'class':kind,'status':details['status'],'frames_found':int(frame is not None),'frame':frame,'seconds':time.monotonic()-start,'notes':'Exact checked symmetric-matrix reduction and weighted clique coloring; existence decision, not count.','details':details}
    output.write_text(json.dumps(r,indent=2)+'\n');print(json.dumps(r),flush=True);return r
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--pools',choices=['real','planted1'],required=True);p.add_argument('--class',dest='kind',choices=['B','C'],required=True);p.add_argument('--seconds',type=float,default=7200);p.add_argument('--output',required=True);a=p.parse_args()
    if hasattr(os,'sched_getaffinity'):os.sched_setaffinity(0,sorted(os.sched_getaffinity(0))[:2])
    run(a.pools,a.kind,a.seconds,a.output)
