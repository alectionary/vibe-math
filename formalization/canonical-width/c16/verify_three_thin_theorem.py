#!/usr/bin/env python3
"""Independent source bridge for the at-least-three-thin-families theorem.

The general span/annihilator argument is stated in INVERSE-FOUR-HOURS.md.
This consumer checks the finite hypotheses and the exact block SDP dual.
No search, numerical optimization, cyclic-frame hypothesis, or Lean claim.
"""
from pathlib import Path
from itertools import combinations,product
import argparse,json,hashlib
from verify_two_thin_obstruction import report,sdot,tbits,tracecov
from verify_inverse_lift import vp,mp,pm,outer,shifts,vshifts,rank,mm,mat,pack,transpose,apply
from block_moment_dual import verify as verify_dual


def verify(source,certificate,rational_psd=None):
    base=report(source)
    q=source['dictionary']
    A=list(map(vp,q['X_left_dictionary']))
    B=list(map(vp,q['X_right_factors']))
    C=list(map(vp,q['Z_left_factors']))
    D=list(map(vp,q['Z_right_dictionary']))
    # Only pair(1,2) shares a residue line; its total X span has rank124.
    # Every other pair is a unimodular S basis. A full frame cannot use(1,2).
    for thin in [B,C]:
        assert [(i,j) for i,j in combinations(range(5),2) if not((pm(thin[i][0],thin[j][1])^pm(thin[i][1],thin[j][0]))&3)]==[(1,2)]
    one_ranks=[rank(v for a in A for v in shifts(outer(a,b))) for b in B]
    assert one_ranks==[64]*5
    annihilator_ranks=[]
    for i,j in combinations(range(5),2):
        total_rank=rank(v for a in A for h in [i,j] for v in shifts(outer(a,B[h])))
        if (i,j)==(1,2):
            assert total_rank==124
            annihilator_ranks.append({'thin_pair':[i,j],'X_available_span_rank':total_rank,'excluded_by_span':True})
            continue
        assert total_rank==128
        groups=[[k for k,d in enumerate(D) if sdot(B[h],d)==0] for h in [i,j]]
        ranks=[rank(v for c in C for k in group for v in shifts(outer(c,D[k]))) for group in groups]
        annihilator_ranks.append({'thin_pair':[i,j],'opposite_thick_types':groups,'opposite_span_ranks':ranks,'X_available_span_rank':total_rank})
    viable=[x for x in annihilator_ranks if not x.get('excluded_by_span') and min(x['opposite_span_ranks'])>=64]
    assert len(viable)==1 and viable[0]['thin_pair']==[3,4]
    # The 64 X vectors with thin B4 must pair to Z annihilating B3.
    assert viable[0]['opposite_thick_types'][0]==[3,5]
    assert certificate['block']==4 and certificate['target']==64 and certificate['period']==16
    dual=verify_dual(certificate,source,rational_psd=rational_psd)
    # Physical sector exchange is beta-self-adjoint and transports each thin
    # owner to one owner. Thus (X,Z)->(L^-1 Z,L X) preserves the Gram matrix.
    P=transpose(list(map(vp,source['sector_exchange']['P_columns'])))
    Q=list(map(vp,source['sector_exchange']['Q_rows']))
    L=[pack(mm(mm(P,transpose(mat(1<<k))),Q)) for k in range(128)]
    assert rank(L)==128
    tb=[tbits(1<<k) for k in range(128)]
    tc=[tracecov(1<<k) for k in range(128)]
    lt=[tbits(v) for v in L];lc=[tracecov(v) for v in L]
    assert rank(tc)==128
    assert all((lt[i]&tc[j]).bit_count()%2==(tb[i]&lc[j]).bit_count()%2 for i,j in product(range(128),repeat=2))
    sx={mp(v) for v in source['tensor']['X_tensor_coordinates']}
    sz={mp(v) for v in source['tensor']['Z_tensor_coordinates']}
    assert {apply(L,x) for x in sx}==sz
    zowner={v:j for j,c in enumerate(C) for d in D for v in shifts(outer(c,d))}
    assert len(zowner)==720
    permutation=[]
    for b in B:
        owners={zowner[apply(L,x)] for a in A for x in shifts(outer(a,b))}
        assert len(owners)==1;permutation.append(owners.pop())
    assert sorted(permutation)==list(range(5))
    return {'status':'PASS','theorem':'Every full original C16 minimum-pool canonical frame uses at least three thin families in each sector.',
        'source_C16_answered':False,'one_thin_family_X_span_ranks':one_ranks,'pairwise_thin_unimodularity_checks':20,'shared_residue_pair':[1,2],
        'two_thin_annihilator_cases':annihilator_ranks,'forced_X_thin_pair':[3,4],
        'forced_64_pair_block_X_thin':4,'forced_64_pair_block_Z_thick_types':[3,5],
        'exact_block_dual':dual,'exchange_rank':128,'exchange_self_adjoint_basis_pairings':16384,
        'exchange_source_points':720,'exchange_thin_owner_permutation':permutation,
        'restricted_two_by_two_control':base,'remaining_thin_family_counts_per_sector':[3,4,5],
        'ordinary_computer_assisted_proof':True,'Lean_completion':False}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('certificate',type=Path)
    ap.add_argument('--source',type=Path,default=Path(__file__).parent/'inversion-results/normal-form.json')
    ap.add_argument('--rational-psd',type=Path);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    from rational_cyclic_psd import read
    result=verify(json.loads(a.source.read_text()),json.loads(a.certificate.read_text()),rational_psd=read(a.rational_psd) if a.rational_psd else None)
    result['source_SHA256']=hashlib.sha256(a.source.read_bytes()).hexdigest()
    result['dual_certificate_SHA256']=hashlib.sha256(a.certificate.read_bytes()).hexdigest()
    a.output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ['status','theorem','exchange_thin_owner_permutation','source_C16_answered']}))
if __name__=='__main__':main()
