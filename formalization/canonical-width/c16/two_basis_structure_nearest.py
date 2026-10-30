"""Exact L1-nearest local-box pattern law to a saved physical mixture's masses."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,hashlib,json,time
import numpy as np
from scipy.optimize import linprog
from flint import fmpz_mat
from two_basis_structure import lambda_affine,lambda_values,anchor_feature,solve_unique
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--localbox',type=Path,required=True);ap.add_argument('--localbox-replay',type=Path,required=True);ap.add_argument('--archive',type=Path,required=True);ap.add_argument('--archive-report',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();local=json.loads(a.localbox.read_text());gate=json.loads(a.localbox_replay.read_text());report=json.loads(a.archive_report.read_text());assert local['status']=='EXACT_OUTER_FEASIBLE' and report['point_sha256']==local['point_sha256'];assert report['columns_sha256']==sha(a.archive)
 # The receipt is a frozen independent row/point audit. Bind it verbatim;
 # exact inequalities are checked again below independent of solver status.
 assert sha(a.localbox) in json.dumps(gate)
 saved=np.load(a.archive);raw=list(map(lambda v:Q(float(v)),saved['master_mixture_weights']));assert min(raw)>=0;mass=sum(raw);assert mass>0;old=[sum(w for w,m in zip(raw,saved['masks']) if int(m)==k)/mass for k in range(16)];assert sum(old)==1
 low=list(map(Q,local['exact_target'][:11]));base,C=lambda_affine(low);A=[];b=[];labels=[]
 for i,r in enumerate(local['rows']):A.append(r['a']+[0]*16);b.append(Q(r['b']));labels.append(['localbox',i])
 for m in range(16):
  for sign in (1,-1):
   row=[sign*v for v in C[m]]+[0]*16;row[5+m]=-1;A.append(row);b.append(sign*(old[m]-base[m]));labels.append(['distance',m,sign])
 objective=[0]*5+[1]*16;fp=a.output.with_suffix('.frozen.json');assert not fp.exists();frozen={'status':'FROZEN_NEAREST_LOCALBOX_PATTERN_LAW','source_C16_answered':False,'point_sha256':local['point_sha256'],'X_anchors':local['X_anchors'],'Z_anchors':local['Z_anchors'],'source_hashes':{p:sha(ROOT/p) for p in ['two_basis_structure.py','two_basis_structure_nearest.py']},'localbox_sha256':sha(a.localbox),'localbox_replay_sha256':sha(a.localbox_replay),'archive_sha256':sha(a.archive),'archive_report_sha256':sha(a.archive_report),'old_binary_weight_sum_before_normalization':str(mass),'old_lambda_masses':list(map(str,old)),'scope':'Nearest law within accepted per-vector localbox projection only. No bucket, rank or full two-basis membership is asserted.'};fp.write_text(json.dumps(frozen,indent=2)+'\n')
 Af=np.array(A,dtype=float);bf=np.array(list(map(float,b)));lp=linprog(objective,A_ub=Af,b_ub=bf,bounds=[(None,None)]*21,method='highs',options={'presolve':False,'time_limit':30,'primal_feasibility_tolerance':1e-9,'dual_feasibility_tolerance':1e-9});out={**frozen,'frozen_sha256':sha(fp),'numeric_status':int(lp.status),'numeric_message':lp.message,'status':'NUMERICAL_NEAREST_LAW_INCONCLUSIVE'}
 if lp.status==0 and lp.x is not None:
  out['numerical_L1_distance']=float(lp.fun);order=sorted(range(len(A)),key=lambda i:abs(float(Af[i]@lp.x-bf[i])));active=[]
  for i in order:
   if fmpz_mat([A[j] for j in active+[i]]).rank()>len(active):active.append(i)
   if len(active)==21:break
  try:
   x=solve_unique([A[i] for i in active],[b[i] for i in active]);assert all(sum(Q(v)*z for v,z in zip(row,x))<=rhs for row,rhs in zip(A,b));ids=[i for i,z in enumerate(lp.ineqlin.marginals) if z < -1e-10];z=solve_unique([[A[i][j] for i in ids] for j in range(21)],[-v for v in objective]);assert all(v>=0 for v in z);primal=sum(x[5:]);dual=-sum(w*b[i] for i,w in zip(ids,z));assert primal==dual;lam=lambda_values(low,x[:5]);assert min(lam)>=0 and sum(lam)==1 and sum(abs(v-w) for v,w in zip(lam,old))==primal;assert all(sum(lam[m]*anchor_feature(m)[j] for m in range(16))==low[j] for j in range(11))
   out.update(status='EXACT_NEAREST_LOCALBOX_PATTERN_LAW_CANDIDATE',lambda_masses=list(map(str,lam)),high_moments=list(map(str,x[:5])),absolute_deviations=list(map(str,x[5:])),exact_L1_distance=str(primal),primal_active_rows=active,dual_indices=ids,dual_weights=list(map(str,z)),row_labels=labels,rows_checked=len(A),minimum_lambda=str(min(lam)))
  except (AssertionError,ZeroDivisionError) as error:out.update(status='RATIONAL_NEAREST_RECOVERY_REJECTED',error=str(error),numerical_primal=lp.x.tolist(),numerical_dual=list(map(float,lp.ineqlin.marginals)))
 out['elapsed_seconds']=time.monotonic()-start;assert all(sha(ROOT/p)==v for p,v in frozen['source_hashes'].items());a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['row_labels','numerical_dual','source_hashes','old_lambda_masses']},flush=True)
if __name__=='__main__':main()
