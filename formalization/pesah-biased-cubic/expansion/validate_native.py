import json,pathlib,time,resource
import numpy as np
from pauli import lattice
from engine import osd as preserved
from native_osd import osd as forward
resource.setrlimit(resource.RLIMIT_CPU,(180,190));rng=np.random.default_rng(202611241);rows=[]
for L,count in [(2,40),(4,40),(6,10),(8,5),(10,3)]:
 for sector,H in enumerate(lattice(L)[:2]):
  oldtime=newtime=0
  for i in range(count):
   e=(rng.random(H.shape[1])<.25).astype(np.uint8);s=H@e%2;p=rng.random(H.shape[1]) if i%2 else np.full(H.shape[1],.2)
   t=time.perf_counter();a=preserved(H,s,p);oldtime+=time.perf_counter()-t;t=time.perf_counter();b=forward(H,s,p);newtime+=time.perf_counter()-t;assert np.array_equal(a,b)
  rows.append(dict(L=L,sector=sector,cases=count,preserved_seconds=oldtime,forward_seconds=newtime,speedup=oldtime/newtime));print(rows[-1],flush=True)
pathlib.Path(__file__).with_name('native-validation.json').write_text(json.dumps(dict(passed=True,rows=rows,shared='Same NumPy reliability sorting, graph and syndrome inputs. Native forward elimination and Python integer RREF return identical free-zero order-zero OSD corrections. This verifies an implementation optimization, not an independent scientific replication.',timing_limit='Exploratory timings in shared environment with pure-Z production running; not historical speedup claim.'),indent=2)+'\n')
