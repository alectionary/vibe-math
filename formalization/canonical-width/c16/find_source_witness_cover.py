#!/usr/bin/env python3
"""Optimize dual-expansion covers over all allowed source-pair witnesses.

For a full source frame, beta(u,v)=sum_i beta(u,z_i)*beta(x_i,v).
Every allowed source witness pair therefore forces a selected edge in the
rectangle N(v) x N(u). Only the witness is normalized; frames stay arbitrary.
"""
from pathlib import Path
import argparse
import collections
import hashlib
import json
import time

ROOT = Path(__file__).resolve().parent


def canonical(e):
    a,b,h=e
    return min(e,(b,a,-h%16))


def rotate(m,h):
    return ((m<<h)|(m>>(16-h)))&65535


def reverse(m):
    return sum(((m>>h)&1)<<(-h%16) for h in range(16))


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args()
    start=time.monotonic()
    paths=[ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt']
    X,Z=[[int(s,16) for s in p.read_text().split()] for p in paths]
    pat=[[sum(((X[16*i]&Z[16*j+h]).bit_count()%2)<<h for h in range(16)) for j in range(45)] for i in range(45)]
    edges=[(i,j,h) for i in range(45) for j in range(45) for h in range(16) if pat[i][j]>>h&1]
    E=sorted(set(map(canonical,edges)))
    assert len(edges)==6238 and len(E)==3132
    pos={e:k for k,e in enumerate(E)}
    revpat=[[reverse(m) for m in r] for r in pat]
    best=None
    records=[]
    histogram=collections.Counter()
    for i in range(45):
        # Each entry records the canonical case and the phases at which u
        # pairs1 with that case's Z endpoint. A second mask handles v.
        by=[[(1<<pos[canonical((r,b,h))],rotate(pat[i][b],-h%16)) for b in range(45) for h in range(16) if pat[r][b]>>h&1] for r in range(45)]
        for j in range(45):
            for h in range(16):
                if not pat[i][j]>>h&1:
                    continue
                cover=0
                for r in range(45):
                    F=rotate(revpat[r][j],h)
                    for bit,G in by[r]:
                        if F&G:
                            cover|=bit
                cost=cover.bit_count()
                histogram[cost]+=1
                records.append({'u_X_index':16*i,'v_Z_index':16*j+h,'case_count':cost})
                if best is None or cost<best[0]:
                    best=(cost,16*i,16*j+h,cover)
                    print(f'Best {cost} cases at source u={16*i}, v={16*j+h}; {time.monotonic()-start:.2f}s',flush=True)
    count,u,v,cover=best
    cases=[{'id':f'X{i:02d}-Z{j:02d}-h{h:02d}','X_index':16*i,'Z_index':16*j+h,'orbit_tuple':[i,j,h],'status':'unresolved'} for k,(i,j,h) in enumerate(E) if cover>>k&1]
    result={'status':'PASS','source_C16_answered':False,
            'theorem':'Every full source frame has a translate and optional sector exchange containing one listed selected pair. The dual-expansion identity forces a selected edge in N(v) x N(u).',
            'witness':{'u_X_index':u,'v_Z_index':v,'beta':1,'u_logical_hex':hex(X[u]),'v_logical_hex':hex(Z[v])},
            'case_count':count,'cases':cases,'whole_pair_cases_excluded':0,
            'tested_witness_orbits':len(records),'cost_histogram':dict(sorted(histogram.items())),
            'witness_costs':records,
            'scope':'Minimum only within the6238 allowed source-pair witness orbits tested here. This is a cover, not completed cases or a runtime improvement. Arbitrary binary witness vectors and higher-rank linear functionals may improve it.',
            'source_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
            'elapsed_seconds':time.monotonic()-start}
    assert count==518 and (X[u]&Z[v]).bit_count()%2==1
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(f'PASS: complete source-witness screen, {len(records)} witnesses, minimum {count} cases.',flush=True)


if __name__=='__main__':
    main()
