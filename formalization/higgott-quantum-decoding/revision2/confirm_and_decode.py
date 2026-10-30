"""Fixed-budget follow-up; preserves all original outputs."""
import sys,json,time,math
from pathlib import Path
import numpy as np,stim,pymatching,networkx as nx
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root))
from circuits import bolza,planar

def relabel(v):
    out=v.copy()
    if v.shape[1]>1:out[:,0]^=v[:,1] # invertible and self-inverse
    return out

def altered(m,transform=False):
    g=m.to_networkx();h=nx.Graph();h.add_nodes_from(g.nodes(data=True))
    for u,v,d in reversed(list(g.edges(data=True))):
        d=dict(d)
        if transform:
            ids=set(d['fault_ids'])
            if 1 in ids:ids.symmetric_difference_update({0})
            d['fault_ids']=ids
        h.add_edge(u,v,**d)
    return pymatching.Matching(h)

def main():
    rows=[];diagnostics=[];index=0
    for k in [0,6,8,10,15]:
      p=10**(-3+.1*k)
      for family in ['b1','q2']:
       for basis in (['X','Z'] if family=='b1' else ['H','V']):
        c=bolza(root/'inputs/bolza',1,basis,p) if family=='b1' else planar(2,basis,p,noise_model='EM3_v3')
        m=pymatching.Matching.from_detector_error_model(c.detector_error_model(decompose_errors=True));s=c.compile_detector_sampler(seed=710000+index)
        failures=0;t=time.monotonic()
        for batch in range(100):
            d,o=s.sample(10000,separate_observables=True);a,w=m.decode_batch(d,return_weights=True);failures+=int(np.any(a!=o,axis=1).sum())
            if batch==0:
                for label,tr in [('reversed_edges',False),('relabeled_and_reversed',True)]:
                    if tr and c.num_observables==1:continue
                    mm=altered(m,tr);b,ww=mm.decode_batch(d,return_weights=True)
                    if tr:b=relabel(b)
                    neq=np.any(a!=b,axis=1)
                    diagnostics.append(dict(family=family,basis=basis,p=p,variant=label,shots=10000,native_failures=int(np.any(a!=o,axis=1).sum()),variant_failures=int(np.any(b!=o,axis=1).sum()),prediction_disagreements=int(neq.sum()),equal_objective_disagreements=int((neq & np.isclose(w,ww,atol=1e-7,rtol=1e-10)).sum()),maximum_weight_difference=float(np.max(abs(w-ww)))))
        row=dict(family=family,basis=basis,p=p,shots=1000000,failures=failures,seed=710000+index,elapsed_seconds=time.monotonic()-t);rows.append(row);index+=1;print(row,flush=True)
        (Path(__file__).parent/'confirmation.json').write_text(json.dumps(rows,indent=2)+'\n')
        (Path(__file__).parent/'decoder_diagnostics.json').write_text(json.dumps(diagnostics,indent=2)+'\n')
if __name__=='__main__':main()
