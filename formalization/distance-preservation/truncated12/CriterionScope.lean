import ProfileTransport
set_option maxHeartbeats 0
namespace TruncatedDistance
variable {L : ℕ} [NeZero L]

/-- Full source three-row RCPC, written in the normalized exponent model. -/
def NoFullRowRCPC (e : Fin 3 → Fin 4 → ZMod L) : Prop :=
  ∀ i j k : Fin 3,i≠j → i≠k → j≠k → ¬(∀ c,rowForm e i j k c=0)

/-- The strengthened three-column repetition test already excludes full-row
RCPC. Thus omitting a separate redundant field does not change the source scope. -/
theorem no_full_row_of_no_triple (e : Fin 3 → Fin 4 → ZMod L) (h : NoTripleRow e) :
    NoFullRowRCPC e := by
  intro i j k hij hik hjk hz
  apply h i j k hij hik hjk 0 1 2 (by decide) (by decide) (by decide)
  rw [hz 0,hz 1,hz 2]
  exact ⟨rfl,rfl⟩

#print axioms no_full_row_of_no_triple
end TruncatedDistance
