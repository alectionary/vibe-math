#!/usr/bin/env python3
"""Compact775-feature Wolfe discovery with exact native full-basis pricing.

Only positive seed vertices and one best vertex per iteration enter history.
The complete291-class support witnesses are saved only for retained cuts.
Numerical mixtures are discovery state, never an accepted membership proof.
Every exported separator still requires the unchanged independent consumer.
"""
from pathlib import Path
from fractions import Fraction
import argparse,ast,datetime,gzip,hashlib,json,time
import numpy as np
from scipy.linalg import lstsq
from full_partner_native import NativeFullPartnerBatch
from full_partner_projection import mask_universe
from full_partner_projection_features import FEATURES,column_features,moment_target,rotate
from verify_projected_profile_moment_rows import point_vector
from verify_full_partner_basis_oracle import dimension

ROOT=Path(__file__).resolve().parent
LAYOUT='1,k,C1..C8,n[45],d[45,16].ravel(C)'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 raw=Path(p).read_bytes();return json.loads(gzip.decompress(raw) if str(p).endswith('.gz') else raw)
def write(p,value):
 raw=(json.dumps(value,indent=2)+'\n').encode();Path(p).write_bytes(gzip.compress(raw,mtime=0) if str(p).endswith('.gz') else raw)
def stem(path):return path.name.removesuffix('.json.gz').removesuffix('.json')
def local_imports(path,found):
 if path in found:return
 found.add(path)
 for node in ast.walk(ast.parse(path.read_text())):
  modules=([node.module] if isinstance(node,ast.ImportFrom) else [a.name for a in node.names] if isinstance(node,ast.Import) else [])
  for module in modules:
   if module:
    p=ROOT/(module.split('.')[0]+'.py')
    if p.exists():local_imports(p,found)

