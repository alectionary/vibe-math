#!/usr/bin/env python3
"""Bounded arbitrary-vector witness search; frames' allowed pools stay fixed."""
from pathlib import Path
import argparse
import json
import random
import time

ROOT=Path(__file__).resolve().parent


def bits(m):
    while m:
        b=m&-m;m^=b;yield b.bit_length()-1


def canon(i,j):
    a,b,h=i//16,j//16,(j-i)%16
    return min((a,b,h),(b,a,-h%16))


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=60);ap.add_argument('--seed',type=int,default=20261028);a=ap.parse_args()
    start=time.monotonic();rng=random.Random(a.seed)
    X,Z=[[int(s,16) for s in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']]
    A=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    classes=sorted({canon(i,j) for i,row in enumerate(A) for j in bits(row)})
    pos={c:k for k,c in enumerate(classes)}
    ids=[{j:1<<pos[canon(i,j)] for j in bits(row)} for i,row in enumerate(A)]
    def cost(u,v):
        assert (u&v).bit_count()%2
        R=sum(((u&z).bit_count()%2)<<j for j,z in enumerate(Z));out=0
        for i,x in enumerate(X):
            if (x&v).bit_count()%2:
                for j in bits(A[i]&R):out|=ids[i][j]
        return out.bit_count(),out
    u,v=X[608],Z[608];best,cover=cost(u,v);assert best==518
    history=[];tested=0;complete_passes=[];seen=set()
    for phase in range(4):
        side=phase%2;base=u if side==0 else v;dictionary=X if side==0 else Z
        candidates=set(dictionary)|{1<<k for k in range(128)}|{base^w for w in dictionary}|{base^(1<<k) for k in range(128)}
        # Reproducible two-source perturbations of the current auxiliary vector.
        for _ in range(1500):candidates.add(base^rng.choice(dictionary)^rng.choice(dictionary))
        eligible=[w for w in sorted(candidates) if (w&(v if side==0 else u)).bit_count()%2]
        finished=True
        for w in eligible:
            if time.monotonic()-start>a.seconds:finished=False;break
            uu,vv=(w,v) if side==0 else (u,w)
            if (uu,vv) in seen:continue
            seen.add((uu,vv));n,mask=cost(uu,vv);tested+=1
            if n<best:
                best,cover,u,v=n,mask,uu,vv
                history.append({'case_count':best,'u_hex':hex(u),'v_hex':hex(v),'phase':phase,'seconds':time.monotonic()-start})
                print('Improved arbitrary rank-one witness to',best,flush=True)
        complete_passes.append({'phase':phase,'side':'u' if side==0 else 'v','eligible_candidate_count':len(eligible),'finished':finished})
        print('phase',phase,'tested',tested,'best',best,'seconds',time.monotonic()-start,flush=True)
        if not finished:break
    result={'status':'PASS','source_C16_answered':False,'seed':a.seed,'scope':'Bounded arbitrary-vector auxiliary search: source vectors, coordinates, one-source and coordinate perturbations, plus1500 seeded two-source perturbations per alternating phase. No optimum over arbitrary vectors is claimed.','tested_trace_one_witnesses':tested,'complete_passes':complete_passes,'best_case_count':best,'u_hex':hex(u),'v_hex':hex(v),'case_tuples':[c for k,c in enumerate(classes) if cover>>k&1],'improvements':history,'elapsed_seconds':time.monotonic()-start}
    a.output.write_text(json.dumps(result,indent=2)+'\n')


if __name__=='__main__':main()
