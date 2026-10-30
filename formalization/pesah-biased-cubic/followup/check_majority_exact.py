"""Independent rational convolution check of saved ideal-majority predictions."""
from fractions import Fraction
from pathlib import Path
import json, time, resource
R=Path(__file__).resolve().parent
start=time.perf_counter(); rows=[]; max_error=0
source=json.loads((R.parent/'expansion/sector-limits.json').read_text())
for item in source['rows']:
 L=item['L']
 if L>10: continue
 p=Fraction(str(item['p'])); outcomes={}
 for label,m,N in [('cubic_pure_Z_ideal_point',L,L*L),('cubic_pure_X_ideal_loop',L*L,L)]:
  # Bernoulli polynomial convolution; no SciPy, binomial coefficient or CDF.
  mass=[Fraction(1)]
  for _ in range(m):
   nxt=[Fraction(0)]*(len(mass)+1)
   for k,value in enumerate(mass): nxt[k]+=value*(1-p);nxt[k+1]+=value*p
   mass=nxt
  assert sum(mass)==1
  q=sum(mass[m//2+1:])+(mass[m//2]/2 if m%2==0 else 0)
  # Independent two-state parity recursion, not the closed-form production expression.
  odd=Fraction(0)
  for _ in range(N): odd=odd*(1-q)+(1-odd)*q
  err=abs(float(odd)-item[label]);assert err<2e-14;max_error=max(max_error,err)
  outcomes[label]=float(odd)
 rows.append(dict(L=L,p=float(p),**outcomes))
out=dict(rows=rows,comparisons=2*len(rows),maximum_absolute_error=max_error,tolerance=2e-14,seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,scope='Exact rational Bernoulli polynomial convolution and parity recursion versus frozen SciPy binomial predictions. Shared model, sizes and probabilities; independent arithmetic and probability evaluation. Tolerance concerns floating-point evaluation, not statistical uncertainty. Independent errors and independent unbiased ties are required; no BP-OSD threshold is established.')
(R/'majority-exact-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='rows'},indent=2))
