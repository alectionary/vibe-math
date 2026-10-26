from pathlib import Path
import json
R=Path(__file__).resolve().parent
T=json.loads((R/'catalog-targets.json').read_text())
classic=[p for p,t in enumerate(T) if t['kind']=='classical_weight_le10']
classprop=' ∨ '.join(f'p={p}' for p in classic)
head='''import SourceCycleFacts
import PureDistance
import PackedTablesAudit
set_option maxHeartbeats 0
set_option maxRecDepth 1000000
namespace TruncatedDistance
open FamilyWords TannerSix KernelCatalog
variable {L : ℕ} [NeZero L]

def NoColumnPartition (e : Fin 3 → Fin 4 → ZMod L) : Prop :=
  ∀ a b c d : Fin 4,a≠b → a≠c → a≠d → b≠c → b≠d → c≠d →
    ¬(∀ i,columnForm e i a b c d=0)
def NoTripleRow (e : Fin 3 → Fin 4 → ZMod L) : Prop :=
  ∀ i j k : Fin 3,i≠j → i≠k → j≠k → ∀ a b c : Fin 4,
    a≠b → a≠c → b≠c →
      ¬(rowForm e i j k a=rowForm e i j k b ∧ rowForm e i j k a=rowForm e i j k c)
def sourceVars (e : Fin 3 → Fin 4 → ZMod L) : Fin 6 → ZMod L :=
  ![e 1 1,e 1 2,e 1 3,e 2 1,e 2 2,e 2 3]
def targetVector (p t : ℕ) (k : Fin 6) : Int := targetValue p t k.val
def targetForm (e : Fin 3 → Fin 4 → ZMod L) (p t : ℕ) : ZMod L :=
  integerDot (targetVector p t) (sourceVars e)
'''
head+='def needsClassicalBound (p : ℕ) : Prop := '+classprop+'\n\n'
lines=[head]
for p,t in enumerate(T):
 for j,f in enumerate(t['forms']):
  vec='!['+','.join('('+str(v)+')' if v<0 else str(v) for v in f)+']'
  lines.append(f'theorem vector_{p}_{j} : targetVector {p} {j}={vec} := by\n  funext k\n  fin_cases k <;> decide +kernel\n')
args='''    (e : Fin 3 → Fin 4 → ZMod L)
    (h4 : NoFour (CEdge e)) (h6 : NoSix (CEdge e))
    (hR0 : ∀ j,e 0 j=0) (hC0 : ∀ i,e i 0=0)
    (hCP : NoColumnPartition e) (hP : NoTripleRow e)
    (D : ℕ) (hC : ClassicalAtLeast e D)
'''
for p,t in enumerate(T):
 lines +=[f'theorem obstruction_{p}\n'+args+f'    (hExtra : needsClassicalBound {p} → 10<D)\n    (hz : ∀ t : Fin (targetArity {p}),targetForm e {p} t.val=0) : False := by']
 for j in range(len(t['forms'])):
  lines +=[f'  have h{j} := hz ⟨{j},by decide +kernel⟩',f'  change integerDot (targetVector {p} {j}) (sourceVars e)=0 at h{j}',f'  rw [vector_{p}_{j}] at h{j}',f'  norm_num [integerDot,sourceVars,Fin.sum_univ_succ,zsmul_eq_mul] at h{j}']
 k=t['kind'];v=t['locator']
 if k=='cycle4':
  i,z,a,b=v;lines +=[f'  apply source_four_form_nonzero e h4 {i} {z} (by decide) {a} {b} (by decide)', '  simp only [hR0,hC0]','  linear_combination h0']
 elif k=='cycle6':
  a,b,c=v;lines +=[f'  apply source_six_form_nonzero e h6 hR0 {a} {b} {c} (by decide) (by decide) (by decide)','  simp only [hR0,hC0]','  linear_combination h0']
 elif k=='partial_row':
  z,a,b,c=v;i,j=[x for x in range(3) if x!=z]
  lines +=[f'  apply hP {i} {j} {z} (by decide) (by decide) (by decide) {a} {b} {c} (by decide) (by decide) (by decide)','  constructor', '  · unfold rowForm','    simp only [hR0,hC0]','    linear_combination -h0', '  · unfold rowForm','    simp only [hR0,hC0]','    linear_combination -h1']
 elif k=='column_rcpc':
  a,b,c,d=v;lines +=[f'  apply hCP {a} {b} {c} {d} (by decide) (by decide) (by decide) (by decide) (by decide) (by decide)','  intro i','  fin_cases i','  · simp [columnForm,hR0]','  · unfold columnForm','    simp only [hR0,hC0]','    linear_combination h0','  · unfold columnForm','    simp only [hR0,hC0]','    linear_combination h1']
 elif k=='cyclic_torsion':
  n,i,z=v;lines +=[f'  apply row_small_torsion_impossible e h4 {n} (by decide) (by decide) {i} {z} (by decide)','  intro j','  fin_cases j','  · simp [hC0]']
  for j in range(3):lines +=['  · simp only [nsmul_eq_mul,hR0,hC0]',f'    linear_combination h{j}']
 elif k=='column_two_torsion':
  a,b=v;lines +=[f'  apply column_two_torsion_impossible e h4 {a} {b} (by decide)','  intro i','  fin_cases i','  · simp [hR0]']
  for j in range(2):lines +=['  · simp only [nsmul_eq_mul,hR0,hC0]',f'    linear_combination h{j}']
 elif k=='classical_weight_le10':
  a,b=v;assert a==0
  lines +=[f'  have hsmall : D≤10 := torsion5_forces_classical_bound e D hC {b} (by decide) hC0 (by', '    intro i','    fin_cases i','    · simp [hR0]','    · simp only [nsmul_eq_mul]','      linear_combination h0','    · simp only [nsmul_eq_mul]','      linear_combination h1)',f'  have hlarge : 10<D := hExtra (by decide +kernel)','  omega']
 else:raise ValueError(k)
 lines+=['']
lines+=['theorem source_target_obstruction\n'+args+'    (p : Fin 64) (hExtra : needsClassicalBound p.val → 10<D)\n    (hz : ∀ t : Fin (targetArity p.val),targetForm e p.val t.val=0) : False := by','  fin_cases p']
for p in range(len(T)):lines +=[f'  · exact obstruction_{p} e h4 h6 hR0 hC0 hCP hP D hC hExtra hz']
lines +=['#print axioms source_target_obstruction','end TruncatedDistance']
(R/'TargetObstructions.lean').write_text('\n'.join(lines)+'\n')
print({'target_types':len(T),'classical_alternative_ids':classic})
