#!/usr/bin/env python3
"""Bounded full/half-turn moment comparison with checked local profile hulls."""
from pathlib import Path
import argparse,gzip,json,math,time
import numpy as np
import cvxpy as cp
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--capacity-cuts',type=Path);ap.add_argument('--conditional-capacity',type=Path,nargs='*',default=[]);ap.add_argument('--conditional-matrix',type=Path);ap.add_argument('--conditional-cross-matrix',type=Path);ap.add_argument('--conditional-nogoods',type=Path);ap.add_argument('--conditional-linear-cuts',type=Path,nargs='*',default=[]);ap.add_argument('--certificate-margin',action='store_true');ap.add_argument('--eps',type=float,default=1e-6);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--iterations',type=int,default=30000);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();start=time.monotonic();data=json.loads(gzip.decompress(a.hulls.read_bytes()));P=data['period'];q=45;target=128 if P==16 else 64;X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];unit=[];bad=[]
 for h in range(P):
  first=np.array([[(X[16*i]&Z[16*j+h]).bit_count()%2 for j in range(q)] for i in range(q)])
  second=np.zeros_like(first) if P==16 else np.array([[(X[16*i]&Z[16*j+h+8]).bit_count()%2 for j in range(q)] for i in range(q)])
  unit.append(first^second);bad.append(first&second)
 assert all(np.array_equal(unit[h],unit[(-h)%P].T) and np.array_equal(bad[h],bad[(-h)%P].T) for h in range(P));half=P//2;p=cp.Variable(q);S={0:cp.Variable((q,q),symmetric=True),half:cp.Variable((q,q),symmetric=True)};T={0:cp.Variable((q,q),symmetric=True),half:cp.Variable((q,q),symmetric=True)}
 for h in range(1,half):S[h]=cp.Variable((q,q));T[h]=cp.Variable((q,q));S[P-h]=S[h].T;T[P-h]=T[h].T
 cut_reports=[json.loads(file.read_text()) for file in a.conditional_linear_cuts];forced_zeros=set()
 for report in cut_reports:
  assert report['status']=='PASS'
  for r in report['cuts']:
   if r['bound']==0 and all(c>=0 for c in r['coefficients']):
    for h,c in enumerate(r['coefficients']):
     if c:
      i,j=r['anchor_orbit'],r['orbit']
      if h>half:h=16-h;i,j=j,i
      forced_zeros.add(('S' if r['sector']=='X' else 'T',h,i,j))
 rows=cp.reshape(p,(q,1),order='C')@np.ones((1,q));con=[p>=0,p<=1,cp.diag(S[0])==p,P*cp.sum(p)==target]
 margin=cp.Variable(name='certificate_margin') if a.certificate_margin else None
 if a.certificate_margin:con.extend([margin>=0,p>=margin,p<=1-margin])
 for M in [sum(S.values()),sum(T.values())]:con.append(cp.sum(M,axis=1)==target*p)
 for h in range(half+1):
  for M in [S[h],T[h]]:
   con.extend([M>=0,M<=rows,M<=rows.T,M>=rows+rows.T-1])
   if a.certificate_margin:
    mask=np.ones((q,q))
    if h==0 and M is S[0]:np.fill_diagonal(mask,0)
    side='S' if M is S[h] else 'T'
    for ss,hh,i,j in forced_zeros:
     if ss==side and hh==h:
      mask[i,j]=0
      if h in (0,half):mask[j,i]=0
    if h in (0,half):assert np.array_equal(mask,mask.T)
    con.extend([cp.multiply(mask,M)>=margin*mask,cp.multiply(mask,rows-M)>=margin*mask,cp.multiply(mask,rows.T-M)>=margin*mask,cp.multiply(mask,1-rows-rows.T+M)>=margin*mask])
  if P==8:con.append(cp.multiply(bad[h],T[h])==0)
 con.append(cp.sum(sum(cp.multiply(unit[h],T[h]) for h in range(P)),axis=1)==p)
 G=cp.bmat([[np.ones((1,1)),cp.reshape(p,(1,q),order='C')],[cp.reshape(p,(q,1),order='C'),(sum(S.values())+sum(T.values()))/(2*P)]]);D0=sum(S.values())-sum(T.values())
 if a.certificate_margin:con.extend([G[:-1,:-1]-margin*np.eye(q)>>0,D0[:-1,:-1]-margin*np.eye(q-1)>>0])
 else:con.extend([G>>0,D0>>0])
 for k in range(1,half+1):
  for sign in [1,-1]:
   B={h:S[h]+sign*T[h] for h in range(P)};real=B[0]+(-1)**k*B[half];imag=0*B[0]
   for h in range(1,half):real+=math.cos(2*math.pi*k*h/P)*(B[h]+B[h].T);imag+=math.sin(2*math.pi*k*h/P)*(B[h]-B[h].T)
   block=real if k==half else cp.bmat([[real,-imag],[imag,real]])
   con.append((block-margin*np.eye(block.shape[0]) if a.certificate_margin else block)>>0)
 weights=[]
 for r in data['records']:
  o=r['orbit'];features=np.array([s['moments'] for s in r['shapes']],dtype=float).T;w=cp.Variable(features.shape[1],nonneg=True);weights.append(w);con.extend([cp.sum(w)==1,P*p[o]==features[0]@w])
  if a.certificate_margin:con.append(w>=margin)
  for h in range(1,half+1):con.append(P*S[h][o,o]==features[h]@w)
 capacity_constraints=conditional_constraints=0
 if a.capacity_cuts:
  report=json.loads(a.capacity_cuts.read_text());assert report['status']=='PASS' and report['orbits_checked']==45 and report.get('conditioned_on_anchor') is None and report.get('conditioned_on_X_index') is None and report.get('conditioned_on_X_absent') is None;caps=np.array([min(r['full_frame_count_upper_bound'],11 if r['orbit']==12 else 16)//(2 if P==8 else 1) for r in report['records']],dtype=float);upper=cp.reshape(p,(q,1),order='C')@caps.reshape((1,q));con.extend([sum(S.values())<=upper,sum(T.values())<=upper]);capacity_constraints=2*q*q
  if a.certificate_margin:con.extend([sum(S.values())<=upper-margin,sum(T.values())<=upper-margin])
 for file in a.conditional_capacity:
  assert P==16;report=json.loads(file.read_text());assert report['status']=='PASS' and report.get('conditioned_on_X_index') is not None;fixed=report['conditioned_on_X_index'];assert fixed%16==0;anchor=fixed//16
  for r in report['records']:
   o=r['orbit'];con.append(sum(S[h][anchor,o] for h in range(P))<=(r['full_frame_count_upper_bound']+int(o==anchor))*p[anchor]);conditional_constraints+=1
 if a.conditional_matrix:
  assert P==16;cohort=json.loads(a.conditional_matrix.read_text());assert cohort['status']=='PASS' and len(cohort['records'])==45 and cohort.get('selected_quotient_sector','X')=='X';matrix=np.array(cohort['capacity_matrix'],dtype=float);assert matrix.shape==(45,45);upper_conditional=cp.multiply(matrix,cp.reshape(p,(q,1),order='C'));con.append(sum(S.values())<=upper_conditional);conditional_constraints+=45*45
  if a.certificate_margin:con.append(sum(S.values())<=upper_conditional-margin)
 cross_constraints=0
 if a.conditional_cross_matrix:
  assert P==16;cohort=json.loads(a.conditional_cross_matrix.read_text());assert cohort['status']=='PASS' and len(cohort['records'])==45 and cohort['selected_quotient_sector']=='Z';matrix=np.array(cohort['capacity_matrix'],dtype=float);assert matrix.shape==(45,45);nonpartners=sum(cp.multiply(1-unit[h],T[h]) for h in range(P));upper_cross=cp.multiply(matrix,cp.reshape(p,(q,1),order='C'));con.append(nonpartners<=upper_cross);cross_constraints=45*45
  if a.certificate_margin:con.append(nonpartners<=upper_cross-margin)
 if a.conditional_nogoods:
  assert P==16;cutdata=json.loads(a.conditional_nogoods.read_text())
  for cut in cutdata['cuts']:
   anchor=cut['anchor_X_index']//16;o=cut['orbit'];mask=cut['mask'];con.append(sum(S[h][anchor,o] for h in range(P) if mask>>h&1)<=(mask.bit_count()-1)*p[anchor]);conditional_constraints+=1
 weighted_cuts=0
 for report in cut_reports:
  assert P==16;assert report['status']=='PASS'
  for r in report['cuts']:
   i=r['anchor_orbit'];j=r['orbit'];B=S if r['sector']=='X' else T;con.append(sum(r['coefficients'][h]*B[h][i,j] for h in range(16))<=r['bound']*p[i]-(margin if a.certificate_margin and not (r['bound']==0 and all(c>=0 for c in r['coefficients'])) else 0));weighted_cuts+=1
 for side,h,i,j in forced_zeros:con.append((S if side=='S' else T)[h][i,j]==0)
 problem=cp.Problem(cp.Maximize(margin) if a.certificate_margin else cp.Minimize(0),con);print('PROFILE MOMENT prepared',P,data['mode'],data['shape_variables'],'shape variables',len(con),'constraint objects',flush=True);a.output.write_text(json.dumps({'status':'RUNNING','period':P,'mode':data['mode'],'scope':'Sufficient strict-margin witness search, not a necessary-model obstruction' if a.certificate_margin else 'Numeric necessary-model test; not a proof'})+'\n')
 value=problem.solve(solver='SCS',max_iters=a.iterations,eps=a.eps,time_limit_secs=a.seconds,verbose=False);stats=problem.solver_stats;out={'status':problem.status,'source_C16_answered':False,'scope':'Sufficient strict-margin witness search; failure or infeasibility does not exclude source frames.' if a.certificate_margin else 'Numerical profile-enhanced moment relaxation; no original exclusion without exact source-binding and dual replay, no construction from moments.','physical_target':128,'restricted_to_halfturn':P==8,'period':P,'mode':data['mode'],'shape_variables':data['shape_variables'],'strict_margin_witness_search':a.certificate_margin,'capacity_RLT_scalar_inequalities':capacity_constraints,'conditional_RLT_inequalities':conditional_constraints,'conditional_nonpartner_RLT_inequalities':cross_constraints,'conditional_weighted_phase_inequalities':weighted_cuts,'wall_seconds':time.monotonic()-start,'solver_seconds':stats.solve_time,'iterations':stats.num_iters,'objective':value,'margin':float(margin.value) if a.certificate_margin and margin.value is not None else None}
 if p.value is not None:
  arrays={'p':p.value,**{f'S{h}':S[h].value for h in range(half+1)},**{f'T{h}':T[h].value for h in range(half+1)},**{f'w{o}':w.value for o,w in enumerate(weights)}};np.savez_compressed(a.output.with_suffix('.npz'),**arrays);out['max_constraint_violation']=max(float(np.max(c.violation())) for c in con)
 np.savez_compressed(a.output.with_suffix('.scs.npz'),**{k:v for k,v in stats.extra_stats.items() if isinstance(v,np.ndarray)});out['solver_info']=stats.extra_stats.get('info',{})
 def clean(v):
  if isinstance(v,dict):return {k:clean(x) for k,x in v.items()}
  if isinstance(v,list):return [clean(x) for x in v]
  if isinstance(v,float) and not math.isfinite(v):return None
  return v
 out=clean(out);a.output.write_text(json.dumps(out,indent=2,allow_nan=False)+'\n');print(out,flush=True)
if __name__=='__main__':main()
