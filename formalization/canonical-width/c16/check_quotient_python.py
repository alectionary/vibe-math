#!/usr/bin/env python3
"""Independent integer/set transcription of the partitioned quotient search."""
import argparse
import json
from pathlib import Path


def rank(rows):
    piv={}
    for value in rows:
        while value:
            p=value.bit_length()-1
            if p not in piv:piv[p]=value;break
            value^=piv[p]
    return len(piv)


def members(bits):
    while bits:
        bit=bits&-bits;yield bit.bit_length()-1;bits^=bit


def complete(X,Z,need,cap):
    xa=[sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    za=[sum(((x&z).bit_count()%2)<<i for i,x in enumerate(X)) for z in Z]
    xo=[sum(((x>>b)&1)<<i for i,x in enumerate(X)) for b in range(128)]
    zo=[sum(((z>>b)&1)<<j for j,z in enumerate(Z)) for b in range(128)]
    nodes=0;capped=False;solution=None
    def rec(ax,az,chosen):
        nonlocal nodes,capped,solution
        if solution is not None or capped:return
        if nodes>=cap:capped=True;return
        nodes+=1;left=need-len(chosen)
        if not left:solution=chosen;return
        if ax.bit_count()<left or az.bit_count()<left:return
        if rank([X[i] for i,j in chosen]+[X[i] for i in members(ax)])<need:return
        if rank([Z[j] for i,j in chosen]+[Z[j] for j in members(az)])<need:return
        best=100000;side=False;candidates=0
        def consider(owner,available,zside):
            nonlocal best,side,candidates
            candidates0=owner&available;n=candidates0.bit_count()
            if 0<n<best:best=n;side=zside;candidates=candidates0
        for b in range(128):
            if best==1:break
            consider(xo[b],ax,False);consider(zo[b],az,True)
        if best>1:
            for owner in za:
                if best==1:break
                consider(owner,ax,False)
            for owner in xa:
                if best==1:break
                consider(owner,az,True)
        if not candidates:return
        for v in members(candidates):
            if capped or solution is not None:return
            partners=(za[v]&ax) if side else (xa[v]&az)
            for w in members(partners):
                if capped or solution is not None:return
                i,j=(w,v) if side else (v,w)
                aa=ax&~za[j]&~(1<<i);bb=az&~xa[i]&~(1<<j)
                if aa.bit_count()<left-1 or bb.bit_count()<left-1:continue
                rec(aa,bb,chosen+[(i,j)])
            if side:az&=~(1<<v)
            else:ax&=~(1<<v)
    rec((1<<len(X))-1,(1<<len(Z))-1,[])
    return solution,nodes,capped


def main():
    ap=argparse.ArgumentParser();ap.add_argument('partners',type=Path);ap.add_argument('--cap',type=int,default=1000000)
    args=ap.parse_args();root=Path(__file__).parent
    X=[int(s,16) for s in (root/'pools/xcoords.txt').read_text().split()]
    Z=[int(s,16) for s in (root/'pools/zcoords.txt').read_text().split()]
    for line in args.partners.read_text().splitlines():
        if 'partners' in line:line=line.split('partners',1)[1]
        assignment={int(t.split(':')[0]):int(t.split(':')[1]) for t in line.split() if ':' in t}
        if not assignment:continue
        kept=sum(1<<p for p in assignment)
        assert all(((Z[j]>>64)&kept)==1<<p for p,j in assignment.items())
        xv=[x for x in X if all((x&Z[j]).bit_count()%2==0 for j in assignment.values())]
        zv=[z for z in Z if ((z>>64)&kept)==0]
        solution,nodes,capped=complete(xv,zv,128-len(assignment),args.cap)
        print(json.dumps({'partners':assignment,'status':'FOUND' if solution is not None else 'CAPPED' if capped else 'DEAD',
                          'nodes':nodes,'pool_sizes':[len(xv),len(zv)]}),flush=True)


if __name__=='__main__':main()
