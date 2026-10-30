"""Independent channel representation, optimizer, and analytical control checks."""
from pathlib import Path
import json,math
import numpy as np
import networkx as nx
import stim,pymatching
from circuits import bolza,planar
from run_replication import no_correction_exact
ROOT=Path(__file__).parent

def exclusive_channel(c):
    out=stim.Circuit();block=[]
    def flush():
        if not block:return
        n=len(block);assert n in (7,31)
        q=block[0].gate_args_copy()[0]
        p=-math.expm1(((n+1)//2)*math.log1p(-2*q))
        for j,ins in enumerate(block):
            out.append('E' if j==0 else 'ELSE_CORRELATED_ERROR',ins.targets_copy(),(p/(n+1))/(1-j*p/(n+1)))
        block.clear()
    for ins in c.flattened():
        if ins.name=='E':block.append(ins)
        else:flush();out.append(ins)
    flush();return out

def independent_minimum(m,syndrome):
    g=m.to_networkx();boundary=[v for v,d in g.nodes(data=True) if d.get('is_boundary')]
    assert len(boundary)<=1
    defects=list(np.flatnonzero(syndrome));n=len(defects)
    if not n:return 0.
    aux=nx.Graph();aux.add_nodes_from(range(2*n if boundary else n))
    for i,u in enumerate(defects):
        distances=nx.single_source_dijkstra_path_length(g,int(u),weight='weight')
        for j in range(i):
            if int(defects[j]) in distances:aux.add_edge(i,j,weight=distances[int(defects[j])])
        if boundary and boundary[0] in distances:aux.add_edge(i,n+i,weight=distances[boundary[0]])
    if boundary:
        for i in range(n):
            for j in range(i):aux.add_edge(n+i,n+j,weight=0.)
    pairs=nx.min_weight_matching(aux,weight='weight')
    assert len(pairs)*2==len(aux)
    return sum(aux[u][v]['weight'] for u,v in pairs)

def main():
    rows=[]
    source=ROOT/'inputs'/'bolza'
    for family in ['b1','b2','q2','q3','q4']:
        for basis in (['X','Z'] if family[0]=='b' else ['H','V']):
            c=bolza(source,int(family[1]),basis,.001) if family[0]=='b' else planar(int(family[1]),basis,.001,noise_model='EM3_v3')
            dem=c.detector_error_model(decompose_errors=True);m=pymatching.Matching.from_detector_error_model(dem)
            d,o=c.compile_detector_sampler(seed=991).sample(100000,separate_observables=True)
            d2,o2=exclusive_channel(c).compile_detector_sampler(seed=992).sample(100000,separate_observables=True)
            f=int(np.any(m.decode_batch(d)!=o,axis=1).sum());f2=int(np.any(m.decode_batch(d2)!=o2,axis=1).sum())
            p1,p2=f/100000,f2/100000;se=math.sqrt((p1*(1-p1)+p2*(1-p2))/100000)
            errors=[]
            for s in d[:100]:
                _,weight=m.decode(s,return_weight=True)
                errors.append(abs(weight-independent_minimum(m,s)))
            d0,o0=c.without_noise().compile_detector_sampler(seed=993).sample(4096,separate_observables=True)
            row=dict(family=family,basis=basis,shots_per_generator=100000,independent_binary_failures=f,
                exclusive_categorical_failures=f2,difference_z=(p1-p2)/se if se else 0,
                optimizer_cases=100,maximum_objective_difference=max(errors),
                noiseless_detector_events=int(d0.sum()),noiseless_observable_events=int(o0.sum()),
                no_correction_exact=no_correction_exact(dem,c.num_observables),
                no_correction_empirical=float(np.any(o,axis=1).mean()))
            rows.append(row);print(row,flush=True)
    (ROOT/'provenance'/'independent_checks.json').write_text(json.dumps(rows,indent=2)+'\n')

if __name__=='__main__':main()
