#!/usr/bin/env python3
"""Physical-frame consumer of the exchange split and normalized-coordinate map."""
from pathlib import Path
import argparse
import json
import numpy as np
from conditioned_moment import source_data, read, ROOT, P
from exchange_moment_model import model
from cyclic_moment_sdp import moments_from_masks
from audit_pools import exchange
from verify_partial_frame import mask, shift


def verify(families, mapping, patterns):
    source=read(ROOT/'physical-pool-source.json')
    Z=[shift(mask(r),h) for r in source['Z_orbit_representatives'] for h in range(P)]
    X=[exchange(z) for z in Z]
    xi,zi={v:i for i,v in enumerate(X)},{v:i for i,v in enumerate(Z)}
    pairs=[(xi[mask(r['X'])],zi[mask(r['Z'])]) for r in read(ROOT/'partial-frame-88.json')['pairs']]
    selected={9*c+i for c in families for i in range(9)}
    inverse=[{v:i for i,v in enumerate(ids)} for ids in mapping]
    pairs=[(i,j) for i,j in pairs if inverse[0][i]//16 in selected and inverse[1][j]//16 in selected]
    k=len(pairs)
    masks=[0]*90
    for i,j in pairs:
        masks[i//P]|=1<<(i%P)
        masks[45+j//P]|=1<<(j%P)
    first,C=moments_from_masks(masks,P)
    prob,p,Cnormal,info=model(ROOT,mapping,families,k,True)
    ids=info['original_active_orbits']
    variables={v.name():v for v in prob.variables()}
    variables['exchange_first'].value=(first[:45][ids]+first[45:][ids])/2
    for h in range(9):
        S=(C[h][:45,:45]+C[h][45:,45:])/2
        T=(C[h][:45,45:]+C[h][45:,:45])/2
        variables[f'S{h}'].value=S[np.ix_(ids,ids)]
        variables[f'T{h}'].value=T[np.ix_(ids,ids)]
    residual=max(float(np.max(c.violation())) for c in prob.constraints)
    assert residual<2e-12,residual
    expected=[]
    for mirrored in [False,True]:
        norm_masks=[0]*90
        for a,b in pairs:
            i,j=(b,a) if mirrored else (a,b)
            for side,v in enumerate([i,j]):
                w=inverse[side][v]
                norm_masks[side*45+w//P]|=1<<(w%P)
        expected.append(moments_from_masks(norm_masks,P))
    assert np.max(abs(p.value-(expected[0][0]+expected[1][0])/2))==0
    assert all(np.max(abs(Cnormal[h].value-(expected[0][1][h]+expected[1][1][h])/2))==0 for h in range(P))
    from conditioned_moment import add_frozen_base
    con,old=add_frozen_base(prob,p,Cnormal,patterns,k,mapping,True)
    old_residual=max(float(np.max(c.violation())) for c in con)
    assert old_residual<2e-12,old_residual
    return {'families':families,'physical_input_pairs':88,'retained_pairs':k,'exchange_psd_max_violation':residual,'normalized_coordinate_max_error':0,'all_frozen_base_cuts_max_violation':old_residual,'base_cuts':old,'exchange_model':info}


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    _,patterns,_,mapping,_=source_data()
    result={'status':'PASS','scope':'Exact dyadic coordinate/equality controls and numerical PSD replay of known physical frame averages; general necessity follows from the written congruence proof.','source_C16_answered':False,'cases':[verify(f,mapping,patterns) for f in [list(range(5)),[0,3,4]]]}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'status':'PASS','control_pairs':[c['retained_pairs'] for c in result['cases']]}))


if __name__=='__main__':main()
