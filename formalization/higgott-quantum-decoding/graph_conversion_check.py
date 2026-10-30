"""Compare historical graph-conversion policy with native PyMatching import."""
from pathlib import Path
import json
import numpy as np,stim,pymatching
from hcb.tools.analysis.decoding import detector_error_model_to_nx_graph
root=Path(__file__).parent;rows=[]
for index,path in enumerate(sorted((root/'historical_circuits').glob('*.stim'))):
    c=stim.Circuit(path.read_text());dem=c.detector_error_model(decompose_errors=True)
    g=detector_error_model_to_nx_graph(dem)
    for i in range(dem.num_detectors):g.add_node(i)
    legacy=pymatching.Matching(g);native=pymatching.Matching.from_detector_error_model(dem)
    # Deliberately omit legacy 1e10-weight dummy edges: modern matching rejects
    # those artificial edges; they are not physical error mechanisms.
    sampler=c.compile_detector_sampler(seed=9000+index);f1=f2=disagree=0
    for j in range(10):
        d,o=sampler.sample(10000,separate_observables=True)
        a=native.decode_batch(d);b=legacy.decode_batch(d)
        f1+=int(np.any(a!=o,axis=1).sum());f2+=int(np.any(b!=o,axis=1).sum());disagree+=int(np.any(a!=b,axis=1).sum())
    row={'file':path.name,'shots':100000,'native_failures':f1,'legacy_graph_failures':f2,'prediction_disagreements':disagree};rows.append(row)
(root/'provenance'/'graph_conversion_results.json').write_text(json.dumps(rows,indent=2)+'\n')