def seed_columns(archive,reps,X,Z):
 saved=np.load(archive);raw=saved['master_mixture_weights'];assert raw.ndim==1 and np.all(np.isfinite(raw)) and np.min(raw)>=0
 positive=np.flatnonzero(raw>0);assert len(positive)>0;features=[];masks=[];bases=[];mass=[];lookup={};groups=[];rep_set=set(reps)
 for i in positive:
  oldmask=int(saved['masks'][i]);rotation=min(range(16),key=lambda h:rotate(oldmask,h));mask=rotate(oldmask,rotation);assert mask in rep_set
  B=[16*(int(j)//16)+(int(j)%16+rotation)%16 for j in saved['selected_Z_indices'][i]];assert len(B)==len(set(B))==128 and dimension(Z[j] for j in B)==128
  signatures=[sum(((X[512+h]&Z[j]).bit_count()%2)<<h for h in range(16) if mask>>h&1) for j in B]
  assert all(v.bit_count()<=1 for v in signatures) and all(sum(v==1<<h for v in signatures)==1 for h in range(16) if mask>>h&1)
  f=np.array(column_features(mask,B),dtype=np.int16);key=f.tobytes();index=lookup.get(key)
  if index is None:
   index=len(features);lookup[key]=index;features.append(f);masks.append(mask);bases.append(np.array(B,dtype=np.uint16));mass.append(0.);groups.append([])
  mass[index]+=float(raw[i]);groups[index].append(int(i))
 weights=np.array(mass);weights/=weights.sum();return features,masks,bases,weights,groups

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True)
 ap.add_argument('--native-replay',type=Path,default=ROOT/'coupling-results/native-full-partner-union-accepted.json');ap.add_argument('--library',type=Path,default=ROOT/'coupling-results/anchor-native-accepted.dylib')
 ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--max-rounds',type=int,default=10000);ap.add_argument('--max-cuts',type=int,default=4);ap.add_argument('--pricing-scale',type=int,default=1<<24);ap.add_argument('--output',type=Path,required=True)
 a=ap.parse_args();assert 0<a.seconds<=600 and a.max_rounds>0 and a.max_cuts>0 and 0<a.pricing_scale<=1<<40 and not a.output.exists()
 start=time.monotonic();gate=read(a.native_replay);assert gate['status']=='PASS_EXACT_UNCONDITIONED_NATIVE_UNION_GATE' and all(sha(ROOT/p)==v for p,v in gate['source_hashes'].items());assert gate['source_hashes']['coupling-results/anchor-native-accepted.dylib']==sha(a.library)
 target=moment_target(point_vector(a.point),32);b=np.array(list(map(float,target)));scale=a.pricing_scale;allowed,reps=mask_universe(32);assert len(allowed)==4597 and len(reps)==291
 X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in 'xz'];features,masks,bases,weights,groups=seed_columns(a.archive,reps,X,Z)
 active=list(range(len(features)));lookup={f.tobytes():i for i,f in enumerate(features)};batch=NativeFullPartnerBatch(reps,library=a.library)
 sources=set();local_imports(Path(__file__).resolve(),sources);sources.update(ROOT/p for p in ['full_partner_anchor_native.cpp','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz']);sources.add(a.native_replay.resolve());sources.add(a.library.resolve());hashes={str(p.relative_to(ROOT)):sha(p) for p in sorted(sources)}
 frozen={'status':'FROZEN_BEFORE_COMPACT_NATIVE_WOLFE','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_C16_answered':False,'point_sha256':sha(a.point),'seed_archive_sha256':sha(a.archive),'native_replay_sha256':sha(a.native_replay),'source_hashes':hashes,'orbit':32,'feature_layout':LAYOUT,'allowed_masks':len(allowed),'representatives':reps,'seconds':a.seconds,'max_rounds':a.max_rounds,'max_cuts':a.max_cuts,'pricing_scale':scale,'initial_columns':len(features),'seed_archive_column_groups':groups,'initial_numeric_weights':weights.tolist(),'all_seed_bases_physically_rank_and_owner_checked':True,'history_policy':'Only positive coalesced seed vertices and one best exact integer-priced vertex per iteration. All291 supports saved only for retained cuts.','metric':'raw Euclidean','scope':'Bounded discovery. Exact global support candidates require the unchanged independent775 consumer; no approximate membership claim.'}
 fp=a.output.with_name(stem(a.output)+'.frozen.json');assert not fp.exists();write(fp,frozen)
 def mix(ids,w):return w@np.asarray([features[i] for i in ids],dtype=float)
 def objective(x):return .5*float(np.dot(x-b,x-b))
 def correct(ids,w):
  ids=list(ids);w=w.copy();rank=0
  for minor in range(1000):
   if time.monotonic()-start>=a.seconds:return ids,w,minor,rank,'TIME_LIMIT_DURING_CORRECTION'
   old=objective(mix(ids,w));V=np.asarray([features[i][1:] for i in ids],dtype=float)
   if len(ids)==1:alpha=np.ones(1);rank=0
   else:
    eta,_,rank,_=lstsq((V[1:]-V[0]).T,b[1:]-V[0],cond=1e-12,lapack_driver='gelsy');alpha=np.r_[1-eta.sum(),eta]
   # Projected1512 seed vertices can be affinely dependent in775 dimensions.
   # The least-norm affine minimizer still defines a valid correction direction;
   # all accepted iterates must pass feasible mass, decrease and stationarity.
   assert np.all(np.isfinite(alpha))
   if alpha.min()>=-1e-11:
    w=np.maximum(alpha,0);w/=w.sum();keep=w>0;ids=[i for i,k in zip(ids,keep) if k];w=w[keep]
    assert objective(mix(ids,w))<=old+1e-9*max(1.,old)
    return ids,w,minor+1,int(rank),None
   bad=np.flatnonzero(alpha<0);ratios=w[bad]/(w[bad]-alpha[bad]);hit=int(bad[np.argmin(ratios)]);theta=float(min(ratios));assert -1e-12<=theta<=1+1e-12
   w=(1-theta)*w+theta*alpha;w[hit]=0;assert w.min()>=-1e-10;w=np.maximum(w,0);w/=w.sum();keep=w>0;ids=[i for i,k in zip(ids,keep) if k];w=w[keep];assert objective(mix(ids,w))<=old+1e-9*max(1.,old)
  return ids,w,1000,int(rank),'MINOR_CYCLE_LIMIT'
 rounds=[];cuts=[];seen=set();reason='ROUND_LIMIT';positive_count=0;log=a.output.with_name(stem(a.output)+'.progress.json')
 for iteration in range(a.max_rounds):
  if time.monotonic()-start>=a.seconds:reason='TIME_LIMIT';break
  t=time.monotonic();active,weights,minor,rank,failure=correct(active,weights);x=mix(active,weights);raw=b-x;raw[0]=0;norm=max(abs(raw));rec={'round':iteration,'active_columns':len(active),'history_columns':len(features),'objective':objective(x),'max_feature_residual':float(max(abs(b-x))),'correction_seconds':time.monotonic()-t,'minor_cycles':minor,'affine_rank':rank,'failure':failure};rounds.append(rec)
  if failure:reason=failure;break
  V=np.asarray([features[i] for i in active],dtype=float);stationarity=float(max(abs((V-x)@raw)));rec['stationarity_residual']=stationarity
  if stationarity>1e-7*max(1.,norm):reason='CORRAL_STATIONARITY_FAILURE';break
  if norm<=1e-10:reason='NUMERICAL_MIXTURE_REQUIRES_EXACT_RECOVERY';break
  direction=raw/norm;c=[int(np.rint(v*scale)) for v in direction];c[0]=0;t=time.monotonic();priced=batch.price(c);best=int(np.argmax(priced['full_values']));bound=int(priced['full_values'][best]);mask=reps[best];B=list(map(int,priced['bases'][best]));f=np.array(column_features(mask,B),dtype=np.int16)
  assert sum(v*int(y) for v,y in zip(c,f))==bound
  exact=sum(k*v for k,v in zip(c,target));gap=exact-bound;improvement=float(direction@(f-x));rec.update(pricing_seconds=time.monotonic()-t,backend=priced['backend'],exact_upper=bound,exact_target=str(exact),exact_gap=str(gap),scaled_gap=float(gap/scale),best_mask=mask,true_gradient_vertex_improvement=improvement,quantization_bound=32*float(sum(abs(direction-np.array(c)/scale))))
  if gap>0:
   positive_count+=1;key=tuple(c)
   if key not in seen:
    seen.add(key);cuts.append({'round':iteration,'coefficients':c,'upper_bound':bound,'exact_target_value':str(exact),'exact_violation':str(gap),'pricing_scale':scale});cuts.sort(key=lambda cut:Fraction(cut['exact_violation']),reverse=True);del cuts[a.max_cuts:]
  rec['retained_cuts']=len(cuts);print(json.dumps(rec),flush=True)
  if improvement<=1e-12:reason='NO_TRUE_GRADIENT_IMPROVEMENT_FROM_ROUNDED_PRICING';break
  key=f.tobytes();chosen=lookup.get(key)
  if chosen is None:chosen=len(features);lookup[key]=chosen;features.append(f);masks.append(mask);bases.append(np.array(B,dtype=np.uint16))
  if chosen in active:reason='PRICED_VERTEX_ALREADY_IN_CORRAL';break
  active.append(chosen);weights=np.r_[weights,0.]
  if iteration%25==0:write(log,{'status':'RUNNING','elapsed_seconds':time.monotonic()-start,'rounds':rounds,'retained_cut_count':len(cuts),'positive_proposals':positive_count})
 search_done=time.monotonic()
 for cut in cuts:
  priced=batch.price(cut['coefficients']);assert max(map(int,priced['full_values']))==cut['upper_bound'];records=[]
  for i,mask in enumerate(reps):
   B=list(map(int,priced['bases'][i]));nz=128-mask.bit_count();records.append({'mask':mask,'support_value':int(priced['values'][i]),'full_value':int(priced['full_values'][i]),'selected_Z_indices':B,'zero_basis_indices':B[:nz],'owner_indices':B[nz:]})
  cut['support_records']=records
 colpath=a.output.with_name(stem(a.output)+'.columns.npz');assert not colpath.exists();global_weights=np.zeros(len(features));global_weights[np.array(active,dtype=np.int64)]=weights;np.savez_compressed(colpath,features=np.stack(features),masks=np.array(masks,dtype=np.uint16),selected_Z_indices=np.stack(bases),master_mixture_weights=global_weights,active_column_ids=np.array(active,dtype=np.int32))
 assert all(sha(ROOT/p)==v for p,v in hashes.items());result={**frozen,'status':'EXACT_SUPPORT_CUT_CANDIDATE' if cuts else 'NO_EXACT_SEPARATOR_FOUND','frozen_sha256':sha(fp),'cuts':cuts,'rounds':rounds,'stopping_reason':reason,'search_seconds':search_done-start,'elapsed_seconds':time.monotonic()-start,'positive_proposals':positive_count,'history_columns':len(features),'columns_artifact':str(colpath),'columns_sha256':sha(colpath),'source_C16_answered':False};write(a.output,result);batch.close();print({k:result[k] for k in ['status','stopping_reason','search_seconds','elapsed_seconds','positive_proposals','history_columns']},flush=True)

if __name__=='__main__':main()
