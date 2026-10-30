"""Checkpointed, explicitly labelled pilot/full grid; never infer success from execution."""
import argparse, concurrent.futures, json, math, os, pathlib, subprocess, time
p=argparse.ArgumentParser();p.add_argument('--engine',choices=['jags','openmx'],required=True);p.add_argument('--replicates',type=int,default=1);p.add_argument('--mode',choices=['pilot','full'],default='pilot');p.add_argument('--workers',type=int,default=2);p.add_argument('--chapter',type=int,choices=[2,5]);a=p.parse_args()
R=os.environ.get('RSCRIPT','/workspace/slot3-runtime/bin/Rscript'); jobs=[]
def add(script,args,tag):jobs.append((tag,[R,script,*map(str,args),tag]))
if a.engine=='jags':
 for rep in range(a.replicates):
  for N in [500,1000,2000]:
   for delta in [1,1.3,1.5,1.7]:
    tag=f'{a.mode}-c2-n{N}-d{delta}-r{rep}';it=[100,100,100] if a.mode=='pilot' else [1000,7000,12000]
    add('simulation/jags_replication.R',[2,N,60,math.log(delta)/math.sqrt(.5),0,31000+len(jobs),*it],tag)
  for difficulty in [-1,0,1]:
   for mode in ['items','sums']:
    tag=f'{a.mode}-c2-b{difficulty}-{mode}-r{rep}';add('simulation/jags_replication.R',[2,500,60,0,difficulty,32000+len(jobs),*it],tag);jobs[-1][1].extend(['.5',mode])
  for N,J in [(1000,60),(2000,60),(4000,60),(8000,60),(1000,20),(1000,100),(1000,250)]:
   tag=f'{a.mode}-c5-n{N}-j{J}-r{rep}';it=[50,50,50] if a.mode=='pilot' else [5000,50000,25000]
   add('simulation/jags_replication.R',[5,N,J,0,0,33000+len(jobs),*it],tag)
else:
 for rep in range(a.replicates):
  for mechanism in ['MCAR','MAR','MNAR']:
   for q in [2,3,4,5]:
    for missing in [.02,.03,.06,.10]:
     tag=f'{a.mode}-c6-{mechanism}-q{q}-m{missing}-r{rep}';add('simulation/openmx_replication.R',[q,missing,mechanism,34000+len(jobs)],tag)
if a.engine=='jags' and a.chapter:
 jobs=[job for job in jobs if job[1][2]==str(a.chapter)]
pathlib.Path('outputs').mkdir(exist_ok=True)
pathlib.Path(f'outputs/{a.mode}-{a.engine}-planned.json').write_text(json.dumps(jobs,indent=2))
def run(job):
 tag,cmd=job;checkpoint=pathlib.Path('outputs')/(tag+'-checkpoint.json')
 if checkpoint.exists():return json.loads(checkpoint.read_text())
 t=time.time()
 with open(pathlib.Path('outputs')/(tag+'.log'),'w') as f:r=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT)
 result=dict(tag=tag,command=cmd,returncode=r.returncode,elapsed_seconds=time.time()-t,meaning='Execution only; inspect estimation diagnostics before any scientific verdict')
 checkpoint.write_text(json.dumps(result,indent=2));return result
with concurrent.futures.ThreadPoolExecutor(max_workers=a.workers) as pool:
 for result in pool.map(run,jobs):print(json.dumps(result),flush=True)
