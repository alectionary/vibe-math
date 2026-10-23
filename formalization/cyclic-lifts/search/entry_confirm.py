"""Frozen fresh confirmation, restricted to the unchanged two code comparisons."""
from pathlib import Path
from collections import Counter
from statistics import NormalDist
import base64,hashlib,json,math,random,struct,subprocess,tempfile,time,zlib
import benchmark_decoding as b
from develop_loop_mechanisms import codes
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[2]
N=1000000;BATCH=10000;SEEDS={'previous_best':90316268021,'minimum_4':90316268022}

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def pack(xs):return base64.b64encode(zlib.compress(struct.pack('<'+str(len(xs))+'H',*xs),9)).decode()
def compile_engine(dest):
 source=(HERE/'minsum.cpp').read_text();marker='if (h.syndrome(estimate)==s) return {estimate,it,true};'
 assert source.count(marker)==1
 source=source.replace(marker,'record_first(estimate,it);\n    '+marker)
 prefix='#include <string>\nvoid record_first(const std::string&,int);\n#define main archived_main\n'
 Path(dest).with_suffix('.cpp').write_text(prefix+source+'\n#undef main\n'+(HERE/'entry_confirm.cpp').read_text())
 subprocess.run(['c++','-std=c++17','-O3',str(Path(dest).with_suffix('.cpp')),'-o',str(dest)],check=True)

def run_engine(binary,actual,reference,trials):
 lines=[f'252 {len(actual)} 126 {len(trials)}']
 for rows in [actual,reference]:lines.extend(str(len(r))+' '+' '.join(map(str,r)) for r in rows)
 lines.extend(f'{i} {e}' for i,e in trials)
 p=subprocess.run([str(binary)],input='\n'.join(lines)+'\n',text=True,capture_output=True,check=True)
 assert not p.stderr
 records=[]
 for line in p.stdout.splitlines():
  i,it,matched,estimate,first=line.split();records.append((int(i),int(it),bool(int(matched)),estimate,int(first)))
 assert len(records)==len(trials);return records

def effect(g):
 n=g['trials'];delta=(g['lost']-g['gained'])/n
 variance=(g['lost']+g['gained']-n*delta**2)/(n-1)
 return dict(n=n,difference=delta,standard_error=math.sqrt(variance/n),lost=g['lost'],gained=g['gained'])

