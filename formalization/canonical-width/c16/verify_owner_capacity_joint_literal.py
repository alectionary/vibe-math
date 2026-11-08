#!/usr/bin/env python3
"""Full-coordinate endpoint acceptance after optional exact face reduction."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_k)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,json,time
from verify_owner_star_capacity_extension import ROOT,sha,read,context,labels_and_rows,empty,add
from verify_owner_flow_joint_literal import primal as flow_primal
from verify_joint_general_literal import rational,source_star
from verify_two_sided_full_basis_oracle import domains

def accepted_context(c):
    pr=read(c['preparation_receipt']);assert sha(c['preparation_receipt'])==c['preparation_receipt_sha256']
    assert pr['status']=='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_CAPACITY_MODEL'
    assert pr['consumer_sha256']==sha('verify_owner_star_capacity_extension.py')
    assert pr['manifest_sha256']==c['manifest_sha256']==sha(c['manifest'])
    assert pr['model_sha256']==c['semantic_sha256']==sha(c['semantic'])
    for p,h in c['source_bindings'].items():assert sha(p)==h
    if 'face_manifest' in c:assert sha(c['face_manifest'])==c['face_manifest_sha256']
    result=context(c['manifest'],replay_lp=False)
    manifest,saved,M,X,Z,features,rows,vertices=result
    assert manifest['semantic']==c['semantic'] and manifest['lp_sha256']==pr['lp_sha256']
    assert c['zero_tau_pins']==pr['zero_tau_pins']==saved['zero_tau_pins']
    assert c['point_sha256']==pr['point_sha256']==M['point_sha256']==sha(c['point']) and c['point']==saved['point']
    return result
def capacity_values(M,Y,p):
    meta=M['owner_flow_extension'];n=meta['base_variable_count'];E=len(meta['physical_pairs']);slacks=[]
    for row in M['owner_capacity_extension']['rows']:
        m=row['mask'];slack=Y[row['side']][m][row['index']]-sum(p[n+m*E+e] for e in row['edges'])
        assert slack>=0;slacks.append(slack)
    return dict(capacity_rows_checked=len(slacks),minimum_capacity_slack=str(min(slacks)))
def primal(c,M,X,Z,features):
    assert c['status']=='EXACT_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION_REQUIRES_REPLAY'
    dd=domains(X,Z,M['X_anchors'],M['Z_anchors']);data=dict(X=X,Z=Z,xa=M['X_anchors'],za=M['Z_anchors']);stars=[]
    for bi,binding in enumerate(M['star_bindings']):
        bank=read(binding['bank']);assert sha(binding['bank'])==binding['bank_sha256']
        for ci,cut in enumerate(bank['cuts']):stars.append(dict(binding=bi,cut_index=ci,coefficients=source_star(data,cut)))
    assert [(r['binding'],r['cut_index']) for r in stars]==[(r['binding'],r['cut_index']) for r in M['star_rows']]
    inherited=flow_primal(dict(c,status='EXACT_OWNER_FLOW_JOINT_ALLOCATION_REQUIRES_REPLAY'),M,X,Z,dd,features,stars)
    Y={s:[list(map(rational,row)) for row in c['exact_allocations'][s]] for s in ('X','Z')};p=list(map(rational,c['exact_parameters']))
    counts=capacity_values(M,Y,p);meta=M['owner_flow_extension'];r=M['owner_capacity_extension']['rows'][0]
    bad=list(p);bad[meta['base_variable_count']+r['mask']*len(meta['physical_pairs'])+r['edges'][0]]=Y[r['side']][r['mask']][r['index']]+1
    try:capacity_values(M,Y,bad)
    except AssertionError:rejected=['violated-neighbor-capacity']
    else:raise AssertionError('accepted capacity endpoint mutant')
    inherited.update(status='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION',capacity_checks=counts,capacity_corruptions_rejected=rejected,
                     scope='Exact feasible finite listed-rank/star allocation with complete selected shared owner flows and all supplied neighbor capacities; '+('the zero-high law is pinned.' if c['zero_tau_pins'] else 'the high moments are unrestricted.'))
    return inherited
def combination(M,features,pinned,proof):
    assert proof['row_multipliers']==sorted(proof['row_multipliers']);weights={}
    for i,s in proof['row_multipliers']:
        assert type(i)is int and i>=0 and i not in weights;w=rational(s);assert w;weights[i]=w
    out=empty();pins=[];used=ineq=0;count=0
    for i,(label,relation,e) in enumerate(labels_and_rows(M,pinned)):
        count=i+1
        if i not in weights:continue
        w=weights[i]
        if relation=='<=':assert w>=0;ineq+=1
        if label['kind']=='zero_tau':pins.append(dict(row=i,variable=label['index'],weight=str(w)))
        out=add(out,e,w);used+=1
    assert used==len(weights) and all(i<count for i in weights) and not out[1]
    wanted=[[j,str(q)] for j,q in sorted(out[0].items())]
    assert proof['owner_target_coefficients']==wanted and proof['exact_cancellation'] is True
    gap=sum((q*features[j] for j,q in out[0].items()),Q(0));assert gap>0 and rational(proof['exact_gap'])==gap
    return dict(exact_gap=str(gap),used_rows=used,used_inequality_rows=ineq,nonzero_pin_multipliers=pins,
                owner_target_coefficients=wanted,exact_full_variable_cancellation=True,
                general_shared_law_target_excluded=not pins,selected_pinned_law_excluded=bool(pins))
def farkas(c,M,features):
    assert c['status']=='EXACT_OWNER_FLOW_CAPACITY_JOINT_FARKAS_REQUIRES_REPLAY'
    result=combination(M,features,c['zero_tau_pins'],c['proof']);rejected=[]
    neq=len(M['equalities']);nineq=len(M['inequalities'])
    mutations=['wrong-gap','wrong-owner-coefficient']
    if any(neq<=i<neq+nineq for i,s in c['proof']['row_multipliers']):mutations.append('negative-inequality-weight')
    for label in mutations:
        bad=copy.deepcopy(c['proof'])
        if label=='wrong-gap':bad['exact_gap']=str(Q(bad['exact_gap'])+1)
        elif label=='wrong-owner-coefficient':bad['owner_target_coefficients'][0][1]=str(Q(bad['owner_target_coefficients'][0][1])+1)
        else:
            for row in bad['row_multipliers']:
                if neq<=row[0]<neq+nineq:row[1]=str(-Q(row[1]));break
        try:combination(M,features,c['zero_tau_pins'],bad)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted capacity Farkas mutant',label))
    return dict(status='PASS_EXACT_OWNER_FLOW_CAPACITY_FARKAS_SOURCE_ROWS',**result,corruptions_rejected=rejected,
                global_target_exclusion_proved=result['general_shared_law_target_excluded'],
                scope='Exact full source-row combination excludes '+('only the selected pinned law.' if result['nonzero_pin_multipliers'] else 'the target of the general shared-law relaxation; no law pin is used.'))
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert not a.output.exists();start=time.monotonic();c=read(a.certificate)
    manifest,saved,M,X,Z,features,rows,vertices=accepted_context(c)
    out=primal(c,M,X,Z,features) if c['status']=='EXACT_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION_REQUIRES_REPLAY' else farkas(c,M,features)
    out.update(certificate_sha256=sha(a.certificate),consumer_sha256=sha(Path(__file__).name),
               preparation_receipt_sha256=c['preparation_receipt_sha256'],manifest_sha256=c['manifest_sha256'],model_sha256=c['semantic_sha256'],
               point_sha256=c['point_sha256'],zero_tau_pins=c['zero_tau_pins'],source_hashes=M['source_hashes'],face_reduction_used='face_manifest' in c,
               reduction_internals_used_for_acceptance=False,dependencies={p:sha(p) for p in ('verify_owner_star_capacity_extension.py','verify_owner_flow_joint_literal.py','verify_joint_general_literal.py')},
               source_C16_answered=False,priority=19,elapsed_seconds=time.monotonic()-start)
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
