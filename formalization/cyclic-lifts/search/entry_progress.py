"""Secondary baseline-hardness controls and first-gap strata, old and fresh.

This is not a new confirmatory estimand: primary confirmation is entry_confirm.
The fixed central-weight range is 5..16. The joint baseline table uses cells
with at least 100 observations in each source-activity class, chosen by counts
alone, not decoding outcomes. Report retained population mass and all cells.
"""
from pathlib import Path
from collections import Counter
from statistics import NormalDist
import base64,hashlib,json,math,random,struct,subprocess,tempfile,time,zlib
import benchmark_decoding as b
from develop_loop_mechanisms import codes
from merged_mechanism import unpack_bits
HERE=Path(__file__).resolve().parent

def unpack(s):
 raw=zlib.decompress(base64.b64decode(s));return struct.unpack('<'+str(len(raw)//2)+'H',raw)
def pack(xs):return base64.b64encode(zlib.compress(struct.pack('<'+str(len(xs))+'H',*xs),9)).decode()
def compile_engine(dest):
 Path(dest).with_suffix('.cpp').write_text('#define main archived_main\n'+(HERE/'minsum.cpp').read_text()+'\n#undef main\n'+(HERE/'entry_progress.cpp').read_text())
 subprocess.run(['c++','-O3','-std=c++17',str(Path(dest).with_suffix('.cpp')),'-o',str(dest)],check=True)
def aggregate(rows):
 n=sum(v['trials'] for v in rows);return n
def standardized(cells):
 total=sum(v[0]['trials']+v[1]['trials'] for v in cells.values());selected={k:v for k,v in cells.items() if min(v[0]['trials'],v[1]['trials'])>=100}
 mass=sum(v[0]['trials']+v[1]['trials'] for v in selected.values());delta=var=0
 for g in selected.values():
  weight=(g[0]['trials']+g[1]['trials'])/mass;differences=[];variances=[]
  for key in [0,1]:
   n=g[key]['trials'];d=g[key]['sum']/n;differences.append(d);variances.append((g[key]['square_sum']-n*d*d)/(n*(n-1)))
  delta+=weight*(differences[1]-differences[0]);var+=weight*weight*sum(variances)
 return dict(secondary=True,cell_count=len(selected),retained_pairs=mass,total_pairs_in_range=total,retained_fraction_of_million=mass/1000000,standardized_active_minus_inactive=delta,conditional_plugin_standard_error=math.sqrt(var),nominal_95_interval=[delta-1.96*math.sqrt(var),delta+1.96*math.sqrt(var)],limitation='Secondary empirical standardization; weights estimated from the sample; intervals condition on baseline cells and weights, not confirmatory mediation estimates.')

def run():
 start=time.monotonic();out=[]
 with tempfile.TemporaryDirectory(prefix='entry-progress-') as tmp:
  binary=Path(tmp)/'progress';compile_engine(binary)
  for mode in ['development','confirmation']:
   main=json.loads((HERE/('merged-million-results.json' if mode=='development' else 'entry-confirm-results.json')).read_text())
   for name,c in codes().items():
    if mode=='development':
     arms={r['representation']:r for r in main['results'] if r['design']==name};flags={l:unpack_bits(r['syndrome_flags_zlib_base64'],1000000) for l,r in arms.items()};seed=main['seed'];expected=main['error_stream_sha256'];actualfirst=None
    else:
     rec=next(r for r in main['records'] if r['design']==name);flags={l:[x==2 for x in unpack(r['kinds_uint16_le_zlib_base64'])] for l,r in rec['arms'].items()};seed=rec['seed'];expected=rec['error_stream_sha256'];actualfirst={l:unpack(r['first_uint16_le_zlib_base64']) for l,r in rec['arms'].items()}
    rng=random.Random(seed);stream=hashlib.sha256();groups={};hard_groups={};cells_w={};cells_both={};packed=[];retained=[]
    for offset in range(0,1000000,10000):
     errors=[''.join('1' if rng.random()<.04 else '0' for _ in range(252)) for j in range(10000)];payload='\n'.join(errors).encode()
     if offset:stream.update(b'\n')
     stream.update(payload)
     lines=[f'252 126 125 10000 {c["pair"][0]} {c["pair"][1]}']
     for rows in [c['original'],c['merged']]:lines.extend(str(len(row))+' '+' '.join(map(str,row)) for row in rows)
     lines.extend(f'{offset+j} {e}' for j,e in enumerate(errors))
     p=subprocess.run([str(binary)],input='\n'.join(lines)+'\n',text=True,capture_output=True,check=True);assert not p.stderr;records=[list(map(int,line.split())) for line in p.stdout.splitlines()];assert len(records)==10000
     for j,r in enumerate(records):
      index,w,initial,wo,wm,sa,sb,changed=r;assert index==offset+j;active=int(bool(sa or sb));difference=wm-wo
      if actualfirst:
       assert wo==actualfirst['original'][index] and wm==actualfirst['merged'][index]
      packed.extend([w,initial,difference+126,2*sa+sb,changed])
      key='worse_first' if difference>0 else 'better_first' if difference<0 else 'same_first_active' if active else 'same_first_inactive'
      g=groups.setdefault(key,Counter());g['trials']+=1;d=int(flags['merged'][index])-int(flags['original'][index]);g['net']+=d;g['lost']+=d==1;g['gained']+=d==-1
      hk='inactive' if not active else 'soft_only' if not changed else 'hard_worse_weight' if difference>0 else 'hard_better_weight' if difference<0 else 'hard_same_weight'
      hg=hard_groups.setdefault(hk,Counter());hg['trials']+=1;hg['net']+=d;hg['lost']+=d==1;hg['gained']+=d==-1
      assert active or changed==0
      for collection,cell in [(cells_w,str(w)),(cells_both,str(w)+'/'+str(initial))]:
       both=collection.setdefault(cell,{0:Counter(),1:Counter()});v=both[active];v['trials']+=1;v['sum']+=d;v['square_sum']+=d*d
      if len(retained)<8 and index%100003<2:retained.append(dict(index=index,error=errors[j],features=r[1:]))
     if offset%200000==0:print(mode,name,offset+10000,'elapsed',round(time.monotonic()-start,1),flush=True)
    assert stream.hexdigest()==expected
    central={k:v for k,v in cells_w.items() if 5<=int(k)<=16};central_both={k:v for k,v in cells_both.items() if 5<=int(k.split('/')[0])<=16}
    result=dict(mode=mode,design=name,seed=seed,error_stream_sha256=stream.hexdigest(),groups={k:dict(v) for k,v in groups.items()},hard_groups={k:dict(v) for k,v in hard_groups.items()},error_weight_standardization=standardized(central),error_and_initial_syndrome_weight_standardization=standardized(central_both),all_weight_cells=cells_w,all_joint_baseline_cells=cells_both,packed_predecode_features_uint16_le_zlib_base64=pack(packed),packed_stride=5,retained=retained)
    out.append(result);print('COMPLETE',mode,name,'groups',result['groups'],'adjusted',result['error_and_initial_syndrome_weight_standardization'],flush=True)
 result=dict(status='secondary_baseline_controls_and_first_gap_partition',new_noise_patterns=0,records=out,elapsed_seconds=time.monotonic()-start)
 (HERE/'entry-progress-results.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':run()
