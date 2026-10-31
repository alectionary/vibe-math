#!/usr/bin/env python3
"""Literal complete tiny-functional controls for direct order-four discovery."""
from pathlib import Path
from itertools import combinations
import argparse,collections,copy,hashlib,json,time
from sparse_quotient_four import probe
from verify_four_term_small import check
from control_detecting_capacity import frames,sums

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic()
    cases=[(5,[1,2,4,8,16,7],[1,2,4,8,16,3]),
           (6,[1,2,4,8,16,32,7],[1,2,4,8,16,32,3]),
           (6,[1,2,4,8,16,32,7,48],[1,2,4,8,16,32,3,48])]
    counts=collections.Counter();negative=0
    for N,X,Z in cases:
        F=frames(X,Z,N);assert F;counts['literal_full_frames']+=len(F)
        for side in (0,1):
            U,V=(X,Z) if side==0 else (Z,X)
            words=[{0}]
            for q in range(1,5):words.append(words[-1]|{x^v for x in words[-1] for v in V})
            for n in range(3):
                for J in combinations(range(len(V)),n):
                    L=sums(V[j] for j in J)
                    if len(L)!=1<<len(J):continue
                    eligible=[x for x in U if all(not (x&V[j]).bit_count()%2 for j in J)]
                    actual=probe(U,V,J,N,cap=1024)
                    possible=any(set(J)<=f[1-side] for f in F)
                    assert not (actual and possible)
                    if len(sums(eligible))!=1<<(N-len(J)):
                        assert not actual and not possible;counts['already_rank_excluded_queries']+=1;continue
                    expected=set();limits=[{x^ell for x in w for ell in L} for w in words]
                    for w in range(1,1<<N):
                        if w in L:continue
                        D=tuple(i for i,x in enumerate(U) if (x&w).bit_count()%2 and all(not (x&V[j]).bit_count()%2 for j in J))
                        if 1<=len(D)<=4 and w not in limits[len(D)]:expected.add(D)
                    assert {tuple(r['detecting_support']) for r in actual}==expected,(N,side,J)
                    counts['full_rank_queries']+=1;counts['extendible_queries_preserved']+=possible
                    for result in actual:
                        row={'kind':'sparse_quotient_obstruction','side':side,**result,
                             'clause':[-j-1-(len(X) if side==0 else 0) for j in J]}
                        check(X,Z,row,N);counts['certificates_support_'+str(row['order'])]+=1
                        for key,value in [('witness_hex','0x0'),('detecting_support',[]),('minimum_outside_basis_terms',0),('clause',[999])]:
                            bad=copy.deepcopy(row);bad[key]=value
                            try:check(X,Z,bad,N)
                            except AssertionError:negative+=1
                            else:raise AssertionError(('corruption accepted',key))
    assert counts['certificates_support_4']>0
    result={'status':'PASS','source_C16_answered':False,'pool_pairs':len(cases),'counts':dict(counts),
            'mutated_certificates_rejected':negative,'elapsed_seconds':time.monotonic()-start,
            'source_hashes':{p:hashlib.sha256(Path(__file__).with_name(p).read_bytes()).hexdigest() for p in ['sparse_quotient_four.py','verify_four_term_small.py','control_four_term.py']},
            'scope':'Every ambient functional, both sectors, every independent mandatory subset of size<=2 in three specified5D/6D pool pairs. All full frames enumerated. Full-rank residual cases agree exactly; rank-deficient cases separately certified excluded. Includes positive support-four examples.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
