#!/usr/bin/env python3
"""Independent physical replay of affine closure certificates; no elimination."""
from pathlib import Path
import argparse
import collections
import gzip
import json
import time
from verify_anchored_cover_chain import physical,canonical

ROOT=Path(__file__).resolve().parent


def bits(value):
    while value:
        bit=value&-value;value-=bit;yield bit.bit_length()-1


def replay(A,sig,data):
    R=set(map(tuple,data['removed_classes']));x,z=data['anchor'];target=65535^sig[x,z];assert target==data['free_target_signature']
    E=[(i,j,s) for (i,j),s in sig.items() if s and canonical(i,j) in R and (i,j)!=(x,z) and i!=x and j!=z and not A[i]>>z&1 and not A[x]>>j&1];m=len(E);assert m==data['initial_nodes']
    N=[];groups=collections.defaultdict(int)
    for k,(i,j,s) in enumerate(E):
        groups[s]|=1<<k
        N.append(sum((q!=k and i!=ii and j!=jj and not A[i]>>jj&1 and not A[ii]>>j&1)<<q for q,(ii,jj,ss) in enumerate(E)))
    active=(1<<m)-1;nodes=pairs=0
    def check(w,available,residual):
        assert 0<w<65536 and (w&residual).bit_count()%2==1
        assert all(not ((w&s).bit_count()%2) for s,mask in groups.items() if available&mask)
    for step in data['proof']:
        if step[0]==1:
            _,k,w=step;assert active>>k&1;check(w,N[k],target^E[k][2]);active&=~(1<<k)
            for q in bits(N[k]):N[q]&=~(1<<k)
            N[k]=0;nodes+=1
        else:
            assert step[0]==2
            _,k,q,w=step;assert active>>k&1 and active>>q&1 and N[k]>>q&1 and N[q]>>k&1
            check(w,N[k]&N[q],target^E[k][2]^E[q][2]);N[k]&=~(1<<q);N[q]&=~(1<<k);pairs+=1
    assert active.bit_count()==data['remaining_nodes'] and nodes==data['node_cuts'] and pairs==data['pair_cuts']
    if data['outcome']=='UNSAT':check(data['final_separator'],active,target)
    else:assert data['final_separator'] is None
    return {'outcome':data['outcome'],'initial_nodes':m,'remaining_nodes':active.bit_count(),'node_certificates_checked':nodes,'pair_certificates_checked':pairs}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();A,C,pos,sig=physical();d=json.loads(gzip.decompress(a.certificate.read_bytes()));checked=replay(A,sig,d)
    # A tampered functional must fail the proof consumer.
    if d['proof']:
        bad=json.loads(json.dumps(d));bad['proof'][0][-1]=0
        try:replay(A,sig,bad)
        except AssertionError:pass
        else:raise AssertionError('zero separating functional was accepted')
    result={'status':'PASS','source_C16_answered':False,**checked,'corrupt_zero_functional_rejected':bool(d['proof']),'physical_pairings_rebuilt':518400,'elapsed_seconds':time.monotonic()-start,'scope':'Only the stated conditional signature domain is excluded when outcomeUNSAT; cover induction/group premises require separate verification.'};a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':main()
