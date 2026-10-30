"""Run supplied serialized circuits with the separate 2023-version environment."""
import json,time,importlib.metadata
from pathlib import Path
import numpy as np,stim,pymatching
root=Path(__file__).parent;rows=[]
for i,path in enumerate(sorted((root/'historical_circuits').glob('*.stim'))):
    start=time.monotonic();c=stim.Circuit(path.read_text());m=pymatching.Matching.from_detector_error_model(c.detector_error_model(decompose_errors=True))
    sampler=c.compile_detector_sampler(seed=7000+i);failures=0
    for j in range(10):
        d,o=sampler.sample(10000,separate_observables=True);failures+=int(np.any(m.decode_batch(d)!=o,axis=1).sum())
    row={'file':path.name,'shots':100000,'failures':failures,'seed':7000+i,'stim':stim.__version__,'pymatching':importlib.metadata.version('pymatching'),'elapsed_seconds':time.monotonic()-start};rows.append(row);print(row,flush=True)
(root/'provenance'/'historical_results.json').write_text(json.dumps(rows,indent=2)+'\n')
