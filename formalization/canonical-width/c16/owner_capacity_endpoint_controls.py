#!/usr/bin/env python3
"""Small exact controls for literal flow/capacity and full-row dual acceptance."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_k)=='1'
from fractions import Fraction as Q
from pathlib import Path
import copy,json,time
from verify_owner_capacity_joint_literal import combination,capacity_values
from verify_owner_star_flow_extension import flow_values,coordinate,term,add,sha

def main():
    start=time.monotonic();output=Path('two-basis-results/owner-capacity-endpoint-small-controls.json');assert not output.exists()
    # Equation1+x=0 and inequality-x<=0 make a literal algebraic contradiction.
    # The alternative proof uses the explicit x=0 pin and must retain that scope.
    toy=dict(variables=[dict(kind='tau',mask=7)],lambda_expressions=[term(0,0)],
             sectors={'X':dict(allocations=[[term(1,0)]],local_consistency=[add(term(0,0),term(1,0))])},
             equalities=[dict(kind='local_consistency',side='X',local_index=0)],
             inequalities=[dict(kind='box',side='X',mask=0,index=0,bound='lower')])
    common=dict(owner_target_coefficients=[[0,'1']],exact_gap='1',exact_cancellation=True)
    free=dict(common,row_multipliers=[[0,'1'],[1,'1']]);pinned=dict(common,row_multipliers=[[0,'1'],[2,'-1']])
    a=combination(toy,[Q(1)],False,free);b=combination(toy,[Q(1)],True,pinned)
    assert a['general_shared_law_target_excluded'] and not a['nonzero_pin_multipliers']
    assert not b['general_shared_law_target_excluded'] and b['selected_pinned_law_excluded'] and len(b['nonzero_pin_multipliers'])==1
    rejected=[]
    for label in ('negative-inequality','uncancelled-variable','wrong-gap','duplicate-weight','outside-row'):
        bad=copy.deepcopy(free)
        if label=='negative-inequality':bad['row_multipliers'][1][1]='-1'
        elif label=='uncancelled-variable':bad['row_multipliers']=bad['row_multipliers'][:1]
        elif label=='wrong-gap':bad['exact_gap']='2'
        elif label=='duplicate-weight':bad['row_multipliers'].insert(0,[0,'1'])
        else:bad['row_multipliers'].append([99,'1'])
        try:combination(toy,[Q(1)],False,bad)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted dual mutant',label))
    # Rank-one X pool and two parallel Z choices; both physical edges are shared.
    lam=[Q(0)]*16;lam[0]=Q(2,5);lam[1]=Q(3,5)
    Y={'X':[[v] for v in lam],'Z':[[v/3,2*v/3] for v in lam]}
    params=[v for row in Y['Z'] for v in row]
    meta=dict(base_variable_count=0,physical_pairs=[[0,0],[0,1]],
              cells=[[m,0,e,2*m+e] for m in range(16) for e in range(2)],
              stars=[dict(side='X',probe=0,edges=[0,1]),dict(side='Z',probe=0,edges=[0]),dict(side='Z',probe=1,edges=[1])],
              shared_edges=[dict(edge=e,physical_pair=[0,e],stars=[0,e+1]) for e in range(2)])
    model=dict(variables=[dict(kind='owner_joint') for _ in params],X_anchors=[],Z_anchors=[],owner_flow_extension=meta,
               owner_capacity_extension=dict(rows=[dict(side='X',mask=m,index=0,edges=[0,1]) for m in range(16)]))
    owner=[Q(0)]*36495;owner[coordinate(0,0)]=Q(1,3);owner[coordinate(0,1)]=Q(2,3)
    flow=flow_values(model,[1],[1,1],lam,Y,owner,params);caps=capacity_values(model,Y,params)
    for label in ('negative-shared-cell','broken-flow-column','violated-capacity'):
        bad=list(params);bad[0]=Q(-1) if label=='negative-shared-cell' else bad[0]+Q(1,1001)
        try:
            if label=='violated-capacity':capacity_values(model,Y,bad)
            else:flow_values(model,[1],[1,1],lam,Y,owner,bad)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted flow mutant',label))
    files=['owner_capacity_endpoint_controls.py','verify_owner_capacity_joint_literal.py','verify_owner_flow_joint_literal.py','verify_owner_star_flow_extension.py','verify_owner_star_capacity_extension.py']
    out=dict(status='PASS_SMALL_LITERAL_FLOW_CAPACITY_AND_FULL_DUAL_CONTROLS',source_hashes={p:sha(p) for p in files},
             exact_free_dual=a,exact_pin_dependent_dual=b,flow_checks=flow,capacity_checks=caps,
             non_dyadic_law=list(map(str,lam)),exact_shared_parameters=list(map(str,params)),
             corruptions_rejected=rejected,priority=19,elapsed_seconds=time.monotonic()-start,
             scope='Small helper controls only; no physical720 endpoint, C16 strictness, solver or source conclusion.')
    output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
