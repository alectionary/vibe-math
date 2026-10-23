"""Secondary finite-sample robustness check for the two frozen interactions.

Maurer-Pontil (COLT 2009), Theorem 4. Each one-sided failure budget is .05/8:
two codes x two disjoint source strata x two tails. Apply to (D+1)/2 in [0,1].
Conditioning on baseline-stratum memberships yields iid observations within
each stratum; summing radii yields interaction intervals. No new noise.
"""
from pathlib import Path
from fractions import Fraction
import hashlib,json,math
HERE=Path(__file__).resolve().parent

def run():
 source=HERE/'entry-confirm-results.json';packet=json.loads(source.read_text());records=[]
 for r in packet['records']:
  strata={}
  for label in ['active','inactive']:
   g=r['interaction'][label];n=g['n'];s=g['lost']-g['gained'];squares=g['lost']+g['gained'];mean=Fraction(s,n)
   assert n>=2 and math.isclose(float(mean),g['difference'],abs_tol=1e-15)
   variance=Fraction(n*squares-s*s,n*(n-1))
   radius=math.sqrt(2*float(variance)*math.log(320)/n)+14*math.log(320)/(3*(n-1))
   strata[label]=dict(n=n,mean=float(mean),sample_variance=float(variance),radius=radius)
  d=strata['active']['mean']-strata['inactive']['mean'];radius=sum(g['radius'] for g in strata.values())
  interval=[d-radius,d+radius];records.append(dict(design=r['design'],difference=d,simultaneous_95_interval=interval,strata=strata))
  print(r['design'],interval,flush=True)
 result=dict(status='secondary_finite_sample_bernstein_intervals',new_noise_patterns=0,
   source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),family_failure_probability=.05,
   one_sided_events=8,one_sided_delta=.05/8,logarithm_argument=320,
   source=dict(authors=['Andreas Maurer','Massimiliano Pontil'],year=2009,
      title='Empirical Bernstein Bounds and Sample Variance Penalization',locator='Theorem 4, PDF page 2',url='https://www.learningtheory.org/colt2009/papers/012.pdf'),
   records=records,limitation='Secondary robustness calculation, not a replacement primary analysis or a Lean proof of the confidence theorem. Does not establish mediation or remove baseline hardness differences.')
 (HERE/'entry-bernstein.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':run()
