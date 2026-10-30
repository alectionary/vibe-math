"""Resume-safe, bounded general Pauli experiments. Config is fixed before trials."""
import argparse,hashlib,json,pathlib,random,resource,time
import numpy as np
from pauli import lattice,direction,sample,make,trial
from geometry import rhombic
p=argparse.ArgumentParser();p.add_argument('config');p.add_argument('output');a=p.parse_args()
c=json.loads(pathlib.Path(a.config).read_text());fingerprint=hashlib.sha256(pathlib.Path(a.config).read_bytes()).hexdigest();output=pathlib.Path(a.output)
resource.setrlimit(resource.RLIMIT_CPU,(c.get('cpu_seconds',2400),c.get('cpu_seconds',2400)+10));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3))
if c.get('osd_engine')=='native':
 import engine,native_osd
 engine.osd=native_osd.osd
old=json.loads(output.read_text()) if output.exists() else {};assert not old or old['config_sha256']==fingerprint
rows=old.get('rows',[]);done={r['condition_id'] for r in rows};start=time.perf_counter();prior_elapsed=old.get('elapsed_seconds',0);graph=None;last_L=None
for i,condition in enumerate(c['conditions']):
 for gen in c.get('generators',['numpy','stdlib']):
  key=f'{i}:{gen}'
  if key in done:continue
  L=condition['L'];deform=condition['deformed'];rate=condition['p'];r=direction(condition['axis'],condition.get('bias','inf'))
  graph_key=(condition.get('code','cubic'),L)
  if graph_key!=last_L:graph=(rhombic if graph_key[0]=='rhombic' else lattice)(L);last_L=graph_key
  decoders=make(graph,rate,r,deform,c.get('iterations',10));seed=c['seed']+i*2+(gen=='stdlib');rng=np.random.default_rng(seed) if gen=='numpy' else random.Random(seed)
  count=np.zeros(6,int);t=time.perf_counter()
  for shot in range(c['shots']):count+=trial(decoders,graph,*sample(rng,3*L**3,rate,r,gen),deform)
  row=dict(condition,condition_id=key,generator=gen,seed=seed,shots=c['shots'],iterations=c.get('iterations',10),seconds=time.perf_counter()-t)
  row.update(zip(['failures','point_failures','loop_failures','point_osd','loop_osd','invalid'],map(int,count)));rows.append(row)
  data=dict(config=c,config_sha256=fingerprint,rows=rows,complete=False,elapsed_seconds=prior_elapsed+time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
  tmp=output.with_suffix('.tmp');tmp.write_text(json.dumps(data,indent=2)+'\n');tmp.replace(output)
  print(f'{key}: L={L} D={deform} p={rate}: {count.tolist()} {row["seconds"]:.2f}s',flush=True)
data=dict(config=c,config_sha256=fingerprint,rows=rows,complete=True,elapsed_seconds=prior_elapsed+time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss);output.write_text(json.dumps(data,indent=2)+'\n')
