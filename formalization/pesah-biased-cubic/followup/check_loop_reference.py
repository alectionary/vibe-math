"""Replay saved restricted-support stress witnesses with external historical code."""
import pathlib,sys,json
import numpy as np
R=pathlib.Path(__file__).resolve().parent
sys.path[:0]=[str(R.parent/'simulation'),str(R.parent/'expansion')]
from validate import historical
from geometry import rhombic
_,reference=historical(pathlib.Path('/tmp/bn3d-2021'))
V,F,S,M=rhombic(2); records=[]
for item in json.loads((R/'rhombic-loop-exhaustive.json').read_text())['examples']:
 e=np.array(item['error'],np.uint8); prior=np.zeros(24);prior[:8]=item['p']
 c=reference['bp_osd_decoder'](F.astype(int),(F@e%2).astype(int),prior,max_bp_iter=10).astype(np.uint8)
 assert np.array_equal(c,item['correction'])
 assert not np.any(F@(e^c)%2) and np.any(S@(e^c)%2)
 records.append(dict(p=item['p'],error_weight=int(e.sum()),matching_correction=True,valid_but_logical_failure=True))
result=dict(records=records,errors=[],scope='Four exhaustive L2 stress witnesses at p1e-12 agree with externally executed historical dense decoder. Outside dissertation L4,6,8,10 and reported probability grids; not a refutation of plotted zero-failure observations. Shared inputs/matrix and NumPy; independent dense versus sparse message layout.')
(R/'rhombic-loop-reference-validation.json').write_text(json.dumps(result,indent=2)+'\n');print(len(records),'witnesses verified')
