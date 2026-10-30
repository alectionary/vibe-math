"""Small prospective cost pilot, before the production design is launched."""
import json,pathlib,resource,time
import numpy as np
from engine import lattice,make_decoders,trial
rng=np.random.default_rng(20261030);rows=[]
for L in (4,6,8,10):
    if L==10:rng=np.random.default_rng(93)
    graph=lattice(L);shots=10 if L==10 else 20
    for deformation in (False,True):
        p=.08 if deformation else .03;decoders=make_decoders(graph,p,deformation);start=time.perf_counter()
        outcomes=[trial(decoders,graph,(rng.random(3*L**3)<p).astype(np.uint8),deformation) for _ in range(shots)]
        rows.append(dict(L=L,deformed=deformation,p=p,n=shots,seconds=time.perf_counter()-start,counts=np.array(outcomes).sum(axis=0).tolist()))
out=pathlib.Path(__file__).resolve().parents[1]/'results/pilot.json'
out.write_text(json.dumps(dict(rows=rows,maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss),indent=2)+'\n')
