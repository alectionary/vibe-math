"""Full old-sample failure audit; mechanism definitions remain development-only."""
from pathlib import Path
from collections import Counter
import base64,json,random,tempfile,time,zlib,struct
import benchmark_decoding as b
from merged_mechanism import unpack_bits
from loop_engine import compile_engine,run_engine
from develop_loop_mechanisms import codes
HERE=Path(__file__).resolve().parent
FIELDS=['iterations','cycle_start','cycle_period','cycle_repeat','box_passes','hard_tail_period']

def pack16(values):return base64.b64encode(zlib.compress(struct.pack('<'+str(len(values))+'H',*values),9)).decode()

def run():
 start=time.monotonic();old=json.loads((HERE/'merged-million-results.json').read_text());n=old['independent_noise_patterns'];selected={};syns={};iters={}
 for rec in old['results']:
  key=rec['design'],rec['representation'];syn=unpack_bits(rec['syndrome_flags_zlib_base64'],n);it=zlib.decompress(base64.b64decode(rec['iterations_zlib_base64']))
  syns[key]=syn;iters[key]=it
  selected[key]=set(i for i,x in enumerate(syn) if x or it[i]>=75)
  selected[key].update([i for i,x in enumerate(syn) if not x][:32])
 union=set.union(*selected.values());errors={};rng=random.Random(old['seed'])
 for i in range(n):
  error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
  if i in union:errors[i]=error
 results=[]
 with tempfile.TemporaryDirectory(prefix='loop-old-full-') as tmp:
  binary=Path(tmp)/'loop';compile_engine(binary)
  for name,c in codes().items():
   for label in ['original','merged']:
    key=name,label;indices=sorted(selected[key]);columns={f:[] for f in FIELDS+['box_check_plus_one','robust_last_plus_one','pinned_check_plus_one']};counts=Counter();examples={};witnesses=[]
    for start_batch in range(0,len(indices),512):
     trials=[(i,errors[i]) for i in indices[start_batch:start_batch+512]]
     records=run_engine(binary,c[label],trials,profile=0)
     for (i,error),rec in zip(trials,records):
      assert rec['index']==i and rec['matched']==(not syns[key][i]) and rec['iterations']==iters[key][i]
      kind='success' if rec['matched'] else 'failure';counts[kind]+=1
      if rec['robust_tail_last'][0]==100:assert not rec['matched']
      values={f:rec[f] for f in FIELDS};values.update(box_check_plus_one=rec['box_check']+1,robust_last_plus_one=rec['robust_tail_last'][0]+1,pinned_check_plus_one=rec['pinned_checks'][0]+1)
      for f in columns:columns[f].append(values[f])
      for criterion,value in [('fixed',rec['cycle_period']==1),('periodic',rec['cycle_period']>1),('box',rec['box_check']>=0),('robust',rec['robust_tail_last'][0]==100),('pinned',rec['pinned_checks'][0]>=0),('hard_only',rec['hard_tail_period']>0 and rec['cycle_period']==0)]:
       if value:
        counts[criterion]+=1
        if criterion not in examples:examples[criterion]=i
      if rec['pinned_checks'][0]>=0:
       other='merged' if label=='original' else 'original'
       if not syns[name,other][i] and 'discordant_pinned' not in examples:examples['discordant_pinned']=i
     if start_batch%4096==0:print(name,label,start_batch+len(trials),'/',len(indices),'elapsed',time.monotonic()-start,flush=True)
    details=run_engine(binary,c[label],[(i,errors[i]) for i in sorted(set(examples.values()))],True,profile=0)
    results.append(dict(design=name,representation=label,counts=dict(counts),indices=indices,fields_uint16_le_zlib_base64={f:pack16(xs) for f,xs in columns.items()},example_indices=examples,witnesses=details))
    print('COMPLETE',name,label,dict(counts),'elapsed',time.monotonic()-start,flush=True)
 result=dict(status='full_existing_sample_development_failures_and_all_late_successes',seed=old['seed'],new_noise_patterns=0,entry_iteration=75,radius=1,selection='all old syndrome failures, all successes reaching iteration 75, first 32 successes per arm',records=results,elapsed_seconds=time.monotonic()-start)
 (HERE/'loop-development-full-results.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':run()
