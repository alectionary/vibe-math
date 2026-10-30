"""Independent low-pivot replay of conditional allocation rank cuts."""
from pathlib import Path
from fractions import Fraction as Q
import argparse,copy,gzip,hashlib,json,time
from verify_two_sided_full_basis_oracle import physical_source,domains
ROOT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def read(p):
 p=Path(p);return json.loads(gzip.decompress(p.read_bytes()) if p.suffix=='.gz' else p.read_text())
def rank_low(vectors):
 piv={}
 for x in vectors:
  while x:
   k=(x&-x).bit_length()-1
   if k in piv:x^=piv[k]
   else:piv[k]=x;break
 return len(piv)
def row_check(c,U,dd,lam,y):
 m=c['mask'];assert type(m)is int and 0<=m<16 and lam[m]>0;F=c['forced_zero_indices'];S=c['indices'];assert F==dd[m]['zero_forced'];assert S==sorted(set(S)) and set(S)<=set(dd[m]['zero_free']);assert rank_low(U[j] for j in F)==len(F)
 r=rank_low(U[j] for j in F+S)-len(F);assert r==c['contraction_rank'] and c['physical_span_rank']==r+len(F);assert all(y[m][j]==lam[m] for j in F);left=sum(y[m][j] for j in S);bound=r*lam[m];gap=left-bound;assert gap>0 and Q(c['lambda_mass'])==lam[m] and Q(c['exact_lhs'])==left and Q(c['exact_bound'])==bound and Q(c['exact_violation'])==gap;return gap

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--allocation',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();t=time.monotonic();b=read(a.bank);c=read(a.allocation);receipt=read(a.receipt);assert b['status']=='EXACT_PATTERN_RANK_VIOLATIONS_REQUIRE_REPLAY';assert b['certificate_sha256']==sha(a.allocation) and b['receipt_sha256']==sha(a.receipt);assert receipt['status']=='PASS_EXACT_DIRECT_PATTERN_COUNT_ALLOCATION' and receipt['certificate_sha256']==sha(a.allocation) and receipt['consumer_sha256']==sha(ROOT/'verify_two_basis_direct_allocation.py');ff=a.bank.with_suffix('.frozen.json');assert b['frozen_sha256']==sha(ff) and all(sha(ROOT/p)==h for p,h in b['source_hashes'].items());assert b['producer_sha256']==sha(ROOT/'screen_two_basis_allocation_ranks.py');fp=a.allocation.with_name(a.allocation.name.removesuffix('.json.gz').removesuffix('.json')+'.frozen.json');f=read(fp);assert c['frozen_sha256']==sha(fp)==receipt['frozen_sha256'];assert f['point_sha256']==b['point_sha256']==receipt['point_sha256'];X,Z,_=physical_source();side=f['side'];assert side==b['side'];U=X if side=='X' else Z;dd=[d[side] for d in domains(X,Z,f['X_anchors'],f['Z_anchors'])];lam=list(map(Q,f['lambda_masses']));y=[list(map(Q,r)) for r in c['exact_allocations']];gaps=[row_check(row,U,dd,lam,y) for row in b['cuts']];negative=[]
 for key,value in [('contraction_rank',b['cuts'][0]['contraction_rank']+1),('exact_violation','0'),('lambda_mass','0')]:
  bad=copy.deepcopy(b['cuts'][0]);bad[key]=value
  try:row_check(bad,U,dd,lam,y)
  except AssertionError:negative.append(key)
  else:raise AssertionError('corrupt cut accepted')
 out=dict(status='PASS_EXACT_CONTRACTED_PATTERN_RANK_CUTS',bank_sha256=sha(a.bank),allocation_sha256=sha(a.allocation),allocation_receipt_sha256=sha(a.receipt),point_sha256=b['point_sha256'],consumer_sha256=sha(__file__),dependencies={p:sha(ROOT/p) for p in ['verify_two_sided_full_basis_oracle.py','verify_algebraic_model.py','verify_two_basis_direct_allocation.py']},cuts_checked=len(gaps),violating_patterns=sorted(set(row['mask'] for row in b['cuts'])),minimum_exact_gap=str(min(gaps)),maximum_exact_gap=str(max(gaps)),corruptions_rejected=negative,elapsed_seconds=time.monotonic()-t,scope='All rows are valid contracted zero-matroid rank inequalities and strictly reject this count allocation. No fixed-lambda/global target nonmembership or source case exclusion follows.');a.output.write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out),flush=True)
if __name__=='__main__':main()
