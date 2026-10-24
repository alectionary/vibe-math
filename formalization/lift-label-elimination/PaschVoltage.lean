import Mathlib.Tactic.Abel
import Mathlib.Tactic.FinCases
import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Data.ZMod.Basic

set_option maxHeartbeats 0
namespace PaschVoltage
variable {G : Type*} [AddCommGroup G]

/-- Edge differences in the order01,02,03,12,13,23. -/
def Compatible (d : Fin 6 → G) (x : Fin 4 → G) : Prop :=
  x 1-x 0=d 0 ∧ x 2-x 0=d 1 ∧ x 3-x 0=d 2 ∧
  x 2-x 1=d 3 ∧ x 3-x 1=d 4 ∧ x 3-x 2=d 5

def Balanced (d : Fin 6 → G) : Prop :=
  d 0+d 3=d 1 ∧ d 0+d 4=d 2 ∧ d 1+d 5=d 2

noncomputable instance (d : Fin 6 → G) : Decidable (Balanced d) := Classical.propDecidable _

def offsets (d : Fin 6 → G) (t : G) : Fin 4 → G :=
  fun i => match i.val with
  | 0 => t
  | 1 => t+d 0
  | 2 => t+d 1
  | _ => t+d 2

theorem compatible_implies_balanced (d : Fin 6 → G) (x : Fin 4 → G)
    (h : Compatible d x) : Balanced d := by
  rcases h with ⟨h01,h02,h03,h12,h13,h23⟩
  refine ⟨?_,?_,?_⟩
  · calc
      d 0+d 3=(x 1-x 0)+(x 2-x 1) := by rw [h01,h12]
      _=x 2-x 0 := by abel
      _=d 1 := h02
  · calc
      d 0+d 4=(x 1-x 0)+(x 3-x 1) := by rw [h01,h13]
      _=x 3-x 0 := by abel
      _=d 2 := h03
  · calc
      d 1+d 5=(x 2-x 0)+(x 3-x 2) := by rw [h02,h23]
      _=x 3-x 0 := by abel
      _=d 2 := h03

theorem offsets_compatible (d : Fin 6 → G) (h : Balanced d) (t : G) :
    Compatible d (offsets d t) := by
  rcases h with ⟨h1,h2,h3⟩
  change (t+d 0)-t=d 0 ∧ (t+d 1)-t=d 1 ∧ (t+d 2)-t=d 2 ∧
    (t+d 1)-(t+d 0)=d 3 ∧ (t+d 2)-(t+d 0)=d 4 ∧ (t+d 2)-(t+d 1)=d 5
  refine ⟨by abel,by abel,by abel,?_,?_,?_⟩
  · rw [← h1]; abel
  · rw [← h2]; abel
  · rw [← h3]; abel

theorem exists_compatible_iff (d : Fin 6 → G) :
    (∃ x, Compatible d x) ↔ Balanced d :=
  ⟨fun ⟨x,h⟩ => compatible_implies_balanced d x h,
    fun h => ⟨offsets d 0,offsets_compatible d h 0⟩⟩

theorem compatible_unique (d : Fin 6 → G) (x : Fin 4 → G)
    (h : Compatible d x) : x=offsets d (x 0) := by
  rcases h with ⟨h1,h2,h3,_,_,_⟩
  ext i
  fin_cases i
  · rfl
  · change x 1=x 0+d 0
    rw [← h1]; abel
  · change x 2=x 0+d 1
    rw [← h2]; abel
  · change x 3=x 0+d 2
    rw [← h3]; abel

def solutionEquiv (d : Fin 6 → G) (h : Balanced d) :
    {x : Fin 4 → G // Compatible d x} ≃ G where
  toFun x := x.val 0
  invFun t := ⟨offsets d t,offsets_compatible d h t⟩
  left_inv x := Subtype.ext (compatible_unique d x.val x.prop).symm
  right_inv _ := rfl

theorem balanced_solution_count (d : Fin 6 → G) (h : Balanced d) :
    Nat.card {x : Fin 4 → G // Compatible d x}=Nat.card G :=
  Nat.card_congr (solutionEquiv d h)

theorem unbalanced_no_solution (d : Fin 6 → G) (h : ¬ Balanced d) :
    ¬ ∃ x, Compatible d x := by
  simpa only [exists_compatible_iff] using h

theorem solution_count (d : Fin 6 → G) :
    Nat.card {x : Fin 4 → G // Compatible d x}=
      if Balanced d then Nat.card G else 0 := by
  classical
  by_cases h : Balanced d
  · rw [if_pos h]; exact balanced_solution_count d h
  · rw [if_neg h]
    letI : IsEmpty {x : Fin 4 → G // Compatible d x} :=
      ⟨fun x => h (compatible_implies_balanced d x.val x.prop)⟩
    exact Nat.card_of_isEmpty

theorem cyclic_solution_count (N : ℕ) [NeZero N] (d : Fin 6 → ZMod N) :
    Nat.card {x : Fin 4 → ZMod N // Compatible d x}=
      if Balanced d then N else 0 := by
  classical
  rw [solution_count,Nat.card_eq_fintype_card,ZMod.card]

#print axioms exists_compatible_iff
#print axioms compatible_unique
#print axioms balanced_solution_count
#print axioms cyclic_solution_count
end PaschVoltage
