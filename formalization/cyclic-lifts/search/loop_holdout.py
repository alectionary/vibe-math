"""Frozen paired holdout: one million independent errors per existing code."""
from collections import Counter
from pathlib import Path
import json,hashlib,random,tempfile,subprocess,time
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from loop_engine import compile_engine,run_engine
from merged_million import contrast
from loop_development_full import pack16
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
N=1000000;BATCH=10000;SEEDS={'previous_best':90316268011,'minimum_4':90316268012}
LABELS=['original','merged'];CLASSES=['exact','stabilizer','syndrome','logical']
FIELDS=['iterations','cycle_start','cycle_period','cycle_repeat','box_passes','box_check_plus_one','robust_last_plus_one','pinned_check_plus_one','hard_tail_period']

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def freeze():
 paths=[Path(__file__),HERE/'loop_engine.py',HERE/'loop_mechanisms.cpp',HERE/'minsum.cpp',HERE/'benchmark_decoding.py',HERE/'develop_loop_mechanisms.py',HERE/'merged_million.py',HERE/'loop_development_full.py',HERE/'loop_reference.py',HERE/'degree-preserving-results.json',HERE/'distance-matched-selection.json',HERE/'loop-development-results.json',HERE/'loop-development-full-results.json',HERE/'loop-development-validation.json',HERE.parent/'LOOP-DEVELOPMENT-PROTOCOL.md',HERE.parent/'LOOP-HOLDOUT-PROTOCOL.md']
 out=dict(status='frozen_before_holdout_noise_and_outcomes',trials_per_code=N,seeds=SEEDS,p=.04,entry=75,radius=1,sha256={str(p.relative_to(ROOT)):sha(p) for p in paths})
 p=HERE/'loop-holdout-selection.json';assert not p.exists(),'Do not overwrite a frozen holdout selection';p.write_text(json.dumps(out,indent=2)+'\n')
 return out,sha(p)

def mechanism_flags(rec):
 cycle=rec['cycle_period']>0;box=rec['box_check']>=0;pinned=rec['pinned_checks'][0]>=0;robust=rec['robust_tail_last'][0]==100
 return dict(cycle=cycle,box=box,pinned=pinned,primary=cycle or box or pinned,robust=robust)

