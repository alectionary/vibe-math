#!/usr/bin/env python3
"""Literal functional enumeration, including positive support-four examples."""
from pathlib import Path
from itertools import combinations
import argparse,collections,hashlib,json,time
from detecting_capacity_four import probe
from control_detecting_capacity import frames,sums

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,required=True);a=p.parse_args();start=time.monotonic()
    # Every pool contains the standard basis. The extra weight-four X point
    # cannot occur in a full frame with this Z pool. For J={3}, w=29 has four
    # detecting points and quotient word length4, exercising the new bound.
    cases=[(5,[1,2,4,8,16,15],[1,2,4,8,16,3]),
           (6,[1,2,4,8,16,32,15],[1,2,4,8,16,32,3]),
           (6,[1,2,4,8,16,32,15,48],[1,2,4,8,16,32,3,48])]
    counts=collections.Counter()
    for N,X,Z in cases:
        F=frames(X,Z,N);assert F
        for side in (0,1):
            U,V=(X,Z) if side==0 else (Z,X)
            forbidden={c:{} for n in (2,3) for c in combinations(range(len(U)),n) if not any(set(c)<=f[side] for f in F)}
            short={0:{0}}
            for n in (1,2,3):short[n]=short[n-1]|{x^v for x in short[n-1] for v in V}
            for n in (0,1,2):
                for J in combinations(range(len(V)),n):
                    L=sums(V[j] for j in J)
                    if len(L)!=1<<len(J):continue
                    expected=set();limits={d:{x^v for x in short[d] for v in L} for d in (1,2,3)}
                    for w in range(1,1<<N):
                        if w in L:continue
                        D=tuple(i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J))
                        if not 2<=len(D)<=4:continue
                        if not any(c in forbidden for size in (2,3) for c in combinations(D,size)):continue
                        if w not in limits[len(D)-1]:expected.add(D)
                    actual=probe(U,V,J,forbidden,N,cap=64)
                    eligible=[x for x in U if all(not (x&V[j]).bit_count()%2 for j in J)]
                    if len(sums(eligible))!=1<<(N-len(J)):
                        # Discovery deliberately delegates rank-deficient inputs
                        # to the earlier, already decisive rank obstruction.
                        assert not actual and not any(set(J)<=f[1-side] for f in F)
                        counts['already_rank_excluded_queries']+=1
                        continue
                    got={tuple(row['detecting_support']) for row in actual};assert got==expected,(N,side,J,got,expected)
                    assert not (actual and any(set(J)<=f[1-side] for f in F))
                    counts['queries']+=1
                    for D in got:counts['certificates_support_'+str(len(D))]+=1
    assert counts['certificates_support_4']>0
    result={'status':'PASS','source_C16_answered':False,'pool_pairs':len(cases),'counts':dict(counts),
            'source_sha256':hashlib.sha256(Path(__file__).with_name('detecting_capacity_four.py').read_bytes()).hexdigest(),
            'elapsed_seconds':time.monotonic()-start,'scope':'Literal enumeration of all ambient functionals on three specified5D/6D pool pairs, for every independent mandatory subset of size<=2 with full residual rank. Rank-deficient cases separately checked as already excluded and intentionally skipped by capacity discovery. Exact agreement with support-four discovery, known identity frames preserved, positive support-four certificates exercised.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
