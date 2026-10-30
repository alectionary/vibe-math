"""Bounded SweepMatch reconstruction: historical sweep + modern matching."""
import argparse,json,pathlib,random,resource,time,hashlib,sys
import numpy as np
from pauli import lattice,direction,sample
from sweep_adapter import build
p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('config');p.add_argument('output');a=p.parse_args();c=json.loads(pathlib.Path(a.config).read_text());h=hashlib.sha256(pathlib.Path(a.config).read_bytes()).hexdigest();out=pathlib.Path(a.output)
resource.setrlimit(resource.RLIMIT_CPU,(c.get('cpu_seconds',2400),c.get('cpu_seconds',2400)+10));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3))
old=json.loads(out.read_text()) if out.exists() else {};assert not old or old['config_sha256']==h
if old.get('complete'):print('Already complete; verified config hash');sys.exit(0)
rows=old.get('rows',[]);done={r['condition_id'] for r in rows};start=time.perf_counter();prior=old.get('elapsed_seconds',0)
for i,cond in enumerate(c['conditions']):
 L=cond['L'];d=cond['deformed'];p=cond['p'];r=direction(cond['axis'],cond.get('bias','inf'));V,F,S,M=lattice(L);n=3*L**3
 from scipy.sparse import csr_matrix
 v=csr_matrix(V);f=csr_matrix(F)
 for gen in c.get('generators',['numpy','stdlib']):
  key=f'{i}:{gen}'
  if key in done:continue
  seed=c['seed']+i*2+(gen=='stdlib');rng=np.random.default_rng(seed) if gen=='numpy' else random.Random(seed);code,decoder=build(pathlib.Path(a.source),L,p,r,d,seed+1000000);count=np.zeros(4,int);t=time.perf_counter()
  for shot in range(c['shots']):
   ex,ez=sample(rng,n,p,r,gen)
   if d:ex[:n//3],ez[:n//3]=ez[:n//3].copy(),ex[:n//3].copy()
   syndrome=np.concatenate([f@ez%2,v@ex%2]);corr=decoder.decode(code,syndrome.copy()).astype(np.uint8);rx=ex^corr[:n];rz=ez^corr[n:];invalid=bool(np.any(v@rx%2) or np.any(f@rz%2));point=bool(np.any(v@rx%2) or np.any(M@rx%2));loop=bool(np.any(f@rz%2) or np.any(S@rz%2));count+=np.array([point or loop,point,loop,invalid],int)
  row=dict(cond,condition_id=key,generator=gen,seed=seed,sweep_seed=seed+1000000,shots=c['shots'],seconds=time.perf_counter()-t);row.update(zip(['failures','point_failures','loop_failures','invalid'],map(int,count)));rows.append(row)
  data=dict(config=c,config_sha256=h,rows=rows,complete=False,elapsed_seconds=prior+time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,scope='Historical sweep code, modern PyMatching2.3.1; exact0.2.4 dependency blocked. Sector failure includes residual syndrome or nontrivial logical. max_sweep_factor4 source default.');tmp=out.with_suffix('.tmp');tmp.write_text(json.dumps(data,indent=2)+'\n');tmp.replace(out);print(key,L,d,p,count.tolist(),round(row['seconds'],2),flush=True)
  del decoder,code
# Preserve checkpoint data and mark successful completion.
data['complete']=True;out.write_text(json.dumps(data,indent=2)+'\n')
