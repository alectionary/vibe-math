#!/usr/bin/env python3
"""Discovery census: one-bit single-class feasibility reduces to2-SAT.

A translation/exchange class has at most32 edges. Unit signatures distribute
these uniformly over16 colours, so a single class offers at most two choices
per colour. Pair incompatibilities give binary forbidden-choice clauses.
Saved positive frames are checked physically by the independent consumers.
"""
from pathlib import Path
import argparse
import json
import time
from signature_cover import logical_data,canonical

ROOT=Path(__file__).resolve().parent


def solve(A,domains):
    graph=[[] for _ in range(32)];reverse=[[] for _ in range(32)]
    def edge(i,j):graph[i].append(j);reverse[j].append(i)
    for t,options in enumerate(domains):
        assert 1<=len(options)<=2
        if len(options)==1:edge(2*t+1,2*t)
    for t in range(16):
        for u in range(t):
            for v,(i,j) in enumerate(domains[t]):
                for w,(ii,jj) in enumerate(domains[u]):
                    if i==ii or j==jj or A[i]>>jj&1 or A[ii]>>j&1:edge(2*t+v,2*u+1-w);edge(2*u+w,2*t+1-v)
    seen=set();order=[]
    def visit(v):
        if v in seen:return
        seen.add(v)
        for w in graph[v]:visit(w)
        order.append(v)
    for v in range(32):visit(v)
    component={}
    def assign(v,c):
        if v in component:return
        component[v]=c
        for w in reverse[v]:assign(w,c)
    for v in reversed(order):
        if v not in component:assign(v,len(component))
    if any(component[2*t]==component[2*t+1] for t in range(16)):return None
    pairs=[domains[t][int(component[2*t+1]>component[2*t])] for t in range(16)]
    for k,(i,j) in enumerate(pairs):
        for ii,jj in pairs[:k]:assert i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1
    return pairs


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();A,_,_=logical_data();classes=sorted({canonical(i,j) for i,row in enumerate(A) for j in range(720) if row>>j&1});records=[]
    for w in [36,37,39,38,44]:
        F=[(row>>(16*w))&65535 for row in A];units=[c for c in classes if (F[16*c[0]]&F[16*c[1]+c[2]]).bit_count()==1];positive=[]
        for aa,bb,h in units:
            x,z=16*aa,16*bb+h;orbit={(16*(x//16)+(x+t)%16,16*(z//16)+(z+t)%16) for t in range(16)};orbit|={(j,i) for i,j in list(orbit)};domains=[[] for _ in range(16)]
            for i,j in sorted(orbit):
                signature=F[i]&F[j];assert signature.bit_count()==1;domains[signature.bit_length()-1].append((i,j))
            pairs=solve(A,domains)
            if pairs is not None:positive.append({'case':[aa,bb,h],'partial_matching':pairs})
        support=sum(bool(F[16*aa]&F[16*bb+h]) for aa,bb,h in classes);nonunit=support-len(units);records.append({'witness_orbit':w,'support_classes':support,'unit_classes':len(units),'single_class_unit_SAT':len(positive),'unit_only_cover_floor':nonunit+len(positive),'positive_records':positive})
    result={'source_C16_answered':False,'scope':'Exact2-SAT discovery census for one-bit classes; positives must be checked physically. Floors apply only to covers retaining every nonunit class.','records':records,'elapsed_seconds':time.monotonic()-start};a.output.write_text(json.dumps(result,indent=2)+'\n');print('Unit-signature census reproduced',[(r['witness_orbit'],r['single_class_unit_SAT']) for r in records])


if __name__=='__main__':main()
