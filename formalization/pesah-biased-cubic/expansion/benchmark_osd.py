"""Reconstructed naive-vs-reused elimination benchmark, not historical hardware."""
import json,pathlib,sys,time,resource
import numpy as np
from pauli import lattice
from validate import historical
_,reference=historical(pathlib.Path(sys.argv[1]));rref=reference['get_rref_mod2'];optimized=reference['osd_decoder']
resource.setrlimit(resource.RLIMIT_CPU,(180,190));resource.setrlimit(resource.RLIMIT_AS,(2*1024**3,2*1024**3))
def naive(H,s,p):
 order=np.argsort(-p);selected=[];rank=0
 for col in order:
  a=H[:,selected+[col]];rr,_=rref(a,np.zeros(len(H),int));new_rank=int(np.any(rr,axis=1).sum())
  if new_rank>rank:selected.append(col);rank=new_rank
 # Eliminate again to solve on selected independent columns, as described baseline.
 rr,b=rref(H[:,selected],s);answer=np.zeros(H.shape[1],int)
 for i,col in enumerate(selected):answer[col]=b[i]
 return answer
rng=np.random.default_rng(202611211);records=[]
for L in [2,3,4]:
 H=lattice(L)[0].astype(int)
 for repeat in range(5):
  e=(rng.random(H.shape[1])<.08).astype(int);s=H@e%2;p=rng.random(H.shape[1]);t=time.perf_counter();a=naive(H,s,p);slow=time.perf_counter()-t;t=time.perf_counter();b=optimized(H,s,p);fast=time.perf_counter()-t;assert np.array_equal(a,b);assert np.array_equal(H@a%2,s)
  records.append(dict(L=L,repeat=repeat,naive_seconds=slow,reused_seconds=fast,speedup=slow/fast));print(records[-1],flush=True)
pathlib.Path(sys.argv[2]).write_text(json.dumps(dict(records=records,source_claim='factor10, Section3.3.2 p46',scope='limited reconstructed benchmark; naive baseline implemented from prose, optimized routine external historical source. Vertex matrices L2,3,4, five independent RHS/reliability cases each; not original hardware/workload. Shared NumPy and elimination helper. No exact historical speedup verdict.'),indent=2)+'\n')
