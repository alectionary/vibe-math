"""Exact Bernoulli-channel expectation of the first-round syndrome-weight gap.

Walsh expansion uses E[(-1)^(row dot error)] = (1-2p)^row_weight.
This is an exact finite calculation, not an eventual-failure predictor.
"""
from pathlib import Path
from fractions import Fraction
from collections import Counter
import json,time
import benchmark_decoding as b
from develop_loop_mechanisms import codes
HERE=Path(__file__).resolve().parent

def walsh(xs):
 ys=xs.copy();step=1
 while step<len(ys):
  for j in range(0,len(ys),2*step):
   for k in range(j,j+step):
    a,z=ys[k],ys[k+step];ys[k]=a+z;ys[k+step]=a-z
  step*=2
 return ys

def exact_polynomial(masks,values):
 transformed=walsh(values);xors=[0]*len(values);coeff=Counter()
 for s,f in enumerate(transformed):
  if s:xors[s]=xors[s&(s-1)]^masks[(s&-s).bit_length()-1]
  if f:coeff[bin(xors[s]).count('1')]+=f
 M=max(coeff,default=0)
 numerator=sum(v*23**w*25**(M-w) for w,v in coeff.items())
 return Fraction(numerator,len(values)*25**M),dict(sorted(coeff.items()))

def run():
 started=time.monotonic();records=[]
 for name,c in codes().items():
  rows=c['original'];a,z=c['pair'];source=set(rows[a]+rows[z]);incident=[[j for j,row in enumerate(rows) if v in row] for v in range(252)]
  assert all(len(es)==3 for es in incident) and set(rows[a]).isdisjoint(rows[z])
  affected=[j for j,row in enumerate(rows) if source.intersection(row)]
  totals={key:Fraction(0) for key in ['00','01','10','11']};details=[]
  for check in affected:
   ids=sorted(set([a,z,check]+[i for v in rows[check] for i in incident[v]]));lookup={v:i for i,v in enumerate(ids)}
   masks=[b.rowmask(rows[j]) for j in ids];size=1<<len(ids)
   values={key:[0]*size for key in totals}
   for assignment in range(size):
    syn=lambda j:(assignment>>lookup[j])&1
    old=merged=syn(check)
    for v in rows[check]:
     old^=int(all(syn(j) for j in incident[v]))
     merged^=int(all((syn(a)^syn(z)) if j in [a,z] else syn(j) for j in incident[v]))
    values[str(syn(a))+str(syn(z))][assignment]=merged-old
   row=dict(check=check,original_syndrome_coordinates=ids,expectation_numerators_by_stratum={},walsh_coefficients_by_stratum={})
   for key,xs in values.items():
    expectation,coeff=exact_polynomial(masks,xs);totals[key]+=expectation
    row['expectation_numerators_by_stratum'][key]=[expectation.numerator,expectation.denominator]
    row['walsh_coefficients_by_stratum'][key]=coeff
   details.append(row)
  odd=Fraction(1,2)*(1-Fraction(23,25)**6)
  probabilities={'00':(1-odd)**2,'01':odd*(1-odd),'10':odd*(1-odd),'11':odd**2}
  result=dict(design=name,changed_original_checks=affected,source_checks=[a,z],unconditional_expected_gap=float(sum(totals.values())),exact_unconditional_gap=[sum(totals.values()).numerator,sum(totals.values()).denominator],strata={key:dict(probability=float(probabilities[key]),joint_gap=float(x),conditional_gap=float(x/probabilities[key]),exact_joint_gap=[x.numerator,x.denominator]) for key,x in totals.items()},details=details)
  records.append(result);print(name,'E[merged-original initial syndrome defects]=',result['unconditional_expected_gap'],'strata=',result['strata'],flush=True)
 out=dict(status='exact_rational_first_round_expectation',p_numerator=1,p_denominator=25,new_noise_patterns=0,formalization_limit='The existing Lean first-round threshold proves the decision rule; this Fourier expectation calculation is independently checked arithmetic, not a Lean probability theorem.',records=records,elapsed_seconds=time.monotonic()-started)
 (HERE/'entry-first-round.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
