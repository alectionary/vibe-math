from pathlib import Path
R=Path(__file__).resolve().parent
s='''import TenGeometry
import TenIndex
import PatternRealizations
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]
variable {e : Fin 3 → Fin 4 → ZMod L}
variable {u : Fin 4 → Fin 4 → ZMod L → ZMod 2}
variable {v : Fin 3 → Fin 3 → ZMod L → ZMod 2}

def tenQubits (d : TenGeometry e u v) : Fin 10 → Qubit L :=
  !['''
qs=[f'.inl (({j+1},d.K {j} {a}),d.S {j})' for j in range(3) for a in range(2)]
qs += [f'.inr ((d.H {i} {a},{i+1}),d.T {i})' for i in range(2) for a in range(2)]
s+=','.join(qs)+']\n\n'
s+='def tenChecks (d : TenGeometry e u v) : Fin 18 → SourceModel.ZCheck L :=\n  !['
checks=[f'(({j+1},0),d.S {j})' for j in range(3)]
meta=[('internalU',j) for j in range(3)]
for i in range(2):
 checks.append(f'((0,{i+1}),d.T {i})');meta.append(('internalV',i))
 for j in range(3):
  for a in range(2):
   checks.append(f'(({j+1},{i+1}),d.S {j}+e {i+1} (d.K {j} {a}))');meta.append(('cross',i,j,a))
checks+=['((0,0),0)'];s+=','.join(checks)+']\n\n'
s+='''/-- The actual pair geometry realizes precisely its finite catalog index. -/
def ten_realization_of_geometry (d : TenGeometry e u v)
    (hR0 : ∀ k,e 0 k=0) (hC0 : ∀ l,e l 0=0)
    (c : Fin 3 → Fin 6) (r : Fin 2 → Fin 3) (bits : Fin 64)
    (hK : ∀ j a,columnPairValue (c j).val a.val=(d.K j a).val)
    (hH : ∀ i a,rowPairValue (r i).val a.val=(d.H i a).val)
    (hflip : ∀ i j,flip10 (tenRank c r bits) i.val j.val=(d.flip i j).val) :
    PatternRealization e 10 (tenRank c r bits) := by
  refine {
    qubits := tenQubits d
    checks := fun k _ => tenChecks d k
    left_bound := ?_
    right_bound := ?_
    labels := ?_
    check_column := ?_
    check_row := ?_
    left_edge := ?_
    right_edge := ?_
  }
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;> simp [edge] <;> split_ifs <;> decide +kernel
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;> simp [edge] <;> split_ifs <;> decide +kernel
  · intro q
    fin_cases q <;> simp [vertex,tenQubits,VertexLabel,
      tenRank_columns c r bits 0,tenRank_columns c r bits 1,tenRank_columns c r bits 2,
      tenRank_rows c r bits 0,tenRank_rows c r bits 1]
'''
for j in range(3):
 for a in range(2):s+=f'    · rw [show column10 (tenRank c r bits) {j}=(c {j}).val from tenRank_columns c r bits {j}]\n      exact hK {j} {a}\n'
for i in range(2):
 for a in range(2):s+=f'    · rw [show row10 (tenRank c r bits) {i}=(r {i}).val from tenRank_rows c r bits {i}]\n      exact hH {i} {a}\n'
s+='''  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;> simp [edge,tenChecks]
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;> simp [edge,tenChecks]
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;>
      simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk
'''
for item in meta:
 if item[0]!='cross':
  s+='    · simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]\n'
  continue
 _,i,j,a=item
 s+=f'''    · have hb : (d.flip {i} {j}).val=0 ∨ (d.flip {i} {j}).val=1 := by
        have := (d.flip {i} {j}).isLt
        omega
      rcases hb with hb|hb
'''
 for bit in range(2):
  mate=0 if a==bit else 1
  s+=f'''      · have he : d.flip {i} {j}={bit} := Fin.ext hb
        have hf : flip10 (tenRank c r bits) {i} {j}={bit} := (hflip {i} {j}).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T {i}=(d.S {j}+e {i+1} (d.K {j} {a}))+e (d.H {i} {mate}) {j+1}
        have hm := d.matching {i} {j} {a}
        simp only [he] at hm
        change d.S {j}+e {i+1} (d.K {j} {a})=d.T {i}-e (d.H {i} {mate}) {j+1} at hm
        linear_combination -hm
'''
s+='\n#print axioms ten_realization_of_geometry\nend TruncatedDistance\n'
(R/'TenRealization.lean').write_text(s)
