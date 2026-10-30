#!/usr/bin/env python3
"""Literal old-capacity handoff plus complete shared eight-event law or exact ray."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):assert os.environ.get(k)=='1'
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,json,time
from verify_owner_k22_capacity_extension import ROOT,sha,read,context,replay_wrapper,atom_values,EVENTS,features
from verify_owner_star_flow_extension import empty,term,add
from verify_owner_star_capacity_extension import labels_and_rows

def value(e,f,p):return sum((v*f[j] for j,v in e[0].items()),Q(0))+sum((v*p[j] for j,v in e[1].items()),Q(0))
def bound_context(c):
    assert c['manifest_sha256']==sha(c['manifest']) and c['semantic_sha256']==sha(c['semantic'])
    data=context(c['manifest']);d,w,face,mapping,saved,M,f,q,allowed=data
    assert c['semantic']==d['semantic'] and c['semantic_sha256']==d['semantic_sha256']
    assert c['point']==w['point'] and c['point_sha256']==w['point_sha256'] and c['zero_tau_pins'] is True
    assert c['source_C16_answered'] is False
    for p,h in c['source_bindings'].items():assert sha(p)==h
    prep=read(c['preparation_receipt']);assert sha(c['preparation_receipt'])==c['preparation_receipt_sha256']
    assert prep['status']=='PASS_EXACT_OWNER_K22_CAPACITY_MODEL' and prep['manifest_sha256']==sha(c['manifest'])
    assert prep['model_sha256']==d['semantic_sha256'] and prep['consumer_sha256']==sha('verify_owner_k22_capacity_extension.py')
    for p,h in prep['source_hashes'].items():assert sha(p)==h
    solver=read(c['solver_frozen']);assert sha(c['solver_frozen'])==c['solver_frozen_sha256']
    assert solver['status']=='FROZEN_SINGLE_EXACT_OWNER_K22_CAPACITY_SOPLEX_TRIAL'
    assert solver['input_manifest_sha256']==sha(c['manifest']) and solver['input_lp_sha256']==d['lp_sha256'] and solver['semantic_sha256']==d['semantic_sha256']
    assert solver['preparation_receipt_sha256']==c['preparation_receipt_sha256'] and solver['zero_tau_pins'] is True
    rows,_=replay_wrapper(w,data)
    return data,solver,rows
def projection_context(c,receipt,data,solver):
    d,w,face,mapping,saved,M,f,q,allowed=data
    p=read(c['parent_projection']);r=read(receipt)
    assert sha(c['parent_projection'])==c['parent_projection_sha256']==r['certificate_sha256']
    assert r['status']=='PASS_EXACT_LITERAL_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION'
    assert r['consumer_sha256']==sha('verify_owner_capacity_joint_literal.py')
    assert p['status']=='EXACT_OWNER_FLOW_CAPACITY_JOINT_ALLOCATION_REQUIRES_REPLAY'
    assert p['manifest']==w['parent_full_manifest'] and p['manifest_sha256']==w['parent_full_manifest_sha256']==r['manifest_sha256']
    assert p['semantic']==w['parent_semantic'] and p['semantic_sha256']==w['parent_semantic_sha256']==r['model_sha256']
    assert p['point_sha256']==r['point_sha256']==c['point_sha256']
    assert p['zero_tau_pins'] is True and p['original_parent_solver_not_rerun'] is True
    assert p['derived_from_extended_manifest']==c['manifest']
    raw=p['derived_from_extended_primal'];assert '-X='+str((ROOT/raw).resolve()) in solver['command']
    assert p['source_bindings'][raw]==c['source_bindings'][raw]==sha(raw)
    for table in (p['source_bindings'],r['source_hashes'],r['dependencies']):
        for file,h in table.items():assert sha(file)==h
    assert p['exact_parameters']==c['exact_parameters'][:22481]
    assert p['lambda_masses']==c['lambda_masses'] and p['exact_allocations']==c['exact_allocations']
    return p,r
def literal_law(c,data,newrows):
    d,w,face,mapping,saved,M,f,q,allowed=data
    assert c['status']=='EXACT_OWNER_K22_CAPACITY_ALLOCATION_REQUIRES_REPLAY'
    params=list(map(Q,c['exact_parameters']));assert len(params)==22513
    assert c['exact_parameters']==list(map(str,params))
    lam=list(map(Q,c['lambda_masses']));assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
    Y=c['exact_allocations'];assert all(len(Y[s])==16 and all(len(row)==720 for row in Y[s]) for s in 'XZ')
    assert len(c['center_atoms'])==16 and all(len(row)==16 for row in c['center_atoms'])
    pairs={tuple(p):i for i,p in enumerate(M['owner_flow_extension']['physical_pairs'])};weights={m:Q(0) for m in allowed}
    local_checks=0;forbidden=0;minimum=None;pair_masses={'X':[],'Z':[]}
    for m in range(16):
        y=[Q(Y['X'][m][j]) for j in (614,281)]+[Q(Y['Z'][m][j]) for j in (51,83)]
        t={(i,j+2):params[13393+568*m+pairs[x,z]] for i,x in enumerate((614,281)) for j,z in enumerate((51,83))}
        sx,sz=params[22481+2*m:22483+2*m];pair_masses['X'].append(sx);pair_masses['Z'].append(sz)
        A=atom_values(lam[m],y,t,sx,sz)
        assert len(A)==11 and min(A.values())>=0 and sum(A.values())==lam[m]
        assert c['center_atoms'][m]==[str(A.get(b,Q(0))) for b in range(16)]
        minimum=min(A.values()) if minimum is None else min(minimum,min(A.values()))
        for b,v in A.items():
            full=m|(b<<4)
            if full not in weights:assert v==0;forbidden+=1
            else:weights[full]+=v
        local=[sum(A.values())]+[sum(v for b,v in A.items() if b>>i&1) for i in range(4)]
        local+=[sum(v for b,v in A.items() if b>>i&1 and b>>j&1) for i,j in ((0,1),(0,2),(0,3),(1,2),(1,3),(2,3))]
        assert local==[lam[m],*y,sx,t[0,2],t[0,3],t[1,2],t[1,3],sz];local_checks+=len(local)
    assert forbidden==24 and sum(weights.values())==1
    assert c['same_sector_pair_masses']=={s:list(map(str,v)) for s,v in pair_masses.items()}
    assert sum(pair_masses['X'])==f[7848] and sum(pair_masses['Z'])==f[186]
    actual=[Q(0)]*37
    for m,v in weights.items():
        for j,b in enumerate(features(m)):actual[j]+=v*b
    assert actual==q
    slacks=[]
    for row in newrows:
        result=value(row['expression'],f,params)
        assert result==0 if row['relation']=='=' else result<=0
        if row['relation']=='<=':slacks.append(-result)
    return dict(conditional_atom_slots_checked=176,forbidden_atoms_zero=forbidden,conditional_local_moment_equalities=local_checks,
        global_eight_features_checked=37,global_same_sector_totals_checked=2,new_rows_checked=len(newrows),
        positive_global_atoms=sum(v>0 for v in weights.values()),global_eight_atoms=[dict(mask=m,weight=str(v)) for m,v in weights.items() if v],
        minimum_conditional_atom=str(minimum),minimum_new_inequality_slack=str(min(slacks)),
        exact_complete_shared_eight_event_law=True)
def combine_proof(proof,byname,f):
    rows=proof['row_multipliers'];assert len(rows)==len({name for name,_ in rows})
    total=empty();pins=[]
    for name,text in rows:
        assert name in byname and type(text)is str;weight=Q(text);assert weight and str(weight)==text
        relation,e=byname[name];assert relation=='=' or weight>=0
        total=add(total,e,weight)
        if name.startswith('zero_tau'):pins.append(name)
    assert not total[1] and proof['exact_cancellation'] is True
    assert proof['owner_target_coefficients']==[[j,str(v)] for j,v in sorted(total[0].items())]
    gap=sum((v*f[j] for j,v in total[0].items()),Q(0));assert gap==Q(proof['exact_gap'])>0
    assert sorted(proof['pin_rows_used'])==sorted(pins)
    return gap,pins
def tiny_controls():
    # x<=0 and x>=1 give an exact contradiction with nonnegative multipliers.
    byname={'upper':('<=',term(1,0)), 'lower':('<=',add(term(0,0),term(1,0),-1))}
    proof=dict(row_multipliers=[['upper','1'],['lower','1']],owner_target_coefficients=[[0,'1']],exact_gap='1',exact_cancellation=True,pin_rows_used=[])
    assert combine_proof(proof,byname,[Q(1)])[0]==1
    bad=[]
    p=copy.deepcopy(proof);p['row_multipliers'][0][1]='-1';bad.append(('negative_inequality_multiplier',p))
    p=copy.deepcopy(proof);p['row_multipliers'].pop();bad.append(('uncancelled_variable',p))
    p=copy.deepcopy(proof);p['exact_gap']='2';bad.append(('wrong_exact_gap',p))
    p=copy.deepcopy(proof);p['pin_rows_used']=['zero_tau0'];bad.append(('invented_pin_scope',p))
    rejected=[]
    for name,p in bad:
        try:combine_proof(p,byname,[Q(1)])
        except AssertionError:rejected.append(name)
        else:raise AssertionError(('accepted corruption',name))
    # Pin-use is exposed even when all remaining coefficients cancel exactly.
    pinrows={'lower':('<=',add(term(0,0),term(1,0),-1)),'zero_tau0':('=',term(1,0))}
    p=copy.deepcopy(proof);p['row_multipliers']=[['lower','1'],['zero_tau0','1']];p['pin_rows_used']=['zero_tau0']
    assert combine_proof(p,pinrows,[Q(1)])[1]==['zero_tau0']
    return dict(exact_ray_controls=2,corruptions_rejected=rejected)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--certificate');ap.add_argument('--parent-receipt');ap.add_argument('--controls-only',action='store_true');ap.add_argument('--output',required=True);a=ap.parse_args();start=time.monotonic()
    controls=tiny_controls()
    if a.controls_only:
        assert not a.certificate and not a.parent_receipt
        out=dict(status='PASS_OWNER_K22_ENDPOINT_EXACT_RAY_CONTROLS',controls=controls)
    else:
        assert a.certificate;c=read(a.certificate);data,solver,newrows=bound_context(c);d,w,face,mapping,saved,M,f,q,allowed=data
        if c['status']=='EXACT_OWNER_K22_CAPACITY_ALLOCATION_REQUIRES_REPLAY':
            assert a.parent_receipt;p,r=projection_context(c,a.parent_receipt,data,solver);out=literal_law(c,data,newrows);rejected=[]
            for label in ('changed_same_sector_parameter','changed_atom','changed_cross_cell'):
                bad=copy.deepcopy(c)
                if label=='changed_same_sector_parameter':bad['exact_parameters'][22481]=str(Q(bad['exact_parameters'][22481])+1)
                elif label=='changed_atom':bad['center_atoms'][0][0]=str(Q(bad['center_atoms'][0][0])+1)
                else:
                    pairs=M['owner_flow_extension']['physical_pairs'];j=13393+pairs.index([614,51]);bad['exact_parameters'][j]=str(Q(bad['exact_parameters'][j])+1)
                try:literal_law(bad,data,newrows)
                except (AssertionError,ValueError):rejected.append(label)
                else:raise AssertionError(('accepted corruption',label))
            out.update(status='PASS_EXACT_LITERAL_OWNER_K22_CAPACITY_ALLOCATION',parent_projection_sha256=sha(c['parent_projection']),parent_receipt_sha256=sha(a.parent_receipt),
                parent_capacity_consumer_sha256=sha('verify_owner_capacity_joint_literal.py'),parent_full_rows_retained=98730,parent_full_parameters_replayed=22481,corruptions_rejected=rejected)
        else:
            assert c['status']=='EXACT_OWNER_K22_CAPACITY_FARKAS_REQUIRES_REPLAY' and not a.parent_receipt
            byname={label['name']:(rel,e) for label,rel,e in labels_and_rows(M,True)};assert len(byname)==98730
            for row in newrows:assert row['name'] not in byname;byname[row['name']]=(row['relation'],row['expression'])
            assert len(byname)==98868
            gap,pins=combine_proof(c['proof'],byname,f)
            out=dict(status='PASS_EXACT_PINNED_OWNER_K22_CAPACITY_FARKAS',exact_gap=str(gap),all_full_variables_cancelled=True,full_variables=22513,
                pin_rows_used=pins,pin_free_certificate=not pins,scope='Exact contradiction of this pinned-law extension only; no unreviewed global projection.')
        out.update(certificate_sha256=sha(a.certificate),manifest_sha256=c['manifest_sha256'],model_sha256=c['semantic_sha256'],point_sha256=c['point_sha256'],
            preparation_receipt_sha256=c['preparation_receipt_sha256'],zero_tau_pins=True,global_target_exclusion_proved=False,all_subset_rank_membership_proved=False,
            source_hashes={**w['source_hashes'],**c['source_bindings']},controls=controls)
    out.update(consumer_sha256=sha(Path(__file__).name),dependencies={p:sha(p) for p in ['verify_owner_k22_capacity_extension.py','verify_owner_star_capacity_extension.py','verify_owner_star_flow_extension.py','verify_global_eight_probe_law.py']},
        source_C16_answered=False,priority=19,elapsed_seconds=time.monotonic()-start)
    path=ROOT/a.output;assert not path.exists();path.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ('source_hashes','global_eight_atoms')}))
if __name__=='__main__':main()
