"""Exact feasible phase-I point by rescaling physical archived pattern laws."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json,math,time
import numpy as np
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_two_sided_anchor_count import columns,feature
from verify_projected_profile_moment_rows import point_vector
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--seed',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();started=time.monotonic();seed=json.loads(a.seed.read_text());assert seed['point_sha256']==sha(a.point) and seed['archive_sha256']==sha(a.archive);lam=list(map(Q,seed['lambda_masses']));assert min(lam)>=0 and sum(lam)==1;xx,zz=seed['X_anchors'],seed['Z_anchors'];saved=np.load(a.archive);raw=[Q(float(w)) for w in saved['master_mixture_weights']];assert min(raw)>=0;D=math.lcm(*(q.denominator for q in raw));nums=[int(q*D) for q in raw];totals=[sum(n for n,m in zip(nums,saved['masks']) if int(m)==k) for k in range(16)];X,Z,_=physical();counts=[[0]*1440 for _ in range(16)];records=[]
 for i,n in enumerate(nums):
  m=int(saved['masks'][i])
  if not n or not lam[m]:continue
  bx=list(map(int,saved['selected_X_indices'][i]));bz=list(map(int,saved['selected_Z_indices'][i]));assert len(bx)==len(set(bx))==len(bz)==len(set(bz))==128 and dimension(X[j] for j in bx)==dimension(Z[j] for j in bz)==128
  assert all((j in bx)==bool(m>>k&1) for k,j in enumerate(xx)) and all((j in bz)==bool(m>>(k+2)&1) for k,j in enumerate(zz))
  for k,j in enumerate(xx):
   if m>>k&1:assert sum((X[j]&Z[v]).bit_count()%2 for v in bz)==1
  for k,j in enumerate(zz):
   if m>>(k+2)&1:assert sum((Z[j]&X[v]).bit_count()%2 for v in bx)==1
  chosen=bx+[720+j for j in bz];assert feature(m,chosen)==list(saved['features'][i])
  for j in chosen:counts[m][j]+=n
  records.append({'archive_column':i,'mask':m,'weight':str(lam[m]*n/totals[m])})
 assert all(not lam[m] or totals[m]>0 for m in range(16));marginals=[[lam[m]*n/totals[m] if lam[m] else Q(0) for n in counts[m]] for m in range(16)];assert all(sum(Q(r['weight']) for r in records if r['mask']==m)==lam[m] for m in range(16))
 owner=point_vector(a.point);target=[Q(1) if j is None else owner[j] for j in columns(xx,zz)];actual=[sum(lam[m]*feature(m,[])[i] for m in range(16)) for i in range(11)]+[sum(marginals[m][j] for m in range(16)) for j in range(1440)]+[sum(marginals[m][j] for m in range(16) if m>>k&1) for k in range(4) for j in range(1440)];assert actual[:11]==target[:11];bounds=[]
 for side in range(2):
  ids=[11+720*side+j for j in range(720)]+[1451+1440*k+720*side+j for k in range(4) for j in range(720)];residual=[target[i]-actual[i] for i in ids];bound=sum(map(abs,residual));bounds.append({'side':'X' if side==0 else 'Z','exact_L1_objective_upper_bound':str(bound),'approximate_L1_objective_upper_bound':float(bound),'maximum_absolute_feature_error':str(max(map(abs,residual))),'positive_error_variables':sum(v>0 for v in residual),'negative_error_variables':sum(v<0 for v in residual),'exact_error_residuals':list(map(str,residual))})
 out={'status':'EXACT_PHYSICAL_FEASIBLE_PHASE_ONE_POINT','source_C16_answered':False,'seed_sha256':sha(a.seed),'archive_sha256':sha(a.archive),'point_sha256':sha(a.point),'consumer_sha256':sha(Path(__file__)),'X_anchors':xx,'Z_anchors':zz,'lambda_masses':list(map(str,lam)),'rescaled_mixture':records,'physical_basis_pairs_checked':len(records),'sectors':bounds,'scope':'Exact physical mixture has prescribedpattern masses; addingexplicit signederrors givesa feasible restrictedphase-Ipoint. This isnotnecessarilyanLPbasis, andpositiveerrors are not targetmembership. No new optimization or pricing.','elapsed_seconds':time.monotonic()-started};a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['rescaled_mixture','sectors']});print([{k:v for k,v in r.items() if k!='exact_error_residuals'} for r in bounds])
if __name__=='__main__':main()
