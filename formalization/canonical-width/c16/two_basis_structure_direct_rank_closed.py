"""Scaled immutable successor accepting literal physical endpoint rank rows.

All prior rows are independently checked physical contraction ranks. Numerical
margin is discovery; exact recovery must pass every target/bucket/box/rank row.
No claim beyond this finite rank-cut relaxation is made.
"""
from pathlib import Path
from fractions import Fraction as Q
from math import lcm
import argparse,gzip,json,time
import numpy as np
from scipy.sparse import vstack
from scipy.optimize import linprog
from scipy.linalg import qr
from flint import fmpz_mat
from two_basis_structure_direct_allocation import ROOT,sha,read,expr,plus,construct,sparse,evaluate,exact_check
from two_basis_structure import solve_unique
from verify_two_sided_full_basis_oracle import physical_source,domains,target,rank

def rowkey(r):return r['mask'],tuple(r['forced_zero_indices']),tuple(r['indices']),r['contraction_rank']
def load_rows(banks,receipts,U,dd,side,lam,xx,zz):
 rows={};sources={};bindings=[];omitted=set()
 for bank,receipt in zip(banks,receipts):
  d=read(bank);q=read(receipt);assert q['status'] in ['PASS_EXACT_CONTRACTED_PATTERN_RANK_CUTS','PASS_EXACT_PATTERN_CONTRACTED_RANK_ROWS','PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY','PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS','PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS'];assert q['bank_sha256']==sha(bank);assert d['side']==side and d['X_anchors']==xx and d['Z_anchors']==zz;sources[str(bank)]=sha(bank);sources[str(receipt)]=sha(receipt);bindings.append(dict(bank=str(bank),bank_sha256=sha(bank),receipt=str(receipt),receipt_sha256=sha(receipt)))
  geometry=q['status']=='PASS_COMPLETE_CONTRACTED_RANK_LE_3_GEOMETRY';physical=q['status'] in ['PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS','PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS']
  if physical:
   consumer='two_basis_structure_verify_physical_closed_rank_bank.py' if q['status']=='PASS_EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS' else 'two_basis_structure_verify_physical_rank_bank.py';expected='EXACT_PHYSICAL_CONDITIONAL_CLOSED_RANK_ROWS_REQUIRE_REPLAY' if 'closed' in consumer else 'EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS_REQUIRE_REPLAY';assert q['consumer_sha256']==sha(ROOT/consumer) and d['status']==expected;assert all(sha(ROOT/p)==h for p,h in d['source_hashes'].items());sources[consumer]=sha(ROOT/consumer)
  if geometry:assert q['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_small_geometry.py') and d['allocation_or_point_used'] is False
  for r in d['rows'] if geometry else d['cuts']:
   m=r['mask'];F=r['forced_zero_indices'];S=r['indices'];assert (geometry or physical or r['side']==side) and F==dd[m]['zero_forced'] and S==sorted(set(S)) and set(S)<=set(dd[m]['zero_free']);assert rank(U[j] for j in F)==len(F);assert rank(U[j] for j in F+S)-len(F)==r['contraction_rank']
   if not lam[m]:omitted.add(rowkey(r));continue
   rows[rowkey(r)]={k:r[k] for k in ['mask','forced_zero_indices','indices','contraction_rank']}
 return [rows[k] for k in sorted(rows)],sources,bindings,len(omitted)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--lambda-seed',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--side',choices=['X','Z'],required=True);ap.add_argument('--rank-bank',type=Path,nargs='+',required=True);ap.add_argument('--rank-receipt',type=Path,nargs='+',required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--seconds',type=float,default=120);a=ap.parse_args();assert not a.output.exists() and len(a.rank_bank)==len(a.rank_receipt) and 0<a.seconds<=120;start=time.monotonic();seed=read(a.lambda_seed);lam=list(map(Q,seed['lambda_masses']));assert min(lam)>=0 and sum(lam)==1 and all(not l for m,l in enumerate(lam) if m.bit_count()>2) and all(lam[m]>0 for m in [0,1,2,4,8]);assert seed['point_sha256']==sha(a.point);xx,zz=seed['X_anchors'],seed['Z_anchors'];X,Z,_=physical_source();U=X if a.side=='X' else Z;full=target(a.point,xx,zz);s=int(a.side=='Z');b=full[11+720*s:731+720*s]+[full[1451+1440*i+720*s+j] for i in range(4) for j in range(720)];assert all(sum(lam[m] for m in range(16) if m&t==t)==full[k] for k,t in enumerate([0,1,2,4,8,3,5,9,6,10,12]));dd,E,variables,eq,labels,ineq,meta,face,local=construct(X,Z,a.side,xx,zz,lam,b);rankrows,sources,bindings,omitted=load_rows(a.rank_bank,a.rank_receipt,U,dd,a.side,lam,xx,zz)
 rankexpr=[]
 for r in rankrows:
  m=r['mask'];e=expr(-lam[m]*r['contraction_rank'])
  for j in r['indices']:e=plus(e,E[m][j])
  rankexpr.append(e)
 n=len(variables)
 def normalized(rows,masks):
  out=[]
  for (c,r),m in zip(rows,masks):
   l=lam[m];assert l>0
   z=(c/l,{k:v/l for k,v in r.items()})
   assert z[0]*l==c and {k:v*l for k,v in z[1].items()}==r
   out.append(z)
  return out
 scaled_boxes=normalized(ineq,[x[0] for x in meta]);scaled_ranks=normalized(rankexpr,[r['mask'] for r in rankrows]);Abox,bbox=sparse(scaled_boxes,n,True,[Q(1)]*16,meta);Arank,brank=sparse(scaled_ranks,n,True,[Q(1)]*16,[[r['mask']] for r in rankrows]);Aub=vstack([Abox,Arank],format='csr');bub=np.r_[bbox,brank];Aeq,beq=sparse(eq,n,False,lam);paths=['two_basis_structure_direct_rank_closed.py','two_basis_structure_direct_rank_physical.py','two_basis_structure_direct_rank_geometry.py','two_basis_structure_direct_rank_refine_scaled.py','two_basis_structure_direct_rank_refine.py','two_basis_structure_direct_allocation.py','two_basis_structure.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt'];sources.update({p:sha(ROOT/p) for p in paths});frozen=dict(status='FROZEN_SCALED_DIRECT_PAIR_COMPLETE_LOW_RANK_GATE',zero_mass_geometry_rows_omitted=omitted,exact_positive_lambda_scaling_checked=True,scaled_box_rows=len(scaled_boxes),scaled_rank_rows=len(scaled_ranks),side=a.side,X_anchors=xx,Z_anchors=zz,point_sha256=sha(a.point),lambda_seed_sha256=sha(a.lambda_seed),source_hashes=sources,lambda_masses=list(map(str,lam)),variables=variables,variable_count=n,global_equation_count=len(eq),box_inequality_count=len(ineq),rank_inequality_count=len(rankrows),rank_banks=bindings,rank_rows=rankrows,global_equation_labels=labels,local_face_fixes=face,local_block_summary=local,seconds=a.seconds,margin_definition='lambda-scaled margin on nonconstant boxes and all supplied rank rows; margin0 retains every feasible allocation',scope='Count/box allocation plus finite accepted contracted-rank rows only; remaining rank inequalities omitted.');fp=a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');assert not fp.exists();fp.write_text(json.dumps(frozen,indent=2)+'\n');print('PREPARED',a.side,n,'vars',len(eq),'equalities',len(rankrows),'rank rows',flush=True)
 c=np.zeros(n+1);c[-1]=-1;lp=linprog(c,A_ub=Aub,b_ub=bub,A_eq=Aeq,b_eq=beq,bounds=[(None,None)]*n+[(0,.5)],method='highs-ipm',options={'presolve':False,'time_limit':a.seconds,'primal_feasibility_tolerance':1e-10,'dual_feasibility_tolerance':1e-10,'ipm_optimality_tolerance':1e-10});out=dict(status='DIRECT_ALLOCATION_NUMERICAL_INCONCLUSIVE',frozen_sha256=sha(fp),numeric_status=int(lp.status),numeric_message=lp.message,iteration_count=int(lp.nit),numeric_margin=None if lp.x is None else float(lp.x[-1]),prior_rank_row_count=len(rankrows),elapsed_seconds=time.monotonic()-start)
 if lp.x is not None:
  np.savez_compressed(a.output.with_name(a.output.name.removesuffix('.json.gz').removesuffix('.json')+'.numeric.npz'),x=lp.x,variables=np.array(variables,dtype=np.int64));x=[Q(float(v)) for v in lp.x[:-1]];den=[lcm(*(z.denominator for z in [e[0],*e[1].values()])) for e in eq];A=[[int(e[1].get(j,0)*d) for j in range(n)] for e,d in zip(eq,den)];rhs=[-e[0]*d for e,d in zip(eq,den)];rank0=int(fmpz_mat(A).rank());_,_,roworder=qr(np.array(A,dtype=float).T,pivoting=True,mode='economic');rows=list(map(int,roworder[:rank0]));_,_,colorder=qr(np.array(A,dtype=float)[rows],pivoting=True,mode='economic');cols=list(map(int,colorder[:rank0]));res=[rhs[k]-sum(v*z for v,z in zip(A[k],x)) for k in range(len(A))]
  try:
   correction=solve_unique([[A[k][j] for j in cols] for k in rows],[res[k] for k in rows]);
   for j,v in zip(cols,correction):x[j]+=v
   assert all(sum(v*z for v,z in zip(row,x))==t for row,t in zip(A,rhs));y=evaluate(E,x);fail=exact_check(y,lam,dd,b);rslack=[lam[r['mask']]*r['contraction_rank']-sum(y[r['mask']][j] for j in r['indices']) for r in rankrows];rfail=[[i,str(v)] for i,v in enumerate(rslack) if v<0];out.update(global_exact_rank=rank0,recovery_pivot_rows=rows,recovery_pivot_columns=cols,maximum_parameter_correction=str(max([Q(0),*map(abs,correction)])),exact_box_failures=fail,exact_rank_failures=rfail,minimum_exact_rank_slack=str(min(rslack)),exact_feature_equations=3600,exact_global_bucket_equations=len(eq),minimum_box_slack=str(min(min(v,lam[m]-v) for m,row in enumerate(y) for v in row)),sector_target=list(map(str,b)),exact_allocations=[[str(v) for v in row] for row in y]);out['status']='EXACT_DIRECT_COUNT_ALLOCATION_REQUIRES_REPLAY' if not fail and not rfail else 'EXACT_DIRECT_ALLOCATION_RECOVERY_FAILED'
  except (AssertionError,ValueError,ZeroDivisionError) as error:out['exact_recovery_error']=str(error)
 assert all(sha(ROOT/p)==h for p,h in sources.items());out['elapsed_seconds']=time.monotonic()-start;raw=(json.dumps(out,indent=2)+'\n').encode();a.output.write_bytes(gzip.compress(raw,mtime=0) if str(a.output).endswith('.gz') else raw);print({k:v for k,v in out.items() if k not in ['exact_allocations','sector_target','exact_box_failures','exact_rank_failures']},flush=True)
if __name__=='__main__':main()
