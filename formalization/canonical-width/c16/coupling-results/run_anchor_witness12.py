import json,os,subprocess,sys,time
from pathlib import Path
r=Path('coupling-results');name='anchor-witness12'
c=json.loads((r/'anchor-witness11-derived-command.json').read_text())['command']
c[c.index('--name')+1]=name
c[c.index('--warm-point')+1]='coupling-results/anchor-witness11.npz'
c[c.index('--active-cuts')+1]='coupling-results/anchor-witness11-active.json'
i=c.index('--boolean-cuts')+1
while i<len(c) and not c[i].startswith('--'):i+=1
c.insert(i,'coupling-results/anchor-witness11-all-triples.json')
(r/(name+'-derived-command.json')).write_text(json.dumps({'command':c,'parent_trial_frozen':'coupling-results/anchor-witness11-frozen.json','scope':'Add84 exact Boolean triangles and1 omitted legacy row exposed by rejected point11. Same54 partner rows,296rank rows; projected margin0.01 remains sufficient only.'},indent=2)+'\n')
e=os.environ.copy()
for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:e[k]='1'
for label,command in [('numeric',c),('exact',[sys.executable,'-u','check_anchor_coupling_trial.py','--name',name,'--direct-triples'])]:
 t=time.monotonic()
 with (r/(name+'-controller-'+label+'.log')).open('w') as f:
  try:rc=subprocess.run(command,env=e,stdout=f,stderr=subprocess.STDOUT,timeout=450).returncode
  except subprocess.TimeoutExpired:rc=124
 print(label,rc,time.monotonic()-t,flush=True)
 if rc!=0:break
