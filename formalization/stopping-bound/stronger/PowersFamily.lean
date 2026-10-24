import PowersThree
import SidonMatrices
namespace PowersThree
open Matrix

/-- Reusable family statement on every sufficiently long odd lift. -/
theorem positive_family (γ n : ℕ) [NeZero n]
    (hn : 3^γ ≤ n) (heven : Even γ) (hodd : Odd n) :
    let S := support γ n
    (SidonStopping.X (ZMod 2) S * (SidonStopping.X (ZMod 2) S)ᵀ = 0) ∧
    (∀ v, (Finset.univ.filter (fun c => SidonStopping.X (ZMod 2) S c v = 1)).card = γ) ∧
    (∀ c, (Finset.univ.filter (fun v => SidonStopping.X (ZMod 2) S c v = 1)).card = 2*γ) ∧
    (∀ T, Incidence.Stopping (SidonStopping.E S) T → 2*(γ+1) ≤ 3*T.card) ∧
    (SidonStopping.X (ZMod 2) S).mulVec (SidonStopping.leftOnes (G := ZMod n)) = 0 ∧
    (¬ ∃ a, (SidonStopping.X (ZMod 2) S)ᵀ.mulVec a =
      SidonStopping.leftOnes (G := ZMod n)) ∧
    (SidonStopping.X ℝ S * (SidonStopping.X ℝ S)ᵀ =
      SidonStopping.BadX ℝ S * (SidonStopping.BadX ℝ S)ᵀ) := by
  dsimp only
  have hcard := support_card γ n hn
  have he : Even (support γ n).card := by simpa [hcard] using heven
  refine ⟨SidonStopping.css _,?_,?_,?_,SidonStopping.leftOnes_kernel _ he,?_,SidonStopping.gram_equal _⟩
  · intro v; rw [SidonStopping.column_weight,hcard]
  · intro c; rw [SidonStopping.row_weight,hcard]
  · intro T hT
    simpa only [hcard] using SidonStopping.stopping_bound _ (sidon γ n hn) T hT
  · apply SidonStopping.leftOnes_not_stabilizer _ he
    simpa using hodd

def liftLength (d t : ℕ) : ℕ := 3^(2*d)*(2*t+1)
lemma lift_positive (d t : ℕ) : 0 < liftLength d t := by
  unfold liftLength
  exact Nat.mul_pos (pow_pos (by omega) _) (by omega)
lemma lift_large (d t : ℕ) : 3^(2*d) ≤ liftLength d t := by
  unfold liftLength
  have h := Nat.mul_le_mul_left (3^(2*d)) (by omega : 1 ≤ 2*t+1)
  simpa using h
lemma lift_odd (d t : ℕ) : Odd (liftLength d t) := by
  unfold liftLength
  have hp : Odd (3^(2*d)) := (show Odd (3:ℕ) by decide).pow
  exact hp.mul ⟨t,by omega⟩

theorem arbitrary_fixed_guarantee (d t : ℕ) [NeZero (liftLength d t)]
    (T : Finset (Bool × ZMod (liftLength d t)))
    (hT : Incidence.Stopping (SidonStopping.E (support (2*d) (liftLength d t))) T) :
    d+1 ≤ T.card := by
  have hb := SidonStopping.stopping_bound _ (sidon (2*d) _ (lift_large d t)) T hT
  rw [support_card (2*d) _ (lift_large d t)] at hb
  omega
end PowersThree

namespace PowersThree
theorem lengths_unbounded (d N : ℕ) : ∃ t, N < 2*liftLength d t := by
  refine ⟨N,?_⟩
  have hp : 1 ≤ (3:ℕ)^(2*d) := Nat.one_le_pow _ _ (by omega)
  unfold liftLength
  nlinarith
end PowersThree
