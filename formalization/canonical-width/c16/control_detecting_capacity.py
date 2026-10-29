#!/usr/bin/env python3
"""Literal tiny full-frame controls for the detector-capacity implication."""
from pathlib import Path
from itertools import combinations
import argparse,hashlib,json,random,time
from detecting_capacity import probe

def sums(values):
    out={0}
    for v in values:out|={x^v for x in list(out)}
    return out

def frames(X,Z,N):
    found=[]
    for ids in combinations(range(len(X)),N):
        # Literal enumeration tests independence and dual coordinates.
        if len(sums(X[i] for i in ids))!=1<<N:continue
        labels={sum(((X[i]&z).bit_count()%2)<<k for k,i in enumerate(ids)):j for j,z in enumerate(Z)}
        if all(1<<k in labels for k in range(N)):
            found.append((frozenset(ids),frozenset(labels[1<<k] for k in range(N))))
    return found

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    units=[1,2,4];extra=[3,5,6,7];pools=[units+[x for k,x in enumerate(extra) if mask>>k&1] for mask in range(16)]
    cases=[(3,X,Z) for X in pools for Z in pools];rng=random.Random(20261029)
    for k in range(32):
        cases.append((4,[1,2,4,8]+sorted(rng.sample([x for x in range(1,16) if x not in [1,2,4,8]],4+k%3)),
                        [1,2,4,8]+sorted(rng.sample([x for x in range(1,16) if x not in [1,2,4,8]],4+(k//3)%3))))
    queries=certificates=known_frames=positive_queries=0
    for N,X,Z in cases:
        F=frames(X,Z,N);assert F;known_frames+=len(F)
        for side in (0,1):
            U,V=(X,Z) if side==0 else (Z,X)
            forbidden={tuple(ids):{} for size in (2,3) for ids in combinations(range(len(U)),size) if not any(set(ids)<=f[side] for f in F)}
            for size in range(min(N-1,3)+1):
                for J in combinations(range(len(V)),size):
                    L=sums(V[j] for j in J)
                    if len(L)!=1<<len(J):continue
                    possible=any(set(J)<=f[1-side] for f in F);positive_queries+=possible
                    rows=probe(U,V,J,forbidden,N,cap=8);queries+=1
                    assert not (possible and rows)
                    for row in rows:
                        certificates+=1;w=int(row['witness_hex'],16)
                        D=[i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J)]
                        assert D==row['detecting_support'] and tuple(row['forbidden_child_indices']) in forbidden
                        assert set(row['forbidden_child_indices'])<=set(D)
                        for s in range(row['capacity_bound']+1):
                            for terms in combinations(V,s):
                                total=w
                                for z in terms:total^=z
                                assert total not in L
    result={'status':'PASS','source_C16_answered':False,'three_dimensional_pool_pairs':256,'four_dimensional_sampled_pool_pairs':32,
            'all_tested_pools_contain_identity_frame':True,'literal_full_frames':known_frames,'queries':queries,
            'extendible_queries_preserved':positive_queries,'certificates_literally_checked':certificates,
            'elapsed_seconds':time.monotonic()-start,'source_sha256':hashlib.sha256(Path(__file__).with_name('detecting_capacity.py').read_bytes()).hexdigest(),
            'scope':'All256 pairs of3D pools containing the fixed identity basis, plus32 deterministic4D sampled pool pairs. Every full frame in each tested pool pair enumerated literally. Forbidden children established by those complete tiny frame lists, not by the discovery routine. Not an exhaustive screen of all4D pools.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
