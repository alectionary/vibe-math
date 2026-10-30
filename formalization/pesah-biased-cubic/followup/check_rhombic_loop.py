"""Exhaustive small-lattice check of actual unrestricted decoder versus support uniqueness."""
import pathlib,sys,json,time,itertools,resource
import numpy as np
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'expansion'));sys.path.insert(0,str(R.parent/'simulation'))
from geometry import rhombic
from engine import Decoder
resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3));resource.setrlimit(resource.RLIMIT_CPU,(300,310))
V,F,S,M=rhombic(2);rows=[];start=time.perf_counter();examples=[]
for p in [1e-12,.001,.1,.49,.5]:
 prior=np.zeros(24);prior[:8]=p;decoder=Decoder(F,prior,10);bad=invalid=outside=0
 for bits in itertools.product([0,1],repeat=8):
  e=np.zeros(24,np.uint8);e[:8]=bits;s=F@e%2;c,osd=decoder.decode(s);r=e^c
  inv=bool(np.any(F@r%2));fail=bool(np.any(S@r%2));out=bool(np.any(c[8:]));invalid+=inv;bad+=fail;outside+=out
  if fail or inv:examples.append(dict(p=p,error=e.tolist(),correction=c.tolist(),osd=bool(osd),invalid=inv,logical_failure=fail))
 rows.append(dict(p=p,errors=256,logical_failures=bad,invalid=invalid,corrections_outside_physical_support=outside))
out=dict(L=2,rows=rows,examples=examples,seconds=time.perf_counter()-start,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,scope='Exhaustive256first-axis errors at each supplied prior; finite implementation check, not a general BP guarantee. Includes very small prior stress outside reported production grids. Shared source geometry and actual primary decoder; ideal support injection is a separate proof.')
(R/'rhombic-loop-exhaustive.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='examples'},indent=2))
