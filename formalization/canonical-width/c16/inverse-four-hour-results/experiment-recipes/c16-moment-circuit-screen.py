from pathlib import Path
import json,itertools,time
import numpy as np
root=Path('/private/tmp');out={};start=time.monotonic()
for side in ['X','Z']:
 V=[int(v,16) for v in (root/f'c16-new-rank-rectangles-{side}.txt').read_text().split()[2:]];assert len(V)==720 and len(set(V))==720;lookup={v:i for i,v in enumerate(V)};pairs={};circuits=set()
 for i,j in itertools.combinations(range(720),2):
  w=V[i]^V[j];pairs.setdefault(w,[]).append((i,j))
  if w in lookup and lookup[w]>j:circuits.add((i,j,lookup[w]))
 for group in pairs.values():
  for a,b in itertools.combinations(group,2):
   t=tuple(sorted(a+b))
   if len(set(t))==4:circuits.add(t)
 def normalize(t):return min(tuple(sorted((i//16)*16+(i%16+h)%16 for i in t)) for h in range(16))
 reps=sorted({normalize(c) for c in circuits});out[side]=reps;print(side,'3',sum(len(c)==3 for c in circuits),'4',sum(len(c)==4 for c in circuits),'orbits',len(reps),'seconds',time.monotonic()-start,flush=True)
(root/'c16-new-source-short-circuits.json').write_text(json.dumps(out)+'\n')
path=root/'c16-new-global-triangle-moments.npz'
if not path.exists():path=root/'c16-new-rank-SDPglobal.moments.npz'
data=np.load(path);p=data['first'];C={h:data[f'C{h}'] for h in range(9)};C.update({h:C[16-h].T for h in range(9,16)});cuts=[];maximum=0
for side in ['X','Z']:
 offset=0 if side=='X' else 45
 for rep in out[side]:
  for phase in range(16):
   r=sum(C[(v%16+phase)%16][:,offset+v//16] for v in rep)-(len(rep)-1)*p;maximum=max(maximum,float(r.max()))
   for i in np.where(r>1e-5)[0]:cuts.append({'sector':side,'circuit':rep,'phase':phase,'anchor':int(i),'violation':float(r[i])})
cuts.sort(key=lambda c:c['violation'],reverse=True);result={'source_circuit_orbits':{s:len(v) for s,v in out.items()},'moment_input':str(path),'maximum_conditional_circuit_violation':maximum,'violated_cuts':len(cuts),'top_cuts':cuts[:3000],'source_C16_answered':False};(root/'c16-new-circuit-moment-screen.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='top_cuts'}),flush=True)
