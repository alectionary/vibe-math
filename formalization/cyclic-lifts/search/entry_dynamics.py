"""Old-data development then frozen secondary analysis of the existing holdout.

This selects syndrome-discordant pairs retrospectively. Direction concordance
within that cohort is not population failure prediction or causal attribution.
Counterfactual single updates are diagnostics, never fed back into decoding.
"""
from pathlib import Path
from collections import Counter
import base64,hashlib,json,random,struct,subprocess,sys,tempfile,time,zlib
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from merged_mechanism import unpack_bits
from merged_state_engine import data

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[2]
FIELDS=['original_weight','merged_weight','split_on_merged_weight','original_cumulative','merged_cumulative','split_on_merged_cumulative','direct_bit_changes','paired_bit_changes','propagated_bit_changes','original_flips','merged_flips','original_pinned_last5','merged_pinned_last5','original_low_margin','merged_low_margin','direct_message_l1','propagated_message_l1']
CHECKPOINTS=[5,10,25]
RULES={'weight':lambda x:x[1]-x[0], 'cumulative':lambda x:x[4]-x[3],
       'propagated_cumulative':lambda x:x[5]-x[3], 'pinned':lambda x:x[12]-x[11]}

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def pack(xs):return base64.b64encode(zlib.compress(struct.pack('<'+str(len(xs))+'q',*xs),9)).decode()
def compile_engine(dest):
 source=(HERE/'minsum.cpp').read_text()
 before='for (int it=1; it<=max_iter; ++it) {'
 after='if (h.syndrome(estimate)==s) return {estimate,it,true};'
 assert source.count(before)==source.count(after)==1
 source=source.replace(before,before+'\n    save_input(q,it);').replace(after,'save_output(message,estimate,it);\n    '+after)
 pre='''#include <vector>
#include <string>
#include <cstdint>
struct Snapshot {std::vector<int64_t> q,r;std::string estimate;};
std::vector<Snapshot>* active_states=nullptr;std::vector<int64_t> current_input;
void save_input(const std::vector<int64_t>&q,int it){if(active_states&&it<=25)current_input=q;}
void save_output(const std::vector<int64_t>&r,const std::string&x,int it){if(active_states&&it<=25)active_states->push_back({current_input,r,x});}
#define main archived_single_main
'''
 path=Path(dest).with_suffix('.cpp');path.write_text(pre+source+'\n#undef main\n'+(HERE/'entry_dynamics.cpp').read_text())
 subprocess.run(['c++','-std=c++17','-O3',str(path),'-o',str(dest)],check=True)

def metrics(rows,rule,t):
 c=Counter();strata={}
 for rec in rows:
  if min(rec['iterations'])<=t:continue
  x=rec['features'][str(t)];score=RULES[rule](x);direction=rec['lost']
  key='merged_worse' if score>0 else 'original_worse' if score<0 else 'tie'
  d=strata.setdefault(key,Counter());d['lost' if direction else 'gained']+=1
  c['lost' if direction else 'gained']+=1
  if score==0:c['ties_lost' if direction else 'ties_gained']+=1
  elif (score>0)==direction:c['correct_lost' if direction else 'correct_gained']+=1
  else:c['wrong_lost' if direction else 'wrong_gained']+=1
 sensitivity=(c['correct_lost']+.5*c['ties_lost'])/c['lost'] if c['lost'] else None
 specificity=(c['correct_gained']+.5*c['ties_gained'])/c['gained'] if c['gained'] else None
 return dict(counts=dict(c),balanced_concordance=(sensitivity+specificity)/2 if sensitivity is not None and specificity is not None else None,strata={k:dict(v,net=v['lost']-v['gained']) for k,v in strata.items()})

