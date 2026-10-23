"""Development only: existing seed, no new holdout data."""
from pathlib import Path
from collections import Counter
import json,random,tempfile,time,hashlib
import benchmark_decoding as b
from merged_mechanism import unpack_bits
from loop_engine import compile_engine,run_engine
HERE=Path(__file__).resolve().parent

def codes():
 source=json.loads((HERE/'distance-matched-selection.json').read_text());merged=json.loads((HERE/'degree-preserving-results.json').read_text())
 out={}
 for name in ['previous_best','minimum_4']:
  hx,hz,_=b.construction(source['codes'][name]['B'],14);rec=next(r for r in merged['records'] if r['design']==name)
  out[name]=dict(original=hx,merged=rec['hx_rows'],hz=hz,pair=rec['representative_pair'])
 return out

def run():
 start=time.monotonic();old=json.loads((HERE/'merged-million-results.json').read_text());n=old['independent_noise_patterns'];selected={};arms={}
 for r in old['results']:
  key=r['design'],r['representation'];syn=unpack_bits(r['syndrome_flags_zlib_base64'],n)
  indices=[i for i,x in enumerate(syn) if x][:256]+[i for i,x in enumerate(syn) if not x][:32]
  selected[key]=set(indices);arms[key]=r
 union=set.union(*selected.values());errors={};rng=random.Random(old['seed'])
 for i in range(max(union)+1):
  error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
  if i in union:errors[i]=error
 out=[]
 with tempfile.TemporaryDirectory(prefix='loop-development-') as tmp:
  binary=Path(tmp)/'loop';compile_engine(binary)
  for name,c in codes().items():
   for label in ['original','merged']:
    key=name,label;trials=[(i,errors[i]) for i in sorted(selected[key])]
    records=run_engine(binary,c[label],trials)
    counts=Counter();chosen={}
    for rec in records:
     kind='success' if rec['matched'] else 'failure';counts[kind]+=1
     for k,last in enumerate(rec['robust_tail_last']):
      if last==100:counts['robust_'+str(k)]+=1
     for k,check in enumerate(rec['pinned_checks']):
      if check>=0:counts['pinned_'+str(k)]+=1
     for criterion,value in [('fixed',rec['cycle_period']==1),('periodic',rec['cycle_period']>1),('box',rec['box_check']>=0),('hard_only',rec['hard_tail_period']>0 and rec['cycle_period']==0)]:
      if value:
       counts[criterion]+=1
       chosen.setdefault(criterion,rec['index'])
    details=run_engine(binary,c[label],[(i,errors[i]) for i in sorted(set(chosen.values()))],True)
    out.append(dict(design=name,representation=label,counts=dict(counts),records=records,witnesses=details))
    print(name,label,dict(counts),'elapsed',time.monotonic()-start,flush=True)
 result=dict(status='development_existing_noise_only',seed=old['seed'],selection='first 256 syndrome failures and first 32 syndrome successes per arm',new_noise_patterns=0,records=out,elapsed_seconds=time.monotonic()-start)
 (HERE/'loop-development-results.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':run()