def run():
 started=time.monotonic();frozen,selection_sha=freeze();results=[];contrasts=[];cohorts=[];batches=[];examples=[];wrapper_checks=0
 with tempfile.TemporaryDirectory(prefix='loop-fresh-holdout-') as tmp:
  binary=Path(tmp)/'loop';stock=Path(tmp)/'stock';compile_engine(binary)
  subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for name,c in codes().items():
   rng=random.Random(SEEDS[name]);stream=hashlib.sha256();zp=b.basis(c['hz']);xm=list(map(b.rowmask,c['original']))
   counts={l:Counter() for l in LABELS};failed={l:bytearray() for l in LABELS};syn={l:bytearray() for l in LABELS};kinds={l:bytearray() for l in LABELS}
   fields={l:{f:[] for f in FIELDS} for l in LABELS};groups={};chosen={};seen=set()
   for offset in range(0,N,BATCH):
    size=min(BATCH,N-offset);errors=[''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for j in range(size)]
    payload='\n'.join(errors).encode();digest=hashlib.sha256(payload).hexdigest()
    if offset:stream.update(b'\n')
    stream.update(payload);trials=[(offset+j,e) for j,e in enumerate(errors)]
    paired={l:run_engine(binary,c[l],trials,profile=0) for l in LABELS}
    if offset==0:
     for l in LABELS:
      terminal=b.engine(stock,c[l],252,[(.04,e) for e in errors[:32]],100,.8)
      assert terminal==[(r['iterations'],bool(r['matched']),r['estimate']) for r in paired[l][:32]];wrapper_checks+=32
    batch_counts={l:Counter() for l in LABELS}
    for j,error in enumerate(errors):
     index=offset+j;word=b.string_mask(error);flags={};terminal={}
     for l in LABELS:
      rec=paired[l][j];assert rec['index']==index
      residual=word^b.string_mask(rec['estimate']);matched=not any(b.syndrome(xm,residual));assert matched==bool(rec['matched'])
      ok=b.in_span(residual,zp);assert not ok or matched
      kind=0 if residual==0 else 1 if ok else 2 if not matched else 3;terminal[l]=kind
      kinds[l].append(kind);failed[l].append(not ok);syn[l].append(not matched)
      batch_counts[l][CLASSES[kind]]+=1;batch_counts[l]['iteration_sum']+=rec['iterations']
      flags[l]=mechanism_flags(rec)
      assert not any(flags[l].values()) or not matched
      for k,v in flags[l].items():batch_counts[l][k]+=v
      batch_counts[l]['fixed']+=rec['cycle_period']==1;batch_counts[l]['periodic']+=rec['cycle_period']>1
      batch_counts[l]['eligible_75']+=rec['iterations']>=75
      values={f:rec[f] for f in ['iterations','cycle_start','cycle_period','cycle_repeat','box_passes','hard_tail_period']}
      values.update(box_check_plus_one=rec['box_check']+1,robust_last_plus_one=rec['robust_tail_last'][0]+1,pinned_check_plus_one=rec['pinned_checks'][0]+1)
      for f,v in values.items():fields[l][f].append(v)
     a,z=terminal['original'],terminal['merged'];direction='lost_syndrome_match' if a!=2 and z==2 else 'gained_syndrome_match' if a==2 and z!=2 else 'both_syndrome_fail' if a==z==2 else 'both_syndrome_match'
     g=groups.setdefault(direction,Counter());g['cases']+=1
     for l in LABELS:
      for k,v in flags[l].items():g[l+'_'+k]+=v
     transition='both_fail' if a>=2 and z>=2 else 'rescued' if a>=2 else 'harmed' if z>=2 else 'both_succeed'
     reasons=[]
     for l in LABELS:
      for mechanism,enabled in flags[l].items():
       for criterion in [l+'/'+mechanism,transition+'/'+l+'/'+mechanism]:
        if enabled and criterion not in seen:seen.add(criterion);reasons.append('first_'+criterion)
     if transition not in seen:seen.add(transition);reasons.append('first_'+transition)
     if reasons:chosen[index]=dict(index=index,error=error,transition=transition,direction=direction,reasons=reasons,records={l:paired[l][j] for l in LABELS})
    for l in LABELS:counts[l].update(batch_counts[l])
    batches.append(dict(design=name,offset=offset,trials=size,error_sha256=digest,arms={l:dict(batch_counts[l]) for l in LABELS}))
    print(name,offset+size,'/',N,'failures',[sum(failed[l]) for l in LABELS],'pinned',[counts[l]['pinned'] for l in LABELS],f'elapsed {time.monotonic()-started:.1f}s',flush=True)
   for index,e in sorted(chosen.items()):
    detail={l:run_engine(binary,c[l],[(index,e['error'])],True,profile=0)[0] for l in LABELS}
    for l in LABELS:
     for k,v in e['records'][l].items():assert detail[l][k]==v
    examples.append(dict(design=name,**e,details=detail))
   for l in LABELS:
    ct=counts[l];assert sum(ct[k] for k in CLASSES)==N
    results.append(dict(design=name,representation=l,trials=N,p=.04,counts=dict(ct),failure_count=sum(failed[l]),failure_rate=sum(failed[l])/N,wilson_95_interval=b.wilson(sum(failed[l]),N),syndrome_count=sum(syn[l]),failure_flags_zlib_base64=b.pack(failed[l]),syndrome_flags_zlib_base64=b.pack(syn[l]),outcome_classes_uint16_le_zlib_base64=pack16(kinds[l]),fields_uint16_le_zlib_base64={f:pack16(xs) for f,xs in fields[l].items()},certificate_coverage_wilson_95={k:b.wilson(ct[k],sum(syn[l])) for k in ['cycle','box','pinned','primary','robust']}))
   contrasts.append(dict(design=name,quantum=contrast(failed['original'],failed['merged']),syndrome=contrast(syn['original'],syn['merged'])))
   cohorts.append(dict(design=name,seed=SEEDS[name],error_stream_sha256=stream.hexdigest(),groups={k:dict(v) for k,v in groups.items()}))
 for rel,digest in frozen['sha256'].items():assert sha(ROOT/rel)==digest,rel
 assert sha(HERE/'loop-holdout-selection.json')==selection_sha
 out=dict(status='frozen_one_million_fresh_paired_errors_per_code',selection_sha256=selection_sha,independent_error_patterns=2*N,primary_decoder_executions=4*N,trials_per_code=N,seeds=SEEDS,p=.04,wrapper_stock_terminal_checks=wrapper_checks,results=results,contrasts=contrasts,cohorts=cohorts,batches=batches,examples=examples,elapsed_seconds=time.monotonic()-started)
 (HERE/'loop-holdout-results.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(contrasts,indent=2),flush=True)
if __name__=='__main__':run()
