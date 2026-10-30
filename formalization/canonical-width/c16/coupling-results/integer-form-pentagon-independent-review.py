#!/usr/bin/env python3
"""Symbolic32-action polynomial audit, independent of coordinate folding."""
from pathlib import Path
from fractions import Fraction
from collections import Counter
from itertools import product
import hashlib,json,sys,time
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from verify_physical_integer_forms import compile_row,matrix
from verify_projected_profile_moment_rows import point_vector
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def move(e,r,s):
 sector,j=divmod(e,720);orbit,phase=divmod(j,16);return 720*(sector^s)+16*orbit+(phase+r)%16
def add_orbit(poly,events,coefficient):
 for s in (0,1):
  for r in range(16):poly[tuple(sorted({move(e,r,s) for e in events}))]+=coefficient
def main():
 start=time.monotonic();bank=ROOT/'coupling-results/anchor-witness12-pentagon-bank.json';receipt=ROOT/'coupling-results/anchor-witness12-pentagon-independent.json';b=json.loads(bank.read_text());rr=json.loads(receipt.read_text());assert rr['status']=='PASS' and rr['bank_sha256']==sha(bank);point=ROOT/'coupling-results/anchor-witness12-rational.json.gz';assert b['point_sha256']==sha(point);owner=point_vector(point);truth=0;terms=0;gaps=[];maxcoef=0
 for cut in b['cuts']:
  e,w,c=cut['events'],cut['weights'],cut['constant'];raw=Counter();raw[()]=-32*c*(c-1)//2
  for i,(event,v) in enumerate(zip(e,w)):
   add_orbit(raw,[event],-(c*v+v*(v-1)//2))
   for other,u in zip(e[:i],w[:i]):add_orbit(raw,[event,other],-v*u)
  row,rhs=compile_row(cut);folded=Counter();folded[()]=-32*rhs
  for j,v in row.items():
   maxcoef=max(maxcoef,abs(v))
   if j<45:add_orbit(folded,[16*j],v)
   else:
    side,rem=divmod(j-45,18225);h,rem=divmod(rem,2025);i,k=divmod(rem,45);add_orbit(folded,[16*i,720*side+16*k+h],v)
  assert {k:v for k,v in raw.items() if v}=={k:v for k,v in folded.items() if v};terms+=sum(v!=0 for v in raw.values());gap=sum(v*owner[j] for j,v in row.items())-rhs;assert gap==Fraction(cut['exact_violation'])>0;gaps.append(gap)
  for bits in product((0,1),repeat=len(e)):
   L=c+sum(v*x for v,x in zip(w,bits));expanded=c*(c-1)//2+sum((c*v+v*(v-1)//2)*x for v,x in zip(w,bits))+sum(w[i]*w[j]*bits[i]*bits[j] for i in range(len(e)) for j in range(i));assert expanded==L*(L-1)//2>=0;truth+=1
 M,r,metadata=matrix([bank],[receipt]);assert M.shape==(len(b['cuts']),36495)
 for i,gap in enumerate(gaps):
  a,z=M.indptr[i:i+2];assert sum(int(v)*owner[int(j)] for j,v in zip(M.indices[a:z],M.data[a:z]))-int(r[i])==gap
 out=dict(status='PASS_SYMBOLIC_PHYSICAL_INTEGER_FORM_REVIEW',source_C16_answered=False,bank_sha256=sha(bank),receipt_sha256=sha(receipt),point_sha256=sha(point),reviewer_sha256=sha(Path(__file__)),source_hashes={p:sha(ROOT/p) for p in ['physical_integer_form_rows.py','accept_physical_integer_forms.py','verify_physical_integer_forms.py','verify_projected_profile_moment_rows.py']},cuts=len(gaps),truth_assignments=truth,symbolic32_action_polynomials_checked=len(gaps),symbolic_monomial_terms=terms,minimum_exact_violation=str(min(gaps)),maximum_exact_violation=str(max(gaps)),maximum_abs_owner_coefficient=maxcoef,compiled_matrix_nonzeros=int(M.nnz),scope='For integerL=c+sum b_i x_i, binomial(L,2)>=0 universally. ExpandedBooleanpolynomial and32-actionmomentpolynomial agree symbolically for everyacceptedrow; exactpoint12gaps andmatrixrows independentlyreplayed. No sourcegeometryassumption orsourceframeclaim.')
 p=ROOT/'coupling-results/anchor-witness12-pentagon-symbolic-review.json';assert not p.exists();p.write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':main()
