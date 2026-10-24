import BicycleMatrices
open Matrix
namespace Bicycle.Family
variable {n : ℕ}
def BadE (v : Var n) (c : Check n) : Prop := E (false,v.2) c
instance : DecidableRel (@BadE n) := fun v c => inferInstanceAs (Decidable (E (false,v.2) c))

theorem bad_entry {R : Type*} [Zero R] [One R] (c : Check n) (v : Var n) :
    BadX R c v = if BadE v c then 1 else 0 :=
  HX_entry (R := R) c (false,v.2)

def two : Finset (Var n) := {(false,0),(true,0)}
theorem two_card : (@two n).card = 2 := by simp [two]
theorem two_stopping : Incidence.Stopping BadE (@two n) := by
  classical
  refine ⟨by simp [two],?_⟩
  intro c
  by_cases hc : E (false,(0:Check n)) c
  · have heq : two.filter (fun v => BadE v c) = two := by
      apply Finset.filter_eq_self.mpr
      intro v hv
      simp only [two,Finset.mem_insert,Finset.mem_singleton] at hv
      rcases hv with rfl | rfl <;> exact hc
    rw [heq,two_card]
    omega
  · have heq : two.filter (fun v => BadE v c) = ∅ := by
      apply Finset.eq_empty_iff_forall_notMem.mpr
      intro v hv
      obtain ⟨hv,he⟩ := Finset.mem_filter.mp hv
      simp only [two,Finset.mem_insert,Finset.mem_singleton] at hv
      rcases hv with rfl | rfl <;> exact hc he
    rw [heq]
    simp

/-- A positive column rules out a singleton stopping support. -/
theorem positive_stopping_ge_two {V C : Type*} [DecidableEq V] [DecidableEq C]
    (E : V → C → Prop) [DecidableRel E] (positive : ∀ v, ∃ c, E v c)
    (S : Finset V) (hS : Incidence.Stopping E S) : 2 ≤ S.card := by
  classical
  by_contra h
  have hc : S.card = 1 := by have := Finset.card_pos.mpr hS.1; omega
  obtain ⟨v,rfl⟩ := Finset.card_eq_one.mp hc
  obtain ⟨c,hv⟩ := positive v
  exact hS.2 c (by simp only [Finset.filter_singleton,hv,↓reduceIte,Finset.card_singleton])

theorem bad_lower_two (T : Finset (Var n)) (hT : Incidence.Stopping BadE T) : 2 ≤ T.card :=
  positive_stopping_ge_two BadE (fun v => ⟨v.2, by simp [BadE,E,col]⟩) T hT

theorem bad_real_incidence (c : Check n) (v : Var n) : BadX (n := n) ℝ c v = 1 ↔ BadE v c := by
  rw [bad_entry]
  split <;> simp_all

/-- Any lower bound valid for these two CSS matrices and depending only on their
real Gram matrix returns at most two on the good family. This conclusion applies
also to every function of the Gram spectrum. -/
theorem gram_only_cannot_improve_two [NeZero n]
    (lower : Matrix (Check n) (Check n) ℝ → ℕ)
    (valid_bad : ∀ T : Finset (Var n), Incidence.Stopping
      (fun v c => BadX (n := n) ℝ c v = 1) T → lower (BadX (n := n) ℝ * (BadX (n := n) ℝ)ᵀ) ≤ T.card) :
    lower (HX (n := n) ℝ * (HX (n := n) ℝ)ᵀ) ≤ 2 := by
  rw [real_gram_equal]
  have he : (fun v c => BadX (n := n) ℝ c v = 1) = (@BadE n) := by
    funext v c
    exact propext (bad_real_incidence c v)
  have h := valid_bad two (by
    simpa only [Incidence.Stopping,bad_real_incidence] using (@two_stopping n))
  simpa [two_card] using h
end Bicycle.Family
