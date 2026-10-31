#!/usr/bin/env python3
"""Literal all-functional controls, including a planted direct-sum witness."""
from pathlib import Path
from itertools import combinations
import argparse,collections,hashlib,json,time
from conditioned_double_pair import probe
from control_detecting_capacity import frames,sums
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();counts=collections.Counter()
    X=[1,2,4,8,16,15];Z=[1,2,4,8,16,3];cases=[(5,X,Z),(10,X+[v<<5 for v in X],Z+[v<<5 for v in Z])]
    for N,X,Z in cases:
        F=frames(X,Z,N);assert F;counts['literal_full_frames']+=len(F)
        for side in (0,1):
            U,V=(X,Z) if side==0 else (Z,X);forbidden={K:{} for K in combinations(range(len(U)),2) if not any(set(K)<=f[side] for f in F)}
            bundles=[set(A+B) for A,B in combinations(forbidden,2) if not set(A)&set(B)];words=[{0}]
            for n in range(4):words.append(words[-1]|{x^v for x in words[-1] for v in V})
            for n in range(3):
                for J in combinations(range(len(V)),n):
                    L=sums(V[j] for j in J)
                    if len(L)!=1<<len(J):continue
                    possible=any(set(J)<=f[1-side] for f in F);got=probe(U,V,J,forbidden,N,cap=100000);assert not (possible and got)
                    E=[u for u in U if all(not (u&V[j]).bit_count()%2 for j in J)]
                    if len(sums(E))!=1<<(N-len(J)):
                        assert not got and not possible;counts['rank_deficient']+=1;continue
                    limits=[{x^l for x in ss for l in L} for ss in words];expected=set()
                    for w in range(1,1<<N):
                        if w in L:continue
                        D=tuple(i for i,u in enumerate(U) if (u&w).bit_count()%2 and all(not (u&V[j]).bit_count()%2 for j in J))
                        if 4<=len(D)<=6 and any(K<=set(D) for K in bundles) and w not in limits[len(D)-2]:expected.add(D)
                    assert {tuple(r['detecting_support']) for r in got}==expected,(N,side,J)
                    for r in got:
                        w=int(r['witness_hex'],16);D=tuple(i for i,u in enumerate(U) if (u&w).bit_count()%2 and all(not (u&V[j]).bit_count()%2 for j in J));assert D==tuple(r['detecting_support']);A,B=[tuple(c['indices']) for c in r['forbidden_children']];assert A in forbidden and B in forbidden and not set(A)&set(B) and set(A+B)<=set(D);assert w not in limits[len(D)-2];counts['certificates_support_'+str(len(D))]+=1
                    counts['full_rank_queries']+=1;counts['extendible_queries_preserved']+=possible
    assert counts['certificates_support_6']>0
    result={'status':'PASS','source_C16_answered':False,'counts':dict(counts),'elapsed_seconds':time.monotonic()-start,'source_sha256':hashlib.sha256(Path(__file__).with_name('conditioned_double_pair.py').read_bytes()).hexdigest(),'scope':'All full frames, ambient functionals, both sectors, and independent mandatory sets throughsize2 on specified5D pool and its10D direct sum. Includes six-detector/two-disjoint-pair obstructions; rank-deficient queries separately excluded.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
