import json,os,subprocess,sys,time
from pathlib import Path
r=Path('coupling-results'); name='anchor-witness11'
c=json.loads((r/'anchor-witness10-derived-command.json').read_text())['command']
c[c.index('--name')+1]=name
c[c.index('--warm-point')+1]='coupling-results/anchor-witness10.npz'
for flag,suffix in [('--basis-cuts','.json.gz'),('--basis-replays','-independent.json')]:
 i=c.index(flag)+1
 while i<len(c) and not c[i].startswith('--'):i+=1
 c[i:i]=['coupling-results/native775-witness10'+suffix,'coupling-results/native775-witness10-gauge-rounded'+suffix]
c+=['--projected-margin','0.01']
record={'command':c,'parent_trial_frozen':'coupling-results/anchor-witness10-frozen.json','scope':'Prior necessary families plus2 raw native775 cuts and5 gauge-rounded cuts; enlarged positive projected margin0.01 is sufficient-only discovery, never an obstruction test.'}
(r/(name+'-derived-command.json')).write_text(json.dumps(record,indent=2)+'\n')
e=os.environ.copy()
for k in ['OPENBLAS_NUM_THREADS','OMP_NUM_THREADS','VECLIB_MAXIMUM_THREADS','MKL_NUM_THREADS']:e[k]='1'
for label,command in [('numeric',c),('exact',[sys.executable,'-u','check_anchor_coupling_trial.py','--name',name,'--direct-triples'])]:
 t=time.monotonic()
 with (r/(name+'-controller-'+label+'.log')).open('w') as f:
  try: rc=subprocess.run(command,env=e,stdout=f,stderr=subprocess.STDOUT,timeout=450).returncode
  except subprocess.TimeoutExpired:rc=124
 print(label,rc,time.monotonic()-t,flush=True)
 if rc!=0:break
