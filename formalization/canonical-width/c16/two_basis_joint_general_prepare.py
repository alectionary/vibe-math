"""Prepare a sparse general-law joint model and exact reference controls; no solve."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,gzip,json,time
import numpy as np
from two_basis_joint_general_model import ROOT,sha,read,prepare,row_expression,value,encode_model,decode_model,exact_combination

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--reference-X',dest='rx',type=Path,required=True);ap.add_argument('--reference-Z',dest='rz',type=Path,required=True);ap.add_argument('--output-prefix',type=Path,required=True);a=ap.parse_args();start=time.monotonic();mp=Path(str(a.output_prefix)+'.json.gz');np=Path(str(a.output_prefix)+'.npz');rp=Path(str(a.output_prefix)+'-prepared.json');assert not any(p.exists() for p in [mp,np,rp]);specs={}
 for side in 'XZ':
  g=f'two-basis-results/two-basis-small-flat-{side}-geometry';c=f'two-basis-results/two-basis-point22-{side}-closed-rank-bank';specs[side]=[(g+'.json',g+'-independent.json'),(c+'.json',c+'-independent.json')]
 model,features=prepare(a.point,specs);model['source_hashes']['two_basis_joint_general_prepare.py']=sha(__file__);ys={}
 for side,p in [('X',a.rx),('Z',a.rz)]:
  d=read(p);fp=p.with_name(p.name.removesuffix('.json.gz')+'.frozen.json');f=read(fp);receipt=p.with_name(p.name.removesuffix('.json.gz')+'-independent.json');r=read(receipt);assert r['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS' and r['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_closed_allocation.py') and r['certificate_sha256']==sha(p) and r['frozen_sha256']==d['frozen_sha256']==sha(fp);assert r['point_sha256']==sha(a.point) and f['side']==side;ys[side]=[list(map(Q,row)) for row in d['exact_allocations']]
  for q in [p,fp,receipt]:model['source_hashes'][str(q)]=sha(q)
 x=[Q(0) if z['kind']=='tau' else ys[z['side']][z['mask']][z['index']] for z in model['variables']];allocchecks=0
 for side,s in model['sectors'].items():
  for m,row in enumerate(s['allocations']):
   for j,e in enumerate(row):assert value(e,features,x)==ys[side][m][j];allocchecks+=1
 packet={};counts={};maxcoeff=Q(0)
 for kind,prefix in [('equalities','eq'),('inequalities','ub')]:
  indptr=[0];indices=[];data=[];rhs=[];zero=0;nonzero_rows=0
  for descriptor in model[kind]:
   e=row_expression(model,descriptor);constant=sum((v*features[k] for k,v in e[0].items()),Q(0));v=constant+sum((c*x[k] for k,c in e[1].items()),Q(0));assert v==0 if kind=='equalities' else v<=0
   rhs.append(float(-constant));zero+=not e[1];nonzero_rows+=bool(e[0] or e[1])
   for k,c in sorted(e[1].items()):indices.append(k);data.append(float(c));maxcoeff=max(maxcoeff,abs(c))
   indptr.append(len(indices))
  packet[prefix+'_indptr']=np_array=np_module_array(indptr,'int64');packet[prefix+'_indices']=np_module_array(indices,'int32');packet[prefix+'_data']=np_module_array(data,'float64');packet[prefix+'_rhs']=np_module_array(rhs,'float64');counts[kind]=dict(rows=len(model[kind]),nonzeros=len(indices),rows_without_variables=zero,nonzero_symbolic_rows=nonzero_rows)
 # Formal Farkas interface controls: sum both box bounds for one coordinate
 # over all patterns is -sum(lambda)=-feature0. No point values are used.
 combination=[]
 for i,d in enumerate(model['inequalities']):
  if d['kind']=='box' and d['side']=='X' and d['index']==0:combination.append((i,Q(1)))
 assert len(combination)==32 and exact_combination(model,[],combination)=={0:Q(-1)};rejected=[]
 for label,rows in [('negative_inequality_multiplier',[(combination[0][0],Q(-1))]),('uncancelled_free_variables',[(next(i for i,d in enumerate(model['inequalities']) if d['kind']=='box' and d['side']=='X' and d['mask']==3 and d['index']==0),Q(1))])]:
  try:exact_combination(model,[],rows)
  except AssertionError:rejected.append(label)
  else:raise AssertionError('invalid target-only combination accepted')
 encoded=encode_model(model);restored=decode_model(encoded);assert restored['lambda_expressions']==model['lambda_expressions'] and all(restored['sectors'][s]['allocations']==model['sectors'][s]['allocations'] for s in 'XZ');encoded['reference_assignment_sources']={'X':str(a.rx),'Z':str(a.rz)};encoded['reference_law_high_moments']=['0']*5;mp.write_bytes(gzip.compress((json.dumps(encoded,separators=(',',':'))+'\n').encode(),mtime=0));packet.update(nvars=np_module_array([len(x)],'int64'),reference_x=np_module_array([float(v) for v in x],'float64'));assert all(np_module_isfinite(v) for v in packet.values());np_module_save(np,packet)
 assert all(sha(ROOT/p)==h for p,h in model['source_hashes'].items());out=dict(status='PASS_PREPARED_GENERAL_SHARED_LAW_MODEL_WITH_EXACT_REFERENCE',producer_sha256=sha(__file__),model_module_sha256=sha(ROOT/'two_basis_joint_general_model.py'),model_path=str(mp),model_sha256=sha(mp),numeric_packet_path=str(np),numeric_packet_sha256=sha(np),point_sha256=sha(a.point),variables=len(x),local_variables={s:model['sectors'][s]['local_variable_count'] for s in 'XZ'},shared_high_variables=5,all_sixteen_patterns_retained=True,fixed_law_faces_used=False,symbolic_feature_roundtrip_checks=model['symbolic_feature_roundtrip_checks'],reference_allocation_coordinates_checked=allocchecks,rows=counts,rank_rows={s:len(model['sectors'][s]['rank_rows']) for s in 'XZ'},maximum_abs_variable_coefficient=str(maxcoeff),formal_combination_controls='32boxbounds=>-feature0<=0',invalid_combinations_rejected=rejected,encoded_expression_roundtrip=True,lp_run=False,all_subset_rank_membership_proved=False,source_C16_answered=False,elapsed_seconds=time.monotonic()-start,scope='Sparse symbolic preparation and an exact feasible reference for this finite rank-row relaxation only. All5law variables remain free in the model. No new solve, all-rank membership, target separation, or source-frame claim.');rp.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)

# Avoid naming collisions with the output path named np in main.
def np_module_array(v,dtype):return np.array(v,dtype=dtype)
def np_module_isfinite(v):return bool(np.isfinite(v).all())
def np_module_save(path,data):np.savez_compressed(path,**data)
if __name__=='__main__':main()
