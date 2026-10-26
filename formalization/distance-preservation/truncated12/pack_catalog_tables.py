"""Emit compact total table lookups and small kernel audits against explicit tables."""
from pathlib import Path
import itertools,json,hashlib
R=Path(__file__).resolve().parent

def pack(xs,bits):return sum(x<<(bits*i) for i,x in enumerate(xs))
def flatten(xs):return [x for row in xs for x in row]
def zz(x):return 2*x if x>=0 else -2*x-1

def main():
 p4=list(itertools.permutations(range(4)));p3=list(itertools.permutations(range(3)))
 cp=list(itertools.combinations(range(4),2));rp=list(itertools.combinations(range(3),2));cl=[]
 for a,b in itertools.product(range(4),repeat=2):
  for ls in itertools.product([x for x in range(4) if x not in (a,b)],repeat=3):cl.append([a,b,*ls])
 targets=json.loads((R/'catalog-targets.json').read_text());assert len(targets)==64
 lines=['namespace KernelCatalog']
 audit=['import CatalogTables','import PackedTables','set_option maxHeartbeats 0','set_option maxRecDepth 1000000','namespace KernelCatalog']
 for name,table,width in [('perm4Value',p4,4),('perm3Value',p3,3),('columnPairValue',cp,2),('rowPairValue',rp,2),('centerLeafValue',cl,5)]:
  n=pack(flatten(table),2)
  lines +=[f'def {name} (p i : Nat) : Nat := ({n} / (2^(2*({width}*p+i))))%4']
  original={'perm4Value':'permutations4','perm3Value':'permutations3','centerLeafValue':'centerLeaves'}.get(name)
  if original:
   audit +=[f'theorem {name}_audit : (∀ p : Fin {len(table)}, ∀ i : Fin {width}, {name} p.val i.val=({original}[p.val]!)[i.val]!) := by decide +kernel',f'#print axioms {name}_audit']
 arities=[len(t['forms']) for t in targets];assert max(arities)<=3
 vals=[]
 for t in targets:
  for k in range(3):vals += [zz(x) for x in t['forms'][k]] if k<len(t['forms']) else [0]*6
 assert max(vals)<16
 lines +=[f'def targetArity (p : Nat) : Nat := ({pack(arities,2)} / (2^(2*p)))%4',f'def targetEncoded (p t k : Nat) : Nat := ({pack(vals,4)} / (2^(4*(18*p+6*t+k))))%16','def targetValue (p t k : Nat) : Int :=\n  let n := targetEncoded p t k\n  if n%2=0 then (n/2 : Nat) else -((n+1)/2 : Nat)','end KernelCatalog']
 audit +=['theorem targetArity_audit : (∀ p : Fin 64, targetArity p.val=(targets[p.val]!).size) := by decide +kernel','#print axioms targetArity_audit','theorem targetValue_audit : (∀ p : Fin 64, ∀ t : Fin (targetArity p.val), ∀ k : Fin 6, targetValue p.val t.val k.val=((targets[p.val]!)[t.val]!)[k.val]!) := by decide +kernel','#print axioms targetValue_audit','end KernelCatalog']
 (R/'PackedTables.lean').write_text('\n'.join(lines)+'\n');(R/'PackedTablesAudit.lean').write_text('\n'.join(audit)+'\n')
 print({'packed_sha256':hashlib.sha256((R/'PackedTables.lean').read_bytes()).hexdigest(),'targets':len(targets)})
if __name__=='__main__':main()
