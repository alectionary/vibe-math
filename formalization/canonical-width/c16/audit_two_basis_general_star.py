#!/usr/bin/env python3
"""Independent all-row owner translation and exact dual/residual controls."""
import os
assert os.nice(0)==19, 'verified nice19 required before research imports'
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse, copy, json, time
import two_basis_joint_general_star as producer
from verify_two_basis_joint_general import ROOT, read, sha, empty, term, add, decode, literal_row, ev
from verify_two_sided_full_basis_oracle import point_owner

def independent_map(xx,zz):
    anchors=[(0,j) for j in xx]+[(1,j) for j in zz]
    ground=[(s,j) for s in [0,1] for j in range(720)]
    def pair(a,b):
        same=a[0]==b[0]
        if not same and a[0]==1:a,b=b,a
        i,j=a[1]//16,b[1]//16;h=(b[1]%16-a[1]%16)%16
        if h>8:i,j,h=j,i,16-h
        if h in [0,8] and i>j:i,j=j,i
        if same and h==0 and i==j:return i+1
        return 1+(45 if same else 18270)+2025*h+45*i+j
    return [0]+[j//16+1 for s,j in anchors]+[pair(anchors[i],anchors[j]) for i,j in combinations(range(4),2)]+[j//16+1 for s,j in ground]+[pair(a,b) for a in anchors for b in ground]
def mapped(e,mapping):
    a={}
    for j,v in e[0].items():
        k=mapping[j];a[k]=a.get(k,Q(0))+v
        if not a[k]:del a[k]
    return a,dict(e[1])
def direct_star(M,cut):
    assert type(cut['rhs'])is int and cut['rhs']==0;e=empty()
    for m,c in cut['lambda_coefficients']:
        assert type(m)is int and 0<=m<16 and type(c)is int;e=add(e,M['lambda_expressions'][m],c)
    for s in ['X','Z']:
        for m,j,c in cut[s+'_coefficients']:
            assert all(type(v)is int for v in [m,j,c]) and 0<=m<16 and 0<=j<720
            e=add(e,M['sectors'][s]['allocations'][m][j],c)
    for j,c in cut['T_coefficients']:
        assert type(j)is int and 18270<=j<36495 and type(c)is int;e=add(e,term(0,j+1,c))
    return e
def independent_combination(M,eq,ub):
    e=empty()
    for kind,weights in [('equalities',eq),('inequalities',ub)]:
        for i,w in weights:
            assert type(i)is int and 0<=i<len(M[kind]);w=Q(w)
            assert kind=='equalities' or w>=0
            d=M[kind][i]
            r=M['star_rows'][d['star_index']]['expression'] if d['kind']=='owner_star' else literal_row(M,d)
            e=add(e,r,w)
    return e
def check_combination(M,result,eq,ub):
    e=independent_combination(M,eq,ub);residual=dict(e[1]);correction=sum((min(Q(0),v) for v in residual.values()),Q(0))
    e=add(e,term(0,0,correction));e[1].clear()
    assert result['owner_target_coefficients']==[[j,str(v)] for j,v in sorted(e[0].items())]
    assert result['residual_coefficients']==[[j,str(v)] for j,v in sorted(residual.items())]
    assert Q(result['exact_residual_correction'])==correction and result['exact_cancellation']==(not residual)
    return e
def toy_model():
    lam=[term(0,0)]+[empty() for _ in range(15)]
    E=[[term(1,0)] if m==0 else [empty()] for m in range(16)]
    return dict(lambda_expressions=lam,variables=[dict(kind='allocation',side='X',mask=0,index=0)],
        sectors={'X':dict(allocations=E,local_consistency=[add(term(0,1),term(1,0),-1)])},
        equalities=[dict(kind='local_consistency',side='X',local_index=0)],
        inequalities=[dict(kind='lambda_nonnegative',mask=m) for m in range(16)]+[
            dict(kind='box',side='X',mask=0,index=0,bound='lower'),dict(kind='box',side='X',mask=0,index=0,bound='upper')])
def controls():
    M=toy_model();producer.probability_bound_guard(M);cases=[]
    for eq,ub in [([],[(16,1)]),([],[(17,1)]),([],[(16,1),(17,1)]),([(0,2)],[]),([(0,-2)],[]),([(0,1)],[(17,1)]),([],[])]:
        r=producer.exact_projected_combination(M,eq,ub,residual_correction=True)
        e=check_combination(M,r,eq,ub);integer=producer.integer_owner_row(r)
        cases.append(dict(equality_weights=eq,inequality_weights=ub,result=r,integer=integer))
        # Literal x=q in[0,1] verifies the resulting target row independently.
        assert all(ev(e,[Q(1),Q(q,5)],[Q(q,5)])<=0 for q in range(6))
    assert cases[1]['result']['exact_cancellation'] is False and cases[1]['result']['exact_residual_correction']=='0'
    rejected=[]
    bad=copy.deepcopy(M);bad['inequalities'].pop(16)
    try:producer.probability_bound_guard(bad)
    except AssertionError:rejected.append('missing-probability-box')
    else:raise AssertionError('missing box accepted')
    for label,eq,ub,correction in [('negative-inequality',[],[(16,-1)],True),('uncancelled-without-guard',[],[(17,1)],False)]:
        try:producer.exact_projected_combination(M,eq,ub,residual_correction=correction)
        except AssertionError:rejected.append(label)
        else:raise AssertionError('invalid combination accepted')
    reference=cases[0]['result']
    for label,field,value in [('wrong-correction','exact_residual_correction','1'),('lost-residual','residual_coefficients',[]),('flipped-constant','owner_target_coefficients',[[0,'1']])]:
        r=copy.deepcopy(reference);r[field]=value
        try:check_combination(M,r,[],[(16,1)])
        except AssertionError:rejected.append(label)
        else:raise AssertionError('corrupt residual certificate accepted')
    directions=[]
    ray=[0]*19;ray[0]=1;ray[-1]=1
    for orientation in [1,-1]:
        accepted,attempts=producer.ray_candidates(M,[Q(1),Q(2)],[orientation*v for v in ray],seconds=10)
        assert accepted and all(r['sign']==orientation for r in accepted)
        for r in accepted:
            e=check_combination(M,r,r['equality_multipliers'],r['inequality_multipliers'])
            assert ev(e,[Q(1),Q(2)],[Q(0)])==Q(r['exact_target_violation'])>0
            assert r['compiled_owner_coefficients']==[[0,1]] and r['compiled_owner_rhs']==1
        directions.append(dict(orientation=orientation,accepted=len(accepted),attempts=len(attempts)))
    return dict(exact_combination_cases=cases,synthetic_ray_directions=directions,corruptions_rejected=rejected,
        synthetic_targets_are_controls_only=True)

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--base-model',type=Path,required=True);ap.add_argument('--review',type=Path,required=True)
    ap.add_argument('--point',type=Path,required=True);ap.add_argument('--star-bank',type=Path,action='append',default=[])
    ap.add_argument('--star-receipt',type=Path,action='append',default=[]);ap.add_argument('--output',type=Path,required=True)
    a=ap.parse_args();assert not a.output.exists() and len(a.star_bank)==len(a.star_receipt);start=time.monotonic()
    saved=read(a.base_model);receipt=read(a.review)
    assert receipt['status']=='PASS_EXACT_GENERAL_SHARED_LAW_MODEL' and receipt['model_sha256']==sha(a.base_model)
    assert receipt['point_sha256']==sha(a.point) and receipt['consumer_sha256']==sha(ROOT/'verify_two_basis_joint_general.py')
    assert all(sha(ROOT/p)==h for p,h in saved['source_hashes'].items())
    nv=len(saved['variables']);base=producer.decode_model(saved);mapping=independent_map(saved['X_anchors'],saved['Z_anchors'])
    assert len(mapping)==7211
    lifted,features=producer.lift_model(base,a.point)
    assert mapping==lifted['source_feature_to_owner_target'] and features==[Q(1),*point_owner(a.point)]
    independent=dict(base,lambda_expressions=[],sectors={});expressions=0
    for raw,actual in zip(saved['lambda_expressions'],lifted['lambda_expressions']):
        expected=mapped(decode(raw,7211,nv),mapping);assert expected==actual;independent['lambda_expressions'].append(expected);expressions+=1
    for side,s in saved['sectors'].items():
        E=[[mapped(decode(raw,7211,nv),mapping) for raw in row] for row in s['allocations']]
        consistency=[mapped(decode(raw,7211,nv),mapping) for raw in s['local_consistency']]
        assert E==lifted['sectors'][side]['allocations'] and consistency==lifted['sectors'][side]['local_consistency']
        independent['sectors'][side]=dict(base['sectors'][side],allocations=E,local_consistency=consistency);expressions+=16*720+len(consistency)
    # Explicit duplicate feature coalescence and same-sector diagonal handling.
    assert mapping[11]==mapping[731]
    assert producer.owner_expression(({11:Q(3),731:Q(-2)},{5:Q(7)}),mapping)==({mapping[11]:Q(1)},{5:Q(7)})
    semantic_rows=0
    for kind in ['equalities','inequalities']:
        for d in base[kind]:
            old=literal_row(base,d);expected=mapped(old,mapping)
            assert producer.row_expression(lifted,d)==literal_row(independent,d)==expected;semantic_rows+=1
    producer.append_stars(lifted,zip(a.star_bank,a.star_receipt));star_count=0
    sources=dict(lifted['source_hashes'])
    for bp,rp in zip(a.star_bank,a.star_receipt):
        b,r=read(bp),read(rp);assert r['status']=='PASS_EXACT_CONDITIONAL_OWNER_STAR_CUTS' and r['bank_sha256']==sha(bp)
        assert b['source_hashes']==r['source_hashes'] and all(sha(ROOT/p)==h for p,h in r['source_hashes'].items())
        for cut in b['cuts']:
            expected=direct_star(independent,cut);assert lifted['star_rows'][star_count]['expression']==expected
            assert producer.row_expression(lifted,lifted['inequalities'][len(base['inequalities'])+star_count])==expected;star_count+=1
        sources[str(bp)]=sha(bp);sources[str(rp)]=sha(rp)
    assert star_count==len(lifted['star_rows']);producer.probability_bound_guard(lifted)
    result=controls()
    for p in [a.base_model,a.review,a.point,Path(__file__),ROOT/'two_basis_joint_general_star.py',ROOT/'verify_two_basis_joint_general.py']:
        sources[str(p)]=sha(p)
    assert all(sha(ROOT/p)==h for p,h in sources.items())
    out=dict(status='PASS_EXACT_GENERAL_STAR_MAPPING_AND_CERTIFICATE_CONTROLS',consumer_sha256=sha(__file__),
        adapter_sha256=sha(ROOT/'two_basis_joint_general_star.py'),base_model_sha256=sha(a.base_model),base_review_sha256=sha(a.review),
        point_sha256=sha(a.point),source_hashes=sources,owner_feature_map_entries=7211,exact_expressions_translated=expressions,
        original_semantic_rows_translated=semantic_rows,accepted_star_rows_translated=star_count,
        all_variables_probability_bound_guard=True,controls=result,lp_run=False,source_C16_answered=False,
        process_nice=os.nice(0),elapsed_seconds=time.monotonic()-start,
        scope='All source expressions and rows translated independently; synthetic dual/residual controls only. No actual LP solution or new source cut.')
    a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k not in ['source_hashes','controls']}),flush=True)
if __name__=='__main__':main()
