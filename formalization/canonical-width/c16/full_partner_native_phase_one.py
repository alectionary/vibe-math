#!/usr/bin/env python3
"""Bounded warm active L1 master, with one exact native-priced vertex per round.

Reuses the existing primal active-column formulation. Discovery only: neither
floating feasibility nor master stationarity accepts a source claim.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json,time
import numpy as np
import highspy
from scipy.sparse import csc_matrix,coo_matrix
from full_partner_projection_native_wolfe_v2 import local_imports,write,read,LAYOUT
from full_partner_projection import mask_universe
from full_partner_projection_features import column_features,moment_target
from full_partner_native import NativeFullPartnerBatch
from verify_projected_profile_moment_rows import point_vector
from verify_full_partner_basis_oracle import dimension
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--seconds',type=float,default=180);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert 0<a.seconds<=300 and not a.output.exists();start=time.monotonic()
 X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];A=np.array([(X[512]&z).bit_count()%2 for z in Z],dtype=int)
 dropped=[54,55+int(np.flatnonzero(A==0)[0]),55+int(np.flatnonzero(A==1)[0])];coords=[i for i in range(775) if i not in dropped];assert len(coords)==772 and coords[0]==0
 target=moment_target(point_vector(a.point),32);assert sum(target[10:55])==128 and sum(target[55:])==128*target[1] and sum(v*int(z) for v,z in zip(target[55:],A))==target[1]
 allowed,reps=mask_universe(32);batch=NativeFullPartnerBatch(reps);saved=np.load(a.archive);positive=np.flatnonzero(saved['master_mixture_weights']>0)
 sources=set();local_imports(Path(__file__).resolve(),sources);sources.update(ROOT/p for p in ['physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz','full_partner_anchor_native.cpp','coupling-results/anchor-native-accepted.dylib','coupling-results/native-full-partner-union-accepted.json']);hashes={str(p.relative_to(ROOT)):sha(p) for p in sorted(sources)}
 frozen={'status':'FROZEN_WARM_NATIVE_PHASE_ONE','source_C16_answered':False,'point_sha256':sha(a.point),'seed_archive_sha256':sha(a.archive),'source_hashes':hashes,'orbit':32,'feature_layout':LAYOUT,'allowed_masks':len(allowed),'representatives':reps,'seconds':a.seconds,'per_master_seconds':25,'initial_positive_seed_columns':len(positive),'dropped_gauge_coordinates':dropped,'retained_coordinates':coords,'pricing_scale':16777216,'history_policy':'Only global best priced vertex is added; retain basic columns plus two newest vertices.','scope':'Same primal L1 formulation as earlier active master, with warm compact seed and native one-vertex pricing. Numerical outcomes are not accepted membership or source decisions.'}
 fp=a.output.with_suffix('.frozen.json');assert not fp.exists();write(fp,frozen)
 H=highspy.Highs()
 for k,v in [('output_flag',False),('threads',1),('solver','simplex'),('presolve','off'),('simplex_strategy',0),('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:assert H.setOptionValue(k,v)==highspy.HighsStatus.kOk
 n=len(coords);b=np.array([float(target[i]) for i in coords]);assert H.addRows(n,b,b,0,np.zeros(n+1,dtype=np.int32),np.array([],dtype=np.int32),np.array([],dtype=float))==highspy.HighsStatus.kOk
 errors=2*(n-1);E=coo_matrix((np.r_[np.ones(n-1),-np.ones(n-1)],(np.tile(np.arange(1,n),2),np.arange(errors))),shape=(n,errors)).tocsc();assert H.addCols(errors,np.ones(errors),np.zeros(errors),np.full(errors,highspy.kHighsInf),E.nnz,E.indptr.astype(np.int32),E.indices.astype(np.int32),E.data)==highspy.HighsStatus.kOk
 features=[];masks=[];bases=[];lookup={};active=[];recent=[]
 def add(mask,B,f):
  f=np.array(f,dtype=np.int16);assert f[0]==1 and sum(map(int,f[10:55]))==128 and sum(map(int,f[55:]))==128*int(f[1]) and int(f[55:]@A)==int(f[1]);key=f.tobytes();idx=lookup.get(key)
  if idx is None:idx=len(features);lookup[key]=idx;features.append(f);masks.append(mask);bases.append(np.array(B,dtype=np.uint16))
  if idx in active:return False,idx
  M=csc_matrix(f[coords].astype(float).reshape(-1,1));assert H.addCols(1,np.zeros(1),np.zeros(1),np.full(1,highspy.kHighsInf),M.nnz,M.indptr.astype(np.int32),M.indices.astype(np.int32),M.data)==highspy.HighsStatus.kOk;active.append(idx);return True,idx
 for i in positive:
  mask=int(saved['masks'][i]);B=list(map(int,saved['selected_Z_indices'][i]));assert mask in reps and len(B)==len(set(B))==128 and dimension(Z[j] for j in B)==128
  sig=[sum(((X[512+h]&Z[j]).bit_count()%2)<<h for h in range(16) if mask>>h&1) for j in B];assert all(v.bit_count()<=1 for v in sig) and all(sig.count(1<<h)==1 for h in range(16) if mask>>h&1)
  f=column_features(mask,B);assert list(f)==list(saved['features'][i]);add(mask,B,f)
 rounds=[];cuts=[];reason='TIME_LIMIT';scale=frozen['pricing_scale'];weights=np.zeros(len(features));last_c=None
 while time.monotonic()-start<a.seconds:
  remaining=a.seconds-(time.monotonic()-start);H.setOptionValue('time_limit',H.getRunTime()+min(25,max(.01,remaining)));t=time.monotonic();H.run();status=H.getModelStatus();sol=H.getSolution();info=H.getInfo();rec={'round':len(rounds),'active_columns':len(active),'history_columns':len(features),'status':str(status),'LP_seconds':time.monotonic()-t,'numeric_L1_objective':float(info.objective_function_value),'primal_valid':bool(sol.value_valid),'dual_valid':bool(sol.dual_valid)};rounds.append(rec)
  if sol.value_valid:
   weights=np.zeros(len(features));weights[np.array(active)]=np.array(sol.col_value[errors:]);rec['positive_columns']=int(sum(weights>0));rec['minimum_weight']=float(min(weights))
  if not sol.dual_valid:reason='NO_VALID_DUAL_SNAPSHOT';print(json.dumps(rec),flush=True);break
  c=[0]*775
  for i,value in zip(coords[1:],sol.row_dual[1:]):c[i]=int(np.rint(float(value)*scale))
  last_c=c;t=time.monotonic();priced=batch.price(c);best=int(np.argmax(priced['full_values']));upper=int(priced['full_values'][best]);value=sum(v*t for v,t in zip(c,target));gap=value-upper;rec.update(pricing_seconds=time.monotonic()-t,exact_gap=str(gap),scaled_gap=float(gap/scale),upper_bound=upper,mask=reps[best]);print(json.dumps(rec),flush=True)
  if gap>0:
   records=[]
   for i,m in enumerate(reps):
    B=list(map(int,priced['bases'][i]));nz=128-m.bit_count();records.append({'mask':m,'support_value':int(priced['values'][i]),'full_value':int(priced['full_values'][i]),'selected_Z_indices':B,'zero_basis_indices':B[:nz],'owner_indices':B[nz:]})
   cuts.append({'coefficients':c,'upper_bound':upper,'exact_target_value':str(value),'exact_violation':str(gap),'pricing_scale':scale,'support_records':records});reason='EXACT_POSITIVE_GAP_REQUIRES_INDEPENDENT_REPLAY';break
  if status!=highspy.HighsModelStatus.kOptimal:reason='MASTER_CAP_INCONCLUSIVE';break
  if info.objective_function_value<=1e-10:reason='NUMERICAL_MEMBERSHIP_REQUIRES_EXACT_RECOVERY';break
  basis=H.getBasis();protected=set(recent[-2:]);drop=[j for j,g in enumerate(active) if g not in protected and basis.col_status[errors+j]!=highspy.HighsBasisStatus.kBasic and abs(sol.col_value[errors+j])<=1e-12]
  if drop:
   assert H.deleteCols(len(drop),np.array([errors+j for j in drop],dtype=np.int32))==highspy.HighsStatus.kOk;ds=set(drop);active[:]=[g for j,g in enumerate(active) if j not in ds]
  B=list(map(int,priced['bases'][best]));added,g=add(reps[best],B,column_features(reps[best],B));recent.append(g);rec['pruned_columns']=len(drop)
  if not added:reason='EXACT_PRICED_VERTEX_ALREADY_ACTIVE';break
  write(a.output.with_suffix('.progress.json'),{'status':'RUNNING','rounds':rounds,'elapsed_seconds':time.monotonic()-start})
 cp=a.output.with_suffix('.columns.npz');assert not cp.exists();weights=np.pad(weights,(0,len(features)-len(weights)));np.savez_compressed(cp,features=np.stack(features),masks=np.array(masks,dtype=np.uint16),selected_Z_indices=np.stack(bases),master_mixture_weights=weights,active_column_ids=np.array(active,dtype=np.int32));assert all(sha(ROOT/p)==v for p,v in hashes.items());batch.close()
 out={**frozen,'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND','frozen_sha256':sha(fp),'cuts':cuts,'rounds':rounds,'stopping_reason':reason,'columns_artifact':str(cp),'columns_sha256':sha(cp),'last_coefficients':last_c,'elapsed_seconds':time.monotonic()-start};write(a.output,out);print(json.dumps({k:out[k] for k in ['status','stopping_reason','elapsed_seconds']}),flush=True)
if __name__=='__main__':main()
