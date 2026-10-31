#!/usr/bin/env python3
"""Export a source-bound necessary-case conic model and variable map.

No solver result or source exclusion is asserted.
"""
from pathlib import Path
import argparse,gzip,json,math,time
import numpy as np
import cvxpy as cp
ROOT=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--case',type=int,nargs=3,required=True);ap.add_argument('--case-bridge',type=Path,required=True);ap.add_argument('--case-replay',type=Path,required=True);ap.add_argument('--basis-cuts',type=Path,nargs='+',required=True);ap.add_argument('--basis-replays',type=Path,nargs='+',required=True);ap.add_argument('--projected-cuts',type=Path,nargs='+',required=True);ap.add_argument('--projected-replays',type=Path,nargs='+',required=True);ap.add_argument('--boolean-margin',type=float,default=0.0);ap.add_argument('--projected-margin',type=float,default=0.0);ap.add_argument('--boolean-cuts',type=Path,nargs='+',required=True);ap.add_argument('--psd-interior-epsilon',type=float,default=0.0);ap.add_argument('--matroid-cuts',type=Path,nargs='+',required=True);ap.add_argument('--matroid-replays',type=Path,nargs='+',required=True);ap.add_argument('--warm-point',type=Path,required=True);ap.add_argument('--active-cuts',type=Path,required=True);ap.add_argument('--hulls',type=Path,required=True);ap.add_argument('--forbidden-patterns',type=Path,nargs='+',required=True);ap.add_argument('--capacity-cuts',type=Path);ap.add_argument('--conditional-capacity',type=Path,nargs='*',default=[]);ap.add_argument('--conditional-matrix',type=Path);ap.add_argument('--conditional-cross-matrix',type=Path);ap.add_argument('--conditional-nogoods',type=Path);ap.add_argument('--conditional-linear-cuts',type=Path,nargs='*',default=[]);ap.add_argument('--certificate-margin',action='store_true');ap.add_argument('--eps',type=float,default=1e-6);ap.add_argument('--seconds',type=float,default=300);ap.add_argument('--iterations',type=int,default=30000);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.certificate_margin;assert min(a.psd_interior_epsilon,a.boolean_margin,a.projected_margin)>=0;witness_only=any(x>0 for x in (a.psd_interior_epsilon,a.boolean_margin,a.projected_margin));scope=('Sufficient fixed-interior witness search; failure cannot exclude source frames.' if witness_only else 'Numerical approximation of necessary model with zero artificial margins; exact primal or dual replay is required.');start=time.monotonic();data=json.loads(gzip.decompress(a.hulls.read_bytes()));P=data['period'];assert P==16;q=45;target=128 if P==16 else 64;X,Z=[[int(v,16) for v in (ROOT/f'pools/{s}coords.txt').read_text().split()] for s in ['x','z']];unit=[];bad=[]
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
 else:con.extend([G[:-1,:-1]-a.psd_interior_epsilon*np.eye(q)>>0,D0[:-1,:-1]-a.psd_interior_epsilon*np.eye(q-1)>>0])
 for k in range(1,half+1):
  for sign in [1,-1]:
   B={h:S[h]+sign*T[h] for h in range(P)};real=B[0]+(-1)**k*B[half];imag=0*B[0]
   for h in range(1,half):real+=math.cos(2*math.pi*k*h/P)*(B[h]+B[h].T);imag+=math.sin(2*math.pi*k*h/P)*(B[h]-B[h].T)
   block=real if k==half else cp.bmat([[real,-imag],[imag,real]])
   con.append((block-margin*np.eye(block.shape[0]) if a.certificate_margin else block-a.psd_interior_epsilon*np.eye(block.shape[0]))>>0)
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
 from canonical_forbidden_moment_matrix import matrix as forbidden_matrix
 FM,forbidden_rows=forbidden_matrix(a.forbidden_patterns)
 moment_vector=cp.hstack([p]+[cp.vec(S[h],order='C') for h in range(9)])
 con.append(FM@moment_vector<=0)
 print('FORBIDDEN CONDITIONED ROWS',FM.shape[0],flush=True)
 from physical_owner_moment_matrix import matrix as owner_matrix
 from verify_algebraic_model import physical
 physical_X,physical_Z,physical_A=physical();assert X==physical_X and Z==physical_Z
 OM,owner_rows,owner_metadata=owner_matrix(physical_A)
 owner_vector=cp.hstack([p]+[cp.vec(B[h],order='C') for B in (S,T) for h in range(9)])
 con.append(OM@owner_vector<=0)
 print('PHYSICAL OWNER ROWS',OM.shape[0],flush=True)
 from physical_circuit_moment_matrix import matrix as circuit_matrix
 rank_bank=json.loads((ROOT/'moment-resumption-results/physical-rank-moment-bank.json').read_text())
 CM,circuit_rows,circuit_metadata=circuit_matrix(rank_bank['physical_circuits'])
 active=json.loads(a.active_cuts.read_text());assert active['status']=='VALID_ROW_SUBSET_SELECTED'
 for file,digest in active['source_hashes'].items():assert __import__('hashlib').sha256((ROOT/file).read_bytes()).hexdigest()==digest
 circuit_active=active['active_indices']['circuit'];assert circuit_active==sorted(set(circuit_active)) and all(0<=i<CM.shape[0] for i in circuit_active)
 if circuit_active:con.append(CM[circuit_active]@owner_vector<=0)
 print('PHYSICAL CIRCUIT ROWS',CM.shape[0],flush=True)
 from physical_legacy_linear_moments import build as legacy_linear_matrix
 LM,legacy_rhs,legacy_rows,legacy_rectangles,legacy_fold=legacy_linear_matrix(rank_bank['mapping'])
 legacy_active=active['active_indices']['legacy'];assert legacy_active==sorted(set(legacy_active)) and all(0<=i<LM.shape[0] for i in legacy_active)
 if legacy_active:con.append(LM[legacy_active]@owner_vector<=np.array(legacy_rhs,dtype=float)[legacy_active])
 print('LEGACY LINEAR ROWS',LM.shape[0],flush=True)
 from conditional_matroid_moment_matrix import matrix as matroid_matrix
 MM,matroid_rows=matroid_matrix(a.matroid_cuts,a.matroid_replays);con.append(MM@owner_vector<=0);print('MATROID ROWS',MM.shape[0],flush=True)
 from complete_boolean_triples import matrix as boolean_matrix
 BM,boolean_rhs,boolean_rows=boolean_matrix(a.boolean_cuts);con.append(BM@owner_vector<=boolean_rhs-a.boolean_margin);print('BOOLEAN ROWS',BM.shape[0],flush=True)
 from projected_profile_moment_matrix import matrix as projected_matrix
 PM,projected_rhs,projected_rows=projected_matrix(a.projected_cuts,a.projected_replays);con.append(PM@owner_vector<=projected_rhs-a.projected_margin);print('PROJECTED PROFILE ROWS',PM.shape[0],flush=True)
 from accepted_integer_coupling_rows import matrix as basis_matrix, normalized as basis_normalized
 FMbasis,basis_rhs,basis_rows=basis_matrix(a.basis_cuts,a.basis_replays);NM,basis_scaled_rhs,basis_scales=basis_normalized(FMbasis,basis_rhs);con.append(NM@owner_vector<=basis_scaled_rhs-a.projected_margin);print('ACCEPTED COUPLING AND INTEGER ROWS',FMbasis.shape[0],'scales',basis_scales.tolist(),flush=True)
 bridge=json.loads(a.case_bridge.read_text());assert bridge['status']=='PASS_SELECTED_PAIR_MOMENT_BRIDGE'
 assert all(__import__('hashlib').sha256((ROOT/f).read_bytes()).hexdigest()==s for f,s in bridge['source_hashes'].items())
 replay=json.loads(a.case_replay.read_text());assert replay['status']=='PASS' and replay['bridge_sha256']==__import__('hashlib').sha256(a.case_bridge.read_bytes()).hexdigest() and replay['consumer_sha256']==__import__('hashlib').sha256((ROOT/'verify_cover_case_moment_bridge.py').read_bytes()).hexdigest()
 case_record=next(r for r in bridge['records'] if r['case']==a.case)
 ci,cj,ch=a.case;case_orbit_size=case_record['edge_orbit_size'];assert case_orbit_size in (16,32)
 assert case_record['X_index']==16*ci and case_record['Z_index']==16*cj+ch
 assert physical_A[16*ci]>>(16*cj+ch)&1
 con.append(T[ch][ci,cj]>=1/case_orbit_size)
 case_scope={'case':a.case,'anchor':[16*ci,16*cj+ch],'edge_orbit_size':case_orbit_size,'necessary_floor':'1/'+str(case_orbit_size),'owner_coordinate':case_record['owner_coordinate'],'bridge_sha256':__import__('hashlib').sha256(a.case_bridge.read_bytes()).hexdigest(),'replay_sha256':__import__('hashlib').sha256(a.case_replay.read_bytes()).hexdigest()}
 scope='Case-conditioned: '+scope
 problem=cp.Problem(cp.Maximize(margin) if a.certificate_margin else cp.Minimize(0),con);print('PROFILE MOMENT prepared',P,data['mode'],data['shape_variables'],'shape variables',len(con),'constraint objects',flush=True);a.output.write_text(json.dumps({'status':'RUNNING','period':P,'mode':data['mode'],'scope':scope,'witness_only':witness_only})+'\n')
 import scs
 from cvxpy.reductions.solvers.conic_solvers.scs_conif import dims_to_solver_dict
 canonical,chain,inverses=problem.get_problem_data(cp.SCS);stuff=[v for v in inverses if hasattr(v,'var_offsets')][-1];initial=np.load(a.warm_point);x0=np.zeros(canonical['A'].shape[1]);filled=set();packed_offsets={};assert not a.certificate_margin
 def pack(variable,values):
  varid=variable.id
  for inverse in inverses:
   if isinstance(inverse,tuple) and len(inverse)>=2 and isinstance(inverse[0],dict) and varid in inverse[0]:varid=inverse[0][varid].id
  offset=stuff.var_offsets[varid];packed_offsets[variable.id]=offset;values=np.asarray(values).ravel();assert len(values)==stuff.id_map[varid][1];ids=set(range(offset,offset+len(values)));assert not ids&filled;filled.update(ids);x0[offset:offset+len(values)]=values
 pack(p,initial['p'])
 for side,B in [('S',S),('T',T)]:
  for h in range(9):
   arr=initial[f'{side}{h}'];pack(B[h],np.array([arr[i,j] for i in range(q) for j in range(i,q)]) if h in (0,8) else arr.ravel(order='F'))
 for o,w in enumerate(weights):pack(w,initial[f'w{o}'])
 assert filled==set(range(len(x0)))
 zc=canonical['dims'].zero;lc=canonical['dims'].nonneg;initial_res=canonical['A']@x0-canonical['b'];audit={'warm_point_sha256':__import__('hashlib').sha256(a.warm_point.read_bytes()).hexdigest(),'canonical_variables_mapped':len(filled),'max_initial_equality_residual':float(np.abs(initial_res[:zc]).max(initial=0)),'max_initial_linear_inequality_violation':float(initial_res[zc:zc+lc].max(initial=0)),'scale':1e-6,'adaptive_scale':False}
 a.output.with_suffix('.warmstart.json').write_text(json.dumps(audit,indent=2)+'\n');print('WARMSTART',audit,flush=True)
 assert not witness_only, 'This diagnostic uses zero artificial margins only'
 import highspy
 from scipy.sparse import save_npz
 linear=canonical['A'][:zc+lc].tocsr();right=np.asarray(canonical['b'][:zc+lc]);low=right.copy();low[zc:]=-highspy.kHighsInf
 save_npz(a.output.with_suffix('.linear-A.npz'),linear)
 np.savez_compressed(a.output.with_suffix('.linear-data.npz'),rhs=right,warm=x0)
 owner_map=list(range(packed_offsets[p.id],packed_offsets[p.id]+45))
 for B in (S,T):
  for h in range(9):
   offset=packed_offsets[B[h].id]
   if h in (0,8):
    table={};k=0
    for i in range(45):
     for j in range(i,45):table[i,j]=table[j,i]=offset+k;k+=1
    owner_map.extend(table[i,j] for i in range(45) for j in range(45))
   else:owner_map.extend(offset+j*45+i for i in range(45) for j in range(45))
 owner_map=np.array(owner_map,dtype=np.int64)
 literal_warm=np.concatenate([initial['p']]+[initial[f'{side}{h}'].ravel() for side in ('S','T') for h in range(9)])
 assert len(owner_map)==36495 and np.array_equal(x0[owner_map],literal_warm)
 np.savez_compressed(a.output.with_suffix('.linear-data.npz'),rhs=right,warm=x0,owner_to_canonical=owner_map)
 out={'status':'EXPORTED_NUMERIC_LINEAR_NECESSARY_CASE_MODEL','source_C16_answered':False,'source_anchor_excluded':False,
      'case_condition':case_scope,'variables':linear.shape[1],'equalities':zc,'inequalities':lc,'nonzeros':linear.nnz,
      'PSD_rows_omitted':int(canonical['A'].shape[0]-zc-lc),'owner_coordinates_mapped':len(owner_map),
      'owner_map_warm_literal_identity':True,'zero_artificial_margins':not witness_only,
      'accepted_coupling_and_integer_rows':FMbasis.shape[0],
      'physical_integer_form_rows':sum(r.get('family')=='physical_integer_form' for r in basis_rows),
      'scope':'Inherited zero-margin linear necessary model with source-selected floor. PSD omitted. Canonical doubles are discovery data, not an exact semantic certificate.',
      'seconds':time.monotonic()-start}
 save_npz(a.output.with_suffix('.full-A.npz'),canonical['A'])
 np.savez_compressed(a.output.with_suffix('.full-data.npz'),b=canonical['b'],c=canonical['c'],warm=x0,owner_to_canonical=owner_map)
 out['status']='EXPORTED_NUMERIC_CONIC_NECESSARY_CASE_MODEL'
 out['full_cone_dimensions']={'z':zc,'l':lc,'s':list(canonical['dims'].psd)}
 out['full_rows']=canonical['A'].shape[0]
 out['scope']='Zero-margin necessary source-case conic model. Bothfullconic andlinear-onlynumericpackets exported. Exactsemanticprimal/dual required forsourceclaim.'
 a.output.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
