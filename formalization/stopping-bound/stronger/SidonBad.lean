import SidonMatrices
import BadStopping
namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
def badE (S : Finset G) (v : Bool × G) (c : G) : Prop := c-v.2 ∈ S
instance (S : Finset G) : DecidableRel (badE S) := fun v c =>
  inferInstanceAs (Decidable (c-v.2 ∈ S))
def twin : Finset (Bool × G) := {(false,0),(true,0)}
theorem twin_card : (twin (G := G)).card = 2 := by simp [twin]
theorem twin_stopping (S : Finset G) : Incidence.Stopping (badE S) (twin (G := G)) := by
  classical
  refine ⟨by simp [twin],?_⟩
  intro c
  by_cases hc : c ∈ S
  · have heq : twin.filter (fun v => badE S v c) = twin := by
      apply filter_eq_self.mpr
      intro v hv
      simp only [twin,mem_insert,mem_singleton] at hv
      rcases hv with rfl | rfl <;> simpa [badE] using hc
    rw [heq,twin_card]
    omega
  · have heq : twin.filter (fun v => badE S v c) = ∅ := by
      apply eq_empty_iff_forall_notMem.mpr
      intro v hv
      obtain ⟨hv,he⟩ := mem_filter.mp hv
      simp only [twin,mem_insert,mem_singleton] at hv
      rcases hv with rfl | rfl <;> exact hc (by simpa [badE] using he)
    rw [heq]
    simp

theorem bad_lower_two (S : Finset G) (hS : S.Nonempty) (T : Finset (Bool × G))
    (hT : Incidence.Stopping (badE S) T) : 2 ≤ T.card := by
  apply Bicycle.Family.positive_stopping_ge_two (badE S) _ T hT
  intro v
  obtain ⟨s,hs⟩ := hS
  exact ⟨s+v.2,by simpa [badE] using hs⟩

theorem bad_entry (R : Type*) [Zero R] [One R] (S : Finset G) (v : Bool × G) (c : G) :
    BadX R S c v = if badE S v c then 1 else 0 := rfl

theorem bad_row_weight (S : Finset G) (c : G) :
    (univ.filter (fun v => BadX (ZMod 2) S c v = 1)).card = 2*S.card := by
  have hi : (fun v : Bool × G => BadX (ZMod 2) S c v = 1) =
      (fun v => c-v.2 ∈ S) := by
    funext v
    simp only [bad_entry,badE]
    apply propext
    by_cases hc : c-v.2 ∈ S <;> simp [hc]
  simp only [hi]
  rw [← univ_product_univ]
  rw [filter_product_right (s := (univ : Finset Bool)) (t := (univ : Finset G)) (fun j : G => c-j ∈ S),card_product]
  have he : (univ.filter (fun j : G => c-j ∈ S)).card = S.card := by
    -- Reversal is a bijection: this row uses c-j, rather than j-c.
    have heq : univ.filter (fun j : G => c-j ∈ S) = S.image (fun s => c-s) := by
      ext j
      simp only [mem_filter,mem_univ,true_and,mem_image]
      exact ⟨fun hj => ⟨c-j,hj,by abel⟩,fun ⟨s,hs,he⟩ => by simpa [← he] using hs⟩
    rw [heq,card_image_of_injective _ (sub_right_injective : Function.Injective (fun s : G => c-s))]
  simp only [card_univ,Fintype.card_bool,he]

theorem gram_only_bound (S : Finset G)
    (lower : Matrix G G ℝ → ℕ)
    (valid_bad : ∀ T : Finset (Bool × G), Incidence.Stopping (badE S) T →
      lower (BadX ℝ S * (BadX ℝ S)ᵀ) ≤ T.card) :
    lower (X ℝ S * (X ℝ S)ᵀ) ≤ 2 := by
  rw [gram_equal]
  have h := valid_bad twin (twin_stopping S)
  simpa [twin_card] using h
end SidonStopping

namespace SidonStopping
open Matrix Finset
variable {G : Type*} [Fintype G] [AddCommGroup G] [DecidableEq G]
theorem bad_binary_incidence (S : Finset G) (v : Bool × G) (c : G) :
    BadX (ZMod 2) S c v = 1 ↔ badE S v c := by
  rw [bad_entry]
  by_cases h : badE S v c <;> simp [h]
theorem bad_column_weight (S : Finset G) (v : Bool × G) :
    (univ.filter (fun c => BadX (ZMod 2) S c v = 1)).card = S.card := by
  have hh := degree S (false,v.2)
  change (univ.filter (fun c : G => c-v.2 ∈ S)).card = S.card at hh
  simpa only [bad_binary_incidence,badE] using hh
theorem spectral_data_equal {Data : Type*} (S : Finset G)
    (f : Matrix G G ℝ → Data) :
    f (X ℝ S * (X ℝ S)ᵀ) = f (BadX ℝ S * (BadX ℝ S)ᵀ) :=
  congrArg f (gram_equal S)
end SidonStopping
