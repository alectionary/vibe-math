"""Generate concrete Lean data from the fixed baseline certificate."""
from pathlib import Path
import json
HERE=Path(__file__).resolve().parent
x=json.loads((HERE/'logical-six-certificate.json').read_text())
def lit(a):return '['+', '.join(map(lit,a))+']' if isinstance(a,list) else str(a)
header='''import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.Module.Pi
import Mathlib.Algebra.BigOperators.Ring.Finset

/-! Concrete baseline: same subdivided K3,3 local topology, different logical role.
Generated data from the unchanged lift-14 cyclic benchmark; finite certificates
and a linear-functional proof of exclusion from the complete stabilizer span. -/
set_option maxRecDepth 20000
set_option maxHeartbeats 8000000
namespace CyclicLogicalSix

'''
for key,ty in [('baseline_B','List (List Nat)'),('hx_rows','List (List Nat)'),('hz_rows','List (List Nat)'),('logical_support','List (Fin 252)'),('stabilizer_support','List (Fin 252)'),('dual_support','Finset (Fin 252)')]:
 val=lit(x[key]);
 if key=='dual_support':val='{'+', '.join(map(str,x[key]))+'}'
 header+='def '+key+' : '+ty+' := '+val+'\n\n'
body=(HERE/'logical-certificate-body.txt').read_text()
(HERE.parents[1]/'dyadic-rank/CyclicLogicalSix.lean').write_text(header+body)
