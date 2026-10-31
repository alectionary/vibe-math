#!/usr/bin/env python3
"""One bounded X-sector batch IPM diagnostic, with exact lambda-row pricing."""
from pathlib import Path
from fractions import Fraction
import argparse,datetime,json,time
import highspy
import numpy as np
from two_sided_full_basis_oracle import TwoSidedFullBasisOracle,sha,source_hashes,json_exact,rank
from two_basis_inner_sector_v3 import read_lambda,sector_target,feature_rows

ROOT=Path(__file__).resolve().parent
F=3600
def write(path,obj):Path(path).write_text(json.dumps(json_exact(obj),indent=2)+'\n')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
 assert not a.output.exists();prefix=a.output.with_suffix('');fp=prefix.with_name(prefix.name+'.frozen.json')
 initial_path=prefix.with_name(prefix.name+'.initial-exact.json');matrix_path=prefix.with_name(prefix.name+'.lp-data.npz')
 assert not any(p.exists() for p in [fp,initial_path,matrix_path])
 point=ROOT/'coupling-results/integer-witness15-rational.json.gz'
 seed=ROOT/'two-basis-results/two-basis-structure-nearest-32x27-point15.json'
 report_path=ROOT/'two-basis-results/two-sided-full-basis-32x27-wolfe-point15.json'
 receipt_path=ROOT/'two-basis-results/two-sided-full-basis-32x27-endpoint-independent.json'
 controls_path=ROOT/'two-basis-results/two-sided-full-basis-controls-v3-independent.json'
 xx,zz=[80,512],[186,433];lam=read_lambda(seed,point,xx,zz);wanted=sector_target(point,xx,zz,'X')
 report=json.loads(report_path.read_text());receipt=json.loads(receipt_path.read_text());controls=json.loads(controls_path.read_text())
 assert receipt['status']=='PASS_BOUNDED_ENDPOINT_AUDIT_INCONCLUSIVE' and receipt['report_sha256']==sha(report_path)
 archive_path=ROOT/report['columns_artifact'];assert receipt['archive_sha256']==report['columns_sha256']==sha(archive_path)
 assert controls['status']=='PASS' and controls['producer_sha256']==sha(ROOT/'two_sided_full_basis_oracle.py')
 assert controls['consumer_sha256']==sha(ROOT/'verify_two_sided_full_basis_oracle.py')
 oracle=TwoSidedFullBasisOracle();domains=oracle.prepare(xx,zz);saved=np.load(archive_path)
 positive=[m for m,v in enumerate(lam) if v>0];mass_row={m:i for i,m in enumerate(positive)};K=len(positive)
 masks=[];bases=[];source_ids=[];seen=set()
 for archive_id,(mask,row) in enumerate(zip(saved['masks'],saved['selected_X_indices'])):
  m=int(mask);B=tuple(map(int,row))
  if not lam[m] or (m,B) in seen:continue
  assert B==tuple(sorted(set(B))) and len(B)==128 and all(0<=j<720 for j in B)
  d=domains[m]['X'];assert rank(oracle.X[j] for j in B)==128
  assert set(d['selected_anchor_indices'])<=set(B) and not set(d['absent_anchor_indices'])&set(B)
  assert all(sum((oracle.X[j]&oracle.Z[k]).bit_count()%2 for j in B)==1 for k in d['opposite_selected_indices'])
  seen.add((m,B));masks.append(m);bases.append(B);source_ids.append(archive_id)
 counts={m:sum(q==m for q in masks) for m in positive};assert all(counts.values())
 pattern_features={m:np.zeros(F,dtype=np.int64) for m in positive}
 ptr=[0];indices=[]
 for m,B in zip(masks,bases):
  rr=feature_rows(m,B);pattern_features[m][rr]+=1
  indices.extend([mass_row[m],*[K+j for j in rr]]);ptr.append(len(indices))
 basis_nnz=len(indices);nb=len(bases)
 for sign in [1,-1]:
  for j in range(F):indices.append(K+j);ptr.append(len(indices))
 values=np.r_[np.ones(basis_nnz+F),-np.ones(F)]
 exact_feature=[sum(lam[m]*int(pattern_features[m][j])/counts[m] for m in positive) for j in range(F)]
 residual=[t-x for t,x in zip(wanted,exact_feature)]
 ep=[1+max(v,Fraction(0)) for v in residual];en=[1+max(-v,Fraction(0)) for v in residual]
 assert all(x+p-n==t and p>0 and n>0 for x,p,n,t in zip(exact_feature,ep,en,wanted))
 rhs=np.asarray([*[float(lam[m]) for m in positive],*map(float,wanted)])
 np.savez_compressed(matrix_path,column_starts=np.asarray(ptr,dtype=np.int32),row_indices=np.asarray(indices,dtype=np.int32),values=values,
  rhs=rhs,shape=np.asarray([K+F,nb+2*F]),masks=np.asarray(masks,dtype=np.uint8),selected_indices=np.asarray(bases,dtype=np.uint16),
  original_archive_column_ids=np.asarray(source_ids,dtype=np.int32),positive_patterns=np.asarray(positive,dtype=np.uint8))
 hashes=source_hashes()
 for p in [Path(__file__),ROOT/'two_basis_inner_sector_v3.py',seed,report_path,receipt_path,controls_path,ROOT/'verify_two_sided_full_basis_oracle.py']:
  hashes[str(p.resolve().relative_to(ROOT))]=sha(p)
 frozen=dict(status='FROZEN_BEFORE_SINGLE_BATCH_IPM',source_C16_answered=False,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
  X_anchors=xx,Z_anchors=zz,side='X',point_sha256=sha(point),lambda_masses=list(map(str,lam)),sector_target=list(map(str,wanted)),
  source_hashes=hashes,initial_archive=str(archive_path.relative_to(ROOT)),initial_archive_sha256=sha(archive_path),
  positive_patterns=positive,deleted_zero_patterns=[m for m,v in enumerate(lam) if not v],physical_columns=nb,mass_rows=K,feature_rows=F,
  variable_count=nb+2*F,nonzeros=len(indices),lp_data_sha256=sha(matrix_path),seconds=120,
  solver_options={'solver':'ipm','run_crossover':'off','presolve':'off','threads':1,'time_limit':120.0,'ipm_optimality_tolerance':1e-8},
  column_generation=False,all16_patterns_repriced=True,scope='OnebatchIPMdiscovery atfixedlambda; numericalinfeasiblecannotcontradictexplicitstrictphase-Ifeasibility.')
 write(fp,frozen)
 write(initial_path,dict(status='EXACT_STRICT_PHASE_I_FEASIBLE_WITNESS_CANDIDATE',source_C16_answered=False,
  point_sha256=sha(point),side='X',X_anchors=xx,Z_anchors=zz,lambda_masses=list(map(str,lam)),sector_target=list(map(str,wanted)),
  frozen_sha256=sha(fp),lp_data_sha256=sha(matrix_path),source_hashes=hashes,
  pattern_records=[dict(mask=m,basis_count=counts[m],weight_per_basis=str(lam[m]/counts[m])) for m in positive],
  positive_feature_errors=list(map(str,ep)),negative_feature_errors=list(map(str,en)),
  phase_I_objective=str(sum(ep)+sum(en)),all_model_variables_strictly_positive=True,
  scope='Uniformpositiveweights overeveryretainedphysicalbasis andpositiveerrors; strictphase-Ifeasibilityonly, nottargetmembership.'))
 H=highspy.Highs()
 for name,value in frozen['solver_options'].items():assert H.setOptionValue(name,value)==highspy.HighsStatus.kOk
 assert H.setOptionValue('output_flag',False)==highspy.HighsStatus.kOk
 assert H.addRows(K+F,rhs,rhs,0,np.zeros(K+F+1,dtype=np.int32),np.array([],dtype=np.int32),np.array([],dtype=float))==highspy.HighsStatus.kOk
 assert H.addCols(nb+2*F,np.r_[np.zeros(nb),np.ones(2*F)],np.zeros(nb+2*F),np.full(nb+2*F,highspy.kHighsInf),
  len(indices),np.asarray(ptr,dtype=np.int32),np.asarray(indices,dtype=np.int32),values)==highspy.HighsStatus.kOk
 start=time.monotonic();H.run();solve_seconds=time.monotonic()-start;status=H.getModelStatus();sol=H.getSolution();info=H.getInfo()
 solution_path=prefix.with_name(prefix.name+'.solution.npz')
 x=np.asarray(sol.col_value);dual=np.asarray(sol.row_dual)
 np.savez_compressed(solution_path,column_values=x,row_dual=dual,column_dual=np.asarray(sol.col_dual),row_values=np.asarray(sol.row_value))
 numerical=None
 if sol.value_valid and len(x)==nb+2*F:
  mass=np.zeros(K);found=np.zeros(F)
  for j,(m,B) in enumerate(zip(masks,bases)):mass[mass_row[m]]+=x[j];found[feature_rows(m,B)]+=x[j]
  numerical=dict(minimum_variable=float(min(x)),maximum_mass_residual=float(max(abs(mass-rhs[:K]))),
   maximum_phase_I_equality_residual=float(max(abs(found+x[nb:nb+F]-x[nb+F:]-rhs[K:]))),
   maximum_feature_residual=float(max(abs(found-rhs[K:]))),feature_L1_residual=float(sum(abs(found-rhs[K:]))))
 cuts=[];priced_direction=None
 if len(dual)==K+F and np.all(np.isfinite(dual)) and max(abs(dual[K:]))>0:
  raw=dual[K:];norm=max(abs(raw));scale=1<<24;c=[int(np.rint(v*scale/norm)) for v in raw];bounds=[];records=[]
  for m,d in enumerate(domains):
   w=[c[j]+sum(c[720*(i+1)+j] for i in range(4) if m>>i&1) for j in range(720)]
   r=oracle.support_pattern(d,w+[0]*720)['X_support'];bound=int(r['value']);bounds.append(bound)
   records.append(dict(mask=m,value=bound,selected_indices=r['selected_indices'],zero_basis_indices=r['zero_basis_indices'],owner_indices=r['owner_indices']))
  left=sum(v*t for v,t in zip(c,wanted));right=sum(v*t for v,t in zip(bounds,lam));gap=left-right
  priced_direction=dict(side='X',X_anchors=xx,Z_anchors=zz,coefficients=c,pattern_bounds=bounds,exact_left=str(left),
   lambda_masses=list(map(str,lam)),exact_right_at_lambda=str(right),exact_violation=str(gap),support_records=records,
   inequality='sum_m pattern_bounds[m]*lambda[m] >= exact_left',dual_source_is_discovery_only=True)
  if gap>0:cuts.append(priced_direction)
 assert all(sha(ROOT/p)==h for p,h in hashes.items())
 out=dict(frozen);out.update(status='EXACT_FIXED_LAMBDA_SECTOR_SEPARATOR_CANDIDATE' if cuts else 'BOUNDED_BATCH_IPM_INCONCLUSIVE',
  frozen_sha256=sha(fp),solver_status=str(status),solve_seconds=solve_seconds,ipm_iterations=int(info.ipm_iteration_count),
  solver_objective=float(info.objective_function_value),primal_value_available=bool(sol.value_valid),dual_value_available=bool(sol.dual_valid),
  numerical_residual=numerical,solution_artifact=str(solution_path),solution_sha256=sha(solution_path),
  exact_initial_witness=str(initial_path),exact_initial_witness_sha256=sha(initial_path),cuts=cuts,priced_direction=priced_direction,
  exact_target_membership_proved=False,global_moment_cut_proved=False,elapsed_after_solver_setup=time.monotonic()-start)
 write(a.output,out);print(json.dumps({k:out[k] for k in ['status','solver_status','solve_seconds','ipm_iterations','solver_objective','numerical_residual']}),flush=True)

if __name__=='__main__':main()
