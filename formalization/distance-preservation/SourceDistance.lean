import FamilyTheorem
import SourceSectors
set_option maxHeartbeats 0
namespace SourceDistance
variable {L : Nat} [NeZero L]
open FamilyWords SourceModel

def C (c : Fin 3 × ZMod L) (v : Fin 4 × ZMod L) : ZMod 2 :=
  P (FamilyWords.exponent c.1 v.1) c.2 v.2

theorem c_action (x : CyclicCover.Word (ZMod L)) (c : Fin 3 × ZMod L) :
    (∑ v, C c v * x v) = CyclicCover.boundary DistanceFamily.liftE x c := by
  simp only [Fintype.sum_prod_type,C]
  simp_rw [P_action]
  rfl

def LogicalX (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  (∀ c : ZCheck L, ∑ q, HZ c q * SourceModel.join u v q = 0) ∧ ¬ InSpanX u v

def LogicalZ (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) : Prop :=
  (∀ c : XCheck L, ∑ q, HX c q * SourceModel.join u v q = 0) ∧ ¬ InSpanZ u v

theorem logicalX_iff (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    LogicalX u v ↔ DistanceFamily.LogicalX u v := by
  have hz : (∀ c : ZCheck L, ∑ q, HZ c q * SourceModel.join u v q = 0) ↔
      ∀ j i t, Syndrome u v j i t = 0 := by
    constructor
    · intro h j i t; exact (z_action u v j i t).symm.trans (h ((j,i),t))
    · intro h c; exact (z_action u v c.1.1 c.1.2 c.2).trans (h _ _ _)
  simp only [LogicalX,hz,inSpanX_iff,DistanceFamily.LogicalX]

theorem logicalZ_iff (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) :
    LogicalZ u v ↔ DistanceFamily.LogicalX (DistanceFamily.transpose u) (DistanceFamily.transpose v) := by
  have hx : (∀ c : XCheck L, ∑ q, HX c q * SourceModel.join u v q = 0) ↔
      ∀ j i t, Syndrome (SourceModel.transpose u) (SourceModel.transpose v) j i t = 0 := by
    constructor
    · intro h j i t; exact (x_action u v i j t).symm.trans (h ((i,j),t))
    · intro h c; exact (x_action u v c.1.1 c.1.2 c.2).trans (h _ _ _)
  simp only [LogicalZ,hx,inSpanZ_iff,DistanceFamily.LogicalX]
  rfl

def ClassicalHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ x : CyclicCover.Word (ZMod L), (∀ c, ∑ v, C c v * x v = 0) ∧ x ≠ 0 ∧
    (CoverWeight.support x).card = n

def QuantumHasWeight (L : Nat) [NeZero L] (n : Nat) : Prop :=
  ∃ u : Fin 4 → Fin 4 → ZMod L → ZMod 2,
    ∃ v : Fin 3 → Fin 3 → ZMod L → ZMod 2,
      (LogicalX u v ∨ LogicalZ u v) ∧
      (CoverWeight.support (SourceModel.join u v)).card = n

theorem classical_weight_iff (n : Nat) :
    ClassicalHasWeight L n ↔ DistanceFamily.ClassicalHasWeight L n := by
  simp only [ClassicalHasWeight,DistanceFamily.ClassicalHasWeight,c_action,CyclicCover.Kernel]

theorem quantum_weight_iff (n : Nat) :
    QuantumHasWeight L n ↔ DistanceFamily.QuantumHasWeight L n := by
  simp only [QuantumHasWeight,DistanceFamily.QuantumHasWeight,logicalX_iff,logicalZ_iff]
  rfl

/-- Every actual nonzero classical source codeword is heavier than the explicit
actual quantum logical, in the full quotient and with both sectors available. -/
theorem source_counterfamily (hL : 11 ∣ L) :
    (∀ x : CyclicCover.Word (ZMod L),
      (∀ c, ∑ v, C c v * x v = 0) → x ≠ 0 → 12 ≤ (CoverWeight.support x).card) ∧
    (∃ u : Fin 4 → Fin 4 → ZMod L → ZMod 2,
      ∃ v : Fin 3 → Fin 3 → ZMod L → ZMod 2,
      LogicalX u v ∧ (CoverWeight.support (SourceModel.join u v)).card ≤ 11) := by
  constructor
  · intro x hx hn
    exact DistanceFamily.classical_lower_twelve hL x (fun c => (c_action x c).symm.trans (hx c)) hn
  · exact ⟨U,V,(logicalX_iff U V).mpr DistanceFamily.explicit_logical,DistanceFamily.explicit_weight⟩

#print axioms c_action
#print axioms logicalX_iff
#print axioms logicalZ_iff
#print axioms quantum_weight_iff
#print axioms source_counterfamily
end SourceDistance
