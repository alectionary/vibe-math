"""Predefined initial-source-syndrome strata; no decoder/noise changes.

Hypothesis fixed before extraction: replacing two odd source syndromes by their
even XOR can supply an initial progress disadvantage. All four strata and both
directions are retained. Conditional contrasts are descriptive, not mediation.
"""
from pathlib import Path
from collections import Counter
import hashlib,json,random,sys
from develop_loop_mechanisms import codes
from merged_mechanism import unpack_bits
from merged_million import contrast
HERE=Path(__file__).resolve().parent

def run(mode):
 assert mode in ['development','holdout']
 selection=HERE/'entry-initial-selection.json'
 hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in [Path(__file__),HERE/'minsum.cpp',HERE/'develop_loop_mechanisms.py']}
 if mode=='development':assert not selection.exists()
 else:assert json.loads(selection.read_text())['sha256']==hashes
 main=json.loads((HERE/('merged-million-results.json' if mode=='development' else 'loop-holdout-results.json')).read_text())
 out=[];N=1000000
 for name,c in codes().items():
  arms={r['representation']:r for r in main['results'] if r['design']==name}
  syn={l:unpack_bits(r['syndrome_flags_zlib_base64'],N) for l,r in arms.items()}
  fail={l:unpack_bits(r['failure_flags_zlib_base64'],N) for l,r in arms.items()}
  seed=main['seed'] if mode=='development' else main['seeds'][name]
  rng=random.Random(seed);stream=hashlib.sha256();groups={}
  source=[c['original'][i] for i in c['pair']]
  for index in range(N):
   error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
   if index:stream.update(b'\n')
   stream.update(error.encode())
   a,b=[sum(error[v]=='1' for v in row)%2 for row in source]
   key=str(a)+str(b);g=groups.setdefault(key,Counter());g['trials']+=1
   for l in arms:g[l+'_syndrome']+=syn[l][index];g[l+'_quantum']+=fail[l][index]
   g['lost']+=not syn['original'][index] and syn['merged'][index]
   g['gained']+=syn['original'][index] and not syn['merged'][index]
  expected=main['error_stream_sha256'] if mode=='development' else next(r for r in main['cohorts'] if r['design']==name)['error_stream_sha256']
  assert stream.hexdigest()==expected
  for g in groups.values():g['net_syndrome']=g['lost']-g['gained'];assert g['net_syndrome']==g['merged_syndrome']-g['original_syndrome']
  out.append(dict(design=name,seed=seed,error_stream_sha256=stream.hexdigest(),groups={k:dict(v) for k,v in sorted(groups.items())}))
  print(mode,name,json.dumps(out[-1]['groups']),flush=True)
 result=dict(status='predefined_initial_syndrome_strata',mode=mode,new_noise_patterns=0,hypothesis='The 11 -> 0 initial syndrome annihilation may disproportionately contribute to the syndrome penalty.',records=out)
 path=HERE/f'entry-initial-{mode}.json';path.write_text(json.dumps(result,indent=2)+'\n')
 if mode=='development':selection.write_text(json.dumps(dict(status='fixed_initial_strata_before_existing_holdout_extraction',sha256=hashes,development_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),strata=['00','01','10','11'],limitation='Secondary analysis of existing known-outcome holdout, not new confirmatory noise.'),indent=2)+'\n')
if __name__=='__main__':run(sys.argv[1])
