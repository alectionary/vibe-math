"""Paired exploratory 10/100-iteration and stable-tie checks for every BP family."""
import json,pathlib,time,resource
import numpy as np
from pauli import lattice,direction,sample,make,trial
from geometry import rhombic
import engine,native_osd
engine.osd=native_osd.osd
R=pathlib.Path(__file__).resolve().parent;resource.setrlimit(resource.RLIMIT_CPU,(1200,1210));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));out=R/'decoder-diagnostics.json';old=json.loads(out.read_text()) if out.exists() else {};records=old.get('records',[]);done={(r['family'],r['L'],r['deformed']) for r in records};start=time.perf_counter()
for i,name in enumerate(json.loads((R/'families-plan.json').read_text())['configs']):
 config=json.loads((R/name).read_text());family=config['family']
 for L in [4,10]:
  for d in [False,True]:
   if (family,L,d) in done:continue
   selected=[c for c in config['conditions'] if c['L']==L and c['deformed']==d];first=selected[0];p=float(np.mean([c['p'] for c in selected]));r=direction(first['axis'],first['bias']);g=(rhombic if first['code']=='rhombic' else lattice)(L);n=g[0].shape[1];dec=[make(g,p,r,d,10),make(g,p,r,d,100),make(g,p,r,d,10)]
   for decoder in dec[2]:decoder.sort_kind='stable'
   seed=202670000+i*100+L*2+int(d);rng=np.random.default_rng(seed);counts=np.zeros((3,6),int);discordant=np.zeros((2,2),int);t=time.perf_counter()
   for shot in range(50):
    ex,ez=sample(rng,n,p,r,'numpy');results=[trial(ds,g,ex,ez,d) for ds in dec];counts+=results
    for j in [0,1]:
     a,b=results[0][0],results[j+1][0]
     if a!=b:discordant[j,int(b)]+=1
   record=dict(family=family,L=L,deformed=d,p=p,seed=seed,shots=50,counts=counts.tolist(),paired_discordant=discordant.tolist(),seconds=time.perf_counter()-t);records.append(record)
   out.write_text(json.dumps(dict(records=records,complete=False,elapsed_seconds=time.perf_counter()-start,meaning='Rows of counts:10 quicksort,100 quicksort,10 stable. Count columns:total,point,loop,pointOSD,loopOSD,invalid. Discordant rows compare100 orstable tobaseline; columns alternative succeeds / alternative fails. Exploratory diagnostics; shared errors/graph/decoder, not independent replication. No threshold fit and no claim of equivalence from50 trials.'),indent=2)+'\n');print(family,L,d,counts[:,0].tolist(),flush=True)
data=json.loads(out.read_text());data['complete']=True;out.write_text(json.dumps(data,indent=2)+'\n')
