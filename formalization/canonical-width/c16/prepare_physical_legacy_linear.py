#!/usr/bin/env python3
"""Recheck retained physical ranks and all old Boolean-form controls."""
from pathlib import Path
from collections import Counter
import hashlib,json,time
import numpy as np
from physical_legacy_linear_moments import build,read
from verify_algebraic_model import physical
from verify_mixed_rank_cover_cuts import echelon
from moment_triangle_cuts import literal_control as triangle_control
from moment_integer_form_cuts import literal_control as integer_control
from verify_partial_frame import mask,shift
from audit_pools import exchange
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    start=time.monotonic();bp=ROOT/'moment-resumption-results/physical-rank-moment-bank.json';mapping=read(bp)['mapping'];M,rhs,records,rectangles,fold=build(mapping);X,Z,A=physical();rankchecks=0
    for n,(orbits,r) in enumerate(rectangles.items()):
        ids=[16*o+h for o in orbits for h in range(16)]
        for U in (X,Z):assert len(echelon(U[i] for i in ids))==r;rankchecks+=1
        if n%1000==0:print('PHYSICAL RECTANGLE',n,round(time.monotonic()-start,2),flush=True)
    triangle=triangle_control();forms=read(ROOT/'inverse-four-hour-results/lattice-source-integer-forms.json.gz');boolean=sum(integer_control(r) for r in forms)
    source=read(ROOT/'physical-pool-source.json');Zp=[shift(mask(s),h) for s in source['Z_orbit_representatives'] for h in range(16)];Xp=list(map(exchange,Zp));lookup=[{v:i for i,v in enumerate(U)} for U in (Xp,Zp)];pairs=[tuple(lookup[s][mask(r[side])] for s,side in enumerate(('X','Z'))) for r in read(ROOT/'partial-frame-88.json')['pairs']];assert all(((A[x]>>z)&1)==(i==j) for i,(x,_) in enumerate(pairs) for j,(_,z) in enumerate(pairs));masks=[[0]*45 for _ in range(2)]
    for pair in pairs:
        for s,v in enumerate(pair):masks[s][v//16]|=1<<(v%16)
    corr=lambda a,b,h:(a&((b>>h)|(b<<(16-h)))&65535).bit_count()
    flat=np.array([masks[0][i].bit_count()+masks[1][i].bit_count() for i in range(45)]+[sum(corr(masks[s][i],masks[s if side=='S' else 1-s][j],h) for s in (0,1)) for side in ('S','T') for h in range(9) for i in range(45) for j in range(45)],dtype=np.int64)
    assert max(M@flat-32*np.array(rhs,dtype=np.int64))<=0
    # Independently evaluate every older moment variable in the actual physical
    # frame, averaging physical sector exchange before applying old coordinates.
    from block_moment_dual import layout
    op,OC,V=layout(90,16);checked=0
    for h in range(9):
        for i in range(90):
            for j in range(90):
                si,sj=i//45,j//45;a=mapping['X' if si==0 else 'Z'][16*(i%45)];b=mapping['X' if sj==0 else 'Z'][16*(j%45)+h];oa,ha=divmod(a,16);ob,hb=divmod(b,16);expected=sum(corr(masks[si^s][oa],masks[sj^s][ob],(hb-ha)%16) for s in (0,1));assert expected==flat[fold[OC[h][i][j]]];checked+=1
    point=ROOT/'moment-resumption-results/owner-combined-necessary.npz';z=np.load(point);numeric=np.concatenate([z['p']]+[z[f'{side}{h}'].ravel() for side in ('S','T') for h in range(9)]);violation=M@numeric-np.array(rhs);bykind=Counter(r['origin']['kind'] for r,v in zip(records,violation) if v>1e-7)
    paths=[ROOT/'inverse-four-hour-results'/name for name in ['rank-rectangle-X.json','rank-rectangle-Z.json','lattice-source-rankcuts.json.gz','lattice-source-triangles.json.gz','lattice-source-integer-forms.json.gz']]
    result={'status':'PASS','source_C16_answered':False,'distinct_linear_rows':len(records),'matrix_nonzeros':M.nnz,'row_kinds':dict(Counter(r['origin']['kind'] for r in records)),'physical_rectangle_rank_checks':rankchecks,'distinct_physical_rectangle_sets':len(rectangles),'Boolean_triangle_controls':triangle['Boolean_literal_tests'],'integer_form_Boolean_controls':boolean,'old_coordinate_moment_values_checked':checked,'physical88_exact_row_controls':len(records),'numerical_candidate_sha256':sha(point),'numerically_violated_rows':int(sum(violation>1e-7)),'violations_by_kind':dict(bykind),'maximum_numeric_violation':float(max(violation)),'input_hashes':{str(p.relative_to(ROOT)):sha(p) for p in [bp,*paths]},'source_hashes':{p:sha(ROOT/p) for p in ['physical_legacy_linear_moments.py','prepare_physical_legacy_linear.py']},'elapsed_seconds':time.monotonic()-start,'scope':'All previously frozen rectangle, triangle and integer-form constraints translated into physical sector-folded coordinates. Every physical rectangle rank is recomputed in both pools; Boolean formulas and the known88-pair matching control every used row. Numerical separation is not infeasibility.'}
    (ROOT/'moment-resumption-results/physical-legacy-linear-preparation.json').write_text(json.dumps(result,indent=2)+'\n');print(result,flush=True)
if __name__=='__main__':main()
