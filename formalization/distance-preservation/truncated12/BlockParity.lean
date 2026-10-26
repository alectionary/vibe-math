import GeneralLP
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : Nat} [NeZero L]

def leftMass (u : Fin 4 → Fin 4 → ZMod L → ZMod 2) (j : Fin 4) : ZMod 2 :=
  ∑ k, ∑ s, u j k s
def rightMass (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (i : Fin 3) : ZMod 2 :=
  ∑ l, ∑ s, v l i s

theorem sum_syndrome (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2) (j : Fin 4) (i : Fin 3) :
    (∑ t, GeneralLP.Syndrome e u v j i t) = leftMass u j + rightMass v i := by
  unfold GeneralLP.Syndrome
  rw [Finset.sum_add_distrib]
  congr 1
  · rw [Finset.sum_comm]
    simp_rw [sub_eq_add_neg, FamilyWords.sum_shift]
    rfl
  · rw [Finset.sum_comm]
    simp_rw [FamilyWords.sum_shift]
    rfl

/-- Every first-left block and second-right block has the same support parity.
This uses the actual arbitrary-base source syndrome, with no girth assumption. -/
theorem common_block_parity (e : Fin 3 → Fin 4 → ZMod L)
    (u : Fin 4 → Fin 4 → ZMod L → ZMod 2)
    (v : Fin 3 → Fin 3 → ZMod L → ZMod 2)
    (hk : ∀ j i t, GeneralLP.Syndrome e u v j i t = 0) :
    ∃ p : ZMod 2, (∀ j, leftMass u j = p) ∧ (∀ i, rightMass v i = p) := by
  have h (j : Fin 4) (i : Fin 3) : leftMass u j = rightMass v i := by
    apply CharTwo.add_eq_zero.mp
    rw [← sum_syndrome e u v j i]
    simp [hk]
  refine ⟨leftMass u 0, ?_, ?_⟩
  · intro j
    exact (h j 0).trans (h 0 0).symm
  · intro i
    exact (h 0 i).symm

#print axioms common_block_parity
end TruncatedDistance
