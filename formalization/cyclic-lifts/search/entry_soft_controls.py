"""Exploratory hardness controls within the soft-only first-step partition.

Uses existing packed features/outcomes only. These categories are post-update;
standardized differences are descriptive and not causal mediation estimates.
"""
from pathlib import Path
from collections import Counter
import base64,json,math,struct,zlib
from merged_mechanism import unpack_bits
HERE=Path(__file__).resolve().parent

def unpack(s):
 raw=zlib.decompress(base64.b64decode(s));return struct.unpack('<'+str(len(raw)//2)+'H',raw)

def contrast(cells):
 selected=[g for k,g in cells.items() if 5<=int(k.split('/')[0])<=16 and min(g[a]['n'] for a in ['inactive','soft_only'])>=100]
 mass=sum(sum(x['n'] for x in g.values()) for g in selected)
 differences=[];variance=[]
 for g in selected:
  weight=sum(x['n'] for x in g.values())/mass
  a=g['soft_only'];z=g['inactive']
  differences.append(weight*(a['sum']/a['n']-z['sum']/z['n']))
  for x in [a,z]:
   variance.append(weight*weight*(x['squares']-x['sum']**2/x['n'])/(x['n']*(x['n']-1)))
 d=math.fsum(differences);se=math.sqrt(math.fsum(variance))
 return dict(cells=len(selected),retained_pairs=mass,contrast_soft_minus_inactive=d,nominal_conditional_95_interval=[d-1.96*se,d+1.96*se])

def run():
 packet=json.loads((HERE/'entry-progress-results.json').read_text());records=[]
 for r in packet['records']:
  source=json.loads((HERE/('merged-million-results.json' if r['mode']=='development' else 'entry-confirm-results.json')).read_text())
  if r['mode']=='development':
   flags={x['representation']:unpack_bits(x['syndrome_flags_zlib_base64'],1000000) for x in source['results'] if x['design']==r['design']}
  else:
   rec=next(x for x in source['records'] if x['design']==r['design'])
   flags={k:[v==2 for v in unpack(a['kinds_uint16_le_zlib_base64'])] for k,a in rec['arms'].items()}
  data=zlib.decompress(base64.b64decode(r['packed_predecode_features_uint16_le_zlib_base64']));cells={};totals={}
  for i,(w,initial,delta,stratum,changed) in enumerate(struct.iter_unpack('<5H',data)):
   label='inactive' if not stratum else 'soft_only' if not changed else None
   if label is None:continue
   d=int(flags['merged'][i])-int(flags['original'][i])
   for g in [cells.setdefault(str(w)+'/'+str(initial),{'inactive':Counter(n=0,sum=0,squares=0),'soft_only':Counter(n=0,sum=0,squares=0)})[label],totals.setdefault(label,Counter(n=0,sum=0,squares=0))]:
    g['n']+=1;g['sum']+=d;g['squares']+=d*d
  result=dict(mode=r['mode'],design=r['design'],raw_groups={k:dict(v) for k,v in totals.items()},standardization=contrast(cells),joint_cells={k:{a:dict(v) for a,v in g.items()} for k,g in cells.items()})
  for k,v in totals.items():assert v['n']==r['hard_groups'][k]['trials'] and v['sum']==r['hard_groups'][k]['net']
  records.append(result);print(r['mode'],r['design'],result['standardization'],flush=True)
 out=dict(status='exploratory_soft_only_baseline_control',new_noise_patterns=0,records=records,
   limitation='Post-update category, selected after inspecting the confirmation results. Conditional plug-in intervals do not include empirical-weight uncertainty, multiplicity or selection. No confirmatory or causal mediation claim.')
 (HERE/'entry-soft-controls.json').write_text(json.dumps(out,indent=2)+'\n')
if __name__=='__main__':run()
