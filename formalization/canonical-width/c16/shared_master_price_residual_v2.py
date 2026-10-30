"""Exact source-combination diagnostic guided by named HiGHS decimal JSON.

This is not a solver-dual/optimality certificate. Printed decimal tokens are
chosen exact rational multipliers, inequality signs are clipped explicitly,
and every finite residual is bounded by a separately certified source row.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import gzip
import json
import re
import time
from verify_shared_master_common import ROOT,guard,resolve,sha,read,value
from verify_shared_master_preparation import context
from shared_master_price_algebra import add,LOW
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle

DECIMAL=re.compile(r'[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?\Z')


def parse_highs_candidate(candidate,names):
    names=list(names);assert len(names)==len(set(names))
    assert candidate['status']=='NUMERICAL_SHARED_MASTER_ROW_DUAL_CANDIDATE'
    assert candidate['dual_valid'] is True
    rows=candidate['row_dual'];assert candidate['rows']==len(names)==len(rows)
    assert [r[0] for r in rows]==names,'Missing/reordered/duplicate/foreign named row'
    entries=[];values={}
    for record in rows:
        assert isinstance(record,list) and len(record)==2
        name,token=record
        assert type(token)is str and DECIMAL.fullmatch(token),'Nonfinite/nondecimal string'
        number=Q(token);values[name]=number;entries.append([name,token,str(number)])
    return values,entries,dict(candidate_format='HIGHS_NAMED_DECIMAL_ROW_DUAL_JSON',
        complete_named_rows=len(names),all_rows_explicit=True,
        decimal_tokens_chosen_as_exact_rationals=True,original_solver_dual_exactness_claimed=False,
        numerical_dual_valid_is_not_mathematical_feasibility=True)


def encode(v):
    if isinstance(v,Q):return str(v)
    if isinstance(v,dict):return {str(k):encode(x) for k,x in v.items()}
    if isinstance(v,(list,tuple)):return [encode(x) for x in v]
    return v


def tiny_controls(output):
    import copy
    names=['eq','le','sm_nonneg_9']
    candidate=dict(status='NUMERICAL_SHARED_MASTER_ROW_DUAL_CANDIDATE',dual_valid=True,rows=3,
                   row_dual=[['eq','-1.25e-2'],['le','3.50E-3'],['sm_nonneg_9','-2']])
    raw,entries,meta=parse_highs_candidate(candidate,names)
    assert raw==dict(eq=Q(-1,80),le=Q(7,2000),sm_nonneg_9=Q(-2))
    assert -raw['eq']==Q(1,80) and max(Q(0),-raw['le'])==0
    rejected=[]
    mutations={}
    for label in ('nonfinite','duplicate_row','unknown_row','missing_row','false_availability','numeric_instead_of_decimal_string'):
        bad=copy.deepcopy(candidate)
        if label=='nonfinite':bad['row_dual'][0][1]='NaN'
        elif label=='duplicate_row':bad['row_dual'][1][0]='eq'
        elif label=='unknown_row':bad['row_dual'][1][0]='foreign'
        elif label=='missing_row':bad['row_dual'].pop()
        elif label=='false_availability':bad['dual_valid']=False
        else:bad['row_dual'][0][1]=0.5
        mutations[label]=bad
    for label,bad in mutations.items():
        try:parse_highs_candidate(bad,names)
        except (AssertionError,ValueError):rejected.append(label)
        else:raise AssertionError(label)
    result=dict(status='PASS_HIGHS_JSON_GUIDED_SOURCE_MULTIPLIER_PARSER_CONTROLS',source_sha256=sha(__file__),
                exact_decimal_examples=3,positive_inequality_clipping_example=True,rejected_mutants=rejected,
                no_solver_or_physical_query=True,scope='Parser/exact-rationalization controls, not a solver-dual certificate.')
    output.write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(dict(status=result['status'],output=str(output),sha256=sha(output))))


def main():
    ap=argparse.ArgumentParser();ap.add_argument('--controls',action='store_true')
    for key in ('manifest','preparation','numerical-candidate','numerical-frozen','bounds-certificate','bounds-receipt','output'):
        ap.add_argument('--'+key)
    a=ap.parse_args();guard();start=time.monotonic();out=resolve(a.output);assert not out.exists()
    if a.controls:tiny_controls(out);return
    assert all(getattr(a,k) for k in ('manifest','preparation','numerical_candidate','numerical_frozen','bounds_certificate','bounds_receipt'))
    data,L,semantic=context(a.manifest,a.preparation,check_columns=False);M,f=data['M'],data['f'];d=data['manifest']
    candidate=read(a.numerical_candidate);frozen=read(a.numerical_frozen)
    assert candidate['manifest_sha256']==sha(a.manifest) and candidate['lp_sha256']==d['lp_sha256']
    assert sha(candidate['manifest'])==sha(a.manifest)
    assert sha(candidate['frozen'])==candidate['frozen_sha256']==sha(a.numerical_frozen)
    assert frozen['manifest_sha256']==sha(a.manifest) and frozen['preparation_receipt_sha256']==sha(a.preparation)
    assert frozen['semantic_sha256']==d['semantic_sha256'] and frozen['lp_sha256']==d['lp_sha256']
    assert frozen['zero_tau_pins'] is False and frozen['all_sixteen_patterns'] is True
    names=[r[0] for r in data['parent_rows']]
    names += [f'sm_mass_{s}_{m}' for m in range(16) for s in 'XZ']
    names += [f'sm_link_{s}_{m}_{j}' for m in range(16) for s in 'XZ' for j in range(720)]
    names += ['sm_nonneg_'+str(j) for j in range(22513,L['variable_count'])]
    raw,entries,parser=parse_highs_candidate(candidate,names)
    bc,br=read(a.bounds_certificate),read(a.bounds_receipt)
    assert br['status']=='PASS_EXACT_SHARED_MASTER_PATTERN_LOCAL_PROBABILITY_BOUNDS'
    assert br['certificate_sha256']==sha(a.bounds_certificate)
    assert br['consumer_sha256']==sha('verify_shared_master_projection_bounds.py')
    assert bc['manifest_sha256']==br['manifest_sha256']==sha(a.manifest)
    assert bc['preparation_sha256']==sha(a.preparation) and bc['point_sha256']==d['point_sha256']
    assert br['finite_variables_covered']==22508 and br['exact_tau_superset_identities']==5
    boundmap={r['variable']:r['mask'] for r in bc['bounds']}
    assert set(boundmap)==set(range(5,22513))
    expression=({},{})
    clipped=[];parent_weights=[]
    for name,e,relation in data['parent_rows']:
        pi=raw[name]
        if relation=='<=':
            weight=max(Q(0),-pi)
            if pi>0:clipped.append([name,pi])
        else:
            assert relation=='=';weight=-pi
        if weight:
            parent_weights.append([name,weight]);expression=add(expression,e,weight)
    blocks={}
    for m in range(16):
        for s in 'XZ':
            pmass=raw[f'sm_mass_{s}_{m}']
            expression=add(expression,M['lambda_expressions'][m],pmass)
            costs=[]
            for j,e in enumerate(M['sectors'][s]['allocations'][m]):
                pi=raw[f'sm_link_{s}_{m}_{j}'];costs.append(-pi)
                if pi:expression=add(expression,e,pi)
            blocks[s,m]=dict(constant=-pmass,weights=costs)
    assert all(0<=j<22513 for j in expression[1])
    residual={j:v for j,v in expression[1].items() if j>=5}
    high={M['variables'][j]['mask']:v for j,v in expression[1].items() if j<5}
    sigma=[Q(0)]*16
    for j,v in residual.items():sigma[boundmap[j]]+=min(Q(0),v)
    rho=[sum((v for h,v in high.items() if m&h==h),Q(0)) for m in range(16)]
    oracle=TwoSidedFullBasisOracle();domains=oracle.prepare(M['X_anchors'],M['Z_anchors'])
    records=[];minima={};negative=[]
    archives={(s,m):{tuple(sorted(L['columns'][k]['indices'])) for k in L['blocks'][s,m]} for m in range(16) for s in 'XZ'}
    for m in range(16):
        support=oracle.support_pattern(domains[m],[-v for s in 'XZ' for v in blocks[s,m]['weights']])
        assert support['status']=='EXACT_TWO_SIDED_PATTERN_BASIS_SUPPORT'
        record=dict(mask=m,oracle_support=support,sectors={})
        for s in 'XZ':
            b=blocks[s,m];chosen=support[s+'_selected'];minimum=b['constant']-Q(support[s+'_support']['value'])
            assert minimum==b['constant']+sum((b['weights'][j] for j in chosen),Q(0))
            minima[s,m]=minimum
            record['sectors'][s]=dict(constant=b['constant'],weights=b['weights'],minimum=minimum,selected_indices=chosen)
            if minimum<0:negative.append(dict(side=s,mask=m,minimum=minimum,indices=chosen,
                                               is_archived=tuple(sorted(chosen)) in archives[s,m]))
        records.append(record)
    pattern_costs=[minima['X',m]+minima['Z',m]+sigma[m]+rho[m] for m in range(16)]
    fmap=M['source_feature_to_owner_target'][:11];q=[f[j] for j in fmap]
    endpoint=data['endpoint'];params=list(map(Q,endpoint['exact_parameters']))
    assert len(params)==22513
    law=[value(e,f,params) for e in M['lambda_expressions']]
    assert law==list(map(Q,endpoint['lambda_masses'])) and min(law)>=0 and sum(law)==1
    assert all(sum(law[m] for m in range(16) if m&h==h)==q[i] for i,h in enumerate(LOW))
    G=expression[0];gvalue=sum((v*f[j] for j,v in G.items()),Q(0))
    coarse=sum((min(Q(0),v) for v in residual.values()),Q(0))
    coarse_gap=gvalue+coarse+min(minima['X',m]+minima['Z',m]+rho[m] for m in range(16))
    assert gvalue+min(pattern_costs)>=coarse_gap
    deps=['shared_master_price_residual_v2.py','shared_master_price_algebra.py','verify_shared_master_common.py',
          'verify_shared_master_preparation.py','verify_shared_master_projection_bounds.py',
          'two_sided_full_basis_oracle.py','verify_two_sided_full_basis_oracle.py']
    result=dict(status='EXACT_SHARED_MASTER_RESIDUAL_FULL_DOMAIN_PRICING_REQUIRES_REPLAY',
                manifest=a.manifest,manifest_sha256=sha(a.manifest),preparation=a.preparation,preparation_sha256=sha(a.preparation),
                candidate_format='HIGHS_NAMED_DECIMAL_ROW_DUAL_JSON',
                numerical_candidate=a.numerical_candidate,numerical_candidate_sha256=sha(a.numerical_candidate),
                numerical_frozen=a.numerical_frozen,numerical_frozen_sha256=sha(a.numerical_frozen),
                bounds_certificate=a.bounds_certificate,bounds_certificate_sha256=sha(a.bounds_certificate),
                bounds_receipt=a.bounds_receipt,bounds_receipt_sha256=sha(a.bounds_receipt),
                feasible_law_source=d['parent_endpoint'],feasible_law_source_sha256=d['parent_endpoint_sha256'],
                feasible_law_receipt=d['parent_endpoint_receipt'],feasible_law_receipt_sha256=d['parent_endpoint_receipt_sha256'],
                point=d['point'],point_sha256=d['point_sha256'],decimal_rows=entries,parser=parser,
                raw_nonzero_dual=[[name,v] for name,v in raw.items() if v],
                clipped_positive_parent_inequality_duals=clipped,source_parent_row_weights=parent_weights,
                ignored_sm_nonneg_nonzero=[[name,v] for name,v in raw.items() if name.startswith('sm_nonneg_') and v],
                ignored_sm_nonneg_row_count=L['variable_count']-22513,
                owner_feature_coefficients=[[j,v] for j,v in sorted(G.items())],source_target_constant=gvalue,
                finite_residual_coefficients=[[j,v] for j,v in sorted(residual.items())],tau_residual=[[h,v] for h,v in sorted(high.items())],
                pattern_bound_correction=sigma,high_moment_pattern_correction=rho,pattern_costs=pattern_costs,
                pattern_records=records,negative_price_records=negative,negative_full_prices=len(negative),
                low_owner_map=fmap,low_moment_targets=q,feasible_pattern_law=law,
                constant_minorant_gap=gvalue+min(pattern_costs),saved_law_cost_gap=gvalue+sum(c*w for c,w in zip(pattern_costs,law)),
                coarse_non_tau_constant_correction=coarse,coarse_constant_minorant_gap=coarse_gap,
                parent_variable_count=22513,parent_rows_checked=98863,non_tau_bounds_covered=22508,
                nonzero_non_tau_residuals=len(residual),nonzero_tau_residuals=len(high),
                non_tau_residual_L1=sum((abs(v) for v in residual.values()),Q(0)),
                source_hashes={p:sha(p) for p in deps},zero_tau_pins=False,all32_domains_priced=True,
                phase_one_optimum_claimed=False,dual_stationarity_claimed=False,
                artificial_errors_evaluated_at_source_zero=True,raw_float_dual_is_proof=False,numerical_candidate_is_proof=False,
                source_C16_answered=False,scope='Exact rational source combination guided by named HiGHS decimal JSON; bounded finite residuals, not solver optimality.',
                elapsed_seconds=time.monotonic()-start)
    payload=(json.dumps(encode(result),separators=(',',':'))+'\n').encode()
    out.write_bytes(gzip.compress(payload,mtime=0) if out.suffix=='.gz' else payload)
    print(json.dumps(dict(status=result['status'],output=str(out),sha256=sha(out),
                          source_target_constant=str(gvalue),constant_minorant_gap=str(result['constant_minorant_gap']),
                          non_tau_residuals=len(residual),negative_prices=len(negative),elapsed_seconds=result['elapsed_seconds'])))


if __name__=='__main__':main()
