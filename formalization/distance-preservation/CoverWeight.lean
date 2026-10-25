import Mathlib.Data.ZMod.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

set_option maxHeartbeats 0
namespace CoverWeight
variable {A B : Type*} [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B]

def support (x : A → ZMod 2) : Finset A := Finset.univ.filter (fun a => x a ≠ 0)
def push (p : A → B) (x : A → ZMod 2) (b : B) : ZMod 2 :=
  ∑ a, if p a = b then x a else 0

lemma nonzero_one (a : ZMod 2) (h : a ≠ 0) : a = 1 := by
  fin_cases a
  · exact False.elim (h rfl)
  · rfl

theorem sum_eq_card_support (s : Finset A) (x : A → ZMod 2) :
    (∑ a ∈ s, x a) = ((s.filter (fun a => x a ≠ 0)).card : ZMod 2) := by
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
    by_cases hx : x a = 0
    · simp [Finset.sum_insert,Finset.filter_insert,ha,hx,ih]
    · have hx1 := nonzero_one (x a) hx
      simp [Finset.sum_insert,Finset.filter_insert,ha,hx1,ih,Nat.cast_add,add_comm]

theorem push_eq_card (p : A → B) (x : A → ZMod 2) (b : B) :
    push p x b = (((support x).filter (fun a => p a = b)).card : ZMod 2) := by
  unfold push
  rw [← Finset.sum_filter, sum_eq_card_support]
  congr 1
  congr 1
  ext a
  simp [support,and_comm,and_left_comm,and_assoc]

theorem push_support_subset (p : A → B) (x : A → ZMod 2) :
    support (push p x) ⊆ (support x).image p := by
  intro b hb
  have hn : push p x b ≠ 0 := (Finset.mem_filter.mp hb).2
  by_contra h
  have he : (support x).filter (fun a => p a = b) = ∅ := by
    apply Finset.eq_empty_iff_forall_notMem.mpr
    intro a ha
    rcases Finset.mem_filter.mp ha with ⟨hs,hp⟩
    exact h (Finset.mem_image.mpr ⟨a,hs,hp⟩)
  have hh := push_eq_card p x b
  rw [he,Finset.card_empty,Nat.cast_zero] at hh
  exact hn hh

theorem push_weight_le (p : A → B) (x : A → ZMod 2) :
    (support (push p x)).card ≤ (support x).card :=
  (Finset.card_le_card (push_support_subset p x)).trans (Finset.card_image_le)

theorem zero_push_fiber_lower (p : A → B) (x : A → ZMod 2) (hz : push p x = 0)
    (b : B) (hb : b ∈ (support x).image p) :
    2 ≤ ((support x).filter (fun a => p a = b)).card := by
  obtain ⟨a,ha,hp⟩ := Finset.mem_image.mp hb
  have hpos : 0 < ((support x).filter (fun a => p a = b)).card :=
    Finset.card_pos.mpr ⟨a,Finset.mem_filter.mpr ⟨ha,hp⟩⟩
  have hc := push_eq_card p x b
  have he := congrFun hz b
  rw [he] at hc
  have hne : ((support x).filter (fun a => p a = b)).card ≠ 1 := by
    intro h1
    rw [h1] at hc
    norm_num at hc
  omega

/-- If binary projection cancels completely, every occupied base fiber costs
at least two selected variables. -/
theorem zero_push_weight_doubles (p : A → B) (x : A → ZMod 2) (hz : push p x = 0) :
    2 * ((support x).image p).card ≤ (support x).card := by
  calc
    2 * ((support x).image p).card = ∑ b ∈ (support x).image p, 2 := by simp [Nat.mul_comm]
    _ ≤ ∑ b ∈ (support x).image p, ((support x).filter (fun a => p a = b)).card :=
      Finset.sum_le_sum (fun b hb => zero_push_fiber_lower p x hz b hb)
    _ = (support x).card := (Finset.card_eq_sum_card_image p (support x)).symm

#print axioms push_weight_le
#print axioms zero_push_weight_doubles
end CoverWeight
