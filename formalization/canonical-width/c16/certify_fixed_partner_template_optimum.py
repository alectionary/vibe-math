#!/usr/bin/env python3
"""Exact primal/dual certificate for a fixed-T ten-feature upper-bound LP.

A negative optimum limits this fixed template with the supplied per-mask upper
bounds. It does not establish projected membership, optimal pair pricing, or
source feasibility. The source upper bounds have their own independent receipt.
"""
from pathlib import Path
from fractions import Fraction
import argparse
import hashlib
import json

import numpy as np
from scipy.optimize import linprog
from full_partner_projection_features import column_features, moment_target
from verify_projected_profile_moment_rows import point_vector


def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def solve_exact(A,b):
    rows=[[Fraction(x) for x in row]+[Fraction(v)] for row,v in zip(A,b)]
    n=len(rows)
    assert all(len(row)==n+1 for row in rows)
    for j in range(n):
        pivot=next(i for i in range(j,n) if rows[i][j])
        rows[j],rows[pivot]=rows[pivot],rows[j]
        divisor=rows[j][j];rows[j]=[v/divisor for v in rows[j]]
        for i in range(n):
            if i!=j and rows[i][j]:
                multiplier=rows[i][j];rows[i]=[x-multiplier*y for x,y in zip(rows[i],rows[j])]
    return [row[-1] for row in rows]


def verify(cert,point,bounds,frozen,replay):
    assert cert['point_sha256']==sha(point) and cert['bounds_sha256']==sha(bounds)
    assert cert['frozen_sha256']==sha(frozen) and cert['bounds_replay_sha256']==sha(replay)
    bank=json.loads(bounds.read_text());meta=json.loads(frozen.read_text());receipt=json.loads(replay.read_text())
    assert receipt['status']=='PASS' and receipt['bank_sha256']==sha(bounds) and receipt['frozen_sha256']==sha(frozen)
    assert meta['weight_mode']=='affine_phase_template'
    coefficients=meta['coefficients'];assert len(coefficients)==775 and not any(coefficients[:10])
    target=moment_target(point_vector(point));records=bank['records'];assert len(records)==291
    features=[column_features(r['mask'],())[:10] for r in records]
    upper=[Fraction(r['upper']) for r in records]
    u=list(map(Fraction,cert['unconditional_coefficients']));assert len(u)==10
    assert all(sum(x*y for x,y in zip(row,u))+b<=0 for row,b in zip(features,upper))
    dual={int(row):Fraction(value) for row,value in cert['dual_weights'].items()}
    assert all(0<=row<len(records) and value>=0 for row,value in dual.items())
    assert all(sum(value*features[row][j] for row,value in dual.items())==target[j] for j in range(10))
    fixed=sum(c*t for c,t in zip(coefficients,target))
    primal=fixed+sum(x*y for x,y in zip(u,target[:10]))
    dual_bound=fixed-sum(value*upper[row] for row,value in dual.items())
    assert primal==dual_bound==Fraction(cert['exact_optimal_violation'])
    return {'status':'PASS','source_C16_answered':False,'mask_constraints_checked':len(records),
            'exact_feature_reproduction_equations':10,'nonnegative_dual_weights':len(dual),
            'exact_optimal_violation':str(primal),'approximate_optimal_violation':float(primal),
            'strict_separator_exists_with_supplied_bounds_and_fixed_T_forms':primal>0,
            'scope':'Exact optimum only for ten unconditional coefficients with fixed11T forms and the supplied291 certified upper bounds. No arbitrary-coefficient projection membership, optimal pair pricing, or source feasibility follows.'}


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--bounds',type=Path,required=True)
    ap.add_argument('--replay',type=Path,required=True);ap.add_argument('--certificate',type=Path,required=True)
    ap.add_argument('--output',type=Path,required=True);ap.add_argument('--verify-only',action='store_true')
    a=ap.parse_args();frozen=a.bounds.with_suffix('.frozen.json')
    if a.verify_only:cert=json.loads(a.certificate.read_text())
    else:
        bank=json.loads(a.bounds.read_text());meta=json.loads(frozen.read_text());target=moment_target(point_vector(a.point))
        A=np.array([column_features(r['mask'],())[:10] for r in bank['records']],dtype=np.int64)
        upper=[Fraction(r['upper']) for r in bank['records']]
        lp=linprog(-np.array(list(map(float,target[:10]))),A_ub=A,b_ub=-np.array(list(map(float,upper))),bounds=[(None,None)]*10,method='highs')
        assert lp.success
        active=np.flatnonzero(-lp.ineqlin.marginals>1e-9).tolist();assert len(active)==10
        dual=solve_exact(A[active,:].T.tolist(),target[:10])
        u=solve_exact(A[active,:].tolist(),[-upper[row] for row in active])
        value=sum(c*t for c,t in zip(meta['coefficients'],target))+sum(x*y for x,y in zip(u,target[:10]))
        cert={'status':'EXACT_FIXED_TEMPLATE_OPTIMUM_CANDIDATE','source_C16_answered':False,
              'point_sha256':sha(a.point),'bounds_sha256':sha(a.bounds),'frozen_sha256':sha(frozen),
              'bounds_replay_sha256':sha(a.replay),'producer_sha256':sha(Path(__file__)),
              'unconditional_coefficients':list(map(str,u)),
              'dual_weights':{str(row):str(v) for row,v in zip(active,dual)},
              'exact_optimal_violation':str(value),
              'scope':'Finite fixed-template LP optimum, not projected membership or a source result.'}
        assert not a.certificate.exists();a.certificate.write_text(json.dumps(cert,indent=2)+'\n')
    result=verify(cert,a.point,a.bounds,frozen,a.replay)
    result.update(certificate_sha256=sha(a.certificate),consumer_sha256=sha(Path(__file__)))
    a.output.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))


if __name__=='__main__':main()
