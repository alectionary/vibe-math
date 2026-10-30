"""Cross-check generalized sampling/conjugation and historical dense decoder."""
import argparse,json,pathlib,warnings
import numpy as np
from pauli import lattice,direction,sample,make,trial
from validate import historical
from engine import trial as xtrial,make_decoders
p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('output');a=p.parse_args();_,ref=historical(pathlib.Path(a.source));rng=np.random.default_rng(202611031);rows=[];warnings.filterwarnings('ignore',category=RuntimeWarning)
for L in [2,3,4]:
 graph=lattice(L);n=3*L**3
 for deformed in [False,True]:
  for axis,bias,p in [('X','inf',.08),('Z','inf',.22),('Z','30',.15),('depolarizing','0.5',.04)]:
   r=direction(axis,bias);decoders=make(graph,p,r,deformed);mismatches=invalid=0
   for j in range(10):
    ex,ez=sample(rng,n,p,r,'numpy');out=trial(decoders,graph,ex,ez,deformed);invalid+=int(out[-1])
    if axis=='X':assert np.array_equal(out,xtrial(make_decoders(graph,p,deformed),graph,ex,deformed))
    if deformed:ex[:n//3],ez[:n//3]=ez[:n//3].copy(),ex[:n//3].copy()
    for decoder,error in zip(decoders,[ex,ez]):
     syndrome=decoder.sparse@error%2;ours,_=decoder.decode(syndrome);old=ref['bp_osd_decoder'](decoder.H.astype(int),syndrome.astype(int),decoder.p,max_bp_iter=10).astype(np.uint8);mismatches+=int(not np.array_equal(ours,old))
   rows.append(dict(L=L,deformed=deformed,axis=axis,bias=bias,corrections=20,mismatches=mismatches,invalid=invalid))
assert sum(r['mismatches']+r['invalid'] for r in rows)==0
out=dict(passed=True,rows=rows,shared_dependencies='Same graph, error inputs, NumPy and host. Historical dense BP/OSD implementation vs preserved sparse/integer implementation. Not independent end-to-end.',sampling='One categorical Pauli draw per qubit; Y contributes to both components. Pure-X path matches preserved stage-1 results on identical inputs.')
pathlib.Path(a.output).write_text(json.dumps(out,indent=2)+'\n');print('480/480 corrections match; no invalid syndromes; pure-X compatibility passed')
