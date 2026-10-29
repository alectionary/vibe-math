#!/usr/bin/env python3
"""Exhaustive tiny dual-basis and actual callback controls for mixed-sign clauses."""
from pathlib import Path
from itertools import combinations
import argparse,hashlib,json,random,tempfile
from conditional_span_oracle import NativeConditionalSpan,ConditionalSpanOracle
from signature_cover import encode
from full_anchor_model import at_least_network
from pysat.solvers import Solver
def rank(rows):
    piv={}
    for v in rows:
        while v:
            b=v&-v
            if b not in piv:piv[b]=v;break
            v^=piv[b]
    return len(piv)
def model(V,N):
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(V)) for x in V];E=[(i,j,0,0) for i,x in enumerate(V) for j,z in enumerate(V) if A[i]>>j&1];cnf,n,_,_=encode(A,[0],E,with_xor=False);left={i:[k for k,e in enumerate(E,1) if e[0]==i] for i in range(len(V))};right={j:[k for k,e in enumerate(E,1) if e[1]==j] for j in range(len(V))};p={i:len(E)+k+1 for k,i in enumerate(sorted(left))};q={j:len(E)+len(left)+k+1 for k,j in enumerate(sorted(right))}
    for group,owners in [(left,p),(right,q)]:
        for i in group:cnf.append([-owners[i]]+group[i])
    extra,n=at_least_network(list(p.values()),N,n);cnf+=extra;mapping={v:i+1 for i,v in p.items()};mapping.update({v:len(V)+j+1 for j,v in q.items()});end=len(E)+2*len(V)
    def remap(v):return mapping.get(v,2*len(V)+v if v<=len(E) else v)
    cnf=[[remap(abs(l))*(1 if l>0 else -1) for l in row] for row in cnf];return cnf,n,E
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--library',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();rng=random.Random(20261029);V=list(range(1,16));native=NativeConditionalSpan(V,V,a.library,4);rows=[]
    for k in range(200):rows+=native.check([rng.choice([-1,0,0,0,1]) for i in range(30)])
    native.close();bases=0;checks=0
    for B in combinations(V,4):
        if rank(B)!=4:continue
        D=[next(z for z in V if all(((x&z).bit_count()%2)==(i==j) for j,x in enumerate(B))) for i in range(4)];truth=[v in B for v in V]+[v in D for v in V];bases+=1
        for row in rows:assert any(truth[abs(l)-1]==(l>0) for l in row['clause']);checks+=1
    assert bases==840;integration=[]
    with tempfile.TemporaryDirectory(prefix='c16-span-controls-') as temp:
        for name,pool,expected in [('full',V,True),('nonsplit',[4,8,13,14,15],False)]:
            cnf,n,E=model(pool,4)
            for enabled in [False,True]:
                oracle=None
                with Solver(name='cadical195',bootstrap_with=cnf) as solver:
                    if enabled:
                        oracle=ConditionalSpanOracle(pool,pool,a.library,Path(temp)/(name+'.jsonl'),dimension=4);solver.connect_propagator(oracle)
                        for v in range(1,2*len(pool)+1):solver.observe(v)
                    answer=solver.solve();assert answer==expected
                    if answer:
                        selected=set(solver.get_model());pairs=[e[:2] for k,e in enumerate(E,1) if 2*len(pool)+k in selected];assert len(pairs)==4
                        for k,(i,j) in enumerate(pairs):
                            for l,(ii,jj) in enumerate(pairs):assert (pool[i]&pool[jj]).bit_count()%2==(k==l)
                    integration.append({'pool':name,'oracle':enabled,'answer':answer,'oracle_statistics':oracle.stats if oracle else None})
                    if oracle:oracle.close()
    out={'status':'PASS','dimension4_unordered_dual_basis_frames_exhausted':bases,'native_generated_clauses':len(rows),'clause_by_full_frame_truth_checks':checks,'callback_integration':integration,'native_library_sha256':hashlib.sha256(a.library.read_bytes()).hexdigest(),'scope':'All840 unordered binary dimension4 dual frames satisfy every generated clause; actual SAT and UNSAT callbacks agree with ordinary solving. These are controls, not original C16 conclusions.'};a.output.write_text(json.dumps(out,indent=2)+'\n');print('SPAN CONTROLS PASS',bases,checks,'and four solver integrations',flush=True)
if __name__=='__main__':main()