def run(mode):
 assert mode in ['development','holdout'];start=time.monotonic()
 paths=[Path(__file__),HERE/'entry_dynamics.cpp',HERE/'minsum.cpp',HERE/'benchmark_decoding.py',HERE/'develop_loop_mechanisms.py',HERE/'merged_state_engine.py']
 hashes={str(p.relative_to(ROOT)):sha(p) for p in paths}
 freeze=HERE/'entry-dynamics-selection.json'
 if mode=='holdout':
  frozen=json.loads(freeze.read_text());assert hashes==frozen['sha256']
 else:assert not freeze.exists(),'Preserve the frozen secondary-analysis definition'
 old=json.loads((HERE/('merged-million-results.json' if mode=='development' else 'loop-holdout-results.json')).read_text())
 N=1000000;allrows=[];results=[];retained=[];replayed=0
 with tempfile.TemporaryDirectory(prefix='entry-dynamics-') as tmp:
  binary=Path(tmp)/'entry';compile_engine(binary)
  for name,c in codes().items():
   arm={r['representation']:r for r in old['results'] if r['design']==name}
   syn={l:unpack_bits(r['syndrome_flags_zlib_base64'],N) for l,r in arm.items()}
   if mode=='development':its={l:list(zlib.decompress(base64.b64decode(r['iterations_zlib_base64']))) for l,r in arm.items()}
   else:its={l:struct.unpack('<1000000H',zlib.decompress(base64.b64decode(r['fields_uint16_le_zlib_base64']['iterations']))) for l,r in arm.items()}
   indices={i for i in range(N) if syn['original'][i]!=syn['merged'][i]}
   seed=old['seed'] if mode=='development' else old['seeds'][name]
   expected=old['error_stream_sha256'] if mode=='development' else next(r for r in old['cohorts'] if r['design']==name)['error_stream_sha256']
   rng=random.Random(seed);stream=hashlib.sha256();trials=[]
   for i in range(N):
    error=''.join('1' if rng.random()<.04 else '0' for _ in range(252))
    if i:stream.update(b'\n')
    stream.update(error.encode())
    if i in indices:trials.append((i,error))
   assert stream.hexdigest()==expected
   rows=[];profiles={};check_examples={};first_indices=[]
   for offset in range(0,len(trials),256):
    batch=trials[offset:offset+256]
    p=subprocess.run([str(binary)],input=data(c['original'],c['merged'],c['pair'],batch),text=True,capture_output=True,check=True)
    assert not p.stderr;records=[json.loads(line) for line in p.stdout.splitlines()];assert len(records)==len(batch)
    for (i,error),r in zip(batch,records):
     assert r['index']==i
     for l in ['original','merged']:assert r[l][0]==its[l][i] and bool(r[l][1])==not_bool(syn[l][i])
     lost=bool(r['original'][1]);features={str(t):r['steps'][t-1] for t in CHECKPOINTS if len(r['steps'])>=t}
     rec=dict(index=i,lost=lost,iterations=[r['original'][0],r['merged'][0]],features=features);rows.append(rec)
     for k,x in enumerate(r['steps'],1):
      if min(rec['iterations'])<=k:continue
      key=('lost' if lost else 'gained')+'/'+str(k);q=profiles.setdefault(key,Counter());q['cases']+=1
      for j,f in enumerate(FIELDS):q[f]+=x[j]
     key='lost' if lost else 'gained'
     if key not in check_examples:
      check_examples[key]=i;retained.append(dict(design=name,error=error,**r))
    replayed+=len(batch)*2
    if offset%4096==0:print(mode,name,offset+len(batch),'/',len(trials),'elapsed',round(time.monotonic()-start,1),flush=True)
   allrows.extend(rows)
   metrics_by_checkpoint={str(t):{rule:metrics(rows,rule,t) for rule in RULES} for t in CHECKPOINTS}
   flat=[]
   for r in rows:
    flat.extend([r['index'],int(r['lost']),*r['iterations']])
    for t in CHECKPOINTS:flat.extend(r['features'].get(str(t),[-1]*len(FIELDS)))
   results.append(dict(design=name,seed=seed,error_stream_sha256=stream.hexdigest(),pairs=len(rows),stride=4+3*len(FIELDS),packed_int64_le_zlib_base64=pack(flat),metrics=metrics_by_checkpoint,profiles={k:dict(v) for k,v in profiles.items()}))
  pooled={rule:metrics(allrows,rule,10) for rule in RULES}
  if mode=='development':
   chosen=max(RULES,key=lambda rule:pooled[rule]['balanced_concordance'])
  else:chosen=frozen['chosen_rule']
  out=dict(status='development_old_only' if mode=='development' else 'frozen_secondary_existing_holdout_check',new_noise_patterns=0,selection='all syndrome-discordant pairs; direction concordance restricted to both trajectories still active after checkpoint',checkpoints=CHECKPOINTS,fields=FIELDS,chosen_rule=chosen,pooled_iteration10=pooled,records=results,retained=retained,primary_decoder_replays=replayed,elapsed_seconds=time.monotonic()-start,sha256=hashes)
  path=HERE/f'entry-dynamics-{mode}.json';path.write_text(json.dumps(out,indent=2)+'\n')
  if mode=='development':
   freeze.write_text(json.dumps(dict(status='frozen_after_old_data_before_secondary_holdout_feature_extraction',checkpoint=10,chosen_rule=chosen,development_sha256=sha(path),rules=list(RULES),sha256=hashes,limitation='Existing holdout terminal outcomes and late certificates were previously examined; this is new fixed secondary analysis, not an untouched confirmatory experiment.'),indent=2)+'\n')
  print('COMPLETE',mode,chosen,json.dumps(pooled[chosen]),flush=True)

def not_bool(x):return not bool(x)
if __name__=='__main__':run(sys.argv[1])
