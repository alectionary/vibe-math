#!/usr/bin/env python3
"""Bounded simultaneous16-signature necessity screen of fixed pair cases."""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data,encode
from exchange_signature_cover import representation

ROOT=Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--cover',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=120);a=ap.parse_args();start=time.monotonic()
    import pycryptosat
    A,C,E=logical_data();cnf,n,S,events=encode(A,C,E,with_xor=False)
    solver=pycryptosat.Solver(threads=1,options={'minmatrixrows':'0','maxmatrixrows':'1000','autodisablegauss':'0'})
    for clause in cnf:solver.add_clause(clause)
    for t in range(16):solver.add_xor_clause([v for v,s in events if s>>t&1],True)
    positions={(e[0],e[1]):k for k,e in enumerate(E)}
    d=json.loads(a.cover.read_text());cases=d.get('cases') or [{'id':f'X{x:02d}-Z{z:02d}-h{h:02d}','X_index':16*x,'Z_index':16*z+h} for x,z,h in d['retained_case_tuples']]
    records=[]
    for c in cases:
        if time.monotonic()-start>a.seconds:break
        index=positions[c['X_index'],c['Z_index']]
        sat,model=solver.solve(assumptions=[index+1],time_limit=.2)
        witness=[]
        if sat:
            chosen=[k for k in range(len(E)) if model[k+1] and k!=index]
            small=representation(chosen,E,target=65535^E[index][2]);assert small is not None
            chosen=[index]+small;value=0
            for i,k in enumerate(chosen):
                x,z,s,cl=E[k];value^=s
                for l in chosen[:i]:
                    xx,zz,_,_=E[l];assert x!=xx and z!=zz and not A[x]>>zz&1 and not A[xx]>>z&1
            assert value==65535 and len(chosen)<=17
            witness=[list(E[k][:2]) for k in chosen]
        records.append({'id':c['id'],'X_index':c['X_index'],'Z_index':c['Z_index'],'answer':sat,'partial_matching':witness})
        if len(records)%50==0:print(len(records),'fixed pairs;',sum(r['answer'] is True for r in records),'SAT,',sum(r['answer'] is False for r in records),'UNSAT,',time.monotonic()-start,'seconds',flush=True)
    result={'status':'DISCOVERY_ONLY','source_C16_answered':False,'cover':str(a.cover),'case_count':len(cases),'tested':len(records),'satisfiable':sum(r['answer'] is True for r in records),'unsatisfiable':sum(r['answer'] is False for r in records),'unknown':sum(r['answer'] is None for r in records),'records':records,'scope':'Partial induced matchings with the16 simultaneous signatures, not full128-frame completions. Any UNSAT result still requires an independently checked certificate before a source case can be excluded.','elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('Saved conditional screen', {k:result[k] for k in ['tested','satisfiable','unsatisfiable','unknown']},flush=True)


if __name__=='__main__':main()
