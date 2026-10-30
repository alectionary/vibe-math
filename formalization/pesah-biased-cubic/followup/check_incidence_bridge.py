"""Compare Lean-exported incidence with independent Python construction.
Shared periodic-axis convention; independent source-language implementations.
"""
import pathlib,sys,json,hashlib
import numpy as np
R=pathlib.Path(__file__).resolve().parent;sys.path.insert(0,str(R.parent/'simulation'))
from engine import lattice
p=pathlib.Path(sys.argv[1]);groups={};L=None
for line in p.read_text().splitlines():
 if line.startswith('L '):L=int(line[2:]);groups[L]={'V':[],'F':[]}
 elif line.startswith(('V ','F ')):groups[L][line[0]].append([int(x) for x in line[2:]])
 else:raise ValueError('Unexpected Lean output: '+line[:120])
records=[]
for L,g in groups.items():
 V,F,_,_=lattice(L)
 for name,expected in [('V',V),('F',F)]:
  actual=np.array(g[name],dtype=np.uint8);assert actual.shape==expected.shape;assert np.array_equal(actual,expected)
  records.append(dict(L=L,matrix=name,shape=list(actual.shape),entries=int(actual.size),mismatches=0))
out=dict(records=records,export_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),source_hashes={str(x.relative_to(R)):hashlib.sha256(x.read_bytes()).hexdigest() for x in [R/'lean/CubicIncidence.lean',R/'lean/IncidenceConsumer.lean']},limit='Exact finite cross-language bridge at L2,4,6, not arbitrary-size equivalence or homology/distance proof. Shared source conventions, independently implemented incidence formulas.',errors=[])
(R/'incidence-bridge-validation.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
