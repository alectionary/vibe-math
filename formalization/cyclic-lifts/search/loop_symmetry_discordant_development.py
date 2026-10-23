"""Old syndrome-discordant failures only: initial-color symmetry diagnostic.

No fresh samples or revised holdout classifications. A positive diagnostic
still requires an explicit invariance proof before being called a mechanism.
"""
from pathlib import Path
from collections import Counter
import json,random,time,hashlib
from develop_loop_mechanisms import codes
from merged_mechanism import unpack_bits
from loop_symmetry_development import partition
HERE=Path(__file__).resolve().parent

def run():
 start=time.monotonic();old=json.loads((HERE/'merged-million-results.json').read_text());n=old['independent_noise_patterns'];selections={};flags={}
 for name in ['previous_best','minimum_4']:
  for label in ['original','merged']:
   arm=next(r for r in old['results'] if r['design']==name and r['representation']==label);flags[name,label]=unpack_bits(arm['syndrome_flags_zlib_base64'],n)
  selections[name]=[i for i in range(n) if flags[name,'original'][i]!=flags[name,'merged'][i]]
 indices=set.union(*(set(xs) for xs in selections.values()));rng=random.Random(old['seed']);errors={};stream=hashlib.sha256()
 for i in range(n):
  error=''.join('1' if rng.random()<.04 else '0' for v in range(252))
  if i:stream.update(b'\n')
  stream.update(error.encode())
  if i in indices:errors[i]=error
 assert stream.hexdigest()==old['error_stream_sha256']
 results=[]
 for name,c in codes().items():
  groups={};examples=[]
  for offset,index in enumerate(selections[name]):
   label='original' if flags[name,'original'][index] else 'merged';direction='gained_match' if label=='original' else 'lost_match';found=partition(c[label],errors[index]);g=groups.setdefault(direction,Counter())
   g['cases']+=1;g['candidate_cases']+=bool(found['candidate_checks']);g['non_discrete_variable_partitions']+=found['variable_classes']<252
   if found['candidate_checks'] and sum(e['direction']==direction for e in examples)<2:examples.append(dict(index=index,error=errors[index],representation=label,direction=direction,**found))
   if offset%5000==0:print(name,offset+1,'/',len(selections[name]),'elapsed',time.monotonic()-start,flush=True)
  result=dict(design=name,groups={k:dict(v) for k,v in groups.items()},examples=examples);results.append(result);print(name,result['groups'],flush=True)
 out=dict(status='old_discordant_failure_symmetry_diagnostic_not_frozen_holdout_or_Lean_proof',new_noise_patterns=0,old_error_stream_sha256=stream.hexdigest(),records=results,elapsed_seconds=time.monotonic()-start)
 (HERE/'loop-symmetry-discordant-development.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
