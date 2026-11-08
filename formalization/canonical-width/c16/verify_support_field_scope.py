#!/usr/bin/env python3
"""Exact finite controls for a coefficient-field warning in the paper screen.

For every even q>=2, the off-diagonal support of K_q has binary support
rank q: over F2 the unique support matrix A=I+J satisfies A^2=I.
Its mimsup is2: over Q the matrix B_ij=i-j has the same support and rank2,
while a triangular2 minor (or the q=2 matching) gives the matching lower bound.
The infinite-family conclusion is this written argument, not the finite test.
"""
from pathlib import Path
import argparse
import json
from verify_anchor_cover import basis_indices


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    controls=[]
    for q in range(2,65,2):
        rows=[((1<<q)-1)^(1<<i) for i in range(q)]
        assert len(basis_indices(rows,range(q)))==q
        for i in range(q):
            square=0
            for j in range(q):
                if rows[i]>>j&1:square^=rows[j]
            assert square==1<<i
        B=[[i-j for j in range(q)] for i in range(q)]
        assert all((B[i][j]!=0)==bool(rows[i]>>j&1) for i in range(q) for j in range(q))
        assert B[0][0]*B[1][1]-B[0][1]*B[1][0]==1
        if q>2:assert [[rows[i]>>j&1 for j in [1,2]] for i in [0,1]]==[[1,1],[0,1]]
        controls.append({'q':q,'binary_support_rank':q,'rational_support_rank':2,'mimsup_written_squeeze':2})
    result={'status':'PASS','source_C16_answered':False,'finite_controls':controls,
        'written_family_result':'For every even q>=2: support-rank_F2(K_q)=q and mimsup(K_q)=2. Thus binary support rank is not functionally equivalent to mimsup, and strictness already occurs at K4.',
        'source_comparison':'F153 Section4.2 defines support rank relative to a field; the displayed rank2 K_q construction uses enough distinct field elements. The open support-rank questions must not silently be specialized to F2. Their intended coefficient-field scope remains a formulation gate in this screen.',
        'claim_limit':'No claim to answer the authors intended field convention or the unrestricted C16 question. No Lean completion.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('PASS:32 even complete-graph controls; coefficient-field formulation gate retained.',flush=True)


if __name__=='__main__':main()
