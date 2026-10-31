"""Independent exact fixed-lambda physical phase-I state replay."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,hashlib,json,time
from verify_algebraic_model import physical
from verify_full_partner_basis_oracle import dimension
from verify_full_partner_projection import point_data
from verify_two_sided_anchor_count import columns
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def replay(d,point,X,Z):
 assert d['status']=='EXACT_NORMALIZED_PHASE_I_STATE_CANDIDATE' and d['source_C16_answered'] is False and d['point_sha256']==sha(point);assert all(sha(ROOT/p)==v for p,v in d['source_hashes'].items());xx,zz=d['X_anchors'],d['Z_anchors'];side=d['side'];assert side in 'XZ';s=int(side=='Z');U,V=(X,Z) if s==0 else(Z,X);own=xx if s==0 else zz;opp=zz if s==0 else xx;lam=list(map(Q,d['lambda_masses']));assert len(lam)==16 and min(lam)>=0 and sum(lam)==1
 owner,_=point_data(point,32);alltarget=[Q(1) if j is None else owner[j] for j in columns(xx,zz)];ids=[11+720*s+j for j in range(720)]+[1451+1440*k+720*s+j for k in range(4) for j in range(720)];target=[alltarget[i] for i in ids];assert list(map(Q,d['sector_target']))==target
 for j,subset in enumerate([0,1,2,4,8,3,5,9,6,10,12]):assert sum(lam[m] for m in range(16) if m&subset==subset)==alltarget[j]
 masses=[Q(0)]*16;actual=[Q(0)]*3600;seen=set()
 for record in d['pattern_basis_records']:
  m=record['mask'];B=record['selected_indices'];w=Q(record['weight']);assert type(m)is int and 0<=m<16 and w>0;assert B==sorted(set(B)) and len(B)==128 and all(type(j)is int and 0<=j<720 for j in B);assert dimension(U[j] for j in B)==128;assert (m,tuple(B)) not in seen;seen.add((m,tuple(B)));assert all((j in B)==bool(m>>(2*s+k)&1) for k,j in enumerate(own));opposite=[j for k,j in enumerate(opp) if m>>(2*(1-s)+k)&1];assert dimension(V[j] for j in opposite)==len(opposite);sig=[sum(((U[j]&V[v]).bit_count()%2)<<k for k,v in enumerate(opposite)) for j in B];assert all(v.bit_count()<=1 for v in sig) and all(sig.count(1<<k)==1 for k in range(len(opposite)));masses[m]+=w
  for j in B:
   actual[j]+=w
   for k in range(4):
    if m>>k&1:actual[720+720*k+j]+=w
 assert masses==lam;positive=list(map(Q,d['positive_feature_errors']));negative=list(map(Q,d['negative_feature_errors']));assert len(positive)==len(negative)==3600 and min(positive)>=0 and min(negative)>=0;assert all(x+p-n==t for x,p,n,t in zip(actual,positive,negative,target));assert all(p==max(Q(0),t-x) and n==max(Q(0),x-t) for x,p,n,t in zip(actual,positive,negative,target));objective=sum(positive)+sum(negative);assert objective==Q(d['phase_I_objective'])
 return {'side':side,'physical_bases_checked':len(seen),'pattern_masses_checked':16,'exact_feature_equations':3600,'exact_phase_I_objective':str(objective),'approximate_phase_I_objective':float(objective),'exact_mixture_mass':'1','membership_proved':objective==0}
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--certificate',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();started=time.monotonic();d=json.loads(a.certificate.read_text());fp=a.certificate.with_name(a.certificate.name.removesuffix('.last-feasible-exact.json')+'.frozen.json');assert d['frozen_sha256']==sha(fp);X,Z,A=physical();assert dimension(X)==dimension(Z)==128;result=replay(d,a.point,X,Z);mutants=[]
 bad=copy.deepcopy(d);bad['point_sha256']='0'*64;mutants.append(('point_binding',bad));bad=copy.deepcopy(d);bad['pattern_basis_records'][0]['weight']='-1';mutants.append(('negative_weight',bad));bad=copy.deepcopy(d);bad['pattern_basis_records'][0]['selected_indices'].pop();mutants.append(('basis_cardinality',bad));bad=copy.deepcopy(d);bad['positive_feature_errors'][0]=str(Q(bad['positive_feature_errors'][0])+1);mutants.append(('changed_error',bad));rejected=[]
 for name,bad in mutants:
  try:replay(bad,a.point,X,Z)
  except (AssertionError,ValueError):rejected.append(name)
  else:raise AssertionError('corrupt state accepted '+name)
 result.update(status='PASS_EXACT_FIXED_LAMBDA_PHASE_I_STATE',source_C16_answered=False,certificate_sha256=sha(a.certificate),point_sha256=sha(a.point),consumer_sha256=sha(Path(__file__)),source_hashes=d['source_hashes'],dependencies={p:sha(ROOT/p) for p in ['verify_algebraic_model.py','verify_full_partner_basis_oracle.py','verify_full_partner_projection.py','verify_two_sided_anchor_count.py']},negative_controls_rejected=rejected,elapsed_seconds=time.monotonic()-started,scope='Exact physical mixture with fixed pattern masses and explicit nonnegative feature errors. Nonzero objective is not target membership. The feasible point is not claimed to be a simplex basis.');a.output.write_text(json.dumps(result,indent=2)+'\n');print({k:v for k,v in result.items() if k not in ['source_hashes','dependencies','exact_phase_I_objective']},flush=True)
if __name__=='__main__':main()
