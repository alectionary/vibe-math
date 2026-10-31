#!/usr/bin/env python3
"""Exact finite premises and small controls for the cited mimsup squeeze."""
from pathlib import Path
from itertools import combinations, permutations
from collections import Counter
import argparse
import hashlib
import json

ROOT = Path(__file__).resolve().parent


def rank(rows):
    piv = {}
    for v in rows:
        while v:
            k = v.bit_length()-1
            if k not in piv:
                piv[k] = v
                break
            v ^= piv[k]
    return len(piv)


def mim(A):
    for k in range(min(len(A), len(A[0])), 0, -1):
        for rows in combinations(range(len(A)), k):
            for cols in combinations(range(len(A[0])), k):
                M = [[A[i][j] for j in cols] for i in rows]
                if all(sum(r)==1 for r in M) and all(sum(r[j] for r in M)==1 for j in range(k)):
                    return k
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--output', type=Path, required=True)
    a = ap.parse_args()
    X = [int(v,16) for v in (ROOT/'pools/xcoords.txt').read_text().split()]
    Z = [int(v,16) for v in (ROOT/'pools/zcoords.txt').read_text().split()]
    rows = [sum(((x&z).bit_count()%2)<<j for j,z in enumerate(Z)) for x in X]
    assert rank(X)==rank(Z)==rank(rows)==128
    cert = json.loads((ROOT/'inversion-results/triangular-support.json').read_text())
    I,J = cert['X_indices'],cert['Z_indices']
    M = [[(X[i]&Z[j]).bit_count()%2 for j in J] for i in I]
    assert len(set(I))==len(set(J))==128
    assert all(M[i][i]==1 and all(v==0 for v in M[i][:i]) for i in range(128))
    # Obtain thin-family labels independently from source factors rather than
    # reusing a search claim or labels on the saved triangular witness.
    from verify_pool_inverse_structure import simple,phase
    source = json.loads((ROOT/'inversion-results/normal-form.json').read_text())
    family_counts=[]
    for side, selected in [('X',I),('Z',J)]:
        actual=source['tensor'][side+'_tensor_coordinates']
        lookup={tuple(map(tuple,v)):i for i,v in enumerate(actual)}
        labels={}
        q=source['dictionary']
        for c in range(5):
            for t in range(9):
                for h in range(16):
                    v=simple([phase(w,h) for w in q['X_left_dictionary'][t]],q['X_right_factors'][c]) if side=='X' else simple(q['Z_left_factors'][c],[phase(w,h) for w in q['Z_right_dictionary'][t]])
                    idx=lookup[tuple(map(tuple,v))]
                    assert idx not in labels
                    labels[idx]=c
        counts=Counter(labels[i] for i in selected)
        assert counts=={3:64,4:64}
        family_counts.append(dict(counts))
    # In the complete triangular support, distinct equal-histogram words
    # cannot compare coordinatewise. Consequently one tensor factor vanishes
    # in either off-diagonal direction for every triangular support subpattern.
    controls=0
    for r,s in [(2,1),(2,2),(2,3),(3,1),(3,2),(4,1)]:
        words=sorted(set(permutations([i for i in range(r) for _ in range(s)])))
        for x in words:
            for y in words:
                assert all(a<=b for a,b in zip(x,y))==(x==y)
                controls+=1
    # A row basis preserves existence of a1 in each individual column, but
    # not the maximum induced matching: do not apply Lemma4.4 to the wrong
    # compatibility matrix.
    A=[[1,1],[0,1],[1,0]]
    B=A[:2]
    assert rank([sum(v<<j for j,v in enumerate(row)) for row in A])==2
    assert rank([sum(v<<j for j,v in enumerate(row)) for row in B])==2
    assert all(any(row[j] for row in A)==any(row[j] for row in B) for j in range(2))
    assert mim(A)==2 and mim(B)==1
    result={'status':'PASS','source_C16_answered':False,
        'finite_premises':{'pool_sizes':[len(X),len(Z)],'source_binary_pairing_rank':128,'triangular_minor':128,'strict_lower_nonzeros':0,'thin_family_counts':family_counts},
        'written_consequence':'Using Groenland etal arXiv2312.03859v1 Lemma7.1 and Observation4.6: him=mimsup=support-rank_F2=rank_F2=128, for the full source matrix and its both-sector thin{3,4} restriction. The asymptotic implication is a cited written proof, not a finite enumeration or Lean proof.',
        'balanced_word_controls':controls,
        'row_basis_counterexample':{'A':A,'representative_row_basis':B,'ranks':[2,2],'maximum_induced_matching':[2,1],'binary_factor_realization':{'X':[1,2,3],'Z':[1,3]}},
        'source_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [ROOT/'pools/xcoords.txt',ROOT/'pools/zcoords.txt',ROOT/'inversion-results/triangular-support.json',ROOT/'inversion-results/normal-form.json']}}
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'status':'PASS','pairing_rank':128,'triangular_minor':128,'families':[3,4],'balanced_word_controls':controls,'source_C16_answered':False}))


if __name__=='__main__':
    main()
