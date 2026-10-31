#!/usr/bin/env python3
"""Build a physical multi-orbit seed for bounded projection pilots.

Fresh exact supports provide full opposite bases. A restricted numerical L1
master selects a convex combination solely as a search initializer. Every
column is retained and can be independently replayed; no membership is claimed.
"""
from pathlib import Path
import argparse, json, time, hashlib
import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csr_matrix, hstack, coo_matrix
from scipy.linalg import qr
from full_partner_projection import mask_universe, read, sha, LAYOUT
from full_partner_projection_features import FEATURES, moment_target
from full_partner_safe_pricing import support_all
from full_partner_batched_weights import IntegerPhaseWeightBatch
from full_partner_basis_oracle import FullPartnerBasisOracle
from verify_projected_profile_moment_rows import point_vector
ROOT = Path(__file__).resolve().parent


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--orbit',type=int,choices=tuple(o for o in range(45) if o!=12),required=True)
    ap.add_argument('--point',type=Path,required=True)
    ap.add_argument('--source-controls',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args(); assert not a.output.exists()
    started=time.monotonic(); controls=read(a.source_controls)
    assert controls['status']=='PASS' and controls['orbit']==a.orbit
    assert controls['consumer_sha256']==sha(ROOT/'verify_full_partner_projection_multi_orbit.py')
    assert all(sha(ROOT/p)==s for p,s in controls['source_hashes'].items())
    allowed,reps=mask_universe(a.orbit)
    assert len(allowed)==controls['allowed_masks_independently_enumerated']
    oracle=FullPartnerBasisOracle(); domains=[(m,oracle.prepare(a.orbit,m)) for m in reps]
    batch=IntegerPhaseWeightBatch(reps); rng=np.random.default_rng(20261030+a.orbit)
    coefficients=[[0]*FEATURES]+[list(map(int,rng.integers(-31,32,FEATURES))) for _ in range(4)]
    paths=['full_partner_projection_seed_multi_orbit.py','verify_full_partner_projection_multi_orbit.py',
        'full_partner_safe_pricing.py','full_partner_batched_weights.py','full_partner_projection.py',
        'full_partner_projection_features.py','full_partner_basis_oracle.py',
        'verify_projected_profile_moment_rows.py','projected_profile_moment_matrix.py']
    sources={**controls['source_hashes'],**{p:sha(ROOT/p) for p in paths}}
    frozen={'status':'FROZEN_PHYSICAL_ORBIT_SEED','source_C16_answered':False,'orbit':a.orbit,
        'point_sha256':sha(a.point),'source_hashes':sources,'source_controls_sha256':sha(a.source_controls),
        'coefficient_cohorts':coefficients,'representatives':reps,'allowed_masks':len(allowed),
        'feature_layout':LAYOUT,'restricted_L1_master_seconds':30}
    fp=a.output.with_suffix('.frozen.json'); assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
    features=[]; masks=[]; witnesses=[]; seen=set()
    for c in coefficients:
        _,records,columns=support_all(oracle,domains,c,batch)
        for r,f in zip(records,columns):
            packed=np.asarray(f,dtype=np.int16);key=packed.tobytes()
            if key in seen: continue
            seen.add(key);features.append(packed);masks.append(r['mask']);witnesses.append(r['selected_Z_indices'])
    F=np.stack(features); target=np.asarray(list(map(float,moment_target(point_vector(a.point),a.orbit))))
    n=len(F); errors=2*(FEATURES-1)
    E=coo_matrix((np.r_[np.ones(FEATURES-1),-np.ones(FEATURES-1)],
        (np.tile(np.arange(1,FEATURES),2),np.arange(errors))),shape=(FEATURES,errors)).tocsr()
    lp=linprog(np.r_[np.zeros(n),np.ones(errors)],A_eq=hstack([csr_matrix(F.T,dtype=float),E]),
        b_eq=target,bounds=(0,None),method='highs',options={'time_limit':30,'primal_feasibility_tolerance':1e-9,
        'dual_feasibility_tolerance':1e-9})
    if lp.status==0:
        weights=np.maximum(lp.x[:n],0);weights[weights<1e-12]=0;weights/=weights.sum()
        selected=np.flatnonzero(weights>0)
        U=(F[selected[1:]].astype(float)-F[selected[0]]).T
        _,R,_=qr(U,mode='economic',pivoting=True)
        rank=int(np.count_nonzero(abs(np.diag(R))>1e-10))
        if rank!=len(selected)-1: raise ValueError('Restricted seed positive columns not affinely independent')
        mode='restricted_L1_optimal_numerical_mixture'
    else:
        weights=np.zeros(n); weights[int(np.argmin(np.sum((F-target)**2,axis=1)))]=1
        selected=np.flatnonzero(weights);rank=0;mode='nearest_single_physical_column'
    archive=a.output.with_suffix('.columns.npz')
    np.savez_compressed(archive,features=F,masks=np.asarray(masks,dtype=np.uint16),
        selected_Z_indices=np.asarray(witnesses,dtype=np.uint16),master_mixture_weights=weights,
        active_column_ids=selected.astype(np.int32),orbit=a.orbit)
    assert all(sha(ROOT/p)==s for p,s in sources.items())
    result={**frozen,'status':'PHYSICAL_SEED_REQUIRES_INDEPENDENT_REPLAY','frozen_sha256':sha(fp),
        'columns_artifact':str(archive),'columns_sha256':sha(archive),'feature_columns':n,
        'seed_mode':mode,'numeric_master_status':int(lp.status),'numeric_master_message':str(lp.message),
        'positive_columns':len(selected),'affine_rank':rank,'numeric_mass':float(weights.sum()),
        'numeric_max_feature_residual':float(np.max(abs(weights@F-target))),
        'elapsed_seconds':time.monotonic()-started,
        'scope':'Fresh physical orbit-specific full-basis columns and a numerical convex seed only; no projected membership or source feasibility.'}
    a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k not in ('source_hashes','coefficient_cohorts','representatives')})


if __name__=='__main__':main()
