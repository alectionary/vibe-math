#!/usr/bin/env python3
"""Rebuild an exact fixed-anchor signature model after each new identity.

Zero-signature free edges may be deleted for this partial necessity test. New
equations recompute the active set from ALL compatible original source edges.
Signature-presence compression is applied only to the free graph; the fixed
anchor is outside it and its contribution is subtracted from every target.
"""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data,encode
from adaptive_matrix_identities import parity,compress

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--prior',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=180);ap.add_argument('--call-seconds',type=float,default=15);ap.add_argument('--rounds',type=int,default=30);a=ap.parse_args();start=time.monotonic()
    import pycryptosat
    A,_,_=logical_data();X,Z=[[int(s,16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']]
    all_edges=[(i,j) for i in range(720) if i!=48 and not A[i]>>48&1 for j in range(720) if j!=48 and not A[48]>>j&1 and A[i]>>j&1]
    prior=json.loads(a.prior.read_text());equations=list(prior['equations']);records=[]
    for iteration in range(a.rounds):
        if time.monotonic()-start>=a.seconds:break
        sx=[0]*720;sz=[0]*720;target=0
        for k,eq in enumerate(equations):
            u,v=int(eq['u_hex'],16),int(eq['v_hex'],16)
            for i in range(720):sx[i]|=parity(X[i],v)<<k;sz[i]|=parity(u,Z[i])<<k
            target|=(parity(u,v)^parity(X[48],v)*parity(u,Z[48]))<<k
        E=[(i,j,sx[i]&sz[j],0) for i,j in all_edges if sx[i]&sz[j]]
        clauses,n,S,events=encode(A,[0],E,with_xor=False,compress_signatures=True)
        solver=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'1000','autodisablegauss':'0'})
        for c in clauses:solver.add_clause(c)
        for k in range(len(equations)):solver.add_xor_clause([v for v,s in events if s>>k&1],bool(target>>k&1))
        call_start=time.monotonic();sat,model=solver.solve(time_limit=min(a.call_seconds,max(.01,a.seconds-(time.monotonic()-start))))
        r={'iteration':iteration,'equation_count':len(equations),'active_edges':len(E),'distinct_signatures':len(events),'answer':sat,'call_seconds':time.monotonic()-call_start}
        if sat:
            reps={}
            for k,e in enumerate(E):
                if model[k+1]:reps.setdefault(e[2],k)
            signatures=[e[2] for e in E];chosen=compress(list(reps.values()),signatures,target)
            pairs=[(48,48)]+[E[k][:2] for k in chosen];R=[1<<k for k in range(128)]
            for q,(i,j) in enumerate(pairs):
                for ii,jj in pairs[:q]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
                for b in range(128):
                    if X[i]>>b&1:R[b]^=Z[j]
            for eq in equations:
                u,v=int(eq['u_hex'],16),int(eq['v_hex'],16);assert sum(parity(X[i],v)*parity(u,Z[j]) for i,j in pairs)%2==parity(u,v)
            r['partial_matching']=pairs;r['partial_size']=len(pairs);r['residual_rows_hex']=[hex(v) for v in R]
            if any(R):
                row=next(i for i,v in enumerate(R) if v);col=(R[row]&-R[row]).bit_length()-1;r['selected_next_equation']=[row,col]
                u,v=1<<col,1<<row;equations.append({'u_hex':hex(u),'v_hex':hex(v),'label':f'compact-adaptive-entry-{row}-{col}','full_target':int(row==col),'anchor_value':parity(X[48],v)*parity(u,Z[48]),'free_edges_with_value_one':sum(parity(X[i],v)*parity(u,Z[j]) for i,j in all_edges)})
        records.append(r)
        result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'anchor':[48,48],'edge_count':len(all_edges),'equations':equations,'records':records,'elapsed_seconds':time.monotonic()-start,'compression':'Free edges only; active signatures rebuilt from all original compatible edges at every round. Not a full-frame completion test.'}
        a.output.write_text(json.dumps(result,indent=2)+'\n');print('compact matrix',r['equation_count'],sat,'partial',r.get('partial_size'),'elapsed',time.monotonic()-start,flush=True)
        if sat is not True or not any(R):break


if __name__=='__main__':main()