def run():
 start=time.monotonic();selection=HERE/'entry-confirm-selection.json';assert not selection.exists(),'Never overwrite the fresh confirmation freeze'
 inputs=[Path(__file__),HERE/'entry_confirm.cpp',HERE/'minsum.cpp',HERE/'develop_loop_mechanisms.py',HERE/'benchmark_decoding.py',HERE/'degree-preserving-results.json',HERE/'distance-matched-selection.json',HERE.parent/'ENTRY-CONFIRM-PROTOCOL.md',HERE/'entry-initial-development.json',HERE/'entry-initial-holdout.json',HERE/'entry-first-round.json']
 frozen=dict(status='frozen_before_independent_confirmation_noise',seeds=SEEDS,trials_per_code=N,primary='conditional syndrome-failure contrast: source-active minus source-inactive, separately for each fixed code',sha256={str(p.relative_to(ROOT)):sha(p) for p in inputs})
 selection.write_text(json.dumps(frozen,indent=2)+'\n');selection_sha=sha(selection)
 records=[];batches=[];examples=[];controls=0
 with tempfile.TemporaryDirectory(prefix='entry-confirm-') as tmp:
  binary=Path(tmp)/'entry';compile_engine(binary);stock=Path(tmp)/'stock';subprocess.run(['c++','-std=c++17','-O3',str(HERE/'minsum.cpp'),'-o',str(stock)],check=True)
  for name,c in codes().items():
   rng=random.Random(SEEDS[name]);stream=hashlib.sha256();zp=b.basis(c['hz']);xm=list(map(b.rowmask,c['original']));source=[c['original'][i] for i in c['pair']]
   arms={l:dict(kinds=[],iterations=[],first=[]) for l in ['original','merged']};strata=[];groups={};chosen=set()
   for offset in range(0,N,BATCH):
    errors=[''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for j in range(BATCH)];payload='\n'.join(errors).encode()
    if offset:stream.update(b'\n')
    stream.update(payload);trials=[(offset+j,e) for j,e in enumerate(errors)]
    paired={l:run_engine(binary,c[l],c['original'],trials) for l in arms}
    if offset==0:
     for l in arms:
      assert b.engine(stock,c[l],252,[(.04,e) for e in errors[:32]],100,.8)==[(r[1],r[2],r[3]) for r in paired[l][:32]];controls+=32
    for j,error in enumerate(errors):
     word=b.string_mask(error);s=[sum(error[v]=='1' for v in row)%2 for row in source];key=str(s[0])+str(s[1]);strata.append(2*s[0]+s[1])
     g=groups.setdefault(key,Counter());g['trials']+=1;kinds={};firsts={}
     for l in arms:
      i,it,matched,estimate,fw=paired[l][j];assert i==offset+j
      residual=word^b.string_mask(estimate);assert matched==(not any(b.syndrome(xm,residual)))
      ok=b.in_span(residual,zp);assert not ok or matched
      kind=0 if residual==0 else 1 if ok else 2 if not matched else 3;kinds[l]=kind;firsts[l]=fw
      arms[l]['kinds'].append(kind);arms[l]['iterations'].append(it);arms[l]['first'].append(fw)
      g[l+'_syndrome']+=kind==2;g[l+'_quantum']+=kind>=2;g[l+'_logical']+=kind==3
     g['lost']+=kinds['original']!=2 and kinds['merged']==2;g['gained']+=kinds['original']==2 and kinds['merged']!=2
     delta=firsts['merged']-firsts['original'];g['first_gap_sum']+=delta;g['first_gap_square_sum']+=delta*delta
     if key=='00':assert delta==0
     direction='lost' if kinds['original']!=2 and kinds['merged']==2 else 'gained' if kinds['original']==2 and kinds['merged']!=2 else 'other'
     for token in [key+'/'+direction]:
      if token not in chosen:
       chosen.add(token);examples.append(dict(design=name,index=offset+j,error=error,stratum=key,direction=direction,records={l:paired[l][j] for l in arms}))
    batches.append(dict(design=name,offset=offset,error_sha256=hashlib.sha256(payload).hexdigest()))
    if offset%100000==0:print(name,offset+BATCH,'/',N,'elapsed',round(time.monotonic()-start,1),flush=True)
   inactive=groups['00'];active=Counter()
   for key in ['01','10','11']:active.update(groups[key])
   ea,ei=effect(active),effect(inactive);delta=ea['difference']-ei['difference'];se=math.hypot(ea['standard_error'],ei['standard_error']);z=NormalDist().inv_cdf(.9875)
   interaction=dict(difference=delta,standard_error=se,bonferroni_simultaneous_95_interval=[delta-z*se,delta+z*se],active=ea,inactive=ei)
   records.append(dict(design=name,trials=N,seed=SEEDS[name],error_stream_sha256=stream.hexdigest(),groups={k:dict(v) for k,v in sorted(groups.items())},interaction=interaction,strata_uint16_le_zlib_base64=pack(strata),arms={l:{key+'_uint16_le_zlib_base64':pack(xs) for key,xs in arm.items()} for l,arm in arms.items()}))
   print('COMPLETE',name,json.dumps(interaction),flush=True)
 for rel,h in frozen['sha256'].items():assert sha(ROOT/rel)==h,rel
 assert sha(selection)==selection_sha
 out=dict(status='fresh_fixed_size_confirmation_complete',selection_sha256=selection_sha,new_independent_noise_patterns=2*N,primary_decoder_executions=4*N,stock_controls=controls,records=records,batches=batches,examples=examples,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-confirm-results.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
