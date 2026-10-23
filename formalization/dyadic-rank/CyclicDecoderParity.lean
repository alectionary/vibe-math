import CyclicDecoderPersistence

/-! Parity persistence under even local decision changes. This explains the
retained finite-horizon two-variable oscillations, without assuming that the
full message state is periodic or that the behavior persists past the horizon. -/
namespace CyclicDecoderParity

def bitParity {V : Type*} : List V → (V → Bool) → Bool
  | [], _ => false
  | v :: vs, x => x v ^^ bitParity vs x

theorem bitParity_xor {V : Type*} (row : List V) (x y : V → Bool) :
    bitParity row (fun v => x v ^^ y v) = (bitParity row x ^^ bitParity row y) := by
  induction row with
  | nil => rfl
  | cons v vs ih =>
    simp only [bitParity, ih]
    exact CyclicMergedMessages.xor_shuffle _ _ _ _

theorem even_change_preserves {V : Type*} (row : List V) (x y : V → Bool)
    (even : bitParity row (fun v => x v ^^ y v) = false) :
    bitParity row x = bitParity row y := by
  rw [bitParity_xor] at even
  cases hx : bitParity row x <;> cases hy : bitParity row y <;> simp_all

/-- Even changes on one check preserve its incorrect parity for the stated horizon. -/
theorem wrong_parity_persists {V : Type*} (row : List V) (words : Nat → V → Bool)
    (target : Bool) (horizon : Nat)
    (wrong : bitParity row (words 0) ≠ target)
    (even : ∀ k, k < horizon → bitParity row (fun v => words k v ^^ words (k+1) v) = false) :
    ∀ k, k ≤ horizon → bitParity row (words k) ≠ target := by
  intro k
  induction k with
  | zero => intro _; exact wrong
  | succ k ih =>
    intro hk
    have same := even_change_preserves row (words k) (words (k+1)) (even k (by omega))
    rw [← same]
    exact ih (by omega)

/-- Knowing every local decision sign determines the check parity. -/
theorem knownSign_map {V : Type*} (row : List V) (bounds : V → CyclicDecoderPersistence.Interval)
    (bits : V → Bool)
    (known : ∀ v ∈ row, CyclicDecoderPersistence.signRange (bounds v) = some (bits v)) :
    CyclicDecoderPersistence.knownSign (row.map bounds) = some (bitParity row bits) := by
  induction row with
  | nil => rfl
  | cons v vs ih =>
    have head := known v (by simp)
    have tail : ∀ w ∈ vs, CyclicDecoderPersistence.signRange (bounds w) = some (bits w) := by
      intro w hw
      exact known w (by simp [hw])
    simp only [List.map_cons, CyclicDecoderPersistence.knownSign, head, ih tail,
      CyclicDecoderPersistence.xorKnown, bitParity]

end CyclicDecoderParity
#print axioms CyclicDecoderParity.wrong_parity_persists
#print axioms CyclicDecoderParity.knownSign_map
