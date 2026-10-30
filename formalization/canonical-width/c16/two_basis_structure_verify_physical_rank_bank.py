"""Independent source-bound replay of cuts exported from physical rank endpoints.

The exported bank has its own provenance, separate from the small-flat screen.
Every row is checked by literal physical contraction rank and exact raw target
mass. Its geometry is target-independent; discovery violation is point-bound.
"""
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains
ROOT=Path(__file__).resolve().parent

def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_bytes())
def frozen(p):return p.with_name(p.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json')
def rank(vectors):
 B={}
 for v in vectors:
  while v:
   k=(v&-v).bit_length()-1
   if k in B:v^=B[k]
   else:B[k]=v;break
 return len(B)
def row_key(r):return r['mask'],tuple(r['forced_zero_indices']),tuple(r['indices']),r['contraction_rank']
def geometry(r,U,dd):
 m=r['mask'];assert type(m)is int and 0<=m<16;F=r['forced_zero_indices'];S=r['indices'];rr=r['contraction_rank'];assert F==dd[m]['zero_forced'] and rank(U[j] for j in F)==len(F);assert S==sorted(set(S)) and all(type(j)is int and 0<=j<720 for j in S) and set(S)<=set(dd[m]['zero_free']);assert type(rr)is int and rr>=0 and rank(U[j] for j in F+S)-len(F)==rr;assert r['physical_span_rank']==rr+len(F);return m,F,S,rr

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();start=time.monotonic();b=read(a.bank);assert b['status']=='EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS_REQUIRE_REPLAY';assert b['side'] in ['X','Z'];assert all(sha(ROOT/p)==h for p,h in b['source_hashes'].items());assert b['producer_sha256'] in b['source_hashes'].values();apath=ROOT/b['allocation_path'];allocation=read(apath);afp=frozen(apath);af=read(afp);assert sha(apath)==b['allocation_sha256'] and allocation['frozen_sha256']==sha(afp);assert [af[k] for k in ['side','X_anchors','Z_anchors','point_sha256']]==[b[k] for k in ['side','X_anchors','Z_anchors','point_sha256']];assert all(sha(ROOT/p)==h for p,h in af['source_hashes'].items());lam=list(map(Q,af['lambda_masses']));y=[list(map(Q,row)) for row in allocation['exact_allocations']];X,Z,_=physical_source();U=X if b['side']=='X' else Z;dd=[d[b['side']] for d in domains(X,Z,b['X_anchors'],b['Z_anchors'])];endpoints={}
 for s in b['endpoint_sources']:
  cp,rp=ROOT/s['certificate'],ROOT/s['receipt'];d,r=read(cp),read(rp);fp=frozen(cp);f=read(fp);assert sha(cp)==s['certificate_sha256']==r['certificate_sha256'] and sha(rp)==s['receipt_sha256'];assert d['frozen_sha256']==sha(fp)==r['frozen_sha256'];assert r['consumer_sha256']==sha(ROOT/'two_basis_structure_verify_physical_push_early.py');assert r['status'] in ['PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION','PASS_EXACT_PHYSICAL_SINGLE_PATTERN_BASIS_MIXTURE','PASS_EXACT_PHYSICAL_PUSH_RELABEL_PARTIAL_STATE'];assert f['solver_module']=='exact_matroid_push_relabel_early.py' and f['solver_sha256']==sha(ROOT/f['solver_module'])==r['solver_sha256'];assert all(sha(ROOT/p)==h for p,h in f['source_hashes'].items());assert [f[k] for k in ['side','X_anchors','Z_anchors','point_sha256','allocation_sha256']]==[b[k] for k in ['side','X_anchors','Z_anchors','point_sha256','allocation_sha256']];assert r['allocation_sha256']==b['allocation_sha256'] and r['point_sha256']==b['point_sha256'];assert s['certificate_sha256'] not in endpoints;endpoints[s['certificate_sha256']]=(d,r,f)
 gaps=[];seen=set()
 for row in b['cuts']:
  m,F,S,rr=geometry(row,U,dd);key=row_key(row);assert key not in seen;seen.add(key);d,r,f=endpoints[row['endpoint_certificate_sha256']];assert m==f['selected_mask'] and r['status']=='PASS_EXACT_PHYSICAL_SINGLE_PATTERN_RANK_VIOLATION';assert lam[m]>0;left=sum(y[m][j] for j in S);bound=lam[m]*rr;gap=left-bound;assert gap>0 and [Q(row[k]) for k in ['lambda_mass','exact_lhs','exact_bound','exact_violation']]==[lam[m],left,bound,gap];cut=dict(forced_zero_indices=F,indices=S,contraction_rank=rr,physical_span_rank=rr+len(F),exact_raw_violation=str(gap));assert cut==d['physical_rank_cut']==r['endpoint']['physical_rank_cut'];assert d['solver_endpoint']['status']=='EXACT_RANK_VIOLATION';gaps.append(gap)
 rejected=[]
 if b['cuts']:
  first=b['cuts'][0]
  for label,key,value in [('rank','contraction_rank',first['contraction_rank']+1),('outside-domain','indices',[-1]),('span-rank','physical_span_rank',first['physical_span_rank']+1)]:
   row=copy.deepcopy(first);row[key]=value
   try:geometry(row,U,dd)
   except (AssertionError,IndexError):rejected.append(label)
   else:raise AssertionError('corrupt physical rank geometry accepted')
 out=dict(status='PASS_EXACT_PHYSICAL_CONDITIONAL_RANK_ROWS',bank_sha256=sha(a.bank),consumer_sha256=sha(__file__),producer_sha256=b['producer_sha256'],point_sha256=b['point_sha256'],allocation_sha256=b['allocation_sha256'],side=b['side'],X_anchors=b['X_anchors'],Z_anchors=b['Z_anchors'],cuts_checked=len(gaps),violating_patterns=sorted({r['mask'] for r in b['cuts']}),minimum_exact_gap=str(min(gaps)) if gaps else None,maximum_exact_gap=str(max(gaps)) if gaps else None,endpoints_bound=len(endpoints),corruptions_rejected=rejected,dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','two_basis_structure_verify_physical_push_early.py','physical-pool-source.json','pools/xcoords.txt','pools/zcoords.txt']},all_subset_rank_membership_proved=False,shared_lambda_nonmembership_proved=False,global_target_nonmembership_proved=False,source_C16_answered=False,scope='Each listed conditional rank inequality is checked directly in the source physical pool after joint contraction. Exact positive discovery gaps reject this supplied allocation only. The row geometry remains valid for later allocations with the same anchors/sector.',elapsed_seconds=time.monotonic()-start);a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2),flush=True)
if __name__=='__main__':main()
