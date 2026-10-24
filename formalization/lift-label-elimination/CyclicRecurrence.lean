import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.FinCases
import Mathlib.SetTheory.Cardinal.Finite

set_option maxHeartbeats 0
set_option maxRecDepth 100000
namespace CyclicRecurrence
abbrev F := ZMod 2

def pattern (a : Fin 3 → F) (r : ZMod 7) : F :=
  match r.val with
  | 0 => a 0
  | 1 => a 1
  | 2 => a 2
  | 3 => a 0+a 1
  | 4 => a 1+a 2
  | 5 => a 0+a 1+a 2
  | _ => a 0+a 2

theorem pattern_recurrence : ∀ (a : Fin 3 → F) (r : ZMod 7),
    pattern a (r+3)=pattern a r+pattern a (r+1) := by decide

theorem pattern_initial : ∀ (a : Fin 3 → F) (i : Fin 3),
    pattern a (i.val : ZMod 7)=a i := by decide

/-- The recurrence determines every term from the first three bits. -/
theorem sequence_unique (f : ℕ → F)
    (h : ∀ n, f (n+3)=f n+f (n+1)) (n : ℕ) :
    f n=pattern (fun i : Fin 3 => f i.val) (n : ZMod 7) := by
  induction n using Nat.strong_induction_on with
  | h n ih =>
    by_cases hn : n<3
    · exact (pattern_initial (fun i : Fin 3 => f i.val) ⟨n,hn⟩).symm
    · obtain ⟨k,rfl⟩ : ∃ k, n=k+3 := ⟨n-3,by omega⟩
      rw [h k, ih k (by omega), ih (k+1) (by omega)]
      simpa only [Nat.cast_add, Nat.cast_ofNat, Nat.cast_one] using
        (pattern_recurrence (fun i : Fin 3 => f i.val) (k : ZMod 7)).symm

variable (N : ℕ) [NeZero N]

def ScalarCondition (f : ZMod N → F) : Prop :=
  ∀ t, f (t+3)=f t+f (t+1)

def candidate (h7 : 7 ∣ N) (a : Fin 3 → F) : ZMod N → F :=
  fun t => pattern a (ZMod.castHom h7 (ZMod 7) t)

theorem candidate_condition (h7 : 7 ∣ N) (a : Fin 3 → F) :
    ScalarCondition N (candidate N h7 a) := by
  intro t
  simp only [candidate, map_add, map_ofNat, map_one]
  exact pattern_recurrence a _

theorem kernel_unique (h7 : 7 ∣ N) (f : ZMod N → F)
    (hf : ScalarCondition N f) :
    f=candidate N h7 (fun i : Fin 3 => f (i.val : ZMod N)) := by
  have hn : ∀ n : ℕ, f (n : ZMod N)=
      pattern (fun i : Fin 3 => f (i.val : ZMod N)) (n : ZMod 7) := by
    apply sequence_unique
    intro n
    simpa only [Nat.cast_add, Nat.cast_ofNat, Nat.cast_one] using hf (n : ZMod N)
  funext t
  have ht := hn t.val
  rw [ZMod.natCast_zmod_val] at ht
  have hc : ZMod.castHom h7 (ZMod 7) t=(t.val : ZMod 7) := by
    conv_lhs => rw [← ZMod.natCast_zmod_val t]
    exact map_natCast _ _
  simpa only [candidate, hc] using ht

def scalarEquiv (h7 : 7 ∣ N) :
    {f : ZMod N → F // ScalarCondition N f} ≃ (Fin 3 → F) where
  toFun f i := f.val (i.val : ZMod N)
  invFun a := ⟨candidate N h7 a,candidate_condition N h7 a⟩
  left_inv f := Subtype.ext (kernel_unique N h7 f.val f.prop).symm
  right_inv a := by
    funext i
    simp only [candidate, map_natCast]
    exact pattern_initial a i

theorem scalar_kernel_card (h7 : 7 ∣ N) :
    Nat.card {f : ZMod N → F // ScalarCondition N f}=8 := by
  rw [Nat.card_congr (scalarEquiv N h7), Nat.card_eq_fintype_card,
    Fintype.card_fun, Fintype.card_fin, ZMod.card]
  decide

theorem shift_seven (h7 : 7 ∣ N) (f : ZMod N → F)
    (hf : ScalarCondition N f) (t : ZMod N) : f (t+7)=f t := by
  have he := kernel_unique N h7 f hf
  rw [he]
  change pattern _ ((ZMod.castHom h7 (ZMod 7)) (t+7)) =
    pattern _ ((ZMod.castHom h7 (ZMod 7)) t)
  rw [map_add, map_ofNat]
  have hz : (7 : ZMod 7)=0 := by decide
  rw [hz, add_zero]

#print axioms sequence_unique
#print axioms scalarEquiv
#print axioms scalar_kernel_card
#print axioms shift_seven
end CyclicRecurrence
