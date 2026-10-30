"""Produce an exact owner-row candidate from the tiny pattern-cost LP.

The independent final acceptance is verify_shared_master_minorant.py.
No optimizer or physical pricing is called by this adapter.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import json
import time
from verify_shared_master_common import ROOT,guard,resolve,sha,read
from read_soplex_exact_output_v2 import read_named_rational
from verify_two_sided_full_basis_oracle import point_owner
from shared_master_price_algebra import LOW,check_minorant,owner_projection


def encode(v):
    if isinstance(v,Q):return str(v)
    if isinstance(v,dict):return {str(k):encode(x) for k,x in v.items()}
    if isinstance(v,(list,tuple)):return [encode(x) for x in v]
    return v


def main():
    ap=argparse.ArgumentParser()
    for key in ('manifest','primal','dual','solver-frozen','output'):
        ap.add_argument('--'+key,type=Path,required=True)
    a=ap.parse_args();guard();start=time.monotonic();out=resolve(a.output)
    assert not out.exists()
    m=read(a.manifest)
    assert m['status']=='EXACT_SHARED_MASTER_PATTERN_COST_LP_REQUIRES_REPLAY'
    assert m['variable_count']==16 and m['row_count']==27 and m['low_masks']==list(LOW)
    assert sha(m['pricing'])==m['pricing_sha256'] and sha(m['pricing_receipt'])==m['pricing_receipt_sha256']
    assert sha(m['lp'])==m['lp_sha256']
    p=read(m['pricing']);pr=read(m['pricing_receipt'])
    assert pr['status']=='PASS_EXACT_SHARED_MASTER_FULL_DOMAIN_PRICING'
    assert pr['pricing_sha256']==m['pricing_sha256']
    assert pr['consumer_sha256']==sha('verify_shared_master_projection.py')
    frozen=read(a.solver_frozen)
    assert frozen['input_manifest_sha256']==sha(a.manifest) and frozen['input_lp_sha256']==m['lp_sha256']
    assert '-X='+str(resolve(a.primal)) in frozen['command']
    assert '-Y='+str(resolve(a.dual)) in frozen['command']
    costs=list(map(Q,m['pattern_costs']));q=list(map(Q,m['low_moment_targets']))
    assert costs==list(map(Q,p['pattern_costs'])) and q==list(map(Q,p['low_moment_targets']))
    xx=read_named_rational(resolve(a.primal),['x'+str(i) for i in range(16)])
    law=[xx['x'+str(i)] for i in range(16)]
    assert min(law)>=0
    assert all(sum(law[k] for k in range(16) if k&h==h)==q[i] for i,h in enumerate(LOW))
    objective=sum(c*x for c,x in zip(costs,law))
    names=['f'+str(i) for i in range(11)]+['n'+str(i) for i in range(16)]
    raw=read_named_rational(resolve(a.dual),names,'dual')
    accepted=None
    for sign in (1,-1):
        dual={name:sign*v for name,v in raw.items()}
        d=[dual['f'+str(i)] for i in range(11)]
        b=[sum((d[i] for i,h in enumerate(LOW) if k&h==h),Q(0)) for k in range(16)]
        if any(dual['n'+str(k)]>0 or b[k]-dual['n'+str(k)]!=costs[k] for k in range(16)):continue
        if sum(c*x for c,x in zip(d,q))!=objective:continue
        accepted=(sign,d,b);break
    assert accepted is not None,'No exact tiny primal/dual optimality equality'
    sign,d,b=accepted
    assert check_minorant(costs,d)==b
    owner={int(j):Q(v) for j,v in p['owner_feature_coefficients']}
    row=owner_projection(owner,p['low_owner_map'],d)
    f=[Q(1),*point_owner(resolve(p['point']))]
    assert [f[j] for j in p['low_owner_map']]==q
    source_value=sum(v*f[j] for j,v in owner.items())
    assert source_value==Q(p['source_target_constant'])
    gap=source_value+objective
    rational_row=row['rational_owner_feature_coefficients']
    assert sum(v*f[j] for j,v in rational_row.items())==gap
    integer_gap=sum(v*f[j+1] for j,v in row['integer_owner_coefficients'])-row['integer_rhs']
    assert integer_gap==gap*row['positive_scale']
    maxabs=max([abs(row['integer_rhs']),*[abs(v) for j,v in row['integer_owner_coefficients']]])
    dependencies=['shared_master_price_projection.py','shared_master_price_algebra.py',
                  'shared_master_price_minorant.py','verify_shared_master_projection.py',
                  'read_soplex_exact_output_v2.py','verify_two_sided_full_basis_oracle.py']
    result=dict(status='EXACT_SHARED_MASTER_PROJECTED_OWNER_ROW_REQUIRES_REPLAY',
                minorant_manifest=str(a.manifest),minorant_manifest_sha256=sha(a.manifest),
                primal=str(a.primal),primal_sha256=sha(a.primal),dual=str(a.dual),dual_sha256=sha(a.dual),
                solver_frozen=str(a.solver_frozen),solver_frozen_sha256=sha(a.solver_frozen),
                pricing=m['pricing'],pricing_sha256=m['pricing_sha256'],pricing_receipt=m['pricing_receipt'],
                pricing_receipt_sha256=m['pricing_receipt_sha256'],point=p['point'],point_sha256=p['point_sha256'],
                dual_sign=sign,minorant_coefficients=d,minorant_pattern_values=b,pattern_costs=costs,
                minimizing_pattern_law=law,low_moment_targets=q,low_owner_map=p['low_owner_map'],
                exact_minimum_pattern_cost=objective,source_target_constant=source_value,
                exact_projected_gap=gap,constant_minorant_gap=source_value+min(costs),
                rational_owner_feature_coefficients=[[j,v] for j,v in sorted(rational_row.items())],
                owner_indices=[j for j,v in row['integer_owner_coefficients']],
                owner_coefficients=[v for j,v in row['integer_owner_coefficients']],rhs=row['integer_rhs'],
                positive_normalization_scale=row['positive_scale'],integer_exact_violation=integer_gap,
                maximum_integer_coefficient_bits=maxabs.bit_length(),fits_signed_int64=maxabs<=2**63-1,
                candidate_separates_point=gap>0,zero_tau_pins=False,
                source_hashes={name:sha(name) for name in dependencies},elapsed_seconds=time.monotonic()-start,
                scope='Pin-free necessary owner-row candidate; acceptance requires independent source/pricing/minorant replay and positive gap for target exclusion.',
                source_C16_answered=False,full_source_frame=False)
    out.write_text(json.dumps(encode(result),indent=2)+'\n')
    print(json.dumps(dict(status=result['status'],output=str(out.relative_to(ROOT)),sha256=sha(out),
                          exact_projected_gap=str(gap),candidate_separates_point=gap>0,
                          coefficient_bits=result['maximum_integer_coefficient_bits'])))


if __name__=='__main__':main()
