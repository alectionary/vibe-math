#!/usr/bin/env python3
"""Bounded shared-profile extension with exact physical rank-prefix rows.

This is discovery only. Numerical feasibility is not full matroid membership;
any dual direction must be repriced by the existing independent support consumer.
"""
from pathlib import Path
from fractions import Fraction
import argparse,gzip,hashlib,json,time
import numpy as np
import highspy
from scipy.sparse import coo_matrix,save_npz
from full_partner_projection import mask_universe,read
from full_partner_projection_features import column_features,candidate_weights,moment_target
from full_partner_basis_oracle import FullPartnerBasisOracle,add_vector
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--point',type=Path,required=True);ap.add_argument('--prefix',type=Path,required=True);ap.add_argument('--rank-prefixes',action='store_true');ap.add_argument('--seconds',type=float,default=120);a=ap.parse_args();start=time.monotonic();out=Path(str(a.prefix)+'.json');assert not out.exists()
 paths=['full_partner_prefix_extension.py','full_partner_projection.py','full_partner_projection_features.py','full_partner_basis_oracle.py','verify_projected_profile_moment_rows.py','projected_profile_moment_matrix.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt','algebraic-results/orbit-rank-profiles.json.gz','algebraic-results/hulls-16-rank.json.gz','moment-resumption-results/symmetry-bridge-independent.json','coupling-results/native775-witness9-gauge-rounded.json.gz','coupling-results/native775-witness9-gauge-rounded-independent.json']
 hashes={p:sha(ROOT/p) for p in paths};allowed,masks=mask_universe(32);target=moment_target(point_vector(a.point),32);source=read(ROOT/'coupling-results/native775-witness9-gauge-rounded.json.gz');directions=[source['cuts'][i]['coefficients'] for i in (0,7)] if a.rank_prefixes else []
 frozen={'status':'FROZEN_BEFORE_PREFIX_EXTENSION','source_C16_answered':False,'point_sha256':sha(a.point),'source_hashes':hashes,'orbit':32,'representatives':masks,'allowed_masks':len(allowed),'rank_cut_indices':[0,7] if directions else [],'seconds':a.seconds,'presolve':'off','scope':'Necessary shared-profile count and selected rank-prefix extension. No exact full-basis membership or source decision from numerical LP status.'};fp=Path(str(a.prefix)+'.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n')
 O=FullPartnerBasisOracle();er=[];ec=[];ed=[];ur=[];uc=[];ud=[];rhs=list(target);variables=[('lambda',m,-1) for m in masks];rmeta=[];domains=[];ni=0
 for mid,m in enumerate(masks):
  f=column_features(m,())
  for i,v in enumerate(f[:10]):
   if v:er.append(i);ec.append(mid);ed.append(v)
  d=O.prepare(32,m);assert d['status']=='FULL_PARTNER_BASIS_DOMAIN';domains.append(d);phase=[h for h in range(16) if m>>h&1];buckets=[d['zero_indices'],*d['owner_bins']];base=len(rhs);rhs.extend([Fraction(0)]*len(buckets));indices={}
  for bi,bucket in enumerate(buckets):
   er.append(base+bi);ec.append(mid);ed.append(-d['zero_basis_required'] if bi==0 else -1)
   for j in bucket:
    vi=len(variables);variables.append(('y',m,j));indices[j]=vi;jo,b=divmod(j,16);er.extend([10+jo,base+bi]);ec.extend([vi,vi]);ed.extend([1,1])
    for h in phase:er.append(55+16*jo+(b-h)%16);ec.append(vi);ed.append(1)
    if bi==0:ur.extend([ni,ni]);uc.extend([vi,mid]);ud.extend([1,-1]);ni+=1
  seen=set()
  for ci,c in enumerate(directions):
   w=candidate_weights(m,c);order=sorted(d['zero_indices'],key=lambda j:(-w[j],j));piv={};prefix=[]
   for pos,j in enumerate(order):
    prefix.append(j);add_vector(piv,O.Z[j]);rank=len(piv)
    if pos+1<len(order) and w[order[pos+1]]==w[j]:continue
    if rank==len(prefix) or rank==d['zero_basis_required']:continue
    key=tuple(sorted(prefix))
    if key in seen:continue
    seen.add(key);ur.extend([ni]*(len(key)+1));uc.extend([mid]+[indices[k] for k in key]);ud.extend([-rank]+[1]*len(key));rmeta.append({'mask':m,'direction':ci,'prefix':key,'rank':rank,'matrix_row':ni});ni+=1
 E=coo_matrix((np.array(ed,dtype=np.int16),(er,ec)),shape=(len(rhs),len(variables))).tocsr();U=coo_matrix((np.array(ud,dtype=np.int16),(ur,uc)),shape=(ni,len(variables))).tocsr();b=np.array(list(map(float,rhs)))
 print({'variables':len(variables),'equalities':E.shape[0],'inequalities':U.shape[0],'rank_prefixes':len(rmeta),'nnz':E.nnz+U.nnz,'setup_seconds':time.monotonic()-start},flush=True)
 H=highspy.Highs()
 for k,v in [('output_flag',False),('threads',1),('solver','simplex'),('presolve','off'),('time_limit',a.seconds),('primal_feasibility_tolerance',1e-9),('dual_feasibility_tolerance',1e-9)]:assert H.setOptionValue(k,v)==highspy.HighsStatus.kOk
 assert H.addVars(len(variables),np.zeros(len(variables)),np.ones(len(variables)))==highspy.HighsStatus.kOk
 assert H.addRows(E.shape[0],b,b,E.nnz,E.indptr.astype(np.int32),E.indices.astype(np.int32),E.data.astype(float))==highspy.HighsStatus.kOk
 assert H.addRows(U.shape[0],np.full(U.shape[0],-highspy.kHighsInf),np.zeros(U.shape[0]),U.nnz,U.indptr.astype(np.int32),U.indices.astype(np.int32),U.data.astype(float))==highspy.HighsStatus.kOk
 before=time.monotonic();H.run();status=H.getModelStatus();result={**frozen,'status':'NUMERICAL_EXTENSION_RESULT','solver_status':str(status),'solver_seconds':time.monotonic()-before,'variables':len(variables),'equalities':E.shape[0],'inequalities':U.shape[0],'rank_prefixes':len(rmeta),'nnz':E.nnz+U.nnz,'frozen_sha256':sha(fp)}
 if status==highspy.HighsModelStatus.kOptimal:
  x=np.array(H.getSolution().col_value);np.savez_compressed(str(a.prefix)+'.npz',x=x,rhs=np.array(list(map(str,rhs))),variables=np.array(variables,dtype=str));result.update(max_equality_residual=float(max(abs(E@x-b))),max_inequality_violation=float(max(0,max(U@x))),minimum_variable=float(min(x)),positive_variables=int(sum(x>0)))
 elif status==highspy.HighsModelStatus.kInfeasible:
  rs,exists,ray=H.getDualRay();result.update(ray_status=str(rs),ray_exists=bool(exists))
  if exists:np.savez_compressed(str(a.prefix)+'.ray.npz',ray=np.asarray(ray),rhs=np.array(list(map(str,rhs))))
 save_npz(str(a.prefix)+'.equalities.npz',E);save_npz(str(a.prefix)+'.inequalities.npz',U)
 Path(str(a.prefix)+'.rank-rows.json.gz').write_bytes(gzip.compress(json.dumps(rmeta,separators=(',',':')).encode(),mtime=0))
 assert all(sha(ROOT/p)==v for p,v in hashes.items());result['elapsed_seconds']=time.monotonic()-start;out.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k not in ['source_hashes','representatives']},flush=True)
if __name__=='__main__':main()
