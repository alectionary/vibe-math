import ElevenGeometry
import ElevenIndex
import PatternRealizations
set_option maxHeartbeats 0
namespace TruncatedDistance
open FamilyWords KernelCatalog
variable {L : ℕ} [NeZero L]
variable {e : Fin 3 → Fin 4 → ZMod L}

def elevenQubits (d : ElevenGeometry e) : Fin 11 → Qubit L :=
  ![.inl ((0,d.singleK 0),d.singleS 0),.inl ((1,d.singleK 1),d.singleS 1),.inl ((2,d.singleK 2),d.singleS 2),.inl ((3,d.centerK 0),d.centerS 0),.inl ((3,d.centerK 1),d.centerS 1),.inl ((3,d.leafK 0),d.leafS 0),.inl ((3,d.leafK 1),d.leafS 1),.inl ((3,d.leafK 2),d.leafS 2),.inr ((d.rightH 0,0),d.rightT 0),.inr ((d.rightH 1,1),d.rightT 1),.inr ((d.rightH 2,2),d.rightT 2)]

def elevenChecks (d : ElevenGeometry e) : Fin 18 → SourceModel.ZCheck L :=
  ![((0,0),d.singleS 0+e 0 (d.singleK 0)),((0,1),d.singleS 0+e 1 (d.singleK 0)),((0,2),d.singleS 0+e 2 (d.singleK 0)),((1,0),d.singleS 1+e 0 (d.singleK 1)),((1,1),d.singleS 1+e 1 (d.singleK 1)),((1,2),d.singleS 1+e 2 (d.singleK 1)),((2,0),d.singleS 2+e 0 (d.singleK 2)),((2,1),d.singleS 2+e 1 (d.singleK 2)),((2,2),d.singleS 2+e 2 (d.singleK 2)),((3,elevenRow d.orientation 0 0),d.centerS 0+e (elevenRow d.orientation 0 0) (d.centerK 0)),((3,elevenRow d.orientation 1 0),d.centerS 1+e (elevenRow d.orientation 1 0) (d.centerK 1)),((3,0),d.leafS 0+e 0 (d.leafK 0)),((3,elevenRow d.orientation 0 1),d.centerS 0+e (elevenRow d.orientation 0 1) (d.centerK 0)),((3,elevenRow d.orientation 1 1),d.centerS 1+e (elevenRow d.orientation 1 1) (d.centerK 1)),((3,1),d.leafS 1+e 1 (d.leafK 1)),((3,elevenRow d.orientation 0 2),d.centerS 0+e (elevenRow d.orientation 0 2) (d.centerK 0)),((3,elevenRow d.orientation 1 2),d.centerS 1+e (elevenRow d.orientation 1 2) (d.centerK 1)),((3,2),d.leafS 2+e 2 (d.leafK 2))]

/-- The actual oriented source geometry realizes its exact catalog index. -/
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
    · exact hK 0
    · exact hK 1
    · exact hK 2
    · exact hC 0
    · exact hC 1
    · exact hL 0
    · exact hL 1
    · exact hL 2
    · exact hH 0
    · exact hH 1
    · exact hH 2
  · intro k hk
    fin_cases k <;> simp [edge,elevenChecks]
  · intro k hk
    fin_cases k <;> simp [edge,elevenChecks,elevenRow,ho,Nat.add_assoc]
  · intro k hk
    fin_cases k <;> simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
  · intro k hk
    fin_cases k
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 0=(d.singleS 0+e 0 (d.singleK 0))+e (d.rightH 0) 0
      have hm := d.single_matching 0 0
      change d.singleS 0+e 0 (d.singleK 0)=d.rightT 0-e (d.rightH 0) 0 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 1=(d.singleS 0+e 1 (d.singleK 0))+e (d.rightH 1) 0
      have hm := d.single_matching 0 1
      change d.singleS 0+e 1 (d.singleK 0)=d.rightT 1-e (d.rightH 1) 0 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 2=(d.singleS 0+e 2 (d.singleK 0))+e (d.rightH 2) 0
      have hm := d.single_matching 0 2
      change d.singleS 0+e 2 (d.singleK 0)=d.rightT 2-e (d.rightH 2) 0 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 0=(d.singleS 1+e 0 (d.singleK 1))+e (d.rightH 0) 1
      have hm := d.single_matching 1 0
      change d.singleS 1+e 0 (d.singleK 1)=d.rightT 0-e (d.rightH 0) 1 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 1=(d.singleS 1+e 1 (d.singleK 1))+e (d.rightH 1) 1
      have hm := d.single_matching 1 1
      change d.singleS 1+e 1 (d.singleK 1)=d.rightT 1-e (d.rightH 1) 1 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 2=(d.singleS 1+e 2 (d.singleK 1))+e (d.rightH 2) 1
      have hm := d.single_matching 1 2
      change d.singleS 1+e 2 (d.singleK 1)=d.rightT 2-e (d.rightH 2) 1 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 0=(d.singleS 2+e 0 (d.singleK 2))+e (d.rightH 0) 2
      have hm := d.single_matching 2 0
      change d.singleS 2+e 0 (d.singleK 2)=d.rightT 0-e (d.rightH 0) 2 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 1=(d.singleS 2+e 1 (d.singleK 2))+e (d.rightH 1) 2
      have hm := d.single_matching 2 1
      change d.singleS 2+e 1 (d.singleK 2)=d.rightT 1-e (d.rightH 1) 2 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 2=(d.singleS 2+e 2 (d.singleK 2))+e (d.rightH 2) 2
      have hm := d.single_matching 2 2
      change d.singleS 2+e 2 (d.singleK 2)=d.rightT 2-e (d.rightH 2) 2 at hm
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching 0 0
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching 1 0
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 0=(d.leafS 0+e 0 (d.leafK 0))+e (d.rightH 0) 3
      have hm := d.leaf_matching 0
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching 0 1
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching 1 1
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 1=(d.leafS 1+e 1 (d.leafK 1))+e (d.rightH 1) 3
      have hm := d.leaf_matching 1
      linear_combination -hm
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching 0 2
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      exact d.internal_matching 1 2
    · simp [edge,elevenChecks,elevenQubits,ZEdge,CEdge]
      change d.rightT 2=(d.leafS 2+e 2 (d.leafK 2))+e (d.rightH 2) 3
      have hm := d.leaf_matching 2
      linear_combination -hm

#print axioms eleven_realization_of_geometry
end TruncatedDistance
