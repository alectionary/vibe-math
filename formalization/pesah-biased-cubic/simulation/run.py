"""Bounded, checkpointed two-generator Monte Carlo; no multiprocessing."""
import argparse,json,pathlib,random,resource,time
import numpy as np
from engine import lattice,make_decoders,trial

def main():
 p=argparse.ArgumentParser();p.add_argument('--output',required=True);p.add_argument('--shots',type=int,default=250);p.add_argument('--iterations',type=int,default=10);p.add_argument('--sizes',type=int,nargs='+',default=[4,6,8,10]);p.add_argument('--sensitivity',action='store_true');p.add_argument('--sort-kind',choices=['quicksort','stable'],default='quicksort');a=p.parse_args()
 resource.setrlimit(resource.RLIMIT_CPU,(2400,2410));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3))
 output=pathlib.Path(a.output);rows=[];start=time.perf_counter()
 for L in a.sizes:
  g=lattice(L)
  for deform in (False,True):
   rates=([.05,.065,.08,.095] if deform else [.02,.03,.04,.05]) if not a.sensitivity else ([.08] if deform else [.03])
   for rate_i,p in enumerate(rates):
    decoders=make_decoders(g,p,deform,a.iterations,a.sort_kind)
    for gen in ('numpy','stdlib'):
     seed=2026103000+L*100+int(deform)*10+rate_i+(100000 if gen=='stdlib' else 0)
     rng=np.random.default_rng(seed) if gen=='numpy' else random.Random(seed)
     count=np.zeros(6,dtype=int);t=time.perf_counter()
     for i in range(a.shots):
      # Independent RNG implementations: PCG64 vector Bernoulli vs MT19937 scalar draws.
      e=(rng.random(3*L**3)<p).astype(np.uint8) if gen=='numpy' else np.fromiter((rng.random()<p for _ in range(3*L**3)),dtype=np.uint8)
      count+=trial(decoders,g,e,deform)
     row=dict(L=L,deformed=deform,p=p,generator=gen,seed=seed,shots=a.shots,iterations=a.iterations,sort_kind=a.sort_kind,failures=int(count[0]),point_failures=int(count[1]),loop_failures=int(count[2]),point_osd=int(count[3]),loop_osd=int(count[4]),invalid=int(count[5]),seconds=time.perf_counter()-t)
     rows.append(row)
     output.write_text(json.dumps(dict(rows=rows,elapsed_seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,complete=False),indent=2)+'\n')
     print(f'L={L} deform={deform} p={p} {gen}: {count[0]}/{a.shots}; {row["seconds"]:.1f}s',flush=True)
 output.write_text(json.dumps(dict(rows=rows,elapsed_seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,complete=True),indent=2)+'\n')
if __name__=='__main__':main()
