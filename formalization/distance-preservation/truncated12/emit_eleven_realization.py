from pathlib import Path
R=Path(__file__).resolve().parent
s='''import ElevenGeometry
import ElevenIndex
import PatternRealizations
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]
variable {e : Fin 3 → Fin 4 → ZMod L}

def elevenQubits (d : ElevenGeometry e) : Fin 11 → Qubit L :=
  !['''
qs=[f'.inl (({j},d.singleK {j}),d.singleS {j})' for j in range(3)]
qs +=[f'.inl ((3,d.centerK {a}),d.centerS {a})' for a in range(2)]
qs +=[f'.inl ((3,d.leafK {i}),d.leafS {i})' for i in range(3)]
qs +=[f'.inr ((d.rightH {i},{i}),d.rightT {i})' for i in range(3)]
s+=','.join(qs)+']\n\n'
s+='def elevenChecks (d : ElevenGeometry e) : Fin 18 → SourceModel.ZCheck L :=\n  !['
checks=[];meta=[]
for j in range(3):
 for i in range(3):
  checks.append(f'(({j},{i}),d.singleS {j}+e {i} (d.singleK {j}))');meta.append(('single',j,i))
for i in range(3):
 for a in range(2):
  checks.append(f'((3,elevenRow d.orientation {a} {i}),d.centerS {a}+e (elevenRow d.orientation {a} {i}) (d.centerK {a}))');meta.append(('internal',a,i))
 checks.append(f'((3,{i}),d.leafS {i}+e {i} (d.leafK {i}))');meta.append(('leaf',i))
s+=','.join(checks)+']\n\n'
s+='''/-- The actual oriented source geometry realizes its exact catalog index. -/
def eleven_realization_of_geometry (d : ElevenGeometry e)
    (c : Fin 24) (r : Fin 6) (labels : Fin 204)
    (hK : ∀ j : Fin 3,perm4Value c.val j.val=(d.singleK j).val)
    (hH : ∀ i : Fin 3,perm3Value r.val i.val=(d.rightH i).val)
    (hC : ∀ a : Fin 2,centerLeafValue labels.val a.val=(d.centerK a).val)
    (hL : ∀ i : Fin 3,centerLeafValue labels.val (2+i.val)=(d.leafK i).val) :
    PatternRealization e 11 (elevenRank c r labels d.orientation) := by
  let p := elevenRank c r labels d.orientation
  have hc : p/2448=c.val := elevenRank_columns c r labels d.orientation
  have hr : p/408%6=r.val := elevenRank_rows c r labels d.orientation
  have hl : p/2%204=labels.val := elevenRank_labels c r labels d.orientation
  have ho : p%2=d.orientation.val := elevenRank_orientation c r labels d.orientation
  change PatternRealization e 11 p
  refine {
    qubits := elevenQubits d
    checks := fun k _ => elevenChecks d k
    left_bound := ?_
    right_bound := ?_
    labels := ?_
    check_column := ?_
    check_row := ?_
    left_edge := ?_
    right_edge := ?_
  }
  · intro k hk
    fin_cases k <;> simp [edge]
  · intro k hk
    fin_cases k <;> simp [edge]
  · intro q
    fin_cases q <;> simp [vertex,elevenQubits,VertexLabel,hc,hr,hl]
'''
for j in range(3):s+=f'    · exact hK {j}\n'
for a in range(2):s+=f'    · exact hC {a}\n'
for i in range(3):s+=f'    · exact hL {i}\n'
for i in range(3):s+=f'    · exact hH {i}\n'
s+='''  · intro k hk
    fin_cases k <;> simp [edge,elevenChecks]
  · intro k hk
    fin_cases k <;> simp [edge,elevenChecks,elevenRow,ho,Nat.add_assoc]
  · intro k hk
    fin_cases k <;> simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
  · intro k hk
    fin_cases k
'''
for typ,*args in meta:
 if typ=='single':
  j,i=args
  s+=f'''    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT {i}=(d.singleS {j}+e {i} (d.singleK {j}))+e (d.rightH {i}) {j}
      have hm := d.single_matching {j} {i}
      change d.singleS {j}+e {i} (d.singleK {j})=d.rightT {i}-e (d.rightH {i}) {j} at hm
      linear_combination -hm
'''
 elif typ=='internal':
  a,i=args
  s+=f'''    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching {a} {i}
'''
 else:
  i=args[0]
  s+=f'''    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT {i}=(d.leafS {i}+e {i} (d.leafK {i}))+e (d.rightH {i}) 3
      have hm := d.leaf_matching {i}
      linear_combination -hm
'''
s+='\n#print axioms eleven_realization_of_geometry\nend TruncatedDistance\n'
(R/'ElevenRealization.lean').write_text(s)
