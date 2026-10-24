import HGPPatterns
import GramCounterexample12
import FanoBlock
import Mathlib.Tactic.Ring
set_option maxHeartbeats 0
set_option maxRecDepth 4096
namespace HGPCounts
open HGPIncidence HGPPatterns
variable {U C D E : Type*}
    [Fintype U] [Fintype C] [Fintype D] [Fintype E]
    [DecidableEq U] [DecidableEq C] [DecidableEq D] [DecidableEq E]

theorem cubic (H1 : U → Finset C) (H2 : E → Finset D)
    (h1 : ∀ u, (H1 u).card=3) (h2 : ∀ e, (H2 e).card=3) :
    ∀ v, (columns H1 H2 v).card=3 := by
  intro v
  cases v with
  | inl x => rcases x with ⟨u,a⟩; simp [columns,h1]
  | inr x => rcases x with ⟨c,b⟩; simp [columns,h2]

theorem inter_left (H1 : U → Finset C) (H2 : E → Finset D) (u v : U) (a : D) :
    columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inl (v,a)) = (H1 u ∩ H1 v) ×ˢ {a} := by
  ext x
  rcases x with ⟨c,t⟩
  simp [columns,and_assoc,and_left_comm,and_comm]

theorem inter_right (H1 : U → Finset C) (H2 : E → Finset D) (c : C) (a b : E) :
    columns H1 H2 (.inr (c,a)) ∩ columns H1 H2 (.inr (c,b)) = {c} ×ˢ (H2 a ∩ H2 b) := by
  ext x
  rcases x with ⟨d,t⟩
  simp [columns,and_assoc,and_left_comm,and_comm]

theorem mixed_card (H1 : U → Finset C) (H2 : E → Finset D) (u : U) (a : D) (c : C) (b : E) :
    (columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inr (c,b))).card ≤ 1 := by
  have hs : columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inr (c,b)) ⊆ {(c,a)} := by
    intro x hx
    rcases x with ⟨d,t⟩
    have h : (d ∈ H1 u ∧ t=a) ∧ (d=c ∧ t ∈ H2 b) := by
      simpa [columns,eq_comm,and_assoc,and_left_comm,and_comm] using hx
    simp [h.1.2,h.2.1]
  simpa using Finset.card_le_card hs

theorem linear (H1 : U → Finset C) (H2 : E → Finset D)
    (h1 : ∀ u v, u≠v → (H1 u ∩ H1 v).card ≤ 1)
    (h2 : ∀ a b, a≠b → (H2 a ∩ H2 b).card ≤ 1) :
    ∀ u v, u≠v → (columns H1 H2 u ∩ columns H1 H2 v).card ≤ 1 := by
  intro x y hxy
  cases x with
  | inl x =>
    rcases x with ⟨u,a⟩
    cases y with
    | inl y =>
      rcases y with ⟨v,b⟩
      by_cases hab : a=b
      · subst b
        have huv : u≠v := by intro he; subst v; exact hxy rfl
        rw [inter_left]
        simpa using h1 u v huv
      · have he : columns H1 H2 (.inl (u,a)) ∩ columns H1 H2 (.inl (v,b)) = ∅ := by
          apply Finset.not_nonempty_iff_eq_empty.mp
          exact fun hn => hab ((left_left H1 H2 u v a b).mp hn).1
        simp [he]
    | inr y => rcases y with ⟨c,b⟩; exact mixed_card H1 H2 u a c b
  | inr x =>
    rcases x with ⟨c,a⟩
    cases y with
    | inl y =>
      rcases y with ⟨u,b⟩
      simpa only [Finset.inter_comm] using mixed_card H1 H2 u b c a
    | inr y =>
      rcases y with ⟨d,b⟩
      by_cases hcd : c=d
      · subst d
        have hab : a≠b := by intro he; subst b; exact hxy rfl
        rw [inter_right]
        simpa using h2 a b hab
      · have he : columns H1 H2 (.inr (c,a)) ∩ columns H1 H2 (.inr (d,b)) = ∅ := by
          apply Finset.not_nonempty_iff_eq_empty.mp
          exact fun hn => hcd ((right_right H1 H2 c d a b).mp hn).1
        simp [he]

theorem count42_product (H1 : U → Finset C) (H2 : E → Finset D)
    (hd1 : ∀ u, (H1 u).card=3) (hd2 : ∀ a, (H2 a).card=3)
    (h41 : ∀ u v, u≠v → (H1 u ∩ H1 v).card ≤ 1)
    (h42 : ∀ a b, a≠b → (H2 a ∩ H2 b).card ≤ 1) :
    GlobalCounting.count42 (columns H1 H2) =
      Fintype.card D * GlobalCounting.count42 H1 + Fintype.card C * GlobalCounting.count42 H2 := by
  have h := root_mass_product H1 H2
  rw [PairRootBridge.rootPairSum_eq_four_count42 _ (cubic H1 H2 hd1 hd2) (linear H1 H2 h41 h42),
      PairRootBridge.rootPairSum_eq_four_count42 _ hd1 h41,
      PairRootBridge.rootPairSum_eq_four_count42 _ hd2 h42] at h
  apply Nat.eq_of_mul_eq_mul_left (by decide : 0<4)
  calc
    4 * GlobalCounting.count42 (columns H1 H2) = _ := h
    _ = 4 * (Fintype.card D * GlobalCounting.count42 H1 + Fintype.card C * GlobalCounting.count42 H2) := by ring

namespace Concrete

def XA := columns Absorbing42Small.baseA FanoBlock.columns

def XB := columns Absorbing42Small.baseB FanoBlock.columns

theorem baseA_global_count : GlobalCounting.count42 Absorbing42Small.baseA = 7 := by decide

theorem baseB_global_count : GlobalCounting.count42 Absorbing42Small.baseB = 5 := by decide

theorem full_A_count : GlobalCounting.count42 XA = 49 := by
  unfold XA
  rw [count42_product _ _ Absorbing42Small.baseA_cubic_linear.1 FanoBlock.cubic
    Absorbing42Small.baseA_cubic_linear.2.2 FanoBlock.linear,
    baseA_global_count,FanoBlock.count42_zero]
  norm_num

theorem full_B_count : GlobalCounting.count42 XB = 35 := by
  unfold XB
  rw [count42_product _ _ Absorbing42Small.baseB_cubic_linear.1 FanoBlock.cubic
    Absorbing42Small.baseB_cubic_linear.2.2 FanoBlock.linear,
    baseB_global_count,FanoBlock.count42_zero]
  norm_num

theorem variable_count : Fintype.card (Sum (Fin 12 × Fin 7) (Fin 12 × Fin 7)) = 168 := by decide

#print axioms full_A_count
#print axioms full_B_count
end Concrete
#print axioms count42_product
end HGPCounts
