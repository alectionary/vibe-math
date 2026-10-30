from pathlib import Path
from fractions import Fraction
from collections import Counter
from itertools import product
import argparse,hashlib,json,sys,time
C=Path('/private/tmp/c16-coupling-clean-0957/formalization/canonical-width/c16');sys.path.insert(0,str(C))
from verify_physical_integer_forms import compile_row,matrix
from verify_projected_profile_moment_rows import point_vector
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def move(e,r,s):
 sector,j=divmod(e,720);orbit,phase=divmod(j,16);return 720*(sector^s)+16*orbit+(phase+r)%16
def add_orbit(poly,events,coefficient):
 for s in (0,1):
  for r in range(16):poly[tuple(sorted({move(e,r,s) for e in events}))]+=coefficient
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--bank',type=Path,required=True);ap.add_argument('--receipt',type=Path,required=True);ap.add_argument('--point',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();assert not a.output.exists();b=json.loads(a.bank.read_text());rr=json.loads(a.receipt.read_text());assert rr['status']=='PASS' and rr['bank_sha256']==sha(a.bank);assert b['point_sha256']==sha(a.point);owner=point_vector(a.point);truth=terms=0;gaps=[]
 for cut in b['cuts']:
  e,w,c=cut['events'],cut['weights'],cut['constant'];raw=Counter();raw[()]=-32*c*(c-1)//2
  for i,(event,v) in enumerate(zip(e,w)):
   add_orbit(raw,[event],-(c*v+v*(v-1)//2))
   for other,u in zip(e[:i],w[:i]):add_orbit(raw,[event,other],-v*u)
  row,rhs=compile_row(cut);folded=Counter();folded[()]=-32*rhs
  for j,v in row.items():
   if j<45:add_orbit(folded,[16*j],v)
   else:
    side,rem=divmod(j-45,18225);h,rem=divmod(rem,2025);i,k=divmod(rem,45);add_orbit(folded,[16*i,720*side+16*k+h],v)
  assert {k:v for k,v in raw.items() if v}=={k:v for k,v in folded.items() if v};terms+=sum(v!=0 for v in raw.values());gap=sum(v*owner[j] for j,v in row.items())-rhs;assert gap==Fraction(cut['exact_violation'])>0;gaps.append(gap)
  for bits in product((0,1),repeat=len(e)):
   L=c+sum(v*x for v,x in zip(w,bits));expanded=c*(c-1)//2+sum((c*v+v*(v-1)//2)*x for v,x in zip(w,bits))+sum(w[i]*w[j]*bits[i]*bits[j] for i in range(len(e)) for j in range(i));assert expanded==L*(L-1)//2>=0;truth+=1
 M,r,metadata=matrix([a.bank],[a.receipt]);assert M.shape==(len(b['cuts']),36495)
 for i,gap in enumerate(gaps):
  lo,hi=M.indptr[i:i+2];assert sum(int(v)*owner[int(j)] for j,v in zip(M.indices[lo:hi],M.data[lo:hi]))-int(r[i])==gap
 out={'status':'PASS_SYMBOLIC32_INTEGER_FORM_ROWS','cuts':len(gaps),'truth_assignments':truth,'symbolic_monomial_terms':terms,'bank_sha256':sha(a.bank),'point_sha256':sha(a.point),'wrapper_sha256':sha(__file__),'source_C16_answered':False};a.output.write_text(json.dumps(out,indent=2)+'\n');print(out)
if __name__=='__main__':main()
