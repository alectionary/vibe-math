import json,sys,time
from pathlib import Path
sys.path.insert(0,'/private/tmp/c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16')
from verify_inverse_lift import vp,vshifts,rank
root=Path('/private/tmp');s=json.load(open(root/'c16-four-hour-inverse-20261027T202223/formalization/canonical-width/c16/inversion-results/normal-form.json'));out={};start=time.monotonic()
for side,key in [('X','X_right_factors'),('Z','Z_left_factors')]:
 V=[v for a in map(vp,s['dictionary'][key]) for v in vshifts(a)];piv={};kernel=[]
 for i,v in enumerate(V):
  c=1<<i
  while v:
   k=v.bit_length()-1
   if k not in piv:piv[k]=(v,c);break
   w,d=piv[k];v^=w;c^=d
  if not v:kernel.append(c)
 assert len(kernel)==19 and rank(V)==61
 weights={};short=[];v=0;minimum=80
 for k in range(1,1<<19):
  v^=kernel[(k&-k).bit_length()-1];w=v.bit_count();weights[w]=weights.get(w,0)+1;minimum=min(minimum,w)
  if w<=12:short.append(v)
 short.sort(key=lambda v:(v.bit_count(),v));minimal=[]
 for v in short:
  if not any(w&v==w for w in minimal):minimal.append(v)
 def norm(v):
  S=[i for i in range(80) if v>>i&1]
  return min(tuple(sorted((i//16)*16+(i%16+h)%16 for i in S)) for h in range(16))
 reps=sorted({norm(v) for v in minimal});out[side]={'rank':61,'nullity':19,'complete_kernel_nonzero_words':(1<<19)-1,'minimum_relation_weight':minimum,'weight_distribution':weights,'minimal_relation_orbits_through12':reps,'kernel_basis':[hex(v) for v in kernel]};print(side,'min',minimum,'short',len(short),'minimal',len(minimal),'orbits',len(reps),'seconds',time.monotonic()-start,flush=True)
(root/'c16-new-thin-relations.json').write_text(json.dumps(out,indent=2)+'\n')
