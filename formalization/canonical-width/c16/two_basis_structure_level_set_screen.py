"""Exact rank replay of every distinct saved push/relabel level upper set.

Discovery labels are untrusted. Every accepted row is certified directly by
physical GF(2) rank after the already source-bound joint contraction. No
solver extension, label invariant, or maximum-defect assertion is required.
"""
from pathlib import Path
from fractions import Fraction as Q
from itertools import product
import argparse,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def add(B,v):
 while v:
  k=(v&-v).bit_length()-1
  if k in B:v^=B[k]
  else:B[k]=v;return

def rank(vs):
 B={}
 for v in vs:add(B,v)
 return len(B)
def highrank(vs):
 B={}
 for v in vs:
  while v:
   k=v.bit_length()-1
   if k in B:v^=B[k]
   else:B[k]=v;break
 return len(B)
def contained(B,v):
 for k in sorted(B):
  if v>>k&1:v^=B[k]
 return not v

def check_row(row,U,F,E,y,l):
 S=row['indices'];assert S==sorted(set(S)) and set(S)<=set(E)
 r=rank(U[j] for j in F+S)-len(F)
 assert r==row['contraction_rank']==highrank(U[j] for j in F+S)-len(F)
 lhs=sum((y[j] for j in S),Q(0));gap=lhs-l*r
 assert str(lhs)==row['exact_raw_lhs'] and str(l*r)==row['exact_raw_rhs'] and str(gap)==row['exact_raw_violation'] and gap>0
 return True

