import FamilyLogical

set_option maxHeartbeats 0
namespace FamilyPauliDistance
open Matrix FamilyRank FamilyLogical CyclicRecurrence

variable (q : ℕ) [NeZero q]

def pauliWeight (x z : Qubits q → F) : ℕ :=
  (BinarySupportEquiv.bitSupport x ∪ BinarySupportEquiv.bitSupport z).card

def Logical (x z : Qubits q → F) : Prop :=
  (X q*ᵥz=0 ∧ Z q*ᵥx=0) ∧
  (x∉LinearMap.range (X q).transpose.mulVecLin ∨ z∉LinearMap.range (Z q).transpose.mulVecLin)

theorem lower (hq : 2≤q) (x z : Qubits q → F) (h : Logical q x z) : 6≤pauliWeight q x z := by
  rcases h with ⟨⟨hx,hz⟩,hn⟩
  have hl := (FamilyLogical.distance_six q hq).1
  rcases hn with hn | hn
  · have h6 := hl x (Or.inr ⟨hz,hn⟩)
    exact h6.trans (Finset.card_le_card Finset.subset_union_left)
  · have h6 := hl z (Or.inl ⟨hx,hn⟩)
    exact h6.trans (Finset.card_le_card Finset.subset_union_right)

theorem witness_logical : Logical q 0 (word q) := by
  refine ⟨⟨word_kernel q,?_⟩,Or.inr (logical_nontrivial q)⟩
  simp

theorem witness_weight : pauliWeight q 0 (word q)=6 := by
  simpa [pauliWeight,BinarySupportEquiv.bitSupport,BinaryDistance.weight] using word_weight q

/-- Exact quantum CSS distance for mixed Pauli supports, not merely a classical minimum. -/
theorem distance_six (hq : 2≤q) :
    (∀ x z : Qubits q → F, Logical q x z → 6≤pauliWeight q x z) ∧
    (Logical q 0 (word q) ∧ pauliWeight q 0 (word q)=6) :=
  ⟨lower q hq,witness_logical q,witness_weight q⟩

#print axioms lower
#print axioms witness_logical
#print axioms witness_weight
#print axioms distance_six
end FamilyPauliDistance
