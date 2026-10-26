import TenGeometry
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
  ![.inl ((1,d.K 0 0),d.S 0),.inl ((1,d.K 0 1),d.S 0),.inl ((2,d.K 1 0),d.S 1),.inl ((2,d.K 1 1),d.S 1),.inl ((3,d.K 2 0),d.S 2),.inl ((3,d.K 2 1),d.S 2),.inr ((d.H 0 0,1),d.T 0),.inr ((d.H 0 1,1),d.T 0),.inr ((d.H 1 0,2),d.T 1),.inr ((d.H 1 1,2),d.T 1)]

def tenChecks (d : TenGeometry e u v) : Fin 18 → SourceModel.ZCheck L :=
  ![((1,0),d.S 0),((2,0),d.S 1),((3,0),d.S 2),((0,1),d.T 0),((1,1),d.S 0+e 1 (d.K 0 0)),((1,1),d.S 0+e 1 (d.K 0 1)),((2,1),d.S 1+e 1 (d.K 1 0)),((2,1),d.S 1+e 1 (d.K 1 1)),((3,1),d.S 2+e 1 (d.K 2 0)),((3,1),d.S 2+e 1 (d.K 2 1)),((0,2),d.T 1),((1,2),d.S 0+e 2 (d.K 0 0)),((1,2),d.S 0+e 2 (d.K 0 1)),((2,2),d.S 1+e 2 (d.K 1 0)),((2,2),d.S 1+e 2 (d.K 1 1)),((3,2),d.S 2+e 2 (d.K 2 0)),((3,2),d.S 2+e 2 (d.K 2 1)),((0,0),0)]

