"""Bounded old-data-only screen for an equitable-partition parity obstruction.

This is exploratory development, not a revision of the frozen holdout detector.
A positive partition certificate requires a separate Lean invariance proof.
"""
from pathlib import Path
from collections import Counter
import json,random,time
from develop_loop_mechanisms import codes
HERE=Path(__file__).resolve().parent

def classify(keys):
 lookup={};return [lookup.setdefault(key,len(lookup)) for key in keys]

def partition(rows,error):
 n=252;ve=[[] for v in range(n)]
 for c,row in enumerate(rows):
  for v in row:ve[v].append(c)
 target=[sum(error[v]=='1' for v in row)%2 for row in rows]
 vc=[0]*n;cc=classify([(target[c],len(row)) for c,row in enumerate(rows)])
 rounds=0
 for iteration in range(1,n+len(rows)+1):
  nv=classify([(vc[v],tuple(sorted(cc[c] for c in ve[v]))) for v in range(n)])
  nc=classify([(cc[c],tuple(sorted(vc[v] for v in row))) for c,row in enumerate(rows)])
  rounds=iteration
  if nv==vc and nc==cc:break
  vc,cc=nv,nc
 else:raise AssertionError('Refinement did not stabilize')
 candidates=[c for c,row in enumerate(rows) if target[c] and all(k%2==0 for k in Counter(vc[v] for v in row).values())]
 return dict(rounds=rounds,variable_classes=len(set(vc)),check_classes=len(set(cc)),candidate_checks=candidates,variable_colors=vc,check_colors=cc)

def run():
 start=time.monotonic();old=json.loads((HERE/'loop-development-results.json').read_text());records=old['records'];indices=set(i['index'] for r in records for i in r['records']);rng=random.Random(old['seed']);errors={}
 for i in range(max(indices)+1):
  error=''.join('1' if rng.random()<.04 else '0' for v in range(252))
  if i in indices:errors[i]=error
 results=[]
 for name,code in codes().items():
  for label in ['original','merged']:
   rec=next(r for r in records if r['design']==name and r['representation']==label);counts=Counter();examples=[]
   for row in rec['records']:
    found=partition(code[label],errors[row['index']]);counts['cases']+=1;counts['failures']+=not row['matched'];counts['successes']+=bool(row['matched']);counts['candidate_cases']+=bool(found['candidate_checks'])
    if found['candidate_checks']:
     assert not row['matched'],'Potential obstruction condition conflicts with an observed success'
     if len(examples)<3:examples.append(dict(index=row['index'],error=errors[row['index']],**found))
   result=dict(design=name,representation=label,counts=dict(counts),examples=examples);results.append(result);print(name,label,dict(counts),flush=True)
 out=dict(status='exploratory_old_data_partition_screen_not_frozen_holdout_or_Lean_proof',new_noise_patterns=0,selection=old['selection'],records=results,elapsed_seconds=time.monotonic()-start)
 (HERE/'loop-symmetry-development.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
