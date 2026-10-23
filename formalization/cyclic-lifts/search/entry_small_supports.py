"""Bounded countercheck: source double-odd pairs and one outside extra error.

All 36 source-crossing weight-two errors, and all 8640 weight-three errors
with one error on each source and one outside their union, per fixed code.
These are exhaustive test inputs, not Bernoulli Monte Carlo trials.
"""
from pathlib import Path
from collections import Counter
import itertools,json,subprocess,tempfile,time
import benchmark_decoding as b
from develop_loop_mechanisms import codes
HERE=Path(__file__).resolve().parent

def run():
 start=time.monotonic();records=[]
 with tempfile.TemporaryDirectory(prefix='entry-small-') as tmp:
  binary=Path(tmp)/'stock';subprocess.run(['c++','-O3','-std=c++17',str(HERE/'minsum.cpp'),'-o',str(binary)],check=True)
  for name,c in codes().items():
   a,z=[c['original'][i] for i in c['pair']];outside=sorted(set(range(252))-set(a)-set(z));zp=b.basis(c['hz']);examples={};summaries={};allcases=[]
   for weight in [2,3]:
    supports=[sorted([v,w]) for v in a for w in z] if weight==2 else [sorted([v,w,x]) for v in a for w in z for x in outside]
    counts=Counter();columns={l:[] for l in ['original','merged']};iterations={l:Counter() for l in columns}
    for offset in range(0,len(supports),512):
     batch=supports[offset:offset+512];errors=[''.join('1' if v in support else '0' for v in range(252)) for support in batch]
     paired={l:b.engine(binary,c[l],252,[(.04,e) for e in errors],100,.8) for l in columns}
     for j,error in enumerate(errors):
      kind={}
      for l in columns:
       it,matched,x=paired[l][j];residual=b.string_mask(error)^b.string_mask(x);ok=b.in_span(residual,zp);assert not ok or matched
       kind[l]='success' if ok else 'logical' if matched else 'syndrome';columns[l].append(kind[l]);counts[l+'_'+kind[l]]+=1;iterations[l][it]+=1
      direction=kind['original']+'/'+kind['merged'];counts[direction]+=1
      if direction not in examples:examples[direction]=dict(support=batch[j],error=error,weight=weight,records={l:paired[l][j] for l in columns})
    summaries[str(weight)]=dict(patterns=len(supports),counts=dict(counts),iterations={l:dict(v) for l,v in iterations.items()},outcomes=columns)
    print(name,weight,len(supports),dict(counts),flush=True)
   records.append(dict(design=name,summaries=summaries,examples=examples))
 result=dict(status='exhaustive_source_crossing_small_support_counterchecks',new_monte_carlo_patterns=0,scope='All 36 crossing pairs and all 8640 one-per-source plus one-outside triples per code; no claim to exhaust all weight-three supports.',records=records,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-small-supports.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':run()
