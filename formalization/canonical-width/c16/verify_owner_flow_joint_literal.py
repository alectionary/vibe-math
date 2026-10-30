#!/usr/bin/env python3
"""Literal exact primal or source-row Farkas acceptance for shared owner flows."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_k)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,json,time
from verify_owner_star_flow_extension import ROOT,sha,read,context,flow_values,labels_and_rows,empty,add,coordinate
from verify_joint_general_literal import check_primal,rational
from verify_two_sided_full_basis_oracle import target

def accepted_context(c):
    prep=read(c['preparation_receipt'])
    assert sha(c['preparation_receipt'])==c['preparation_receipt_sha256']
    assert prep['status']=='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_MODEL'
    assert prep['consumer_sha256']==sha('verify_owner_star_flow_extension.py')
    assert prep['manifest_sha256']==c['manifest_sha256']==sha(c['manifest'])
    assert prep['model_sha256']==c['semantic_sha256']==sha(c['semantic'])
    for p,h in c['source_bindings'].items():assert sha(p)==h
    result=context(c['manifest'],Path('two-basis-results/two-basis-joint-general-point22.json.gz'),Path('two-basis-results/two-basis-joint-general-point22-independent.json'),replay_lp=False)
    manifest,saved,M,X,Z,dd,features,stars,checks=result
    assert manifest['semantic']==c['semantic'] and manifest['lp_sha256']==prep['lp_sha256']
    assert c['zero_tau_pins']==prep['zero_tau_pins']==saved['zero_tau_pins']
    assert c['point_sha256']==prep['point_sha256']==M['point_sha256']==sha(c['point'])
    assert c['point']==saved['point']
    return result

def primal(c,M,X,Z,dd,features,stars):
    assert c['status']=='EXACT_OWNER_FLOW_JOINT_ALLOCATION_REQUIRES_REPLAY'
    n=M['owner_flow_extension']['base_variable_count'];base=dict(M,variables=M['variables'][:n])
    cp=dict(c,exact_parameters=c['exact_parameters'][:n])
    full=target(c['point'],M['X_anchors'],M['Z_anchors'])
    inherited=check_primal(cp,base,dd,full,features[1:],stars)
    lam=list(map(rational,c['lambda_masses']));Y={s:[list(map(rational,row)) for row in c['exact_allocations'][s]] for s in ('X','Z')}
    parameters=list(map(rational,c['exact_parameters']))
    flow=flow_values(M,X,Z,lam,Y,features[1:],parameters)
    rejected=[]
    for label in ('negative-flow','changed-shared-flow','wrong-edge-marginal'):
        p=list(parameters);owner=list(features[1:]);meta=M['owner_flow_extension']
        if label=='negative-flow':p[n]=Q(-1)
        elif label=='changed-shared-flow':p[n+meta['shared_edges'][0]['edge']]+=1
        else:
            x,z=meta['physical_pairs'][0];owner[coordinate(x,z)]+=1
        try:flow_values(M,X,Z,lam,Y,owner,p)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted flow primal mutant',label))
    return dict(status='PASS_EXACT_LITERAL_OWNER_FLOW_JOINT_ALLOCATION',base_checks=inherited,flow_checks=flow,
                exact_parameters_checked=len(parameters),flow_corruptions_rejected=rejected,
                complete_selected_owner_flows_proved=True,all_subset_rank_membership_proved=False,
                all_owner_stars_satisfied=False,global_target_exclusion_proved=False,
                scope='Exact feasible finite listed-rank/star allocation with complete shared flows for the chosen centers; '+('the zero-high law is pinned.' if c['zero_tau_pins'] else 'the five higher moments are unrestricted.'))

def combination(M,features,pinned,proof):
    terms=proof['row_multipliers'];assert terms==sorted(terms)
    weights={}
    for i,s in terms:
        assert type(i)is int and i>=0 and i not in weights;w=rational(s);assert w;weights[i]=w
    out=empty();pins=[];used=0;inequalities=0;count=0
    for i,(label,relation,e) in enumerate(labels_and_rows(M,pinned)):
        count=i+1
        if i not in weights:continue
        w=weights[i]
        if relation=='<=':assert w>=0;inequalities+=1
        if label['kind']=='zero_tau':pins.append(dict(row=i,variable=label['index'],weight=str(w)))
        out=add(out,e,w);used+=1
    assert used==len(weights) and all(i<count for i in weights)
    assert not out[1], ('uncancelled variables',len(out[1]))
    wanted=[[j,str(q)] for j,q in sorted(out[0].items())]
    assert proof['owner_target_coefficients']==wanted and proof['exact_cancellation'] is True
    gap=sum((q*features[j] for j,q in out[0].items()),Q(0));assert gap>0 and rational(proof['exact_gap'])==gap
    return dict(exact_gap=str(gap),used_rows=used,used_inequality_rows=inequalities,
                nonzero_pin_multipliers=pins,owner_target_coefficients=wanted,
                exact_variable_cancellation=True,general_shared_law_target_excluded=not pins,
                selected_pinned_law_excluded=bool(pins))

def farkas(c,M,features):
    assert c['status']=='EXACT_OWNER_FLOW_JOINT_FARKAS_REQUIRES_REPLAY'
    check=combination(M,features,c['zero_tau_pins'],c['proof']);rejected=[]
    for label in ('wrong-gap','wrong-owner-coefficient'):
        bad=copy.deepcopy(c['proof'])
        if label=='wrong-gap':bad['exact_gap']=str(Q(bad['exact_gap'])+1)
        else:bad['owner_target_coefficients'][0][1]=str(Q(bad['owner_target_coefficients'][0][1])+1)
        try:combination(M,features,c['zero_tau_pins'],bad)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted Farkas mutant',label))
    return dict(status='PASS_EXACT_OWNER_FLOW_FARKAS_SOURCE_ROWS',**check,
                corruptions_rejected=rejected,global_target_exclusion_proved=check['general_shared_law_target_excluded'],
                scope='Exact source-row combination excludes '+('only the selected pinned law.' if check['nonzero_pin_multipliers'] else 'the target of the general shared-law necessary relaxation; no pin equation is used.'))

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert not a.output.exists();start=time.monotonic();c=read(a.certificate)
    manifest,saved,M,X,Z,dd,features,stars,checks=accepted_context(c)
    if c['status']=='EXACT_OWNER_FLOW_JOINT_ALLOCATION_REQUIRES_REPLAY':out=primal(c,M,X,Z,dd,features,stars)
    else:out=farkas(c,M,features)
    out.update(certificate_sha256=sha(a.certificate),consumer_sha256=sha(Path(__file__).name),
               preparation_receipt_sha256=c['preparation_receipt_sha256'],manifest_sha256=c['manifest_sha256'],model_sha256=c['semantic_sha256'],
               point_sha256=c['point_sha256'],zero_tau_pins=c['zero_tau_pins'],source_hashes=M['source_hashes'],
               dependencies={p:sha(p) for p in ('verify_owner_star_flow_extension.py','verify_joint_general_literal.py','verify_two_sided_full_basis_oracle.py')},
               source_C16_answered=False,priority=19,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)

if __name__=='__main__':main()
