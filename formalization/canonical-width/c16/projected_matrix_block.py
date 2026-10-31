#!/usr/bin/env python3
"""Structured inverse-matrix blocks with an exact conditional rank target.

U is an independent source-vector family; V is an explicit auxiliary dual.
Every full source frame satisfies ALL r^2 equations of their Gram identity.
After fixing an anchor, its subtracted target H has rank<=#free selected pairs.
SAT models are partial necessity witnesses only, never full-frame completions.
"""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data,encode
from adaptive_matrix_identities import parity,compress
from select_residual_witness import rank

ROOT=Path(__file__).resolve().parent


def dual(vectors):
    n=len(vectors);rows=list(vectors);labels=[1<<i for i in range(n)];pivots=[];k=0
    for col in range(128):
        q=next((j for j in range(k,n) if rows[j]>>col&1),None)
        if q is None:continue
        rows[k],rows[q]=rows[q],rows[k];labels[k],labels[q]=labels[q],labels[k]
        for j in range(n):
            if j!=k and rows[j]>>col&1:rows[j]^=rows[k];labels[j]^=labels[k]
        pivots.append(col);k+=1
        if k==n:break
    assert k==n
    result=[sum(((labels[j]>>i)&1)<<pivots[j] for j in range(n)) for i in range(n)]
    assert all(parity(u,v)==(i==j) for i,u in enumerate(vectors) for j,v in enumerate(result))
    return result


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--dimension',type=int,required=True);ap.add_argument('--baseline',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=30);ap.add_argument('--compressed',action='store_true');a=ap.parse_args();start=time.monotonic()
    import pycryptosat
    A,_,_=logical_data();X,Z=[[int(s,16) for s in (ROOT/f'pools/{side}coords.txt').read_text().split()] for side in ['x','z']]
    indices=(list(range(608,624))+list(range(704,720))+list(range(0,720)))
    chosen=[];U=[]
    for k in indices:
        if rank(U+[X[k]])>len(U):chosen.append(k);U.append(X[k])
        if len(U)==a.dimension:break
    V=dual(U);r=len(U);assert r==a.dimension
    prior=json.loads(a.baseline.read_text());old=prior['equations'];offset=len(old)
    equations=[(int(e['u_hex'],16),int(e['v_hex'],16)) for e in old]+[(u,v) for u in U for v in V]
    a0=[parity(u,Z[48]) for u in U];b0=[parity(X[48],v) for v in V]
    H=[sum(((i==j)^(a0[i]*b0[j]))<<j for j in range(r)) for i in range(r)];hrank=rank(H)
    target=0
    for k,(u,v) in enumerate(equations):target|=(parity(u,v)^parity(X[48],v)*parity(u,Z[48]))<<k
    sx=[sum(parity(x,v)<<k for k,(u,v) in enumerate(equations)) for x in X]
    sz=[sum(parity(u,z)<<k for k,(u,v) in enumerate(equations)) for z in Z]
    E=[(i,j,sx[i]&sz[j],0) for i in range(720) if i!=48 and not A[i]>>48&1 for j in range(720) if j!=48 and not A[48]>>j&1 and A[i]>>j&1 and sx[i]&sz[j]]
    clauses,n,_,events=encode(A,[0],E,with_xor=False,compress_signatures=a.compressed)
    solver=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'5000','autodisablegauss':'0'})
    for c in clauses:solver.add_clause(c)
    for k in range(len(equations)):solver.add_xor_clause([v for v,s in events if s>>k&1],bool(target>>k&1))
    built=time.monotonic();print('built projected block',r,'target rank',hrank,'active edges',len(E),'equations',len(equations),'seconds',built-start,flush=True)
    sat,model=solver.solve(time_limit=a.seconds);pairs=[]
    if sat:
        selected=[k for k in range(len(E)) if model[k+1]]
        if a.compressed:
            reps={}
            for k in selected:reps.setdefault(E[k][2],k)
            selected=list(reps.values())
        selected=compress(selected,[e[2] for e in E],target);pairs=[(48,48)]+[E[k][:2] for k in selected]
        assert len(selected)>=hrank
        value=0
        for k in selected:value^=E[k][2]
        assert value==target
        for k,(i,j) in enumerate(pairs):
            for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
    old_partial=prior['records']
    excluded=[{'iteration':p['iteration'],'partial_size':p['partial_size']} for p in old_partial if p['answer'] is True and p['partial_size']-1<hrank]
    result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'dimension':r,'baseline':str(a.baseline),'baseline_equations':offset,'auxiliary_U_source_indices':chosen,'auxiliary_U_hex':list(map(hex,U)),'auxiliary_V_hex':list(map(hex,V)),'auxiliary_Gram':'identity','anchor':[48,48],'conditional_target_rows_hex':list(map(hex,H)),'conditional_target_rank':hrank,'necessary_free_pairs_at_least':hrank,'necessary_total_partial_pairs_at_least':hrank+1,'baseline_partial_witnesses_ruled_out_by_rank':excluded,'equations':len(equations),'active_edges':len(E),'compressed_free_signatures':a.compressed,'parity_events':len(events),'answer':sat,'partial_matching':pairs,'construction_seconds':built-start,'solve_seconds':time.monotonic()-built,'elapsed_seconds':time.monotonic()-start,'scope':'Rank is an exact necessary consequence of simultaneous block equations. UNKNOWN is no case exclusion; SAT is a partial necessity witness only. Acceptance of a source exclusion requires an independent UNSAT proof.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('block result',r,sat,'partial size',len(pairs),flush=True)


if __name__=='__main__':main()
