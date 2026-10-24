import BinarySupportEquiv
import Mathlib.Tactic.NormNum

set_option maxHeartbeats 0
namespace BinaryDistance
open Matrix BinarySupportEquiv PaschKernelCount
open scoped BigOperators
variable {V C : Type*} [Fintype V] [Fintype C] [DecidableEq V] [DecidableEq C]

def weight (x : V → ZMod 2) : ℕ := (bitSupport x).card

theorem support_empty_iff (x : V → ZMod 2) : bitSupport x=∅ ↔ x=0 := by
  constructor
  · intro h
    rw [← indicator_support x,h]
    funext v
    simp [supportIndicator]
  · rintro rfl
    simp [bitSupport]

theorem column_sum (H : V → Finset C) (hd : ∀ v, (H v).card=3) (v : V) :
    (∑ c, checkMatrix H c v : ZMod 2)=1 := by
  change (∑ c, if c∈H v then (1 : ZMod 2) else 0)=1
  have hc : (∑ c, if c∈H v then (1 : ZMod 2) else 0)=((H v).card : ZMod 2) := by
    simp [← Finset.sum_filter]
  rw [hc,hd]
  decide

theorem kernel_even (H : V → Finset C) (hd : ∀ v, (H v).card=3)
    (x : V → ZMod 2) (hx : checkMatrix H *ᵥ x=0) : weight x%2=0 := by
  have hs : ∑ v, x v=0 := by
    calc
      ∑ v, x v=∑ v, (∑ c, checkMatrix H c v)*x v := by simp only [column_sum H hd,one_mul]
      _=∑ c, (checkMatrix H *ᵥ x) c := by
        simp only [Matrix.mulVec,dotProduct,Finset.sum_mul]
        exact Finset.sum_comm
      _=0 := by rw [hx]; simp
  have hi : ∑ v, x v=(weight x : ZMod 2) := by
    conv_lhs => rw [← indicator_support x]
    simp [supportIndicator,weight,← Finset.sum_filter]
  rw [hi] at hs
  exact Nat.mod_eq_zero_of_dvd ((ZMod.natCast_eq_zero_iff _ _).mp hs)

theorem no_weight_two (H : V → Finset C) (hd : ∀ v, (H v).card=3)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (x : V → ZMod 2) (hx : checkMatrix H *ᵥ x=0) : weight x≠2 := by
  intro hw
  obtain ⟨u,v,huv,hS⟩ := Finset.card_eq_two.mp hw
  have hi : x=supportIndicator {u,v} := by
    rw [← hS]
    exact (indicator_support x).symm
  have hh : H u=H v := by
    ext c
    have hz := congrFun hx c
    rw [hi] at hz
    have he : ((checkMatrix H)*ᵥsupportIndicator {u,v}) c=
        (if c∈H u then 1 else 0)+(if c∈H v then 1 else 0) := by
      rw [matrix_indicator_eq_selected]
      simp only [GlobalCounting.selected,Finset.filter_insert,Finset.filter_singleton,
        Finset.mem_singleton]
      by_cases hu : c∈H u <;> by_cases hv : c∈H v <;> simp [hu,hv,huv]
      all_goals decide
    rw [he] at hz
    by_cases hu : c∈H u <;> by_cases hv : c∈H v <;> simp [hu,hv] at hz ⊢
  have hl := h4 u v huv
  rw [hh,Finset.inter_self,hd] at hl
  omega

/-- Cubicity, linearity and absence of weight four give minimum nonzero kernel weight at least six. -/
theorem lower_bound (H : V → Finset C) (hd : ∀ v, (H v).card=3)
    (h4 : ∀ u v, u≠v → (H u ∩ H v).card≤1)
    (hn4 : ∀ x : V → ZMod 2, checkMatrix H *ᵥx=0 → weight x≠4)
    (x : V → ZMod 2) (hx : checkMatrix H *ᵥ x=0) (hn : x≠0) : 6≤weight x := by
  have hp := kernel_even H hd x hx
  have h2 := no_weight_two H hd h4 x hx
  have h4x := hn4 x hx
  have h0 : weight x≠0 := by
    intro h
    exact hn ((support_empty_iff x).mp (Finset.card_eq_zero.mp h))
  omega

#print axioms kernel_even
#print axioms no_weight_two
#print axioms lower_bound
end BinaryDistance
