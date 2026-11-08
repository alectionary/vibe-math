#!/usr/bin/env python3
"""Literal all-functional and all-frame controls for the conditioned support finder."""
from pathlib import Path
from itertools import combinations
import argparse,collections,hashlib,json,time
from conditioned_detector_five import probe
from control_detecting_capacity import frames,sums
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();counts=collections.Counter()
    cases=[(5,[1,2,4,8,16,15],[1,2,4,8,16,3]),(6,[1,2,4,8,16,32,15],[1,2,4,8,16,32,3]),(6,[1,2,4,8,16,32,15,48],[1,2,4,8,16,32,3,48])]
    for N,X,Z in cases:
        F=frames(X,Z,N);assert F;counts['literal_full_frames']+=len(F)
        for side in (0,1):
            U,V=(X,Z) if side==0 else (Z,X);forbidden={K:{} for n in (2,3,4) for K in combinations(range(len(U)),n) if not any(set(K)<=f[side] for f in F)}
            words=[{0}]
            for n in range(4):words.append(words[-1]|{x^v for x in words[-1] for v in V})
            for n in range(3):
                for J in combinations(range(len(V)),n):
                    L=sums(V[j] for j in J)
                    if len(L)!=1<<len(J):continue
                    possible=any(set(J)<=f[1-side] for f in F);got=probe(U,V,J,forbidden,N,cap=10000);assert not (possible and got)
                    E=[u for u in U if all(not (u&V[j]).bit_count()%2 for j in J)]
                    if len(sums(E))!=1<<(N-len(J)):
                        assert not got and not possible;counts['already_rank_excluded_queries']+=1;continue
                    limits=[{x^l for x in ss for l in L} for ss in words];expected=set()
                    for w in range(1,1<<N):
                        if w in L:continue
                        D=tuple(i for i,u in enumerate(U) if (u&w).bit_count()%2 and all(not (u&V[j]).bit_count()%2 for j in J))
                        if not 2<=len(D)<=5 or not any(set(K)<=set(D) for K in forbidden):continue
                        if w not in limits[len(D)-1]:expected.add(D)
                    assert {tuple(r['detecting_support']) for r in got}==expected,(N,side,J)
                    for r in got:
                        w=int(r['witness_hex'],16);D=tuple(i for i,u in enumerate(U) if (u&w).bit_count()%2 and all(not (u&V[j]).bit_count()%2 for j in J));assert D==tuple(r['detecting_support']) and tuple(r['forbidden_child_indices']) in forbidden and set(r['forbidden_child_indices'])<=set(D);assert w not in limits[len(D)-1];counts['certificates_support_'+str(len(D))]+=1
                    counts['full_rank_queries']+=1;counts['extendible_queries_preserved']+=possible
    assert counts['certificates_support_5']>0
    result={'status':'PASS','source_C16_answered':False,'pool_pairs':len(cases),'counts':dict(counts),'elapsed_seconds':time.monotonic()-start,'discovery_source_sha256':hashlib.sha256(Path(__file__).with_name('conditioned_detector_five.py').read_bytes()).hexdigest(),'scope':'Three specified5D/6D pool pairs, both sectors, all independent mandatory subsets throughsize2. Literal enumeration of every ambient functional and every full frame establishes exact agreement for every support<=5 containing a forbidden child. Includes positive support-five examples; rank-deficient residuals separately excluded.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
