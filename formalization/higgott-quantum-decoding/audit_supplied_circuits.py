"""Audit published circuit data with installed Stim/PyMatching, no external code imports."""
import argparse, collections, hashlib, json, math, time
from pathlib import Path
import numpy as np
import stim
import pymatching

def channel_check(p=0.001):
    q=-math.expm1(math.log1p(-p)/16)/2
    dist=np.zeros(32);dist[0]=1
    for v in range(1,32):
        dist=(1-q)*dist+q*dist[np.arange(32)^v]
    target=np.full(32,p/32);target[0]+=1-p
    return {'p':p,'independent_component_probability':q,'max_absolute_distribution_error':float(abs(dist-target).max()),'distribution':dist.tolist()}

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--shots',type=int,default=4096);a=ap.parse_args()
    rows=[]
    for index,p in enumerate(sorted(a.source.glob('*.stim'))):
        if '_l=1_' not in p.name and '_l=2_' not in p.name:continue
        c=stim.Circuit(p.read_text());start=time.monotonic()
        row={'filename':p.name,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'shots':a.shots,'seed':20261030+index,'num_qubits_in_simulation':c.num_qubits,'num_observables':c.num_observables,'num_detectors':c.num_detectors}
        flat=c.flattened();row['mpp_instruction_count']=sum(i.name=='MPP' for i in flat)
        clean=c.without_noise();d,o=clean.compile_detector_sampler(seed=row['seed']).sample(a.shots,separate_observables=True)
        row['noiseless_detector_events']=int(d.sum());row['noiseless_observable_flips']=int(o.sum())
        assert not d.any() and not o.any()
        if '_p=0.001' in p.name:
            dem=c.detector_error_model(decompose_errors=True)
            row['graphlike_distance']=len(c.shortest_graphlike_error())
            m=pymatching.Matching.from_detector_error_model(dem)
            d,o=c.compile_detector_sampler(seed=row['seed']).sample(a.shots,separate_observables=True)
            pred=m.decode_batch(d)
            row['block_failures']=int(np.any(pred!=o,axis=1).sum())
            row['uncorrected_block_failures']=int(np.any(o,axis=1).sum())
            row['observable_failures']=np.sum(pred!=o,axis=0).tolist()
        row['elapsed_seconds']=time.monotonic()-start;rows.append(row)
    a.output.write_text(json.dumps({'purpose':'small preparation pilot, not final performance results','channel_check':channel_check(),'circuits':rows},indent=2)+'\n')

if __name__=='__main__':main()
