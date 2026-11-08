#!/usr/bin/env python3
"""Independent successor proof for all selected-neighbor owner capacities."""
import os
assert os.getpriority(os.PRIO_PROCESS,0)==19
for _k in ('OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','MKL_NUM_THREADS','VECLIB_MAXIMUM_THREADS','NUMEXPR_NUM_THREADS','BLIS_NUM_THREADS'):
    assert os.environ.get(_k)=='1'
from pathlib import Path
from fractions import Fraction as Q
from itertools import combinations
import argparse,json,time
from verify_owner_star_flow_extension import ROOT,sha,read,decode_model,empty,term,add,expression as flow_expression,rank
from verify_two_sided_full_basis_oracle import physical_source,point_owner

def expression(M,d):
    if d['kind']!='owner_neighbor_capacity':return flow_expression(M,d)
    n=M['owner_flow_extension']['base_variable_count'];E=len(M['owner_flow_extension']['physical_pairs']);m=d['mask']
    out=add(empty(),M['sectors'][d['side']]['allocations'][m][d['index']],-1)
    for edge in d['edges']:out=add(out,term(1,n+m*E+edge))
    return out
def labels_and_rows(M,pinned):
    for kind,rel in [('equalities','='),('inequalities','<=')]:
        for i,d in enumerate(M[kind]):yield dict(name=kind+str(i),kind=kind,index=i),rel,expression(M,d)
    if pinned:
        for i,v in enumerate(M['variables']):
            if v['kind']=='tau':yield dict(name='zero_tau'+str(i),kind='zero_tau',index=i),'=',term(1,i)
def expected_capacities(M,X,Z):
    flow=M['owner_flow_extension'];chosen={s:sorted(t['probe'] for t in flow['stars'] if t['side']==s) for s in ('X','Z')}
    pair_ids={tuple(pair):i for i,pair in enumerate(flow['physical_pairs'])};vertices={s:[] for s in ('X','Z')};rows=[]
    start=M['owner_capacity_extension']['parent_inequality_count']
    for side in ('X','Z'):
        for i in range(720):
            if i in chosen[side]:continue
            neighbors=[j for j in chosen['Z' if side=='X' else 'X'] if ((X[i]&Z[j]) if side=='X' else (X[j]&Z[i])).bit_count()%2]
            if len(neighbors)<2:continue
            vertices[side].append(i)
            edges=sorted(pair_ids[(i,j) if side=='X' else (j,i)] for j in neighbors)
            for m in range(16):rows.append(dict(kind='owner_neighbor_capacity',side=side,index=i,mask=m,edges=edges))
    records=[dict(inequality_index=start+i,**d) for i,d in enumerate(rows)]
    expected=dict(parent_inequality_count=start,chosen_centers=chosen,common_unchosen_vertices=vertices,rows=records,all_sixteen_patterns=True,structural_zero_rows_retained=True)
    assert M['owner_capacity_extension']==expected
    assert M['inequalities'][start:]==rows
    return rows,vertices
def text_replay(path,M,saved,features):
    def tokens():
        with (ROOT/path).open() as f:
            for line in f:yield from line.split()
    it=iter(tokens());assert [next(it) for _ in range(7)]==['Minimize','obj:','+','0','x0','Subject','To'];n=len(M['variables']);count=nz=0
    for label,rel,e in labels_and_rows(M,saved['zero_tau_pins']):
        assert saved['row_labels'][count]==label and next(it)==label['name']+':'
        coeff={};tok=next(it)
        while tok in ('+','-'):
            q=Q(next(it))*(1 if tok=='+' else -1);var=next(it);assert var.startswith('x') and 0<=int(var[1:])<n
            j=int(var[1:]);coeff[j]=coeff.get(j,Q(0))+q;tok=next(it)
        assert tok==rel and Q(next(it))==-sum((q*features[j] for j,q in e[0].items()),Q(0))
        assert {j:q for j,q in coeff.items() if q}==e[1];count+=1;nz+=len(e[1])
    assert count==len(saved['row_labels']) and next(it)=='Bounds'
    for i in range(n):assert [next(it),next(it)]==['x'+str(i),'free']
    assert next(it)=='End' and next(it,None) is None
    return count,nz