/-- The actual pair geometry realizes precisely its finite catalog index. -/
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
    · rw [show column10 (tenRank c r bits) 0=(c 0).val from tenRank_columns c r bits 0]
      exact hK 0 0
    · rw [show column10 (tenRank c r bits) 0=(c 0).val from tenRank_columns c r bits 0]
      exact hK 0 1
    · rw [show column10 (tenRank c r bits) 1=(c 1).val from tenRank_columns c r bits 1]
      exact hK 1 0
    · rw [show column10 (tenRank c r bits) 1=(c 1).val from tenRank_columns c r bits 1]
      exact hK 1 1
    · rw [show column10 (tenRank c r bits) 2=(c 2).val from tenRank_columns c r bits 2]
      exact hK 2 0
    · rw [show column10 (tenRank c r bits) 2=(c 2).val from tenRank_columns c r bits 2]
      exact hK 2 1
    · rw [show row10 (tenRank c r bits) 0=(r 0).val from tenRank_rows c r bits 0]
      exact hH 0 0
    · rw [show row10 (tenRank c r bits) 0=(r 0).val from tenRank_rows c r bits 0]
      exact hH 0 1
    · rw [show row10 (tenRank c r bits) 1=(r 1).val from tenRank_rows c r bits 1]
      exact hH 1 0
    · rw [show row10 (tenRank c r bits) 1=(r 1).val from tenRank_rows c r bits 1]
      exact hH 1 1
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;> simp [edge,tenChecks]
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;> simp [edge,tenChecks]
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk <;>
      simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
  · intro k hk
    fin_cases k <;> norm_num [edgeCount] at hk
    · simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
    · simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
    · simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
    · simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
    · have hb : (d.flip 0 0).val=0 ∨ (d.flip 0 0).val=1 := by
        have := (d.flip 0 0).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 0 0=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 0=0 := (hflip 0 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 0+e 1 (d.K 0 0))+e (d.H 0 0) 1
        have hm := d.matching 0 0 0
        simp only [he] at hm
        change d.S 0+e 1 (d.K 0 0)=d.T 0-e (d.H 0 0) 1 at hm
        linear_combination -hm
      · have he : d.flip 0 0=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 0=1 := (hflip 0 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 0+e 1 (d.K 0 0))+e (d.H 0 1) 1
        have hm := d.matching 0 0 0
        simp only [he] at hm
        change d.S 0+e 1 (d.K 0 0)=d.T 0-e (d.H 0 1) 1 at hm
        linear_combination -hm
    · have hb : (d.flip 0 0).val=0 ∨ (d.flip 0 0).val=1 := by
        have := (d.flip 0 0).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 0 0=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 0=0 := (hflip 0 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 0+e 1 (d.K 0 1))+e (d.H 0 1) 1
        have hm := d.matching 0 0 1
        simp only [he] at hm
        change d.S 0+e 1 (d.K 0 1)=d.T 0-e (d.H 0 1) 1 at hm
        linear_combination -hm
      · have he : d.flip 0 0=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 0=1 := (hflip 0 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 0+e 1 (d.K 0 1))+e (d.H 0 0) 1
        have hm := d.matching 0 0 1
        simp only [he] at hm
        change d.S 0+e 1 (d.K 0 1)=d.T 0-e (d.H 0 0) 1 at hm
        linear_combination -hm
    · have hb : (d.flip 0 1).val=0 ∨ (d.flip 0 1).val=1 := by
        have := (d.flip 0 1).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 0 1=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 1=0 := (hflip 0 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 1+e 1 (d.K 1 0))+e (d.H 0 0) 2
        have hm := d.matching 0 1 0
        simp only [he] at hm
        change d.S 1+e 1 (d.K 1 0)=d.T 0-e (d.H 0 0) 2 at hm
        linear_combination -hm
      · have he : d.flip 0 1=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 1=1 := (hflip 0 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 1+e 1 (d.K 1 0))+e (d.H 0 1) 2
        have hm := d.matching 0 1 0
        simp only [he] at hm
        change d.S 1+e 1 (d.K 1 0)=d.T 0-e (d.H 0 1) 2 at hm
        linear_combination -hm
    · have hb : (d.flip 0 1).val=0 ∨ (d.flip 0 1).val=1 := by
        have := (d.flip 0 1).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 0 1=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 1=0 := (hflip 0 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 1+e 1 (d.K 1 1))+e (d.H 0 1) 2
        have hm := d.matching 0 1 1
        simp only [he] at hm
        change d.S 1+e 1 (d.K 1 1)=d.T 0-e (d.H 0 1) 2 at hm
        linear_combination -hm
      · have he : d.flip 0 1=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 1=1 := (hflip 0 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 1+e 1 (d.K 1 1))+e (d.H 0 0) 2
        have hm := d.matching 0 1 1
        simp only [he] at hm
        change d.S 1+e 1 (d.K 1 1)=d.T 0-e (d.H 0 0) 2 at hm
        linear_combination -hm
    · have hb : (d.flip 0 2).val=0 ∨ (d.flip 0 2).val=1 := by
        have := (d.flip 0 2).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 0 2=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 2=0 := (hflip 0 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 2+e 1 (d.K 2 0))+e (d.H 0 0) 3
        have hm := d.matching 0 2 0
        simp only [he] at hm
        change d.S 2+e 1 (d.K 2 0)=d.T 0-e (d.H 0 0) 3 at hm
        linear_combination -hm
      · have he : d.flip 0 2=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 2=1 := (hflip 0 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 2+e 1 (d.K 2 0))+e (d.H 0 1) 3
        have hm := d.matching 0 2 0
        simp only [he] at hm
        change d.S 2+e 1 (d.K 2 0)=d.T 0-e (d.H 0 1) 3 at hm
        linear_combination -hm
    · have hb : (d.flip 0 2).val=0 ∨ (d.flip 0 2).val=1 := by
        have := (d.flip 0 2).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 0 2=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 2=0 := (hflip 0 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 2+e 1 (d.K 2 1))+e (d.H 0 1) 3
        have hm := d.matching 0 2 1
        simp only [he] at hm
        change d.S 2+e 1 (d.K 2 1)=d.T 0-e (d.H 0 1) 3 at hm
        linear_combination -hm
      · have he : d.flip 0 2=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 0 2=1 := (hflip 0 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 0=(d.S 2+e 1 (d.K 2 1))+e (d.H 0 0) 3
        have hm := d.matching 0 2 1
        simp only [he] at hm
        change d.S 2+e 1 (d.K 2 1)=d.T 0-e (d.H 0 0) 3 at hm
        linear_combination -hm
    · simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hR0,hC0]
    · have hb : (d.flip 1 0).val=0 ∨ (d.flip 1 0).val=1 := by
        have := (d.flip 1 0).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 1 0=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 0=0 := (hflip 1 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 0+e 2 (d.K 0 0))+e (d.H 1 0) 1
        have hm := d.matching 1 0 0
        simp only [he] at hm
        change d.S 0+e 2 (d.K 0 0)=d.T 1-e (d.H 1 0) 1 at hm
        linear_combination -hm
      · have he : d.flip 1 0=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 0=1 := (hflip 1 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 0+e 2 (d.K 0 0))+e (d.H 1 1) 1
        have hm := d.matching 1 0 0
        simp only [he] at hm
        change d.S 0+e 2 (d.K 0 0)=d.T 1-e (d.H 1 1) 1 at hm
        linear_combination -hm
    · have hb : (d.flip 1 0).val=0 ∨ (d.flip 1 0).val=1 := by
        have := (d.flip 1 0).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 1 0=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 0=0 := (hflip 1 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 0+e 2 (d.K 0 1))+e (d.H 1 1) 1
        have hm := d.matching 1 0 1
        simp only [he] at hm
        change d.S 0+e 2 (d.K 0 1)=d.T 1-e (d.H 1 1) 1 at hm
        linear_combination -hm
      · have he : d.flip 1 0=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 0=1 := (hflip 1 0).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 0+e 2 (d.K 0 1))+e (d.H 1 0) 1
        have hm := d.matching 1 0 1
        simp only [he] at hm
        change d.S 0+e 2 (d.K 0 1)=d.T 1-e (d.H 1 0) 1 at hm
        linear_combination -hm
    · have hb : (d.flip 1 1).val=0 ∨ (d.flip 1 1).val=1 := by
        have := (d.flip 1 1).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 1 1=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 1=0 := (hflip 1 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 1+e 2 (d.K 1 0))+e (d.H 1 0) 2
        have hm := d.matching 1 1 0
        simp only [he] at hm
        change d.S 1+e 2 (d.K 1 0)=d.T 1-e (d.H 1 0) 2 at hm
        linear_combination -hm
      · have he : d.flip 1 1=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 1=1 := (hflip 1 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 1+e 2 (d.K 1 0))+e (d.H 1 1) 2
        have hm := d.matching 1 1 0
        simp only [he] at hm
        change d.S 1+e 2 (d.K 1 0)=d.T 1-e (d.H 1 1) 2 at hm
        linear_combination -hm
    · have hb : (d.flip 1 1).val=0 ∨ (d.flip 1 1).val=1 := by
        have := (d.flip 1 1).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 1 1=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 1=0 := (hflip 1 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 1+e 2 (d.K 1 1))+e (d.H 1 1) 2
        have hm := d.matching 1 1 1
        simp only [he] at hm
        change d.S 1+e 2 (d.K 1 1)=d.T 1-e (d.H 1 1) 2 at hm
        linear_combination -hm
      · have he : d.flip 1 1=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 1=1 := (hflip 1 1).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 1+e 2 (d.K 1 1))+e (d.H 1 0) 2
        have hm := d.matching 1 1 1
        simp only [he] at hm
        change d.S 1+e 2 (d.K 1 1)=d.T 1-e (d.H 1 0) 2 at hm
        linear_combination -hm
    · have hb : (d.flip 1 2).val=0 ∨ (d.flip 1 2).val=1 := by
        have := (d.flip 1 2).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 1 2=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 2=0 := (hflip 1 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 2+e 2 (d.K 2 0))+e (d.H 1 0) 3
        have hm := d.matching 1 2 0
        simp only [he] at hm
        change d.S 2+e 2 (d.K 2 0)=d.T 1-e (d.H 1 0) 3 at hm
        linear_combination -hm
      · have he : d.flip 1 2=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 2=1 := (hflip 1 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 2+e 2 (d.K 2 0))+e (d.H 1 1) 3
        have hm := d.matching 1 2 0
        simp only [he] at hm
        change d.S 2+e 2 (d.K 2 0)=d.T 1-e (d.H 1 1) 3 at hm
        linear_combination -hm
    · have hb : (d.flip 1 2).val=0 ∨ (d.flip 1 2).val=1 := by
        have := (d.flip 1 2).isLt
        omega
      rcases hb with hb|hb
      · have he : d.flip 1 2=0 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 2=0 := (hflip 1 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 2+e 2 (d.K 2 1))+e (d.H 1 1) 3
        have hm := d.matching 1 2 1
        simp only [he] at hm
        change d.S 2+e 2 (d.K 2 1)=d.T 1-e (d.H 1 1) 3 at hm
        linear_combination -hm
      · have he : d.flip 1 2=1 := Fin.ext hb
        have hf : flip10 (tenRank c r bits) 1 2=1 := (hflip 1 2).trans hb
        simp [edge,tenChecks,tenQubits,ZEdge,CEdge,hf]
        change d.T 1=(d.S 2+e 2 (d.K 2 1))+e (d.H 1 0) 3
        have hm := d.matching 1 2 1
        simp only [he] at hm
        change d.S 2+e 2 (d.K 2 1)=d.T 1-e (d.H 1 0) 3 at hm
        linear_combination -hm

#print axioms ten_realization_of_geometry
end TruncatedDistance
