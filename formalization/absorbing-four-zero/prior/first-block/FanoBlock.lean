import GlobalCounting
import Mathlib.Data.Fintype.Prod
set_option maxHeartbeats 0
namespace FanoBlock

def columns (v : Fin 7) : Finset (Fin 7) :=
  match v.val with
  | 0 => {0,4,6}
  | 1 => {0,1,5}
  | 2 => {1,2,6}
  | 3 => {0,2,3}
  | 4 => {1,3,4}
  | 5 => {2,4,5}
  | _ => {3,5,6}

theorem transpose_circulant : ∀ v c, c ∈ columns v ↔
    (v.val + 7 - c.val) % 7 ∈ ({0,1,3} : Finset ℕ) := by decide

theorem cubic : ∀ v, (columns v).card = 3 := by decide

theorem linear : ∀ u v, u ≠ v → (columns u ∩ columns v).card ≤ 1 := by decide

theorem all_check_pairs : ∀ c d : Fin 7, ∃ v, c ∈ columns v ∧ d ∈ columns v := by decide

theorem count42_zero : GlobalCounting.count42 columns = 0 := by decide

/-- This fixed circulant block cannot be partitioned into three check groups
with one neighbor of each variable in each group, as a three-row-group SCB
mother/daughter construction would require. -/
theorem no_three_check_groups :
    ¬ ∃ color : Fin 7 → Fin 3,
      ∀ v c d, c ∈ columns v → d ∈ columns v → c ≠ d → color c ≠ color d := by
  rintro ⟨color,hcolor⟩
  have hi : Function.Injective color := by
    intro c d heq
    by_contra hne
    obtain ⟨v,hc,hd⟩ := all_check_pairs c d
    exact hcolor v c d hc hd hne heq
  have hcard := Fintype.card_le_of_injective color hi
  norm_num at hcard

#print axioms transpose_circulant
#print axioms count42_zero
#print axioms no_three_check_groups
end FanoBlock