def controls():
 # Different pivot directions, all labels and all rational targets on a tiny
 # parallel/loop matroid; exact rank, not the labels, is the authority.
 U=[0,1,1,2,3];checked=0
 for ls in product(range(3),repeat=5):
  for h in sorted(set(ls),reverse=True):
   S=[i for i,x in enumerate(ls) if x>=h]
   assert rank(U[i] for i in S)==highrank(U[i] for i in S);checked+=1
 y=[Q(0),Q(2,3),Q(2,3),Q(1,3),Q(1,3)];row=dict(indices=[1,2],contraction_rank=1,exact_raw_lhs='4/3',exact_raw_rhs='1',exact_raw_violation='1/3');assert check_row(row,U,[],list(range(5)),y,Q(1));rejected=[]
 for key,value in [('contraction_rank',2),('exact_raw_violation','0'),('indices',[1,3])]:
  bad=dict(row);bad[key]=value
  try:check_row(bad,U,[],list(range(5)),y,Q(1))
  except AssertionError:rejected.append(key)
  else:raise AssertionError('corrupt rank row accepted')
 return dict(literal_upper_sets_checked=checked,corruptions_rejected=rejected)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--prefix',default='two-basis-results/two-basis-push-relabel-Z-remaining10-dyadic50');ap.add_argument('--output',required=True,type=Path);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();X,Z,bridge=physical_source();records=[];allrows=[];sources={p:sha(ROOT/p) for p in ['two_basis_structure_level_set_screen.py','two_basis_structure_verify_physical_push_v2.py','verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py']};files=sorted(ROOT.glob(a.prefix+'-m*.json.gz'));assert len(files)==10
 for file in files:
  stem=file.name.removesuffix('.json.gz');fp=file.with_name(stem+'.frozen.json');rp=file.with_name(stem+'-independent.json');d,f,receipt=map(read,[file,fp,rp]);assert d['frozen_sha256']==sha(fp);assert receipt['certificate_sha256']==sha(file) and receipt['frozen_sha256']==sha(fp) and receipt['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_push_v2.py');assert receipt['status'] in ['PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE','PASS_EXACT_PHYSICAL_PUSH_RELABEL_PARTIAL_STATE'];assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());sources.update(f['source_hashes'])
  for p in [file,fp,rp]:sources[str(p.relative_to(ROOT))]=sha(p)
  allocation=read(ROOT/f['allocation_path']);assert sha(ROOT/f['allocation_path'])==f['allocation_sha256']==receipt['allocation_sha256'];m=f['selected_mask'];side=f['side'];U=X if side=='X' else Z;dd=domains(X,Z,f['X_anchors'],f['Z_anchors'])[m][side];p=next(p for p in f['prepared_positive_patterns'] if p['mask']==m);F,E=p['forced_zero_indices'],p['physical_zero_ground_indices'];assert F==dd['zero_forced'] and E==dd['zero_free'];assert rank(U[j] for j in F)==len(F);l=Q(p['lambda_mass']);y=list(map(Q,p['raw_sector_target']));assert y==list(map(Q,allocation['exact_allocations'][m]));q=list(map(Q,p['conditional_zero_target']));assert q==[y[j]/l for j in E];V=[int(v,16) for v in p['quotient_vectors_hex']];P={}
  for j in F:add(P,U[j])
  assert all(contained(P,v^U[j]) for v,j in zip(V,E));r=d['solver_endpoint'];levels=r['levels'];assert len(levels)==len(E) and all(type(v)is int and v>=0 for v in levels);D=int(r['denominator']);g=list(map(int,r['target_numerators']));x=list(map(int,r['achieved_numerators']));assert len(g)==len(x)==len(E) and all(Q(v,D)==q[i] for i,v in enumerate(g));B=dict(P);S=[];mass=Q(0);achieved=Q(0);checks=[];rows=[]
  for h in sorted(set(levels),reverse=True):
   new=[i for i,z in enumerate(levels) if z==h]
   for i in new:add(B,U[E[i]]);S.append(E[i]);mass+=y[E[i]];achieved+=Q(x[i],D)
   rr=len(B)-len(F);indices=sorted(S);assert rr==highrank(V[i] for i,z in enumerate(levels) if z>=h);gap=mass-l*rr;cut=dict(mask=m,forced_zero_indices=F,indices=indices,contraction_rank=rr,physical_span_rank=rr+len(F),exact_raw_lhs=str(mass),exact_raw_rhs=str(l*rr),exact_raw_violation=str(gap),level_threshold=h-1)
   checks.append(dict(threshold=h-1,size=len(S),contraction_rank=rr,exact_raw_violation=str(gap),empty_threshold_level=(h-1 not in levels),has_deficient_coordinate=any(g[i]>x[i] and levels[i]>=h for i in range(len(E))),exact_achieved_conditional_mass=str(achieved),achieved_equals_rank=achieved==rr))
   if gap>0:check_row(cut,U,F,E,y,l);rows.append(cut)
  # A span closure has the same exact rank and can only strengthen a row.
  closure=None
  if rows:
   best=max(rows,key=lambda z:Q(z['exact_raw_violation']));C={}
   for j in F+best['indices']:add(C,U[j])
   S=sorted(j for j in E if contained(C,U[j]));lhs=sum((y[j] for j in S),Q(0));closure=dict(best,indices=S,exact_raw_lhs=str(lhs),exact_raw_violation=str(lhs-l*best['contraction_rank']),derived_by='full physical zero-pool span closure');check_row(closure,U,F,E,y,l);rows.append(closure)
  allrows.extend(rows);records.append(dict(mask=m,solver_status=r['status'],stop_reason=r['stop_reason'],ground_size=len(E),contracted_rank=r['rank'],steps=r['steps'],pushes=r['pushes'],lifts=r['lifts'],zero_basis_count=len(r['bases']),seconds=r['seconds'],raw_L1=d['exact_raw_L1_residual'],maximum_level=max(levels,default=0),distinct_levels=sorted(set(levels)),checks=checks,positive_level_rows=len(rows)-(closure is not None),strongest_span_closure=closure))
 out=dict(status='PASS_EXACT_SAVED_LEVEL_UPPER_SET_RANK_SCREEN',source_hashes=sources,producer_sha256=sha(__file__),point_sha256=records and read(files[0])['point_sha256'],records=records,rank_rows=allrows,controls=controls(),positive_patterns=[z['mask'] for z in records if z['positive_level_rows']],all_subset_rank_membership_proved=False,source_C16_answered=False,scope='Every distinct saved level upper set is tested by independent literal physical contraction rank. Positive rows reject only the supplied allocation. Empty-level and label invariants are not needed for row validity; absence of a found row is inconclusive.',elapsed_seconds=time.monotonic()-start);a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],patterns=out['positive_patterns'],rows=len(allrows),elapsed_seconds=out['elapsed_seconds'],summaries=[dict(mask=z['mask'],rows=z['positive_level_rows'],best=z['strongest_span_closure'] and {k:z['strongest_span_closure'][k] for k in ['contraction_rank','exact_raw_violation']}) for z in records]),indent=2),flush=True)
if __name__=='__main__':main()
