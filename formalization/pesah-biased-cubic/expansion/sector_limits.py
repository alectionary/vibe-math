"""Exact finite Bernoulli calculations for ideal restricted-sector decoders.

These are optimal-majority sector predictions, not BP-OSD threshold estimates.
"""
import json,pathlib
from scipy.stats import binom

def majority(n,p):return float(binom.sf(n//2,n,p)+(.5*binom.pmf(n//2,n,p) if n%2==0 else 0))
rows=[]
for L in [4,6,8,10,20,40,80,160]:
 for p in [.1,.2,.3,.4,.49,.5]:
  chain=majority(L,p);plane=majority(L*L,p)
  rows.append(dict(L=L,p=p,cubic_pure_Z_ideal_point=(1-(1-2*chain)**(L*L))/2,cubic_pure_X_ideal_loop=(1-(1-2*plane)**L)/2))
pathlib.Path(__file__).with_name('sector-limits.json').write_text(json.dumps(dict(rows=rows,assumptions='Independent Bernoulli errors, periodic equal dimensions, minimum-weight majority per connected chain/plane with unbiased tie breaking. Logical error is parity of independently miscorrected homologous chains/planes. Not an assertion that BP-OSD realizes this decoder.',asymptotic='For fixed p<1/2, Hoeffding q_m <= exp(-2m(1/2-p)^2); parity failure <= number_of_components*q_m, giving zero limit for L^2 chains lengthL or L planes areaL^2. At p=1/2 each component is ambiguous and logical parity failure=1/2.'),indent=2)+'\n')
