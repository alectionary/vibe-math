"""Bounded source-pinned decoder diagnostic; not the recovered Higgott stack."""
import sys,json,time
from pathlib import Path
import numpy as np,stim,pymatching
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'vendor/honeycomb-boundaries/src'))
from hcb.tools.analysis.decoding import decode_using_pymatching
rows=[]
for i,name in enumerate(['b1_X_0.stim','b1_Z_0.stim','q2_H_0.stim','q2_V_0.stim']):
 c=stim.Circuit((root/'historical_circuits'/name).read_text());t=time.monotonic();sampler=c.compile_detector_sampler(seed=93000+i)
 a=sampler.sample(100000,append_observables=True);d=a[:,:c.num_detectors];o=a[:,c.num_detectors:]
 pred=decode_using_pymatching(circuit=c,bit_packed_det_samples=np.packbits(d,axis=1,bitorder='little'),use_correlated_decoding=False)
 rows.append(dict(file=name,shots=100000,failures=int(np.any(o!=pred,axis=1).sum()),seed=93000+i,elapsed_seconds=time.monotonic()-t));print(rows[-1],flush=True)
(root/'revision2/source_pinned_results.json').write_text(json.dumps(rows,indent=2)+'\n')