def context(path,replay_lp=True):
    m=read(path);assert m['status']=='PASS_EXACT_OWNER_FLOW_CAPACITY_LP_FRACTION_TEXT_ROUNDTRIP'
    assert m['semantic_sha256']==sha(m['semantic']) and m['lp_sha256']==sha(m['lp'])
    pm,pr=read(m['parent_manifest']),read(m['parent_receipt'])
    assert m['parent_manifest_sha256']==sha(m['parent_manifest']) and m['parent_receipt_sha256']==sha(m['parent_receipt'])
    assert pm['status']=='PASS_EXACT_OWNER_FLOW_LP_FRACTION_TEXT_ROUNDTRIP'
    assert pr['status']=='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_MODEL'
    assert pr['consumer_sha256']==sha('verify_owner_star_flow_extension.py')
    assert pr['manifest_sha256']==sha(m['parent_manifest']) and pr['model_sha256']==pm['semantic_sha256']==sha(pm['semantic'])
    assert pr['lp_sha256']==pm['lp_sha256']==sha(pm['lp']) and pr['point_sha256']==pm['point_sha256']==m['point_sha256']
    for p,h in pr['source_hashes'].items():assert sha(p)==h
    parent=read(pm['semantic']);saved=read(m['semantic']);raw=saved['model'];old=parent['model']
    assert saved['status']=='EXACT_COMPLETE_OWNER_FLOW_LP_EXPORT_REQUIRE_REPLAY'
    assert saved['point']==parent['point'] and saved['feature_values']==parent['feature_values']
    assert saved['point_sha256']==m['point_sha256']==sha(saved['point'])
    assert type(saved['zero_tau_pins'])is bool and saved['zero_tau_pins']==m['zero_tau_pins']
    for k,v in old.items():
        if k not in ('status','source_hashes','inequalities'):assert raw[k]==v,(k,'parent changed')
    assert raw['status']=='PREPARED_COMPLETE_SELECTED_OWNER_FLOW_AND_CAPACITY_MODEL_NO_SOLVE'
    start=len(old['inequalities']);assert raw['owner_capacity_extension']['parent_inequality_count']==start
    assert raw['inequalities'][:start]==old['inequalities']
    for p,h in old['source_hashes'].items():assert raw['source_hashes'][p]==h
    for p,h in raw['source_hashes'].items():assert sha(p)==h
    M=decode_model(raw);X,Z,_=physical_source();rows,vertices=expected_capacities(M,X,Z)
    assert len(rows)==m['capacity_rows'] and len(M['variables'])==m['variable_count']
    assert len(M['equalities'])==m['equalities'] and len(M['inequalities'])==m['inequalities']
    features=[Q(1),*point_owner(saved['point'])];assert features==list(map(Q,saved['feature_values']))
    count,nz=text_replay(m['lp'],M,saved,features) if replay_lp else (len(saved['row_labels']),m['nonzeros'])
    assert count==m['row_count'] and nz==m['nonzeros']
    return m,saved,M,X,Z,features,rows,vertices
def controls(M,X,Z):
    frames=checks=0
    for dim in (2,3):
        U=list(range(1,1<<dim));n=len(U);bases=[b for b in combinations(range(n),dim) if rank(U[j] for j in b)==dim]
        for xb in bases:
            for zb in bases:
                if not all(sum((U[x]&U[z]).bit_count()%2 for z in zb)==1 for x in xb):continue
                if not all(sum((U[x]&U[z]).bit_count()%2 for x in xb)==1 for z in zb):continue
                frames+=1
                for selected in combinations(range(n),2):
                    for i in range(n):
                        if i in selected:continue
                        lhs=sum(int(i in xb and j in zb) for j in selected if (U[i]&U[j]).bit_count()%2)
                        assert lhs<=int(i in xb)
                        lhs=sum(int(j in xb and i in zb) for j in selected if (U[j]&U[i]).bit_count()%2)
                        assert lhs<=int(i in zb);checks+=2
    rejected=[];start=M['owner_capacity_extension']['parent_inequality_count']
    for label in ('missing-pattern-capacity','wrong-incident-edge','wrong-endpoint'):
        bad=dict(M);bad['inequalities']=list(M['inequalities'])
        if label=='missing-pattern-capacity':bad['inequalities'].pop()
        else:
            row=dict(bad['inequalities'][start])
            if label=='wrong-incident-edge':row['edges']=[-1]
            else:row['index']=-1
            bad['inequalities'][start]=row
        try:expected_capacities(bad,X,Z)
        except AssertionError:rejected.append(label)
        else:raise AssertionError(('accepted capacity mutant',label))
    return dict(actual_tiny_dual_frames=frames,literal_neighbor_capacity_checks=checks,corruptions_rejected=rejected)
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--manifest',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
    assert not a.output.exists();t=time.monotonic();m,saved,M,X,Z,features,rows,vertices=context(a.manifest)
    small=controls(M,X,Z)
    out=dict(status='PASS_EXACT_COMPLETE_SELECTED_OWNER_FLOW_CAPACITY_MODEL',manifest_sha256=sha(a.manifest),model_sha256=m['semantic_sha256'],lp_sha256=m['lp_sha256'],
             consumer_sha256=sha(Path(__file__).name),parent_receipt_sha256=m['parent_receipt_sha256'],point_sha256=m['point_sha256'],source_hashes=M['source_hashes'],
             variables=len(M['variables']),rows=m['row_count'],nonzeros=m['nonzeros'],capacity_rows=len(rows),common_unchosen_vertices=vertices,
             exact_parent_prefix_preserved=True,derived_probability_bounds_inherited=True,all_sixteen_patterns=True,zero_tau_pins=saved['zero_tau_pins'],
             finite_controls=small,solver_run=False,source_C16_answered=False,C16_strictness_proved=False,priority=19,elapsed_seconds=time.monotonic()-t,
             scope='Exact parent-preserving physical capacity and complete LP-text proof; no optimization or feasibility conclusion.')
    a.output.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='source_hashes'}),flush=True)
if __name__=='__main__':main()
