#!/usr/bin/env python3
"""Exact physical bridge for cyclic and sector averaging of source frames.

Rank128 of the paired 256-bit graph vectors, together with rank128 of each
projection, proves the indicated index correspondence is a linear isomorphism.
Pairing preservation then maps every source Gram-identity frame to a frame.
"""
from pathlib import Path
import argparse,hashlib,json,time
ROOT=Path(__file__).resolve().parent
def rank(values):
    piv={}
    for x in values:
        while x:
            bit=x&-x
            if bit in piv:x^=piv[bit]
            else:piv[bit]=x;break
    return len(piv)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    paths=[ROOT/f'pools/{s}coords.txt' for s in 'xz'];X,Z=[[int(x,16) for x in p.read_text().split()] for p in paths];assert len(X)==len(Z)==720 and rank(X)==rank(Z)==128
    assert all(0<=v<(1<<128) for v in X+Z)
    rotation=[16*(i//16)+(i%16+1)%16 for i in range(720)];assert sorted(rotation)==list(range(720))
    graphs={'X_to_Z':rank([x|(z<<128) for x,z in zip(X,Z)]),
            'X_phase_generator':rank([x|(X[rotation[i]]<<128) for i,x in enumerate(X)]),
            'Z_phase_generator':rank([z|(Z[rotation[i]]<<128) for i,z in enumerate(Z)])}
    assert all(r==128 for r in graphs.values())
    sector_checks=phase_checks=0
    for i in range(720):
        for j in range(720):
            pair=(X[i]&Z[j]).bit_count()%2
            assert pair==(X[j]&Z[i]).bit_count()%2;sector_checks+=1
            assert pair==(X[rotation[i]]&Z[rotation[j]]).bit_count()%2;phase_checks+=1
    out={'status':'PASS','source_C16_answered':False,'source_pool_ranks':[128,128],
         'graph_ranks':graphs,'sector_pairing_comparisons':sector_checks,'phase_pairing_comparisons':phase_checks,
         'pool_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
         'consumer_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'elapsed_seconds':time.monotonic()-start,
         'scope':'Exact generator and sector-swap symmetries of the720-index physical pools. They preserve linear dependence and Gram identity, so averaging over16 cyclic shifts and2 sector choices preserves source-valid necessary inequalities.'}
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
