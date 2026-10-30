#!/usr/bin/env python3
"""Independent old-layout coefficient comparison and physical matching controls."""
from pathlib import Path
from collections import Counter
from functools import reduce
from operator import xor
import gzip,hashlib,json,time
import numpy as np
from fractions import Fraction as F
from physical_circuit_moment_matrix import matrix
from block_moment_dual import layout as old_layout
from moment_circuit_cuts import constraint as old_constraint
from verify_algebraic_model import physical
from verify_mixed_rank_cover_cuts import echelon
from verify_partial_frame import mask,shift
from audit_pools import exchange
from certify_profile_moment_point import layout
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();bp=ROOT/'moment-resumption-results/physical-rank-moment-bank.json';bank=json.loads(bp.read_text());circuits=bank['physical_circuits'];X,Z,A=physical();checks=0
    for C in circuits:
        for h in range(16):
            D=[16*(i//16)+(i%16+h)%16 for i in C]
            for U in (X,Z):assert reduce(xor,(U[i] for i in D),0)==0 and len(echelon(U[i] for i in D))==len(D)-1;checks+=1
    M,rows,meta=matrix(circuits);p,C,V=old_layout(90,16);fold={i:i%45 for i in range(90)}
    def coordinate(side,h,i,j):
        if side=='S' and h==0 and i==j:return i
        if h in (0,8) and i>j:i,j=j,i
        return 45+(0 if side=='S' else 9*2025)+2025*h+45*i+j
    for h in range(9):
        for i in range(90):
            for j in range(90):
                k=coordinate('S' if (i<45)==(j<45) else 'T',h,i%45,j%45);idx=C[h][i][j]
                assert fold.setdefault(idx,k)==k
    for row,r in zip(rows,meta):
        old,rhs=old_constraint({'sector':'X' if r['child_sector']=='S' else 'Z','circuit':circuits[r['circuit_index']],'phase':r['phase'],'anchor':r['anchor_orbit']},p,C);assert rhs==0;terms=Counter()
        for k,c in old:terms[fold[k]]+=c
        assert tuple(sorted((k,c) for k,c in terms.items() if c))==row
    source=json.loads((ROOT/'physical-pool-source.json').read_text());Zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp));lookup=[{v:i for i,v in enumerate(U)} for U in (Xp,Zp)];pairs=[tuple(lookup[s][mask(r[side])] for s,side in enumerate(('X','Z'))) for r in json.loads((ROOT/'partial-frame-88.json').read_text())['pairs']];assert all(((A[x]>>z)&1)==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));masks=[[0]*45 for _ in range(2)]
    for pair in pairs:
        for s,v in enumerate(pair):masks[s][v//16]|=1<<(v%16)
    corr=lambda a,b,h:(a&((b>>h)|(b<<(16-h)))&65535).bit_count()
    flat=[masks[0][i].bit_count()+masks[1][i].bit_count() for i in range(45)]+[sum(corr(masks[s][i],masks[s if side=='S' else 1-s][j],h) for s in (0,1)) for side in ('S','T') for h in range(9) for i in range(45) for j in range(45)];assert max(M@np.array(flat,dtype=np.int64))<=0
    # Check exact known-null-vector reconstruction on an actual affine-feasible
    # rational candidate. The candidate itself remains PSD-rejected.
    hp=ROOT/'algebraic-results/hulls-16-rank.json.gz';names,index,m=layout(json.loads(gzip.decompress(hp.read_bytes())));point=ROOT/'moment-resumption-results/interior-pivots-point.json.gz';v=list(map(F,json.loads(gzip.decompress(point.read_bytes()))['values']));first=[v[index['p',i]] for i in range(45)]
    SS=[[sum(v[m('S',h,i,j)] for h in range(16)) for j in range(45)] for i in range(45)];TT=[[sum(v[m('T',h,i,j)] for h in range(16)) for j in range(45)] for i in range(45)];G=[[F(1),*first]]+[[first[i],*[(SS[i][j]+TT[i][j])/32 for j in range(45)]] for i in range(45)];D=[[SS[i][j]-TT[i][j] for j in range(45)] for i in range(45)]
    for Q,null in [(G,[F(-8)]+[F(1)]*45),(D,[F(1)]*45)]:
        n=len(Q);assert null[-1]==1
        assert all(sum(Q[i][j]*null[j] for j in range(n))==0 for i in range(n))
        assert all(Q[i][-1]==-sum(Q[i][j]*null[j] for j in range(n-1)) for i in range(n-1))
        assert Q[-1][-1]==sum(null[i]*Q[i][j]*null[j] for i in range(n-1) for j in range(n-1))
    result={'status':'PASS','source_C16_answered':False,'bank_sha256':sha(bp),'physical_translated_circuit_rank_checks':checks,'old_full_layout_coefficient_rows_compared':len(rows),'physical88_exact_averaged_circuit_controls':len(rows),'known_null_principal_reconstruction_exact':True,'null_reconstruction_input_sha256':sha(point),'null_control_is_not_a_feasibility_certificate':True,'source_hashes':{p:sha(ROOT/p) for p in ['physical_circuit_moment_matrix.py','verify_physical_circuit_moments.py','moment_circuit_cuts.py','block_moment_dual.py']},'elapsed_seconds':time.monotonic()-start,'scope':'All stated physical circuit-rank inequalities, exact coefficient translation from the older90-orbit layout, known matching controls, and exact zero-frequency principal reconstruction. No original frame or infeasibility result.'}
    (ROOT/'moment-resumption-results/physical-circuit-independent.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
