"""Produce exact all32 full-basis prices from an accepted shared-master dual.

Independent physical support and source-combination replay is performed by
verify_shared_master_projection.py. This producer never calls an LP solver.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse
import gzip
import json
import time
from verify_shared_master_common import ROOT,guard,resolve,sha,read,value,link_index
from verify_shared_master_preparation import context
from read_soplex_exact_output_v2 import read_named_rational
from shared_master_price_algebra import reconstruct,pattern_cost,LOW
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle


def json_exact(v):
    if isinstance(v,Q):return str(v)
    if isinstance(v,dict):return {str(k):json_exact(x) for k,x in v.items()}
    if isinstance(v,(list,tuple)):return [json_exact(x) for x in v]
    return v


def main():
    ap=argparse.ArgumentParser()
    for key in ('manifest','preparation','endpoint','primal','dual','output'):
        ap.add_argument('--'+key,type=Path,required=True)
    a=ap.parse_args();guard();start=time.monotonic();output=resolve(a.output)
    assert not output.exists()
    endpoint=read(a.endpoint)
    assert endpoint['status']=='PASS_EXACT_RESTRICTED_SHARED_MASTER_PHASE_ONE_OPTIMUM'
    assert endpoint['manifest_sha256']==sha(a.manifest)
    assert endpoint['preparation_receipt_sha256']==sha(a.preparation)
    assert endpoint['primal_sha256']==sha(a.primal) and endpoint['dual_sha256']==sha(a.dual)
    assert endpoint['consumer_sha256']==sha('verify_shared_master_endpoint.py')
    data,L,semantic=context(a.manifest,a.preparation,check_columns=False)
    M,f=data['M'],data['f'];N=L['variable_count']
    names=[r[0] for r in data['parent_rows']]
    names += [f'sm_mass_{s}_{m}' for m in range(16) for s in 'XZ']
    names += [f'sm_link_{s}_{m}_{j}' for m in range(16) for s in 'XZ' for j in range(720)]
    names += ['sm_nonneg_'+str(j) for j in range(22513,N)]
    raw=read_named_rational(resolve(a.dual),names,'dual')
    sign=endpoint['dual_sign'];assert sign in (-1,1)
    dual={name:sign*v for name,v in raw.items()}
    assert {name:v for name,v in dual.items() if v}=={name:Q(v) for name,v in endpoint['normalized_dual_row_weights']}
    primal_dict=read_named_rational(resolve(a.primal),['x'+str(j) for j in range(N)])
    primal=[primal_dict['x'+str(j)] for j in range(N)]
    assert primal[:22513]==list(map(Q,endpoint['full_parameters']))
    columns=[dict(c,variable_index=22513+k) for k,c in enumerate(L['columns'])]
    errors=[dict(side=s,mask=m,index=j,plus_variable=L['plus_start']+link_index(s,m,j),
                 minus_variable=L['minus_start']+link_index(s,m,j))
            for m in range(16) for s in 'XZ' for j in range(720)]
    metadata=M['variables']+[dict(kind='conditional_same_sector_pair',mask=m,side=s) for m in range(16) for s in 'XZ']
    assert len(metadata)==22513
    proof=reconstruct(((name,rel,e) for name,e,rel in data['parent_rows']),
                      M['lambda_expressions'],{s:M['sectors'][s]['allocations'] for s in 'XZ'},
                      dual,metadata,columns,errors)
    assert not proof['tau_residual']
    gvalue=sum((v*f[j] for j,v in proof['owner_coefficients'].items()),Q(0))
    assert gvalue==Q(endpoint['exact_objective'])
    assert gvalue==sum(primal[L['plus_start']:])
    blocks={(b['side'],b['mask']):b for b in proof['blocks']}
    assert set(blocks)=={(s,m) for s in 'XZ' for m in range(16)}
    oracle=TwoSidedFullBasisOracle();domains=oracle.prepare(M['X_anchors'],M['Z_anchors'])
    records=[];minima={};negative=[]
    for m in range(16):
        weights=[-c for s in 'XZ' for c in blocks[s,m]['weights']]
        support=oracle.support_pattern(domains[m],weights)
        assert support['status']=='EXACT_TWO_SIDED_PATTERN_BASIS_SUPPORT'
        record=dict(mask=m,oracle_support=support,sectors={})
        for s in 'XZ':
            b=blocks[s,m];minimum=b['constant']-Q(support[s+'_support']['value'])
            selected=support[s+'_selected']
            assert minimum==b['constant']+sum((b['weights'][j] for j in selected),Q(0))
            minima[s,m]=minimum
            record['sectors'][s]=dict(constant=b['constant'],weights=b['weights'],minimum=minimum,selected_indices=selected)
            if minimum<0:negative.append(dict(side=s,mask=m,minimum=minimum,indices=selected))
        records.append(record)
    costs,rho=pattern_cost(minima,proof['tau_residual'])
    fmap=M['source_feature_to_owner_target'][:11]
    q=[f[j] for j in fmap]
    law=[value(e,f,primal) for e in M['lambda_expressions']]
    assert law==list(map(Q,endpoint['lambda_masses'])) and min(law)>=0 and sum(law)==1
    assert all(sum(law[m] for m in range(16) if m&h==h)==q[i] for i,h in enumerate(LOW))
    dependencies=['shared_master_price_domains.py','shared_master_price_algebra.py',
                  'verify_shared_master_common.py','verify_shared_master_preparation.py','verify_shared_master_endpoint.py',
                  'read_soplex_exact_output_v2.py','two_sided_full_basis_oracle.py','verify_two_sided_full_basis_oracle.py']
    result=dict(status='EXACT_SHARED_MASTER_FULL_DOMAIN_PRICING_REQUIRES_REPLAY',
                manifest=str(a.manifest),manifest_sha256=sha(a.manifest),preparation=str(a.preparation),preparation_sha256=sha(a.preparation),
                endpoint=str(a.endpoint),endpoint_sha256=sha(a.endpoint),primal=str(a.primal),primal_sha256=sha(a.primal),
                dual=str(a.dual),dual_sha256=sha(a.dual),dual_sign=sign,
                point=data['manifest']['point'],point_sha256=data['manifest']['point_sha256'],
                parent_variable_count=22513,finite_residual_coefficients=[],tau_residual=[],
                owner_feature_coefficients=[[j,v] for j,v in sorted(proof['owner_coefficients'].items())],
                source_target_constant=gvalue,pattern_costs=costs,high_moment_pattern_correction=rho,
                low_owner_map=fmap,low_moment_targets=q,feasible_pattern_law=law,
                pattern_records=records,negative_column_prices=negative,
                parent_rows_checked=proof['parent_rows_checked'],archive_columns_checked=proof['archive_column_stationarity_checks'],
                error_stationarity_checks=proof['error_stationarity_checks'],
                constant_minorant_gap=gvalue+min(costs),saved_law_cost_gap=gvalue+sum(c*w for c,w in zip(costs,law)),
                source_hashes={p:sha(p) for p in dependencies},
                zero_tau_pins=False,all32_domains_priced=True,artificial_errors_evaluated_at_source_zero=True,
                scope='Source-valid projected ingredients awaiting independent replay; missing columns alone are inconclusive.',
                source_C16_answered=False,elapsed_seconds=time.monotonic()-start)
    output.write_text(json.dumps(json_exact(result),indent=2)+'\n')
    print(json.dumps(dict(status=result['status'],output=str(output.relative_to(ROOT)),sha256=sha(output),
                          negative_prices=len(negative),constant_minorant_gap=str(result['constant_minorant_gap']),
                          elapsed_seconds=result['elapsed_seconds'])))


if __name__=='__main__':main()
