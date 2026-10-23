"""Exact physical-bit XOR convolution, independent of the Walsh calculation."""
from pathlib import Path
from collections import Counter
from fractions import Fraction
import json,sys,time
ROOT=Path(__file__).resolve().parents[1];HERE=ROOT/'formalization/cyclic-lifts/search';sys.path.insert(0,str(HERE))
import benchmark_decoding as b
from develop_loop_mechanisms import codes

def expectation(code,check):
 old,new=code['original'],code['merged'];a,z=code['pair'];variables=old[check]
 old_inc=[[i for i,r in enumerate(old) if v in r] for v in variables]
 new_inc=[[i for i,r in enumerate(new) if v in r] for v in variables]
 om=list(map(b.rowmask,old));nm=list(map(b.rowmask,new))
 masks=sorted(set([om[check],om[a],om[z]]+[om[i] for es in old_inc for i in es]+[nm[i] for es in new_inc for i in es]))
 lookup={v:i for i,v in enumerate(masks)};k=len(masks);columns=Counter()
 for v in range(252):
  col=sum(1<<j for j,mask in enumerate(masks) if (mask>>v)&1)
  if col:columns[col]+=1
 dist=[0]*(1<<k);dist[0]=1;degree=0
 for col,multiplicity in columns.items():
  even=(25**multiplicity+23**multiplicity)//2;odd=(25**multiplicity-23**multiplicity)//2
  dist=[even*x+odd*dist[i^col] for i,x in enumerate(dist)];degree+=multiplicity
 assert sum(dist)==25**degree
 totals={key:0 for key in ['00','01','10','11']}
 for assignment,mass in enumerate(dist):
  if not mass:continue
  bit=lambda mask:(assignment>>lookup[mask])&1
  o=m=bit(om[check])
  for os,ms in zip(old_inc,new_inc):
   # Independently use numerical first posteriors, not the conjunction formula.
   op=3332431+sum(-2665945 if bit(om[i]) else 2665945 for i in os)
   mp=3332431+sum(-2665945 if bit(nm[i]) else 2665945 for i in ms)
   o^=int(op<0);m^=int(mp<0)
  key=str(bit(om[a]))+str(bit(om[z]));totals[key]+=(m-o)*mass
 return {key:Fraction(v,25**degree) for key,v in totals.items()},k,len(columns),degree

def run():
 start=time.monotonic();source=json.loads((HERE/'entry-first-round.json').read_text());checks=0;maxdim=0
 for packet in source['records']:
  code=codes()[packet['design']]
  for row in packet['details']:
   got,k,groups,bits=expectation(code,row['check']);maxdim=max(maxdim,k)
   for key,value in got.items():assert value==Fraction(*row['expectation_numerators_by_stratum'][key]),(packet['design'],row['check'],key)
   checks+=1
   if checks%8==0:print(checks,'exact physical-bit convolutions PASS; elapsed',round(time.monotonic()-start,1),flush=True)
 out=dict(status='exact_expectation_independently_matches_physical_bit_convolution',original_checks_verified=checks,stratum_expectations_verified=4*checks,maximum_joint_syndrome_coordinates=maxdim,new_noise_patterns=0,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-expectation-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(out,flush=True)
if __name__=='__main__':run()
