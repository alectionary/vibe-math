#!/usr/bin/env python3
"""Proof-producing affine-span consistency for target-XOR induced matchings.

If a solution contains i (or i,j), its remaining signature is represented by
currently compatible remaining nodes. A separating binary functional forbids
that node (or pair). Rules compose inductively; no frame tuples are enumerated.
"""
from pathlib import Path
import argparse
import collections
import gzip
import json
import time
from signature_cover import logical_data

ROOT=Path(__file__).resolve().parent


def bits(value):
    while value:
        b=value&-value;value^=b;yield b.bit_length()-1


def separator(groups,available,target):
    if not target:return None
    basis={}
    for s,mask in groups:
        if not available&mask:continue
        v=s
        while v:
            p=v.bit_length()-1
            if p not in basis:basis[p]=v;break
            v^=basis[p]
        if len(basis)==16:return None
    residual=target
    for p in range(15,-1,-1):
        if residual>>p&1 and p in basis:residual^=basis[p]
    if not residual:return None
    witness=residual&-residual
    for p in sorted(basis):
        if (basis[p]&witness).bit_count()%2:witness^=1<<p
    assert (witness&target).bit_count()%2==1
    assert all(not ((s&witness).bit_count()%2) for s,mask in groups if available&mask)
    return witness


def closure(rows,edges,target,seconds=60,max_passes=100):
    start=time.monotonic();m=len(edges);N=[];grouped=collections.defaultdict(int)
    for k,(i,j,s) in enumerate(edges):
        grouped[s]|=1<<k
        N.append(sum((q!=k and i!=ii and j!=jj and not rows[i]>>jj&1 and not rows[ii]>>j&1)<<q for q,(ii,jj,ss) in enumerate(edges)))
    groups=list(grouped.items());active=(1<<m)-1;proof=[];passes=[];stop='pass_bound';final=None
    for iteration in range(max_passes):
        nodes=pairs=0
        for k in list(bits(active)):
            if time.monotonic()-start>seconds:stop='wall_bound';break
            w=separator(groups,N[k],target^edges[k][2])
            if w is not None:
                proof.append([1,k,w]);active^=1<<k;nodes+=1
                for q in bits(N[k]):N[q]&=~(1<<k)
                N[k]=0
        final=separator(groups,active,target)
        if final is not None:stop='UNSAT';passes.append({'iteration':iteration,'nodes_removed':nodes,'pair_cuts':0,'remaining_nodes':active.bit_count(),'seconds':time.monotonic()-start});break
        if stop=='wall_bound':break
        for k in bits(active):
            if time.monotonic()-start>seconds:stop='wall_bound';break
            for q in list(bits(N[k]&((1<<k)-1))):
                w=separator(groups,N[k]&N[q],target^edges[k][2]^edges[q][2])
                if w is not None:proof.append([2,k,q,w]);N[k]^=1<<q;N[q]^=1<<k;pairs+=1
        passes.append({'iteration':iteration,'nodes_removed':nodes,'pair_cuts':pairs,'remaining_nodes':active.bit_count(),'seconds':time.monotonic()-start})
        if stop=='wall_bound':break
        if not nodes and not pairs:stop='FIXPOINT';break
    return {'outcome':stop,'initial_nodes':m,'remaining_nodes':active.bit_count(),'node_cuts':sum(p[0]==1 for p in proof),'pair_cuts':sum(p[0]==2 for p in proof),'proof':proof,'final_separator':final,'passes':passes,'elapsed_seconds':time.monotonic()-start}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--domain',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=60);a=ap.parse_args();A,C,E=logical_data();d=json.loads(a.domain.read_text());R=set(map(tuple,d.get('trial_removed',d.get('removed_after'))));x,z=d['anchor'];small=[(i,j,s) for i,j,s,c in E if C[c] in R and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1];target=d['free_target_signature'];result=closure(A,small,target,a.seconds);result.update({'source_C16_answered':False,'domain':str(a.domain.resolve().relative_to(ROOT)),'anchor':[x,z],'removed_classes':sorted(R),'free_target_signature':target,'scope':'Target-dependent conditional node/pair exclusions in this normalized cover domain only. Not unconditional original-source pair exclusions.'});a.output.write_bytes(gzip.compress(json.dumps(result,separators=(',',':')).encode(),compresslevel=3,mtime=0));print('affine closure',result['outcome'],'nodes',result['initial_nodes'],'->',result['remaining_nodes'],'pair cuts',result['pair_cuts'],'seconds',result['elapsed_seconds'],flush=True)


if __name__=='__main__':main()
