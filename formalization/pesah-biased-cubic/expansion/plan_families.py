"""Freeze full finite-bias and remaining BP-OSD endpoint grids before execution."""
import json,pathlib
R=pathlib.Path(__file__).resolve().parent;source=json.loads((R/'source-bias-curves.json').read_text())['records'];plans=[]
for code in ['cubic','rhombic']:
 for axis in ['X','Z']:
  for bias in ['1','3','5','10','30','100']:
   centers={}
   for d in [False,True]:
    if bias=='5':
     # Explicit methods-text alternative, log-interpolate only for prospective p-grid center.
     a=next(r['threshold'] for r in source if (r['code'],r['axis'],r['deformed'],r['bias_label'])==(code,axis,d,'3'));b=next(r['threshold'] for r in source if (r['code'],r['axis'],r['deformed'],r['bias_label'])==(code,axis,d,'10'));import math;center=a+(b-a)*math.log(5/3)/math.log(10/3)
    else:center=next(r['threshold'] for r in source if (r['code'],r['axis'],r['deformed'],r['bias_label'])==(code,axis,d,bias))
    centers[d]=center
   plans.append((f'{code}-{axis}-eta{bias}',code,axis,bias,centers))
for code in ['cubic','rhombic']:
 plans.append((f'{code}-depolarizing',code,'depolarizing','.5',{False:.043 if code=='cubic' else .015,True:.042 if code=='cubic' else .017}))
for axis,centers in [('X',{False:.01,True:.017}),('Z',{False:.284,True:.065})]:plans.append((f'rhombic-{axis}-pure','rhombic',axis,'inf',centers))
files=[]
for i,(name,code,axis,bias,centers) in enumerate(plans):
 conditions=[dict(code=code,L=L,deformed=d,axis=axis,bias=bias,p=round(centers[d]*factor,6)) for L in [4,6,8,10] for d in [False,True] for factor in [.8,.95,1.05,1.2]]
 c=dict(purpose='Whole-dissertation BP-OSD reconstruction; frozen source-centered grid; eta5 is methods-text alternative, not figure source value',family=name,osd_engine='native',seed=202620000+i*10000,shots=100,iterations=10,cpu_seconds=2400,conditions=conditions)
 path=R/(name+'-config.json');path.write_text(json.dumps(c,indent=2)+'\n');files.append(path.name)
(R/'families-plan.json').write_text(json.dumps(dict(configs=files,trials_per_family=6400,total_trials=6400*len(files),scope='All remaining BP-OSD endpoint arms and X/Z finite bias families at both plot eta3 and methods eta5; preserved pure-X and initial pure-Z stay separate.',resources='At most two family workers plus the existing single pure-Z process: three CPU workers, each 2GiB address-space cap and2400 CPU seconds; host cgroup4CPU/16GiB. Per-condition deterministic checkpoints.',pilot='families-pilot.json: native engine L10 measured about .005–.05 seconds per trial depending on family; pilot excludes production.',uncertainty='Declare 28 family-specific three-comparison threshold families (two arms plus signed contrast), with per-family alpha=.05 Bonferroni; any pooled dissertation-wide ranking additionally needs a separately declared cross-family adjustment. Eta5 has no printed source point. No grid-wide significance from an unadjusted point.'),indent=2)+'\n');print(len(files),'families',6400*len(files),'trials')
