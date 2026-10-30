#!/usr/bin/env python3
"""Exact support pricing of residual-based heuristic directions; no optimizer.

The saved nonnegative binary-rational mixture weights are normalized exactly.
Metric choices are frozen before pricing. Exact positive target gaps still need
independent physical replay; residual directions carry no optimality assertion.
"""
from pathlib import Path
from fractions import Fraction
import argparse,hashlib,json,math,time
import numpy as np
from full_partner_projection import mask_universe,support_all,sha,LAYOUT
from full_partner_basis_oracle import FullPartnerBasisOracle
from full_partner_projection_features import moment_target
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent


def exact_seed(point,archive):
    target=moment_target(point_vector(point));z=np.load(archive);all_weights=z['master_mixture_weights']
    assert all_weights.min()>=0
    selected=np.flatnonzero(all_weights>0)
    weights=[Fraction(float(all_weights[i])) for i in selected]
    denominator=math.lcm(*(w.denominator for w in weights));integers=[w.numerator*(denominator//w.denominator) for w in weights]
    total=sum(integers);assert total>0
    F=z['features'][selected].astype(object)
    sums=np.asarray(integers,dtype=object)@F
    sums2=np.asarray(integers,dtype=object)@(F*F)
    mixture=[Fraction(int(v),total) for v in sums]
    variance=[Fraction(int(v),total)-m*m for v,m in zip(sums2,mixture)]
    assert all(v>=0 for v in variance) and target[0]==mixture[0]==1
    residual=[b-m for b,m in zip(target,mixture)]
    return target,mixture,residual,variance,selected,integers,total


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert not a.output.exists() and not a.output.with_suffix('.frozen.json').exists()
    start=time.monotonic();target,mixture,residual,variance,selected,numerators,denominator=exact_seed(a.point,a.archive)
    metrics=[('raw',[Fraction(1)]*775),
             ('target_floor_1',[1/max(Fraction(1),abs(b))**2 for b in target]),
             ('target_floor_1_16',[1/max(Fraction(1,16),abs(b))**2 for b in target]),
             ('mixture_variance_floor_1_256',[1/max(Fraction(1,256),v) for v in variance])]
    scales=[1<<16,1<<24,1<<32]
    allowed,reps=mask_universe(32);paths=['full_partner_projection_residual.py','full_partner_projection.py',
        'full_partner_projection_features.py','full_partner_basis_oracle.py','verify_projected_profile_moment_rows.py',
        'projected_profile_moment_matrix.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt',
        'algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz',
        'moment-resumption-results/symmetry-bridge-independent.json','coupling-results/full-partner-orbit32-independent.json']
    hashes={p:sha(ROOT/p) for p in paths}
    frozen={'status':'FROZEN_BEFORE_RESIDUAL_DIRECTION_PRICING','source_C16_answered':False,
        'point_sha256':sha(a.point),'archive_sha256':sha(a.archive),'source_hashes':hashes,'orbit':32,
        'feature_layout':LAYOUT,'allowed_masks':len(allowed),'representatives':reps,
        'allowed_mask_list_sha256':hashlib.sha256(json.dumps(allowed,separators=(',',':')).encode()).hexdigest(),
        'selected_mixture_columns':selected.tolist(),'exact_mixture_numerators':list(map(str,numerators)),
        'exact_mixture_denominator':str(denominator),'metrics':[{'name':n,'diagonal':list(map(str,D))} for n,D in metrics],
        'integer_scales':scales,'scope':'Heuristic residual directions from a non-Euclidean-optimized L1 mixture; no optimality or membership assertion.'}
    fp=a.output.with_suffix('.frozen.json');fp.write_text(json.dumps(frozen,indent=2)+'\n')
    oracle=FullPartnerBasisOracle();domains=[(p,oracle.prepare(32,p)) for p in reps];proposals=[];cuts=[]
    for name,D in metrics:
        direction=[d*r for d,r in zip(D,residual)];direction[0]=0;maximum=max(map(abs,direction));assert maximum>0
        for scale in scales:
            c=[round(scale*x/maximum) for x in direction]
            upper,records,columns=support_all(oracle,domains,c)
            value=sum(x*y for x,y in zip(c,target));mixed=sum(x*y for x,y in zip(c,mixture))
            gap=value-upper;wolfe=upper-mixed
            assert wolfe>=0,'Saved mixture columns should be within this priced source projection'
            proposal={'metric':name,'coefficients':c,'upper_bound':upper,'exact_target_value':str(value),
                'exact_mixture_value':str(mixed),'exact_violation':str(gap),'exact_Wolfe_gap':str(wolfe),
                'scaled_violation':float(gap/scale),'scaled_Wolfe_gap':float(wolfe/scale),
                'pricing_scale':scale,'support_records':records,
                'scope':'Exact support of a heuristic rounded residual direction; neither chosen metric nor residual is claimed optimized.'}
            proposals.append(proposal)
            if gap>0:cuts.append(proposal)
            print(json.dumps({k:proposal[k] for k in ('metric','pricing_scale','scaled_violation','scaled_Wolfe_gap')}),flush=True)
    assert all(sha(ROOT/p)==digest for p,digest in hashes.items())
    out={k:frozen[k] for k in ('point_sha256','source_hashes','orbit','feature_layout','allowed_masks','representatives','allowed_mask_list_sha256')}
    out.update(status='EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_RESIDUAL_SEPARATOR_FOUND',
        source_C16_answered=False,frozen_sha256=sha(fp),archive_sha256=sha(a.archive),proposals=proposals,cuts=cuts,
        exact_raw_residual_norm_squared=str(sum(r*r for r in residual)),
        exact_max_absolute_residual=str(max(map(abs,residual))),elapsed_seconds=time.monotonic()-start,
        scope='Exact global pricing of frozen heuristic residual directions only. No optimized L2 projection, membership, or source resolution follows; positive cuts require independent support replay.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'status':out['status'],'elapsed_seconds':out['elapsed_seconds'],'cuts':len(cuts)}),flush=True)


if __name__=='__main__':main()
