"""Dissertation-convention rhombic decoders vs global-Hadamard-mapped source."""
import json,pathlib,sys,warnings
import numpy as np
from geometry import rhombic
from pauli import direction,sample,make,trial
from validate import historical
import engine,native_osd
engine.osd=native_osd.osd
_,ref=historical(pathlib.Path(sys.argv[1]));rng=np.random.default_rng(202611251);rows=[];warnings.filterwarnings('ignore',category=RuntimeWarning)
for L in [2,4]:
 g=rhombic(L);n=g[0].shape[1]
 for axis,bias,p in [('X','inf',.015),('Z','inf',.25),('Z','30',.15),('depolarizing','.5',.02)]:
  for d in [False,True]:
   dec=make(g,p,direction(axis,bias),d);mismatch=invalid=0
   for _ in range(10):
    ex,ez=sample(rng,n,p,direction(axis,bias),'numpy');invalid+=int(trial(dec,g,ex,ez,d)[-1])
    if d:ex[:n//3],ez[:n//3]=ez[:n//3].copy(),ex[:n//3].copy()
    for decoder,e in zip(dec,[ex,ez]):
     s=decoder.sparse@e%2;a,_=decoder.decode(s);b=ref['bp_osd_decoder'](decoder.H.astype(int),s.astype(int),decoder.p,max_bp_iter=10);mismatch+=int(not np.array_equal(a,b))
   assert mismatch==invalid==0;rows.append(dict(L=L,axis=axis,bias=bias,deformed=d,corrections=20,mismatches=mismatch,invalid=invalid))
pathlib.Path(sys.argv[2]).write_text(json.dumps(dict(passed=True,records=rows,shared='Same matrices and error vectors, NumPy, host; historical dense routine versus sparse BP/native GF2 implementation. Geometry separately checked against historical global-Hadamard mapping. Not a historical production-runtime replication.'),indent=2)+'\n');print('320/320 rhombic reference corrections match')
