"""Independent physical endpoint replay for the frozen early-gap solver.

No push/relabel or physical-runner imports. Rebuild all prepared contractions
with low pivots and certify returned mixtures or literal rank cuts directly.
An inconclusive endpoint proves only a valid physical intermediate mixture.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains,target
from verify_two_basis_direct_allocation import check_allocation
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def basis(vectors):
 out={}
 for v in vectors:
  while v:
   k=(v&-v).bit_length()-1
   if k in out:v^=out[k]
   else:out[k]=v;break
 return out

def rem(v,B):
 for k in sorted(B):
  if v>>k&1:v^=B[k]
 return v

def endpoint_check(d,f,U,prepared):
 m=f['selected_mask'];p=next(p for p in prepared if p['mask']==m);F,E=p['forced_zero_indices'],p['physical_zero_ground_indices'];l=Q(p['lambda_mass']);q=list(map(Q,p['conditional_zero_target']));wanted=list(map(Q,p['raw_sector_target']));zero_rank=p['contracted_rank'];owners=p['owner_bins'];assert zero_rank+len(F)+len(owners)==128
 r=d['solver_endpoint'];D=int(r['denominator']);assert D>0 and r['ground_size']==len(E) and r['rank']==zero_rank and all((v*D).denominator==1 for v in q);gi=[int(v*D) for v in q];assert list(map(int,r['target_numerators']))==gi;counts=[0]*len(E);mass=0;seen=set()
 for row in r['bases']:
  B=row['indices'];w=int(row['weight_numerator']);assert w>0 and B==sorted(set(B)) and len(B)==zero_rank and all(type(j)is int and 0<=j<len(E) for j in B);S=sorted(F+[E[j] for j in B]);assert tuple(S) not in seen;seen.add(tuple(S));assert len(S)==zero_rank+len(F) and len(basis(U[j] for j in S))==len(S);mass+=w
  for j in B:counts[j]+=w
 assert mass==D and counts==list(map(int,r['achieved_numerators']));assert len(seen)<=f['maximum_active_bases'] and r['maximum_active_bases']<=f['maximum_active_bases'];expected=[Q(0)]*720
 for j in F:expected[j]=l
 for i,j in enumerate(E):expected[j]=l*Q(counts[i],D)
 for owner in owners:
  for j,v in zip(owner['indices'],owner['conditional_probabilities']):expected[j]=l*Q(v)
 fullD=int(d.get('full_basis_denominator',D));assert fullD>0;fullcounts=[0]*720;fullmass=0;physical=d['physical_basis_records'];allowed=set(F+E+[j for o in owners for j in o['indices']]);own=f['X_anchors'] if f['side']=='X' else f['Z_anchors'];shift=0 if f['side']=='X' else 2
 for record in physical:
  S=record['selected_indices'];w=int(record['weight_numerator']);assert w>0 and S==sorted(set(S)) and len(S)==128 and set(S)<=allowed and set(F)<=set(S);assert len(basis(U[j] for j in S))==128;assert all((j in S)==bool(m>>(shift+k)&1) for k,j in enumerate(own));assert all(len(set(S)&set(o['indices']))==1 for o in owners);assert len(set(S)&set(F+E))==zero_rank+len(F);fullmass+=w
  for j in S:fullcounts[j]+=w
 assert fullmass==fullD;support_sizes=[len(r['bases'])]+[sum(Q(v)>0 for v in o['conditional_probabilities']) for o in owners];assert d.get('lift_component_support_sizes',support_sizes)==support_sizes and len(physical)<=sum(support_sizes)-len(support_sizes)+1;achieved=[l*Q(c,fullD) for c in fullcounts];assert achieved==expected==list(map(Q,d['raw_achieved_allocations']));errors=[a-b for a,b in zip(wanted,achieved)];L1=sum(map(abs,errors));assert L1==Q(d['exact_raw_L1_residual']) and max(map(abs,errors))==Q(d['exact_raw_max_residual']);status=r['status'];cut=None
 if status=='EXACT_BASE_MIXTURE':assert not any(errors) and r['violated_rank'] is None and d['physical_rank_cut'] is None
 elif status=='EXACT_RANK_VIOLATION':
  c=r['violated_rank'];S=c['indices'];assert S==sorted(set(S)) and all(type(i)is int and 0<=i<len(E) for i in S);A=sorted(E[i] for i in S);rr=len(basis(U[j] for j in F+A))-len(F);rawgap=sum(wanted[j] for j in A)-l*rr;assert rawgap>0 and rr==c['rank'] and rawgap/l==Q(c['exact_violation']);cut=dict(forced_zero_indices=F,indices=A,contraction_rank=rr,physical_span_rank=rr+len(F),exact_raw_violation=str(rawgap));assert cut==d['physical_rank_cut']
 else:assert status=='BOUNDED_PUSH_RELABEL_INCONCLUSIVE' and d['physical_rank_cut'] is None
 assert d['exact_local_membership_candidate']==(status=='EXACT_BASE_MIXTURE');assert d['all_patterns_membership_proved'] is False and d['two_sector_membership_proved'] is False and d['source_C16_answered'] is False
 return dict(solver_status=status,zero_basis_count=len(seen),physical_basis_count=len(physical),exact_zero_integer_weight_mass=str(mass),zero_common_denominator=str(D),exact_full_integer_weight_mass=str(fullmass),full_common_denominator=str(fullD),raw_marginals_checked=720,exact_raw_L1_residual=str(L1),local_mask_membership_proved=status=='EXACT_BASE_MIXTURE',physical_rank_cut=cut)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();d=read(a.certificate);stem=a.certificate.name.removesuffix('.json.gz').removesuffix('.json');fp=a.certificate.with_name(stem+'.frozen.json');f=read(fp);assert d['status']=='PHYSICAL_PUSH_RELABEL_ENDPOINT_REQUIRES_REPLAY' and d['frozen_sha256']==sha(fp);assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());assert f['point_sha256']==sha(a.point)==d['point_sha256'];assert d['allocation_sha256']==f['allocation_sha256'] and d['selected_mask']==f['selected_mask'] and d['side']==f['side'];apath=ROOT/f['allocation_path'];allocation=read(apath);assert sha(apath)==f['allocation_sha256'];afp=apath.with_name(apath.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');af=read(afp);assert allocation['frozen_sha256']==sha(afp);receipts=[ROOT/p for p,h in f['source_hashes'].items() if h==f['allocation_receipt_sha256']];assert len(receipts)==1;ar=read(receipts[0]);assert ar['status']=='PASS_EXACT_DIRECT_COUNT_AND_LISTED_RANK_ROWS' and ar['certificate_sha256']==sha(apath) and ar['frozen_sha256']==sha(afp) and ar['consumer_sha256']==sha(ROOT/'verify_two_basis_rank_geometry_allocation.py');tiny=[ROOT/p for p,h in f['source_hashes'].items() if h==f['tiny_controls_receipt_sha256']];assert len(tiny)==1;tr=read(tiny[0]);assert f['solver_module']=='exact_matroid_push_relabel_early.py' and f['solver_sha256']==sha(ROOT/f['solver_module']);assert tr['status']=='PASS_EXACT_VERSIONED_PUSH_RELABEL_TINY_ENDPOINTS' and tr['producer']==f['solver_module'] and tr['producer_sha256']==f['solver_sha256'] and tr['consumer_sha256']==sha(ROOT/'two_basis_structure_versioned_push_controls.py') and tr['endpoint_checker_sha256']==sha(ROOT/'two_basis_structure_push_relabel_controls.py') and tr['cases']==2374 and tr['maximum_defect_required'] is False;assert tr['bank_sha256'] in f['source_hashes'].values();X,Z,bridge=physical_source();xx,zz,side=f['X_anchors'],f['Z_anchors'],f['side'];assert [xx,zz,side]==[af['X_anchors'],af['Z_anchors'],af['side']];U=X if side=='X' else Z;dd=[z[side] for z in domains(X,Z,xx,zz)];lam=list(map(Q,af['lambda_masses']));y=[list(map(Q,row)) for row in allocation['exact_allocations']];full=target(a.point,xx,zz);s=int(side=='Z');b=full[11+720*s:731+720*s]+[full[1451+1440*i+720*s+j] for i in range(4) for j in range(720)];allocation_checks=check_allocation(y,lam,dd,b);prepared=f['prepared_positive_patterns'];assert [p['mask'] for p in prepared]==[m for m,l in enumerate(lam) if l];contractions=0
 for p in prepared:
  m=p['mask'];F,E=p['forced_zero_indices'],p['physical_zero_ground_indices'];assert F==dd[m]['zero_forced'] and E==dd[m]['zero_free'] and Q(p['lambda_mass'])==lam[m] and list(map(Q,p['raw_sector_target']))==y[m];P=basis(U[j] for j in F);assert len(P)==len(F);V=[int(v,16) for v in p['quotient_vectors_hex']];assert len(V)==len(E) and all(0<=v<1<<128 for v in V);assert all(rem(v^U[j],P)==0 for v,j in zip(V,E));r=dd[m]['zero_required']-len(F);assert len(basis(V))==r and len(basis(V+[U[j] for j in F]))==r+len(F) and p['contracted_rank']==r;q=list(map(Q,p['conditional_zero_target']));assert q==[y[m][j]/lam[m] for j in E] and min(q)>=0 and max(q)<=1 and sum(q)==r;assert all(y[m][j]==lam[m] for j in F);B=p['initial_local_basis'];assert B==sorted(set(B)) and len(B)==r and all(type(i)is int and 0<=i<len(E) for i in B) and len(basis(U[j] for j in F+[E[i] for i in B]))==r+len(F);assert [o['indices'] for o in p['owner_bins']]==dd[m]['bins']
  for o in p['owner_bins']:
   prob=list(map(Q,o['conditional_probabilities']));assert prob==[y[m][j]/lam[m] for j in o['indices']] and min(prob)>=0 and sum(prob)==1
  contractions+=1
 result=endpoint_check(d,f,U,prepared);mutants=[]
 bad=copy.deepcopy(d);bad['solver_endpoint']['bases'][0]['weight_numerator']='-1';mutants.append(('negative_weight',bad));bad=copy.deepcopy(d);B=bad['solver_endpoint']['bases'][0]['indices'];B[1]=B[0];mutants.append(('duplicate_physical_basis_index',bad));bad=copy.deepcopy(d);bad['raw_achieved_allocations'][0]=str(Q(bad['raw_achieved_allocations'][0])+1);mutants.append(('changed_raw_marginal',bad));bad=copy.deepcopy(d);bad['solver_endpoint']['denominator']=str(int(bad['solver_endpoint']['denominator'])+1);mutants.append(('changed_common_denominator',bad));bad=copy.deepcopy(d);B=bad['physical_basis_records'][0]['selected_indices'];B[1]=B[0];mutants.append(('duplicate_full_basis_index',bad));bad=copy.deepcopy(d);bad['full_basis_denominator']=str(int(bad.get('full_basis_denominator',bad['solver_endpoint']['denominator']))+1);mutants.append(('changed_full_basis_denominator',bad));rejected=[]
 for name,bad in mutants:
  try:endpoint_check(bad,f,U,prepared)
  except (AssertionError,ValueError):rejected.append(name)
  else:raise AssertionError('corrupt endpoint accepted')
 status={'EXACT_BASE_MIXTURE':'PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE','EXACT_RANK_VIOLATION':'PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION','BOUNDED_PUSH_RELABEL_INCONCLUSIVE':'PASS_EXACT_PHYSICAL_PUSH_RELABEL_PARTIAL_STATE'}[result['solver_status']];out=dict(status=status,certificate_sha256=sha(a.certificate),frozen_sha256=sha(fp),allocation_sha256=sha(apath),allocation_receipt_sha256=sha(receipts[0]),point_sha256=sha(a.point),solver_module=f['solver_module'],solver_sha256=f['solver_sha256'],tiny_controls_receipt_sha256=sha(tiny[0]),consumer_sha256=sha(__file__),dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_two_basis_direct_allocation.py','verify_algebraic_model.py']},source_hashes=f['source_hashes'],side=side,selected_mask=f['selected_mask'],prepared_positive_contractions_checked=contractions,accepted_allocation_checks=allocation_checks,endpoint=result,corruptions_rejected=rejected,elapsed_seconds=time.monotonic()-start,all_patterns_membership_proved=False,two_sector_membership_proved=False,source_C16_answered=False,scope='One exact physical conditional zero-basis law or one physical rank cut at the selected mask. Other prepared patterns are input-checked only. No whole-allocation, two-sector, full-frame or source-case claim.');a.output.write_text(json.dumps(out,indent=2)+'\n');print({k:v for k,v in out.items() if k not in ['source_hashes','dependencies','accepted_allocation_checks']},flush=True)
if __name__=='__main__':main()
