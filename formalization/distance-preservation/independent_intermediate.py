"""Independent upper-bound check for the separately selected L13 finite case."""
from pathlib import Path
import json
import numpy as np
import independent_verify as iv
R=Path(__file__).resolve().parent
if __name__=='__main__':
    saved=json.loads((R/'intermediate-weights.json').read_text());c=saved['source_candidate'];L=13
    C,X,Z=iv.expand(c['E'],L);dc=iv.distance(C);dt=iv.distance(C.T)
    assert dc['distance']==14 and dt['distance']==26
    assert not np.any((X@Z.T)%2)
    rank=len(iv.eliminate(X)[1]);witness=None
    for a in range(4):
        support=[a*4*L+j for j in dc['witness']]
        w=np.zeros(25*L,dtype=np.uint8);w[support]=1
        assert not np.any((Z@w)%2)
        if len(iv.eliminate(np.vstack([X,w]))[1])==rank+1:
            witness=support;break
    out={'E':c['E'],'L':L,'classical':dc,'transpose':dt,'rank_X':rank,'quantum_upper':14 if witness else None,
         'nontrivial_quantum_support':witness,'method':'Dense coefficient/Kronecker expansion, full classical enumeration, and augmented stabilizer rank. No discovery-program imports.',
         'quantum_lower_scope':'Separate C++ exhaustive-support report only; no Lean certificate for a lower bound14.'}
    (R/'independent-intermediate.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps({'dC':dc['distance'],'dT':dt['distance'],'independent_quantum_upper':out['quantum_upper'],'quantum_lower_lean_certified':False}))
